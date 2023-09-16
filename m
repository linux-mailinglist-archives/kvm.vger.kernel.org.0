Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E23F7A2F13
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 11:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbjIPJxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 05:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbjIPJxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 05:53:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18CDCD0;
        Sat, 16 Sep 2023 02:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694858012; x=1726394012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ub4i+7/Nq1xk7dy6tjvuEZbfUQbBpW9K/cCmy8f69nM=;
  b=hawuiMII1XLRvRkN3YNKK6qnSfaPivIhqi4xoQhsbNwjDf8npHghzTH8
   Iw7a+OvHFLxqaPeW2H3kex1OIdfciKQ7VYp0kON99n4Pq0egXri6gTPZG
   cCmTKfWFcMUM/YIMbw6SwNvs1hT8YdHDCIiWbaU9aPOLefb3m0Y/9AVo9
   BahWx9ixCfRR6/YZ68J+7Ikfb6FaP/ViwHwf0nlFnVTqv+0vH3s2K8MZs
   YAvXX3nAAtQ5JWEdcbp3bR71YIh04euYxjHiQxqMq0/IMsyA1f42xKlrt
   WyXSQSucwnBAlOdxcCOJ2pHTjtNFf/KpDX1J0zs6hqdQK1t8BMpBNyQCy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="382134742"
X-IronPort-AV: E=Sophos;i="6.02,152,1688454000"; 
   d="scan'208";a="382134742"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2023 02:53:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="748460147"
