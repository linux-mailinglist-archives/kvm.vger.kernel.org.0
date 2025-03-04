Return-Path: <kvm+bounces-39971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A98A4D336
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B66D3AAC97
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB6A1F5404;
	Tue,  4 Mar 2025 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hRxl63Yh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3C11F4264
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068093; cv=none; b=lpRzd+t7FEfBS4lONpl56HiipfEceNc1C/KN+ED2mtCtLh7hFbL6zVnGcAOrqVSQ7TNlJ0nzoOBkSlQC3T/aeQJIj/jUMWicC3jwpAbpZHaNNf1u8Q4iNL6ra9XkXja0plGWQF2mHUoYXkx3RBcsBwWTNe7dlam57b6IO9ECDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068093; c=relaxed/simple;
	bh=eL87BOoGzXVDBj2SXPjQdFK+ZlB7bcDHzO1QoGp1gFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0/S1yPw0411fw2T4tRahC7XizjsjrW9IymP27xbjHpeN7sOeY/oAU/m4VxcEgCbUm47ox4f1txCWXwwN2eFCvVvmU2UnU+W/q60YdEXqOxXPhsHP5oAQazK50pZH3O2yZDxX/fbspR2wVX/I1nDmNt0n3e6k+J4l+3d76wlghA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hRxl63Yh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boHxbjq3P2vU0fO6UUb8Hfrkk8ida9vHUjKzaMq4o5k=;
	b=hRxl63YhH3cWq5wtgOcWS0xmKRfWoVP4s3YnHbChoSFQx2YGDQQ4doLP2DIFvUn+DB8rLh
	Vjl+z+pG7i2W+m0ec6sYJuTJRuOKxcg6kMOTX5FA+IvbhMVuv/j41JTWF+zu/wyfS5gffZ
	En7Eem8DZqG2tDduQLzNIlwGiAhh/v4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-vJzJJj2WOO6KNxF4zOcTCw-1; Tue, 04 Mar 2025 01:01:26 -0500
X-MC-Unique: vJzJJj2WOO6KNxF4zOcTCw-1
X-Mimecast-MFC-AGG-ID: vJzJJj2WOO6KNxF4zOcTCw_1741068085
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-223725aa321so21424715ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 22:01:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741068085; x=1741672885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boHxbjq3P2vU0fO6UUb8Hfrkk8ida9vHUjKzaMq4o5k=;
        b=IR8kvkegzx8cAXZnxdgX6DM89wZL7bSnCiBsfXKXaKK1VV/CPZnyZJP4EKfOLDhuiR
         88q0bhTotUxMsra5GQX7I1SBOzIxftg2QAfOFVLBNHMNzZ6SCe61Yo8GlaJq0k2Silt+
         A+0gjjh6LqL9kC1EhbZC6R0C9AhDmlLdT4BHzkievVwfB+ippoAU/bVAzFgwjmo6YrZq
         mkNm3BnZ+fjMnWW92B9f9WZ13yeoUM+O1xIOVnH41wcV4tqGviw6ehp44I9H+2myhUlm
         WB+U4eoZerDiCix8JldSBYTNtMa2G/ljIXnllXaPxa3b//i92dhY40Cv6xNjT0O4+1rt
         GPpA==
X-Forwarded-Encrypted: i=1; AJvYcCVhLNs6mcbU/HBZNBzjaWHX6kG8wd4qIyzAZePL1K6mhTfDyxdwDY2J/iwCbdsdo0YnnBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOe5dG6IiU3IfaSO3PB8vrvEaEhKXULdTm2zKTQhxI3qjhi1Hi
	bvyK83hM04GQQYpZSWQ78HlzlhkE9SnVOtEEM4/LXJRt4DBK+OZf20wEnbhmdt7WlidBC9vB8hy
	AlDhB7oBP8RuSE6PqLt4m3novlhTqia+jBQTB9u2wcLu/lTj38w==
X-Gm-Gg: ASbGncvC5kRT6TqnYkBujj8semz9yCpnoAgiJHrrdPEMmoQeIkl5E0cvvLXzVeI7/g6
	No7l2lA2GApLv5qkQdmVHUztESfFBewmI+9HtCIWbjR0MxsaM29rdpbesW6SwZseMAO5d2FTq8+
	DbSo+A1FOS65fDkUpp44/+IdT9PqbeLpR23QY4XEcNFYPd9Uw/DS4sEcbguAkhcsEphbajdjd1M
	0aui0m7qsjz/aXWD7vuns0reQoCs2mpOw+dkrEAB/Yhrd4u5t5MfnKXC0HNN9D2HwtfJJNDyHnX
	FQaLZy4gumwv+mOfMA==
X-Received: by 2002:a17:902:d543:b0:210:f706:dc4b with SMTP id d9443c01a7336-22368f8901emr239972325ad.13.1741068085381;
        Mon, 03 Mar 2025 22:01:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHElCuS6yRgRylUHMYlinoo6CRmRHfyntq1vELw6NqviCnDfsX3HH8S1d66GYPIYgVFC5KeFg==
X-Received: by 2002:a17:902:d543:b0:210:f706:dc4b with SMTP id d9443c01a7336-22368f8901emr239972065ad.13.1741068085037;
        Mon, 03 Mar 2025 22:01:25 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504dc6desm87837665ad.168.2025.03.03.22.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:01:24 -0800 (PST)
Message-ID: <12b5ba41-4b1e-4876-9796-d1d6bb344015@redhat.com>
Date: Tue, 4 Mar 2025 16:01:16 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/45] arm64: rme: support RSI_HOST_CALL
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-29-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-29-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
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
> index c785005f821f..4f7602aa3c6c 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -107,6 +107,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return -EFAULT;
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

I don't understand how a negative error can be returned from kvm_smccc_call_handler().
Besides, SMCCC_RET_NOT_SUPPORTED has been set to GPR[0 - 3] if the request can't be
supported. Why we need to set GPR[0] to ~0UL, which corresponds to SMCCC_RET_NOT_SUPPORTED
if I'm correct. I guess change log or a comment to explain the questions would be
nice.

>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -168,6 +188,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
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


