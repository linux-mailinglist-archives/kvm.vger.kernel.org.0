Return-Path: <kvm+bounces-36631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02297A1CEBA
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A844E3A4C56
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF126175D4F;
	Sun, 26 Jan 2025 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H+v4A1an"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F925A62A
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926033; cv=none; b=uCpJQ8spwqrfftUWjcH5LskK2eOifcwYy5rdX8+XcpBjaZJKUTZn+rRC8nHjxZJBdvJ5vdZ0cj/PBtNFQ7pBP5GzwqIz2DV2WwWg2YnQdkrBPOmCk1TtRjcfhEpOOfqFFsSEPV0eWIt5k3KmVo2Ra4jDMTsrwwa04+hLBSFIYLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926033; c=relaxed/simple;
	bh=pM8qUUNvaJNHm+L48cHRcyQLruThU4My2WxYWMWa1rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2mcI9/K7mVQyEYQfI5hCPeaV9pJisf/6sKkRX2Y2Z22KODr0II9Fth0yJaD2NwzcF6qwZsty86lAtP5qJFPetLnjJLbOlHkUl7AWLPbMtLSEBWOei91g3EDAPoe6uZBOCEe0lsQpZD5DRhT8oBBl0wuFRRJ5mxwVTwBdZSazc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H+v4A1an; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-216426b0865so60921405ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737926031; x=1738530831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M9kpcRwj4XMG8ftG4wmZyZnxF1iU/ErySCW5MvOqlTU=;
        b=H+v4A1anwbOQwEQav/OVDMXYzeKja/sfH9QJ+zJZGT1ySPNtLZi+DIQnTjf4Bbjh+4
         +0m3q/5oKJb/UicoB5YgyyGXkbYvrK6QKxiiVJ6OART2OthQfRlgw3F/CFlz/F3Tn+ux
         ZdFOPwNZloVgSEFqgLyB5DGE97gCgzeBw03A7aQYmS8tM/pEKVnPRZAIbBDAWkNZ/8at
         FNVJ5BG/i7d1c+9Z0Kh2BIxtFS3ahAvLnHn2V2GfMWvylSf+4TMoW6mbXrSHFgJTDmFL
         zuRUqAdLusgKAMPaSfvViF5HtPZJoohd96q62b8X42AWxvdX9bQ2Xp306rduIb/idVdN
         gdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737926031; x=1738530831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9kpcRwj4XMG8ftG4wmZyZnxF1iU/ErySCW5MvOqlTU=;
        b=spBjzZ218dR8AeEMZSRMJY9g0VobIJbhVUdQCd3NrxvF+FmUtwokUZxmXdPnMsQslJ
         3pqxRuqvw+7LTXEq6H1X8OULlFBekQC4ERc/XkyonjTozIY6iVxabjIipvJQr3eiHSLr
         8d6Z0RxnKmLw7lM7O/f2fruGGw4LFURe/6D1rrnHYRdFP7OquqbFEbNGxUJb1IdbfMN1
         DOYQjsS27NbMOA43RYYz/+E4KZtFPPExjaGBK5k5sb1zzqYUX62iFn5TSAz1hInJAPcC
         h/HXx0zDjZpjXuBGpcIO+bWdsB7ive0pyW7RdJ0jauDUhDSPQWEfF+dQ9rBUCrPXNHNh
         s93Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOAYjwQMnd/WkNQEFi4/3rpgVdl99AOGKSNFc93A0AYPlwrU2flu8obK3Smt0W46o3AZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4b8/YKwodl/TwgHwGfBPhBtnEePMapZmMJwo1AuTHhgqh73TB
	33mIFwCs55CWw+NJsgkAxn7D0pppvszNZOUefX1rfF755tkhhJwAgWP8gPE4lKc=
X-Gm-Gg: ASbGncs41vEyuKOTD2yq1GKW7ziNfOtK5DC6JQynguimYd/0LcPdricRgmZr1NxaQVn
	qEtYGcIxi656loLJMmEkjhIkw29+w/cciVDEr2GrUFY9ow5fhknc1pkVsPADrOoHS7UIvkuv4lc
	02hk9rEHM/ba5VRQ5FcElFKpO/WTj9xroTnYOy/mjkaRqLC4mpajk6U2ejgyiX/2MrpxQVstfs5
	9enS7MFUXe8NoOSqVwXBNuzUbAinsea+Ul7xjbQgbLGtFEKA+rlKXk+MVBLqBeeAMxncK7cdkgg
	HTxujiJoabN8gH33pP76aRzgK6WIx5Ngn1WAsZmBtYTGRBk=
X-Google-Smtp-Source: AGHT+IEZs0zeKB5IzyrVqsgjZQ8Qgr6yuUndfoZR9xIIrSSkISsRSLWzsvON9msLe4CFxT+Ly8wqnw==
X-Received: by 2002:a17:902:f551:b0:215:431f:268a with SMTP id d9443c01a7336-21c3556016amr565306785ad.31.1737926031507;
        Sun, 26 Jan 2025 13:13:51 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3bb9sm50157355ad.92.2025.01.26.13.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:13:51 -0800 (PST)
Message-ID: <c844b086-b3fd-438d-a4ce-6571094e5e14@linaro.org>
Date: Sun, 26 Jan 2025 13:13:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/20] accel/tcg: Move cpu_memory_rw_debug() user
 implementation to user-exec.c
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-15-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> cpu_memory_rw_debug() system implementation is defined in
> system/physmem.c. Move the user one to accel/tcg/user-exec.c
> to simplify cpu-target.c maintenance.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/tcg/user-exec.c |  92 +++++++++++++++++++++++++++++++++++++
>   cpu-target.c          | 102 +-----------------------------------------
>   2 files changed, 94 insertions(+), 100 deletions(-)
> 
> diff --git a/accel/tcg/user-exec.c b/accel/tcg/user-exec.c
> index c4454100ad7..e7e99a46087 100644
> --- a/accel/tcg/user-exec.c
> +++ b/accel/tcg/user-exec.c
> @@ -19,6 +19,8 @@
>   #include "qemu/osdep.h"
>   #include "accel/tcg/cpu-ops.h"
>   #include "disas/disas.h"
> +#include "exec/vaddr.h"
> +#include "exec/tswap.h"
>   #include "exec/exec-all.h"
>   #include "tcg/tcg.h"
>   #include "qemu/bitops.h"
> @@ -35,6 +37,7 @@
>   #include "internal-common.h"
>   #include "internal-target.h"
>   #include "tb-internal.h"
> +#include "qemu.h"

What is required from *-user/qemu.h?
We really should not be including that in accel/tcg/.

> +            if (flags & PAGE_WRITE) {
> +                /* XXX: this code should not depend on lock_user */
> +                p = lock_user(VERIFY_WRITE, addr, l, 0);

Ah, here it is, complete with comment.

Indeed, I don't think lock_user is required at all.  page_get_flags() and g2h() are 
sufficient.

> +                mmap_lock();
> +                tb_invalidate_phys_range(addr, addr + l - 1);
> +                written = pwrite(fd, buf, l,
> +                                 (off_t)(uintptr_t)g2h_untagged(addr));
> +                mmap_unlock();

We probably want to own mmap_lock for the entire function.


r~

