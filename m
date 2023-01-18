Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718BC671EA2
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjARN5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 08:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjARN4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 08:56:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6545585;
        Wed, 18 Jan 2023 05:29:36 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s67so24500374pgs.3;
        Wed, 18 Jan 2023 05:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gTmYGFbnmeCPW2MRLupoC59xlxn4uUeHuUvCevs7WXQ=;
        b=LoPo/7lV3PVsff57JQEJpECKO7OHtYeEpqPoSSe0eveZcG6SSHpoEXki47FiO72ODQ
         9ZZt/5F6kQsCqLihVB+FdfLny6Vj5ptg3ZpxgUR8EwENrhiC1eTjcwBz8z5LTOcFp8kJ
         9tAfNLTkYscnBat92aE52ShAuXt80UvvJl49DUIzSHqLlCooNR5qX4IJ7s+z7xeuXSlj
         q7Y5aIPXx//xsMJYyxMxF7Rod6afbzuR/ZQm5Wz3L8KqKer1eSGs9QRIlwQ1CQu0+clH
         KmpZqVFOAQLu0L7khPNpypmIf8IedrxMlY6ps66Mw/aoY2KMmslkXOAbkEgqbwQjIfdf
         AAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTmYGFbnmeCPW2MRLupoC59xlxn4uUeHuUvCevs7WXQ=;
        b=6zJIjqhpa200WqkfkzPMmkHx51QmTxetEidV/h80s7fkx/dlaxTT+V1g/FemWkcC3A
         6LaVMj4bCcIa7qXITRgU4oiQG5VXROPLDVztfjo4eIujXoLBiaFn2NKv51GEUbzXJeDz
         y/U8Ye8NaVyqNYxMTH0CJgeBFAnisDoEdh438LDqLVaYV6/nG+NyfwJGjluRbgN2h55Y
         YlCObTML3I1eRYaWv/2CvEoLBVcgD0ZOZo08az9oYQ55fCP/b5cF1vRYxIK3C3jj+Spj
         NKVIu5ZzB5yPv1kqfhLwEbBw3zMv4o7rCT2AadyaEDReYceSGhWmPZjXcgi5zphHKnUi
         YE3g==
X-Gm-Message-State: AFqh2kqg48YHPMJOqakLGZdwvEwBpJr5g33r7u50ZRw/Oewvr7cwi/QG
        4RQnExdJtIc+3TBWcM0iQH4=
X-Google-Smtp-Source: AMrXdXuJ4kYwmUS7FBqtPHfOWARPBImPQnR96jC4mCyWO6yH20jWVO7kWwYw8p3vX2v6A+wHIcqxFA==
X-Received: by 2002:a62:52c5:0:b0:585:fc75:c544 with SMTP id g188-20020a6252c5000000b00585fc75c544mr7440591pfb.15.1674048576348;
        Wed, 18 Jan 2023 05:29:36 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id w125-20020a626283000000b005815a371177sm21362735pfb.52.2023.01.18.05.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 05:29:35 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 3C538104E09; Wed, 18 Jan 2023 20:29:32 +0700 (WIB)
Date:   Wed, 18 Jan 2023 20:29:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
Subject: Re: [v3 1/6] KVM: arm64: Document PV-lock interface
Message-ID: <Y8f0Oz2W9QevuZJM@debian.me>
References: <20230117102930.1053337-1-usama.arif@bytedance.com>
 <20230117102930.1053337-2-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LKnbaJbZgtLjGMWc"
Content-Disposition: inline
In-Reply-To: <20230117102930.1053337-2-usama.arif@bytedance.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LKnbaJbZgtLjGMWc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2023 at 10:29:25AM +0000, Usama Arif wrote:
> Introduce a paravirtualization interface for KVM/arm64 to obtain whether
> the VCPU is currently running or not.
>=20
> The PV lock structure of the guest is allocated by user space.
>=20
> A hypercall interface is provided for the guest to interrogate the
> location of the shared memory structures.
>=20

The doc LGTM, thanks.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--LKnbaJbZgtLjGMWc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8f0NQAKCRD2uYlJVVFO
o4qgAQDcP0rNaydRQo4231hMi0Vw3TckZruhUL6c4YQM/lptNAD/dTmwvHDvLrPL
bQ8mmtSifTbeLABeqIK776M+1x9SLgo=
=hq72
-----END PGP SIGNATURE-----

--LKnbaJbZgtLjGMWc--
