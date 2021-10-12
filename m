Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25814429EFE
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhJLHyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 03:54:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234368AbhJLHyE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 03:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634025122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DawGZtwoY4tpG7sttmX7k/wQ7T3bzhJ2Z3tfnHYSP0M=;
        b=Usta307o22Nn+hEtjft6Ko5kGKJWCfOyw6FWnfkJ0ojTbyfrwJGUWrIXYh28mLsLDAWF9z
        SB6aUtAp0SnF55SxzNN/nugtPW+kS5+yu2BBLOUAIM5SMbY8nzKXqN/fZs6dyZ61JteVvk
        XqwZU406rO5ZHlrndDg/AxsbDhAdDMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-sczdr6Q8ODGw-l3VY02DGQ-1; Tue, 12 Oct 2021 03:51:37 -0400
X-MC-Unique: sczdr6Q8ODGw-l3VY02DGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7BA419057A8;
        Tue, 12 Oct 2021 07:51:34 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FDAA60BE5;
        Tue, 12 Oct 2021 07:51:08 +0000 (UTC)
Message-ID: <8f4be85e44f5997e24d534423b9d9b4dbcaa5d84.camel@redhat.com>
Subject: Re: [PATCH 07/14] KVM: x86: SVM: add warning for CVE-2021-3656
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Bandan Das <bsd@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wei Huang <wei.huang2@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 12 Oct 2021 10:51:07 +0300
In-Reply-To: <4c04106a-fd8e-fb54-799f-06331a3e65b9@intel.com>
References: <20210914154825.104886-1-mlevitsk@redhat.com>
         <20210914154825.104886-8-mlevitsk@redhat.com>
         <4c04106a-fd8e-fb54-799f-06331a3e65b9@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-10-12 at 01:30 +0800, Xiaoyao Li wrote:
> On 9/14/2021 11:48 PM, Maxim Levitsky wrote:
> > Just in case, add a warning ensuring that on guest entry,
> > either both VMLOAD and VMSAVE intercept is enabled or
> > vVMLOAD/VMSAVE is enabled.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 861ac9f74331..deeebd05f682 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3784,6 +3784,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >   
> >   	WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> >   
> > +	/* Check that CVE-2021-3656 can't happen again */
> > +	if (!svm_is_intercept(svm, INTERCEPT_VMSAVE) ||
> > +	    !svm_is_intercept(svm, INTERCEPT_VMSAVE))
> 
> either one needs to be INTERCEPT_VMLOAD, right?

Oops! Of course.

Best regards,
	Maxim Levitsky
> 
> > +		WARN_ON(!(svm->vmcb->control.virt_ext &
> > +			  VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
> > +
> >   	sync_lapic_to_cr8(vcpu);
> >   
> >   	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> > 


