Return-Path: <kvm+bounces-3468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC2E804B4F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3CFC2816F3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD712C1A5;
	Tue,  5 Dec 2023 07:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n7z2Dytw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0029109;
	Mon,  4 Dec 2023 23:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701762199; x=1733298199;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=06sTuDxUOt8gSsTT+39yE/wddHGiL5RITLzT3xNVIJE=;
  b=n7z2DytwEQH4pYActPFcIQE9/ttUlDcArdbjDoiy/aH4invyuM1ncmSo
   nkyu4y6tE336CUgdIzhhZ4VDiIE2CG/8TLGvw1b8nTHW34LA7IvPpaIrP
   eWYA4sQQWi1coS+SpLqsJeFeXUXdesBg5ZjaJxjK+y9cMAGLuWlIKv5hH
   T8xC0l/o1uqIkwwo+AI5kqjtHSmFWVMqZWIoaNEOsQo7NU+MzUK1bu20s
   a2XDnBeIYZ4sGTfIL3a4Ry8vvE9H31SKlDQK4XM9ZXmd5Ie0xIyVLWOc9
   YcPxPcOytBwaIhHGEzlVUBgSLv83X2vXMISqcr5AQ9DQUaWlqQww6xPg0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="7148426"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="7148426"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:43:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="747129636"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="747129636"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:43:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:43:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:43:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:43:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXN71fUFEghbFTq1GzZv5ATvGVKNtigzLQ/cAeyhaBdvsJX5wz8wssSJBIFpurmcSlr65tsW2BuHFbzUJUVkANa0b4xOAJ7QPz8ruU9zMmm+4uonCNyvjhj2YF9H9y4eDRsw8IpueC7RIFYOV3tdB8y4iXqMu3lBBz5MP5iz09dddKpMR/IyWj1mzN53wCRq4pxF2DlqSYieySCbamIKyJ9iIMrNFp189MNMZKx0murOcDNQEBmEUhl73ttswN/cpOm4UeCC0L+EpxSVO4o8HDZZGo2Vyf8UamN1A8DyuAKOjFlOlsIDBSLYNvFXly+d/yAXwOe/m5jgTStz5dv2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSRRY+KHs7vS4sAFhB4P2VTauWDjdJSIVgXYzGeKxnE=;
 b=QVRFFwl9gUm3REP2Tma6XmI7KWoHgJKX+7oTcZSq0UFdzkMQoUfP7s1xg2dNn7CcxSPLZ3EM9S1qFhcoGXK+zFZYOHeTfkMrRbwSmxriC542OkOSHa8t1vV63AotF24FYrFYdWqqDlVxL9C/JPsmX8tiooJsEEb1+MyO92vGjT/kMBaV8NuKygZWwfgR5AEN1zTyQvou/bZfLjZPTbdVSxsZg+EeMsMWEkJbJq9FCPbGCk9OGP45lge0sS3ogEFZHk3An6RW65gAbg/nImyZAFmEB9eZTy3gj9NUug2lWpIMItlLnsqcmUZ/pQ4QsvzCR1LnWEH66PHawHzpBAMCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6249.namprd11.prod.outlook.com (2603:10b6:a03:45a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 07:43:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:43:11 +0000
Date: Tue, 5 Dec 2023 15:14:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 16/42] iommufd: Enable device feature IOPF during
 device attachment to KVM HWPT
