Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC018663935
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 07:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjAJGUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 01:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjAJGUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 01:20:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C586A42606
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 22:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673331641; x=1704867641;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=YRCaHKjYMhck8B2LF7vP/eeVKPRBYJ2qzMzhkKWhW5Y=;
  b=TXHIQrEElRvulO1v7Sma7d8RYCkqfJyo+HzeURrg7u1rVjdlgW6Ehlbq
   YcGpYkd7XB0L6cYTRIo1cdpuVCv8rqFMLBFkyuhLPBKuat+6ANnsX1Eu+
   77k7U8gkkIqgkZ1kP8LbQVEzO0GDvhHKIEoUmtCCALA8XSXhMlyBe9fGx
   dNjCdwCgYZ/wnLCCY4SvfKurUhgFIyMh2oZTRHkVU1Agk5vFrKw3ehBem
   igiT/0kyD4S20CF9EdG31gSg5wFzW0ZPTv9dsd0s78/LxY7zBigVBxE/7
   g779Q1/cH5CxMAgJsuGKCxvydrhvbADx0BWaOtVItWFnWz2uLKjoEq/a9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="306586823"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="306586823"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 22:20:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="634490788"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="634490788"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 09 Jan 2023 22:20:41 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 22:20:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 22:20:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 22:20:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 22:20:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmlTcGbXO4/WmjzH7UBsepC9KD/XrQRdVdA2hFLJWuxjf12eMTL13qhp4d5NOp4kkTjRa0V4SylEW3VVPhox7DbRc8WQ8M122osFfaU1BwXfK+6fp9/os8YswZXwaBsTJbxZX8em9XJXjSYCLyLCnOiorHAZoe+hgxRUFAPLMtpMJrKZJ1Q4A3eEV47vzZulzSeguPRsW/p8fd7jPziDvvxEXbPgLmUZ6HYRnOyLUle+PMpwSO82AUsaLT5/R0uT8MQvQhT0PQSYTopPiL/NUyzoqOi6a6aTxzYPMMhc01O6exPpKWzlmPCQ4LbwL7ZeXepI2RTL1FTZqfQWWiYcWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ/vjJgSdTenr/chU+3p4i9cspEQqq1yQD29tTOx4lI=;
 b=mTvCDVIWmEE6A6QWcg1ou0mM5iI98I6oeVmqIlYl/NqZ4fxcBS/E2KfHWZtp/y30/tlVOg2mpOIZ2/V0txURfNCcB4qTEefcYgHYpOAOzk3fIFWJzlycoRmc8LSwYNZ8k7Leja0p4GBbArKgEhkOK3R9mbaSzBA5LI7jQAJGE1y1X59gYEVIgAd3X/Kd6PZiSpyAPOdOms5rA+W5x5fDP2gAkTmhnaVaUu5wCThJB4kclTIVrGpU1N7ysI0QKEL7Gvd7l4IBVRc5DsMnKV26sb5rf+xojPNpafNWNPHKBQWkdLSI9S7tz4Sma1lc7D8VdDYsJtGHjP6Vq5W392LYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6947.namprd11.prod.outlook.com (2603:10b6:806:2aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 06:20:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 06:20:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Topic: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Index: AQHZJDXlKpTqcd7wo0KCKSjKqB4p7q6XKV9w
Date:   Tue, 10 Jan 2023 06:20:33 +0000
Message-ID: <BN9PR11MB5276893EAD2587164F9F94878CFF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
In-Reply-To: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6947:EE_
x-ms-office365-filtering-correlation-id: fbef9c1f-f76b-472d-481d-08daf2d2c7f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnKTaC3VQxasst2ph4kGWKLyX+MS/Gp1i8M8z8Pv3vl1BSBav9ADBfTJ7acTQ5FgrrAAFWIqjmpxm+Q3p8yQmGaaoXXrLgt03mjVCiZnXpdVTE3K8YhS4C0LdJxAGm3FrpGMuGIDbCXk93aTg7DZKM+jHCP7TFYrQUi3kPqN26xAyW+sBKSGU5c6QZisptvHHV86xZ+mf8Hhj90JhWEVdNYLKiblLBaDt2nwgev5YAftWfFm5n6Mg0YbYg9oUFIezC8Y76e3GPeNYIBRZC9QhKGwi5pOZYiITtNlPeGdYUpWyoaWJfzzCrhfmEBy5HzSrv4G4Rul9mG0HdMZPivdOC7/QoWal6lIzVF7fMND4TKIy17SPmocwDrC0xyPPZlpN2vrD9KSD84nszjkN8J3TzsJcMwGs1aCvR41O04T0Q5sCh8N9V7cTdCheX6D3bD0ZZqCrVRtame/1qb00ixkNEvKbfDnMG/rU7iW+WPbCIeEnt/O9mcokUyUDHSAkC5wKX7w36epfbpuODZdiWmJUMiI72B3EzV3H6YYuf8j3jNJYzwDSPoSx6LXZYikaKM5Y8YsSDy9g00bDJKf8gp4y18ynqxibYQQbLLHTCnmaA7zL7DQ0ecO9oLqP812DKhh2COQugD0RT0JSPdnwLzW+FROwJG2urKBmQrk7T0NaXS3CgaHWKH/cb3v+NPcY60nE0ExR3eGGN8OJ628TuTvdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199015)(6506007)(38100700002)(82960400001)(122000001)(2906002)(478600001)(33656002)(26005)(9686003)(7696005)(186003)(71200400001)(5660300002)(316002)(83380400001)(8936002)(38070700005)(52536014)(55016003)(86362001)(41300700001)(8676002)(64756008)(110136005)(76116006)(6636002)(66946007)(66446008)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AmA141alTIyAs8Ws/SQqtRfR96xlcb0Y+aIp0vN9CCVts9sX7gp55xc7pJ0z?=
 =?us-ascii?Q?+z+BinDXuc/YbFlySVi8bXm3TqIRfD4TIVftO0eLYYRXqOjK2ksjuvJsrKe+?=
 =?us-ascii?Q?DUOUWABNGY5Zflmz4cUSspuKnpG9eB+/mRhg+bwJAXSfZUZW09SSl5DJNVkk?=
 =?us-ascii?Q?034f4YlYQ63ygBWUUWknzVHcKRQ/Z3pcReLvBHzaHoDdL3NDdTJqjKuo0uyI?=
 =?us-ascii?Q?w+BqtzxIK1wb00UBdWUpTLABfgkhqjyxfi9dBZtR77Yxr7MoDoKN7LnGfiSZ?=
 =?us-ascii?Q?jTU4qbsUtS23OtiAZxEf9jXwbnedAJB1e9Y3pXVtcFebuhMG8YBTexK4dbbx?=
 =?us-ascii?Q?TCJayH3xaSjx6NT2bWPDgGG3ZKQuPp1ILbdiESBcWqrawaShEmEeITW6kRaN?=
 =?us-ascii?Q?QbwL+wLrCGk2fGA0H53v+apbp426Tyk35zrTW3QTRzONSI09NGDDGejIZfgl?=
 =?us-ascii?Q?L/i2hXpkX9gQ/DuKzn9o8Z4SQSFGVf9IRTMHYffUktcvQ0MHesxzcGuUzIBJ?=
 =?us-ascii?Q?lGx7TvgM79UYGoQoN1hz6g2GD6uThK+2ahWdRnSn+ipO5x2SocC3mi1AATvZ?=
 =?us-ascii?Q?txOtyUHWNO87dIs0WsbfahA87oPRl8kNzM4dHhk0ZafKstYqAMpOCYEoAnaC?=
 =?us-ascii?Q?c195NS4/QzG30DhlrRu/0VzzcgYqF6ZWkIU9dRbjAPYdzEmI3ZZf2J+Q3ZPG?=
 =?us-ascii?Q?dRSBjX2k3jbAuXggb7o3EfFkbP7Qieg/LRWbb9qiRTAu5WBWrcSh9G/fEWRl?=
 =?us-ascii?Q?LJjeM+LAq6As9J/sFokytnEpOEFNlvq4Q2nZjm2AIBV2xsNJ0NdKWGZWjZFg?=
 =?us-ascii?Q?wa2WgdvWqCFLCxRDRm9objSnAt7UglB9RnnPlzPltoqPF0ThBOKvzjktvyhD?=
 =?us-ascii?Q?+FCK2PS/Qe6Olmr1QWAZvBa2n0qzyUQt3RwDaJFv3is/463Wb5c7yqLw5K4y?=
 =?us-ascii?Q?Nv9Pf+K1YyIxF1y39359czUuu1R26CBzzVvn41s/4sAKuZuJoFp4w6UjUKyA?=
 =?us-ascii?Q?NQKD73wLB3enirM5SQnhjpBlsNdTL5KScxasO/DRgK4t8uABTqLLwUc39bFa?=
 =?us-ascii?Q?7boIckCsDRf//9Ga3L9IDA8fL68iHuUy0k0DLTb26H685FRFn1UFnJ0Fjh9x?=
 =?us-ascii?Q?o1ja+Mk9Ovp6STfmjx5j5EXioXCZtCmIDaK/6TYq0Cri7I+7/Vm6IGXLzSed?=
 =?us-ascii?Q?jFU+diB+kMA85DGW+o7kQF9PiunQv/zDEO3Mr9RsS/4LxeKcKtAWtLuO/n1o?=
 =?us-ascii?Q?aCH1yLauFFTyzn9VyANlJZG3yZe6Mc/GhBLpcs7/WLcoyFyGgIde1G6AfPo2?=
 =?us-ascii?Q?RKu8i8BGxIGsDbcZTWxCG796rWINpxdRl4dq8rhGxzJ/6fLVKU4HpTsFZSsJ?=
 =?us-ascii?Q?Vrzf18RBO7obwtYeH2VCgviKA+08I9/Q57XSwntHFpa9JcMi6UYzeHNL0Hfl?=
 =?us-ascii?Q?EFALllmB5i28yDMCiqE2rwREA5PLKL8gPiCGPR4c9Uc9sromm+993tj3rYgt?=
 =?us-ascii?Q?NfbEuRfp4Qm7No+G5cao8U7bhYGNddMrsMVTKxe9lzgbDHJ6eKL4fD0r5jJ3?=
 =?us-ascii?Q?GsoNTwBwKvNm0T1HMeVNoYWN1etdJ3pYK14+90PQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbef9c1f-f76b-472d-481d-08daf2d2c7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 06:20:33.7344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 76LYsKwc7/6bAkxDhzY0F5+9enTyvQV9z0QhF9bNaqOa1Jb81m+W4JI0O5IzWJ4M0FpX6gFzrEwW0Gfo+afeNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6947
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 9, 2023 10:23 PM
>
>  /**
> - * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
> + * iommufd_vfio_compat_ioas_get_id - Ensure a comat IOAS exists

s/comat/compat/

> +/**
> + * iommufd_vfio_compat_ioas_create_id - Return the IOAS ID that vfio

'ID' is not returned in this case.

and it's slightly clearer to remove the trailing '_id' in the function name=
.

> @@ -235,6 +253,9 @@ static int iommufd_vfio_check_extension(struct
> iommufd_ctx *ictx,
>  	case VFIO_UNMAP_ALL:
>  		return 1;
>=20
> +	case VFIO_NOIOMMU_IOMMU:
> +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
> +

also check vfio_noiommu?

> @@ -264,6 +285,17 @@ static int iommufd_vfio_set_iommu(struct
> iommufd_ctx *ictx, unsigned long type)
>  	struct iommufd_ioas *ioas =3D NULL;
>  	int rc =3D 0;
>
>=20
> +	/*
> +	 * Emulation for NOIMMU is imperfect in that VFIO blocks almost all

s/NOIMMU/NOIOMMU/

> +	 * other ioctls. We let them keep working but they mostly fail since no
> +	 * IOAS should exist.
> +	 */
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) && type =3D=3D
> VFIO_NOIOMMU_IOMMU) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		return 0;
> +	}
> +

