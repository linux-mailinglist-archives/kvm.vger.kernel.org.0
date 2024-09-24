Return-Path: <kvm+bounces-27326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E08983AA9
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 03:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A8F11C2211D
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 01:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E76610D;
	Tue, 24 Sep 2024 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pzb24s8r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4AC184E;
	Tue, 24 Sep 2024 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727139629; cv=fail; b=U9jSLXIW9FgVL9De7zP1jukqfX/jEDHvHG8h6htyZC21Jr3Fx7YaEvTJqcbBLJ/6KhdHLqE6h+Rx9S4H4uhUKRAFSkv+8Si3jhtZzQloUVEJoDaN5jari8Id+1OEzqklJ4MBPjq8/xrApiG3rm5EUHcuyJdTpHCpUI63fFADEC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727139629; c=relaxed/simple;
	bh=BK0G77QAic3AnpHHtGIKw2V/l6AxMvBEDAsIEsSMCgA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FGeOj86O9NzdYLNiR0gL/0AOOHLlrA+nJDA848ICugCrIqwqeriBoKebgLL1tFYmxcsGZ0UL5B4VVko5Gnj966XCNf3WBV3lSWSMKGveaTxSg8hDePGhIlzQx5WmEPTY01gyVQD5ysj5OGEOFW7giKT0mYUvYsxHJdzww9+19CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pzb24s8r; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727139627; x=1758675627;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BK0G77QAic3AnpHHtGIKw2V/l6AxMvBEDAsIEsSMCgA=;
  b=Pzb24s8rNTBNK9T2ELQ7g0dvD8Puha8UGd2PnjUjed3PZxYhfGefOWgW
   AoAdUxGWabDavfmEoDTue/4I1jt4pVQOv9PIJtHanRUZKZTeYiL2aK9Gv
   8o3O4Qr1fhh/UM1D/W5jAVghlMSpR+w3FybBSxsslZcGKZCvIruVGrVFV
   8lgl0u6W+a/pdfI0IFS4KceoX4Pw6mEv67y+qaBqcSFnDLXflSQHEHKyv
   wzFg5rbsVzQxhlfrVmsm9gdpgtQNJtADw9gNtneYeluqUm5xfpybiD0O3
   DZaeSybp0VDhNl4vTjsOTBKQAu7I+dDQvYmolCjV3xcJLuyRRcxe6hLln
   w==;
X-CSE-ConnectionGUID: 3q+meDbTQ9a23NBwUPZTCw==
X-CSE-MsgGUID: Zt0WqoTPRZOL1ffyYpPrAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="29006953"
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="29006953"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 18:00:21 -0700
X-CSE-ConnectionGUID: 9dmoktzyTKmgMjbv5q2rWA==
X-CSE-MsgGUID: x3FC1LR4SqmXKMMxMTBK9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="94588177"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 18:00:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 18:00:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 18:00:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 18:00:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 18:00:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sSr0Tbg2Yz1772HmaxpgKEfyx0Sj5Mw3yYg4yEMEt07W7lWE2iB8qPcBA/el3R6MxrQLDqt/+KkpMyQdkTYMb2fKLbEMAVgLTKQzovs6AqlIEdMIToDT0W0loXyLnWE1Xjxmh8UTgzJEb1kDgeb2l2K+i7U027QmTF6rDB9hQX8d7VzvaiKT06j1o8TU8NX636hKnBGWiBI16YvCEe1Gh5cWQldTh/2QOfdw2+AhDuxV5mCrhBDh6wdfJFS0y9Fsq8WgD0VPCA1LdbbpGisiuUXmUJ4XJ3N9j0XZ4PLrDQL8kKIwTaE2z98b0epA46Z83XUfAlkyMrDFWeViDzls7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J23c5TJ9D+NzYrawEEYqazagXHtEGiSj66nOYNwKKSg=;
 b=esarir9m4IAWBRn7mGv5AXm20OQias/p37UyYXXxg+U0a/6Xz+k//zwB0QjM661WSr87jH13E7PpMZvFa0Iepoezx33KhGbvrgUx4Ii9xfVg0CEgI9DKN2ZUoVDgZ1W+4aTqF0aCGGPDDUDvHhggVwLiKioLsCRH2upoMfpZpKVz38ocis1DnEfsDW6ARB58NISR60JCmqeCL5+YXU+/HCYfWYMdLZLuqxiax1dih9mvN/gUCzZTHGu6l4aRU6xYrm4jHpJNIhInvqB+gpsYm+GsvFwDOKcH3KnUeGbQcb5gyZUEbOazi3+3kZtSd7I7CmBYK1xKqsYKcS2akJ+X6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7291.namprd11.prod.outlook.com (2603:10b6:930:9b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.26; Tue, 24 Sep 2024 01:00:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 01:00:16 +0000
