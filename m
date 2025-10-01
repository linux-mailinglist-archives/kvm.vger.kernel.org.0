Return-Path: <kvm+bounces-59370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1D3BB1BC9
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 23:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4F23B9377
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 21:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC1F30DD2E;
	Wed,  1 Oct 2025 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A/2X4Xtw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759D530DEA9
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352606; cv=none; b=nmbTFdbdZVrZMoUqAK7aGHnclTU4Rpyht45HFkauJ3tQXmNMRG/pEmGZocECxGOTP1jswtoqe8O7zA83fFJc+Pfwad3yaaRh5mqcCIAxEegxS2gVPwEwXgpDtxOr0fgU0BtAwl20rbcaaJ8UAAVrSiaX8FA2x+2V3htCnJlSrgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352606; c=relaxed/simple;
	bh=VE4AMct4NkxLw8d/dkKEm1Doer3T9sCrgHhTxsp1aaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XH1dOeOFkxB44F8/mG2KhzyR53rF87Bm50+6l+DurK789Onq0qRF0ZUEcwPwj1q9Cx9Dv41sAIVxr56nyqSmT1j3+DcDMhlgJMATjPDYQr8WiNDSNgXwBZPWXu5HcYtTIX0AGFmER2gI5U3W+N+2ctNq0nufJeOrNLnaQHfWV24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A/2X4Xtw; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27ee41e074dso2904415ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 14:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759352604; x=1759957404; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZbWysB4BLwKnNSFlp6k22DnxpWHP5NTJ3CmDeF4a/mw=;
        b=A/2X4Xtwi6JtB+9dNR5a6YFNZDYUP2nGjky6avE+f90hz81kuLHWqyQkQOSr8zm13Z
         VRTRiPXGN9EaiI55+PrSUefOn7Foc0AoUIrJ7inEEw2LbpxBpcDU1Zq/iD76giN9S4JJ
         a7xtSsPIxgF17MGSznE4YJ2o28Y+6NfWYuHXxVjboYdr+CXjsAxM/WOjM3NW1LwB0PuQ
         chspsBQHvxjkNtgT13nSEEL3wBo5fSSAdfYeMKl/E/x634yDu+wzzSdjMHXAl0T4LWdM
         ML7/nLtITfY/a7h6dwwo3o9/7nE0xYi5+Wn42sqKOEdqamFbFurcETpwRoeWi922IhOY
         T4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352604; x=1759957404;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbWysB4BLwKnNSFlp6k22DnxpWHP5NTJ3CmDeF4a/mw=;
        b=Pd4TdI1XOCL43IiJf0gxHBJdPQ+9hi2qJzV4FyeO/E7SC7OGn/q+hOG6PTcx/D/xuG
         uVKZhHS/0pdTzvXoAbapY5s4l/WHJ1Dg5yGexyK0dg2TW3yzAflFYVLRfMGIvDfgo6ou
         I6p2BWMUA9qmDy1pi9yrKUn8mSKS4NAXEPd5q1I825pS2uFGNiKlC2vJDg8KQsijKkA0
         LTzgOti0puq+m49SzzKFXnwG341RFk9MTA4+VqFWT2ARtnFwwOBPWcIIM/r0xFKo5z6h
         Aub0qcOrd1XJ9lOrQkv8nO62RjNsfiaDh/Att3AoSScnPhU3dDat0gmJfx87OiXLrVax
         8uJw==
X-Forwarded-Encrypted: i=1; AJvYcCV3duMwd03tYkUyaGlSmogj2XFX7DGfrReboQnCFrQeWEBEF72JwK5JGQh+xpZ9hXOms0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzHIow4Lda7ZkP724HWUnsDgtEewTgSO5d3yege3UQ97Bx16lH
	0X2QJYycHzHytm3nNeFVqhsGzrAh56/As2HgIGahsU8AlcrZ/sBpI2ApgaKDb/QRUXU=
X-Gm-Gg: ASbGncv43FQj5VE1892HBlD5kxKlL8UqPT8zHWmTFA9OYODUQ1iZ8kIl7e4o3eelZWT
	h7g+JGmHetcAbIuIW+adAJJfZPKYoYg0ISdJPLR4NG0vp8JAQnZB73FesGfkDfzJuQ/D72VAn4L
	OVdO15+PVRTyXXdg9+7UUzl6qll06tOcXtDlmGQ76aleMexcoVcE6H1SUWV2Vk5T3LvrLq2TfPa
	YVTcfbVTBWF8gIsm/sgtj7wbE20NvSE+zKcG0blBnNDq+BAi/WRkmeDArx0it4z/vAHQn4JHa8J
	YPPeW42ko4EBpeO/e85TPSpVCu47oxis+Ovj+mRiGj32votm8TpYzKp6x8ZU9b5LIydBE4Q3byD
	snDkkQLDy08Ny/N62gbv9fGFCNjOSBoANh3jREc3+9PoLC+nyhVJwV21auPR9
X-Google-Smtp-Source: AGHT+IEze18lci6QhXSI0pyjivHhs8/ki5NdOSJauXh39b6o1CSyAoKunE55CzTsis1nowYaOBnG0w==
X-Received: by 2002:a17:902:ce0b:b0:28e:80bc:46b4 with SMTP id d9443c01a7336-28e80bc4968mr52046075ad.55.1759352603665;
        Wed, 01 Oct 2025 14:03:23 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.157.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111a37sm5280805ad.8.2025.10.01.14.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 14:03:23 -0700 (PDT)
Message-ID: <51dc4cd9-a12c-4302-ac47-93aaf09a6406@linaro.org>
Date: Wed, 1 Oct 2025 14:03:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] system/ramblock: Move ram_block_is_pmem()
 declaration
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>
References: <20251001164456.3230-1-philmd@linaro.org>
 <20251001164456.3230-3-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20251001164456.3230-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 09:44, Philippe Mathieu-Daudé wrote:
> Move ramblock_is_pmem() along with the RAM Block API
> exposed by the "system/ramblock.h" header. Rename as
> ram_block_is_pmem() to keep API prefix consistency.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> Reviewed-by: Alex Bennée<alex.bennee@linaro.org>
> ---
>   include/system/ram_addr.h | 2 --
>   include/system/ramblock.h | 5 +++++
>   migration/ram.c           | 3 ++-
>   system/physmem.c          | 5 +++--
>   4 files changed, 10 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

