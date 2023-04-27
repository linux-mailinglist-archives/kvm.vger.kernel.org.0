Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E42F6F010A
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbjD0GwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242825AbjD0Gv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:51:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2BA2D76;
        Wed, 26 Apr 2023 23:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682578318; x=1714114318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R4JLQ944T7/Mf5rcQ94ePmGUQX3zLHgGPceabVUAjHU=;
  b=VoRqbmnHhCKIQzvppKp1eLbymJJACjKBSHRgpHHh5D4nBpsHf2D+5l10
   x0adlMst+K3DutTUGF2eCqOybXclgTqF7NLVc7h5wxHKK+nf3sHfFkt72
   mUvPJ1VvDwKHWdsj0mMn02DLvIE9o3ShkQqPIzO61p0mBURyljPy8nOTv
   sh/MrQRi9CK6DA9CKVg4NXQ/5zK5F5JbdJMuF7XtJww/9fd/4sCgjzjkw
   HhIJET9vF2JqgMR4zmcOk2ndVmeCiGUEhyJvF9BLFBeee3+7YgXxk36p9
   wGCGNfWKG7py7zAPqb1FqthCvXDnsU9uhO1GoBx5xOL3buarwuIJuPRCM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="412679300"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="412679300"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:51:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="694259269"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="694259269"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 26 Apr 2023 23:51:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:51:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:51:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:51:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:51:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z82z7USiSFZ8hWx9wTERbXmzqAYIouCfajOyLKKOWlo5kHZH49DlDlWgx0mjd7WxfcuG66Um3aWWkMCpgu4KgxvVQFz/hGkiON6VsnirJtLAhcfxXip6dY2oWtHu381aawJvhOGbzRw+0xIDOYuOEALZUGyPFbdY8PzkT+VIF1A0o7GqqlrG8mxSNTVT1DIX1mgbsBL9h9r7WUjmto2/xq9h7LA9CPFSnLo6l1hPiioiO0b199BrvmBa3DhkK8SSGhvlmMPFsNLmIuGkJHXuk4WY8lHzdxLlQMrBwmg0XDChbrgHX53RrSLdEEKqfflOP0OljX5aUrVdPAEBCKo0Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3qB6dAMQSAMjyYsxtg+ZQWVn7KQZ4qjPQQ12GM+ISw=;
 b=nyIsZBAWb2k430wkKN8qJ8w8dy3rIQ7nA4/92vTq6ZRZvWsfKqYx7SML2hm6lijqBVymgL2In92aeal13VvJbb20jRzmKyIHPN5BhTJ2JgFIly5HraUzayUcWFp4V7knNvRrKTscSjaX6OgTxB6pVxE/XGDTaR2x9j19uXMzK581769Oagxi2rgY/U5cG8Va+syHjIHDzPq6gLvU9/KUD+CVmcgww3Am7NXGXu55aZDF9lpncXlTWmcdGbG7WqqQtjSv3Ez3newOoW3+gvVygyyaE2+Fj27WC1LQXNWO2ena52UAFrw8Dgw4pT+bqOfZCq4BJbcIPmU5PRcXjuuv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 06:51:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 06:51:51 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v4 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZeE8RCgj/749FWEutlxspyctm3K8+typQ
