Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFC26BA64B
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 05:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCOEk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 00:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCOEk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 00:40:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E75C59E69;
        Tue, 14 Mar 2023 21:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678855224; x=1710391224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eg+pnztw/cp4L5buRd8s/x2hV1SRQMKmyjAsPAtfBhg=;
  b=jECDqOecEsqpF0VZAPzK66Nz8PtiE4OojFP56lx9NxY/r6p5JPRWNYzP
   pIkUDh4fGO7LpGzIoJ/26plUfiyTuNHPLLI4tj/dwj1IrBj+23x74KRN7
   QL1/JoKPTJuNuwAgttVYV/ztxTPycQiVkpU5P+5p73IhNF011bkiplp1B
   nxu6rAcmoDiRnSrOLz6WCgkCiyLfd7D1j/VvXwzauFuaTETdfuOB42j6C
   3fIsbDIgcMqaE6GjKYU9IWuNZ0d262kGbaTuboAgoLEd2bzzZLspJ40BK
   4C2ZGcOxnjXxOazY+GS6vPuZJOS6mxd9vFuvv+l+wacwNbe7stykQOR1w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400194704"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="400194704"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 21:40:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672596772"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="672596772"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2023 21:40:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 21:40:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 21:40:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 21:40:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 21:40:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePXnn1AwrOGPhMFRILTiuiuU1OfhkB5NfsISULSvePx0MtMYjv54ikUKVvhfuutkvzQH8lNVqkVdrrtNHoR+ySW7Icd5+5VIX4lFyovwWcAPbqvhZ7G9V15K3uB9Kh2xn0TtyL/N9YnLJBzPDfy3rp7tm0L7/ZlSI6t2TO78WuU/9mAwBQKR1TN5t9yCh9u3KkC/13r6nF8JyA6AHB88pQgDglFw/UJvuK9cJvUd8UwUjmjtA8IEtl91x1x9k4FHjdmJHCKf2b2zvZwYQzRLY3ak5IHJuLMbGtOFyJTfnF2x+K0QA8ZVJTS3/pCBawsB4IfxNtsZWQbpPdtCLLyR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SqngSdp70GO1hB2osTl/PIhcAVHTYNQ5YSGtTUne/Y=;
 b=Pt1gJW5kdhq/ZO/8IVK/8vNP1Ukv/9PoMUYDy96rLLwM63+U4YsUcySXDQDIC/T5Qw782TZvTHD4s74Zwo0xeBuOL5lnL0wBx3xQAGsME/OZqHutKs+51CFKB043F7nrm0pdqGagHeFA8+uvLsYUUSG3tDr57wtjlpROBEu8I1dPVFF/NONd2JoDGTPxgCW63LRZBFKJWz98R0vaeDQsYNP3dIQGo4WQwc8cHlZw5FHfVJ5XqW0hmD2yYXxuhRfbZroeNpLTHfiiLKFbXW/lkd+nfU1xyWgfdIXn4Xk1Rfx51659EpKCKWeHJBA1vNpVBvZy70+J7CdYDHItAzM0vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 04:40:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 04:40:20 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIP+SZa7TzGK02S6HlHFxIIra7zumiAgAAAm6CAABGNAIAHfd5g
