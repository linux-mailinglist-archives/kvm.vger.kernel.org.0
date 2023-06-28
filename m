Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427D740F0A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 12:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjF1Kmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 06:42:40 -0400
Received: from xry111.site ([89.208.246.23]:44116 "EHLO xry111.site"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbjF1Kka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 06:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1687948824;
        bh=j1QlM126j6MA+r/+OaAKCCpzmed3Q7diNaQnwFqIZ8U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=he8v0OYnFOPwL55tjufGR98tmw8tQQXPIdHEIUgxkSsv3f7JngrXzV1aU+i1bsw2J
         iFw/W/hTQzIIJQwMxFXpuNk9D22uydpV2stSa1vQUA2L+oMLFWkCKDo25UoMgrjiLz
         hh5nGrEcl5FwV7L/20/wRImVTklBVOpe9UIkxR9g=
Received: from [192.168.124.11] (unknown [113.140.11.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id D86A165C20;
        Wed, 28 Jun 2023 06:40:21 -0400 (EDT)
Message-ID: <74a06e8e7d0bab88892321dbdb891762487b6f6b.camel@xry111.site>
Subject: Re: [PATCH v15 27/30] LoongArch: KVM: Implement vcpu world switch
From:   Xi Ruoyao <xry111@xry111.site>
To:     WANG Xuerui <kernel@xen0n.name>, bibo mao <maobibo@loongson.cn>,
        zhaotianrui <zhaotianrui@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, tangyouling@loongson.cn
Date:   Wed, 28 Jun 2023 18:40:20 +0800
In-Reply-To: <baf5c93f-59ae-57eb-49e0-a0231dab325d@xen0n.name>
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
         <20230626084752.1138621-28-zhaotianrui@loongson.cn>
         <f648a182-7c26-5bbc-6ae5-584af26e9db1@loongson.cn>
         <7017277c-3721-b417-5215-491efae7c8a9@loongson.cn>
         <cfc87f85-3a09-8a9e-4258-4fb1fd8013ab@xen0n.name>
         <30261345-45de-8511-e285-fe16ee408ba1@loongson.cn>
         <baf5c93f-59ae-57eb-49e0-a0231dab325d@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-06-28 at 18:22 +0800, WANG Xuerui wrote:
> > is "ori t0, zero, CSR_PRMD_PIE" hard to understand? It is basic
> > arithmetic instr and easy to understand also. To be frank I do not
> > see the advantage of using li.w, also there is no document that
> > pseudo-instruction should be used with high priority.

> It depends on the reader. Sure the semantics are the same, but with "ori=
=20
> xx, zero, xx" someone's always going to wonder "why do 'x =3D 0 |=20
> something' when you can simply li.w", because even if it's easy to=20
> understand it's still an extra level of indirection.
>=20
> And I've given the historical and general software engineering=20
> perspective too; it's not something set in stone, but I'd expect general=
=20
> software development best practices and minimizing any *possible* reader=
=20
> confusion to be acceptable.

The pseudo *should* be the high priority in general.  If we don't
consider the pseudos high priority, people will start to load immediates
with "their own way", like writing "addi.w $t0, $zero, 42" or even "xori
$t0, $zero, 42" for "42".  These may puzzle the uarch, causing a
performance worse than "ori $t0, $zero, 42".  So the only rationale
things are either:

1. Telling people always use pseudos if possible.

or

2. Telling people "remember to use ori for loading small immediates, not
other instructions".

1 is obviously easier.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
