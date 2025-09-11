Return-Path: <kvm+bounces-57343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFF3B53A02
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7409A166BE7
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2098C35FC33;
	Thu, 11 Sep 2025 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ATkiQyKx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672863128D8;
	Thu, 11 Sep 2025 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757610682; cv=fail; b=Jeva6PHLBXVBzyg6UBMbZ1rmaYWj7NrNDa/K42ZvdqpTHaLNkEWED2K/ERFG6eqBjhr1RnAQ1eVja29eHl1urpGm47uKOf+m4Nsuo/hjMsbMldGf9VBqYCQTkYFxLcZ15EoM3i5GlQdDWmM5ciUsKI3pl4xFFu0MUiya5ksCkBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757610682; c=relaxed/simple;
	bh=9id/7ToFhEII5MHAgPErjOdPDBa4CCPFBPpIpmIenn8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QDIYDoeYZz3FWkvnbhABqWZztkproKv0g8lciBFIVnE5POKdOBwPy3/pk9fHx9YCnZ9OAWtWXMgf3eu+twX1fyc/gR6Y4tuBz+rdmnaE0EWxwqYveWfT1gqorN9a9/U5bf6EnqnPwHm9lzChk+rtezCtktSofYPA0X78JdkRJ/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ATkiQyKx; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757610680; x=1789146680;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9id/7ToFhEII5MHAgPErjOdPDBa4CCPFBPpIpmIenn8=;
  b=ATkiQyKx5nGlvvMn2wvhdwTsY6fdSeT2QOWCMAmMyzh2u4h4H9iEvVOC
   fnxDG0uNREAuT2RrcH+xSqKQkIyUH2rn0yEzx1la9k67un3e21zYwXfnm
   98gwq2Q2K16EvI3XNN/p5Ul5AJytq3q5VeCPpCZC1JqwGhqcUZMbGs4Fp
   guP7TzB12pQq3bC2zbifi9rS2oYL0RPmDwoYYZAvljDYGM8krA2SGnzee
   mROWEeegilBiywSSP0At4w3iX0L/KNRc1ig9Xq5ZIS1Wok9OJOpV+WNZ/
   HK803vnFnYyxhrYt0fSuDvh7TBn4A4RpMzj18WOnQtSj6eJzJGuU3Qg/v
   w==;
X-CSE-ConnectionGUID: XtSOzqpwTCy3v+68foOhHA==
X-CSE-MsgGUID: Rjrz/93BT36lQgkVcwp7xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="71376071"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="71376071"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:11:19 -0700
X-CSE-ConnectionGUID: +2ZNLkRHQryTmVJ6NtxUUQ==
X-CSE-MsgGUID: a2z4RF1URzmQ3SZCTGUJfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="197428628"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:11:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 10:11:18 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 10:11:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.70)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 10:11:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBeJSf9ox55n+mlTVCZPvoq6i7vi2RkGtMCplBK4AQIUOpL4MGnD6PP59prfs2XUqGnmFuEAzQiINKB86AOQPQVylAWCx+7Qnp6tfXJ0G1Ln3P19AAiv28/hyDCg5v6RB/Sirk8ObBVtdmYrG90lyvHrJF01olBMkpT5Hwbaj1aWiLYeS0N9p608hfYUvAHpJSiM/z17A5PaPJCPbR9yrnWeQByxr6Lpyt1HAVIdyz4BKwqsgeREwtAI/k/g6RUNeDAhWbcx1xSbObjVGwpcQj5TLHDy+VThTCTDdVzkF5Tl8zMhP+/UjBuTch0/6KgnnpRVRnvAJd9kPmGMaEqV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nb1dOE9YeJH54nVc9Wg2ri1V64LNQpkKF7iflZ1EQI=;
 b=aHlcps1lbBJhhHsXhMw1TKonYgZ/ulN9nQcmKIAOnm9wCjxoBsbON1pTaUykUqcKvnLLFpZMFzrcpv5+XvFpMQrDJNkV39enSpZtoLC6P4G/wV8CdWUkejuoOCTLtIndJaFdJ6CgPnXOQv7RcfqcWSnSi/nfRLWMH7wfxT3knvb16q4sCS/GTy0ACur652ZuEJpOYy9bUEA9WDyyAkM/Ys7YdSsIRYOXGQMsNG6jiDFWmn3lp6hbtIn0w0G5sxcR5UojWoRKNw4AeTfsCyyGTyemlutcEFRLnnIVDxwHSQOnWk3lwyiECsFa4SuGuWVmtR3PceqUCq6ZSONosPbJ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 17:11:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 17:11:14 +0000
