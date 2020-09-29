Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFA827BF56
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgI2I1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2I1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 04:27:06 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2670C061755
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 01:27:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so4290688wrl.12
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 01:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=udwDCy4e/wlnFSgHZcCkMVFIs67+GyghU51aCG4MaMk=;
        b=JKHB031wJh7fLdCZmYKFIwfyEOE8tX+tkUOKw3VBMxu+ul0d0+JGnRPGT/4uQ0Qj3C
         fBTp78ympf7PA5yXA8YacDXHWaLd09Sh1XKH6qaLnltIHhbtCyvZgjthMcSPfkKHCwHD
         b1MVUGx0K4s1lAvC/djVLknOjn/nkA6h9TzzrSgt4Gj/cjxpZgR55jliIeY2+gWeeI9s
         dp51JOi097XaVJNBgavxE2bOSmgl6rN5Mz4JHBr4yegctfCR8yY3Yz0VJRngSM+xmKtV
         vVaxx5AY8Re75rpsq5/i0GOY+JXD1Nj2Eww/NXRVDE5Jv+QN06Ddd8b/6dPTgtPWBowW
         MAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=udwDCy4e/wlnFSgHZcCkMVFIs67+GyghU51aCG4MaMk=;
        b=pG7+3oUvkTa6/a1yExxdwVZqJQsklJtm27kU+Nq5o7PQmfnh6knNWkwNHJ6Ez3eAX/
         FwAsLrdPsLV63JxshxT9jte1dwvfa9J3a2EB5wH9oIobBzPznOqa9PDLHfKpUwpEOwLa
         Q5vDNDHoEZwtAj+3KsYMCbBlSQI7KvIrbFg/6nk01Mg4mCIYfgWWCLsURb1dT5+2Kzco
         MSvR6X6AJmAQsvFZ9l1Vds4VFb8FB6OsahNS+VD1LaS3ojAdPv9LKJtxp0nLs/2DOs+Z
         ZZRmY6zq/k91LRZnWNxKA1u8owmL8OwBKL/6TDMSjqjxCfFLf4LAPtdP1Jnnm0xdNf7h
         +u1A==
X-Gm-Message-State: AOAM530sayzLdwVn+Me8Hy7V/7QXUoJc5szIBP+OO3yT3YWxn7MFXsUv
        nJSskx/KiktvlqYKrYbXA4U=
X-Google-Smtp-Source: ABdhPJzEWMGpXR0C6BuQC9ijtnYHf2XlO/qAHDRdEO5knC9aoHHNHh0eD22HwwdszJ/DrkLZPgiMNQ==
X-Received: by 2002:adf:df87:: with SMTP id z7mr2951511wrl.239.1601368024443;
        Tue, 29 Sep 2020 01:27:04 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id a15sm5047282wrn.3.2020.09.29.01.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:27:03 -0700 (PDT)
Date:   Tue, 29 Sep 2020 09:27:02 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com,
        Zhengxiao.zx@alibaba-inc.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yan.y.zhao@intel.com, kvm@vger.kernel.org,
        eskultet@redhat.com, ziye.yang@intel.com, qemu-devel@nongnu.org,
        cohuck@redhat.com, shuangtai.tst@alibaba-inc.com,
        dgilbert@redhat.com, zhi.a.wang@intel.com, mlevitsk@redhat.com,
        pasic@linux.ibm.com, aik@ozlabs.ru, eauger@redhat.com,
        felipe@nutanix.com, jonathan.davies@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com
Subject: Re: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200929082702.GA181243@stefanha-x1.localdomain>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2020 at 02:00:46AM +0530, Kirti Wankhede wrote:
> * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
>   respect to IOMMU container rather than per device. All pages pinned by
>   vendor driver through vfio_pin_pages external API has to be marked as
>   dirty during  migration. When IOMMU capable device is present in the
>   container and all pages are pinned and mapped, then all pages are marked
>   dirty.

=46rom what I can tell only the iommu participates in dirty page tracking.
This places the responsibility for dirty page tracking on IOMMUs. My
understanding is that support for dirty page tracking is currently not
available in IOMMUs.

Can a PCI device implement its own DMA dirty log and let an mdev driver
implement the dirty page tracking using this mechanism? That way we
don't need to treat all pinned pages as dirty all the time.

Stefan

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9y79UACgkQnKSrs4Gr
c8jVhwgAjiypvmL7JOtUmRv3GKhQ2tIewJV7/79aGG4hTvP6divYUzMs6Aqp1hKt
kqtLl2kHVoINotaX5w03iDjJnUZ7IMLUGoEG3bzs16DhEB9AYj6kTxxsWjZJHUdZ
nIHobpDgHNYUvhFh7UYVPyiAxLyXUuZJgKtL8UsK9A8WiSM/0AgIhs8tDgW6KVMN
9AVuTGllSV0/TXjxKI7e/9ZhH/u3zIFDEty3rApcGp8r5W9QYB8+S4j5NzBFsruo
zp6Ya+Dwm4rAon2DEN0oM2b+Uupb4RgCIbIaEIlsrtTFQ3+QJSUCBCVbKMKMBKpW
Bgn+A8mXCIexbP/D1tcUrCVtv6vsiw==
=BaMB
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
