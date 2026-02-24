Return-Path: <kvm+bounces-71625-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gK4QFiPPnWn4SAQAu9opvQ
	(envelope-from <kvm+bounces-71625-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:17:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CD204189ADA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EC003179316
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1B33A785A;
	Tue, 24 Feb 2026 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUVzz2CL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138AA3A7858;
	Tue, 24 Feb 2026 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949718; cv=fail; b=PqGFT91ovN1gT12PIx2J60Mv5GlT6Yg0OzDZ+zlmdQ17K2jSYZjK6QRFd3YuxuYx5Q5mrrATTQqiWEzRWkxE6DGL8OfMub67l9lLYQPcHzaixTPKQnL7dC716mUc0ZH0qy5x0NkklDkvkCsVhs/eE78v6ouL5F4yns1lwzKtoVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949718; c=relaxed/simple;
	bh=gq2LhhOSYJ9lZtkbBZYKEGq+Bglg19wdUQZ9ho1iSxw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pJNY5Vzyzn+E8Wp3mJg2AfXct0ZZCFCX+icYpGfFJObOm/2N8btmeas2Cnrw2e+kBVzDd5G3MTW+0NlySpB3Syl0CZRR/Fs2JzLDXOkRkY5YyigP8aftJkXAzaMkZqDROMB5gOSEoQI+MAQ5ZFIJIzxv0ZuUcxD/taEGj/8CDfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUVzz2CL; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771949716; x=1803485716;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gq2LhhOSYJ9lZtkbBZYKEGq+Bglg19wdUQZ9ho1iSxw=;
  b=OUVzz2CLAwCCKMvJAznGGYThhrogYJapHpCTehnFUjjXEdmJEwrKHLI9
   zJ6CVMX8LxyI7nlBB2uPc02tCevm2CCZkvxGZcwHTnjt+w2SGlQjEounp
   CNFiDliGKRwvRlmaoQjEsGnv29W58XvjtWsSUPxQLQ3BJ5RTCMaWZHWZG
   NuBlplpjl9WrsR23f5x41HqmlwBijRypwb/Y15ycX6OCv3o+eDoh++4Nm
   9mbx37bNchZiJN+CUu59X7bNg7i4WbehBWGYNGbkLPpR5amjFyQJLAsqf
   7mzDsu4nx19ebbDJlmANCY3E9lSYJKBXhbgqfzruEidOM3mbvzHdY5VxQ
   w==;
X-CSE-ConnectionGUID: k9n+1QY9RkGu7Vy9mzZFrg==
X-CSE-MsgGUID: ID6j5Q2JSi2ckYx/pF0BQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="83681676"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="83681676"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 08:15:15 -0800
X-CSE-ConnectionGUID: EzCVxFXuTfCOn/FvS5CF0w==
X-CSE-MsgGUID: 91O3tx69Rh6+qm1gkojHzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="214295689"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 08:15:14 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 08:15:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 08:15:13 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 08:15:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/qm7dKNz4Ek0gczR75ek08gM35AXISBp1yzqBHoiLauaVC1y4WBETlXFB/aXB2fHly3/0CGS+i7W+Z0jvws1ynuRTfsTq8npkBXkvmPlAKn+JS1ZpeTv4mqXcI9f5h0jhVsMRa5qqoqsXB6coFUitpo7rnu9TI2MULeK14FonFg1V0d9q55prRHtqshphEjdqsV2NZNoJKO7n1TnLCjSJEAnlm5sz0xoiCGLJrC2m3m59dZk83V8gKwUdMziZSqEGLubgGBRsD0LqsPNcqwDw8aIcflqH+wKcrC2ZRuIkUBhwtpJOcoYnz5J8rMF3w2SHmtbPSvx53eFxmMS8O4qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZl+ssNHT1ZJ/gxu46KrE11DyMNvB1lZ0A3nDOLejSQ=;
 b=GLNTAUp4aKmKNvpvBUBHv1y7Ea5mVItDDwBR0Qk+4u0SO2qrCLdoSF40FpWtTaQkv9+qTWKFQNQR/labFQ7u8ZMWO4MpOT2ImWpntKicJBpmzbd+JCS/v8nMhl9vJoL90LU7nAjQlvXFHmI1MWFLmV2NSypgMrR/yAOsHl5gRDIu9USD6xKCt7p4eQuaKmnyr966sxKgz8p83OYrDHR86VP0INvvsIIx4rpIlwTRiaa96iq4PIYOOU9yXUPTVi03vz14LrGMatcsoQ2HshIW066cv0vkZ37lngSLgQhiurisIPdyUpSdilEiftGMyg+ZYxAgu1vCxtnz+CfLRTAObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6660.namprd11.prod.outlook.com (2603:10b6:510:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:15:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:15:08 +0000
Message-ID: <323aba14-dd6b-41d4-be5f-4b6de8dbe946@intel.com>
Date: Tue, 24 Feb 2026 08:13:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>, "Luck, Tony" <tony.luck@intel.com>,
	"Moger, Babu" <Babu.Moger@amd.com>, "eranian@google.com" <eranian@google.com>
CC: "Moger, Babu" <bmoger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
 <730c193e-bf31-47a8-8f46-3a4c19b96f77@arm.com>
 <9ae7909a-dbb1-4d54-a47c-2ffdb4899b64@intel.com>
 <08b3568a-c034-4531-8263-e27015306dca@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <08b3568a-c034-4531-8263-e27015306dca@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:303:8c::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fef6926-09c0-454a-daef-08de73bfe02c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18082099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dFBDNnM3Q2JXU1QvOEZiN1ZwWUlIRUpVNklLYlNyRDNqamQ0ZzZSTDB6eVVq?=
 =?utf-8?B?aDJRY3crMlhjN0drdzNmS1pFUU5uNHVvY3BubkpHV1dkOTBCOURYN1ZVeWJM?=
 =?utf-8?B?TkRjaEVnRjM3WmkzUks0d25NM29SaTFDWnQwRStBWmJZclA4dGcvV3pXdFRN?=
 =?utf-8?B?VGtleC9QUFlBQzk5ZElET2FVZDhOZUpUTkNVK0tCQ3JEbDQ3cDQ1SDNOK2M3?=
 =?utf-8?B?T3lCNUtlY3NEREl1RjlOeHJva1NNN0tWVWx5NU0yWHArSWppOVhTWmduV0hp?=
 =?utf-8?B?TGhsQ0FkWmxja1BxdFdDWG91QVMyTnFISlMvK3JlUVhCYncyYklJeWI1Qkhv?=
 =?utf-8?B?REJCRTRHY3ovNGwxM0pyc05JYkg2cENieHJZT0R2L1lVb0lQN3ZVTUlrc2s2?=
 =?utf-8?B?bkZQdFJHNzZaamRpaUlWbE15RE9XNU5QTTFuSlV3NHBqZXZiUUZ6NVJtWk9K?=
 =?utf-8?B?TmhweFJiZS9vdWR4eWhuMmJVWXpTYnlicVhtL254NWV6TzlFUnNTQ0F5YUln?=
 =?utf-8?B?TkpaemNqTDlTcWo4ekVJdmZId1RoV1Fpc09qTWQ0ajlJMGUxNUtROEJZUk9R?=
 =?utf-8?B?WDIrTmMzTGRjd25WZkJQbitGRC9MSTNxVFEyMWpXaEJoRUFGNWU1YWhJVHlx?=
 =?utf-8?B?TTFNWk8zNWFER05FclBWUEZ2Yzl3czVxVkZiMXlZZEhFNWR4ZkVOMWVWQTQw?=
 =?utf-8?B?Z0FPRjFvT211YTVybDZibVJqbXhLQU5LVWVwSVBNMmpRWlIzMmN4cmY0QXpI?=
 =?utf-8?B?WjE0eEtuMk8xSHpHUCsvMnRkZGJZWnM4alovTzVlYlFPOEt0bVRMMXU2Y09j?=
 =?utf-8?B?ajAzaDJZR1ZDT3RvWi9WeElFRVc0cDVUdVVsSWNQT3RFNFA5K3ZxSEdaeXdK?=
 =?utf-8?B?dVlnOE11a29GWFpoZ0hFSHZkaVowRHIxK1R2VVJ4TVNQZy93Sk42RlkyRmoy?=
 =?utf-8?B?YkxPc1loRUhSQzJpTURmb0x1NlAzOE15ZGliUVJ3WERVNkVXM2V3VVBwbEZL?=
 =?utf-8?B?ek5kU3Nwc09IdGx2ZGtIemx4aU9Vd2k4RCtMb3RKaGdwTExIWmttdkhxbmZL?=
 =?utf-8?B?dFhyVjR6aEorLy82emJNZGtWQnRPTlM5T3o4L0FGWVU0dHBVdEpEMkx3TzNa?=
 =?utf-8?B?Z3lHQzdLT1RTSEM4UitDamdXNXV2MzJYOWNHTWtyUHE5djZRRFdURlBsMDNW?=
 =?utf-8?B?UDVud25WQ0pYNXhDQ0haZHoyNVMyZVo5OXkwcUVHMVZpT3JjZXYyL09JT2dr?=
 =?utf-8?B?UjIrNzd4Z1lNd1cyL2F3M2tnMFpXWjFodWFBU3RwUnVGUGlDL2VjYjZhaHdq?=
 =?utf-8?B?WVFxdmdxVnQrN0Q3UU9IL3U1WGdZZnBpWDRrY3p2S2FhcmtKVUw2V3JlaW5G?=
 =?utf-8?B?YVBHZkpSTlVDZEZ6NDJ0b3VXSGxkMEVabFFOb0RxdDY2SjN5UGpBczI1QS9p?=
 =?utf-8?B?d3ZiRVNaZTlLVVg2b3V1U2VhUGVLOXg5cnZ3UG1xUUExbE0rRzdkNmlLTzMv?=
 =?utf-8?B?SCtNVzRIZGlOVitLUmIyTW5QOURiK2lMNUdTT1prL3cwblhYejYvWjE3NXlZ?=
 =?utf-8?B?ZWZWZnVTbkp4aXQ1ekNDRFJlaVArR2V6cXNqQk95U1pvd1JZbW80RzhaVjA4?=
 =?utf-8?B?TGs0cTExL1BJcG1rRERuSXkyNUcxdjY5SUxZTmlQK0tDYU9CQml2eWxXbFVT?=
 =?utf-8?B?ZDl2TjZwZFpBWkJ4QnZ3cWJmSHhiampRWlFiZUs4YnlPNG5TcnpneEhwd1Y5?=
 =?utf-8?B?SjJ0TGl6Rnl1ZmlsTDBpdDEzdzZ2WmlYaHNDVDVGeUZ2L2Q4YVZRNzI3bFBL?=
 =?utf-8?B?UWJkYUkwSFlZQXJ0MFB3bW93a29ENzNaSW82bC93S3JrVjVEKzVsVExMZGll?=
 =?utf-8?B?R0hmVFlyc2w1NXZuT0Q3ZUtVaGlWczZCOUU3bklqL0FqY0pJNzRjMXFIUTZT?=
 =?utf-8?B?R2xjQlhYMnZ1ZmZ3NjZhb3hGN1c3U1c0dFdpS29VZnNFbHlkcldRZkNUUlor?=
 =?utf-8?B?Smx4aXZDa1h6MDk1b2V5VTRRNUlkSnFIZkVJVHRNNVVIdCtkMDMrOG15bGpV?=
 =?utf-8?B?QkovYUY4eW1kdzRWSGRXWUxsYkFsc3h5VG9PQUFEcHUrcmp4VFQrazMzWllW?=
 =?utf-8?Q?hOC51tm+baIVJMqVan3NYnZLH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THdheUFURGkya1JaYlVPTzZ0eE12QkVTN3NpdzY1d1g0NWV1cGVBRUZyZGFQ?=
 =?utf-8?B?Njc4a1YreDVrditXakVQUk05NGJ0c3RGQk1jODNlcVBiSGtGbmF6R251MHY4?=
 =?utf-8?B?RkQ2c3U4RVJML2xELytheWRBeERpTkxmU1d3L3dwR29DRWI5cDB2VlMwT3VS?=
 =?utf-8?B?Vk9xOTFaV2NUZjhiKzRQcjZ4R0ozKzBJSnJjQXpjb08rOTA3MGU1cncxR2ZL?=
 =?utf-8?B?OUgvaW83Y3BLakN5VGh3K2QwWTcwWVlieGRMbWl6cEpmOU1GU1ZhT0xIVzdy?=
 =?utf-8?B?dlNrWGRCSzdMdVZYbTErMFFHSnorSUg1L0xMK3AwSGtNaVR5MEhyT2FLUnRW?=
 =?utf-8?B?eWY4dWxOS1JoVGZmZXdqWFQzZld0ZnpaelZodjQyQ3U2WjVQSTVLMkNlQ2Rr?=
 =?utf-8?B?aEsyRW8wNC9nVDRwUUk4cFNIamNIY3J4TFpmeE1HcWlEZjBPVUF3dUlPMzUr?=
 =?utf-8?B?TXlzVFBJRnIvRjJmLzlSbmJPR1Nab3AyN1pFT1hiWmU5SXJZNS9BSmZBczdh?=
 =?utf-8?B?Z3NZTk5JaUR1NmlvMGR5Wjh6WDZidlNQa1RERDBXWlBmRjRyVHYvTzZaRTZI?=
 =?utf-8?B?aGp0NXVHYzhYUVd4SGhsak9JSjBtZVBEUjJFUUxOSFBDT0hyWk1FQ0Frd2Zk?=
 =?utf-8?B?TXMxZFdZdmpNbDRsTXBBeFJ4MFJJMS9keXRlNXZiZndvZWUrdlR1SW9YQWFw?=
 =?utf-8?B?NUt1aFFVQWdLS0N0bGd2RXhhc1N4ZjROVStTTXJHN2tLYnhOVDlxaG0zN2cw?=
 =?utf-8?B?M3dCaGR5ZXErMzlqMW5sVXVJMGY0ZW5ad29ybGtCNHZhOUFJK29Edm1hN3NG?=
 =?utf-8?B?MWFhcmhtd1pXc21yN1BEMXdySnRpUCtXbnhOSVk4dXl3a1grN0xtRG1sTXZX?=
 =?utf-8?B?WnBPb3kvL0FJc0RnMTZEelJ4YUg4VjNKUEM2eFlNRXpOZ3hoR2Q4cTJPN0Mx?=
 =?utf-8?B?Mms5bjFDM2kzM0o0V2dsUytORW1uS1BvZlhSSld5M0o1RmdKd2hqQ0ErMzFX?=
 =?utf-8?B?WE44T3RmUDU5Vll4enIrMXhxTy9GRndQRmJFU01uZGZNTnBHY2xuU2R2ZExo?=
 =?utf-8?B?ek9WaXZNK0VwWnhPZzd2VUJwSk5sTWRORnNGMzk1ZWhPakFaREtuWkdtRjlL?=
 =?utf-8?B?cjFjQzRlM0NGQVcxYUt0WnVEOFNVYVozV0p3NlNQSyt6d0lxbnMyL09ONzhT?=
 =?utf-8?B?TE1uQmttK3F4VktpckZWQTNBWlMyYUVHU1J6UDFPMVprTU9raVY0SXRlcjZQ?=
 =?utf-8?B?cXlPRjRpNklSakhOOGhBMDV6Q252NklOTVp4ZXFESStOajhBQmR2YzB2ZGxD?=
 =?utf-8?B?N0htRlU0amJCeXhJdjY5ZzRSRUI4MG5OYWdoN3NGd1RKYVpPcmhBcW9PNXpU?=
 =?utf-8?B?ZnpaNzdYTTdPYWorblFpNVU1WjlrOTBoSnNCOGtaZFBVb0RUYlFWcUViUkdt?=
 =?utf-8?B?TUlUNHppTGZZRXdPRndud1VDZUIwdVJXOTVValo1V0JxS2dvUEtyOHpiQ25V?=
 =?utf-8?B?dGpLT0lTbWxCRysyaG94ayt2MHo4ZW9ZZTFWdlZMNXd5dUtoaUFJODlsWWky?=
 =?utf-8?B?cDZlR2cvTTVsZUZUaGlnWnBuVkJCNVpsbEhUakxXL1RrcmZabUMwY2YxdlVZ?=
 =?utf-8?B?T1lPTzNwcDRyeWZsRTA1S2dKUlpNUUR2TkpGSlVadFFrcFkyZVVQRmRRWS9z?=
 =?utf-8?B?MnR5MzJmOHg0clpBaDRyMlJFYUt6TWZrLzU3bmFxVGNzakZaSWg2TVNMbFpr?=
 =?utf-8?B?a2FXKzFDd3Q0TmlESXdPUUI4K05DbEZodWFuKzQ5SkEvRklWU3djSnpBeTVO?=
 =?utf-8?B?RUdRcituVTNaaytXN3JtUUw1VjhNS25YS0ZwSStzMnI4OFA4WThXcXJWemZp?=
 =?utf-8?B?ZlVZWlZTdEVpTEtUWDVlMUVRdUpKa3o2bWMxVjdXTVBoME1oNi90WEhyL2VJ?=
 =?utf-8?B?OHAvenZEMEkveDFNL3hmd0UxcHhLeUdFbnJmOFVQUlJGYUZOYWpnTEMrNkQ1?=
 =?utf-8?B?MlZyam1JTzc3Z2lOR2tLOU83VE8zb0FMczY2a2o0eGpFSGRpOVhUa1AyTm02?=
 =?utf-8?B?NTJoRWFyMHErSFJDalNCSlF4aysrTjFvL1I2cWw2WmVyKzAzMHFVUElLSGhG?=
 =?utf-8?B?Yk8zcmcwdnkxU2FMTHlwVkJtNzd6NW5sMEtLT1dUWTRVVllYNFg5TG5Ldkdx?=
 =?utf-8?B?NGJubkEwZlNhU29YUkNaNk1VOUxBY3AvUTYzNVZxeFFhaUZNQXg1M1BIZ1Vv?=
 =?utf-8?B?VklObFY4NGlrRE1nb25MblN2ZnpBUE85ZWJqWlRuUG1sUHJoSkRWbnY4cksv?=
 =?utf-8?B?TkxPVlNhQ0VTQTV3TFR4dTVWeGVveDY0V2JjNnlpSVAwS0R4NE1IanY4cFpT?=
 =?utf-8?Q?SIqKkW6q6OqYvC2Y=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fef6926-09c0-454a-daef-08de73bfe02c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:15:08.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QywA/yJgONK5OUHSD1OIZlgyg/blPLVAN0PzeeTkRSeRotLhAponhblvWpdd9C4Ukuq9UiKDH6dWGzw1dNiGbonGMHkMVyZ57C9ZEZFwXrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6660
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71625-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CD204189ADA
X-Rspamd-Action: no action

Hi Ben,

On 2/24/26 1:36 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 2/23/26 16:38, Reinette Chatre wrote:
>> Hi Ben,
>>
>> On 2/23/26 2:08 AM, Ben Horgan wrote:
>>> On 2/20/26 02:53, Reinette Chatre wrote:
>>
>> ...
>>
>>>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
>>>> ----------------------------------------------------------------------------------------------
>>>> 1. User space creates resource and monitoring groups for user tasks:
>>>>  	/sys/fs/resctrl <= User space default allocations
>>>> 	/sys/fs/resctrl/g1 <= User space allocations g1
>>>> 	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
>>>> 	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
>>>> 	/sys/fs/resctrl/g2 <= User space allocations g2
>>>> 	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
>>>> 	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
>>>>
>>>> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
>>>> 	/sys/fs/resctrl/kernel <= Kernel space allocations 
>>>> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
>>>> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
>>>> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
>>>> 	# echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>>>>    - info/kernel_mode_assignment becomes visible and contains
>>>> 	# cat info/kernel_mode_assignment
>>>> 	//://
>>>> 	g1//://
>>>> 	g1/g1m1/://
>>>> 	g1/g1m2/://
>>>> 	g2//://
>>>> 	g2/g2m1/://
>>>> 	g2/g2m2/://
>>>>    - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>>>>      similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>>>>      avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>>>>      user space to likely change it.
>>>> 4. Set groups to be used for kernel work:
>>>> 	# echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
>>>
>>> Am I right in thinking that you want this in the info directory to avoid
>>> adding files to the CTRL_MON/MON groups?
>>
>> I see this file as providing the same capability as you suggested in
>> https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/. The reason why I
>> presented this as a single file is not because I am trying to avoid adding
>> files to the CTRL_MON/MON groups but because I believe such interface enables
>> resctrl to have more flexibility and support more scenarios for optimization.
>>
>> As you mentioned in your proposal the solution enables a single write to move
>> a task. As I thought through what resctrl needs to do on such write I saw a lot
>> of similarities with mongrp_reparent() that loops through all the tasks via
>> for_each_process_thread() while holding tasklist_lock. Issues with mongrp_reparent()
>> holding tasklist_lock for a long time are described in [1].
>>
>> While the single file does not avoid taking tasklist_lock it does give the user the
>> ability to set kernel group for multiple user groups with a single write.  When user space
>> does so I believe it is possible for resctrl to have an optimization that takes tasklist_lock
>> just once and make changes to tasks belonging to all groups while looping through all tasks on
>> system just once. With files within the CTRL_MON/MON groups setting kernel group for
>> multiple user groups will require multiple writes from user space where each write requires
>> looping through tasks while holding tasklist_lock during each loop. From what I learned
>> from [1] something like this can be very disruptive to the rest of the system.
>>
>> In summary, I see having this single file provide the same capability as the
>> on-file-per-CTRL_MON/MON group since user can choose to set kernel group for user
>> group one at a time but it also gives more flexibility to resctrl for optimization.
>>
>> Nothing is set in stone here. There is still flexibility in this proposal to support
>> PARTID and PMG assignment with a single file in each CTRL_MON/MON group if we find that
>> it has the more benefits. resctrl can still expose a "per_group_assign_ctrl_assign_mon" mode
>> but instead of making  "info/kernel_mode_assignment" visible when it is enabled the control file
>> in CTRL_MON/MON groups are made visible ... even in this case resctrl could still add the single
>> file later if deemed necessary at that time.
>>
>> Considering all this, do you think resctrl should rather start with a file in each
>> CTRL_MON/MON group?
> 
> From what you say, it sounds like the optimization opportunities granted
> by having a single file will be necessary with some usage patterns and
> so I'd be happy to start with just the single
> "info/kernel_mode_assignment" file. It does mean that you need to
> consider more than the current CTRL_MON directory when reading or
> writing configuration but I don't see any real problem there.

When reading the global file it will display all groups, yes. Writing configuration
need only modify the group(s) needing to be modified (similar to schemata file).

Babu and I did speculate a bit on other interactions with "info/kernel_mode_assignment"
in https://lore.kernel.org/lkml/0645bba3-6121-41d4-b627-323faf1089b7@intel.com/ and
resctrl may need to adjust how a task's group membership is managed. resctrl could cache
some state or manage task membership differently entirely like
what Peter proposed in https://lore.kernel.org/lkml/20240325172707.73966-1-peternewman@google.com/

If task group membership management becomes "cheap" then resctrl interface can be
reconsidered.

Reinette

> 
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/ 
> 
> Thanks,
> 
> Ben
> 


