Return-Path: <kvm+bounces-32710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E209DB1A5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36581163784
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813D47DA9F;
	Thu, 28 Nov 2024 03:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CayuTlIC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984B0323D;
	Thu, 28 Nov 2024 03:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732762860; cv=fail; b=gXv5GB3DSTyzj3ywBac+tdSgnUfy1BpwtPWtyeA/0ncF/yLt/br2PPcgB56njeHUMxOAuXGT7HISmRtm1XFeaVi3SQVqyFJeuOHDQy3ZRO58IQ0Bs0gi9D9uiRlMvs/YN62KbXVaLwUVKwhBGMaBSJ2AqoBbCAbiXn0e1K+0o5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732762860; c=relaxed/simple;
	bh=6gPKvdrf0dK0kzvjo9mrwqRQo0KV2IWtFqqccRl4eLs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XUEFJzozl2rPVtHeuVb+mJWZzQFyZD1B1PPtS1XqNIA17uvBZ2+C6e/bWb+xxL1gXKlwyENK6CHmeci8jbjJ7OfV1xw9QB1S3+LyV0WCjo1s9tTKFAg9JG9vbowJwg0awszkeJK0qm2E5dAvzDxOwcxGmeailRvNlDYA345I1A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CayuTlIC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732762859; x=1764298859;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6gPKvdrf0dK0kzvjo9mrwqRQo0KV2IWtFqqccRl4eLs=;
  b=CayuTlICgGES9zxslwwOP4oDAYC9n+7pNSzb724atEeuh8XoYtsxOMvv
   lzQT76X9wVrUp5LYulBnYma5hv/qNgPgCLdHZwEAtHKCrEjZ2suv8wOMj
   moSQ0bvmAXqqiBFJufDF6ZGaXWfTHRIO/bJg805CPZUJD4aIJcdO9Ic3b
   /3irptUiRcYlW+WhdMTOW4CERXITgz/Sf5HFRgJElLd0JaeQcQgtZtCr/
   c/gk4KVn/4YxIO/pk+E0OpZDARLavISv0hHR6qGj8vKvDVCDNqk+eXLyj
   Vye0ZNXZb96sNEQVrEY15uJ3eJGj7YavvHWoQNS+ssVq3xn8TcCdo6juF
   g==;
X-CSE-ConnectionGUID: wMRjsCEeQcmlcQr0AZZVGg==
X-CSE-MsgGUID: OVEGmQ+5QXuD1c6/zaEuGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="36912525"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="36912525"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:00:58 -0800
X-CSE-ConnectionGUID: 7VJhC1taQNKZP1+38ST16Q==
X-CSE-MsgGUID: dWCFMcjrTG649cmnoz5Miw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="97194287"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 19:00:58 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 19:00:56 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 19:00:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 19:00:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2PGNpwVu1utJYcE1GmmZyQV40OQxHh3YQdzXtXrxGc3K1F6D+djy3VgJtHbsOI/hE/iNzy90AMOKOfBlYCpBPU4rrjJdEnI/sqhVR8TC3jExmOTFuzQlf1/B4AETZD+ejZRNa9Uj2WtI23jn8tGz3C0zqPfYL2HwRCEM5VoOp5hexOTgQh78MraqCCwNOhLQsxXJmF1cgJC09PWcf2WtmWxcv6mMMPS/ug1xv/A2IT4SXiIXsvFWmGz4BbYpA4kR57ezsp9o94vmN5KWtNQA8QVaGRJKxKfqEvHpEM8dEBrw49OY/Y2r4yoMg9PqbK8RJMKLcHDOzb+4pbKdO34lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quBt1ZB9JypwXitj2TtiXAJbpNHRrL2VxCkXuAqTRo0=;
 b=KgkL3fx4gDdFgK2H/pRkj3x30iYUC+fq25f7bjRxn5nkyayiQjaed9SvqK5bESJhXZ8PySqNVu0aoUynSBBiFdwQc9ncGqi3Z63PkCK8Ew5C5mPxZTEMQ9OX4bTnTiQpDmJiaDn6XCW0FI8Q3m9XZoy1yQh6AZF0Dvt5qYOjkeV2MkFJWpzTXAs6juObJ+HIQlDWNyaorer1BNL9jUpxQnDcrofdg0pQ8fkei6Xa72eyIj3FofbO0LwedMAlxjKRJ4Zkhh2j4ChpnABGIiyb+MYa0tMGmX2h+I7oo6W/LW3Dodt2LAVyZyrSyeU3jSptx2uUrmbnyJGN7wR+JOMtQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Thu, 28 Nov
 2024 03:00:53 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8182.019; Thu, 28 Nov 2024
 03:00:53 +0000
