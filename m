Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E127D09DA
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376457AbjJTH42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376430AbjJTH4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFBF106
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697788582; x=1729324582;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=fBlQIJYWDE7vOhIix2sxImwRadE6/cHb77cjEyVB4Kw=;
  b=lpz6vAZtnsrmCdtvSX/yzhkuTRlh08tv8RMUV28RrPDLtFQKs1wbBXsB
   bUTU8+JhZVdE1macZ6/+0eBz42fPfnZzBVRm4ETswfVPasKz0WCHsd2KK
   ko3F2AxQ5tMPTxiWQCjjJleS5UGoWZUS0hvZjVSomQ9SqFajYVgChiLo/
   7Xrm+FVWI76DSwNDCuyBAZ+Ehb5axyvpnNKmn8r0yYwVmJKSwni9oKyIh
   ysJyX2Tb1qj0vADn4DfxLw1TEOujHQ7UDYyol/4AR3FQGbyrv1ZiihqEq
   uVWplWuVN0MdGKT6fXA5PIdzgwqH3Q7N1D9wMfiVq1lxICZpGoOreLMp1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="376831727"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="376831727"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 00:56:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="5031059"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 00:55:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:56:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:56:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 00:56:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 00:56:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS+OZD/AERbPqZjdhgczbF8AW/emvNMmd/E+naB8NRFVqsYUTbkh2x6i5gYxHQdR0L37NEiNdE/DtOoEAKgd28u/UxIxQgwcsGL0gv8AK4u6uhA/ZmaQkauTzu+/GWNisL26qE6VL81Wipk7PsK41WCzqtVKNQ8zDnzpz5xDxkfoK/i3Q4L7DoNwMArskDX7fdoH8dNuskCVwn8eWK1D41FMp8SFsvSbNBEUkuNJI2ihq1YtY/bzYC5zTzXg5TvQ4/+IRdCIPEuALRXq6Gl6b6mCPBH2rqIXbaWUKGfBgRw5SS4f9iHe4mSSf5LIAJv6meVyM1hQjRj7Xm9t6mSS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsEYsa+4PDmcjpxuGM47f7hfELrDozMMfpQ/SukSMpw=;
 b=C0vE6oVO0o7SCwZQvgtBzfv2jd+lM+tp3bIYlGk6NxHKgBxTNBNy31i6jJCJK4tphz9pZ5q0klrenU3k8XfC71yvNnhxyNr8nL96oO6ie7/psLgn5GZx/bqGATmDRU9+R3gViNEJFu2GRPcJjZS22rCBmuPpyPqH0x2GKnw5zo4QeTb3Ldr7GINVDKHi8qEutM1boHIDNVtDhpVKcqNdbM6bFksE9WAu4AAH2g5UyS5NZfB2v7m2dSL2RUo2WtcBu6aTbbueUTdxiRvSxSTvJ2z/ML15CumMtXLGR/c/MhUYm6NnXFI5ClF4RnCeYsUChAjrq6D+8dhT3LaK4S4/7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 07:56:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 07:56:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Thread-Topic: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Thread-Index: AQHaAgGluSbZOZ2b7UuFBnzYedbfx7BSMuoggAAeFdA=
