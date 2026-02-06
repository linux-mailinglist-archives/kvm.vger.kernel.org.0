Return-Path: <kvm+bounces-70384-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGP3IZMxhWlV9wMAu9opvQ
	(envelope-from <kvm+bounces-70384-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:10:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72594F881D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8547C300616E
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 00:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917235B1EB;
	Fri,  6 Feb 2026 00:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bW1FR6DU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F4288D2;
	Fri,  6 Feb 2026 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770336651; cv=fail; b=FINsb9Hsryo2O+bMSHkty0DGAhllvftQFxgWRRjNKMbud7Iz72kNedhfZC2/D/FLrAVPB8LyEwQ+zUnpQrCJKntXSLo2bjDZrZractV5f5piuE3KS+wo3IL3x0e2nVVTf4xV8uypnH9W08C2U4ftkcS4qNTWSr60SyTlncimfEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770336651; c=relaxed/simple;
	bh=9OyJI9CkTcLM9pD7IGEUobn9FORc2Hu9hDL9can3T7M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=icVwOUhBSlIry8l2xIZEW29bYuU+yUmuwGWBzBiMtcRpElPmVMpynUgLdhFe+JvytQ0NLjR5IOXB3Mf/pYhXc0oqCE9ZqKp+8EfSmN/Y26+pby6azR8xC61OYYwdoZMpBSR3oOwNL8kVHsVUjYZhmyQTM05pcVx9+rD1Chrnlpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bW1FR6DU; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770336651; x=1801872651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9OyJI9CkTcLM9pD7IGEUobn9FORc2Hu9hDL9can3T7M=;
  b=bW1FR6DULzteLvmT4qKLQZTL+gtLRWLpnJkhwCSUh7E+blfawhms5Q68
   nPG3CV3iIpylEZQoTt7ggS7lK1gmBmMUPODkzpGRONWIqcehJZ0SmU7DH
   1+x7BNeEjXRW1bQ7nF0txJUKFKeMD4ZDK7DvqKBl4lz+xVQX53EoUf9tF
   +mkiqIacHaMPcwhHk6U4v8SU8xiAH6Xpsj3WISdhh/7InF0UULRjOuaer
   zq7lEgHkIrqPm1lubGzFtYCH1Afb1JYk38pWqICFeG5sNOmPUEGjGzBpI
   Tv32sSCnjaZi9Fu0xtaiZrrTsw1tBffrYTl9cZ/Vg2fx5kEenf4V9BPYP
   A==;
X-CSE-ConnectionGUID: kGEsacFGQgGHwrINTQeM3Q==
X-CSE-MsgGUID: oz6PhMMwRl6BGSGU9XWyLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="94194657"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="94194657"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 16:10:51 -0800
X-CSE-ConnectionGUID: e34fgxH5S6Oyf8OhpAwzdA==
X-CSE-MsgGUID: TJjsorqrTOqLM7UGhMRcOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210024747"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 16:10:51 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 16:10:50 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 16:10:50 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 16:10:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifX9ItfCr6EgDhWnX6lpgkZn/G43Gva/86q/mqqm93Uv8RM+4OemfPnNd+1vDpX9iHeaDM6J+tYXWu+NbquFaCbSC1Lh6NpdQOd2a4+gqWnAOnXiBFDY9/xqgoBNY47NSlDpqytbZuPYtPCFhJmbEm8fDgx92vEsYGbEX/g9GrA4Wj8cTfTS/QweNyAsMvn5Cy5ziYKXUe/aVkz65GpnWsQHPKzUn9SSKHoo00opcOj94mIjS90NRXw2TywsqjOUegXXWvAiU/MhLpOdgNB4x52KWg+RV8+kxmridE3TkEiCF8SrPL5xvuWdZuUN8Ybf+OJ0CcFCqa2D7ywjJ0WnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7THXvKUHsGwmo5ufcvadI3GFDY6RoDMKHVj46gt+3OQ=;
 b=LfPLcPnjVaEl12fYPSp1G4dquK4IFsKABzPYUxs0tIb+ZrsWYWZLyKX3LPUtBZkQ8Va4TsGHQB1TvoCXh5cQxgUb4n3nFJUpKFWMxD71BsB2G15RYSZqt5LgOWEwOvg1Ho6lavXSIkBEsFMv5AFf9cgY2shObF7mNcM4VRFP/vtFN6VDTr26hlK7/3Bw15lCepV5YqaH1OlJDxJMrBN9OPcIYTRKy666RwtOudIJ71QZVMhnmb29wcg82UOZUZx2gAW1qlyoMkBh9R5B3NMHOy59QZfmwsdKN3v4NaeQhAOM/NuPpUd3lDc+7hHdLyYymc6sUNQmj2DKJPupweIYqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Fri, 6 Feb
 2026 00:10:40 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 00:10:40 +0000
Message-ID: <ab7f5935-fd5e-4ba5-a97d-5433f241a089@intel.com>
Date: Thu, 5 Feb 2026 16:10:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] x86/virt: rename x2apic_available to
 x2apic_without_ir_available
