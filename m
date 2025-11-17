Return-Path: <kvm+bounces-63338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE98C631E1
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 41AAC35CD92
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5976328631;
	Mon, 17 Nov 2025 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W09uBouR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB42232860C;
	Mon, 17 Nov 2025 09:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370675; cv=fail; b=uBoDj2nGZj1pVw2xSkzibmk0BAi6ZLckPm9fc+FsxI2DRO3TYxDJ67mOnGolumPvPgX4wHL4CnTkzXsGPnKnpEPqjEfFo4XEzTq+cld5IbIe0B10WlOaSfnvPpx2MtaaeufP6FJ8k1dyiKd4X4rXwENGR0x93QLEIzCumpDv0Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370675; c=relaxed/simple;
	bh=Nxq7J9hey0CyKndQ/tq4q2CwPkfXaOaOYli6TpyQNDE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NxxxMSHFfR79n2GFhPDqYzVyHdxoTjMNwBScQwafDDIyJ1kE2Lb0j3zySaM4JnAO2ss0/5hzWh2vjMJGnQIGtUsas0v6Is1Lt+ZJjAZ3vH/p6MfJAWOZomjBtKsTO0jGavFtKN/qdFgpRtPbCEy97Oc5YwLz2/1ApoDo93n4EIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W09uBouR; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763370672; x=1794906672;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Nxq7J9hey0CyKndQ/tq4q2CwPkfXaOaOYli6TpyQNDE=;
  b=W09uBouRYqf27LeO0vbTqypkVb7BfhiulbpUK/zxUy79O9lMQ+RGkaTM
   1+e7JUayK3hmGjgj++SABhaBJ9iWeBD9+qqHN9md3MwQUT7NXIhs3SA0L
   3gFUFrndSYbBShriYNogfrxBx6KgoF9orDCIv004ueoE4THhdqo1MDnlh
   a+L8Dq41MifwvDX8I/iX7iHoVpLHtAhIDkU3n0admTo6Bi9Mwyzen1PYn
   sj11uwyxZbNmuEvAAgw8y7SlLcMaPZcWGxlrv0CuzpuUVC1sklJQwotNY
   yucLs7iO18O+qe/Cdh4bxJtQ8bKlKsLv45Np3s01aAYipTVOgeasRxGPi
   g==;
