Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C26C6A85
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCWOPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCWOPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4722526C3F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679580856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxDKUlZyoUGwaVLgr7eBvNFATgoiI7SiN8TqrQ4NDJk=;
        b=NYtGAlvlVQrulG4+c28FZ+3RVfy07O7/x3GmefdfDr+yTMRuJ7m37QzNZ8ldHMn8FF4tnz
        0gDxB5r1E54Uzf9FslpYrptrFRWXa0XtxEJ+6ph+dLFL4QDbB+u3pnvNBV3/yisv/oBUMZ
        cItpfM9zFB+of1HagiuTjclhB1JaTLE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-wD7UlWYXPeWtk_LvYygpDw-1; Thu, 23 Mar 2023 10:14:13 -0400
X-MC-Unique: wD7UlWYXPeWtk_LvYygpDw-1
Received: by mail-wr1-f70.google.com with SMTP id d18-20020adfa412000000b002d43970bb80so1816119wra.6
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679580851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lxDKUlZyoUGwaVLgr7eBvNFATgoiI7SiN8TqrQ4NDJk=;
        b=ZRj9z+/26iM+9RSALoVAXgxDlhuIBVm/wSaKPVHzpoUb5S+P6oqIwRfPcCTwidlsjT
         mNc5FirvtjzJ4TwhsXv68tkm3FZ3nBD7OgRgulepE3XnyCmHFcLiPv2mutWxfMWwvtFv
         Py12p6BWpd2ADhpehz+nxFjWlRMmrjpnsREtB8Y6hLJyKbEYW2SEkKBoSI71kEhdJN4n
         I+Se5N9v4ViPrSVfOJVdZ7S8bZfOd/Vfw+FYOkRRsJyQ1IFsZpxiMkQA2GiTn5vvk74l
         y0P4X+kL5KnK675Haopg7D+bdF4uEO1X/EgoI+lh9GgKSyWt51WPr9I+23Ielb8gGwrm
         hDEw==
X-Gm-Message-State: AAQBX9fi/z9U4ckDl1ngWqj4sixb74lJ4LL3qGkNcsqXNC2LmDWBs/3f
        zTfBxrKsh5yscGtacFb4et84RQGD+EtaS4IOUnrK/ZN5V5HhVU7p4CnvYreP+CGzZMis70na9O0
        kKumuziMswKKr
X-Received: by 2002:a5d:4e83:0:b0:2cf:e445:295f with SMTP id e3-20020a5d4e83000000b002cfe445295fmr2772086wru.61.1679580851570;
        Thu, 23 Mar 2023 07:14:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350acmls2sCF3QXxHFpxw/8qHUfIyBxACLTfPzxQSRPvkp3EL6IqVZWX7zw10WKrc1KMcfGn0nQ==
X-Received: by 2002:a5d:4e83:0:b0:2cf:e445:295f with SMTP id e3-20020a5d4e83000000b002cfe445295fmr2772073wru.61.1679580851323;
        Thu, 23 Mar 2023 07:14:11 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d5646000000b002d2f0e23acbsm16216116wrw.12.2023.03.23.07.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 07:14:10 -0700 (PDT)
Message-ID: <3516a985-2254-8522-2a71-d9e58e91b5f1@redhat.com>
Date:   Thu, 23 Mar 2023 15:14:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 09/10] powerpc: Support powernv machine with
 QEMU TCG
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-10-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-10-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
> This is a basic first pass at powernv support using OPAL (skiboot)
> firmware.
> 
> The ACCEL is a bit clunky, now defaulting to tcg for powernv machine.
> It also does not yet run in the run_tests.sh batch process, more work
> is needed to exclude certain tests (e.g., rtas) and adjust parameters
> (e.g., increase memory size) to allow powernv to work. For now it
> can run single test cases.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/ppc_asm.h   |  5 +++
>   lib/powerpc/asm/processor.h | 14 ++++++++
>   lib/powerpc/hcall.c         |  4 +--
>   lib/powerpc/io.c            | 33 ++++++++++++++++--
>   lib/powerpc/io.h            |  6 ++++
>   lib/powerpc/processor.c     | 10 ++++++
>   lib/powerpc/setup.c         | 10 ++++--
>   lib/ppc64/asm/opal.h        | 11 ++++++
>   lib/ppc64/opal-calls.S      | 46 +++++++++++++++++++++++++
>   lib/ppc64/opal.c            | 67 +++++++++++++++++++++++++++++++++++++
>   powerpc/Makefile.ppc64      |  2 ++
>   powerpc/cstart64.S          |  7 ++++
>   powerpc/run                 | 30 ++++++++++++++---
>   13 files changed, 234 insertions(+), 11 deletions(-)
>   create mode 100644 lib/ppc64/asm/opal.h
>   create mode 100644 lib/ppc64/opal-calls.S
>   create mode 100644 lib/ppc64/opal.c
> 
> diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
> index 6299ff5..5eec9d3 100644
> --- a/lib/powerpc/asm/ppc_asm.h
> +++ b/lib/powerpc/asm/ppc_asm.h
> @@ -36,7 +36,12 @@
>   #endif /* __BYTE_ORDER__ */
>   
>   /* Machine State Register definitions: */
> +#define MSR_LE_BIT	0
>   #define MSR_EE_BIT	15			/* External Interrupts Enable */
> +#define MSR_HV_BIT	60			/* Hypervisor mode */
>   #define MSR_SF_BIT	63			/* 64-bit mode */
>   
> +#define SPR_HSRR0	0x13A
> +#define SPR_HSRR1	0x13B
> +
>   #endif /* _ASMPOWERPC_PPC_ASM_H */
> diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> index ebfeff2..8084787 100644
> --- a/lib/powerpc/asm/processor.h
> +++ b/lib/powerpc/asm/processor.h
> @@ -3,12 +3,26 @@
>   
>   #include <libcflat.h>
>   #include <asm/ptrace.h>
> +#include <asm/ppc_asm.h>
>   
>   #ifndef __ASSEMBLY__
>   void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
>   void do_handle_exception(struct pt_regs *regs);
>   #endif /* __ASSEMBLY__ */
>   
> +/*
> + * If this returns true on PowerNV / OPAL machines which run in hypervisor
> + * mode. False on pseries / PAPR machines that run in guest mode.

s/If this/This/

  Thomas

