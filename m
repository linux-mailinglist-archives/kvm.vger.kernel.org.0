Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914F16C6549
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCWKjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCWKiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC62D38446
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F45625D8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BD0C4339B;
        Thu, 23 Mar 2023 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679567793;
        bh=AiS8dSPCKWDsq3eZ7fJAM1zTxXlSdU85APs6cGWwkyg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=cVnnpvtmKuYQMh/yj6cr0af33CLhHRsXcDRuRSd76QGIYurwcQUkte+v4WREomm3g
         fgQyT4SZLJzK/fs3yR/hCVZQSp0mpWLfewImPfsTHQi2vUC7ehslg9EdLZVUTyzCPg
         eB6UIuoglmfKWsIpO5pEIKYYg9YSsKRcrxLhyR3YQ98/BPWvZ+cAoCcLArSBrDqBlr
         wCKe949/sLk/kqe6uy1zAJRU1Sx8Zw4i88jGllm+5lUnPHOmw/ok8m8cSA4HTK1+aW
         tiiDVYNXWDRN8lpim397S6y/RZ8zgWOhD/unmkAik2KIQm+e54TO6LLb/xUhe7dSXk
         hZoS+1PsJhoow==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Kees Cook <keescook@chromium.org>,
        Nick Knight <nick.knight@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        vineetg@rivosinc.com, Al Viro <viro@zeniv.linux.org.uk>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, Zong Li <zong.li@sifive.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH -next v15 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
In-Reply-To: <20230317113538.10878-15-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-15-andy.chiu@sifive.com>
Date:   Thu, 23 Mar 2023 11:36:31 +0100
Message-ID: <87a6034uvk.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> From: Vincent Chen <vincent.chen@sifive.com>
>
> The vector register belongs to the signal context. They need to be stored
> and restored as entering and leaving the signal handler. According to the
> V-extension specification, the maximum length of the vector registers can
> be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
> sigframe, it may not be enough. To resolve this problem, this patch refers
> to the commit 94b07c1f8c39c
> ("arm64: signal: Report signal frame size to userspace via auxv") to enab=
le
> userspace to know the minimum required sigframe size through the auxiliary
> vector and use it to allocate enough memory for signal context.
>
> Note that auxv always reports size of the sigframe as if V exists for
> all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
> reason is that users usually reference this value to allocate an
> alternative signal stack, and the user may use V anytime. So the user
> must reserve a space for V-context in sigframe in case that the signal
> handler invokes after the kernel allocating V.
>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
