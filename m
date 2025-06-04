Return-Path: <kvm+bounces-48424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF82ACE216
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88C0A18949C2
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145351DED69;
	Wed,  4 Jun 2025 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/LtHklp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3F5339A1
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749053989; cv=none; b=p4YtSKq0G5qDrgRGrK7LayGJACcVwH7ef2S/WqOH5FWBeGpOg5teXTyalRT39ek/cPDYQ+9+BanGb620NnEDgE80dlj61AaahoWV0BuZkzDJXlpTGhK8LOQt4T3rIKaxmxE8nDE0bNTpswoc7j7fXOu9GrLrMfcjNd27Wc+g0UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749053989; c=relaxed/simple;
	bh=y3F25a2pa6S8w4TqkjybCugMmFlZGUBOKp656lW4RBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdjWSpBBHg+7gtuNnQne/9rxa5zoi0mYpDbkg70jFdEg3aGCkXdA9BEve1Cp7slYvtbwYLfPQwNw9hmLHnQnL7AibNRG4y2cRZK9tO9Mk9JI5t/WHnqJgN9+xIwI6ze4i0N7DgrLMnvVrIxmLKP59FZl0ozO3CPYMfbOaFiathY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b/LtHklp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749053986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=csg6622WwuHA1d9W4OikS57rwnjGZheDjPfoYpBH7sQ=;
	b=b/LtHklpPRMXz2Tnc6b4kkYivkaeG5tNlCjUfvXU4jgWW52ytOrMcvqwqOTUz3ssa4bt41
	/ci5uVZ6ZOXbVPoGPYtQJF/K2ll0HKC6E0pe5QvZrK6Bouw2Mesiczu0KPFDNiU0BQcsHO
	7T0ZyuzTWe4F70eTTtVO/x9jTI7sxfc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-YZif_Bv1Ox2e29JChHSeNA-1; Wed, 04 Jun 2025 12:19:45 -0400
X-MC-Unique: YZif_Bv1Ox2e29JChHSeNA-1
X-Mimecast-MFC-AGG-ID: YZif_Bv1Ox2e29JChHSeNA_1749053984
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f8fd1847so2991f8f.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749053984; x=1749658784;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csg6622WwuHA1d9W4OikS57rwnjGZheDjPfoYpBH7sQ=;
        b=EMP9rB7by6ZHsWUJ2mapTpvvGnjZimfSp5bKzrtKLUBbFKmdqT0fVSIu9ncqqCLDx2
         JGABnOv9DiHDlbUV/vVXdA3DJobffg3fiyc9t6HMxin+8reKM88mVzPvHcFJb/dt79Yu
         nnx96MIWyt83O1pq64qdIEsGtVpdlm39x5qbkMb5CUItl+Woy9rz4ZaRIquN72BcL5fZ
         pMlNr3+dBSVNDkdcgYQi/ZgERpstisi1e7iOiVcGf+qkda1HG6lygTvneQLEqi8aNCMf
         YTPXLpKeRyZpPnZOtQ8YLjWUe+kimFYiYw8q3aGZmgsveWKX0deLwKc8o7IEbigZduGu
         7L4Q==
X-Gm-Message-State: AOJu0YyhKeIEImVDlwOd4pD1x8VuCZXLoYEa2yaPSsfrhG5UZ/KT6HK1
	N8iBA+0Hm4GlV0pAls0s0t6ltmKLtoIxVAiyDSiYqRimKyU1Q6Ce0mzYOHhsbJWyW6pBsdj4qC0
	l3BXGTaSy4+HHKGisT9kp6no2XC0jIgMnPURtLGZVXy5U/uEaiT9O+6LyeEnbKQ==
X-Gm-Gg: ASbGnctc3oun4pAhYpPLw7R2csMjgCNARCjni4fWgKlh2gUHQobnWVIRjsAu/I1020g
	r0Q8yYx4ozfH3my14zdFjvX6K+xnh6uCxHqF+zzozxA3k3oz5C/ZB/adruEEgG1JIouO3sbj3o1
	FeuzNCuSnY9swWN7sjqemYfF5k/CN8oKUhLVigFGCMnY9txA6L5R0dlEAf18qtqF/KwmACHPn+P
	dOJWGCWas3+8HeCMeNDjMlZ3oo3ukyFB6AXxgGqUi8CkJeuQDPBAwPACtoXc/prShFNmfuI9RC4
	C7Idvkmxo7kYCA==
