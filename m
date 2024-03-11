Return-Path: <kvm+bounces-11481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55769877966
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73A3C1C20E20
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D74210FA;
	Mon, 11 Mar 2024 01:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5tNGb7t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9247A7EC;
	Mon, 11 Mar 2024 01:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710119295; cv=fail; b=YWFORshQiESH6Nu7rlRppwJTgcjaZUMk5mD/ID9NzPSkZAMg5ta9b9vLRF2KsGWzyxe9uozSWvK7DFSJM1aFbzx4bktcCSpRH42IJmvzXCIZwzNEIMwJD5jooIUmcos8Rd8TjWrMPsHMQMAovVAVBMbwtghAfkg/Uw5AO7GXGR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710119295; c=relaxed/simple;
	bh=9DaUm0zmMYnfIvOPHB1rDOOROOhH5qjmdDsfgfM9fMM=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ipzYQFqwn1Oq9tB4NRyw481lacu07TFUVNUi1iRmIZHhj3WyCLdk4cxX9Sh/VBuCNrTHI4QdyshBoa4FjJYvXRlYKSgHBriMsvWwCJlsycBW/1kTTm05okCxW5g4Ve6Ht2YAEdoz90PUwdnJiLpzHWK38CRmZYWAPsQOV8wJjUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5tNGb7t; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710119294; x=1741655294;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9DaUm0zmMYnfIvOPHB1rDOOROOhH5qjmdDsfgfM9fMM=;
  b=I5tNGb7tlxNtMKNCyyWFEwWwXlWD1hNAIsV1KjmaAZFYgA4pVaViqeyB
   lxYOvA59TR9xtKz1TyUpm+JLOkwD6jiGN+5MozFT5Or7l9MuaGNDgPVbU
   BQ6KXGiJSwK3bQnAxxDCacXRYszf5wUXXnz+gSLsbpCmoyA31XjoTj04E
   6zDmnpzIBamPPKU/e+yjRpW0Eb80osmPzEkPP+0GFcQbaum0xFs4pQjEX
   Q1VZ5lLw/F/rcNszfeeXfxqUY2UDFUXctGpEqotjifj44Ufif8nFy05fC
   Uj+nynaVYMnv3ZiUNH83qoO4drQ+HXJ4V/Raj4GvlVSwc32c4UpljzXQW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="16203964"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="16203964"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:08:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11445915"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:08:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:08:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:08:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:08:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etTogKAb8VQRdHbnI5j7PwHV8LDeztOTbl9CSrnZemxYYnIZB6j4sH7AUVkXpco6yCBqzTtWosO8Sb29W3oqdbyA6tKUh/eHURlak6KtwrecAt4nqvg+fQO3YiD4WDxdg8lb+HOpdmoOHU639RtAI0BES4bqpWbzGBFp1TX+GTDggWcAWzouWkgcoSsTpyhBUHn8yBwkTh+EEPYjsxRhEu6grI8gBSjFNVWNY82xC6x/eAf4rrd2cSYTufsTsskW3MS4xHr+LU7VASz7A1KzY6xI17eQSl6QQnBg06Y3HhMLvLds8l5ris2ShhiUi/DzfC/GTO0DPAHYOuyRcXS6Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER2vBc5wLhhPlq53du3xnszxinaFJDtCYc01w3GNeMk=;
 b=iKMhHAkfGr4YZuotMFFwiBYS4SJI4ZtqVOq1cQ1eGIBGhqIpXTghqEMB8aX5GQVcg6FMyOaMtDSX6DVVFitKilY3KQwRb0SpC5uhKSYCKbKhODrwHjb1mI5VfYTv+gvxlOicknTECCXxo73w1c1jnK5TBfLiIhikkDn3IdcLbEnx4JRv86wQihqLcKM/ijm3jMWFdOoQOZIA6EBeJE/4bO9VFvzWvu4jxgP7mrcfQ1hdGIrZTw9tFJwZjHpOXs3BXi6IPY7w0GLCyFymKtZPPepsJQfVJXxzpzr01ccxrJ3Gr287/qf/HEUO05ajgodKyzMXxxvGKdZ0T4nh/X1L6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6441.namprd11.prod.outlook.com (2603:10b6:208:3aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Mon, 11 Mar
 2024 01:08:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.014; Mon, 11 Mar 2024
 01:08:10 +0000
Message-ID: <bf8e5e51-422f-4ecc-ae10-ee13c68eea8f@intel.com>
Date: Mon, 11 Mar 2024 14:08:01 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: David Matlack <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com> <ZepptFuo5ZK6w4TT@google.com>
 <20240308021941.GM368614@ls.amr.corp.intel.com>
 <296e1196-9572-4839-9298-002d6c52537c@intel.com>
In-Reply-To: <296e1196-9572-4839-9298-002d6c52537c@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:907:1::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c775f3-6c0a-4452-49a4-08dc4167b7e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXBKfVh+b7SBw1dhMI3TZIQ6uTaUx3y+lpr0LSQ0pAlupyWc9oDRWa4ER/D/MNGjD5+T0zX28IIidi3Bu+4MM0ZojbDAhXZkf2XoVsPn0a92NPsy0D+JjGRp53w4mh+uRpUmxWJMVHDIekWZDnbxvrtXg6kYHxZ6xMQ8rfTDSxq1e6fcbJnHCVyGhJzZ7RY8Sc94wEjMEAC7HyRC2PA3Yc0fkU+5fTGmF14z3ofqCpTR6+gRh+GN/cJbWKau/UMObZ/TkXbnWX7KYokocbGVa+sofCspcUO0KpluleAQbcgrgKoPm2VXOiOT5LScCQM/XPnOh3IeEmPUG4+DY7KFA1Tz8XPLK2tFMWSMJy8aj8IfvOSLgR8kEDj/3VEG8jtQyDUxC2yXlOphFZJt9KaQBJ45xYX/9QUKvn5ThRNG+oUt3b7SGA6zD2YcWK9T4jzos/iusMyGhsX1Hup4twx+FcNjRgr9HQPafTho3Fy6Dpa0Ml8T0g+t36PaDrXYswPqhaVlk1WCCLOg7ga3mGnfw0ARSbxyZzbQPzDdDQWvCmR/Wv13P94W5WkNQ1jiJWHPbZSQtrW7qA4Wgib+dyKKe0TRUNJE2cnkJhXgPivsyViml6u08nN6OVByz4nbSL4KGC5HjkpV00HFp7QUwLpFdcbyFzPR17E5D1cYX1Sy/i0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0lyZ2VkWXRBbzZ1eDB1Z2hsV0Z6SG1kVkFZK0Ftak5ha2V2QzVSU0kvSTNC?=
 =?utf-8?B?TmhJd01MdUowMTFuMXIyZWhlM01LMHZaK09KVUc0ZU4vVjlQVVB6UzNFMExI?=
 =?utf-8?B?cm1EdVg1bFNrSnI3ZTY1NlJxZmUrYXZaNEJPb2VoUUZRc1VpYzUrMTNzVWNK?=
 =?utf-8?B?Rkc2VHRQcnUweGErNExnZ25RUzAyQ2JWanpUOEtkSUpNL2owajNScklrRjNP?=
 =?utf-8?B?S2dVYzVMVlkzcTlyR3VISWRoNlNOMXluMUp2ci95enNHTzVEZnBONklOcmND?=
 =?utf-8?B?YXRKeW41MmMxTEdjQWtoczRONUV6TS9GWFJEUGFqSDZZVWRLeFdxTWFmQTlR?=
 =?utf-8?B?SjRFdE1QbmhlRHFiSU55aFZqMlVNUGs3OVUrU1MwTUZhd3VPOTNxVjZ0eDdz?=
 =?utf-8?B?TkcrUlc0Z1JFc0pwQk52bkZYc0ROeXJmNTB3Smh4aGlqclcwRi84YWZSY1ZV?=
 =?utf-8?B?dWVBdW5VQmhzVkF1Rjh6OGNZUVMrQUg3OWIrZno0OVpWa2wzUWZQM2UrNGo1?=
 =?utf-8?B?ckxML0ZoSWVxcEE5a1RKMmtKVGk0a29TNXZSTzdzdExpK3o0djJIKzlPbWZ6?=
 =?utf-8?B?OE14SksxcE16SDcxVTNUZXNwYjBTZDN4QS9qcTdZTGtuS1FKLzQ3TmI4R3pD?=
 =?utf-8?B?TkN4dXcxRkdndUhuTHNtYmtycStDaWVFOHl1bTV1cW84UmNnS2hyWnM1ZGli?=
 =?utf-8?B?UTg2VWRidnEya0JVZFRJNnFsa25hN004U0xIWXA5T1FTdUNaQ1lNekYxUCts?=
 =?utf-8?B?MVY3Ty81Z09zaVJmdm5yT0dudHk3cTBlNTJ6N1R5bzdXcU5kdVdjVGNMNmVN?=
 =?utf-8?B?UXliZTlGemdsd245YUpuaTVaWUIybFdhYitPN0lnY2hiTDlBZU00WUI4QTY1?=
 =?utf-8?B?VG5vKy9Tc29qSUtleFNRdTRpU0I3K2dxUjNuU21TdVU1RnNJTU1TckdORDhw?=
 =?utf-8?B?c3YrN0t4d3NwK2l1Rm9pTVo2T2dBQ2l2Z3VIYmZaTEYyakhjUzBhTjlJVmsz?=
 =?utf-8?B?czRISGVwSGVMM0hvelB2K1Z0clFQd1hGRXhNbWxyS1BJTGd1b25mV2VrMlZE?=
 =?utf-8?B?emxHNWdzREZkd2VaUUN6VWc2Rk82eUNWeHVwRjBleFpjeEovOGpUWUplOUR2?=
 =?utf-8?B?MmJxNVZ2d1ZPb2hqRk11ajFYNktGQUgxb0ZOUCtDWE9KR1c1VkFKTWJWaHpa?=
 =?utf-8?B?MDd5NDJaYWV3WC9JTmZqUUxIdWV4OEg0KzloTFJoQkE3QzVFUmVGSTJzMFhw?=
 =?utf-8?B?b2JnTlhWVHlDOCtjUzY3dEFiT2VwTlFZQWZjd1pXRVRVQ1dnenpBbHpGQ1BR?=
 =?utf-8?B?cVh6cGwwd1hxWXUvS214RnN5aURWMEZiTlB3RFFXbFJiV3hzSlRXRU9NVWhq?=
 =?utf-8?B?S29vU0pkb0R2cFhDU1pqTWZRT2VvUzhMbDUvTC9aa2IyaTJIV2pWazNTUmlL?=
 =?utf-8?B?QUFnN1FLTDNjemM1WUpjOTB6QVFSWGcwNlVha2FEU2NCOVQ1blkwRWkrUHpw?=
 =?utf-8?B?U1haUGdybnBkS1BFK3YwcWtxWkk5VGVvUkhXd3g2MWF0NHE4b1lWajJ2UCtL?=
 =?utf-8?B?dGJTNHNlazlOQjIzcHZoSEJ6TU5TOGtrbENEUFRVZ1QrcDlBRG5vVWtrVDl0?=
 =?utf-8?B?VHNMaDN5d1ZtL3Z5S0hHWERhRGFwY2dSOGFka3k5VkluK25LTW5GNzRQMXhp?=
 =?utf-8?B?QlJBOHRCSUpEZVlnbE5jaklmU3lmS2R3ZVpMRER2VjNaaXZjSjYySjBkcC9C?=
 =?utf-8?B?UElLWVRXcDJ3bWtNSXRhTjdya2htWnlueWFCaXdZK3p5SGVkc0VMeUJIcXpE?=
 =?utf-8?B?c1UzQVo3UElNZHlYMThYSDVKbkJPODF5NVArTUw5SHYxUHR6eDluZWdmYllU?=
 =?utf-8?B?WVJNdFlubFNsSWN0WTBBYWw1TDA5eE9rYnhBOVE4bEdNTEt4MHVrazRHUkFJ?=
 =?utf-8?B?VXAzRkNrVU5yU0VqMDlmOEVFb2FxQzlibnRVTGw5WUplZXVTRGZZbVI4R2ds?=
 =?utf-8?B?bENVTlBLQVBnNXlNZDZnK1JaYlZ3aE8zUDhQdDZUdzNqN014T1VTZWRqU1lJ?=
 =?utf-8?B?V3lmMEk0b2kvVDNKUTJkajkyWXNGYVdiUnBsY1pjQmNNc3BicGl4d285cUsr?=
 =?utf-8?Q?jIU+1FgJAZGam2CbITHA/lMT/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c775f3-6c0a-4452-49a4-08dc4167b7e9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 01:08:10.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfwExovMrbKrDHFCmID0G7kH4+w35GERerXgso1aPc+2Ju8gbBSgxL+zsUiaa9d6zHQeCg8gzlQpb1utkKiz2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6441
X-OriginatorOrg: intel.com

Maybe just the "underlying physical pages may be
> encrypted" etc. 

Sorry, perhaps "encrypted" -> "crypto-protected"?

