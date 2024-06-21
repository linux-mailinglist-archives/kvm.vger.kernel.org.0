Return-Path: <kvm+bounces-20206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1165F911C82
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853B31F243D6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 07:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC3B16B39E;
	Fri, 21 Jun 2024 07:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JvK7De0A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A6168C20;
	Fri, 21 Jun 2024 07:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718953921; cv=fail; b=LS7ZIcS5K/MvI+Gi/9P+oeKhvcfqsmF8mfhqBtOUz+nrceLAs+hOg/tUMyIBly1Bb/eRj3LE3fTb96rj4Acx5+Z41wo48Ep1J+kLdTzQSsj5pwtiQeok2xixW4F9vgJkhkexYjB+mPFC6+qlffmf1BKwoOxYwddUnsRILwRxuTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718953921; c=relaxed/simple;
	bh=M+CC+MiUps41U3KGkMBL5OuT2t7CQu20pAGv8iBxj4s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SdWxrXs9FyuDbDVlqZpVDGpr5PfO9dh3riJGG73h8GRj0Xz/vXJqdiuP/kXFFZzPiwi8o378nDMEOUavvzKgGo+w5Qx7rkmkIi4WXpaAxAg+AzGLqm8nxsxyZAxghb0EprD2IKwHIILEcNkjXESmwPjSogh5AhymdGpbo1ZpYmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JvK7De0A; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718953919; x=1750489919;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=M+CC+MiUps41U3KGkMBL5OuT2t7CQu20pAGv8iBxj4s=;
  b=JvK7De0A7VPYXUR5w7KXdWHODXXeOPI6kjASAs8r94eKFliRSLUx0TB9
   JDu1HnEy5pU0F3MA/TqLlWkKYOB54w/nQwqBzPwwxhBMxuDK8ymqGzMGe
   WcVW9brQXjxCKcCbQUHV2q3TC4N59zg52L/5JYUA1ZJHrR0lfotRuyUH3
   bjK9mCklN531GrjR4UINqJZcoUjGvGrFJ+teI1Tn7MuqPs10OMpm8ptBo
   Q3fNRRmZPIun6TPdolYKDqC/YpZgxPHAGqRZ1e1khgDgArmttAl8BDpTW
   ZGv4bJfk/XUsR+TXVpq11izbL9B9ek7KH3iVWEissqI9/v0XjZtXqX4uD
   Q==;
X-CSE-ConnectionGUID: Rha01OYcSOy6BNBwHkpUag==
X-CSE-MsgGUID: gE5TAqKfTSijcCMWNp2WDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="38494681"
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="scan'208";a="38494681"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 00:11:58 -0700
X-CSE-ConnectionGUID: 98GtokgWRBW22npeiIT6EQ==
X-CSE-MsgGUID: bJrZdzvqQpSdo3uCxnhsfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="scan'208";a="42322010"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 00:11:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 00:11:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 00:11:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 00:11:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 00:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMkadJhxpqOpmhKYaDpqgj9HnstZl/yEhP2YR1OdZNt166fV+O2Q9j7SQKNVQvXW2BNpWGHPjisVZGpe9gv8UiQkNfjm90tL5muOy0y3TU5/ibq8D3RWmHFBSOApHDTljySI23mAjfgvZFmO4Wh5jkfGH0XQQunG8bDWkZnk4cRl5pUqDmJzXqoS/dymXGac3DQuGnvJ2gp9h1ZAeB2iQZTq0iO+32FzIwn+3q3Hn0WS5iY+ilYZl6eD9oo1IjfDU/U7oNjOpznc4O21TQ8B25kDxGnmrRC0ia0Z9S8QJGCWbe4hDM53buM8SsRoD+jejhgayh6c6ObwWHY1frlSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5+MtH6tGaMQMDGIrCW+kCVxsslIlZozyKb4p856Mms=;
 b=ZKEMi0GEiTOMA8pvy48A2FOthQ/XFrGR6HIA4tJCFrnuZnnh2pPWuKQsXCnKkWvBETVlT69t2YspVAdRscOnB6LnSQNgR2vb9xRafQbOeIQM+7n9NOv7TUWG/3Qm32M1C6IvQ6l0O/Gdi1DqzoPPipG8ABDCjpzSd+cp7DP34sDJ+1FDIEyCNP3flpdhMj+A+X9a1M1v6yrboBr+jm1KAD9bL4n7L2Wm5uD15j33h0Bs4fud5TXPS+55CNly1brIvn33V4i74K9ztfyasKpsAdKhbNQdkWUCppGjD3ovIYI70OSMksVVdPx1g/l8O/yItmchppdk//la6x5+bfRjdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7504.namprd11.prod.outlook.com (2603:10b6:a03:4c5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.21; Fri, 21 Jun 2024 07:11:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Fri, 21 Jun 2024
 07:11:53 +0000
