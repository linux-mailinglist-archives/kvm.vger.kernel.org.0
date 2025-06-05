Return-Path: <kvm+bounces-48466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 740D7ACE877
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 04:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F63A17410B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 02:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E2C1F4701;
	Thu,  5 Jun 2025 02:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPdohg4N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE484A0C;
	Thu,  5 Jun 2025 02:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749091816; cv=fail; b=FWf5bsNOOKjAtejMDVQlmN3bGyfLH0SnJ+Byi1a0aabCF3arQzzx9BKLNggYHz+FVjnuSGbeg5q9pJBvxHd+B6slcxOOjYupDBfZUj5x4xq5BXWfK4WJojX2IwmlOraqHP9D3AHyqWgzHUxzFUcIc6wj9snq2LPBDf7iWB+IJzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749091816; c=relaxed/simple;
	bh=YmY9/p35gK+6HSTQlBQYII5OFlBZGj8BUpI2eTqx5V0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u9KHGwRFhib+t7s+Ut1u+xZgaG6Y3RrZ1JHc/YmUn7NPhRl0wWXs6cSo7wvwr0qN5V/FLrEqxX74th5Sdidb7vZ3Li271PmrW52yHDr3W5mf+G+xqnfdGW84y1cvxtR/NgInTGx70tWY0M+hoKqzFzHjcuPeRZBSjFoc+tN07iQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPdohg4N; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749091815; x=1780627815;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YmY9/p35gK+6HSTQlBQYII5OFlBZGj8BUpI2eTqx5V0=;
  b=MPdohg4N9+VDqOZ5OsbwZg3dhsK9pIYem3usHuI0g7P3tBN15laYEco9
   bX5hmaIJX8VsxdNGN3K6+CNVMML5kjgLi7ZE9Kdvy29lTARDmMUdL/hUN
   PsrYnNCxJfL0gZrsqaQjLzQwdlyn4Fby4YbuO09NEWMfTBAyfQu7DKKxf
   9Gm+TXPhGsWqjg3yl7kH+DwfVAWuQ3dJ18dLw2Ly022aozaCJI9qb0UFV
   Cm7/Wys8gUdB+1KnEifLuYF8pV6nn6DBMCCu68nJTW7M+GX9XmyM5fu4I
   1C9TKx6mVfnavPPtI3NcBRZWTsTd3OZ2voikTkoCj0koi2l1eM+14YmxL
   A==;
