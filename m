Return-Path: <kvm+bounces-36630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0001A1CE80
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF1143A70E5
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450AF1607B4;
	Sun, 26 Jan 2025 20:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UAA6gBlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403E25A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737924139; cv=none; b=FwDADsWhmw74zRu6BaGx/6hVhlygtktJnggTwEzUZzWThwvn4r15atqXq5oDuXxXp/tNWPtTMCTiCE0pbYqdgYxQ8o17iS6vkOqZtRY7TwUCHJtNLAsz4ihwtJmo6c22sxjhf/oj+/mFkMC9pKfBTEJFInAWg09+HALQaF+hoUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737924139; c=relaxed/simple;
	bh=WrNZsyTDEp3t+DALVpU4lpxfmzfSwN/ew7PUDLWrq8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3nIJGt8/YZJCgi3xDn4+UOrXn9kfP7F/B/53PzRltHJMcDpGLuXGAsyEKwwX7hR4SB7UMnRt7Nf8nH4mNJA/KsgJbzFlbKZK61mXG7xHMdU2eCCSdBjCog/5+qlbQlxLoN18qH8QAtF+l3MOChyqCTIi8QZ1cdRRb+FRMxwYQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UAA6gBlU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21631789fcdso62912305ad.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737924137; x=1738528937; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H48ko7PqBt1MRDsTfWIcWC8+CkMs626ufkIw2bc/5x8=;
        b=UAA6gBlUvyfXajy3J7HkqSffczEMvjw2PI7tPGepJCl3fzj7I4QKWe8WhgAv8AlGk1
         LazOrdKAG+mSQCBx5Q/d2QdNGVVnbgYvbW8dbKAm8UjchJVFtBBZ+jPb50E4VcVRRjoh
         pdyoog04HOlXo5l7RPDY2T5YiBZre/HKKrV2n24TL02usByAsWGSCua94rAPcAWAhp4d
         N8+Ah0K32IrKcIEcm5/Giwa1tiFmqNIEcUQuNLh+SPeXB3gR8sNP+Njle3ZMYfU2idYG
         INmdJXX25qttKcmfoVO084x/Hks0JQy0lDZ9IlxeMMjQENM3bO5yJUrAWVExP8zSzf8D
         lMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737924137; x=1738528937;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H48ko7PqBt1MRDsTfWIcWC8+CkMs626ufkIw2bc/5x8=;
        b=j2cQXmyI45rAWVSIS7Kt8gIbNsRSFzRs4BlvTRJU6oQdjlQ9UqlbJc+aVq5LY0qQ36
         nCc5xfF/euyLV8/Ty86ElNT4LfktZH55Y5ldjfz5lYbusjcN+05K8k3dMyyajFGbzmQf
         1CuNoBMan98L3ujC9dM8fAkRpRwifZwFqWqnzJiIa1SVktHI7QZsQo54WZ98gXzV/dwP
         y+q/cAmoCXBL0zREp3HnGxLXwFMlhXgzy+lbkZPYZugfyBTHMFNNEaDzML1X2cPRDkwB
         ixZo0cEAksnJutrU2Qgehbo4l6Osoq4Kg1Bhz+KHP9wTj40VVDTUZ9AE4FjkUcI5CZOz
         VhKg==
X-Forwarded-Encrypted: i=1; AJvYcCWGjEqa/5Xnj2P+pEB38p3a2Mq+YAlGhiqlJQ3Jn/EXRe8//ChJ/I/LEmW0zyo4ERbbS0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8aXE9Y/1pr6YsVtQOAOmekLbnWEnWAH9t8R4JitU4IdPwy/mh
	PUtIVYPgzgcalMzDL7aQyRJsCMSsNNL37dJbj8VjzTRHIyvlOtMuC+CBKlR4ZSA=
X-Gm-Gg: ASbGncs6pDjfeXQhqctBSUX2Rq4dfQdBg9YaG+vG8A+7mSi/rffRMHlPoCoWC9Uq+Cf
	5N7QgqF4mHK5MUKyZ4u4FkGgbt5DPoELF2nWnE2H1yskslj8oxRvsLab39j2TLqzZSeXzY7conZ
	3YLZZlbfbai6hx+xqj2pFMRfipA8Rk+G0h58nPXZeYjwW3KRl3U4vllHMzG4kyzJHubuMP4Zz1F
	izCnLnmHUHZkwTxmoeqTq2m/KYwMi9VKxPa+TDPY17fYK2CBWnKkalSjiOBfLOQuD7fbeVK61nj
	03Dz0kd8MubqnoKLqSRyE7cG5qQ6bcW+U9byML8IfbinDt0=
X-Google-Smtp-Source: AGHT+IET1Hgf5DlFtTnLB6zbw3cCOrZlZ4h4Z0Ht47r+OhnvTjZQY9E5YHFS64waNnu9A7EWzAD+mw==
X-Received: by 2002:a05:6a00:2719:b0:72a:83ec:b1cb with SMTP id d2e1a72fcca58-72f8adf4091mr15476076b3a.0.1737924137118;
        Sun, 26 Jan 2025 12:42:17 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b3233sm5836919b3a.61.2025.01.26.12.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:42:16 -0800 (PST)
Message-ID: <fc81002d-b169-40f7-80e1-c93e55fadd30@linaro.org>
Date: Sun, 26 Jan 2025 12:42:15 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/20] accel: Forward-declare AccelOpsClass in
 'qemu/typedefs.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-14-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-14-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> The heavily imported "system/cpus.h" header includes "accel-ops.h"
> to get AccelOpsClass type declaration. Reduce headers pressure by
> forward declaring it in "qemu/typedefs.h", where we already
> declare the AccelCPUState type.
> 
> Reduce "system/cpus.h" inclusions by only including
> "system/accel-ops.h" when necessary.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/qemu/typedefs.h           | 1 +
>   include/system/accel-ops.h        | 1 -
>   include/system/cpus.h             | 2 --
>   accel/accel-system.c              | 1 +
>   accel/hvf/hvf-accel-ops.c         | 1 +
>   accel/kvm/kvm-accel-ops.c         | 1 +
>   accel/qtest/qtest.c               | 1 +
>   accel/tcg/cpu-exec-common.c       | 1 -
>   accel/tcg/cpu-exec.c              | 1 -
>   accel/tcg/monitor.c               | 1 -
>   accel/tcg/tcg-accel-ops.c         | 1 +
>   accel/tcg/translate-all.c         | 1 -
>   accel/xen/xen-all.c               | 1 +
>   cpu-common.c                      | 1 -
>   cpu-target.c                      | 1 +
>   gdbstub/system.c                  | 1 +
>   system/cpus.c                     | 1 +
>   target/i386/nvmm/nvmm-accel-ops.c | 1 +
>   target/i386/whpx/whpx-accel-ops.c | 1 +
>   19 files changed, 12 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

