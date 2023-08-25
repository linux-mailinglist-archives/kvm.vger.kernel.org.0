Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF90778815E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 09:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbjHYH6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 03:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243360AbjHYH6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 03:58:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EED9E;
        Fri, 25 Aug 2023 00:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692950289; x=1724486289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s8cAMTzktealvVfnTLRG0vnBHQLNzGmwn81ojO6lbSo=;
  b=nCUqFvWOWs82hkhg8TmHtEOgUBq3Od4ORCtxG8XZsmpMGVFUi2sIPpMq
   ASBp18Q/gCDC9YZbBmdm8iZAEgWWOvMgkLm+H/LxwZXWv6h9jOOPSrEEs
   eQY3RkJ5evusUV4untxME49AfJ3M2AR/K1KMNZ+HTCkkoYFOJKXm34Ajn
   oBgIxqyx1i3tdk8L9ZplfvTejvnkPLy7gVvMcaxTqZ/W8uvcDv2jsAg4P
   Xk0O7khyDQ2SelTlQEpnxTcFNGuUndA4untSej8bHb8RN8eau9drgiEsk
   fiUzDczsIgGb25aXtd3CIGuCK/zFFzZkcw1ps4YNqQgQjn8p+1qvv5kCq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354187080"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354187080"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 00:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="984017576"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="984017576"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2023 00:57:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:57:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:57:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 00:57:39 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 00:57:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coPQ/5q40nkiK2+x3DkMZ7Lhe4wEZdPzvJk/OBIhotTIaosgbp7N1sdUqs75IoZrjf5wcxHvDfuARnAYzOpC/bX0UkKJeB5mMC6EEVSiTIGfYQHNIKs11vt7JL6zv43VpE8DU5EfXlni/VoR6cAlMSm7Xm8/ccu1n80q9LLA+A5H43eWSP2WRwRcQryVjgI8rLf/ywn8rYcEXETkU6YOuopXGg63eEZydT4YCvyfnT9h7Zr1VP8zlmFBk/SIxOo/qQbZ0ldC4ebzrNXbbLCVPybqTPs8sHHIxRdR2xnf7oqHkzs2rvhcJpQugKElbi6gOC4zDAtInjv+Tr1tNyvvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8cAMTzktealvVfnTLRG0vnBHQLNzGmwn81ojO6lbSo=;
 b=nDaUTju8gn3xyM7AxhUPIpfHAZOmTwlflFRZw+YiMEgbbb9h5NEKBEQKXzuPMnWXf/xbLLvdeZNFYjSEvhY4iQs/VyMlJtu342ZEIx/IPoilPTf6PQmwRpBv5zGMxmdiuq+sPOdTbc7PfxZqPMebgkTwbEa+BPxJGKk4yfchdLHQ2Q/pYwG8lyQMpVhIQD4qUzZsP4vleo9hUucvaVjvvrVetARA502u7M3Bqva2lx1Ui+BFeQEI+HbbC8MrsaOCuxwojfHdKDA0GP/5E7kI3EILgDVyEklABQUTJB4pmOwlzyHNQY0lMMoPpiTCPuZ66mKCo4LXbV8A5N1VgwKJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5088.namprd11.prod.outlook.com (2603:10b6:a03:2df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 07:57:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 07:57:25 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH v4 04/10] iommu: Cleanup iopf data structure definitions