Date: Thu, 28 Nov 2024 11:00:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Message-ID: <Z0fc3Z6YJB20uP3G@intel.com>
References: <20241127201019.136086-1-pbonzini@redhat.com>
 <20241127201019.136086-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241127201019.136086-4-pbonzini@redhat.com>
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: eb8f5539-3101-428d-95f4-08dd0f58df7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gDFAV+WzQ3mFj2H/N1k6Zd9qpyfddSEfI/gAzsibj8b0ypnBUxtOKvuqIg+D?=
 =?us-ascii?Q?YfX40vz4qUf3rPoDjj4Jq04UUgYjhv17VKDEdZTo53yn9FnPTCQUeww2ZWto?=
 =?us-ascii?Q?dsXzrg0s53thkosW0JL60q0kK3lP1amkHVEtNu4rm87C2pRpwqrn+BBkKJCl?=
 =?us-ascii?Q?553xXHQ/WCINHs/VDkBKCOtZdBAS4sFd2mTFwptbo1qJ/bpiHRM8fg0prsvi?=
 =?us-ascii?Q?+WfvBx7NROMGQaKN7nJoNdGIILL/GFuVCKbj8yEemyfePGOA2b6WAnfb2nF9?=
 =?us-ascii?Q?aqGFG5yR57A150qM2Ixuo44y/LoAzmVp+WWfkd5XuqEzsyYk3Q70W6oDynew?=
 =?us-ascii?Q?ZORBsJHUeNVm4iIo1YZyZJ3+p79/OhFienQ4vuyxmCS6+c0ajmkNAp5SfJKN?=
 =?us-ascii?Q?Ne4H3h0AyiiwE2CjCVfiNqlcjmKyipQ4kSb1VRgTFYLrokrLzVCKHqv+BK0V?=
 =?us-ascii?Q?kVEhHp3Tp+lddqaxQTy3mgefn9x+74xcniay6Dgg9JDpm92Ida/DYntwJrEt?=
 =?us-ascii?Q?tA9TgZOC0mA2fZDcmxv2v8ogHS1+EHEgG2aBWATZLRJiZjXA1/2q6G/rN7/n?=
 =?us-ascii?Q?Vp0JBp8Gbf1o3L5n4aLNIvlhMUUwnPiKh86Roz4xe2ZUUh6UvgRydFduh+mx?=
 =?us-ascii?Q?SN4UOfGyzLuG+408fqayvf4NUDAbGLDRmoRzWjR/NZ9hovIi6kOtid3L6g1V?=
 =?us-ascii?Q?wk3Ke7hpJYLDAmCgcqGvb3dNvvCil1Xqx3kd6E9105y1DvG7ke+f03QCkXyl?=
 =?us-ascii?Q?yKIy6WVi1AllwYS3DgTbVS/9i4+o5jrsOHctQLXge5S0IhFT4GV0FcSaAUMS?=
 =?us-ascii?Q?c+avOZskuXXOfvnQXfHRHUj8yBB2hVu+vJnBm/1VARIZFm7XXStOgzL2S4Xn?=
 =?us-ascii?Q?vgL+ALbZf7jNlWO7y4Y/Xgr/RgpKV6XvTVP19O0mBMAFEFbHQtN6HMhUoZCe?=
 =?us-ascii?Q?j31r9JdwNZKKchm7QRU938UoGi64V+dqMyx027FRrxso0E+OIiWSFh0BWu6N?=
 =?us-ascii?Q?dPToC5+R1ut75lZdkvNRgiypIHHv3JdLsMtbatI5xV+C31vfwB6rU+RFJ32k?=
 =?us-ascii?Q?Iudki6qdJEXlqohQkE/3rA86OLtJSQ0rVa3f50+u3i5pSi7cWMqoPuObK0ku?=
 =?us-ascii?Q?erC9avroYeM04xXdys8hyLJKH8HQz59oLWKfEiyEFvTi2jtyGvPwrW4T9l1C?=
 =?us-ascii?Q?XcpOz1hc3JzFsRRFSU/N20sBeNp/ynxbZKpdmsFCp55dyduBBdM/u5Xf0qmm?=
 =?us-ascii?Q?+RiJDyiVTFz08Q0QOOXRW5pgoRxhIqFEzcEOikQQOljznSNIGbd2yYXQw3qV?=
 =?us-ascii?Q?PBakOg+w9TY7hJev199SMgmsJnep4TBqOuclsf/r5G6r1Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R8kd8Md/e9DfiJ4pnOBB8oj5aWSZvCsIl93LYiOdrp/Wd9GP/mSC/COEgR21?=
 =?us-ascii?Q?bFnSCBptI5PkQLeVxk8RSnqwJIUHjOsleVuuHPNP0u3je8CjeLw1qbovb/Ze?=
 =?us-ascii?Q?XoCE6H870oyG7WrVJlx1dAMv1mCt4t/ZbtEhiy9SjC8VkpKaimUDqQ4MH6lh?=
 =?us-ascii?Q?zfO+8FuiCy7B2NpPRoj30xQOrADh5RYiUsC6RO11Ej3FM732URpGYBNSgh2y?=
 =?us-ascii?Q?FI+dh0s4VOPp2Ams3sWRK9Im1Z7OGB196oUskN6frzlnCZoyBDOqxWQ2xW4X?=
 =?us-ascii?Q?BBwV7KW9uEne7ukaSt3i7upLXwmdWivRljh370CaLyCsutctBgpdpDrmbSau?=
 =?us-ascii?Q?m8wf6Ru75+OJNExxtB5BK8gxqIs+F3VmQ39fjHfrQ8KNZZG1MKptYjQ4c2+0?=
 =?us-ascii?Q?2v0F9/kDkwpJM5yWD/DPjGxTAKh9Q1GbOKgMc1b870WN2aIks5iOSn73iHZf?=
 =?us-ascii?Q?lV4GuP1YXU2r76LO1i46WsuEWARFnAYowpqhHVJelmCCgplbvwTGgzR71aCX?=
 =?us-ascii?Q?JJS68KaWv2ZHIXsV4mXEbHMT88/6ZPdZkkZCO07TmiAnuGyFsqXZv/TX9LKp?=
 =?us-ascii?Q?6Q3HFLueDXdkGYFnOnwCJx4b1s1YCvG2ZRr0n86Ht6tHjoOMO+DpLVtdT+vG?=
 =?us-ascii?Q?BFldmof3PH/tPD673iYRrjEKo7XtpFdXo8y2W0VcgHM/USP6WJAdyxn0SvVs?=
 =?us-ascii?Q?c2rSKEbwjWQuj5wgGvtTP2PGrAA3RHEcMoZwhEERbzzZSAkYrhLJxW9GBxfb?=
 =?us-ascii?Q?EDAVPzT8PXGjTRr9fPoS79318LVoUEAlg4Xyn6RHvD79cBd3tOWnncsbYXy2?=
 =?us-ascii?Q?ySxY5iXm1Yxe14n4gqUsy2NWk2JTIpNA4A0GuBfWuPeZPwVmlhzeG/jTT2V7?=
 =?us-ascii?Q?EUryrswMVWlKjeniu2V8PUylOPfCFt/aMhGelATyWF0KNOdiXXVAbxWYyluN?=
 =?us-ascii?Q?8hytEKHhXhnSd9DemermxULlypYaSAx89YQrS4tDTepzKZcy1NEDSvKiwAqW?=
 =?us-ascii?Q?b/y2A1rPeIreMSMiprLOj0py9qyVyXS0NOTWx03gj9md6guvTIJaATcWzXjj?=
 =?us-ascii?Q?BhMMULNPK4mhR3DgzgmjGQ7pzgUNL8Z2NoaPxshcbR7r6oqDAWd4rMdjE2Lk?=
 =?us-ascii?Q?hOR/Ga/GWGLuswPt5l2Eq6ccO/lhXk5jUJfPg1aCS90uphN+B5CB+sclMULS?=
 =?us-ascii?Q?mIJ1PSVJaauOAbnaTJHE57lqjmMFfvMI4DQ46BQgkbWmdX4DZmfhA677tmeD?=
 =?us-ascii?Q?Vw1hPv5rNY/96MrrTnm+ovU9OBHjK3SXwEqgjREwbSCOP5tpsREgEQCJ2+TJ?=
 =?us-ascii?Q?seoP7OMM87ZSQjvA4unNjjQh/4MYc462rKz8Kicrl61NmNVdvQsm2pAq3nxY?=
 =?us-ascii?Q?hBdYAp5+pBvVNXV5qmratn4aEnqhTIY9N96Vey7eTEO5y6NMq17SCmGLXHFw?=
 =?us-ascii?Q?ywWi0rTu275vcpk7jUmqZru/3LaEQWm0uBmDvAFoCiNAtNKUjLXA7wBAn+GF?=
 =?us-ascii?Q?y/huX0fPuSClw5N+7ejKBoSObeP2pSdSN5syedxpXY0XPPdUnO6S1CS+561A?=
 =?us-ascii?Q?4M/eav6z0+UJyJF6CBLRGBVqfue7FBkeEya0MoXw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8f5539-3101-428d-95f4-08dd0f58df7e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2024 03:00:53.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JC+dp/Fa77fised13O7zi4EPXrav6dalXDe5NXpVQkftMkL0rkHS+rPKGguDENs4sE3+QnpPz96S5OFzvUkowg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com