X-IronPort-AV: E=Sophos;i="6.02,152,1688454000"; 
   d="scan'208";a="748460147"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2023 02:53:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sat, 16 Sep 2023 02:53:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sat, 16 Sep 2023 02:53:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sat, 16 Sep 2023 02:53:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sat, 16 Sep 2023 02:53:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GImUnrd1f8IVYVLH1LjWHn8ak+4Llw1gZHIjDNel6SmqFjMxMfVXJkd7zxYse3STArAfYEZXNsMk5en/UsDcFOtpqsSOcDCmTeKtaE90axAs2ESxPiyP+1NjuUSm8jIJEd2B2SeWyzpJETTDGQv27ewgOx8OtADgdwLmGHE65KuBu5k90JkStDQlLlpkn+huF8+WzNhPJxxnp1eOk1MhNLOTq8RE58AbJwl55WyGpY0zmap0Q+0DPAH2zDAeeq1Qrg1BTRCnEfp8gI2ivTSB3IRODcdfedY4ZB5jbFMwD/cyoKAKz8zQ62YixT4MhiX0l1dFdz1GCQSTIRCvv89V6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zv5JY1cj4T9IqYh3UvuuWa/drg7kFTz+fYGLNRpIICg=;
 b=f3XdQRJkMwBhcYjcIDw3XMxnZyEidopYkS/fWL1bPblosmRqFjuTfTAweoKPFFypTp6lX7JnMokeevUG8EYHRAJJxyRATxUosTAeONpElvmckPzmYohgfFqyqi0t0Av0og34m3R+8YBqK+4yn+nQ8Aj0T3mcUrFZvt4CFDNTmZDUTjajFh6znMMGULmzhYLLeqODIWcG/lzULTbwtR5cgUV7UnRl7eSTbbqo0iuWaByo4LNJu8dIQWYRllgvOB7ckDjscnMdyOuoo0r3TiTTc4v2ARGXapxFv/Ow35ff5GQLnbCzkwn+mwNNy8AE3LXjNFdYHLex2fhAfqsh5CIL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4653.namprd11.prod.outlook.com (2603:10b6:806:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Sat, 16 Sep
 2023 09:53:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6792.023; Sat, 16 Sep 2023
 09:53:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        oushixiong <oushixiong@kylinos.cn>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pds: Use proper PF device access helper
Thread-Topic: [PATCH] vfio/pds: Use proper PF device access helper
Thread-Index: AQHZ5rFDCQ0JWtwtcU+DMfvAXSfZOLAcP/oAgAD5NlA=
Date:   Sat, 16 Sep 2023 09:53:29 +0000
Message-ID: <BN9PR11MB527624CEBA0B039CD62A8F428CF5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914021332.1929155-1-oushixiong@kylinos.cn>
 <20230915125858.72b75a16.alex.williamson@redhat.com>
In-Reply-To: <20230915125858.72b75a16.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4653:EE_
x-ms-office365-filtering-correlation-id: 3a352435-b0e8-47f3-816d-08dbb69ac777
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KxjsItxDZwOCn/MbDZ7MXKTDwNMJhdFSL2VGeI24tv7pMKS+5v1lB8vGo+4pSDCzLotrNh9eNz4vBLH493YcrkDx5BQLPei+4rVSCd8+xJiPtOwj0/PFuO6cWjeEZD4WpujKDSC7X2BIbVfhrBxSFdAKHbMr/6NOPRpdwlcsOvlUmgXmlcVwGGw/7j3fKBz7q2TC00zRGX0bQIbdSyI3nM605c4elGUMBTniVNI5DFvEFngOSQJ/B3xvM09Qj1CBkS/962+u/SeGT0aFKntUA86eWtIups1SHVOgIazYJ72Bhc82dmX8qw4nrxc58Gpk5qn8AVxd8BLBfhUObGgEwC8uXJFGaisAmNlExUMPEL4zoR2sW43QewE1es8Ku3LJx4M6dmAtKyaJmcbtKM5aDWQyONpjs7E9IHQWb5/adxvxMgeT5+Z04W5dG0mmL7kip3tcCyDShB93kTpwb4hxsPXYXux/NnYogjolVPorvwdz31pBXSYwRnxTip9Vs4l17Xca653Qs6MfJaTe9Ylkko6eDFOFVJ/9hlgpXrk5NtDyWaybCKw87qPyzut+oCrwxNN5v2gLaI6TBBHjbB83ktZAvk/+WHOnhfk9vIcLcBo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199024)(1800799009)(186009)(4744005)(2906002)(86362001)(122000001)(38100700002)(33656002)(82960400001)(38070700005)(55016003)(4326008)(41300700001)(316002)(71200400001)(64756008)(8676002)(66556008)(110136005)(9686003)(8936002)(66946007)(54906003)(6506007)(76116006)(52536014)(66446008)(66476007)(83380400001)(478600001)(7696005)(966005)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MtT0dgkKlYqgzkkxDUvBB3D9+gMsE9zMXAVC6W0kP1TFJhcUjlIsdlM4mhuP?=
 =?us-ascii?Q?Mpyf+JnVclXGBdBX5O08rdMD1/A3JENK0DLmqxeFVQ91cnk45BAozeSrGCDZ?=
 =?us-ascii?Q?183o+3O1hIdo71ag6QPJxEo5QggvJE677A4D+Un9mnyxF+SpQ7OWzA8aqQRE?=
 =?us-ascii?Q?Rm6CTh+Ri6rSgrg5Ik2KjzKngXozv5Jd6pGhHLa9V028eKTy4QMOKId8JlhR?=
 =?us-ascii?Q?I/OIPqxopY+5h6OwucGSqqGwYCLys+5fjDiZRDu+FvjrZ4LAYUBIj4YIprBs?=
 =?us-ascii?Q?Y7zrzR8L5sf0zdUJL64yRH66FN6ySNpO++eh2dliKsWaCaNlcfD6U88pxyaP?=
 =?us-ascii?Q?dRgT6ceRJmp2lidivAkKrPPis1aRs/JPNMVXfriQUCWNGwHzH1BZYgkeIudz?=
 =?us-ascii?Q?jG9+kYJ0mB7ImZpPVAXEIsS16jrRVU0zsa9IeOIEIhtfMH1WffwlIRC93IHf?=
 =?us-ascii?Q?2CdsiECZNhrpiU1q544bEpGNcrmiBMYsWxT+3hSizfzVGHIeHp/Pks4VPFZX?=
 =?us-ascii?Q?forTV/7z+p8YK4a22FBNWPvP4nugLGOGW8bFUxwRYHeTH7rftNjtavhCUO6g?=
 =?us-ascii?Q?eVxCBiskSTYTheqMviciuEugfAUQgB+90SiaQLVK14ZO1f32POVtJVgxvRO/?=
 =?us-ascii?Q?Cw1H+4IpNNFB4LYtpllQx1XUOahcwG6t3NMbU8bXrwZ+bB6AoS4q9cjT+vD1?=
 =?us-ascii?Q?UajXZrqvki4rgFsHPU6JbM1Wx7MvIW6aKAHx8Km81LtjtcUmi+NarnMHITx5?=
 =?us-ascii?Q?4+e13MWNQPjgRH3KrvEJK7gbx8Ibk313wxrG9JKRNNojjAaZ1pgWN3l0kjrU?=
 =?us-ascii?Q?7WxOc9N3/Hq0iQpsDpwYHYM211e6WFYK42I0UD5qk9wpGoWk7MQPkIa4UxE0?=
 =?us-ascii?Q?5HIDMEVUc+VVpkdCMlrVFvgVEW6xfXCw+P7ehM2Lu/rlaeulGjMT5JyRAgAJ?=
 =?us-ascii?Q?BsyY1GtUEzJHiLqKA/8jyRJ5shRbEcI7lB3NZLgn4TdGCJtdt0JighS0C21f?=
 =?us-ascii?Q?9og+bLffKl7j2yR0dn+8AFbgD6pL7vkOaVo2sVTE2MuGDK7dzXyvPPnTFLxi?=
 =?us-ascii?Q?uut6yihahDHDLTbtkk1jYr3JaJ6oGCNAAKUnAufqDTHR4EssU5ylel53zyCn?=
 =?us-ascii?Q?BBogamb0fcdQyPPW378GkUKk9YFehxHqgZfO22ac368WvmDZGoTcZeApm05h?=
 =?us-ascii?Q?vu8qllxwRRdKhTTyOIjgD02XFNRZH5yXYAYxR6TTBSUeytQ9vgsffCvJPaA0?=
 =?us-ascii?Q?qKkK1/n1FnK0JWZUMbRsk0OOxX4VFCPOoZuJIBu/v75WUSZv1Js/N+Hjyden?=
 =?us-ascii?Q?VlhRNP82BT7vFa/vJhgNZDtg2189bcqfk1qp9yrZjbjCIPEhZmrJPqezGDU2?=
 =?us-ascii?Q?I9lByjC5DMnFTs0SiAdA/Dqqj63g2DnZJ3/z9M3nalZxu++lzjbX5G6QLeH4?=
 =?us-ascii?Q?XvXo+62UEhmsB2VC75CAsKZgYD7+n/8Otp2lZEp811lndP8c8OL0OA7qN4GF?=
 =?us-ascii?Q?C3rQIZYxNQ6siRj4HplvfNJeMZN9BGFfZP08dFf5/EFSPKWqL/KvBafipEBP?=
 =?us-ascii?Q?TAYJhcBUHDWi7EbuW4BTce0yAI5uxi7r5YkEKndI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a352435-b0e8-47f3-816d-08dbb69ac777
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2023 09:53:29.0404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/EegFIdGvA+lPu1iDTrBDE3nHyfmNdRS7cNpMk+p8rHizqGNej3UB/rIeCzNCcEdgp7IRyKMoX46/5x8wXQAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4653
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, September 16, 2023 2:59 AM
>=20
> On Thu, 14 Sep 2023 10:13:32 +0800
> oushixiong <oushixiong@kylinos.cn> wrote:
>=20
> > From: Shixiong Ou <oushixiong@kylinos.cn>
> >
> > The pci_physfn() helper exists to support cases where the physfn
> > field may not be compiled into the pci_dev structure. We've
> > declared this driver dependent on PCI_IOV to avoid this problem,
> > but regardless we should follow the precedent not to access this
> > field directly.
> >
> > Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> > ---
> >
> > This patch changes the subject line and commit log, and the previous
> > patch's links is:
> >
> 	https://patchwork.kernel.org/project/kvm/patch/20230911080828.6
> 35184-1-oushixiong@kylinos.cn/
>=20
> Kevin & Jason,
>=20
> I assume your R-b's apply to this version as well.  Thanks,
>=20

yes.
