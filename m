Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF837D61D3
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 08:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjJYGuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 02:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjJYGuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 02:50:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B9B181
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 23:50:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9b9faf05f51so761041866b.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 23:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698216640; x=1698821440; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MwdrCLs7J8pw9TLHstYCMVRsUZqiCP56vCN/PW3QTMo=;
        b=LOsrUHKtNHXqvv2Rv06Qg37pWRMDznTuKeoBdSFU2mi58FCKO7JQOFoxSink7rDQ6E
         eaFzpMioxz/gjd40YMjXg26hPEpkkdgTYxzEL1r264J3ZxJN/Hf9lBwOkPTFfat6fRdh
         RC5UXSRVqe4OqjvfmQuK4bJdL5f0ark9mF+74i9sNVRqUbWsRAbYK0cSZM3rNpAcCQGS
         cqIzk8XlOmHNjBWTIWelNK/eQP9Uc8hH08ZZrh2Z1wLUcofKFRdlJJvdVPUvRIZQRaNh
         xJN1eDqN//dwdN6JaJVCRdBEkgIzXPH/3Nb5cktJMCPSzInHbuPV0XzCdtFA9TLjRVbC
         474Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698216640; x=1698821440;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MwdrCLs7J8pw9TLHstYCMVRsUZqiCP56vCN/PW3QTMo=;
        b=PJFczWYprIGl+gbSb6GVoCfxEuxLjeMTEQ08mJ9nwvRfcA7VR4fMs8TtC7TaUNb4mt
         axjxleaS7x1eXQWO0haQ4RB9rVr2hNfSa78fIHkhRziW+yqhwIZPx06EObihvrRYm6Er
         /mdT0exit6W+uJXYtyxokbRWHrKPMZdWodTZpJAgjDlBUd7QjPs8jh3x3AuXPkpO7IJ3
         l+ZClKSHXrtS2naHKm5bUUO5fAHKB97KenLbZZFThHUhyR2PiFYSxg7kvOSGuSIYzsRh
         Lqm8N49u6RHuneqXUgXJ8hYR5pSeCLpok4JHkix3dI6gBwsXSZxJpA/lW81+NebNxoOE
         xQ3g==
X-Gm-Message-State: AOJu0YwOlMKTA2LtHdBLFhKMQUw6OmQPsquGwggIvnfRA1u7LB56pQuK
        BJM1KVWV53sJeA9e/b9kp+2ZSA==
X-Google-Smtp-Source: AGHT+IEHX75CQrrE1AAOHnqkbOnbbTtmku7y2INZej13eNL87gyTFaPI5KTEJpDz3xLYzWLGvD/1wg==
X-Received: by 2002:a17:906:dace:b0:9c3:730e:6947 with SMTP id xi14-20020a170906dace00b009c3730e6947mr11584331ejb.41.1698216640370;
        Tue, 24 Oct 2023 23:50:40 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id s18-20020a1709060d7200b009cd52d08563sm678032ejh.223.2023.10.24.23.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 23:50:40 -0700 (PDT)
Date:   Wed, 25 Oct 2023 08:50:33 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
Message-ID: <20231025-d21b7077ff99828bef7cfaa8@orel>
References: <20231024132655.730417-1-cleger@rivosinc.com>
 <20231024132655.730417-3-cleger@rivosinc.com>
 <20231024-e122c317599cd4c6db53c015@orel>
 <da308888-0e47-4ca4-b318-8f089421dc0b@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da308888-0e47-4ca4-b318-8f089421dc0b@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 08:03:52PM +0200, Clément Léger wrote:
> 
> 
> On 24/10/2023 17:23, Andrew Jones wrote:
> > On Tue, Oct 24, 2023 at 03:26:52PM +0200, Clément Léger wrote:
> > ...
> >> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
> >> index 09b47ebacf2e..3ab438f30d13 100644
> >> --- a/arch/riscv/lib/uaccess.S
> >> +++ b/arch/riscv/lib/uaccess.S
> >> @@ -10,8 +10,7 @@
> >>  	_asm_extable	100b, \lbl
> >>  	.endm
> >>  
> >> -ENTRY(__asm_copy_to_user)
> >> -ENTRY(__asm_copy_from_user)
> >> +SYM_FUNC_START(__asm_copy_to_user)
> >>  
> >>  	/* Enable access to user memory */
> >>  	li t6, SR_SUM
> >> @@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
> >>  	csrc CSR_STATUS, t6
> >>  	sub a0, t5, a0
> >>  	ret
> >> -ENDPROC(__asm_copy_to_user)
> >> -ENDPROC(__asm_copy_from_user)
> >> +SYM_FUNC_END(__asm_copy_to_user)
> >>  EXPORT_SYMBOL(__asm_copy_to_user)
> >> +SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)
> >>  EXPORT_SYMBOL(__asm_copy_from_user)
> > 
> > I didn't see any comment about the sharing of debug info among both the
> > from and to functions. Assuming it isn't confusing in some way, then
> 
> Hi Andrew,
> 
> I did some testing with gdb and it seems to correctly assume that
> __asm_copy_to_user maps to __asm_copy_from_user for debugging. The basic
> tests that I did (breakpoints, disasm, etc) seems to show no sign of
> problems for debugging. Were you thinking about other things specifically ?

Mostly just backtrace symbols, but I suppose we can live with it, since
it wouldn't be the only weird thing in a backtrace.

Thanks,
drew
