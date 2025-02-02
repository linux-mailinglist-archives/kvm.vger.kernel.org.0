Return-Path: <kvm+bounces-37077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC93A24C7E
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 03:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010D5188581B
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 02:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678D51798F;
	Sun,  2 Feb 2025 02:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+Zya/uz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0A28F5
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462564; cv=none; b=o1O2PoDukOnfGKvzMo2tkgrOpmPjVM7g/A2LBpBh61l6U10sXQxDEjuLlxQTbHzkiKJeeHzjmw/I7hN9BPdCJK+R23MTmgdg00ZlLnjgrqxsr000m1GnQMC13eZmxhDfviwEjULBC0RdAl2HwmplcBO7FCi/EXyKjgwbfW9urYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462564; c=relaxed/simple;
	bh=YpG5rQ2KFsWWjOCvMTMldtm0ojXwxSh6Ny+S3WE3jww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Re9xNXteGCA++vjauNBM9kRiV/wYlPD1e7Y8xwKi++VrNujjMvr90wwnPMb2Lv/llgG/W5uh2LWfr5hBq/9VGc6wgMAVDdZrGUdViHDTVOhzi37E6FeY0li5uvaOnvyhBPnD2nOsqX0CxO4JpIOe5d1hH7r14M1jBSDuJ/VXSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+Zya/uz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaPgjrYHflaoqP5DxCw0DAPnLuPRTINmmGCdI1hjL0g=;
	b=H+Zya/uzs2s8lq440k5zOvKoWbQc08gHuhl4PyvRPEOxvTBzK/0E0J2s02LOepONmXD93P
	JMVGNZFH8d5FdhtVF7aTHMUHBCIBOj58opv9eTLvlsjeG0mJb4tHXwQAM9wF3nqdROW4DS
	Zbt/OQ3DZh0Itn9g7kNjRlXcapxVjls=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-o422lBTpMNCBAKvVFF7h8Q-1; Sat, 01 Feb 2025 21:16:00 -0500
X-MC-Unique: o422lBTpMNCBAKvVFF7h8Q-1
X-Mimecast-MFC-AGG-ID: o422lBTpMNCBAKvVFF7h8Q
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-216266cc0acso72979265ad.0
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 18:16:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462560; x=1739067360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oaPgjrYHflaoqP5DxCw0DAPnLuPRTINmmGCdI1hjL0g=;
        b=FDNRaw1QvwCcVMiPeXC7SV0PsywOEgC8uq2ClhwfiLwYr0ReF7H3CZ7S3ZEGA0HdHS
         ecCCXEciktGER17mNCCekhND3SlyLFbNRc8SL/mS6kjqxf7gnrmIKsvSF/tOc1+5o0CV
         82WFwPZGaiBxNXctB5g2WZYoMz7xFif1L1M5b/OOLFznOKqcinOzfixXrcNN7OBjNzBp
         e+rTdXY1b0UVQ7HlUFqVEjzBHtm6Rk9qYPbVCzhFYfKw9ZpliutAXE4DUh/sKz3VINYZ
         RUMl3vFv66dZ4MNzQzgqzZ7OeL3GxbL/6v9e8QxU2+EH8n4EpELKJklANEXmm9C3J/R+
         /4Fg==
X-Forwarded-Encrypted: i=1; AJvYcCUzLw5TQXxQIFYkHoH6kX2VLUKSOUUqVPmR/ULUSDuQUNQD2NTkiGDsI8nw0d4QGXBQCP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxioY4j3ar5oTsgfAJ3KQC/nFmsGTPmsrxt4GXaDLl5GdbmPAOT
	CMjZCGb9PWJt5Z0Ya83eP2D9+3R8KGqk7Tq7g+cz5NEXamowJMkZ6xCtGs9zUsECNswL/V4Xjiz
	K5fvkzho8+D4Qlt+B5yYtraAXSEcmMs9eDJHdkICKIIuVv9Cqxw==
X-Gm-Gg: ASbGncvUCfD4IzDl6HIt6fe3CU6CZa1B/t16FtjJAAiZ6D8TMixRimMlnfVaOymnqfx
	aZpPdCQUwZY6utpj5B+oTTfeCXld8Zy7+AJJvU5Cos03Wz24MrFiv0nYcWtfZLKwckPiWoLV9z4
	Tn6Dmwnnb6BFcqL/++D/KwrhGXMwtKpH7RvtVhZ3ylZUFDamWsyvMYD7aZrVmQVit4GxDN6S+29
	Uu7i+COB223St/D2lOD9/QhiwU5Vw9ijlIn4mf1j4CwewbKy7FEjXBjEmL4CARev/9NEP5hnGrU
	tk6wVw==
X-Received: by 2002:aa7:8c43:0:b0:72f:f86d:c543 with SMTP id d2e1a72fcca58-72ff86dc5cfmr9769152b3a.9.1738462559689;
        Sat, 01 Feb 2025 18:15:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwN4JpbwAKVJUbVg+/34hGwQp5HKYXpKcr/Eo2PO+gIzPd+r9+tV930pBIODwVO11f1VYIuw==
X-Received: by 2002:aa7:8c43:0:b0:72f:f86d:c543 with SMTP id d2e1a72fcca58-72ff86dc5cfmr9769126b3a.9.1738462559318;
        Sat, 01 Feb 2025 18:15:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe69ba47esm5834225b3a.96.2025.02.01.18.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:15:58 -0800 (PST)
Message-ID: <ae13e762-bd0d-4525-8919-f6b1bcfc8fee@redhat.com>
Date: Sun, 2 Feb 2025 12:15:51 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/43] arm64: Don't expose stolen time for realm guests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-26-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-26-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> It doesn't make much sense as a realm guest wouldn't want to trust the
> host. It will also need some extra work to ensure that KVM will only
> attempt to write into a shared memory region. So for now just disable
> it.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index eff1a4ec892b..134acb4ee26f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -432,7 +432,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();
>   		break;

kvm_vm_ioctl_check_extension() can be called on the file descriptor of "/dev/kvm".
'kvm' is NULL and kvm_is_realm() returns false, which is the missed corner case.

>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);

Thanks,
Gavin