Date:   Wed, 15 Mar 2023 04:40:19 +0000
Message-ID: <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: 9f0decdc-f4ed-46fb-8af0-08db250f61ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJ2IUO0FV8iLyFh9sTvngxIJXUFDRDyQLgImgupQyZ1I38JXrO3GE2cG9xbxfCI5WKeKo8k4+irOmppLWQxfSx5ih+UCUMsyYOk+lLYUfE3PQLRrm0jB67TqBoPOMYpqMsCvUyq7ZFqyySfvpIeexwZIoKz9DwsAIRSp5Ze2qxmlZV0ySz6+Y1BddzCdm0uDkPkX3qkkEROAyqD3WUTgOTl+A1A0cuapEehZp4EvAeYs1lyIv1FsuSCg3RMwn0XlOweDyv4JIZG3rJSUKnq7T53QkvZ0Ay2WnGodQN7FrkLfLv3mRnQwXFuc60/pxtNnd/rkJWNGfex5UB5HKWKqSjElg0+bNDsdVAbp0q0nR8gWW1xcsFm2MmayduW5S+qLYRIWMVzh36FqvKmQLhP4/ToerfqCXjPn7Md3Yp9IvxEYnz5Tuo9Jx6WNFcHt467b4MjDv1A4IunBKdrFKvznhoCdKXr7/J6Cp8PSuaIZ5S0eIBRLtD/82Ynjb2adudT8rcyksa0ntkPA2wKasag4yv7t/l0Us0G6DhrfZY1uyU6mVs+3jAmACZkIVvEmn4v6FKnKzWSV/5bPVnsvBSFinqrMAjO/1u+kE+mm/PSEB0Jr8DsItdy9NsV5lisZH0XnulIQeavTBuX4qykUNvb5poHKrZ8L0/RQdvR6qWbWYH7zoDUeXmiqoGXUHYAuhoRcRRjP5BBJfOnVhTkjmjKWTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199018)(41300700001)(7416002)(52536014)(8936002)(5660300002)(2906002)(38100700002)(38070700005)(86362001)(33656002)(122000001)(82960400001)(7696005)(71200400001)(478600001)(76116006)(66946007)(66556008)(66476007)(64756008)(8676002)(66446008)(55016003)(4326008)(110136005)(54906003)(316002)(26005)(6506007)(9686003)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6310jfqoxLk4vq6PZoAkGWkar4H69NQGT4m0SlFFRLvBcNZsuSOxLk2VEEHK?=
 =?us-ascii?Q?TOn4dpznbLTnE17SqzzQCi7oCzivFDaZJa3cYqw41fkydBFtcFsfJqZpjTKg?=
 =?us-ascii?Q?aM5eNsMF5YfgqQizSC8U6b3wWne/cjUM3OYe8YAbTncanoiYGjAjpgXo26Go?=
 =?us-ascii?Q?1ZdThGES2XKXe+rXqT/6IEKPww0dg8fcCNCqcq5zbMb/O4mj0JhJFSlsGePT?=
 =?us-ascii?Q?pk6llsAEwJs0MbVr7XyoEdt3flPPSDqqArH2KsMXvjvNa6PeSbKntsJ3qMZV?=
 =?us-ascii?Q?7rGk3houlQ2MraB/4ntaKkLOkr8dDoYpWZKQWVpTPmpDp4+GbnF6gektg7W+?=
 =?us-ascii?Q?8cttSvhXRaQ2+vdtNYky0EZp0aWhTdgNYywhe8m/SvM9spRwFM4GLe5a2aFQ?=
 =?us-ascii?Q?uxtRYupMddTc4sj/Km+teaXU+BlET4JwugYcqY4suKGmFClz/CVqWYXuDdbe?=
 =?us-ascii?Q?2MLee2ZUC58CdsJJLBcbLqUF33RMTdqMz+HJGSa76f9iH/OKYkyWEQJwa2Vg?=
 =?us-ascii?Q?ibm/xevMT4niwBaq8izaOp83Gn8KTVht2zn56k3d0W/fuY70IP1t8AOcWJcw?=
 =?us-ascii?Q?d81Ca7ZzcpAUVtVbPXW/FioSmF8YxMUjmh+E9tIe8EY8JBoAhXDRCIk9GYQ1?=
 =?us-ascii?Q?OV5zDjYf3iT78T7ZjM4FVc72cNOpj8amqsChdot4QpjeFpAvogxpCUT/D2n1?=
 =?us-ascii?Q?T759TnZCXMg115T3uSuaEiAb9o+n/l4cYFC/jcLHQDeIOwZQD3tNd/QRtMml?=
 =?us-ascii?Q?WVJJhJyafqmXhMu3NphWBDHoaII6YYPgN/yiU1TIhhKvZ0hHqGzaunG72See?=
 =?us-ascii?Q?9uvgaTNwx7EC+bMN8dtm6YtkQ4OiegOHXV7wR8g94BPqwv74ZkZraQwOQkbx?=
 =?us-ascii?Q?FemYSPe2qtBjKOWJHLS6nvrjq/0AlQTpzX17q86i0VGVkUOBSnUnJHfe4LlY?=
 =?us-ascii?Q?Uo4O7+A05WOgDjr1f8ZPqxvr3zTP9OnCblWjD2+yPGv/GU97XXTVjREqoTyO?=
 =?us-ascii?Q?z4zqT7o7Xo0d133/VbTtkhXn1CIU2CD8NWa6+/Z7yxL2RlZU3rTc3sfINQWb?=
 =?us-ascii?Q?eW5mXgot4/E/EbpQw6yidmocBkh56wn/U/eKUHyoU5UQpAJw5H/KyzoIPf50?=
 =?us-ascii?Q?6BcJa1liSLHY16ulTnHTnto0v2mxBdxidBDwwA+5J9wBy8cAyT6H44YaxKGM?=
 =?us-ascii?Q?GFY2Jvr4V8znVJ3ENbRBDJmIo94RIfXBDOODQnzBEtZQ80rEsYg4RjZImVln?=
 =?us-ascii?Q?B4GbdAJfgU150dp6bWt3i0cbxzcCRK0KCCQF42XFcYxTd97JvlPl2MYK5/FM?=
 =?us-ascii?Q?P6f4pq3D1Jro+E45hJwqrRZQFXRFYoV98nWe352hvTSrL1cbU913wkCSBKxg?=
 =?us-ascii?Q?x0WGQQJ2gB0BNeGnjhq9G7fHQXMLMjhdSr8vG7DBxRe91Tvvapc/IEMPhJZc?=
 =?us-ascii?Q?f4ObK6S1T+VxxbSY3CB/LogR3vtfNEmvUCVV+6W4ms3G07rLhzTXgfSlbkCh?=
 =?us-ascii?Q?TWuRQM0/RNYtz7N9dtTa5Z/rYvi9aZwPszgiHsmy7S7uszoBDI3oSzvTdfrC?=
 =?us-ascii?Q?bOM/cLXyWzg5CBGlCXDFDO+r77GBBBgkusVf7K6V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0decdc-f4ed-46fb-8af0-08db250f61ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 04:40:19.7097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UWUbyrOVCNkN9reyvH1Ya4A0hMJGhz6v2UvxjRfBa1MBSUuTML4Mm2OyJULYRXQqH73TGqbnYZ6i1xq/LdEaZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, March 10, 2023 6:07 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, March 10, 2023 5:58 PM
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Friday, March 10, 2023 5:02 PM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Wednesday, March 8, 2023 9:29 PM
> > > > +
> > > > +static int vfio_device_cdev_probe_noiommu(struct vfio_device
> *device)
> > > > +{
> > > > +	struct iommu_group *iommu_group;
> > > > +	int ret =3D 0;
> > > > +
> > > > +	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!capable(CAP_SYS_RAWIO))
> > > > +		return -EPERM;
> > > > +
> > > > +	iommu_group =3D iommu_group_get(device->dev);
> > > > +	if (!iommu_group)
> > > > +		return 0;
> > > > +
> > > > +	/*
> > > > +	 * We cannot support noiommu mode for devices that are
> > > protected
> > > > +	 * by IOMMU.  So check the iommu_group, if it is a no-iommu group
> > > > +	 * created by VFIO, we support. If not, we refuse.
> > > > +	 */
> > > > +	if
> > > (!vfio_group_find_noiommu_group_from_iommu(iommu_group))
> > > > +		ret =3D -EINVAL;
> > > > +	iommu_group_put(iommu_group);
> > > > +	return ret;
> > >
> > > can check whether group->name =3D=3D "vfio-noiommu"?
> >
> > But VFIO names it to be "vfio-noiommu" for both
> VFIO_EMULATED_IOMMU
> > and VFIO_NO_IOMMU. And we don't support no-iommu mode for
> emulated
> > devices since VFIO_MAP/UNMAP, pin_page(), dam_rw() won't work in
> the
> > no-iommu mode.
>=20
> correct.
>=20
> >
> > So maybe something like below in drivers/vfio/vfio.h. It can be used
> > to replace the code from iommu_group_get() to
> > vfio_group_find_noiommu_group_from_iommu() In my patch.
> >
> > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > static inline bool vfio_device_group_allow_noiommu(struct vfio_device
> > *device)
> > {
> > 	lockdep_assert_held(&device->dev_set->lock);
> >
> > 	return device->group->type =3D=3D VFIO_NO_IOMMU;
> > }
> > #else
> > static inline bool vfio_device_group_allow_noiommu(struct vfio_device
> > *device)
> > {
> > 	struct iommu_group *iommu_group;
> >
> > 	lockdep_assert_held(&device->dev_set->lock);
> >
> > 	iommu_group =3D iommu_group_get(device->dev);
> > 	if (iommu_group)
> > 		iommu_group_put(iommu_group);
> >
> > 	return !iommu_group;
> > }
> > #endif
>=20
> this makes sense.

Just have one more think. vfio_device_is_noiommu() is already able
to cover above vfio_device_group_allow_noiommu(), just needs
to make it work when !VFIO_GROUP. In the group code, group->type
=3D=3D VFIO_NO_IOMMU means vfio_noiommu=3D=3Dtrue. So no need to
check it. While in the case !VFIO_GROUP, needs to check it. So the
code is as below. I can use vfio_device_is_noiommu() in cdev path.

# if IS_ENABLED(CONFIG_VFIO_GROUP)
static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
{
        return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
               vdev->group->type =3D=3D VFIO_NO_IOMMU;
}
#else
static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
{
        struct iommu_group *iommu_group;

        if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
                return -EINVAL;

        iommu_group =3D iommu_group_get(vdev->dev);
        if (iommu_group)
                iommu_group_put(iommu_group);

        return !iommu_group;
}
#endif
