Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075917BCA97
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 02:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344220AbjJHAGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 20:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjJHAGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 20:06:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B364B6;
        Sat,  7 Oct 2023 17:06:45 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-690bd8f89baso2630852b3a.2;
        Sat, 07 Oct 2023 17:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696723604; x=1697328404; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bTUmEcdn90yDICcymw/6ZAnQy50L9PCf2cOKREv6Dxg=;
        b=foI/AKBtnOAk1LUdI7Sl7MPLCpYRdSS5meqE/VYa6BZIjKc0Deni3ev145NwVPlm2o
         MBTtT/aE25tU/KhM41MJRhwrq28uRagM/2RWDDJGL0KZ82hs6tcn2vijIcxzCnnl0kPk
         y40nByVnrBpayf0nnRLNhocJNfKS4f31ShKHiM0oq6HQiiohlJ8UlKd1n2XTVX4Qd0aT
         jk4SeP9Am34Fn/PqlGRPEXWR4Df0jbd4SnvAX3QvV00SnuKU5r6gnHKNC4pjgVXqtvkN
         eU5aEhT28hvjx05Am7Wih2ujB93XOWhlp2PR9H7f46smmQ87GDDxphf1oMuDE8NmjDs3
         onWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696723604; x=1697328404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTUmEcdn90yDICcymw/6ZAnQy50L9PCf2cOKREv6Dxg=;
        b=DS8dbe1+SevZzDIXDfHnpeeSyy0jwo+hl3DxGpO5zvQlUUxzCPvupCyipqLB7LtL3y
         h1H/oUQ0Ao8omCgaRW7blJkN4H4RbcuSmSupAU/kOuX14imZO+f1zEPas7fL1njzX5MJ
         HKqQiXLlaJALEqYlIwXVPLmuGTvzecwo6YNiOS76lAX0WtT6M50zYX9CzmBBglHWK7bE
         kpcbdyRo4dcXvNza+O+PO1lQxZKkO8wkF4X4wWNGCuXfY67ig8hVUPe2GPd3jCRMuAjh
         XKzPk9MFThb02qUg9NEtyTxPh0oKVDoZYkyMsGRoOMIenaL4rE4fU5oBATzK56QoZ9H5
         zgvg==
X-Gm-Message-State: AOJu0YzqrRyji0CSM8LKv3i0YTJ4rpzYNEQrFWjOmHPL+vQ/nr/AIDxY
        GMyBHgk0ER+wDX8zLnRdXog=
X-Google-Smtp-Source: AGHT+IFHDN5+FLcvCVs5Z8TB7ZVZRrjOERwcy9tGqSxCapxu6Q0LwtpbiHHkneqIFeyw3DFqNYBhig==
X-Received: by 2002:a17:902:ceca:b0:1c5:9c73:c91c with SMTP id d10-20020a170902ceca00b001c59c73c91cmr13506515plg.48.1696723604556;
        Sat, 07 Oct 2023 17:06:44 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c16-20020a170903235000b001c0a414695bsm6473567plh.43.2023.10.07.17.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Oct 2023 17:06:43 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4217381B5CE3; Sun,  8 Oct 2023 07:06:41 +0700 (WIB)
Date:   Sun, 8 Oct 2023 07:06:41 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
Cc:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <anuaggarwal@nvidia.com>, <dnigam@nvidia.com>, <udhoke@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <ZSHykZ2GgSn0fE_x@debian.me>
References: <20231007202254.30385-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1NNiZyyRTdcr+9q8"
Content-Disposition: inline
In-Reply-To: <20231007202254.30385-1-ankita@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1NNiZyyRTdcr+9q8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 08, 2023 at 01:52:54AM +0530, ankita@nvidia.com wrote:
> PCI BAR are aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes.
>=20

Reading garbage or padding in that case?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--1NNiZyyRTdcr+9q8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZSHykQAKCRD2uYlJVVFO
o1M2APsH03ryYg6rpO4m+TNrTVyteM4p95rY7zKYL1/IPGVsXwEAkwHm3sLwLo3c
mNHzMFH99QPPRscMn9RAbx+d0o69ZQw=
=aAng
-----END PGP SIGNATURE-----

--1NNiZyyRTdcr+9q8--