Message-ID: <6d3ea767-517d-44e1-bb9b-6ce3c5416193@intel.com>
Date: Thu, 11 Sep 2025 10:11:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to
 enable assignments on mkdir
To: Borislav Petkov <bp@alien8.de>
CC: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<akpm@linux-foundation.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>, <kees@kernel.org>,
	<arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <pawan.kumar.gupta@linux.intel.com>,
	<perry.yuan@amd.com>, <manali.shukla@amd.com>, <sohil.mehta@intel.com>,
	<xin@zytor.com>, <Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>,
	<tiala@microsoft.com>, <mario.limonciello@amd.com>,
	<dapeng1.mi@linux.intel.com>, <michael.roth@amd.com>,
	<chang.seok.bae@intel.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
 <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
 <0bacc30d-0e0d-45da-ab13-dca971f27e2c@intel.com>
 <20250911165433.GBaML-yTUZHkywuJIe@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250911165433.GBaML-yTUZHkywuJIe@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:303:b6::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: 678cebf1-b527-4438-88f5-08ddf15636d5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dzNRYlZJNUJjUGJ4c3N5RTZ5ZlVqd01kbnJjdzYyS3pWYVc4aDR2UHhpR2Y1?=
 =?utf-8?B?VE1vcVBoZFZBNHNtelFOUmo4bEZnMWlqS29pejYxRGs5czcyTVpGYXZDRm9x?=
 =?utf-8?B?SWk1U2lCRE4xK2Zsa092TFUweTZVUklwUy9LUGpFWml5OFdtWE1BNWNnSDNS?=
 =?utf-8?B?NUUwQ1I0OTBHK0RBSEM0dmZMZTMrYmUyejgweHA0dUxIL2EweGxhTjNTenh6?=
 =?utf-8?B?UWU4UStyR0d3QVdtUVFpeHZqTkJsa2RnUkVPREc1NTRwM0RQZ2NtUWVVK3VI?=
 =?utf-8?B?M2xlSFVUcW0xNHJqSG1tTzgxdlVDK1E2V2VDUWhMeURSanJ3LzAvYzRtVk5N?=
 =?utf-8?B?ckkvRXk1R0tDVHRZcDhBZERsZVdMWnlscGdhZDUzYi9vL0I1NjFCeUtHWW1i?=
 =?utf-8?B?MHhySm5jTTRUaVRGR0ozRHpBeGFsRnlFOEFISWVMeE1OY0VjUkVkelNuVjc4?=
 =?utf-8?B?WWRjaEExSk40cXNJY2w0dUNRS2ZXNFprY0RlaWtpbDB1UlpNNkNPSS81MnVT?=
 =?utf-8?B?MUdjZUpJNDI1anBrZVRBOHhLR0RCMGoySkhQQ2d4WkdremRTNS96VDZlaHFy?=
 =?utf-8?B?bUhFT0lnaDBkOGpYOUE4UDd6bCt2ZWNuYzNycXZJYUFGTDN6R29IVTdyWmNX?=
 =?utf-8?B?NkpObE0rWFBJcUxLbGZnakZZSklNU1hLWTNmWlRnTGJOWUdyRDB1cWw4aVJ6?=
 =?utf-8?B?VitJWmh3ZUZNODBIUndCbVdrUXBtbXNXQzNlNGVWSVlRTmpacXdkdkphdjQy?=
 =?utf-8?B?emdUQ0xKQTFzNWhHR0lNRkxLZVFwYkJDUUhSYlh4cnYwR2p3eVdFRVJTQnlS?=
 =?utf-8?B?WG84T3JXUGVPUUNOdVdWOWVPUDVRV3hDS2t1RWZkSmpBTzlqUllsamlvRUZM?=
 =?utf-8?B?MUN1ODJVT1htcmdiZU9HVksvcFFrN0h6RFNDQTJDNitCcTZNRXlTaWxOaXlH?=
 =?utf-8?B?UGR1QTI5T0p0a3F3OGVnLzE1dVJ6MGNibjRUSkpKeGJ4STFCeVFlamlNSnRP?=
 =?utf-8?B?T2gxc0pmcldBRFo1ZFIyaW4wKy9zaTluKzVoY3hMbERQVkZXNmlhc0swUmxm?=
 =?utf-8?B?V1R5K05PR2tCTlllQ0JOMUs4ZFZYSjVvaUxVVkNNbnJSTm0yTU5oa0lrTy82?=
 =?utf-8?B?UEJhYWQzZThhWThSMzJRaHdkYzRCZEgyTXpkR1NnKzNGdGpnc0YyZW9WQ0pi?=
 =?utf-8?B?T3pDa2xocmFMUWhWTCtKblRtQ3REaHBpSk5Pd3FlZGJYZHhNLzRrNnU1dXc3?=
 =?utf-8?B?Y085UjFwV2hQdGRZZUdSa2JYalI1ZGJ6WUdyY3FzdDFzcFhIUmRSUXBna1U4?=
 =?utf-8?B?c2ZWZllmcjJpSEIvcGRUN2dHYTJ2UW9UaHdJYXZRYis5bldPS2VPRHVONFAv?=
 =?utf-8?B?bjN4cUdGcEZLaFJpeDlEWXJaWGtRVXVkQmhjdTlCOXBuV25mVTBXcThGdUkx?=
 =?utf-8?B?d3dtU2hEYjNPZ1pMbkl4eFFod0pjNFJOVGFiRnUzSUNvMi83YUZROGNjNDFX?=
 =?utf-8?B?MjdYVDNBZUszVHlkNU0rRUtzcHZ6c1dLMG5rT2hmOWQ1eG9IZkt5RXRnZ1dT?=
 =?utf-8?B?QUJ1VXJYZmVYTUQveDZJWlBhUUNQbjV4ZE96SlRGOFN3VTRNOWlOVHZIcDZN?=
 =?utf-8?B?MjBwUU5XWVA1aURMZHhpSVlzYzl5OU1KTyttRWd3ejVTejdNNFpFRFRpQkd4?=
 =?utf-8?B?RnZRaWZaenc0dXU5WkJNZmpWbkZlbXRUaFJKMEdiYzRtOGU1a2RHOXRHRTJ1?=
 =?utf-8?B?RVgreEVKRVJLbDl2d2Myd00wZjVrQUM3aTRKNXI5Q2w4MlhlYklIRGx2Zit2?=
 =?utf-8?B?cEE4OSt3MFZXMXl3Y2RDaURQMVpabnd4R3c0QnQySFlxQlZkTGgrMlRFdE8y?=
 =?utf-8?B?OXpkSjkvK280NVZ3d05rUi84UVVCek9KS3Mya3RGbmpMU0p1ZFpHR3piWnZn?=
 =?utf-8?Q?V8gGTRvM1Zs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0RmUWFYT1RkUTRNalppWTFJdU1xQmlQcEdCemlEcHY3UnkraFArdjZjcTJa?=
 =?utf-8?B?ZDVHdHRyTXJrRUQ5bE5rZHFZclhBUFVqNVdSeWRkVXVMMTJJbVVieVppZys3?=
 =?utf-8?B?bTdIalA1UmVwOXphSnZQVUFCTlVCa0ZTOWQ5emxoeVZMQzJMQ0RORDVVZ0pQ?=
 =?utf-8?B?VkRtR24wWU55OUI2ZHMyajR5N1hqTGt3Y3NjVnNDaFh0ejZINkJkcmd3b2Rj?=
 =?utf-8?B?TUJUand0ZisvVlZPaE1lK0VXL2NndGx5Kzl4cXBUdDQvdkNVQnI5K3FPbkN1?=
 =?utf-8?B?b28zQnlYcVN2YVgyd2t3NmdvSk1HcDMwNGx4NzNVeGlHa2NaR2lHUHEzZWJW?=
 =?utf-8?B?RjVkaGV6Y1NhaDRmN3JMWk4vN1d1WWNCTlI2bHVObDRqSENFOFkvalJXNzdV?=
 =?utf-8?B?QWd0T3duMTI0d2krcFZ1QWVmRi9pOXBZSFdkWWJlM2JQYytSaE1LL2x5MXFj?=
 =?utf-8?B?aFRBY0lJM0NTQi8wKzlQdmh0OVdCb0tDUkthR29memhGbm16TjI0WmRTTHdD?=
 =?utf-8?B?S3RJc1FLNTRFZ3lxbmNEQ0UrZjBNWktrWkdCN0w0ZjNGdWQwbVNVVzAvZDV6?=
 =?utf-8?B?Y0NCNVJZbCtGanlzYVBYQ1VTQkk1UlNxbW9SZEpMM1pxTFY1aHA5a3g1MTFa?=
 =?utf-8?B?UnVkVTBwd0JKc2F2ZTBucTNZenFVZzJIc0h3TGl4MjUyL3dsSzBSRFFlMENh?=
 =?utf-8?B?YVpxRHF2ZGx1UHlwTUxWM0pualphYW5mTnZCSmlJcXlhUk9GU21JNmR4UDQ1?=
 =?utf-8?B?M2tzNVN4a1RCYWgyZUQ3M3I0bk0zdkxvUEJhZGE4UVJQL1ZBUHBRQWNJWDdh?=
 =?utf-8?B?QkQ4anpIYVN5S0k2MkpOeGdZaVlXL0xNUmIwUk96TmU4c1owbVIzM01QeXpy?=
 =?utf-8?B?cHhKbGVmcVFLbHk3NVF0VEFFc3ZtNDRSZ05jMEM5WXdFNTgyZldrM0QzNmw5?=
 =?utf-8?B?b2pSbm01b3huU2YwRFNZYk5aRzZCYjUxZWZwR2tpN1BvWk4rSk9FQldQL0VM?=
 =?utf-8?B?VVZrVi9PaW9UUUxHelpOd3dPdmJocG5MeDhKOElBRHlEME1XS0FDd2pjelZs?=
 =?utf-8?B?SUhTeEdsSTdEaUVBZ3ZISmlxT1h4SXhaYjM0ek9CZEpDcFJ1aXAySXRGOFJR?=
 =?utf-8?B?eFFuV3FldDVueW10WVJQVExqZXVhNmljRTZoU3V5UDVtSDlhQXF4T2E0eU9j?=
 =?utf-8?B?Vm9oYmF5dTZ4aEtMaCttS3VDaFcvQUZ0RzdRaVUvTktJdERWMERiTlBhMHQw?=
 =?utf-8?B?Z0pkTmFHVm9mMjFjOWxJRThTcC9GMWwxNWo0elZEZDhpbEh2cXZHSkUzRWxX?=
 =?utf-8?B?dEh0Z2pUQTdMNzhGK29QRmpyR0dCMmtzZzhPTTJFZGdIUm5jZnpyYWFlR3po?=
 =?utf-8?B?Y0crUVVEcFVtWFhHdFRxZDBqdHRjV0pDUzc0ZTI4b2c5WlZxL05YdGZyTWpG?=
 =?utf-8?B?TUlyU3BqVXZuQjN3N1Y2OENId2xtRGRlMzA3aml6bGNWbFpiRHVKV09kazk5?=
 =?utf-8?B?U1BpZ2hXaStPWTU5MDMrNFhwSnQwN29ER0Zld1lsSU4rQ0pBSm5oUkhaMllw?=
 =?utf-8?B?MFV1SFlpWktsOXl0c2RSVmpKMUV3cVRNOG0xcTk2T0NPL3VMSG55OTBTdEVZ?=
 =?utf-8?B?a0dIOVVKZ0xoVGdUbXFJTEZwRW5FOE9CY0Rjajc5NWd3UjYzSGw1TUErVGJy?=
 =?utf-8?B?N3pDNUNIVlpsQmlQREhkbk4wSGhLU2R5WGJMMmNzellFSHNrUUFhaWJaTmlX?=
 =?utf-8?B?MzhFb1pJMHZ4TmtxdytNVENXTjNtcXlrQnE0Z0MyaVNkRGt4Q2hnalhBZWRy?=
 =?utf-8?B?TXF6SVV0TEVvQ2RVU2wreHBUMnpubVRIaURKdXFOa1dFYUhQem96Zzhzb05G?=
 =?utf-8?B?SXkvUjcrKzB0TE5wd3crR1FwaHVzNUc1Zk5EZ2RHait5TWxJbXdpY2pvY25k?=
 =?utf-8?B?RTNYMklveHFRRXI3eTRCdzRmY1RHbUlaQ2ovQ0FtWVd3WXdyZmFDSjNMM0Rq?=
 =?utf-8?B?YnpBQnVqa1pPTGhZTENMamRTOE9IM1FraFluOWQ2bGxtYkU5NENyQS91bXNE?=
 =?utf-8?B?ZVlkSm92eTdNamJRb3A5bXQ5RXp3T0RMWnR1ekF5cm1RM1E2ZU9STytlQnY4?=
 =?utf-8?B?Q3BjazN6TUFNMmNKbURaMWVrM0xaYmZzMks5OUJUSHRSNUtFK2lwMjRSVDJV?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 678cebf1-b527-4438-88f5-08ddf15636d5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 17:11:14.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWktHdqduGccuodoq1ZBJPFmGO4OJsIxEcDYzECUonHYro8Vbse7M9NTEvdA5npKONU6Y1EPne0D6FZ34PIM+ytSM4rLBdH/5/ozvMrjnx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com

