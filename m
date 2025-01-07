Return-Path: <kvm+bounces-34660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BE4A0375B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 06:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64C561885FB3
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 05:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7ADB1A0731;
	Tue,  7 Jan 2025 05:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="exwaslfz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA795A95C;
	Tue,  7 Jan 2025 05:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736227758; cv=fail; b=jDd3LG32dHTtxbSt20vX7JKjcHLEldAPOBcjUHZDkQXwtDN7CMo36P3plOo8Jwf5R4MSp0iiI5FYRRyZb8FojAAQSkUoJ4DsIA+Ttb1nQFG0y6taz73QV5u5tKUjJi8B+wXr81XQAHIdXEBXkaeNpdcfE2fziVHQjLr6gQP+b9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736227758; c=relaxed/simple;
	bh=OqBCx80F8iVBBYayb48oE5qZuxpPaZkBjpwlpNhtysw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AB4gGwqIEi+n6jiGDVeMHOpndvLPG1zZV1WUeQbLNwH7YNOAuCzLIkkeG0Y0lVWP1Jhw+xTfSORe2B3e0f3Lqt+7IIdpQPqqlgzgJx8DQYMGUJaB2AofpmAiyn6m3wwzYaEuTYE7SZLA5OMZq/v+3vriWyo6J9yXV/bi0KbvwDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=exwaslfz; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736227757; x=1767763757;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OqBCx80F8iVBBYayb48oE5qZuxpPaZkBjpwlpNhtysw=;
  b=exwaslfzxXp7E8QX8Z5Gegtn44y73bSPRE0pPD32wvrmzkMlHYwSBDMv
   fg52Ta1CND/NmD6g7BshbQZAhaYx6TOmWKbz/cqHSRHQZ0oCSdKUMHwGJ
   orH047A7Rd6RxWHeGkf27xUb5di3LQwbOwb7sG6cbHO5B0h8w7gdJl51b
   E3+9WlhRE/G5nL+Q6O3F0ZhSe92eCCDRubWIQE0Py1TRpw7BGuHvJ/On+
   YfbztMtT1ZvDrqQy5+FIsv42hs/UFTCCp6AvypMPmXw+s7/gFl6FL/RgQ
   TkdSqLRvZTfUpgJ20cEpwHbo2asFuJ9i/KSB5WPdSjSrMbpXrB/erlly/
   Q==;
X-CSE-ConnectionGUID: EAs+k4PEQ9+uS6THFcIytw==
X-CSE-MsgGUID: 8NfCEdz+QX65iYK5t3O8JQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="35627287"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="35627287"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 21:29:15 -0800
X-CSE-ConnectionGUID: 31kn5OnuQSSrWsSoxyGFxQ==
X-CSE-MsgGUID: z6i9guIIRKGlVcq4u/JmDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102844740"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 21:29:15 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 21:29:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 21:29:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 21:29:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kead7vjp5Iq72nTzsGyhm9kFOU+wLzC9AGBzN3/KFexrISFQL8TGzvJKS8UScdqc0R/r8l0x8oZjTNv0xk3nf+ZlEvjFqhayfwnJUjCPr8v/pCNzR43EfTiFIKiY139Wnr/HKWqNY1gaFLjPryQw9uHOxLWW16OSJ+wWrCpvUgXqaSAV+o0ZyfDViD5s/siZ0OZ6YpUz93z1Z/plM1k5Df2tlJ7ix3LOfq/quVAAl6FlIUkdBz+i4wvxCij9L1S7LQDD8wuBKZQazoIPtug5EnMk8Y6mN7X0wlSCSuHjzkFTZVrY+EaiVchVzIsWz2u3yAd6Vxxizit/H+KWUltnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sd9BFdcWEUTKwOcwShzdYTVLUzBpvxCDtHPzBwAORss=;
 b=FkzHhIxaqIP1MyoIynDJgQQFJEiu5Z954zZw/0psvpgOXbLpI4cCxHMC/u5Rs4yRlHIcvYBezIZIYdf6iTieURDn7R+c3fLG2SrrhmzVzZionsKVBXuqGCNL+Pa28/FntY9GYj5OVeeaI/jKeOpAHDMtSwDfN402FHHQl+pVgBk9ZSLGLmYiiesv9j/haa2wwO5f+F/x0ZqKH1J1DyWl4ZpEm9VLu0eXPOvaDT0G6QG1yyOFY5WpAEP+lbyTptp/Pv6uTUt8gsQz9elPeg7hA2OGUDbQjXYyKAMyZlWEMRd/Rp43y5ZCHamSFCBssShynZhHu55LWuKaofGv0ri0qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 05:28:28 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 05:28:28 +0000
