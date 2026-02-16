Return-Path: <kvm+bounces-71139-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCTXJ16hk2mj7AEAu9opvQ
	(envelope-from <kvm+bounces-71139-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:59:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 38756148035
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 65E133019FF7
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 22:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B23D2F39A3;
	Mon, 16 Feb 2026 22:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EgLw0rQB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210992D73BC;
	Mon, 16 Feb 2026 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771282770; cv=fail; b=pVtHwn01et9ixS+fCC5Nk/3Btwvgot22qZ/HSiSReHgwRlpu+R6/x/Y1EgGjES8EFA+8453c6is8TuZZI/d7+7XaHrTpEesGZDUC6Z0mGpReGCQS7fpBZANzPFy9oJqNIx54ZoB1b4wcQfwWSJ1dAGmm0MfjDnQn1hbvlnNWuPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771282770; c=relaxed/simple;
	bh=1SQNHvjw1gKxxJxMTryuWm8xbej39P6MPdJ/Upxs0Os=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=kpz4yxRCWSzdOYqaLez0gw6eDEYLHYuJJL2UsVYr198GpJmknZLZ7IA7XdF1DMhnJLfiVdBdT1hevMPq79ISn5Yl4SzeLs0xTwNbbIHk2MfkoUbMuK2cI6oa61tYiNA3y0ZsfUhf21+sKysh5sN63YHTAWqWelw2HXWz5xfCTNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EgLw0rQB; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771282770; x=1802818770;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=1SQNHvjw1gKxxJxMTryuWm8xbej39P6MPdJ/Upxs0Os=;
  b=EgLw0rQBN/M7U/j7Zcw57lbUU8ZB2zrCgzUI48dp4A5fuqH6d3m+LggZ
   EMeZIfBsKgckHad2kRgBLZU9bEvVPdojz9vfvvv2qz2zBKKkdkhoOePy2
   wqgJRKTymOZBjrbqPoA73DR5OnajptBKoEe/t4C6ukLjw7Uym5UiJZmqe
   HVDhgn1+FJtkCY3i32Z6BW8DRF0YAyeO9IGN0PjnbTveN1VQoxHrS0cY4
   IrUPEwCtCgsxk/QTZy8PAVPDAcYbP1E8yfgQPBkZCAiv3WKD5qUIkUzW6
   r1+4fNkmXm/lYRingVv0K1ipsKQYQp4Z06jlBIP1N0oVAD0w5fYc7U0zk
   A==;
X-CSE-ConnectionGUID: UESuhSLgRsO4B+HCyzjTsQ==
X-CSE-MsgGUID: pLYq1hf5T/urU4BkSFMqzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="83458845"
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="83458845"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 14:59:29 -0800
X-CSE-ConnectionGUID: eIOnd8xtTaSmEaSouRRMdw==
X-CSE-MsgGUID: L5RuULreRjyRqcoeiP0NKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="217860758"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 14:59:27 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 16 Feb 2026 14:59:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 16 Feb 2026 14:59:27 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 16 Feb 2026 14:59:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HDzZfDx0vkw1cXchMHTS1WA59p7raVQRr0X5c4so1syR4Ma0yE52ZbiU/IFOQ5DF0AAfcxH/wDrT85DnhmoeR60/7coyLcFE+tFUX2Mfh/x15VOywWteahmwftBg2ryI1wq97diHQrvjBeLXq5ujvKimYyKoz4KcWK9N/g2/1NGeKfF+zY6/+louDRJT9qU5/GouMtawv0GK38Alzti7ZV7evavJah4Yg+yA1bNh6el6IDFtS71+s57qhxjx82gUjLus6FMDN1gMvdO9PBnTm1ypkRzNMpPeqx70thhq3w/THpZzHmRxjT4SFKH4uoiTRrJLEaB1sIgzf1h4KzLSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptq68ZggVHWdMg3HmOEB7uzfJyaom5WEBPcKklqAor8=;
 b=QvUWa1TyHkKMg0Y5Fy0CD6PEG5uTHVtXWGliZnLc5+xi/y0qfrVxQ3uuNxk5U8eV9xOcsRg1CJOfwQQTATwMzviLXr+7nEjmNKeQOn5+8YM6hokz8D2C9l8rIanVEFDk0HOX0v/WviGww3O+JNA+NB7kpaNYjCR3ndG8ISowXc38ml5I3zmnRr1SMqBX728MPWjL1PLBA+z62CqkXHSdCvXkHsvy+RosPhBXQ7yRyMdhQ66QgJhQUfgF7zez45n55BL2ShZ7Q5vTa6Z2Jk1pCU/hKijzcHpnsIy0AUSgqOM/4AMi9RIMRjdRNsHMNErOPQaZUcbB2IqYxCzrsJRwoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6726.namprd11.prod.outlook.com (2603:10b6:806:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 22:59:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 22:59:25 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 16 Feb 2026 15:00:08 -0800
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <6993a17823329_2f4a100d0@dwillia2-mobl4.notmuch>
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
References: <20260214012702.2368778-1-seanjc@google.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6726:EE_
X-MS-Office365-Filtering-Correlation-Id: 93eca9ea-c6c6-4638-1805-08de6daf07fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WUFzSHB3VHFIUmhHbzJqVFE0UExQMnZtcmc2VFZFQnc3c3B4SUM5SlkzclJ3?=
 =?utf-8?B?LzhsYVQzTHNrbUFrTDVEWHJhcUlCVld1aWlucklILzFqQzl4VW1LQXJYRlV1?=
 =?utf-8?B?TVA4Skp5NGp5UlBtaTl0TGhSaEd4RnVMY2tSb1JxRU9HYjVrWW45WWtQNmI1?=
 =?utf-8?B?OTZ4N3krK2U1K1daTGNFejZhM285bVdFd2tkQnd6WVhEaWRtdHB3SmJRUERE?=
 =?utf-8?B?V01UYlBOVy82b3N1aHZONXY5RFFsOHZzenJzODYyOGRpVlE1MWtCQ0loc1N3?=
 =?utf-8?B?Q0NxdDlubGNid3dvRGFLeU9lSlhUQWxoRndib2xkNm9zdXZPN0JGRDlPdjFj?=
 =?utf-8?B?ZGFSSGtKK0FYLzZGdUtTQnhUMHN0dEFaRlV6RCtPNlEvZGFCV3NHOVBNMjIz?=
 =?utf-8?B?RWczMGVMR1I5NEU4UVhra3VMTks4dHVxUElzOEtpQTk3aEIyUWNHM2RZTStZ?=
 =?utf-8?B?cWdMY1J6TE92REFrWWpiYjdIdmFralAzWEVpbUdIQ2QwS3kzSnY3THM1Zi9k?=
 =?utf-8?B?Y3pzcGdLd0p1V3JUVEhyV0JyVnVsWWF3RGMrNHFRc01uK1VZRkttSUxBYXZO?=
 =?utf-8?B?MjNScW5JV3EyclZpZnFQRjZBVnRkZHZHV005WG5DajhMelpJN0FzSkcxM2pp?=
 =?utf-8?B?aEhTN3NSSXhucEdNaWUyNmZxeDNZY1gxNDJJVEt6ZGRHQU5XZ2JQWjkyMXh1?=
 =?utf-8?B?Z2pNYkRlU2YyS1dFQ1ByQmJaaERHRWt2YWxJTG1MV2lrb1NWNmtXZndwV3ZV?=
 =?utf-8?B?dkt0cmt0MG9RZ3pKMUNNTVNjNlkyTDR5V01OdTdtaUtiSU1TKzFhS3JKc2Iz?=
 =?utf-8?B?SkxVOEg2MzFhaXRvekxPbFFKT09JZG5CRVlVVDZBM25lWDBZUXl2MDhQVGJY?=
 =?utf-8?B?MGdCMnluSTl1ZUNUMHp1SkJrRGZ6aXYvZzJTMlU1Y1hacU1kOXd6eHJmOFpV?=
 =?utf-8?B?UDVKZUw1MkN0aWFEamdnNUxkWnpOeG1JYWJQN2NiSXFySHMraVpqTGRScThR?=
 =?utf-8?B?clJFYWtWMWdneHZpTm9tTkRBQVZpL0dyc0hROHVTZzdoMkdWMW5wem0xcm5M?=
 =?utf-8?B?MVAycXVXN0YrcFhlQUF4TzIvT1Vid2FJbU5tcnBEb0hlaVZ0TzgwUmk1REM0?=
 =?utf-8?B?WllHbWJxZlZvZDMwQmw4Tm1MWklMTzk4WDJ6OEtHNkkvM1ZobnY1aVhPWDNN?=
 =?utf-8?B?RkxHWkovV2IvOVVDc1JyRXBBa1l1Y0FzS1lhUU01bm85TVIwWk1lemZkeDdK?=
 =?utf-8?B?dzRJdHplZ3RBZnBaWFQ4R0tWYlVtdTBaalFmTFlDV3VuSzVMb1Q2eER6ZzM0?=
 =?utf-8?B?THg2UTdDMU9naTBBZURBSnMrWHZ3QXZBWTFEd3pPb0NlbE5XOTg4SWJIaHVv?=
 =?utf-8?B?TkNvQ0h4aDdKZXI4YkJBK2lJZHV1VVNUbUJNZkR5elBxUGZjeDZkNGRpSElE?=
 =?utf-8?B?eDRpUjFkenFJUzQ0eUYxSkMyN0hpNCtnSUJJWkhlZjZXN2thSnJwSE1TdkpS?=
 =?utf-8?B?Q25QdkV3WVlIaEhBSjZtU2ltc3haeXBSTVlTNlQ5bmtFSWV6cDV2NGlSMnBt?=
 =?utf-8?B?VVhBdmkySlpLUjlWSENaaVVSU212TnpkUkIralV5SHh4UHZtSjcrTU5jTitW?=
 =?utf-8?B?eVljKzdYZi9NWTJoR3RkQ2VSekZBNjhCSmh3VU0ya2QxaFQvanNWbnZ1RUFo?=
 =?utf-8?B?NnlIdjhzc05tc2NQYS9hUHMzYzBwdjNOYU5DVUI2NHNYV0dBcCszNjg4R1M0?=
 =?utf-8?B?dzI0cVltZmJ5ei92RGZCQWFUOEt1a3lLekFXRy9ya3JvK3J5bDVoWTBXU2th?=
 =?utf-8?B?UG1IMHZBV2VzNGRSeEUwWnFxNWdURk9rSEpNQXc0RngvSHpIOE84L1NtRU1h?=
 =?utf-8?B?NmVjQU1Yd0tUdXg2bFdtT2RYUFZrQ2s2OWppWkFDL1RvOENxME1NTUNkRWpH?=
 =?utf-8?B?cDY0NCtzVVlrSXY4WGRtNE1YVWc5Q2dEczRoekgvRGJTRmR2Ui9JR3BSQS93?=
 =?utf-8?B?eEhnRFM4WlVMeVIvQkd3K2NFY1BLWkJiMk8zZG11b0dJQWRjQjRMdHFCSXNX?=
 =?utf-8?B?ZFdXQnlhdHMvTjB5Ym4zRkdYYW5KVHBGeis5REZpcmQ0YlJUOTE2WkZyd3NR?=
 =?utf-8?B?YVk2Vm5GajRRcWorTWRCb2NKTkQ0MjVFN1RDejk1K0x3azI3SmVaMllmYUpk?=
 =?utf-8?Q?MEfcGLEBfC1v/CC5+533bWs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUl2VzFjSmt2UmVVcllpRkhzK1hDUWZBNFlVYVREOUFyK0pabzZSeE9SVVl1?=
 =?utf-8?B?OGxURXlMQ2h0aGF4cVNQL1g2dkhMVWhDbFV5K1E3SlpBUzl6L3ZvaWR4ejVG?=
 =?utf-8?B?RFh6dG5JRmtiYmpkZ3B6U2RTN2l6QkZiWGIrZG1QbGtWMm0xMzFqanZKQ0tV?=
 =?utf-8?B?UDErL1V0ZDVuVkk4NHAwQStkdUR3WmI1ZkMwTGQ5Vm5ObkJybEJBRWxDV2dr?=
 =?utf-8?B?dGJ4S0UxeUw4MUxBQjNaOE1ic0lKN3RacnJVQWt1WGErVjkzL0lMVXNhUTdM?=
 =?utf-8?B?Tld6Q1E2QVlzR09hSzMvSTN6UldVUEErMHhSNlJlNUtrS3ZobFkwcmk5TlhF?=
 =?utf-8?B?c2xtZTVBVGQvNmNXNEZFVnA4UFZwbklJdzYzK0t3TjIreXZERkZFNTU3Q1NJ?=
 =?utf-8?B?UU9YZE90ZVdrOS9OTlpEUU5XU2hoTWkrcCt2NndqTjRXQStmbTlBQlQ1dkQ0?=
 =?utf-8?B?ckNTdzlSMUpmNXE1bmlvSEc2d1p0VnkyaWJyVW83Z0ovT1V3Z0tmYklML2l3?=
 =?utf-8?B?OUNaUkYxeElpUkw1VjJDNXllS2FiOXdsaTdBclNnUzZvVVdBUS9WZnNEaE5W?=
 =?utf-8?B?bHRuWmJlVGZtdmFQYjJTN1BEd1NIVFRFckQ5YWY0bFNxWlpEL1hCQlVOekVD?=
 =?utf-8?B?elN0cFhzOWxEUUw3b2d3QTBZb1k5MEhHMFBMR0luR05rSGNoK3FnMytXVDhL?=
 =?utf-8?B?WnpKOEp1RUJISFlDR1NWaHJFckpwckxvVkk5cFlYSHl0TTlUejVKeWtSVnZI?=
 =?utf-8?B?TDk3Y2w2TWU4cWk0cTdZU1RXc2RaU1g0YmpFeW1rdndwQi9yeVgyUEpZblJn?=
 =?utf-8?B?VnVmS1dGZWwvb3NNcDJlVVRlZE15bkcrQkRoNHdvVk1YbzVheDRLcUR0djBi?=
 =?utf-8?B?ckRiUTZiRU55QktCR2ZWamxZN1JWWnplZEZwY0dGNGR5TS9OeEk2djVGWGpo?=
 =?utf-8?B?SlAxL1l3UkV0cDlwa1FxRVBsWmp1aUI0VnV3MHBXb0dxaXFPZHQ5UHgwMUpB?=
 =?utf-8?B?dWRJRHlST3h5MDRUM1FrZ2IzYUV0elNBMSttU0xJSVMyTjVLVEM0R2c2VWpu?=
 =?utf-8?B?OXMxS1Q5dnpFQmZ4ZnVSelRLWTAwcllPZjc1bFF1RHZlNCtWVHc5bnIybkxJ?=
 =?utf-8?B?VTJUM09wdVRNc0hPOXFRSElPTDFaRjFtQ3N1bElMSUx3YnVOMzRmQS9yMzgx?=
 =?utf-8?B?b3pwd2hGYUxZZFVuZVljbGFiY24wTW5oOTIvcktReW92UkxDTXFMVTIwVW1y?=
 =?utf-8?B?UmUyUkJzUzRIcStQVzdTQ1JGdVJ4Y2hhaTBNUkJ6MGJjSjU3eDNDMmJJOW12?=
 =?utf-8?B?OER0c0pERnd1Vjdrc0RSUDNuQy9xMEhNdXV4SHlQa0wwSFFZdEFVTmZXZ2t2?=
 =?utf-8?B?V290amwvR3IrMXlVaCtyMjJqb25QSzR5Sk8rTmFDSWxDWjJ5dFVEKzgyZGJ3?=
 =?utf-8?B?bXczK20rdVkweUpmOHNGdEVEYVI1bTFuMlR3SE9SY0pvOHVuNVVDV1VLVW5D?=
 =?utf-8?B?WnBLQlJjSm5zQUc4TlRCenVIYnlIZFJMMk1GWGtVYkVLZ3I5SVhyZVBNQXla?=
 =?utf-8?B?NmtoQmNxeHRBWjlOOWtlclpJdkhuRk1EV1RzSXhOZURsL3BFR0ZYa1g1eC9p?=
 =?utf-8?B?SWljelcxR1Nkb3psSS84dXlvK2tDdTM0Qi9mamJGL1IvRlJiQ3lpUzJGSTFI?=
 =?utf-8?B?TmFFcFhpbTFkREZ0M2VqSnVjNUkxTlFaeUE0M3ZteUJVMyt4OVlMcGdJdVNJ?=
 =?utf-8?B?RjNCTGxMUW9YZXF0VXNYdnFpbXh3N0xRSk1QZ3N1MGNCb25XK3hPbEhkU09J?=
 =?utf-8?B?NlN1OHdYWnZvSkgzbnRSSk5FY3BkMzVBQkVBcEZEckVyTmN2YnZiVktZT2c3?=
 =?utf-8?B?TE0vYWNVNGQ1ZTlqTUZ6VW5oOFh1ZkFsQWFUdTI4aDNLMUMzbld5dktzKzBS?=
 =?utf-8?B?YlVDVEFNTndKalVFVy9FV0t4TTY4djBNQ0lqUjdUc1pGUEhHLzFqYU9YYm5P?=
 =?utf-8?B?QWhaR01XMzk1TjRsYlVoSW1VWmFTei8wMG05NHJVNTFlSjJLUmNHNk9zc08x?=
 =?utf-8?B?emswUUtIU0ZuT2VVTkpIWWxmeHJDV1VDaUF2M01HWkIvRU1wWGdjMmVxcFR3?=
 =?utf-8?B?RVMzamZFZU1pYVF4bFVMQW0rc3lkQXlhcHk5ZTRDL2lFTDd1Zk5jS0FPMFpT?=
 =?utf-8?B?dXNCc0h0OVMrQUp6SmRIUzh6RllzODh6aTJnb000MThCTkZuS20zYkg0bTNR?=
 =?utf-8?B?TnZ5MHF5UnNPdmlHaDhwNThibnVobVV2SXR1L3UvT3ZlcjRJNkd0ZGNsNHAr?=
 =?utf-8?B?ZUhRVEFlMlViSTNFY0trTExZdGVycDFjNklXa1lnbnBNV0pQRCttZHgxeHNU?=
 =?utf-8?Q?8tnZl7Jwq7hKzXGU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93eca9ea-c6c6-4638-1805-08de6daf07fb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 22:59:25.5240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWjUeGKMUAAUeHb96ZjpaW9bu7uwuGsYhUhPYnK23LGp7/J2VT51/BTh8iRqQfJqTaI0LMrN2oOTElh39u6zubAHm7W5WYvJwQjpf7Dukgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6726
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71139-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 38756148035
X-Rspamd-Action: no action

Sean Christopherson wrote:
> Assuming I didn't break anything between v2 and v3, I think this is ready to
> rip.  Given the scope of the KVM changes, and that they extend outside of x86,
> my preference is to take this through the KVM tree.  But a stable topic branch
> in tip would work too, though I think we'd want it sooner than later so that
> it can be used as a base. 
> 
> Chao, I deliberately omitted your Tested-by, as I shuffled things around enough
> while splitting up the main patch that I'm not 100% positive I didn't regress
> anything relative to v2.
> 
> 
> The idea here is to extract _only_ VMXON+VMXOFF and EFER.SVME toggling.  AFAIK
> there's no second user of SVM, i.e. no equivalent to TDX, but I wanted to keep
> things as symmetrical as possible.
> 
> TDX isn't a hypervisor, and isn't trying to be a hypervisor. Specifically, TDX
> should _never_ have it's own VMCSes (that are visible to the host; the
> TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there is simply
> no reason to move that functionality out of KVM.
> 
> With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
> simple refcounting game.
> 
> v3:
>  - https://lore.kernel.org/all/20251206011054.494190-1-seanjc@google.com
>  - Split up the move from KVM => virt into smaller patches. [Dan]
>  - Collect reviews. [Dan, Chao, Dave]
>  - Update sample dmesg output and hotplug angle in docs. [Chao]
>  - Add comments in kvm_arch_shutdown() to try and explain the madness. [Dave]
>  - Add a largely superfluous smp_wmb() in kvm_arch_shutdown() to provide a
>    convienent location for documenting the flow. [Dave]
>  - Disable preemption in x86_virt_{get,put}_ref() so that changes in how
>    KVM and/or TDX use the APIs doesn't result in bugs. [Xu]
>  - Add a patch to drop the bogus "IRQs must be disabled" rule in
>    tdx_cpu_enable().
>  - Tag more TDX helpers as __init. [Chao]
>  - Don't treat loading kvm-intel.ko with tdx=1 as fatal if the system doesn't
>    have a TDX-Module available. [Chao]

I went through the rest of the patches, the finer grained splits make
sense. No significant concerns, so for the series:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...I expect Chao or Yilun to have a chance to offer a Tested-by per your
comment above.