X-CSE-ConnectionGUID: 3yWNzdpVTZ+h6hw2BJYjYQ==
X-CSE-MsgGUID: AV9TTtNMRF6CF7Hk/YzU2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="61864011"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="61864011"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 19:50:15 -0700
X-CSE-ConnectionGUID: FAwGwC1aQauydGK8ZErFlg==
X-CSE-MsgGUID: uwxiO07gRo6mlAN8QSzUXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="145709667"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 19:50:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 19:50:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 19:50:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 19:50:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QunL98ypijxrIt8x1EQ9xmCLMvny0z/fkeihg1pSlXgxu06VL+n7lP1FlLqnlYskq7vnEzPI2gEP627xahGn+FuGL6kBRyvsfT/+AGE+LI6hbBtM//eYaPbBbYHOjJdUM/esQPt6jUdy9RCGH1faG/t9IzQACKuc/qVk79PIXx3aXq29LMavyNl7d6zxz8JjxXoPJ+SKl0rS7a65LShgl71ExyaJQF6Mv2GsQxNoCy8z8Fd9TLBzaTokTr3eGxgPJwLGM2PQi0kfPZ5ZC55bOA8wAt9OWqdX2DBpa4Sf1DAxpJBj0cKVkIBKj581/ph7fYcB2u/MZ25FhiLxUMVDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zng59T4AIvAPt5zlKQqRTl0j/lMyYzkJrRNTvlyvTAY=;
 b=fazWlphAscYkLir/hZGpaAOnyddlagCLryBYjahMNn9l/0XEsUnrm+ysLvTxtxU3dgfi2x8U9wWRr5iaHKcWuHkhPxJTWABR/SHXMRjMKmb6gn8wmhwRzjpxVYdsYxBSQc+hRl1Fwet50sJPnkfZF5jqctU1SukKG52nh+C0o/Pnaftoba3pbpH+IL23rmbM2dvdiaJ3IKYdI/T6ek0UPRsQXMJokh411DP3RvCOf0Rdmo7w7pvK2iYm4k1nnJHtQWtl4T2bM2pRyLs3G22A4ADjexhllojSZGP+sQyszP91yQNpz5ZM1ZcsjBVfQgoMcsvfMxcb/zg3GFFXtO1RSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7994.namprd11.prod.outlook.com (2603:10b6:806:2e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Thu, 5 Jun
 2025 02:49:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 02:49:55 +0000
Date: Thu, 5 Jun 2025 10:47:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: KL1PR01CA0107.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7994:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f20841c-89b6-4c7d-17c0-08dda3dba703
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tf0MPKov7j6YWTx5LjT+at54T7gLb2UWeX1JzcK1NF+2f+sknxoWw7khy3sZ?=
 =?us-ascii?Q?rgrjHfUZ5vG/F+HE8Kwoqj2aBekj2O7M01CkRHQyBugzNA1FXsUI4Fg/INKc?=
 =?us-ascii?Q?Wws4z9d+DFTp+8a3QkAELP8rfoG8gYvc0gVwJgqm6/JC2EpOlnFYlRcXZAPD?=
 =?us-ascii?Q?v9tJhLKb+DkNScFMA3zuyCJah6xiG6l+UyEvjMoQQEpckTjVnerD2xzNzBuS?=
 =?us-ascii?Q?sLXqkbHDLYHBoWdgaLj57hda5CV+8kdZR49LnrABchnk6Hg7di0fLk8Hv/q2?=
 =?us-ascii?Q?q6O6ut9UML/lKCaFekxdcAd5XkJVQMHNQK3KaNe3+NOVvU/Keln1Ax6W+WxD?=
 =?us-ascii?Q?i6kGKPbc/AFsAuyqlPxi/S/IUaXhK0AVaaUFjzSylMKuQ74cRZ2ZnyAwrVdq?=
 =?us-ascii?Q?mlRL8NlPsX6WAXPRJUFlybxpc37PsUehuF5Nc9CnzrENcROlDePgjRR7dc7V?=
 =?us-ascii?Q?WqWyjCeSlxcbHZ3FtcXFaEQUGGmV/ydaJbxXgyjA7aQ7lP4wp2RnYwhFxFRF?=
 =?us-ascii?Q?TWyEQg9X6xmHpmKzilp4y5mWaqyiFFFdJ6gDECO6uoL4AXZcjic8jrMhRa7q?=
 =?us-ascii?Q?7RTgcZYPxhd2/bwxf3TsW8RmF6dh9iQWBg/Bl1mGgZYOgDVholNbhDBsmgPY?=
 =?us-ascii?Q?wEB4VwU20EnlXwUTjR4tpMIBLEvFwPPOwuS1xBEEB2fHPQj0mNs0gW7++0Jm?=
 =?us-ascii?Q?gsH6g1WPt+yvQhrGUu5T/TmLAyqStisPrKdSGXA/uvfUFbAL/g5g4xuRh5++?=
 =?us-ascii?Q?lmyvAsrALpCFbABg6GbTLKjniMLeIGq+HY6h+OLu27e/7iLmv+fRyeNC6Sk0?=
 =?us-ascii?Q?jzbRbtN7W6sqKQTRzsXK//CND4nVqRBDhwfZKfsGAHACa8WBMqUvQVfZhX3j?=
 =?us-ascii?Q?/rQfkv/mP8ILydmzaav563QjYNuijW7QqpaYIX0oJ2nhGk7PdjYxtzBx6cnS?=
 =?us-ascii?Q?1bwNmnC2iosILFSr7GvWXYS14ymAgg+NStx0uYMCGT1d6OuoYwP5RTQxZyqI?=
 =?us-ascii?Q?CtFUfm3F1hoZkObuyXmN1OTtLNedn6OuABEMDz2VhDKb8UFm21ARbbJzHlPz?=
 =?us-ascii?Q?kIB16sCkcbUDCt7t0rWC+xW6/nMsgCezHr08mIR9r3G4dYOVWBSBqreXfFkH?=
 =?us-ascii?Q?YncKfS8TyzEY6VLSwRgWEeMf5xa40VZHBqDOHY6xci3PJCveXj2wSJhUzYnV?=
 =?us-ascii?Q?oedlK1iguX5kBz/EUygia+OUFQ8yD/+7PfMid43Ym30yEtDQ7/VtWDI1n4bR?=
 =?us-ascii?Q?HE7h423hog7qSkODi4+RzQVaaOLTi5twi/TusTatBN9/bet9dJrWdJA1Vq9g?=
 =?us-ascii?Q?818J/oHzbypYuEbGpWvPxe2ZFv6lkYhnJOrKHh7RZMYcAQTtqVGcrzwDtYf+?=
 =?us-ascii?Q?jsB2XAFIN77Qv6ZaSq4/9QvgweGxlzp5/dz/31MH9+hJJChCDFMilvVy7+5z?=
 =?us-ascii?Q?AXCnS5ROnXI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTVOVdIXfEieS0GQcR5gzq7v1x8rO99f8OQoBK5bdPOSN6OiVyRIt7UQAeti?=
 =?us-ascii?Q?moeCKA1NHahm+/oXIQi2RmamfEpoEDld5gZ38Uz1yNMOcE5mzQufJD/3MuZa?=
 =?us-ascii?Q?eQ/usLHb3vdrssWILQnrBUtAD8Y//dw6qTYi7c7uEygMZERgVW5jhWPqEnbO?=
 =?us-ascii?Q?J/LxxHp0mr50wpr2QKkLWc+lMfZa6uM8pHSESJpL29WNgQL2xsaXO4thZtbB?=
 =?us-ascii?Q?W3GRPLLKtqc6sThCsS9pcXJ4k6YlKhFtlqlCNsnGN8eh6518nhQZvfprdnNK?=
 =?us-ascii?Q?T7SnN8abkyH012UPTpH0neYlBpP5NxIWUjCkhL12EZK72blEKm+7/fl9pGey?=
 =?us-ascii?Q?FbB8EiaZFriAFU8f2Y903nwO6JzuOceqGUkFmx+j7gFazpxXMJI5FXFzu/Gk?=
 =?us-ascii?Q?7DzijCEaWLhla7nEKi1Bmo2Uh2gKUHRB4u29xikNNVJnVDcBAJlg/w8ZKQ8j?=
 =?us-ascii?Q?Nt+EMu1+WmKup/Fwkl5Gqonix1Zj8wt/oKRrnYWEzV/jk0NI93tWngNrX7gF?=
 =?us-ascii?Q?xb60Vv2szK1KJFCbNJUGfLnAd3mgYmcQeb65aQx2y4bVrifEg6vy8v0VEcBN?=
 =?us-ascii?Q?/oVwghSrVu2hMNLQIpcd+jNTvzW7q8bmrhbbeAJ6dKlWLjsO9pQ3AEVjubGW?=
 =?us-ascii?Q?B8l73qZAIA43mxlav1APaoMsbOp6vJD9JGt/P+ttlKQKkPshTke1mTuYrfe1?=
 =?us-ascii?Q?i/mp58XYJHzcDnD2HzYcyhpu2cPIfd3xmJzSkPUJcpzN7KHJYjQClTYEwZZd?=
 =?us-ascii?Q?7+fpnhq2XcBuR7iYjZpPxTX9JjwmNttQoYpJyR6HJcNUbPupxL3azNZ0idwV?=
 =?us-ascii?Q?RECa+T+YwOSEzTk+os9maDhl7vxsRa8vlQosyvL/z11wHYHpN1J7ofo4GLMA?=
 =?us-ascii?Q?VPaPd5BhVF9TejvDFeMm/Fqy3xTLuBEC+IS59VSjuwbzbEMezlJItHlgJGli?=
 =?us-ascii?Q?jAZmj900Q7khYSmbAis8hYb4EKVrDa7O8zU2bPr8SfK5IIy7RvPuK5pSVZUR?=
 =?us-ascii?Q?SY4Ylfqcmd7TKV/jqbfwZDrLkcr4t5L6q5sQYfozbjzB/6+NGDqpsNLGFznk?=
 =?us-ascii?Q?EUPFRjLyxdb9dnH7cVlx8wXZIg+RubgTvEVG5+zmyhPInuaRJshjuGAUDYGz?=
 =?us-ascii?Q?W4DKDAlriCqISAr52TnbuAfdVGNRv+qvV0jjU1LLYne9Szv4uj+FiOfpxXn/?=
 =?us-ascii?Q?0SaJCTwlS1YqxIZOQisX2eQPRK3iTaty7CKfOF788E9RKa1PtgpUCJ5MAgcv?=
 =?us-ascii?Q?Blv/RKzwkSpEXry4QFQMGI4720tykfvMIC1mKd0/IhpQ1maqmRg96KhkRN3i?=
 =?us-ascii?Q?r6r79RDNSYw3lRCY0fMJMjnaPnObsPCLi2Z4GDLOWdM5HcdQKbgo8R6YtcOr?=
 =?us-ascii?Q?K7UWdvGGule++Ea/rvDkqi3qcDvmAp5N9oyVbAJAcY/TBW4YrY20FIoj9P/i?=
 =?us-ascii?Q?uHi+yQPgPJe+YXEiU4lhwR6jni2sYMz0USgLERTejg9IrehvOSXAZZBhLejt?=
 =?us-ascii?Q?J+arQJXlsnlwR75zbbzK5Zf+2VfrVEyIzjGj1rxiieZDkbd0E68FZE+ZkVSD?=
 =?us-ascii?Q?6qPTKHryzVNe2w9XLNr6nOPUUmfHvXVsk3jwmlg3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f20841c-89b6-4c7d-17c0-08dda3dba703
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 02:49:55.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oi0D91dPfyaX5JXVbdpS2oSQqUUEe9mI7M+Kk5iTvm3JjjZPU63/OV1izEBWHtjmUCsTR3bkpE3Bo7tNBpQwTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7994
X-OriginatorOrg: intel.com

On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> Hi Yan,
> 
> While working on the 1G (aka HugeTLB) page support for guest_memfd
> series [1], we took into account conversion failures too. The steps are
> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> series from GitHub [2] because the steps for conversion changed in two
> separate patches.)
...
> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2

