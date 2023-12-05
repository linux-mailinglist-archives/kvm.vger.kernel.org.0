Return-Path: <kvm+bounces-3462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF51804AEA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46768B20D61
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A726415EB2;
	Tue,  5 Dec 2023 07:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEn/Sg9q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2959C;
	Mon,  4 Dec 2023 23:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701760180; x=1733296180;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RtVmaOsriHQ0IdYTdBW44sHZOuW81B9/Txa3EIPaUoo=;
  b=FEn/Sg9qohdFEx6JShrWSO67oXsJ4E7/cYR4jAyjfWSw4PuS+ISKPsb3
   FiUut9Jat3TGFHgFxpB7QthvICS8W/7gslS3a0v/6onmVjv67WU7PkSpf
   9Mpqt50gqKf/1kKsNblSrG2UXOZe/ydrjw3rAtPauFpHPw5BDMZNHIky0
   ML6Lvqi9JRCI/5f0Ou/O+08e2P5DWb/sGojvlCqW5MwUssKAJS7hDneeb
   cONL6wJGKKMhTeKzm7Zct4kztUuOXYhl+Ivff43kUgtNh3ioAk+liIh1L
   3Brxl7iTY+v82Ul0lMVBDGBlSex6XspXTeI7BAKylK38hk6oahvjsQWqC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="745406"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="745406"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:09:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="861655172"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="861655172"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:09:39 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:09:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:09:39 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:09:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7S/KpRWcmvU/iSDFh3Xv682aAHXcQe4IeRCCjwjBKCl9csLJjR+EMOvzgpwSgZb5v3v7IAGjqMRizaDiYh9mmPMnl7ZWPaHoiuARmBIGks3Wh6PAt7dy5j5jqmZJL+ozp9RagiYparrSlinY7I4CQ0sx3ls8DNAkrc3d4ysXpVdw9NRL0xiKnsspKkXW8Knxwn28/uona9IvM3/+/o4PjPesCWUaCPoUabUdovs/InqbN+BE2YThfCsF4poSejnGAuC1kWUGRWBonMgUlG483rAfLFBuXmqTX9e9XGZZsq51TLJrOzhdN2BH5WQ1cJO0vUznQ86xx57GdGa/7Datg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLgzQWJiRfEKnvAVcq8fmSQiipFxkp9rPUinz6LESVM=;
 b=YEZx2Uat927J6LodXTC+a/VQa9Ys+7IO1v6cmTrGtVbJJRVbce0ahhkOTiRPz+0Jqfa1cEr69KvwFrJnkMX+hy0zLaphVLZeZTcDonACzvoIakbkLJn6DFFn4mBqpEGbkarYvt6Db9GkjaoDSzPCTQ7QzKTOUOy9GPHm1yIJ4v1pK+jlx7b8cP2aD8X05w1jk5kvF93ujLXqMrAoZPuSJJGxoQTD8GYRiyRJTc1rKJuR+unJnFzWGXyxMu0WxJoGhu9e0wG94xI4DH4/BT0Q0PBAkFqEIDgGvfOdk45FRRmGE9TeIT0a0/ogIQjiJVVofH7p6sSVUTr2HK0v3GmQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6055.namprd11.prod.outlook.com (2603:10b6:510:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 07:09:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:09:31 +0000
Date: Tue, 5 Dec 2023 14:40:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 11/42] iommu: Add new domain op cache_invalidate_kvm
Message-ID: <ZW7F3AJZe7vrqzcy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092041.14084-1-yan.y.zhao@intel.com>
 <20231204150945.GF1493156@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231204150945.GF1493156@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a5cb472-e92f-4f9a-ffa5-08dbf5612065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJG4KCSZN15lJp1IHsfk/I3KIuS2EaJ24cUmUUEddker4Lkh+ymcLM3YVf+7XjQMTCDdFOoy57xlsksZb9+s8Z0jRz8o5tcvPzSMPmFlDWThSnrZvcfnlju/3Eas+t/GBeyrJ3VmUoILRagrRCChHhQt7gOrRu2rkAXozvO13x/axmNn2zSk/PxPEkYwkXOe714izPsjjX1ou73+EO0ZrG4BFlD4G/ZjBm3vlf8CgRpcHAh9vUN/HuM7/Xymbh4eqVQPido1b+NNQ0Y5or1RzR41OOcCktfgSi6giu2IoiIBH4t9yYJoDYfXK+qLNurSVnMAceJ5KnouOFM244NTFXXF4Q5LzEOd5GC+8drlP3X/c3xRT3y3smywnEQTwShbde9EOVwU5JSs95DLY/BFmrzvW+WpZuWGA8zhHk5qxrx9RMxINof7QhvVUllhmDp1e993rvmL7dxqJ2b/O3d2lGUB/RIUQjdjzHQe1zvqNAKpgHjhma8vewq8kDnu184phsA9mjpN0pyrRnpmTCEeE+pX3lv+SD9Qm/BhIzKjgadedgaDl/UurIWSfmP3+51q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(39860400002)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(86362001)(6486002)(478600001)(6506007)(6512007)(6666004)(66476007)(66556008)(66946007)(54906003)(316002)(6916009)(8936002)(4326008)(8676002)(83380400001)(2906002)(82960400001)(7416002)(5660300002)(41300700001)(4744005)(38100700002)(3450700001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aTpoKo7RGQ2kLPDNBie88/gNSkyf4wz3Ub6+djc1LMswSAwSKnoCCmjQlaIq?=
 =?us-ascii?Q?A0Q16sH6yIb/hNDtOkzGEzuiyVrklyiCADlzv07HfZ5cYc63CHnkhGepjEgY?=
 =?us-ascii?Q?pp9XQwGI6c2tFqF0ipbUNWAOB8R7FMazX8CbADKSp2OrLkTM4DkKDUnS7U5y?=
 =?us-ascii?Q?JolscMWyQYsvJO1mY82nE/SlFDsDwCfb+YgSXpwcGOobc/I68oW3tHh4MhRQ?=
 =?us-ascii?Q?o2k0aPS1ESDCJEq4QhLhsOMH5Itcz3sDHWTLe3RNNNXYrwYVIaSk1leeu/H0?=
 =?us-ascii?Q?SZv4Mnru6OtbpIXb5PAn82CDAZPsgdbfbVwFCIaZr3t55qfCTg8r2O4Q38Gk?=
 =?us-ascii?Q?pRX2T9IPwboFsR7uBUrPtJ3zE12FX8QpYM2bR+Xjt8yhBUqnEiTZMV+vDGzX?=
 =?us-ascii?Q?8wtzYfIrT+jk2qeNE6jJU5avHJ6hskbEIgK+PORg1KXzfbUDeWOk3RDyzQWA?=
 =?us-ascii?Q?H9aAeNHYLgINXWw4fXTFnHxSxajA0OHzafPBZOo/NtjxNQjHOMGLOWIhMq+4?=
 =?us-ascii?Q?PDc4bdQ0hnc2oUKlS+c+kcgZHeAmM3OYU78fTzroVimjiGSGTEO+/h9H5e67?=
 =?us-ascii?Q?PG3dz2xHcK+v2IQ9Kv58oB70ePC2YjUm2yBQRfDzxIwb55I49OQxG+rbee7Y?=
 =?us-ascii?Q?LhVUZC8JlHouVfCYmBzO07sa/OJ49fiNKLrU1fHxD+OAXYg33YokDrOXTmDG?=
 =?us-ascii?Q?Ni6wH4SXjlhaXlKx6gYKmoZbEi/3VdNMs/JOeRBeXcNi8XmACRQvOZsTaSix?=
 =?us-ascii?Q?TwJBrBbTMFc8WxxDQGMXq1XPq2olH/uo3BHndtHI8AXEcJV7irTnMiqo67X6?=
 =?us-ascii?Q?FgD3y8HJwJ1jZ+o3dkI5fWAzHVfcHXVZD1zw5l5RafsOsljxmC2GiOSt9x/g?=
 =?us-ascii?Q?awg79e3cWdxBANTqQo9zHETNhdoU1N4KMFGBvYeazMtLiPZOFNVdaBCLA49Q?=
 =?us-ascii?Q?s17cK0gZcLlNTV04z7/Yzi3Anue2C7hSiuJuxLt7A8Ll8VMxmhQ+ZLTIWdFP?=
 =?us-ascii?Q?ja4sl5Og0/NM4WmKhji7/Bb4nqa5Cs3iyGJi2GHqY+LTYfkQ9eDqrgqOQSgg?=
 =?us-ascii?Q?ut9UWbSJNWDYKzJSBEQsig71UyoXlrYVBSF2Ktkgje2F2GkY0Rh6Lv3NzCFt?=
 =?us-ascii?Q?n8LpXkc1LV2CV1fpKqIUlCaTNfgfzLlkZKezqcDSBCwZCcHbqkAegZZl0quu?=
 =?us-ascii?Q?3pt4HjIrJG3AC8jORNym1Y7Noqi0Ui9MaXPeVqLXkxH7VSpblek/oErUR/+e?=
 =?us-ascii?Q?2z4AangWDmNaZU+m7tzqvk8SdaPkFtsemXtZfgJehZd6HFZ/YbDXFHjm9Nyl?=
 =?us-ascii?Q?Xlzyi4iCqq0FiuSowksWMT3RBVQRFQGyD+4KXSWdpXv+CC4/omj3aknIDJbg?=
 =?us-ascii?Q?XhUIFOAyoXU0CObUL4rCbFqQ4p+kze+UE8c3R4YGplagw9msrzgvS1KFD52/?=
 =?us-ascii?Q?/rma+f1qm7xljG9AjL0bbbrDptcfit3cdDDdut/u6nBP3VIk9djLB3asli7y?=
 =?us-ascii?Q?LVOSReZoc6pnAyOZ6d/oMnbTitqG12w6f8N79trIhn/fepHZ+lGSrvJntjMO?=
 =?us-ascii?Q?EZu05ad3vXw7EfYmUUcm5rCYktNOXtRjQD7u6gIU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5cb472-e92f-4f9a-ffa5-08dbf5612065
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:09:31.3228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXopE6X3Xvb+jOU7kPaU7g5Qo3r9WUNX/MToJKsqVMGrPSjn9GljN6fUoQUJBG+UT/KDKE1GqJDEt6Y9K0jLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6055
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 11:09:45AM -0400, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2023 at 05:20:41PM +0800, Yan Zhao wrote:
> > On KVM invalidates mappings that are shared to IOMMU stage 2 paging
> > structures, IOMMU driver needs to invalidate hardware TLBs accordingly.
> > 
> > The new op cache_invalidate_kvm is called from IOMMUFD to invalidate
> > hardware TLBs upon receiving invalidation notifications from KVM.
> 
> Why?
> 
> SVA hooks the invalidation directly to the mm, shouldn't KVM also hook
> the invalidation directly from the kvm? Why do we need to call a chain
> of function pointers? iommufd isn't adding any value in the chain
> here.
Do you prefer IOMMU vendor driver to register as importer to KVM directly?
Then IOMMUFD just passes "struct kvm_tdp_fd" to IOMMU vendor driver for domain
creation.
Actually both ways are ok for us.
The current chaining way is just to let IOMMU domain only managed by IOMMUFD and
decoupled to KVM.