Thread-Topic: [PATCH v4 04/10] iommu: Cleanup iopf data structure definitions
Thread-Index: AQHZ1vyQX/knEfr01k+yN0AJLKXKtK/6pQ5Q
Date:   Fri, 25 Aug 2023 07:57:25 +0000
Message-ID: <BN9PR11MB5276E509F0B1CE9A8FC301868CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-5-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-5-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5088:EE_
x-ms-office365-filtering-correlation-id: 9c95ef0d-e855-468a-3507-08dba540eba9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aVKRQvUWJCYaInDyYeEtji4gInUCmGk31M26w6pPAurBkLV4B5hlSUEUxfqMN90NpeBSEmvHnJYvP1n3Hjlx/fRW9UbswqTclgvokmn7tiOCKMu8r821Z/sprFoU6uxowsywofRQTuvqd5bb5fs9CkJRJ2XsKZXgsmMks92Q6sex3Ll8UCPSbGRBPTG9XBSsS5XFgqPgGBDA+tsbrq8OQtuGUeEkk1LRFabpCbeK5dwdzM64PEx/ObWfsVD2rxYPmJbkd22los5ZEYwwwHomC9R9powznNfnA68lhH7AqSr4khwSja72saMWxLs6Hr9JVo2/MBp1rI+JpJ4hl6axavyoFnyBGBk/9AAwvfxT3j6/fXMq7AIUzr8oPUTAQQ1lC0V4c+CowaXK57/ZgCZjhiZYkeqzJfVJ6J8AVJ8rt8RMaL7dbLNk43XEn5AZgo2aj5P3j+sV5kTQ+ej0f19z3TqOxeBIabxpcsLCDsxo0M3qYVkL1p1tyZW2fLJsg3EfD0e9jH4HCaC5NAfihF+q2RtFGvdLrCU57a3tecTz2XgNHqQT8+ACOYCvqAS83wZ87Wb0vu2cwLczL/QYQKiKR1RmXU/ojvgpoBP+jrxPLDhJ0NLAMU/KhijZI/aTENGX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(376002)(136003)(39860400002)(1800799009)(451199024)(186009)(7416002)(83380400001)(9686003)(26005)(478600001)(55016003)(5660300002)(52536014)(2906002)(8936002)(4326008)(8676002)(82960400001)(38070700005)(38100700002)(122000001)(66476007)(66556008)(110136005)(66946007)(76116006)(86362001)(71200400001)(41300700001)(64756008)(54906003)(6506007)(558084003)(66446008)(7696005)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cPgb4diKDBUHhJRQEFk1xIIWPnYxXzAIkQbg9nXRcad5RJeep9xuGBhmiUvl?=
 =?us-ascii?Q?cYdgifsaoHdi9kPmo47/twvkx42SiPFla8ZXlewJcZAPxrZv5+HxJ39Jytu3?=
 =?us-ascii?Q?lVcztqnSv2XkgRZtL4MDfghczMupoQV6rhFrO6wRYQduFAGrzOjlH5ODMmEg?=
 =?us-ascii?Q?usx5hSfNRu5gbx30CaTsg81mtAIZNo8e1tZ84kLkmbA8zt04ayjjHJvFFb5t?=
 =?us-ascii?Q?4oHD+JSbwMTSytog0+tAulUob0Z598lwuil41adjNFa3FyVp9jLUWg4vJMvr?=
 =?us-ascii?Q?sANqbrM90tXXnMHDbB/krdrNh8+TcOvpzjcWblB1B3QF7ZEdZvV6om6ny0Xh?=
 =?us-ascii?Q?DVij6SggKUNYqaA/o4Tq8Ul5+1iZXO4vT3LobY7gvonU0yWVN9YnPo9vNo8O?=
 =?us-ascii?Q?SldNX80L+yYzBBt5cRY0R7DyphyVyb6tCM4i1SI6hC3O1SrEv85PaMZeFSiQ?=
 =?us-ascii?Q?amq5BqAki5sYMuQuF8m3QE9dyGtUFKLVXk/XO5pRp8gYBYyPt8MHBWxJ8bOZ?=
 =?us-ascii?Q?dL1d1bcvoI+Jv8rbppdbf0ga6G/ghJmCEIdt5tb5MStnLLbP09Jhmn8m41Ab?=
 =?us-ascii?Q?jsS7PfZr+YknCWbfEdUOsqNi2QYqteptBVLBKiEQ7zYIK8TkB9dkmPd8ol7M?=
 =?us-ascii?Q?/gwYZvt1DOYCzDUxjIdV70z9yKypa4dv/0afO/Gfsd2K7FQaHdQYudE+HbCj?=
 =?us-ascii?Q?B5XMAW1Z8heDnySGo3MUo35T3iJVyicWaYs1RCrpZsjLuBwL1yPxT3vRu6Wd?=
 =?us-ascii?Q?1PLwxtROtDT50OSTbSlf8urkKFkLeVEYOd5zzs727PINhwfUK0jiFD4l/U8I?=
 =?us-ascii?Q?MXzDsWM6mwYXWuc02YsKC7Y0k16xY5pqr/BRbuF5j+yCXdb/644R2FmpE0K9?=
 =?us-ascii?Q?doRNAIno+gexcvjIVRznvpbGCBL76Mv0YwF6wjViMQ+UWqb2cRJGvj2FIzBL?=
 =?us-ascii?Q?LqDkSJRPmrlQNGZ/7l/n+Wc2asGyX7cqiwAI3nv+ARcy5T6BguFeZMKYW36C?=
 =?us-ascii?Q?lB9QvEYKTlyydhbFJEcvw3wFYaCudORF514biFrlrPparY8wan6dzBITH1aj?=
 =?us-ascii?Q?Vxo8TGiX8D1iQMp0US7OPbW++93zyBjG1upwzjHzz5RVeyzatCuu+wM8LECM?=
 =?us-ascii?Q?PeivSeiue2XilxbTis+l+mZcnbQ6B8nNC3xq8m86JD4jKxv+TaZjucpA7Un8?=
 =?us-ascii?Q?+ztHoQYrx5pSOl/9MOSIurV9wmP3xdnGIFYzBri7/A0O+64//Q2+0XfqstkT?=
 =?us-ascii?Q?c6iNiQkTcrNLtKjsb/gtr+wTeZ0vdUV59cR5pLy4Rw4a8qXdJ215tzPPOww1?=
 =?us-ascii?Q?+UQe9SqzGpnq0mhzQj3f+DniVlwdZL8bwdT0fia+w3/nT+vwBZN1FuxpLBdo?=
 =?us-ascii?Q?xu0oEr0p/lVXAYTNwEHDGn85lTRwpeH/cHXO3i3Y3/NNXdAUX6yXQsEQBOxR?=
 =?us-ascii?Q?JVHloDDCCV6/gZju7QnExsxEEERbpXuSk3fj0IuPYGlPDb3o1UngFjsYFt+R?=
 =?us-ascii?Q?prq8Fnvh7TYr7hH3eSxxnVlWqm1MRZCMIYvxaInEhgKpQUksCGxg9xBaR/P4?=
 =?us-ascii?Q?N7V4pxJaZcumR/Xk3Yq/boAqiCn5XPBmcU+Kstiv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c95ef0d-e855-468a-3507-08dba540eba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 07:57:25.2683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xz+fY26Ws41dN9lXQVWEWHQjBxFwM67ZhnRNjXbO2BjsxXpP9dcleJb1dSLQaee97MRlJQRqc4Q9ui615N8lMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5088
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> struct iommu_fault_page_request and struct iommu_page_response are not
> part of uAPI anymore. Convert them to data structures for kAPI.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
