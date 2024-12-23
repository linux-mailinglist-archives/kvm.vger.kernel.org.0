Return-Path: <kvm+bounces-34327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B9A9FAA39
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D93CD188435E
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 06:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F852183CCA;
	Mon, 23 Dec 2024 06:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/erazic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52B83987D;
	Mon, 23 Dec 2024 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734934719; cv=fail; b=esLxhumcsFc2yATTwLIy0ZyPwZZEmP+RnGRKFxNgvXvDf6pgbk8AhRiSti7h8x0kHvhXahaylZLXd73VgwJ+L/jq1Jn4a3NzZKfirER6l/GafUkrTD2034LOF6tATZrBR47hJJJB9bQ4ZY4PeYFuyMJmW9r0WHI6bpWbVD1n53o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734934719; c=relaxed/simple;
	bh=sDbB8HIIeUNEAIN/0GtRis1iZzinBbLiZB0Gqk79IcY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RKUKIcKkbrO+LMImz5IbCcoBVTvNfKZqIqaJnTjNWjG6EclzjqjRObSsnSwzQDgbO4RJZM5L0nShrWW8KL9d0GyHYyfGF3Nvt7eRB5f9XCuzQlBeUW0/Z0VqZLeVVluZVgh8Z0R0ins2qBe3czEhQGF94wSj9g/c4fd9Vqnh8CY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/erazic; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734934718; x=1766470718;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sDbB8HIIeUNEAIN/0GtRis1iZzinBbLiZB0Gqk79IcY=;
  b=U/erazicgjdexw5HNAoPlyVp9EWUCKip5N7N9OQzsBkuirXayhWWPcpG
   3ptvQj5lXu60s4Gt3CFOQnI5ZZsNYW61AbrX1/oz0d9bs/e8q4ktweQZm
   vAXv1zXsDjqQZcuHWLEOR7sz2iH2cub/fiawgQQLgDHxiyG06Eiv7+nfp
   MK7ShwptUghJ3AVnuYiCHG8WWUtNXE5CzUYmvV0Xpi3gXTshuYqOcnqAQ
   1msrPKSF9hYUYjimrB9YbO6N146DOGN7uZG5ELgWd1pfIprLTyXXGXMJT
   R3wpMaSKbpkaqOjShxqm8dFMWDMgBPtqpW8d2E5Lr2HjpNhqQyOlivdJ7
   g==;
X-CSE-ConnectionGUID: vjvV487SQ+O0IOzzGW1EVQ==
X-CSE-MsgGUID: hQ5C+ZGnSiSeR5s2x1XJiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="35612734"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="35612734"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 22:18:37 -0800
X-CSE-ConnectionGUID: YgfPJzbcSFqPUbNfMrcnQA==
X-CSE-MsgGUID: 1k9sDAJ/Qpu6HA/VHBzAAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="98982461"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Dec 2024 22:18:33 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 22 Dec 2024 22:18:32 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 22 Dec 2024 22:18:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 22 Dec 2024 22:18:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKQ1Wz6JqBCm1ayrokozA56ejLDcsl8EpqdSxTdVsDFHurCBy9g2+BnwFtv/4W1u/N7TSs6LBTdyQsFVRf+m0uQVsoYPjJ9OTvmck/Il9rv/PeNVmsCtCsXBFoF+Jn05L2/lHYZYXzpP2izvoKzVe99ISJkCg7bizGJ/lSzdMD0TXiJTYgG5H9WJDJeWEC2QTv8Ue03Snw755XsIOcnqjnFywN49O4StlpmRrsuN8rZVEyfMkw78ebKWXiqTpVAGrA134axa7C3nFMRiPPOJmj300/12n+4L4xdBHuDIxN11JP2kafWRYJKWA2tB2ECLEmJqBjseHuDR2CX8HQOy9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpQ3Ck1naiQ408Is7O93hVkesDGz4GR5cT9NVPFXorI=;
 b=qUFWE5x3MjmlknOdn2WVkMKWcn5hS3DSSrGlu5h0Wvz38TsPoDAhiKB/Q6EC97JjM1yJ6D633hYpt+KyAhTwryKGVKMtJv0oHWkCK5qsrz9MEoWiTRFeQFHBGU9Jw9PhEbh5LGRZcCKxWIm+ADS+SslSPXKP/1kUPWkwG3tv/fjrsXrHUtNQLtHP9I4DTBMZNKAN0kopIuS6GkjboY9QmQ+nu1yodmpft2+7RCS3oY0VBgatNFCuGVSYYI8lzAwWq0H4DPFabvV5VmXVxUyVkzewRH28uW4d4CHchT3d4VIgfc2Cbw0/YNAT2fFv6Ns4DibkGB06VUGG09puoXGuAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Mon, 23 Dec
 2024 06:18:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 06:18:12 +0000
