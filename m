Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAC168D271
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjBGJRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjBGJRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:17:34 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E40D38008;
        Tue,  7 Feb 2023 01:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675761453; x=1707297453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lnwuiCPJ1kODylUgJY90J6Sd80WoYJ16ulevkBFr3Ck=;
  b=JjW/pIQ50ljYXATLk7Ja3dgJ6RaAK0vSV10i36NZPM+WGavnBPzssBB2
   zBaIKiNMi5PAAAZKYgE55MKrmxAbijKmMaMeVPog48xiDZgSJXYMCbRTq
   jzUudweHr9Zt3nm0ilz3r72aON8Y8k0PKLkjj95XkvaiO0S52MpUa1ffW
   d5enxo1IPJjtYfrXVbGeoLxudVdlhmrp+znvZiwTsPmbiUuny7xuwsi4S
   KzyB8r9agexEz3VsJWtByTVr5D+SNaEyknQkUOCBK/7UkUb3DumEhJZwS
   Xz4jwZNXltLraAxiL4f05LHTiYkShr8XByGx3DyN0zn5IrkGS4FMXsqnQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327145782"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="327145782"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 01:17:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="666770079"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="666770079"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 01:17:32 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 01:17:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 01:17:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 01:17:31 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 01:17:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrfIH52PDooP2uZOq3mvBx3duzK8tSljIvBJxHFhbVfTfd0/pVTAHnXSLLOvoc3ZbtyHkdpRUne4Itx0nwX9RkmQ+Jeq1T1EMyfGR9v12tU6nwZUaJC6v7OhrUwlwS4qwZ+ZLEqXl4olY5DAg/kH4wXvXC73c/7wKjV1orSBkvvoIJy/ipSJm/JP/Ke+aFIVQpy6F+XWtaakyu8olZ/7GNUi2v1QUqfhl7RXL2juaIh0xohwOVSaaQ4WQCvmpyUWA4+PByOd90HJ6gkIUmzuAAeeubtG4cDqXC4nsbKlJZQm+sbYGWCqj2RI2WcK9uN9OLNiB3kGI30PC4h75WNinw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+LCdOljwFFomnM1/yv2ZRXfENv/VrxlZjezxAO834E=;
 b=Z2URBHf2uHMM70KrmeRo79fz/2d/jZci62POSPIrB6c23Fdmr+OQs2f5caAyccZuwV4zs4mMwATPN383xz8tvjY0ZDG4SD0emgtNalVQ1rFacV/zzTuMGd+Rys64Z/nf45FF2jVTHC3H0HXTPcaIrXnhqOJeaU2UgZPb69CYUM5E6c+6KNwi6T8lUmeabz9somH/HM1i5N2KZb3l3XyKjAKHZId5+20XbVG/9fxnIGKF+ooADToDX50Ffi0xqkrUSKgZeBg7wl8UQeFfBbgWr/qOj/IRrxpeFudkinN1Z6/RhcfOkebIiQBEU8vSzeefuT7bYVO+WIM5m6uWic+Lvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6874.namprd11.prod.outlook.com (2603:10b6:806:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 09:17:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 09:17:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 13/14] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v2 13/14] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZOgpFuq+WgSot0kSqb57VFjABHq7DKMDw
