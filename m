Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A4A68CB42
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBGAfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBGAfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:35:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E57DB4
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675730151; x=1707266151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UvojFwwZ72e8GG7KXzlxJEmUGa64YfMRFiSEL9IzcNE=;
  b=DvsdO6ktQjkDiFRm0qeTCwXMOcToLR7zVXA9EJdVWPQJcISL05G0w3Ly
   dGcKTBIgXAh3Gmrv7KNC88BcBrRh5jsexglbangC9f5+E+hwbqINFm2zi
   fe6CR6M2vzfPUcU5usQOvx/1LfMqOVWTwD10kSiqioaJ9lX2TKQd4jmbQ
   1NhkaySV1O5sxhCtIEgzWV/BUPIgyzUN2pBTWH+vdDRt3ao0tyI+nkNh8
   afo+Sp5m/ThgpU6x9Sdw92/5jfPbYc9nosTCz1VlYGsAZFyTTamZrUzXk
   IqMEtkkVVg9+pP3PDwe28ugejUQQga1QCuZ0WW2czzkGhFlLbVNb/Dqp6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309004443"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309004443"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 16:35:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="735350486"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="735350486"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2023 16:35:51 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 16:35:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 16:35:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 16:35:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 16:35:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMlZ2+1SxghiZWFO83dlszuREYLPeTWZSgp9p84305vazJ5Cd+mz56pxL5d+pCZESYv1Tdg6SKtjxa0VjJtcYBbtKc7MFy55jJz13Tkhbp+qRuWP+A1OGZlKdQUcaZvbP5EZWQymHYbFtxAK1FBgY99CIW3YbfV3NAaNfsPVYstetAWdElRzpJKbp7NFNMDEpxsDqTslkk/lR8GcIfwLLarOZzTzeXV5fozxh85z/F+Wg4J47xYdJbePdhY2TSiF2OuTmPnTv8JdZ1DExXY8wwQ45dwJ5Yv5GaJc38laXtfuDseM5h5g8CuvHVnOov6KdgEWV4Ma5xDax8ps6F4f1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAEG9iN2oDW9M0Otty6Nv4hPK03nUXS4IL7TD5Jdliw=;
 b=iqhJHSNMn7gfeyjvVJtsFZO7N5jDqUEGiugsUj6dee8jOY6H+C4ez+NVEORy7Qm0hIcsY2coRozahSl9UrxbDr9eAQHZ/yUG4QLIN0UsNvp5KZB3/gofBL2DUkYJIheksZhIoDYtfIjDxwoH3FPUkDsPg+TrSsm8zm19SrJLLyz8fNj7DHdaZTmvslkgDGu9JzmrUVvCk0P275PU5MEhPDTe+okIieGsAMT4yXX4KLkNpkfJuM+pZEakq/Zoc5Qd4Q/s1+wmHDmV8e1y/AF5M7jzSNc0J3m+wB6jcAel272ZkOGdBOFaaJtygKGFadFs6ibYP1Y52gFSSiHN3ndO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Tue, 7 Feb
 2023 00:35:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 00:35:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqafBBqpcX9SES7NJ4Rmsa6D66mbRKAgBCGzgCABEckgIACXXuAgAPaJICAAFxyQIAAVkaAgAALUYCAAJKEkA==
