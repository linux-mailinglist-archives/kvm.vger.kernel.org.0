Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71767D0A23
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376490AbjJTH7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376440AbjJTH7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:59:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F04E8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697788785; x=1729324785;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t92rV74kG+J3uEthEow5dw10lYORGQeDwSYHcqFZTeg=;
  b=RS4oPIUI9lSff34XIm+b0452D280JN0FLcACJ2sF38jP7r1GZtUjAsBQ
   tAdS3B+fNxs3z5UMC8+Kkbt/gh+DjeRIO2/a7NSAHQqgxE75brVTYrb7b
   WUbq8Sr9VG3sLPEYZjJd2AFP41ipcXmzEJ1CnGmmoi4nOPkqHLZA5PhbU
   Y9G7mVnigGzj+d/VU1qf/B9ASzz73kk6howf98rmhBK0Cx7yHC3lMtVF9
   7BWTiggQYIKpW9xFa5174YRca2e16hZT/tYGSLDqIPxx1m7a0VUWmY9e1
   a5UhE0ynecFAWRQmcQa6jGZB/HSXQwzGAi0bqssmsDf2lLa2ANNHL88ry
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="5059820"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="5059820"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 00:59:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="1004524311"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="1004524311"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 00:59:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:59:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:59:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 00:59:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 00:59:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inBDy4COlFHbCP/maGxMXMENwF5cpUGaLyPT/WfLlmiQ3DdcdnxqQzWUwWKM7l/O48Kuyxh65kl4S6WF8VDcoDo6o69WX1hyVAhjgVYQDLgVvS7+TGRJugfJWhq6DrmjD3ugcRgT4yk8F2Vf+se4ju7HrTwvjp8vsL7Agd/I8R/SDvLdZQOMNmYyNqh6thiVeYQ3veA5C4UTh0c0q7PB5XvVbuQORrCg8JSLSJvSE4HP87CoFKdyLxa7jKyO3RigqEHQrc7bZadwyM94PwuJ4f6l3N53CiYfANNDvkiBLZSI0bN0fKS56Zs2Z4yKi34HZ1B7TDdd2+Aruh3vHwK8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t92rV74kG+J3uEthEow5dw10lYORGQeDwSYHcqFZTeg=;
 b=Rv21tX2+9s6YZClNvuFmJ18NJOCV1Edazce3qoHt41Eg4zJN23P0BJuIAweAnNCsouJ5TcR0S39PnlpwaBFmlKXetAHc+2mVnibJVVcKHcZREYhe/FP5Hu7YrZCK9LwGIIdvnu7jgRkxkZWqH3/KBWPjXyyVdiPlF1RZSgE8SvVOUEYl8j2UgQtZ0yC4ytxxgKbVPTlOoeyFoS+SLpp+LSBKgd/qFVadb83TWDJ5CpHPyX7VN6+OspXEkGZY369qnLpicJPHu0/rh5GPfT7x6+mVBTDwXbNrzEbmx7kajhepMk+wyPtGgxNKcRyDY9kKyA/+rTpg2mYui0z4GeI7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 07:59:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 07:59:40 +0000
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
Subject: RE: [PATCH v4 14/18] iommufd/selftest: Test
 IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Thread-Topic: [PATCH v4 14/18] iommufd/selftest: Test
 IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Thread-Index: AQHaAgHErKOTSfDOREGQ7Z94OMkLurBSUqBA