Content-Language: en-US
To: Shashank Balaji <shashank.mahadasyam@sony.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, Long Li <longli@microsoft.com>, Ajay Kaher
	<ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <jailhouse-dev@googlegroups.com>,
	<kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>, Rahul Bukte
	<rahul.bukte@sony.com>, Daniel Palmer <daniel.palmer@sony.com>, Tim Bird
	<tim.bird@sony.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-3-71c8f488a88b@sony.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20260202-x2apic-fix-v1-3-71c8f488a88b@sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::10) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|SN7PR11MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e92a19-1470-4faf-bc33-08de65142955
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VlhFNnVXQjM3Tyt4Z29JT0RuV2t4MkxVL3JxL0FETkpzUjdReThHamNOR2lq?=
 =?utf-8?B?ZlBlcjdhNTRMTGJLQmJUOE9SdXdCbGNubWFsc05VcEw4SERlSFExRndBOFZx?=
 =?utf-8?B?MG5mYVVwRTAvQTZFMVFYRi9LNDNHa3ZVUjlDVzF5RTd4RXA4WHpjZFZXdkw2?=
 =?utf-8?B?ckRwemFmM2tuWk1zYU1OUzJkM0dONHN6ZDNFQmM3S3ZvZXpXb3VyOVB2N2Nm?=
 =?utf-8?B?OGJjQURxQjFvNHBvRS9sWk5pb3JDQTc1eVBKTVltZzdzWDBrZENPTDIreVpI?=
 =?utf-8?B?TGJQS0ErU1ZyL2k1WkRTdzNKMXErYmh0SCtYNG5FYW1rRXMzOWM3UUtVWjFY?=
 =?utf-8?B?bG11QWo1VFh5UlBwSUg0Y2xEUHJrNmZ0NVZMZnVBNnpsVGQ3RWR0OXovWG56?=
 =?utf-8?B?MnI3YitNVnB0TTdPaTVNdlJ0MkppOVI4VmxLOWpxZTNEbWNUZGFOVzJJRE1p?=
 =?utf-8?B?cFB4d3dDWE82RXdJd3lYNitGMy9rN21zSTV6a0l2QjBKMDJ2eXFZK3RjVE1t?=
 =?utf-8?B?M01XeklreUFzQU1Eb3pGdFFVbklLOGNXR0J3UGpzbnhDRFVNOEc2QnFVR3lx?=
 =?utf-8?B?YUpMa095alNhdUJvWS9FbE1mRnRWb0hRNXpsenZmUjFvNjlaUWRrRGs3d0cz?=
 =?utf-8?B?KzkzYUNjTnRISkpTTG5UWFE4Z0dLZEdoTy91bDcrTHZqTFBMY3k0cnR0Z2Vm?=
 =?utf-8?B?aWdOZERnb3I4Yi9sSk9KN3VpNTE5emNndzJDek1CbE5DSUFyanNzNE14Um5W?=
 =?utf-8?B?dVc3NTdHM29xK1NiTE84K1AvcDZrb0FsVmZneStnMms2T3JXWGdyUE4zblZa?=
 =?utf-8?B?SG5RK2xzYjdDb3hyWWFZaFkzbyt3Tks2aGhmVzNZUjVoTW5DVjFRT3hycUNa?=
 =?utf-8?B?YnpCTTFQVm1jYTRKVEdTUGt6UzFEeWJmTVA3cm9NTTVIOE1ObU42cElxZ1hY?=
 =?utf-8?B?UHVWZUNJdHpUYk5GbE9vMTZnM1hseTFwZHdINE9qeHVvY2VMeUVZaVB1Zk9Q?=
 =?utf-8?B?VlV4MTEwNzViQmprRmNGOVorbkxKdkN3MGdsbWd4TlJ0UnBTcnBjdkdGaUxK?=
 =?utf-8?B?WGpYaGpBVWhzZHpKTGhNZ1BCUU5vejh0K3VOT2NKRjZEbU10TnlFaUZDaGh3?=
 =?utf-8?B?eGVaUTNTV1BVQ1l5WFFZVTJjY2JveWJKQmM1NHRLSEdPY1NUeUp3UWxaWmxH?=
 =?utf-8?B?eWVSQTE4U0tnWi9JZVoyVHdRWHBoRnppcmZZbGMrU0tFUmt5VUp3cHZHYjU2?=
 =?utf-8?B?RlRucW9sL3o0ZFBIVDJjRFIvU1hjVjRDN0lEVDBMNW1sVC9ST2tkUDMvVkVU?=
 =?utf-8?B?Y29RenA1cDhOSkVkRHN2UUpMZ0ZYTUhxckRNcWYzc21JaGhzSk1oTE9hMGFG?=
 =?utf-8?B?eUx2R0NqUzJXek1aWFVNdm55R0poQXB5RlhONDdSdUlOQW13NzAxRW4wakh6?=
 =?utf-8?B?V1NubEtyQWNCV1FsV0lxUzJyS0pxa2YxTGtwaDVxRElSN0oyWmlNdHBuTmNP?=
 =?utf-8?B?K2VvWTRyZjdVWWhWaytzUG9yUXZyMTdXbXNOVUtGTG9DbE9GV3E4bWdQSHlh?=
 =?utf-8?B?Uis0UUxSNG1iSzB2SFhrODJ6Um85Vmt4YktVQVF0U0dGRTRjR09mb21qRkg4?=
 =?utf-8?B?STFYZ0dERnBIRy8vQ3UxYXRSUmZ2VzNYWXRaaEgxVnpQbWY5RERjVWdvYVpM?=
 =?utf-8?B?YmdBcUg3YzBnYkF5VSsvUFZlSUlhMWxaeXU4c2dRQnpyK3JNaTVmT0xqU0xW?=
 =?utf-8?B?MEZZR1hIKy9mTzkyOEs2VFRLRVNCWEJKSi8vcndEWHVNdi96V080OU8yOHFu?=
 =?utf-8?B?SDhVak5ycVk3YzlFK01uVmFqS2I2SmprSUtCZjk1WWFBR1Nxdnp5RWtyVmJE?=
 =?utf-8?B?QmRRMmxFd2RKSEFPcTBVbHVaTkgvRGMxOWZPakxIQmlsQlRaVkdONk1jWHRk?=
 =?utf-8?B?azVvMytKa2duWTNJMGVzQ1FSZi9PN1drbG9HNE1JVTFvaEpISkFFKzFXaWt0?=
 =?utf-8?B?NHFCSUt0Q2FBZlZ4NGdnN1JKT0NENXpuVzZ0ME9QdHZrUnJ2UnpXcjh3US93?=
 =?utf-8?B?bGR0ZVRacEJJcWx0RjNZbzRWcU5zR3ZGbC9qcVl3cEZNSDVpcU50U1g1WVBO?=
 =?utf-8?B?RForN0JyRGd1Smltd2dWK21KN1NySUZLV0s3NFAyMTFuS0JlL0duM1dUSlJa?=
 =?utf-8?B?Nnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUVZTC9mbFR6TTh3NXRBckxRU1VGM0N4blo0Rk51dWhUSEx6YUYrRExqd3BD?=
 =?utf-8?B?Zm02RVFSd2tacjJ1c2dVc1pDMHBUNGlpcDhMRjF1ZU1IUFRzUFFxN3V2cUlu?=
 =?utf-8?B?SzMycnlIeDdmL0d2TWdWUC9RdzY0d2dkaFRkWGp6cWpTTDFyR0JwUGVkMEVG?=
 =?utf-8?B?QkJCZ3h6UmNPdlpuMTR5eFQ0M0VVUFZqbXplcytiSWxlcUczYkdjWFdKcUFH?=
 =?utf-8?B?TC9LTFVRa2QxK1cvdmZFR0ZHZ0FlcXR5dWl5NDI2NVRST1VZM1pnMVc1d1BX?=
 =?utf-8?B?dE1XSDAwbWQzSytnQS9kQUFzdnFoWVptN3pjcllPcjA0bmtBbVZxdCtSTFJ6?=
 =?utf-8?B?RkhQSlJSZjZERTZPNGJxTzR4c09sUWl3M1BveVc2N1d6VzhOOFBYSFZzRXpD?=
 =?utf-8?B?M3R3S0huNnpqYnhRODZuN2hxUXhybk9RWG9SVjhTOC9zYUdQU09TY3ZrUXZP?=
 =?utf-8?B?VGNxQnJ6dU1GM2Jld2lsbVRNNVhIUFpqQ0VXZDd1UmtPN00rWktpbm0vZlNI?=
 =?utf-8?B?bW9NQzBGVUV6NW54QkM5TWoraUlqbjJRVFJpSGlhYUtsS1NFTUlucm9hQzN2?=
 =?utf-8?B?RGdKNHVPRzh3UEtVWUdUVHVJWHhoY2luaEU4TkppdlN5UkQxdisvb2dUTXdv?=
 =?utf-8?B?cEFlZ1RONGY2UHhDMlF5S1VuN3RkM3h1K084RlkvWVA0Y0pTcHYzajRTd3RT?=
 =?utf-8?B?RS9sQk5VeTF5MlpoQ0svQVpyMEpRVEV5K1dwaE44Z1IrZi9BdytyTkZ5TTl5?=
 =?utf-8?B?aWNYa1Z2aWgrVnJSYmxoZlhjYjhyQlFSSlRIdTdqYXZielIySmVhYTNTWVBU?=
 =?utf-8?B?WFFtNE40cnRGa09lRUZtUnVBdEhqaDl5bThRaThaTE5tRjFNQy9xVWtqek9L?=
 =?utf-8?B?M1NhWjI2MHBpOHZaY1AwSW9vQUZHekxkVXJRb09TTEplUERqeXk4bUdVL0Jn?=
 =?utf-8?B?eW1xUVRja2ljMTBrRFB5MTR3RnlUcFExNzAvWnJXOXA4NmlHRGl6Q20zYUc1?=
 =?utf-8?B?M0VBdHF5V0Q1c04xaTdjbjNKMzFDYWg1L005QzNsZHVtbWdQQzZzNXlLNE90?=
 =?utf-8?B?T0srMTZhaDloeUNncGJwOWI2elJKbldaUlN0SDZMYmE0b1N2NTE3eElLVU1G?=
 =?utf-8?B?ZFgxcllzRXkrUkIxeFl0UUd6ckZ3cUExbmplandlRklOcjUzeldrZG1EeGhW?=
 =?utf-8?B?QUcvKzhJRk9VSk1lSjMwSmdkRXpGU3VnRGdnbW9lcHVaZzZ6WEhKLzhSTGw3?=
 =?utf-8?B?RlVVTU1wRnlTOS8xaDhhQVlXS1lhUk9zcGdPb1dNcEJNRkJObjBseS95d2pu?=
 =?utf-8?B?elpZMS9YVnFDMnZLOTl2ZkFWeG9UR090bnJ3clZDdTdMU25OR2pjbDJaNjZ5?=
 =?utf-8?B?M1ZrN2JFV2NZNTZyK1dnek1NeGZQU2s5bzk1OFVqaTZHTlRCM1FPMjJsK3Vt?=
 =?utf-8?B?VXV2T1paRW5FZUlielZMajRZY2lmQWpNc1J6NFVtU29tWVZ4aGFxSFloTTJX?=
 =?utf-8?B?UVJRQXdVRTU4bjh1S0RTWTU1R3F2NE9OLytIeWs0OVNMbVFBNk9aTGxKS0Z1?=
 =?utf-8?B?OW5mR3RtY1BtTnNEbFpOM29EWUsvSU94QW1ZQmpRRDBDUVdCNy9kUHYxSWxT?=
 =?utf-8?B?cmw4WmVPNUJDRGpYQTdrZko5TWp5NnltT0lVa05NREIrOVNPYlBnanlSbmw1?=
 =?utf-8?B?bFhkU2VaRURwNjJNMzJKWGViV2J3eUtqSVVyc1pXam9zNEJXUFJ4S3JDbGdP?=
 =?utf-8?B?b3hnZkFqczBUM1FMV2gxcnQzay9aSEtxZUZ5WGdKMVlDaFcvdGZPamdod2Fz?=
 =?utf-8?B?T0k5cUhvNmUwV2lJRGNVMjBUZWNXOWtHQjVFMGc4NG5XSDdxcnNuUm54eC9y?=
 =?utf-8?B?cEQ2SGdWa2Nxbkt2R1hPV3BRd05wbU5Ta0J3RHlGamU5TG0vVkNlUnVSamhr?=
 =?utf-8?B?WW9NdGN5ajRrc2tCbG1McmlXcWVIZVBPNWNjRGs2STJ6ekVSb1JGR0lINS9q?=
 =?utf-8?B?N3FFbFRpU1ZLeU5CbExYRW9jVjF4Z1RpNlVHTENzWVZwVFNjNTNLWjZ0OVRU?=
 =?utf-8?B?UE90a0Evbis2UjM3Q0FLNFhCYTNjSWMzTUNVREtLdUlMRFIzMElabStoU0Mz?=
 =?utf-8?B?MEpRZG1OWFZRZFNvZVZzdW5ZMzNIU3hCa3c2VFM5VFV2NUpFU0U1UUZtZGNF?=
 =?utf-8?B?RjhrOHJtK3VMR0hOTC9sa3piMCs5SjROSmVQS203clJMZWdzdEE4UGtDbjBo?=
 =?utf-8?B?d1pYV3JQcnRpbWVMUWIrYUd2Uys5anhaWXEvOW41ZFd1UkpYNDY1NzhQdUIv?=
 =?utf-8?B?ckZ0d3lwRENrd3pRWXNFZ0dZMkJHZE4rOUFkVXZZcldpYWRvcktWUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e92a19-1470-4faf-bc33-08de65142955
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 00:10:40.3004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUGgmGf9QRU+aFaMQcEv8IxDJvIIxZD26c3bkJWEENJQC1CmvDRSlkYo+zc8vW5u9q7biPDtTUy+BYVISsZqOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70384-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sohil.mehta@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 72594F881D
X-Rspamd-Action: no action

