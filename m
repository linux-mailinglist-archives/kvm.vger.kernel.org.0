Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EE3F4B47
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 15:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhHWNCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 09:02:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236836AbhHWNCn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 09:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629723720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8kt16zM9NUQZu09e40kgTRmDnz1GorO0k0Ms2ASW2g=;
        b=i++sEtjncDPVC+sZ3gkR/iDlAudyoSVbfj847VMpAmYnYYl+yYf8dEgUJldpxBsLakhM38
        aIg6pWK+aVEteE3N0rntA/Z/f6oxIAOHEaswMyo5DBLiLFNGYY6hFZoC0veWIDjeTbiQbD
        OUQ/pBV7y5y+EB3pQRnX198NW/+R4hg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-Yi1MerKXMtqAN4C4RDoVGg-1; Mon, 23 Aug 2021 09:01:57 -0400
X-MC-Unique: Yi1MerKXMtqAN4C4RDoVGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB927185303A;
        Mon, 23 Aug 2021 13:01:55 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26E5460BD9;
        Mon, 23 Aug 2021 13:01:51 +0000 (UTC)
Message-ID: <171eecc55849a924a9d2d02476303f798328a68f.camel@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: few more SMM fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 23 Aug 2021 16:01:50 +0300
In-Reply-To: <20210823114618.1184209-1-mlevitsk@redhat.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-23 at 14:46 +0300, Maxim Levitsky wrote:
> These are few SMM fixes I was working on last week.
> 
> * First patch fixes a minor issue that remained after
>   commit 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")
> 
>   While now, returns to guest mode from SMM work due to restored state from HSAVE
>   area, the guest entry still sees incorrect HSAVE state.
> 
>   This for example breaks return from SMM when the guest is 32 bit, due to PDPTRs
>   loading which are done using incorrect MMU state which is incorrect,
>   because it was setup with incorrect L1 HSAVE state.
> 
> * 2nd patch fixes a theoretical issue that I introduced with my SREGS2 patchset,
>   which Sean Christopherson pointed out.
> 
>   The issue is that KVM_REQ_GET_NESTED_STATE_PAGES request is not only used
>   for completing the load of the nested state, but it is also used to complete
>   exit from SMM to guest mode, and my compatibility hack of pdptrs_from_userspace
>   was done assuming that this is not done.
> 
>   While it is safe to just reset 'pdptrs_from_userspace' on each VM entry,
>   I don't want to slow down the common code for this very rare hack.
>   Instead I explicitly zero this variable when SMM exit to guest mode is done,
>   because in this case PDPTRs do need to be reloaded from memory always.
> 
>   Note that this is a theoretical issue only, because after 'vendor' return from
>   smm code (aka .leave_smm) is done, even when it returned to the guest mode,
>   which loads some of L2 CPU state, we still load again all of the L2 cpu state
>   captured in SMRAM which includes CR3, at which point guest PDPTRs are re-loaded
>   anyway.
> 
>   Also note that across SMI entries the CR3 seems not to be updated, and Intel's
>   SDM notes that it saved value in SMRAM isn't writable, thus it is possible
>   that if SMM handler didn't change CR3, the pdptrs would not be touched.
> 
>   I guess that means that a SMI handler can in theory preserve PDPTRs by never
>   touching CR3, but since recently we removed that code that didn't update PDPTRs
>   if CR3 didn't change, I guess it won't work.
> 
>   Anyway I don't think any OS bothers to have PDPTRs not synced with whatever
>   page CR3 points at, thus I didn't bother to try and test what the real hardware
>   does in this case.
> 
> * 3rd patch makes SVM SMM exit to be a bit more similar to how VMX does it
>   by also raising KVM_REQ_GET_NESTED_STATE_PAGES requests.
> 
>   I do have doubts about why we need to do this on VMX though. The initial
>   justification for this comes from
> 
>   7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")
> 
>   With all the MMU changes, I am not sure that we can still have a case
>   of not up to date MMU when we enter the nested guest from SMM.
>   On SVM it does seem to work anyway without this.
> 
> I still track another SMM issue, which I debugged a bit today but still
> no lead on what is going on:
> 
> When HyperV guest is running nested, and uses SMM enabled OVMF, it crashes and
> reboots during the boot process.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (3):
>   KVM: nSVM: restore the L1 host state prior to resuming a nested guest
>     on SMM exit
>   KVM: x86: force PDPTRs reload on SMM exit
>   KVM: nSVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM mode
> 
>  arch/x86/kvm/svm/nested.c |  9 ++++++---
>  arch/x86/kvm/svm/svm.c    | 27 ++++++++++++++++++---------
>  arch/x86/kvm/svm/svm.h    |  3 ++-
>  arch/x86/kvm/vmx/vmx.c    |  7 +++++++
>  4 files changed, 33 insertions(+), 13 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

This is not really v2, mistake on my part in git-publish.

Best regards,
	Maxim Levitsky

