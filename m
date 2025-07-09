Return-Path: <kvm+bounces-51896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D513AFE2BB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CD185675AC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D77A27A919;
	Wed,  9 Jul 2025 08:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2u6wk5U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2427A131;
	Wed,  9 Jul 2025 08:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050072; cv=fail; b=kZIHavgARr81VPtDG64eudGJ3eGYk24pHDkViuEwKRCAkcItyzuJBascazwvr40jVKq4bxY6cz92SUg5gYsd4+qrj1Q+g/gQ/Dtp3A0CS8sV27EdB2wEkPkx+kNu6nCXyL8SdtP5yagO/SDd+3oMYp6tSbPVQ+lIlgwKwTFmh6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050072; c=relaxed/simple;
	bh=az/ExGfHC9QaQukuOlp0q4ab91yOEU7/8OqviKN3Kt0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LzC3I557mfi425V/yK82/VwLKGZwDcAKqlQANr6BRl8++C89DAiNacJIoEXwglbe9BZ7WaBlfUvSDCxed1HknwuuHxqw1g6Npk+RXrQSyorBY0h+YOIsfOaOaF/+PtNz4PFUyJqBwNi8P2/7+L8VV9aGyijsJftwN599zXNliD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W2u6wk5U; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752050071; x=1783586071;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=az/ExGfHC9QaQukuOlp0q4ab91yOEU7/8OqviKN3Kt0=;
  b=W2u6wk5UbkN9eDuBMe2uNIzP0LLDQDxpwM2Ls/uEryYbk93woVDSZLfr
   g50dp1Y+mSbDfCkoYwXTTCyPL3aKXPzZLwnJyA8LseGgwTfkvLo77yBsN
   UYkFYu2n2Gxzm4+LvsjcCmsh3IIlFfdM2RSMAHKnsTE2LDNndbz+Re4NH
   nCCeLxPcfH7X8GjFGRNRbbwZ8FWlAYrbt8AYxQY2BY/nyR3ACeho15PND
   KWalAsd/0A4rqsUQJHoHDIRT8EPk8ryhxtFXEEj0/NgM03G2kOZryioFF
   vRgGxKNUpYHl5Fz7SCzFXq/ryupZD4mcQsqH8co+1N8r5n6uXKebVULfI
   w==;
X-CSE-ConnectionGUID: AKd0RKi7RCKflkM5PIiiyg==
X-CSE-MsgGUID: kfaLhLvfSFKS020i2M+tWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54159340"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54159340"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 01:34:31 -0700
X-CSE-ConnectionGUID: Xo6pcHrARW2P3RsEtdvhcA==
X-CSE-MsgGUID: ViGWWL7ZTrGtcJJzF7FlXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="186721451"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 01:34:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 01:34:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 01:34:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.82) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 01:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pl3NNIphwRqeUYUlbXd8w3fOehWTeXt2tgPvi+/zfRGvVs1POF/bTvJek1cIjH00RkSaEeQobswBZgaMut+YTE8Gfi+UkKCqfcOKGi2SdZ/JGEs4icYW9Ic/cjHKeZnjdlYZC2OhHDZSVTT/r7qzEq4e6Rv00SBB5XhxjMYjljInkIze0axn1066wEufdhDBAQ6pFpwJaoce/Ips5twkBCBJZ3L7OPwEAdjVEEjsVqdHN4jQe5n9n1sK2Uo8QlXiF8HbJxDfb9yFoV61/vv0sD2t3XSNe1JrvuFSUgcgT/niLHUf8xBiJxZa9n99TbPO45UjdS57AoAfI1Gi1A5IWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mymd8eMfI5Tlv7iL/CI91sMmw+MeMQRplvhJW+CXSig=;
 b=IVJbRR1kaM4hr774BSY5uXczq0D7kIqfb4AcMbqPkiS0Y7MxrBHwY45cGGKtWAdEAWzQ89ptUVlmarR9ELYeRufZt0/OdirwskqaMlLUzTGka+VOo4muue7K+r/y5G2/vINlvErGf0C7wBSRZAsqLlCHbKg5PnuNquTTSHJ+W4fS36V5YUicOAg+S6oz0DQTi6/NJl/Zqgmy3Jj4WN39ZByaLJ1gpqD3KGceyxT8T9o2EX8kZpBAiRSbPb2a3jyd0NAL+ePAuIFStA9ZphZn13Djq6MyrHFUvSlCUOf2EFy8G0Slj1IVkBI3h+dE54wiqYZaIS8fjVLquhRDx4yvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.33; Wed, 9 Jul
 2025 08:34:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 08:34:26 +0000
