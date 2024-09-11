Return-Path: <kvm+bounces-26447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF4A9747B3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 03:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2A2287565
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E924B26AFB;
	Wed, 11 Sep 2024 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUrgw47o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AE32231C;
	Wed, 11 Sep 2024 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726017492; cv=fail; b=V4zXF6SBZxLP+WuQ6dOfdKsEGcnF8Kt4pXx/4/uIYFmOu5jB4HAm1kXr+NJOy7hcxj6XbkXWPqdGoE5Mp6EoMvbmMTPH9dvBKYl0rbCrxSKD01LOOy1hVJbDFJixX4yeiH/mzqOPZOYQlqdk0hmO6MHTAK/zpu2xieFhD3LEroo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726017492; c=relaxed/simple;
	bh=gAzgUeb6S9xnx2FY2kb7j+/7Ko1p4IuL1jZctBpY9ds=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=MkcUmFSfsSYSMXZxrZC1vPxqcpm+ovsXi7NELrKm2ObOZcoJGSv57ZrQhD6crNKN7bZK10qv/qNlHNXQihTnvhAk44peJJ1hRcVwfGXgpVM9HtkO3KfvqS6SUaWvmyIx5ixH1hxoYm6anNFC2uiL4KzOM9jKBenIXs2nvLu8hSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUrgw47o; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726017491; x=1757553491;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gAzgUeb6S9xnx2FY2kb7j+/7Ko1p4IuL1jZctBpY9ds=;
  b=MUrgw47olW4ZxP8n0TrfTGhRGOvArv3kbmXKBxZUrdKXsodJ0ADKrbtg
   0vizotGEp2t6NAEoNGG2Lphjy6nEpWHmOn/lO8pibFBcP4MM9A5h1a/xJ
   y8fcUywwtgleE/wLt6hzddBkw5JE83BOgUA0yZZUSDnAndJl0FRXtERBa
   m60X895vZuZ6cy2p46J8RR3F9yG36y0O9zz/Pj/bMi53BPU7dLkhpYixF
   j9DcPLWYEFm+qlah3ZJVh+SVkUwecIguqlnI60cV3rdmt+41LCzwQXtJZ
   +Hq5asT9QcYQfqjOfH1FLM06hm49z38Ri4c2DSNscLQAhz1FAXKJIATjd
   w==;
