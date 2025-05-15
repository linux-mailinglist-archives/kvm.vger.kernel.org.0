Return-Path: <kvm+bounces-46631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B76DAB7B7D
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 04:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A1DC4668CF
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F78B28C859;
	Thu, 15 May 2025 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPbFlS2q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80077111;
	Thu, 15 May 2025 02:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747275475; cv=fail; b=ofpuAwgwsOcGPfsQIlTh+AMMziPwOuOBv/FO7cBxn5s1NfBdw0VfOxr2NYV871SPw95f4O7qHhnKPKrMAB/zau2GTfOy3pDQJ+x2PA1n19cVtzoHGi8DZYuf5DLXdnJVmXhRsC75iSv7kG/HBe+6kFE7k9alTwcda62rYDqzLiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747275475; c=relaxed/simple;
	bh=C8YI/gdZ+Sagy5ZKnJ4gwEm+Kh7vU/NnMi0prvfVpbo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UNpADM5rxczE2O00i/ewHsxQgPLwN2dvpK+lliFwjvdhEduffcikgrD3looQeeGEvcXkb386wKWERuBBmssF5a7xGkcPGTjqM78+1/Ta/Iz2Vf6MC/7Y9a/fv1bcr6OKvd4E1YCw3gR3nK+29sv1acBHSYNKCIAUhhsPoIZszHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPbFlS2q; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747275474; x=1778811474;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C8YI/gdZ+Sagy5ZKnJ4gwEm+Kh7vU/NnMi0prvfVpbo=;
  b=CPbFlS2q5tesA9HpK2Lut1KRrXjdq/xCtYAanw3dSrth6onjs/4Xvv//
   AirW54NlpJ0US9qsOXdoxu2IxO/D5Ou2+Op1QFHXfaa94qHSnUPaZ8Cj/
   Un6cWkqbtAAJi80QLbjgN6/yW0cdDWeu1pap/euvcX/GrSyVgzxOOUdi4
   I7UNa4noEtyD8SzgPKaXrR4T7rxzIhOllZHbb5cd/h5iLwKKK+7yHcOsN
   8wFcygwu0e9XqJvHvjeoqGaydfLZKpSf4zHoVjjE5v2EAYKizmdZkn/TG
   RGsunsmy8K0jojjfIOxl+cWLCvCDD/m52Qhs9cgPxb16Zfbsydm2icpXS
   w==;
