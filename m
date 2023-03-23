Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B57E6C64C1
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCWKXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjCWKXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B17C272D
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F9D7625B8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19965C4339B;
        Thu, 23 Mar 2023 10:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679567021;
        bh=+pnutHbgPZ/gsCS7OxYK0FsgMPJ0cSQbPnMM0pRkjSk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Yk6QASA9PUP1MTPJaXTYUMe5W+wOgsu370892y+k0ZgVc9h6CvOxLdz3nMR/hkwnU
         D/3lF/ZZKJPiVxtCKXr5MGUvVESG8IMHSQ4Lc2GC9zTPn0mTO+ucGBDA/dVtbbXVwP
         QF4/IiyygNzAhSM4JEweGU1tB7cPSccz2CLRktTLkPsoVtRHTJj/nxhYzmlE+9ifff
         xJB9KlbN5PfCCeyg6/clK582c/nB8w2ylXcbgVzuCBFZ1m7qAc+BY6hYruYHbzT/ts
         VlZ69Sv44rUOKlxjRWe5o10Gm7ULkj+3R3O2OUpa3xAfdCyIHDYHBTSy94WFz5Yc+S
         DzkdFU1+oyVJg==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Jisheng Zhang <jszhang@kernel.org>,
        Nick Knight <nick.knight@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>, vineetg@rivosinc.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, Dmitry Vyukov <dvyukov@google.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH -next v15 09/19] riscv: Add task switch support for vector
In-Reply-To: <20230317113538.10878-10-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-10-andy.chiu@sifive.com>
Date:   Thu, 23 Mar 2023 11:23:39 +0100
Message-ID: <87355vwytw.fsf@all.your.base.are.belong.to.us>
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
> This patch adds task switch support for vector. It also supports all
> lengths of vlen.
>
> Suggested-by: Andrew Waterman <andrew@sifive.com>
> Co-developed-by: Nick Knight <nick.knight@sifive.com>
> Signed-off-by: Nick Knight <nick.knight@sifive.com>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
