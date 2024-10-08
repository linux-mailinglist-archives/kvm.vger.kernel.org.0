Return-Path: <kvm+bounces-28089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8DC993BDE
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 505D31C246A3
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 00:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17600DF58;
	Tue,  8 Oct 2024 00:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WktKMB4t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23FB6FD5
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347533; cv=none; b=omQ+oceDZBz2flohQlYJh6MAM2ugE7IMTOJtd9vFoTDyUksezJy1EWPba1iyD6v3PEumoAO/WFog7Qquq/K6JeBFJHe5ztkysvfBNMUXMOM4/XG2/ShMzXWtaygp+Vlq6E6dQ+GPtwrIqOnvYK+AL9Kq102FoLhK8Lik3GCoPD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347533; c=relaxed/simple;
	bh=A9AMI5Ezhm9RDe/MPTYKXI8Tm5VhcV24JBDXVYsjs+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8wsfy7D0gpdwAz2Dci4z/REnZHV/AztMOPoStYN79TxoGHHMFPGNCFd3ruisKil/HzuXVVcrdBJrNoey356h365k5SYAccPXEyVf/DQs4786x3GXUBH7SBTgpgJYd/is8pj9foASw/hPFADMJbLi9Msr5Xyu9Ubf6PtOH+O37g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WktKMB4t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728347531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2t8/t87oydMOb+fbPCK5eA4VfKKGx5GRAmEejqA5qo=;
	b=WktKMB4tTgp2kLl4H6IzP5Unvr+d3DHZDQEaIf3PrRfnIbIF2KEmAqyfbGNEt++OIu7Kss
	Z2+hlMTAwXsYxGr46zWs0t4uH26zBFBxsn3Zi9Ob3p/42VwneX45mbM+OkE/TbFATVqe5z
	2M2wSFPS39hs2LaCLi/DbCmu7QNhSRs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-v-ZAh5NyPcOxq3i5OW7dNg-1; Mon, 07 Oct 2024 20:32:09 -0400
X-MC-Unique: v-ZAh5NyPcOxq3i5OW7dNg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-205425b7e27so45296125ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 17:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347528; x=1728952328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2t8/t87oydMOb+fbPCK5eA4VfKKGx5GRAmEejqA5qo=;
        b=FUpdStDusu+b0wLfOvm2YN3hi7ZWoQwxkkpMr8FP7SajvVcXRmNH8zjfH16j1uMqp5
         7Xt1unrYgTx/cnMRIuI4FdzZ/rALihq43jCqM/SOwVwAPUb2/fJ563iX5cWlPr3/5XZK
         T3Ja85INC60FhRYtIVD/EzFI9bhTCMwvECfcFrn5n01yR96nnuBW/bXWErBoGBmgfCwd
         lkSihfRjoBqecsdBpNsNXJmC3v7UP2P/65FvN4hm7j5/f5DYEopjJGcZQl3OlxxdGHJM
         3byC+IhCx8aJVgXzJ3h6MMd0MRVT2ucjfFoWFmSYFmrXbr45GuU5E/FRC6r5pMwK8I/3
         yOuw==
X-Forwarded-Encrypted: i=1; AJvYcCVFDDkHbjXbaj2nz2sCSxO+Mv8EN6lnKu5C/RrN0WDR3cDghz2/0dyXxlUqyX0p5cA+jXU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgKY3qiuVC3/8knuQpdExCmGm8ceeEsV9Q0ADuB5b0vrFI+NGB
	Pm8p8nWKBs0vtTcTKJ9Mt8Ho+K/Guz+RbFGk2p0/28ax6YElhq8ilzt/NcLma4JJqKAl6kvd+Q8
	pF1cje8rCz5mIesy5hDr6isnTRA4Q24ahXgFIdZnEiP1K8UjBrQ==
X-Received: by 2002:a17:903:1c7:b0:20b:7633:6e5 with SMTP id d9443c01a7336-20bff045264mr190222735ad.50.1728347528634;
        Mon, 07 Oct 2024 17:32:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhKzITncWA4Jo33JtZVn5xzhu6oYqOWO2GtB36kaMCjLxz5smSPbxD5lo2WdfhzKIooRXhxw==
X-Received: by 2002:a17:903:1c7:b0:20b:7633:6e5 with SMTP id d9443c01a7336-20bff045264mr190222385ad.50.1728347528325;
        Mon, 07 Oct 2024 17:32:08 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139316e8sm45047925ad.181.2024.10.07.17.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:32:07 -0700 (PDT)
Message-ID: <545dbeb2-7ee9-4f38-8340-67682a917488@redhat.com>
Date: Tue, 8 Oct 2024 10:31:58 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/11] efi: arm64: Map Device with Prot Shared
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-7-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emulated by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Reworked to use arm64_is_iomem_private() to decide whether the memory
>     needs to be decrypted or not.
> ---
>   arch/arm64/kernel/efi.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


