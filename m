Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9896D68EB
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjDDQb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbjDDQb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:31:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34926449C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:31:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l12so33434762wrm.10
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680625911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nWfv0RYKjPE6ILniOXyfBwX408cO5MlZVjVqu1n4tX0=;
        b=gm6N3McuZafztBRpXbRs/EtWofSB3kteTecmmRGTGY+mg3PO3rycfsnfCepxBdvE1X
         CA5oTDMx7cB9LPbH46uuSVfemJ9TixIn9B9UWz9Bs9tZnhZfBCZAe4wCRIs3KoL86jBU
         7WYugu8GFmQPMm0TPTK1qUCOXVprJyxPc4MkJyRJ42s+0YKCVrpFsh9TgAlpBG4NvO+t
         ALir0xzrye7Fv5xG4El0PCQDewrAqZ/zuZ1LU47SJFC3C/FGW1bjsuEBqFNeWjvYISm6
         hD8UXZk5iori2YiLYozpCToFjFPHX0wCAttrxtOYZ8i03vElaMGoeYb021+GOtGkkALx
         dBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680625911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWfv0RYKjPE6ILniOXyfBwX408cO5MlZVjVqu1n4tX0=;
        b=z/1WdbgtY6TKMwcm2c0udvCzBCNKriAMKpTPXMKiKnL8xY6WvJW7oZ0xmliNVGHoL2
         c1rsNjpNIz+SIhjbmSQt/tj1Y0tdOP6nUHBssLhi/li6e+cnak9DseSHy/eo4FQt2VaQ
         WYBN6NRMXOpKYTXThLHgcTak5/6ZZDNS8mU1hT6lgklpZCOzLnugiukdIvRBnYF+EVSx
         yDIEagProgHaHy2EFqxEh6UBElqgRfVwCuW404/d70SsLYr0t5K822FK9q6CUU5xI7wh
         2ao91p0bEI/WMZ6OZ7aVimdPnF+tAVgoKh3V604KASQ3lv+HsSuyQxIrPqxKieQOZVY3
         zoVQ==
X-Gm-Message-State: AAQBX9chNLUZH7JExZ7/HQyRI/AUc6S7bw1flKBmTDG7nV+kQAX7XFrw
        i/AxIrO5tlclCMTu4mO6HvDKTA==
X-Google-Smtp-Source: AKy350aiLZ902xG3dAVk/EXrQHSxt8nzwRy0ZUODd4WkgfRlIS16RUPDwFhtYw3lILRXUt83CfLWMg==
X-Received: by 2002:a5d:4a4a:0:b0:2ce:aed5:7dc with SMTP id v10-20020a5d4a4a000000b002ceaed507dcmr2109083wrs.68.1680625911057;
        Tue, 04 Apr 2023 09:31:51 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p1-20020a5d68c1000000b002c59f18674asm12741037wrw.22.2023.04.04.09.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:31:50 -0700 (PDT)
Date:   Tue, 4 Apr 2023 18:31:49 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 9/9] RISC-V: KVM: Implement guest external interrupt
 line management
Message-ID: <buomdae5cjxjctzleywsjqejf2k3d3zuwqi7zyrjq4fc2xzng5@mdxdojrdkm4j>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
 <20230404153452.2405681-10-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404153452.2405681-10-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:04:52PM +0530, Anup Patel wrote:
> The RISC-V host will have one guest external interrupt line for each
> VS-level IMSICs associated with a HART. The guest external interrupt
> lines are per-HART resources and hypervisor can use HGEIE, HGEIP, and
> HIE CSRs to manage these guest external interrupt lines.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h |  10 ++
>  arch/riscv/kvm/aia.c             | 239 +++++++++++++++++++++++++++++++
>  arch/riscv/kvm/main.c            |   3 +-
>  arch/riscv/kvm/vcpu.c            |   2 +
>  4 files changed, 253 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