Message-ID: <ZW7NwSCzswweHZh6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092311.14392-1-yan.y.zhao@intel.com>
 <20231204183603.GN1493156@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231204183603.GN1493156@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: d4337d9a-63fd-4bee-9b0e-08dbf565d4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PViN7GFMtO0fl/aN9ZyHkCgcVWvjs8+bjlk0TWEqvifKoPd0N9YKNkQC9dz2pO1OFAqu1uHOegbgVDEazrZ8yYEGl7/zB7ss2I+38IlTxBxAK4svTvUWp6R0eagfJxa+6CIaBPYz3Ky+I5r/ka2Y1FF7XGlE0OVsdH2V25uA9njOFodUk81Rpp2yrDYdtvYh4ob4vxcbCTELuhejmUtQhy0FoEuBBPjTZLSCniOQ8kQEAjxzDrDiIKs0GzWXCJ9EpgQ/2ai5J4aLJAG+Mp4mgwpcx/e2lEXfyZ1+ixTF7sSWqWHgYeJHyZfvTH1cLmp6QVkhvyYQ6soWwOMJswzIuEAfPDj51XS6qShsFXeVF92FkAj+dllRpU9gBCrxr6re81KXmmPxWnW8JTx895jspHIWFC04aRVxm0BBgnrnZEXVVl95CMz+PoAQnrDW1GD5vhaWdMxMY4Kcx88K1xnGjVzZRA7MQSgfnnVxQPDlsOPAyyLdq8YiKGTfosEz0BCqTjXk+lMubqcInAFoRjx49XzPeIDlH75+BDkdul/1iRZgX+85a26LbsyzeZiUDVrZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(396003)(366004)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(38100700002)(2906002)(5660300002)(3450700001)(7416002)(6512007)(82960400001)(26005)(6506007)(6916009)(478600001)(6486002)(41300700001)(66946007)(66476007)(54906003)(66556008)(8936002)(316002)(86362001)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5hHi28MY4mBD7vFLISClG2oam/lA9c6I3ksdj1mtc3urqJ6846E0cwLTvPQV?=
 =?us-ascii?Q?qHCYXe7VRqOs5il59IouFmTipCDePqlt7Y/IyV1Y5PJJZhCv7qZT8uDYk6el?=
 =?us-ascii?Q?UOl4mxbemWobYlGz4HHnINzabXAJ4Y8V3FSHJPRpDu/M9vud8Od5fJH22R3m?=
 =?us-ascii?Q?jE/lW2VmEXmTC9nuNjJtQSxly/H07ob88jDIw8Kr9VuOaKFrfnsR3Fuy/LVV?=
 =?us-ascii?Q?yLQID7gS6qufy2WbFlDSZTRJKkkWzaxMD6KtwBfKkqN66bt+wgm0mf71c/5i?=
 =?us-ascii?Q?EkbuHIANDgJueupZpvnm/EkSYkhfoZD7FTrJkpkv2lVaBgGaE2BeLBO8MRoF?=
 =?us-ascii?Q?OwIdzkTUobqfuptza0w8TbZmGLtcBRQtWK2qWRbp1vMiDna69rVB1WLYrXIj?=
 =?us-ascii?Q?t2ZWpHxFG6Wah1NK3t9ycDZ5z8LKOPPy3OIE8cOmF3ns4TPr0ZpdEb8Wimdr?=
 =?us-ascii?Q?BY0Gq4e3vEkrCXXBUk8mih/QNnSAaXJVehcLR8tPiqtshBuJu8JlWURtcdUJ?=
 =?us-ascii?Q?p/3MSDTbMoPC30ZY3Gl9zlbrkvW+w8W89WcdA2skgRF6u7sVv4p8glLkxrGx?=
 =?us-ascii?Q?ewb1bk9ULCprxysaMjQGJ5cA4qmIOOIKNUKhMlNE2Uo3a/yuW0oinTWma2yT?=
 =?us-ascii?Q?l6PqzG6E8MZ+Ww8vNRJFM3+qkEE+U2PDb8txa5LHmo8X0dk6szGjRifjZEtt?=
 =?us-ascii?Q?qAyIteFVzOLjafjcvL549l0iWRLryxes9v6NbaQiezjQrKNQmtuC+lNhvv6+?=
 =?us-ascii?Q?ow+23GcDVhN49jUWISu2JtKfHtUFTBW4VqC6q1zgUkUWrHAEFDX7qlAZACN6?=
 =?us-ascii?Q?EcMYNts25Ms663jz9Vz0wtoFIKsDPS2aoNaJ+GlGVWtlswXsBuTwn/KejLtx?=
 =?us-ascii?Q?FqpV17qOppZiAG+8hMbSYDagaqNB8A7pCasbIepYLUFPFVQpRwOIWCSz4YF3?=
 =?us-ascii?Q?0+jo1v/+lZX/xYm9jKh7s+PzYeCDvxsG6bUFjaRtJdKmw4nTxo6uaKL7Dc+o?=
 =?us-ascii?Q?FRjJM8JcXtvqa3cYzrXi/C9MVtuyGo26kwWGGxdud2nFAArxoaYrOQw1vIYX?=
 =?us-ascii?Q?tnq9F9oXcDFqFpg7Xda43J0ot8zbNemjMXikWBWUZaPP4jrphaBHXpwKwwsk?=
 =?us-ascii?Q?8Cte/TH80eaMkOiBKihT4Hr/K7sDrKU6dBTODc7YoP5gd+dod9O7QX5hqKLv?=
 =?us-ascii?Q?slMsthCXuVokzjjZxDcl4/+lOH9JprrHU82tkqplNX5Burf6rnjmSNVnE/Dw?=
 =?us-ascii?Q?8tnee0z2kdwDhl+1LLMv4NR0Iosk9/QaxS6NGgUpfG7x1nptBei6GP1KHekI?=
 =?us-ascii?Q?XqwGyjB+oW+6b+wtNutWY1GxSIWLzobajGBCtmOxyFlaqon2h9dA0Eeg9efh?=
 =?us-ascii?Q?QT94TNIpPZp8vyWmfyxH1GV3FD41dQBP8WDWKDZipL1l3yNzLWW4WetZ0RgH?=
 =?us-ascii?Q?bqNaAEnff+BkZykkU6MdzkEqrthQ+H4c3CiNSBxiqwELdaPZbujWzDavCRnu?=
 =?us-ascii?Q?y7U73XnKd/7gfkULPs9oRVqe2vMYSOyZrlZPw+Y7dczBVEXSco9axaICTUjj?=
 =?us-ascii?Q?Hm1SwVDJoXeoicA+szXZVZn6IzxhmrFg/F1eEOEM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4337d9a-63fd-4bee-9b0e-08dbf565d4d5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:43:11.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSAiFO4tcKpLdFP65wxUnVpD3+o5yChm75SJm1JQDf3sR54/K2pxh/ArEnmMvztSJ9j3znAyn4Qm6PXC/dNlrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6249
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 02:36:03PM -0400, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2023 at 05:23:11PM +0800, Yan Zhao wrote:
> > Enable device feature IOPF during device attachment to KVM HWPT and abort
> > the attachment if feature enabling is failed.
> > 
> > "pin" is not done by KVM HWPT. If VMM wants to create KVM HWPT, it must
> > know that all devices attached to this HWPT support IOPF so that pin-all
> > is skipped.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> > index 83af6b7e2784b..4ea447e052ce1 100644
> > --- a/drivers/iommu/iommufd/device.c
> > +++ b/drivers/iommu/iommufd/device.c
> > @@ -381,10 +381,26 @@ int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
> >  			goto err_unresv;
> >  		idev->igroup->hwpt = hwpt;
> >  	}
> > +	if (hwpt_is_kvm(hwpt)) {
> > +		/*
> > +		 * Feature IOPF requires ats is enabled which is true only
> > +		 * after device is attached to iommu domain.
> > +		 * So enable dev feature IOPF after iommu_attach_group().
> > +		 * -EBUSY will be returned if feature IOPF is already on.
> > +		 */
> > +		rc = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_IOPF);
> > +		if (rc && rc != -EBUSY)
> > +			goto err_detach;
> 
> I would like to remove IOMMU_DEV_FEAT_IOPF completely please

So, turn on device PRI during device attachment in IOMMU vendor driver?

