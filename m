Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA87D2F68
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjJWKDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 06:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjJWKDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 06:03:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25639188
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:03:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5406c099cebso755355a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698055425; x=1698660225; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PlK135OBaI7US5u50OHdZS8GXFt6KDacCwj3egjonHM=;
        b=CgNKtl4I2/lojJ+kk4ZOryppolfG7mH+PBf0J3EhZeBttzRbdKIJxB5TztkjdoynNR
         36j2IIp9JFKXU1Dos49f+OUz33543sA7m9atxHkX5aR7LuC2ARCQl4gORB11uFPOB97x
         S3b7s5zuM307chvKGoflpoJ3utJe6dOLGrr1cUBxOkLBSvBcrIKM2XOo0r8ePbGRi2Jk
         cF23irMiONYAKjn8gPR7nsQz6mROxULZfhIf4WittSQCN/rPxA97/FuF8o9WOQRVd99G
         lYtjzJBPHGIkDY80meTlclNpE6UGRBEHuRXNjsctm80BusIl7Aba26NBVXAL0bC6j+dm
         w/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055425; x=1698660225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlK135OBaI7US5u50OHdZS8GXFt6KDacCwj3egjonHM=;
        b=qSF+UCS/DMlYG9lZNgXcRN09TnLlaV5l6Zl6bVW5QhhH7KuVJ5yww8BrUJIYJdYMRG
         GJ0dbuaovP1z3GTMOrgpTZQswRZW1mPBU7ekGk3NLIYrMlDPMghqESud9F30P90VEuqA
         qz3riP9lrAyHZoRnHmaS6cLFG/GcYhE+gJDa6aiH4Bw4lEeFX7ICdMIw0nBtKBn47VxC
         EgTx8G4KFqwxRjy69mmIr8B6p0pxBtGwVg/a9rLYF/gC0HSLvPkrllYv1eB8OE/InrRV
         eMbH/29IXr307ChwuyB4IJj00o02ApYOIgUXyJTIzn4L0HzDHHVCdXxcvM0TGICtxRqS
         DQoA==
X-Gm-Message-State: AOJu0YwZAflxLL7qoJIa8fOdcAidqYHkiJ7I6e9jyh0lOc37ZlVAJ9vC
        EluyKdkkzm2v+qh1J9xyQuQsbA==
X-Google-Smtp-Source: AGHT+IFRfdui73pEXWIt5PF13FM7uWu3c1hEOSC66KBzZbNTtT/nXpui8/s+R6Q0DQh+G3ba6gRH+Q==
X-Received: by 2002:a05:6402:42c4:b0:540:37d6:c1f3 with SMTP id i4-20020a05640242c400b0054037d6c1f3mr3183808edc.11.1698055425598;
        Mon, 23 Oct 2023 03:03:45 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v28-20020a50d59c000000b00536159c6c45sm6147002edi.15.2023.10.23.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 03:03:45 -0700 (PDT)
Date:   Mon, 23 Oct 2023 12:03:44 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 4/5] riscv: kvm: Use SYM_*() assembly macros instead of
 deprecated ones
Message-ID: <20231023-33c38ae1672a9006fb91671b@orel>
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-5-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231004143054.482091-5-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 04:30:53PM +0200, Clément Léger wrote:
> ENTRY()/END()/WEAK() macros are deprecated and we should make use of the
> new SYM_*() macros [1] for better annotation of symbols. Replace the
> deprecated ones with the new ones and fix wrong usage of END()/ENDPROC()
> to correctly describe the symbols.
> 
> [1] https://docs.kernel.org/core-api/asm-annotations.html
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_switch.S | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
