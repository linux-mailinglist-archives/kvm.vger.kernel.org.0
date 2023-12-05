Return-Path: <kvm+bounces-3465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9182804B3C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48C771F213E2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B4328DB6;
	Tue,  5 Dec 2023 07:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9RjYYWv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD2CB;
	Mon,  4 Dec 2023 23:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701761830; x=1733297830;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3T/u+USpeV6ItsOB3ae5UWfELAdL8+TNTo28KbhatKw=;
  b=c9RjYYWvFN4CMIsnvtB+4dEmhNaTZ694VluqMfD862t5ipCWZkUJhYWt
   O1QIYXRbccsNjKBvjYvxTZ8WIRg3wmaFHPNq1oAHbbjFOX87ivEyJqdz4
   wwjsxir8fecJOmK2B0ey56tvTpVHhblRC+6GEjNHihiXs79IAA34gFO29
   9wG87y1ud1deElrTo4MD98mgqePpVaY1dr521NvJbn/scVVRBEHNz2WWz
   cGcrGvio1BOdeRDS6sqIXAXaaX0Y54NvW+QhssNaToIDZMvp85iVfsF8P
   ZFv44FfvlnpLcsijZrAii0jWu1QJFE56lM2re+DVxEtyqfBLBbs8iIDUc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="391016561"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="391016561"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:37:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="914714672"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="914714672"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:37:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:37:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:37:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:37:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:37:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrNmP6fL7VqX320umq62kYhEDtGphz3hgiKW7YtkIOGemgOclej5Djz6wUf/HHKDEgKFMx9COM5+nJ9up9SBSYUd4iOjAFL7Y/y7w7+RbpwqK2G7y3+wqtktlmE2nkmzixJKvZZgA6+W5CseWBGCdYMbPZHMsCblAHZZelnRc0J9E21vrqdGnZl+t+WVYn3EJ77PhaBbhX36A4Km6XALQP5o8dxQmJCjb5q61Nfgwwv5a1HVL6PcmZ65kWnJDkqiLE9uBacHNvOfeabuFh4Nq26Id7FyYfvfbS8H9FsFambgWc1kvx/y9pPEKeK+a/AUb5UmvpZW/9l/0Vl2OXyXEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sbhJYj+pvtCXDmosdxE3JFScIhcl58BPVvLVheEOsY=;
 b=Ta/+c5jsHbr9Pg2vyJzR1jY+P6++0xK1QNHyykVJd+UEQEgdU/BchDdt3jorpOKH9t9/UhqzSeeGPC1nn7O6tAmELGHYCFafSALCmAzOeUHl5TNwTDuZlWEYFAK8turbNqnvS/fJ68/bjJ1PNu9TCsdafBY5z7f6eg8OT2W0tbp079buSR0lnxu+l4tMPUFLFCknFY9bB4uWLbPr8YdxEYYe+gqMxEUB0EPvynVIhVJxt0rYyHHt2w+PJL7gd9wak4akAgtfgIBndWHLzE22lSGBCVB9IyOTzaw0P553SjChXbWYQ09NsaJ8D7mjV6FBb99fPrnIgwXiv1M+eNlkRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4514.namprd11.prod.outlook.com (2603:10b6:5:2a3::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Tue, 5 Dec 2023 07:37:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:37:07 +0000
Date: Tue, 5 Dec 2023 15:08:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 12/42] iommufd: Introduce allocation data info and
 flag for KVM managed HWPT
