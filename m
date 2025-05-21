Return-Path: <kvm+bounces-47226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA18AABEC75
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E22FB1BA3538
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 06:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DC2235364;
	Wed, 21 May 2025 06:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNHsMtlV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24F9230D35;
	Wed, 21 May 2025 06:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747810148; cv=fail; b=jkOkQvRSOHPkY9+SqNhtzqDd92GlswfKv/5ulRyELGr/CZa1mABb2SbPiQ1tEEc2andqaKnC96xLZVh11wl2ApmHn+60eTjsmbNWwAi6JzkXbq11gBSUvsP4yho0c24GKgWbnzV0cYnVNWNeAU0FB8IJ2jxzsZOqmYjdG7kZFdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747810148; c=relaxed/simple;
	bh=anrIDH8smWDPpSIMxn4ddY24zpEtUd3CKSrIrJoO7Us=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=abaNAK1bA7RfbDiv8fnWliqlVpDpD8YFfVdMzXMZ2D5psnYRukJi24HXseXlB9VAmU1V485jmBdzKUvOlGb+Nv6gJX486TpjhCravH13Vgugee0vv7sBkjuncqt78RFeVGizLsz7y14VOYSCpxuH5DT7ndkkL44E1L+qTUtCHG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNHsMtlV; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747810147; x=1779346147;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=anrIDH8smWDPpSIMxn4ddY24zpEtUd3CKSrIrJoO7Us=;
  b=MNHsMtlV5Tw4wxTNoDXrm4DPwaZrfuxLknqtg5p2cyEScaPpBxnl5GOm
   02EObyfjWo43MO3+yD/A2ogXB28814IhMur19jKDAS1Xb5jGlWhn/in79
   GACRDmeNV022bXXqcM+PN3L+4ICZai+GHIkIq8c6/4WEOijXuNhv5d82l
   RB8AaZ3NrZ75kcUlHJuodYZzhvoGsxGQC7q6I7kkaepnJ2C9BNwJ/B3th
   u/eKv0xpCCaKSr5bNZMGgxPUQx+vaLnKq4pyjWCvzH7pFrew2XRSPefnT
   lGWWisFxsaGHygefiIhcSFLwKKWnqQlq1HdfHyKHnydxPiURtX+RfbPSM
   A==;
X-CSE-ConnectionGUID: FIOhTKI7QMSQjke+8A15Zg==
X-CSE-MsgGUID: F3h0Mv++Rded86Ep91mvSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60001918"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60001918"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 23:49:06 -0700
X-CSE-ConnectionGUID: JQwc2+wXTASE35yVIEr1Mg==
X-CSE-MsgGUID: hEM2SqKvSLKOuCM8oVV53A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="144913241"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 23:49:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 23:49:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 23:49:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 23:49:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqkdauqADofIFjk9DRs1Pj6Rd9NKWt3/ZJMYjU+9GGvfEpyEWCQIP0PbWvyJ1Mp3AHvXwfBWKlusnHgLILgwgaHo0bnjeY6viPga/a/zbGbZmGbBx6Lisq5Jg+DHR+s/CNUi6vKnxrCNJcqaBLV2caSy0WEqrEo97Sc7+6Bw5lf7gmblQV6ga09ceYpkbnl1Sd6qRJvW3/JlExi7a+9C59YlK1meQEJnoLX8X44478H/FErKHhqhlUJgyJ2DWaU2FTnDwjOdz/Q3nOq05NpnBzPn1N74CUipKSVtTTQYcSVsiyaHBUwuW3C516NpASrkwq4N/Rvbx9ciMozaHGUNAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFmpjlUMmY930yrno2EG1MZKGtN7FZYcPF1vXQRJslU=;
 b=Jwwg/nhYqXnh3EIj89NLMBJqa/TJlTRej4LwjVFKp0TvOa9Lx+bw7ZYSfYGX+RiMLMLPkFUrJJfNz34FKTSGzBgfeIPmePAWiSdJrAIEjfnAqUHNmfgENo9UinJWnkDIyuAIHH+ljrQZJ/GRM1x3PyVEEy16z7BfIPXEwTpJ/PIa5zGWFfq4/LwHpx8vq5wGQK4oPFYxBWKEXaMCrzKK5y0BMTdGzizUu0fMNmE/qx64iJ+WPPvbMxSZSIK+pi86RRjaHfsAREsjz414wA+hfST+nIOxHaeDy6UZBJkPgW7f+z18WA023Zg6TN2EVWGfBBp0jdZoNoA5qns8eRGGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.19; Wed, 21 May 2025 06:49:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 06:49:02 +0000
