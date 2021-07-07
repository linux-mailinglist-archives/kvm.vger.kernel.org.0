Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FF63BE07A
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 03:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhGGBMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 21:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhGGBMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 21:12:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE9AC061574
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 18:09:45 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so2576264pjb.0
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 18:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Elf6yd51xkGVv1HCTXaAsNiPJI9YFXcZSMrOV69Y7bM=;
        b=hVkDFUHHLBbbmtBBkRhtms5RNSFqn277YQ/bHrBPV70GvbeYcU24SGy+jBk7ZGIpGT
         gyBVUPZyw0Rwyzen4bBoJbGOXVMiiF57okCUbKu3aPcjfqwioYXHoCjZzkZPery5eLbg
         AH/uVk2c2tQBvCqCkC7SQ/WFUM422mn3e/O5CG8V191Pi702EB00pm9N+SGr4FugrLQI
         6QHM9Sl/+vUOkFZXc1wz1l0ghKN4+KdCv46t8U1T7z8VKkg+42sDQaeO0LE4UVUI9GsJ
         uArrrvdxD8x0rtiZgRQ8SrW9vkvsKAK+I7IUCmskO+sS164A34i9WD2lmkumxNOhymNA
         Ertw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Elf6yd51xkGVv1HCTXaAsNiPJI9YFXcZSMrOV69Y7bM=;
        b=K/gRYmK/q0wSZfyDn1rWqnphMG2w8P8vyjGfIhSCwyxI5j1dQE8M92bUzIqI0jZn3F
         5Wlubc/Qwyq/fth/jYY6nPmB3QAAxYLEocPLuLX5iaJkW/OF6oW9N3JxxK7tAK8N4HQT
         G8X6E/ZRNPpZCwJ7Ks0A4wjaiC6x2x3SNQyd1Ac3MdjteN/eCHe8esJSnNHcGrHw0fTI
         AgpMsChUe5V7CV+fCYDC3bPzhmvFxVlgyVKtAl5O213/S8YoYQ+XxoqXA2kq7tlXrDxn
         V52M0uRefnudhu4v3LHi+kYE/wpMq0jUgLFhL48szrwX2slRxdIxej3Tnb2IPqSkmrkg
         0F5Q==
X-Gm-Message-State: AOAM530SGfe8WnC/1tqUHRmQqKbxj4sGDerJsdsO+MQ+37N3LvuOFYoJ
        /+QjFOBcM6FcslKT1nEhdkob4Q==
X-Google-Smtp-Source: ABdhPJz/8vZRqn3Tc52Vz5c9UVAzni9xRt4f01Rg6AtzU0yoqhOf8eqTQvH5k1IMs75thD2jkWhThw==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr23761854pjb.214.1625620184966;
        Tue, 06 Jul 2021 18:09:44 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.149.176])
        by smtp.gmail.com with ESMTPSA id e24sm17995692pfn.127.2021.07.06.18.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 18:09:44 -0700 (PDT)
Subject: Re: [RFC PATCH 8/8] target/i386: Move X86XSaveArea into TCG
To:     David Edmondson <david.edmondson@oracle.com>, qemu-devel@nongnu.org
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, babu.moger@amd.com,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
 <20210705104632.2902400-9-david.edmondson@oracle.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <0d75c3ab-926b-d4cd-244a-8c8b603535f9@linaro.org>
