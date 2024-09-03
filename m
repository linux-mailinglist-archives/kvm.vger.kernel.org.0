Return-Path: <kvm+bounces-25695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D459690A3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B1BF1C227EB
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BF44A3E;
	Tue,  3 Sep 2024 00:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CMPZW0+1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95DA32;
	Tue,  3 Sep 2024 00:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323226; cv=fail; b=K6YqwWM7bEf20DZJDQWUk8hpY5vb2TI72WoCn8X+436Bcxf4VGM/JGFC+oAAi3XNhPa3nhiE5LrSielBOMT29GbB6VIUA6jJNLiqHwU04NNVWPpHCp/ObQHoi/mURsWdlqReSu+zcphdAJJ8uNzjUOK/wxHJAT+EPbtZm46+g/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323226; c=relaxed/simple;
	bh=CKKSHz6FzkTYkSEYSjFqc3zR1T8DJsjVPqi4oab7uAI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qISZ0gc8YmleFVnGe3+1MJ53o3RnySve+ehYQpjh4vo5WblqZKPQtooDIkYwHHPpRs2+fyBpbwAiwKhdu+ahK58B4P44JqOcByisRiO6S7nVnYi1NzLC4JvL/usUy7wQOO4C9Z0rXnZRPL0m9skl+9zpBQbX+nwMz7a0spoqThA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CMPZW0+1; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725323224; x=1756859224;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CKKSHz6FzkTYkSEYSjFqc3zR1T8DJsjVPqi4oab7uAI=;
  b=CMPZW0+1i1/ws/ak9KR01j0UNMgSuEPYgjGba5UNwPyhtSPATLJ9DFDJ
   lbVWZ3X13SFti1NhnfC80Wm2ozy61n74gRKRfpyz1M8yFnmUYAU55tGCV
   hmEjuphw5W3HvI0lYzcOE1ZBpcnDy5MBid6WJcPc2T3e2XR8pHTOgX6e+
   PVcnQL4IOMU+XGbtTlpJ3m3Jh0durpJcm8n2u19UkBTvttBviNnVUoDUD
   45KBVwvx0AYfuHiK3dQvgxQD5c5xgoeGYyETozUavVHZo3arWDpnSexLS
   EjVEPGhMPXawi9SzV6/M/+nqbNprdGv0+e71bkcVjeAIAmEzZffz/1cAX
   w==;