Date: Wed, 21 May 2025 14:46:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4993:EE_
X-MS-Office365-Filtering-Correlation-Id: 99367a9d-e9af-4659-ba50-08dd9833928d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HMb50P/BA+f/vEkpjCVoMaTqVedZfjIIJ2ZAPG2kKH1GgOKmrrHW/hlXdv0+?=
 =?us-ascii?Q?XOPttJowfDAAGsegV9b4CBda97hfxYSSjZQeKbton1U6Smi6FOrUZUHyLk+J?=
 =?us-ascii?Q?bnQa3Z9HsjTIZmJOtwSacD1mI6rrnoKoAthsIl825VViUzXYF7JKqI7xrcmY?=
 =?us-ascii?Q?Z0tk6id1vtPa00UbN7hDRRm3Y+g/P8CWTKU5hcboHTXK22saoawzK9LUeG3S?=
 =?us-ascii?Q?xYp2pd0oviEAG3RmVPRDuB972uXhpEgLW1N/Zppxn1eFcmdY1WtDBr1k/qyP?=
 =?us-ascii?Q?YDRiJH0rIaALspWTO08r20k8NO/XIk1frG5vEdgqwMKSCGSXKAf+ONT/Y0aL?=
 =?us-ascii?Q?+7QctRPDXRdLWFLpaBzFte3CP0mcA2Nt/Nnzy+j0PLSZMsXJLjpPtxDMWolx?=
 =?us-ascii?Q?w9ef3DYnT+4D1Dey16fLM/Ao2zCu5vfirGbdiF/R0l5NMq57QtICm4//dm3W?=
 =?us-ascii?Q?I7irSarolQsobYz2rxB4z2wnIxx5yOY12rarqbGZkGU8cami/lAuJ0GHVrJ+?=
 =?us-ascii?Q?mGppWL2wBU7BEDMZHYDrDsLcXH0Wy2S55Uag2gKmHF8U/fnmTbWaZq6uydn7?=
 =?us-ascii?Q?p/8Ye2b8FP2TPDCwhIMEPZxkbVrpbKul/wrzKLfUmrbCO/+EPHT662y/EBVP?=
 =?us-ascii?Q?OGRu3Aq5Pl+F55W8rky1/Rs3DBhHJijS9oYwO2J1nqaL8qR7+nE3ydNJnb2G?=
 =?us-ascii?Q?xDbtPopRIuxDyICMa5R1kMmuVpayDWhF4F3S/uH9SGBTTYxvmz8QQc51pwPx?=
 =?us-ascii?Q?A0wScFw+tyS7EsZ9lAJ0g7YWplUdhrIZBbY422sIQ+Rs+xUkj1aEAE2wYE9k?=
 =?us-ascii?Q?RyA0xkn+iC2b/uPswHCQrullo4kgFWOws0LtO5tXJGHV784Nq87bk4Jpedn/?=
 =?us-ascii?Q?nCT9yUzZQ8NSK5ZjGjwc7ZQTOFrVMTyiUp32NTJ3FRLHKG/P/DV6NMhSsDF5?=
 =?us-ascii?Q?Xi7hD3gA/NQPHzGDWp1IAWxkrDY7we564aIaRqv8GkvsRaxk8Hb5FcmjHHW+?=
 =?us-ascii?Q?nQnGkLwrLJAMEVxBb7RR77bdPjHgkK3dtYdWOnbpFAGK/mcuqI6eZ7FAPpTv?=
 =?us-ascii?Q?TU3AxAe97Mq071iFs8GZAUYmTfpqPv0WuvkMzSWnzSkd54XV/eixyLjvmYAE?=
 =?us-ascii?Q?ZYxxuTc9kS+/k5CPrUShsFKQPbP3kkhMzTz+GvEMzjjq/p+0AtIGkr+j2Jha?=
 =?us-ascii?Q?Y4V3kBZL1H9pCEyXQHz2BLaRU96atCkRarZmFppk+7zSR0wCYgj7CM41ikfk?=
 =?us-ascii?Q?MP6+DILpeowVOleiyIn0KAEbiWfD3V3QOU6lGPbYfxxguqvsM0s7787wTTy2?=
 =?us-ascii?Q?13rC0q2ulmurVOdTVooPuxT2Ml9BaTz19k00gSGedRfpC8Awgb1VtMcBG2Sk?=
 =?us-ascii?Q?3eGgT1/o1PZmcOtJQM33MC+q3CxB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nisbdyz4RShAXr+Y+EdMFbwgZHpCEk5iLQofzgIiAqHogBfaoEiKSgbAQzgf?=
 =?us-ascii?Q?UdE0YXPyVIkqk4e/LFKkax7Q3cqZ3SbmOMi5JPBy2Ag5ATAbXt/MaA0alhnY?=
 =?us-ascii?Q?oqvKj6ki5dh9WFSzt3fYTaNZFMpEbSTqOuqKPoVyHGcN/bRzi5Bl1H/4CqQ+?=
 =?us-ascii?Q?tBswbf3rYUXtpHgEO2EDVuG2APwqJ9qltrsXWC2DRDk/W8eBTEjl0zfKtj99?=
 =?us-ascii?Q?U/sliCgN5AmjN1d3e2ltokGMP9mInAjNzkLUb1GUMAgNP1rtyhB1/jeNJuh2?=
 =?us-ascii?Q?d4oVu64xAjqNBZjdnN1ofjBtPW7RL6GoZfIVpwC2sCeHhXAHfcRq4IEq9rAb?=
 =?us-ascii?Q?3lmfe628+BZUetzBceFV+wfAN5UoJnHECyJNYAVDqLJz7Is+jsoyc2bn1Vr6?=
 =?us-ascii?Q?Hq7jec0lOb+vY2MVlQR+BvlEUYuhe57kfAVU9DGxkdB+XUa54L4TYt7d6ard?=
 =?us-ascii?Q?tu9pJHo4UFSVB47kCjrZSLkKoP+VqeL+9s2TPpvpwPGbvzNE2Bc74u/lue5N?=
 =?us-ascii?Q?Lzy/81GbLyPGvQIH1tQ4p2JXgJyINE5WGxwlFkY3hJTXc3N6ZRLNJRG7NzCF?=
 =?us-ascii?Q?9P3UWtQ2BF526oWBJ/ZlFLIReIPCeqt8IGxn81ECzsm9LFURaWW50Dp+kq3Z?=
 =?us-ascii?Q?dgXWPuz1KvCQCW0RbBulLigx/FLzZKkriaqLemi1fmks56XnynEaVoPevarN?=
 =?us-ascii?Q?DKIVcEF5BbQz/dPfK0e4pmP/iaJTVAXBncHecFlzMiyIIH1AuHdFIjG9KeN3?=
 =?us-ascii?Q?I/4gOzCXlVB4mZEQvRdJ6T+lk/MshM4Vj4O0KWVrBw52PFBZFmak2ceZjeEn?=
 =?us-ascii?Q?7uoEJrdPpM0b8vrYm3UApmtLvqfP6rdWeZ07uSqufi+zCLL0jr1pq91R9bOW?=
 =?us-ascii?Q?OGhU0hB2doiPywWFi2nJi3hISH9wvF+B2ieH5a7S+DgTYI4lBNjCZFOIdT3k?=
 =?us-ascii?Q?nCXkzdJA5EatUsJ7cKVMuYXu3wwPrWkMXm2KvVS5fNn5YD/0AoN4oee+SJ0U?=
 =?us-ascii?Q?21u6PMHxM2pk6BuOE7O9VVyPM2ZwyuDIu8MRKoKmVcicrw08BHRBPiNCDgJG?=
 =?us-ascii?Q?FL0In7BdF2bbBBe6sI6DQ6L7LOMfXaNG1aMotNEVbF3wjx+EwUXRCdBEgyKt?=
 =?us-ascii?Q?r11YSkZwxaMn4UtIV/oct5SY0m5CPv3LKK0drfVbLfi3seujpMIKrsV8Yv5n?=
 =?us-ascii?Q?BZjOD6B5df+J6wDI5Iyv5ljPgXbcGeCEtiVROdiRNjkfkh302R2NhWe8eHZ5?=
 =?us-ascii?Q?HJA0Gx0jPn0iyiBFNkbz1PNlSt7MUEFPR4aOouXE8pbuOASEar4laO/6q+vE?=
 =?us-ascii?Q?D6DQhvfRJItxpv5HghZg142XE3PiG75TM39gnKr4yzb1zjd6y6cw0Nds4q7u?=
 =?us-ascii?Q?jeym72NFKpDAzHFTEMncsZdquda0eSMQg5pswaq5Zls/siZFTz/X/mjmLlkv?=
 =?us-ascii?Q?aFUkTny5EsB4s8C7oZjovkD5DIueAEJepbgXc3tPX5v+4WxMMXEXdc2clFW/?=
 =?us-ascii?Q?SjVm861LcEHy99lTUVSfB1Nnj/J+fEWWe1tvAN4D9QV4uQrpwduPVQb0gsDh?=
 =?us-ascii?Q?FEtaiSvI5Sti2J+W/TVRZK7Mw2TtPrg6/hYTc/o2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99367a9d-e9af-4659-ba50-08dd9833928d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 06:49:02.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44SfONMkx5fT76aqmbEGu2raEXKtg9z+2OMK6xBiGjZL1nrDExaA5KzHkvZoBsrQc5Z6UZDpPhzFk9ufqYPYcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> >