X-Received: by 2002:a05:6000:250c:b0:3a0:b84c:7c64 with SMTP id ffacd0b85a97d-3a51d8ff9e2mr2726968f8f.13.1749053983541;
        Wed, 04 Jun 2025 09:19:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf43lIbEauPt+sDm35yLZ8848223C3hrJgOMF0TVNAStsqCrlELVBS19S2PHcrLlNfnUhapQ==
X-Received: by 2002:a05:6000:250c:b0:3a0:b84c:7c64 with SMTP id ffacd0b85a97d-3a51d8ff9e2mr2726951f8f.13.1749053983114;
        Wed, 04 Jun 2025 09:19:43 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-450d7fa2493sm201440525e9.16.2025.06.04.09.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:19:42 -0700 (PDT)
Message-ID: <a9f3f64c-2f82-40b0-80c0-ed1482861dc2@redhat.com>
Date: Wed, 4 Jun 2025 18:19:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/28] KVM: nSVM: Access MSRPM in 4-byte chunks only for
 merging L0 and L1 bitmaps
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-26-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250529234013.3826933-26-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 01:40, Sean Christopherson wrote:
> Access the MSRPM using u32/4-byte chunks (and appropriately adjusted
> offsets) only when merging L0 and L1 bitmaps as part of emulating VMRUN.
> The only reason to batch accesses to MSRPMs is to avoid the overhead of
> uaccess operations (e.g. STAC/CLAC and bounds checks) when reading L1's
> bitmap pointed at by vmcb12.  For all other uses, either per-bit accesses
> are more than fast enough (no uaccess), or KVM is only accessing a single
> bit (nested_svm_exit_handled_msr()) and so there's nothing to batch.
> 
> In addition to (hopefully) documenting the uniqueness of the merging code,
> restricting chunked access to _just_ the merging code will allow for
> increasing the chunk size (to unsigned long) with minimal risk.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/nested.c | 50 ++++++++++++++++-----------------------
>   arch/x86/kvm/svm/svm.h    | 18 ++++++++++----
>   2 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e07e10fb52a5..a4e98ada732b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -187,31 +187,19 @@ void recalc_intercepts(struct vcpu_svm *svm)
>   static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
>   static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
>   
> -static const u32 msrpm_ranges[] = {
> -	SVM_MSRPM_RANGE_0_BASE_MSR,
> -	SVM_MSRPM_RANGE_1_BASE_MSR,
> -	SVM_MSRPM_RANGE_2_BASE_MSR
> -};
> +#define SVM_BUILD_MSR_BYTE_NR_CASE(range_nr, msr)				\
> +	case SVM_MSRPM_FIRST_MSR(range_nr) ... SVM_MSRPM_LAST_MSR(range_nr):	\
> +		return SVM_MSRPM_BYTE_NR(range_nr, msr);
>   
>   static u32 svm_msrpm_offset(u32 msr)
>   {
> -	u32 offset;
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
> -		if (msr < msrpm_ranges[i] ||
> -		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
> -			continue;
> -
> -		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
> -		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
> -
> -		/* Now we have the u8 offset - but need the u32 offset */
> -		return offset / 4;
> +	switch (msr) {
> +	SVM_BUILD_MSR_BYTE_NR_CASE(0, msr)
> +	SVM_BUILD_MSR_BYTE_NR_CASE(1, msr)
> +	SVM_BUILD_MSR_BYTE_NR_CASE(2, msr)
> +	default:
> +		return MSR_INVALID;
>   	}
> -
> -	/* MSR not in any range */
> -	return MSR_INVALID;
>   }
>   
>   int __init nested_svm_init_msrpm_merge_offsets(void)
> @@ -245,6 +233,12 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
>   		if (WARN_ON(offset == MSR_INVALID))
>   			return -EIO;
>   
> +		/*
> +		 * Merging is done in 32-bit chunks to reduce the number of
> +		 * accesses to L1's bitmap.
> +		 */
> +		offset /= sizeof(u32);
> +
>   		for (j = 0; j < nested_svm_nr_msrpm_merge_offsets; j++) {
>   			if (nested_svm_msrpm_merge_offsets[j] == offset)
>   				break;
> @@ -1363,8 +1357,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
>   
>   static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
>   {
> -	u32 offset, msr, value;
> -	int write, mask;
> +	u32 offset, msr;
> +	int write;
> +	u8 value;
>   
>   	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
>   		return NESTED_EXIT_HOST;
> @@ -1372,18 +1367,15 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
>   	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
>   	offset = svm_msrpm_offset(msr);
>   	write  = svm->vmcb->control.exit_info_1 & 1;
> -	mask   = 1 << ((2 * (msr & 0xf)) + write);

This is wrong.  The bit to read isn't always bit 0 or bit 1, therefore 
mask needs to remain.  But it can be written easily as:

    	msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
	write = svm->vmcb->control.exit_info_1 & 1;

	bit = svm_msrpm_bit(msr);
	if (bit == MSR_INVALID)
		return NESTED_EXIT_DONE;
	offset = bit / BITS_PER_BYTE;
	mask = BIT(write) << (bit & (BITS_PER_BYTE - 1));

and this even removes the need to use svm_msrpm_offset() in 
nested_svm_exit_handled_msr().


At this point, it may even make sense to keep the adjustment for the 
offset in svm_msrpm_offset(), like this:

static u32 svm_msrpm_offset(u32 msr)
{
	u32 bit = svm_msr_bit(msr);
	if (bit == MSR_INVALID)
		return MSR_INVALID;

	/*
	 * Merging is done in 32-bit chunks to reduce the number of
	 * accesses to L1's bitmap.
	 */
	return bit / (BITS_PER_BYTE * sizeof(u32));
}

I'll let you be the judge on this.

Paolo

>   	if (offset == MSR_INVALID)
>   		return NESTED_EXIT_DONE;
>   
> -	/* Offset is in 32 bit units but need in 8 bit units */
> -	offset *= 4;
> -
> -	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset, &value, 4))
> +	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset,
> +				&value, sizeof(value)))
>   		return NESTED_EXIT_DONE;
>   
> -	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> +	return (value & BIT(write)) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
>   }
>   
>   static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 77287c870967..155b6089fcd2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -634,15 +634,23 @@ static_assert(SVM_MSRS_PER_RANGE == 8192);
>   	(range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +			\
>   	 (msr - SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR) * SVM_BITS_PER_MSR)
>   
> -#define SVM_MSRPM_SANITY_CHECK_BITS(range_nr)					\
> +#define SVM_MSRPM_BYTE_NR(range_nr, msr)					\
> +	(range_nr * SVM_MSRPM_BYTES_PER_RANGE +					\
> +	 (msr - SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR) / SVM_MSRS_PER_BYTE)
> +
> +#define SVM_MSRPM_SANITY_CHECK_BITS_AND_BYTES(range_nr)				\
>   static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 1) ==	\
>   	      range_nr * 2048 * 8 + 2);						\
>   static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 7) ==	\
> -	      range_nr * 2048 * 8 + 14);
> +	      range_nr * 2048 * 8 + 14);					\
> +static_assert(SVM_MSRPM_BYTE_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 1) ==	\
> +	      range_nr * 2048);							\
> +static_assert(SVM_MSRPM_BYTE_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 7) ==	\
> +	      range_nr * 2048 + 1);
>   
> -SVM_MSRPM_SANITY_CHECK_BITS(0);
> -SVM_MSRPM_SANITY_CHECK_BITS(1);
> -SVM_MSRPM_SANITY_CHECK_BITS(2);
> +SVM_MSRPM_SANITY_CHECK_BITS_AND_BYTES(0);
> +SVM_MSRPM_SANITY_CHECK_BITS_AND_BYTES(1);
> +SVM_MSRPM_SANITY_CHECK_BITS_AND_BYTES(2);
>   
>   #define SVM_BUILD_MSR_BITMAP_CASE(bitmap, range_nr, msr, bitop, bit_rw)		\
>   	case SVM_MSRPM_FIRST_MSR(range_nr) ... SVM_MSRPM_LAST_MSR(range_nr):	\