>+static void __do_tdx_cleanup(void)
>+{
>+	/*
>+	 * Once TDX module is initialized, it cannot be disabled and
>+	 * re-initialized again w/o runtime update (which isn't
>+	 * supported by kernel).  Only need to remove the cpuhp here.
>+	 * The TDX host core code tracks TDX status and can handle
>+	 * 'multiple enabling' scenario.
>+	 */
>+	WARN_ON_ONCE(!tdx_cpuhp_state);
>+	cpuhp_remove_state_nocalls(tdx_cpuhp_state);

...

>+static int __init __do_tdx_bringup(void)
>+{
>+	int r;
>+
>+	/*
>+	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
>+	 * online CPUs before calling tdx_enable(), and on any new
>+	 * going-online CPU to make sure it is ready for TDX guest.
>+	 */
>+	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
>+					 "kvm/cpu/tdx:online",
>+					 tdx_online_cpu, NULL);
>+	if (r < 0)
>+		return r;
>+
>+	tdx_cpuhp_state = r;
>+
>+	r = tdx_enable();
>+	if (r)
>+		__do_tdx_cleanup();

The self deadlock issue isn't addressed.

>+
>+	return r;
>+}
>+
>+static bool __init kvm_can_support_tdx(void)
>+{
>+	return cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM);

