Return-Path: <kvm+bounces-63558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FBDC6AB97
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BCDEC4F735D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D7236CDE6;
	Tue, 18 Nov 2025 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aj361unl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQeWTXAv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC8B3502A7
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763483931; cv=none; b=jvXphxRNHYyIWkW4Yrr4ExAmoTfLoUYwANIc+OQWHwL8GmmIXVxrN1YXBVQ2edsuIgLElBuvHaHBSJyUjYZbBW6a4LXXSVZJlpQuPq9E8ussL1bSAhq7QldGpWNuAKffK2vb3nyalI1HkDcKcOEBBn2A+iRYsFT4k40QspM83VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763483931; c=relaxed/simple;
	bh=tjzFIyvBA/l1cVOfrA57AItu/RhSVfv+Cq8LcODc5Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FsH7ouZdq0tSIzLBzHlrWaA7SIoKp5NwdyuQnd+L7IHAnvs+BLLNMTqeTORFR6FNF76bxM/gCiRfx7xjLyTGcPV3fjiIhRKPsyI3b0Dl3NchSkrWVHl22bpv7D6fOVxQBsU0RYtCxs7OTjxEoTwvY9Cv4f82XlRhwhL/vWZHYV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aj361unl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQeWTXAv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763483929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CyDkLmPEbdh4EVyfKiiEMb3jmOinKJvABWPtOOckPaE=;
	b=Aj361unl225TflpmJ9ZFUZQ4YwS83w75CcY6mRNWKjbX+MXJCPqHPIizQYAV/f5DS2rk3P
	ckhvMF/C677p6uLheePo9pUcCXZTjt+FBEojdm0g4Uq1O2RuSBE/CGekFBcVnHwJ65va35
	wDhZRojB9hZZ7THHOX4DrmLbcB5vgsg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-8pDVq3zKMYiUxkQpd5HVTA-1; Tue, 18 Nov 2025 11:38:47 -0500
X-MC-Unique: 8pDVq3zKMYiUxkQpd5HVTA-1
X-Mimecast-MFC-AGG-ID: 8pDVq3zKMYiUxkQpd5HVTA_1763483926
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b739b3d8997so222881166b.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 08:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763483926; x=1764088726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CyDkLmPEbdh4EVyfKiiEMb3jmOinKJvABWPtOOckPaE=;
        b=AQeWTXAvKBWkb21/nGjzmtVO3PUTFFbGFQUoj8lCU0ElZGggTkGfAxhXzkPPjTWvRB
         PKoaldRK1xvQan3pkNqaqiO2IfD6jgQmyxj34+ugCJa0AN69HFEbYHoRsArsgsr3Sd+N
         v3qbeLXTTai8Jw6UhRRmdrEnXpsGRB0PPOIh8Y7S5d1alqHIABkBEdz117aR6kpctBS4
         y/qvmhjcFufn0TV9V2irtfr1iFVCZjRKOisD98EfQyOXG51nmUR1XebNjMfasrNF2e82
         TJXDAkUs72apo7eHkCfLrnj7NH+prk+r+z7X+ALcHKeW3g8NBVo+Hx7hG0q4JeFWYI9s
         8yFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763483926; x=1764088726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyDkLmPEbdh4EVyfKiiEMb3jmOinKJvABWPtOOckPaE=;
        b=hpku9ZJksyh7ZlfwFtqbP6mAOdcJmGmiQK5rIU6B3b9UhdLej9Zp3Z0khZDxbSGqig
         l5821JwxhUWN3XI+Sapo6CEnu/OKVb4nfbguMHCYmQ/b0MMjlloe8Sw9fSqwVz9UHLFp
         EW5bE8GjCGiJbseO49+C1MtLlpGCcJHBQnza6MCt01X1kR+CKMQlTddBRA5OjJmAhabe
         znEed4eokEHz6IY+ydcr15pHI1YS+PATGIlnERqm1Om0+/MtpM3FZvZeiM1GZBPkRwkx
         l1/Aqxnu/4Gt63yxoBIhS4pI4RZ0CoJNwEGd/5H5epF14IhuLVCEUJ7YouGaA1XAJ6Tu
         y2+A==