Date: Tue, 7 Jan 2025 13:27:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Message-ID: <Z3y7RQCT5/chcdHs@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-8-pbonzini@redhat.com>
 <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|DM6PR11MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: dede47c6-bb44-4844-71b7-08dd2edc1d7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4nz9H50PMiV1KcDRmI2Qs7ZxDyUTxKtzPP008DPkamGu4yiVar27PRUEBYrA?=
 =?us-ascii?Q?2mgGy/+jiDaFKMOo8/idwHxQeLeNCYymn3YW5Rhdeylz3jnTbLpjC+StvlDi?=
 =?us-ascii?Q?ldCHOZ62bz26xt8whM1Mw4kynOvG3efmyGy49C43EnkZYtIi5aF5tKpN1NDi?=
 =?us-ascii?Q?SbMHj1Py+SbRM2Bt7BihXKtf39THIsyiRZr8ZOPahCBBs32WsQgMSFte+IE5?=
 =?us-ascii?Q?/Vqb9EGrJbdEFjikAQB1HeMoyroX0MQ1A9Bno9uurjH+3mIWvX4uoW9GU8J4?=
 =?us-ascii?Q?f59JPbangiapnChTvuNyWbFgHYjPYVqXaIgzJzM5OCwjEEJMF0g2XbuuYvQl?=
 =?us-ascii?Q?V69VaFDkazCLZK/rCIX81eiRwNVJpGuOyd71n4u/Tz2X+h+tJ1vs6X0mC3aq?=
 =?us-ascii?Q?WLorr4Sy3gIrkt6dJ9pZ0uxLTfhgNfq/sJUSDmJdNg63w9Sfty4nSohsvsjA?=
 =?us-ascii?Q?51wSBVtmFVBz75qfEj0X+kIu97Hj++9lBxFaOkNtSLPzYsGWFbr5Bwwt0YeL?=
 =?us-ascii?Q?HyWVxyOXiuDbXMXHY91mocHt7j4Ifs+sU0yzk2VmnyXUDIGn9sJpzygf/nFH?=
 =?us-ascii?Q?sTaLWObk0YJk/Pp9TJ9iLwd5w2XAzc5tyOoDUR9KGcWp0jtTaWHDehgVyt5s?=
 =?us-ascii?Q?XWAVyUsLi6C8J3OtgcEdepfvH/Qyqgn4ywc6SgCjuETGC2rsPNlxswFAA6bL?=
 =?us-ascii?Q?AXnttlFB2Ew3qWQ+Tp/jjNQInHNB4pYdblPfenXTuAt0lO3dm5t7czpkkfhH?=
 =?us-ascii?Q?q7VPjtNLFl8azuSBBUnuKDNmaZYVJ9nxCiw0R2YrHNwUv34zmllhMIdOlV5j?=
 =?us-ascii?Q?5rtjkr6qI/5pEnmYwCnuLrLazYcGULkpTy6QUy150YUkSXaIfpYzOWzqPfVC?=
 =?us-ascii?Q?F3u6mAw9K8GdAJP3NFFX5+CjBFZ9XJVmElPhgMDLpjC31NU1Wk1F5YN/Ge0z?=
 =?us-ascii?Q?8tVdPvRDQHDYu8HkNu0PhDRGf5HIZK9v3gvOo7o0yy5qx9C7ZravlfurTuDY?=
 =?us-ascii?Q?1gZ8SXAgLGPTIH5xPfwCH85TcxTY935Vfc9LN+TL+b+4/A4ggRSxiHpjnco3?=
 =?us-ascii?Q?pTKWPYJcMP3SaI3JQ0e71RRZtrXor8PtibMC2TRSrSNUu42u6wB3nLdgwICa?=
 =?us-ascii?Q?Ee1MxbLYxXjS0jzvKqmcN41RBqwQVYYjHJoUvRuYurLClRJY8KLYoukO4nh7?=
 =?us-ascii?Q?V5GxYjXxQH1H4IC+lbvSJxFTa0YsQzBI6RLwBF47AWiSeDpSFcp9HmuxM2Iv?=
 =?us-ascii?Q?una5BBzhzWdolTZAa9iWcfH88b0TXpAufkeTi4SEFy9QNdp5J4pd2nXdfZYh?=
 =?us-ascii?Q?5t/rNWF3gaynQgrS3CsZS1ks60/01MR+XOgsgfGdxOLRpmP+gk6rAHLqyA2w?=
 =?us-ascii?Q?lI/v9LxmMOJFCvd3zbDkP3cc0HQX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LCujT2WwmkrTSeoQaLkScUeBBZVY8eLfOFkF/jTlQWqdrTH3EzfJUxFDtdnO?=
 =?us-ascii?Q?SrQ3ADT/NWihxtZ66USo6RFa+l5TlsGwn7scEaaiPyazxYCh1eWU/GuWtvxI?=
 =?us-ascii?Q?SoJ50zsi7/GmrVN8QoRv65nnouIgsIzW5TqIMnrhlFmLDl0rHFAc+8yLWXC8?=
 =?us-ascii?Q?BMBT92CsVAg0/IZmcvuAXe9spmHTQhlUVjdn29nmv/WaZUKcmAzCkAxIYLEC?=
 =?us-ascii?Q?RRjAChiBZF2w7SKlDrf8VN1Q1Bv4CSHHeuXJpkMcovxGlBLUFPYweGsAEwdb?=
 =?us-ascii?Q?W/c99lVR9jNUTLWh2pAHthMo4J61C99VZMDv5lm8iYlSGW4GObkSI4N9apSi?=
 =?us-ascii?Q?r+fBLa79pF5cg4+rAduEUccwhZ4u7lCFOWvEV2wrdYEOE+sUigikOWUskJ1K?=
 =?us-ascii?Q?unzcbSXp1Ka0IJyjZcESTw+d6gF3m+AnLALbDnpddhLW1LLtrJxKwnMoxB20?=
 =?us-ascii?Q?oiqBxqP5D0rh4ixMSNyi+6BA56upTWsoBfAdv5krFZjMxcFAe/H3NhyfqDxr?=
 =?us-ascii?Q?nkUVyqErDmhFkrdIcaw18jkI0iRCf8F6BDd0NjxEmyRx3Y/I+1xENiIzf7+f?=
 =?us-ascii?Q?BI7FXpldSulaihAmpKz1ixd9itc8N636Zk821Hm/zWwvxpT4j2uAgZUDDleu?=
 =?us-ascii?Q?QbWx3oZ1d6nhAVuzaggxhKGVydfJ4PuVmkNpw0jjBPac6H5RVOpe/zz9hB/e?=
 =?us-ascii?Q?thcaA3TSqUpeevXYKmm2EH9YwE78Bk609/YP6+Mh5jhDOhb6WeQ2jv6+/jGf?=
 =?us-ascii?Q?k4PFF1NDg2/5Pc4gVQWWH210m8scRWe4OTyMWMi63j+3lO41qpFrJ22wqQ73?=
 =?us-ascii?Q?PkPBytWe6IJ9OREpVXovLEVrQ9Uv1DHb1STb6slWcuXlmSUDmHsseSuonHnN?=
 =?us-ascii?Q?mvgVEiCXC8avY0jOFezSDep7jyhyG8yHOYRDsOT/EBsXfGF0AaVD5LNO0RZb?=
 =?us-ascii?Q?JbZs57KLz/h8NfDA/XIZbLLE9afAkUUVNuDw9zU7mnZP1gwcoQi7CSpb4aHV?=
 =?us-ascii?Q?MavokwhUA9nfkS5rzlAtmHsDZqlBfouueyCdVvVxjs2pz4Bz+eihBGB4ldfZ?=
 =?us-ascii?Q?o85d+pI52Kul9pPCg+gnKlYdPWvj6lq2BjtAOBmD6vTQNfVBZOH9ybw+XFoz?=
 =?us-ascii?Q?4kZgkZ9DRhAFEvK4XrPv9NSg1yT92wnqSuvS/KfynqQNMV3UJp86fR69DRNJ?=
 =?us-ascii?Q?OHDennRCA+sEcMs/11J5LBa+Z/umSgQLGsd/euHsbsoWvt/8AapIS7iTPa0V?=
 =?us-ascii?Q?yy6W9ZTFHLHYpl1Hjpgrjay15mZlEw7nKEaIQKss4QulP0YOVkynAiqj3S31?=
 =?us-ascii?Q?J/0jQDOG//7szGCTZIini0Ud8902x+Yxh+c4psgwCcAdbU9DLkx+Xdc4dhqx?=
 =?us-ascii?Q?dd6HMuI0pudLink26X74JC2bFRMdGWqyj4BpxrNlsxcwaszhDMjtKU3yqCoS?=
 =?us-ascii?Q?hXxn6FGwUHO3BnmExIw6j19aUTWN6+im7MM5hdiSyMt6NcmAVWudHcRk/9WC?=
 =?us-ascii?Q?+WeNhGrin/W7TQiqfijiw0essAIBAYj5U9UmbLVy8O3jJXBAs5Jnyg/AN0vo?=
 =?us-ascii?Q?/aYrY5/+z8asMfITiNyP5ioSfMfDuBIZQthowrWx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dede47c6-bb44-4844-71b7-08dd2edc1d7b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 05:28:27.9862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0QU2u+Du79QcKc8H4ne7ULAnKFxwR2p6C/vQplu0b3PQkZ3tI/pp7+qtNYXIeR/slI7G9aOl/cIZKmw9zol6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com

