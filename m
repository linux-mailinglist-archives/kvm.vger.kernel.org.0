Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC034665D60
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 15:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbjAKOMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 09:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjAKOMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 09:12:39 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651D5624C
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 06:12:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id e3so5935248wru.13
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 06:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aXt4s2lip+WA/lmUg4T5cJqMM6VlHjVoPy2O6/n25ds=;
        b=owT5Z7YsSyvfkk7SD7GhDMameVdIh1ypm2zj/GA3jXJb+LOitrJuC4Ov5VDYJGa2MD
         34NiU/BYRVlU9w/pA+AlPEU7FcK/z0WTvFYxvsIqozVzAp/uIoDzpwzvPkjIyMmLdTgC
         2wX1PdfP2vg7wLHUcgMyRDb9cdysZ84IST1ET7Dzd64zYIEgidCgF6hqJyItyaHUMU9O
         K3mfY2hx7xApx07Hp2WO945MYfaWodKR03UbBPkaF1Qwn5/YJqNU14zGm20G8hxEcoYC
         p1xeYsChi+DdE/pve3GDeIW310+PkM/qhL3CHDfBtGAInDI/uaHxEWePqbKAU9cVDLI7
         xuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXt4s2lip+WA/lmUg4T5cJqMM6VlHjVoPy2O6/n25ds=;
        b=eJQrq4m9OLkNmmBgEeZcNGDvpObPmWxNShDlnqMXlWvCbPWs41w+gph3dgLwedDGd3
         sWq8pIiNwzvQawSfGuE97jSWT+fT+y8c4TOs5dM8Bw4f9dVHR3f8uJqvUJxWYDLFN6AO
         /fcyfYc6QdafAojlRzKw7qcLOQ2dKX4WKuXhaI3kHxaHNKJNE1H5J1/lpkHcmWgBHAv7
         JoLrKmy5kuMj2Ne4v22agpwnjKsBdWsBlv7d5qhGsC4gR+eMLpfgvSlL+CqzmOHhLrjP
         bUjMZIul2lqrPYqlcKNp449nZlaGt+ZuAMS8BACoYl1KmSthhLVcJbaUf/H8bfkm3qtX
         1aTw==
X-Gm-Message-State: AFqh2koJ22DkiE56RTkFiTcH6QNOoMoCuQaLl8Ikt93lQuzh6zedoSy0
        Bx3KGmCmwMkcGrz7lcL5nLa9/Q==
X-Google-Smtp-Source: AMrXdXsxKFj7ZVc3xTe+S4UTkutbibA2rD1cSKyHd0bYG1cVbu9ZIHYY5v8GsFOu+jJHXX5CTsVMrA==
X-Received: by 2002:adf:f20a:0:b0:2ba:bd95:e3af with SMTP id p10-20020adff20a000000b002babd95e3afmr12695642wro.47.1673446345000;
        Wed, 11 Jan 2023 06:12:25 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id k9-20020adfd229000000b002bdbef07f7csm2867288wrh.50.2023.01.11.06.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 06:12:24 -0800 (PST)
Date:   Wed, 11 Jan 2023 15:12:23 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 10/13] riscv: alternative: patch alternatives in the
 vDSO
Message-ID: <20230111141223.mib46x54au3n7xpq@orel>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-11-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-11-jszhang@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 01:46:29AM +0800, Jisheng Zhang wrote:
> Make it possible to use alternatives in the vDSO, so that better
> implementations can be used if possible.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/vdso.h     |  4 ++++
>  arch/riscv/kernel/alternative.c   | 25 +++++++++++++++++++++++++
>  arch/riscv/kernel/vdso.c          |  5 -----
>  arch/riscv/kernel/vdso/vdso.lds.S |  7 +++++++
>  4 files changed, 36 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
