Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E297D5A11
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343956AbjJXSEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbjJXSD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:03:58 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8D410E4
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 11:03:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bbbe81185dso11679561fa.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 11:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698170633; x=1698775433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEONOSfW6QqBefI1upMEyQojVOQZ6IVElQgRfFuaf7Y=;
        b=Kp2x6i1b5ec2acOHd7yKUzc8wA3wbH9KadqSvUei3IOTJiXCY2oE16hGCiUjJZT/1V
         ffQy7TDNWLBcXex8TsLBxuZNx9Z9hHt2F+cbwJDNiOQQ4vnZAbMo4UQYwfFHY/gYoHUB
         z2sSDaEm1eDcMVGNdg7ee2/oQqZnCyP10MODkyr0A/U2rKLtK54/zFgvgVX1CgCnTD7L
         XE6APjrvBBNmzMuwrZqS//o3tO2NRL+7W30UFaVKuebBipcVu01QMmhgfETGJFQdpySJ
         OkLPlIC7RN/JuwFH+aK8mXcl753g2ffLoYzt3zivOsT+1kErtK4ZlK39bK0WPSK1l2tU
         I5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698170633; x=1698775433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEONOSfW6QqBefI1upMEyQojVOQZ6IVElQgRfFuaf7Y=;
        b=Vnd3HnQaQ9l1V4QAL13O2j45mKcScL9lmjQBH+YNgFcICrJLSlccXhZvX1p/I6umGW
         HfLCEes0x9k7g3qk/xKFbz/UU5sYCKZIY5HP2slXV/P0qEUkuinoCGMX+AxICM7XNCCG
         eaaCxZysldEz3bz/erpu79C/DRN/rMC73FyTpoBT7eMFVGDSO3AIfnLSe+AYb/VLJw3Q
         bszMNO6gSxdWlQjaZ5NZZNw2q5LwGgzbOJtGD2AWdAH4lZe0EKPLpo8wA47aCg+NPNP6
         zAr6Ysa+BLjDimjTCyI//VZ9LlQiGB4C+UnmJIN2cmAzEGXZE4iVzehNyZ4VMFQDbdM+
         TqHQ==
X-Gm-Message-State: AOJu0YxjdDfv+reVIu1p7c5bV2/MnUK9MYZhCcepHGIsRGAvcUWwQm6p
        tmXH7CASvn/XPTO3t3O0v5Vyaw==
X-Google-Smtp-Source: AGHT+IHG9OjT799vBD3twtVwoDjSUtel3HWPnH4sumZmGMlI+6kjh9AOjNTruwRaRqCbCawkAtVdGA==
X-Received: by 2002:a2e:a179:0:b0:2bc:d505:2bf3 with SMTP id u25-20020a2ea179000000b002bcd5052bf3mr8734627ljl.1.1698170633475;
        Tue, 24 Oct 2023 11:03:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:9f43:3ca4:162c:d540? ([2a01:e0a:999:a3a0:9f43:3ca4:162c:d540])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d4001000000b0032dc1fc84f2sm10498034wrp.46.2023.10.24.11.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 11:03:52 -0700 (PDT)
Message-ID: <da308888-0e47-4ca4-b318-8f089421dc0b@rivosinc.com>
Date:   Tue, 24 Oct 2023 20:03:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20231024132655.730417-1-cleger@rivosinc.com>
 <20231024132655.730417-3-cleger@rivosinc.com>
 <20231024-e122c317599cd4c6db53c015@orel>
Content-Language: en-US
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20231024-e122c317599cd4c6db53c015@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/10/2023 17:23, Andrew Jones wrote:
> On Tue, Oct 24, 2023 at 03:26:52PM +0200, Clément Léger wrote:
> ...
>> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
>> index 09b47ebacf2e..3ab438f30d13 100644
>> --- a/arch/riscv/lib/uaccess.S
>> +++ b/arch/riscv/lib/uaccess.S
>> @@ -10,8 +10,7 @@
>>  	_asm_extable	100b, \lbl
>>  	.endm
>>  
>> -ENTRY(__asm_copy_to_user)
>> -ENTRY(__asm_copy_from_user)
>> +SYM_FUNC_START(__asm_copy_to_user)
>>  
>>  	/* Enable access to user memory */
>>  	li t6, SR_SUM
>> @@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
>>  	csrc CSR_STATUS, t6
>>  	sub a0, t5, a0
>>  	ret
>> -ENDPROC(__asm_copy_to_user)
>> -ENDPROC(__asm_copy_from_user)
>> +SYM_FUNC_END(__asm_copy_to_user)
>>  EXPORT_SYMBOL(__asm_copy_to_user)
>> +SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)
>>  EXPORT_SYMBOL(__asm_copy_from_user)
> 
> I didn't see any comment about the sharing of debug info among both the
> from and to functions. Assuming it isn't confusing in some way, then

Hi Andrew,

I did some testing with gdb and it seems to correctly assume that
__asm_copy_to_user maps to __asm_copy_from_user for debugging. The basic
tests that I did (breakpoints, disasm, etc) seems to show no sign of
problems for debugging. Were you thinking about other things specifically ?

Thanks,

Clément

> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Thanks,
> drew