Here's the proposed new version with changelog:
SEAMCALL RFC:
    - Use struct tdx_td instead of raw TDR u64.
    - Use "struct page *" for sept_page instead of raw hpa.
    - Change "u64 level" to "int level".
    - Rename "level" to "tdx_level" as it's tdx specfic. (Rick)
    - Change "u64 gpa" to "gfn_t gfn". (Reinette)
    - Introduce a union tdx_sept_gpa_mapping_info to initialize args.rcx.
      (Reinette)
    - Call tdx_clflush_page() instead of clflush_cache_range().
    - Use extended_err1/2 instead of rcx/rdx for output.


diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index c6d0668de167..ea5a98fd1dd5 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -105,6 +105,20 @@ struct tdx_module_args {
        u64 rsi;
 };
 
+/*
+ * Used to specify SEPT GPA mapping information for SEPT related SEAMCALLs and
+ * TDCALLs.
+ */
+union tdx_sept_gpa_mapping_info {
+       struct {
+               u64 level       : 3;
+               u64 reserved1   : 9;
+               u64 gfn         : 40;
+               u64 reserved2   : 12;
+       };
+       u64 full;
+};
+
 /* Used to communicate with the TDX module */
 u64 __tdcall(u64 fn, struct tdx_module_args *args);
 u64 __tdcall_ret(u64 fn, struct tdx_module_args *args);
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index bbb8f0bae9ba..787c359a5fc9 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -33,6 +33,7 @@
 #ifndef __ASSEMBLY__
 
 #include <uapi/asm/mce.h>
+#include <linux/kvm_types.h>
 #include "tdx_global_metadata.h"
 
 /*
@@ -143,6 +144,8 @@ struct tdx_vp {
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_sept_add(struct tdx_td *td, gfn_t gfn, int tdx_level, struct page *sept_page,
+                    u64 *extended_err1, u64 *extended_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a16c507296df..adb2059b6b5f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1583,6 +1583,27 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_sept_add(struct tdx_td *td, gfn_t gfn, int tdx_level, struct page *sept_page,
+                    u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = tdx_level, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+               .r8 = page_to_phys(sept_page),
+       };
+       u64 ret;
+
+       tdx_clflush_page(sept_page);
+       ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
+
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
        struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 08b01b7fe7c2..0d1ba0d0ac82 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,6 +18,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX                  1
+#define TDH_MEM_SEPT_ADD               3
 #define TDH_VP_ADDCX                   4
 #define TDH_MNG_KEY_CONFIG             8
 #define TDH_MNG_CREATE                 9
 

