Return-Path: <kvm+bounces-70885-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIx6CF60jGmMsQAAu9opvQ
	(envelope-from <kvm+bounces-70885-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:54:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC96126599
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:54:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 59571301DC13
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C44A3451BA;
	Wed, 11 Feb 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbUoToIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EAE30E84E;
	Wed, 11 Feb 2026 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828877; cv=fail; b=H/vfWmoPSvZhi3gvzZEa72RvnSr+vOpj8mO6VxoQd6cDsDNqNcARMiu4S+L/GTczDihKx7cXyVd1HCCf44fKSIDfW0x3FzCQTcccZrjgHNzm081oN0Skr3Jdn3pheQVWj6+RqkZyUzozErSaD4XBvesrIBwuhkzl8oK+5YGDQUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828877; c=relaxed/simple;
	bh=JbMwZmBzTQUnM37TmtRq0EQmsTvfxoumX8IAdgxPU2g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fKisNhGFNSzlbVSnc4cGERMVLI8cqTqA+F2KI8w9xN7VJCFqgoKLM7p2fz/a8IXlTtE8aOmo/Rs/AoyYvxWmjFfrCCUO8UYlW+VUIg5WMQgkmIViTSE4xHMg0B9YsN3Rpl/MPTwuwkt4FeZoNbx4xsXje2n7Bcv190hFH/VSvwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbUoToIJ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770828876; x=1802364876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JbMwZmBzTQUnM37TmtRq0EQmsTvfxoumX8IAdgxPU2g=;
  b=PbUoToIJ8A/afvpg/DDTypfnlvpDPV+CYuZ9S0sNGokbDTkJoOSCif+R
   vvmvIGAHdpP2lWhIA75HxHS7+Tl0L12LExDqViSY+DgNt/AXp/dQpR74g
   TOU0PVxjd3ayo+7MS2Jg2Lgnze8q6mFTNJlIhzk/kKtAa5U5TJ9lEB06G
   B75BiTCSz5RcUHMqFGXqW5T9kHQWGcfVupkn1aQk7ftRz+41pSGTVzjlq
   UgMsB+QkF/uWteJmRFgpQDMaFpY2gcKfceV9YhOLeHsP/7w8IasGGUIbW
   AvqMZs0kmeQhBS/tBEVDvQhpJwjgnNc718PgOM0MYFGKJUcxoNrJDJXGr
   g==;
X-CSE-ConnectionGUID: GyEj0SjIRjiyhtj8t8frRQ==
X-CSE-MsgGUID: 4UjL78X4T6mszILz8FSPmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="82620669"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="82620669"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:54:30 -0800
X-CSE-ConnectionGUID: 40kLw6wRQGGZEUudNmQ45Q==
X-CSE-MsgGUID: jUPp8541TR+Z4LD0jtDWPg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:54:30 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:54:30 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 08:54:30 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:54:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJdA9qAx8WVzHLoVATG5jvHc1sm+ykGM2YUKUHYdgVv7VHlP8kxR2C9qLlj3fJc8lS750sJgjTQp/ZTVntu0MYz2iRwU1Fps1KXGFTUQec7iCr/LxabxF8tu8TZUR7OANSYtHR+kyFWFpFvAyhMrowYXOyB+ArWUQ3FcvtFlDQVDDKMKSN02xflwyUGg5hYfG5uzbcE0F6pqKv5jd4hYzzQW/WowJ3jrU1hDF/h0PvbNJtGeWxvAaIRAGW3qimlTwMnPEDK17CES8f0L346ECkq0DiVrhV2EENTIxafu5NT8khh6x5iS1VZGuiAG7hccI0JceN9wfugqE6A/ilRpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rYc7diH5lDShsLJ2Lb4KvpGIusIsFJ7nG4gSCovhh8=;
 b=EbWGR7LbaP1rWOsQAP1Yw7MtikEMMaIMvqcEwm6lFxfbtOLWzuncHGkkAP2LT3bMkF1cX326k6XHRQhbgJm2l9GMNbldL/tmOMP3BOuzOLVQbGJdPMTUQH6MshQr+DZhFcsbWVztNWXVgvv8/Vfa7VGI5O53S0yUM1jcUrwqfDJyNzby933F9SmMhXYEgI41kKaNd/b3ZBW90JeZhxPF42aQj586MawlHQ1wiB19LdEpoovKejwM5vAErATvuF+vvuLCeoyF7kVengGrgrte4PUCSNVXzYWQQ0wPbmO6HFZdOn2x5b/UWt1TW0lL6cexTtuCNjt0X2wBcPUh3jFLOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4926.namprd11.prod.outlook.com (2603:10b6:a03:2d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 16:54:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 16:54:25 +0000
Message-ID: <ed2d089b-0249-4f1a-8da2-5e61d5d1158f@intel.com>
Date: Wed, 11 Feb 2026 08:54:21 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/19] x86/resctrl: Add plza_capable in rdt_resource
 data structure
To: Ben Horgan <ben.horgan@arm.com>, Babu Moger <babu.moger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <7b7507eac245988473e7b769a559bd193321e046.1769029977.git.babu.moger@amd.com>
 <a212711a-7af1-4daa-86e7-124ae15a9521@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <a212711a-7af1-4daa-86e7-124ae15a9521@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0245.namprd04.prod.outlook.com
 (2603:10b6:303:88::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0afee9-3938-4baa-059c-08de698e3653
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1hwZDg3Ky9LUDZDRC9qUEUyL1FkWk5QQytrVUZ4Tlk2WGl2YlhVc1dabmpH?=
 =?utf-8?B?cmpkc294ZkI2ZTQzQmlLYVhrS01SR0kzRWoydTNyVEpEQ05lZlMwWmFsWmZy?=
 =?utf-8?B?VFdzckg4NFNwby9qaTA1VDJ2bGM1eEZqM203RTRqVmtINkY0c3JYaUVDTkF1?=
 =?utf-8?B?dStjTEtpMTJvQUIzdVVOMXA4MFZXZlZJcS9LU1ZxTVFIVjRRUVJIUHc4MEM0?=
 =?utf-8?B?UlhlTkR2K1NxV0Rha1JKT0VKaGJYRXYremx2WnI5Mi9FL3gzSS96WVBxcnZD?=
 =?utf-8?B?OGFicjhMYlZGN1BNMHZTOWZMdEwxekFPZTIrUE0yOHFzMTAzcWNqcGlMQ3F4?=
 =?utf-8?B?dHlGQVVHTER3YUNEN1JGWWcrN0lQRFlkajZLaHdwcURGbFNJT3gyOFdGUTRh?=
 =?utf-8?B?cU83dktQc0FGZDhiSWxoc3UyNS9PbkpYaExGdFYwM1Z3TStqZzF6UGMyS0VW?=
 =?utf-8?B?dWM1WnRDSzBYNi93WTNyZDF3L0kvdjh6cTJDSi9QQlpkdndSeHBZWXBDODlG?=
 =?utf-8?B?ZHVrbU5Gb1dEUW02YVhDdFhaMXJMdkNRT29mSjlCZEFndWFGY1BYSjlTRHQ2?=
 =?utf-8?B?a1F4aUFuTlFmck1TcmdQaStwRE5wcEhDZTBhSlFQbVBoRVVHWHRDdXpoS2Yw?=
 =?utf-8?B?bWFJN0lpdnpqeVhtK0E5SDlQQk4yWDFpYXJMSVpxT3FEZ0RpWjUya050d2FL?=
 =?utf-8?B?ZWQ1TzdTSFA0UmRwZkNGc3RPRzNOUDc1aWtBVTlnMllad1ZZNnpLY1FCb3Ew?=
 =?utf-8?B?c3RzVWVpVnRVTWtvVGdhMUNoUTh0UjEycGpic00rTFQ1K1ZmM3VPQklVei9C?=
 =?utf-8?B?OWxCZGJDbWdJMHVpUWI1ZTlXaG11czBhb1pEeWRjakxZVkp5ZnE1ZjJkMmY0?=
 =?utf-8?B?WW14aUpCdWUrcG1kSXhOTDNEeGROZGJzWHR4Ly8rTjlwdDNxR2lUbTFweVoy?=
 =?utf-8?B?RjZtdDN4ME1ZZGdXMHcxNWZWYUs4VVN1S25tdnc2YTMzNnlTMkVuLzFNUlY5?=
 =?utf-8?B?OWRCbDE0U3loS3JSRkJqektqV2pqME5JVURaMUxIMXFtU05GTkhXMnV1djR2?=
 =?utf-8?B?Q2I4Vmw2SDcxWjkxaHIwd0tIM0FjenE3VVoxaGVvWTFIRkNKMGxaQ01iREMy?=
 =?utf-8?B?RFhYdDcwbEcyVFk2SnoxRDdtV1p1ZGs2OUxQRGs2YS9iVzdtRjl6bWNMTjNM?=
 =?utf-8?B?M2N3d1dCWXhxeE9lcUFkZzEreEgzQlpJdHpSZ0hESjZGbmhEVGk4bmsraEpr?=
 =?utf-8?B?ckRBbzBhOUtWVCswUHhOT2k1bmNRS3dJSyt1UTdjdVRlRTBvTm9kODNIS0dl?=
 =?utf-8?B?N0o4M1lFOWhHdGdDcENyV2JvMno3QlNkM3pRRHBvOCtIZGtHN09VSUJwamZy?=
 =?utf-8?B?Qk90QTVLanczVGh2dDlqbGJWNzFxVURQTE9MTEdGWDgzTnk2eDNzNW9POTNU?=
 =?utf-8?B?bXgvUHhhZVpReW9ubzQ5UE1RSmlDWmhlNDE0eGpmV3h3bkxwUE1yUlZTUUNX?=
 =?utf-8?B?MEVrNnUybkUxYkZCKzBLOVErc09oVis5K2owZk15b25ZTXlQTzhHQTBVZDh6?=
 =?utf-8?B?TDFmTW1YTTNBTWpONTJmdUZRekFIKy9JVUhqM0FQY3U0cHd0K2pMbzZ3WHpT?=
 =?utf-8?B?ajRPblkzZ09qYTA1S1VQU0tsZ3RCOWdndXFvN2w1M3JmU1Z2Q0sxa2YrNDVt?=
 =?utf-8?B?OWs4SXY4R1RVQlViOUNGSDk0M1BpMmpCYlphelprampKVURsY292STh3dU5I?=
 =?utf-8?B?Wi9KUE41VTVqWENyR3lWRVNUNVMyZ2FlNUdlemIrN3c1c0w5L2FRTTBVU1kr?=
 =?utf-8?B?WnYwRUJVWklXbU9nUkFsRTljR0pCSkhRZTRrOUx5Vm9OWUxhcmNvUzdIMTJt?=
 =?utf-8?B?VU9sMnlMenZSN2kreVlhdXlQalBJVVU3Unl1RmdSQkRSRHh0cDdUYUVkdEJO?=
 =?utf-8?B?WExMalR1VWFDa1htdHVzQWl0NTFZU0R6dmZENDJkVEtXeGM0T1B0YlAzdWYw?=
 =?utf-8?B?MlJadzlBY3pKeE1ON3dQaEIxNDVNME5qTGFyc2dpVG9kVG1LcFM4THVZUnhS?=
 =?utf-8?B?eFZOS2JPV3VWYjRqM3hFaVk0OFNzZ1BoRm9WU0p0b1VIZzlTaXNLY1JVQlhU?=
 =?utf-8?Q?hHSsBhm7wSn53vh828Hr4fnfZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2N5YTM5SHJocXl5MDJuRUc3QkFGSmM4WUQxa2ZCbHAwQ25GbElaNGJ6a09y?=
 =?utf-8?B?bHFGbWRlaTRzb256L2xFNFh2TXBneWJXeVpsZmdlU1NRbUFFNFdvR0wxZTNS?=
 =?utf-8?B?MFRBYk55cXZtYlk2c3pnWkRtUDNPcGxQNzF1VlFINjdDeDMrOHdFV3o1amZP?=
 =?utf-8?B?aHdmT0RtU2k1RmFQb3lvalhzSG13c0x0a1c0N2JqMFlkYUl6VlNZcVRuVDhp?=
 =?utf-8?B?NzE0ZFBDM0R1L3BKZVh2YUdZTG9PamhwR1VYd1FXSFlzaEhiL1hFVVBCak1T?=
 =?utf-8?B?Ky9DRHdrKzNMQVNMcWJkR2toYlVNQ3R2M0h5ZjRYYzJKa0ErdzN1ZmpWMitu?=
 =?utf-8?B?UGtOekR2b2J3WnlMSmVQa3BBeHN4U054NitVY1YzcEpzRi9KcGRRNHVwM3BW?=
 =?utf-8?B?dGlnYysxd1Z0Q1J0WkUyR0h1dWJaQlY1YWdvYWhoQjdoTkhlQnJjQi9YZERm?=
 =?utf-8?B?QktwTjJUUEdjaE9rcG1jV21FYnlLV2gvYUhUMEtCN21KWjRQRmNoUWM3MjJQ?=
 =?utf-8?B?Y0p3S0RFWjBWNFcwZzgxYVJ4Q3haMHd2SVZnbUJyMmlpdERXTlFIa0I0VnVN?=
 =?utf-8?B?VlNYTXFPMGlJazFmL1lBTGx0czFld0FwSHFuM1BqVmw4bWswazRnNWY1L3V4?=
 =?utf-8?B?V3hsSElZZy9KTS9HSnZaK3NHWFh5Wk54cGtOQ2d6anVZNCtXWTlrNVZzNVlS?=
 =?utf-8?B?Ym5PaVdSSjcxSHBzRitFZEJPa2ZuaW91UkZIWThFZ3BybFJjVGtNbFkzejlu?=
 =?utf-8?B?ZTRqbjA2WkVkaWRIOHFmVXVsN0RiYzdSWDlScWNYNDcya2hvS20vRGNQQ2Ix?=
 =?utf-8?B?NEZJd3dEQWQrSGY0YmxKUGFGdnRQektpMWhEZzI1MW5pV1dUaGlGdU5XbHVw?=
 =?utf-8?B?SmNFdGZEbHdFVDhDcTFnZTNWRTVqL1JXbUFib1pkeTdrQTh1Tys2bmwvV1Ro?=
 =?utf-8?B?Vk5VYXE5bk5na2loblpIV3ZVL0ZaZGk1Y1EwR3RYeG9veE1TUzVzdWplREwy?=
 =?utf-8?B?Y2tVNTFsbWo5ZkhWc2xsZUQ5N1V2MVZncWJYdUxDTGhmZURmVGdDTWZnSnZ0?=
 =?utf-8?B?WE1JV2ZqeW5UdTRxdXB6bzlwUDVpcXljOGhNdnBFZTRXTGM4a3RPQ05FYlpS?=
 =?utf-8?B?WE5CQitJODlKWHgwamhKVXJTbWFSL0F6RDA1Wm1nZXphekZlSmZQT1kwUzdG?=
 =?utf-8?B?dGp1UTZ6OWZ3Z2sxZCt3TnhHbnhvVUJuanpDSGlNYUJLTjZLSmhqcUpwbU9L?=
 =?utf-8?B?TlFzTmgybThqZy9CQmxuNWhwaFpYVWZzN2xDV0Rrci9CZFZrTm55QWoxeE1n?=
 =?utf-8?B?RGNRVUN2WFFwTXBldWsrNVZ0RzgzOUE4Vk5lVVkrdktFWHJIS1loaHFoSjMz?=
 =?utf-8?B?ZFViQmtGa3pydDlUOVhIdTZRYmU4UlFzaDlETW5IRFZZcFpIMm44djVwWFor?=
 =?utf-8?B?UGx4UlZPSSt4Tm52bUFOSUJKRkpwQjRnYTZiWFVEYnpsUy92VFowQmJOcER1?=
 =?utf-8?B?bG84TW9LamxVTUFpNXM5bUJadkQ2RSs1ZnpKRE9mZVcyUm1LY3EvSFBBT0VV?=
 =?utf-8?B?L3ZFcUV4SUJsT2lRTnVIRitqaHRpY3pleHB2TzFybGlGczhpMmx5bk5OaTFY?=
 =?utf-8?B?bklLTC9vWlIvekE0RzdISVpxZ2w3bk4rYWRPYTF4aUVHMTdYdy8zNFo1dnM3?=
 =?utf-8?B?OC92cElxaDJWMG44cThBSEJ4T0dicHRpRGxVSDZXMzVTN2Q2ZkFLZUptd1dD?=
 =?utf-8?B?NjI3NVhycjBFeERiRGFnVnlGdld1c3B1aU5MNEpENTkyWHJxUnRZalVnWVd3?=
 =?utf-8?B?aC9lT3JtT1pVVEtjTXdRU2M2RUUwL1lvenRqNTFvR2hWQ05ib3NEeE9Mb0FT?=
 =?utf-8?B?SkphdkVvMlQxWTRDVFlsZE1Za29zcjRUWWZDeWptcmMxOGZ3YmFwMlhwRXFl?=
 =?utf-8?B?T0JFVjR6QmtzR0hxSE9ySEFGcWZJUFd1T3Vzb1JObExxVjNBSStJY2dIdUNr?=
 =?utf-8?B?OFNJNk1aZmVoWGlqL3BPYytoWjVFV2trWGJRajdkMGQ3eFhwcFRWM0kybVBs?=
 =?utf-8?B?RGEzNTVkQnUyelJvK1FEMHhMUFBOQjlOSGtHQnJoa1oxb3NuYno3NGhtT0ZG?=
 =?utf-8?B?UXJ2OG53MVBicXg3RTE2L1JOSjA1Z21ZNDhjYnVhRTVCYjgyTWZBRC84d3Jp?=
 =?utf-8?B?Wi9UVXVQcGJYeUM0SGtLNEUrNGRuRnRtRHRCY1U3OVBOWWxDRHE1VUJ5UzNF?=
 =?utf-8?B?UHJKUTZzQ3AwVGl0WFpFNTZTTnVWdkNybUt5WUxnSkNYN0JXSUJPbkI0VXdN?=
 =?utf-8?B?d0NKb05Lb3hmWXg5aUgyUklpY0lTRzFMOFdmb0ZjQkxkTHVxaHdYRlllU0Vt?=
 =?utf-8?Q?EXSfiidZbkPcKMiQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0afee9-3938-4baa-059c-08de698e3653
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 16:54:25.2768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xBRRpktRJRYOo0HWe0maC2HWCr8pGZm8iUrbMK/Jzy93d/V3/dbNnxOeC4XFYCk+yT7JNa8C5oDj4LUEahVpX+LJ92bMlZZjFA+6NxNXIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4926
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70885-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 8FC96126599
X-Rspamd-Action: no action

Hi Ben,

On 2/11/26 7:19 AM, Ben Horgan wrote:
> Hi Babu,
> 
> On 1/21/26 21:12, Babu Moger wrote:
>> Add plza_capable field to the rdt_resource structure to indicate whether
>> Privilege Level Zero Association (PLZA) is supported for that resource
>> type.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/kernel/cpu/resctrl/core.c     | 6 ++++++
>>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 5 +++++
>>  include/linux/resctrl.h                | 3 +++
>>  3 files changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>> index 2de3140dd6d1..e41fe5fa3f30 100644
>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>> @@ -295,6 +295,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>>  
>>  	r->alloc_capable = true;
>>  
>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>> +		r->plza_capable = true;
>> +
>>  	return true;
>>  }
>>  
>> @@ -314,6 +317,9 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
>>  	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
>>  		r->cache.arch_has_sparse_bitmasks = ecx.split.noncont;
>>  	r->alloc_capable = true;
>> +
>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>> +		r->plza_capable = true;
>>  }
>>  
>>  static void rdt_get_cdp_config(int level)
>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> index 885026468440..540e1e719d7f 100644
>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> @@ -229,6 +229,11 @@ bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>>  	return rdt_resources_all[l].cdp_enabled;
>>  }
>>  
>> +bool resctrl_arch_get_plza_capable(enum resctrl_res_level l)
>> +{
>> +	return rdt_resources_all[l].r_resctrl.plza_capable;
>> +}
>> +
>>  void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
>>  {
>>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>> index 63d74c0dbb8f..ae252a0e6d92 100644
>> --- a/include/linux/resctrl.h
>> +++ b/include/linux/resctrl.h
>> @@ -319,6 +319,7 @@ struct resctrl_mon {
>>   * @name:		Name to use in "schemata" file.
>>   * @schema_fmt:		Which format string and parser is used for this schema.
>>   * @cdp_capable:	Is the CDP feature available on this resource
>> + * @plza_capable:	Is Privilege Level Zero Association capable?
>>   */
>>  struct rdt_resource {
>>  	int			rid;
>> @@ -334,6 +335,7 @@ struct rdt_resource {
>>  	char			*name;
>>  	enum resctrl_schema_fmt	schema_fmt;
>>  	bool			cdp_capable;
>> +	bool			plza_capable;
> 
> Why are you making plza a resource property? Certainly for MPAM we'd
> want this to be global across resources and I see above that you are
> just checking a cpu property rather then anything per resource.

I agree. For reference: https://lore.kernel.org/lkml/6fe647ce-2e65-45dd-9c79-d1c2cb0991fe@intel.com/

One possible concern for MPAM related to this caught my eye. From
https://lore.kernel.org/lkml/20260203214342.584712-10-ben.horgan@arm.com/ :

	If an SMCU is not shared with other cpus then it is implementation
	defined whether the configuration from MPAMSM_EL1 is used or that from
	the appropriate MPAMy_ELx. As we set the same, PMG_D and PARTID_D,
	configuration for MPAM0_EL1, MPAM1_EL1 and MPAMSM_EL1 the resulting
	configuration is the same regardless.

I admit that I am not yet comfortable with the MPAM register usages ... but from
above it sounds to me as though if resctrl associates different CLOSID/PARTID and
RMID/PMG with a task to be used at different privilege levels as planned with this
work then the mapping to MPAM0_EL1 and MPAM1_EL1 may be easy but MPAMSM_EL1 may be
difficult?  


Reinette



