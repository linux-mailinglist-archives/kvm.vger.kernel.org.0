Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C821D6383C1
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKYGHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKYGHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:07:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E9915737
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 22:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356463; x=1700892463;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=4psrvCjS71wn0iQw9Dg5Emm/j7CTfBIk04WUF+xAxAM=;
  b=l6RVokX4pq7nhNU+2ZL9cXUTVZpw63V8imVa02TUWoblP3ieeBKw4HoY
   LpkGR63YcvMsvPFLmIfqiRVMHu4lBHg1p0Meicwcj00Ew2uYSDOgiSBvu
   /SbSRqW9EGSjBYKnFgjrTSAMdjAOJYzRJc5KHjpnsNLYWemwHJDi3f/uo
   M6BCOZu2wWzGd1NIWzenFVA4rAhraCair6WRXlRWuVvaVe0gx65vLIxQY
   YP4nAHGFRmCekjc4/kZyCMLioM6OLrBZ8PDhT2eJ1PKz29Y9xBbpJkapX
   4vrwqbDN1Gz8LIcKQZqcC1DalxOtEpP2tlPG7Ntz07T6uQo0EeMRHKsgD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294801448"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="asc'?scan'208";a="294801448"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="705966662"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="asc'?scan'208";a="705966662"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 24 Nov 2022 22:07:39 -0800
Date:   Fri, 25 Nov 2022 14:06:37 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, alex.williamson@redhat.com, kevin.tian@intel.com,
        chao.p.peng@linux.intel.com, kvm@vger.kernel.org,
        yi.y.sun@linux.intel.com, Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to
 unmaps come before device open
Message-ID: <20221125060637.GW30028@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Content-Disposition: inline
In-Reply-To: <20221123134832.429589-1-yi.l.liu@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.11.23 05:48:30 -0800, Yi Liu wrote:
> Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode. Un=
der
> this mode, vfio_iommufd_bind() creates an access which has an unmap callb=
ack,
> which can be called immediately. This means mdev drivers may receive unmap
> requests before the mdev is opened. For now, most dma_unmap() callbacks a=
re
> tolerant with such unmap requests, except for gvt-g and vfio-ap. This ser=
ies
> tries to enhance the two drivers.
>=20
> This series is based on Jason's below branch.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=3D=
for-next
> (commit: 57f62422b6f0477afaddd2fc77a4bb9b94275f42)
>=20
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
>=20
> Regards,
> 	Yi Liu
>=20
> Matthew Rosato (1):
>   vfio/ap: validate iova during dma_unmap and trigger irq disable
>=20
> Yi Liu (1):
>   i915/gvt: Move kvmgt_protect_table_init() and gvt_cache_init() into
>     init

btw, for gvt change, pls at least add intel-gvt-dev@lists.freedesktop.org i=
n cc.

thanks

>=20
>  drivers/gpu/drm/i915/gvt/gvt.h    |  2 ++
>  drivers/gpu/drm/i915/gvt/kvmgt.c  |  7 ++-----
>  drivers/gpu/drm/i915/gvt/vgpu.c   |  2 ++
>  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
>  4 files changed, 29 insertions(+), 6 deletions(-)
>=20
> --=20
> 2.34.1
>=20

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCY4BbbQAKCRCxBBozTXgY
J6BwAJ9KiahaSgykyEtEv75aU/rh4cXj1ACfVS98XHIYzljQr40xYWu07qH640I=
=Yse0
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