X-CSE-ConnectionGUID: uPihX2aTT06/ZVJbfZnouA==
X-CSE-MsgGUID: R7ftBSpNSdi7S6XIl61Vhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="64366944"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="64366944"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:11:10 -0800
X-CSE-ConnectionGUID: EVY1g4MhTpCBabRWykH+Rg==
X-CSE-MsgGUID: LoNojqVvQTCojOrYKlMnpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="191186216"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:11:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 01:11:09 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 01:11:09 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.38) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 01:11:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TK5ZNBXK+3o6B+YGhaAk2fRaRd/XENmWbz6nqRtG/aJ+v5v2bT+kf4zybXVWuEnu3tv7u9/+MZ5UGrdpXmrlBbORSscDrGADC5XVq02oXLhZkzjfJkzU2319WR5dglQrTbqIAW3KfbhxgKVpvQw9qChl/U/BRlI8Ef3HdgIQOKo0bm5lxK2iLm5/TibsmUkMBw4qEzuLVEsvriDVA+p5YvycEq9LQ6KDr4UtOdVwTZGx6VOgUUpr8KIVFg2FHHtjjdikJSp++27pKqi97c3VJbz7mhE8Gg4nHfxJhVcVoenajYBLKbfp0aaaZJUzBnec8+12x6DlRw9QDT8S7UP0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oW60b9LWBLGCNvfc6yrJu+tVCuY3NiKKH3qPl++8jk=;
 b=uZmjJwlkGLk0vqBmmQO6W0AcVXMC0paM8iLztP/Chj4Of6DMM3vjhMTJADjEDsuPIAIsJUjMLCt2NH08YP+jTahBOc0Rm7fJkQkJ2G07eBYD03SSquHr5R2NHlMAjh5kPtu6b31tMI7+LqP1kJIPVA/l0hKr6/TntM7KNq7bsuvSVoWCgt4unQoez7b+Mj6EOUJm3xKB8oC8/FCVeGGgCiTK4BU+Pf19ZJflO+Z9y/JUBKV1jy3J55rEp0e+WcnN2Ib61ruO0oVEaNA7A9aDopcF04MCpC+jRoffxO48YHrX49ZphtyM3Q0Li++Mxnfh3zNhMMKXMDWNOb4RuTSZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFC852EF225.namprd11.prod.outlook.com (2603:10b6:518:1::d4c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 09:11:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 09:11:06 +0000
Date: Mon, 17 Nov 2025 17:09:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <michael.roth@amd.com>,
	<david@redhat.com>, <vannapurve@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt
 hook called during write mmu_lock
Message-ID: <aRrmRx5lmaUX+h6y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094320.4565-1-yan.y.zhao@intel.com>
 <60da8b1c-07ea-47fe-9bfd-d87bde294e3e@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <60da8b1c-07ea-47fe-9bfd-d87bde294e3e@linux.intel.com>
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFC852EF225:EE_
X-MS-Office365-Filtering-Correlation-Id: c6fd60aa-433c-4ac9-8408-08de25b93d24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2jxa/LHLKd2E2F2XxVgMSPxMf/NtLYYo/p25/+HexVpp7XcoBTA30Zv3Auge?=
 =?us-ascii?Q?BoJ3p8hDwovUimVw9Eqz9O+5bHYx+IwWhfFmz7LQC/rFoeUL/yywEKhUh/YS?=
 =?us-ascii?Q?9diouu70VREgiLy3kHvqpcJK09YTd9pw1BCrDdnYXugkb+GrkkMv1i6FfuJv?=
 =?us-ascii?Q?BmzQL1nt4kXvVaJrJo8DXNo9xZyyj80ov9q080mkoI905rU1v3PsiL8th2Zu?=
 =?us-ascii?Q?UArUZ0EHYj75tY7Qqip/IyHL85ekjQG/tIxsds77bjmhNd5vB77KDWSXMIhf?=
 =?us-ascii?Q?fH12N+dY28WetE6SdRz6Rnz1e75LI6NHOOpxbgGlrfxLIAiyFLdLPixIvhFu?=
 =?us-ascii?Q?Q+xkWkKOuwz/ggbbyK5UbzLEbkqwd6RecKJStsp1hMDussMmjBW+KA44UzuU?=
 =?us-ascii?Q?POVEKiWoY9zNYv9VE31dvkJLRLhGfe066Pk07DAOZXE1gDb1j2lOJNwlR1Y2?=
 =?us-ascii?Q?Duu2iYYUElmjX5eNsg5VjkF4LzVINUU9ginHwYgbZY/aNcq8kLRSM7SmR/xv?=
 =?us-ascii?Q?papaEMpr6gZ1gn+Gy2Ufk6GlrhdOKn7CHqpF9mvFJbB5ng/kUjaRhw2KD7yK?=
 =?us-ascii?Q?wQxczoWOy4T1NSQePi7USkqhTe7rYt0CUrrpOMcs29fWD1/JQi2a2C/hAHYW?=
 =?us-ascii?Q?xbNsvXWTT5ozCQetnUAVoIUrauyAHFEYTwBCcD9MGUP1HVftlFF3k6/AIXUh?=
 =?us-ascii?Q?SuNv41pHdTuqFO7bkINJjXoH3MCb3iMZLujz4WnDCBN6pWDpTm6kl+B7BAQR?=
 =?us-ascii?Q?dAP8JVLePmc6WhslqBEYxWhhqzmYW3BuybD4BKwN5RJ52SjdFsrxneXVbng3?=
 =?us-ascii?Q?WdzkmvwkLS/Aw8UdKEO40sAa+Gg09pAJzzNdLkqhYUMqqgcbvvRddSaOOW1K?=
 =?us-ascii?Q?NhRsbCLxqJol5/V24FwG66ETjCAPx0IqNvtjhbF6YhTwWmhP2AuXjbjsafzn?=
 =?us-ascii?Q?DNOgzcFXtNbv1cfdTmmyLdsfJVQgvyRT+OceB+sX6rQWElZOIBS2s5qVmFpS?=
 =?us-ascii?Q?h9BH/wuO2gNulDlj1jvOoZvIM+zmj19l0nyvg7k54zvgVvuIJT390b3ij/rV?=
 =?us-ascii?Q?FY2fRQfKyKs/CCnlNnIPTPR1U5SDtk3xWROzoKk3JFVBGIS9iZuChCqXl6Oi?=
 =?us-ascii?Q?N6e4FPgEm3fz3SbDFN48BYZXRlMo+7s/NxStQY/YrqYcaU/7DlVLlYjhyLTZ?=
 =?us-ascii?Q?vXPuyvDy59OgwfMbggfTy1IF9jPWRNJpFv1PATHaXlE4RXafzFQkUxlroEPf?=
 =?us-ascii?Q?npV5y5r+luQlXlMshSIhxez3QhD3MCivANPh7Jlmn6V+RJRBYPhsj4Wa7/x2?=
 =?us-ascii?Q?NrJ/c/bD+k3nnFhE1VRfK57D2JzRs8zRIgsrcIbfmrl5Wh/iUnVmF+nj734v?=
 =?us-ascii?Q?iaxyT+pzaWCfEQYcx7Z0Jk/DVbb/fcuBW48zFCtLyKXlaZ/FGsd27ni6O2HG?=
 =?us-ascii?Q?YgwtBL7h74rjTSZUsT1pXlHpZTczEW0B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G+/IVVXkifUaUn2BtVz1TywbGQPH7dljx8MGrg2EZOOjSSBPO30dQOMbjf4n?=
 =?us-ascii?Q?JdwRnCReeHYjFp6cgV2E5CnwL1fCToq1aoiOAPE599Kdza45R3hPwwxZokoj?=
 =?us-ascii?Q?JVEbXhER1Ycp5KrsqL1KO4ADddJAGvCGj/7RorqxF79y+1JxwUXZWH4QlqEn?=
 =?us-ascii?Q?mBnP7ZWz5iRry81WxaNWgaZBKmAtyqmuPhWUMxo45yE/BjGEdhVUu2NMi1VB?=
 =?us-ascii?Q?bYFiowHIX4O+dVgbCoOGRlx4K/CEFO9ym9j0vmMRcY3jVMa794lD7NhqH9sQ?=
 =?us-ascii?Q?unzk3tq5tUa9mdUYR9yYTqjuUo6UdXXvFvMYeOWHlABG0QvdAviZuPeY/VC4?=
 =?us-ascii?Q?GtrotFauh0qxvLEU9C97b0LGQi5GjQasz4NPewiJu6/QqRrxTBmPTUkRynB4?=
 =?us-ascii?Q?HGqHAXlFzdvKV5kylEY/9DGEO4STwncWMTXQs9XpEBFQELsMtDVMReLIA9Uq?=
 =?us-ascii?Q?6AHU68BGl7C5BmCl6GKFe2V3Ebg3CEK/wsfSZV/Coh4JuLPCWAduIoRjG26b?=
 =?us-ascii?Q?JxX5CtIqs16eK3C0TANRHnvolEEIELOvvRfyRDNFMSFZh5YDw8gOECc5ppjx?=
 =?us-ascii?Q?wxCYbo/9EOHNSIXwH/ym2DsaHIRvxyKqo52OjqVcyIyuNf076BxJGVK5msDF?=
 =?us-ascii?Q?9HRC0NPZ+zhQOBnHCKL5GG0u1hfAI8+MeB5/hkT23tQgrLjhdt3ZA9r+6VkR?=
 =?us-ascii?Q?cNqugwg5HrGvy2Ry11F9PduQ7Wr7SRGXeBOtz56uGaRuyegRXpaqdA7T0MG1?=
 =?us-ascii?Q?9Ei887Kh3oEcGOsmEzLcwJxLm5llVU73PtF3l96xlQyCny2ru0z9lWa3TQos?=
 =?us-ascii?Q?oJZq/L8kJjkvOTERE9tLX4bAnu6amax+Tla8Jy3VuEhqVZcPAT1yqdThfBtk?=
 =?us-ascii?Q?/1Myj8Ln5ZkDNXDAIE4Uh18kD9nE4M0W+e3t3IDfY1Jkuxs7yTLTcPMngpY1?=
 =?us-ascii?Q?fA8GAX2idi/kGcw5vFLaAOw2XPCOPUT43/Zh+gB4KC0sVZjq4/mDGMgQ8sXu?=
 =?us-ascii?Q?/IiaRRXKMCn9T76MQthTqVakIg1UOmX7Pjwhe9NRzjZTDLm2HxkhDBanQrC3?=
 =?us-ascii?Q?+GSORWypcbsUccP9Nwravz6jHHgS2NtfiWIIxLbZIQz6LdMAWO8X8pbF5qwb?=
 =?us-ascii?Q?u3h//6+BZfGqMTxTXq6sydRQ/cnz2OkXnfmHeLoeHLkyiqtojdFFnNV3YeQt?=
 =?us-ascii?Q?qCXGp0GbgHaRt+vzeIPNQ4lgyy61oG6vQBKdCixgizqMj17s0L8wYB9CSPLz?=
 =?us-ascii?Q?JbrAsOE2iHUeEAEJWYdZsvlWDILZdKdudFEJxrTUk7jeImPI9FEYEYzyq9kR?=
 =?us-ascii?Q?H+y+rza3skHsYIw5C9n/EKwdwEbPCXN549GQawWCM3mrKuykS/DenriU30Ta?=
 =?us-ascii?Q?TOHYnznS5TCpR3M2DC+/o4r2yby9gNI8aebxWeLSlztxO/eqzqyzZSEXOaUK?=
 =?us-ascii?Q?rp+Wz2cvKqyCE2YTCQoW3swg4+lGJ8Yr2ZuBx45tQiDrOaGY4qxJ8r5GDcD6?=
 =?us-ascii?Q?f9CdA9xBcWQGxI/+S+gMMlNVBMofcWpUoYjzjX/cGhDpkJAvbhUuae3PXjX2?=
 =?us-ascii?Q?94t0dIRlcJMEajY4p06jACj5IF5RHqZ9cnHChi4f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fd60aa-433c-4ac9-8408-08de25b93d24
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 09:11:05.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vH1ZnDJMA8OKbuFirdIltWxqNoVgDdaSjFJipl2JvQUDKO7smPYrIzNkEKlviwmMgxspCPRKKWWur43UqAC1/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFC852EF225
X-OriginatorOrg: intel.com

On Mon, Nov 17, 2025 at 04:53:17PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:43 PM, Yan Zhao wrote:
> [...]
> >   /**
> >    * handle_removed_pt() - handle a page table removed from the TDP structure
> >    *
> > @@ -765,12 +778,20 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >   	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> >   	/*
> > -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> > -	 * roots, so don't handle it and bug the VM if it's seen.
> > +	 * Propagate changes of SPTE to the external page table under write
> > +	 * mmu_lock.
> > +	 * Current valid transitions:
> > +	 * - present leaf to !present.
> > +	 * - present non-leaf to !present.
> 
> Nit:
> Maybe add a small note to limit the scenario, such as "after releasing the HKID"
> or "during the TD teardown"?
I'm not sure if we need that level of detail.
e.g., for case "present leaf to !present", it's before releasing the HKID w/o
patch [1], but can be after the HKID w/ patch [1].


[1] https://lore.kernel.org/all/20250729193341.621487-6-seanjc@google.com/


> > +	 * - present leaf to present non-leaf (splitting)
> >   	 */
> >   	if (is_mirror_sptep(sptep)) {
> > -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> > -		remove_external_spte(kvm, gfn, old_spte, level);
> > +		if (!is_shadow_present_pte(new_spte))
> > +			remove_external_spte(kvm, gfn, old_spte, level);
> > +		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
> > +			split_external_spt(kvm, gfn, old_spte, new_spte, level);
> > +		else
> > +			KVM_BUG_ON(1, kvm);
> >   	}
> >   	return old_spte;
> 

