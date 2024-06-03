Return-Path: <kvm+bounces-18633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F458D814C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40BE42839A6
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB4A84A49;
	Mon,  3 Jun 2024 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bCmXnOXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1435FBA9
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414340; cv=none; b=hxm/Yg76bzmnJGMGycKLuKtOaGx5FVGSb9zVjsM6hb1YDy0a2S7FxEH3+vTktlcHWUHE77du0IiEQKj6Cx0d6O0SKJQNXjACLTG4vcMl6BIkBtRDoGeZoyi8cjHs3dKiDaEnJKlOf/BKZRt7FZL6T+buX0dj4k9CN1xhw/NI7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414340; c=relaxed/simple;
	bh=WmyNOPkTqGdQ7HBxCKcy9PJD2z69qr0ybzFbnaUFino=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEXe5ytssTlcXVFGAizTdtuDTY+nUcfBp/GLAxyfSHpH3FfjFu5BrPf/xGXPKRLyhGYc1HGFvZfM78idq+xuNdLZxuDNICeWJ/soyujZxWAgum35TEjyDwW6Kkghrs2nXDKe56SED43y/6U721PToQClVEQyVeffugEHdVl7sxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bCmXnOXT; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-354dfe54738so2504484f8f.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717414337; x=1718019137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zc9dnUNQyUzt2UeUZeAUDqEBBcpVb/Y5MKMH1YkpR4E=;
        b=bCmXnOXT8mTt1amzPpB+yYvYeEnW31d7FbkE5aFQbsM+ZaNqg6+VPCC2Ohk41jJxaJ
         jEu1upZZZ7yRaFWxQ9s5fp7k0r0yp7xQC5KCcrMeuXjFTRmHb1Tj0pu8QLg8eQ3S7Ual
         M5rP4GJmZxs7tsXixVFt5Rg006rxoqRyY0/i3F9mx4RnX7H8qYS91FNdlggh6ncQJ4Zg
         Ubtg2bDZexiPRbVh8mQ+THyz5tik+Z0MPYP+jdqVoZJUaEJZXcMFffkH6Yls2p//DcuM
         02qBf88xkM/Mc7totP5KFw4F1U06FYLyvn8txf877NFyEqLP4aFgj6wo/kjlKU7isZPj
         Q8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717414337; x=1718019137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zc9dnUNQyUzt2UeUZeAUDqEBBcpVb/Y5MKMH1YkpR4E=;
        b=iBrY0iWQYAb8vTAQJkl1TCEhVPw9gKttO5BgVuXbaelV5laMAFeIic00d0vXLGD85H
         P0T85/x7KXxIegWckMmR25NjYYVxEtqn+HkeAeoHVcZhF94vf4t9lKwgFF+jWTEf+1gt
         446svN06m296u0Yt4tOxH1OnODSUzp1Hsr/Lb74olhiVjBbHUClLCeGE6/snth2hkWzt
         gAL0Tsich1RX9+/2aXecSUh7Sqhoxx/Hf3PCWX5/2a7ApmJe7pcad5D89wgub7xhxC1c
         vuP7g4zg6BPe5NRaX6nsF2XZxLg/+b/if4BKewprDS0MXBT8+y5cH5T1edZMUK2y7FC8
         c9xw==
X-Forwarded-Encrypted: i=1; AJvYcCWcW2d59fwkZmok9pEQFv0MdzcuGOcdsCKkVvuRBs4HanKLD2OSXXukiXm/qTq4LtwXN9Do4aRzl0TUWBDac8JUKN4/
X-Gm-Message-State: AOJu0Yx+nimp03yhJxIfPcpgiK8XdPDTXPknkPxO5LcdFZzc8nULvnS1
	NiVrIEwZVEycpOejcvjLAgXl7BPHayig0QaF8M4ha2TUiIRCjlBZrM2Mi9gBwig=
X-Google-Smtp-Source: AGHT+IE/YpvUfIOJP5e8RV1C3I7r5Ot4Zty+YzGXVW8+OgUuDk4621Iwh9rhWh0uApX5LDLZgen26w==
X-Received: by 2002:adf:ed43:0:b0:351:d338:d9e9 with SMTP id ffacd0b85a97d-35e0f30b2c7mr6556047f8f.48.1717414336741;
        Mon, 03 Jun 2024 04:32:16 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04caea8sm8523079f8f.28.2024.06.03.04.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:32:15 -0700 (PDT)
Message-ID: <2e7de177-0bc1-4771-bd90-ee46c6ef2c33@linaro.org>
Date: Mon, 3 Jun 2024 13:32:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] hw/core: expand on the alignment of CPUState
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-2-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> Make the relationship between CPUState, ArchCPU and cpu_env a bit
> clearer in the kdoc comments.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/core/cpu.h | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


