Return-Path: <kvm+bounces-57978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51495B83097
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10B3B624A9C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DBA2D6E7C;
	Thu, 18 Sep 2025 05:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bx9wlY4c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73510283FD4;
	Thu, 18 Sep 2025 05:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758174272; cv=fail; b=mKzfUX3s5L5UskWB/xZOOksoavei1AIVTuqxI29dQqN9IYKL4kZG4Ss4MGM56kMqiSJBvYpVn3dI7TFHxzPTP2M24Pa+cA60IohFjsrjowEAMH3dDFC5m08zQhiABUYnks/Dm/hjPAhRMVnydl2xStKK2YHTWMX6caZQBbj5mmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758174272; c=relaxed/simple;
	bh=aB4QdmVUHQd8WQB03ebvRrPnnJWPN06/Ad3r6Z/TIlI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FGVTz4ji6to1j23SrYDDgM4xD+O8XWGtrNaSJeGRp3LEsFiunTeH1LDMQ5sswBqPBMp8aVmoNghSnMBcxT5UQ7Q6NHPGp/vw5ackHa4bRsizdwpu+jWncGnl9JMnb/+jExPk8xGQKom1q0WBFQQZulRTu7dpVBaAauZWIbt5MA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bx9wlY4c; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758174270; x=1789710270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aB4QdmVUHQd8WQB03ebvRrPnnJWPN06/Ad3r6Z/TIlI=;
  b=bx9wlY4ckIegVNSOhUULRYw/LHTNLfF7/p73H9FkQiCXMF7cg3OJM75E
   5RrIfhmRT8Z1td8tfldJFIkfNacRRwIqwLEgZkVbPDo9aplr9MmGQPvQ5
   1Fp4IRpcFvKFLqQ6PLa3zH7hXKa+l9A22IElc245gmNTS0PWjBVg2JCnc
   L61D6DuAISslDKxsnTAxLf72kuKfYXuF17KJ4mSv+3SF8pSy+0dVZmLJS
   eSbBZoSbnEtkQQzLsZ8AmkuFq8Jn8BqNwSyixHbDoPgPmdAMyBzzp8gJQ
   tWW0whHsjoBjBnttQBK/cVACBaSB6/Li98LrDp+MbqBg3is5dNEUiir0u
   Q==;
