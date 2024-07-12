Return-Path: <kvm+bounces-21471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EAB92F58A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECE2128362B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 06:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DB213D896;
	Fri, 12 Jul 2024 06:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LBjoRcp6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53E217BBE;
	Fri, 12 Jul 2024 06:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720765672; cv=fail; b=Fwg4DgzfbMGTxX2gZ5Ry3HW3F9EFZwtt2mJ4ayHei8Gvkfhrklb8gLk7Hb33W1m2KBeV0mWcl4sVHsmrAHn3AxJB6tFTAdf2Ds2saCiUgX6PhIZL9ZemzwhwxtQzPu5fd194gSHfwCKHGeXq1RXuUI/Gb+pZV0S9ghYYh4dOPWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720765672; c=relaxed/simple;
	bh=euU2ZFJPjlE76gXkdy4MD9y346ssuweU7slqyz9pt+E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gdwt0lrtEyM6MlkMwD1qI0vPX7ePsIfGBwI2VDMOCdgS+yukqYlQxg7+YsO8jBnrsOex88l6da1PJg1cpHDFPgUwAbJaE5aRviAI3O1ig5u/egM/JKnNuiEAS9KzP7Rh7WSOCST+F7fZISaib5ipr0cItDfZQAQfNU5qJev0zVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LBjoRcp6; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720765671; x=1752301671;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=euU2ZFJPjlE76gXkdy4MD9y346ssuweU7slqyz9pt+E=;
  b=LBjoRcp6rXjicOLHsOjs2livERQMuVjbLPELyh7svZxbL85SuTWCTZMS
   XjSMgcCB+ffhMzBlN1b+B3QVoQA8oHdMngXsxdu9rEQVvLkoERsvJw1Z2
   ZJeORZF037PyVuwgtxeg+c9SPrA6BzLBk7aJeXjjvWhITgtf0EmoNFJXP
   YBACeJV5gjaUw/FXeK7J0r6Jcg21O02c7sF/CBw9eNaIjypYTMtEmJivr
   BPA1lkTaYyJkimHjeDDiY1VXuZboSapEN1k3eJ4T/Evd9Rd9VhTSpOf2N
   fY+3E3Wqfx3MN3PqUszeMXEAbAYsjnSH8Wtd+3XRGGOo/IrLTvTqTHVdX
   g==;
X-CSE-ConnectionGUID: BdEwjbgJQl+MBFIEqNAbSQ==
X-CSE-MsgGUID: iNgiG1pUQmCFTemGazrBFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="17809797"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="17809797"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 23:27:50 -0700
X-CSE-ConnectionGUID: bn+qQmDeRz2sVzJOnFTisg==
X-CSE-MsgGUID: s/kY6ZShQHKwOo+wQsQfgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="48777576"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 23:27:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 23:27:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 23:27:48 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 23:27:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sH3aYlLIodg6RProFUE8PELeI3F6FAujBSGJgFkp4zN1effv38+7AOGDTHO9SalrUtmFHKM/vnSVWwt0DhpZnxZRRAL+BiofFOXCHRladbn9M/4+vnD2bNYQwx+9ZFQy9ldl/sVqT02vQFNtE5GjEP/80ORdv6IgBbKgmrcGqIhTf6XnlMCW/+BnYzKXpIYKujOjmp6a6VUtTb9RjG9CxGtFWwaAnlJIceHglTwQh74rvjBZgkkXUzkUwSdBqzFjdhX9VnzrjU3LOzH9wUvyuI/pxAFZmEdbfnszcK9ob1j5ikPDcYlEJkirQtoQvAfIgqB/XfweDClal6i+iIiK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=838ziyL5A8vEn8FaaiAmakMzWekw67zSodhtGvPzAxY=;
 b=mBsZevmqaKWyBWLtBjzDOCyi0oAwts6uxNLyDGnV/eIWqqMLvbykOpwmcp5AuOsQ/d5pTGuIgFZcQvU3otYL9Avao35l91BuJ7KDE7AOfw849RxpUJp4EA/9CoeKegs2p8Ves4SufCEekxK8e18qKfVYd6E1UBATZaVWmR9eeHs+iF9QZmzQ0vWXNaUWiZ6sgXZUAd4cvHkPZCw2HwcnkHaS8dZ1UampjyHIe6cDLa1FsKCjkntXKB4IxK26N9uYgHQLlAjrSBcf7Zd3htAiI05lGyp6JXTVsPH1O0vhERxabxI4aVICkxiZcne0yw8KkoZ74vAwh78b6ntdHPBHHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.21; Fri, 12 Jul
 2024 06:27:46 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 06:27:46 +0000