On 2/2/2026 1:51 AM, Shashank Balaji wrote:
> No functional change.
> 
> x86_init.hyper.x2apic_available is used only in try_to_enable_x2apic to check if
> x2apic needs to be disabled if interrupt remapping support isn't present. But
> the name x2apic_available doesn't reflect that usage.
> 

I don't understand the premise of this patch. Shouldn't the variable
name reflect what is stored rather than how it is used?

> This is what x2apic_available is set to for various hypervisors:
> 
> 	acrn		boot_cpu_has(X86_FEATURE_X2APIC)
> 	mshyperv	boot_cpu_has(X86_FEATURE_X2APIC)
> 	xen		boot_cpu_has(X86_FEATURE_X2APIC) or false
> 	vmware		vmware_legacy_x2apic_available
> 	kvm		kvm_cpuid_base() != 0
> 	jailhouse	x2apic_enabled()
> 	bhyve		true
> 	default		false
> 

If both interrupt remapping and x2apic are enabled, what would the name
x2apic_without_ir_available signify?

A value of "true" would mean x2apic is available without IR. But that
would be inaccurate for most hypervisors. A value of "false" could be
interpreted as x2apic is not available, which is also inaccurate.

To me, x2apic_available makes more sense than
x2apic_without_ir_available based on the values being set by the
hypervisors.



> Bare metal and vmware correctly check if x2apic is available without interrupt
> remapping. The rest of them check if x2apic is enabled/supported, and kvm just
> checks if the kernel is running on kvm. The other hypervisors may have to have
> their checks audited.
> 
AFAIU, the value on bare metal is set to false because this is a
hypervisor specific variable. Perhaps I have misunderstood something?



