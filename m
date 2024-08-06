Return-Path: <kvm+bounces-23301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 374309486F3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 570DE1C221CC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDAFA947;
	Tue,  6 Aug 2024 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8xBPOmK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409AE64A;
	Tue,  6 Aug 2024 01:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722907127; cv=fail; b=jrMaORAMBRK25rnB1qmAZi9crKegHh0Ny4gqCVOrISE5f74flx0USyzLUCGDZimS+MEniCI8zz6qRDh3r80AzQPXIS1UObxgz4G71NF8XfqVh6ZeQLyVV1TYWx3JpxcrX7JDApuE0HBOw62pw8nH/Wp6/6k5RaZUTyIpaxD8mwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722907127; c=relaxed/simple;
	bh=/gWestSb2RGqWRMntNsal321sUP696tpI9DlZcMV9QY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J8bwQEhybl28mzGtbTI4wt3stXoAGSDEo5gE5WYi03p0Yd8MtocRixitRCoWGdTX8mfKksiZeYOL6qNdIQuOYNj40gvyFQpLSKMwq8YdCp15DPC36JJI+t+74nz11M+9niyAW1XOrrI47pmtJCMbmqFtrxHRU+dt8y2FnX6qcsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8xBPOmK; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722907125; x=1754443125;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/gWestSb2RGqWRMntNsal321sUP696tpI9DlZcMV9QY=;
  b=h8xBPOmK/iRChCmioxCRuKoDQRSvkBQH0+pff8C2/XHhghH2WH5xu+eN
   CJ23jeikuN0HpMgvHSWFqStVGVn/DhMJI9h4PA0G6nXjA1PThUpHsZkAF
   ewokqSG8+37yj21bW5McSRWhFeFGw/4/ieOlDiUECRLXwoK/NDXpxf7/Z
   srSjzlrRx0fD3oA1DU4RrYSAYCYzRQivbcQ9yZzlhvCNjVlRXMuSSYzrM
   XKE8RB+MZOH8hbWr+E6Xm4phJf/faZ3qUr8rPnpSEoLFZi5zSS0kecQrp
   sH6psIP2N3w2GJIWeQIAwmMLrYbwk+p4G9CLM4wYuQSyu+OKq+L49oPNY
   Q==;
X-CSE-ConnectionGUID: 8D4T/4BTRV2wnfnxVcRnVg==
X-CSE-MsgGUID: 6b7olBmlQI2XbznAa59Usw==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="24765461"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="24765461"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 18:18:44 -0700
X-CSE-ConnectionGUID: eDF0/1GUSje+49qkXcelQw==
X-CSE-MsgGUID: eygc4IO1RbaRvUnJY0fnRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="56435883"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 18:18:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 18:18:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 18:18:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 18:18:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 18:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPbIoHCzFs9ad6nUt1zvBbQ54gxF17fFnQLXZxIkDwGPTdznJUwdEXKr858omalNWZhPSSy+3VwO7rYXm9xDa0+LjyFYaXRYUga7CJHMq1z8MySGA9RMDrK+Lc9QlZglD5HggYpTSY6ke/fLQQ8yOAAS6OjPtWgtgtTGi1C01daakyp+bWZU5imhODW9IxlV8YTvR5v6+ZEsjsAsoiYvzzDeU0/8lpo6K6ELGFS84utnODVl1jg3knbtkqVd5bb902tktH5b4tMfksNKhev9RJ5g8sd+GV4ixea6Xs32Ztg5pvzaIqV6QdsF68SiPM2RHYouZleYpEfxuEb86j2Kvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2YXjuMRV8R29Lhto0+Tka8xxkzz/Xk/y1SRXdb2bFI=;
 b=DzlkwXIDKOFRH0+97PULxrwvGcVQuhy4PDTA6MxXeHhaDsWSmnYbk4mHYiIUe4ZgJ8006xCmDb9OzpwsQ9a91PwscEt6potqs9qPrXKF0hMXRtwgbkBSLzaaG81eLS8KFPCo4igILsI1VxEwvrBvqRYNJwsAAubQlUTJn9sIesbIysfYvFCWV+oD4Dso0Nd8xIGWNDurJrK09E6pjqGAVDWENZjHcEM33XdjQYiEx5SL/weTIYDD6t65wJcZdUKXsjJqpL53Lc7clTAImipDtBbmHhPQCuW1V2Iw2Dgxzcs8yxA814hk1W7Iz6ZhUtfxSwJMzGvYz/U+1Bf0yrbCsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 01:18:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 01:18:41 +0000
