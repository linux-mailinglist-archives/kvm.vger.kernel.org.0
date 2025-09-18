Return-Path: <kvm+bounces-57975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8A6B83058
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 128501C20627
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3742D7387;
	Thu, 18 Sep 2025 05:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D5xckz/G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700C62BDC29;
	Thu, 18 Sep 2025 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173866; cv=fail; b=EUX7tcNIqR/I+7dG31OYfbcSpBCydCHYxlsvxM/U3EjNoZ8ZbQ76Qx8FZtGgb8pdFlDdnayRwn99s/ElvOIH2RSG6qmxf4/8SHHgP+lVu6vsFluRXRt7V5l1H0xmu/QSegOCmBpPBEBRiVMnj+HM7KN/fKBETj6WcpE7E+nNj+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173866; c=relaxed/simple;
	bh=wVsqjH+/Za8H4GpIr437C1mfDW9aN4kIiSJ6kVMWxrw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XbpQDJlTqctDl4lvAAnYf3T12xp0opdfjCJfWrw/IwaGkV0IC9hNEo5xXS44fg5rswc/Mef+SQVuEeLg7F43xJBJ5o7TUZ/HYZwci/+jh4N6RqRgfnw9YfTlVOmQfHKJOAzCH7m4DfypxPCipch1AoPZZYyb21bFu69ir7K57UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D5xckz/G; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758173864; x=1789709864;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wVsqjH+/Za8H4GpIr437C1mfDW9aN4kIiSJ6kVMWxrw=;
  b=D5xckz/G0U2WX3+mEC2FqdZAwMn9AcCqbEMeNS1EFvmkMHRsstEbHKYb
   1zGraJPa0qy1A5PDwH/KmQNIkkw/SDxr65frsjz/sIPyJVArKwn9pDgat
   llyqtzhlvj6o3yrBnvWa6NiBJP4pEBe69BtAMAxl2e/XrS9qB1CTzZN2H
   l0r4ck2xGCHc0/4jvW6Pps7fVBxq9mA3sBn8EbNaX2GAQgUPpTxQgrY5N
   3ZZqa09jrIOheKTjh6qYCoiHcRcebH6tuJDttzzOPLclynbt5bMpeveRc
   VdsjjxfUVM3xMeqEI4Cs09oYR0NehugOCCcQaq0mNyOAi8qHvsr6HE++Q
   w==;
