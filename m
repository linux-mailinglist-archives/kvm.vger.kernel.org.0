Return-Path: <kvm+bounces-48422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1F2ACE1FB
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A75593A9054
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53071D799D;
	Wed,  4 Jun 2025 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDtRzrhR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6851D63C6
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749053508; cv=none; b=RfSrGUnleX9G8xCSmgmZIuMxM8yFO3+2gUFqJwklSeP0VWxWpEOqmsuUrUeAdLLlRknPhk3bDp0W2Sr4BYajGfEaRL7CvJ6ewt1cGX7RXgOx94N5UFtokgDb8seQ4fzHShylBbEkt1wtqtgCZ/fM2y+zErPnK3hm5PZDOfecE84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749053508; c=relaxed/simple;
	bh=PEBRC6vyw7Zzr/Dx+RgU1IbBLuh5V9Aboc7E0pI4nxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSG59Zm53/PvJ0uhWp3wB3NLiq8f7ZHnJGTeuZIPh4ImOB1zbjMsEsoOBen4rpX/nSwzZfmp4f4eqzSOVqVRUlx8hKKF0zmUxgdODFFv6t68jyv9kyv3DH6gg4ppUZeoZnM5/LQc5wTDV+gPfhI0o/6uI4lU7lM/2ZKsYroV24g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDtRzrhR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749053505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DsR/Xi77gXaYpWGLoi6n+eLDE2ORizgb2ZfPz94+A/w=;
	b=cDtRzrhRgFC4KxcIoxRz9lnT+Jxwmj/WilC8f+XwAMlAevGZ2/N1WScvRN6giE6170maZ8
	3m+fyAx8X3Ac9z97oTO3Uo64lAvxo/rZoRliQwgPNvKBdDtZbZNSUdNDLXIxBYaKNmN/vR
	8vr6vyNSPg0p0rpc+BCQRNx+VNCAyHo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-JCx7_qPXO8W5uIYwlDFr9Q-1; Wed, 04 Jun 2025 12:11:43 -0400
X-MC-Unique: JCx7_qPXO8W5uIYwlDFr9Q-1
X-Mimecast-MFC-AGG-ID: JCx7_qPXO8W5uIYwlDFr9Q_1749053503
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so25363085e9.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749053503; x=1749658303;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsR/Xi77gXaYpWGLoi6n+eLDE2ORizgb2ZfPz94+A/w=;
        b=FBy3YTPRLLTysrWTt2PzcxANdq55N/NEhSVt7fLEeMX1tGohJ9psN4CFInJFTz2h5t
         IFbC3XVbOgdYd9ItWwPpu6tJAxrnjC0m5AaVtwgnQVQoYIbkpkrNmypgFlCmAJLbPGtH
         AaAOhZQuNkixtyKg8GqbJ0buOjXveWAANVqGojOWvkDDkSNdnUxWxPKN4G6Us9D+AzFv
         fSDCNUZPlw9Sv0e6ism2qnB3+bxt3Ec43ywLGufZUSClBaRmD0q7T/cwDX1VGHTUxS0K
         g9HLBFOS1UPgUEQVdrTeC1/phZobg9uuv9r5pttvoPgC4P5p3WhogP+FEpORupD7HM41
         KtLQ==
X-Gm-Message-State: AOJu0YzTkNmxcen7+8nd7WbKwRKk6UBUi1EG8siil9hHEvOC/ZIKvQZT
	pHLgtw1zsIl4wbM+tHNR7YeYEub3SLQUq1tx7KYorHA3FsY8MGHxVPICg+NOVC+37EaFVpY2paT
	3fKfU+7K/QbKVBesHJCeHP8s4/C7Je+E3RcSvHDK7/ojS27bov/8q+A==
X-Gm-Gg: ASbGncuryfswzehA3nmpXLaO6wzsUs91YH1u72gep6bIkRGQ+ejuGLKWgAg8mYAhjml
	bwH4OOiYLYO9EBnqvbpFu2DGNAhZ2Eya/fNSbV2aK4NIpsef76bSH3vxwXKMmXjaRN/GP8avu+u
	ZaZ1q+3bDg6liWwD5J8ChwGkeXafB+wtViTGW+cJpd+5Oby4Z1T05fjJFUno9Tk/RIerGY3EBM5
	JXKLXPkw5qIgfT9+JwmjWcrHl10kMo1xJQN7GOgxB0y56u7mi/VygojP/6AyrUFD61ILJLRtUrP
	HaeEOu+AwqtlmA==
