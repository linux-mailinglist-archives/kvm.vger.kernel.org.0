Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49BB6D1645
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCaEPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 00:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCaEP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 00:15:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5168DD323;
        Thu, 30 Mar 2023 21:15:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so22083096pjz.1;
        Thu, 30 Mar 2023 21:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680236127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wwB+gbYNlN/hJQCONryj4KagzH8OwzCp7h0EU9aVCXo=;
        b=IQ5TWysAyoyV2pAdHElJDi1Dh/nE17X1VAluEvisr2b5DdP3YTiFCj0mfzL6VP3fDl
         yMhG91NdNLu78SN8X6cdG3xN2aRXdbsraAgt1YszS+LDi0i8mpJg/9mJIAU1J5YtvK+R
         TFkW/QSd8Omq3sRGqpY8PZye7KOPhTTDtUYWlncqVmstl025QYwKieWdeE9GXBOQ1HGq
         RyjM53QTSFM18rLS6ZdqyxZOqbV/C1GtxmFDjKwACXSUUn1Gz++8Y9Chd0+j0PyZ5xOJ
         HBP0zGrsTA0bcQmR/wxyKQtKfSAElXQ7IerniA4eU4wUBvJ3FCVTx6l5EgxrWVK7UWOi
         cSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680236127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwB+gbYNlN/hJQCONryj4KagzH8OwzCp7h0EU9aVCXo=;
        b=hktj2/eSz7pTs3sS0zhZ/2Ur8omtzgrHB/5/Bck2QJCtgTON59FXyLBN4xTZhI3E8A
         JTeGB79CNCz2lBTLuQzzqICXy2688RnTjOBXq1e9OCuMWigEBuR2JJhdrCA8TyO8VaPu
         CynTVcYQR5WaQWG1pmOjSUha328u2t9heB5VdtufLKoio+ktfZpcYVpUg7Z9S4K9CjSl
         649xVKQCE6aoWf+U53IveWdsvjFnuBiUxd+11Ynbj0hVXcLHzrn37fZ9owil0jXhkIsf
         DyTEfI8iWbT61iIZrDF5LGCb65QibQZn/InzevE+rEmU573zELqjqtwcjqO3P3x5nPVc
         g/WQ==
X-Gm-Message-State: AAQBX9cQFUga9CN5eR3TECxfBD5a+rOOPRavF5Ty6Q2k7zeUzOOWSXib
        FL2ilnFJCOfvnPX0JoqwcGc=
X-Google-Smtp-Source: AKy350Zfhwe3Ic2BfPr01L8tuEMFw0RJVUzUsWe0y2UFDKost6KpxREtdxFsQFqIX67SOR00+l8h0A==
X-Received: by 2002:a05:6a20:a11b:b0:e4:152:e920 with SMTP id q27-20020a056a20a11b00b000e40152e920mr3892736pzk.11.1680236126748;
        Thu, 30 Mar 2023 21:15:26 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-78.three.co.id. [180.214.233.78])
        by smtp.gmail.com with ESMTPSA id t38-20020a634466000000b00502f4c62fd3sm595886pgk.33.2023.03.30.21.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 21:15:26 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id DA0731067D9; Fri, 31 Mar 2023 11:15:22 +0700 (WIB)
Date:   Fri, 31 Mar 2023 11:15:22 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Takahiro Itazuri <itazur@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        zulinx86@gmail.com
Subject: Re: [PATCH] docs: kvm: x86: Fix a broken field list
Message-ID: <ZCZeWlhQ8GK7gYSi@debian.me>
References: <20230330233956.78246-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tdxjAvrHOWglhTOm"
Content-Disposition: inline
In-Reply-To: <20230330233956.78246-1-itazur@amazon.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--tdxjAvrHOWglhTOm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2023 at 12:39:56AM +0100, Takahiro Itazuri wrote:
> This commit adds a missing `:` to fix a broken field list.

Please don't say "This commit does foo", but rather "Do foo".
Also, add:
Fixes: ba7bb663f5547e ("KVM: x86: Provide per VM capability for disabling P=
MU virtualization")

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--tdxjAvrHOWglhTOm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCZeVwAKCRD2uYlJVVFO
o6RlAP9FwwZyvAaLbpW6snjP6yMTYA89vjLr5NDUXS66DWe32AD/W1p3wQobD7ab
P/3MrKM43jU06fP36xJBMGCX62tAewY=
=9XUK
-----END PGP SIGNATURE-----

--tdxjAvrHOWglhTOm--
