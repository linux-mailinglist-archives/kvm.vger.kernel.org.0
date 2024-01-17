Return-Path: <kvm+bounces-6384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 875C3830275
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 10:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B6DD1C22736
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF1414271;
	Wed, 17 Jan 2024 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ML4F4cbz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0A14264
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705484401; cv=none; b=e5NUFYgUhKC978C5imGtoVCRiMBRDXFWGUW0C7gXhd5Cs3DRXpwASAQDdRGpWFC3YqQVuoe/4PaUe1dJnxYW1LZuikiJCKm1ptWiDCv0AGk35+5FdzIAMUoICoBG+Zbp3jaExxkozEfU21ADoCso3DT6v7mRkB3UVTagZ6mP82Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705484401; c=relaxed/simple;
	bh=fj2HpoInJ1LDcTmb47YOWZDGESUO6+XO9QHljF3gn84=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=Ovcyp1JSpLW3RLri/2QjIckLDAIq+1msc4oHq/7HdWUv7pqgDmrw8O8+wyFtS0ahPn2iEEfMdCdMJJ8Xd9fGo8N/fBuWARxevItQePI3GF8/p5XfIbJSI0kWbACCBP2a3WPgg1wzuODJ8t063gxwxR65KliNJjbfK8Ew6IzL4D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ML4F4cbz; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e7065b7bdso37095255e9.3
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 01:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705484398; x=1706089198; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xmYDWnl8dTqsrDQj2YhUBjlV25jNbeQ7ObR2DibyeoA=;
        b=ML4F4cbzCSrATOpu0AF2zj8I4u2Ic+30hCngDJv9zIZUpA/IJINYqzVf561dHpZ6RP
         SRtJ/V62Kq/HJtD7b2YnlNjHdqzo0vV1X+henAQJpxGyk66eCHQUmu5up39FnNfINj5u
         cixg9uryxEafY16zKDNcIZzD63g+kLEzEpG2A8FRcajPIr1UDxousw84DFmL+hx6pVrk
         nrsgNTFCqjtNFfxO0kh162ZjovMVdg4VX9qkHlTkvr+klh618/SMC/XmwRxCRmAbWPMD
         gRX56gvDvhbj7ONflmO555PQFjmyba45a881FvmxjHtUraneO/70R9zgPii9wRInOw4B
         2NzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705484398; x=1706089198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xmYDWnl8dTqsrDQj2YhUBjlV25jNbeQ7ObR2DibyeoA=;
        b=GWjz8Jn6HcKoDjlRpqN2oL/GDSzyAQAhxm0hV/WJO8c4LVg6sQq+nRGY8UEupYRgmh
         6bSVXWR/V6K5xriRmAPlI+0L/mFiFr75mPR/96XKZy8Dy8vTAXBnNktxb7aJ/g8Y6r/1
         7AhA/2lNNEBl+Pt+blARyArr5Y3TIVSosNNYaStciPBMnTSqbgirp6ZnczzAxObuE/0U
         O96mepyVjO9lNxhapBYEq1Oqxm3I3oOfGGlxIU/Npyw87TZeszGew7Gdrfkkiz/wx1f2
         6A58MeZN07JSMb/GBHBdMnPNwdTFpTFCtI34tbuVDYKA/tpYpxXsPA/wxnO2XOlcl9CW
         Nfcg==
X-Gm-Message-State: AOJu0Yw+BtpGuagkka1fNSHYYao9wMbonZlBmVcty/BJmYVzXthkP2s5
	j3Szl8odlsvtfcd7l881dXdZZIzgtVs1mQ==
X-Google-Smtp-Source: AGHT+IFBrcEeQrmmn7TjIuwnPOuNkld5cdjzyHfmIIbVrYYCuAqRVRKzyKECnEpnS/yA6LjWMHmnzQ==
X-Received: by 2002:a05:600c:3799:b0:40e:6812:2bd0 with SMTP id o25-20020a05600c379900b0040e68122bd0mr2619023wmr.267.1705484398269;
        Wed, 17 Jan 2024 01:39:58 -0800 (PST)
Received: from [192.168.69.100] ([176.176.156.199])
        by smtp.gmail.com with ESMTPSA id k20-20020a05600c1c9400b0040e54f15d3dsm25655095wms.31.2024.01.17.01.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 01:39:57 -0800 (PST)
Message-ID: <bd2e30cd-4723-4b7d-b12e-c4b329aed18b@linaro.org>
Date: Wed, 17 Jan 2024 10:39:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, kvm@vger.kernel.org
References: <20231129205037.16849-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231129205037.16849-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/11/23 21:50, Philippe Mathieu-Daudé wrote:
> 'can_do_io' is specific to TCG. Having it set in non-TCG
> code is confusing, so remove it from QTest / HVF / KVM.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/dummy-cpus.c        | 1 -
>   accel/hvf/hvf-accel-ops.c | 1 -
>   accel/kvm/kvm-accel-ops.c | 1 -
>   3 files changed, 3 deletions(-)

Patch queued.