X-CSE-ConnectionGUID: yRmH3XQFQ7Wdhim70CMk8Q==
X-CSE-MsgGUID: 1iP0NacyTl+MQkyrLLuHYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60604187"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="60604187"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:37:43 -0700
X-CSE-ConnectionGUID: y6NaQpYjT/i3eClU7K6krw==
X-CSE-MsgGUID: cHJSkcuqQr+JQ5y727AySQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175037741"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:37:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:37:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:37:40 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.50) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:37:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9mt6+3cqftQc3qBQxtE7c/lh9tj1HGxlfSPWfwPlWzx6FQOOH83qHNkmYaOhQ9Vajv3d7cOmJNSvbljqnWGjWMvr/uAsrdggYld5ekF5Vfj5+6C7ixyz6HmTXDPMf9Z2czdNZ1TJ8Wpm9w5PMfP9ZE47sHp3E7FiKgUM+BI09bCyd930ARpoFjQASYMKM6JyYywkK1601r1EjlnU98CzSC6MvqcExuS0KYHzlz5fDX/quNwtSLK410OwE2QGB6cW/y1qKX480moitjA+QtaEBTpTXHlCDwZAd+T7R3ApaQLJh8o5rGMwKaJLfjcE7hMw/pMDAbdgAu/KjxJgJxNOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvtVG7gKliZe0/S8hQgU3OgOxaNDoBQvkfPjsdFcQZ8=;
 b=c2JFk2SrgGnnHxSg9TR4j76O1B6FxeAekZisYxfFb0vR3dYC4v7vRcfMBFT4vKdWpP5get+tkjOliGFrXNYix77diQFgIiFAIV68GxnclTSjfINdD5PSOgzAVsKvdyWES4eLKN6vCmjJ9q7ibV2QPt/TLoFCgx3Vu4k0e1Z1Lw3bKcQi1/h1WAOsFtsTwsaXJ/EV0x9nlf1b0FX2VAZ1KLURLUQxvxSsjKO9+N8eMfo7wFq/WW2wNu4rpnnK0NNp19xnLSSej1M3VBHK1EJf7klKhap2HrLKQXEADeLP/GHazBsdslXE9ckaCZ2420OCywVkWANCkwKtO782aVRZUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6383.namprd11.prod.outlook.com (2603:10b6:8:bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 05:37:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:37:37 +0000
Message-ID: <d18dc408-0a05-47b4-9126-19a7bd5fff6b@intel.com>
Date: Wed, 17 Sep 2025 22:37:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/10] fs/resctrl: Add user interface to enable/disable
 io_alloc feature
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
 <2cc1e83ba1b232ff9e763111241863672b45d3ea.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <2cc1e83ba1b232ff9e763111241863672b45d3ea.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: d923b329-af33-4fe0-22a1-08ddf67579df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZjlEOEM5WU9QN2lhenlHRDVwNEZsS3Q0MVNKNE9MYmEyVUpBcWd4YWoxNVdx?=
 =?utf-8?B?TkNqajJ6M3g2L3Y0dC9kQ2NaaFppb3MwWENRVFVuamppa21JQmUwUEhyUHJH?=
 =?utf-8?B?TGhqVXRDNDFmblExVVlER2Q3WXVPWlFydlhvWm82TnlwRTk4bEtnR0NvYWN0?=
 =?utf-8?B?WGRTOU9jaFVUZkYzYXA2V3BsVlBqME5ZbDJic09RRDIzdTlSNUdWSWF1ODlZ?=
 =?utf-8?B?cTNnTzNtdmE5MzlGbnpValZmOExtdjlZdytLNHFPZFpqalRrOW5vZDhEQ0Mx?=
 =?utf-8?B?U0xHaXVJSHpmVjU0d2VGVDJDODdJNGdOTXhUQU5ad3NjTnJSRGxUSnpNL0M4?=
 =?utf-8?B?K2l6SDliY3pqSUdDUzRycWthYlVLZEl3ZmVLOUZZa01IM3R5TlNHSkNXYWVE?=
 =?utf-8?B?cTNKaXgrTXRPOXQreE5QR3ZiTW9hQlZRK08zelRZNlFpbm94WWxubmNJNWFh?=
 =?utf-8?B?TXVyNFdRR0diRGxKbHNFTDJESjh5NVhxVWNySzhwZ3VZSGNEWWZqUUVqckxX?=
 =?utf-8?B?cm9MU2JHT014c2ZUY3hBOGYzSzlldDZOZG9xa0Iwa0RuY2ttY2FzRlpVMmhZ?=
 =?utf-8?B?QWlEQVEwMUNycHlTS242TUYwT054U3NTWTZOTEVSR0JlV1o1OW4wUGgweEM4?=
 =?utf-8?B?M3lVSFdqZVVKR0tEaUR1RzV5ZXU0QkRET3JOTzJrcGF2S2VSV21PbURsV3JH?=
 =?utf-8?B?bGExRXRIajJESlZRcU14VlkvZ1lSc3ZNblZoNVVOTlJMYzJBMVpWRFlWd3pU?=
 =?utf-8?B?N0xhYnBJTmJDY1NRajlBamlpNTNXMGNkOGdYME1xVnRYT2QvYXd3Y2tSRVNa?=
 =?utf-8?B?bkVhTGhNSExyTU1jOTNUR05mWHNUZ2w2R0ZQVWdKbXZjSjV5RnBnNmFBWjcr?=
 =?utf-8?B?ZzZRM1lGM1ZJSk5qNno1UlZadUxNcnZkUEpVVGZmU3RrSFJUcU1mb0JkZTEr?=
 =?utf-8?B?ZWR2QU5tYUZ6TU82d1AyL0d6Y0tzSmUvLzJaU0IrTTk5bDZFcGhTMVk4bk1L?=
 =?utf-8?B?Qi9QWDUwQTdFbHVrQzlJekpYNGMxSmx5bXVpcU5IK0lJcy9yTjBaZnNFTDlO?=
 =?utf-8?B?bVR6YThpQlFMbS95anYrNU9qSUNUbGcrRHl4V3l2ak14Rkh2UkgwN3ZuMktz?=
 =?utf-8?B?NVVXc2hkRFJ3RVBOS0VaYnJaR0FTaGlwb1J5VVV0SENycUIweVZNYVIwQ0lB?=
 =?utf-8?B?cGxML2VFazQ4VGx6Z25mTHMvNzhZZHdIdzN4ZnBpZG1uVytPNC9PR0VZbXJk?=
 =?utf-8?B?U3R4WnFVUkJReXRHdjBYMW05ZkoySXQ1VmtDVHdKNjVOZ2Y4WUcvZnVSUndk?=
 =?utf-8?B?Q1NHOU1yd1JnWm9aODkvazZiMnFvejNTY0M5elliVDkvK1huUHdsRVdtVmd0?=
 =?utf-8?B?eHBlTUNCUm9JMXMzcmtYWlZuZHc5RmtCbklLSTcwR2d0Y1AvSHAzZEJMQUxm?=
 =?utf-8?B?aG5VajV4ZHVjbkhFYkQ3dDYzcXc1cjEwdDhvVkY4R3YrMDQ3a0ppMDVycHY4?=
 =?utf-8?B?Tnp5SnhqeWd6TGRLUTJod0FHcmM0SVhkdHFhRWVWLzE3SVJFWFFPV3piZFBO?=
 =?utf-8?B?MTBkOEFBTDFNdEhmVm5IelBwbVdJQ0Z4RDBTWmtTZGFUbVZZZ2xnVjRPTUg5?=
 =?utf-8?B?enlVS1d0ZXMwTkJrZWh4dENwbC9XazA5S0cwcnFBNE42ZFRCVDFlaGcrbWNL?=
 =?utf-8?B?Nnh0cmFIQ3FSRUthRlk5dVJqUFlBYlJBNDRnRXNRNTN0aE5iUE40Q0k5OHBR?=
 =?utf-8?B?V2JJcDdXODZSUGR6U2o4R2laOVdqMzlOQVBHNFNZaWxzbTJMZHpsK2Nhd1hC?=
 =?utf-8?B?cDBXTTNKRFpSRCtwRzZjRVBOQlhlT2pwRWJFTmU5TlFmK2dwSlQzWXJlaWxS?=
 =?utf-8?B?MnJIWXRORUJnTDk1ZXBhT0d2eXhSZEtlZ0NMb1gzc2tqSlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3M4RmExM0xOdVk2cm5yUHl6d3E1SGk3QTFpaDE4eHhRU0NJTUtyMFA4bGI5?=
 =?utf-8?B?Y0pldGduY290VHdWeWJzWmY0N3hZb1M2YjRSdE9zY0txQUVWamVPbE8vSGx0?=
 =?utf-8?B?blIwam51eEpMT3hjY05GQkdRYnhjYnVKWVNpd2pvbVpieEo0RFBhaTlkMXZL?=
 =?utf-8?B?MHRHZVhhQmRQT21hdkY1dXEzZkRkSjBwVVc3RHhzcTZ1czY1MFZTT3A5Q3dn?=
 =?utf-8?B?eFRoWkJ1cWNVQk5VTDlhTlpiYVh1UmVxbGdsNXZyQUZNZTNGUDk2UnQ1dS9K?=
 =?utf-8?B?TjhPT0JUSC9vTjZBVVM2S1kwRE5FVkUyem9MamhKVGtzdmF4bDR0VnJwTThn?=
 =?utf-8?B?U1pQSkZhdDFlVm5vbm96MmovNzdDSGhJU3l1ZG9XTlNwdUtJM1gram8xSkwy?=
 =?utf-8?B?WGN0eXhPaXJpVWp2RlBVSFcyWFd2UmRXM1ordnk2OGgzTk1IeFlpZlVJN084?=
 =?utf-8?B?TmxpamdhK0hHZHZMeExHT1pUYzl1S0pwVFVpQ2NqdkZWeFUxdVI0TjQxS3h0?=
 =?utf-8?B?T2dkOGdONWVMbjdRM2NwZC9sc3N4aEloTDl1TWNNMlJBRnlnUVY1QUpHS3dQ?=
 =?utf-8?B?R2hPamxJV3dyYVpQd21UdTBLcE5WcVc2Nnlib0JqYjJhRXVlVnpJSk1lVDhJ?=
 =?utf-8?B?THRPUFpNeDJaQ3Z6T1BmbzUzeFJnMFhNekFKVXRPUTBYdTFwZk10YTFQNi9Z?=
 =?utf-8?B?QzFtWUlRUUFkVjB4TVI0azd0MHVPRDY5VFA0aVZMV1l4bkdwdjJqdmxHdEJC?=
 =?utf-8?B?ckk4UUtMQWRHNDZKM3hrQ1lKZzRGY3V4USs3MjZaUVFkNFpFdHdEUFJuaGZR?=
 =?utf-8?B?bC83VVlQQm00ZE1DeTF0UmhMSVBwekxWNU5EM01UV3ppd1dtdTVLdm9VcGUz?=
 =?utf-8?B?dWdoUFRLdHpEbUdrVDlHUWJpMGZOVnpGUDNhb0tiZmFaS0J6K2UvNlJKc3JC?=
 =?utf-8?B?VDRheXNKRnQyRW5YdVNHYTRLemlQOHRXQ0RzUkxjU0lhRFp2dGJlekxRTWo1?=
 =?utf-8?B?V2R2dVk2WTJYUjhwbG0vNW80UDFRSDN1N2V2Tk5pRlplelN6TFBYaHNqWVJ4?=
 =?utf-8?B?c0xwK3d1MFNuVlhkbjNkVkIvZlE5aUVwVmF0MXpwb1MzN0xHcmdjcFJUbm92?=
 =?utf-8?B?bVNERE9kQWthWlYxdVJzS1Q4dnFzQnNYTFk0eEg2NW13SC9kUjQ1MW5MT3dH?=
 =?utf-8?B?bkg3RkkyTGszY3BDWmUyc0RhZE1IT2xtMG1KejRuSWxjZFE5RUVVL21sZndi?=
 =?utf-8?B?aXBzcjdNQ0dsaFdUNTRHMDA3YnY3cllWTnRjYUhpSjNDL3I0bEkra28ybE9y?=
 =?utf-8?B?c1JpNnZicEx2VVlxTERpU1dhY0FVSWRtSHVhbVgxR1E0QzEzSUhQNVpaVVBi?=
 =?utf-8?B?a0lKczkySVpkcndlSXp6THdnVW5meWQwaUlCNkhnZEE0Z0ZOQzlSMm1Nc1d2?=
 =?utf-8?B?VG91aHBvWTVWWmlhUFF6VG5Xai9DUUZDWGo3VzEzLzlPRmxNVUV2K2FrV3E2?=
 =?utf-8?B?a3duaWcrbTh0QW0vRGYyYzYrZmtnTWhtMjdSYlBCaXhqR1AzaDN3ZmpDL0tj?=
 =?utf-8?B?dTRwSXJxZ3ZkU25NLzdQV1RJeDJuNlVuY0JYbUViTjdWMmxpSU1RK0cxUnFO?=
 =?utf-8?B?UjRWR3RhQUg1bXVLWU1Ca1M4QXVTWkdlRTVPeTJPWi9PNkRWb3dCL3hJSnVw?=
 =?utf-8?B?bUNMYU5SbklZMml3a0ZsWnFFbGgzc1hiWjhLTWpILzVzeGZxR0FrcmxscEY4?=
 =?utf-8?B?Y1VRdytrNlJ3RW9pZ3BkWUo3VEhVSWFWTnk3NEQ0QUJBVWlEMWVCWXUvQnRj?=
 =?utf-8?B?THZZOUcvcjBYUXBHSnV6NWdha29zMjFocG5ZRmE2bTVzZ3A2WkN5aHVZeGox?=
 =?utf-8?B?ejNLUDMxbUtpaTJiaEpDNkJpV0Z1bWdyY3NnZmVzWnVsTjJxYjFveE50MTNP?=
 =?utf-8?B?SGR2QnpnYlBHaXdaajBWaFI1ZkxwMlZ4bVh0RUZDQlRRMm5JYUkyblhhRWlw?=
 =?utf-8?B?dXZ5N2VYL0FGb0ZzQS9Xc0t4bHRSdmhhMUZOMDZhRFdtSUZtWXJheGRBOEw5?=
 =?utf-8?B?SkRtY3JXTFpoZVNSSm5YN3B6U1BoNWxrVEVBZW1WWWdCcCtJZHY2ZW9OZzB2?=
 =?utf-8?B?M25peXVQcUJUSXdTVE1Mc0ZheW9mOFd1aUpRdHcyQ25SR0pUeTN1ZEM1UWl6?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d923b329-af33-4fe0-22a1-08ddf67579df
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:37:37.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1IwXubviQAXMBt86vQlKOVA29Cb110VD/EsNobmOecY0JK/HS+Prfvj+GXvV/k+d2HsaGyARxb6KiIEobt/ONm0mCnpUJIHrZwiPFB+kfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6383
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> "io_alloc" feature in resctrl enables direct insertion of data from I/O
> devices into the cache.