Date: Wed, 9 Jul 2025 16:34:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<thomas.lendacky@amd.com>, <nikunj@amd.com>, <bp@alien8.de>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Message-ID: <aG4ph7gNK4o3+04i@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d1c76d-eace-4611-5381-08ddbec3699b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SBzHM1dIZJh6mNTFLm1Biihg+NkGCYQET3Ck3pk3/KJjN72rk3YbI5Veqv+D?=
 =?us-ascii?Q?KBM1J/MXz7vZi+3LR2g27kj80wWjuZzkVRqRSGXz2GlVkjteJ/u5STOruy9P?=
 =?us-ascii?Q?2boAv74KESUFatQCX8/xN9o+QfYyj2yY1lXH5QVdxUtBrrAVozb4dDlPWT09?=
 =?us-ascii?Q?Ig6O9laxHpdzYp66Q41oVa01hHmK7XMtsU3+n6/Sj2dowbvz4Xf004gmpJaq?=
 =?us-ascii?Q?GYIzcxr8umnE+oCIYM2ndYuPyBM7uZCgDto+iIQKDKYy0oSkf2fy06Yvbjs8?=
 =?us-ascii?Q?SiV0N5mILfIxvJnNzO4bA4vnI2ti26XKVZuPm84MV/ILH3vQxpvh/H+2Eh+x?=
 =?us-ascii?Q?Fo5hnD3iippc+0RQQi+UTMckTAkAkZJrN1LziCQGGIs6Foc4S1/yRYhsc70u?=
 =?us-ascii?Q?B46g08rayW6E7sV/x6ETVRND0jo84NShXZF1R2GuOcK7e72UIKs5qiAFx2wX?=
 =?us-ascii?Q?7L8Nu7F8Y8nC/igg9Ogv5QQOLQoU/cQokZaxR+4GKdyzA5ZycZK3YaIjyBaP?=
 =?us-ascii?Q?ZrQ/vv/FnDDspzsb5pbgBGrIZmxYrq/kAI7GpO2cYc6l1UMD8OmookmnqSqN?=
 =?us-ascii?Q?ztte6yH8+Ys422SPvxtdh0ZwTAGFLainQjeGMlWK7X66uFT4Io8gKdjw9TQa?=
 =?us-ascii?Q?2tgT1slFch8BITyI3As8SNL7prl/VQ2GrRmtSPMTldrf+SpRLxSd1MbS+aoz?=
 =?us-ascii?Q?33/FhllJiOn1Mjt1TBF1CbmgqHwiyZFNFIIRMfm4PhoeuXdoeJ58X7Bl7Hd3?=
 =?us-ascii?Q?ghyxvfu84TS/6uCsZzcyEy+cAbobcnf3342aXGhf02jzNMsXZR7AEYN/YdBL?=
 =?us-ascii?Q?+pD5iKgEpbFuzCe9R6/gDPobGRV89wATbL6ZwGpAHI+GVV9T9vTMm9DVRvAa?=
 =?us-ascii?Q?gL0QG531vxeKzsPnvtwiMtREdxMDCsRD0ZLmaAI73V1GygaTmWqqrZ7lwIeH?=
 =?us-ascii?Q?V+kIXUc1O41LjFKFiw50c8dF+Ck/dy4F1yZQtSyBGu/VwCghXyTP7CzXaEt5?=
 =?us-ascii?Q?F0N0o/id51zS0g9vWihOIlpF8LLgBrlh4XeUkbPum10Ee2bsOJxhl9ihLCKe?=
 =?us-ascii?Q?+lF3wvvXGbHH+cmXvyEOxcW10OIiWK0tZn/8HM0l1LRiboW5SQ+cMSJO/aK2?=
 =?us-ascii?Q?tpVS9tOVLTgq4kfDhEA5nWKfmMingV/DrTJvgj8Sirr09BW48scojhIKTKjk?=
 =?us-ascii?Q?/Q32bkQ3rsUoa1K08r5e9CSP54u/AgOestGUXY4e3nblUmMzEnowPdag6lsx?=
 =?us-ascii?Q?Kj5M8T6AJRKNaaGrKROpDAIyazb2z0u9SlalcyW/jwl9M/GkCwt7cVYLFXGa?=
 =?us-ascii?Q?pqX91p6dJCrdNxr7ICE3pXs8r5rd/tyQz8CdgAXIeM4ca8qKI2oD7T7U+HCt?=
 =?us-ascii?Q?yoXxoYlgLfGa0yqbm9xi89aYQWRgWraDAa5doYRaLnewFD3iiQdFMf/qdjxk?=
 =?us-ascii?Q?S0z+PSAFA2k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h7CWiSegGzQmQfXVECl9QXokxeOfPuL4NHzL6zjoSVlPI46MlhmwkdjPDOJV?=
 =?us-ascii?Q?j53uRIWmsNwFHRo201LCAb5Y/wsABEB1+mrBSF4JhMOGHIgnaT2AgLcDBIi5?=
 =?us-ascii?Q?P0aM/cV1QiMNPz/SLLbjmVOqauDUqXJXEEuk000fHsSWHVrzNDvKx99QhMFQ?=
 =?us-ascii?Q?E3VYxic7fR5ArzjcVNvFp2vi+Kd7iAlmTNZuBE88EAa6WJvcX+NszVwrpaH8?=
 =?us-ascii?Q?0iWrEIfjD2ORQc3o09bHzHXs9LambN5+WhhESJGar1iB9OnbPW5jIFZx/zzd?=
 =?us-ascii?Q?j80sCOddKGPEJj/BhOEsOxNDSQoV/dwKLbXAAJE+oOPLvVneK5FSgCz5VNfn?=
 =?us-ascii?Q?sQZ+F3FPqtdW0UarZKNlTcknUeYTN8BvVvszRsMlka6GxzwxaLSLJynveIm/?=
 =?us-ascii?Q?IhMDCP8dhouHfkB9rdXyIVeIeu9CNsTkZjQu0RBkl9inoWux/rMft6Wi/6L6?=
 =?us-ascii?Q?7W6E4e7CELAnkiJgZw0BT6BFoTcrUpWzey6xTRVJwVJ3CE3NrZ3kmaQeCopj?=
 =?us-ascii?Q?f6/xGVsdtOb0qAnXjfqG61RH33BVDGV6QkcDlMFBnIDmvLW4WyTzalsZEaK9?=
 =?us-ascii?Q?f+1y9QEJ51JsapolwroNRKS5CbDzVLM1fDrL+goS7FdrnjcwI7pwzh5O65LJ?=
 =?us-ascii?Q?612hK2d2dLWwL8lAccS9StOIPMkTDfDPjQ5XgvPmNVWH7TeQ2LFChTl4hirK?=
 =?us-ascii?Q?3shrm3CCzEA95THsTLRust+xdKTxOi+BtfHvWrD7hDOHWNPd/x3ifzmGgQl8?=
 =?us-ascii?Q?H9l1Tm74sG3Uo7prcJUxzYC1qaOe36NZwwBvTizoyLG9SVTzk37cgv8iRVpF?=
 =?us-ascii?Q?SESQfHLjHyWtYGKHr+qg8UOK4iTtYRHBjbhijsFj9Ta+oA6cQuLBW/0MuXc7?=
 =?us-ascii?Q?WLPa1LqZHjfCXgxxnIv/royzy+QyTSKB5WVLdpM4hKJ59CKVXOQtzJqRS8Yw?=
 =?us-ascii?Q?jb5QbIB1vINyPOm5pmqK2BlznwZtnpQ2E054oPh2v+LUIJ5p/nG5zP/7w7aj?=
 =?us-ascii?Q?2e2u9H3P6U5WyRoDvNKlf4z3iSFoUpUtu6grcmQXi9IXXi9HimtUuTj27XuD?=
 =?us-ascii?Q?ytyhC6mHGua9y7ttrwSiyOdxtw4h2Qz1BU093eAmGv4Mu8EjipPmygrA3o0D?=
 =?us-ascii?Q?/+JDkysjCdmhsCIEw6m34gUmrpdiZrsbYfWq3kSsQq1Vf24eocuB4T73iBJv?=
 =?us-ascii?Q?NYs5lv6wS0fguHlhg1h5aTlBm2hz4EJCv/9Sh7jbglqExkzo/vavrUxEqqhR?=
 =?us-ascii?Q?yA+zMJK5A8LVBJ1stUVXqPPDS9Gx2ZJt/m89qApT73pMQ/u0IZBadbyrQigS?=
 =?us-ascii?Q?qBqZ0q2gt2Qvp0BRLA4DZXgPCy7TEUUcbPqhmnjaAiIlL3YLuDti7/r0GyZN?=
 =?us-ascii?Q?JaId5aQsVaKY6E07BTERRldEPaxvXxt5a0V8AP7HKeoNM9mwZAiQEF1HvgRQ?=
 =?us-ascii?Q?WPnFsBBzHtF+VeadQiKUBMHnsvewKLsCUo4OidCVyr3Q9uJ9EijSqrWodDWf?=
 =?us-ascii?Q?2gSSZUuayAvN9ODpFmzQao0sxMXYlaZq2kw6BJ2u4KAb4LrhQUEHUyHoehaF?=
 =?us-ascii?Q?hzP0fTk0n+mYef3zA6BiK5uf4lIjpYvu2ug4Af2F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d1c76d-eace-4611-5381-08ddbec3699b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 08:34:26.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtW2+ETQl0+xBt2Rae7JCo18Ogss/lHSMhvTG1WRwZEhMrDspo4KTDbGpflNyDdMGxrFilSLRlfLzGPdykRDyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com

On Wed, Jul 09, 2025 at 05:38:00PM +1200, Kai Huang wrote:
>Reject the KVM_SET_TSC_KHZ VM ioctl when there's vCPU has already been
>created.
>
>The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
>frequency that all subsequent created vCPUs use.  It is only intended to
>be called before any vCPU is created.  Allowing it to be called after
>that only results in confusion but nothing good.
>
>Note this is an ABI change.  But currently in Qemu (the de facto
>userspace VMM) only TDX uses this VM ioctl, and it is only called once
>before creating any vCPU, therefore the risk of breaking userspace is
>pretty low.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>---
> arch/x86/kvm/x86.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 699ca5e74bba..e5e55d549468 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -7194,6 +7194,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> 		u32 user_tsc_khz;
> 
> 		r = -EINVAL;
>+
>+		if (kvm->created_vcpus)
>+			goto out;
>+

shouldn't kvm->lock be held?

> 		user_tsc_khz = (u32)arg;
> 
> 		if (kvm_caps.has_tsc_control &&
>-- 
>2.50.0
>
>