Date:   Tue, 7 Feb 2023 09:17:29 +0000
Message-ID: <BN9PR11MB5276A5DEB3855788C02A343B8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-14-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-14-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6874:EE_
x-ms-office365-filtering-correlation-id: 6f19acee-a951-4c1d-d233-08db08ec22c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZVkpkiuX5i284MIDX95KSXnJ06TlxCo6jahjdjIle2U7UeNj9MVmb8fiCqrFBOPe1HadSJRHia9Y6Hi0tuxSu4IODkVJ85/06xlp5MdmyN6F3EP5mv7zMnn9NNOWvZ80qg4cNV9Fv74bbrkyATAc0DIg8b1esiY2Sc+si+7N9SDok2TAJU65CEAZ2PQGe//pT5ckFmeF7Yijb/gPfrEsWT95cXP+IbKWvA1iiK/lKCgA5hsUINVh6ATbfwcxKP/SqpuCMwRvLvWgyiuctTxNr34YErKs95m6UPW0epaONTIPii0tgHM6GAjdMw5etfK2hc73ILl4p8cY6q4uXCBJlsYPYtm7Lq0i2zKGQ2bjHWfv0xGlMTptjYOsoyQ/7Z3XRjD9pTbfbQ9mPbecHq/9ooQN/09iEOAa2RTPua5hZSjJZXXpZJ0wmajb1geaBzo0T8BONT0pP5LW1z46V9MYf2a1a0dRpF51Ef77IXAuqgPqb/rmDKDoKvL7JKF6fXD5+ksZv2svUrGvEv/T6QrKIbOdHjv9Dtn5t/5CyG4aWvMKubDaaJbZ8lVOiMtqBUlv6UDb8sHCxAh1bHe3RnIh0VWnEKcH9OVrVx1G4MBBzwB1S4tlTRJG+5GhFRbgY+MS+aLyedJgmdl1ADO7WQAi4W6F5L2ywLiZj42V1tfA9YQAReP6qU741+YrxGywaVGRtDWyd2gCGwE0ln/aXSa6AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199018)(38100700002)(82960400001)(122000001)(38070700005)(6506007)(33656002)(186003)(26005)(9686003)(86362001)(76116006)(66946007)(64756008)(4326008)(83380400001)(66556008)(8676002)(316002)(66476007)(52536014)(110136005)(478600001)(54906003)(7416002)(7696005)(66446008)(5660300002)(2906002)(41300700001)(8936002)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SgfzbZ5hmHk4T7FvHIKKCXRuiegDx9zRXLz293TxN8M9+t6v5VRomXue8edL?=
 =?us-ascii?Q?PeTECFAuG2M/VAwXTBDBKlbLWpba3qGJDxmDkJEZcc7MT3y+IBovQAgfNwSf?=
 =?us-ascii?Q?NSmyInUhJH3/T3qo4hBuwyeavBXX6/KG+b4LBSRRwYIkKt0k29hLFinfYyiG?=
 =?us-ascii?Q?xw55D3PABioFqkmhYV/0OlxsDBnROfRGrRb+aXtCarhxkdb4Inh5vQN/K6pn?=
 =?us-ascii?Q?8U75wTRw2jLDBpGFiB0ksldbT8dagwTV2UEF3zmmk4DKNCBJOCtjJrlxqhQB?=
 =?us-ascii?Q?2COIjtP70ucEc/RpPMYsfTEfctBfdFkh59d5iB7XuaePyPC2GKZJ5/4YKXlD?=
 =?us-ascii?Q?4MvVm9pksJUnhAaA1TXPU2sr25Xzl1WS7ICBJu5nB2aPaAwD9sDvN7CvzFzP?=
 =?us-ascii?Q?z3p8z2vFdHDOxp/NR8o64OjMQuun/dkSdoeOjCzq7OfpIi4JTDFWBBU8+0On?=
 =?us-ascii?Q?rp7V7TwiCd9sbWq8pSerzXsBvC6HXiHFqDlBD1ThOXV9DR0wygM+GgnurXKR?=
 =?us-ascii?Q?KpQw4JmMvh1UNBja52oMlJcffshZCa0MmI5FBRu8FDAjHGJfqlWuc+RDwAlM?=
 =?us-ascii?Q?D7hb+HAQZ48/PNMaUNpd1xWq5V1XyNmBxQ+j2WDZ1C6yRTt/LZIIXbsc6XIh?=
 =?us-ascii?Q?AaW4ByQP/sqXbI//f1jaAVODESVfEWUV06TCkXbVG6SGmbDrS8dN0YV7hGTt?=
 =?us-ascii?Q?ZWGgeSBfsq4gfo7TbTCpQVCgwmxWjHg28JVSSJSyipeTUARTQyBCsaZjWmYu?=
 =?us-ascii?Q?2sUtGQ8DVuj9Vnm2OAMoKnq3kGLz/qfnoL30FovQaJK1+4A4Ge6meVoFqEqW?=
 =?us-ascii?Q?Tymo36EZ2cOoDLESVXK6dQ2/IErMJ83st7MOcroHUh/Oi2UC9eZMh1Jzf/HG?=
 =?us-ascii?Q?fb6m9TIRTJ8zM4BK5+oZqhlrR46j32SvnoOxBJUwlcgPRoGUP+bREVI9yt/q?=
 =?us-ascii?Q?DZ+pPg60G9UB0cy7OT4LVSOnv9ru1GIasCpLs0yzCAHCCmA/9Fq5A+60QLgK?=
 =?us-ascii?Q?lFy8AqbMYGyeOjbNqIdH2L7jRM1sOj85C7lqTF5N2s/ZIE7jik7Tu5AJu3gG?=
 =?us-ascii?Q?KkMlNuwGSXFzeaoOJEihiJK8CB63yYnm2pylJA3ZlJifUYldF3yemlUZZtmp?=
 =?us-ascii?Q?L9S6ACC0J4du7CPtoNXgCCw1Eg3iHcEBx1ygQe86wugHCn4CqhEL5dz5i6zM?=
 =?us-ascii?Q?50tSdqoexrLLILBZpYs8N7l/gh+rgPj3nCSuU6mClqOUA8D3Tm0X/AfxcWBg?=
 =?us-ascii?Q?Hm6Gyza+mJ6ieYQNwV9BKRtLfoaKcwLMl28hJ7gC2CZXHGCCHeVTLF6lPIt4?=
 =?us-ascii?Q?6k6BmXnIcBbae5ZbTgDCajat4re5J523rC18x17Y4HCozkUq082cDTlxYydB?=
 =?us-ascii?Q?hDL0DFFvVQxtKjfLCuiWHB05vJpEZzTHjZPH4mBdMCjjV7VdR4zelXf5cVA6?=
 =?us-ascii?Q?FzsXpQQ5ZPj1g2xJGSGhaYJd8hbLAwEK5EJ8zerLT40wPA/RsjJigLQDhmT8?=
 =?us-ascii?Q?+fR0fqM6ut+5eKwDnP+IEvWxPX1K/hPI8sUYyC4MAkkmi2w5eJf+uDVMVhhv?=
 =?us-ascii?Q?l2NgE0iyMzA2rp0hjjCX0vdPk/8pyc+Lg7/PQWeX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f19acee-a951-4c1d-d233-08db08ec22c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 09:17:29.1660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5Htlcb2JP34ovNoNcs34cE81WlKqkcwzJMWow+EohCkezM1O9yLDF/NDmwEjOmp0Z1GLDMkMYVPYXl1AsjqnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6874
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:06 PM
>=20
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device =3D df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd =3D NULL;
> +	unsigned long minsz;
> +	struct fd f;
> +	int ret;
> +
> +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, iommufd);

