Return-Path: <kvm+bounces-36623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC7CA1CE50
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B0F53A6999
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF52175D4F;
	Sun, 26 Jan 2025 20:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JI7QvkE8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567781487F8
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921661; cv=none; b=rEjGifvvxve5fRkcz9WddNFFqyHOu4pTFthJcW75xabE8zyBr91Z/j3DwFmAbggpIkvqHAYGA0b0QTc68YrozRv+WkYyZq+b4MFkeT7zqSe10WOTulSBwT/dQvVv4zr7B+tUypcWobXTJvgdbY9orsA+yWLcCU09kkOWbtuztuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921661; c=relaxed/simple;
	bh=bIbaoVDdLPOEpIz7+QokQ5qEvetvyfsQcZbQ4dLN5AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QM9LixIZgrPTINOKTRBURLOwz2tHrZEFbld3PKmYmAam3ugR/L4NuIiPca3Ge5AObwAXUH9UxNncqb9W8luweHL5RDZA3mDRK3N10WUfUOwjK8cnanJFGMtoF1w0RjL/QaubgvmeVRABRosxzibMjhjW2BHsg/pklzHiG+6CIss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JI7QvkE8; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-216728b1836so58990725ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737921659; x=1738526459; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTEeD0XMSKGDjb4UjeehXNP6i1pjJAUAQz3ZrUzV6BY=;
        b=JI7QvkE8S3AoSNXlJK0wSY1G9WH6lShXSmMyTmJsvxPt0BTJ7/is/GUk9kOyu4ay1D
         bff6nN3WmDSe6uoeQfDYE61qPw1vEBkF5T/vSICX0CqnY31ocj/xoRb3IRRuo7tB3/wH
         ig+SNamoaQuKKNtT+f0xXLD+zTkUGChnGk9OXPBpg6pH480tx9onW50gfKHwd2eg5kwA
         timU5vwVOzM/9fRxQk0bNYRYgje+kvyEHVtlU31dOgCN97iy4tKtYYAUIkucn+FsWkW4
         3Nk4xJIyK8CuHscgDy5tY/OCouP6WwPCOjzMFeIebS7s6gcnSwJx1CZ8aBYPtawYbfee
         EhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921659; x=1738526459;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTEeD0XMSKGDjb4UjeehXNP6i1pjJAUAQz3ZrUzV6BY=;
        b=pwGYs10ebIg9Ed0YWgwrSXmSn9UDIyHAVVoRkybs31KcpOSyqyCUBzhwaXn4oW+51B
         /eNuIPrt7O97HsCiUcaoIqWnkskjINA9zvd7k2Efpo7uHFaoEHbc/TdkrrNmQsZOs/ps
         K9wqfzzL1jpHcZEbCRC+NdX46NhZjuwWUiolXEQrUwciNW1BRG9zETsKN0b3Nv5tf4sP
         V29ITCOs/lyUVFryoBXl2s6//4zbixrbPhetIk7eI9XN11GCuljCm18zZl6DeSOqlBsm
         6Ch+mc3hQv2U1mNH6oIkSIQvUIVDU6FgI3B7rwDHYVq950+EAqCKQfQ/io79FlfmRXXS
         wt5w==
X-Forwarded-Encrypted: i=1; AJvYcCXsd6a+nU78TJNjCtMxbBGwoMlefdJNugho3F82oE2Wku88PfvHJSA0hGgLduaFGuC7dIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2t5Ge0fKH5o9ftVQCup+2vD510yeQUlK1O6XFLHQ+TITDmHTK
	An+421YHGP9QXlgVF9IosRAEFMphyyA6ZrlUPdDA5RvJSQ3oEMVnleWPjsmY3E4=
X-Gm-Gg: ASbGncsCDvFuzB2Yr5FglPTY8NUEhVqzvt/8hNK5B5R2l1g6x+N0JexTARdj/e90937
	AOk/m7g9/ZtkoNiLDL6IUPxPlVCC3ywsB5VgsCEUHIU+2P5GBHXG7/7w0fPSx0x/6C7qHfg/D6F
	LBFh2yOcaenW91fbyEpeHh+sIsi+PPYaV/PORcystYZENjF+5V0tPpa+9KH03lpVYF60eQ2fzNQ
	AXLB++3BGC9U86bScq0apTTB0YzDJ/x4tT0jyFXmv2Env7bnBxil/cswouCsRxNkfieJzcaDLOi
	AkhQLIjG4A+SdyMhS9NqIq2Ntg6pQWuwj+QKZoqMNh2Fp2c=
X-Google-Smtp-Source: AGHT+IHk4oCZBkQ3EpN55L01I/3BlN88uO4hEsi17nz9LIDtFF+nfMo3swxHhoOsy6uzlknivzwr8w==
X-Received: by 2002:a05:6a21:99aa:b0:1e0:d89e:f5cc with SMTP id adf61e73a8af0-1eb21485c9bmr55831284637.11.1737921659596;
        Sun, 26 Jan 2025 12:00:59 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac495983698sm4974713a12.55.2025.01.26.12.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:00:59 -0800 (PST)
Message-ID: <aa1564ba-b51d-4278-9368-2849266f8685@linaro.org>
Date: Sun, 26 Jan 2025 12:00:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/20] accel/tcg: Build tcg_flags helpers as common code
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-8-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> While cpu-exec.c is build for each target,tcg_flags helpers
> aren't target specific. Move them to cpu-exec-common.c to
> build them once.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/tcg/cpu-exec-common.c | 33 +++++++++++++++++++++++++++++++++
>   accel/tcg/cpu-exec.c        | 32 --------------------------------
>   2 files changed, 33 insertions(+), 32 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

