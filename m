Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CEB6E08EE
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDMId1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDMId0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:33:26 -0400
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F3810E5;
        Thu, 13 Apr 2023 01:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1681374801;
        bh=SD8a8KFvnCSwbVV6zTztQabyB1P9t20ITTiwlQmT/kI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mMPkg7kd9d75I9RqubzvixZuTjV6gCBc24cVfdissGsaD546SzMl6lHKKk97MVXY5
         arvvJFZE2+2piTELSwG6ZBV1DkuEVUCc2DKc0j+J9gj7LBWUK6Z8sGFRvYUzstmWX3
         d+Vs220AH4XoU20omhJFRsciXnyPUKhuCS76xOX0=
Received: from [192.168.124.11] (unknown [113.140.11.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 772AE65C44;
        Thu, 13 Apr 2023 04:33:18 -0400 (EDT)
Message-ID: <ee3b287c78d9fbbbc996a787053b4c37fe365c2c.camel@xry111.site>
Subject: Re: [PATCH v6 29/30] LoongArch: KVM: Enable kvm config and add the
 makefile
From:   Xi Ruoyao <xry111@xry111.site>
To:     kernel test robot <lkp@intel.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Date:   Thu, 13 Apr 2023 16:33:10 +0800
In-Reply-To: <202304131526.iXfLaVZc-lkp@intel.com>
References: <20230412083023.1693910-30-zhaotianrui@loongson.cn>
         <202304131526.iXfLaVZc-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.0 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-04-13 at 15:32 +0800, kernel test robot wrote:

> vim +/asm +244 arch/loongarch/include/asm/loongarch.h
>=20
> f2ac457a61389b Huacai Chen=C2=A0 2022-05-31=C2=A0 238=C2=A0=20
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 239=C2=A0 /* GCSR */
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 240=C2=A0 static inline u64 =
gcsr_read(u32 reg)

Try __always_inline instead of inline because this "function" will
definitely break up if it's not inlined.

And I guess we should have something like:

extern u64 __compiletime_error("gcsr_read parameter is not a constant")=20
__gcsr_read_non_const(void);

static __always_inline u64 gcsr_read(u32 reg)
{
	u64 val =3D 0;

	if (!__builtin_constant_p(reg))
		return __gcsr_read_non_const();

	asm volatile (
... ...

Or perhaps we should just rewrite gcsr_read to a macro.

> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 241=C2=A0 {
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 242=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0u64 val =3D 0;
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 243=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0/* Instructions will be available in binutils later */
> 2c87b678639d25 Tianrui Zhao 2023-04-12 @244=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
asm volatile (
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 245=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"parse_r __reg, %[val=
]\n\t"
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 246=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 247=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * read val from gues=
t csr register %[reg]
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 248=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * gcsrrd %[val], %[r=
eg]
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 249=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 250=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0".word 0x5 << 24 | %[=
reg] << 10 | 0 << 5 | __reg\n\t"
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 251=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0: [val] "+r" (val)
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 252=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0: [reg] "i" (reg)
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 253=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0: "memory");
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 254=C2=A0=20
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 255=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0return val;
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 256=C2=A0 }
> 2c87b678639d25 Tianrui Zhao 2023-04-12=C2=A0 257=C2=A0=20
>=20

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
