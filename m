Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8CB59F2B1
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 06:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiHXEeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 00:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiHXEeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 00:34:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246D44E636;
        Tue, 23 Aug 2022 21:34:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so14017707pgs.3;
        Tue, 23 Aug 2022 21:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5lmhx1choShnek6ylGDa96lcrlcyc9d0MBUwzbOMyng=;
        b=ZeZJzuIrL/PwTGNR180LzSv0/AaFHeZ7oNXF9/4hzdTdyBuUoie7UAsJdP/Qj6S4ZE
         ytMZFs9Dldfs/MEbE4uWCmff7jqdfeqDaDWMlExeaL2htM/Hm25ixiVjjAD70Mcr5GFD
         1JkkNW9xb2kKECFxI23Es5wmKYvx4D/KTBzbDtJerUbT/bEv5B1Uh9JteTnz7vFuH6wW
         Nl42xqyN9vEFh+Pb0SO6YJLHFTOOPCimnmXzoCcqem2IbO55LphiYgqm8QkfjOdHwYVY
         I3zNyKL8ykeINIZXHLUHf7bnWNjO+Wig/4XljhgYB8wlZVzoX1fnm2NewK7de0rpqA1E
         QJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5lmhx1choShnek6ylGDa96lcrlcyc9d0MBUwzbOMyng=;
        b=e842t3rhAYd7cWy4PJpOCCZuoLbPbb5vIB8nvk1ngKBgwSwaeYzpDbTjVtHJI7o1fl
         wdowEqhScxKbx3EQfx6afdzdbrSwhEXAevpDUOvb4hcPB9tVUAcFX2cigprLE4KXa/9y
         9L95Gl5DgA4a9SK/YEQbzFfT/mpfi2kNzSxeMpKTop3MLlYcPH09usrz2oH5wjBwGFe2
         vuwgnotJSqHxNFBy7TsO/8lp/FWlLagOvSxFQLRiIStmOpvlQZgxEQAVrjBq+0duSxT+
         xM9fJK17Cx+23sZsAGYYb6PRv0jpa3dNjWtsRTs+0GGXeSJQN1mC96bmjKajoH74Ztam
         Femw==
X-Gm-Message-State: ACgBeo05sTSQ9qcuftNWVvJ9atfNdXVZsMTb6JkJD2QIGrc7dHHvVDmw
        z6Z9lu0dcRqAuGFKXmpNjooVWVQIGtWIaQ==
X-Google-Smtp-Source: AA6agR5ZRN/Qzv0T2OCUtruTxs/rk6mTiBTX0WpP68KwDRaVLGKA+8DBf/4UtkvhoUyr+yERe6/cSA==
X-Received: by 2002:a63:ff24:0:b0:42a:20e7:99a5 with SMTP id k36-20020a63ff24000000b0042a20e799a5mr21059268pgi.261.1661315643699;
        Tue, 23 Aug 2022 21:34:03 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902dac500b0017154ae6265sm11535572plx.211.2022.08.23.21.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 21:34:02 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 09A05103D8E; Wed, 24 Aug 2022 11:33:58 +0700 (WIB)
Date:   Wed, 24 Aug 2022 11:33:58 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, corbet@lwn.net, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation/x86: Add the AMX enabling example
Message-ID: <YwWqNotXp2LXH0Dx@debian.me>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="shosNBwKqU4RfQfH"
Content-Disposition: inline
In-Reply-To: <20220616212210.3182-2-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--shosNBwKqU4RfQfH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 16, 2022 at 02:22:09PM -0700, Chang S. Bae wrote:=20
> +  1. **Check the feature availability**. AMX_TILE is enumerated in CPUID
> +     leaf 7, sub-leaf 0, bit 24 of EDX. If available, ``/proc/cpuinfo``
> +     shows ``amx_tile`` in the flag entry of the CPUs.  Given that, the
> +     kernel may have set XSTATE component 18 in the XCR0 register. But a
> +     user needs to ensure the kernel support via the ARCH_GET_XCOMP_SUPP
> +     option::
> +
> +        #include <asm/prctl.h>
> +        #include <sys/syscall.h>
> +	#include <stdio.h>
> +        #include <unistd.h>
> +
> +        #define ARCH_GET_XCOMP_SUPP  0x1021
> +
> +        #define XFEATURE_XTILECFG    17
> +        #define XFEATURE_XTILEDATA   18
> +        #define XFEATURE_MASK_XTILE ((1 << XFEATURE_XTILECFG) | (1 << XF=
EATURE_XFILEDATA))
> +
> +        unsigned long features;
> +        long rc;
> +
> +        ...
> +
> +        rc =3D syscall(SYS_arch_prctl, ARCH_GET_XCOMP_SUPP, &features);
> +
> +        if (!rc && features & XFEATURE_MASK_XTILE =3D=3D XFEATURE_MASK_X=
TILE)
> +            printf("AMX is available.\n");
> +

nit: stdio include line isn't aligned with the rest of code.

Otherwise LGTM (no new warnings).

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--shosNBwKqU4RfQfH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYwWqMwAKCRD2uYlJVVFO
o5gfAQDFGMfjHw0hS1MOP5RO2eq7A/WccU3VanEOM9WnnDwg6wEA8ZJFliETNA19
ot9sN26UxpKA5lylzcSD4VpBvZs32gY=
=SGaz
-----END PGP SIGNATURE-----

--shosNBwKqU4RfQfH--