Date:   Tue, 6 Jul 2021 18:09:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705104632.2902400-9-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/21 3:46 AM, David Edmondson wrote:
> Given that TCG is now the only consumer of X86XSaveArea, move the
> structure definition and associated offset declarations and checks to a
> TCG specific header.
> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>   target/i386/cpu.h            | 57 ------------------------------------
>   target/i386/tcg/fpu_helper.c |  1 +
>   target/i386/tcg/tcg-cpu.h    | 57 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 58 insertions(+), 57 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 96b672f8bd..0f7ddbfeae 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1305,48 +1305,6 @@ typedef struct XSavePKRU {
>       uint32_t padding;
>   } XSavePKRU;
>   
> -#define XSAVE_FCW_FSW_OFFSET    0x000
> -#define XSAVE_FTW_FOP_OFFSET    0x004
> -#define XSAVE_CWD_RIP_OFFSET    0x008
> -#define XSAVE_CWD_RDP_OFFSET    0x010
> -#define XSAVE_MXCSR_OFFSET      0x018
> -#define XSAVE_ST_SPACE_OFFSET   0x020
> -#define XSAVE_XMM_SPACE_OFFSET  0x0a0
> -#define XSAVE_XSTATE_BV_OFFSET  0x200
> -#define XSAVE_AVX_OFFSET        0x240
> -#define XSAVE_BNDREG_OFFSET     0x3c0
> -#define XSAVE_BNDCSR_OFFSET     0x400
> -#define XSAVE_OPMASK_OFFSET     0x440
> -#define XSAVE_ZMM_HI256_OFFSET  0x480
> -#define XSAVE_HI16_ZMM_OFFSET   0x680
> -#define XSAVE_PKRU_OFFSET       0xa80
> -
> -typedef struct X86XSaveArea {
> -    X86LegacyXSaveArea legacy;
> -    X86XSaveHeader header;
> -
> -    /* Extended save areas: */
> -
> -    /* AVX State: */
> -    XSaveAVX avx_state;
> -
> -    /* Ensure that XSaveBNDREG is properly aligned. */
> -    uint8_t padding[XSAVE_BNDREG_OFFSET
> -                    - sizeof(X86LegacyXSaveArea)
> -                    - sizeof(X86XSaveHeader)
> -                    - sizeof(XSaveAVX)];
> -
> -    /* MPX State: */
> -    XSaveBNDREG bndreg_state;
> -    XSaveBNDCSR bndcsr_state;
> -    /* AVX-512 State: */
> -    XSaveOpmask opmask_state;
> -    XSaveZMM_Hi256 zmm_hi256_state;
> -    XSaveHi16_ZMM hi16_zmm_state;
> -    /* PKRU State: */
> -    XSavePKRU pkru_state;
> -} X86XSaveArea;
> -
>   QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
> @@ -1355,21 +1313,6 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>   QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
>   
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
> -
>   typedef struct ExtSaveArea {
>       uint32_t feature, bits;
>       uint32_t offset, size;
> diff --git a/target/i386/tcg/fpu_helper.c b/target/i386/tcg/fpu_helper.c
> index 4e11965067..74bbe94b80 100644
> --- a/target/i386/tcg/fpu_helper.c
> +++ b/target/i386/tcg/fpu_helper.c
> @@ -20,6 +20,7 @@
>   #include "qemu/osdep.h"
>   #include <math.h>
>   #include "cpu.h"
> +#include "tcg-cpu.h"
>   #include "exec/helper-proto.h"
>   #include "fpu/softfloat.h"
>   #include "fpu/softfloat-macros.h"
> diff --git a/target/i386/tcg/tcg-cpu.h b/target/i386/tcg/tcg-cpu.h
> index 36bd300af0..53a8494455 100644
> --- a/target/i386/tcg/tcg-cpu.h
> +++ b/target/i386/tcg/tcg-cpu.h
> @@ -19,6 +19,63 @@
>   #ifndef TCG_CPU_H
>   #define TCG_CPU_H
>   
> +#define XSAVE_FCW_FSW_OFFSET    0x000
> +#define XSAVE_FTW_FOP_OFFSET    0x004
> +#define XSAVE_CWD_RIP_OFFSET    0x008
> +#define XSAVE_CWD_RDP_OFFSET    0x010
> +#define XSAVE_MXCSR_OFFSET      0x018
> +#define XSAVE_ST_SPACE_OFFSET   0x020
> +#define XSAVE_XMM_SPACE_OFFSET  0x0a0
> +#define XSAVE_XSTATE_BV_OFFSET  0x200
> +#define XSAVE_AVX_OFFSET        0x240
> +#define XSAVE_BNDREG_OFFSET     0x3c0
> +#define XSAVE_BNDCSR_OFFSET     0x400
> +#define XSAVE_OPMASK_OFFSET     0x440
> +#define XSAVE_ZMM_HI256_OFFSET  0x480
> +#define XSAVE_HI16_ZMM_OFFSET   0x680
> +#define XSAVE_PKRU_OFFSET       0xa80
> +
> +typedef struct X86XSaveArea {
> +    X86LegacyXSaveArea legacy;
> +    X86XSaveHeader header;
> +
> +    /* Extended save areas: */
> +
> +    /* AVX State: */
> +    XSaveAVX avx_state;
> +
> +    /* Ensure that XSaveBNDREG is properly aligned. */
> +    uint8_t padding[XSAVE_BNDREG_OFFSET
> +                    - sizeof(X86LegacyXSaveArea)
> +                    - sizeof(X86XSaveHeader)
> +                    - sizeof(XSaveAVX)];
> +
> +    /* MPX State: */
> +    XSaveBNDREG bndreg_state;
> +    XSaveBNDCSR bndcsr_state;
> +    /* AVX-512 State: */
> +    XSaveOpmask opmask_state;
> +    XSaveZMM_Hi256 zmm_hi256_state;
> +    XSaveHi16_ZMM hi16_zmm_state;
> +    /* PKRU State: */
> +    XSavePKRU pkru_state;
> +} X86XSaveArea;
> +
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);

My only quibble is that these offsets are otherwise unused.  This just becomes validation 
of compiler layout.

I presume that XSAVE_BNDREG_OFFSET is not merely ROUND_UP(offsetof(avx_state) + 
sizeof(avx_state), some_pow2)?

Do these offsets need to be migrated?  Otherwise, how can one start a vm with kvm and then 
migrate to tcg?  I presume the offsets above are constant for a given cpu, and that 
whatever cpu provides different offsets is not supported by tcg?  Given the lack of avx, 
that's trivial these days...


r~