Date: Mon, 23 Dec 2024 13:43:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: guest_memfd: Remove RCU-protected attribute
 from slot->gmem.file
Message-ID: <Z2j4lrOfeGDsd+R/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241104084137.29855-1-yan.y.zhao@intel.com>
 <20241104084303.29909-1-yan.y.zhao@intel.com>
 <fc22436b-6053-47d0-8329-d75cd748ea61@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc22436b-6053-47d0-8329-d75cd748ea61@redhat.com>
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 98ef82d9-2249-432a-b656-08dd2319943a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VEtfMzziva3/QmVJKWycHst7ncLJLxGqfAtKpv+FRVqKsBPWSz4CRq4JF0Df?=
 =?us-ascii?Q?OV0sS+fqxTi1Q35hYZwy+Pra92pnlf/rLY9k9FYVY0zwBeNSH+UBIEj7uFJo?=
 =?us-ascii?Q?GziNVoRleZ85lh/YzBiYFuEWsBu6zRMGq/hAj9xdjIJelNv8QWZxnvF6crsL?=
 =?us-ascii?Q?buuKrzzyDrp587UCPmZnsWG31eBVg+k7yU3rwctFEwTzwSN1cWLP4xnA2REc?=
 =?us-ascii?Q?NLnF88AP7Fl8bkEpc1zdmnVyZkxXVJy+mAbGy7KR8GFVLFnuJuKMAuIlCbTm?=
 =?us-ascii?Q?d8bP/UMb7lnnnHjguCDouoFLj2G0hsYh/tuk+Dxt+xSCy9eTk6t5WutzwXwh?=
 =?us-ascii?Q?OSD/F68i25sf/JFMPTMlLmQ/+wz5dNyUWVKE8c3rdXyu1GbifFEwHPN/sWiy?=
 =?us-ascii?Q?33xOYY4ZiGX4DievOiMwqskz1n22xQbXwUgdVJv+IEvZJZBXlGQYAqTo1JHx?=
 =?us-ascii?Q?YiCEEtOV7dENv3HotvshT5WW6lr90+c2nLC5QPSEuX959D6fZl4PnBVMvXI9?=
 =?us-ascii?Q?464EbwYgsZRFqd0C/q4l21FGlJHMfz7KPY5Wmbdz31tBVyOh+kTYa3sGGFz4?=
 =?us-ascii?Q?ZcPn23qTeRR0u98JjVjEDCrKkSmwvsnxwsGheKm8Cr1k0+kZjdxdnUnZxiA2?=
 =?us-ascii?Q?V8e8/btPsyq/QQeT0c0++IY8X5/n+UlVHane99vYV+alluU807DpIwID6Hv/?=
 =?us-ascii?Q?jyyZLlHaa17jQa13IlbFTW0Cx4Eb95a8MDPxf1mWGH53bV5ImTUujyE6bmxz?=
 =?us-ascii?Q?ZNYAvJ0zuY0LJGY7enrTmG1c5mnlGUIDIO/jLiCbo1/Nu1vNvxmdjn82kxFX?=
 =?us-ascii?Q?zXwFRNzE4I7K0pB31m/4tJl6MTSRFIFAWJ1+noH6/cfbjuj9rSXIo6vTm+6S?=
 =?us-ascii?Q?21dwA4KHcU/2pYbNHEwppR5Mx3LQLEWRThNDGmA8qDbgBv4q4lZEDeTQUIZR?=
 =?us-ascii?Q?g8n5ARWi/vCTvnRe47jqPwTY+iFORFj2vKMT1QP1ZLg1KIdrSbeB3lffFPU1?=
 =?us-ascii?Q?+3Ph9p7L52p0/5g1K0xZNiN5GcrynxjsoAGbFlnuERUSojDPXPTeODWHKNzj?=
 =?us-ascii?Q?cTMi2SS8q7zGGhHbXgmkeASO1eT445tMNEv0iY/Ri8OTdtQxJHziBqPiKTrg?=
 =?us-ascii?Q?aAzkeak7SB8DFyQa6K858OCxbqZEzwJmtRj2/MlI+iSmyPBN039uiK4p4hhS?=
 =?us-ascii?Q?0sb/9/e+23Kan1tMBy7+x+mwHc2PxpmQYPrCMFeXgEBL0WDz/WRv6jvxaxTR?=
 =?us-ascii?Q?b+B+crFoM43jpHqM//U+m6z5wRWoMelQuikDOrYp8R3FVEym0Ze9+b/A/U6G?=
 =?us-ascii?Q?HAGZbFHmkA631DYy+f7JWyjGO4fFO2or+WRNSX4ux7djH3ur5px+FfK7IVwO?=
 =?us-ascii?Q?LBkknJZv6FAwbktvrCg57EqikT5b?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzDR53y4UXrqYBaAkW31f0xBDhndx4Uc2U3/t6slNUFmysQ8OpPHreGHEJlV?=
 =?us-ascii?Q?2VbjBne95ChQJvmh36tZeQkAVjbdzFT9sqo37CVF8B9yRT3UgrJtvxqBnItA?=
 =?us-ascii?Q?qrz/huUVBLKqw8/tu6BNNBtXuaQKSdDWOookqr5rSClIp+ogWW4T4iKjwwEg?=
 =?us-ascii?Q?2/QlvS4P0ztorUbeXTdGBPia2WUdJWVWUGx9UZ/Hv9SCR2ebxZE6jET1cHfq?=
 =?us-ascii?Q?mZFKV/BG3lRUwiHAbtYX7Xw7qx5hfCARuf+9fZ0IrGmUu62AGmtDMmeCQnq+?=
 =?us-ascii?Q?KoJjk4atQoQ2XlFHYDhzuiL7lEHfN29GzbGo4tmYnLYP7u6SbtDwmrMD6FM/?=
 =?us-ascii?Q?awwhEpZD0wQFnGM0gR+1mayuSifbD0W12mIMotDrtWHS+QQMl9pcs6V+2Ep6?=
 =?us-ascii?Q?TONC0JSThmg2uPREEyRU9rYQIYJQjLF5Q2gMhMlKMvTyI9n/XIAUW7FcWjIL?=
 =?us-ascii?Q?eAYCA3eRWHrmNRs9gbArB+q46tx2zk8r4+yY50gleCBoW6NgABa79CeYCfYX?=
 =?us-ascii?Q?KmvlnrG+MYywXLhqO0uLn6n/7kzAh8pNFKTW3YQdJjg+XbpD7i6DtAIXzYEK?=
 =?us-ascii?Q?N4l2rw9mKlKuJ7552a8mmh8ei1N38Xf+m/HBgJdwJycxwJPes65lSW6R9BEf?=
 =?us-ascii?Q?Y+qVZ1ykbLWYqnSo8ol3yMue4gnIkRzrybQf6ZNmxR0zSkC2URu4Wjvhakp6?=
 =?us-ascii?Q?rybPysQrMaKvD+w04jS6TYvVfQP1cI3dUoC8XtF5BBlQAmnc2b+7tJ1wrHJ0?=
 =?us-ascii?Q?nxGDpUxjwKBGBFFIydTKO1Il0ABsgxXdZk6WCVmOnwFwqgVTHMunxejGWCro?=
 =?us-ascii?Q?RdzGNNco0G8SI684Ot9yUsR6JyrC/LUQ/Di6J50QPvU9WOAn+xrJ3BAQOR1s?=
 =?us-ascii?Q?wCFiXkfJShUmxaGyFjCvX8Rct7Q3d6BARxq8ZrdB+Ivp0gCvwaAHabyWYQnz?=
 =?us-ascii?Q?3nXAAhE52L2GJckLZDvEKmpRYyS7agaMm9zzbqE1NoGxy37rHSrcBgbKltxx?=
 =?us-ascii?Q?dLLwAtTXdJnv4L6/Rx+xmW8/zVTBI8XkqUUB0EI+1Y2FfJQ1EkMHo4/c4AtL?=
 =?us-ascii?Q?30QiA1uVmgcw+2AL8SJ9YVnwvyFAZ244ww+sOyUyweIjAba4GnuD7AIHwkMd?=
 =?us-ascii?Q?F4irRlqDorUcXImg9k6GKWVSRP2QD38e3Py8jT2tdhyC8TRT7kDEhMoQB65J?=
 =?us-ascii?Q?py/iRyiaomT4T4O1odyMW2XKzRzJVrFiRoyE5bN3lCQgweoYdWYwKqpCuWGY?=
 =?us-ascii?Q?2BN2GcH/RSjCMamuTCKEv2XmvjMYUA7sKrlWy2f8X38+1gw9wIKfIlKCM0L8?=
 =?us-ascii?Q?AOpWtMdhgAx1ozuluGvbpZ9M5R0wqxdQi7/sc03MHizuBx9xUWUjKbJv+bBW?=
 =?us-ascii?Q?WIKU9DnB1yCs872IlAlH/0G/xhieS1EaWBq6WSjaKaylvBXybGIKwsm35W60?=
 =?us-ascii?Q?ltXcD3nwXSkqP15fpz8QmoZ+82OJVdvxf4mVxtszL+es3uUhzZro7bVXnkz3?=
 =?us-ascii?Q?aHlP3/3j43Z7Jo9JukiU1awY5WYZWm4aPXE/dpjQxptvbLALy8oRU2MISY/B?=
 =?us-ascii?Q?SS8D/rZtOYyxOnSWyVle9wizKrXjUtndTTNCGZkB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ef82d9-2249-432a-b656-08dd2319943a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 06:18:12.5446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzhGTTPPhSCEhFiUe+yRnmjlCtuWi0Hlzo/W8A7wEcoWhjLPkBQXo5JghWiJCh+z9aoh6fWQEeeVr3guD2pooQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com