Date: Tue, 6 Aug 2024 09:18:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <x86@kernel.org>
Subject: Re: [PATCH v3 2/2] VMX: reset the segment cache after segment
 initialization in vmx_vcpu_reset
Message-ID: <ZrF55uIvX2rcHtSW@chao-email>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
 <20240725175232.337266-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240725175232.337266-3-mlevitsk@redhat.com>
X-ClientProxiedBy: SG2PR04CA0185.apcprd04.prod.outlook.com
 (2603:1096:4:14::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c27e6d-b2b0-4b7a-0be6-08dcb5b5b523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6jPEvnsfbxkEo5d9K4YNiTlTImRt1CBCMBrZyZghgcVVt+YHe8nBQa9i4baE?=
 =?us-ascii?Q?4jVwQc8dnBnjLB8P9Yoj0nXSUfwlLIm6F0OGU5pKC31oEejpej3QzCWqm1Wk?=
 =?us-ascii?Q?lFwcR+6zaYeZxmS1jPRdCOEVEb31OWSptmJTth/7qQWt2xdZpmG4DjPN+oo8?=
 =?us-ascii?Q?q99YWskRMOgo9rDyGnhs3pQh8+68pXXlGHAhUp1BOreMeGlMR+7l+mkheCNM?=
 =?us-ascii?Q?xRkX4ZgavjcHppVmdQLbqqKIog94ZLchTCHiCJef1PtmvHAea7085mfkpTv0?=
 =?us-ascii?Q?y98Fn0bnFwchbY2HtwlD/34+vpk2yGEiuCvB1hsambrmNhZ5JRwGT93KK5X3?=
 =?us-ascii?Q?LnzXUnKx/CT3XGpn6AQZtYMGR+SmSX5JdHvul++yfgUtHYeg20p7u4K8ay0F?=
 =?us-ascii?Q?JhWj1PECzKsAl3XBoqPiuzVkuiEFRjOZQG4RjeWNrxV6vqfF/6c0lE+GV19z?=
 =?us-ascii?Q?bHwoiHypm7jLQ0Eh2cTvYNNXI43IN3eckHD+Z+Gf9vpF+pMvVxHxGF9dLbdo?=
 =?us-ascii?Q?bhcp44RW1XZHQITV60m78Kk5EvW2sW/arpgaxQ2CUT5wFsONCO3SVWN3w2j9?=
 =?us-ascii?Q?hpKRxSD1JvrzQDV0FhMsztV4FzjVQ8l4GK+2uvWCytKl72e50BpcGk5lMaez?=
 =?us-ascii?Q?1FPR2Q1tiVhqvegxFhUb4scStzVfEH90wvU5fA/yeMVvgnvLQ0RTFsBnDAyn?=
 =?us-ascii?Q?8CLZMXabT2G00qdteK/EfCGZIkZXIclyCduoHoPdnn4Grm1E3T7woxqK4vE+?=
 =?us-ascii?Q?zhIfmkwB/gv874AAn1zD4SF6J1rbk//wyisZoTEomf/NnTZWWPy3iApLTSsk?=
 =?us-ascii?Q?de1HB3lJXtQyfNWHg+fy8iT1vy5M0RegxPAk42uGfz/0uIxTIjDQ9IythNO/?=
 =?us-ascii?Q?WIhlB6oYq87RQb94dhncK9sBADWuP+9ah0Kn4eJjnMcK4ljf1nyQzJNwQoNC?=
 =?us-ascii?Q?LOVx1KK+mDasJgyRUVsCAkRV4nWOmD7LIccwkFipxe81w6wjdlGFNDRXiyzf?=
 =?us-ascii?Q?9wq6GE3RdPjLL5dGyTut41b4QdiIwN+tONqrODDChNTf0TvXTFoKQYA+n1Eh?=
 =?us-ascii?Q?TarZQeEYBdQtC3MTAARwU95xz9rgcSerOb50VnaABD3BjUe0/E3ioGcKB7ei?=
 =?us-ascii?Q?MvuAhk7ZZVfa32WVAAy5E918DF348iitfODLZReHpKNjUPs5SORHkLzm/hIq?=
 =?us-ascii?Q?HxbdctemkD1L2XSTKtzhIXPwgI6IGtQuvYhcYON8utoXIm+NsRDLKuyROjXo?=
 =?us-ascii?Q?5mCQRtcN7CNI1M17xj9V6sITgIs4eoXneUS3YfdEBXjFPaudG+JAs+XNdNTp?=
 =?us-ascii?Q?nqWcyIImDntRVx6Zzin1MkymlT0vK8hpMrvtLn5dwFBYPw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iLcloc/XJLdN16Y3aMhqe68mVZpy5OnkKJ9AisdVuQ2OLIesyZVDgkU5iaz8?=
 =?us-ascii?Q?8zGZzm8k4FCmC9/45xdHXEPTPaYEYmukhrRjmM8JD6VTO6i1gW7tgqzyjNot?=
 =?us-ascii?Q?8+9NUKayrofn0I6FGlw0vuh0YhSMVpD6BL1AQ/eIY4k/qD1xaNf1F8m/hJ1G?=
 =?us-ascii?Q?HM3PSbJAnpa7pnbbse6gXFz2QDrIflTbfgyfgw0loJs8Eo3/cnC3mbNA0zLc?=
 =?us-ascii?Q?CTS3qjfADFLvptFI9+MDk02MxW0TxEwh13PCj9aJx1NGNV0hilBaMIh5uh+A?=
 =?us-ascii?Q?IPQ0KinW6BO4Py8D/1kx7WHwxd+dcYnkoZbR4hjPSmDe3+22KMXzc9FnvmNH?=
 =?us-ascii?Q?IUvI4NTL0piscqC2FhkpCevOXNCOQ0tNVp55ucc6147jx36MWXYzO7Z1Zd8q?=
 =?us-ascii?Q?vTS1Bcr3AJ9hevvuau/6qG+cUt7H9q1m/a8haPgwZ9vOm1/WFhzttRNlPdVq?=
 =?us-ascii?Q?BPvf+6v/TTigvPmVMnl7el9FYBjt1fzC9rrm5CZL6wv3Uzcs4jlt5BncSwW8?=
 =?us-ascii?Q?hSEdsa6Y7YraJbQ4l/AzHeHHbdymKEM+Le8cE03yiPOMv9KjXhyuZZiNvDae?=
 =?us-ascii?Q?Q8bsAIhwsHdANgDL47fYEg1dci9Hgz9K4FqKBx/VNom1MMLnbfXd2ksoyevL?=
 =?us-ascii?Q?UEcKeLXcmfJLpmWyl01B9WuJvK1Mk1kI+PDRmDNC67Mxs1jkmKgk+6n3KIg+?=
 =?us-ascii?Q?NGlgQ1JDbzS7/g2QSOZ6vtcEoL7YA6XoH9naPWN467qdArrAeI3X033shBta?=
 =?us-ascii?Q?cklo/FqsQV6TugqMp7BCrsQvBt5e1b3bybGWl/IbL7b6NHbKi59WAQwHK42/?=
 =?us-ascii?Q?YvoVrCWAjIbtPyho9JXqTXCf2663EPXiwye0gbgTkZnT+WcItD1ZiZ9PtQhn?=
 =?us-ascii?Q?kLlQS78gimjMSQf6bGTdW3qVj7XmHoLRKybmjUen7uBmZJwQkiM/aDOTVQlw?=
 =?us-ascii?Q?0oD0EhVH1By3YfwG7SHwc9WmVPoly2BNxRfDv0L6hPO/p7l76j15VfDzt8pe?=
 =?us-ascii?Q?NsmWlPMKHScII6h9Sb9xQGzDaT22Hi3l3aZm42+t6tWWJlO+eTfcRixj2Ydx?=
 =?us-ascii?Q?i4ztSvJZS4l1D2b5mjIzPO9hNkwYPaX0yArADVflRmPzh48yW9DtKcqjlaOm?=
 =?us-ascii?Q?ueL4hhHz6gmJsuYL2mdg53FhrUn4bMjQW7XD3laV1UN+R40EvkwBF6OleMiQ?=
 =?us-ascii?Q?u+nWeiSg1Ktui1UEbaA9jCYqp6EpU5DI2XaeQ6Fz84o7FIdqwGbP1PBRO9Pl?=
 =?us-ascii?Q?ETd9vL7VJ0jPHWC6v4urFDxAt9dNvNzDHJGxa0i08CAUyVN6zPjSQ7EyOQOW?=
 =?us-ascii?Q?6Y9CuU46pbVvswPAAKI42TyujgWHR8smmwKJN9dSxHfSvvzBuHvDbunDhI1w?=
 =?us-ascii?Q?yrgBSZNvmPZweQiTAO2oQl5n1CcbcKZCzyRgVHfkYH7sNcp2z/+gtVjycebw?=
 =?us-ascii?Q?6qmlYf8+n7wthEks+WuYXKjTpaUQPRccMasiWsssr84xS3J71fzM7rqIDxzT?=
 =?us-ascii?Q?aNEg9cGn7LzO8ED2dfmde3g+rg1Uyl1S+UZocA9CRmSshUKrYp50JkMiAS/I?=
 =?us-ascii?Q?TxJrsxTLlxjUFOrcyWtb6xsKc64WF4Xes5QA5E1G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c27e6d-b2b0-4b7a-0be6-08dcb5b5b523
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 01:18:41.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GbZUZ9DRYvi/rw6Zs208biwUqqceJ7P6DOdRksolBev0qXAV0TlLoNq/tWffjdojSwbAphmhEIenqGl7GsOS4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

On Thu, Jul 25, 2024 at 01:52:32PM -0400, Maxim Levitsky wrote:

KVM: VMX:

>reset the segment cache after segment initialization in vmx_vcpu_reset
>to avoid stale uninitialized data being cached in the segment cache.
>
>In particular the following scenario is possible when full preemption
>is enabled:
>
>- vCPU is just created, and the vCPU thread is preempted before SS.AR_BYTES
>is written in vmx_vcpu_reset.
>
>- During preemption, the kvm_arch_vcpu_in_kernel is called which
>reads SS's segment AR byte to determine if the CPU was in the kernel.
>
>That caches 0 value of SS.AR_BYTES, then eventually the vCPU thread will be
>preempted back, then set the correct SS.AR_BYTES value in the vmcs
>and the cached value will remain stale, and could be read e.g via
>KVM_GET_SREGS.
>
>Usually this is not a problem because VMX segment cache is reset on each
>vCPU run, but if the userspace (e.g KVM selftests do) reads the segment
>registers just after the vCPU was created, and modifies some of them
>but passes through other registers and in this case SS.AR_BYTES,
>the stale value of it will make it into the vmcs,
>and later lead to a VM entry failure due to incorrect SS segment type.

I looked into the same issue last week, which was reported by someone
internally.

>
>Fix this by moving the vmx_segment_cache_clear() call to be after the
>segments are initialized.
>
>Note that this still doesn't fix the issue of kvm_arch_vcpu_in_kernel
>getting stale data during the segment setup, and that issue will
>be addressed later.
>
>Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Do you need a Fixes tag and/or Cc: stable?

>---
> arch/x86/kvm/vmx/vmx.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index fa9f307d9b18..d43bb755e15c 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -4870,9 +4870,6 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	vmx->hv_deadline_tsc = -1;
> 	kvm_set_cr8(vcpu, 0);
> 
>-	vmx_segment_cache_clear(vmx);
>-	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
>-
> 	seg_setup(VCPU_SREG_CS);
> 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
> 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
>@@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	vmcs_writel(GUEST_IDTR_BASE, 0);
> 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
> 
>+	vmx_segment_cache_clear(vmx);
>+	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);

vmx_segment_cache_clear() is called in a few other sites. I think at least the
call in __vmx_set_segment() should be fixed, because QEMU may read SS.AR right
after a write to it. if the write was preempted after the cache was cleared but
before the new value being written into VMCS, QEMU would find that SS.AR held a
stale value.

>+
> 	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
> 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
> 	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
>-- 
>2.26.3
>
>