Date: Fri, 21 Jun 2024 15:10:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <erdemaktas@google.com>,
	<isaku.yamahata@gmail.com>, <linux-kernel@vger.kernel.org>,
	<sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240619223614.290657-18-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:3:18::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 154f7f47-87bc-46ac-a8fe-08dc91c16d8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?v6l+v+FoI+HvUstCQZDKb/MHNftd/sW1eTHhxKp7nF28qx4av1Yk5OCa9QPO?=
 =?us-ascii?Q?T/15YxkFro7HtSTVHB+iSfmFLU9eDRpouXmGwvDkGKpzyY998OReyORy02qg?=
 =?us-ascii?Q?+EKKbP9IdDCPk2YrX3hm/iP/GM36E/vRzbSqxalL/ME7bmyfhT8CWrjF6liy?=
 =?us-ascii?Q?MG8qFfi0/Z1haD3qWkoX1/y7uoM4g5ziiggoXc7L6zxqQhzJTVz9X1Wb7Eqs?=
 =?us-ascii?Q?QdIj7ygfJbWS3QXEWY9axs6UUBrM1LolHwguW4jqNyEK5lZ0fZ0fj77kiqI6?=
 =?us-ascii?Q?D9kV/8vjBTFRYhg/t6JYZdXphZXz4KRANBMpkftSpXlvuVOn/a4yH7k+gB9H?=
 =?us-ascii?Q?08gLROrB9fG7/9rBaHPgRgzrlM/bcN7G0Nhpbo9j2sizptcuP79E+9sRdQy4?=
 =?us-ascii?Q?1vF4Qv9bmMcSW1MnDcrc93AWZru7D1n9NoD6O4q5vvDxkmps+0X4JqEDpsfe?=
 =?us-ascii?Q?pgmQhyS4I4bQ63ptEInAcEyrYMjpBdUCLRoc1uVWHGDbgSZ4bvUHZmAzcpVa?=
 =?us-ascii?Q?o8EE6AOfaBUMLtlWBnJBkHAEaHX7vwMQ9viwQPLsd48rj+ZimJhnPY3q+sjI?=
 =?us-ascii?Q?oMyZ/6qPhWgK64uLtyZYU8iKzwDP96nRPjjev+TX83KU5Sol/opMs1MerJcx?=
 =?us-ascii?Q?A4vgXJV2lEry0ocxaojUDA96OgNPX174AIhiy5gfrL6LIDAn+KXU1gZCpGJt?=
 =?us-ascii?Q?7ktQQgparqpSlUzHEBob5chtynHmOFbIgqTZZE3YS1ot66t/CB6omoJdc5nX?=
 =?us-ascii?Q?ZJ4Onuyg/n/0mKn7uMm50mvqc/yNEU/zRaJiSu7YZwAH0b9YckcnGSs+7P7c?=
 =?us-ascii?Q?IWPMBRml0tUDm5RnkVUQgHT+/SiZJJR8UvG0e504v6SBnXi5pvBWcmNnky1u?=
 =?us-ascii?Q?NEe1KE5yPTTRn4nOD09LdxITNZkZ4HDUybCcQEC+2tJ1QZRb0PC9u6EHwsky?=
 =?us-ascii?Q?ydHOp3AGNHgepJWdPXxz+rs0ohOrh8bmkJ3Ix31xmzKw+2/UibFj+nhV+OA3?=
 =?us-ascii?Q?gDvRDRtSXjvQ0e6di4y5roeHDD1ycLfWJKiM6xqf4NFZcKtVrr2YYadCRe0q?=
 =?us-ascii?Q?/PiOrxf1/+lAnhK9cDAgLrYPcp7ITbjdzU5ew4RRBSNcyin1fW5rz+bspk1o?=
 =?us-ascii?Q?HU5OjWHPzXMt+ch5dofa2SMgq4jmGzTMry+6BUaBjOazIs5Xzqn/hXrQapuw?=
 =?us-ascii?Q?4z0iVN6qsAeXU5itRV4rMjEioPJjEAptAxaq4tJC5KgycUEalCMw9eMV8Zw0?=
 =?us-ascii?Q?rLWUlDIcBCD+rFWuveUVR2+Ypsoqrb1I+0s4/LmAYEw23+2M3UMJv4Jaqas/?=
 =?us-ascii?Q?IEj/qKjogXb/itLKjWt32F1S?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zjVKqI2FFQm67tU5CPFGBIwopCphGu9uBCGaEY4SXwCk4q6YU8iX9tzPb7Kn?=
 =?us-ascii?Q?Mb9Vcq41iGxDF//kyEkGWEYnU1naBmvnbY4jVIANm5vcvbdG1tzXj3gv7lD3?=
 =?us-ascii?Q?pY63t+tk7qMdG9yKFC67zIcpnTQK8v/OzN66PKdpzrAdf1fxH1sbbL4b3+Yv?=
 =?us-ascii?Q?+UdN07cft/MwJMgyEdMD6QTthlDEV50wzIHVU9E/WchUM6OpNxWySoMhaomp?=
 =?us-ascii?Q?7L7xuvsyfqvlwoBfnXMxeze9h/znTIHaHdDtZMkIEKb1ZvrzTbYK6kaRnLV9?=
 =?us-ascii?Q?qBNbliAYpeQbAiW36bi2M37QcXF8r8PLjvCzpfmXEhc/ZjdH+RtsRTYDCSDp?=
 =?us-ascii?Q?i1o7LPeDi4+9jHmIj9LGGV8gZLwDa7g+VxsMpwC/MTzn0fV4bQ7IvFldnB9e?=
 =?us-ascii?Q?+DgwZ5YSqErUciUKZ3SNyjiY/o5yagtfTnWs5v7j20gi9gkTubDeZDEVU1Sj?=
 =?us-ascii?Q?FXTkj4xA0ADVknOcDmwmc+oZlFAve7GGsL2GEWgABlwWIV/DOiP8ZOxvMQIl?=
 =?us-ascii?Q?+yTeMGcVxVEa+sDVWjkFHWiZUV7hSSs4V2cDxANtEZuTeTCtJzqtMQ1zOmYn?=
 =?us-ascii?Q?t0uS8KcUKFYmgjTNqOg/IuQrNkbHIV3DozlrDqH0LxP249H8VJ8Mr3iqGWfh?=
 =?us-ascii?Q?deFljeBO2EJIEPsedg8HfUdas9d0bLG487JhBfP63z0n/lcf0Wt3Mz0ZOCjq?=
 =?us-ascii?Q?77vdSSCFv0ypR6lJ40uF8+Xv95RGx7LsDYDiskvws/dTT3DvT4jHN48K2QT+?=
 =?us-ascii?Q?gO+NkQyPUXg5NSucfNg1VLs0/IAFNBtcA7uDYpODdM3yxzoRQdemzduyuWTJ?=
 =?us-ascii?Q?lsWQt6GBoosV3v6S/8i+mQ/PzQGm4jpLrN6yOiAqzGe3S9O5wC4nCw/UzZjS?=
 =?us-ascii?Q?xE2szlYVWO9AkjB95+n/ztneVs42FfiK3pF5G3M9LDbGN4oRfx5VpcZrSSK7?=
 =?us-ascii?Q?sC2S9yAXYB3mv1/OBTfxyvjHcCTiijPiU5lV9ssPZwuJ4c1tl7qCl+WOnFPC?=
 =?us-ascii?Q?cz7EmzOzjZdfcfN7VewKCTzz6Fh7vTvt7HY8ARtRt2Kbbl3vuFXo5/RvZZyK?=
 =?us-ascii?Q?b6GaQ8kV/ySm68XBsadYwetv7o+uyhO02fccHmS2958ug+qgA9+FMP/VXt/D?=
 =?us-ascii?Q?n7wsEvnSo9Gann7cWgXsfzTxCA9W0zmRdBzbWUf9igGqm4BnafoA5PDkYoMH?=
 =?us-ascii?Q?2OXiTIyYiS98ujsyS/GD4Pt9pcKWB7Cm174OlciWWbEhFKBt2RYQtKF/lBwr?=
 =?us-ascii?Q?rHJsJAuNXr2w2GfSdstfFsv1DeZxAVtTX97O7uySFUujoxq6es/SfpgF6N1V?=
 =?us-ascii?Q?t2FicjRMr2qmvKCBk5MgmZ2lpkm9pnWJvuXyurphD9LVKHaplExgPuWiy43K?=
 =?us-ascii?Q?yt29LNwzwqsHAoP4w83NTR2jUVKnR/bPGOeXiUMNjBaCEobuCNGnCM8nloTu?=
 =?us-ascii?Q?3ae36y72FNVU2y6IS0No2RMLlxlwuMp8ekl7+lpi1HQBfIFVo40xMRAnS5B0?=
 =?us-ascii?Q?0o2IzPbPtrwi1t5FWq23YSBKzzQAkjpW3khAnya9/6wybBCahmFdd2uDe8w5?=
 =?us-ascii?Q?1tnax/jhoefjN1jN73fTmjqHwCPY06i3rF3lX/E6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 154f7f47-87bc-46ac-a8fe-08dc91c16d8e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 07:11:53.3862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUYT27epJ3fnXUOb3FLusXbUbdKY8QeJ10CUT2h3ymMx5j+opLIrKAukQGhnMZWpOcX/lQSLm232nG0GEX9Fvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7504
