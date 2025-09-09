Return-Path: <kvm+bounces-57118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F393B50276
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 004954434D8
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98ADE35209B;
	Tue,  9 Sep 2025 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aDBMJKPv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535C350D7D;
	Tue,  9 Sep 2025 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757435094; cv=fail; b=GlJ5b3Xx1V7W3L+zmlVXA9GHX/p4OWljpTOtEHqgWnIRzjOidURGh7/iD2JcidBeIrAnGMJcCXwQFsDvxf3WFd0eLjNDFiJPzL03/5BPCFwd7ZpjgssfwMM6HZXfeHmBR/LfCvqRBETv6A7jqjmd9bmaPE++yiV79acDoRDfoTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757435094; c=relaxed/simple;
	bh=KW/3tEmRaqObARNkmNmTH4jaLvbuoO5vmpWvGQ4dt70=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HrlteBC7ebtwqgRmvjEPG/DhUwzKzwmLjFILi3UOwtxnxgGz8hsT3aqywkSxHIJ8OQTNVFXdY+j2t/UU17nH0EaQdxLULAnGzaulOZa0mqfKCb+PtVrNLyO/+WkolaBeh3uJ/15RJufKNCrG19vN4NRf/6+QzWSBwGgC6hp8zW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aDBMJKPv; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757435094; x=1788971094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KW/3tEmRaqObARNkmNmTH4jaLvbuoO5vmpWvGQ4dt70=;
  b=aDBMJKPv1zbVQtfAkW77tfgATTY4na6+kDpyA4d6PLVGm7bV4Rk64QkG
   CuXqP9xVDywc0zPGsN7yAfrV2RrCUUWacD3SgHQ6L1QP5ND1FRfsjyNkf
   qanrAS1BE2de4gPqA0iOMfYbIEiQVYLqnPNYijG/R1gj2DwjSVRqLg5Kl
   bNAOs4AcIbJnsT/4CCg3Yeuf7CVWs0FRcCHYWvtWyNQDtv8XRMxAAMy0J
   2BRPm/jRUJc5E7JgaoOK9qvEMcPVE8zdS/cOri1IavdVC7CmjSbtSA+xB
   nU2e2fnWczhwOI6YEcckglnYLnUwN8ZeI/7XW5CH1S4Trogrp5F2HiCbK
   w==;
