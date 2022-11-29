Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5963B96D
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 06:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiK2FWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 00:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbiK2FWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 00:22:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF9E51C14
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:22:20 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v1so20273553wrt.11
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VX+itqdtRrB43wl3kKgpncV8GANmiBc0pfcxw2yUuLM=;
        b=bG/IrQ/Jixzo6903r9hdiDVrqSlnGMjeHDlGeazVMHCkysWbRtlm/GeJRZvt+CRWWl
         W742Q2rnyombXejTvQ7gcaZl4N7K8AJXrYys3m2CHDKY6fptemRY4xey51NIYgBfdpEV
         4vXYqPl68pOufbrcBNozppHSP9Igq+6RWmLPg+0CxBAHZWzAUB9BGnkFhjQckBmRE0fw
         CL6Utxu+ZMfHuSD1H2+5WWT+UKHPolCf3993tJi6aRmXyVnK2KTCyaBiewLdCDv91Sok
         L0PSv5bAifCxKQRiSXiBTm4amKUjVcYuQ8Dh44fDHd9vmA2MtpMTZ2dZfyq3ASyXUtAN
         OJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VX+itqdtRrB43wl3kKgpncV8GANmiBc0pfcxw2yUuLM=;
        b=FVQqNz3xWVz4xF0TyUoc4MFrxBHJwY3CBP7YTWf5SiRIB/Ue6wxGcLTLsQfD+KHZCK
         tRbm2hUXk/R4PszW+tNJ6q+8eV32S0miaBTuItzIjshRsxS8b++0MxNk9kaVAzaEP7nV
         EcYC3yrqzB1Tn90ANto6PI31xgkF4reNpVKVUa/rTeM+luaMjJCzrJTx4jRW1o0clV7j
         s9pSL3k25pWWleiPrIpLuS0pJjJHhrG5mNp7yzXAYU30KGUSazaWXfGeaKaSFb8FzRcD
         Wqh+ZQ2It96/bkQ9tsiC2d9B2zEVEfmu90yJvzaMdyMyYcO0wf3SNwoLrXrDoxmmNg1Q
         gGqQ==
X-Gm-Message-State: ANoB5pmQyFbopvEsnOFK3IWPvwO7vs6KcgYAw2BW0KIU/OZpEpQrgKAt
        Gfgb7L82SMkSgW/3sK0AT2TZBg==
X-Google-Smtp-Source: AA0mqf5kd2rGATn4w0hFZs+L6eWBIfmaBzTGS2MjDUeIdf1p0JbHZPqT6eh18lSMKNcQd+csJcJ8kg==
X-Received: by 2002:adf:f244:0:b0:242:1da0:4984 with SMTP id b4-20020adff244000000b002421da04984mr3305960wrp.240.1669699338615;
        Mon, 28 Nov 2022 21:22:18 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id dn6-20020a05600c654600b003cf894dbc4fsm712294wmb.25.2022.11.28.21.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:22:18 -0800 (PST)
Date:   Tue, 29 Nov 2022 06:22:17 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] RISC-V: KVM: Save mvendorid, marchid, and mimpid
 when creating VCPU
Message-ID: <20221129052217.7rpw33yrr6i6kncx@kamzik>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
 <20221128161424.608889-8-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128161424.608889-8-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 09:44:22PM +0530, Anup Patel wrote:
> We should save VCPU mvendorid, marchid, and mimpid at the time
> of creating VCPU so that we don't have to do host SBI call every
> time Guest/VM ask for these details.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  5 +++++
>  arch/riscv/kvm/vcpu.c             |  6 ++++++
>  arch/riscv/kvm/vcpu_sbi_base.c    | 11 +++++------
>  3 files changed, 16 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
