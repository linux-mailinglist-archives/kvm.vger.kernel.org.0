Return-Path: <kvm+bounces-20595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 368BB91A2E4
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 929F9B22803
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE59613B285;
	Thu, 27 Jun 2024 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNcQnGoQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF524D5BD
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481502; cv=none; b=X16EsphmtM5/2Xn7Ax/aFlIZxdI0fts/HwOQ/ewickTWXchHcfOPEVbr4h1Jc1UM4JV1LBYBa0Z4pxYg9GW4rIYgTbTZBk9iKZE4Q5kk0uwhmnVOwXgDL1Tbc1fKoxg3aQvmPqtW4+qCPUzbWEOfYI5jvPRdppKKsJ7IpxGnV70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481502; c=relaxed/simple;
	bh=yuFWJtdUiYRkpwh6rSQvEWbXJ0BQlft24jQgn9ZM8a8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mON4Csn4K8vjQvXzXlE+HLP1U4py/3nRUsv6bZ7tpes024ySwqdx/tFTuvs4pnLYetmEF9gl0vxApIH3ubVUdX0yKe9Aph7NLSi6Qrqqkn685z4ECwN4He6Pge7FwUYaaRjSwHoMqsn0HUCIInHSCkTxqWYDNzUhNRKUrAyvuiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNcQnGoQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719481498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yqRLg7ee1bABnvc/dG6I18978Zp1WN2T4sMbFW19aJc=;
	b=QNcQnGoQFiu/50/0yG+y49Q6yn3nHsvDfQJ6+LlXVJahuYYfTZDG1AXaGCbvtpfyDxHEJm
	wBsY1i/ob0bOI94fvyussZdw9ZpSa0VzycBNuPw0tknimxCeyLQlcWKPXGr0skd4uhmWBm
	fE+rzrNSjosgbUU1ozOeXGQTv/yE3Q4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-wSL9LBbzPT2uZ1cl26uXTg-1; Thu, 27 Jun 2024 05:44:57 -0400
X-MC-Unique: wSL9LBbzPT2uZ1cl26uXTg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6ae4c8c30baso99066646d6.0
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 02:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719481497; x=1720086297;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqRLg7ee1bABnvc/dG6I18978Zp1WN2T4sMbFW19aJc=;
        b=pV8mT6wHq8Pto7Nv+zhzdRG0bttiwTs5C29XQw9iugkZh2tOBixE+4+8oVD/JvCe2t
         qqTUpMJcu/ki27v9gC596EaIZ0dsWTqqtkeLKSXmGFkCQ5nMG6qjipIPvZRrFCOlWK3P
         EVCOmNvCn89cPpqBlwutnakxZR+j7BG0WgF8oQ8OjXu48VOwi2ZR1AIf7xxMyDjUM11X
         Z9cY4JvjfvIau+94F7gYGUwAuKu3kUNLTdIsWLOgPumIurAF6SILpzycsTQaBqg5oEJv
         DYGp2Uk7QpDkicQaEK6klMJANI6XN0CWNkl9aQ1k5a73crbdlZTtEgUy8Msdfj7yCkNr
         IW4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFfM4qcrQvrJNC04AaDJR7CL2z70GPeseCH+BZ5dspavlBaSs5xqpMcydQgvIGtX/L6ObxMHQswbhw5+H6SmbMsmvm
X-Gm-Message-State: AOJu0YyOgOD7Xve4tRud/Tl6kQVpHDcfL11w2uWEgYfGXebo2TCwyj8L
	nOLKSyxkKbHarNCSwToVaUEWYdj4my7oZMl/wg00fNhBitNVviEvXn6HBRla3W7NYu6DR29hobf
	pHKurYg5m8e0+LwAna8Y43H/2HiXBaEgRceOrASMj7su/7TzMF2xQ52sKKQ==
