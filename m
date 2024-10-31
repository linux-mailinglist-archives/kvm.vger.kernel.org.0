Return-Path: <kvm+bounces-30269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1209B872D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 00:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1EE21C218C9
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802671E3DFE;
	Thu, 31 Oct 2024 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CB0gGkCO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3AF22097;
	Thu, 31 Oct 2024 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417632; cv=fail; b=gKT5qrxjGj8Hg7db1t2TPAf4afQUXMo3CTnCdd3FQrirZUkzwulQ1rrYG+U5faTqk+K3hNMj9ZlfkrnJq3Janffj9tv/1vf6kOECgs2CO7AL7kuxmPk83s2DgNp+9xmfHwzqRBiyPiBtWy2aZjCxYBQJ8+7gunrzKDaq9uRQL1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417632; c=relaxed/simple;
	bh=kFCneiSrdU11G0DNHcr8v9Om2QLYQt82FqNBttjnm0c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hJqGBWjW8peOl/AOOm/74TSUCcXK/V9dnHXfy88dKJurqCzSj72nTNxS9GUVgWY5QJmyrA8DqIWD+yau42bwETvNKRq59gBAlTsONN3p9wvfXG5BbiD19xj+eZ27xTt0aQotN5St/ZYc1+Ct/cRXMtBWCfH6m7IKicIP8QzsgNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CB0gGkCO; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730417627; x=1761953627;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kFCneiSrdU11G0DNHcr8v9Om2QLYQt82FqNBttjnm0c=;
  b=CB0gGkCOiUHuMrolkSmaEKpLTIkkl2d5OgfeH/7yMOx2Cr45dvaTJDCR
   GEu8vN0YqJhvUcCfDTHpoSwd20lqeoAkfWFUiAYVITMwfFBgwIvU++x0B
   1XKiWue2DmutEw0pt7bodXy8PN77X0Mj4YAYPPZLTN3kMwhT+KgxJtekP
   Zzg15DUioaJwRM6rdV7WLZtFeQm0WiPzXG94chdQ5BIVwWMEA2YeOAvKf
   Pm4DGPTqGz6ptckWUXvGZClTSKjIwc2wKSH5EVMpS1TtZl6YrDNVYfTze
   TR8EmUYz3vR5j3VCwbQH5vOJO19bh28kyii/yt7qq2ja6X/9pBCw4kyCj
   g==;