(repetition)

> 
> On AMD systems, when io_alloc is enabled, the highest CLOSID is reserved
> exclusively for I/O allocation traffic and is no longer available for
> general CPU cache allocation. Users are encouraged to enable it only when
> running workloads that can benefit from this functionality.
> 
> Since CLOSIDs are managed by resctrl fs, it is least invasive to make the
> "io_alloc is supported by maximum supported CLOSID" part of the initial
> resctrl fs support for io_alloc. Take care not to expose this use of CLOSID
> for io_alloc to user space so that this is not required from other
> architectures that may support io_alloc differently in the future.
> 
> Introduce user interface to enable/disable io_alloc feature. Check to
> verify the availability of CLOSID reserved for io_alloc, and initialize
> the CLOSID with a usable CBMs across all the domains.

I think the flow will improve if above two paragraphs are swapped. This is
also missing the non-obvious support for CDP. As mentioned in previous patch, if
the related doc change is moved from patch 5 to here it can be handled together.

Trying to put it all together, please feel free to improve:

	AMD's SDCIAE forces all SDCI lines to be placed into the L3 cache portions
	identified by the highest-supported L3_MASK_n register, where n is the maximum
	supported CLOSID.

	To support AMD's SDCIAE, when io_alloc resctrl feature is enabled, reserve the
	highest CLOSID exclusively for I/O allocation traffic making it no longer available for
	general CPU cache allocation. 

	Introduce user interface to enable/disable io_alloc feature and encourage users
	to enable io_alloc only when running workloads that can benefit from this
	functionality. On enable, initialize the io_alloc CLOSID with all usable CBMs
	across all the domains.

	Since CLOSIDs are managed by resctrl fs, it is least invasive to make 
	"io_alloc is supported by maximum supported CLOSID" part of the initial
	resctrl fs support for io_alloc. Take care to minimally (only in error messages)
	expose this use of CLOSID for io_alloc to user space so that this is
	not required from other	architectures that may support io_alloc differently in the future.

	When resctrl is mounted with "-o cdp" to enable code/data prioritization        
	there are two L3 resources that can support I/O allocation: L3CODE and L3DATA.  
	From resctrl fs perspective the two resources share a CLOSID and the            
	architecture's available CLOSID are halved to support this.                      
	The architecture's underlying CLOSID used by SDCIAE when CDP is enabled is      
	the CLOSID associated with the L3CODE resource, but from resctrl's perspective  
	there is only one CLOSID for both L3CODE and L3DATA. L3DATA is thus not usable  
	for general (CPU) cache allocation nor I/O allocation. Keep the L3CODE and      
	L3DATA I/O alloc status in sync to avoid any confusion to user space. That      
	is, enabling io_alloc on L3CODE does so on L3DATA and vice-versa, and        
	keep the I/O allocation CBMs of L3CODE and L3DATA in sync.       

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