X-CSE-ConnectionGUID: S1yUXIA4TNqRUatgSxdfTw==
X-CSE-MsgGUID: mhlhLsjWQxqTDXzHIs9uBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="35366672"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="35366672"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 18:18:10 -0700
X-CSE-ConnectionGUID: eyK9aJwGQfymjjuZJefUIw==
X-CSE-MsgGUID: LMgaBEL8TbeVWcEzLTmVdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="71581727"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 18:18:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 18:18:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 18:18:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 18:18:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 18:18:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bveTk0+mE60bSMqKFjYMM9eCGDJI58uKVuzNZHiSifmqxW69g8MK1AnoowPaD6HxAai5IehZezuBWQQrPJGfDbnhdFGiXkCuOShERA6eJhnqI0iIAlUJocPrc6aD3cKVBbJ4GgSF3hxErJk24SgBBJVeSI86CnGnw1cxlBzAJgKp5g18YyAN2pWpUNfLpk4l0CK1NojE5RBPIMH5TtqICXPPta5mI2lttmmwRya+Ka6HBhHosNpYDmTpuDxddcqHcY2DdaZGjLrb+MgkDrKgHGee7eDvOqxA6YuiklL5bUrWpyCm5k9Wi+k78x8OyaCTBev5bQ9uHt+Gzz53cStPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfsnEy1qfnnUua5+s91EZEVt6FQOKDTn78HjFrd1tVM=;
 b=Dus8nFrcfUJZgCrJdbJHdfb8xPQnCgnr0kiR0hL/slkQsH8wQo3ICRD9+ULEzuF0EIeFDLc6RIe+gTGb74SARufv241gGlIARzYPneOwA4z2CGokW+ZYimin2rPvHJ2x7AB2c3HaUX2Cvqg+xapmomAI2Of+zPU8+Ws4FA2BUqAlIkV7lPW3isVVYFnPBwazO3xWP0Y2Ef3Ty8zqt479u5ZZFxsHvrMH409QDtMQLZ25Vnji6BsKLlDKrElttJ0dgaw3DONaPKQ0fVhDImUuXmoliNSUVy9XlPo5lCapvgYkNeM4VtHMzT2fdnx2Zt0JhqrT3CsvOfQ7rFMz0y2O2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6759.namprd11.prod.outlook.com (2603:10b6:806:25e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Wed, 11 Sep
 2024 01:18:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 01:18:01 +0000
Message-ID: <8618bce9-8c76-4048-8264-dfd6afc82bc6@intel.com>
Date: Wed, 11 Sep 2024 13:17:54 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
 <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
 <Zt-LmzUSyljHGcMO@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuan Yao
	<yuan.yao@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Yan Y Zhao <yan.y.zhao@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
In-Reply-To: <Zt-LmzUSyljHGcMO@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::25) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: 3502bd71-90e5-47fd-13ab-08dcd1ff93f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUxEVkg4MTNGZ0R4MklMa3k1bExMSzBxR1BJeUpUUDJieWNxMHFlcndTd2hm?=
 =?utf-8?B?aDUxRUJhQ0xCbElId3NhU2VrbXZUdUR6Y052ckRhQUZJOXFVY3dzT0RoWHJ5?=
 =?utf-8?B?WC9rcUt2R0Jvc0RteE1ndFNLbit1eGpRdlNqR1k3KzFMMFJYWCt3dDdkNWhk?=
 =?utf-8?B?Wk9VdE5tcWxYY2phc25BYlgyVEJzQ1dEbHdWT1FxakhPU3Y5Rnc3NWR5K3lF?=
 =?utf-8?B?NlhKT2RXaXVVYURUcVlLMFl3cWh0RDZ1Mm8zalBNY21zTGRkSEFQS09MUzZq?=
 =?utf-8?B?SU9lWjd1aTJZL3JneWNjUmg3YmN0T2YwQXE4TjM4aFkrT3hKZTRWNG11TGdm?=
 =?utf-8?B?MzI3MmRXZWljbzBtK2ZRakRJR0RUcDd5ZHVoOW1TNjVvaERFcTZNRWxnQnYx?=
 =?utf-8?B?WlVuOXlVUDZwWHM3WUJRcTllcDZ1aFdmd2NtUXpBajZtcTRNQ0lHRFZZMlRC?=
 =?utf-8?B?Ti96aDBIN0hMbTRTbjZlV2JmVEdVa1UyY3NUNVVZdG1UMVNURU9OR2sySURD?=
 =?utf-8?B?UnB6NlJNRUpuVUIyUjZuajREUUpmMXJMQTBYaENrdUVZcmx3TDdjb3lzUUVq?=
 =?utf-8?B?M3F0SHc4a2E0akhmWWdJb1BmUTFXSGRZL1I2czlVR2FJNGRTZmJ5RW1VVWNt?=
 =?utf-8?B?Yk5YQ2YxM1ZnelNaeTUrTjZYR29hc0lXaHhPdzFOQzl2S2hSL21GR2djQVNP?=
 =?utf-8?B?TnlnUkR6QmdtaE1xVFR0RzRRWkkvcVdldHNQaFJtL0c5aUt0UVRpeVNyb1JF?=
 =?utf-8?B?ZjJpVEpRMVJYVzI5QUFpaG5IMlB3bVcwaGNKSm1mT0gzUTZMWlpKenV2UUVS?=
 =?utf-8?B?M011YmhtYjRWZXZlc3E5Z0hwSVVQWXlJOTJIbTNNNGJ5N1BJSExCNGNKM1VE?=
 =?utf-8?B?RHpIN1ZvZWVmMlhaUUxBUjd6NUU1RytaVWcwTG5TUnp3NVpQQ1pQdmtLbGlN?=
 =?utf-8?B?bE9hcERqZitMZFJTdWkxTWdDRFMxT3Z4OUluS2tVQk5UR2pGL3NtVDVmR0lP?=
 =?utf-8?B?RU1VVXVDakcrQlZ4UUl5RGpDV0JRZ1pSMlBvU1dqaFZVdnFJUnk4ckhCa0R1?=
 =?utf-8?B?R1RTZm9OQUE5ZWpNdS9CYnpUaUhacExoRW1vZnFJaGJDL0xZUG02T1U4Ymgx?=
 =?utf-8?B?eUQzc2Z6WFFZczE3dmNXQ3FkVXYvU3JIZ3dORnZ1ME1BYnMxcUgvc2xRZWRM?=
 =?utf-8?B?TDhyYVZvOE4vd1pidWxWdzZlRTRta29zQkNXSitVektqMXFjM2ZqYWtweTBv?=
 =?utf-8?B?OVRIUlJvQWR0aHpvM3QrZm45MmsxNXp0aUlqb2lqa0tsaDhqcnNScG1YNDlN?=
 =?utf-8?B?cmRmZGJyNm9sNzdqcUd2L1dpaS9iMlk5UFBBRG95ZVQ1WnNlODcvZmZmNnAw?=
 =?utf-8?B?TDZVYi9ua1ZxNDJjay93MFJZcmVyaisxd3kzTWUxM2VJbzJDWGNjS0U0Mmx6?=
 =?utf-8?B?YThjSVRESXVxZ1BRZ2sySjdEc0ZtWGxlSkR1K0JDRHM5VFZxZHdqMFVtWldJ?=
 =?utf-8?B?c2lSZEhzK3B1VW5WTVFWQ2lLM2NHcjdPYnJSTHBQZlpjTVhHNkVtSnNrd01t?=
 =?utf-8?B?SWJIRDlNdFFYZ1pnOHlpODUyNDllOFBEZDY5QWU1REk2dHB6K0lDYW1WU1Nv?=
 =?utf-8?B?SU9KOXhRcUpWNHBWUVpKK3pzY1hsd2RSVkRpWEZqV2hJYjE5VGlkYjkwUnFm?=
 =?utf-8?B?aU1lRDBhUmpDTXZxT0I3WTJXdDVaZFFRVnlWcDJzL1c3bEFiS2hhWjIrRHow?=
 =?utf-8?B?NzFMaXVONmkvTE9KMUhDOWxRMEMxMmRKMUViUVQ3M2pjcTRHTUhIalFhVTd1?=
 =?utf-8?B?SFFuQnh4NDRLTmNOQ2d2dz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDBPTSsvMFdnRzAzRDN6anFiTkFiMEZHQVlxR1Z4N0Y5QUF2ZlpJMXVuRlQ4?=
 =?utf-8?B?ZTRKYVh6WERrTU51VGlNNmpqSzZzK3pvVExtVHhReEZNR3JOY3QzZGJsYWxJ?=
 =?utf-8?B?YW5Yd2JzejFaTThMdk4wd1NpRXJ1K2FKWkRLWFpqZHlONlVxdFE2MWdZK3Y3?=
 =?utf-8?B?TXRFcUF3YUJjaFdNVlVKWFNFSDFNUURsSHhBVG5XclN0aUJEQnFaRElGa2dI?=
 =?utf-8?B?WENBTGcvYVMvRG42RS9nMjBYbDVZR200ZkNGTDg1TkRiQWpJaEthbkJLeEFt?=
 =?utf-8?B?V09GYzhKbGJYWTR4WjlkS3d1bHB5UjJGTnZMS2xPdjcxZGY4YmhSVlc2ekE1?=
 =?utf-8?B?YjBHL2RlaFFvV3lYeENTOFpzTWdFd1k0M1UxMFI4alpDUktwTmpGVERFR054?=
 =?utf-8?B?dzQ0UW1nRWtzUTE1RDRHclRKeHpjSVFFS0tmaDJFVS9EcFplMWljV0dyUmdt?=
 =?utf-8?B?bno5czlxRlhhczVxaUhvN0ZaMUlrMGh6VnBWYVE4eWJOemx3blUwNktGTTVE?=
 =?utf-8?B?eWtDbERJUEloVVBud3JmSGxPTkg5dTlwVXBGOThEMkJzMUZwTDU4VUxXdnNB?=
 =?utf-8?B?YkpndktwRDlONmx0T0tkQkVPTitjVGJlUzFGcXVwdmFickN6dUdFUzBjWkM3?=
 =?utf-8?B?SFNZQmdFendDdVJzekxqdDdXdzByYUNMaWRjZmhGVFRSME9GYlZjUmdrb2tL?=
 =?utf-8?B?M3NEZzh6am95bXRjVTJ4WXB0YVM2YUpsblhQWi9VZld3RzZKYUlXaGRsZWlS?=
 =?utf-8?B?NEtiRnlaMjNJeVVDSzJSSithbzlTYjl4ZjV5am9HdG9mK1lYTHl3eXgxWkU4?=
 =?utf-8?B?VkJNeC9YRGZ4N2pieTU3enNOdjc5MXc4Q0xMK2RNdzJnQmRMRHN2ckxHa05U?=
 =?utf-8?B?UStlVlFOc1VXMytFeEk1clFNWXVYRXZqWUh6Rmc4d1hPTnFTcEhaWUdCK1BX?=
 =?utf-8?B?alpFd1lwdGZLNTBsdGxqMlFDekUwaEo2dlh4SUpLS3U2aVd4bDF4eDJKaXRK?=
 =?utf-8?B?bHNDdXFYdS91ZVhodGNPNWdDUE9ML1JVdnlqZVN5Ym5JMWE4KzlNWlNGU1Q0?=
 =?utf-8?B?M1czbFNCUC9sdTVhcFNmTHdPTjMzOGNXczhmQXVBNk05N1QxL1JackwxNC9S?=
 =?utf-8?B?d0dzNWpaenU3RkJmWTZtTElubjVnbld5N2VBRG1HY0tXa1g1eXJpQTZyWHp6?=
 =?utf-8?B?YnA5MjArM0p2NkxjVU92cnpEeGlTMTJENmhNa082NDlGbStNUWIyOVVJWERu?=
 =?utf-8?B?RnNtV1JIb24yc3RpL29TSjhvNkp2OEcvM0dIQlNOYUVKZEU3VnhPMGJuSnhL?=
 =?utf-8?B?SHhmNy9PT0pZVVJIcEZ4RFJOM01JVk02d2FjQkhYR2JxTkZLUkJOMVpRcU0v?=
 =?utf-8?B?SmpyUjF6VmIzNllJY01laVZ2QUtmU3pBRkRMTGNGWFdFcG5YV0NJaVlRVUg5?=
 =?utf-8?B?MjhGUmFBbnBydjkyN0s3cVhOcnpXZm9IZU9DbE9obnMxQzdQS1RKVitSU09K?=
 =?utf-8?B?cDlrdFJzZUY4ZmF3dW85cENEYUljNzh3VFNwSWZXTWE5WkdhUWNObjhIcnlN?=
 =?utf-8?B?d1c1M1N4ck9LYU9ENDN0N3l5aWhDZVhNOHhKR2lzblhQeXV1NzE3b1hmdEJH?=
 =?utf-8?B?TWF2TlBIMDFZc25Md052cEY0a3JJdmhwTVlHb1YvU3Nqa3FXSGYwUy9ocDJi?=
 =?utf-8?B?dGF4MlN2Q3VPUVo4UlU3b2tjcWgzTUFHS3NMYTY1V0xubTQxcENkdm1jWk0w?=
 =?utf-8?B?KzlvMzZUck5hNVlicmhIMEI0MHE3cWU2bGpyTkwrVkc0Ny8wS0xYdTZobkha?=
 =?utf-8?B?VkRHMmFRTXRPemZTUFZEb2h1ZmJHSjM5cEpwa1Zjem9RZ1VpZTA4OVQ2RGJu?=
 =?utf-8?B?RFBWaGZ3WGtHcS90T0Q4aktVOHNmVXNaMlhpMjlEYjgvZjdhUjR2M1Z0ekhn?=
 =?utf-8?B?MkRKZEd1aWV0M05qU2hRYVNBV2ZJajUyR0lmR2JaMGRYa0tUbllNVHpMK1N2?=
 =?utf-8?B?UEpHV3dES0o1WS95dXBFeHlhNzhMV0ZHK2FCYXlnT3ZibWZTWUpHakVZTEpC?=
 =?utf-8?B?ZTF6NFA0ZXVjUS9XdWNrY2hWaGx1cFQ2bFZKeG5iejBBVS96bGVaci9oY0Jr?=
 =?utf-8?Q?5vT5eZcdDKb0PxzgrpkbYGgSL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3502bd71-90e5-47fd-13ab-08dcd1ff93f0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 01:18:01.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YADLg1apeiuh0yX7x0QaDaebmYtdH6xKvnJ67vKRVS+3BA8+f/UVmOeSJ7UE0Cu3wzHw/tRPdx3xrnmHog27Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6759
