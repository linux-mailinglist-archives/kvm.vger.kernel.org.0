Return-Path: <kvm+bounces-36628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E028FA1CE78
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C9037A327F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07F41607B4;
	Sun, 26 Jan 2025 20:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vMAdmON+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE825A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923980; cv=none; b=HxAflALpAf26AZbobAK8u0x2nOH8voI7ryHEjsrrojHtMhpAgs9k1oXaWkasAHoAvezuyYy/eNB8IFd6CLK+J57ukOHik5IvhJ0wSQje2OaTqWWkpb5ceFPzHMSzrNYNdLUmZ5in1/cm6HdsEiJadqunE/uG6blCqc5XNcbtvyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923980; c=relaxed/simple;
	bh=R7EA6hcHufkaH1GJGi2GEPUj2tTDhUJZiUo7u6zHl5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KEofFJZGxQ1MwoPqVZX0XyleytPN/U4cXYcWu24I7Q7cqQfKb7hxeufwOZaX4kuj/oFFAH4h8vwcmxOEX0Z1pAuhGc0rdJxGyDuqfWa70HZdzZ6mVaW16nqNttugfX7D2OEr+93U0ojdseRklp9ENbPsRm+zBE3/4XWNDygJFeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vMAdmON+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2163dc5155fso64824855ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737923978; x=1738528778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MvjpRtAdSgDSzkYfmgpR6A/dBIEK8m+/NiOGB5xZ+o4=;
        b=vMAdmON+3TyoCiOm1GAcGXEFdufo0/J+nV/KMaSCYopBov4zpv2tZf7s1r2WOwvo98
         ClWRupv219qBRcgavi3VO+mAfWy9bcwIfAASWrkcuHg2C3lxx5bBkyFrHTofd0szh2BN
         tOEYlKoFWQ3+lND43B3niqG0E3CI2tVL/U5n9agZ9eNlilpAcP1jvl0EH5dj09r2E3FQ
         Ogu6Hgc0MGMix//W4VzYDsCua2e5pWQC4XqH0SyfjrLUet6LCA+JXy6dEbBucS8s4EKc
         zVWVunEbfZNJfh9vf1YmcmB2AQhgCA47ZgmaCGjiz6JfONnN/+NXBaAtX4JwnMpbE22p
         bQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923978; x=1738528778;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MvjpRtAdSgDSzkYfmgpR6A/dBIEK8m+/NiOGB5xZ+o4=;
        b=RSzNl4xmOoiJ7gObIQMCeaEJTSS8CkVF7BS64Wy+u/CIB912yBWWiRcG8XatomvoDU
         bkNBhrR8ECi2ubAoNCpzmKxTu5Whb6oPQD++YjSW7Ukr+n/NGEB0rtd78m7nNeoWXKQL
         2v0lYZajM7/xRXSAXEr9psNf6Q7uT+jd1mL6jVWZYNB5Hkrbi+RQin0HGebCK5FfpqPr
         c3QtMSuHlJKG4X0Zonrc66WPVJxUA8h0DrHO3wxFG3VR47frWm3/5HdYsyH+iF3oL+Ov
         DvX3wkNBYjUZBgaDKqVWIZ7yd7u8qEEdPzRa3hcdwPcM9FE7byfXLyZmhZYCxVJD7W5j
         SO0g==
X-Forwarded-Encrypted: i=1; AJvYcCU1EicPB7rh4w66cNZTQMmUJ4vdsDmLSexSFyK5D2XqTQOz6V3lZDbwkjwpvz2m0tHo17c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxofIAYZ/O+FpArScd+Mph9bTObXTL32x8sP4kC1CWznIhEwwQ2
	BYdaZp9ch35vTwcN56spX7LRuVr6YEy5627qmjpTGgY2Dmq41cODTVyjcrQtOag=
X-Gm-Gg: ASbGncsWrx9xQBRBhUgIpPRNk4AgOLveu5x5tOaf3I+ZfyV/zgRbT5/QeR7VOs5Ako5
	9fc4IGrDoIlgZZbCxgpxu9K6ql0UNmALoYQbJUnNibXtM18bnx5jpprzlRIetd/4A4A0dZIi1K7
	FOKRGTt5O2dywbLnI7hgc1qX6FE4wrU1IVc1mvBNfARVTknGTDUyc/uzXIyXYf006FiTb556JLi
	+5GKKpMyLQRWUSbXCt/LBA/lUGSNB7yQyUYqm+NI5AZYgkunLMd12m4QBn4BNuKlTuWh4NqIrbA
	45FGS86Zl8u7J8s5lP5Iy+P+2VTdkeboAfPMxB4l41gDtk0=
X-Google-Smtp-Source: AGHT+IGm+ocgYvvkVWsUvSKMByg6rdOolrkUz0sM7TYcNoHM9kXNHQjPzT7fvMCLNswi1NUAED96dg==
X-Received: by 2002:a05:6a20:394b:b0:1e5:a0d8:5a33 with SMTP id adf61e73a8af0-1eb21480ef0mr65256986637.18.1737923977749;
        Sun, 26 Jan 2025 12:39:37 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac48f897f8dsm4913213a12.22.2025.01.26.12.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:39:37 -0800 (PST)
Message-ID: <25ab2464-7878-4ade-89b5-1691f70736fc@linaro.org>
Date: Sun, 26 Jan 2025 12:39:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/20] accel: Rename 'hw/core/accel-cpu.h' ->
 'accel/accel-cpu-target.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-12-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> AccelCPUClass is for accelerator to initialize target specific
> features of a vCPU. Not really related to hardware emulation,
> rename "hw/core/accel-cpu.h" as "accel/accel-cpu-target.h"
> (using the explicit -target suffix).
> 
> More importantly, target specific header often access the
> target specific definitions which are in each target/FOO/cpu.h
> header, usually included generically as "cpu.h" relative to
> target/FOO/. However, there is already a "cpu.h" in hw/core/
> which takes precedence. This change allows "accel-cpu-target.h"
> to include a target "cpu.h".
> 
> Mechanical change doing:
> 
>   $  git mv include/hw/core/accel-cpu.h \
>             include/accel/accel-cpu-target.h
>   $  sed -i -e 's,hw/core/accel-cpu.h,accel/accel-cpu-target.h,' \
>     $(git grep -l hw/core/accel-cpu.h)
> 
> and renaming header guard 'ACCEL_CPU_TARGET_H'.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   MAINTAINERS                                               | 2 +-
>   include/{hw/core/accel-cpu.h => accel/accel-cpu-target.h} | 4 ++--
>   accel/accel-target.c                                      | 2 +-
>   cpu-target.c                                              | 2 +-
>   target/i386/hvf/hvf-cpu.c                                 | 2 +-
>   target/i386/kvm/kvm-cpu.c                                 | 2 +-
>   target/i386/tcg/tcg-cpu.c                                 | 2 +-
>   target/ppc/kvm.c                                          | 2 +-
>   target/riscv/kvm/kvm-cpu.c                                | 2 +-
>   target/riscv/tcg/tcg-cpu.c                                | 2 +-
>   10 files changed, 11 insertions(+), 11 deletions(-)
>   rename include/{hw/core/accel-cpu.h => accel/accel-cpu-target.h} (95%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

