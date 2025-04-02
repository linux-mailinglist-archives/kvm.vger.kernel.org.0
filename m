Return-Path: <kvm+bounces-42433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E094AA7866B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BD8F16895C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0F570813;
	Wed,  2 Apr 2025 02:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bHpT2R0K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD3175A5;
	Wed,  2 Apr 2025 02:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743560942; cv=fail; b=rYzeqlrR53lfywJOqpKgSel62e4Khxqcozx26m/KHWZNCh3MMhl9ZkzUpwmPX+wIPKqxUKtG4jig3qNthqR4XPg5F/vHK9sJlKP5CpGOn+qNIXpR+ximfcLLMWVR4zT4mtpzLjQZL8r+CTHrfa6BbcEPjtw6PNVcnOvclRAlDBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743560942; c=relaxed/simple;
	bh=FJxASc0OViCDioarPZcr/wajEJ5FFZTF9gmOxKIGDZU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k34dJn5d4MY83az1dzo3y04AtKzcakcAg5ZlJlbSk0L9ZpmNykgPEP5X1teDVjca2Z+cm1KcSNdgCU8P+A8Et1eeZPNRJVg77N5neAwYjYZ3c+aE9hA0xQ8es61bIyLb9CLuPOQhQjb5KIvlAKheQj1SQ6K8MNDBOHlrbFDF7bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bHpT2R0K; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743560940; x=1775096940;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FJxASc0OViCDioarPZcr/wajEJ5FFZTF9gmOxKIGDZU=;
  b=bHpT2R0KzR7WYLedz14CYYoKkxJxrsA923YD/7mnKvZCqSq3sqoQQCLi
   bsQL5EhhoFy3LRPfXMZZk098zh3jsLG9LXOJ57CorCiHxu/ysxJnyjFKr
   cuZkcrjvN+6L8uxlHq+g0P0tigfsaZCoFqxwzoLdJDwm24NcuR3oMCAxZ
   puZOYYjpe3mR8cSnUUzFsZtYWKuVxi+AKf1jOuGq8mXvKqZzmeAqaFegx
   HZ1uCZxaw4jfXVnEll1cvivwiAJ8xhwIU17I17nmTmbw4ZTOTPfZXg9Y7
   qXmDidbJsXgzuFZqXJTJxnnbw5mBu6HGrac0Ndt6weR31J9ZSlmS/YugK
   Q==;
