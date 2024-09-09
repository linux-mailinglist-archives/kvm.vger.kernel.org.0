Return-Path: <kvm+bounces-26128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5DB971C56
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 16:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9440B22660
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C131BA293;
	Mon,  9 Sep 2024 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1ZH2TaC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA911B9B50
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725891558; cv=none; b=mLmi9HIfAFg7G4xN0w9uKGc1eKTcrH5UpianPK9LsRzt7PxkUEo1xXTlPVq3B3Qsd6ppGulxnSR7G8U/vbWTFgmHOw+s7kkSdekygu3SUfFWrIPevtvHq5uXcI0USUzI5ujM9tWnjugdnaAXcJcYoXdHwk/PGbQ4SPLSiiUE0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725891558; c=relaxed/simple;
	bh=Fj5LNziTMqtzCjMbkl5w3kfDVFl3K59SkSvNLxIC7iM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VlxkNRpr/vUGgenKOxd4ISs42H3P2N0+OwaUa8w+oZZFb2d02NMhcpZO3vCpm9beI+KtVaPNHORw623Xjluk93qBeyIkxts8u4HSPIuT2PoT1PeuFioiUK9SXUJFr4MmO9zFdKrkWwEJlpqSmetrVfZeFHGT1V4bZeHhbDQEdt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c1ZH2TaC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725891555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eBLkKhXp9IgxNX2yeeW6O6fQLwZJ+MZJspFPgeLHbCo=;
	b=c1ZH2TaCMZulJtWtJdtKEgib17IqeCPibub19YR4QxVAmhLU53qvz8wqgYCGxUtbnt2XZv
	8aOqSMDs0vAzEYUdD4KzeWDxRkS0nY1BO+GfrH3bWI6Sa0CKL964eUZo5RspLdzkT+Ks0+
	CuKlL1dQ+QeCgIkhT9XzlvytrBCUOjg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-wXBNmmYVOJa9-jhkHRYXbg-1; Mon, 09 Sep 2024 10:19:14 -0400
X-MC-Unique: wXBNmmYVOJa9-jhkHRYXbg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3756212a589so2961876f8f.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 07:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725891553; x=1726496353;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eBLkKhXp9IgxNX2yeeW6O6fQLwZJ+MZJspFPgeLHbCo=;
        b=twtrup0S1k58+bdiYXPXL6NtlFgMbi3DIAlRFoW+3BAPXo3qKVCl7LOK9Do+kT7cG4
         IJXsBXw7CRnlo2kKNXrazut3T8i1yWif3CvFjfVpvyp+t8VCB9WLeYq0rWJE+XZvZzwk
         LHwvUF5Y3uaPJqFOt0OxIWMm9vq7Qzc9t0gg/QP8RwDQFKRTFEbAL2UF8N9E7mGSZdd7
         4GpsEBc6HVSyBeO3JkBB0rLFO4GXzUAyQuhtG/aWHDUcINW/QzndtZhnb8Tj68w0Nad0
         rFPvOtLFAWSJoYb2xQb5oyvbkzsI56WuDiJqujoxs74LObBAKQuyu9dhqalKdg73xq/1
         +AYg==
X-Forwarded-Encrypted: i=1; AJvYcCVuDcsx7a24mELQP7AQWDg/5XUJkQse7I90d64k3jz0gEQNgUni05K6AOC38DLJ9L1f34E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFqz2lwLoPqYFvGC+qZwcWB+wehjH6CqSAlF5oEr0rp8ZcXIB8
	X5EJC2rZtMpObS0nozXKxOGMNVnW+fhXpW2t62ZGkmgRAi23uHJkWxj0QtEQvpMqjTVKDTqSTsJ
	M08w1k6Zqkqp3xk6WCuSBL3hMkWNbWBhBMTbVktiBAQEDyaRXcg==
X-Received: by 2002:a05:6000:d0:b0:378:8f2f:905f with SMTP id ffacd0b85a97d-3789229b892mr6657209f8f.11.1725891552855;
        Mon, 09 Sep 2024 07:19:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF92aZYTmU0KTaowXt9FdXRZgIuqDGTbHIYM92LHicfEaWMMszqPwq3TKh+5RRCjE6otGxZew==
X-Received: by 2002:a05:6000:d0:b0:378:8f2f:905f with SMTP id ffacd0b85a97d-3789229b892mr6657187f8f.11.1725891552418;
        Mon, 09 Sep 2024 07:19:12 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956652e8sm6246452f8f.30.2024.09.09.07.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 07:19:11 -0700 (PDT)
Message-ID: <bd423b07-3cb4-434f-b245-381cd0ba4e58@redhat.com>
Date: Mon, 9 Sep 2024 16:19:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] KVM: TDX: Add accessors VMX VMCS helpers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-7-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-7-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> +static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
> +							 u32 field, u64 bit)	\
> +{										\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx, TDVPS_##uclass(field), 0, bit);			\
> +	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
> +		       field, bit,  err);					\

Maybe a bit large when inlined?  Maybe

	if (unlikely(err))
		tdh_vp_wr_failed(tdx, field, bit, err);

and add tdh_vp_wr_failed to tdx.c.

Paolo