Hi Ackerley,
Thanks for providing this branch.

I'm now trying to make TD huge pages working on this branch and would like to
report to you errors I encountered during this process early.

1. symbol arch_get_align_mask() is not available when KVM is compiled as module.
   I currently workaround it as follows:

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -102,8 +102,13 @@ static unsigned long kvm_gmem_get_align_mask(struct file *file,
        void *priv;

        inode = file_inode(file);
-       if (!kvm_gmem_has_custom_allocator(inode))
-             return arch_get_align_mask(file, flags);
+       if (!kvm_gmem_has_custom_allocator(inode)) {
+               page_size = 1 << PAGE_SHIFT;
+               return PAGE_MASK & (page_size - 1);
+       }


2. Bug of Sleeping function called from invalid context 

[  193.523469] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:325
[  193.539885] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3332, name: guest_memfd_con
[  193.556235] preempt_count: 1, expected: 0
[  193.564518] RCU nest depth: 0, expected: 0
[  193.572866] 3 locks held by guest_memfd_con/3332:
[  193.581800]  #0: ff16f8ec217e4438 (sb_writers#14){.+.+}-{0:0}, at: __x64_sys_fallocate+0x46/0x80
[  193.598252]  #1: ff16f8fbd85c8310 (mapping.invalidate_lock#4){++++}-{4:4}, at: kvm_gmem_fallocate+0x9e/0x310 [kvm]
[  193.616706]  #2: ff3189b5e4f65018 (&(kvm)->mmu_lock){++++}-{3:3}, at: kvm_gmem_invalidate_begin_and_zap+0x17f/0x260 [kvm]
[  193.635790] Preemption disabled at:
[  193.635793] [<ffffffffc0850c6f>] kvm_gmem_invalidate_begin_and_zap+0x17f/0x260 [kvm]

This is because add_to_invalidated_kvms() invokes kzalloc() inside kvm->mmu_lock
which is a kind of spinlock.

I workarounded it as follows.

 static int kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
                                             pgoff_t start, pgoff_t end,
@@ -1261,13 +1268,13 @@ static int kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
                        KVM_MMU_LOCK(kvm);
                        kvm_mmu_invalidate_begin(kvm);

-                       if (invalidated_kvms) {
-                               ret = add_to_invalidated_kvms(invalidated_kvms, kvm);
-                               if (ret) {
-                                       kvm_mmu_invalidate_end(kvm);
-                                       goto out;
-                               }
-                       }
                }


@@ -1523,12 +1530,14 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
        }

 out:
-       list_for_each_entry_safe(entry, tmp, &invalidated_kvms, list) {
-               kvm_gmem_do_invalidate_end(entry->kvm);
-               list_del(&entry->list);
-               kfree(entry);
-       }
+       list_for_each_entry(gmem, gmem_list, entry)
+               kvm_gmem_do_invalidate_end(gmem->kvm);

        filemap_invalidate_unlock(inode->i_mapping);


Will let you know more findings later.

Thanks
Yan

