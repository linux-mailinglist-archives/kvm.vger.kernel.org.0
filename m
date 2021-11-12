Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0754144E28C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 08:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhKLHrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 02:47:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234568AbhKLHqw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 02:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636703041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=of5gwDBwxdcYh6K59nXNYWEL/33AGRMxrOyNV/fv1+8=;
        b=S4zlMOd0jiZnGKFSOaNjf8CXW/L04VomG3a4Aut3GlxPk37bLRDQoyfPDnjpwNk/0fAZ5Z
        44nzZWi2Bn8l9Htwm5CWtchuYGyzps8t091GsgqYnLGyrfn9A9UIWcJzx+zPjITfQhEJhl
        bI0N8tkK+bGygnErCHeIDOG/3wl2iIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-aByo8f2oOyW0e1bO26HJOA-1; Fri, 12 Nov 2021 02:43:57 -0500
X-MC-Unique: aByo8f2oOyW0e1bO26HJOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AF8A19200C2;
        Fri, 12 Nov 2021 07:43:55 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7281057F55;
        Fri, 12 Nov 2021 07:43:48 +0000 (UTC)
Message-ID: <556d68697f5cd30e32307b1c56ae51b42f87cd4f.camel@redhat.com>
Subject: Re: [PATCH v5 2/7] nSVM: introduce smv->nested.save to cache save
 area fields
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 12 Nov 2021 09:43:47 +0200
In-Reply-To: <49852dbc-548d-5bf1-6254-ec69d3041961@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
         <20211103140527.752797-3-eesposit@redhat.com>
         <49852dbc-548d-5bf1-6254-ec69d3041961@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-11 at 14:52 +0100, Paolo Bonzini wrote:
> On 11/3/21 15:05, Emanuele Giuseppe Esposito wrote:
> > Note that in svm_set_nested_state() we want to cache the L2
> > save state only if we are in normal non guest mode, because
> > otherwise it is not touched.
> 
> I think that call to nested_copy_vmcb_save_to_cache is not necessary at 
> all, because svm->nested.save is not used afterwards and is not valid 
> after VMRUN.

Yes, but since setting nested state is absolutely not performance critical,
having it do the same thing as normal VMRUN is always better.

Best regards,
	Maxim Levitsky

> 
> The relevant checks have already been done before:
> 
>          if (!(vcpu->arch.efer & EFER_SVME)) {
>                  /* GIF=1 and no guest mode are required if SVME=0.  */
>                  if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
>                          return -EINVAL;
>          }
> 
> 	...
> 
>          /*
>           * Processor state contains L2 state.  Check that it is
>           * valid for guest mode (see nested_vmcb_check_save).
>           */
>          cr0 = kvm_read_cr0(vcpu);
>          if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
>                  goto out_free;
> 
> (and all other checks are done by KVM_SET_SREGS, KVM_SET_DEBUGREGS etc.)
> 
> Paolo
> 


