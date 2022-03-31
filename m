Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F624ED313
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiCaEnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiCaEno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:43:44 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6496211E
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 21:41:57 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KTVyC5hnpz4xLb; Thu, 31 Mar 2022 15:41:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1648701715;
        bh=PYjTDL7MyWr9MF/EKQzb1+YssBWFGuseGQUQm0EYzOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hljvYbKRI0/OVRWMOFkiCOykYE3S+tyl0XaoxCCS0HUVMmZAgStteoI/N2F6RkOCz
         6u5B3yeo4OryUwU2LRvnrEZ/nkI+axkAaXkcPf5vuMUz4kQRA5gqiJ0osIH0qz0Gf6
         H4PL5QT/ACfEOtY74diCJImdwDVX+1QFBQ/da2ng=
Date:   Thu, 31 Mar 2022 15:36:29 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <YkUvzfHM00FEAemt@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WfdTxXupCMJl/Tke"
Content-Disposition: inline
In-Reply-To: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WfdTxXupCMJl/Tke
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 18, 2022 at 02:27:33PM -0300, Jason Gunthorpe wrote:
> Connect the IOAS to its IOCTL interface. This exposes most of the
> functionality in the io_pagetable to userspace.
>=20
> This is intended to be the core of the generic interface that IOMMUFD will
> provide. Every IOMMU driver should be able to implement an iommu_domain
> that is compatible with this generic mechanism.
>=20
> It is also designed to be easy to use for simple non virtual machine
> monitor users, like DPDK:
>  - Universal simple support for all IOMMUs (no PPC special path)
>  - An IOVA allocator that considerds the aperture and the reserved ranges
>  - io_pagetable allows any number of iommu_domains to be connected to the
>    IOAS
>=20
> Along with room in the design to add non-generic features to cater to
> specific HW functionality.


[snip]
> +/**
> + * struct iommu_ioas_alloc - ioctl(IOMMU_IOAS_ALLOC)
> + * @size: sizeof(struct iommu_ioas_alloc)
> + * @flags: Must be 0
> + * @out_ioas_id: Output IOAS ID for the allocated object
> + *
> + * Allocate an IO Address Space (IOAS) which holds an IO Virtual Address=
 (IOVA)
> + * to memory mapping.
> + */
> +struct iommu_ioas_alloc {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 out_ioas_id;
> +};
> +#define IOMMU_IOAS_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOC)
> +
> +/**
> + * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
> + * @size: sizeof(struct iommu_ioas_iova_ranges)
> + * @ioas_id: IOAS ID to read ranges from
> + * @out_num_iovas: Output total number of ranges in the IOAS
> + * @__reserved: Must be 0
> + * @out_valid_iovas: Array of valid IOVA ranges. The array length is the=
 smaller
> + *                   of out_num_iovas or the length implied by size.
> + * @out_valid_iovas.start: First IOVA in the allowed range
> + * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
> + *
> + * Query an IOAS for ranges of allowed IOVAs. Operation outside these ra=
nges is
> + * not allowed. out_num_iovas will be set to the total number of iovas
> + * and the out_valid_iovas[] will be filled in as space permits.
> + * size should include the allocated flex array.
> + */
> +struct iommu_ioas_iova_ranges {
> +	__u32 size;
> +	__u32 ioas_id;
> +	__u32 out_num_iovas;
> +	__u32 __reserved;
> +	struct iommu_valid_iovas {
> +		__aligned_u64 start;
> +		__aligned_u64 last;
> +	} out_valid_iovas[];
> +};
> +#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_R=
ANGES)

Is the information returned by this valid for the lifeime of the IOAS,
or can it change?  If it can change, what events can change it?

If it *can't* change, then how do we have enough information to
determine this at ALLOC time, since we don't necessarily know which
(if any) hardware IOMMU will be attached to it.

