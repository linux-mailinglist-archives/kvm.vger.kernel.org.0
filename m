Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C663B96B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 06:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiK2FV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 00:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiK2FVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 00:21:43 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EF451C0E
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:21:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id x5so20321888wrt.7
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYIgS9wavWTQxom2MJ9tshe8CLRx28IqX95DlGjmTVU=;
        b=ILN9ASxgD5Mclt1SjFrHgHV0dysZ0WP+PKmni3yTjqjyFxE0exN5YRpwgFxlZ1oTNG
         hVfSKHaheY5vLb6XcwCwK/H6E+uwyRbr8vyMHi+hvpv8kc15wr2px1OCot+8lI6Q4CuC
         6LbgxuVGKU7GDlGfhOflU32KTb148z6NX80x5fUZFR/m3lXUZ0mG3KEKF9VcnfVl9HW7
         aEK3IrDJao01snfQFniBjN9fLFKaTHdnkQhP75BYrWvmKNlwUEowGaC/+2Y0O9TPCMex
         FyAh6tt3mA1h06C3tVowOagZ6AZ69wqkCprBkG6WRp9DOxZZOMLD0MEVZZOcO4qeQlsp
         NP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYIgS9wavWTQxom2MJ9tshe8CLRx28IqX95DlGjmTVU=;
        b=5E0RiY3mEShOX/p2ww9Y33hbGrC7747WiJbloa4xDIovGonRo9+cmg3fJMbgZZA402
         7bUCAbE4keFW2nc4dn61IRWl0ZAFSlAx1VM89ZGfAWVaKJcqbtMoJL98z2xqWW9+bGys
         kmVqgVxq6THeWBpWvIugFQs0hLnKkPvEhLKn8wbnVRM8uDqSCpiFuxXeN25xKo+73c5/
         1vpiz/9LgFG/+4MSBiaLzFveegTJjvyQ3k0xtOXRe0aPwjAVm8zWVmw4sI2Puela/PMt
         HWIz/cHIvEfNVSpEcSPrPx7Sp1d1Vl+1aJQrtJFZLhkp7kXS2bh3OAkPSzBNLul8+pB7
         JO3g==
X-Gm-Message-State: ANoB5pl82RQUeTebj7+uuEEAkDwbOQClghfncpFEz/ZX1lrkpg6mq8cc
        404jzcpJ+iEvVwUGyYv0/RWwRA==
X-Google-Smtp-Source: AA0mqf5RAQI+qSWpaCf/qgkdVGaOnsgmv73eZHpMRbLqpYhxE+0JzBIjypWTrIlCw7OVJQtx5MZ9Yg==
X-Received: by 2002:a5d:4e4f:0:b0:242:1a8b:98b7 with SMTP id r15-20020a5d4e4f000000b002421a8b98b7mr4282228wrt.699.1669699301144;
        Mon, 28 Nov 2022 21:21:41 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id y14-20020adff14e000000b00226dba960b4sm12733162wro.3.2022.11.28.21.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:21:40 -0800 (PST)
Date:   Tue, 29 Nov 2022 06:21:39 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] RISC-V: Export sbi_get_mvendorid() and friends
Message-ID: <20221129052139.t7txrey3u45ssl2u@kamzik>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
 <20221128161424.608889-7-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128161424.608889-7-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 09:44:21PM +0530, Anup Patel wrote:
> The sbi_get_mvendorid(), sbi_get_marchid(), and sbi_get_mimpid()
> can be used by KVM module so let us export these functions.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kernel/sbi.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
