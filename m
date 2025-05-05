Return-Path: <kvm+bounces-45522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD16AAAB0F3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A52C87BDAEE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141843184D1;
	Mon,  5 May 2025 23:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OSrdAl1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E663A54A0
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487646; cv=none; b=G/63unSxdRhvyu2JBMvaQKK2ELItGIheZa7VoHfM5cuqkakGXzoFgHDJDZ4nqqvNS1FJuuQaKepphmgB7PhoQQvE308kqej+ILn0tYbw2MfIONsSqLiIONoDf0QvmTT0GvTsNDOfdO/ADqNiuifKF2jXo58nX/+oDaYWPwNWHJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487646; c=relaxed/simple;
	bh=VX9iiQme4y1BI040eMX3uASRypvxs2iXjX1ujnWZo9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GQRCIyyCe4YDcmvweVuueCkuClcFzQa+8e4dFI6Y1RkgBDKDjfXkQFOJpe66AZeDVhGa00T+WYtPYrSbtuNDRXEd9BTJ5E5M4u21nx7Ne6SZal4i5uT/SprsYxdbo4W3dvMqcZPso1gpCPKIUIb+9mN5wd/vnOnmaRnc7ywrDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OSrdAl1b; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-309fac646adso5614417a91.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487642; x=1747092442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DColEmLeOznk74rz9KqevCsTLWb7uFfsWuQwws4WyvU=;
        b=OSrdAl1b0gEq5nRIqaz+trlwMILvXx3DnYLnCMI0rGY9QeymPy3oo1dhv7V/qfU3r5
         1DDgb6MzTmClTXUoouGPMxig2YB9+MMf/Mb8HY9u/STkaAtWULSnMHKVYjfT2iJqc08I
         lVEG6DOTdf5x6qlza5eDBqMGHFVjI30slYeHstb2LglgXySzZGCEjLh5XWpEIddgewY8
         NkWvRyCT8FUN1+w/1cM8lYrhVQvaD/Bp8ESXqdsC2z5JhsO+NGYLFTpdeigOa/xReitZ
         ibXizaPtf/NaQQ1ahsyrR78TWKYPb9t7YS35jAWtsbyWeG1FF/lQT3KezBSuZ7H/H47f
         WYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487642; x=1747092442;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DColEmLeOznk74rz9KqevCsTLWb7uFfsWuQwws4WyvU=;
        b=PlBdxjVmnufXjtUVMhP0kv3eFWtZqZLdbHQc9kO1XxM07TZ6Sh8RrlI5QuCNzfkrIj
         yXvZL8Z3pi5JbDJZgCJcnq2XiN2kSGTcPX0b+cZKWy46HOcrAs1LCKISDDiZ290vdfU8
         tGvu15rav2AJr4UOqmXEVQrkNSMWAMbgMgRxX3SCGb2tR2IYQLmWSWFU/eyGKKUkXHOk
         vvRjen3BIy2ZkEPH6h/HK9SW5oh1CdJJBK5SxHej3RrcyEzG/LyvL7LDtEXdUUk+qJLp
         p5/r0rTK9LIqgQlFoK5zIHVvErk42nTgaY1Rx045kvZzDArCI/h9lTbdRJ/nhPoQHjrR
         yO0w==
X-Forwarded-Encrypted: i=1; AJvYcCUVFTqpf5OnsmilPzTLSz3IFrSYjZPm3i+RH4s1Z8ElHBAbjq6wRTInzRG1OciMhWWUVL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYFQOX2Y+xur+9oXez0qnLJyxWaXNjWTPVqIT6/1Iei2CLgGi5
	O3LxbM7sp0E3DPCwm9OrLPQrkMpY+CBVCmHONLXODkpNaJoKlp+fA/Jh7582EB1yHg+esy+0IvB
	JoyQ=
X-Gm-Gg: ASbGnctO1RySaFn8VzC2i0mtfcfyl9umIbwFsI2JZq2ADMBP3r6LhhhGlqErN0QNcWC
	wAzGTXagx+sdTkcQ6F3XZz3MwEDU4A3C0hdjU1wv3um50CW2veZ2VE0qYZ2CztyX8Gs4R+qiCnN
	RjFKE+d74mCQRzzffg6JSfygu+497uPLyE4ku7V88tW5IPWIjRy3S7bbL06AlcJVgd69Mc5R+KH
	zgTZcMHrllTKmv/BT5tDGFJ8GUJI4Efa+ps0fQ5I/v/xEa5Y7Mz2cTd5aa9VXGB7WQcpKLpAVXY
	wyXYG1cWzb3DyOa2G2t/7tEmAbstVI8nHSPrdy8O2BsLjJsvI3PDhQ==
X-Google-Smtp-Source: AGHT+IFgstfeaoCNVrbCHdFFeS0ZpKEX0NF2KwZsdipdG+8jwM/CES45trboYz2SF8VajkqqYc5+hw==
X-Received: by 2002:a17:90b:544e:b0:2fa:3174:e344 with SMTP id 98e67ed59e1d1-30a7bb28833mr2046495a91.14.1746487642685;
        Mon, 05 May 2025 16:27:22 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4745f920sm9649121a91.8.2025.05.05.16.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 16:27:22 -0700 (PDT)
Message-ID: <c009277c-4777-4a80-94ed-922f40147700@linaro.org>
Date: Mon, 5 May 2025 16:27:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/50] single-binary: compile target/arm twice
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org, anjo@rev.ng,
 Peter Maydell <peter.maydell@linaro.org>, alex.bennee@linaro.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Patches left for review:

- [PATCH v6 04/50] meson: apply target config for picking files from 
libsystem and libuser
- [PATCH v6 41/50] target/arm/tcg/vec_internal: use forward declaration 
for CPUARMState
- [PATCH v6 42/50] target/arm/tcg/crypto_helper: compile file once
- [PATCH v6 47/50] target/arm/helper: restrict define_tlb_insn_regs to 
system target
- [PATCH v6 50/50] target/arm/tcg/vfp_helper: compile file twice 
(system, user)

Regards,
Pierrick