X-Received: by 2002:ad4:576a:0:b0:6b5:4526:8be9 with SMTP id 6a1803df08f44-6b545268ee8mr149086746d6.51.1719481496759;
        Thu, 27 Jun 2024 02:44:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErqTyRFwKHq7SxVGJqIw+gNtoVN8ukHfx2uuZniDKZqVYn1b3b+Mt14w/7nAuKpA7JA480VA==
X-Received: by 2002:ad4:576a:0:b0:6b5:4526:8be9 with SMTP id 6a1803df08f44-6b545268ee8mr149086536d6.51.1719481496395;
        Thu, 27 Jun 2024 02:44:56 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-177-66.web.vodafone.de. [109.43.177.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5924657a9sm3759426d6.34.2024.06.27.02.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 02:44:55 -0700 (PDT)
Message-ID: <121e78f1-ca4f-46a1-a5ac-26d1928a5921@redhat.com>
Date: Thu, 27 Jun 2024 11:44:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, linux-s390
 <linux-s390@vger.kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Marc Hartmayer <mhartmay@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240627090520.4667-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/06/2024 11.05, Christian Borntraeger wrote:
> in rare cases, e.g. for injecting a machine check we do intercept all
> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> LPSWEY was added. KVM needs to handle that as well.
> 
> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  1 +
>   arch/s390/kvm/kvm-s390.c         |  1 +
>   arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>   arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>   4 files changed, 50 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 95990461888f..9281063636a7 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -427,6 +427,7 @@ struct kvm_vcpu_stat {
>   	u64 instruction_io_other;
>   	u64 instruction_lpsw;
>   	u64 instruction_lpswe;
> +	u64 instruction_lpswey;
>   	u64 instruction_pfmf;
>   	u64 instruction_ptff;
>   	u64 instruction_sck;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 50b77b759042..8e04c7f0c90c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -132,6 +132,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	STATS_DESC_COUNTER(VCPU, instruction_io_other),
>   	STATS_DESC_COUNTER(VCPU, instruction_lpsw),
>   	STATS_DESC_COUNTER(VCPU, instruction_lpswe),
> +	STATS_DESC_COUNTER(VCPU, instruction_lpswey),
>   	STATS_DESC_COUNTER(VCPU, instruction_pfmf),
>   	STATS_DESC_COUNTER(VCPU, instruction_ptff),
>   	STATS_DESC_COUNTER(VCPU, instruction_sck),
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 111eb5c74784..c61966cae121 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -138,6 +138,22 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
>   	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
>   }
>   
> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> +{
> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
> +
> +	/* The displacement is a 20bit _SIGNED_ value */
> +	if (disp1 & 0x80000)
> +		disp1+=0xfff00000;
> +
> +	if (ar)
> +		*ar = base1;
> +
> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
> +}
> +
>   static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
>   					      u64 *address1, u64 *address2,
>   					      u8 *ar_b1, u8 *ar_b2)
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1be19cc9d73c..1a49b89706f8 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int handle_lpswey(struct kvm_vcpu *vcpu)
> +{
> +	psw_t new_psw;
> +	u64 addr;
> +	int rc;
> +	u8 ar;
> +
> +	vcpu->stat.instruction_lpswey++;
> +
> +	if (!test_kvm_facility(vcpu->kvm, 193))
> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +
> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
> +	if (addr & 7)
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> +	if (rc)
> +		return kvm_s390_inject_prog_cond(vcpu, rc);

Quoting the Principles of Operations:

"If the storage-key-removal facility is installed, a spe-
cial-operation exception is recognized if the key value
in bits 8-11 of the storage operand is nonzero."

Do we need to have such a check here, too?

  Thomas


> +	vcpu->arch.sie_block->gpsw = new_psw;
> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	return 0;
> +}
> +
>   static int handle_stidp(struct kvm_vcpu *vcpu)
>   {
>   	u64 stidp_data = vcpu->kvm->arch.model.cpuid;
> @@ -1462,6 +1492,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
>   	case 0x61:
>   	case 0x62:
>   		return handle_ri(vcpu);
> +	case 0x71:
> +		return handle_lpswey(vcpu);
>   	default:
>   		return -EOPNOTSUPP;
>   	}