...

> +ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
> +			       size_t nbytes, loff_t off)
> +{
> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
> +	struct rdt_resource *r = s->res;
> +	char const *grp_name;
> +	u32 io_alloc_closid;
> +	bool enable;
> +	int ret;
> +
> +	ret = kstrtobool(buf, &enable);
> +	if (ret)
> +		return ret;
> +
> +	cpus_read_lock();
> +	mutex_lock(&rdtgroup_mutex);
> +
> +	rdt_last_cmd_clear();
> +
> +	if (!r->cache.io_alloc_capable) {
> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	/* If the feature is already up to date, no action is needed. */
> +	if (resctrl_arch_get_io_alloc_enabled(r) == enable)
> +		goto out_unlock;
> +
> +	io_alloc_closid = resctrl_io_alloc_closid(r);
> +	if (!resctrl_io_alloc_closid_supported(io_alloc_closid)) {
> +		rdt_last_cmd_printf("io_alloc CLOSID (ctrl_hw_id) %d is not available\n",

%d -> %u ?

> +				    io_alloc_closid);
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (enable) {
> +		if (!closid_alloc_fixed(io_alloc_closid)) {
> +			grp_name = rdtgroup_name_by_closid(io_alloc_closid);
> +			WARN_ON_ONCE(!grp_name);
> +			rdt_last_cmd_printf("CLOSID (ctrl_hw_id) %d for io_alloc is used by %s group\n",

%d -> %u ?

> +					    io_alloc_closid, grp_name ? grp_name : "another");
> +			ret = -ENOSPC;
> +			goto out_unlock;
> +		}
> +
> +		ret = resctrl_io_alloc_init_cbm(s, io_alloc_closid);
> +		if (ret) {
> +			rdt_last_cmd_puts("Failed to initialize io_alloc allocations\n");
> +			closid_free(io_alloc_closid);
> +			goto out_unlock;
> +		}
> +	} else {
> +		closid_free(io_alloc_closid);
> +	}
> +
> +	ret = resctrl_arch_io_alloc_enable(r, enable);
> +
> +out_unlock:
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +
> +	return ret ?: nbytes;
> +}

Reinette



