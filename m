Return-Path: <kvm+bounces-2912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00B77FF030
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D26391C20DC7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91D647A72;
	Thu, 30 Nov 2023 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A70XgI0f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399301728
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:31:22 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-332fd78fa9dso592832f8f.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701351080; x=1701955880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C/yCzubWKQxS7Fy3Kco2IAWc/FIsP2Et/rAFvlXXtYk=;
        b=A70XgI0fX8WrhibBTr70BYAgGQ/anKs+YHsSfmGS+tm5meqiwsvm+FRa7gaIREvCeN
         NjSPuwsWnmL/mOYG46vg9ccD0Bek5Xl711OUKgZT7x2O6SsyJWKowXx5UoTQzf9LaGv8
         z4kwc5wU0swHAgZadRBe7+5LNjuI3lUbZhSjYoRC1uCseXI1t7xg4fHJL2gmbnxv1Qqu
         d1aV9Ibs3PVI4kp9wQF7n/7T1cbqZokSDeV3f+zFc+wazR3n4rS8xyoNfQP0ckaYmD5i
         6BNsfXZriAUcZZY9ReWdBnvXsQO48mSTY+KbkZqXtrHzD1TsU0E2TpgET5CEqR9NDT4D
         BDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701351080; x=1701955880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/yCzubWKQxS7Fy3Kco2IAWc/FIsP2Et/rAFvlXXtYk=;
        b=qNAVNeNKEBbQWv0vdviQ56HooN9e8xzIXaBmP/pErtq2grjO5jUITQ/EnAgFrbacEp
         bwGcICuy6OypOY5Tm3jGKEf0htYvKA5tIghZWEO5+n/eCD9mzl4xEkV18nvui6OsI000
         z8hM7ZayfNUrFWgxQWbJ4uuQbo+Aq6uR8Pk9cBmgYkuLjBxoMwKZjh2XTguE+JImEZAK
         wV+cpKrdCrJ8q6R+p5rf3UNHhNGjk/UXUdfJSgZw4ExVj85hKf3nllGP3O2FcVSdiLOU
         cae6kXJ0tgpfp6PIJc8eOqxLXXKlPduFDXJdyHyO19fCGt6JSuoiEwjTyDXKveE3pyDa
         gV4g==
X-Gm-Message-State: AOJu0YwDQgJQTqUQ86mF5fs9FVmCDuD/vnCwWoHDqXAojvuPReSq9IX1
	WC9Q6W61GWhig6HQwdR4EBaB6up6zI0JTIP9ZkrBbg==
X-Google-Smtp-Source: AGHT+IH3mYM6u5yqPaWTXEEelKCiAMTv7BDhaqBAydzuRBu/xAoku9xgJaGToArNkflYVngVSZwmKg==
X-Received: by 2002:adf:f4ce:0:b0:333:16b8:4190 with SMTP id h14-20020adff4ce000000b0033316b84190mr4405514wrp.11.1701351080628;
        Thu, 30 Nov 2023 05:31:20 -0800 (PST)
Received: from [192.168.69.100] (sev93-h02-176-184-17-116.dsl.sta.abo.bbox.fr. [176.184.17.116])
        by smtp.gmail.com with ESMTPSA id g11-20020adff40b000000b00333174445fesm1577772wro.5.2023.11.30.05.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 05:31:20 -0800 (PST)
Message-ID: <73ca9d6c-62d4-412a-b847-f2c421887e96@linaro.org>
Date: Thu, 30 Nov 2023 14:31:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Content-Language: en-US
To: Claudio Fontana <cfontana@suse.de>, qemu-devel@nongnu.org
Cc: Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, kvm@vger.kernel.org
References: <20231129205037.16849-1-philmd@linaro.org>
 <3d8bbcc9-89fb-5631-b109-24a9d08da1f5@suse.de>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <3d8bbcc9-89fb-5631-b109-24a9d08da1f5@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Claudio,

On 30/11/23 13:48, Claudio Fontana wrote:
> Hi Philippe,
> 
> took a quick look with
> 
> grep -R can_do_io
> 
> and this seems to be in include/hw/core/cpu.h as well as cpu-common.c,
> 
> maybe there is more meat to address to fully solve this?
> 
> Before we had stuff for reset in cpu-common.c under a
> if (tcg_enabled()) {
> }
> 
> but now we have cpu_exec_reset_hold(),
> should the implementation for tcg of cpu_exec_reset_hold() do that (and potentially other tcg-specific non-arch-specific cpu variables we might need)?

Later we eventually get there:

diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 9b038b1af5..e2c5cf97dc 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -89,6 +89,9 @@ static void tcg_cpu_reset_hold(CPUState *cpu)

      cpu->accel->icount_extra = 0;
      cpu->accel->mem_io_pc = 0;
+
+    qatomic_set(&cpu->neg.icount_decr.u32, 0);
+    cpu->neg.can_do_io = true;
  }

My branch is huge, I'm trying to split it, maybe I shouldn't have
sent this single non-TCG patch out of it. I'll Cc you.

> If can_do_io is TCG-specific, maybe the whole field existence / visibility can be conditioned on TCG actually being at least compiled-in?
> This might help find problems of the field being used in the wrong context, by virtue of getting an error when compiling with --disable-tcg for example.
> 
> Ciao,
> 
> Claudio


