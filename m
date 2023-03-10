Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF76B35F9
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 06:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCJFKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 00:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCJFKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 00:10:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2EF22DE3;
        Thu,  9 Mar 2023 21:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678425011; x=1709961011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SWMN+iAt1aw+0Eb1uuZZ39b0M2azlhniutjRhiNC0L8=;
  b=BhpknqPLgg3Y2wQlXyt33hICS6q/elRk3zqUAmLMdy8yJ6DlMevxo2q+
   kiK3axbBmUL4NPi2IJC5SvUkoAoF+fcED0naP71ZWqcb0BLXvdnEHhUKW
   YjSXgpTP8h43KO0l5uJcUfVk4RMBfjkXz+KSvCGvDDuo9F8ieNP5Ql/Ek
   C/o9OfS5QqUvXfXk36s1KiP0e42a84AQYaVW9G6T6VHJibd0N/TiRlodU
   TOskB3kbKRJRCv+c+FcXxrRCDNIe/WAKhR3lvRV5mfoXczoNWwwyPVZBN
   koa5ZFIoUEICW59OYAE8OheEkMy9V7dQg74nPUi2MrglvcZf6BnTlt6Ni
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="339010740"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="339010740"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 21:08:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="670964603"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="670964603"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 09 Mar 2023 21:08:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:08:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:08:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 21:08:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 21:08:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM2XpAMvxIbuIssMDi8qrlw+rPfAto4UB++DkwcgiCnMU9Q4N+j05cYVHg7CpOV1fdJPMcd6sY3RLqKlfoRoWkivS9aGX1MezAxjdzOWdY7ZTvpFu8GLniIl0mTKba9v8wSaLCsVAMPWhUmi7cMJzYZgK4/Z9xi5PN8kfU1bpoms5o0TORbntTvClRcX9K2G797BOIqanUtpYjNxvhw/cr3cMjQsgdSQGa0b+TrI7IeZ4b/CUXjjP6b3N52Ci52bL/JL6kRT6eLTa7GfycN6uruTFkKWrCYiJuK7dpPzlcXroEO9LatxY6wLddfH/vhUP2cq62xXwgSuwTpm9l22rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjR6WxU1rl0Kb1c77ZXq0PibBOshlp9fozu61UVba4c=;
 b=gPDEh39SBCONy6RMIE9faphvyZuUvOSY8akbGDrDNaRPuL+hCNTXhFLfLtg+lVh3bLzR7RzNaPjOXWsWCLB1GP3RgQnVXW4JPVJ7t2WGk9wuiYGnh9YNBx2vrDnVik13jWYiNDfVPo0jY56dCx2fRb6bQk8pWwnFuMxCOGMwkK4EhEz/XyTQzc+xOoG10GIwjIXHN8ch7HRZKNbLoWNz4eG9CBL1R5ruC3SknPHRLcaiZQl2e38OdfAlHlmZfuvvQDGA69wT/T/5uVmMkvyqUue4hbWL9YxgkJBtDmCqjNegYl1C3arUCbfb+kVYJTHHwW6k3SsT7x8/LgLtw9ILHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7639.namprd11.prod.outlook.com (2603:10b6:806:32a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 05:08:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 05:08:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 11/24] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Topic: [PATCH v6 11/24] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Index: AQHZUcICCmS2DybszE+6XUIAmfs5Tq7zd2aw