X-CSE-ConnectionGUID: 2+bXUd8STH+UlP8gKdx6lQ==
X-CSE-MsgGUID: HP/m1XDMRfiGX9/0FNJ14A==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="56274001"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="56274001"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:28:59 -0700
X-CSE-ConnectionGUID: YoBg+zp2Sg25nSkAtifjhA==
X-CSE-MsgGUID: V06SfFbQRjGZfFwfOBQriA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="149740342"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:28:59 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 1 Apr 2025 19:28:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 1 Apr 2025 19:28:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 19:28:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pV7sMAeALiUC9VS0pgy036hkHhaPrUWxOCYK3aVS129jqexYiNX8d+XV588P5KpGl8+MfR7Hw1l3e76//Ov6+mYviGDyFLp5F9N/C17JrgT/hwG1T46UAWETEi0OczfKwz82MHZutB7rFDO1NDLYmaSoxueq89YORZbGiA+dCAewx1B0aOECX64zyEMQ5kBPuh/OjDzukCwhSpQVw0UIwc+5VRLVNugSaQB8ThYwhK5lMN+FPd/6ntqHSH+2FF9LKBm41/NOM6fSgq90N9k3zKzgLcLn5UXSymjS8D+WS3MPbXIDP4LaaVQsH7ABICS4PsmL6RcHOApNarAqOc1xbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erHKb5o7lLrDVSEnHAa11YU2xKkMWwX5UaamPPyqNO4=;
 b=wkbyQhXpQCp/VATFq4anOaLt1JN7OmW6fadCJhpgGJS9Fou/7tkIn6bJNb7k52tZvLd9GghRLEU+cGUIH9nxPRImcPcQ6uMJGGfzWFUtVe4h6x+nF3+HJgRWd19LkGJWwypz77VkHzH9u8cwXb4KhFkrpd6XWZr14nDueDVWzbd89lMETN0CemTt6vaNNm8Cpzx1vvVhWCn7bkRNr0maA+CvFIX9ebuAn6TJ6fblu9c0EBZqMjVLKut3skUaGnMyIiD0rmnI1TCl/8ioE7hVsrpUjD1fa25mIt1LEejztF5U/M/VWh/7ZFRgvXI+yiL3HgLO/VXjV6hWqehRq3Ox+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8838.namprd11.prod.outlook.com (2603:10b6:806:46b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 02:28:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 02:28:29 +0000
Date: Wed, 2 Apr 2025 10:28:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Mitchell Levy <levymitchell0@gmail.com>, "Samuel
 Holland" <samuel.holland@sifive.com>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>, Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v4 3/8] x86/fpu/xstate: Add CET supervisor xfeature
 support
Message-ID: <Z+ygwMmxRJQIRGoy@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-4-chao.gao@intel.com>
 <d472f88d-96b3-4a57-a34f-2af6da0e2cc6@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d472f88d-96b3-4a57-a34f-2af6da0e2cc6@intel.com>
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8838:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d5c833-740a-4b7b-bcd2-08dd718e0e07
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N0szNThPemNwWk4yU0pDalRZTUp0dEE3Q3lud0lFanY3SEVOUTFGTlNpWmxz?=
 =?utf-8?B?bnlJRXNiaG9aZkcxbngvQnd2M25FdDFBTys1OXhINXU0UGt6cTUxWlMrOFhJ?=
 =?utf-8?B?czdGbm5XUWsxZXZsNlhLc0xHNjNoK2RicHRyMGZSY0kwclh5eXZxL1F4WVk4?=
 =?utf-8?B?Z1NqK3VIVWoyRDhtdkdWUlBLUG1BTnBucW0zTVlTU01wMnlnbHNpbmo0Rm1Z?=
 =?utf-8?B?eEJadVNYT2N1dXAxbEhUb1BQMVppWTdQQ1ZDRmNCV2xHdEhyRTJYbi9WUEhG?=
 =?utf-8?B?U011cnVWUjdnOE9lSmpIQU44SGFzT3ppZ3NLQ3NPMkc3TzZIN1U1OEtGcGly?=
 =?utf-8?B?WEhHZHhuYmxGZWd5dklNRStaa1llWXRjVG9kV3VTQnBLbkJUYkhwYWJGWlcz?=
 =?utf-8?B?QTM0bEJ1QU1UUmRQbFhYVi9xUnd4Y1M2VytaUnpjditSc3NTcW1sd3Fhc0dZ?=
 =?utf-8?B?QjZNbFloUzZvSWE3UWxkVFR3dVR0SnJ3R1FwWGpjemozSEw3TmVoMDZKWVFE?=
 =?utf-8?B?SWNtMTltZlZPMFgxc3kydE93MUNNMVZCdkptSUZWbGlpUDNTUUhqbjE1NFJB?=
 =?utf-8?B?RXhLL3V1eGJxSThyZEwxd21HM2VoWXhyY1UveDNRUDdLQ2dna29HSkFoUHBl?=
 =?utf-8?B?dzlKQ3V3bnUvYlM4Q3l5Ui96Z0hPSnNXZ2tuOTIyRmdIcndIZ0ZidlVKVWlP?=
 =?utf-8?B?aUlNWEp5UW8yNkJCTzJTMkdKazB2cmV2RC9NaWlMbGtCa1NTSlFxaWdaZFRj?=
 =?utf-8?B?UW52SjVDaTZ4cjZIbWNBbG51azFqUXdhblM1eCtpMy9OclZEazN2ZUJyYmRu?=
 =?utf-8?B?SUV6MW1PVmNIcHJwOUJVM0NtaEF6WEViK0x2WXZFaFdYeE8wTTBGeHpCNEFM?=
 =?utf-8?B?UlhNeXh0bnp1QzU0azQ3OXpQRnVDUjYvYjJkamZEZUVJZ3IybTU4aUwwemlP?=
 =?utf-8?B?TDBZRXJ3bXlxK3JWQW02eEVCNi84UFhLZlZxV2oxQlNiM2hHNUppZ3dJdDNM?=
 =?utf-8?B?WDZtUjBaeUNRK2lHeGhVZ2c4UjFQemM0V3l6OUtuV0NQTFJTVkQ3KzV1dlc2?=
 =?utf-8?B?bXArSVNESjhidlhCVjlhUTZTUWdVeDZLL1FVTFZCbGpnYmFUaWZSVFZ0R25j?=
 =?utf-8?B?STRRL3Ezek1Oem5LekJEd0F4UE9uRjhYb1QxUTlEcXdUVXF1MXJTa1VUN0Ix?=
 =?utf-8?B?SXJESlhPR1MzRkRsSDZGcHNEZEh2QmlnalcyM2Zka0R2M2tVTkwyODVtb1Jt?=
 =?utf-8?B?SklrSEJVczBMdGdsa092dmxBMzlxNGNXeGVIR3R4Ylc4Q0FZL1dnZDkwQmtr?=
 =?utf-8?B?dEppVmorcGc4RnJkdjd3TUlHV21pUmhiZXhIckFPVHVlMEt3N3doSjNsanAz?=
 =?utf-8?B?cjJwZTUxVmYxVG5JYnZaTE9JMVdFMVIwMmJYVU1tckFKeW94SXFPT3p6ZmJm?=
 =?utf-8?B?YVIrOXZrQmgxUExiZjNYRElGb2loOENZaXNNVkFHVnNSUmVhQWgrMVJId0E2?=
 =?utf-8?B?TmNmZE40UEMzZUZqM29ZZFp0N2pWY3EvSTZIUVdldjNTRGFkVEI1c0FycXZa?=
 =?utf-8?B?WE9ENFArdVRURjdkYmxNa2tuMXIxVmlIdEMvb25zNTVRTUR3RkZvb0NkNDlh?=
 =?utf-8?B?MW5xdUxlbjQyVFVhZ21UZjJ1SFVDd0ZuZGwrWUxZZ0NHMU9pQzNNaWNISCs4?=
 =?utf-8?B?Yy9wYmJCS3FTZlp4dmx6L3cxM2VYVEp0c3haMnBVQ3Z2QTFmTlNZVFFORENp?=
 =?utf-8?B?Z3FnT2JNWWsvRERnMmtvaXZoZXNvdXJSM1VaUy9iNDhlUTMvbUZZRW9XUzN4?=
 =?utf-8?B?Ym4rUk1KenJqZjRYaHVJZUh3R3Jwc2hNRFoxeDhGa3ppeXFmSHFmRjFWNE80?=
 =?utf-8?Q?6Er6uZ/q4qFUS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zk1WK3lRMmZpQmdhWEtHVFh5L0Q0NXRVNk5LSmxSckdqWFlxVG9Pc2FTeG1n?=
 =?utf-8?B?d2l3TnR6eTUvaVFiMjIwcDh5dHo1VU40ZUtiSCtDSHVybkFDTmZ0M2g4eUt0?=
 =?utf-8?B?dExtTUhkV2lzc0NVUWY5bTh3T0gwZmhnMlZGQXB3YmxZRUJ0cmcrZ1NLVHR1?=
 =?utf-8?B?RlJjeGpMQzJUWW5pSDlOMFlyZkVoajM2TzVNaThRcnJuQzJUS2dKRW11TXVi?=
 =?utf-8?B?emxMa2RNUE9aaVhENC9VUGRnVnl4bDJScjluemZQYWZhSFp5a1M4VzZsZTZQ?=
 =?utf-8?B?REdQTzF6eENLcWZpS2U5ZWdRRnJVK0dBK0JFTXF2TnBzeEhPMDZaWjQxZDl4?=
 =?utf-8?B?RTNDcks0RnpudG5xb2dubC9HWTlXK3J5STF4NFZVRENENDFUaUdLRXNXMjB1?=
 =?utf-8?B?SHZZRzQzMWIvZ2l0MHZUYlpJUEpFalQ0akZNK1NobGVBYVJ3VStjTDJPYXBO?=
 =?utf-8?B?dHgyemZwZTVFTXVLT3ZlU0V6cGxQN1R3ZUNoanBjMlpHUVUxbWF4UndZTGtz?=
 =?utf-8?B?NWM4TUpzb3RpYkp0NWF4OXFiYlZCTkVqWm1ML3IzT051NkNJTStmUTR3TUFX?=
 =?utf-8?B?aVZTY1pEelZzOHk5RlJiQUxMSWdMZUZSQlRKQTJXb1dONmgzeWlCNllTT05H?=
 =?utf-8?B?ZlFpeDIxOTlmL1puM1hsQkdEU3c2QXNVM0ZLYldrQUYxSUg2aDJZWG5MSElq?=
 =?utf-8?B?VDRYQlR2bnlOQUNXKzhVZ1BLZy9rMVpsZUVOUEVFaDBIZzB0YmR3WTNVR1Ev?=
 =?utf-8?B?RUJDRG1ndDU2TXBoNkwvRzg0a3JtYllnYmNyOENGbGhkNko5SjlQUGRnKzc4?=
 =?utf-8?B?Y0JpRHJUM01iUFhIV1lQcWxsYzJEZkVueXc3MFN0KzJwNjBheEVZa2pwNnhZ?=
 =?utf-8?B?c2l5QXViV2pUbUFPZGpDeE9KUXpwdHpOaHp0L2xKU1hKaDZrZFhTQkpFQ2tu?=
 =?utf-8?B?ZnpVbE45eTNVTXV2RHdqZWQ0bmJoalRadHc0RkwweXZWUmRpL3JyWXhGaXpl?=
 =?utf-8?B?ZFIvemdoNjlDb0ZTbmFuZ29LQzZpL0UxNkpSalRsM2FtWWd5dnYybWRoTlBn?=
 =?utf-8?B?RmxqUUtHSjBlUWNVb3N3enhXYTU4TnRrSk03QmhuczNsbGdzLzEvdGl0RFl4?=
 =?utf-8?B?clFSeDNUUFlSeG45NzNXY1A3Z1lKUlNibUNFNWpBRlRERTRZUE1QMHpFb1J5?=
 =?utf-8?B?T1lXa0hSU2VCbWkzUFVBb1Q5V3lLekZjYmNiNHg1Wk1qSElVUTBrdW5HZUdP?=
 =?utf-8?B?S1VjUW9tSjZPSnhOVmJUUGFMcjhXS09DYmNqbUdRRjdXRDFQdzQvOW9KZHdI?=
 =?utf-8?B?OWRBaW9XL3AvQm9SWjlqcjdyWStKWHRFT1ZQK0FOS0dKaXN0WVlMclVnbGR6?=
 =?utf-8?B?NnZtdndOaXF5MkZnRXdja29YVVNTZnAwNmpYdkp1N2QvcDBwbzBjL3I3L1Fr?=
 =?utf-8?B?cHpKZzhRcERwVjQyWnFZbFFlMlhDZVY5S1hHa2UvaEYvdXRIc2dLd011dVhO?=
 =?utf-8?B?NCtvOUpHS3ppT3dLTkFsRVdaZjVzUzhpVHVNQ2JHVkdab1pCelh2Wk1uUDZy?=
 =?utf-8?B?SUdNWWZjdlRhYjlTY2cxR3lEa2dSTWl5TVJVSjQvUmZONm8zbFNGOGxRclk2?=
 =?utf-8?B?UXJTSlFkM3B6bDFOcDh3cFkyYlR5UWpuSWZkSkZWK2VLSlNOWW9SODdobUgz?=
 =?utf-8?B?UGZlY3U1RXZJNzd4UjI5L1g1Y1NaZUdLZjBmSmVTRTFjblYwam5YV081VGQv?=
 =?utf-8?B?QnlBTFE3bGNJZGxtd0pMZWtBR0RKTHJkdGtPY1V2S0hXM243anFyK2M2WEJM?=
 =?utf-8?B?TWFUZVF1NENka1NmbmQwOFpJWlN4TkUzN3B4SUJQNlcxWkExNTNRNHZYd1lu?=
 =?utf-8?B?ZzdDaENZQzJRNUt2WUVvY25Ja09LaTkwc1hOaDZ2S1RrKzhiZFl1RHUxdVZj?=
 =?utf-8?B?Yko3clFCbFZ2clRScnhzdjBzY0R0VXlLNEFTRlRPd2Q0V2pCMzJYd0FOU2NJ?=
 =?utf-8?B?K01XSmVCVEJNeFBsZmlUR2FkalVJM1NkU0h1ZUVDeE1nVTQxOWh1MXdSbjJU?=
 =?utf-8?B?Y090VUdZdXBQZjlLMDU4cnVkcWhDYS9EU244Rk9FdzFEelN2QnhuU0YyVTdj?=
 =?utf-8?Q?REded0x5+1bvCII+UUuoXzpLL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d5c833-740a-4b7b-bcd2-08dd718e0e07
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 02:28:29.3450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ4O1NciWPNkvpwq8iryXOBxApl8+YnV/R7SybkKb+TK81YvTHmftqfcJUtLqbRoTwqcslrHg589Fhwd/+xuVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8838
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 10:15:50AM -0700, Chang S. Bae wrote:
>On 3/18/2025 8:31 AM, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> To support CET virtualization, KVM needs the kernel to save and restore
>> the CET supervisor xstate in guest FPUs when switching between guest and
>> host FPUs.
>> 
>> Add CET supervisor xstate support in preparation for the upcoming CET
>> virtualization in KVM.
>> 
>> Currently, host FPUs do not utilize the CET supervisor xstate. Enabling
>> this state for host FPUs would lead to a 24-byte waste in the XSAVE buffer
>> on CET-capable parts.
>> 
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
>Placing this patch immediately after a few mainline fixes looks to suggest
>that supervisor CET state can be enabled as-is, implying that the follow-up
>patches are merely optional optimizations.

Yes, this is intentional. I mentioned it in the cover letter:

"""
Reorder the patches to put the CET supervisor state patch before the
"guest-only" optimization, allowing maintainers to easily adopt or omit the
optimization.
"""

>
>In V2, Dave provided feedback [1] when you placed this patch second out of
>six:

In my opinion, he wasn't referring to the patch introducing the CET supervisor
xstate (i.e., this patch). Rather, he requested that the patch making the CET
supervisor xstate a guest-only feature should follow the introduction of
fpu_guest_cfg and the relevant cleanups.

>
> > This series is starting to look backward to me.
> >
> > The normal way you do these things is that you introduce new
> > abstractions and refactor the code. Then you go adding features.
> >
> > For instance, this series should spend a few patches introducing
> > 'fpu_guest_cfg' and using it before ever introducing the concept of a
> > dynamic xfeature.
>
>In V3, you moved this patch further back to position 8 out of 10. Now, in
>this version, you've placed it at position 3 out of 8.
>
>This raises the question of whether you've fully internalized his advice.
>
>If your intent is to save kernel memory, the xstate infrastructure should
>first be properly adjusted. Specifically:
>
>  1. Initialize the VCPU’s default xfeature set and its XSAVE buffer
>     size.
>
>  2. Reference them in the two sites:
>
>    (a) for fpu->guest_perm
>
>    (b) at VCPU allocation time.
>
>  3. Introduce a new feature set (you named "guest supervisor state") as
>     a placeholder and integrate it into initialization, along with the
>     XSAVE sanity check.
>
>With these adjustments in place, you may consider enabling a new xfeature,
>defining it as a guest-supervisor state simply.

I believe you are suggesting that the CET supervisor xstate should be
introduced directly as a guest-only feature, rather than first introducing it
in one patch and then converting it to guest-only in a subsequent patch.

This is a valid point, and I have considered it. However, I chose to split them
into two patches because the guest-only aspect is merely an optimization, and
the decision on whether to accept it is still pending. This order and split-up
make it easier for maintainers to make a decision.