X-CSE-ConnectionGUID: PmgBYFtBQtm2/FU/QEOtcw==
X-CSE-MsgGUID: 0JiOZcS8Sw2KLRSPu1YVxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59677749"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59677749"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 09:24:53 -0700
X-CSE-ConnectionGUID: JOQTH9YkQfuytrdkHUw2Yw==
X-CSE-MsgGUID: +OGgS0d/S5msDWqmA98GiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="177186455"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 09:24:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 09:24:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 09:24:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.89) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 09:24:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=til0jobxy5VXa0UH+3xUAbJUxK8uR8RXPnVdivoV+CPicnTsceUGngrd+3Uy173F31egfHDYJme1s61ibVcJUnMVeOJnEX8J+1Md0t8P9PL7tYlzEV8vq5Ki7ezB3TOYIvn1cO7RRf4gNUlncDznjYj1CLhck2iDJsePVo4YJ8BlAm1rrUK9vZh82b5yerbGNWI+jSN8O6kH8iv07CllNsqpXMYpQ+Si6YQ4eFdnQ+izehvl9dxdpQGVO7x2wSSqPkpmdE1dYGIi8sn958Plw2TexCTJcFnDVGzkdXlIIyOEnHbbufS/BZc1tA/M/kfuGLA1CmtUlbIajGMPhZ6cFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cByU1fxmu0ug7D09/TirQFxxdyvxawtqWCRBQqM6VRU=;
 b=IuFNpRSlSTXoWcS0c4jgyTgIhFcyWaZIQO7LEPJmjm3JsRnla+tvfm50pGGRYQIiqcKy9GYYUKQjDxYEBawpU6cBKb+6v4qR9bbsLilPrD+F+QLcuLRL9Z/wDiSE9tz43lf4Zp0b1W3M7CVYPOzkBVvjXryHR68PhP4Ij5w0L+ZeEI+SpqRKIeyVv3+ZIZCECMQbS+pny2GF6t98LXndS0NiNXkIHvRLsud6c2zgOE/A2KhGvET2y2N9EsSgihsAVlwrAD7ZLuu2tyFGFiWViEuYC49YFHyZMBfmRjfbx/ey/FBLkbwScc7ECHqbnkbH3M3HFiJTPuND89qfejnZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7808.namprd11.prod.outlook.com (2603:10b6:8:ee::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 16:24:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 16:24:43 +0000
Message-ID: <0227e8ec-aa65-43e6-af07-e71f7a1edca2@intel.com>
Date: Tue, 9 Sep 2025 09:24:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Borislav Petkov <bp@alien8.de>
CC: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<akpm@linux-foundation.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>, <kees@kernel.org>,
	<arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <pawan.kumar.gupta@linux.intel.com>,
	<perry.yuan@amd.com>, <manali.shukla@amd.com>, <sohil.mehta@intel.com>,
	<xin@zytor.com>, <Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>,
	<tiala@microsoft.com>, <mario.limonciello@amd.com>,
	<dapeng1.mi@linux.intel.com>, <michael.roth@amd.com>,
	<chang.seok.bae@intel.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>
 <20250909161930.GBaMBTku_VgKUpTs2V@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250909161930.GBaMBTku_VgKUpTs2V@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0236.namprd04.prod.outlook.com
 (2603:10b6:303:87::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8a3555-c436-4747-bff1-08ddefbd625f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDAzZFFRUUdwMWVOaHg2VXJBTDQ0ZE96Um0xMEkwOWZFQTJFMUdQcEtNWEtr?=
 =?utf-8?B?NUJORUxVcmZBVUhqZ2haZ0wzYkpyTUYxQmFXNVM2QU5MZGJRZVNQeGRJcGxE?=
 =?utf-8?B?dlQ0QmJNSEROL1d5Q2wwYWxJaGE4Y3pnMjRXVlcxT2pzdWVwNW5heWxaZVBt?=
 =?utf-8?B?blhIVjFTWGJGc2wxeVB3WW1Ha01yMDNRa3dhazNKaHh2L2NRSStiK1hpM1Nr?=
 =?utf-8?B?OTI1SEphRW9lVVQzYnl6d2IwSjRnSEJGYkV3b3Z0ZVRJQ0t3QjNBL200YVRv?=
 =?utf-8?B?anlZazBjcUkxUnJCVXQxdUw3ZndvYTNhV1ovMTg0VkRMVVJEL2plNTBvNFdt?=
 =?utf-8?B?cTVBK3A0Mk5MOXVwMFg2MXoxbktVVENzTjduM1lIVlN4UTBiUmVlUlljcUNE?=
 =?utf-8?B?bFBXK1pRZ3hvSk9TeFoxU0dGcHRlbkEzQUVHL2dkb1FFd042MitDMnErQUNG?=
 =?utf-8?B?bHg2TXhQMndCM0VxR0dzTGp3Q3ZCWGRXalVxS3NTWmRtbUJOekw4d0szcWll?=
 =?utf-8?B?SnBnZ3RqUThuRzRVcThoNFZMSDRJcUlsRTRsak9oOVFSeDFCRGppeTFzM3dP?=
 =?utf-8?B?WHNMc1E2U3pwLzdOZ0ZKa3pqMzVqcVNRS1NMbzdMZWRqU2NwSzMyWkxQemVT?=
 =?utf-8?B?a3VYa3JCWWF2N2JTS3BOYVdybGZSK3pUU3JTN3BDVG5ob3VmWHh3YThzTWJj?=
 =?utf-8?B?RTVOUTlUaUgrT0kzaXNpdjJNd1dQVElqbkZhSVF4c2hEbCt2MnA5aWRMdXl6?=
 =?utf-8?B?WVpSMkF4N2c2OVBwN0JKOVBoQzEwUWZ5ZCtLNVdhaVFDTjhIUG5WUUJjUHN3?=
 =?utf-8?B?MW5WL1JZdS9hWVk2eFdTamx2Zm1UOTdzd2hqd29HZlFLUHYwS0RxaFNlQk1y?=
 =?utf-8?B?TlAwU1A2clBrMkVHQXQvblUyMFMydjRUL1VSWHJTRDhXVFVIQ3RkanozREhN?=
 =?utf-8?B?TlNHUUwydWFSR2JHUy92MGtXVjJ1SnE0S1pHZ1hUT2hOS0RBVmhtYVFHTkZx?=
 =?utf-8?B?UkVqZnl6R2JKUkc0d1ZSM2E3NmxwQWhUSWtWZGEyTUF0M0UrWXRIT1Nlam1K?=
 =?utf-8?B?OWpaWkxZdUlLZXJIaXpNcFI4ck5ydkpGLzBmc3ZtdFFuemJwUVNhU3J6ZkFV?=
 =?utf-8?B?N2x2TlVVS1JhYWRTM2prRW1GckplalNsb040dzIzVE12eVgyS1h6MTlhUHJX?=
 =?utf-8?B?QTduUHNDL3BCc3dHTlZtMHNZRFozd2FtZ3FJV0hEdXpackNMbU5TenY2RC93?=
 =?utf-8?B?ckM0bmQvVmpiWm9VUzhuR0Y5TVY5d2tLYlkrbldET2xydkF6ZkhWY0pnUU5M?=
 =?utf-8?B?bGpkVTk2RUZNYzRkWXFYUHpPQjk1cWtDd252MU1JQ3NnWTV4MG12ZTRNTjZG?=
 =?utf-8?B?L1VRMVhXZi9HeG1GZ0xBOGkySnBidzdUemZQdU1yRHpRak5NVUdCN1FvN21V?=
 =?utf-8?B?RTNQWHdRLzh3VFBxclAyMU9sMFozTTJTV3NvZzlySzZCd3ZlT29TT2VseS9M?=
 =?utf-8?B?cGxqdllocGFoYTUxN05XVjJSY3pPQ0ZHVGNqbXRYSGlJQ0tpOVB6bG56WlE1?=
 =?utf-8?B?dnAzRzJ4dGFYNXBlNUtDUGFxVzNiM0VhZ0g1RTJORWNJRm9EdzhmcU42MWJZ?=
 =?utf-8?B?T1hyVTFMdE1PNEEyNWJKR1dXcVpEdm54enlBKzEvWEQ3MWNnYVQ0QmpNc2Rl?=
 =?utf-8?B?QWJxelhUWTg3RGJtMjhpb2RKR1RJaGdxdDVaSHJvZnljcEpXbG5mMFVIbkxs?=
 =?utf-8?B?RDJUQTEzWkJuWkJuT1FBS21pSW9odnkwYS9RZzd6RjlyeXZUYUJXSTBJWGVy?=
 =?utf-8?B?dVJ0RVpKeFVsNlBTNFM2b0drMXUvMjNDdkN0VDljZXBXejhPTVA4QWpyRlFX?=
 =?utf-8?B?d1lVWCtTTlFmV1VuaEIyM2F2NXU0NmpoZ0N3ejRFQjFZS3ZNcFdWL0g1Mjdi?=
 =?utf-8?Q?DrhP5B7JSmI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1o4azgxVSszV0RMZzA5MFplcUJTQlJnT1ZyY1RXMnpzL05lNlBOak45WWVD?=
 =?utf-8?B?aVNlWnliT0ZGd3IwVW1OTUdhTnpxeE1ES0I1MVB4VlV0dFVlWDc2Z2tEMUhr?=
 =?utf-8?B?RjJyMy8vNGRjWklGbWU1ZEpNQUtRM3BudWZjeXV6bmNORlVteTJUWHg2S1RL?=
 =?utf-8?B?ZGtZMEE2aTE3QmpnaU1ndEdzMjRqMjlsRHY2U1Q0NnRSSkJqSjBBaHowc1ow?=
 =?utf-8?B?cGt1aWtOYURGZUNNV0ZwOGF3OVRvRlZyajBEQnFXVUxPcnBOKzVwbTI0MGgw?=
 =?utf-8?B?NVgrb1VIYUs5cEtjL2FSRldkNy9DdUl2THFya3FtKzlOSnAwM3MzT09SZUM5?=
 =?utf-8?B?Y3dEMm94bHpxNGlhWkNicE16THBCLzhYK0xiTU5scDZGQ3RDZkxmajVCcStP?=
 =?utf-8?B?WlVnUHdRaDc5T1ZMa0FSM0hWaDkxNU1tL1ZEYmxETVJTTU5ORUNNcVhua2Iz?=
 =?utf-8?B?WThJektuWFAyanloQVJoOVU3djZoS2dNRjFQUXNFdWVJL0lOdzF5ZW5nanBG?=
 =?utf-8?B?M1orTXdlU2xoU3lTakxOcU1pN29vaUYzUFZZOXZwY01Lc1hHNkRZQUpTTHM1?=
 =?utf-8?B?cm1zWmloV2drOVVDR0lFeFpRUDdJUWViYkpBMlRrb0RXRVptbEtYZGdXbmU2?=
 =?utf-8?B?L3ZjT3V3ZDlINzRqUXJ5eFJZbUlyUERyN2J5RTMxL0VhdkVhRVBrckdObEpW?=
 =?utf-8?B?MHdoUWR3TVpZdHZlSjMvaGpzQTRjVy80Y1hnUEg4NDVIcEtDcFNtRnhhT1c3?=
 =?utf-8?B?NW8wUHd2bTBrNUtXTTRjL3hUbnBCc1dSLy92VTVXWHV6cnhGMUJraGdiOGo3?=
 =?utf-8?B?WHdDbzhmdGlIR1h0clc1a0VWWm1UTmx5V1VwUHdFcGZjYVZNbEZRTzhibXNS?=
 =?utf-8?B?ZjhuRjJmTnlNbnF2ai9mdmJ4ODB5emIwQXRieXJBRmhoazVSUm14Z24vRXdi?=
 =?utf-8?B?cEJIQ29RYzR4aHk4SlFBV1RKZEp5TjZPTHRmaG0wTDRTc0pWWkpjLzJMYUQx?=
 =?utf-8?B?TUZpaHdkOGxHVmltRkFrM1kvWW11MWE5bFJYNjYzdEJ0dHpGRVR3RWNYK1NP?=
 =?utf-8?B?dmJ4bTZDajV0QXp4RGtHaFNKSGd4VGFseStKWEZacGFaSkh0cUtpdUUvNWds?=
 =?utf-8?B?QU9hVkhVengyREpJWHZUaHlFWmtrZ3FjWFJVUWJtWThQOXZ0aWJQcVJJcXJi?=
 =?utf-8?B?S0wyQit0blBKTUsxU0hQMmNLSkVVSzQzNU0xOFYzQVQ0bFdYVkZuWUk1S3VO?=
 =?utf-8?B?VXE4WENPRXpXdUtoaThsUWtqWmpma0lGeHlGY2JzaEZzNjQ3UUhmVFBRR2hF?=
 =?utf-8?B?NFV6d0FqTm9Ndk82SUM3S0JkaFhOcW50bG8wM2dhYjFrdllaTnRXN2VURXVO?=
 =?utf-8?B?M2NsQUVKVkxWeGpDZVFXdmsva3R0ckU3cjRtaSs0SlpXazRZY2p6QmY5R0xS?=
 =?utf-8?B?aWIrTkx3UWNHK1BrSU9mUGRQcUpTbmxpYm5MNlNMWmJUSmxxT0xrYmhxRm9Y?=
 =?utf-8?B?ak9YeW5HOSsweU55YlJhWWNtYkpUOWFWUEVHa2hsdERHWHBZWmJsRXpqM1Rn?=
 =?utf-8?B?eHNtZTRaSjVaRDhZS05oUktTUXRSbENhcUtTcjRzempTVzNjQWZhamFsNnlz?=
 =?utf-8?B?SDlETGVBeGViaFcraEIrYWY0Vlh3UC9rNDZTeEZSdDA0bm9vL2xGanlxaFcx?=
 =?utf-8?B?L0R3cXhQSEJrUkN3U0hPSlYwdzJEeU1Kc0RqaGNCTGZGbXgvS256RGlNV3ZK?=
 =?utf-8?B?QXpYWkFIaUpXTFAyNlZVNFRndmRwZ015azN3YXFhVm9OSE9zNUEvU0UvdFor?=
 =?utf-8?B?Ti9iYml5V25hQzY2U1RHMXRDcnZMZlRCbDdxTThCaDlTRFd6SW9zWklCbUsw?=
 =?utf-8?B?UlhDd0ROOWdCSTZtdDdGWFc1VVUxbnhma0YzOGdLYmRyNUlBZW9DbmhMUmZQ?=
 =?utf-8?B?QnlFOUhCcDJoeVF5ZnY4d3VJSncxbTFUQ0ppanhSMDNjcUxoMTA4NFgvZUxo?=
 =?utf-8?B?QzVxbHVDcTZLTlNIcGhBRURVRzJJTHNMMFJjVHN3VU1zaHVyYkFjSy9RSDhk?=
 =?utf-8?B?OFN2U0RwcWZEcVNZK2dkQUQvQ1BHSlZ6dTZXT1ZMclViUFRZS1U5bU5TN1dM?=
 =?utf-8?B?b1I3d1ozZ0FSM1F0a0NxRmJPZWJ4NUw2KzRXVkwvUWltN0lHMlg1ZEp2RWJ5?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8a3555-c436-4747-bff1-08ddefbd625f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 16:24:43.6434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Itwl9mhTiDj0AJYbiSVE8eWG3zjR0g7EZ/9npUszAGicPLFYeVA4r4p+b1OWnO6SLZvvMT3TAu4tIE/X5mpGO5l8uANbY5bWzYqnahia1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7808
X-OriginatorOrg: intel.com



On 9/9/25 9:19 AM, Borislav Petkov wrote:
> On Tue, Sep 09, 2025 at 09:03:13AM -0700, Reinette Chatre wrote:
>> When I checked tip/master did not include x86/urgent yet but when it does (and
>> tip/master thus includes x86/cache and x86/urgent), could you please
>> merge your series on top of tip/master to ensure all conflicts can be resolved
>> cleanly and ready to provide conflict resolutions to Boris if needed?
> 
> Thanks, just give it a test but no rebasing anymore - I'm going through the
> set. If there are conflicts, we do enough patch tetris in tip to catch them
> and handle them upfront - you guys don't have to worry about it.

Thank you very much Boris.

Reinette