Date: Tue, 24 Sep 2024 08:58:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <isaku.yamahata@intel.com>, <dmatlack@google.com>,
	<sagis@google.com>, <erdemaktas@google.com>, <graf@amazon.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control
 memslot zap behavior
Message-ID: <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021043.13881-1-yan.y.zhao@intel.com>
 <ZvG1Wki4GvIyVWqB@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvG1Wki4GvIyVWqB@google.com>
X-ClientProxiedBy: SG2PR02CA0093.apcprd02.prod.outlook.com
 (2603:1096:4:90::33) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: eb282a93-eda4-455f-a968-08dcdc3440dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6z/eawqnRLGVURbYgvgfCTXuMkfq47SuFiiULRr38EoCkhhtXGfdefzfpUsJ?=
 =?us-ascii?Q?xF004Qn6+NmzpeWYH1778dJQpjqpWlDta63FLOSgifKrl9jhKEptvV+ijSeJ?=
 =?us-ascii?Q?/qswBw57stuYdf8FOdzEHH3ZAdhZKzfrmAIrz2SuLuMsU3S1eZMrfWyI0VGe?=
 =?us-ascii?Q?xJaCcW7XJ89+0dfioX8hozK0/ZdEHuY/XoGWjmD4+uwhG0ogftuQfMk48UN2?=
 =?us-ascii?Q?DlF32Qitjh+bGUeEgxF/Xh3ux5M3HVyQKhIfJygC2fGlRX9ktXmgl8AxAq8L?=
 =?us-ascii?Q?DLxqegbn3akz2/i9Sutv2ujLCqtex5y3bOuWV+btl0SMvDs9fK5Tkgxo7tlZ?=
 =?us-ascii?Q?MDNIHcuU/ZeIy0jAeoDEMb70uSWu9p8hpL11on5wSSTDy2UUS/kMow3tz2Pw?=
 =?us-ascii?Q?9YcTnjDK9yh/IAeBwAKRvzGyKQ6f0olYponeFr28TK5BPOQex3H+tY+R6QR+?=
 =?us-ascii?Q?BBOZ4zvPrkGDlYkiYXpzq62y4+NN1cbwmpOlyHTE+GpB9ueqYHxZvPu64LUp?=
 =?us-ascii?Q?gTXRvHhAERyMtLMTK2rsZZ8838mM66HqyqlgaUfyCS0vgCPMk2Cj31QEYwwn?=
 =?us-ascii?Q?6S/VWfwuBpRmLHlYu6ouBInDMIvQxSyT42MJWa/uszpaxmRQBMqkAxMuOoa0?=
 =?us-ascii?Q?ouq2T1kohyOK28whHGGUPwaaPyzpKynj4W9Y+0dxo/nl9Efhxl7IsVwiE6W9?=
 =?us-ascii?Q?KBFOZjs6n7xEzEFiWHtJMSASs5qWas1WU5hqLXOtuIob+uYoyFwPRS9cISZp?=
 =?us-ascii?Q?wc0gBkg5hJR7O+qIGEszfaUFxWAfm2CqenXznG1z+dlWwqPZj+JtereggtU9?=
 =?us-ascii?Q?xqPhPkCpjsOkNBSReaQVtXSdPDyeATaWwsiU1+3ydS0WLEfn8jyD5ybsq0GH?=
 =?us-ascii?Q?Tj5UmnbkXWNdV4KcdJkEi8BYZ3d/Xxu/GUwfVFKpgNlY1U8CIUmQ7LC2TiMj?=
 =?us-ascii?Q?vUQD0E+qPxWmvmAy6VtVhHyMcGoikIYVDyKMj8eK1OQiNdWbQXFQLcuJuTqb?=
 =?us-ascii?Q?p1JqyN3lkSbDMQte/NKACQNBiw9u6swtfrkbi6PIIePT+ZDn/VRSfltSAGa1?=
 =?us-ascii?Q?abGT6vpB1c0EwAHFOJmrLsQeSDb7gGzpOlXALA1VxaxcSDe3H7tWym4rDcDv?=
 =?us-ascii?Q?gF37T9UsB0SWE8CJuZghfsIRgCZ72t8dzyYJwWZPpAGz8Ag5I9ZqaqaCeeBp?=
 =?us-ascii?Q?FG0sj1RscTBR3Xx3MXOBwEPt+hEGKI9KOn38bw2ZxuVk4IxGzNsI8cH0caca?=
 =?us-ascii?Q?kMse3julDLP2vxSkT6Ft9fkQH1T8IiKrk+yAW9LLhdk0XoWvyaqvBwNYPTLr?=
 =?us-ascii?Q?Z9yvXZ957tMAruGfyT4QPcJ2jkUWe4oz4rMmbVyDU+qLhVetUj1VpQ0s9wN+?=
 =?us-ascii?Q?8aTa3I0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HKEgnRI/ubK3M3J4iu8XYXq3vXIKXHd433VEy0t/iou8ua/dN/K5yAhsHNeZ?=
 =?us-ascii?Q?eMKOHhLmeb/q86DkZ3ConeTlWmmoFdMygqQHDwIRbUOFP/0KboQWSbBekGqX?=
 =?us-ascii?Q?/8AHVRRpMJu9qbITBHkv/goAcbpLs4ioVKuAE8dVezPrN/NSABXD4nnC2fDh?=
 =?us-ascii?Q?nCE+WoqzK9IbP+z4ksQsb2zGJ6+dVGKuFnsOYPP62Ixpuboekdc8TKMOsCd+?=
 =?us-ascii?Q?5OOui/YiDVXxsealYhtv/iqNFtWYQMfnEZXEyo+KTF3RcvAzrITNKCJx8fEQ?=
 =?us-ascii?Q?mAXA2Sro9PDMd7tcaM/UpcWe+L5+Ngi5oLfAdstrXzUnYjIZopuyJhhoSGQy?=
 =?us-ascii?Q?3MFWEhqh8MbAoz/qnOiwhi/xHvJ/rSYrXvjvK2x/qLNFJ+xWn74cMm4tRNLy?=
 =?us-ascii?Q?7faTu7L+83skekD+BLVkzduupxZL8FKeFRd8MMhaOtUn1zDqi0IeBM3UATVX?=
 =?us-ascii?Q?9C+tnBtV/w5EPctm91gDFFEepFWUxduEaNu5TKgU+c94kyM0k0PF2PF0FeVN?=
 =?us-ascii?Q?8OVV3z8nA+sigiDqKmIx+EfXVdWg7AD63eq/Y6fuWY4JjTZhzntSVhIvMd32?=
 =?us-ascii?Q?rNGElSba4Qxi8S7GSvwjC5bd0ogiA+JMlz4En9aB8Xzt/yATZi+vtx9exAsF?=
 =?us-ascii?Q?BDBNRaWM6NZQSCJXjxUUlLapVcUl42k7Dh0oXRsiGd6ReXZx6qvyu+UerbUs?=
 =?us-ascii?Q?ksw/WjZZTpKxgpN28b42zo8qpXu3ZOH1McdnkUHELuM1uLq0GTl96KdZba2D?=
 =?us-ascii?Q?K5Yf6AnrfuKths/O7XDdRL3dIwjxrqzbr/CeIMYyoyw8eDpQjJfIgTLWk3gq?=
 =?us-ascii?Q?frXx6hxXGz/WDI3CtqLoVArjnIM3CanOhn/rNXe/mw2tIS4p5hTlcaHzcjN/?=
 =?us-ascii?Q?NU1ZtRT75tMYJbXS4rMiGLQJTkBfQI9L8jpapb6K2eKxjITdG9j5/UwzVXux?=
 =?us-ascii?Q?/8non+ecX675lYjkHQFp3tVSsGl2AkQSnaq0YeCXSYps04x3LG2Yp6xcqVtr?=
 =?us-ascii?Q?1/eXsdT1LA2ChH+G/GSBIwgPN+C2XkohfzFLzgy+uPjPJLETvhHfe20TbzP9?=
 =?us-ascii?Q?foYm4nkOlD4vbQepzd0H4V6IP0MA3TOhDx2kBY3HK53G+vOATcP05B5GOHhX?=
 =?us-ascii?Q?IPxLAdH5zxJm9rznjNzRxIZWKt7N6JkDxOzhj/PsybUUBprfLHQkSLi9PPe0?=
 =?us-ascii?Q?rb1dEN+XkCqyhaYjL4g7zig4Q2yvNoPQwj9v+dM/R54xH/u88LRhrixmbHM+?=
 =?us-ascii?Q?HlLuWoBtiYVh2eyht4+fgXuCEdyxOfvzw+yeZEcfVBjG0ABmsLUMV3FPZVVo?=
 =?us-ascii?Q?tqjZ+sqi2IETk67ZLzIP4DP+A9cQQC3DQbgeV5cz2R5KD85WaJVNmXIWlc4l?=
 =?us-ascii?Q?8XKRKwVqHV7AdW3hJ3GbD1aR48jAd2840EWb5qHuTPGlfgQQLBbwdtlJz8Qb?=
 =?us-ascii?Q?layR0IsR2jYTGzA9uXhP57Ly+cy5fYqUNKd62repPOg9iO+c7fg36jm8+3Ao?=
 =?us-ascii?Q?M6XFOMhoqCfyKNT8OmHB7VqDwnzXC1Zop6w8nU4jXQV5c+mAhxXvbDYGRVX4?=
 =?us-ascii?Q?YaxzvLLafkGK4hE8EkD/NXw0gOM5DiEwqeucW3ig?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb282a93-eda4-455f-a968-08dcdc3440dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 01:00:16.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+hn784a1re/qF1nt2p27MqtUf8ybVtG0ITgOvpzj1FOnIrCPMD9dzXoRtKP3vnkVuEQMyWjFkGpG1uKeEAaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7291