X-OriginatorOrg: intel.com

On Wed, Jun 19, 2024 at 03:36:14PM -0700, Rick Edgecombe wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 630e6b6d4bf2..a1ab67a4f41f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
>  	 * ultimately frees all roots.
>  	 */
> -	kvm_tdp_mmu_invalidate_all_roots(kvm);
> +	kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
all roots (mirror + direct) are invalidated here.

>  	kvm_tdp_mmu_zap_invalidated_roots(kvm);
kvm_tdp_mmu_zap_invalidated_roots() will zap invalidated mirror root with
mmu_lock held for read, which should trigger KVM_BUG_ON() in
__tdp_mmu_set_spte_atomic(), which assumes "atomic zapping don't operate on
mirror roots".

But up to now, the KVM_BUG_ON() is not triggered because
kvm_mmu_notifier_release() is called earlier than kvm_destroy_vm() (as in below
call trace), and kvm_arch_flush_shadow_all() in kvm_mmu_notifier_release() has
zapped all mirror SPTEs before kvm_mmu_uninit_vm() called in kvm_destroy_vm().


kvm_mmu_notifier_release
  kvm_flush_shadow_all
    kvm_arch_flush_shadow_all
      static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
      kvm_mmu_zap_all  ==>hold mmu_lock for write
        kvm_tdp_mmu_zap_all ==>zap KVM_ALL_ROOTS with mmu_lock held for write

kvm_destroy_vm
  kvm_arch_destroy_vm
    kvm_mmu_uninit_vm
      kvm_mmu_uninit_tdp_mmu
        kvm_tdp_mmu_invalidate_roots ==>invalid all KVM_VALID_ROOTS
        kvm_tdp_mmu_zap_invalidated_roots ==> zap all roots with mmu_lock held for read


A question is that kvm_mmu_notifier_release(), as a callback of primary MMU
notifier, why does it zap mirrored tdp when all other callbacks are with
KVM_FILTER_SHARED?

Could we just zap all KVM_DIRECT_ROOTS (valid | invalid) in
kvm_mmu_notifier_release() and move mirrord tdp related stuffs from 
kvm_arch_flush_shadow_all() to kvm_mmu_uninit_tdp_mmu(), ensuring mmu_lock is
held for write?

>  
>  	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 