X-CSE-ConnectionGUID: PiTGJiojTZ2B0HjcPEM4ZQ==
X-CSE-MsgGUID: zpDd7aNZRFGyMOs87Nfp/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="66749927"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="66749927"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:17:53 -0700
X-CSE-ConnectionGUID: jMqQRZCKQESLdAhLjK/Weg==
X-CSE-MsgGUID: uKOA60uqRm+A00GKjrCA0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="138724642"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:17:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 19:17:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 19:17:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 19:17:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzhaNzwM3///UcxdRz8wxLu84CiAtr2CzndccEKE/RC8qyrq3vpRd26Kd2bJoeuL0nX1dqeh1eSPWMLV3PoGjdB6EILoSzt1xNTTTRVEZUa5jJgslzkIrB2TWhsaUrfdJqPiPBMjQAM572ZImTpV0YdwznCEAvVyC9oNztzW6F3UPZ/yPxtu+p3RudoavyU+FSdanTcNliG8Hb83HpYxDjYxI4gbaQx5+K2h433TdgtzIBGnPv8clpGz3BZAgJHMAKi6xdSOPciaUBPjVJfyA6D2xP0JxkSQvI3L/bQJIscCMHLm4PPkzqDEUotO7f2uHA+bbh7Dd3srphbf41t9sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G9XK5R5BcKS4Wxt+eE2V6/i61W9NM/zG56MAlpPFZQ=;
 b=oQGlPBSE5kUGS1nYMD62GNBb9xFrgShswHUqXEg7J8MbkQjhlN0P/wttghovhDg5b6cx2XlSFpcH8K1Ru+nJEJHobKk+Odg1U+Dgze2qBZCCJQIyOJcRZ9M9i4wDkCUZhVft6Mp5JBddk+HhZXHy9YaxxkYReDDlDVRABSOdT5Os2KG4d0guTTXv7nUFC7Akq8s1BfXiWD53/kYZ2lyB8zj8F/1SbsOQbcAPhtRHL6IeTNRL2mgAsJ5DE6Mo9YjVyUnEXsfqflS3bkaYpBUPRZ0WB1eI/aeGsaoBfHe50O+G85CFSL6LJkWbMp/k+EqQr2j2oz5/xBQr3f8AwgWNXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL4PR11MB8848.namprd11.prod.outlook.com (2603:10b6:208:5a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 02:17:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Thu, 15 May 2025
 02:17:13 +0000
Date: Thu, 15 May 2025 10:16:58 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aCVOmp/tlpgRuAF4@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250424030428.32687-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: KU2P306CA0079.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3a::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL4PR11MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: f25cec51-43c2-4aa9-3df6-08dd93569ac3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?V1jx9IHcOEGA6/YQ3YO/Gk4kLWxR85rFjWyHn4nLAOupP61jTNseXQZ7gSgH?=
 =?us-ascii?Q?wJErW9CHxxTGSNOQsRfPUW95V0h1Lk+i4AhIn6ebcBIjCwaouuiPlnyuTtpK?=
 =?us-ascii?Q?QUb8RPkfHcxCwrO+PjETjwlkqVi7wQMKzNMQc/T3WcHv+LujJWWA0kbqlLPd?=
 =?us-ascii?Q?TRLmouCJn7ZIZmezeLcH29fRM0YJ7LCrPZGvIbqM3qH0w9nbZ8HtcgTQEl2P?=
 =?us-ascii?Q?SjyPXU012kOLhfr12n8cXeXJtBcVUYovuSxV1W5r/znDJEvSHJ6wZYRkYDhK?=
 =?us-ascii?Q?0lho0h+bjYXZGyEXIyGYwRczWeRpB+TaU6b7HtbhGlUkgcWCr78c5ZPTSjYj?=
 =?us-ascii?Q?WyUiGuGGok+zAoygoDkm454iJVB9dr+BTtF2r18Ri7PcU7aRppRZM7PwRAUz?=
 =?us-ascii?Q?8A19kKUwHth8T5eS3gYp50Unmf9E/5ouCUaTMk/X8hdqL4jDbkh8zi3SYCVU?=
 =?us-ascii?Q?J8oQGR1uWpNM71L6lCxdgZyF6s8NgFtZz7//5VsfLbZd/+QwUTIFU9JkRtzX?=
 =?us-ascii?Q?bCGnMo1gw3sNwOosaEXtV9P8UcxnqSAP6YGqNpI/nL8YZwy65Lgz591gyfyl?=
 =?us-ascii?Q?RYrTxOE0v9bUFb5cP0IJCGKKhJtE1f7IchUBxoPKbk9rYZgglHkwvsszvl9h?=
 =?us-ascii?Q?c/0wYc0Dejm1BPrln+pHwmhQLiQKHOZgAD4K+wZQCVI8N49HogO/FdknmlTs?=
 =?us-ascii?Q?Es2sikNtbd9kN2EKevilO9XYh1sbBSg8P6cOteCr6Deufz7AiGSs8CEWohZU?=
 =?us-ascii?Q?mIKjRniM4RDsqi6EXbjkdsX0RoF1z9dv0eA+qW/pDzL3MVyow1/r77POjq6F?=
 =?us-ascii?Q?8C00BEkBBaEdnwJJFuBT9v/5zdSmNblJKbQ5G/+JwhFYMdqZWVAcDPQ8h74n?=
 =?us-ascii?Q?dzTxBeV7P6j6CrQVhktPLeB7XedXR0Kb5ABS96VS2vz4RB9EsCCv7GqkEEcq?=
 =?us-ascii?Q?ZyTIMA+LTga7r8liojCov9ue1k/cJFa1qM/Z0sLGglcNjc7gp8H7UoYsdHXU?=
 =?us-ascii?Q?vK3Pr6w3cmoSm9wpsbeblqAF8eY/XtXRsszODWwCPYpU4AJZc37BjuXkdH3z?=
 =?us-ascii?Q?QyD26vUUHncYYprIjnUHc/0b+m3aughQAH7ufnPucoaWPNqwCkdDJph+MKiH?=
 =?us-ascii?Q?n6PkhMGY3xkVasEoINJBhEAoVJwjmYLXY125zd/4VQCFL7GSYAaatVhMpvdK?=
 =?us-ascii?Q?1NC7iMsTaf4xrvPgFj2SghNlm6ESV+kqq6sf7IeHddlKAKXKZJVGQOpS0cSb?=
 =?us-ascii?Q?vUkNV3qlfu4bwJbwAJkQxlm47peoswesAEKCB4YETwT3DJiGWCl0nRjWFr3t?=
 =?us-ascii?Q?DOweeEiX+lZM2RT4fmC1ewW46uewHK1gwknsXC5Jk1tmO+abtSxiyYpNvOvL?=
 =?us-ascii?Q?moBAp0SxpgY6c2YVYtCZnwL6gFcvt2zkrnyzp4EhBw5s2quYhDCvevCLDa6U?=
 =?us-ascii?Q?F3VrJTCHiK8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xsUTzarXfNoaDmhQ5bJRVNkY+0xUsqPkntKbdeer1q/7EE8g4N5WbFlC6BT6?=
 =?us-ascii?Q?MvAqqli6GFdhiZjOR4SzYKo6SPzOyZisdXcM8mzzwPEY9qokuinaTWqYErty?=
 =?us-ascii?Q?IVqH4O9s3VEeNdABTgtbGWzasPB39nwUtpgtbYm0LQOKqT4BinFJMAleoQ5T?=
 =?us-ascii?Q?mPAKbmKtp9/Yw15hTO/DWXQXiJYogUu+KAehRV91nS9w4xGMceHwIAWqAx9E?=
 =?us-ascii?Q?5waOEc3Cn999An31IuyZatwxrudIhaDVAq/0W5i/Z7R0PrrU+hNeQpX1PULe?=
 =?us-ascii?Q?A0co5LkRTHNaEQIcfKKQTKhel0glnLCwdVdQpwiPiGTbeyawfxE39J2BvQFd?=
 =?us-ascii?Q?Vog94lbmbahIKeGBMbkEWZdLVyC1HJWuTtTgSbRh7Lu+XVDIdDvUtyAoDlHe?=
 =?us-ascii?Q?3dDCmGppg5dhIkXVAQB0QYRPaTXL2LpqIrCNSFnEyNy9CSegXXYHTBy9EaSF?=
 =?us-ascii?Q?eNA/EQ8xOefYVkvJ+MF4BKFOFyO4ZF9dukLi+ybewpZWTqgBrPkFJC+OI+cA?=
 =?us-ascii?Q?IxbOXQh0TCazgrlnUe4X1kHJ1iFwIEb5kZiv8m437NgQMOOX+bzT6A5TnreA?=
 =?us-ascii?Q?Zl7x4RSSMBRykYIkFDIOKx6unOw7D2GhuP9i+j9aceeTk7feZx0B9zN4mhFs?=
 =?us-ascii?Q?XejWu28NI6ACg8hShZkikthPDHZU8ovmLlAi5zap2NcWjjP3T25M/kpAJRsQ?=
 =?us-ascii?Q?nz6vIMc2v/pJD7mkLPC+ZbUZOUsULhBi9u3Je/+A3bZ9xNSRdNK/OyQ5ddwN?=
 =?us-ascii?Q?AMWSpsobQyKcjhbipumT+SWtUXH5BKsih8UvR7Tr+tV//xYyEgCcPqaFFgSE?=
 =?us-ascii?Q?11KU9Qe/7An17VWJKII4KL3YSD4IG2OjYpJedOjWKVJJ54JXtCodTO2i0IRL?=
 =?us-ascii?Q?YbsXPspEG48kVH2pW8OJx2EvptRhLlb5dTiNnhtsukjkR+zzAkeMEWg8b//Q?=
 =?us-ascii?Q?0HhLTLJmmasqYhTJ9oin06i6cD+ZdZWCl1wLeLweK96vOc87hbINI8sX3eLf?=
 =?us-ascii?Q?3Syghk7ybETs4t5p9bT6ACSULkHllvbw0y7iegCDuF+Q0zldsWTya9dgyUk1?=
 =?us-ascii?Q?XOl+44762tlVwgwoOVvo7t3d8ukb+TELj9S872X20GmwM/mCMK1wmfxzW8HK?=
 =?us-ascii?Q?RNGbIl6CccjiEtwppiS0Uf9aypf3vJDzTw+I92xdh0XdHFZrJuiPbGzWnUx9?=
 =?us-ascii?Q?x8xywsEkfL3oXvSYSKiPfBSvObIg9iUexIig1S+Ob7iiDhFa0LsptcBDW6ji?=
 =?us-ascii?Q?Fe0ZMn1zznW0TkxVc64R14L81O+dB5+abCZ1WpsQw8N7ayoPW8PwKuC8QXOS?=
 =?us-ascii?Q?mjBQUDEaekOEp4P3e3xgnMmVlQgxxEL3tYjVWrUHOgFxFgPkjadxuoE/ewEW?=
 =?us-ascii?Q?HwK9SWEVwCYqhrO3i8VR8+U9cXJzgoTGWAnVMDxZ+q+WpcisKi6ZKbl+G6q0?=
 =?us-ascii?Q?7j1+XPxjqA0hADcKDWyXxNeF0xvT4AjMZG7chAzLdVgQJKwnoYHEMZkNsbbd?=
 =?us-ascii?Q?9a88CP4grh0n1axdROlqanhppzFujZHDOQo4DulR9A13h7Ymeyci1wpxUq0q?=
 =?us-ascii?Q?/TgCmrAdFfkzSgsTTy4qTVQc61Sx7lbtBt3RF4eC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f25cec51-43c2-4aa9-3df6-08dd93569ac3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 02:17:13.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90yITBpBeBk6w67DijCVoTuLq+0ByCvjjqtTGy0uoNuIeWs95S/tcrm+IFV26NqF0uQQJkQgNM+uqNocvVu6xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8848
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
>Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
>
>Verify the validity of the level and ensure that the mapping range is fully
>contained within the page folio.
>
>As a conservative solution, perform CLFLUSH on all pages to be mapped into
>the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
>dirty cache lines do not write back later and clobber TD memory.
>
>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>---
> arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>index f5e2a937c1e7..a66d501b5677 100644
>--- a/arch/x86/virt/vmx/tdx/tdx.c
>+++ b/arch/x86/virt/vmx/tdx/tdx.c
>@@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> 		.rdx = tdx_tdr_pa(td),
> 		.r8 = page_to_phys(page),
> 	};
>+	unsigned long nr_pages = 1 << (level * 9);
>+	struct folio *folio = page_folio(page);
>+	unsigned long idx = 0;
> 	u64 ret;
> 
>-	tdx_clflush_page(page);
>+	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
>+	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
>+		return -EINVAL;

Returning -EINVAL looks incorrect as the return type is u64.

>+
>+	while (nr_pages--)
>+		tdx_clflush_page(nth_page(page, idx++));
>+
> 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> 
> 	*ext_err1 = args.rcx;
>-- 
>2.43.2
>