X-OriginatorOrg: intel.com

On Mon, Sep 23, 2024 at 11:37:14AM -0700, Sean Christopherson wrote:
> On Wed, Jul 03, 2024, Yan Zhao wrote:
> > Introduce the quirk KVM_X86_QUIRK_SLOT_ZAP_ALL to allow users to select
> > KVM's behavior when a memslot is moved or deleted for KVM_X86_DEFAULT_VM
> > VMs. Make sure KVM behave as if the quirk is always disabled for
> > non-KVM_X86_DEFAULT_VM VMs.
>  
> ...
> 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> 
> Bad Sean, bad.
> 
> > +/*
> > + * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
> > + *
> > + * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> > + * case scenario we'll have unused shadow pages lying around until they
> > + * are recycled due to age or when the VM is destroyed.
> > + */
> > +static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +	struct kvm_gfn_range range = {
> > +		.slot = slot,
> > +		.start = slot->base_gfn,
> > +		.end = slot->base_gfn + slot->npages,
> > +		.may_block = true,
> > +	};
> > +	bool flush = false;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	if (kvm_memslots_have_rmaps(kvm))
> > +		flush = kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);
> 
> This, and Paolo's merged variant, break shadow paging.  As was tried in commit
> 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot"),
> all shadow pages, i.e. non-leaf SPTEs, need to be zapped.  All of the accounting
> for a shadow page is tied to the memslot, i.e. the shadow page holds a reference
> to the memslot, for all intents and purposes.  Deleting the memslot without removing
> all relevant shadow pages results in NULL pointer derefs when tearing down the VM.
> 
> Note, that commit is/was buggy, and I suspect my follow-up attempt[*] was as well.
> https://lore.kernel.org/all/20190820200318.GA15808@linux.intel.com
> 
> Rather than trying to get this functional for shadow paging (which includes nested
> TDP), I think we should scrap the quirk idea and simply make this the behavior for
> S-EPT and nothing else.
Ok. Thanks for identifying this error. Will change code to this way.
BTW: update some findings regarding to the previous bug with Nvidia GPU
assignment:
I found that after v5.19-rc1+, even with nx_huge_pages=N, the bug is not
reproducible when only leaf entries of memslot are zapped.
(no more detailed info due to limited time to debug).