X-CSE-ConnectionGUID: 1dqmvYzSQB+q3B7DT7LMhA==
X-CSE-MsgGUID: K5nKurwmSq6dCqVoXTl+OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="59712386"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="59712386"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:44:29 -0700
X-CSE-ConnectionGUID: RBscg8TjTSuqxQj4IZurCg==
X-CSE-MsgGUID: vxnfa1rjS/uebIhzkabJ/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="206246172"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:44:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:44:28 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:44:28 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:44:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzbTiwG8kmE96wTFoQc38uxZWgmZV/MebUMVDdIm/s7tlq79qQYsZ98Tvs/DrP7AEFSKUARrUwEV7Zx4cPgGFlO6mafbnLN1YZQw24z3IFrMDkv8TH/CYDLDE1JVTSJjMIwK4j8EPZXKTSopiYJ+GN59cPH4dDAfeweIhaoMjjgzyeZkdQWM78xnldzjfi3B5cCu5iBJ6Nu4q+uX0UbRAR/K6NmKS1xMAiC6SSvSNxLcVvpqNEvumyY6BlcMSzcR2nzu0U4lXS1AGc4aCfywB/7BjGnRwc3MxA3KZzPlcajSsiKfM0wfKDLXgHuLHEs9oPmGJsyCriTrH5pzpQLkEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kt85+TNHIWWdq037OzzAW/srLvGK9jJCQcLc2aPpT98=;
 b=JK1M0960EAaebNfeLL7Oj5q/epMHvIxT4iVfid/Fjj1rrViwe+nPA9ci4kAHf1zqDD2glLMk4Q/pxL8dAsL0xHe7T2vsEQN1l953ScCT9j6zVCn0yi6U04a0KjzemhIWL8HZMahu6+kgdLUHUmpFQh5FrW0sjul4AnFCQhuzeAwUXklBa5X0RNGp7BnoxXYV+2vl7jUXURnq/quTpZydDFw1cKm+9pT2fkFllgGGh74o7WUOYoUFRvEJLdPTmd/d2UGNmhbZwUTza5asCSD3+pbepmnb5Z/Xjp8H7dod7bQ0mVu1HQ4T6vlMgzX11wmUnOjt7Fy1pEDvW0pJJzKuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9105.namprd11.prod.outlook.com (2603:10b6:208:564::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:44:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:44:26 +0000
Message-ID: <298f769b-b893-4ed8-90b1-d9d9dce25037@intel.com>
Date: Wed, 17 Sep 2025 22:44:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/10] fs/resctrl: Modify rdt_parse_data to pass mode
 and CLOSID
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <9200fb7d50964548ef6321214af9967975cd9321.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <9200fb7d50964548ef6321214af9967975cd9321.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9105:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c46b48-2824-4f90-85dd-08ddf6766d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0NDOFp3REpYeGdNaDZVY1pCQXNHbUQ4MktDQTBDSnFIa0hMdTFxL3VOcmhN?=
 =?utf-8?B?Ly9PajRNMFp2TGRQZ1pqaytpbGlaSTkxZlNhQ3ZLcXUySjQwUGowT3BLSjJB?=
 =?utf-8?B?bWpXb3BHaXlnellXeXlBUGtsdjNIejdpN3B4elpkMjBNWlFRengyTmxhTkZl?=
 =?utf-8?B?ZWxhSjJ2ZjVxYm9La1NHVjJpQTV5QmNuLyt0OEplOG1aN3cxK3lKS1k3bktk?=
 =?utf-8?B?UVpaTjJjM3VsOHRHSVNXTTBJb01QeVJEb0NSeUlBMzJ2a0c5cGE4OFp4V21U?=
 =?utf-8?B?MHpYM0trTmdFUTEzMFVIR1JmT1NzaVdGYVg1am5QRmxLaVFrU2VSUGVGL1Br?=
 =?utf-8?B?d0V1NHhkK0VIQUFyT0Rhb2QxNGNuQzJPS2FncHR1WTcyYzZCSXpsL1dHSFZB?=
 =?utf-8?B?cUljUWV6Q0c1aEF5TUtoRHNHZkNxUEF2TWNRdlFtY29SMWNjZ1BGQmdMMHNh?=
 =?utf-8?B?ZUJVR01hTk81eTQ0K253b3BJcGsrbEFad0Q2TEhQZjB5dTVJWi8rRWowUkhH?=
 =?utf-8?B?Y1d2UFhDZFg0ZEZGb1QyVG5sUk1FdFVsUjVuOFlOMWd0MWJLa2NDUU1mK1Fn?=
 =?utf-8?B?OW1zazZTYzk3dmZiMlQ0V3hzWEFiTzFBend0dkw4SEZiWGNpWVJKa2ZndDlU?=
 =?utf-8?B?clIzdEJwVy9JVjdqYVZMenhxb0VOZUgvMmlUNm1QZzRxbjZPZ0ZudEJ2cnl4?=
 =?utf-8?B?K2c0N2ZMOTBrK3lYcW9jcnFIMG9abmhDci9sS3R1cEZIQmRpNHZObm5hNTU3?=
 =?utf-8?B?VjZaN1JMTjZFZWFJaXFiMU5Na2M5bzAyU3I0YVU3NjcwMU1id0F3bXlrN0NQ?=
 =?utf-8?B?TFc4WFR2aFhJWUFtOUw3VDFQUVRnRGpwU0pNMzlxaXNWTFhodVl3UGd4Uzg5?=
 =?utf-8?B?SmI2VFhZSGZqNTl6QjVscXNKNU1ybDZMSiszalVPUWFuSTViQXpMcHRNazNo?=
 =?utf-8?B?U0p2cVpNNDNPejRDcVJxbmpxVGZpN2U3YVVnYzI5T1dJczhsaFpLN0FPSzly?=
 =?utf-8?B?TXV3cWlkcWN5dXlzMnd5a28vV2hhMzAraE94YWVyWFM5UEhEV2VYd2Q3M0hU?=
 =?utf-8?B?MDExQ2NENFJlZ2JVaTZrT21wYkRwbjVuT1FJcUVDK2NNclhiVzQ0MG9qMmhL?=
 =?utf-8?B?cGNDakJjaGxVZEthMEN3djZ4c2JMK3Y2N0kwNWgwaVFuYllIR2oxRDEzZ2Fj?=
 =?utf-8?B?OFA4RkRKVk92T1llN3p3cXBwRUMzazJIT2pOZkpTSXAraUFRRGVaL3F3cVhq?=
 =?utf-8?B?TU1STlQyM2NjWGU2K1hVTk9Vc0hlaUhENmhpTFQ2ZE9uYmxDbUo2aS9hZDVN?=
 =?utf-8?B?bVJzSHQvSGxOV1l3a0dQN1FRcWlWR292S1phcDM3eXlHUkQ3ZWRLNUJoUU80?=
 =?utf-8?B?K0lWVGduZ2pLc3JqTHVNa0cxVkJLR3NNaGw4TmtZUStsY3EyMzhxUEZVbUQ0?=
 =?utf-8?B?OWdEdWVSQXVSL3BxQU81ZVdSaFMvM0pzNTVpYlQ2M2g0L1pBTzZJUDR3dUd1?=
 =?utf-8?B?K0RZVk5QWlZZcDhCeFpUdlpUSk81b0swL3NnN2l2WXh6RFEzK3MyNmhFdFBD?=
 =?utf-8?B?bmdqSkF0MllXVlRjTTZGYzU1b3V3SjFidzZNR3JJSmdaQTZDMzV2dVNIMGZQ?=
 =?utf-8?B?YXRkYXk1V1JEUkFsdmR2dEhNNEFRWXlKbFN6RVFSQVRsRXJUZVFIR1RudzAv?=
 =?utf-8?B?L0dxWlpNNnQ2Z3dQcHQzNTFIcVVacm54TkNSUE5xOG0yMDZGSU4wcmhra29E?=
 =?utf-8?B?dHdrRDBNSWEzUlhHU1hjMWZmNVQ2LzNTOVl6YW5Xb1BvNHhyUXU0MlZ0ZTFs?=
 =?utf-8?B?ZkR5eXU0Z3UweFEzaUh1QnNxbDFaUmwvVW5ZWXB5WEZubWtHbnVPaDk4Mjlr?=
 =?utf-8?B?SW9iNWpJZE94QzE5U1dTU3ArZndvR2xkRGp3cXpPc2xYTzhRdmFhWkRtM2Jp?=
 =?utf-8?Q?4qb7Jf/RXc4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1N1UWxMTXl6YUJvRi9TNlZFRytZQjVrMzd1RXlKdUhTQnRtYnI2Snk2MHR6?=
 =?utf-8?B?WEtERkR1WTg3b0c5THJ2ampYVDJDYUhqaGVEeW0xQkRKRUtPbHFFUi9TRWxP?=
 =?utf-8?B?aWRsNVJWS1VWL3VsNXpBZDFHRFRBUzVBYW5URDl2Q1M2ZU9BN25ncDkxOU12?=
 =?utf-8?B?dmh2ZlRtZHA4eEdaVC81MS9NaVhnTlhkU1RzTFR5NytSenZNMDZYbnZ1MG41?=
 =?utf-8?B?dUFxbUdEelFvZXBoc2lIV2VMVG9aK0FnTmdsVDNsS1M5NHBvOUsvbEpMdzdx?=
 =?utf-8?B?OFFleS9xbGg0WVlpV3h6Q2ZOZGJ3WXpINFc4TUlSU0RDeFVTMlRKVGNLUVpx?=
 =?utf-8?B?LzBnTzN5bXFkc1NqY0xlbmRWa3JOUHMvMTVSdTNwTG9BNVdpWnZUY0JQTjVF?=
 =?utf-8?B?cTlzdXcvSHhGc2pFMnZxUmFuMXNrSFkvcFEydlZTZVZUMjFjRk01YllmWUJL?=
 =?utf-8?B?R1lzejB2UllrTmIvKzdpdDdmTVBQb2ZZdnBZS0tWVXRNU21kai8rYUE0VXF6?=
 =?utf-8?B?ZUl3cXA4Wm5YWitFOG9xWURmM2RjeVlOWTlGbGFuTkYvTkZybmczMFVTTmFD?=
 =?utf-8?B?ZERWaHA0NG5Id3J0TXVyN0dvRlVweGt0c21MU3phN3ZTWXBEVkJzUldHVmpi?=
 =?utf-8?B?dmNHTmgrV2FMODgrSFMydXI2NWZVWnNZVFRPSnhMVlFUMGhqcHoyMU5mcnJD?=
 =?utf-8?B?VGFyamxPWDN1L29iWFRvTXdUbHZwWGdGVEJ5bGZ5ZTNoUFNXV0dUT3dLYm1I?=
 =?utf-8?B?RjFhUHdSNnV2OFhibjhMYkdDaG00eDFpUFhKSFpPUWdtRkh1TFZqT3pZcUda?=
 =?utf-8?B?dUZtOTdvY09EVStVUlUvd2FUNzNTM3NXanlPMzNaaU9zNC9VY0xaT3Rvays1?=
 =?utf-8?B?d21meGh1aWJtRFlaOUthMy9DdERrZTU1djRZeXJtdHBHaHFGcW9yZ2FvK3Fs?=
 =?utf-8?B?ay9qaTVpM1oxUEJoZ2VlT0NSSTJzakNxQzY1SEpUNzhvd3JZRFhGOWpMekxu?=
 =?utf-8?B?N2FlaGVxanEzQTJnSEYxejgyNkJveis2OXFCRWJCczlZRGtiWk9NSzQxZnoz?=
 =?utf-8?B?RkUybkdiaTNsMVhLeDEyVEhYdEJQb1ZyOEthK0FnRFdMN0w2d2JlVEdSMFAw?=
 =?utf-8?B?SnhMOGhJbkowd01sN3ZUOXdpSjlLZ1J6ZG9XUS9ydUNzdS9hbFZ3N2lFTzR2?=
 =?utf-8?B?WTVWZWxjUGw0d3NoTStiN2NLUnhUTHRndUN0ZnZXSGZobVpXSHZ3ZnlVZ0ZG?=
 =?utf-8?B?K0lILzJKc0xpS2UwTkhWS0x2RFY0VmUwL2xucjEwTytPNlcreC9XcEptYUJY?=
 =?utf-8?B?TytXNFhIU01OZFgzcWg0dWZJSU52M3pud1BSb2E3aVhsY0p1b1RhdGltMUVV?=
 =?utf-8?B?TGxIMHcvL3NPRzNXTURxdWpDdWRLc3JvSFJZalQ4cWlITU5WSzI5d2JYTUlF?=
 =?utf-8?B?T2VlZHUyK2NxUm1SS1VuakJKR3AwSEdmSnBJWTRrNFJjRml1L0pxRWlWUXQ4?=
 =?utf-8?B?OTNGT1NyQ0lackUwZG8vZ3g4aTZuMXB1NUxSaUNIL3ZrS1VrWktUY0lGOGpE?=
 =?utf-8?B?dGMyNU9VMWZGR1M1QUJYaTZ2akZZRzlBblR1RmM4OWtNOFR3dUdHc042WTN4?=
 =?utf-8?B?cmtPOXltRlc2OVhXWEowZXBCMEVOSk5pWnArZlcvWWxJai9Tb2Z4NllDU3NZ?=
 =?utf-8?B?Sk1ySGJadWpoTkJiYVM3Zi9FbW41bHQxZXVBM2swS1VqMmxKWkd6NGFYNHBL?=
 =?utf-8?B?Z1dvZE1GUTNYTTI0V0FtbHBqcXlzdFZqWGZaN3J1ajFFb3ZEQ3NTcVgyU2Zi?=
 =?utf-8?B?NUV5NTdncmlPcGFxYmlYWWcvY2hkMTBGK2pWck9rMndTVzROZlllc2pNcG5Y?=
 =?utf-8?B?V2ZBSFE2YkNIWkxKVW1yRys0R2dWNXA0d2dUN3F6c0p4cHZlRTVIU3YyTC9a?=
 =?utf-8?B?V0dlOHZ6c3Z6azRFc1cyM2lQMWNhYXhadDg3SVFzMWg2ck5COWRuTTZXdXl3?=
 =?utf-8?B?YXJlSnhIZXZEcFVNeFBBdTFDUk5OeVZPSjY4bmc4VXpRcnROVE4zMmdxYlBW?=
 =?utf-8?B?R0lVZEhsSUowbVpjQi9Lck1sTmhNZTU0THRwL2JqVXJaSk82akJJQnk3ZkRE?=
 =?utf-8?B?UldnalFFVUdpUVNJdThLUEdBcnBuTnFnZnFJZFBvLzdXWWh2R2E5UWNHWHlT?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c46b48-2824-4f90-85dd-08ddf6766d71
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:44:26.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Fcq5CViIYMYKOISicUaA3PhkVEKLMAQ4lhvTKDyH9twaPciFxUqn/wzqEM7GLqytcK3SSCT1V01XwCxvf2ilLc2xtfmmookJjSrcGLxwSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9105
X-OriginatorOrg: intel.com

Hi Babu,

nit:
Subject: fs/resctrl: Modify struct rdt_parse_data to pass mode and CLOSID

On 9/2/25 3:41 PM, Babu Moger wrote:
> parse_cbm() require resource group mode and CLOSID to validate the Capacity
> Bit Mask (CBM). It is passed via struct rdtgroup in struct rdt_parse_data.
> 
> The io_alloc feature also uses CBMs to indicate which portions of cache are
> allocated for I/O traffic. The CBMs are provided by user space and need to
> be validated the same as CBMs provided for general (CPU) cache allocation.
> parse_cbm() cannot be used as-is since io_alloc does not have rdtgroup
> context.
> 
> Pass the resource group mode and CLOSID directly to parse_cbm() via struct
> rdt_parse_data, instead of through the rdtgroup struct, to facilitate
> calling parse_cbm() to verify the CBM of the io_alloc feature.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

With Subject change:

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