X-Received: by 2002:a05:600c:c84:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-451f0a64fc7mr31302315e9.5.1749053502619;
        Wed, 04 Jun 2025 09:11:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHteOnS0Gg77gqG4u7I26C//pPyu/v0qnnwsZvQ18MOxZ2BNEIuvk8lMeeyoo1HHYFxGcsk3A==
X-Received: by 2002:a05:600c:c84:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-451f0a64fc7mr31301905e9.5.1749053502227;
        Wed, 04 Jun 2025 09:11:42 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c7e5sm22134216f8f.28.2025.06.04.09.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:11:41 -0700 (PDT)
Message-ID: <1392db34-0c37-49db-8ece-68c02ff3520d@redhat.com>
Date: Wed, 4 Jun 2025 18:11:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/28] KVM: SVM: Add helpers for accessing MSR bitmap that
 don't rely on offsets
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-12-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250529234013.3826933-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 01:39, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 47a36a9a7fe5..e432cd7a7889 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -628,6 +628,50 @@ static_assert(SVM_MSRS_PER_RANGE == 8192);
>   #define SVM_MSRPM_RANGE_1_BASE_MSR	0xc0000000
>   #define SVM_MSRPM_RANGE_2_BASE_MSR	0xc0010000
>   
> +#define SVM_MSRPM_FIRST_MSR(range_nr)	\
> +	(SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR)
> +#define SVM_MSRPM_LAST_MSR(range_nr)	\
> +	(SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR + SVM_MSRS_PER_RANGE - 1)
> +
> +#define SVM_MSRPM_BIT_NR(range_nr, msr)						\
> +	(range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +			\
> +	 (msr - SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR) * SVM_BITS_PER_MSR)
> +
> +#define SVM_MSRPM_SANITY_CHECK_BITS(range_nr)					\
> +static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 1) ==	\
> +	      range_nr * 2048 * 8 + 2);						\
> +static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 7) ==	\
> +	      range_nr * 2048 * 8 + 14);
> +
> +SVM_MSRPM_SANITY_CHECK_BITS(0);
> +SVM_MSRPM_SANITY_CHECK_BITS(1);
> +SVM_MSRPM_SANITY_CHECK_BITS(2);

Replying here for patches 11/25/26.  None of this is needed, just write 
a function like this:

static inline u32 svm_msr_bit(u32 msr)
{
	u32 msr_base = msr & ~(SVM_MSRS_PER_RANGE - 1);
	if (msr_base == SVM_MSRPM_RANGE_0_BASE_MSR)
		return SVM_MSRPM_BIT_NR(0, msr);
	if (msr_base == SVM_MSRPM_RANGE_1_BASE_MSR)
		return SVM_MSRPM_BIT_NR(1, msr);
	if (msr_base == SVM_MSRPM_RANGE_2_BASE_MSR)
		return SVM_MSRPM_BIT_NR(2, msr);
	return MSR_INVALID;
}

and you can throw away most of the other macros.  For example:

> +#define SVM_BUILD_MSR_BITMAP_CASE(bitmap, range_nr, msr, bitop, bit_rw)		\
> +	case SVM_MSRPM_FIRST_MSR(range_nr) ... SVM_MSRPM_LAST_MSR(range_nr):	\
> +		return bitop##_bit(SVM_MSRPM_BIT_NR(range_nr, msr) + bit_rw, bitmap);

... becomes a lot more lowercase:

static inline rtype svm_##action##_msr_bitmap_##access(
	unsigned long *bitmap, u32 msr)
{
	u32 bit = svm_msr_bit(msr);
	if (bit == MSR_INVALID)
		return true;
	return bitop##_bit(bit + bit_rw, bitmap);
}


In patch 25, also, you just get

static u32 svm_msrpm_offset(u32 msr)
{
	u32 bit = svm_msr_bit(msr);
	if (bit == MSR_INVALID)
		return MSR_INVALID;
	return bit / BITS_PER_BYTE;
}

And you change everything to -EINVAL in patch 26 to kill MSR_INVALID.

Another nit...

> +#define BUILD_SVM_MSR_BITMAP_HELPERS(ret_type, action, bitop)			\
> +	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, read,  0)	\
> +	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, write, 1)
> +
> +BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
> +BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
> +BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
Yes it's a bit duplication, but no need for the nesting, just do:

BUILD_SVM_MSR_BITMAP_HELPERS(bool, test,  test,    read,  0)
BUILD_SVM_MSR_BITMAP_HELPERS(bool, test,  test,    write, 1)
BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear, read,  0)
BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear, write, 1)
BUILD_SVM_MSR_BITMAP_HELPERS(void, set,   __set,   read,  0)
BUILD_SVM_MSR_BITMAP_HELPERS(void, set,   __set,   write, 1)

Otherwise, really nice.

Paolo


