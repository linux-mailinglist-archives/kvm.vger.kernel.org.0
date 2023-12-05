Return-Path: <kvm+bounces-3466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E274804B3F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0958A1F21500
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C39428E34;
	Tue,  5 Dec 2023 07:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvLVUbNL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F01CB;
	Mon,  4 Dec 2023 23:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701761909; x=1733297909;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=XrDqvcHlFuIPEPslRKT64ihPvpS7QoiRNf/txQ39orY=;
  b=hvLVUbNLrz3WB2FdBpztJ1blS9vCleGuMytH/L3bfkWEWRAwtOlqiF8l
   H9PsXgdf1kSpv5Y2nE4kib5abxSr0kaY6dwpKdBwrGvUDN1O3nY/LBD3E
   nm2nFCcCf+zyaLozU8ZPmwaxD6BOIc7O7ENpl7Mx/AH/PiSEf9oy0SE8K
   SvYadvBiYS1VfYtOovDWSXBuUdPT8o4L982K4mzGYr59tYuut3dakM3FW
   /9ECsPFHeN72Rzq2yXftr6VxBqWav8bheHd4EdnIHuAJfl8cok9MyshPS
   kLya+wwp6HsXuGcWb5oaDdpq8y3OBskxpfS6N+M4WQJ95wEWFGc8lFfG8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="373302814"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="373302814"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:38:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="799866780"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="799866780"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:38:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:38:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:38:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:38:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuI6LL8hBm5BGUkq7CtfDvAL0SHJpZ5GIAGlRs8HTJVREP6azhxbj4G0Z+YKDRRGCUJGEltto4GRXiZ6wiNPxLxyMF+jG19/J5J+mMZHsqBZQ20XmUFhrOl5/K2KGPiJmqPiGIEfMBeeqqDvCTaXfvnVINdrWpWZb72VzMj9baD3BGdtxOFJ0d5/XcH0WGj08AltmBh7CGtzNIibvHPyvCK9hfsHCEN0HeS2fV6c4IkXduVUfj44yrG4dUL0pV3EvCgyiNjX7BNm98icSz4jgu2y5eGEFyvP7ggF0DpeVxAvuIbXWbKJ0mvx3IVRITWW95Bt4Eq+4Vq5kSO6ePPBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AzFDmTDM2FZxOgFp2xjuCA345kOP7+JTpXKC3t1svI=;
 b=MD9mBFRgBqPnjalhEhXqjApykmbCgbiV0oQlI8x2kZCMOqBC+b2wTv1MzHRmd+/JYYQFHosooZ+tBpS2pb0KFjWTPavMuf3O7I3q5sv4inB0FCYlHAKkgdcxHJOiXhulzaNlLJZjmlvm66ibmQ4cpCbPcNqusFBEo6amakOl0KM9YCrW9dXhyOVJXXiltKAlQGIJoKTMoiy5J3EFcrNuC70Eo2x2zMpMpR84sZ9Ce8bOGtlkQXeWLCYf4keCqoSJYHvJKm9Z0kQG3t1gZRpLHyyRirz3QdA6xoqQQBXUG8/GEcNmYlLhIST1cM0kpb1P7uz7ruGQo+LacBrcqotIWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4514.namprd11.prod.outlook.com (2603:10b6:5:2a3::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Tue, 5 Dec 2023 07:38:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:38:20 +0000
Date: Tue, 5 Dec 2023 15:09:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 14/42] iommufd: Enable KVM HW page table object to be
 proxy between KVM and IOMMU
