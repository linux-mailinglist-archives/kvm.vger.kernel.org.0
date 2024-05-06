Return-Path: <kvm+bounces-16680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF268BC866
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BF601C2034C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F50140E46;
	Mon,  6 May 2024 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HReM/PSv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED89137747;
	Mon,  6 May 2024 07:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980697; cv=fail; b=InYm1gf64LZmgZyVMQhpd9Ochp8gPU0wtX54OF6J1WfTP3CTDaau4QKHu/SoJfhZvg56BXjFRWGYSfDEofH+OqEi9MzCc8EUPgxGpSKAaVAXWBKfGIPtYPclrl72LgwKNCwDID8SyQjM+uDfI7jvjFRXiX+xtC/Nz8F5+prlrf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980697; c=relaxed/simple;
	bh=0SZtqFDb3AeM4xyvjz9N2X8V1CIQ1iQjd7V1hAQYY3w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PlGLNm5pEynltlbUvrt8bWHmElxP5qcCN4JNgz9vlrhYOY4MYYLX5PbohbbsCmJ47yEiVsnKHrkNMOm4OFrwqM1f2Vp3E35SZECTJ7pN5wa/dNGGP9xjhb8hpNySQvgCQOoAR5dEp13G+INxeOrz5CZoc8783Ojqsck6IkKrYRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HReM/PSv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714980696; x=1746516696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0SZtqFDb3AeM4xyvjz9N2X8V1CIQ1iQjd7V1hAQYY3w=;
  b=HReM/PSv6p/T3tw0LTRZh85j4FjzgdJU2AhR/z464YAObwYaujlV8wTw
   fopaXZAMpvxEGiJsLUdN1hBadMEHzF+ylRJCtrCUHrDFpClFgWZzx7kR6
   StabfncUss5ZBaHLbp3RbGE1yjAzQR9hiI+l1rqUbTXqB5Ajwvv9h4DJy
   DSDfJAnmYzRRK/pshKLph+9MY03cVbwgIYX3+JFiNL27+o3U98Fe2TQiT
   mCsHAW5Y+tnGDWbILZj32LcGAz212FxwjVt/bCzQvA2srDF4r/M8zK08p
   ZKayhy1h8ejRH7stLV6h2VTNafEqV6oDYpvN26DX/mWkPIIUHvouOlXlc
   Q==;
X-CSE-ConnectionGUID: hUSXP/v/SvyQ86Fp5nRg2Q==
X-CSE-MsgGUID: iL4SmNWOQKC8gihV7L/nCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14519552"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14519552"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:31:34 -0700
X-CSE-ConnectionGUID: mTJfdvY/S4mUD9u85QvaLg==
X-CSE-MsgGUID: R48jCoYJQV+uYLuUcPQDqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28191293"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 00:31:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 00:31:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 00:31:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 00:31:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+cfSvLdu7iRnzGBM8E/f3wAH8joSTBUNW0ljae/VAASXnRzXFoyh7M3+eMvbAU+3IFhqigtIR7tSaf9Pbl+08aTXbSlVNa4rZvYp54/77wVhG9AoB/adwGUBWL0vjJ4jNxU/l9Nvivd+jJkXTCUHuH8Bv2m43SvwyXyljNSH+rytMTDz/ilcRJQpwtAyLNbHH/+//T/WB6p8r1NV1B1kPMVLV8G4kHMeyQNu/5Lpwx9o0EpXIjdNQV98e9RDwK1O7KUulgKXYTLC1h5Qxv7QfQ9Ctv55nUA62ARuReiP7n1AkRSkDTh9CAeZfr304KugaKhBn1puHt3QA05jjkuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPJFsy2ZN68psZbLaevXRQdccUaPf7iVsQZq+rdBYfc=;
 b=XIwN3bWxo/bqWXD7PsAET26FHfu/FMWoVmnhfFSsXeQ23LVDgRBYKT4bj0v/hhsF47aCQiWtLMUe3Kia9BGVi1KX2wPHhMwtVCwJajPSCkK/blWmp5ycqL3QUlnlDr1VWJP24HfX7XHQwjY7BDhifuxczMCSpyKscEckFDeqtXp9ijFk1LDbOEurA617vedc1ifg7zUCfNrsNrdgs/fOw/zzUrqcV0N60UucRL3zhb7Fk50EBTeUpooKGsY63icX1r7/vEJ8DkJrqjG1II///CpRL+aoGW5pRjDOqyqoe4XK4kA0GU7BDglUdyY0OSte2HRkVpKNv+BYjrni0PRa5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 6 May
 2024 07:31:30 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 07:31:30 +0000