X-Forwarded-Encrypted: i=1; AJvYcCX6dIolgwQjLo8BnfaEnJrDAIsKC8grk3BuIIWrVfaK7tmKyiLHB0JJheuJneQu3FUieTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZk9QEU4V5Mv3LRaor18/RWdJGowSFKnngocP1+hA+BGVNvHWh
	rd0O1zmdosLNs5Vt8xE28HZaHwQP+pptEUJsaR3GyhLgO7Au7cfXUYJ3ehiIGtWu6jVZJKie5Kd
	M7Qff7MESmKKydxkH/X9YCRwsH/oCRwAkkum8GIP+1uU/bIQvjCv1dQ==
X-Gm-Gg: ASbGnctf9IoeLIvAOTuCXV9m2MO8iZdBfF6lcpmrxfw3M+asPUL2lXiYEomAQj2DwMG
	UBvDBZqfM5VskxQx3cro0+v1kYA2flWxgg9UNoW7bmIntC4VcUp1SZ/g+Sj4cuSGi4bYQx/d8lv
	A2lLgol8TV0Qp9DHRvOcQr5Zto0pRosc8LJVHGRC2hP9E3rAc0hoq/RJnLWQlsNSRng8v6n+2dS
	vF8ArnDs8WJXwEkSgkUGpAChK9K98tuKyxnt1zwYxeAfwSMwl+S9JtycKmGDp81Jo+MFmeVZi2p
	lUv7vto4zmMwmhAkuSyZUBfWJC8fsPaCLUnWP2GqI2GmKtaM1CI5YLAlvmfQC1RBJy3o3/VTHj7
	IGaImk4OkqpIrsuuoC/Rf3EqJM0SOH7PSbM2yfpkD2USQkmL6SAwkA9RnR82XjXUef2TLyBq2B3
	HaRHSlS8EPrhkAVNw=
X-Received: by 2002:a17:907:7f02:b0:b76:31e6:2ee1 with SMTP id a640c23a62f3a-b7631e62f01mr102265866b.18.1763483926305;
        Tue, 18 Nov 2025 08:38:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMe3P2lDhvef1j0kFOUzz5ARTSXWKhfn0W9nGpOzbOGXUPzG/TeDHySCcVXMMmB9qwSapzbA==
X-Received: by 2002:a17:907:7f02:b0:b76:31e6:2ee1 with SMTP id a640c23a62f3a-b7631e62f01mr102262566b.18.1763483925892;
        Tue, 18 Nov 2025 08:38:45 -0800 (PST)
Received: from [192.168.10.81] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b734fa81172sm1377513166b.15.2025.11.18.08.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 08:38:45 -0800 (PST)
Message-ID: <62dc0550-340e-4126-8368-1869609bbd68@redhat.com>
Date: Tue, 18 Nov 2025 17:38:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 fix for 6.18, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Mark Brown <broonie@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20251114113415.3217950-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251114113415.3217950-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/25 12:34, Marc Zyngier wrote:
> Paolo,
> 
> I'm back with my weekly routine of collecting patches, plugging
> another couple of regressions (the FGT one is particularly annoying).
> I hope this is the last one for this cycle, but my gut feeling is that
> we're not quite finished with it yet...
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 4af235bf645516481a82227d82d1352b9788903a:
> 
>    MAINTAINERS: Switch myself to using kernel.org address (2025-11-08 11:21:20 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.18-3
> 
> for you to fetch changes up to 85592114ffda568b507bc2b04f5e9afbe7c13b62:
> 
>    KVM: arm64: VHE: Compute fgt traps before activating them (2025-11-12 10:52:58 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.18, take #3
> 
> - Only adjust the ID registers when no irqchip has been created once
>    per VM run, instead of doing it once per vcpu, as this otherwise
>    triggers a pretty bad conbsistency check failure in the sysreg code.
> 
> - Make sure the per-vcpu Fine Grain Traps are computed before we load
>    the system registers on the HW, as we otherwise start running without
>    anything set until the first preemption of the vcpu.

Pulled, thanks.

Paolo