On Sun, Dec 22, 2024 at 07:38:44PM +0100, Paolo Bonzini wrote:
> On 11/4/24 09:43, Yan Zhao wrote:
> > Remove the RCU-protected attribute from slot->gmem.file. No need to use RCU
> > primitives rcu_assign_pointer()/synchronize_rcu() to update this pointer.
> > 
> > - slot->gmem.file is updated in 3 places:
> >    kvm_gmem_bind(), kvm_gmem_unbind(), kvm_gmem_release().
> >    All of them are protected by kvm->slots_lock.
> > 
> > - slot->gmem.file is read in 2 paths:
> >    (1) kvm_gmem_populate
> >          kvm_gmem_get_file
> >          __kvm_gmem_get_pfn
> > 
> >    (2) kvm_gmem_get_pfn
> >           kvm_gmem_get_file
> >           __kvm_gmem_get_pfn
> > 
> >    Path (1) kvm_gmem_populate() requires holding kvm->slots_lock, so
> >    slot->gmem.file is protected by the kvm->slots_lock in this path.
> > 
> >    Path (2) kvm_gmem_get_pfn() does not require holding kvm->slots_lock.
> >    However, it's also not guarded by rcu_read_lock() and rcu_read_unlock().
> >    So synchronize_rcu() in kvm_gmem_unbind()/kvm_gmem_release() actually
> >    will not wait for the readers in kvm_gmem_get_pfn() due to lack of RCU
> >    read-side critical section.
> > 
> >    The path (2) kvm_gmem_get_pfn() is safe without RCU protection because:
> >    a) kvm_gmem_bind() is called on a new memslot, before the memslot is
> >       visible to kvm_gmem_get_pfn().
> >    b) kvm->srcu ensures that kvm_gmem_unbind() and freeing of a memslot
> >       occur after the memslot is no longer visible to kvm_gmem_get_pfn().
> >    c) get_file_active() ensures that kvm_gmem_get_pfn() will not access the
> >       stale file if kvm_gmem_release() sets it to NULL.  This is because if
> >       kvm_gmem_release() occurs before kvm_gmem_get_pfn(), get_file_active()
> >       will return NULL; if get_file_active() does not return NULL,
> >       kvm_gmem_release() should not occur until after kvm_gmem_get_pfn()
> >       releases the file reference.
> 
> Thanks for the analysis, I added some notes:
Thank you for adding those notes!

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4ec2564c0d0f..c788d0bd952a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -602,6 +602,11 @@ struct kvm_memory_slot {
>  #ifdef CONFIG_KVM_PRIVATE_MEM
>  	struct {
> +		/*
> +		 * Writes protected by kvm->slots_lock.  Acquiring a
> +		 * reference via kvm_gmem_get_file() is protected by
> +		 * either kvm->slots_lock or kvm->srcu.
> +		 */
>  		struct file *file;
>  		pgoff_t pgoff;
>  	} gmem;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9d9bf3d033bd..411ff7224caa 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -261,6 +261,12 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * dereferencing the slot for existing bindings needs to be protected
>  	 * against memslot updates, specifically so that unbind doesn't race
>  	 * and free the memslot (kvm_gmem_get_file() will return NULL).
> +	 *
> +	 * Since .release is called only when the reference count is zero,
> +	 * after which file_ref_get() and get_file_active() fail,
> +	 * kvm_gmem_get_pfn() cannot be using the file concurrently.
> +	 * file_ref_put() provides a full barrier, and get_file_active() the
> +	 * matching acquire barrier.
>  	 */
>  	mutex_lock(&kvm->slots_lock);
> @@ -508,8 +514,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	/*
>  	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
> -	 * kvm_gmem_bind() must occur on a new memslot.
> -	 * Readers are guaranteed to see this new file.
> +	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
> +	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
>  	 */
>  	WRITE_ONCE(slot->gmem.file, file);
>  	slot->gmem.pgoff = start;
> @@ -547,6 +554,11 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  	filemap_invalidate_lock(file->f_mapping);
>  	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
> +
> +	/*
> +	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
> +	 * cannot see this memslot.
> +	 */
>  	WRITE_ONCE(slot->gmem.file, NULL);
>  	filemap_invalidate_unlock(file->f_mapping);
> Queued to kvm-coco-queue.
> 
> Paolo
> 

