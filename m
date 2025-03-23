Return-Path: <kvm+bounces-41766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BECF9A6D0C2
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:27:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2E3A188D360
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690A819E83E;
	Sun, 23 Mar 2025 19:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SRskFxRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA7D1946C7
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758017; cv=none; b=hF6S3mbVHHpDuzLvBOXTYmwZFq85Bb7LO97B6Bas+0nGxeOOez99Fi+bwWlsQ8j6q5pMZUqxd1QNEVjp8t/xUUvFA9Rmtylb/ydP+gn+71ULITM0Mb9dEtkRbeZQ9Xd8GldI0ERu3RDSUKklJuV2+MjEfaT8bGW2uCtgUmovOlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758017; c=relaxed/simple;
	bh=spS7unad/QH8Smdp1l17hM0oP8c3PurLwKqOaZw+5Bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HQ9/i/GZBC/OKtzXzibZz4utzN/w0CHw7tk0aBWk+mzMOkIpeIJF7yu2+nZEy8qGGl9AibtRHal42blCzHOe7wptcrKX8fPYHEZAOaqndcwDYaWsy8r1g8NXZQmNB2pdE5EegnDhUn2Ed5A6VTcIMjIxJsib/gcKK6MQILJ/Mig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SRskFxRR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2239c066347so80397845ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758015; x=1743362815; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nf4+rA43Kt9Mv7AOyCCKgBarZrgUwABieRc07zFXEno=;
        b=SRskFxRRYOf2h0k/8Df2m9etgBXBSqavcJX7yF/klIEc2o40oMekkjUAzzXQijgkLe
         Wn5rJ7DNvnRsEQ4DRWcDkl1cths61kL/JQqxwfJWp5QyBvxPl099JC8PIzHsEqNuixDg
         VwuBe2X3cKXNO/1tTazCUJJGu7e6gk5TMtXAQ40zJe+4p3Z1qPL7TCJURGkPzYoWBWb2
         4bqldNEaImd7xEte8tyRVoPRwjaJcq28WhbjHpoh6XDYqgu7ROmNAcRqN7BaEEwOd2E/
         8Dv05gL47Hj5vbGX2VdzgBcwO3QZmGD+L1mn6arDlg104nEK0rLHwOrMkirV1/ol0WqF
         VrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758015; x=1743362815;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nf4+rA43Kt9Mv7AOyCCKgBarZrgUwABieRc07zFXEno=;
        b=rrty2tu7EqrTjpuMJ6LAhCRzs5s6/gSut7/+HK7iQM2KVYb4r2O+uWq0D3SmkDViup
         2qcb+1/wAmp6jmZNhbKaOFwfOtnjpnu7ji4lNNxG9Mkb5ky35Kf0m7WnV/ku9SY8Jzq8
         rfTxz+9Y6LmCYMCvhvEZHgf3ZJklBgEwUGtV7cORz0R9r6WlGeHJSpY9L0XVC4/YZYfD
         CszTcRjURpac6VKXBGNxvgJcMRcqzxntU015f6GfCwDe7yEFhqDOVCJL+Lk/4pe4zuZn
         izN0cNUlqD8wzdmz/KdIjBeowxwbAWJ8CBgy4x8z6wIPNacXoHvdix4BMEqQC/xwXkGp
         zePg==
X-Gm-Message-State: AOJu0YyohMf5AsHtlvmGeCsp+PZlmtQK7tz6AjinQ5FUxy97xlgDna/f
	UVU67i+udf5pgXvzs+ezMHbSM6VlfaZWEfvbm2p2Dwsc4Y88X2T2TzcXRcMEsuc=
X-Gm-Gg: ASbGnctV+1aR9Lk7ycnC2gZgGQc2XAhIYYywEUtrmSIKQmQrJLq5VhjxZUnJPNQ8Q+E
	e8TWFy6hBGNkPjZibOZe8le8zaOalxgu8KQeFhsUhArJxrt01I/PNi4l0f9cvRQxmmzVxzGt5Ak
	z7RLtcQMg+mVE6vA4nboeeX4sv5MTnssst2GLIvYuoEgoMPj1l7pvNmgZmti/UV4iweFTeH6JTw
	foL8JdgcuTphrcgaFEWysI3n1xzpD9p7mgcGYI844MJl6ZrhOD2wLc/q8z9hcproNyqi2cRlawn
	s6QlWTj1mgZ21tIbSRjNzS+bdGyEJL0v4Tw+oQUEASzbInkkox7exnp9W7jVcOKrw8hA8fBj2ip
	i98iFTYOG
X-Google-Smtp-Source: AGHT+IHRgCNveshKuDJuoCV+0B+dzaT9aXiMJpElP8KJKw7QemBWMjAKApy0XLHS8tcZ5GFOpDaplA==
X-Received: by 2002:a17:90b:4f84:b0:2ee:a583:e616 with SMTP id 98e67ed59e1d1-3030fe7e2b7mr15835517a91.9.1742758015264;
        Sun, 23 Mar 2025 12:26:55 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f5d71b5sm6331942a91.18.2025.03.23.12.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:26:54 -0700 (PDT)
Message-ID: <61f1bc3a-abcd-4cf5-9d56-1132c8fc3ba7@linaro.org>
Date: Sun, 23 Mar 2025 12:26:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/30] exec/cpu-all: remove BSWAP_NEEDED
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-2-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> This identifier is poisoned, so it can't be used from common code
> anyway. We replace all occurrences with its definition directly.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h    | 12 ------------
>   linux-user/syscall_defs.h |  2 +-
>   bsd-user/elfload.c        |  6 +++---
>   hw/ppc/mac_newworld.c     |  4 +---
>   hw/ppc/mac_oldworld.c     |  4 +---
>   hw/sparc/sun4m.c          |  6 +-----
>   hw/sparc64/sun4u.c        |  6 +-----
>   linux-user/elfload.c      |  8 ++++----
>   8 files changed, 12 insertions(+), 36 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

