Return-Path: <kvm+bounces-41686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDF1A6C024
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABE9716A50E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF4922B5A5;
	Fri, 21 Mar 2025 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qDgnrbE6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062161EBA1E
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575107; cv=none; b=kem0UMqJfFZfibIQ1aZLTuA/t6Dml1+modC6VGeYk6i9QxE+CxcHSHHL4zsDfLd7enUDvJJI0k4cqBRycjCU42+7MI/lRl5yOUmQnyfvrJgFhadSjEFdKEXAh1hfdfeaHGC3JNFeFqFmti48oG9QJUng7vDD4H6hAspPy6ZcZW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575107; c=relaxed/simple;
	bh=t8o+pDroJzutf1wCqZ+xYT+SqZ0sP5ebkAElyo8AkrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GG12hP9ve+U4L4mNFJaCLrrEDd1KDxoJ1J809yTrYbT5diYSoYCtI+/5D4VVcE58BYZCxfPznrNfhbhR/pY9/hbBQCx+I7Lu5sQoXwEuO4V/j09YPTUoVYR+PPz5PeGx7+/SeaAmdbqg49jjLcL9zaRKaredx/SVQWXecRmwoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qDgnrbE6; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff6a98c638so4755301a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 09:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742575105; x=1743179905; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Po+8A7oIRxr9NXsNwzfrLWOQZJ6V+4VHyvpZcXsIsSY=;
        b=qDgnrbE6ND5k8kDeEnuhBK5bLK0H8uKtiKc8UEOqAxz1WmvE2LrU52c4W3jzIkWAsU
         YENZmEzZddl9L4LGPKP3rA97++rTI1RVP8v5gaQ973MYL/IyHxNda65zT1KQXo4hz57D
         Gq4Fewpypk+aLR+yA+MKXQmTBBmWWtBzXQ0nzjIeTF6akUjk+yfrrSb0UNd3caOmSDbr
         sOirchni+gQ9k9pR/73L5NPqfIsQSp9R5XnMPh8TG2QfEomVWvxUEgWdhkkjoZhKYAR0
         o8GcLJr0JVdbzbplzDRylt08FEvzymoQzzi4vrFNgHr/uDH3CafHt/bL6iQNToQ1mPmn
         yTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575105; x=1743179905;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Po+8A7oIRxr9NXsNwzfrLWOQZJ6V+4VHyvpZcXsIsSY=;
        b=td3/6k4kG9zdYJGEgRynVPcRdxvxqXUgTfR3JNtcBF/BhMpdhuGhfO7/0TqptSN4Tn
         vM8Pevp3fKHkYxplf5Z7Y/XeX3kcrZnfszp7TZtY8xlGvmzRw5Og03VSarxgKBhloy1y
         PsxkZsZm/ZSa0IwBiKoOAf/u9SujgyTQN29jZti55VB0MrjG6O7nLqIZXUOtmyEr9krz
         3ZrFZrcKRJ5iRamxxWT1zhQ2WMmDvYU4MW/tAnrddE2xtLmZUUofPGS2NnysSHYj4Aff
         Zio/0XxbRoi5lRINVcOW6eRzT3OR//+IU0Wc27xR3HMMSeyk70jUS0XqA7RRTNCeAVkp
         ZCpg==
X-Gm-Message-State: AOJu0YwZPNUW9mCx2WQX5bfi3ecc+GHtQ/P2n5iaXyWOF8Vgwk2xeksP
	0JdrGTm5cZnudVtGXRl8Zg5lXK6sgSy5lGdMyQtPE15oajZ3Yszb4uAJf3quwF4=
X-Gm-Gg: ASbGncvMrPWUQ31TKbnEEvkaJnGnoS9YANtu8+jqvGIS4Ij/T18Ruek6mV5ZDFi2EIh
	eRdFxRCBDMwDHPqtEI/ntQGz6qaa1COYMekJ1AlzxNLYjdCK7dhOzIdg75zCrQkKaK9iKD7CeTy
	FZBKCJnj/cjZnabz1uP6hFryQMecgLH2SYfMYLjp3Hxu6897TVZ6Z+8TatkQQJqgKayRafUMKq0
	bPTfEN8JbZ/Mr+PK+rt/ynmONsT0z6TKa/+YON+MHi10GdxT2xnyCbc1g1R1iW1S9rATiO80yCV
	B2JhYMNv4WD5s3imw/K6dcqAKMNrAIH1owEx4Xne7/VxaWbBIK9LY4/XbdHHUppv7WtKossawcP
	PbVVRLQ/Dj8L393j8+40=
X-Google-Smtp-Source: AGHT+IHD+Sw1ed5DoL405gur8EOIIjes7eESLfyzMPwXXFmmPARwBWAqgfR5qqpOR1G7ogBZyIjHAg==
X-Received: by 2002:a17:90b:4c4a:b0:2f4:4003:f3ea with SMTP id 98e67ed59e1d1-3030ff21efdmr7057846a91.33.1742575105064;
        Fri, 21 Mar 2025 09:38:25 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf61a44csm6295878a91.37.2025.03.21.09.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 09:38:24 -0700 (PDT)
Message-ID: <be360a66-fcb6-401b-911c-871601e7c726@linaro.org>
Date: Fri, 21 Mar 2025 09:38:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/30] exec/cpu-all: remove exec/cpu-interrupt include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-9-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-9-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h  | 1 -
>   target/alpha/cpu.h      | 1 +
>   target/arm/cpu.h        | 1 +
>   target/avr/cpu.h        | 1 +
>   target/hppa/cpu.h       | 1 +
>   target/i386/cpu.h       | 1 +
>   target/loongarch/cpu.h  | 1 +
>   target/m68k/cpu.h       | 1 +
>   target/microblaze/cpu.h | 1 +
>   target/mips/cpu.h       | 1 +
>   target/openrisc/cpu.h   | 1 +
>   target/ppc/cpu.h        | 1 +
>   target/riscv/cpu.h      | 1 +
>   target/rx/cpu.h         | 1 +
>   target/s390x/cpu.h      | 1 +
>   target/sh4/cpu.h        | 1 +
>   target/sparc/cpu.h      | 1 +
>   target/xtensa/cpu.h     | 1 +
>   accel/tcg/cpu-exec.c    | 1 +
>   hw/alpha/typhoon.c      | 1 +
>   hw/m68k/next-cube.c     | 1 +
>   hw/ppc/ppc.c            | 1 +
>   hw/xtensa/pic_cpu.c     | 1 +
>   23 files changed, 22 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

