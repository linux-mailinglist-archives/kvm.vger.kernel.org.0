Return-Path: <kvm+bounces-69258-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 178UO7H0eGnYuAEAu9opvQ
	(envelope-from <kvm+bounces-69258-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:24:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D7698640
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CD193031335
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 17:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFA82E9759;
	Tue, 27 Jan 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKJwyC9B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7208139D;
	Tue, 27 Jan 2026 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769534629; cv=fail; b=l+5D7BPlY+CEIgq2VNKjE3VIqVCaEAmGfNpvLcxk9MCLlWsc7lO+k6SYIFn2qeBBHwxg6XZHXwcmbb2Fs35Iy2gn6kktUlgC6Hp7nV2f8HUq+Wv77gFs+wPr4Dvh4UPNM3tcdSI62kB+VRS9AYkbRJujx2EkL7R/8ZlOgYT6xTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769534629; c=relaxed/simple;
	bh=1wzb+YwWrRUfj8ihC9zZMjAw92NDJ/ZIX0cnP8UaOYw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=k5PLYZRbqOgSJb4sS0RuG8OEt44XMQInLT8JdCmDCykuFGrrJCaA3k/tw46CupBC7Y1vAiBfu5p+VkCF9aWIUPWa1px+rjEfdcPtPFq4gZgRGfvTuGeUp8UUxEtHzBGA1Lwc54b+dKS/VLdfubhbrKr0OJitGOwoDJMiK7kUaWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKJwyC9B; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769534628; x=1801070628;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=1wzb+YwWrRUfj8ihC9zZMjAw92NDJ/ZIX0cnP8UaOYw=;
  b=kKJwyC9BzSV1ODerx9caA6vFensnKsbZPbVSx5GCpjfbs0zkgB8zexcD
   uHr2m8EKu7AUrzv29LxZ/bbSyDNpXFtxPneBXRUat6RyHtNUj1kS4uIGk
   leGxQfS/LtZYTHovEwOlAGrOoiK20xgUGiiCAnGG/mnG790tvIl0KvfwL
   DbsT2Rl87RcNGhPgglnu96l79DQVoLosjkOObbdDdLz/eumucCyj2xz4N
   1KkLzq1rhN4LpGxI8gu6JjU9KnQ3YyGa8Sf7cUh25CvBhCaNSHcnXOIUE
   nA2XXmbmIHf9j0o42Iae47UJGkARYMffwCxagw68tmn0Mk7xh5tW7klDH
   Q==;
X-CSE-ConnectionGUID: b+BYg+AARBqWPeF34zENzA==
X-CSE-MsgGUID: SDbPtyNeTvWQXfM64OU2eA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="74599333"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="74599333"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 09:23:46 -0800
X-CSE-ConnectionGUID: 97DPZC2xSSGmAlnlPich+A==
X-CSE-MsgGUID: d78rYPlDQBiCTVs/YMVWwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="245657258"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 09:23:46 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 09:23:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 09:23:44 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.29)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 09:23:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtKSeBrp7aPn6ytm1WJdRv20gguvvY7Dt2dsNSdt2+9i+8TScogzOu6FfDzy14SQk0bUXY3/OcFaLB0D3ovEKe8gaZ01AqnJxhPYy7FfaOfATVFIJpKZytkrwMLehjoK0ygC6V6hStqJToYkGm1t6g83cMvIL4Fxd2x3kVfsA7F00FalYymBRCH/qdvN+0VbKeET01+ZdW6Jsu6yYRi4IGD2/MM2YU/qqYlgpFTMC5Xd9PICNVj7iqJ2hSNRSQvydNkFSMdzgdmx6awZkKsudoP+Ib6/lujwEQ39XaVKgHhfUHaumz6rHgiMAPtSCeeiuWLdt1jxeDD8lcHDtbzXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwjMKOx+bRxbtvHyReU71mYlvo94c7G6k+lWtG18exU=;
 b=WxpF6WjV2bk1PHZh5AnK5kparfzgWf+EsXBg1cGsYFPjEFOOD7uT6c6BpgFo84ouYh4dkE+TwbWM6/a2kcMFISKVlwsvXR/rakr53nzy20ezrjSfCtoZTcD6+WcYin+wC3SK0ZwyUHPRGaNDUp4kQ7IpaNv8YN4v3iWdTwzr2ZdsaP3Sd3IriGXl+bZL6qlokQRCnCmN4ThBo8jyt3ZUQZfRpxQVJSiI7u7AIqqM8Tv6y7G0tCEHiFYRomfBk2krIzXtU2I9qjrMgaRZhEXjBpMtBbFez5YS6rdPcpi5QHy8emc2ThZVG4338EDQBuS/kbJOPCOCtLdZUHSJOAt50w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Tue, 27 Jan
 2026 17:23:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9564.006; Tue, 27 Jan 2026
 17:23:39 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 27 Jan 2026 09:23:37 -0800