X-OriginatorOrg: intel.com


>> Host-Side (SEAMCALL) Operation
>> ------------------------------
>> The host VMM is expected to retry host-side operations that fail with a
>> TDX_OPERAND_BUSY status. The host priority mechanism helps guarantee that at
>> most after a limited time (the longest guest-side TDX module flow) there will be
>> no contention with a guest TD attempting to acquire access to the same resource.
>>
>> Lock operations process the HOST_PRIORITY bit as follows:
>>     - A SEAMCALL (host-side) function that fails to acquire a lock sets the lock’s
>>     HOST_PRIORITY bit and returns a TDX_OPERAND_BUSY status to the host VMM. It is
>>     the host VMM’s responsibility to re-attempt the SEAMCALL function until is
>>     succeeds; otherwise, the HOST_PRIORITY bit remains set, preventing the guest TD
>>     from acquiring the lock.
>>     - A SEAMCALL (host-side) function that succeeds to acquire a lock clears the
>>     lock’s HOST_PRIORITY bit.
> 
> *sigh*
> 
>> Guest-Side (TDCALL) Operation
>> -----------------------------
>> A TDCALL (guest-side) function that attempt to acquire a lock fails if
>> HOST_PRIORITY is set to 1; a TDX_OPERAND_BUSY status is returned to the guest.
>> The guest is expected to retry the operation.
>>
>> Guest-side TDCALL flows that acquire a host priority lock have an upper bound on
>> the host-side latency for that lock; once a lock is acquired, the flow either
>> releases within a fixed upper time bound, or periodically monitor the
>> HOST_PRIORITY flag to see if the host is attempting to acquire the lock.
>> "
>>
>> So KVM can't fully prevent TDX_OPERAND_BUSY with KVM side locks, because it is
>> involved in sorting out contention between the guest as well. We need to double
>> check this, but I *think* this HOST_PRIORITY bit doesn't come into play for the
>> functionality we need to exercise for base support.
>>
>> The thing that makes me nervous about retry based solution is the potential for
>> some kind deadlock like pattern. Just to gather your opinion, if there was some
>> SEAMCALL contention that couldn't be locked around from KVM, but came with some
>> strong well described guarantees, would a retry loop be hard NAK still?
> 
> I don't know.  It would depend on what operations can hit BUSY, and what the
> alternatives are.  E.g. if we can narrow down the retry paths to a few select
> cases where it's (a) expected, (b) unavoidable, and (c) has minimal risk of
> deadlock, then maybe that's the least awful option.
> 
> What I don't think KVM should do is blindly retry N number of times, because
> then there are effectively no rules whatsoever.  E.g. if KVM is tearing down a
> VM then KVM should assert on immediate success.  And if KVM is handling a fault
> on behalf of a vCPU, then KVM can and should resume the guest and let it retry.
> Ugh, but that would likely trigger the annoying "zero-step mitigation" crap.
> 
> What does this actually mean in practice?  What's the threshold, 

