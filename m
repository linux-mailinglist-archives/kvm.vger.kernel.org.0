Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1607970DDCF
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 15:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbjEWNpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 09:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbjEWNpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 09:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C4E9
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 06:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6C0632A7
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 13:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543C7C4339C;
        Tue, 23 May 2023 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684849542;
        bh=ETJcP1r57z0YzI21dRpkzECXtCN17+uNlMT7Hv4M6F8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=f923UW09WKDPNspjcv5xj7oJnXWo210SE3L1Aem6JnPzcyiaDY7Fd6uW7ERkCz9dI
         n2nwVgfzhbsmzeG7SBeDs9cKqWZ3tB73w3umDeEGuDjqAy5857nTv3uynT4QoS/0b8
         ZLpEv/gxWDoGRunaG1K2naK2cKlt8KIzHBmLdxXI97c6mr/dU9adlQyp1s0kIp2XKS
         81Sp7pBxvUswjvdOPhs4a8Sc9pYYYTwNfbVcaY3ANdOhGvJn/4Jqughy/tmRQqU1X6
         y5C3kYiqzvhESOhhprySdZu+DzhAZ1lz1WvxxrQhWixlzPxxPaElxtTdiCvo+r1D2f
         Dxzl67BNTx83A==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: Re: [PATCH -next v20 21/26] riscv: Add sysctl to set the default
 vector rule for new processes
In-Reply-To: <20230518161949.11203-22-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
 <20230518161949.11203-22-andy.chiu@sifive.com>
Date:   Tue, 23 May 2023 15:45:40 +0200
Message-ID: <87wn0zb1q3.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> To support Vector extension, the series exports variable-length vector
> registers on the signal frame. However, this potentially breaks abi if
> processing vector registers is required in the signal handler for old
> binaries. For example, there is such need if user-level context switch
> is triggerred via signals[1].
>
> For this reason, it is best to leave a decision to distro maintainers,
> where the enablement of userspace Vector for new launching programs can
> be controlled. Developers may also need the switch to experiment with.
> The parameter is configurable through sysctl interface so a distro may
> turn off Vector early at init script if the break really happens in the
> wild.
>
> The switch will only take effects on new execve() calls once set. This
> will not effect existing processes that do not call execve(), nor
> processes which has been set with a non-default vstate_ctrl by making
> explicit PR_RISCV_V_SET_CONTROL prctl() calls.
>
> Link: https://lore.kernel.org/all/87cz4048rp.fsf@all.your.base.are.belong=
.to.us/
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
> ---
> Changelog v20:
>  - Use READ_ONCE to access riscv_v_implicit_uacc (Bj=C3=B6rn)

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
