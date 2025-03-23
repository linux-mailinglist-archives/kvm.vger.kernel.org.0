Return-Path: <kvm+bounces-41776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CECCA6D0ED
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AACA716EC61
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EAE1A5B9A;
	Sun, 23 Mar 2025 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QJELwUII"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C4D1A265E
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759463; cv=none; b=li3l1sNTyWs2yDSE15hUHkkuERieGQkZNEuZunMBS5CnBqKrgvo2JO3dgnMHMk43qZSItyM9fEfajVwaB3RCOJ+IeOHcn3aeoZxgxQE53tSX6zo9VoZOUqB8tdrcV9RHt8COrzXlFChMDEGOvSA/FdDEuAPUHwUWlo41qthtNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759463; c=relaxed/simple;
	bh=0ndbU5O5ir6R+c7BGw1NGKkIRP/wWZbMx+PnjPtUq7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/ye4Yfx5+PR/Y1GJ6lQkm/SBZYm6HKZUST5cjXDtSkGFhMP9cGdzKXXIjZ5k+1ICD5kZA6YEvi24CxvBMBeD4A0ZuznHYFvUWEWXeXAvW5kn/kjqVf8TCOfelgGKw+PfIsmFO3sBp29XkmtqWwU3mM1jN9HnH5pv+IXfRJmuZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QJELwUII; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff6cf448b8so8425745a91.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759461; x=1743364261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cACQA11NUfjHlZKukc9yFXklQ9Z28sUCMFdeYvHLg8=;
        b=QJELwUIIvgCjMmHF4+i2hxtiMat3SyalaKzandJfN95LlTev7ZP8jPRgGUG/630/BU
         7HHcyVI+Jy9VypQDzeC9zpK3+otj/0tuYzn6R3iX6ir4+uMha+ay1rDU/m6ft635P+AL
         RncqTyPm68CK05fd/3DGNZ8qy0ovXGPfSoe/ErZMxZpEuO06Xj98Fv08KAEFTQnAH4XW
         d9gloshHioGbPrmoPbJWaChHdl77ALaP92pf8VVC6jzKGW+cI0DZVMSGq7E3MlsIz80o
         kYZu+YXOrT9Iysu18d35daQKXT/dXgI//xr8wRALY5cdjViRP/+IlMwKXHOzb1hxXXf4
         zs4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759461; x=1743364261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cACQA11NUfjHlZKukc9yFXklQ9Z28sUCMFdeYvHLg8=;
        b=AwihBQHY8J4zMmBg9TeZvDwuhWpz4XZ5biw6hpn5q62QOD/Cjp1XUPqnuHpa5sTtSE
         snxO7EwxrZT2Y2S9AMmTIZC70D1rQVESpWkwS6Yet4b2BFX8gKwGMA40Lu2pB0ACx77H
         0Fi4QIa52Kx3AkMz7nu1tacovbbwBxno61+65YZgBw0m0mKaBXTPv+QfdNyBUAYjVsri
         70zxXQMlGPK6p2EpIeFQRnXlDsj2GkobJDQK56GhZtvUXR8wJhpI9IuETIrebxWFNBCQ
         aIlPs3mQWiTwDKfkikMBBsYzVOoNmp6OxiCIrCOGfF7Fsh3VTpIpVh6mJgOScmGJx2RV
         59wg==
X-Gm-Message-State: AOJu0YzFXQmUV37Jmpfa2VrPllKQ/j6d+ug5MJsckSTD8YLDrrWOeEnf
	hPX1UTne4KwZOnMiWuziHGcqoSwVh+sVOlApM5Njxu7NSgw8KO/lXJKQx+A+Ntk=
X-Gm-Gg: ASbGncvNXQUCvt64ylARLx51XBEmmUuICIFjKzFi+9pYkyBlfC9PiREhyYUvLs3bc0I
	djCnUiUA2I/lAtjQztuZkaU+uCsUMHA1bjKOrauAUO8lBkYHEkQdON2/uM0gpAkPx2dQRtiFa9O
	pPLs5RL5qJMS/CMMi7mc2Ox9g8yZFRlhL/Ro4GEnDpZW/dwNmpt0BYFBfrFRpF3mQOi6XGVG3C2
	5X7g7LovCmL73LkzfMolH8rfhk6tWr69OVcX8Wj6DKUOQXb1dGZa9ZrVLQ42TTe6nnh23dDXCc4
	2FKVIXhyIv4Y9gV5IpcUGTZXdzGJkFmt3KbK9boWz0sttXou9V4qP5mVzra0UDaw3Iv4/1JxyCY
	Lz2QhKAaH
X-Google-Smtp-Source: AGHT+IF9tILNR/1q7pcFaBhzR1mDJV3PWl9v+xc/N3wMTWCmiaYVNWI+gppKnB8IdDZBX6M6C/fgGw==
X-Received: by 2002:a17:90b:4fcc:b0:2fe:ba82:ca5 with SMTP id 98e67ed59e1d1-3030fe9c927mr19623821a91.11.1742759461401;
        Sun, 23 Mar 2025 12:51:01 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f5d8287sm6390252a91.15.2025.03.23.12.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:51:01 -0700 (PDT)
Message-ID: <c65629bf-dcd0-463e-8d72-5f8e5fba2f63@linaro.org>
Date: Sun, 23 Mar 2025 12:50:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 29/30] hw/arm/xlnx-versal: prepare compilation unit to
 be common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-30-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-30-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:30, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/arm/xlnx-versal.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
> index 278545a3f7b..f0b383b29ee 100644
> --- a/hw/arm/xlnx-versal.c
> +++ b/hw/arm/xlnx-versal.c
> @@ -17,9 +17,7 @@
>   #include "hw/sysbus.h"
>   #include "net/net.h"
>   #include "system/system.h"
> -#include "system/kvm.h"
>   #include "hw/arm/boot.h"
> -#include "kvm_arm.h"
>   #include "hw/misc/unimp.h"
>   #include "hw/arm/xlnx-versal.h"
>   #include "qemu/log.h"

Likewise, re unused headers.
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