Date:   Thu, 27 Apr 2023 06:51:50 +0000
Message-ID: <BN9PR11MB5276B3415711B74816D5D9AD8C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-9-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-9-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4589:EE_
x-ms-office365-filtering-correlation-id: e201d4a2-85db-47d4-0003-08db46ebe10e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2GvkkufEhlHIjZVopJozgxdjxDGRrEMkJbAVg4Bi3paqx+FUoZfewyzP33aVrDIlvOzbU2WOCQSoVf2KC7Tm5SZoz9QOEB+Jw6jte7vy8QlZiur0G/cTJkdC6JDsLf260eR6dlF1tta36V0A1sFBEMTPLIthbuSGPB1ToZvcNsMZFO4T8seq1SNNbUtjFSFvZ18Ym2XSewCMmoQ5OCx8VIrE/S0WCAWa6OI7iUYRIdDMReIpcRgyVOpyKdYMAayI0CIQ9KdNPyaByHd/aKajzMxgQZzNJkQo1YI5Uq51bgn2AS9BxsAFUH1aBCP3EGrfGBEduYHuWy4c3GhvUHJCvOFZBIHUHBuUcY47zc1kmPhbo6jEzDOVTVJ+lOZcNAjrlm0i9TPs7ZhNlXmmUDCB57LpavNjpyqNLX3PK/mGD/pAtEJddy8QqtA4tVsmTrpvwcxN9NUPwwOKvsfbHbGJoVRyMAP/wFDCLQqbsjy8XAhAVIKVvTjSYUH0iT9e4vlq6Tg2NrD1558bniEgG2vxkAdbepAITEo3PybUUoYmKSQ/hiB/yAzsDWQhRQQygdFoc0XX1FeF0rxWiPpFaFedPy7lVhHQRdJZTEE74qbekIb4HHBKZZfMWBHPbOiAVUGb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199021)(66556008)(4326008)(64756008)(66476007)(66446008)(66946007)(76116006)(316002)(110136005)(2906002)(54906003)(478600001)(7696005)(8676002)(33656002)(71200400001)(8936002)(55016003)(5660300002)(52536014)(186003)(7416002)(41300700001)(6506007)(9686003)(86362001)(26005)(122000001)(38070700005)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IfxNyrt2SUaJ4TApwY/W246Vy61c/i5HT16AYb6MZYOIPjU/alrt32ht+APZ?=
 =?us-ascii?Q?5A2a5kX0fvk8Veq45mSmUkUwnZWxxNoqYmB71wwA7rsIcnXlpdwUf79X497o?=
 =?us-ascii?Q?CfTG7QW2Q2dK5uup9VsR8+sIM59c2Dw7NBy9zYyWKo/IMt3l6FGO7cs3p45g?=
 =?us-ascii?Q?TQRb8+7FONVn68HYgyMVIcN53jJc85MA/lBiSPae4Betr1SnK/9kwhxzGwn3?=
 =?us-ascii?Q?x/FUNt4xNhqgSiAcwPBUePmeozuif5IAUjG12RwuHp+BTRCkV4Jrs19yoCTH?=
 =?us-ascii?Q?AklbuGrceNkqFGYnunQ9yZK+TJdwqqduvFjJ5/zZAHYoMd+Tfm2uSeKEthmP?=
 =?us-ascii?Q?FJXvoCa2obKB/IEclx6Tpkz9F39cRVcrJ/Grk349hM9OxDthxRPSi7C81EiP?=
 =?us-ascii?Q?J1c64LIzxKStT5nTj2Ldquuv2hkkYeaQGHP+OxPWxbQQtcRCCttyqccb410u?=
 =?us-ascii?Q?emylpGRNcX+Bq7bTDROMysww/30pwe9jYDeU7HM0uwVhGKCwjZaalF7d5rkG?=
 =?us-ascii?Q?U0kgQQJ6N3POVjCsi/cTca5GtGWKSYW3uHLTsOaRfyNrirdbLqQxMhHIAHMC?=
 =?us-ascii?Q?JwGWPTFrIwZA7FYFfcnY6ysxUv48/GaOc9Tw/Sbg+Uz7l82fh3EBxaP3t+E+?=
 =?us-ascii?Q?jv5n6rHUknwuaaBl4BTA3nVieQKrUcwJb9M/aMS1LJuYblwOSRhg8o37h8Vu?=
 =?us-ascii?Q?zH2EABTqjVZqSTCFpimGB8N86ADSPe/mivynJZy+/9uXkrOFHdx/LoTacvp3?=
 =?us-ascii?Q?/B721hClOdGHOPjyW/d42YD0nvISV6Jn90pkovWGtV9WVvmDXYjamdJjVZ1y?=
 =?us-ascii?Q?GOrO83Q+wcT9A+9aIpkn0kDx9tk5EJgFRYXTxffVp51n3J7Ml8/oByQi3uHl?=
 =?us-ascii?Q?epLQa+pmF/DQXu8yv9NHiyCLBOGbnvLTuprTHL2YFiY3lyBpUaUnvAjvoxJm?=
 =?us-ascii?Q?NBOfm5n3vesIEw7I3rXFgfOMYWXeQl0pDaCXo8FtGz9vKPC8emrAIDCAiqof?=
 =?us-ascii?Q?Mv0jBhBCRrW4SEl5MCPKh/XB1ICRk5zrC3aZFFRHuOnviMYev7U/Sv/oexRD?=
 =?us-ascii?Q?zEH/TJ9WJYvzWCS22WHYDeYmzqDPFLMrLsHXPeKbWyg58HWNAhrPKD5/nDJm?=
 =?us-ascii?Q?3oDBxyzhp/A7mqbUhx5ZNmAjd3h1EFL5/QrX6IEB8kegM+39ZMjLaFGcfI8C?=
 =?us-ascii?Q?Lqce5Lo4uxa3raswc83i0YjAM3gC83A8Hk3IaWY/41j8ir/+2vcfrk/T0CiR?=
 =?us-ascii?Q?kY6ok7YWeOJ3ug6edyYHX5D66SzV6ymYzhhA+QOcRBBxLEbsWh4M25A07bfT?=
 =?us-ascii?Q?FBaeUOPeBOZRgDTInw33knxzisVoaJa2c6zAMwuGID2KtwS9zQbIHaBSOJuY?=
 =?us-ascii?Q?PXDaezuRPjw66nDd/j4SskkkXHedZcTvLLBWyc7x5khIWWXZ/dfUwRocxkOQ?=
 =?us-ascii?Q?DHZayya1wcSqVo6neaa1+Grv35eIM5FXyajIaToDFny1QkNQtjDNmT9x0Pzt?=
 =?us-ascii?Q?uoZ7R9PKLKwPkbFqWY2AFkcvW28Z+wu5TxW7r+8a7eL0wVLlUP/gotszReyA?=
 =?us-ascii?Q?i9Jac5Dg/owqiFJjoYagZTw6Yizq6OQv1BtcAhAq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e201d4a2-85db-47d4-0003-08db46ebe10e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:51:50.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vP8Duvtvz9iZNiTId82cQAawcNFWEUCHSd92HTLVimEOgLvcgqA8yb4OJqCoSkqGWl5iXnACqcJyZi4FD7i0Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