> +/**
> + * enum iommufd_ioas_map_flags - Flags for map and copy
> + * @IOMMU_IOAS_MAP_FIXED_IOVA: If clear the kernel will compute an appro=
priate
> + *                             IOVA to place the mapping at
> + * @IOMMU_IOAS_MAP_WRITEABLE: DMA is allowed to write to this mapping
> + * @IOMMU_IOAS_MAP_READABLE: DMA is allowed to read from this mapping
> + */
> +enum iommufd_ioas_map_flags {
> +	IOMMU_IOAS_MAP_FIXED_IOVA =3D 1 << 0,
> +	IOMMU_IOAS_MAP_WRITEABLE =3D 1 << 1,
> +	IOMMU_IOAS_MAP_READABLE =3D 1 << 2,
> +};
> +
> +/**
> + * struct iommu_ioas_map - ioctl(IOMMU_IOAS_MAP)
> + * @size: sizeof(struct iommu_ioas_map)
> + * @flags: Combination of enum iommufd_ioas_map_flags
> + * @ioas_id: IOAS ID to change the mapping of
> + * @__reserved: Must be 0
> + * @user_va: Userspace pointer to start mapping from
> + * @length: Number of bytes to map
> + * @iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA i=
s set
> + *        then this must be provided as input.
> + *
> + * Set an IOVA mapping from a user pointer. If FIXED_IOVA is specified t=
hen the
> + * mapping will be established at iova, otherwise a suitable location wi=
ll be
> + * automatically selected and returned in iova.
> + */
> +struct iommu_ioas_map {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 ioas_id;
> +	__u32 __reserved;
> +	__aligned_u64 user_va;
> +	__aligned_u64 length;
> +	__aligned_u64 iova;
> +};
> +#define IOMMU_IOAS_MAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_MAP)
> +
> +/**
> + * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
> + * @size: sizeof(struct iommu_ioas_copy)
> + * @flags: Combination of enum iommufd_ioas_map_flags
> + * @dst_ioas_id: IOAS ID to change the mapping of
> + * @src_ioas_id: IOAS ID to copy from
> + * @length: Number of bytes to copy and map
> + * @dst_iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IO=
VA is
> + *            set then this must be provided as input.
> + * @src_iova: IOVA to start the copy
> + *
> + * Copy an already existing mapping from src_ioas_id and establish it in
> + * dst_ioas_id. The src iova/length must exactly match a range used with
> + * IOMMU_IOAS_MAP.
> + */
> +struct iommu_ioas_copy {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 dst_ioas_id;
> +	__u32 src_ioas_id;
> +	__aligned_u64 length;
> +	__aligned_u64 dst_iova;
> +	__aligned_u64 src_iova;
> +};
> +#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)

Since it can only copy a single mapping, what's the benefit of this
over just repeating an IOAS_MAP in the new IOAS?

> +/**
> + * struct iommu_ioas_unmap - ioctl(IOMMU_IOAS_UNMAP)
> + * @size: sizeof(struct iommu_ioas_copy)
> + * @ioas_id: IOAS ID to change the mapping of
> + * @iova: IOVA to start the unmapping at
> + * @length: Number of bytes to unmap
> + *
> + * Unmap an IOVA range. The iova/length must exactly match a range
> + * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
> + * In the latter case all IOVAs will be unmaped.
> + */
> +struct iommu_ioas_unmap {
> +	__u32 size;
> +	__u32 ioas_id;
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
>  #endif

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--WfdTxXupCMJl/Tke
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJFL8YACgkQgypY4gEw
YSJl+w//R6dOO7b4WSMtrZrAlHdvvE/xztVJlWrC1ZrygwI97F/VZWbGEz3YMfTv
CqIDPUnfP0FRG/thFZqk6IHpZ7kXXZSZTKfjx+5HMCk13hylBWQ5eE4nj9OzqkaU
hPf5yxY+sERKRCBxDnqv7KaMzJO4eXn8PkAz0lKgq36AhyMk9vnhVZm5h365mfAg
hqAhE8ytCzV0kZwv86sZRdjV8QGiNajnV1InnfXqGAAK1kJupJZEQ5f/R1Uqc/Bx
X27xeedN6JVkwo3jEzs6EJF4DWLGwzVYY8deYHBo1iSrgDVex/IVeR4ffFln2N39
CvCv73uutv8uiYbG18TDjDC98Qa9OgIhYQ6TEca6rkVc4qx5MjrgBS+WFTraK7tY
H2Q37WcYyDxQtAL1fTObGIgGbDD97pEgDHD/XlhyLwDemhC3PH/f/7uTMayM9TDE
XF6QQMMF0+oE8UMKjxVt7VK2jW6WpbpncBNCXMFJKdeOkxwPWUnyNn4+e4cIQYie
Nu/J2oyVIBuvU5dvxP5RMZQXShYSSruKWRftoofB77vAiw2qFKlq/6ylmxh5LBqI
X20V61mmXIEo1rK2ufkRWegXMd9h5C0dIGlyBAwl1nsv19/OO9ThTzj2l5MZHoNc
uRguyJjdHde+g7W0c+6lFsakPBigI/m1+IkmaSKIS0YsysjBgwg=
=zpWz
-----END PGP SIGNATURE-----

--WfdTxXupCMJl/Tke--
