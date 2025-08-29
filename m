Return-Path: <kvm+bounces-56235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4991FB3B003
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F4907BD266
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6907F18BC3B;
	Fri, 29 Aug 2025 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpxgOiyd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7A61891A9;
	Fri, 29 Aug 2025 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756428261; cv=fail; b=BCzUtqTlsFHpp+1PbEDq7zVtP3JGO4ogDTsnKQof50+lh0mzPwAqx4r0nZ8vix/qHAT5o4kpzq0udywnk2g67bfJL1fUgGqUliem3JRgKtxjC6NS/C5TqnIFis06D5u0Pmx277A4SJu+TuBc5JM2FxSvfyXOrm7NrI8vW0hSmNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756428261; c=relaxed/simple;
	bh=9GOZQlsbGXkARVECj1SA3vlJHdKuHL6JyiVrLmGQVkI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o56Ze3Ge2p3w7NxHdMgVYO7MT4jQkkLPFCdk+JobUh/XvyeOgQW5IL6i/4GMdYAavgVUXBT8BxJI2Smv2fnyIB5X8pKhgsoarH2P5b/I0OyaqH8xcheFK4luUpNXcherHka+k0ZnYzfR7qhz506mSb9ZeNdlsHYT6EIzsOPd+aU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GpxgOiyd; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756428259; x=1787964259;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9GOZQlsbGXkARVECj1SA3vlJHdKuHL6JyiVrLmGQVkI=;
  b=GpxgOiydJ9yWykapwpjewubIG+oeHJQSoH2Zhi8VTcKZPL2x57G6XEjM
   d45YynWxT0j11zoxTPLORHpQ9dCBlUJfWyyLuAnfgaZ82VIxtutYMOXpE
   JUfl3D7fKHmBMoCLPI4a3XXFJ3utNB+JJ/5nHF0wyxswgzBhf34KsTYbj
   0elcIxMx5vH8wePIlg95O8wlmdlhDI6BaGNN/d9TOGjV7a2AzkcOl7X13
   qts8v/CWNBhYawwgXJLMnDW72d5Au6GyEZ5pLOjdozuxsuA9sKa4DGkJt
   xuM0s+iA3A55oHGslfFN8/r2LCdHl5iDC9mmM8XUT11x0eLdxCE7zkfq1
   w==;
