Return-Path: <kvm+bounces-20995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1254927FCC
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 109901C21683
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FDF12B87;
	Fri,  5 Jul 2024 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cd7m5fRn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47C879F3
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720143172; cv=none; b=uCfIgFAfEy7TU7GL1TwgFm1neGirnLe/jIEkFseAvXsJnMWeDRPH9h3ZljD6IoqzhJuc9tn+dWB27bfNZCzhZVONgzVxlbGrzJMTjYLkRX0dfZOTgqYbC0evHQv7wJW+ZxMPpclWzQrI+LM1/gFyJVf0wZwKypK/RMf5uoQNUoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720143172; c=relaxed/simple;
	bh=joi/ZbQF5UZJT83oRi4Qzjkbop2NvPgJmoAyIcaK1aY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SsibH0C2KF/xQb/2UtmM1EY4eSdmUZlbjwGojBcPqNjEl/a2tBLKqZm5WhQ7Th/A5eRb0deao1Fy2hEzJpP10bTaKc61ki6w8wk5p5TdgCy/smwthFz/L/qB/7XI9kj4ctL6VfzzRmpNMeujr5wFuzGDCBw7BTEzytU/vX8E9/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cd7m5fRn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720143169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9TRW1LftiMp3tODMlxbNr5xLzrk/cXFTqGoijSSTc2U=;
	b=Cd7m5fRnS0wx/zrPrroCs9M8enlY4YIsSIHMYPs3IC3pEFfBV65rjuqipJyW6nfTbWcL2V
	35qyTpT4gtWwwgnj+TeBzYSFPTIcbkZZooTgjiaZ1MVZe0yR2zzbbzFKM6s5w3w2sISPu7
	jDUWmzzyIEyNtrVC6BPUNv4qRIXQDeE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-PTJwtdKFMfudrkH8-ZvHpw-1; Thu, 04 Jul 2024 21:32:47 -0400
X-MC-Unique: PTJwtdKFMfudrkH8-ZvHpw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79ef7451d26so11722085a.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720143167; x=1720747967;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TRW1LftiMp3tODMlxbNr5xLzrk/cXFTqGoijSSTc2U=;
        b=QFlm2ZPEWhu8/px2P3Db8BD0W2+qf9vsUCYt5DxHgLWJQdLxne+pQXSmv6yVAwMBjV
         mQNipipZ33dy3ykIIn5jbODbvY/Gl/gkZdr0UPC5+LCzqGLP2uEF6LeXC4mYIufo3z1V
         zmmKxqTvpJ6G9HYW6/mYW4CrTnNj6mHiluv/lAgZlNrQgVkwjX9ppp5Q3Xt8TIVimNMh
         3Qi79e39D55O+nDl6jMm+JR+jSYPbwgfT4ZroWhcm0Ll/BdWJxAQPS17fci53BD3D1eA
         ognNFkh2QtbydLFpnRyrizWFZEZLYdLuMAWeX9XooHl6Wndotj+H23GeHZkO3AP7X8I7
         cC3A==
X-Gm-Message-State: AOJu0Ywiu2ZF65iu0t/VRp6A0mVTGwqrS2Rg59nPG5kw84Zfovrsv8qz
	HJ9nFvoNFXCQ7J6D66b3j760qETyoiuPNVvZ7IK35zE6vzZRfSLmhpzg/nKWDFuXEa77rS40B7N
	TSbrHA84HCcS611dpO13gPHEQV+pjt+CMoezZAZDUu9ZQpL/X6w==
X-Received: by 2002:a05:620a:811b:b0:79d:5972:a7f8 with SMTP id af79cd13be357-79eee25829bmr306761485a.75.1720143167391;
        Thu, 04 Jul 2024 18:32:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElOWQWtUQoswvp12eWueS3hzOEJ5cWZPvfmYg/2dq2gbq+H8DOUCmhwsXMFzGo2GrWneHE+w==
X-Received: by 2002:a05:620a:811b:b0:79d:5972:a7f8 with SMTP id af79cd13be357-79eee25829bmr306760685a.75.1720143167061;
        Thu, 04 Jul 2024 18:32:47 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d6927961csm726200885a.41.2024.07.04.18.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:32:46 -0700 (PDT)
Message-ID: <8dfa84f39a718f82c23c11fbe02e4710351cbf73.camel@redhat.com>
Subject: Re: [PATCH v2 28/49] KVM: x86: Clear PV_UNHALT for !HLT-exiting
 only when userspace sets CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:32:45 -0400
In-Reply-To: <20240517173926.965351-29-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-29-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Now that KVM disallows disabling HLT-exiting after vCPUs have been created,
> i.e. now that it's impossible for kvm_hlt_in_guest() to change while vCPUs
> are running, apply KVM's PV_UNHALT quirk only when userspace is setting
> guest CPUID.
> 
> Opportunistically rename the helper to make it clear that KVM's behavior
> is a quirk that should never have been added.  KVM's documentation
> explicitly states that userspace should not advertise PV_UNHALT if
> HLT-exiting is disabled, but for unknown reasons, commit caa057a2cad6
> ("KVM: X86: Provide a capability to disable HLT intercepts") didn't stop
> at documenting the requirement and also massaged the incoming guest CPUID.
> 
> Unfortunately, it's quite likely that userspace has come to rely on KVM's
> behavior, i.e. the code can't simply be deleted.  The only reason KVM
> doesn't have an "official" quirk is that there is no known use case where
> disabling the quirk would make sense, i.e. letting userspace disable the
> quirk would further increase KVM's burden without any benefit.

Makes sense overall.


> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4ad01867cb8d..93a7399dc0db 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -287,18 +287,17 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
>  					     vcpu->arch.cpuid_nent, base);
>  }
>  
> -static void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
> +static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
>  
> -	vcpu->arch.pv_cpuid.features = 0;
> +	if (!best)
> +		return 0;
>  
> -	/*
> -	 * save the feature bitmap to avoid cpuid lookup for every PV
> -	 * operation
> -	 */
> -	if (best)
> -		vcpu->arch.pv_cpuid.features = best->eax;
> +	if (kvm_hlt_in_guest(vcpu->kvm))
> +		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +
> +	return best->eax;
>  }
>  
>  /*
> @@ -320,7 +319,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  				       int nent)
>  {
>  	struct kvm_cpuid_entry2 *best;
> -	struct kvm_hypervisor_cpuid kvm_cpuid;
>  
>  	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	if (best) {
> @@ -347,13 +345,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
> -	kvm_cpuid = __kvm_get_hypervisor_cpuid(entries, nent, KVM_SIGNATURE);
> -	if (kvm_cpuid.base) {
> -		best = __kvm_find_kvm_cpuid_features(entries, nent, kvm_cpuid.base);
> -		if (kvm_hlt_in_guest(vcpu->kvm) && best)
> -			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> -	}
> -
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>  		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  		if (best)
> @@ -425,7 +416,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.guest_supported_xcr0 =
>  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>  
> -	kvm_update_pv_runtime(vcpu);
> +	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
>  
>  	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> @@ -508,6 +499,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  		 * stale data is ok because KVM will reject the change.
>  		 */
>  		kvm_update_cpuid_runtime(vcpu);
> +		kvm_apply_cpuid_pv_features_quirk(vcpu);
>  
>  		r = kvm_cpuid_check_equal(vcpu, e2, nent);
>  		if (r)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





