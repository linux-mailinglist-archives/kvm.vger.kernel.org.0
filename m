Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4C407CD9
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhILKeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:34:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhILKed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631442798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INc5cECNI9sJ05Bk6PZMOwiVAdVb2WxqVCqnhvKwEZM=;
        b=e76xlHdzSLJPK8pzk6d2z88tg20bt1PLlNKKfJ4MFPmgm92d432mpoTAQeC28Lpx07A8Gt
        oGLBxaezR/picHgrsDNCCiByi5psD0TkYIhq6izw9ZXHzBsfLZwW3WAk0+uGnMvNVP+csC
        Tqtum0vlbcLmPMB+/bl2IpXZli4UtBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-XVqpWGwjP16_HM1c4VWdow-1; Sun, 12 Sep 2021 06:33:17 -0400
X-MC-Unique: XVqpWGwjP16_HM1c4VWdow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2DE6801B3D;
        Sun, 12 Sep 2021 10:33:14 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDE0A5D9DD;
        Sun, 12 Sep 2021 10:33:10 +0000 (UTC)
Message-ID: <ba96d0334762fc41f20ed997c859d4b01c38b6d8.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: nSVM: restore the L1 host state prior to
 resuming a nested guest on SMM exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Sun, 12 Sep 2021 13:33:09 +0300
In-Reply-To: <YTkzUaFD664+9WB+@google.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
         <20210823114618.1184209-2-mlevitsk@redhat.com>
         <YTkzUaFD664+9WB+@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-09-08 at 22:04 +0000, Sean Christopherson wrote:
> On Mon, Aug 23, 2021, Maxim Levitsky wrote:
> > If the guest is entered prior to restoring the host save area,
> > the guest entry code might see incorrect L1 state (e.g paging state).
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 1a70e11f0487..ea7a4dacd42f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4347,27 +4347,30 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
> >  				return 1;
> >  
> > -			if (svm_allocate_nested(svm))
> > +			if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
> > +					 &map_save) == -EINVAL)
> >  				return 1;
> 
> Returning here will neglect to unmap "map".
> 
> >  
> > -			vmcb12 = map.hva;
> > -
> > -			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> > -
> > -			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
> > -			kvm_vcpu_unmap(vcpu, &map, true);
> > +			if (svm_allocate_nested(svm))
> > +				return 1;
> 
> Ditto here for both "map" and "map_save", though it looks like there's a
> pre-existing bug if svm_allocate_nested() fails.  If you add a prep cleanup patch
> to remove the statement nesting (between the bug fix and this patch), it will make
> handling this a lot easier, e.g.
> 
> static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	struct kvm_host_map map, map_save;
> 	u64 saved_efer, vmcb12_gpa;
> 	struct vmcb *vmcb12;
> 	int ret;
> 
> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 		return 0;
> 
> 	/* Non-zero if SMI arrived while vCPU was in guest mode. */
> 	if (!GET_SMSTATE(u64, smstate, 0x7ed8))
> 		return 0;
> 
> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> 		return 1;
> 
> 	saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
> 	if (!(saved_efer & EFER_SVME))
> 		return 1;
> 
> 	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
> 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
> 		return 1;
> 
> 	ret = 1;
> 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr), &map_save) == -EINVAL)
> 		goto unmap_map;
> 
> 	if (svm_allocate_nested(svm))
> 		goto unmap_save;
> 
> 	/*
> 	 * Restore L1 host state from L1 HSAVE area as VMCB01 was
> 	 * used during SMM (see svm_enter_smm())
> 	 */
> 
> 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save,
> 				map_save.hva + 0x400);
> 
> 	/*
> 	 * Restore L2 state
> 	 */
> 
> 	vmcb12 = map.hva;
> 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
> 
> unmap_save;
> 	kvm_vcpu_unmap(vcpu, &map_save, true);
> unmap_map:
> 	kvm_vcpu_unmap(vcpu, &map, true);
> 	return 1;
> }
> 
Will do. I haven't given the error path enough attention.

Thanks!
Best regards,
	Maxim Levitsky