> 
>  BUG: kernel NULL pointer dereference, address: 00000000000000b0
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 6085f43067 P4D 608c080067 PUD 608c081067 PMD 0 
>  Oops: Oops: 0000 [#1] SMP NOPTI
>  CPU: 79 UID: 0 PID: 187063 Comm: set_memory_regi Tainted: G        W          6.11.0-smp--24867312d167-cpl #395
>  Tainted: [W]=WARN
>  Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
>  RIP: 0010:__kvm_mmu_prepare_zap_page+0x3a9/0x7b0 [kvm]
>  Code:  <48> 8b 8e b0 00 00 00 48 8b 96 e0 00 00 00 48 c1 e9 09 48 29 c8 8b
>  RSP: 0018:ff314a25b19f7c28 EFLAGS: 00010212
>  Call Trace:
>   <TASK>
>   kvm_arch_flush_shadow_all+0x7a/0xf0 [kvm]
>   kvm_mmu_notifier_release+0x6c/0xb0 [kvm]
>   mmu_notifier_unregister+0x85/0x140
>   kvm_put_kvm+0x263/0x410 [kvm]
>   kvm_vm_release+0x21/0x30 [kvm]
>   __fput+0x8d/0x2c0
>   __se_sys_close+0x71/0xc0
>   do_syscall_64+0x83/0x160
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e

