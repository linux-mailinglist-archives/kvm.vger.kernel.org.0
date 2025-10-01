Return-Path: <kvm+bounces-59372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2C6BB1C6B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 23:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB001734A3
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 21:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F4830F92C;
	Wed,  1 Oct 2025 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l4g8e8jL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E2C13C3CD
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352705; cv=none; b=bSy6n+Zta69vDyu2Lb1s8cOS4cbU0P/t0tQNpC+eHtQmSZB3FwE9FBzE7/BrVsGUx6bx/7shk08QJm/gEJiSVRrvc7/hvl4jtuFIDxLx4AhCjeEfmOrelqiZyh+QBopBefdpPF1ICPasvDZ/hhCJPX53AGns/TQrWJHTpYGv7Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352705; c=relaxed/simple;
	bh=ZShVSxhehEmrdFw/LvgEXLRo+X7kXOhXW0bU/SP0bmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFLgcYSAQF1cYS59wAOJ5zmtGtsyZiSZKg4ArNpwFxCK37IH2gVlFtiBKfcFtJ4TrUorhAzrFyy7na95RFk/mGngcDLbkAIZUF6LVKm1R+UfLIZkjsDxv8FhsnuVl5gzzCWCpPzjiSzwtuzJEVcqRlmJ4zMGhuiXu9on+5Yb2FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l4g8e8jL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2680cf68265so1844175ad.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 14:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759352702; x=1759957502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBoDt4i180w0W+W3GnmR6lat2pqax9OiVtrPjs0Bc5o=;
        b=l4g8e8jLjWyUqHi5vB2o6SaX5Do7NskPYx4qGDaeHcI8HTksNHoD2vuC8LDKix/VFe
         6NQ852Frq0ZSJNte5y5eJk5xzbk72SL/dXU6zR0NMBUBVWWIfXplbzy5/O5pVBxE7r+d
         9r8wsiCuLebF96xmlirxDZvM+TDA5I1mLzUFKIUu4Jo+ktqf8jq1sHqkp9JNc5fqFZbc
         UgTRxdgKwA1aLUsFPgkkqaYMqwuQwCKHXCgf1+8viMLczth4VQRx5fmUA47iiun2MB37
         PypY+JGUhEW9vL2oN8mHqD+D0UGjqzLkOOaI1BkeK/BQ2c/jDz7kAIEi9a+lN4yv50td
         SenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352702; x=1759957502;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBoDt4i180w0W+W3GnmR6lat2pqax9OiVtrPjs0Bc5o=;
        b=OwmHehw2QVuNJTUa9gy9nlE1KwgIXYrfuNO09LFiSdTpWitnuaf+jEHqf8Zjw0stXG
         c4Wi/OVR5mvD9xiyWlUxo/DcG2RIRM1g5pgmC80w/ey97qbkNs1CEUXKwI2X45Ps4Qi+
         dteOMjN6mYiByRzfiEIRkR2zfTwLCp9CsTcq+ZTtYmLHLN+q01CJuDsaFgBtgT+eZEBA
         cNokbDOTZAOfZp4KF6ctcfolaFL7HWle6lo9BeOibLKN8BA0DrnTBNM8h/F3y73vbgdC
         YLUurPJuuahODD8KrbKSNiS3hzx7KbMQGL+B8KoMdcjlffsNaYpnvPyJ5+1YZybSkCLB
         BVWA==
X-Forwarded-Encrypted: i=1; AJvYcCUaHKzPZ1KyVGOsx+zQpQ3bryc7k7+NbujhKCw2OqLjyhgsvx7hwLWEvwe/XJ3B+0lYyw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEvVzroiU3Yb8+K9mwAW7r8MHklKTI70BVrU3AXdfu6YeJkQzU
	oh65YjaKZtez51Cr0ALo0XyurTOQg/HYtTpe2G9NPoAvoIRu6Eoi78jHHUSy9gh3d9U=
X-Gm-Gg: ASbGncucztwECNR3r0gb5uknV7vTwKMulPunAjQSxjWBzD1lov11q7bdcle3w8VUAQk
	kRV89C2vrG43HMDWNX3vJ+gpXvQ9tqJ08Y833dJ9UD4vhr4qfL6NjWTlZgDp8OSn95guUNWFCPY
	YXldZrytVGxewimpdZg/Hnhymn06vIB0P0tr+9CMHEOMQZWoZ6/Nc7lEf2iCXb5j+Wp6zlzuc7f
	NztfzdESimmVEMOdNTsmiWVvbTAvCeGgx6RE03WFplcHmidfmK9Z9dKMgq/8Il6fj8xf9Dg9KSk
	aQNUKQVPYVrew4EIi0CuSOxmJG7PaR4TXya4wjeZJKbY7rwIjSYf9Pvoro2JNTBOFW/x7S/TBM+
	XOBowtgXQI/RliA6xw1MqxKKzwbtb1WpCvMfmXuSQgXHfxnGhHq419jxMF6uv
X-Google-Smtp-Source: AGHT+IGsFw7njXVok92E1aEOYbg0c+sleSab7rqVSZKHYCMYdqDq8eQ21cflr8t+sNqWkTiPCNcEgg==
X-Received: by 2002:a17:903:230d:b0:267:a231:34d0 with SMTP id d9443c01a7336-28e7f4440a5mr67875105ad.42.1759352702384;
        Wed, 01 Oct 2025 14:05:02 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.157.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d11191bsm5318465ad.11.2025.10.01.14.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 14:05:01 -0700 (PDT)
Message-ID: <9bb1c7ae-c852-4438-a28f-0e047dc7c4a0@linaro.org>
Date: Wed, 1 Oct 2025 14:05:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] system/ramblock: Use ram_addr_t in
 ram_block_discard_guest_memfd_range
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 David Hildenbrand <david@redhat.com>
References: <20251001164456.3230-1-philmd@linaro.org>
 <20251001164456.3230-5-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20251001164456.3230-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 09:44, Philippe Mathieu-Daudé wrote:
> Rename @start as @offset, since it express an offset within a RAMBlock.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/ramblock.h | 3 ++-
>   system/physmem.c          | 8 ++++----
>   2 files changed, 6 insertions(+), 5 deletions(-)

The patch subject is now wrong.  Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