Message-ID: <ZW7MnVXWw13W3yn/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092216.14278-1-yan.y.zhao@intel.com>
 <20231204183410.GM1493156@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231204183410.GM1493156@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: 74137d21-beed-4ab7-f860-08dbf56526ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: top7cAWsbXKDO/eF2dgI/zPczpbx4gHMGzyIsX+bFs755otNyXsbM9w9Ig1qj4LgoAPurlUgFp02WwSJk8o4cSqIX+nhIr4uURIidBtNaaMetaWx17h/FZat/xOiuBGmQj/Ck0eCL2xGBk0q8g8Anvybazw6W5QBIBGPvKkSrO4Ff+x7TYQxIjM+lOVAgDgIK8qCwKIWqrb6xyiEd4eZ6Fyy7/Up+wxQESvH9FvvuRvtbCVuREkvni/LQN1sxYKid0CdWP2aLza41izSr5ovgI4ENFr8gdMb9YAl96YkX3tgW5S5eShx9zQEs23o2ADXrx0asAmg4zb5wI71/pLe7n8P796jFcHDl1qiPuHMSEPDAZaULlcenCjxsCSU0MH4evoAysGqhD3HYR+rHAGXiEkSSyBTrpZTOXQw52Yiuv9ackQ0prEa3MNdWTIUNh33HGJUL4q3DAtQ0DAiUsCscXuTPYxpmwEfZI9511rFepwsqYFTb0n6mRfyh8V3iZGGR9udC5V9w1CUGo/aYE+sUtEfcMETzoWI3QmSzR0R3ILIZeSc0muNeiUWkMdOywNl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(3450700001)(7416002)(4744005)(2906002)(316002)(66556008)(6916009)(54906003)(66476007)(86362001)(66946007)(8676002)(41300700001)(4326008)(8936002)(5660300002)(38100700002)(82960400001)(6486002)(83380400001)(478600001)(26005)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KqdH+ao8rFZ1XthsUp06F1cp8nMD9/xrWVW0UeDflyIIDg2GpcDD9Msh0J6?=
 =?us-ascii?Q?XsXl441X9+zpixHNTfamcpRzLuUincVI82/hjHoE5YU9wFeHy9mqSCT+Rhl4?=
 =?us-ascii?Q?4J3Jgeif3bR9b1OoYrtBQXco6EjCnn1cLtLmvkP3GR522/pwzHjgm0hK92SE?=
 =?us-ascii?Q?KmSGa1n2dyjt26A4uVdXsPQac3rGWL8ua1GATJ3c77KwyA4bn8RvGl/ntcwl?=
 =?us-ascii?Q?gcE7zI+3GTltFjOxOKeRfPS+8asHohJSRlgFX2Jp8MskrVCOMGT4ueUJjNYo?=
 =?us-ascii?Q?gmVCieUYjwsJ3rhEVPAa/RQgmvbdAHWETMpRTc7b3zR5/X/W8wIaw0DJ/Q/e?=
 =?us-ascii?Q?Y0DNf+OemyrWFaGFvNLZT8dDPO19hV44vWsxahzeAAx4mnQCILERkZ4I6w4P?=
 =?us-ascii?Q?vEjYsRek4YS2JW+ip+kchRLlZJFOvJaPZyqg2bzm1ZtUrOV6JS8dT6kI79U8?=
 =?us-ascii?Q?1YYPFD9qK1M/gP2bPPLqfFpJcSolsZOwkyUb3K95/9xGwTiVpdJVS+ZZpKyL?=
 =?us-ascii?Q?YGeApz1SNSr+sXeaF3SbW6fYO1MdJxIqSV05on6bnpEd96SDWaFnoc0TwbJW?=
 =?us-ascii?Q?efK5XBByt6hsdgT2LmtgqFYtOHWy3vT6Nhwr+oWp6b3FM4rwRJfk/sIRe3bi?=
 =?us-ascii?Q?8l5zWCKUIwVahqf9J600VCoAUOJiIp0OCWPcobEyaym68jZD9RDRhkNuUei3?=
 =?us-ascii?Q?uMwyriOjJWpzydkvQTqeh2LnNw2JVJO4O15AG6Fctr399oOCVGDxm9cVQjyt?=
 =?us-ascii?Q?XeYmRd49O+Oyj/N5ylAruRKWQaSUPK4vQJNbE1vwR1KUUc0W4lKC+jvK7EBZ?=
 =?us-ascii?Q?VRwqXK5rLn9HzExLUqYdxbbqhcr7Y5K4JZP8E/RR064e7nJCYdBx+k57bpu5?=
 =?us-ascii?Q?QNgcE0rLLQ2sLVLRfE+MjCQV6K4wd+qzQVmkltaccVIZxK5vURDFGJ4qDI61?=
 =?us-ascii?Q?bwe9y3yb/2ox3oxCyQj0JObggsg2xxpD7BFnj2eLhCq4UQbu4UybVS7fuLgc?=
 =?us-ascii?Q?gXxt7U1zkMjumR6bnL87cRLgRDX8q2AVhurTGvuMqoLCkytR7BymSzcZcoNv?=
 =?us-ascii?Q?QWvxE0prCk/41DuT8gVtKLoYxAtce74V340v2RB4z6t3/RlvFW9fFS0RefV0?=
 =?us-ascii?Q?pFpVFJJ0WQ38NC9CK8VUsw7092BjHubwKK+QGZzUAGENt3tBKkwHnffxK40a?=
 =?us-ascii?Q?6JMmAlh5GlOsrgLK0OGpbjTC17bwqpJY9Gs9e1LJPOMvUxKhi/E3dwbX65cT?=
 =?us-ascii?Q?p8SORU8UDM6D0XaOOYtbsjfEn0PYxWM9OFK095zl+0LQ47ZD2eCL//0hksP6?=
 =?us-ascii?Q?3TKVJmmSI7yQCS+XoveOHVv1hUOKUu+AJXHar7jh2v4wf7mhvNMmtYjMKktA?=
 =?us-ascii?Q?MjRxp5P4bTJaYgPrZnqh5DBsGV+0AVvyZOMRR61T0XEN+wZ5Itt+cRp/5Bec?=
 =?us-ascii?Q?mEET1Il8fNYNN2tK5HrrahmafCfX0Cx1HF1B1m+tHvAK2TYcMk0baPbY/X/r?=
 =?us-ascii?Q?0/xGgm7GMiW+BMrLvs5bqU3ZeP7FObK7i2y23n8V9qS5AUNxVzRs0zdkG2q7?=
 =?us-ascii?Q?eAvzVMcCbnvH8a+NstvlIMGy7DcisyiDewlLvUFW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74137d21-beed-4ab7-f860-08dbf56526ff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:38:19.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Pn5WTZyLqyIUtg3dmg1utiW5SR785fcQMRIed/geGwtzAuCO0A+FKOLHbkCjLcExVO2YVviJvOP97Fb4mQ3Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4514
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 02:34:10PM -0400, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2023 at 05:22:16PM +0800, Yan Zhao wrote:
> > +config IOMMUFD_KVM_HWPT
> > +	bool "Supports KVM managed HW page tables"
> > +	default n
> > +	help
> > +	  Selecting this option will allow IOMMUFD to create IOMMU stage 2
> > +	  page tables whose paging structure and mappings are managed by
> > +	  KVM MMU. IOMMUFD serves as proxy between KVM and IOMMU driver to
> > +	  allow IOMMU driver to get paging structure meta data and cache
> > +	  invalidate notifications from KVM.
> 
> I'm not sure we need a user selectable kconfig for this..
> 
> Just turn it on if we have kvm turned on an iommu driver implements it
>
Got it, thanks!