shouldn't the minsz include out_devid?

> +	/*
> +	 * Before the first device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain a
> +	 * reference. This reference is held until device closed. Save
> +	 * the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);

there is no multi-open for cdev so "before the first device open"
doesn't make sense here.

> +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> +			     void __user *arg)
> +{
> +	struct vfio_device *device =3D df->device;
> +	struct vfio_device_attach_iommufd_pt attach;
> +	int ret;
> +
> +	if (copy_from_user(&attach, (void __user *)arg, sizeof(attach)))
> +		return -EFAULT;

lack of a minsz check

> +
> +	if (attach.flags || attach.pt_id =3D=3D IOMMUFD_INVALID_ID)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	if (df->noiommu)
> +		return -ENODEV;

-EINVAL

> +
> +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> +			     void __user *arg)
> +{
> +	struct vfio_device *device =3D df->device;
> +	struct vfio_device_detach_iommufd_pt detach;
> +
> +	if (copy_from_user(&detach, (void __user *)arg, sizeof(detach)))
> +		return -EFAULT;

lack of minsz check

> +	mutex_lock(&device->dev_set->lock);
> +	if (df->noiommu)
> +		return -ENODEV;

-EINVAL

> @@ -442,16 +443,41 @@ static int vfio_device_first_open(struct
> vfio_device_file *df,
>  {
>  	struct vfio_device *device =3D df->device;
>  	struct iommufd_ctx *iommufd =3D df->iommufd;
> -	int ret;
> +	int ret =3D 0;
>=20
>  	lockdep_assert_held(&device->dev_set->lock);
>=20
> +	/* df->iommufd and df->noiommu should be exclusive */
> +	if (WARN_ON(iommufd && df->noiommu))

pointless comment

> +		return -EINVAL;
> +
>  	if (!try_module_get(device->dev->driver->owner))
>  		return -ENODEV;
>=20
> +	/*
> +	 * For group path, iommufd pointer is NULL when comes into this

"For group/container path"

> +	 * helper. Its noiommu support is in container.c.
> +	 *
> +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> +	 * Its noiommu support is supposed to be in vfio_iommufd_bind().

remove "supposed to be"

> +	 *
> +	 * For device cdev path, iommufd pointer here is a valid value for
> +	 * normal cases, but it is NULL if it's noiommu. The reason is
> +	 * that userspace uses iommufd=3D=3D-1 to indicate noiommu mode in
> this

"iommufd < 0"

> +	 * path. So caller of this helper will pass in a NULL iommufd

I don't think that is the reason. Instead the caller is required to pass
NULL iommufd pointer to indicate noiommu. Just remove the reason part.

> +	 * pointer. To differentiate it from the group path which also
> +	 * passes NULL iommufd pointer in, df->noiommu is used. For cdev
> +	 * noiommu, df->noiommu would be set to mark noiommu case for
> cdev
> +	 * path.

"To differentiate ..., check df->noiommu which is set only in the cdev path=
"

> +	 *
> +	 * So if df->noiommu is set then this helper just goes ahead to
> +	 * open device. If not, it depends on if iommufd pointer is NULL
> +	 * to handle the group path, iommufd compat mode, normal cases in
> +	 * the cdev path.

this doesn't match the code order. Probably can be removed after earlier
explanation.

> + * @argsz:	 user filled size of this data.
> + * @flags:	 reserved for future extension.
> + * @dev_cookie:	 a per device cookie provided by userspace.
> + * @iommufd:	 iommufd to bind. iommufd < 0 means noiommu.

s/iommufd < 0/a negative value/