X-CSE-ConnectionGUID: eUYecKUyTUSn2v86avVdVQ==
X-CSE-MsgGUID: WENxXUHzShizwWPT/TWImA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58859147"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58859147"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:44:18 -0700
X-CSE-ConnectionGUID: mHtmJ8WGSxer0W3jkBBqMQ==
X-CSE-MsgGUID: OSqHSRfgSdK6hihR9PXNSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169548543"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:44:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:44:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 17:44:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:44:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRJOND9zaFxW92RGk6XC8LtkEN0y0FSzi8VymoLXw8IJLbcv4CUjh6xQeun/XhSqgLFPpM0w4+uq7tj0ZFQouVSVuuR9LF0jcIz2q3cC4glR2T4+Y7d/r8g4lp09oNkvdKuwyfnYSE6rbozeX6gQSHbprJYMSzVQ1uzUAFDDwtPwNq3b0Ol7k4WkJ6FaZy3ZdRML/wSLn4jJHC7DyW5ajytEfgR4JZuBTjPVoGhx3Q5fIImHSUyD+IHtmGclh0CLA078TstLP81qg5l+oKmRygAXOvCL1VRse+Q2o5y0lNB3A9yck4VawgpYd4UFqlJ+xVNRBG7Xp8OryiwgmQ/Vmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdPvS4Cd1Jisbm/yL7wZzJd4tuAO6yx98t1GwrAcY+M=;
 b=UXSdg1xgy0QN1UgXF2qF0Nky7KUVTcAraoF5Y8hY945EIO7UVRtTQVyQ2XtTGP+VHmb2k/s1huX4OKuQPtUp5IojlIfAT5TIp9hHCx80xBM0L+YBmDhpfEOkNaR+HdLn+gn+aFtwdw/myGZP4MOf1F2Wdi6NF+1TPH60XI70lCF0os+ge6Uh2YVMUoQAc/EAlfu2n/S+6Bozf1gIdDOeaD8LYLiexdZve80ogbcX6C3AYVxlWFtze59ATFqSWlts4go0aSdI8R8t5B8ErL1kJdzkvduaCbvDyyhhEGXOUy38ZfWaQWAAwzuhBSa3+ZdvChFlx/wzIYJBaYwVd2Ia9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4832.namprd11.prod.outlook.com (2603:10b6:a03:2dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 00:44:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9073.016; Fri, 29 Aug 2025
 00:44:06 +0000
Date: Fri, 29 Aug 2025 08:43:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>,
	<xin@zytor.com>
Subject: Re: [PATCH v13 01/21] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
Message-ID: <aLD3yS6LQR7b55CR@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-2-chao.gao@intel.com>
 <402d79e7-f229-4caa-8150-6061e363da4f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <402d79e7-f229-4caa-8150-6061e363da4f@intel.com>
X-ClientProxiedBy: SI2P153CA0035.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: f810e272-e6be-4893-b1b1-08dde69528a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tpSvsFaBDLdM/CsGQqElHvHOHJl/xRHW1kFU7BSFfVB3CUFhPRiXrI+RWrY9?=
 =?us-ascii?Q?+SQwM1ohLYKeveqiNo8SjXz/8q5HI2NtNxBKQYVFC58dmCT5vO6avVKP2vjq?=
 =?us-ascii?Q?wkhcHFauM8ilZnoR8hN8coJaCo7YqKr81x/uCwTNTNy/s2Ge/hMpt6uE2Tvy?=
 =?us-ascii?Q?mhxlV4BYiiw4rkmN1N+jye1ZepyekYKfZQImha4F1HczQjg+6Jdobsfabz59?=
 =?us-ascii?Q?TmaPPnB4RtavLsJovBsPqJa+OqvRnDVYPg/yTb7iGJBym2/0uJOVnVyunyIo?=
 =?us-ascii?Q?VfU9Sw7xymKUNIwgoIWm8eRO9Nt1dh1FRd9yM0NC2RVkhtVI3BstSwuMOTKV?=
 =?us-ascii?Q?gCaboIuc232N6reVr992zMxqbW9FcMbuxYvE7f1T6SEKe8wdepSnkrxfKx24?=
 =?us-ascii?Q?nh8godzD2jIQevm5vTLnZrgGj70Odr8Vl4ZK1VG4yIFKgH0Qj+oDW4hEGyIJ?=
 =?us-ascii?Q?4HbBn0knCP0r3jNNTKKbWyF676Ac+nAHvojHZMafNNtcSvRi/W4aP1CVIe9p?=
 =?us-ascii?Q?zGVEAD5cPBzyjMlBuEzB82vK+FFyR+rvEMiK2r+n+tdbYkqRAaYCsyMYum9Z?=
 =?us-ascii?Q?Og6oLLUpVVqZ0X8/duYnVw3vY8eYkZqtZfmK+yQjY6MD02OI2u5UaDrqUGZU?=
 =?us-ascii?Q?YRoGBMt8FcGIoQeaVDnwcBLkJ5u5GSqe/Csd0ksiGGaXEc0hPX/cDpGi6NuX?=
 =?us-ascii?Q?rdoP8hA1r5Kx/89642DkuN8J/mDVM6koFvzkhu82aTTElQRvWeFpYaRZGzFF?=
 =?us-ascii?Q?qf8rVeADGzYn/Bw0FsX2AF4e93U9iKgIwWb35JOXBBxNi7WqB0Xqhk4J79G+?=
 =?us-ascii?Q?pDcmic6L9yCEMQJc9LMnrFEQxlDffzNB5yhhjV413yqheNfJccOyhGNFuS3X?=
 =?us-ascii?Q?QOWfn1Q/7adui9gQFgKNP1j6J9U5YCbkiYhVnLpM2QiD6MWFoxrIdg1a2UcS?=
 =?us-ascii?Q?Gf9oX6GWYaWT2ijKGydaoQPXShojG2jUxD7TqD1oBxnQpI0CWQfzQZqm3hkY?=
 =?us-ascii?Q?skG2KBgP+rzH2qLH4B6E8Cy16zNt71hYI15XAx2J8Pejtf2N1AYFUQ0XE8u6?=
 =?us-ascii?Q?tLf7CqN2oZoOdqB549yF/9Rtm8vjblsflEiUnSdh04ZIqP4sEW/2SFDM7TzP?=
 =?us-ascii?Q?/XuaZ5NN11izx+brD7Z5wiikNuXjQjcmEEQ8mEXTG0QXXh2z4N7T5ODR3gFY?=
 =?us-ascii?Q?w5SXwrYKTgqmN33FX6H6ns9mjIxm8OoVMcmjX9Y7FphofXzoGuVl/GVmr9XV?=
 =?us-ascii?Q?wQO+W6L4AMtY5mGydnuJkQ215CfK+ZNGhA1Cl6I+oI5tIKv5RA82bKOFG5WB?=
 =?us-ascii?Q?TYGH6npoLhl+lXwIk7itL/X769+B4At8w7AK+A9C2CMNTG2diiPkkjeOLc+5?=
 =?us-ascii?Q?vfONe1pw4IMxdLSUxhQBhN3Kbmrt2U/z10kAx5/ThShiChvKsyvKlN7ezExG?=
 =?us-ascii?Q?lliNYn/fVsY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F+IsizAzt/Tg2UG0R46dYHMosx1I/wY8hTKcUKQ9nBJZP3qPqecb5pi5Ufmr?=
 =?us-ascii?Q?gfE4D3Kta84BF/cHDGu3HD2z0Bh8qyl5SjAek5lRfT6c8SZ+O5IXr+mUfCgA?=
 =?us-ascii?Q?/51qrFPa2t2W3RwcnAzELxyFBzTEbuc+vhMvZgCtCHVtnO5UofFH8eb0qUv0?=
 =?us-ascii?Q?UViYCAekDM1dIxGCGjFhan8jiEzXThtaHDGUKjGG8DdKV7CYU8qt4ki31gpa?=
 =?us-ascii?Q?YSmBulQVAu2jIRdnNTLMcobVdvtk+swA0Pbh0MMkV0F8qMsppDsaXIQn/HJX?=
 =?us-ascii?Q?KYNJfzH0CYtEJXoZL3ZhQsecnnXFU65r8NFgCs8RNIklERL7hC6DklJajnFN?=
 =?us-ascii?Q?OJ4M47OelgG9qj66SSdFYmwZq9lAYMM/qeF5ybeNM8w0B70+x5NubKIpaVyF?=
 =?us-ascii?Q?jO/OdWRetokzLLfya+r71fw1/2tkeWHeLzcLnEAfh/y9FDLBA8bpUUZYCCDW?=
 =?us-ascii?Q?T6RFvIoll6ax3DxLdKJHv07CEB50RVZEMFPeJM9auPLJlYNekfTObAM8heBw?=
 =?us-ascii?Q?ME2rKRGP9gcDm/Pan6TEjlZpRd6m0MlE2W8pFCADESYlmhr8jEJnDIkuIilz?=
 =?us-ascii?Q?TiuiuI/fSYSaKr3T7yGCtk46g9uYAU/P5WSnVdH76PuGSBvhtLBdHWgMSRYo?=
 =?us-ascii?Q?COlyLbJRgrzxYbKEOTRk8eNWr+CjGx0NQkc98NbipTENuxNXPWkwXHZbStz8?=
 =?us-ascii?Q?eMMR8aTn4G8TmxqtLWVgSvjYLZAfyM0beqFRWU981k6wO8mbSzX00IKJabvC?=
 =?us-ascii?Q?NMJUt6LigCIANZHG961LZyTpzzxHJpYWeiMyhobAhTV33T5eVHgqazLAK8Tk?=
 =?us-ascii?Q?qFIBYzGlI3VA8RrAXsteVktJUvLhRFCBoqHpydKhklnL2l6KqQYvVSIjNnwo?=
 =?us-ascii?Q?W0HpFbylrrbPk8EmUT5dN5qOonhpCQMxc3WukLWMFGjSj6tmEiXvDtr5rVR9?=
 =?us-ascii?Q?4lFQ/GpmuclnJZf5VyjFjc42U/JZPNiASO66H0gLdTucnr4JriuLAWHG88ko?=
 =?us-ascii?Q?jTc2vv2xSryf7E7hhzjyKyHuK1h3IypPtCeSnCig59TIIoFKYyutEmAU2s9F?=
 =?us-ascii?Q?ZmRwlp36bDiw7NHf763ARdNvu63jJ6kPbxfhIcnbK3Mo3LAFipkSkudfmbFe?=
 =?us-ascii?Q?G/hhvANqEc5AkU4SOZc2OBxV7h9xmSWwSEZTe792gukpeXhE/tHdRjLdywNY?=
 =?us-ascii?Q?Hv3t/LCipcfDvV0vFHmbz9KmGTV1dz2k8MxkaSsxAhRGs0gTcd8JvV1OFAdO?=
 =?us-ascii?Q?j4MRb7x/o3ghM2cIe1d9VNTMmN/MKj0JQS4y7YCShhpKCSXxPChqKjVOtk4o?=
 =?us-ascii?Q?n5Y203adx1ZH7X8AWT8lVP4/ELGwytxh+g1KuRBKw1WKXZ9MgK8va7apgfDD?=
 =?us-ascii?Q?/GaL8RXHkf0oWBfgFTTHkteE3dYY4qSnh5YMPvCmacOVPVfBHID5QpeXz+pe?=
 =?us-ascii?Q?Bhs+Xe7u4rrl0iKhrzpSymyTzvtvwOpV89IrKcEIRbKbSmhowztqKQagGNIW?=
 =?us-ascii?Q?Y9RGUJ6LBNcQ+8b0r4Yb/pJ3jlHhFSfgNW+ZnT+Sg/TByzNbqsCh+ePMhrPJ?=
 =?us-ascii?Q?xfxHbZIeUuFLQk4keRw/M4dQybjA1BcgCGTS4G0k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f810e272-e6be-4893-b1b1-08dde69528a4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:44:06.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AmCqwqZoVhgKC3k0TZ3SPGGHpchWV/Ay0dhda7dsmpeDt5vfpfeMtxM6yhvq6DtwmoxdtYng2sRhd/RxLUYgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4832
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 08:58:07PM +0800, Xiaoyao Li wrote:
>On 8/21/2025 9:30 PM, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
>> KVM synthetic MSR through it.
>> 
>> In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
>> it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
>> and hides the difference of synthetic MSRs and normal HW defined MSRs.
>> 
>> Now carve out a separate room in KVM-customized MSR address space for
>> synthetic MSRs. The synthetic MSRs are not exposed to userspace via
>> KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
>> composes the uAPI params. KVM synthetic MSR indices start from 0 and
>> increase linearly. Userspace caller should tag MSR type correctly in
>> order to access intended HW or synthetic MSR.
>
>The old feedback[*] was to introduce support for SYNTHETIC registers instead
>of limiting it to MSR.

GUEST_SSP is a real register but not an MSR, so it's ok to treat it as a
synthetic MSR. But, it's probably inappropriate/inaccurate to call it a
synthetic register.

I think we need a clear definition for "synthetic register" to determine what
should be included in this category. "synthetic MSR" is clear - it refers to
something that isn't an MSR in hardware but is handled by KVM as an MSR.

That said, I'm still fine with renaming all "synthetic MSR" to "synthetic
register" in this series. :)

Sean, which do you prefer with fresh eyes?

If we make this change, I suppose KVM_x86_REG_TYPE_SIZE() should be dropped, as
we can't guarantee that the size will remain constant for the "synthetic
register" type, since it could be extended to include registers with different
sizes in the future.

>
>As in patch 09, it changes to name guest SSP as
>
>  #define KVM_SYNTHETIC_GUEST_SSP 0
>
>Nothing about MSR.
>
>[*] https://lore.kernel.org/all/ZmelpPm5YfGifhIj@google.com/
>

<snip>

>> +
>> +#define KVM_X86_REG_MSR(index)					\
>> +	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
>> +#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
>> +	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
>
>BTW, do we need to add some doc of the IDs, e.g., to
>
>4.68 KVM_SET_ONE_REG in Documentation/virt/kvm/api.rst ?

Yes. Will do.

<snip>
>> +struct kvm_x86_reg_id {
>> +	__u32 index;
>> +	__u8  type;
>> +	__u8  rsvd;
>> +	__u8  rsvd4:4;
>
>why naming it rsvd4? because it's 4-bit bit-field ?

I believe so. I copied this from here:

https://lore.kernel.org/kvm/aKS2WKBbZn6U1uqx@google.com/

I can rename rsvd and rsvd4 to rsvd1 and rsvd2 if that would be clearer.

>
>> +	__u8  size:4;
>> +	__u8  x86;
>> +};