Date:   Tue, 7 Feb 2023 00:35:48 +0000
Message-ID: <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7400:EE_
x-ms-office365-filtering-correlation-id: ad957bcf-5f3c-4b8e-0f7b-08db08a341ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTd5hTv+zeZ6ecopFQbHuuVX2UHA7n05WwLv4wGhiwINtAKj+Y2V9PaG54bejwpq3PQPuxE0A41tPEuTK8FDPbuGazDJonbPzOiu3KZ7Z9IlJCjsF7dCzH4g7yipNOtasYUEUYPgcPsg6sz9iu+8aRLdtcmvjZSvRPC/rKpvkvPa2Uruf5s3uyH1waiEXSRXrNbleuQr4WKpUqm9n30vAgU4VcWTGLlnjEmTRSZet4F/Fw7qTiC62AOTMvQjzZFt6pGZNU/oPSsDXSmskO9RF9SpDR2whndUz4FlUGZnJcoEN512AWTG51pnLklLi6CpYeB7RbniYQFGjVvmi5edmIpwgznCcI+aO1MQGBxW4LlgqSergDAS7HrmuUVvzLlDw8D7SJ6gUaR3bie3B8kClrFAsiocGepBn9tKJtSh5ZEANPUgHqBWR+zxLGqWdbYzTD/nruXejPS0JbhzQDwhz5rqR+4e7Rxw1u6suO/c2qYwdi9FgvChSt2TCL9Nzrv4p2XZiLzEiUqEmVo98qwRc3rdoBZJDLElw13SOGTuqj7msb30NzTwct1WGgdpcBJfyaHTrOqqEq3wyIxyRGgVEEvONI4MSjd2mxFpt2UTNux59zsw5gValPluI4L4Jn1UvyhUKSQ/kVW+mrkxTFFVOnGMuu/6DdEVyUSvwL1OGLzLbX3BqRkNXyxCCPoM1mvSlOfJ55o7y3iNiiTn7NGd1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199018)(8936002)(38070700005)(38100700002)(316002)(7696005)(55016003)(71200400001)(110136005)(41300700001)(54906003)(478600001)(86362001)(2906002)(82960400001)(52536014)(66946007)(33656002)(4744005)(66476007)(66556008)(64756008)(76116006)(4326008)(122000001)(186003)(26005)(9686003)(6506007)(66446008)(5660300002)(8676002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FTy1emX0LE5opBvW+I1W9mz7SI6AXo0h7m1pzvd6wU2GqhFTXuL9w50bcaZU?=
 =?us-ascii?Q?5Yry9h3CQxo0t2W+cJgrRHVCsXkjK8Jf//ObVpAwqLes8ss35b+xCOj2QrVt?=
 =?us-ascii?Q?LwC38YCD/0DpvSBO1NiPKk2F2K+4noGKXc/DoV0bcE+slooysh9f8+WHUlQI?=
 =?us-ascii?Q?q2TxXBW6xC1U6PyyN2CyToGx2lHnL22DMppsEKWMJaBkeGCVg1h8DBy18cFZ?=
 =?us-ascii?Q?tuDFFHMpb7kZ9RnQa/7WzTlMZuqsO2yNd+PCt6BKk0Yxfc6I8e+XuB86CbOv?=
 =?us-ascii?Q?c/GPlezhwb9ed4e9JENT4Leq4Ou7U9XAk3hUJme6MtxlQqjdKqQ9V2v1oLG4?=
 =?us-ascii?Q?mLpEKDiC4D0Kxot8yx1E+6zy6HAYasHwMKw66LMIfTubgbyHzkVSZqhjG9pJ?=
 =?us-ascii?Q?pBL3kGF6TX6w7+P8m6wDHW33va+3qcRfDp1mrdIch3HE3aXNW1Q7cwuCjZk4?=
 =?us-ascii?Q?uoppgS5k+zRkZL5UHOg/GH7XL1h4w7UNFG5ybWqlXpXpjMhfRh5zlJcfsvEp?=
 =?us-ascii?Q?540GDCH3+5an9sm/ubMW2ytXt5W4ntLurGVT+aCR6guhIWG5MsNgmq1zF79l?=
 =?us-ascii?Q?fdQkE24uab+E5mgUdhIMyy6pPHoH43Zce2A7TNn7QjGIqMHmD+6PzPXeD5ru?=
 =?us-ascii?Q?bgTzLmjIMAeEdyxYKL+WiN83f3T2jZk/E7RWG6EcjDXspwGT+3TIkR/1Zv2d?=
 =?us-ascii?Q?ndiZ3+YDt7zlOIRJ28gZR55m9xoC/DWAF8G+lc1NBkZqg019+ZtZ9ftVZrHY?=
 =?us-ascii?Q?Z36ADMKsobp3ub98+v1xUAO6HxsiWc8UtmuThRxZruc+nMOZ6PNw3vJbPClf?=
 =?us-ascii?Q?vdfWAwFuSzNyefl06qHHYy3VjAuHIFE4ewxpCXWzwoBkWjE7JSjT8eJaa3QA?=
 =?us-ascii?Q?WpWOrTAPte/CdbLNhJ4kawEP47p3Yrap/T0TJG5JreFLKE/NrQOmmF6mN4aj?=
 =?us-ascii?Q?2Em5kxzMA616CzjIvnVoDz3T5EY/ct554CkiQZacAoeRPss/GCS8cza6kyYZ?=
 =?us-ascii?Q?/4J1PugasNzMzCaZwKNVavMIpB5OJ/9wqwduqOSN+gxuPrrzReNOi89vVoEY?=
 =?us-ascii?Q?EmUWq1HzaPoFTaHtMSbK3Zao9eFs6ztZDFH9NZbDvwzauh/d9T5XzjLJoLA/?=
 =?us-ascii?Q?sBCZaqNSUKcGLUv+3bfMyQ2R8Ca/FOy6dTmt3FSI/SFeUjN8tv2IxW1+sMC8?=
 =?us-ascii?Q?VzhjifShQoPaL4TX8BUBzOoK9bNWo0BBCMROGJ1Uc3yirqH51Tr1PIjpfWQj?=
 =?us-ascii?Q?NnXiz07+j0PfRO/GDXCDSOp10N+8tWi4swkHQngk2IPOvtSy+1z8U1Tuiers?=
 =?us-ascii?Q?UgGkAB0otOtiiGS30Be6i285mM9y6us78OQa7ZYQixe9Sv8FTl8RWvgXklHV?=
 =?us-ascii?Q?BWtMU6CMdVKqgM93C6UQfr/JVd6542N3AzdxSjUYWNUvhsdGi7iBVlAK3rP7?=
 =?us-ascii?Q?dj5K8vfGMdlG9Jp5gmYeYEMfL4/K7fZDx1rQaSHnoa3MzOtlD0tTA64axy5J?=
 =?us-ascii?Q?CFqalXHPMlnNyprOgcigjBtfaFvODCej5GRytWry98aJGgCkDhpj9YQIfgfd?=
 =?us-ascii?Q?BpduBg6Z9W+D0Ea+/oZkVTdvsZJ2locrRPVVcv2T?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad957bcf-5f3c-4b8e-0f7b-08db08a341ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 00:35:48.1269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1NuWVe3JuLTS8CxZSE66wq2t37QZI3fbHy3QEQrXwxqGA2m4oIa6/xZb7kRY6gJZYBpULQM27p1AKHupgl98yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 11:51 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, February 6, 2023 11:11 PM
> >
> > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > It's probably simpler if we always mark DMA owner with vfio_group
> > > for the group path, no matter vfio type1 or iommufd compat is used.
> > > This should avoid all the tricky corner cases between the two paths.
> >
> > Yes
>=20
> Then, we have two choices:
>=20
> 1) extend iommufd_device_bind() to allow a caller-specified DMA marker
> 2) claim DMA owner before calling iommufd_device_bind(), still need to
>      extend iommufd_device_bind() to accept a flag to bypass DMA owner
> claim
>=20
> which one would be better? or do we have a third choice?
>=20

first one
