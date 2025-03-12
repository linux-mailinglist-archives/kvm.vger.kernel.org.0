Return-Path: <kvm+bounces-40827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E97A5DC80
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 13:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE30F3A12D0
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 12:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AFE241CA2;
	Wed, 12 Mar 2025 12:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wu0piOdr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD503232
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782280; cv=none; b=hynpl/4Px6tnLNCDKsnTrkuISDnTLeTRMyNxs/L36CPmgsiElJdyx1D7xYKgW+vbHUnVfRr7ZiInSqbCepre+/eszaj6j+8ICxvxORjkIIDW5hGzQ+gzUXg8GGIImVbfdejljgPgZG86XrMsOlKQlEdaOH7vmi0caraNb450LA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782280; c=relaxed/simple;
	bh=jWP+VCZ+lRFSY+iA7RTy4X7XIY2qYQruBp/b4nktngE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dyUayJelYbbl/R2oP51Ytaj2bEkj2k/JCfv3afSgJkSJbyzc6ujueTqltxlBMIr+u3kek39Nc0bfQRTj4ytuITKgvA49DceiuINj26sJTmrcnnKjiwWRJvN0/P2hA294ohJSafVTxhGVe1E6m6YrlOx6IPVPPFZfHXGuHugpeYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wu0piOdr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741782276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x5eH1CtD+RuuF9Ip0GWP4GE3Gbbme2ciDSuu2/kRpJY=;
	b=Wu0piOdrvtTSN1bW15fL5JQdV25PYSDK9TFOf22y82wWP6FIUVAU+kuG9eWaWHaIQnYCOY
	QS4321fA79cGI4yUykeN8CmN9zvlPOA3/UedoRjxqMP4873lMQ49E1Tk9AEZYwV+rQ/tMW
	AFlWpa7aEGXXcJerLgDtbm/IMlVLM+E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-7V5egqQtPQqEMBYPurGu2w-1; Wed, 12 Mar 2025 08:24:35 -0400
X-MC-Unique: 7V5egqQtPQqEMBYPurGu2w-1
X-Mimecast-MFC-AGG-ID: 7V5egqQtPQqEMBYPurGu2w_1741782274
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39131851046so2305198f8f.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 05:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741782274; x=1742387074;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5eH1CtD+RuuF9Ip0GWP4GE3Gbbme2ciDSuu2/kRpJY=;
        b=DJ5CkTsiScuqakZ/0ZaAK5fZDLzf6yGlo26/N+/BTD7d8WhVzD14j2fk1q6JyxVWVU
         EOzm0l15Da0swQ3Z4noz33OCawVCDXk383ugupuEGM9d8tVmq4FOctIJhzMp1bA4rf+M
         8hx0w79Klh52DP9jwsbXphaTQqoA71Dyl27P6GCWSw9yK/lCo1VzcyWeTUqPm8bts4ah
         oMvaEV5z+h++ZmbcIdUJ6/Vi/TS7LDPp2SWk/WpxWInSoyxPf/QQR2bqBWf8dxUxAH2T
         U5ln4UbIX65H8EVOMS+YQY1xnoxKJ8ZCO8WiDofE/6YHWLky0w9H0/RDsTiU5TTEGUC0
         YICw==
X-Forwarded-Encrypted: i=1; AJvYcCWnz3wTOm7kM4+pm6JVnmjfVmkR/uYJ1xCSAJVRpmnz9WZ/XVNZdeNeH0Ylto24gIUtJ3I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3asMEpKMwZejp1FiT1W5Yz3P/YiPu+YCNm/ho1vkbfJO2xeHm
	MAyR1/WUp0W+AxQ/l8M+dDW7OyuaPc5DXcKXmknSZY5wiYxfw1NG7l3IiNbBqb2FPo4gQ17N9gq
	dDd3EDuC0BLP+PBOfvf7rH/p96rQoiIKhu98DrXQ7H+e/t4QCRw==
X-Gm-Gg: ASbGncv/X4aIC8E9OvPRru//MzKpCI9Jc4l/K6ir3qbsFSlgg0fWLFX5MLUH/sVQS7Y
	63vs8PH/Mtigd8immJF9fTa34HM41v+P4KyOu/PQiBE6mlqmhuY4RDbG0Df4LJqidSXYeyM7vMU
	qtrTNWeN0zW7eH7VLLQTdKXqDKBdN3u7eXMcXQjriNmWACXLLdRR+GkyKo0oEKzF64Pz5nE8eb3
	a/aq54TH62KUgFH7u2yDI8aeO+kp2/txbuuWlBq43jdaGb5fWBGOwhaUyCaDRCl0/x5hUChM8f7
	4bbmK8XWZnus2rME0I2N0A==