> >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> >>> is turned off. I currently reverted this patch. No further debug yet.
> >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> >>
> >> kvm_gmem_populate
> >>   filemap_invalidate_lock
> >>   post_populate
> >>     tdx_gmem_post_populate
> >>       kvm_tdp_map_page
> >>        kvm_mmu_do_page_fault
> >>          kvm_tdp_page_fault
> >> 	   kvm_tdp_mmu_page_fault
> >> 	     kvm_mmu_faultin_pfn
> >> 	       __kvm_mmu_faultin_pfn
> >> 	         kvm_mmu_faultin_pfn_private
> >> 		   kvm_gmem_get_pfn
> >> 		     filemap_invalidate_lock_shared
> >> 	
> >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> >> ("locking: More accurate annotations for read_lock()").
> >>
> >
> > Thank you for investigating. This should be fixed in the next revision.
> >
> 
> This was not fixed in v2 [1], I misunderstood this locking issue.
> 
> IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> part of the KVM fault handler to map the pfn into secure EPTs, then
> calls the TDX module for the copy+encrypt.
> 
> Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> held throughout the process?
If kvm_gmem_populate() does not hold filemap invalidate lock around all
requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
mapping it just successfully installed?

TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
invalidate lock being taken in kvm_gmem_populate().

Looks sev_gmem_post_populate() does not take kvm->mmu_lock either.