Another subtle difference. The container path has below check which applies
to noiommu:

	/*
	 * The container is designed to be an unprivileged interface while
	 * the group can be assigned to specific users.  Therefore, only by
	 * adding a group to a container does the user get the privilege of
	 * enabling the iommu, which may allocate finite resources.  There
	 * is no unset_iommu, but by removing all the groups from a container,
	 * the container is deprivileged and returns to an unset state.
	 */
	if (list_empty(&container->group_list) || container->iommu_driver) {
		up_write(&container->group_lock);
		return -EINVAL;
	}



> @@ -133,12 +133,13 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
>=20
>  	iommufd =3D iommufd_ctx_from_file(f.file);
>  	if (!IS_ERR(iommufd)) {
> -		u32 ioas_id;
> -
> -		ret =3D iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
> -		if (ret) {
> -			iommufd_ctx_put(group->iommufd);
> -			goto out_unlock;
> +		if (!IS_ENABLED(CONFIG_VFIO_NO_IOMMU) ||
> +		    group->type !=3D VFIO_NO_IOMMU) {
> +			ret =3D
> iommufd_vfio_compat_ioas_create_id(iommufd);
> +			if (ret) {
> +				iommufd_ctx_put(group->iommufd);
> +				goto out_unlock;
> +			}

This doesn't prevent userspace from mixing noiommu and the check
in vfio_iommufd_bind() is partial which only ensures no compat ioas
when binding a noiommu device. It's still possible to bind a VFIO_IOMMU
type device and create the compat ioas afterwards.

somehow we need a sticky bit similar to container->noiommu.