Hi Boris,

On 9/11/25 9:54 AM, Borislav Petkov wrote:
> On Thu, Sep 11, 2025 at 09:24:01AM -0700, Reinette Chatre wrote:
>> About repeating things: As I see it the annoying repeating results from desire to
>> follow the "context-problem-solution" changelog script while also ensuring each
>> patch stands on its own. With these new features many patches share the same context
>> and then copy&paste results. I see how this can be annoying when going through
>> the series and I can also see how this is a lazy approach since the context is
>> not tailored to each patch. Will work on this.
> 
> Thanks. And I know it makes sense to repeat things to introduce the context
> but let's try to keep that at minimum and only when absolutely necessary.

Will do.
 
>> About too much text that explains the obvious: I hear you and will add these criteria
>> to how changelogs are measured. I do find the criteria a bit subjective though and expect
>> that I will not get this right immediately and appreciate and welcome your feedback until
>> I do.
> 
> Yeah, that's fine, don't worry. But it is actually very simple: if it is
> visible from the diff itself, then there's no need to state it again in text.
> That would be waste of text.
> 
> Lemme paste my old git archeology example here in the hope it makes things
> more clear. :-)
> 
> Do not talk about *what* the patch is doing in the commit message - that
> should be obvious from the diff itself. Rather, concentrate on the *why*
> it needs to be done.
> 
> Imagine one fine day you're doing git archeology, you find the place in
> the code about which you want to find out why it was changed the way it 
> is now.
> 
> You do git annotate <filename> ... find the line, see the commit id and
> you do:
> 
> git show <commit id>
> 
> You read the commit message and there's just gibberish and nothing's
> explaining *why* that change was done. And you start scratching your head,
> trying to figure out why. Because the damn commit message is not worth the
> electrons used to display it with.

Thank you very much. Will use this as changelog benchmark.

 
> This happens to us maintainers at least once a week.
:(

Reinette