I think kvm_gmem_populate() needs to hold the filemap invalidate lock at least
around each __kvm_gmem_get_pfn(), post_populate() and kvm_gmem_mark_prepared().

> If we don't have to hold the filemap_invalidate_lock() throughout, 
> 
> 1. Would it be possible to call kvm_gmem_get_pfn() to get the pfn
>    instead of calling __kvm_gmem_get_pfn() and managing the lock in a
>    loop?
> 
> 2. Would it be possible to trigger the kvm fault path from
>    kvm_gmem_populate() so that we don't rebuild the get_pfn+mapping
>    logic and reuse the entire faulting code? That way the
>    filemap_invalidate_lock() will only be held while getting a pfn.
The kvm fault path is invoked in TDX's post_populate() callback.
I don't find a good way to move it to kvm_gmem_populate().

> [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
> 
> >>> > @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> >>> >  	struct file *file = kvm_gmem_get_file(slot);
> >>> >  	int max_order_local;
> >>> > +	struct address_space *mapping;
> >>> >  	struct folio *folio;
> >>> >  	int r = 0;
> >>> >  
> >>> >  	if (!file)
> >>> >  		return -EFAULT;
> >>> >  
> >>> > +	mapping = file->f_inode->i_mapping;
> >>> > +	filemap_invalidate_lock_shared(mapping);
> >>> > +
> >>> >  	/*
> >>> >  	 * The caller might pass a NULL 'max_order', but internally this
> >>> >  	 * function needs to be aware of any order limitations set by
> >>> > @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>> >  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
> >>> >  	if (IS_ERR(folio)) {
> >>> >  		r = PTR_ERR(folio);
> >>> > +		filemap_invalidate_unlock_shared(mapping);
> >>> >  		goto out;
> >>> >  	}
> >>> >  
> >>> > @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>> >  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
> >>> >  
> >>> >  	folio_unlock(folio);
> >>> > +	filemap_invalidate_unlock_shared(mapping);
> >>> >  
> >>> >  	if (!r)
> >>> >  		*page = folio_file_page(folio, index);
> >>> > -- 
> >>> > 2.25.1
> >>> > 
> >>> > 
> 

