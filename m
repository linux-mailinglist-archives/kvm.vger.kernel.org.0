Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8826C6523
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCWKc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjCWKc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:32:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFEB1C7F5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70BDCB81EBD
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D47C433D2;
        Thu, 23 Mar 2023 10:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679567380;
        bh=fDcF61tjo8q8qHagQMk3UpbEV6iDDR23l7YEGst1DbA=;
        h=From:To:Cc:Subject:In-Reply-To:Date:From;
        b=n6QIicGg7E0gminwcg/q/adbTOOQgBbPAKLqEQ1UE71B7Wf+/FNk+s3SsPov1noLU
         9Uy5iTtQU8C11P44+jeeKePKM42eWGDr4RpOHKRsQGQsojdWnWN3IYz7r6PfM1+qKv
         U+tquSHVVsDhENd1Q1raVbXJJmRZfPXwL1k+y4eOiUQZ5L7HOmoQZ1MHh9jvxvRJVt
         0Mw5Cg3FSs6c1oG8CfdAYLbP+ZfjmFgR1xBj3iQo+Q8rbNtKHZSkcyqQ9MJUyGnqmm
         5edNc2VyVOwlys6jqtbSvmQKRqBZzhIOB/rXuvmm28o/DOM/qlZqaEkxnEDtaDugvv
         FN++C8+NMHoVA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        =?utf-8?B?Qmo=?= =?utf-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v15 10/19] riscv: Allocate user's vector context
 in the first-use trap
In-Reply-To: <20230317113538.10878-11-andy.chiu@sifive.com>
Date:   Thu, 23 Mar 2023 11:29:37 +0100
Message-ID: <87edpf4v72.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
