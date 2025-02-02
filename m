Return-Path: <kvm+bounces-37079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F298A24CC1
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 07:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14ADE18842A1
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 06:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712E1D5173;
	Sun,  2 Feb 2025 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7dXItFt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67E11CAA7B
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 06:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738478517; cv=none; b=XwYE1Qi9wPaGhtZ+FlV0ZQKu7A4cN2OczBALSx3uUzIfotb4iLWQrwgDSoKlTfLDRCqYyRQgmXaliHhurxAtJiWUdZr3hg6H3KJ3kCrxoCNOK+v+Sm7pXEVKuyn2Ai4X/7zpTJb9/1Mojuhj6IE1KtS6AmZ5qzzQeMPxj8LJ5kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738478517; c=relaxed/simple;
	bh=wSTLzGhMLffhO/v6hJYaRpeR5d/1GKbHdC9MlbN+LvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mV3PL5k91x7PaQ9eTGP76aKJfxhXIc1ENUmunvZrRbdEsVPU9Jp26Bt70GE4XPdINhanBHWPdB+HKw670jlSHdgAezQcgruy4Stqv4Cd+9k3iHVjtNSiTWxNWhQ/OF36xgFF85wmNd+r5qUm7xe8nyWjkvodYCNenBeuQ41HRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7dXItFt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738478514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O9bc7QlURY2KqxOqSdcgXWV1nxuIWVaexteEdP17afs=;
	b=E7dXItFtOeCyqZlZTZEnNlzp7jPw5T5UTC/U22qHv38dWkbJUUbnHJs3KrWKZ6DNRYFtGa
	mUH0gzJyn9pcaD38DYpgxT+PVsljrccBwyEeQDNvkhtI/h34O3eeTtWqu5cDEalCoVu2WH
	S6hZAvl4pk3/DDbv0NrXTpYUTVlDXLU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-I3jLCiozMlSrG5_oLtWCQA-1; Sun, 02 Feb 2025 01:41:51 -0500
X-MC-Unique: I3jLCiozMlSrG5_oLtWCQA-1
X-Mimecast-MFC-AGG-ID: I3jLCiozMlSrG5_oLtWCQA
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2161d185f04so48331455ad.3
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 22:41:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738478510; x=1739083310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O9bc7QlURY2KqxOqSdcgXWV1nxuIWVaexteEdP17afs=;
        b=tJ8MFq3LZLK9LiPtm6yR2MPdMYXVfqvWTLbdPHi6nzwVN7ZkHAK1AWvMn+s0P3yJ/o
         5nzJIJmLPpRsJ0syLJz3HwG4tpp33S2F2mcDjPTEOWCg7j4p2+1/MIfLLaXYE+IZj7ly
         0PWej6TpTOMzhJCYAbQ1wer/MWqY5KyOfpL5Dj80fUcytllUGGUjjW9aVd0xHaf1bkOf
         36fbNKO/LuL/vhAkhJL4u4oHBKTiK3sZRAM83i9aLtatQWIacnA6J4wsq9svV1rjobmt
         mBe8Nw+PZDqni+BfHx3QThgnn+YwfdE/u+rG3wxytciFGtKs2pU4sDM6ArGh9nJ0YDYa
         hLBw==
X-Forwarded-Encrypted: i=1; AJvYcCV3+7O/9M4QhwVgbVyB3+3thLKaWs1Qlnrb405mQHgKegm9RukN+MatZSq4FEiJPhNx3nk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5Y6oq0VJ6A8Qg9m8kVtemBov9RBSy5UUIswZllZIzFJ01qd3V
	e/PvAozJyWclnUVb+f2esI0rxf90IMpH0Ec5/O4VWS50nAyYRJ78Dzuv5Z8cqKJg9HCOrVbALHK
	PH/xLFkgaDkMBWg+hJxDDkCVfJThXiGrw2gN7rBwolGXMKtl6Cw==
X-Gm-Gg: ASbGnctsVZl6JVTiU1s5ki+pkTUbQzYwE/g3nLa/mxloSBTCleWXyFrfQFlGr8r882m
	fdlmk8iOYifuolHqowucRWThVa4kF8rmGNUXwcki7W5oXeeio1ZZx+q6V0TAAgcHVMeyCD1s03y
	u2QcishALwAJzkEvexnJUypu6NUcZYRQbgFciIlRl3koUxvIvoQdNqiMtjwQS3keHKuc3q+w1R2
	skQdxR24oXNKtaPQVeMmNQBCHv4dsmWfdXGa947ckdZctMDqoJtJ67Ys41Zmx91ON+JcmzZFrg4
	GLyaVg==
X-Received: by 2002:a17:902:e742:b0:215:a97a:c6bb with SMTP id d9443c01a7336-21dd7c65891mr279349355ad.12.1738478509995;
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgiNqSMRe7eOLK7UU7yfr7SRk/XUpHiWVSGyN9DA4ZXFp8THxJ4DGREQDo0HNpjoMWa/PKyw==
X-Received: by 2002:a17:902:e742:b0:215:a97a:c6bb with SMTP id d9443c01a7336-21dd7c65891mr279349065ad.12.1738478509619;
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32efa0csm53772495ad.116.2025.02.01.22.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
Message-ID: <69a424e0-1350-484c-9ce7-b40c4fcacd8e@redhat.com>
Date: Sun, 2 Feb 2025 16:41:40 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 27/43] arm64: rme: support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-28-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-28-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Forward RSI_HOST_CALLS to KVM's HVC handler.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rme-exit.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index 8f0f9ab57f28..b2a367474d74 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -103,6 +103,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
> +{
> +	int ret, i;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu->stat.hvc_exit_stat++;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	ret = kvm_smccc_call_handler(vcpu);
> +
> +	if (ret < 0) {
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +		ret = 1;
> +	}
> +
> +	return ret;
> +}
> +

It seems that the return value from kvm_smccc_call() won't be negative. Besides,
the host call requests are currently handled by kvm_psci_call(), which isn't
what we want. So I think a new helper is needed and called in kvm_smccc_call_handler().
The new helper simply push the error (NOT_SUPPORTED) to x0. Otherwise, a unexpected
return value will be seen by guest.

handle_rec_exit
   rec_exit_host_call
     kvm_smccc_call_handler

>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -164,6 +184,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>   		return rec_exit_psci(vcpu);
>   	case RMI_EXIT_RIPAS_CHANGE:
>   		return rec_exit_ripas_change(vcpu);
> +	case RMI_EXIT_HOST_CALL:
> +		return rec_exit_host_call(vcpu);
>   	}
>   
>   	kvm_pr_unimpl("Unsupported exit reason: %u\n",

Thanks,
Gavin


