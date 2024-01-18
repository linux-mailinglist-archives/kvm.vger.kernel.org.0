Return-Path: <kvm+bounces-6452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E38F0832042
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84615B21C22
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05332E84F;
	Thu, 18 Jan 2024 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YUKdRXIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CA02E836
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608525; cv=none; b=hqhMZ9UqmhLyuSvxA8EPUPe8uxZrIGXJlP6pfHuc/Ga8GuDkYUpF4bI8OCjxErMial7xjPYJAPhMH2W0NC+4Sfea3hSc4l7STDhdUAnW/bF8k7PFI/ehAmlKRERlqH+sLhixd9t0fqOuuAKCIj62DYGZCcRASvCdJzaMZVdYKHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608525; c=relaxed/simple;
	bh=FjU+Eph1v4BZ46FTlv0ardZL/2xCgpQgQynZBzW/9kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ds4qlw0DcW035G2oUDfUvRGU5hIw0/cpwa7MREhr3dfDFbJnKy9i0S6p6uXduSwt+4wiojl2wiJu1fnl2BVyW4/sjmOaYwYMXvkLxsKSiAkemRZqMOQ97ZpKIKDJ5rViMGakEXbj1WLoWtjkgiiw7k3geuYSX7NxmP9KLQbAIH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YUKdRXIB; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e8fec0968so382525e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608523; x=1706213323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=haeX5zmggnkllRSh2IyLwuRzJwGjqqUgrN991UiOKFY=;
        b=YUKdRXIBmCQZdRXUjXAf6k2PLvhUTS184Tsus3qU5nPq1oylFl7RNNgDvegWTRMTmV
         SKS9v0zYwwXsEcU7eMQm+DGzX6SI2QHfwIwXJ10e4NPko5sVKaJS/h14t9yBjC1uczCt
         x/Q8i3YbXdKq6iJ7BJtkOwyR118rfN+1jsE9gs5Zybmk4D0r5HLrdNzV0fZ7MhuWrkvS
         5cMQeMTBDvTNDOwGccCAK3NCnFHH/Q2btSnymGek/vEg2uB0GDmGpcjn5rJL86Z2zNU6
         EKJ5QMjeS+oDPKvHcpeOqaEFQhK6N09X2jJQGnux5Ffv9OfAr+9AG5mse51bCdDKb85z
         lMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608523; x=1706213323;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haeX5zmggnkllRSh2IyLwuRzJwGjqqUgrN991UiOKFY=;
        b=clQ2eF/lG/Oo3xuDFWvOHjVa9jy4tFughJDtZ8+jiAlIxt9jG0wJXqg4KJuCb1sukU
         Voc9V0C4LiG4KXpor6/fWSD2I+BQ1ofzmuWVWgdw+L8wVhjFxQkMz9khdP2j3XLx0RO9
         tXqOrECgh2uQ4CuaTF5TJ4759T4rRDCgsLY3INCpHyN4xSfySAJAxxJQU/X03O9S9Ms3
         3fK7P+4/OL24jNz+dfaOiCwcBQnXhMZFFSnHwt4R4xmKqSfu+QrgZJL3uP7Sc9iXr44o
         nMDAmwnPLLzGpiFzd26GLVbAzqdeIZ/q4aDBYF1BlzYCYdwE3gq3rteHkMFbeEhdiEmN
         I4Pw==
X-Gm-Message-State: AOJu0Yw9ji/1yggc5cV9RzjUtVu9WkzkoZu4TbvItvryBR5T+YWguW8O
	9/1bQZuS42+APO5HP+h/WDsUQBhn5sJUbbBPIMN7U1hFKco/oDO5H+x74/ZfDMw=
X-Google-Smtp-Source: AGHT+IF1cvUiwdlvGuy/umIofxo4jxXUUakN8g035Hkx43UBNfkpqf5cMEgzAL/KoKKa/HRjhbA+FQ==
X-Received: by 2002:a05:600c:1c9c:b0:40e:7677:c25c with SMTP id k28-20020a05600c1c9c00b0040e7677c25cmr795282wms.142.1705608522835;
        Thu, 18 Jan 2024 12:08:42 -0800 (PST)
Received: from [192.168.124.175] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id l6-20020a7bc346000000b0040d81ca11casm26099868wmj.28.2024.01.18.12.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 12:08:42 -0800 (PST)
Message-ID: <fbb60cf4-78a3-4133-b138-bc37a79ca68c@linaro.org>
Date: Thu, 18 Jan 2024 21:08:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/20] arm: Rework target/ headers to build various hw/
 files once
Content-Language: en-US
To: qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>, qemu-arm@nongnu.org,
 Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Eric Auger <eric.auger@redhat.com>,
 Niek Linnenbank <nieklinnenbank@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Alistair Francis <alistair@alistair23.me>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Andrey Smirnov <andrew.smirnov@gmail.com>, Rob Herring <robh@kernel.org>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, Tyrone Ting <kfting@nuvoton.com>,
 Beniamino Galvani <b.galvani@gmail.com>, Alexander Graf <agraf@csgraf.de>,
 Leif Lindholm <quic_llindhol@quicinc.com>, Ani Sinha <anisinha@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Jean-Christophe Dubois <jcd@tribudubois.net>,
 Joel Stanley <joel@jms.id.au>, Hao Wu <wuhaotsh@google.com>,
 kvm@vger.kernel.org
References: <20240118200643.29037-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/1/24 21:06, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> In order to fix a bug noticed [*] by Cédric and Fabiano in my
> "Remove one use of qemu_get_cpu() in A7/A15 MPCore priv" series,
> I ended reusing commits from other branches and it grew quite
> a lot. This is the first "cleanup" part, unrelated on MPCorePriv.
> 
> Please review,
> 
> Phil.
> 

[*] 
https://lore.kernel.org/qemu-devel/501c1bfe-fb26-42ab-a925-9888755c72ad@linaro.org/

> Philippe Mathieu-Daudé (18):
>    hw/arm/exynos4210: Include missing 'exec/tswap.h' header
>    hw/arm/xilinx_zynq: Include missing 'exec/tswap.h' header
>    hw/arm/smmuv3: Include missing 'hw/registerfields.h' header
>    hw/arm/xlnx-versal: Include missing 'cpu.h' header
>    target/arm/cpu-features: Include missing 'hw/registerfields.h' header
>    target/arm/cpregs: Include missing 'hw/registerfields.h' header
>    target/arm/cpregs: Include missing 'kvm-consts.h' header
>    target/arm: Expose arm_cpu_mp_affinity() in 'multiprocessing.h' header
>    target/arm: Declare ARM_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
>    hw/cpu/a9mpcore: Build it only once
>    hw/misc/xlnx-versal-crl: Include generic 'cpu-qom.h' instead of
>      'cpu.h'
>    hw/misc/xlnx-versal-crl: Build it only once
>    target/arm: Expose M-profile register bank index definitions
>    hw/arm/armv7m: Make 'hw/intc/armv7m_nvic.h' a target agnostic header
>    target/arm: Move ARM_CPU_IRQ/FIQ definitions to 'cpu-qom.h' header
>    target/arm: Move e2h_access() helper around
>    target/arm: Move GTimer definitions to new 'gtimer.h' header
>    hw/arm: Build various units only once