...

>+int __init tdx_bringup(void)
>+{
>+	int r;
>+
>+	if (!enable_tdx)
>+		return 0;
>+
>+	if (!kvm_can_support_tdx()) {
>+		pr_err("tdx: no TDX private KeyIDs available\n");

The lack of X86_FEATURE_TDX_HOST_PLATFORM doesn't necessarily mean no TDX
private KeyIDs. In tdx_init(), X86_FEATURE_TDX_HOST_PLATFORM is not set if
hibernation is enabled.

>+		goto success_disable_tdx;
>+	}
>+
>+	if (!enable_virt_at_load) {
>+		pr_err("tdx: tdx requires kvm.enable_virt_at_load=1\n");
>+		goto success_disable_tdx;
>+	}
>+
>+	/*
>+	 * Ideally KVM should probe whether TDX module has been loaded
>+	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
>+	 * to probe whether the module is loaded (there is no CPUID or MSR
>+	 * for that), and making SEAMCALL requires enabling virtualization
>+	 * first, just like the rest steps of bringing up TDX module.
>+	 *
>+	 * So, for simplicity do everything in __tdx_bringup(); the first
>+	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
>+	 * only complication is having to make sure that initialization
>+	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
>+	 * cases.
>+	 */
>+	r = __tdx_bringup();
>+	if (r) {
>+		/*
>+		 * Disable TDX only but don't fail to load module if
>+		 * the TDX module could not be loaded.  No need to print
>+		 * message saying "module is not loaded" because it was
>+		 * printed when the first SEAMCALL failed.
>+		 */
>+		if (r == -ENODEV)
>+			goto success_disable_tdx;

Given that two error messages are added above, I think it is worth adding one
more here for consistency. And, reloading KVM will not trigger the "module is
not loaded" error which is printed once.

>+
>+		enable_tdx = 0;
>+	}
>+
>+	return r;
>+
>+success_disable_tdx:
>+	enable_tdx = 0;
>+	return 0;
>+}

