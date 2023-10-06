Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703FB7BB679
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 13:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjJFLdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 07:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjJFLdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 07:33:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E6D83
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 04:33:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83086C433C7;
        Fri,  6 Oct 2023 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696592033;
        bh=Wmpj47eWouOy0s3yGBvFb02dB4bwUEGYO5sCAS2bLU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmMjlVvgMoMeEf5Y6WeYQoxMj/XfnZ0MtZQzru6bWszmCBvN6FDBkqIQaB6XwhJJL
         uCZ6k3K/RvizdaTiSNwPcRd37P/OnUFapLcLtdhkkFJAiH1qpRUHpB8aSkU0pzrKNX
         VmcOnAssCNYQoG0PfIO61vPnvfX9+3LVymoGqL4VZUtJGwdgtUVxB6TsLYq6PTBBOK
         p6JtdB2PreMA76Nq6+4T+0gqptSckEl8MQuqDYR3inpQz401Xq455AkLLh+Wk8US51
         Eqi1TJYROcYzZKWk4nxbb86kOZQcBKEPEm6DhWsDzC6NdBg2P3iPGJ54WKL0khwMIM
         JDdi+GUUeqJ4A==
Date:   Fri, 6 Oct 2023 12:33:48 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/2] tools: arm64: Add a copy of sysreg-defs.h generated
 from the kernel
Message-ID: <ec96d303-f0c4-470c-b23c-e59054c52008@sirena.org.uk>
References: <20231005180325.525236-1-oliver.upton@linux.dev>
 <20231005180325.525236-2-oliver.upton@linux.dev>
 <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
 <ZR_SLyTfkhmdZoXI@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9m+I37GxfCApkzWQ"
Content-Disposition: inline
In-Reply-To: <ZR_SLyTfkhmdZoXI@linux.dev>
X-Cookie: Rome wasn't burnt in a day.
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9m+I37GxfCApkzWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2023 at 09:23:59AM +0000, Oliver Upton wrote:
> On Fri, Oct 06, 2023 at 01:23:08AM +0100, Mark Brown wrote:

> > That said I'm not 100% clear why this isn't being added to "make
> > headers" and/or the perf build stuff?

> Isn't 'make headers' just for UAPI headers though? Also, perf is just an

Possibly, I didn't look closely.  It'd certainly be more tasteful.

> incidental user of this via cputype.h, KVM selftests is what's taking
> the direct dependency.

If perf doesn't care perhaps just restructure things so it doesn't pull
it in and do whatever you were doing originally then?

> > Surely if perf is happy to peer into the main kernel source it could
> > just as well do the generation as part of the build?  There's no great
> > obstacle to having a target which runs the generation script that I
> > can see.

> That'd be less than ideal, IMO. tools maintaining a separate set of kernel
> headers from the authoritative source avoids the need to coordinate
> changes across kernel and tools. To keep things that way we either need
> to copy the script+encoding or the header output. The latter isn't that
> bothersome if/when we need an update.

The error Stephen found was:

| In file included from util/../../arch/arm64/include/asm/cputype.h:201,
|                  from util/arm-spe.c:37:
| tools/arch/arm64/include/asm/sysreg.h:132:10: fatal error: asm/sysreg-defs.h: No such file or directory

so that's already happening - see perf's arm-spe.c.  You could also fix
perf by avoiding spelunking in the main kernel source like it's
currently doing.

--9m+I37GxfCApkzWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUf8JsACgkQJNaLcl1U
h9D43gf+KthLRpX4SbHMrpSO1jtnzw/gUASBohZj6copHrQmZDwZhbuFi0Sj8VWd
Fao7nKtMwboFJ94TSh/xvYx9o5m63MUYzsVJBQdFlHRnsENznHX8d9E0Ve0B2xK+
51RAPNNBv7FYsGIRR/kU8/Y5WBpCOeKhJ4fQ0WxQXTmAYD+/4IixdFJaEmY3i+H7
gF+5Pd1RghykREOtqdciakEBTzQ2pCuxvAS2emvyWrlNjK2JEb7T8DdulwWhC9nq
4t53fZ0J+ByIDkW8Dne74XvFU9Ws+brhni1iynySWo7BmqKgHFpXV4CaeN1bEEpK
lVtS3LAXzwdCHuB573s8cYJu4DefUw==
=yH5q
-----END PGP SIGNATURE-----

--9m+I37GxfCApkzWQ--