Date:   Fri, 10 Mar 2023 05:08:16 +0000
Message-ID: <BN9PR11MB5276D3C01F75380A815D218E8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-12-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7639:EE_
x-ms-office365-filtering-correlation-id: a5af189c-adce-45aa-e3b7-08db21257549
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +C6t5xHNYKD6AvRdpsPZXXHFApuKzceV6Q2vddS8aE6+GYVSpkeUHcx/45MyRi1bOzfMt3wNa9BlZ6c+Y1OtmL5GzXEAJetEWNLCEyU86dlv7yYeLM8dscDQcLSz8OS7Nrf1tUjWX6tr0y+7//viZc8sMpag7JQbgKCIy3Mhqp4x3NkdSSMVHGELnxe8QTBc7wmdPZcvYgZJW5zikl6hsm35ibEjwsZKMqQB0AwgOxzPhq74+PG3igIlRxJM9I+IZq4mpfFUZ16ks3YYnNIWozuU9BEK9QxQHYkYdyJji4OOwFn149ZgxcasNUbv/SfP8164Indd5jWVpsYvZTVeNhZyWk3p0LyAADf/ji1EoSUIY8245wJT1GelnM8UsKCzUnYIWP5+IknzjKeXr4m4uq5kmOAqsL/4Lau4hD/NTb6ylNZ4SOfCweaETY0PGlJt7qU+9UIB2kL6YQUNVNk5xDIyFGVOMlPD7CLjSVMDLWKsDukbw2vQq4nIeWwh27oNVhtvPxpcziGvx/3Gkl10+uWowSrU35q9MvANcKeFceQV92YEYNVfR0IVCTKw/MmlTJr5QmDvu3/ZM9eM0Oe0RWDkWWJNED+faP2Ud8ogkKy4uFafdLySjYFOdTblP8x7VrssFG+5nqKUTMR00wJtMTDScdVYUk5UB3ZXxGHehKa+xv5ZoYptCnHbi6bxf7CLLmAxi4JRhjqa2MUPxhL/BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(82960400001)(83380400001)(33656002)(478600001)(110136005)(55016003)(54906003)(38070700005)(122000001)(316002)(38100700002)(71200400001)(52536014)(9686003)(6506007)(186003)(7696005)(26005)(7416002)(2906002)(64756008)(5660300002)(8936002)(66946007)(8676002)(66556008)(66476007)(41300700001)(66446008)(76116006)(4326008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VzJafM73ktYiYIuvJ4toj9K1W9LgKjynDEsWDLN/68+nKuVZh53E07IFWcHK?=
 =?us-ascii?Q?Oq+YsbpDqYLuvfJDctpVRoEBKf08C6eThYu3K861Fb7RCKPy32zACXjR2POC?=
 =?us-ascii?Q?b+up97IHjQzMkQ76jApQpjbqicrPJ46EOYL4+w7ZaTUpu3hqESamaMVC97uk?=
 =?us-ascii?Q?h0A9DtZgXEvtjdkRJL0/UjHOlbzwGuezLlYaES7YvbPgD8H+2KxbQjwqPoan?=
 =?us-ascii?Q?CpT0H10OBID7Y+lCdj2Og5xE0oFtpYkaYuC1/24SMBTHW+kJLy7VE0LCcY/z?=
 =?us-ascii?Q?CW7apqYxuz/3a4G6zvGmOoEBtYJn3luH8VTBFMOrUb2x1EDSsJXftfwE86Nq?=
 =?us-ascii?Q?L6uF/VMaU+E3zoUgZs8M5v06sTJitDw1vFVOxkue+BSOQznaZe0DjGzGQ/eh?=
 =?us-ascii?Q?RJ2YoLCyuZBecdgaIhRaXl5Bjon+u6tDJZaD+3u4IQBO6ajWUWJixQDERsQ1?=
 =?us-ascii?Q?SnHqvtHcJ2XMz62O8mDbtXtmJIoA1SiTFtk7V0YHGDPrny1eNgT7HNK9UCXr?=
 =?us-ascii?Q?fqRm2FidL7BC1zWEqd7XrdOJTkzhaFSfSADD8MiqvTd8thEDIuHKlkbsi3JZ?=
 =?us-ascii?Q?+fzd8KWvoxWqnbN1cM9lZqTcZJOR5CvKKP7ySiw0+5A6oINtW5PQIYuSkEDa?=
 =?us-ascii?Q?LFe6bY/UBmxaXJamFO0XyFPQmJGxvMhdpyzg+Lh1moyg2NMEXvQg4yDgZQv6?=
 =?us-ascii?Q?oH05U2BVaabpW3JZKgtb4yeyysGvfIdrOTYU5vzW4nyDBritNxdfq7RQCjOG?=
 =?us-ascii?Q?t6QyHZvkgdBLDVUF0FuMuva2Xts8yPtFOoXoIjMlSBUhfuq99jCEQWXVMiHC?=
 =?us-ascii?Q?5DJcqdpxzFQwYFah4rAQNDfzAgfMmhN3EFJorqSuJyj7XDP0aCktdGBYm98n?=
 =?us-ascii?Q?1CMTiQKZKqHPcL7Jmk3nAqY+aw1jII1fGy7pXfTgrdfF0HJQ5TuDaSSitQpg?=
 =?us-ascii?Q?nemCvFcCEdvDUos98r6e9dOrQ92Kr3LajjEEn2buhPxzLDXfSkotYZyjflKr?=
 =?us-ascii?Q?CV7KROP9n+hRYZAm8W7zSs23L4ITZgy0ldToxrO4CnnuFy0+t7EMPg7s3yTr?=
 =?us-ascii?Q?UqvpiYihJmZ0GcBf+Pcu2Nq8gBBHAyawJpTFtHWlh2x/OrFzctsQgdZxPURR?=
 =?us-ascii?Q?pTC5jxq4+VQYRuTAvRtHJqKZYRSMEJXopo3HsNRy5N7IvTx1u/zPK/7UOXYU?=
 =?us-ascii?Q?nnyr32zDmBRSe+sqp/kZg+0jI2frbFadf8wGgKoWHxmaQRaiXWVGcLC49cAF?=
 =?us-ascii?Q?x8A+YlmkBF9swu5c3rHCVASM2I821DHc7Zex8ghI+IiWMmeamDU6xa3RljR/?=
 =?us-ascii?Q?zYiAk5tJhRY9VAWgNRSXJ2H1ym+pgdVWSOymxBlkHI1ncuwTwKNPadjKWG3+?=
 =?us-ascii?Q?Fapw78KDVmCamlA+Kn4NAfTj+JnzKf4Y0zxXuO2CfucxEU00LKKAugPrSSXG?=
 =?us-ascii?Q?Gj9IYpHYWjvLK67GuWSlxqvELMv7ODAcLC5urKMArEGg1IxGSzaIZtJ+aVLq?=
 =?us-ascii?Q?RvOFezgeLDcr1nztL4gn7y1CGLshSoPmnJ1v9SxeouYtEgz2eyPdmNKApB6N?=
 =?us-ascii?Q?oh6SbSWhX4xamxLw86BMxpwy3CwLnVpJAYJyuB8L?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5af189c-adce-45aa-e3b7-08db21257549
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 05:08:16.8184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97NdTAxsuTlq3te0Kwr1lvLfS8a1pGITNoIPWkDt0qX3bDiZ8yFXE7b8SEwqcoIueemtb3l7gUjQyQtpxeeoOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7639
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> @@ -1319,8 +1319,14 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
>  			break;
>  		}
>=20
> -		/* Ensure the FD is a vfio group FD.*/
> -		if (!vfio_file_is_group(file)) {
> +		/*
> +		 * For vfio group FD, sanitize the file is enough.
> +		 * For vfio device FD, needs to ensure it has got the
> +		 * access to device, otherwise it cannot be used as
> +		 * proof of device ownership.
> +		 */
> +		if (!vfio_file_is_valid(file) ||
> +		    (!vfio_file_is_group(file)
> && !vfio_file_has_device_access(file))) {
>  			fput(file);
>  			ret =3D -EINVAL;
>  			break;

IMHO it's clearer to just check whether it's a valid vfio group/device fd
here.

then further restrictions are checked inside vfio_file_has_dev() when
it's called by vfio_dev_in_user_fds().

if fd is group then check whether device belongs to group.

if fd is device then check whether device allows access.

i.e.

>=20
> +/**
> + * vfio_file_has_device_access - True if the file has opened device
> + * @file: VFIO device file
> + */
> +bool vfio_file_has_device_access(struct file *file)
> +{
> +	struct vfio_device_file *df;
> +
> +	if (vfio_group_from_file(file) ||
> +	    !vfio_device_from_file(file))
> +		return false;
> +
> +	df =3D file->private_data;
> +
> +	return READ_ONCE(df->access_granted);
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_has_device_access);
> +
> +/**
> + * vfio_file_has_dev - True if the VFIO file is a handle for device
> + * @file: VFIO file to check
> + * @device: Device that must be part of the file
> + *
> + * Returns true if given file has permission to manipulate the given dev=
ice.
> + */
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> +{
> +	struct vfio_group *group;
> +	struct vfio_device *vdev;
> +
> +	group =3D vfio_group_from_file(file);
> +	if (group)
> +		return vfio_group_has_dev(group, device);
> +
> +	vdev =3D vfio_device_from_file(file);
> +	if (device)
> +		return vdev =3D=3D device;
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> +

merge above two into one vfio_file_has_dev().