X-CSE-ConnectionGUID: NWYXmoEbTeKFvMv959ViiQ==
X-CSE-MsgGUID: VMttF/OSRDi/tFUoY+/yaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41282962"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41282962"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 16:33:47 -0700
X-CSE-ConnectionGUID: EYeUHRM4SImoZw/UYgRJ7g==
X-CSE-MsgGUID: F5fGTfsgQX2sFuUuull96g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="82707781"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 16:33:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 16:33:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 16:33:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 16:33:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sm3Wxo/0LPr4FqU2J2l9kFvZJ5jrOvym2g67MWZoLcuWq+eUWVkLNwODsZSD5tZcPGtC03tULvsN2CzjAv4LJR7sn/quaS+/8RU5nSUFcrpkT6wEUzejCmSSHFmWEM2aoH+YWHgprlcOv5Vsu9aINZqp5y3wqtkP6FSEN1rrbvvwSp9r+cI/RdjM4KVoGIcXSSZ1sDAIHZo+9uuRT1aTN98pw1rTIVlpPzpv84gXIJy1uwFfCuVnzRU6MztV1y28OeK5jPRh7BDDoCglOMhXFB1NNGLsaBFmdHqFc8xV66am6fx2b5q9WCsQxND6oGEKXRYBgUPH4N8sNovLrT5KZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6waDSxZwthoxzfco+VEMGmG/j9BFZMZZcpN+v3qwHU=;
 b=hI5eCn6pzehTRoMre8jsoSs4yN7DSitA/zz98EV/nbld3/CZ0GHeYJUkmZMmdafUArD7Vge2UsZRYRMS8fi4Z4EqVmp9kTFeUQJI9KxmGV5BD+v94TqSRyOYPhW/LTb1z8NlgUl/sqS6WVy09x0QHAR6ifTDclWPnuYFFCSLpN836bn7wIvrxSjuFk6yOb/T/Qcemgws7R6/f+W4+n1qbnTHmkicbpIlfAGJKiz6VQ/7ZmU1TlC9x8TMQ22hsBKajQjGvDUoLoRwcpxU5GMv6TwRybdLA9ldGxJ9HX74N2mtXEFa9y5XKZgPcr2tgd81ddcEOIAFtIhI9zDa7kDrsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7353.namprd11.prod.outlook.com (2603:10b6:208:435::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Thu, 31 Oct
 2024 23:33:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 23:33:34 +0000
Message-ID: <b3bdd85c-9373-483a-a205-631016a3a77d@intel.com>
Date: Fri, 1 Nov 2024 12:33:26 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Yuan" <yuan.yao@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
 <ZyMAD0tSZiadZ/Yx@yzhao56-desk.sh.intel.com>
 <0ad78fb6ba88e5cac8b67eecf2851e393c58739c.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <0ad78fb6ba88e5cac8b67eecf2851e393c58739c.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA0PR11MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c96b06-292e-4ceb-2995-08dcfa046fa6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dDlySHBpK3AzaExOWWtJc3JoSzUzS3lXRlgzazhHS1VhVDgrdG42SGdQdG85?=
 =?utf-8?B?RWhXK0JPRFZ3YnJ4ZURoRTk5UEViaFJETEkvNzJDemdTRklKUWpRVk0vNXVT?=
 =?utf-8?B?RGpmRXltcW5aYTVpZmxrRi9iNTlxUHZid1huZkNWLzlXNkhmUWNvZnhkVU9M?=
 =?utf-8?B?RzljeEVrQmNxZFJoNVFBYnA1L3BwY29JMVdVMGg2WERxRmpYREVsWFhvQzVF?=
 =?utf-8?B?SzVqZHRIZVZOR0RuZHYxMzNzTzJGejRGQnUyL2xYdnA5T0lkNjUyUEZpOElD?=
 =?utf-8?B?UlpVaGxQaWZIZGMzS2JtejdJRXYzU09NZVVFbUt2TXZFR1l2MWs3QjNjenhY?=
 =?utf-8?B?K1hIS245MmRYL0lGdHFwUmNiVGFWYzluaHg2RXZpSHJocVBDRitCbWNYZ01F?=
 =?utf-8?B?c2IwUHpSRTE3bHBiTUR5L3JkMVNkejVPZ1BIbmplSUJsQlU1bnVVWGt2SVQx?=
 =?utf-8?B?MXFwckdiUlhhREpnS3EzemkwZWFVelBveWxiZ2NkS1EyVHBPMFMzemVnOHlD?=
 =?utf-8?B?ZXpnbGxiNGYzdVNwbDdlY1BGZlBtRVBPaW40eUpyamtRN2xwRGdGWFhJMWFy?=
 =?utf-8?B?T1FvT3Q3dTRPSm1oZEdheWw2STVFUklScmJXdVdqMUpwN3BCOEI2eExSaTR1?=
 =?utf-8?B?M3ZtQWI2NU1GTWtvUkE0bXNFdi9BZ1RJSnoyZ2duQm1ZN1F1c3BZVzAvYkVu?=
 =?utf-8?B?YkhXaXBtNFhQMWFvRnNiNVEvWFVuaTRSWHpDWE03TDJkOEFBUm5PckE1Z2Q2?=
 =?utf-8?B?SEVFNkRpS2x2SWRRWktBcm9pQnJjeW9RZHB4d0x6N0hBRHUxV2cza0JDL0VC?=
 =?utf-8?B?cEx1MDZwRVd4Nm1rT0tIckJxeWJ4K0gybzNwejhkcmt4SG55NlQvdWpGeFgw?=
 =?utf-8?B?cDVkM1NFOHRGV1RTdFAwNjNHRXI1b2MzcC82SHNyME5YYlE5WTRiV2NzUTRR?=
 =?utf-8?B?c1VHOG41TGxGajI1KzdDdTdPT1FtcElkckxYNTJFRmxhb3BrWExnOTAwd3FR?=
 =?utf-8?B?b0FvTFZXNWtRdkVqYi9EdnlQeityT3VwbzNRZ3lvR3ZMYXFPS1ZndHRtQXY2?=
 =?utf-8?B?bzIvNkJ6eUZBTzNJaWcwWUxZSE5oNWZhOHY4N3RXNjhUT1lneDBENWRKRW5J?=
 =?utf-8?B?cTdiTmR4SmVvQjdmOWg4Qk5VUDRyRUlVNGhrWkhGeUdRTnFUelhKSkUzdlZ0?=
 =?utf-8?B?VzRweHByQ0NIbUVCMmhwSnlldFZKUlZpTTFxbWNrKzZYSTE3ZUhYZEJmNTJ2?=
 =?utf-8?B?MDAxMjhMNGV1MklVZjVFdEhlazRhb1AvczZUbVMxYnZvc1FwelgvdVZTSklE?=
 =?utf-8?B?dVhVVzFJaU5aSTVOOTQzaUJBTnFsVjBWelVUd0IvREpXZi9GL1BicFJZN2g4?=
 =?utf-8?B?TnprbEZ1ZWhUTTk5UHNmMDdFd3B3VVFSdW00OUpQZzlCemppZllnREJqYmZ6?=
 =?utf-8?B?T0VPMVNoSmJBS1dSRG5IR0NaTW4vWnZ2eWhPZjRKdmx0TEt1L2xiejVURDlx?=
 =?utf-8?B?K3VwQzg1Q0pQenVId2NscGZaMlFUcEZHRnZEWlRsOTNDVExXc3pmN1pYcnc5?=
 =?utf-8?B?R1JSY0ErdllhWVZiS0dTVEdhcWFyMll6OENlRUxiaktKdnc1L2F5cjVLRm5r?=
 =?utf-8?B?VGwvb3cyOW5VTmRQMW1DZTlzcTNPYWtVQ0h0cnFGQ3BwNVRoY0JpdkpNZjBa?=
 =?utf-8?B?U2JScVJFbzNkRWxPcEFEQlVjQ2xqMExjd1czRERORWpKOXJMRXcxMGlxd3lZ?=
 =?utf-8?Q?z6UR0pgD1/NkqYZGYBkyP11a4139diu6VB5K4As?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzFTZEE2eWwwM2ptTlo2Ykg2OXFMN2xYZGxxZVJnZnZDczZCc3ppUEoySFFn?=
 =?utf-8?B?T3JSclFsMFlnTUt0MDlmVFlXR2FMWmpsc1NaNFFGVEhZQlFNYkVPSEdrbWIy?=
 =?utf-8?B?WCtOakFuRVAwUW5jV05YbmJrYnBjTENqVlZWL0ZENTNPaHJMMHpYMk9BSGhT?=
 =?utf-8?B?Y2N6TFgxMFh4Mjh5V3hIdlI2a1VQNjRDbUhxZEg0WWtBc3ZuNWtQZXF2RmFx?=
 =?utf-8?B?VS9CYlBlQks2NkxPbUVvZTNRenR5MTRRcHdON1dYUmtMbnhlNUltbzBQbS9n?=
 =?utf-8?B?WGpFSVdXRWpyeTRJS09uZmZmcTNYbEFSajcvazNtbnR0TjNVR0NWWjZHczNU?=
 =?utf-8?B?eXpPRTBWLzg1bWhySlczclh0cGt2REd1MVZZNklSb1FERlU1eE1ac1g4Wmhw?=
 =?utf-8?B?dHpZSERWcXQrQzFsdUZLQ2JtTk0xY0pFMWdsZmZTYkFUN3VPS0tudHdzNFJF?=
 =?utf-8?B?RmpzTDd4YmVpa29lYTNpT1A3L0ZoZnExSTBwTlNNS2phbTF3Y2VmblgxcWJD?=
 =?utf-8?B?M2M0WXVxcU01QXVXNDJuODFMczFhdEpZdmtsUlRQK2lUeDJ3T0YweTRHaE92?=
 =?utf-8?B?ZjdUMkcvWGtMWmI1SU1aT1AzL21LR21hcTVBQWNnM0tROWtHVVMrNmV2T3M5?=
 =?utf-8?B?TkpzU2pNK2pVWXFVSCt4N2FzN1g0MklZdFBrZ1NsRGVZbUlteWlrcG90dDdM?=
 =?utf-8?B?cU9FZzdmSWdXM1FLNlRxcG5MUzZYS05VYU5wZGZSTVoyZUFIUTJFMlNqaFUy?=
 =?utf-8?B?b0xFZkRKd0dGNWlCSEVxZ1VjbXpMNllLbFA0dzlpazZ6WVQydjhUc3J0V0xI?=
 =?utf-8?B?dTBMZDRXVUcxWWZXK0ljUHM0U2t4VFhwcC85eUhuSzJWU3BHOGthRWZTcUtv?=
 =?utf-8?B?V0JtYXdGOHNZMG1DbE8yWlFzdUFNYjZqRGNIaFhXNVo2R1FPOCtZRG93MzlO?=
 =?utf-8?B?dzJHQnJuSTRqU2RmcDRPK29XbGpMdWRqakhRei9BSzJuMXdmOEdnQ1lrUFZ3?=
 =?utf-8?B?VjlERkRjYjNZc3VKM1kwRzB3UHExMnM5K1hPbHAvSHk4RGpJQzQ0eHJEUTY0?=
 =?utf-8?B?ZUJBaGR6OXhJTDMrYlRVYXlIQ1F2VFZsYkN6SFRXNUtZZGRkSkQ2VGZsSTlO?=
 =?utf-8?B?SVBQT2kxS2R1ODRyQ2NtSHU4RzRpaUF4ZmtiYXFqNDdzT2hEMkRTZ0JTeCsr?=
 =?utf-8?B?UHJJS0dkREdYZkNvNFBmMnB6RGNIZTRwNTNZQmE0dSs4WXlxaHJMa0QzcVhU?=
 =?utf-8?B?Mk1tYTFrNUdpYmQvWGhkeVZJVW95U0hxMk85ZVRnRVovQ0IwRkxVWE1jNHVq?=
 =?utf-8?B?VDV3NEZnREhzNFZkM0s4VUJwNVVQMGkxY1dSNnBLYzNoQ0ZwS2RQbkplZXow?=
 =?utf-8?B?Y0dZaVZ1V1FhUStjQ2JwV1M0NjRyTzM1alVzUVpubTI3TnR0L2pkSS84b0JF?=
 =?utf-8?B?cG41bG01Y0NtUkt3WDFJRForbWxSZit3ZFB5c1ZOWFNBemNBSTFjQVRLOVRn?=
 =?utf-8?B?TmJ5VlJOU2o3bUM0cEJ3UkJoUjRleW9lMW54ZmRXL29jQ09yNVlKeEJIRXpB?=
 =?utf-8?B?eHpjVG9TOStTZzJlWGdtRUZwTERsYlVoemFTYy9QelhIeUI2MGxsNUtlVWRZ?=
 =?utf-8?B?bHpyYmtTSnZEN0Y3elBkdDM0KzNsenE0eXhPdklWdjJ2VDR2dlFISmhzd2hD?=
 =?utf-8?B?T0xkTkEza0t6dHRmTzJUU0l1bVkrbUJEdUhOTmpadm1tYzRyei9Xek5yTU5C?=
 =?utf-8?B?SGlkbVhqTHhSWHViL0JFdVNwOU83MW1jWmFwRVVHSXI1anAvUDVUOGFraHBy?=
 =?utf-8?B?WWpJSTZHSEdqaVk3c3Zsd3FzRyttSDZzaWRmOHhHNy84emt4djFhUTVLVEQ1?=
 =?utf-8?B?YnNTazkxRitBdHNMMmFQTjh4NExrYkJUN2Jra2g2elRYdEZsc3RkUTJLdnhW?=
 =?utf-8?B?MnhOcjRsY2cyT01OeVhReTZNcFdIMG5EVWw4NWRDcDRyQ1ZiWEFML3F3WElt?=
 =?utf-8?B?cHZNd2R0cDQ3MFEyR1RiWENiWkY0NWxML25yMzNtaDNwYllDbWd0NS93S09D?=
 =?utf-8?B?NEpMak9ZaFpYT3ZGVXdsczE5bnQra1kxaWFDS0JIbEYxR2pLY3dYVU9Ldm5y?=
 =?utf-8?Q?dJkSL/ZbWClww9+LRtuRbFj/3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c96b06-292e-4ceb-2995-08dcfa046fa6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 23:33:34.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhdZZSYzjBK+8wremznVv2w49+8HArDaFSlzVMyqxGRJurIDT+kxgszcMHjUwJedwUCkrPgV2RS7GbCkiIZg8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7353
X-OriginatorOrg: intel.com



On 1/11/2024 7:57 am, Edgecombe, Rick P wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index bad83f6a3b0c..bb7cdb867581 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c

...

> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +       const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +       void *page = __va(page_pa);
> +       unsigned long i;
> +
> +       /*
> +        * The page could have been poisoned.  MOVDIR64B also clears
> +        * the poison bit so the kernel can safely use the page again.
> +        */
> +       for (i = 0; i < PAGE_SIZE; i += 64)
> +               movdir64b(page + i, zero_page);
> +       /*
> +        * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +        * from seeing potentially poisoned cache.
> +        */
> +       __mb();
> +}

Just FYI there's already one reset_tdx_pages() doing the same thing in 
x86 tdx.c:

/*
  * Convert TDX private pages back to normal by using MOVDIR64B to
  * clear these pages.  Note this function doesn't flush cache of
  * these TDX private pages.  The caller should make sure of that.
  */
static void reset_tdx_pages(unsigned long base, unsigned long size)
{
         const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
         unsigned long phys, end;

         end = base + size;
         for (phys = base; phys < end; phys += 64)
                 movdir64b(__va(phys), zero_page);

         /*
          * MOVDIR64B uses WC protocol.  Use memory barrier to
          * make sure any later user of these pages sees the
          * updated data.
          */
         mb();
}