Date:   Fri, 20 Oct 2023 07:56:15 +0000
Message-ID: <BN9PR11MB5276CE4450862067F4871C108CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-7-joao.m.martins@oracle.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5285:EE_
x-ms-office365-filtering-correlation-id: 8d37522d-2d3d-467e-2d51-08dbd1420971
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u+R6Tg1w9vm8nyw3Fpg27arudyBzmzOSZ3HPhjjoY5orok4Ws4lWy7huNvpeG4PP+i0wHa4EMQQ6hGSYpAJQcRJjrNeFW5M5u/i3f7ovvJjARExMpsaMmG/973ku5cxc5wjJP8TcIx7J2AgT7d6QuGNdTql1uyhc9YZ9pkdbsCSsakCfc73gs1wuCMB38Ema+36tkXiahMYdNAtVvTE98v0Gq8Wfh+7Be3LX8SaiTrdROTzOaKCvpQGP8MrTTMAyutUrAJJnyTUN7adRo6uKU/epXvgGYb8SjuYijgvKYtSBxrUMLtAaZluN4uW3K4Ol4bDlBIvIiSa908WV2m5M6Wllj+1Sg9FlqvQslQQwaAiIFZvhihdMswqayq20oreWcoUef/dpg+cChyoFQMgDhX5az/NbS4srRIgum3rVk9li984E61JrAHLurm9eTpxkPjSmNqE9vPGsWFsfpYJqsGxkvpXsQh4qVMpiPWY6+TmF1JW1wxH/pjZO/g15apicjYX2Uzeo2IEcq40m6MnE65/xwePW8hA4NVBbl3sIPp5wg9VL5sAVWuFhj/UjXlO1tEQvK2DL1/g0GVF8BSDC4uhv58bnLOeiCMwBy3J5c99GQtrd8xYS15UhQN5QYlWZ3VvYL9SEyyzuPqrg58jg1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(396003)(376002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(55016003)(26005)(71200400001)(7696005)(6506007)(9686003)(83380400001)(41300700001)(8936002)(4326008)(7416002)(8676002)(52536014)(5660300002)(2906002)(478600001)(76116006)(54906003)(66446008)(66476007)(66946007)(64756008)(66556008)(110136005)(316002)(122000001)(82960400001)(86362001)(38100700002)(33656002)(38070700009)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mh40LVJNEuFhcNw1sVbOdglICB/ZWzuON+G5XqdSePw0JCWaVI5bLzIp0p0a?=
 =?us-ascii?Q?DHVP25NwsO9/qSNcOR2TWp5OdFr4I8PkXbcyspiBba6ZyLlAYkfeI2jzFFPB?=
 =?us-ascii?Q?tNOvraP6WgJPfUq6vSRDlDwQz/NShXUBEyxMTQb3STvhI8juyKkRJTDY1WEi?=
 =?us-ascii?Q?2/t58xGzzq2TJU1OQPtZusCiQK/Aak1NwxVrE5la+8FoD2e7vA7HosjmMTNw?=
 =?us-ascii?Q?XNdzXbneVgVVCG6IdABC/uO+VgGa9V9j82lBjuer4rrWZgYU5nhWPKVGxDK/?=
 =?us-ascii?Q?q8LiG2Cr1lk7o4cCptr9PWg4iy2UI1ZpdW6eeLpoTiWXrOWmFoaKSnISGYdD?=
 =?us-ascii?Q?S5Sjm8mcJ4hnfNmLUF4C5NH+BRCAtDKBIMxWqlVzUacqP6GD0tTtrcB5hm29?=
 =?us-ascii?Q?H8LE8Sxmy6gkO6l9GOrCZm6W2gTzQBB1E1iqfXcTubBSkTaUpwcX5aiFHqfz?=
 =?us-ascii?Q?bwfUE4CKmDbPqaSykDSACQZ0hWrBtEysg79YF5C/AuA1bPCXx1M+FpCstkGw?=
 =?us-ascii?Q?vt8qUEyEWlXwjn87GxOfHSjy0Yu4zn9sWd3w0ABkyFgvxdQ3BFU6NG7+N3cF?=
 =?us-ascii?Q?jmFhNQb6XodlzfgjLSeuEIhy3DK9NGPIU3VZgvqm8jmcukMi0EPe3u0u/ktw?=
 =?us-ascii?Q?A4Xp5zbQLnNdCDUo9NmXRWcLJlrnw1ZtMAo70EPC/taIBrvDgNovq+fommGN?=
 =?us-ascii?Q?zKkV1qPOvRS5WaKGOB+csXfAgq9kcnHp79Osn/pMMD19aVtnb2YdCAhoKvqe?=
 =?us-ascii?Q?k/XekPZCBc5V6H5wtM8KK2iUbo1mcpiz9y92A6tOKykDKdHVCjvlnwASh5S+?=
 =?us-ascii?Q?UACV/V9PyugLh3VkOWO8RuMnDPEZ5wKZrMEcf1gUoEnXMJEnaZtJjNtJpJPr?=
 =?us-ascii?Q?GkyijgWtHFFRU6pjaHbU9BI9cOQYiU+n9m+1ovQtWvbK4hIaknanwTSyEV6D?=
 =?us-ascii?Q?Ys//0PrOQqWuD3UXkU+tRQovrRKuTq8Drg/5vZm4BeKjg9qn3YvIvpECRPaT?=
 =?us-ascii?Q?metyXQjk3QC2DJFHb+cAoDOJWj2OnyDNH9UAM0ECDYSEUPF0GNDlYlpIVZPv?=
 =?us-ascii?Q?oHRI71Tozj78Nvabf8qS7qTTFuz3PJ2ix4lV3GUdwdQkbD0P0Ixh03jX5GIm?=
 =?us-ascii?Q?O1flXUMyNAIIVq/qHVy9pZpq2ly/SoxPwwAWUq3c8KORHR0vAXgOPf7e+iGx?=
 =?us-ascii?Q?ztoBYtzR781TbNNNQ24cR2+O7pYvdgEcFDbR6MozWRLnaXf4CGy+T3q0/ejD?=
 =?us-ascii?Q?LsAFErSBPXr++S5Fcrt8IqpB6AjoJP21PcoCN9jyATvjH0wMoRmrZJTdg4Mp?=
 =?us-ascii?Q?EoujyoZDOle+/XO3bRyiLTI4wxEd/DpsSna2zSUhcnMV9s2ckRaOfbTlbf9p?=
 =?us-ascii?Q?b8Wvz45ieRZHDubL6t1rYcyoqWjSqRrr9rwz8gp18rYC1w5wt3eBo/T9VdZO?=
 =?us-ascii?Q?YE2bKqTFfXXUb6eE9LZ+9xd2KQ6XRyKfxnoVGUGk2HlsR6yZiRTCDSpcO+/G?=
 =?us-ascii?Q?H9a1CSY9MjTEnkKAu6/MXQ75HYc+lsORvPS6tXSXr6faSXW1mdKLHLpvzq54?=
 =?us-ascii?Q?Uy4+NIlay4+vji46YGIhsDgUqNt69VKN0T3QlycR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d37522d-2d3d-467e-2d51-08dbd1420971
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 07:56:15.9127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5lr/rWvySG75HSKOhCUYPDeuXLoVWTvnn3pMyzDX2PXxlw+XbpAqMa+JwIpodJc5xA7AjvsVHQrL1w4wbMS92g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Friday, October 20, 2023 2:09 PM
>=20
> > From: Joao Martins <joao.m.martins@oracle.com>
> > Sent: Thursday, October 19, 2023 4:27 AM
> >
> > +
> > +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> > +			    struct iommu_domain *domain, bool enable)
> > +{
> > +	const struct iommu_dirty_ops *ops =3D domain->dirty_ops;
> > +	int ret =3D 0;
> > +
> > +	if (!ops)
> > +		return -EOPNOTSUPP;
> > +
> > +	down_read(&iopt->iova_rwsem);
> > +
> > +	/* Clear dirty bits from PTEs to ensure a clean snapshot */
> > +	if (enable) {
> > +		ret =3D iopt_clear_dirty_data(iopt, domain);
> > +		if (ret)
> > +			goto out_unlock;
> > +	}
>=20
> why not leaving this to the actual driver which wants to always
> enable dirty instead of making it a general burden for all?
>=20

looks I was misled by the commit msg. This is really for the reality
that there is no guarantee from previous cycle where the user will
quiesce device, read/clean all the remaining dirty bits and then
disable dirty tracking. It's true for live migration but not if just
looking at this dirty tracking alone.

So,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