FWIW, the limit in the public TDX module code is 6:

   #define STEPPING_EPF_THRESHOLD 6   // Threshold of confidence in 	
			detecting EPT fault-based stepping in progress

We might be able to change it to a larger value though but we need to 
understand why it is necessary.

> is the VM-Enter
> error uniquely identifiable, 

When zero-step mitigation is active in the module, TDH.VP.ENTER tries to 
grab the SEPT lock thus it can fail with SEPT BUSY error.  But if it 
does grab the lock successfully, it exits to VMM with EPT violation on 
that GPA immediately.

In other words, TDH.VP.ENTER returning SEPT BUSY means "zero-step 
mitigation" must have been active.  A normal EPT violation _COULD_ mean 
mitigation is already active, but AFAICT we don't have a way to tell 
that in the EPT violation.

> and can KVM rely on HOST_PRIORITY to be set if KVM
> runs afoul of the zero-step mitigation?

I think HOST_PRIORITY is always set if SEPT SEAMCALLs fails with BUSY.

> 
>    After a pre-determined number of such EPT violations occur on the same instruction,
>    the TDX module starts tracking the GPAs that caused Secure EPT faults and fails
>    further host VMM attempts to enter the TD VCPU unless previously faulting private
>    GPAs are properly mapped in the Secure EPT.
> 
> If HOST_PRIORITY is set, then one idea would be to resume the guest if there's
> SEPT contention on a fault, and then _if_ the zero-step mitigation is triggered,
> kick all vCPUs (via IPI) to ensure that the contended SEPT entry is unlocked and
> can't be re-locked by the guest.  That would allow KVM to guarantee forward
> progress without an arbitrary retry loop in the TDP MMU.

I think this should work.

It doesn't seem we can tell whether the zero step mitigation is active 
in EPT violation TDEXIT, or when SEPT SEAMCALL fails with SEPT BUSY. 
But when any SEPT SEAMCALL fails with SEPT BUSY, if we just kick all 
vCPUs and make them wait until the next retry is done (which must be 
successful otherwise it is illegal error), then this should handle both 
contention from guest and the zero-step mitigation.

> 
> Similarly, if KVM needs to zap a SPTE and hits BUSY, kick all vCPUs to ensure the
> one and only retry is guaranteed to succeed.

Yeah seems so.


