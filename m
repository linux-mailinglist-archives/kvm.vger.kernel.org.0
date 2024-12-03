Return-Path: <kvm+bounces-32942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1E09E2A33
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8110164212
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E6A1FC117;
	Tue,  3 Dec 2024 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmuLuc6O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6D1F75B7;
	Tue,  3 Dec 2024 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733248916; cv=fail; b=egkEhgmafd8+iLOOZ4bLpVQNMffjjPKzNqbte7Qmm2+/hq0XceUU1X0vuKUdXP4e1Hi64W0DJWeNMo6t3Utze2QgBWwZgmImMU7WpP8WYC/xTOXqaiuKo6cAlfOdqRoNLwCVAdthMmYqTJUK29yQdlthD06huK+/MliLUWAHWb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733248916; c=relaxed/simple;
	bh=mnHcQ/EBT9j9E/Zob+0FPZVmrVXaQbz5yzRiDP6kPLU=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=McO9kgLoz7Z3+m/lzSz7qauUWCRntS/szNMtunCd1Rc7+EZPpgphCZ6ZCIEBOuCpuqXflBULQoABVRLf3NQPE6JtR/kWWr5n2LsES7n5PTbRvDbws2WeBya0WmHYdRxsG3TMkCOhu3yZQ9AFMNmYM1EfLWCcApwovY9wHYPKeg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmuLuc6O; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733248915; x=1764784915;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mnHcQ/EBT9j9E/Zob+0FPZVmrVXaQbz5yzRiDP6kPLU=;
  b=OmuLuc6OVxrxw04At521RR1DKUDGH8aMLtp0oRF/by0adBBhEedti5Np
   Cqp1CMGtGY7Fyqor70Gt0Bsx4sYg8xQiImnFja5/W0kpxie6gFVKc5cZY
   Cgp2wi5CuCrXNZ+XQAO5bMB9cZVI2C6bnTWRPAkUJj/UmC6+9JYbvXM2L
   sjs9Z7rhV/VbfyLp+3gLdofH+7IMbYKXC0DC2mB+eyx/2K2E/sxD3EFo4
   sh5GPKHtvBpSJYKwbydReSkV16f0q7k9hYFY2wRBg0D6IoIadnW1UB+rH
   sH9WbEnuLlq1CjxMyjsgW9XZIDhaTcAM+IpojRBm27qyUQMwqvBal9FLX
   g==;
