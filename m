Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B737974E6E6
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 08:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjGKGMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 02:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjGKGMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 02:12:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793B8AB;
        Mon, 10 Jul 2023 23:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689055935; x=1720591935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ig0M5MOspWppeGum6rl6qrGkA+V3kGiISIi8JEjemKw=;
  b=BD1mTVVPDCEv+5eGLPrdzVbsx6Xgu5xGQkAqMRowUAf/MgbGsUabj7Jm
   7aeMPSe8CevcxZtfrV4J6OdvfwQD9B4jgSajHUV35+grToHFQSiPKYoME
   f5lBrJqMXebsPWf+ywhz/T7/ktHHogAt0IplQ3N+T+lVBQLh05vrlOf1R
   hj8varinR5lkdVJWkawvzFSwAquyc1TrRV5OjK1zNdrbtSdiRfJaOkVJn
   JKl+xLr+qeRhJfbEwhzwvwaJ2MNq03bDyhuOLd5lcZq9fL3nlD+m/blMW
   r7Fc4XeqQ0/YDj8X4H7CESCEyvCqHEr06FQ3ksJ7eKUm96UdCJpT7mHJr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="363402162"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="363402162"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 23:12:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="791079003"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="791079003"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2023 23:12:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:12:14 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:12:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 23:12:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 23:12:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6i2Ct35R+G2PzuY5TrM2ELGjLb4w2LqQt2wH5HrifKhrXIrrjIyc/bu2Iz0Q5k17EnOwM2YnTtcH1Zq7jxiAozyg/bWBIoYf45CEeNxKPmg6vy+2NsQt6C3aeNy1nSkSb/G/V3dl8PqmMtQE8zw/0TTY9/ll9ffs4baEahqPGihQ4txrF7rTPxjc6rCLXzQ30XTcYy0ACTSEkEK4Md/UT493+exRrt+UGg/pbKXS+ZGlOuqRWXiK9HnFZuRQ7fX+Ewv0bMsBLW8uZIXMDgQt0ONqZ3IWz6Cew8YzEpfazhemu6QSqCE59u/PhfbS8s2yHOlm3t/KnhUeJ0Lqx8dyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3JLTwia2hquFqVo76tniszWFv9nnRdddkcveHZx2wE=;
 b=OReImJXzHGj41nZlcKhAaYEBygEmMaSEGYVTJkwGpdqkfRMCXSR1mSaEMXPaBqRZnmqPy//iXN7i5KMPbksEHfMKxYeMu8e2BgbBvO+8RRGCJDOimT0O8D8DXK80Te5ODt9Or0OBqOP08IDxV/D02icGazFz96DwbACdAcv7k2IjtIeAYPJki5pQfRP1ZboPecThUSvDYbdKcmV/HLD9Cv9BBl7SQWeyrLpdYlhF4/uLAZB3F3RvlXhMWvFOAYowhCOoDayNsAX6179niqowHnpIj/yMHYCOg3go3G+pAGuZIoLbQO70/wf+uCCkTqN9Y/ByCFOLZGulZIrL7FYcug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7242.namprd11.prod.outlook.com (2603:10b6:930:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 06:12:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 06:12:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/9] iommu: Add common code to handle IO page faults
