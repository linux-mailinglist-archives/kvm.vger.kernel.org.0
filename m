Return-Path: <kvm+bounces-39968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1C8A4D31A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6685D3AE71D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576D81F4735;
	Tue,  4 Mar 2025 05:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXvsJvkr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F81F419B
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066960; cv=none; b=k1ef6/43chUhN76aJ3kHEjPZNH6VYCOQ8wQ/d7uH1L37jP78QTBsQUtEfpgXWhBDUGLs9rLXdqbQqtFvsv39m7Prj6dIVvhtiN0ZK7aiw5FDEghdxgIGqHDp6hGXx43siJHyhnZUe3vKprphUKkmHKUI+Gz+EUNGwlgjDnYV8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066960; c=relaxed/simple;
	bh=NDiYP2H5hYhH1uYD5YWszI9pFiidjNwL9HaA1erSaWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMNnysTJzrKOUWzeS+rx3n7j7raOFaFgfUx+w2cVA2+QtIfTUYutv0b4yFASsFG0cUBkdwxT61vvV41HN3gQKFIRdDWdOUSEGpKgacwoV3xlAwewb8nZNmg9At8IKNkxmuqllu8Mg2zF22veeZeY+Ur78fbV3PjxyKg6y5eg9GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FXvsJvkr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hbTXak4fZZgmEd0OOFQqdTCiZzdYnXYZunDKpr8m1kE=;
	b=FXvsJvkr8vTg/NGV8bmPDHKz8/TPxVpu+VolLGnlx5NscmMgk/8nPzbnVvNrKBfZJKFRqr
	rKreK7k4S4/DvVwT9TKxrKhAtJiSrlm9EcWnbn8/uRUIFau/+OCCUl8Qsd+P+DozXxMbHX
	rE/Szd3tgNBHF+m7PuCR5r+u+i/gb44=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-bFtFb2-gNui8HAiNZvlHcw-1; Tue, 04 Mar 2025 00:42:20 -0500
X-MC-Unique: bFtFb2-gNui8HAiNZvlHcw-1
X-Mimecast-MFC-AGG-ID: bFtFb2-gNui8HAiNZvlHcw_1741066940
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2feda472a38so4829351a91.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066939; x=1741671739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbTXak4fZZgmEd0OOFQqdTCiZzdYnXYZunDKpr8m1kE=;
        b=xVHLw6kd3z7jlodAhqIgzzaX04ktxj5aKz8Zy3GkdEVQtKwiKgzWQ7C5gQcqR2Cmwg
         EsgxdaVWWZm8804apjm07V4gzUdXz6fTjqaF1X+AWkkldld4iuf7xob/E9EcBsghXjKE
         ACl63SpOa/MtZcWJpe/PF4L0U6t9tbiL7RKnluHEqgnadq96ajDoNkC95gw1ik3Ygqgh
         QaCeDmLGiJQd/lmi3GHV4YIz/y2rwCtA8CEb4kXENUUQzurqxBJHI/MLArONeDmOOT0s
         /UaSq/6gLcvJunXMh5ZcjJJvi9OX07JDdomuZBeZbcOxT6aonPB237GqRxe7d1G0x8tK
         YHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOIiF4vKsFdMTYr9BwfZPceQRNm//ubKPIUsORrKbWzFDmlmSZAS7SLaKtZ1b5B6OHTrk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4FXvBTqqDVxokHzTzISfnIPHr1XNuKM/0/0DWDqXs8iFHini8
	z2Sp/XEWNLZlQ9yjyJdZwGGZdUdPtdiXBJxK+mE29lLKlXFc3V2IcdV3hIEFMuyllBBP1XkHStW
	xF9xwiwicc0jgKMMnd0YfTCX3oj5s0yIXu9QfIatY3arze5LSLhpYpNkagA==
X-Gm-Gg: ASbGncvbyECwMyERys1vmsCOFNGOzKD7cIlYKAA6VIzcw2Z4ZXy/Q8kylfc2chndgnw
	QizK5M6+Kpn+LfCVZDEDIBStyFhLcBL6PMOQjWzxvSVmXK45PxxpGRRI9tvLGlkMQgGOaoSj0Tt
	8b1CU74G1sflFqlW2+HtvCHLO+c2trdw47BQkb03IHGLbpWrSFSoOg7I1vF+GDTmAVFGJlenJxm
	7foFpS9gsnM6/jvMdrKQByamC1q3mL5RNS1IpNkgWwpfmcb9Qp063vzHvYn3KDIPTq3Wsmzii5m
	cXJ3HJwYbNNrl6FaPw==
X-Received: by 2002:a05:6a20:c781:b0:1ee:e8c4:e1b6 with SMTP id adf61e73a8af0-1f2f4e01578mr26530457637.33.1741066939190;
        Mon, 03 Mar 2025 21:42:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHurZweDDClFEM+EDFVGKyToeXZSnslvrdiIY31gYPFZM1mfyMjnp3vImA6Ky+0fKgY2QYszg==
X-Received: by 2002:a05:6a20:c781:b0:1ee:e8c4:e1b6 with SMTP id adf61e73a8af0-1f2f4e01578mr26530433637.33.1741066938923;
        Mon, 03 Mar 2025 21:42:18 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af075209ba3sm5804806a12.29.2025.03.03.21.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:42:18 -0800 (PST)
Message-ID: <ecf15da0-49ff-4cc3-9e4e-5c47f79acc06@redhat.com>
Date: Tue, 4 Mar 2025 15:42:10 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/45] arm64: Don't expose stolen time for realm guests
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-27-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-27-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
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

With Documentation/virt/kvm/api.rst updated:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a6718dec00c9..79d541c95bfb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -403,7 +403,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();
>   		break;
>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);


