Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E981E4727
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 17:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbgE0PRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 11:17:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389637AbgE0PRg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 11:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590592655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRXJGyhyibwz7e++zj9JGkGdUoHwUBwUQqj4v1/HHvw=;
        b=epTsF70z7EAcd9994cZUNSL+y8e5/NrEKAzalkdnX4/BHqe0/fEU+Y+uFPDpepQWRyoUST
        oJXkSAaXSruTG3WyZzpNN2k4dq0NTFlPDuyAxM6qJ1FD7ThWddroc5sDVTU5HucVlQhPKB
        cCUStT4RrajqYwtdMjogKZDQSASY6MY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-lKYOSppzONe8SR7bISTzJw-1; Wed, 27 May 2020 11:17:31 -0400
X-MC-Unique: lKYOSppzONe8SR7bISTzJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E0AE107ACF2;
        Wed, 27 May 2020 15:17:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB03021EF8;
        Wed, 27 May 2020 15:17:25 +0000 (UTC)
Message-ID: <2e2cca1f7eab64dc55d3ac306f92f9f8318fc775.camel@redhat.com>
Subject: Re: [PATCH 0/2] Fix issue with not starting nesting guests on my
 system
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Wed, 27 May 2020 18:17:24 +0300
In-Reply-To: <20200527011344.GB31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
         <20200527011344.GB31696@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 18:13 -0700, Sean Christopherson wrote:
> On Sat, May 23, 2020 at 07:14:53PM +0300, Maxim Levitsky wrote:
> > On my AMD machine I noticed that I can't start any nested guests,
> > because nested KVM (everything from master git branches) complains
> > that it can't find msr MSR_IA32_UMWAIT_CONTROL which my system
> > doesn't support
> > at all anyway.
> > 
> > I traced it to the recently added UMWAIT support to qemu and kvm.
> > The kvm portion exposed the new MSR in KVM_GET_MSR_INDEX_LIST
> > without
> > checking that it the underlying feature is supported in CPUID.
> > It happened to work when non nested because as a precation kvm,
> > tries to read each MSR on host before adding it to that list,
> > and when read gets a #GP it ignores it.
> > 
> > When running nested, the L1 hypervisor can be set to ignore unknown
> > msr read/writes (I need this for some other guests), thus this
> > safety
> > check doesn't work anymore.
> > 
> > V2: * added a patch to setup correctly the X86_FEATURE_WAITPKG kvm
> > capability
> >     * dropped the cosmetic fix patch as it is now fixed in
> > kvm/queue
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > Maxim Levitsky (2):
> >   kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM capabilities
> >   kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
> 
> Standard scoping in the shortlog is "KVM: VMX:" and "KVM: x86:".
This another thing I usually mess up in the commit messages.
Fixed and noted for futher patches 

> 
> >  arch/x86/kvm/vmx/vmx.c | 3 +++
> >  arch/x86/kvm/x86.c     | 4 ++++
> >  2 files changed, 7 insertions(+)
> > 
> > -- 
> > 2.26.2
> > 
> > 