Thread-Topic: [PATCH 3/9] iommu: Add common code to handle IO page faults
Thread-Index: AQHZs5RGNoDpcYXyIk6nKOb2hc3wzq+0FOwQ
Date:   Tue, 11 Jul 2023 06:12:05 +0000
Message-ID: <BN9PR11MB52761F71BA509501C1766E9A8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-4-baolu.lu@linux.intel.com>
In-Reply-To: <20230711010642.19707-4-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7242:EE_
x-ms-office365-filtering-correlation-id: e734049a-c4e3-4e2e-a529-08db81d5bfec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xo7dTWYEEJXJ1lvpqViXah6dq4f+7hCAKsU8tBF00STBsOWBHglfTVE0KtKaBcNvvmTzcMiYiS7Tfq7zOYguo4PljA6rUwn2d5MAh6q2Ucb96QQV1RbaI/eC/CJRJmw1AWw7IsYtq6YBLXzrcXT8UOHRgLAzlmnLUVxkg7BOpD/DXDzg62IoczAX/V5wr61RG67lceDYUT9Se6gm3Qd7Abgl1nMXIRy9ExlnSsGYJBFBFRs1SuyBZMC46rA7IoQYkHVgOng+O5E1xk2VhexrZcRNYEkD8mzgtUpfN4STLDkI1B7cDgr2CEuTx/lQ3bAAT+d6Mhz6qO8dWSBZzMexpwg/abGSxDWKJ5EhGzkcBKCy2+M1LMrOkd19HTj2FGTFLHSWZnFMCs/S8tkz4fjErcfrcxfYcNRhpybBjnYkO6Zc4dApjPVMYmG0HzB+kM8dlZpGmSb++CDqurNRaj9MpBJ9ORwahzBGJFO8BvnwwqEWkDWcVTsnAqVG6QS0GX287qDdR5hX2W4EGdIDb2pEy3eCwhhA02RAUKJwef8iM5ubuDi4hfwKS64po+vlqFqrCvkSPf4+9CS5RNMO1AZWbLP5VXxPJQVAh6S/uHU3fNymCwkRLKpQ4wA0ospSAS8q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(7696005)(71200400001)(82960400001)(478600001)(122000001)(110136005)(54906003)(7416002)(8936002)(52536014)(5660300002)(8676002)(2906002)(86362001)(33656002)(38070700005)(4326008)(316002)(55016003)(76116006)(64756008)(66446008)(66476007)(38100700002)(66946007)(66556008)(41300700001)(26005)(6506007)(9686003)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QBEiBfCG1ODS7DOJ54tdTa7fvefs/d+SsqRUR1mF4EKQn84yyicmbXQZwEWR?=
 =?us-ascii?Q?xJgUhUUjahdLFgQCXRnjlnm5Cjo5loJ6LwKDwgy53AKpJJP8ztd1Y3/8Jd0J?=
 =?us-ascii?Q?AvZ0TRN324JtH1eCb1zEUfZ2va/MD3igMNPo3obQMC83n+hfKURcXXfiPf/d?=
 =?us-ascii?Q?Q0LqtF6kwh0DzniRmvYxi/gR17dQGI1uBwiN61V9T2GEbhcv6guojbT3fchH?=
 =?us-ascii?Q?NcjLn+JdDhLoiJft6YvQPkaeTEArkqCPU+wb4sJYqR/8yfIC+DZAViU+GYkq?=
 =?us-ascii?Q?WutyAZFs8EiSY0EqgF0ZrkS+lBB3FDKnTbJeyQ6OKa2Ww+EBJxrqo8qonBoL?=
 =?us-ascii?Q?7rMjJpprqK6nuLuOl2gYzLAe6g4DYvhrxtc38li6o/Yh87QV+cfxrz85XrrC?=
 =?us-ascii?Q?DQUEOvG78O4g218SFBqpJhtPKSg2Vw2qmlP12sAmBS9pNTfoMiFOjzNfu+xJ?=
 =?us-ascii?Q?Hetr4lsDzhDdIotXlJ3ICYAXZytLLgyVRGUtDoseGZR08x5jFr3S9vAegmbH?=
 =?us-ascii?Q?/hUsxLpUIyalmor86/b13hq+R0X//2SJmVlhEJGnnYp1k6m+GqkjvhqftWbk?=
 =?us-ascii?Q?uV4P9lWzGuZFUihKTL9oi1IOEuue8OpLEy9qrddZSmFcitFOpPgGS/b7oEvc?=
 =?us-ascii?Q?Gmzx1uxcB0xQyOxGpX+iwcaCNx8V2b34NkKJL3AK0/0UWDNKZL4Hf6//tYsG?=
 =?us-ascii?Q?F8DmTx3qJh/HT/k7WC7mKh6c4Z8PIkdlM6N6cnLj9frvjzuJmtrzQEMtCAtL?=
 =?us-ascii?Q?vVGDsBZMWfR62S+6HWuhIrucyyqk4Y3o4KtdE/BXLsmBnR0bu80PMIGXskge?=
 =?us-ascii?Q?dcYIHg5KKDnEsNR+Erx3/XuG897fPTBogmTFofucPDHejri/pTobYMYKXAnh?=
 =?us-ascii?Q?PlYqjRjZV/JX17GHAmqpEyys8zBpVURrzQeLrljbJ08BZxXQ6X7bRm63mYM+?=
 =?us-ascii?Q?jxYWM6H94Wl86eEjR6kUx114B1NLRBSyd2Nia6rrdPjBnMUJjnhSeRPbz38E?=
 =?us-ascii?Q?OaYwBo2fyxLElv6zaZzE94diOoApJOQOk/XfUKXDR26585HspIgxcJHcnnbC?=
 =?us-ascii?Q?pVK2acVpe1v6nE0D9qw9SvbVQVzeIl5+Q6UejMmIHWpTjatJA2JHC8yTFriV?=
 =?us-ascii?Q?NpMoLLBxoAmhHYh9MUprPpN3Ierlf0r1IaQhpq9dV1aG5yadu+pzn1qxxqO6?=
 =?us-ascii?Q?/c5G+tHfSFC/gIw6sDGSlPhxD/n+naYIu91XgAJ5YhlJvpX920WscGqj36tT?=
 =?us-ascii?Q?BfGDTtXIQnD6UT6WDBnUBOypF74TMTQ55qHRr718ZO58ZeynfF2tdPvmBRn3?=
 =?us-ascii?Q?zY7+uTIgO1MbAh4fk5fZoCiNMGDk98vFw1XSSYLWOYeUDs+Y72086Lq6e7Mm?=
 =?us-ascii?Q?TOHi8VD6tN8cib/E8V0x4D8frEyBF6gILsdd3JbtXuZLnskDmQ300uE3viUS?=
 =?us-ascii?Q?/XIBDieKfwwHTmXL3tTPZ1jSB2/fvypb7oQUybeBnqvtp/rekmIq58b9J0am?=
 =?us-ascii?Q?ede/YEJc2AogyLVv5KbYOE7y23qQcO3fc76HC3l/LIP47yjZvQbkwVDoF02K?=
 =?us-ascii?Q?8KmcKYLwH98b3q8yZoKFzUzttAE5hB+kQU1dV3+K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e734049a-c4e3-4e2e-a529-08db81d5bfec
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 06:12:05.0590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80wRAZNMAXmCwt2mT5tZewGuuQVJ4eIi5Fds1fY4/hURoEFJSnRpkXnqrIYArKrLXpaVMLaxRf8fZD4agAg99w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7242
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, July 11, 2023 9:07 AM
>=20
> +static int iommu_handle_io_pgfault(struct device *dev,
> +				   struct iommu_fault *fault)
> +{
> +	struct iommu_domain *domain;
> +
> +	if (fault->type !=3D IOMMU_FAULT_PAGE_REQ)
> +		return -EINVAL;
> +
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> +		domain =3D iommu_get_domain_for_dev_pasid(dev, fault-
> >prm.pasid, 0);
> +	else
> +		domain =3D iommu_get_domain_for_dev(dev);
> +
> +	if (!domain || !domain->iopf_handler)
> +		return -ENODEV;
> +
> +	if (domain->iopf_handler =3D=3D iommu_sva_handle_iopf)
> +		return iommu_queue_iopf(fault, dev);

You can avoid the special check by directly making iommu_queue_iopf
as the iopf_handler for sva domain.

> +
> +	return domain->iopf_handler(fault, dev, domain->fault_data);
> +}

btw is there value of moving the group handling logic from
iommu_queue_iopf() to this common function?

I wonder whether there is any correctness issue if not forwarding
partial request to iommufd. If not this can also help reduce
notifications to the user until the group is ready.
