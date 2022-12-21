Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328B8652BF6
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 04:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiLUD56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 22:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiLUD54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 22:57:56 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0363F108D
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 19:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671595074; x=1703131074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=//oYpctFL6F7hySYBeNoBQtT4H7vqg+gur83a0yiHAg=;
  b=dHrIgKzZaVaQiiemKIw5mhHvOB1yBfabGDStwFUF+L7Zzx03YpD+XpSI
   eh0oop8drixwc9H81Y/KQL4X7nSpGBtlFoSaN8+/uYKWdSPeEZXB208gp
   BTxFpbZMNiDxbYPqZM/+7t5XolhMQeGvxJ6e8soQlktaRFWtDaLN5VDCQ
   cjuAVugL/ULvf69kmWPqsrTHp2lQ/56McbfMA4lG/J4JPx5eBMLT/+R61
   6wOOdp481968POCDd/yoWHcrYXHSM6OzHQX5hxdHAn/fRovyb5REuLCAl
   Fkt3E0l5gszpjo7heitN7xD9q+L3V5YGYJ49f84vjAFyDgLmJyjdTUnEg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321687577"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="321687577"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 19:57:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="758371980"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="758371980"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 20 Dec 2022 19:57:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 19:57:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 19:57:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 19:57:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 19:57:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yka1IcjBW7orqGbQ0rjpyILt6D+7bwUShCImGN9i7IuRB7szXvW16LSO25LFNsnL3B6nBHExHsmEVIc+MZXGDimGHBIqKv0h42e24wiIIVcI+ZG5U2dUab2SFXrrojuWEeXcfoo7Nc730boUKBnZHL6Xr2zpyG8lXsWDTb4Qw9BOr9xt6UjpX3apO9/LqhMrc9jT5VJOddbDS+e/KJ8bS+Ih6IZUAJrE+UzVDJj8BM6pm9jDPUjZF2nLAX/FW2kUu862Ie1JFAdCt2+Zxn0Z4mjrlf2y0nmQvv/nA9spMSHOOgAZiHJ3045irriatmE+CXPJwpTHNo7bd0GOoEVI6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhFpYzMnHOfzddNrZnw8csYMihch1MA+py+vaA/NXAk=;
 b=DdBd+QinboV5RwH6cY7RPkL+pdGzQixtMmifaZB1gOdpOREGpVV2+Y4ayl1l7VzWKWfurriigDdC9ClMBarhje/Q9TxRrCgr5pzgLV0lj8VL4Cz+e3QymgKnYfFf9eqeNJAKZ3nxelSRarY/e2BlNk0vGpE6ULZcIKslouq0fbCAaJ0UZzw5x02aAYHw2PyCSqGhsY8MZt5cydP/86AUGWAMndJTTJHJqrly+aC5zPMWLkIGelt3PjQGkT2FWg0n5iY+LJR5Z9HgwUfuo/KY938yRCywcFHoZyTEaIkWnl90zHLaysF2SMoDTA1puJskS/LNYVxzJ4gwYgdFRV5YxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8129.namprd11.prod.outlook.com (2603:10b6:8:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 03:57:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 03:57:40 +0000
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
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 01/12] vfio: Allocate per device file structure
Thread-Topic: [RFC 01/12] vfio: Allocate per device file structure
Thread-Index: AQHZE4aS7mdeOrZhBkCfz9xHON931K53pwYw
Date:   Wed, 21 Dec 2022 03:57:40 +0000
Message-ID: <BN9PR11MB52761BBD44F2CD5C121035708CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-2-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8129:EE_
x-ms-office365-filtering-correlation-id: 00713d39-4bb2-4f4b-b79e-08dae3078181
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjbvV+oif3zaFyl3ORuNjNYi+/K6aWn0TVkKsQL1xsgg0YQgKgh5eQg+l/tYmsTwcSQjrFL3hCPFva+hb7n3qPtsyh+GLCwh4W7l6DUPQU8EMZxGvgTnX1VSGOOQh3s7oK31FTRwFEVa+edzGktztlprhJKuxlYmKXqhMmviG4YuVhDZutoYBuPEGLH2TVj72zNMbXPQA4HJuGaEKeg2yl/1rem9glFmhuyax4/HYDHxke2ZaEBC6uV0vIlBFrJqHWXKZao9O6CbNxzUAsX1uYT7RcDhFtiASQVS2cnUPeSEhHx3N44d/KYc+A1L9yCYXR1vANjfibc1QBViPj2HjFbMT6mDyi/miDHuOhqy71NiLOn8E1XvbMCKEXpkO7SACuz4HtR46IY1pEk4aAceNyg0zi4FBq0fJXHo8jgdAicWnA9sAwYuyTnJDfF/ZwVRyvj9lY+qMdvhY8UsIMZXRMb/uOujkrnnwUuSm9yauFXRL/zfWX0zir9NdEnfitw/CFkwIXxx5bywsDVyF+VcS3c1R2wntTEXOBHTtnPlyFnsubQRcGhYPk32Z/fHaupPyrAiMulRlYc+clmO5WU2yxzcvuvqgnnPhdBgCgVMsWhhxKSjpDR3h0r5Hjv9C057NTfGBBbNh4/JHMbp5dhyN/LvAXxN6X97YWC7u9uL69lTIdsShIq9movLtjfsvdJ7iPUt+SI9ROOP1FxSoYl1+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199015)(5660300002)(8936002)(83380400001)(4744005)(52536014)(33656002)(186003)(26005)(55016003)(9686003)(41300700001)(2906002)(110136005)(316002)(76116006)(82960400001)(71200400001)(7416002)(478600001)(54906003)(4326008)(7696005)(66946007)(38070700005)(86362001)(8676002)(64756008)(6506007)(66446008)(66476007)(66556008)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DhxYgoVC60DtIy6z408OSoSN17/1+zQw7cGnUcsf2kGph+W6rvzzIRiLrDHp?=
 =?us-ascii?Q?0kj+Lo6YGVVO1AU+E4yLxlzjmSHFXDCE1RcZDUVLywNccu6G3nP3R/AE3DBB?=
 =?us-ascii?Q?OhUOuHtJQVqtTy3sRVMKRalJ4f4EXGygLhE9mZBXp5cGQnhvD4Vmcm8G8veF?=
 =?us-ascii?Q?Cnc21aiwkzaLCQqp/mdHOI/g8WuebT6VTPWklSGd8hD3DAJn0C10kukbvrqD?=
 =?us-ascii?Q?zst0oKuN4eAOgXNJ7P0/xZCUs3O1EBZ0aSAa/1ni3i08hKeMFPJgVdolbJCH?=
 =?us-ascii?Q?VbpLnBAcpwYrMklvGFIUA8oTQPz3B0wxz18qxI4xtxd+o+ym65LfgcW6bTWd?=
 =?us-ascii?Q?Y8aEhe72hXgcYoR+tN9gZ7u+jDZ3g+iHOFvuw0aRZdOnrGGR/XDngdieKLIp?=
 =?us-ascii?Q?M8GoIVHFuvC6BBgqb3bamnRvEyT2fAl7QM7zOg1/T4U/8EI8zJ09H55jzPnT?=
 =?us-ascii?Q?Tuauu/3kbdLE9LwG6Ker20EO5c/mbfrtd9BeNZPFpWrSyf01uWErSQPZPo96?=
 =?us-ascii?Q?Ep1nINxa4M9bRK2X1NRUwi2TIMa2TenxqmlfO+sjko8VfVX9A5TIZOkgxFYj?=
 =?us-ascii?Q?LJCW8y+OIR7oJO/B0kmHn9ceUFT2MrKYcg2hReMDwIj0aCBQwx/wMamgJ+lU?=
 =?us-ascii?Q?Z9cpY0SOsQ5m5XrKZkobyVLcyXL3hdDEqHuJcetD4Q57qpmSI1CKtYIWqbnE?=
 =?us-ascii?Q?UQsrwDd6KcQrtJWKhr2ZdmRyPfO2mlxOestEcyvxHK87+bABVsNnpVY42SVO?=
 =?us-ascii?Q?gCXbg9o342nF6RWhbPRLfd9wsZLrsMXhqk+3ZFu3uls22dvp+qm7vixaRwzY?=
 =?us-ascii?Q?9GO/Jx7HAJyE1ziv0Ij0FFC3KU+4Qh9HDcSmS1n2mS696/5WKptg5kXclQNO?=
 =?us-ascii?Q?Q7zpCgKE3SPCJ8/r/XpoCiC7lZqnsQnLDRKK6ayFdxMlJ4Xu4cxZKTI6rukB?=
 =?us-ascii?Q?egcAEiupvkiRRPayI0Hn1Vo3Ah8cmWZHhIonxbh+ws2VULNPOJU3k8dz5zlR?=
 =?us-ascii?Q?9oAZ3z71xHIKOx/gnmddwqFVjtQIeroc4cbGrZcyCNX1KW07nb/674qgVuiS?=
 =?us-ascii?Q?oAfGhkaszhdRn96QlMxOV03Gduo5HaRm61ucw5pxTMxyqVnWLW4c3pl6LDIa?=
 =?us-ascii?Q?CjPBQTrAVklJHYP8FrmnGIvehkoDTBkRg5eC2jyb7rYmtF3NH4nKQK75EedL?=
 =?us-ascii?Q?pjSnQ6waR9jXL7ptoNUvZoRn+H/98qJaXSFtYHtAPmM7fQbH2Q3Qgq4diegl?=
 =?us-ascii?Q?hgL+1vFbkZbQcTTnLPxiElsE825iT1pcutIfyi6/p+fDmN67gRcbMM+cdC9S?=
 =?us-ascii?Q?jzAiI+MHFS1M7V31Uf5o5kJqGvdC6V4u086LoImYnn2nivEsMd0kyxWDGIYL?=
 =?us-ascii?Q?u1P9iOqnNDV3OChDK0bORuVxr+QyoJm+T6zNMdclfQfj+Hoo9xhDCsWSFDmW?=
 =?us-ascii?Q?7DR+HvcbHPzHA35tj5g4Zu615jecEfJLuDaYNdylLoNGl9zTbF4GCFzq560V?=
 =?us-ascii?Q?jN6lOIEJ4pUqB7K5oN60+QvaWUFuxl5iZnLiBZuKxVAz332Y1eIDlN5xHYyI?=
 =?us-ascii?Q?DnuLPNpdvlm8xjxnlELIm9LRdSHwH5romPsdnWD6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00713d39-4bb2-4f4b-b79e-08dae3078181
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 03:57:40.2916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RsaAZJoFh9jo6atUzti3+gObgpOkEhRX1WIBBuLqu7Xfmg4doqGFdXGAz8Pa2cK7EEvJlB+zKXYEDaf5kRzqKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8129
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
> Sent: Monday, December 19, 2022 4:47 PM
>
>  static int vfio_device_fops_release(struct inode *inode, struct file *fi=
lep)
>  {
> -	struct vfio_device *device =3D filep->private_data;
> +	struct vfio_device_file *df =3D filep->private_data;
> +	struct vfio_device *device =3D df->device;
>=20
>  	vfio_device_group_close(device);
> -
> +	kfree(df);
>  	vfio_device_put_registration(device);

Why putting kfree() in between the two invocations? There is no
strict order requirement of doing so. It reads slightly better to
free df either in the start or in the end.