Date:   Fri, 20 Oct 2023 07:59:40 +0000
Message-ID: <BN9PR11MB52761A0ED3E14B2D9A25596F8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-15-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-15-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5285:EE_
x-ms-office365-filtering-correlation-id: a8e0ee98-9a03-4d8f-2aa9-08dbd1428321
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QqJjBUsFrR23H910eNM6AceypfPXCw6RGFoTFKt92vinJb2uDmT77xXbPwlXNOwY/XFLr2zuT0AluIcLo+ZQVwJSXNRQz2Klv9Oa+fjIS2eFiJ26frypfDP/mB8YbzGW9/jRYB1nooBX4qH1+76GE4sX9+NQE9KUj04uKdjmFXysPeeB/4PhDgJce21Zl+Pc+moYqsVq3SQq9fLjEIs/WoShTmvGpqvBKZbcKzLVwX0e7VRXeIOYbPZ2P/ZDVd46qLdiJbrIIBO6gCVfdLZx3rI4dL/PtDv4PnLXsfVStLlEpWv+27TDUpCevxdyMg1GbrBPucVLHoESR69VcdD6eEtL3fInzn3qyHYJ3uLDYwZ2dZ52xqOftHVZEjFYuvlKyMMBOQG9X/W5qcL0sVxa3+UaFWcl9hh/A17ipfcWK2FxzzpqN1ym6NHx1VEeisLNYISfG254U+G9mrGjYSGNWB6J2L88zTOSe8ups0BrdjXaDTZLUaO5LrWfo5qVUKaw41D4C0Y9wdeuKIv6wvQFak3uWP9oo60hQi1wD6lCRuf3ze73zl8kNoEuEFL+e/D+q84x6e8vAM04pPTKGAlY1UwZQaO0SfIOwBWrNdO66bWx9qkYfQ53MsLEokTRedUV5x/po8XvayIQZK54I+Yrcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(136003)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(33656002)(38070700009)(55016003)(316002)(64756008)(66946007)(110136005)(66556008)(66476007)(76116006)(54906003)(66446008)(86362001)(38100700002)(82960400001)(122000001)(83380400001)(26005)(9686003)(71200400001)(6506007)(7696005)(2906002)(4744005)(478600001)(41300700001)(8936002)(5660300002)(7416002)(4326008)(8676002)(52536014)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bc7WaRKalOQfBw9laK6i5rLP8tHW7PVXxq/1z7m3lNzGyExKZE2x14+vjNF4?=
 =?us-ascii?Q?07IuzxN++5fuPRNSLzvrDcBbIIxTcsvkOl4HU5bVBtXtA3fV/MIwpUGm27eL?=
 =?us-ascii?Q?w5C0nLLOsb0dGmeztpmS3mXFaesKzFZxigcGufuw1iEGqExPsw2tANFuFLAC?=
 =?us-ascii?Q?KJLGQxtmyn4WdV596rw884dIL7U2z7F3TITnXbMlhdAxQcVtIchimO2Ux8NV?=
 =?us-ascii?Q?weHQd9YhhFu3IxJZJwi0tnN9hrvudw1UeiHEbv04MZsfl5HTcDSkHTasGVa+?=
 =?us-ascii?Q?OwXEL2dUAxNTyQzfvkhsvgHF1t3JJxDqBucUs5dKLJ2Qa4F0z6aA9zMwwClw?=
 =?us-ascii?Q?jS7XL1WOlXxGFEQ19JDv9UREz3fahMMigM19KjI7WyVVz06zU5TL0SU7ac0P?=
 =?us-ascii?Q?wyGCq/qtT9tDSWXTT7r9KOuI2tSol2Q4Ic1Up9xEm/veMaXTYQt0IlIaUZA/?=
 =?us-ascii?Q?HAFegXIkbq7+zDZ5RZNvskr5iF1xu6g9vx0ril2hQ7YS+BHIKv0FPPMRChJh?=
 =?us-ascii?Q?/p8BiW+rR31J/wFnKKglhoQ2WdandzZx4uYaYWQ22oBtZG7Djis5Y+Lubej3?=
 =?us-ascii?Q?u/YvwEJoz4IiRKu9IQhHIaNajteVAu1J2K7ZXohwb2yMEVafkk2DcvWQj4Gj?=
 =?us-ascii?Q?Y0OrJRsYtmNab6q4AHZqhswG+KjSXIFVZNlkmWzApRoGomD3kt0tQTfs3x5b?=
 =?us-ascii?Q?DCbFJcq1SEtZAi9uHjZDwO98Qo5P6Q/Ma8TShSScGNGvVlI6Z4tJFbCjkFM3?=
 =?us-ascii?Q?XGQJ4QHGZg4+LsRq80MMLNej0x89aJGREyouUqF3pCrWOWUTcM9hy/By/JaS?=
 =?us-ascii?Q?s9p87GInyVcaRS6GKtwzEH7+ik1s8whwEVewHGmCerioGaumwBB2KkZw+ltN?=
 =?us-ascii?Q?vpE1zkwEOmOgra1UiYQwdVxsI/td0cG8D6tTVVTuHstfB8jNpA5HUAkmcFEz?=
 =?us-ascii?Q?z9lIn8u/3F4xqbJJHXcvp1Al5LURFKuwZ7xKhqjHPkoyOAZDR3Uut3OXzVaB?=
 =?us-ascii?Q?KS7lOAShhLpkLW/eG0mpt7IrMlip9j8bMDV04db0szc5WbcJYE/YIBoIeb51?=
 =?us-ascii?Q?JO/7q9IqYxgEhg9Ze8ZJLWMIzeqK3VwezHIHutGcXzevvTEcX+HeFkXTc1BX?=
 =?us-ascii?Q?C1Tk5ropsHXJnTNHV9UXwxB2oHOwO8ISLjgiLqTFobEilDd2ZK3EK3MVAH4b?=
 =?us-ascii?Q?s+quCEZd9IGDG+v3M//SF326HHud7k+IsadNv1XQHz+fzsbCQjALIRDPlj/u?=
 =?us-ascii?Q?vcKPSBKCDmlji9yFAFwLe1GA5AH+bmKicQps/xcosyeABs2YY/thf3e7B/M3?=
 =?us-ascii?Q?JLBq3b+6znK1RedSO3Ng6T+6liZnFoOsh7RjTPEYUg0DOkqeOHBOAuwJ3aq7?=
 =?us-ascii?Q?sLV6JBl7p1hAei2SQE5XdMVd3ZbB2H1tciL/tIvHbNo9BO2iOunbI0sNl+JI?=
 =?us-ascii?Q?f05dpWzNGEoZnNwkbN2Fk816C7Q8O82Oycjdk2+8pbbHljO2CKpzFvwKyjrH?=
 =?us-ascii?Q?js9DFZxEexRR6MmbpovGed4HdMbHyRtqUtnkLckFoT6p2n4d1CJh3+s6s0+7?=
 =?us-ascii?Q?theO7G01zGZGnj6amJMa7adVoAI9d+0vvbEZoEwO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e0ee98-9a03-4d8f-2aa9-08dbd1428321
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 07:59:40.1001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JrpooFXspeo6SKvPFo7ogJpjtmBeJ9dqqwawkYBEI4O4qgN3+wTXEXzK/Kx2zXLkhmjELnAN7Sq5sga22lXpqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> In order to selftest the iommu domain dirty enforcing implement the
> mock_domain necessary support and add a new dev_flags to test that the
> hwpt_alloc/attach_device fails as expected.
>=20
> Expand the existing mock_domain fixture with a enforce_dirty test that
> exercises the hwpt_alloc and device attachment.
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