X-CSE-ConnectionGUID: isdDH2thQl2b+1PQ4kMGqw==
X-CSE-MsgGUID: K4jAFrJ4Tz+yNjSPqXT8Tw==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="26813509"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="26813509"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 17:27:03 -0700
X-CSE-ConnectionGUID: 7HkLM2IOSpajRz/zCsy8jw==
X-CSE-MsgGUID: KgOmUyOLSL6dgt6GrL46hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="65455635"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 17:27:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 17:27:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 17:27:02 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 17:27:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X89XAIR0L6YIzTrr++HxHrV/uFtmynnsuhd4Nx1G45xV5Q5qY0d1TZQBQmwkvoahg/LuysUxOADF6ksDcujHYcLuKszzHhER0h8yYh8H1+lTpdYSAtjTZo7gUdUOXN2jPkZIuSvrsTSwwf+3WDVmthSpqPjs4bLa1esNaXmgNqgr1AtDa+lgZM3wKR0I6MONxQok+glWeQtnZL54WNKj71mlygc1f9IN2cXUzXawFQX6RKBRA67S3mnKp971O9PRCa5gem6+FYGvZ3BgmjR6sAcFDNPibzRLysd/grjTvqL26zLfNEUVWb9TXZGXMV0I2WR2i9hulNgwGm/cDhBrJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTgHN72J0CBpDCSCi10GP2kto6nGC8Fp2J3tFlMGHzM=;
 b=Sso+8nDowqrYj1izLfdouXa/A5XDYKbakGg363Qb0t/e4jtvijMNVVCsjmKOHf/0VWJQ90a3tTrfAnO7Y1VFZV236ed0bJjJkn4Po4ObZK91bug2Y0iEDcCFuOt8/trJ9bL57ju0/daDm6Bn9F1NS4co5bOjusS11/Hj9PIMjcXofQCwRo28U69YS0X1DAUrVe7ClTO0pBUeZce8A1HWCAsJPxznb/48hP63lRQLkMhrl1cWAU4wjdOP5Gz1cWljEI7gfYjAxSMYe2nRzKPqn46UfRQ5sklj/NzWMV14zyQgDne7x8eNvTSe53Vu6dZj2hYRSnxssEvAfoiLzwb/mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8441.namprd11.prod.outlook.com (2603:10b6:610:1bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 00:27:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:26:59 +0000
Date: Tue, 3 Sep 2024 08:25:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann
	<kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, "Lai
 Jiangshan" <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZtZXYBVYN8agqh5g@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87jzfutmfc.fsf@redhat.com>
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8441:EE_
X-MS-Office365-Filtering-Correlation-Id: 05e0fe02-4025-47f5-a07d-08dccbaf2001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S1i1jcGigIUQQDmtWbfQ9lfG8NmLzPpMKrRdCrDLe6LZrFS2n9vFI+RcX1DK?=
 =?us-ascii?Q?6DrUU6EfoPpE89mTi8INvfo7U5322WVhOeCVKObau7TtHGbGkZ+BnohMK6ag?=
 =?us-ascii?Q?l8HqmMyrRgAL6HbQhkfmDqn0XXQLdCaqwO493LV22GFWZSWdi5o7y/tMUy8f?=
 =?us-ascii?Q?PFF59i/UqfPZPQPOynZWGCM7GLD4hL2BsdrOXhV6nNuzAeNsldeUO6Yjyfok?=
 =?us-ascii?Q?MMIJ/qtG8FqOSamXTG92sHBVnMMzs2DhE+Zlqirr6KtnibX49+yVh1+K2+LM?=
 =?us-ascii?Q?zU/eqTnUT6CJseg07xv9u0w5cCLfUxnxfDiHM5qbuhLHvHG5oGRAPgkv/U/z?=
 =?us-ascii?Q?JA5BMXMth3929/4WUvRFzY2oy05/8sdkcugbBMa4C+Y+ROH5L1NOFPrmB/8p?=
 =?us-ascii?Q?nhuwdyhk+sPwIsCpom02060SmyUZ698vsGUeMB972WhLFgLY/acT5npKCL9b?=
 =?us-ascii?Q?Jpu2T2zEvExFM+t1uQzXev/AI3O2WzLNzR0M16+OQ/RTMG9P5eOKtqlP2stJ?=
 =?us-ascii?Q?5O1YnJQgrbxILG0s8WeacOLVSVMMLqpe3wGUWP0rkGRHUL05f4YVVLtnk0vp?=
 =?us-ascii?Q?xQpLsJbCrj+WzY+nEQwNc7DKvg2Yb3kcSVjxXkRAh/dbiiiyrLNN31QzMKiI?=
 =?us-ascii?Q?0D4mmP1IrpgA6/HbN0hvYptITVxmDVNFTwVumJda/VOM22isXpIVum7EgbQn?=
 =?us-ascii?Q?kXmjGaVT/IPdlcYGaVafqxGGRlz7KV2B8cOAmhWelWdM4Ofuj8y/afVfLCBL?=
 =?us-ascii?Q?1EyBExW6HdhyoLummNfW+iruURa1VaIYIRgm1QLAo2hKitV016FDEq0Ful7Q?=
 =?us-ascii?Q?+qgz4fBjFIkELEAtTw1P5TH+0lT8VTbyRkye+O17iY5Wzi4OGodt7f+ic+1l?=
 =?us-ascii?Q?UBOjkjD4pnCiq5MCwvhZM4zvyIa5dd2C9R6O0JIPF+xdDz5Y2XC+omx/qvMW?=
 =?us-ascii?Q?jmFtz/dj0RD3lArUgIgwhGXZtSuiTpPlaJhrM/2VqP/jyzicvcbxX8U8UEEW?=
 =?us-ascii?Q?W+8ra7B7pbvAXAuAEVWw4vnIESN+XfLtR+dP/LA8Y+S9luCTzpHRhJ6c9P0n?=
 =?us-ascii?Q?Pl0PxFXn1eSY7Y8g9kZcHSOwtFdV1prIC6w6pbasyn80YnWUHuwZ8TNUiUU0?=
 =?us-ascii?Q?ZlE73AOK6WGDMR/2mjsAPMphSyB4ajydw/YiR0XU1SnGdK+kmPQojdvihdrk?=
 =?us-ascii?Q?6MTxb0yDVUFhslhp3ngRv+fx8LKlJA609kxj22eqzMOd+MV3KyGKs+NNWoct?=
 =?us-ascii?Q?ZGAGY0AkDvlVqjvhjNkzm7w5FhhuLm0nRa+xiMDXbZksmFrFAGlT+jR0AHgd?=
 =?us-ascii?Q?/28=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfyQErlP9eQ4B36qRQUQE5UQxcYqXdxZY8+BSLgmuNK+Y960A1KSmOJxpedu?=
 =?us-ascii?Q?TCDtX3G1RIIynZb4mwOQQFo/XnArY6iGC+ncxFEiv8CmURW0fzoTEMhCsoAm?=
 =?us-ascii?Q?SwZc1YnLb3JOtXSbzYFALcFvAqda4vGE6ZqwgtycXiCsjKJrGKeYkKaYA5g1?=
 =?us-ascii?Q?hV7ZTYXhKzEEaspQETs5KIfdMQVMC0hunk+inf3PaUQ7Rr4j1jT9OQiFispv?=
 =?us-ascii?Q?VHpokVJe2X8l8ThtBBsEF8msn9o0FSGmfPhMwRIGhukp0VNtC81MIsL0hLky?=
 =?us-ascii?Q?z1zybD54rG03xe3wshV96p3KKGMd9Cm43d1gjx3d+uE382oGZcs4VxGCxHGa?=
 =?us-ascii?Q?ZfcT1KWm+Tg250hO7lzmxiO4KRvR5s8aV6OhuO0kS82t08xt9nlhwjW2dzFO?=
 =?us-ascii?Q?6wZPmfL8+qlDJMRBQ1fEvBHTJzMTDIuB+Ns1fvBdQ8KY1yG44UuFRBp+Yrbo?=
 =?us-ascii?Q?kIOsoCNMGeuoZHVSNjs1Jf7hdeZecoaUm2Y8XtjEG/P6RfsNcWkpCmNV+cVj?=
 =?us-ascii?Q?HYNQHgcQ19kwuaYDanIkhUF/BBrKluN+pj9mrm0Tp/WdkpodskB798c9FlOR?=
 =?us-ascii?Q?UzOrG92tW2mBLlHXTvmnzsR0emGt2fSlihtCFNcn1mb/nMr13g9ujYTYSXAS?=
 =?us-ascii?Q?S8uapMAhE7baXLmLpY6Ir+AeAhK0fx7nbfTvK6tFWXUCWAlxqtvKN5ZivX2F?=
 =?us-ascii?Q?7MZKaJECQQ73eqgoyi7+B4JxXIx0/SS0HtGnbCDSdz0FglhGn0HMM73gyMd/?=
 =?us-ascii?Q?m0q6pM1Abx2ZbiW+h0ICeTHCxXOPgY/48jXdY75okl0TDOhy53K4aakLz/Wu?=
 =?us-ascii?Q?i7OdZrfF8zF93JLaq+Fq/nZGdpGrCUptFVPmrLJ5om9xuzTBmbTUt0RfnxV4?=
 =?us-ascii?Q?rByo+/4g4pmprdXwN9leslnoITl2MNvoagiGb2EztrPn9iS/VgZWnalzAHG0?=
 =?us-ascii?Q?Xcndkh7K2Z2lLqKIRck9JLCW5UTGoPqaimw3VsRLrRVYSU3trI+YFI7m20S/?=
 =?us-ascii?Q?7OQqYD8Ag9DPEHpbqD0k47cCdZZuivVCMAUdvOIUCahUblNyOGESuICmwzv4?=
 =?us-ascii?Q?iIl1wDWNAG+3CsXIczHjw7mcQtRNxbKuACr0jm6hGMGXQ4Qw2jRuPdnltMNC?=
 =?us-ascii?Q?GUVINUlLWuVA8I+kudra+fXGM42o8aSAbZYDAICHnsgakGn4ExKpVXGHksIt?=
 =?us-ascii?Q?WKbe7ZpBk12TVsH5FgG1WgPE6NDgI+9V7tqJ+mN6Xl0lNxaY04VauTHLKTAc?=
 =?us-ascii?Q?PWxsADPmthYEZ8o0zs1WbUUWeycMCCyeo35GXvTG0/cvicEtKxaSqBrggZzV?=
 =?us-ascii?Q?AGHybV+LZM65vm66yr1jEsgSDvfRYmr4zhPZjGnIlvmpFmid1RAA32EL5dLK?=
 =?us-ascii?Q?cR62RStP0oIP5OwFt+L36Zbr+JL4ppS9Qxq9UT6FQqcpRSlcpegQDqVJxUCE?=
 =?us-ascii?Q?rMzPOGbE7CR0lIbCpZpezQPNKeMU3Dogxzf53I0y1AzhMQsxfr6lOTgP27I9?=
 =?us-ascii?Q?XrHB50/7FS5C6vhY935UpNBp8yDMGg7yJ1RKt7l4bhcfv490qu84fhSh4lGX?=
 =?us-ascii?Q?xBeOqZKAE0Xa8AlHIKAiRTi7LGTIKWGuA33pui4z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e0fe02-4025-47f5-a07d-08dccbaf2001
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:26:59.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRC383jXFecfdLvj93boylAmU29aTsvhzxA2MYnBPIvKRKQqg/gw3+fcwAWVvC1lnI299ePDM3FITsH1MbK34g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8441
X-OriginatorOrg: intel.com

On Mon, Sep 02, 2024 at 11:49:43AM +0200, Vitaly Kuznetsov wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Fri, Aug 30, 2024 at 03:47:11PM +0200, Vitaly Kuznetsov wrote:
> >> Gerd Hoffmann <kraxel@redhat.com> writes:
> >> 
> >> >> Necroposting!
> >> >> 
> >> >> Turns out that this change broke "bochs-display" driver in QEMU even
> >> >> when the guest is modern (don't ask me 'who the hell uses bochs for
> >> >> modern guests', it was basically a configuration error :-). E.g:
> >> >
> >> > qemu stdvga (the default display device) is affected too.
> >> >
> >> 
> >> So far, I was only able to verify that the issue has nothing to do with
> >> OVMF and multi-vcpu, it reproduces very well with
> >> 
> >> $ qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s
> >> -cpu host -smp 1 -m 16384 -drive file=/var/lib/libvirt/images/c10s-bios.qcow2,if=none,id=drive-ide0-0-0
> >> -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
> >> -vnc :0 -device VGA -monitor stdio --no-reboot
> >> 
> >> Comparing traces of working and broken cases, I couldn't find anything
> >> suspicious but I may had missed something of course. For now, it seems
> >> like a userspace misbehavior resulting in a segfault.
> > Could you please share steps launch the broken guest desktop?
> > (better also with guest kernel version, name of desktop processes,
> >  name of X server)
> 
> I think the easiest would be to download the latest Centos Stream 10
> iso, e.g:
> 
> https://composes.stream.centos.org/stream-10/development/CentOS-Stream-10-20240902.d.0/compose/BaseOS/x86_64/iso/CentOS-Stream-10-20240902.d.0-x86_64-dvd1.iso
> (the link is probably not eternal but should work for a couple weeks,
> check https://composes.stream.centos.org/stream-10/development/ it it
> doesn't work anymore).
> 
> Then, just run it:
> $ /usr/libexec/qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s -cpu host -smp 1 -m 16384 -cdrom CentOS-Stream-10-20240902.d.0-x86_64-dvd1.iso -vnc :0 -device VGA -monitor stdio --no-reboot
> 
> and connect to VNC console. To speed things up, pick 'Install Centos
> Stream 10' in the boot menu to avoid ISO integrity check.
> 
> With "KVM: VMX: Always honor guest PAT on CPUs that support self-snoop"
> commit included, you will see the following on the VNC console:
> installer tries starting Wayland, crashes and drops back into text
> console. If you revert the commit and start over, Wayland will normally
> start and you will see the installer.
Hmm, looks this issue can't be reproduced on physical machine "Coffee Lake-S".
The installer can show up to ask for language selection.

But it can be reproduced on the machine "Sapphire Rapids XCC".

> If the installer environment is inconvenient for debugging, then you can
> install in text mode (or with the commit reverted :-) and then the same
> problem will be observed when gdm starts.
>
Same to the gdm.

> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> Silver 4410Y".
Will have a debug to check what's going wrong. Thanks!