X-CSE-ConnectionGUID: DE/CVrUNTcOuVzFE+6S7WQ==
X-CSE-MsgGUID: xXhv7WF1Tfab2/hugCB4fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33227296"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="33227296"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:01:54 -0800
X-CSE-ConnectionGUID: ByCipyd8SleQ0BZmeUrKPA==
X-CSE-MsgGUID: V4zJajzGRmGWlOEgQ6q0hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="94339015"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 10:01:54 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 10:01:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 10:01:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 10:01:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEP78dCf/j345lpW1gUQg8S5t659zIu364k/vtySTBA14QB6zAHDAw6jbokJf7CsNJ0F7VMGrgIbAvVlrTO6o2p0VUBIqUuN1NobUxhEojljvUSG8+jtIOk4iEQc1s9foa8iuvIjQptmTWQetrrdOF4wG7FYikR7CsgKJ10xH9eQfIl+UNcpYOrpqY2vy2ohkmi2hE60YoFLDKrdoeFqqrhtWppWvunvq0YhOuuDjvrnKCLzkXV40J0ufR/D4qSTzkXFIOz3ibAxMvH4+G0AM3UjgbDZKkC2rnmKa98IyjdOlA1F4MJpLyPwVxJkhe+2vFBunsfo2L3S/R+GFwUyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohJybh6UXK+BEA1kwksgI9Ttjoa2liyp5vEdCdL0ON0=;
 b=lJzgKRF29KAURcU+StqJSn17YBsSQGAtleG5swOZk0XFayoqDVpko4RQnw54lxXwFfCMGye91WTLX6sbwCly8NBnS4C3JV8Qnsz7cGaP0zhczt5CHkq8MofA3ethQjgk+d3GNw68xLPC2rCNyvXOPc2/WFK5Cy6jZhCy7pg009m/1VsJCKpofFl68ET+inhu3fe63FVrY8c1QaG8I3uq0Akw21hGqIa/4G6LUKtsH8QEOS/DfwbNqlF3F9mYCht3bNSV0JBwqcJNWijoh3ZjN+8QD+nmALz5ssn0cau2al19bbngYCu7QbpC5tyHNAOw0UQhPFfXXdAs3GkxwbM5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7918.namprd11.prod.outlook.com (2603:10b6:208:3ff::8)
 by DS0PR11MB7579.namprd11.prod.outlook.com (2603:10b6:8:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 18:01:48 +0000
Received: from IA1PR11MB7918.namprd11.prod.outlook.com
 ([fe80::5eb7:69c9:760d:97f1]) by IA1PR11MB7918.namprd11.prod.outlook.com
 ([fe80::5eb7:69c9:760d:97f1%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 18:01:48 +0000
Message-ID: <0b5361c4-3988-41ae-a738-b3f1229e005c@intel.com>
Date: Tue, 3 Dec 2024 10:01:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] vfio/pci: Support 8-byte PCI loads and stores
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, Julian Ruess <julianr@linux.ibm.com>
References: <20240619115847.1344875-1-gbayer@linux.ibm.com>
 <d2ebc64a-668b-4e1d-831f-4e4c4563402e@intel.com>
Content-Language: en-US
In-Reply-To: <d2ebc64a-668b-4e1d-831f-4e4c4563402e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0130.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::15) To IA1PR11MB7918.namprd11.prod.outlook.com
 (2603:10b6:208:3ff::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7918:EE_|DS0PR11MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f9d1dd2-6dbf-42cd-f8b4-08dd13c48e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VVRYTWhzdEZGck1sRlR2VVBCSThvVGRYZ1JtWTVCckUyZkFxaTZMakFzTlJV?=
 =?utf-8?B?M09ldnR2QUlNbEtKTDkrYUhVbFladWlneWZZZnhCV2FVUklqWER2UkVJTm5t?=
 =?utf-8?B?VXE2MUJjaW81YzVWR3VsSnRLMDRpUUtEVFZ1cWhwUzJEeU9yeUtzWXhHdUNZ?=
 =?utf-8?B?TlA1eW1uWjdwQjFmUXl4NExnbmhtaXhMMjNwU0hEVjExb0NlY1VGVVFnamtZ?=
 =?utf-8?B?VTVBbFROdHF0TFcrYnNnbGI5SU1Db1NiYmpvUTcwZ0ZWcFUwNWVXaTErTXRm?=
 =?utf-8?B?MitadE5LenRzUGFielJGTGRHYjA1WldnNENONmIyeTVBOHljcDkwV0d0Ykpv?=
 =?utf-8?B?YWo0OUJhTnRCdzRzTlprbmRmb3kzQ3Y5SlJFNzJtL0VCTnoxSTBRQlFLbW5O?=
 =?utf-8?B?Yk1pZUNYWDdrdDBHa3JnTjg2QVhLSmROR2VmMVUvWlBmSkh6M3NDTVVxUnMw?=
 =?utf-8?B?T1VSa1BnTWdrRzVDOGZlNWVlU1JhVmxld2dvcFlIc2h2R244eXV3Z3lJK2t3?=
 =?utf-8?B?QzdDQllNdlBPQUh4RTFMTlZjc2ZiMWFZUTdWMXdqci9WVlloTGJsU2FJOGtz?=
 =?utf-8?B?a1VHR25hcmxVQ28zOGxlNXl3U1V5NERVM1p2bkE0cEpmcThYSXVPeGRENnpn?=
 =?utf-8?B?SzBXQ1llMUNoVmhsbFBodW9qVHIreGttZ0JEbHNocEZNRmpIRDd6M1VISlRB?=
 =?utf-8?B?cG9iV3R5REdZSHAxZ3YzTFhEb0dseWRpMW1DaWc0ME8zUkJkd0UyN08vZml3?=
 =?utf-8?B?R0JEZFkrdUZIOTl4NXhKWWUvK2dvZzBNSkN4S3lzTW5YTXRoc2toa2JlRG5M?=
 =?utf-8?B?OHllZnJCckQ0blNHc29UMEdsd1F5Q1ZkZjNCOTA5TUxUQStJRTVOVkM1bTI3?=
 =?utf-8?B?SDdIVEdWbUU1MVBTajdReHdNeGk5VXRUNEJReVhycGNXL3NOTFNuYXNNS2FD?=
 =?utf-8?B?Mi9kTnJMOUJreU83MGJ0UEgrZlpLaXpQZ2phdG9yc3NyTFNqT3ZhMFRWbVBp?=
 =?utf-8?B?ZjNETC9CZk1QZmZJbkluQkRHNmFqVVQ3dnZTaFlXRlN1cm1rWHFrbmpFV0pj?=
 =?utf-8?B?a3F4enRIVHludXo3Vkt5b0t6SFVFbHZWSitSWnFhbXIzK01SUWJGcTlod1lR?=
 =?utf-8?B?SUg4NFBjV1prU3R3U0pYbGN0VWw1czhJaEVlNzM0bWNQZnhia09EK2ZldWk3?=
 =?utf-8?B?WFVhSWtTSS9kdW9UcHR1eTRpWXBtTzFLeE4rNUM1TGl1ZDFURlJYcGtBeks0?=
 =?utf-8?B?NzNsb2NsS3k4Vkd6VC9WVWxBYUs4eGVOSzFLWkY5NWVkeVNZem4weGlJWDhX?=
 =?utf-8?B?SlUrbjVvekg1U1pLQWNqd3p3VlNDN3VyL05yNFVlaGJpVURvVFZPYm9hR3J0?=
 =?utf-8?B?YktzczFVQ1J5MEk2V1diWG1EeHRTQ1U4Y3VCOUI2VldpUzRRaU9jQ0RCUXIv?=
 =?utf-8?B?Tm5VdDZyaHVGcVpxeHpNRHdycWVaUmlQSy90blhRakl1aTl6bExvSndWZGww?=
 =?utf-8?B?Vm1ZM2t5eWUxSlAzdkY4Y1UydEtGT244RlZVQkRLM3ZlOFBUWlpaMUZSVVNh?=
 =?utf-8?B?UUc3V0xGN2h0UjhLN3dEaUswd2h3bG5Gbkx3cktYNFVYRUZBU2FHckxNcnA4?=
 =?utf-8?B?QUdud2p1Z0l2NVVIdERleEwwYzJuQ0tMVGRCTTh6dEZQbUFHUWNYNU4vcDd6?=
 =?utf-8?B?NVpIN0xUMG42bVpVM1pzTG5KSzc2U0YxZU9Ja3dDZ3g5czhKTURtZ0kweHZh?=
 =?utf-8?Q?HNzl+46/KQ5iE0ybYYh9QaOxAMtLF7RT4P2oxia?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7918.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVJNY2hJN2ZCeUpqajlIK3FYc0MzdXlHVFFwQ3JWYmMzYzZpblRSK1BlWGZs?=
 =?utf-8?B?Yk5JZE13UXYvZVlxZzRldU96MFlTYVNBVkZoRjdQV3VpMlA2ZS96bDhRMmNX?=
 =?utf-8?B?d1Y3M1gySTAxMDBXSTJyZ2xjeUdja1JNRHgzSU5ScFNJZldrUzByMktyTUhn?=
 =?utf-8?B?N1hWZTl6ZU5wOXRwa1VHdmd2V0NXamY1NndGN3pDL29qZUphZkZPQXFCOUF5?=
 =?utf-8?B?RWh1cllVRFB3Tk0wMEN5ZFkwQTdFekREWitpc1hLVG1qOFd0V0hCNHpOSlho?=
 =?utf-8?B?RXdLN0lRN0lKNG95L2cySHBseG9RcTBlSnhsOEJuZVcxVEFnY1JTUG9nOHVp?=
 =?utf-8?B?cWR6d21UdC9EeHBNaWZUSTFWbDFGRXVYdmhxSEE3Tlc0YlkyODVUQjZ1cDlJ?=
 =?utf-8?B?aCsrYmtMUkttREt4aHJXMHdzTkNJMzhISm8rNGw0cjh1SWl4U25XSlFZZWVQ?=
 =?utf-8?B?RUQveUVrd3I3UHI2MFVId1lSRm4rWmEyUVg2c1ZpYnoxaGlzNU91QXorV3BK?=
 =?utf-8?B?V0IwUkNZQWF2QnJhV2RYL1lWVVVmb05ZVkRrWHBxd3piZ2s3Vmhsd0RLSU9o?=
 =?utf-8?B?RWgrZUtnZTVxcElDa1QrVHNydXdvTE50Nk44ckpmMmRYYTQxZFFiZGhVeGV0?=
 =?utf-8?B?UE9qTndRbVNDSzhFdEx1cm0xUnB1N1ZxTURDRUdZS2lWTjhhd2dTNFc0T2lG?=
 =?utf-8?B?TFpHbE5LVFo2dENTSm9jVWx3cktBMVpON2MrOGR1bExRZFBjR1Z3VUp3L0xY?=
 =?utf-8?B?eXVzTjg5UzgxUTVqVDNvbzZZenYrc1hFK3lkanZERjYzbVFVQjBEZlRJMVZS?=
 =?utf-8?B?ajRMblNQZ1RIZ284S281T3Z2QmJGTithY3RQeE41SjFMekhJZVYwMGZIQTM0?=
 =?utf-8?B?YUtFNXpwUWpseDNQRHhkSnllZkJwYVRZT1REK29jNTRkVkRpR015ZXRwK3JH?=
 =?utf-8?B?aFZRZnl3VU5zR2V0YzlJWUdPZ29iNGl6NVpPdWtPMTE3RUZmUEVrTDJOaVZ5?=
 =?utf-8?B?MjNJVzd3MWR5VUgzc3hrL1k3a1pyUWFxRHdsLzdsbU83S1RieEt4L2hNdjgr?=
 =?utf-8?B?SEwza29vZnlGckgxQldtelFTbjdmQlFMVmZoa2EvWVI2bXg5Z0p0b2FobVdr?=
 =?utf-8?B?eHdQdVdGeTB6eG1tSXVJVktmWHEyK2RwekpIb1JIM2xvbElyaDVhUXNuRE0y?=
 =?utf-8?B?Zys1eklQRWFSZVRMU0hzaTRYSXdWOUtZNnFsWEVkTkRBV2hZTzFvbW5oZzJl?=
 =?utf-8?B?QnYvak1sbi85UU5wSXdTWm9Ia3pCd216OWxRVkFDRWhoc2xvQ3ltaE5PMGM1?=
 =?utf-8?B?SDNGT3F0anZOZkRUbFlvd0FMUnVKZDRsZTlGS29XM3U3aE9XYXkraFdNdmNJ?=
 =?utf-8?B?VWRhZ3FCYnVWaG02Ymtjalg0T1RJQkJBS20yOWNmZEZmZVh1bmdETUxPTTlt?=
 =?utf-8?B?Z0RWZy9pUHpqcmt6Y3FHR0hTNlVWWXBBeGs0RGZtRXJ4ak8yWHl5SUg5WXVt?=
 =?utf-8?B?VlpqSWhuMThVTkFIZDRqUHQ5N1ZwRTl0S2E5V2l0LytyWjRSbi9IODFYTkFX?=
 =?utf-8?B?WlFWUzJ4RmhVUGFacVRKK2p5L0YxTXRJeEYyMklKWTdBMy82RnV1eWpMTmtv?=
 =?utf-8?B?Y0d2NWdPRDhQZXk2eEZodDBMcEpVNmdOT1ZRdVJVRm1UOXpoeDUxNDFXTHB3?=
 =?utf-8?B?am1XQ1pTMVUrb0VFN3VhTERidHE4bmNOcVVIL1RMY2VBZUNFamhmY2JrUUMy?=
 =?utf-8?B?ZVVMU0h6SzJscFJ0TVhDcVVNTUUySkczWUYzWEd4OUN0akFuMXdYWUhJeFl0?=
 =?utf-8?B?Z1crc0QrUjBZY0ZnRG56L3ZyUXZVdkNJaUoramRadlNYd0RqVy8rb2l1c1FU?=
 =?utf-8?B?VnVCWTJuZEdwbXJhZ0NHU1VzR09XdGFhd3h4akc4ZzdSUi85bEJiNEFWSjQ0?=
 =?utf-8?B?Wlc3czg5d3pxeW8vQVE0S2RvOCs4S3RSV2l1eXlZR0ZTdU5qTTg1KzJYdVl2?=
 =?utf-8?B?UGN4Q05GRTNhRGxBbTZvNGNhYitHcFJncWJJMnZ0NlEvR1Q5MXdnRzNsaXlQ?=
 =?utf-8?B?YjNTRE9hd0pXWi9wczdvcCtGVHNjUFdBd1Qwd1hUdmFvUUpmK0daa0Ezc1hm?=
 =?utf-8?Q?C+ULZeI/8NHtLukPLbgXQFDm7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9d1dd2-6dbf-42cd-f8b4-08dd13c48e99
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7918.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 18:01:48.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np7Vc3ZkBmfHxyeAVCCdCFKjRwKFtJ9cTrf9iQcFPlBzRSpV+HAmq8kgJm7G748KoY37r3/ZmGt85bvzqlIHPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7579
X-OriginatorOrg: intel.com

Hi Gerd, Jason and Alex,

I got delayed in sending the below mentioned patches as I was assigned 
to other projects. I will shortly send the patch series that extends the 
8-byte VFIO PCI read/write support to the x86 architecture.

Thanks,
Ramesh

On 6/21/2024 2:50 PM, Ramesh Thomas wrote:
> On 6/19/2024 4:58 AM, Gerd Bayer wrote:
>> Hi all,
>>
>> this all started with a single patch by Ben to enable writing a user-mode
>> driver for a PCI device that requires 64bit register read/writes on s390.
>> A quick grep showed that there are several other drivers for PCI devices
>> in the kernel that use readq/writeq and eventually could use this, too.
>> So we decided to propose this for general inclusion.
>>
>> A couple of suggestions for refactorizations by Jason Gunthorpe and Alex
>> Williamson later [1], I arrived at this little series that avoids some
>> code duplication in vfio_pci_core_do_io_rw().
>> Also, I've added a small patch to correct the spelling in one of the
>> declaration macros that was suggested by Ramesh Thomas [2]. However,
>> after some discussions about making 8-byte accesses available for x86,
>> Ramesh and I decided to do this in a separate patch [3].
> 
> The patchset looks good. I will post the x86 8-byte access enabling 
> patch as soon as I get enough testing done. Thanks.
> 
> Reviewed-by: Ramesh Thomas <ramesh.thomas@intel.com>
> 
>>
>> This version was tested with a pass-through PCI device in a KVM guest
>> and with explicit test reads of size 8, 16, 32, and 64 bit on s390.
>> For 32bit architectures this has only been compile tested for the
>> 32bit ARM architecture.
>>
>> Thank you,
>> Gerd Bayer
>>
>>
>> [1] https://lore.kernel.org/all/20240422153508.2355844-1- 
>> gbayer@linux.ibm.com/
>> [2] https://lore.kernel.org/kvm/20240425165604.899447-1- 
>> gbayer@linux.ibm.com/T/#m1b51fe155c60d04313695fbee11a2ccea856a98c
>> [3] https://lore.kernel.org/all/20240522232125.548643-1- 
>> ramesh.thomas@intel.com/
>>
>> Changes v5 -> v6:
>> - restrict patch 3/3 to just the typo fix - no move of semicolons
>>
>> Changes v4 -> v5:
>> - Make 8-byte accessors depend on the definitions of ioread64 and
>>    iowrite64, again. Ramesh agreed to sort these out for x86 separately.
>>
>> Changes v3 -> v4:
>> - Make 64-bit accessors depend on CONFIG_64BIT (for x86, too).
>> - Drop conversion of if-else if chain to switch-case.
>> - Add patch to fix spelling of declaration macro.
>>
>> Changes v2 -> v3:
>> - Introduce macro to generate body of different-size accesses in
>>    vfio_pci_core_do_io_rw (courtesy Alex Williamson).
>> - Convert if-else if chain to a switch-case construct to better
>>    accommodate conditional compiles.
>>
>> Changes v1 -> v2:
>> - On non 64bit architecture use at most 32bit accesses in
>>    vfio_pci_core_do_io_rw and describe that in the commit message.
>> - Drop the run-time error on 32bit architectures.
>> - The #endif splitting the "else if" is not really fortunate, but I'm
>>    open to suggestions.
>>
>>
>> Ben Segal (1):
>>    vfio/pci: Support 8-byte PCI loads and stores
>>
>> Gerd Bayer (2):
>>    vfio/pci: Extract duplicated code into macro
>>    vfio/pci: Fix typo in macro to declare accessors
>>
>>   drivers/vfio/pci/vfio_pci_rdwr.c | 122 ++++++++++++++++---------------
>>   include/linux/vfio_pci_core.h    |  21 +++---
>>   2 files changed, 74 insertions(+), 69 deletions(-)
>>