> +
> +/*
> + * Check if a given iommu_group has been bound to an iommufd within a
> + * devset.  Returns true if there is device in the devset which is in
> + * the input iommu_group and meanwhile bound to the input iommufd.
> + * Otherwise, returns false.
> + */
> +static bool
> +vfio_devset_iommufd_has_group(struct vfio_device_set *dev_set,
> +			      struct iommufd_ctx *iommufd,
> +			      struct iommu_group *iommu_group)

this function name reads confusing. Probably just use
vfio_dev_in_iommufd_ctx() from next patch which sounds clearer
and open-code this into that helper.

>=20
> -	fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> +	if (fill->devid) {
> +		struct vfio_device *vdev;
> +
> +		/*
> +		 * Report devid for the affected devices:
> +		 * - valid devid > 0 for the devices that are bound with
> +		 *   the iommufd of the calling device.

">0" is inaccurate. All values except 0 and -1 are valid.

> +		 * - devid =3D=3D 0 for the devices that have not been opened
> +		 *   but have same group with one of the devices bound to
> +		 *   the iommufd of the calling device.
> +		 * - devid =3D=3D -1 for others, and clear resettable flag.
> +		 */
> +		vdev =3D vfio_pci_find_device_in_devset(dev_set, pdev);
> +		if (vdev && iommufd =3D=3D vfio_iommufd_physical_ictx(vdev)) {
> +			fill->devices[fill->cur].dev_id =3D
> +
> 	vfio_iommufd_physical_devid(vdev);
> +			if (unlikely(!fill->devices[fill->cur].dev_id))
> +				return -EINVAL;
> +		} else if (vfio_devset_iommufd_has_group(dev_set, iommufd,
> +							 iommu_group)) {
> +			fill->devices[fill->cur].dev_id =3D
> VFIO_PCI_DEVID_NONBLOCKING;
> +		} else {
> +			fill->devices[fill->cur].dev_id =3D
> VFIO_PCI_DEVID_BLOCKING;
> +			fill->resettable =3D false;

NONBLOCKING/BLOCKING is unclear in the context of devid.

since 0 and -1 are talked in all other places and above comment probably
it's clear enough to use plain values?

> +		}
> +	} else {
> +		fill->devices[fill->cur].group_id =3D
> iommu_group_id(iommu_group);
> +	}

move iommu_group_get/put() into 'else' branch.

when calling vfio_dev_in_iommufd_ctx() in the devid branch the group
will be only used in 'else' in this function.