X-Received: by 2002:a5d:5f45:0:b0:390:fb37:1bd with SMTP id ffacd0b85a97d-39132da8e47mr15944270f8f.46.1741782274242;
        Wed, 12 Mar 2025 05:24:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH51uGVxDp6sgBP8pjlgcI8Szg5ZUIcVBBUE+ubiIrZwvNFTjW8ub4KhseAZKG9LTzzqgjnmw==
X-Received: by 2002:a5d:5f45:0:b0:390:fb37:1bd with SMTP id ffacd0b85a97d-39132da8e47mr15944240f8f.46.1741782273797;
        Wed, 12 Mar 2025 05:24:33 -0700 (PDT)
Received: from [192.168.10.81] ([176.206.122.167])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43d0a72f303sm20110135e9.4.2025.03.12.05.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 05:24:33 -0700 (PDT)
Message-ID: <510e0391-410b-40be-b556-f91554b8d3a1@redhat.com>
Date: Wed, 12 Mar 2025 13:24:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio
 to change
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
 rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Nikunj A Dadhania <nikunj@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/24 09:55, Isaku Yamahata wrote:
> Add guest_tsc_protected member to struct kvm_arch_vcpu and prohibit
> changing TSC offset/multiplier when guest_tsc_protected is true.

Thanks Isaku!  To match the behavior of the SEV-SNP patches, this is
also needed, which I have added to kvm-coco-queue:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc2f14a6d8a1..ccde7c2b2248 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3919,7 +3925,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  	case MSR_IA32_TSC:
  		if (msr_info->host_initiated) {
  			kvm_synchronize_tsc(vcpu, &data);
-		} else {
+		} else if (!vcpu->arch.guest_tsc_protected) {
  			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
  			adjust_tsc_offset_guest(vcpu, adj);
  			vcpu->arch.ia32_tsc_adjust_msr += adj;

Also, I rewrote the commit message as follows:

     Add guest_tsc_protected member to struct kvm_arch_vcpu and prohibit
     changing TSC offset/multiplier when guest_tsc_protected is true.
     
     X86 confidential computing technology defines protected guest TSC so that
     the VMM can't change the TSC offset/multiplier once vCPU is initialized.
     SEV-SNP defines Secure TSC as optional, whereas TDX mandates it.
     
     KVM has common logic on x86 that tries to guess or adjust TSC
     offset/multiplier for better guest TSC and TSC interrupt latency
     at KVM vCPU creation (kvm_arch_vcpu_postcreate()), vCPU migration
     over pCPU (kvm_arch_vcpu_load()), vCPU TSC device attributes
     (kvm_arch_tsc_set_attr()) and guest/host writing to TSC or TSC adjust MSR
     (kvm_set_msr_common()).
     
     The current x86 KVM implementation conflicts with protected TSC because the
     VMM can't change the TSC offset/multiplier.
     Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
     offset/multiplier, the TSC timer interrupts is injected to the guest at the
     wrong time if the KVM TSC offset is different from what the TDX module
     determined.
     
     Originally this issue was found by cyclic test of rt-test [1] as the
     latency in TDX case is worse than VMX value + TDX SEAMCALL overhead.  It
     turned out that the KVM TSC offset is different from what the TDX module
     determines.
     
     Disable or ignore the KVM logic to change/adjust the TSC offset/multiplier
     somehow, thus keeping the KVM TSC offset/multiplier the same as the
     value of the TDX module.  Writes to MSR_IA32_TSC are also blocked as
     they amount to a change in the TSC offset.
     
     [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Paolo

> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/x86.c              | 9 ++++++++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 61b7e9fe5e57..112b8a4f1860 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1036,6 +1036,7 @@ struct kvm_vcpu_arch {
>   
>   	/* Protected Guests */
>   	bool guest_state_protected;
> +	bool guest_tsc_protected;
>   
>   	/*
>   	 * Set when PDPTS were loaded directly by the userspace without
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 65d871bb5b35..a6cf4422df28 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2587,6 +2587,9 @@ EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
>   
>   static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
>   {
> +	if (vcpu->arch.guest_tsc_protected)
> +		return;
> +
>   	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
>   				   vcpu->arch.l1_tsc_offset,
>   				   l1_offset);
> @@ -2650,6 +2653,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>   
>   	lockdep_assert_held(&kvm->arch.tsc_write_lock);
>   
> +	if (vcpu->arch.guest_tsc_protected)
> +		return;
> +
>   	if (user_set_tsc)
>   		vcpu->kvm->arch.user_set_tsc = true;
>   
> @@ -5028,7 +5034,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
>   						vcpu->arch.last_guest_tsc);
>   			kvm_vcpu_write_tsc_offset(vcpu, offset);
> -			vcpu->arch.tsc_catchup = 1;
> +			if (!vcpu->arch.guest_tsc_protected)
> +				vcpu->arch.tsc_catchup = 1;
>   		}
>   
>   		if (kvm_lapic_hv_timer_in_use(vcpu))