To: Chao Gao <chao.gao@intel.com>, <dan.j.williams@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <yilun.xu@linux.intel.com>,
	<sagis@google.com>, <vannapurve@google.com>, <paulmck@kernel.org>,
	<nik.borisov@suse.com>, <zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>
Message-ID: <6978f4999af8c_1d331006e@dwillia2-mobl4.notmuch>
In-Reply-To: <aXis76vQhWi3RvEB@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-27-chao.gao@intel.com>
 <6977e73a7a121_30951002f@dwillia2-mobl4.notmuch>
 <aXis76vQhWi3RvEB@intel.com>
Subject: Re: [PATCH v3 26/26] coco/tdx-host: Set and document TDX Module
 update expectations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BN9PR11MB5243:EE_
X-MS-Office365-Filtering-Correlation-Id: f884812e-ecae-408f-cc8d-08de5dc8cf71
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WDg1dTlMcTF3dmZONnpFRE51bFVGR1NkdFpUYVFXNk1qTnVCeGFKRVQrTXNU?=
 =?utf-8?B?NnJHcVkrT0ttaEtzU2JkcFFLTjJ2Q1VZeDAvS0h1RnlON2pvQ3drc1Fzc0RB?=
 =?utf-8?B?bzJyOGloVUhkLzVPdng1RjA3YjlGNDI2UVEvZTFZTG1paUl5ck5mclNmditp?=
 =?utf-8?B?WlRvR0Z3Zy8yaTR4b2g0c1MzZld0am4rWkVXZkZrcjR5WGxRTmJFMEJFOUxa?=
 =?utf-8?B?OEFRTVBwS2pVMHFpaTBwb2xLS3lFcjV5cUhyV2JzYzdKSy9ENXpOSUozOFRw?=
 =?utf-8?B?bVVIRTI1VG5ObitTUllwZEV4WU82aGlwWjdsNDhZS1ZzSUFjTXljK3dLMjBs?=
 =?utf-8?B?STBhTzlaaVBuVFB3NFNFR1dRTlMzcld3WGs0YWM2T1poQ3R0YXdKTVptZHZa?=
 =?utf-8?B?aUJDT1p2TW9zS2NDQ2ZNWEdrRDB2aEZ0bHpXMzcvRHVFazFKcm5iQlJsbHhp?=
 =?utf-8?B?ZnpjRVBSVlF5Qmt4dEZxbXdMektRcWIrMjNHUGo5NWE4YUlMTzNlNzlXYzAw?=
 =?utf-8?B?Q2dZVUhLTWVGOGhzZnRoQWhrM09tbzhGVmZ3U3hJVWhIRVM1SzFVSkVGMkZy?=
 =?utf-8?B?MnI1aHhUYU03Z3ZBQ0dQQndxY1lvakpIVU96bzQ2aUxhVFZqTUwzQWNBYXJU?=
 =?utf-8?B?Ui9yUUNIU2FPbDBVUE1JZ3g0VVRQeW95R01ZVVdsYXpLVDFySXp1VHdGUHZ4?=
 =?utf-8?B?M081VFZXYUd2SjBjankrZ0EwZUdHOVJTTTBxajVRNE5KaEFxOE16b0dFQTJk?=
 =?utf-8?B?L3E4NkpmMkNqZXljTlFDdzhHV0IrWGV0TnlSRUFyWHVBR05rMFV1czYvdlVE?=
 =?utf-8?B?NnAzUFRTeVJRM1pUczlkZDRHKy9MQkxaS1hEOGE5aFlKdElTZHM0TGVVUEpa?=
 =?utf-8?B?TmVDeFhXRTVZQjJZazg4WG9XUHVWVXkvQmJEbUZ1R0VxVlRVQkpqeDVjMkFD?=
 =?utf-8?B?NjhpQjZUSEVMRXZjY0JZb0JNRGxXaHExdU1VVFdKdDNuMVNzYVE2WVRlVjBm?=
 =?utf-8?B?Y0NBcVZMSVJ6RmhHeWN4VlBMMTQvTTdXckZkRHl0WXg2ZEF0MnRXTk9KMzdC?=
 =?utf-8?B?aHE4eUl3SkNzTnFlNTM4eWsydmVKVHZxQ3pKbDU5TUtieS9hNmxDY0wrbDY4?=
 =?utf-8?B?Q2Q1WFZkZFlSQ3NKeUVTdEgzOWFnQS8rb0prK1pmU1VpR2RNb1J2YkFEUVNO?=
 =?utf-8?B?TWMrMVZPWE9QbkhleGxTeWE4c0pHdy9nY0FwVUtyZitrTXhTVHN5alVWV0Z0?=
 =?utf-8?B?VXpJUUt2Ykw1Y2ZPR3ZkZDExTHNEUEtucHkwd0xpbUE4a0thdWUwM3Zic2Rl?=
 =?utf-8?B?VTRVMHNVMkF2NG1xM2lMRTkrOFFIbWMyRGdtb0kxT1hraVZiQUgyc0hBZkk2?=
 =?utf-8?B?RUdEc3pGbGJSRHZTaW8xVjhxbnVsMW1TVmtWVGlTdFU5bTFSN2QzakZpRFh0?=
 =?utf-8?B?RGNVTU02cC9JUUVxT3NaKzZVSXdjQUZ0Q1FkWnFvQUt3ZXdCRkx3U2lDTWhC?=
 =?utf-8?B?OXRvWVYzR2hQeFc0Y043MWNDVTlPay8xYjFtR0ozSmFKdmpVOEMyb21BL0VQ?=
 =?utf-8?B?MWs1cjVSMFVqMGgxazNSOEZyMERpMmQ2V2hjUzA0L2tVUHFNUTZ5M3YraFdV?=
 =?utf-8?B?Z3dueTJUMmFoVzl4OFBETGdVSUFwUnRTZmQyS1lwUWE1V2FsdXlueDg1WE5Z?=
 =?utf-8?B?MTZHS01tRWppN0d5L1dNWE9XMzlXQVVKaUxraWx2OUx2UU5hL2wzcUlRM2lG?=
 =?utf-8?B?YkhWR2I5cWlldmcwWC8wbFNxQWxMcVZ5eG5URnlvbWI0RExiVjdFRisvZzZ1?=
 =?utf-8?B?NThROWE0RVBscnV3Y2g1M0t2UkhWWTkyR0Z0MEY3eGQ5emdRcHEvTTJ5NllY?=
 =?utf-8?B?T3ZNNmNWUFN4eUhjWlJyd3NYdmhyZUxUTWsyTitXOEVlbHpnZzlSMEY3OW1x?=
 =?utf-8?B?aVZ1cTN6WHRMT3N5eUZaMnprTDF1Wk5lQ1RTWm9qTWE0TVBGYlVldTR1Z1lX?=
 =?utf-8?B?ZVdsdmtJQVQ1dGk3YUJwY29sTitZdW9RMHZMdHFZREpibHJTN3VUUlJ6TEt2?=
 =?utf-8?B?aHdoNGMydTJNMXgvYTB3UEhyVk5mQkFIUlo3QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3RyMmNjMjJUUnpPSU42MVNNRTZTM3VZT0o0TlpaMjhxSDNnQ1hFWE52TEVa?=
 =?utf-8?B?Q3hFQXk4WFBTL2xpbklyM293dENLMzZJdjdRZXVmR01nYWs4SWVVL21sMUNL?=
 =?utf-8?B?M1ZBejFzTEdSWWRLL044ZnVtR3JwZzZQYlJZSHBQa1ZTTTNUZTFVd3dMeVlE?=
 =?utf-8?B?YjJpWkRsbGx1aEVKZHlNVlJuSHNpeWk3WTVyRWM0NG9Jc0hhcnJwaU9IU255?=
 =?utf-8?B?ZEsreE1rSkxBNjM1OXNOY2l2TXk3ZkwxTXZ1R1VxSkpEVWR5c3hiZVVsSURQ?=
 =?utf-8?B?S2t1RkRTMTMxdk93QTRnOFM1MGdnOWRoWDZJNThGdldvSXRwczI5czNxc2M2?=
 =?utf-8?B?M253cGFGcGllWXp1bGhLUUJHTFU4ajRSbGlUZDJjR21nYUlpamhmYUpMckpM?=
 =?utf-8?B?bmJDbk5mejZqeENmaUMyb0NVVmh3RWVPTG94VXpBRjFRL3R1TXVYYjFMNldL?=
 =?utf-8?B?RFJCOURua0JUM3JMdEVBQ2ZzdFpadUpGdTZEbEh4b3g0QkhLNG5KcTlaVGUy?=
 =?utf-8?B?dURzY2tGY21nVVN4V05MOGlpM21CUnY3NDJJcmR5TjZKbWcyRTBrRzNXNzB5?=
 =?utf-8?B?eDRtY1pwcVhSVjlWRld3clVJOTNmUUliT3Y1dXdZdmhheHBrVjdWaDB6TGo4?=
 =?utf-8?B?eXZteHBRUlN5ZHpva3hyZm1Ib0lGUUJUNnNkWFVONkNCdnpFWnAyek4yS0RL?=
 =?utf-8?B?b0pHTlNBRUo4MFFVTjllcEwvbHhNZlJEbDNlRE5xU3NzWE8vTUIva00wbzA5?=
 =?utf-8?B?UmdCaWlDT2p5SWtocFh6MW5ZN21tU2d2RE14MWdIY09JdTdsVjZTcjRNWGxn?=
 =?utf-8?B?VkxxSWJlN2gzN1crMmh4VFF1ZGowK29TYzVKQVlFVUhuTlhoaGVvN2oybW9y?=
 =?utf-8?B?cWtWV0xTcFIxQTdoMlBuM0xvZlJ5UnphRjVIVXJmRndsT0x4alk2UlhGZXoy?=
 =?utf-8?B?S2pBMnp4UVV2VDRQdEk3Q3M0VHc3dTc4MlY1TTJ5eDNJL3BxcEJuOEI3TVZm?=
 =?utf-8?B?T2lGTXBwRHFqdVlkRFBaSFBUWll3YlJhdkFKK1VVckdjTXVWb3RRU25FRVJ3?=
 =?utf-8?B?SkxacWF3TlhMVXpsMGRxQ08ydnpqOStQY05TZ1R2WmN4aFNkVlhaN3lGbWRV?=
 =?utf-8?B?WjRLWi9QeXE1M29HMFp2U3JFM1ErbjVpQi8vakMwVTk5bGNTazZBcWJIOFlX?=
 =?utf-8?B?WnJOWG5NNktyWVhXYVRvM3MzM1pZOXBwMzJQT2ZqaXlQek9qMFh5OG5ONGNB?=
 =?utf-8?B?OVZzWlBxMWpYaXRxa2FQUDdZWXVsQXliRklCbXdmK2JnYmR4RkI3VXZLejIw?=
 =?utf-8?B?UE9vNDBsMXA2UEN1K1F2OGxQVnBqc1dWQkVvckFHSmk3cUVHNDZuN1RLajhK?=
 =?utf-8?B?VFVER256QTYvWStMUHhwVDU3dllvb2JQUFFYVFU1NlhXU0dZWTJQcUIvaXp0?=
 =?utf-8?B?WktYY2xUVEsxazBEWStWdVQrWHFTZDdwUVFVM3RwL3Nva0czR3Z5SVJiSmh3?=
 =?utf-8?B?d0dsY2pkVG1UNWxia1hUL2s1TkRpUGR6Y1lBMGRuRWtSbUs0ZkFtYzhOM0hD?=
 =?utf-8?B?UFp6ckNSdmhtb3RtWWFmYUVKVzhVT0xWYWR3U2Y3MmpNL1RVUHZMb0lncXY5?=
 =?utf-8?B?QzRucWJrOUpSY3VXVWduaEYrTjJnNG9vaXpRQjg3WEF2TFF2UmVyNFB5YnlM?=
 =?utf-8?B?N0pQMmNVblhDTmhlWDF5cnJ3YlB2NTdMMzRjdXpwNFViZW8xbWxaZWU5TFdJ?=
 =?utf-8?B?WHVtNDZiWG9Qdnc5MmRjc3dXcXFva1VhQzZrdXB6dllyUHRyVFVTazVRQ2tZ?=
 =?utf-8?B?ZG5ScDlTVkg1clZxMEJ5Zkp0K2VjTWZlRjd6cmU4blB4bS81dVFWb3p4RUZI?=
 =?utf-8?B?UklhZWorMWlBNGhtWkZIN0lCTVpyVkVudXhKSE9HQ3dWK2NBZitQODVBditK?=
 =?utf-8?B?SGFwNG9xUnZHOEx0RTRqWVA1VFNsZ2I2KzBna01FVC9SdGR3SVRoZzlNMmha?=
 =?utf-8?B?YUZHRDdsYmxUTGROSWV2ZzZPT1NPSTdjaWpjQjJkL29UN0NxWWRSMWk1UHZN?=
 =?utf-8?B?Q2tjSktidHlUOUVnVy9Mbjg4Q3FGelZzOHpkcTkvaS9UTllmenBxd21vNTFL?=
 =?utf-8?B?dklzNUY2di90WllwZWpWUGx2NTF6L0dXZ1h1OE1zVTU5ZUpraGtaQXlYaFV0?=
 =?utf-8?B?YklkYVpscmp6WDBqM3l6QVpoYzVlOEo2YXpnblpKU1gxL3JsNjY5eWh0eDVw?=
 =?utf-8?B?cklDVCtKVEppRUVzT0pXSXMxaUhVdm5sY3luaDgwZDdTQWNFcFdmWGRlbng5?=
 =?utf-8?B?eldWTmtzSVlsaloyY2RybUk5SU15dnRCY1NIOFBrY2xKTzA3R3VaejgrNjJB?=
 =?utf-8?Q?2hs6lyoVU634aMDU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f884812e-ecae-408f-cc8d-08de5dc8cf71
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 17:23:38.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FugRdwRXl+dmCH7FNf+6TsFKRcDb4PFYp583EjdfpjRMfdU64Jyc+id5hQukbTnT6e/shuTcCyEYa3z1AtfqSV2jM90ODOcIqWNqRobOQxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:url,intel.com:dkim,linux.dev:email,dwillia2-mobl4.notmuch:mid];
	TAGGED_FROM(0.00)[bounces-69258-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 35D7698640
X-Rspamd-Action: no action

Chao Gao wrote:
[..]
> >So, remove "compat_capable" ABI. Amend the "error" ABI documentation
> >with the details for avoiding failures and the risk of running updates
> >on configurations that support update but not collision avoidance.
> 
> Got it. I will modify this patch as follows:

Overall, looks good to me. You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...after a few additional fixups below:

> diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> index a3f155977016..0a68e68375fa 100644
> --- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> +++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> @@ -29,3 +29,57 @@ Description:	(RO) Report the number of remaining updates that can be performed.
> 		4.2 "SEAMLDR.INSTALL" for more information. The documentation is
> 		available at:
> 		https://cdrdv2-public.intel.com/739045/intel-tdx-seamldr-interface-specification.pdf
> +
> +What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload
> +Contact:	linux-coco@lists.linux.dev
> +Description:	(Directory) The seamldr_upload directory implements the
> +		fw_upload sysfs ABI, see
> +		Documentation/ABI/testing/sysfs-class-firmware for the general
> +		description of the attributes @data, @cancel, @error, @loading,
> +		@remaining_size, and @status. This ABI facilitates "Compatible
> +		TDX Module Updates". A compatible update is one that meets the
> +		following criteria:
> +
> +		   Does not interrupt or interfere with any current TDX
> +		   operation or TD VM.
> +
> +		   Does not invalidate any previously consumed Module metadata
> +		   values outside of the TEE_TCB_SVN_2 field (updated Security
> +		   Version Number) in TD Quotes.
> +
> +		   Does not require validation of new Module metadata fields. By
> +		   implication, new Module features and capabilities are only
> +		   available by installing the Module at reboot (BIOS or EFI
> +		   helper loaded).
> +
> +		See tdx_host/firmware/seamldr_upload/error for more details.
> +
> +What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload/error
> +Contact:	linux-coco@lists.linux.dev
> +Description:	(RO) See Documentation/ABI/testing/sysfs-class-firmware for
> +		baseline expectations for this file. The <ERROR> part in the
> +		<STATUS>:<ERROR> format can be:
> +
> +		   "device-busy": Compatibility checks failed or not all CPUs
> +		                  are online
> +		   "flash-wearout": the number of updates reached the limit.
> +		   "read-write-error": Memory allocation failed.
> +		   "hw-error": Cannot communicate with P-SEAMLDR or TDX Module
> +		   "firmware-invalid": The TDX Module to be installed is invalid
> +		                       or other unexpected errors occurred.
> +
> +		"hw-error" or "firmware-invalid" may be fatal, causing all TDs
> +		and the TDX Module to be lost and preventing further TDX
> +		operations. This occurs when /sys/devices/faux/tdx_host/version
> +		becomes unreadable after update failures.

I would specify the exact unambiguous errno value that gets returned on
read when the version become indeterminate, like ENXIO.

> +		and the (previous) TDX Module stay running.
> +
> +		On certain earlier TDX Module versions, incompatible updates may
> +		not trigger "device-busy" errors but instead cause TD
> +		attestation failures.

I would just leave this out. It bitrots quickly and does not provide
any actionable information. This is not the kernel's responsibility...

> +
> +		See version_select_and_load.py [1] documentation for how to
> +		detect compatible updates and whether the current platform
> +		components catch errors or let them leak and cause potential TD
> +		attestation failures.
> +		[1]: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/version_select_and_load.py

...that detail about what happens when compat detection is missing
belongs in the tooling documentation. That documentation does not exist
yet, so this link needs to be replaced with a pointer to documentation
before this goes upstream. I am assuming that we want to create an
actual package that distributions can pick up as project? It might be
worth going through the exercise of packaging the binaries and the tool
as an rpm or deb to get that work bootstrapped.
"version_select_and_load" probably wants a better name like "tdxctl" or
similar.

Note that a tdxctl project would also attract features related to TDX
Connect to wrap common flows around the tdx_host device sysfs ABIs.

