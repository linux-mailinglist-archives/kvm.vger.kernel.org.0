Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261B33BE665
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhGGKiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhGGKiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625654141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Syoe9M2t0vM3Bv0EamcjPe4W6xrI52FELx5muenx0Qc=;
        b=Gi9IxWS+Qph9s+z7NKSfkrv3BcNDtHzb14lt76ritIF6Q+XerKlY27+AskH9+m85CuxAKz
        JJzyV21+iJZCdlFROCgsbs32HDi4Zz1asXyLXwudMJblKbBOI9I7aP41CxqW/GhvTchom8
        G5iI+ls2VJQpehfe960Yq7zfzccpDL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-5zDSoBSIOkWwzJdIP9rkDg-1; Wed, 07 Jul 2021 06:35:40 -0400
X-MC-Unique: 5zDSoBSIOkWwzJdIP9rkDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 344E8802E62;
        Wed,  7 Jul 2021 10:35:39 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E228F60C05;
        Wed,  7 Jul 2021 10:35:34 +0000 (UTC)
Message-ID: <e9910deb51f0b0163167b45251f7582dedeb9eed.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: nSVM: Restore nested control upon leaving SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Jul 2021 13:35:33 +0300
In-Reply-To: <20210628104425.391276-6-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 12:44 +0200, Vitaly Kuznetsov wrote:
> In case nested state was saved/resored while in SMM,
> nested_load_control_from_vmcb12() which sets svm->nested.ctl was never
> called and the first nested_vmcb_check_controls() (either from
> nested_svm_vmrun() or from svm_set_nested_state() if save/restore
> cycle is repeated) is doomed to fail.

I don't like the commit description.

I propose something like that:

If the VM was migrated while in SMM, no nested state was saved/restored,
and therefore svm_leave_smm has to load both save and control area
of the vmcb12. Save area is already loaded from HSAVE area,
so now load the control area as well from the vmcb12.

However if you like to, feel free to leave the commit message as is.
My point is that while in SMM, SVM is fully disabled, so not only
svm->nested.ctl is not set but no nested state is loaded/stored at all.

Also this makes the svm_leave_smm even more dangerous versus errors,
as I said in previos patch. Since its return value is ignored,
and we are loading here the guest vmcb01 which can change under
our feet, lots of fun can happen (enter_svm_guest_mode result
isn't really checked).

Best regards,
	Maxim Levitsky 

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  arch/x86/kvm/svm/svm.c    | 7 ++++++-
>  arch/x86/kvm/svm/svm.h    | 2 ++
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a1dec2c40181..6549e40155fa 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -304,8 +304,8 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> -					    struct vmcb_control_area *control)
> +void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> +				     struct vmcb_control_area *control)
>  {
>  	copy_vmcb_control_area(&svm->nested.ctl, control);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fbf1b352a9bb..525b07873927 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4344,6 +4344,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
>  		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
>  		u64 vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
> +		struct vmcb *vmcb12;
>  
>  		if (guest) {
>  			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> @@ -4359,7 +4360,11 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  			if (svm_allocate_nested(svm))
>  				return 1;
>  
> -			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, map.hva);
> +			vmcb12 = map.hva;
> +
> +			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +
> +			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
>  			kvm_vcpu_unmap(vcpu, &map, true);
>  
>  			/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ff2dac2b23b6..13f2d465ca36 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -481,6 +481,8 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
>  int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  			       bool has_error_code, u32 error_code);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
> +void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> +				     struct vmcb_control_area *control);
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
>  void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);