Message-ID: <c35ef9a7-433e-4904-93ec-3e6d3deab1c5@intel.com>
Date: Fri, 12 Jul 2024 14:27:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
To: Dave Hansen <dave.hansen@intel.com>, <tglx@linutronix.de>,
	<x86@kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
 <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
 <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: a32b05f8-86b2-45a9-4728-08dca23bbe69
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UFZVWUIxVnNMbHVwRHV6a1A1Vks4eHhNTkNlWVAyRlkrN1ZnMFU0eWg3b0py?=
 =?utf-8?B?YzRnMWpMVFBkRysycDRPUFcxNXdEQU1sb2g5QzNaa1cyWWpNVUtaUjUrTFdJ?=
 =?utf-8?B?ZFNaa1ZaMjBFWE51MEFpRm52ZEE1M0R1VDV5R3lZVTNPbVd5dUF6STdDUVAr?=
 =?utf-8?B?ZnpkdHZCUi9TRHRKVFd0Vm1vZlNKZXo0Q3RJMERjTjN0RUNkTzN1VHRDVlRM?=
 =?utf-8?B?alpvbE9TTVJ1TEhkSkVYVFA4QzNSTzdIeWR0YVZDRE9WVzJBc244Kzh6bmYv?=
 =?utf-8?B?b2UrZlhUdURsSDdoZ1Zqem9WUUpXK2cwUUhCbGRTWE1QTXM1ZEpJMUtCekQ1?=
 =?utf-8?B?RHpmMjhNMUl1WDBwb2Z0R1pUK0VFRlYza0lmNjk3LzR0RGgxUEc1Y0RJQU9O?=
 =?utf-8?B?bXgvbFo5WHN3WXh2Zll2ZEpLMjlhR2RmYlRqeHpwcktuZm1XNzlVUkl0bStm?=
 =?utf-8?B?aWZvRmNxUDdkbDNhL1lEZ0REeGFIRFkzOVNFbkFKc2xpSmJVb1pNTUZ5UkR3?=
 =?utf-8?B?SzdSQlJlZDllTHg5cTdoclljcE5Mb2lPd3JYbTNzOHBGRzFJMTE3UkZGMC9P?=
 =?utf-8?B?L0JJSmIrem44U1JraUh2VVk0MHFXY3pRaFJNQ2pwQ0lhVFkyeEpkTWRKVWFV?=
 =?utf-8?B?VHJCZ3BrdnVLN2VhRlh3S0gwaGNGazNYM3J4OG45NlI3WnZFU1BFbkQxTnJh?=
 =?utf-8?B?SmkzcEtObzZ2a05xWVRnNkl5bmFYL0VIcTVMYkF0enZSVDdtOUY5RUhzQmUv?=
 =?utf-8?B?SHNjOVA1aEVhbUJXOGtsR0h2M1pHdzNVS1RtY1JxV1ZsWU92Z216ekQ3WVdU?=
 =?utf-8?B?OWhDZVk1L012eW1MeTRibGNRZTZRbzRlL0FhTTNaUkVWYU04SjhnUGNPKzRZ?=
 =?utf-8?B?MHk5MjNwWjlrUUhHRzIwMXF5K0VuN3Y4OUQ2aW12Z0Y1TG5HTnR2SjlWOHRG?=
 =?utf-8?B?eXNNdXB1Y0gxa2JkZGtDNTRtRHJjSG1IUFVheGdkc05XVlI3akhmUjdyUlV3?=
 =?utf-8?B?SFlTMVJReWtzM3E4K1ljaDhvNmZVWjhlbmthRXB1TVRPVkEzRjBRVVNBWGxz?=
 =?utf-8?B?RTQ4Zy9VWTlSS3pDc0ZyMUt4aTVIeE9YNmxRQ2VLZEVmdE5zeTRqLzcvSEhi?=
 =?utf-8?B?cWRZcnZWQTdDTEFGTFVLaUJNNTh4YnJvbHFaWHQraEhiR2hvS1ZzNjU4dllK?=
 =?utf-8?B?Z2IyelRTNVNuWDBpV1NmT1JBcWZGZmdjT3lrYW5CZFZhK0FxWVJsR2RMaEp6?=
 =?utf-8?B?RGorc2ZvK3l3T3RBWUxFeURlMUNRS1YvWmRGV2E5Q2l2VHRHbmJWaHF3RUFn?=
 =?utf-8?B?djRPM2tBdk1yOGhsY3lwVk9Dcko2NVVhWW0wNWc0QWcvOGQ4TzNacWgrRkxj?=
 =?utf-8?B?cStFaldjYVUxRWpOMzRPMG9lV29QamkwSHJPLzBqTG82ZnAxRGp1SzFCTEhV?=
 =?utf-8?B?QkR0RndmVHhMV2dhTGdRQUc2bzZqQ2ExRVUreW9pLzY1ckt3SmRLTlhvczlK?=
 =?utf-8?B?a09HdU9EQjV4UkUybFZVdTVWSlUySnk1U2ExQ0tPTXMyWTVsWlJkL2R2VjNX?=
 =?utf-8?B?VlluNjg3VXhvRHgxblQycVZWL1Z0eUU2UklWUzJqVVZtWnN5SXJRcmJDWmFW?=
 =?utf-8?B?TDVKT2Q5eU01eUlRTHNRMDJZQzVwU25pYUNwZTFaUkdnVTNPaERuaDV5c3I0?=
 =?utf-8?B?MWhleHBJcGhGS1A3MnBiY1A0K2hFREZKb0hsU0NCUk1WRXhjcERoaGlZMXlW?=
 =?utf-8?B?bWVpS016ZkxUZW51RTVyL29xTW5VcjhZUFlKeUJEb3lWb2xWSTdIeWo4cTNW?=
 =?utf-8?B?cS9RMmxtRXh4MDVoaGpHZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjMwYStZM2RQbTFGTWZ2eHZIaXB2ejVhcjc4SWdHUnhaTXRlNmpHRm9ZUytY?=
 =?utf-8?B?aTJWT3RuWFU1Zzh6K1QwZG9CVFZHblliNVJucTgxWXNPL0toOEFMeGRoZXFD?=
 =?utf-8?B?TVdSL05FZ05FMDFXb0hQMnhyWEZ2NE1abWZucjlROFlIR09wWUQrWUluY3Yw?=
 =?utf-8?B?ZTBHYm52WnIrUjh2VTFQamxPMmlZUFo1L3p0aXJDL0VJNFZHVEJldlJmWC9s?=
 =?utf-8?B?UE9GelZIeXdVMWJxKzFiNlZ4bGIxVXNDcURmVkEvWTNiRkFoSityalZRNmV3?=
 =?utf-8?B?YXFwcG1OL2s2RjBuV0N1UXpZbGtSNE0zSnloaW1Ic2tBZERvRE16VzlPLzhj?=
 =?utf-8?B?ekpRK3F3dVdqaXlYb0hwOHdNZlpObEREYVhLSHRhS0w2V0Q1dWQxcEphbkxj?=
 =?utf-8?B?Z3RaR0d6THV5UGdKam84MExSN3BWN25WUWFCNlIvNStTOTlSTnN6bCsvUys1?=
 =?utf-8?B?c1hqamcwcDQrU3VLWnFqYWtkeldpS2lnVWd0RGx4RHFWZzVIajRaMkJKTGt0?=
 =?utf-8?B?a1h6ckR3Q3AxZEcwQ1g2REVlRy9lSmU5aE5SSFlzTm9icFNHOS9vTHZQT2pQ?=
 =?utf-8?B?YjhaVTVzRFZTVzRwN3dQa2hsdFRvY015Q2NyUjd0RkxVVE1icmlLM3h6Y2ky?=
 =?utf-8?B?OURtdXFzclBkU3lUK0xSZWNyZUxCc2l6d1RaemMzeHVDYlZpa0ZxYzhZMXV3?=
 =?utf-8?B?b0tRbC9yQU5EVm53OGhranNXMlorY1BsbTNFZVZ5dk1uTG13M3J1NEMrYU9x?=
 =?utf-8?B?NWFFYWpEMnlZaWhCbnc2R3RpYXJGaGl2WGVGQ3RpS3RJU3JEWlFkUU1MQTRR?=
 =?utf-8?B?aFZvWGxrc0EwcFFSS3N3dzA4ZkZnRUhPa2o5N1F5YldWbkFReHdicUZMbmJr?=
 =?utf-8?B?M01WRDJZY0szdEMrc0IvSHlad05lU0g5TXBoUUcySFdlMHMrMVZZUldVbDFH?=
 =?utf-8?B?bi9DeFE0dFdYZG0ydXRRb0tJaDFOT3hPODE2T0hTeG5oeUtUOGhrNkZpSlJY?=
 =?utf-8?B?RGVHTDlMYTR2cGpVMUdob3VlYmZCVmdNdFRsZWczMW1XQXNrMHZLTnI5VERO?=
 =?utf-8?B?c0w2NFo3SUpJUTlYTjRzWXVDS3JnMVBSNTlENDdSRm9DSDlIc3VobEsrUHNS?=
 =?utf-8?B?cVpZVnVuY3JjRDQzcjQxdFg3RnpMdDNHcGR4RnpJZFZaTHBDZ0ZxUXdGeTVp?=
 =?utf-8?B?R2tQTjJWVGxhbjdOZFlOWnlqeCtLNWVreFdUQzlXbSttaXI0RVR2bFQ0U3Za?=
 =?utf-8?B?ZWZSM0x0TXpCRmEyQmREdjAwQW02QWFCb0J1aWhwN1l4QVVsSTMzRnlFUExL?=
 =?utf-8?B?cUw1N2IvSjgzSUhiaFkxUVNVbHhGVWdRYmVsYXJDQk9VZHJNbENEOXBKZFNL?=
 =?utf-8?B?OGQrMlBvSEtEc0RXdFpYYnlNRFJmblJRRjBTd1l6RUZ3bm9vSm1mSzVpS2hR?=
 =?utf-8?B?VkVvOUQ3T2hzTlF6TXZzcFk1N205UnFQNkpGZjVoQlp2a2cvWWhZRTZuTUFY?=
 =?utf-8?B?RUxCWGRpVHJyeXJFa29sOXVrSTF3TTJ0TjN0aU5MaDQreXRydnN2ZkIzU2FG?=
 =?utf-8?B?b0ZvMDNrSkFLRVhzMk5xRW41WDJEckJyenpxSjFIZ0V4NXZjbU5leklsbWl0?=
 =?utf-8?B?Z2ZVVTFEem9aaklsODBldTh6cXljaXVQZnR1Q3ozbmp3YStGSDZXRzRWNDUy?=
 =?utf-8?B?TmtRd1hMV2FnMXV6WS93V080ZzlKSVVwYmlZSkxOdWR2MUZzcGJrcXFkd2Vi?=
 =?utf-8?B?ZG0vWVBDMTRJd2pjdnR5L0Vxdk91akVSVUJjQ0ZGSFZGZWZ4SUxSS05uQnFM?=
 =?utf-8?B?WkhDeDVIekF5UGlNS295T01yWGUzRlJObjAzWnprdmJMeXc1ZUU2RFhvTTAy?=
 =?utf-8?B?d1dOL3R5bWdjdnNUUUt2WUMyMWdGTzBmVzFqeFNVbnRVTVJrVmRjcUw2TEdY?=
 =?utf-8?B?YlEvZUN6cTJieXpyZDgzR3dwQmxndUozOFV2TnFRSENWSmZlaFFCblZycWti?=
 =?utf-8?B?Y0ExOUMxeER3Ri9yVXZvdUR4ZDJiM2x1cEFsL1N0SkVkZTErMlB6U3NPSE50?=
 =?utf-8?B?ME1CMFZaYmZTWWpFRG1LWmpOWTJhMFBuZGZ1akxic0l5OFIxODdWUUJNR0lZ?=
 =?utf-8?B?anZwVFhTRUVtNXI2VisxRGk4Znpva2wvQ0dpb3JsRGZCUlBwc3JhUHZQZ1Jt?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a32b05f8-86b2-45a9-4728-08dca23bbe69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 06:27:46.3821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlTeiDWoFxCwh0o6S20bDZXX0dZHvWESJj26lwiUs0IcU03Ea30L3uKLsaZuf/dHib38IMRrfDVQiBRlu4b+zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

On 7/12/2024 4:58 AM, Dave Hansen wrote:
> On 7/8/24 20:17, Yang, Weijiang wrote:
>> So I'm not sure whether XFEATURE_MASK_KERNEL_DYNAMIC and related changes
>> are worth or not for this series.
>>
>> Could you share your thoughts?
> First of all, I really do appreciate when folks make the effort to _try_
> to draw their own conclusions before asking the maintainers to share
> theirs.  Next time, OK? ;)

Hi, Dave,
Sorry for not doing that and thanks for making the conclusion clear!
I personally prefer applying the whole series so as to eliminates storage space issue and make
guest fpu config on its own settings. But also not sure the changes are worthwhile from kernel's
point of view.