Message-ID: <b0ccf68d-38e0-4522-8a54-974d5a711923@intel.com>
Date: Mon, 6 May 2024 15:30:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/27] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-14-weijiang.yang@intel.com>
 <ZjKphDaJ5Bq-jTVx@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjKphDaJ5Bq-jTVx@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4790:EE_
X-MS-Office365-Filtering-Correlation-Id: f5badbc9-0dc2-49db-156e-08dc6d9e8bf1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MXQ3RktEZXIzc2t0aS9iRlM2YWJEYnZFUHd2bUY5NFVaelg4bWE1d0JiRGph?=
 =?utf-8?B?bE0wODg1dTlnc05lTXJtcW84bHRCVWVzS3JMdWxJbm10ZXYwMXlieXpoMU1r?=
 =?utf-8?B?ZWhiZVFpTVVrQjNjQi9kczR6V3d2L3ZMMkJ6ZjE5Z1hhWnNpb2ZMTXpUS3JY?=
 =?utf-8?B?ZzFtTFI0clVVN3BDeERiZEtucndUd2tMS3Jxa0g1UDZVc3M4b1dVbjBiV2la?=
 =?utf-8?B?SWZQVnJVK0JzL0gwU2xPa2NqSStrbU90elRBYVVxSlZzOVJIK2JXb0R5QWhs?=
 =?utf-8?B?RVNWQTIvYy9uR3JIUHRQUmFydnljVEpRb3lRWjhYYzJIb1NlZFB3em9VbDRB?=
 =?utf-8?B?b2ZWVnEzUUhWQkxsY0VxWk0vUmlUdnVYa3c0NmhXS0FHR1BTY2FxeTQrUkZE?=
 =?utf-8?B?eWNkdkVvTXFDNWsvTW1kSWliTEFOWlAvR1h3cjIyNWNaRWF1d0l4MzRrclp2?=
 =?utf-8?B?RXptK2dpcFZpQmdnTkd4SklKTnV5OU5jMzZHM0NWc2xlUDlwNWpFMDJaWnRD?=
 =?utf-8?B?OGFXelNVRUs4SkNmQnIrK0ttNlN5alhaVGQ3Wmg4ekdNYUEwbkdLL3B3V2Rv?=
 =?utf-8?B?VzB3dmJiQzE3bmtkdmk1TVdrWTFBdXZKZktJVjN5ck1OSmYrTzRoSzFUeFp2?=
 =?utf-8?B?d2Z4VUhwSmUrN0dNWXBxMFJ3VDJKNXNVTjltK1krWGdqQ0drL1lrSlMrejNM?=
 =?utf-8?B?dTk4NmZzL2Vqamp5Y3oySjFqYk1ZRXNUbGltK0JyRDlSOTZwR2xrK0lxQU8v?=
 =?utf-8?B?NUNHWnIvZ3RWV1Y5a0ZpcmQ0NmRpclFIclBVUXo4a256Nk82RXVtR0R4ZlRM?=
 =?utf-8?B?bFRxWHBQVnd4NnVoT1R0SWhJN3VYQmVYVGwxV2hqVkwxU2VWR2NDbmg3SjlD?=
 =?utf-8?B?RWIxbGRSVXc2akhWaE5wNUVxcDM4TkdSbDlDU1ZObHBOdVFHM3BiQkxZV3dz?=
 =?utf-8?B?SEdEb1ZUTy9mbXRsc0srYUNXL0N3UHRhTW1TMTVvUTFGL1V4UG94cmdENTFo?=
 =?utf-8?B?NVpZRk9wSFJjZmlWZUxaaGpxTlN5Qm9ZZC9YWUtnSnYwSFowMXA0WU9nNmQ1?=
 =?utf-8?B?d09aMVRuMTFIVng5YzJIRlRmRksyNThOTjY1byswdEJDcFpaRjIxYXJlZXZy?=
 =?utf-8?B?Wjlidm9oQ3NGRFhpTFQ4NnZiQVd1M2pkUER0SWcrcGRMZGdNQnVqenJTajln?=
 =?utf-8?B?aXNVU3hMK2hJOHVOMXRvU3RBQmc3VTQvRndFWk9vM2pseEdybUVidGV0QVRZ?=
 =?utf-8?B?NW5aNFliY2w1Yi9OOHVIMG1iNlJSWVpwWUR5YW8vVlFZWFFrTEExb2djREht?=
 =?utf-8?B?aDRQVSs2RVZZZTZ6bndIcDduWjlOd3VTMVV4SVBSV2tiRnlaNjREYktKK0Jp?=
 =?utf-8?B?OUZnZE4xQ3dJbndNb1BTNlpiNVRMVllIazhUdTJxOUt3S2Vycjd0WkFaZ3NH?=
 =?utf-8?B?MkJBeVo2RG9rUG55enBRd3E0TzdFOG5tQnc0Mk1nOXUvamRhdE1VUUt6MU5v?=
 =?utf-8?B?UE41OU00VGdNcHg2WTlWYUlaL0cwNUk5WGVPckpTYlU4UG5vdzBhOFJOTUJQ?=
 =?utf-8?B?Q25sSDlwTFVMTkhJb1hUQlo3OWFiOGhOR1hVZTQ4UFR3djVBVzFON0xRcWd0?=
 =?utf-8?Q?2WjayyZ+YjcYicjVsJp2y6VGn8E5BnKyutSgu9U4OIKE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjhKcStmTURpaDYrT2t6Mnk0amNjc1lUYVhsWmVKb0VuNWhZLzZWdUVmQng1?=
 =?utf-8?B?QittbTl5Uk9Pbld0QXNjL3BoZm9RVk0vVGZyYlZweDhFc0VHY1N5VHk0QmU0?=
 =?utf-8?B?VE1IZVpMUGUweFNPWnYxN1pCenFkaVBDd2wvV3Q2OG5rc1NDVytyMVRKR3FS?=
 =?utf-8?B?aUE1bmpFdU5iWXEvclU4YzNMa1V2WGYvVDFFNVJLMEtxSjVLa1BMVmdXZ3kz?=
 =?utf-8?B?YkNjRWdKMHN3Qm9aNzlQY1JtQWIvS0J2aGpCQ2Nrd2RPc2dPQVlXbkVuQlJD?=
 =?utf-8?B?N09DK0pYRkErVENRQkFGa1hheUdBUm8wSTRISGROVXZDNjFFVmJoT01HRHFp?=
 =?utf-8?B?OXJwWHRaQXhzTmZiUnVXZzFNQTE0YlUreGV6Nmpsb3pZYnFlS21mWGRkVjRX?=
 =?utf-8?B?TXZuckFaRHNla3REZlNVN3AxU0RrTE9uQWNQRnpHMWVEVjNVcnV6NTFLNWR6?=
 =?utf-8?B?RXR3dUFoYjNCNjRMMUYvaHo0dGtDcm43c20wVlVzQlV5YVhkWjN0UERWVXdZ?=
 =?utf-8?B?bWQrbGNrakdXYjRjajRsR0xEcDF6Rld5ckg2eXpQT0NvMjVacGtQY1p6Z3pS?=
 =?utf-8?B?aldxcHFJSlE5NmNucXJWMWtXM0laNDlXV2ZWRDJqZS9NcVNyd0lvTzFmTHZI?=
 =?utf-8?B?eHhTQ01UVTFtNFpqZEJzNUNDNllSSE93KzZhRnVDYW1oVFJMWkorWmp6QTlv?=
 =?utf-8?B?Tjlwa2VMb1UzcDBzVXZ3WlBMQ0E4am5TNUhJaXRSak5NN1ZSUFBScy9RTXFY?=
 =?utf-8?B?czErYSs0OUI1Vmx4N3BuUmF4OEZRNmlMOTBaTTArZFpxTVhzV2JHdnVKVnBE?=
 =?utf-8?B?QmNtZ0JZS2d0VURKY1MxU1JTbDJpaVhEUTlVMm9sLzJDOXUyTC9nb2VVWUVy?=
 =?utf-8?B?S1B5OCtaQVVEcjdvZDJKVVBKbjNtb1lDaENvMi9Fd1EwWDNjcTFrMmZ0VUIw?=
 =?utf-8?B?VXVNM2RFR2g3cFlhMTFaR2l4TDBNQUJMcERNNDF2VFNEbmdhVllURCtyMU0x?=
 =?utf-8?B?bU0wekI4dTlENFhzWnd3U0thQ2lQWEtHVTBoT0RmcTJtWEI1SVdteDVMK3BZ?=
 =?utf-8?B?ZG9tOFF6TjEzNWt2djNsN1BHTlp0K3JnS0NveUw3UUJPdVg4cCtBRkVTUjRT?=
 =?utf-8?B?ODZYV2d2M2wySFZ3dXRKWmhRY0k2YWpwa3hVRU1aNkc3UzdVcjZNV3dDYkdp?=
 =?utf-8?B?bXBQbzAwMmZRN2s2Q0t5N0RYcXlmcVpXbWVqaitrUHhSTzUzNERMRVNRc09Q?=
 =?utf-8?B?SDVEcitWTEd0a1VsdFFBZ1lySWFIZXhzUjJHSjNBLzhWNWxndGhXSEJpOWZa?=
 =?utf-8?B?eTFidVEvY1BFSnRDa1Z0Q21FVmlHTmZVQmYzYTkvM0Y1RGlFS1ZtUzZ4cTdw?=
 =?utf-8?B?UjBCYkY1Wk94SmZhdDFPNHdsV0dRRVdTMnBvQU9qSitvaC84ejUxRlQvTXBX?=
 =?utf-8?B?YjNJbmxGL2V0azc0VGtMZEM0cVQ4Wit3d2l1UFpGKzIxUUJUbDAvUHA3MUtk?=
 =?utf-8?B?ODZnU2l0U1kxMS9hdGxEQldnalhPNHhLUTk5TkVPRUxlZ005MTFSV3JNQnVE?=
 =?utf-8?B?VGVJaFBRQkthUnlxTTNsb1RWZHhvcE9uV1BHS3QzdUZhbmtGL0hSV21GSnlK?=
 =?utf-8?B?NEtSNTRhemJ3QmtZVE9ZVU9Mc0xFMFRBYTMyNHVMbGxDY2IvWm1UVXNYaC90?=
 =?utf-8?B?TmpXdTM0TUVidlJ0ODY3OWRReU5wMzJiR2s0VGQ4QytqNFJ6aVpBNlk2REoy?=
 =?utf-8?B?cDBkYnhKU3l3dlB6dXo4YXRKZ3Y1L3h5RHJ4ZFR6dmRBbWppYU9EODZoRDBE?=
 =?utf-8?B?djRXRmkrNS9jT3JDRE9CQTJLdFkwT1NiRTNxSnZFZFFEWnFVdDVlM2t0VFQr?=
 =?utf-8?B?ZTVqbWJRQUZ4R2plTUpiTGZ6WjNLNjNrT1YwNVd5Q2lvVEU5THNXUDRzQ1Fw?=
 =?utf-8?B?aE1rRnJGa0JHTkR6aW96bTUxeFd5M2Q0WTZZbzVWS0VXRzNCNno4WEJXYW5k?=
 =?utf-8?B?bFR1SktGZWVEVmxpazNPZGlDWDhGQk8rMGxuUXNHYlZzbnF5WXY4NFMrU3hw?=
 =?utf-8?B?bnVOd1B1YUVPTS8vckRpaTNpa2N5azBqZDcvb1ZZWE9lcTdiTlZjNkJwQTdO?=
 =?utf-8?B?SWVRNkZXQTYzMVpmWUNtN29ZbERtdWhlckNJVW9QOFg2V0xKcklYOEFLb3FY?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5badbc9-0dc2-49db-156e-08dc6d9e8bf1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 07:31:30.3623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpHBiIDxFHek88h/Hx0wtDA2qYtAZOmpAm3rppL2SCvs6iaHyM4WAe0qtHq7O3p3pD4jLbwxe6id2w6QuSfO1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com

On 5/2/2024 4:43 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9eb5c8dbd4fb..b502d68a2576 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3926,16 +3926,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		}
>>   		break;
>>   	case MSR_IA32_XSS:
>> -		if (!msr_info->host_initiated &&
>> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>> +		/*
>> +		 * If KVM reported support of XSS MSR, even guest CPUID doesn't
>> +		 * support XSAVES, still allow userspace to set default value(0)
>> +		 * to this MSR.
>> +		 */
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
>> +		    !(msr_info->host_initiated && data == 0))
> With my proposed MSR access cleanup[*], I think (hope?) this simply becomes:
>
> 		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> 			return KVM_MSR_RET_UNSUPPORTED;
>
> with no comment needed as the "host && !data" case is handled in common code.

Right, I'll change this part after the cleanup series is merged. Thanks!

>
> [*] https://lore.kernel.org/all/20240425181422.3250947-1-seanjc@google.com