Message-ID: <ZW7MU4L9vybiDqZt@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092113.14141-1-yan.y.zhao@intel.com>
 <20231204182928.GL1493156@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231204182928.GL1493156@nvidia.com>
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: 60fd52e1-f5b5-4c4d-3e00-08dbf564fb60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6r2h7KGDuOVf8e0gI8hQsWpHGYOPfXTNLNv4MYVEhfHc+8CCpWnHGmqbEZiXTJkjmoGxemzcNeyiX/CY4Klxpt3NfC/DaEDmwJfZCXK3E3mI1eKFiJmDX9ZWhdLxfHWVvbALQPiPCwms7lmK7sfnl7Egh1Kcvmj38jpulPyRQdrlFcWC6VrOc3G12ltRjzi1sEdFVoyiPwNjJ6d34whvmKIa/dRZ83TLBV0Dmu9njD03jc4geTjhp0NQjog+Y9u+a+3zVmN6PHTt6b9xsGRnZWhOAYWJY/WUNLtkTbknUux1XBtTrLnXCUTzUfMMuT78bRRZYpE6IRNnnykSGkFQzVY58yB6amEWrvhD8STMA/evymXmnQxp2VM0Zo90w/OY3/+W8iEgRR+0WaLEoe61xzkkpSd97R/weS/6obbmN/U815ctB1RKdDcNM7+zoO+wRhlBxeDv017MDHm+mFxmsmzWutCRHkhCQTDyxWjbofv2OzTJOl+S2hnKPc9sKlzzsI2Li4FS0gxkmZHrAYg8G2pNcJ4XPH3cY8ueBjKDKM7nr64j0skZ3ip6ryUkufk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(3450700001)(7416002)(2906002)(316002)(66556008)(6916009)(54906003)(66476007)(86362001)(66946007)(8676002)(41300700001)(4326008)(8936002)(5660300002)(38100700002)(82960400001)(6486002)(478600001)(26005)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HqDjlyDdu1p+M9wctIEDKIWqrZMSIVCuYSbym9zWVYYk4qQUXZS4mnlfg8s5?=
 =?us-ascii?Q?aytUlXR8I0MWEJ/qlY5Y6YJhpLZ/SgQIv6s6MUfVHdssBfgk3M3YW2RYa1IQ?=
 =?us-ascii?Q?lzWu385xieZG47+w0bvH9KinK17Pgw8R61nLBzsCJ3eHknkFXvhXz+2fGZdR?=
 =?us-ascii?Q?cVJdhwLGwvXsdNsS92EU2k7pxIjvHz3964pQ07nkpWTakE7imJudJymjorJl?=
 =?us-ascii?Q?di1y51WtQrcVYpO1BbbygJdNQMJ9X6Rx4yYNllc4Ja0dcK1jnXv3GXaQydtm?=
 =?us-ascii?Q?8cUcVJdX/8HgyxzGqdaNIQc7ODr17sMEg34jTeo3mEbxD/UAMe5K3IKUEX65?=
 =?us-ascii?Q?IPSRmwqy+j6trswmiPCW+gy/b657fOP+yQ+zZTdIYuKprM1k1tjtfEEkzoJb?=
 =?us-ascii?Q?xxZgcgFrV2DEz1Yqs2hE/OMWqQrxm7GVor3oI4JaaXpa+qkSIXlX8PikITJ5?=
 =?us-ascii?Q?qvGg6HK0JJONkyRE4Jh0qWaeSV/vC4f6p902lHjlSA6UzR3qeQ9G01l/MF8I?=
 =?us-ascii?Q?zd3ANRtRaTR/6BqYNTz5k2Xe0H3NrEqseilt/mvoh9DLyZoNdgW367EgBDFE?=
 =?us-ascii?Q?pZZBVgWfjnUZ6CTHFxJ3GzJNm2z9bu8nMSllgO5gSR+5P6H3aeDOuzTC/h9R?=
 =?us-ascii?Q?fM5aLoIDOm8SjcMWmnS6KLb9Y1pP12QmZzYjeFceYKz4dSXqRjqSCWc7Jo0R?=
 =?us-ascii?Q?Bx2LZ+yRKbCFqOMfKwG38sQh9XTQQBLSRNGRwr23CUIIvx4i5BYFalb4VTUj?=
 =?us-ascii?Q?F4hzLyhb2BoBbM7+6Lxttx2L/ZaFJO46inz1DlrvaKU6zXWvAA2XHs3bfY4M?=
 =?us-ascii?Q?V9J6wjzZxcNmNVeVPB1A3AEGknaBqwcOhbCWTP1Rt+epYguQyRu6v2ZxJP3F?=
 =?us-ascii?Q?fAjB+wSYiPOUOIX+1eULmMWMG+XLw2U4Ycp+c/8DAt4t73EnN2EPbdeeQGCi?=
 =?us-ascii?Q?YwX5wsN4GFH/tFBh6FzPgwAZnX+QezMC8uw9tb9atxwqbYj9SOQ3ojAx0BTz?=
 =?us-ascii?Q?xUJsF4LdmgKAW19O0oEs3tYv8d2a9rxwM5P3fPIGTc5S3MEQ3Caqgbr2ADob?=
 =?us-ascii?Q?djeHR31QWkv0m2qjQOTQeTkbw1sg4RZ9Uuf8p77odWEOj3hzHr7MASgQ9kPU?=
 =?us-ascii?Q?NkXRaKI77tA+ysJEtMSNTWW30Eqt77svYihrdxT0IBsww91u6sAO8Pq8mnHd?=
 =?us-ascii?Q?oW0ZgAB5Hn4mUFO7HegnX8ox+td/CHNoBxzEHnyg4H3zV1UnG8xbUlzjlqkw?=
 =?us-ascii?Q?dA8ytrhqfNekp/UQU4trHIh9Jj++GKw8oh7rkCxD/aYfA4O3563F3JC6y/q5?=
 =?us-ascii?Q?kk34I+yhSBWIQO1SmtuDMV7Erh96mqVrqvGuJTtOGjLN5+0zk2yfw1m2mpE5?=
 =?us-ascii?Q?JU60VAm29/EGdT8x2cx9mfdVlI4FhmB2aFCz2XvsABhVe6LIrEb2Nebjg8pw?=
 =?us-ascii?Q?d4UwlzTBZrzPk8axmJEVYxsvHomgx1kh2rm48vou2kJkSFiS7HGzQYH6LuKa?=
 =?us-ascii?Q?tDDMH4cEPIZJm5OJ2SyWsjYy6rd+s7E154DK+BEHaX/jLVyRRQETBZRDNt+S?=
 =?us-ascii?Q?STKDMhm030IM1VPEWPXcf8gTxZFyfCh5bcEW//IX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fd52e1-f5b5-4c4d-3e00-08dbf564fb60
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:37:06.9062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeenYO+IxxLL71p7FxiZVtN3D7sm1TKOSWKfbZRHHybw0Skn7I967JXVXJap33spzLgKwswuYuHssV7dAIXwJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4514
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 02:29:28PM -0400, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2023 at 05:21:13PM +0800, Yan Zhao wrote:
> 
> > @@ -413,11 +422,13 @@ struct iommu_hwpt_arm_smmuv3 {
> >   * @IOMMU_HWPT_DATA_NONE: no data
> >   * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
> >   * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
> > + * @IOMMU_HWPT_DATA_KVM: KVM managed stage-2 page table
> >   */
> >  enum iommu_hwpt_data_type {
> >  	IOMMU_HWPT_DATA_NONE,
> >  	IOMMU_HWPT_DATA_VTD_S1,
> >  	IOMMU_HWPT_DATA_ARM_SMMUV3,
> > +	IOMMU_HWPT_DATA_KVM,
> >  };
> 
> Definately no, the HWPT_DATA is for the *driver* - it should not be
> "kvm".
> 
> Add the kvm fd to the main structure
>
Do you mean add a "int kvm_fd" to "struct iommu_hwpt_alloc" ?
struct iommu_hwpt_alloc {
        __u32 size;
        __u32 flags;
        __u32 dev_id;
        __u32 pt_id;
        __u32 out_hwpt_id;
        __u32 __reserved;
        __u32 data_type;
        __u32 data_len;
        __aligned_u64 data_uptr;
};

Then always create the HWPT as IOMMUFD_OBJ_HWPT_KVM as long as kvm_fd > 0 ?

