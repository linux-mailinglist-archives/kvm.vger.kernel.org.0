Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817EB6C64B5
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCWKVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCWKVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:21:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CC7D52B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDCE4B8205B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25354C433EF;
        Thu, 23 Mar 2023 10:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679566874;
        bh=Y3UnjiHBiXxJhNV4x+zaUKIGWmEzu1W0E7t5IwjZLcw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Kg7fmjHTnzaiG4FFLThcGszSjwBn/yL+h6xQh6D4WivUS/EneZ2S5RikPQo8LufuK
         vRfSU2YPLijtps8/tA2owcnp5VM3g66SWL1tD+olt3NSwSHjtP+fUEA3A5gEmEY/sC
         Sp3NG5bMaSC6ZYH5dpRzBLZ+hKpZrQ5sFqCpcoLKDcql0Xxjpi8Cl9fbAPj5j3PTRG
         L2XQwugE81+iPiao9yw1iojapY4n49CPzbGZpVe8LGa2tWAVkci655AbCygN1WGxln
         A8mXloS3DrwCavHJ0KsqLrTr8stoweSaNyQU1uZN/4kjY11zHGoQPTWrvldOwrHsnK
         N7olz6+GoqDYA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v15 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
In-Reply-To: <20230317113538.10878-9-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-9-andy.chiu@sifive.com>
Date:   Thu, 23 Mar 2023 11:21:11 +0100
Message-ID: <877cv7wyy0.fsf@all.your.base.are.belong.to.us>
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

> From: Greentime Hu <greentime.hu@sifive.com>
>
> Add vector state context struct to be added later in thread_struct. And
> prepare low-level helper functions to save/restore vector contexts.
>
> This include Vector Regfile and CSRs holding dynamic configuration state
> (vstart, vl, vtype, vcsr). The Vec Register width could be implementation
> defined, but same for all processes, so that is saved separately.
>
> This is not yet wired into final thread_struct - will be done when
> __switch_to actually starts doing this in later patches.
>
> Given the variable (and potentially large) size of regfile, they are
> saved in dynamically allocated memory, pointed to by datap pointer in
> __riscv_v_ext_state.
>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Thank you for doing the scratch reg change!

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
