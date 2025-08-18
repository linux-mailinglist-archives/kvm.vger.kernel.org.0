Return-Path: <kvm+bounces-54893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2A4B2AC2D
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 17:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2492A2062BE
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 15:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA80F24A04D;
	Mon, 18 Aug 2025 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCt30SJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8324886A;
	Mon, 18 Aug 2025 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755529639; cv=fail; b=fhbDktXeAK7OPZ12dX+ZLZAPd4WWf3pXwc9ar4D+15rHmadLmbPAborNQMtTAO2EoVq6mI43jHr0irEv8dtqGYGB53JBFgbAOFR6z9ArkfJu7dXKzPmUXm0jJs3w3e/wj5ADK4kFdrhkhs7Wkg52eh47QwIE1goy1kT5Jku4JqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755529639; c=relaxed/simple;
	bh=7aYnJ4f9YeN/5cdLbMVVozd1Sdk3oDTMrbyPs6iA7oc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JD47rDYtNSip/xJ2a6ADL9HmA1+KsAl+wyCPEEX7B4QQYV2vZNFWJ+GUWRa5Ne1ni52iOfcIZBR+uWKv9FGgUh/dmMbZ1xRvy4gP2ttWsDiVoDtABf3fG9fevN+zCvG+NRzaDNerjyVE43d9Hq/kwvUiQdnd4XtoF5YruXxkykA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCt30SJJ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755529637; x=1787065637;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7aYnJ4f9YeN/5cdLbMVVozd1Sdk3oDTMrbyPs6iA7oc=;
  b=TCt30SJJFiPpXN7nafS4GdCW3uDtYWqlA8RF4I0hrYHqOomk4CASP8RS
   wHsD48Ebo92+K4mu/+ge6Hpe0qYpBcl4ZGIP6wKMFuiOKKhd66B2BoB9Y
   DEwFbWNcwZ4rM1Ms0+8gAn1nlsTPwi7wI2qCrberXMHSgBW2vlfrGhDAy
   GEu9m1atkat1GKZQb5eSYXosp6YDrkGmNcrimTesdrRcOppRevwV+pXbV
   sjCDKeQrCN28dG/EBVLxG8aMsRJElq3OJT5MLZGeVXMq/kNw/+92WQi0r
   IOcFZyUPK7BGE7Yk6wdjWy5ZKtJ5gfjRo0DqLJNeEykMAm4o9TSb8kmNR
   A==;
X-CSE-ConnectionGUID: uE/aSdZRT9Wr6N3Ghgx3wg==
X-CSE-MsgGUID: hU8rJhP8RtGBa+WIbHV/9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="75323947"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="75323947"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 08:07:16 -0700
X-CSE-ConnectionGUID: crbb2fFYSu60eTxn8xrthw==
X-CSE-MsgGUID: /PNZDCakRTSBuHhzZUNUSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167983171"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 08:07:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 08:07:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 18 Aug 2025 08:07:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.85) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 08:07:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pM4AwjwDKUWbF5G71RYB8WiY7yeTELOzPab6dX5Ww3Ep4TkCFUZsWyGrLA2sD/fuY8PA41qXm7jXhlT21f2f6e7bezWlQwKIuF8+Lh0zHI7SBQ+XnP5ZHENJPz8GaWSrtl2fHHK2BEb9yZm/+ryB8JyfhhW5ewtbB0qjlDUcQwI797Qf61K6vgfxoaeNY3hXNxWjk30CGNqf8lbNqqnPGZf4MSDabfliNWJ6JDjkVMKjFpMETln148ea/kn3RO+R+lbAkZ//TaFxv4t3eWOgB60ThueV2VvhjsKbeuLt0AbC97u081a+wQzJmWDMvNYxOlBd+XAQaj+xo3mX/eFipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0+IAwSeMOt+wEYQZnzGo5ETW6eAzV/50VVxQrJEv8Y=;
 b=wiVzUs5V83n7dnOA+ZbuFeKc9L6mbzWT9XwEh3XriKNq6UQ1Do92p5B/9IvYoUvo2yxNXBSDfAja7b2JyZTIx+AkJOStY9MtVrKPqyqsi1c4R8NRx5ySRjeyz4AFJuiS+R2493J5qpqITmDWhn5rg6llwZP5vdtBI22liTpLB2jr3Mt3Lp6RJ4mRTY/307jH3HiF7eU+FFGbO+UGlMwzwwM3CujdC5Af9uRvmwamrzGnwnpVzVgIu5BgaqBPc0R/VIsVbH4Ios4CMngIMiQaAfBa6O0uLgpXIOpncKjq1c4HA/TBjVFDmhmUFgrRP+KJqKaT1Jkk74/ZnGqT0ePdgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by IA0PR11MB7815.namprd11.prod.outlook.com (2603:10b6:208:404::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:07:13 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:07:11 +0000
Message-ID: <4bd07d7d-f4f8-4175-9384-d90b0e3c6e57@intel.com>
Date: Mon, 18 Aug 2025 18:07:06 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
To: "Brown, Len" <len.brown@intel.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>, <ira.weiny@intel.com>, "Sean
 Christopherson" <seanjc@google.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com>
 <aKMzEYR4t4Btd7kC@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aKMzEYR4t4Btd7kC@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR02CA0015.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9::20) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|IA0PR11MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: e114cc34-3415-4e63-b0da-08ddde68e837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUFXZUJoMkEycHhoOWpIL1krTlJEcUpwb1RKTHBQSTJTbkxBeHhUcHpyMUFx?=
 =?utf-8?B?WmJVdlVUSjBUYjloMmJ0Z05zOVZhMDd6eDNSR0NnTzVSU0RobGF1ZURWdEVV?=
 =?utf-8?B?dU5ZcS9OUCtOVngyMjFCZStqY0VhaFRhSVdYQjRYbUVhODBUS2orK3ZzRUt4?=
 =?utf-8?B?TTYxeHArTC9pYkxZdGFpbEUxZ0wwTnJCUTZ6alE0TVVkL29zcGlPUllWemJu?=
 =?utf-8?B?V0hVQTVyRnhNOUdkUUpvd3p1UVV1dUxaRi8vMTdYd2xBYUhnTE5wT2VLTWxs?=
 =?utf-8?B?N2RpVy8wWnR0RzFMNURNcUplRGEvRUJ1Sk1veStlUHhXRHBiaUJJNlNZam0z?=
 =?utf-8?B?TTkyemxBeml4SlJZUlIzYTJzUGx1eUdvbmU2RzAyc0F4S2ZuZjdUekQxdnVh?=
 =?utf-8?B?NlNiR2twVk1TdmF2bkJtQzd4QW9FUDF6K25rNDhFNVBvVkV5Y24zTjFDa1Ir?=
 =?utf-8?B?b09kRUdnODdNK1RHNmpjV1JzTFVrcGx3NVhnNldTTExYSWwxVzllanVFYnVN?=
 =?utf-8?B?TGlUVlR2amh0SWZzWVZBWGVtRzEzdFhjVXJGVElIdG9BTGdzTlBBL0d1bnFm?=
 =?utf-8?B?d1RJT3FGZGk5amlTSXZzZmZFVjllM3VDNWFBYUdQakZQcmwyQldyRWJqQ2lh?=
 =?utf-8?B?cTY3aEMzZzN1OGRsdWgwQVNHSzNTdENkSkc3aThoOC9OQXpkZUJSNXhNVWhD?=
 =?utf-8?B?SXJDSTFuZ25CWmhqZDhGWGM3RmlIdkR4ZTRid2dhdmNJalpRSnpEVDgwbEFE?=
 =?utf-8?B?RVR2MEVKTWFackc5SW5xemdZZm5mUnF3RTVrd3R1Nm1rZEFNUENFR1FaNjNO?=
 =?utf-8?B?eFBKa1M2TEJIWTlZb1dpZDRMUmRBUHgySnlRM1JiUFlLZVpjR0YwN1FKNHhR?=
 =?utf-8?B?dTBteTBqRjVMcC9KTi9FNXovam5wUm1BWlRVRnF0K085SDkrQUhkR2pEWUtB?=
 =?utf-8?B?NjJxUXZwSjFwekFwQVV3YmRDNTJzaEx1ZEdqWjVDOHdoakpqYm9HbGhZVUlE?=
 =?utf-8?B?aWRBQTlST0JWQm5wMUhJYXRtS3FWelN5dFgzMU40aml3eVdVUTlOSllWaXMv?=
 =?utf-8?B?bkE3N244VEkwZTcyazVZRzdWRUpZWlg0MStoU1JtaTlmbXhLMkl5NHpUaVRp?=
 =?utf-8?B?N1MyaXd4SzNIbnY3SEVNMlJQbUVxNVZyb1lTbW1pR3lGc0g5bDVhWnFWWkdq?=
 =?utf-8?B?MFBHZEwyNUMwMWgxd1pVY080N0F4ZjZYSEo2d1BRQ2Ywa09YT3ZaWkh6WFJZ?=
 =?utf-8?B?TERoMzNSQ3hPTzlQa0hCMzdxTFh4WkxJeTAwMkJYekFQZUt4WURPVEN6WS9X?=
 =?utf-8?B?QWowRTRYNmhZNEZodlVJbkVvVC9jYzZZSlZZalY1ZGNvRUE4WmYzTDlBYTd3?=
 =?utf-8?B?enRvOE1ueldkR1E5dGpqRVlua1ZkdVdZanY5aU1xdVpyNWM1ejczTmJOdUtL?=
 =?utf-8?B?VWpmT2d4elZFVGlxZEgrRkMwZ05nNmdUblU3VmtRTXZVVnVZMnovOTlnZWRh?=
 =?utf-8?B?TjJicHNyVjc1OG1Ic0E4ZkUrOUhGSjJFelhPSkhOeHE2MDZpWmE1UGVjVE9n?=
 =?utf-8?B?V2dLN3I3ZkVPMjd6cmlyR3dxU0V5TlZXOTlNOVB5ZFFPZnpIaFhENm1Sd3NQ?=
 =?utf-8?B?c1VNbys1T2ZwNTVuTzcxZzJqRUhhY2krNzR3UEV3QTRNR3dIMWpFdDR3aEFU?=
 =?utf-8?B?azVPNDcxbUI0VUQxVkJLL2hWOGxqWWVORFdrTDVzTjRUYjV1ajZVTk1od2J0?=
 =?utf-8?B?c2RGRW1aRktLNHlNTzQvU05EQXVlTm4yeEl5MU5ZeWhFVEpHVzdpN0pzYlMy?=
 =?utf-8?B?Ulo3bldSN2RiaEd5dTVkSFlSNnpLZ1A1anBOdDg2SVN1dGVLaHB4Wk5mbHRn?=
 =?utf-8?Q?/Fvfu4ik94hav?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amplamFqVzdKM01EZWgwS3F0Q01RdXZLM2FNY29SSDhYYXdFSnpyNzR5aFFB?=
 =?utf-8?B?MVFINjFsd3ppZXIzV3lsVmxCeGYyaXNXTHJJUll0YnJTYzRxczI3OWN2Y1hS?=
 =?utf-8?B?N2xnQWxiK2g2anBuc09hU2JpQWRhQkQ3V3FEYkhHNDR1ZWpHMlVPeW4zWUhu?=
 =?utf-8?B?bnl5R0VHalNYT1RDU1BXV25zS1lKaGlsMVhJTTdSTS9ZWTRpdFVmTlBvTzVN?=
 =?utf-8?B?T0FaSmY3Vjg0KythV0k3OHJ3UFhCS3BzYko2dkVmV1VIcnFSck9DMWRvQlpk?=
 =?utf-8?B?a3JHMmYwWlZpdXdKSTRNVi9LRjE2SUJscFlGMXQyVmx0dDAwN0VUaGczOXJE?=
 =?utf-8?B?Q0pCU2UvUGdOK3ViVUpZakNzenkrSTlFQmRWYi9ENnMrUmVrM2R2d2VrcmFJ?=
 =?utf-8?B?R254NVo4aEpXL3BnNmpKc1Z2QkU4YXFrVGdOeXVzQTRvOHpZWEhXSmM5S3pI?=
 =?utf-8?B?cUJGVy9vR1drckFkS0xMKy82eXpYZXM2WWowTitzcUFabmxWTnJrR2dkTTIy?=
 =?utf-8?B?YTk3NGRvTHpkb3BFSThlbTZwaDQzaVVMY3VTL0krbi8yL0I5U2Vva21LOHA3?=
 =?utf-8?B?ajRmTk8yV1c1MXdoN3VnL0QrS1RVKzl0R2Y1Z2J2TEg5S3puMnJtMHIxTVFN?=
 =?utf-8?B?N3NvUUdXUTdLdDdZR2g1TmFuMFRTVTlsK0pUMVNxbFpoR2R1a3lnZTRBMWdz?=
 =?utf-8?B?cUlLeTVlSjNkbnVHQmNWM2M3cjFMSkd3M1BnMmNUeGMzT0Z1d0JHOWJrSGlY?=
 =?utf-8?B?NTJ3UVZGK1pSaUxlemUxOFduYW9Sb1ArN0FmT2FwSmJZeEl1R3pqZ1BmQ2VK?=
 =?utf-8?B?QmtDaVl1VlJCTUd0QXNUMS8valdueUJWVjJCSWthZVRRS1hGYm5sY2hLM1Rw?=
 =?utf-8?B?MmZzazdqRUY2S215TlZTMXc1SSt4NXl2aml4MVhQdVhyeEJTUjRpcnZ4b2lo?=
 =?utf-8?B?L2w5dEUyUmJ3YTZxczhvbjF6MlBwOUtrWlpKT1laTCtLNmdmNExTR1pKYUo4?=
 =?utf-8?B?WERXNS8rL2JhcDlFS0NXUENmbXdtZ0lVdEVIS2pxbW0wVTNMM3VDc2hXS2xO?=
 =?utf-8?B?T0RWNzBjWlh6OE8rSGVZanpDQWZadTFBdHAyaWdEK3hkWXBEa0dPVG92SmlG?=
 =?utf-8?B?Smp2NFVVNnFQWjl1aGdZcjVDZXpnVW9EV0tyMHZLMk0zemZFeUxCUFlESmRP?=
 =?utf-8?B?d29JcE1OSi96Z3F5Ly9lWkZGaktESG9GcW5OVEZzdDhjM0h6TnE2V3lQQXhL?=
 =?utf-8?B?a09heEFsbGNjQU56Um5SUEQxZCtEdXUrNzlXcXZrdjJQMStBMHZEVUgzMlhW?=
 =?utf-8?B?REhtaEZXbnV1UTFrc3FZQUM5ZE1tMkhCWVBjKzBvMk1ZRDJoUnkwdVdNR200?=
 =?utf-8?B?TjdET0xKeTdPNE1vcEFRcDBacE8yRU1Lc3NUcGVZTk8ycnJUL2o4cUxOQ3Uv?=
 =?utf-8?B?WGs0YzdhUmVucXhib3prUXc3SGhlZ2ZqaGlOR25mN0p5elladVdBRXd3VlNo?=
 =?utf-8?B?SHFjUHJYMW9aRHptSHA1MWRldGp5Q0U1SElMaSs2VEdkSjdtUHdhNWJLdGwv?=
 =?utf-8?B?dmVqSEwrSDNGWXp5QThFdkRDWWdlNjF5b0Q4UzhnR3czQ3Q5RUVPK1dYSlpu?=
 =?utf-8?B?cEc4cXlsVWtKTm1tOUJMbWJZMGYrbHpndnVTcUNjYU9aRUd5NGdKSkFXc2gx?=
 =?utf-8?B?RDRNZVVmNWF5ZXFDaE5QenNOK0VNMC9icmRqK1JzYmtzaDR2TENJVkg3WjFH?=
 =?utf-8?B?L2t4WGV2eXFuSkFmc2U0eVUwOFVvVjIySEtqdDRnd2I0cDZaYzJ0NXFMUUw4?=
 =?utf-8?B?NFFobkluZFBXMDlKSS9MNmJQZE1pUFdVckE1bDBhM2lxb1RNWlQ1RmdGaHRa?=
 =?utf-8?B?UzVQQnNXRjVlcENZUXQ5b28yNW9MYm8wbGNMalNBNmh3MmJiSEROVjBBUjJF?=
 =?utf-8?B?bXd5OEZCaEFGZVVZTE1yU0MrUDRCSEQzRVZrNmxxbXRuT3Y1RllRb3hTR0RU?=
 =?utf-8?B?N0hTWk5vck5DSnBJVVJhVi9rMnlqOGd1WHRoSmRXenFrZ0V6cUF6UWdOZitJ?=
 =?utf-8?B?c3pyWUlXMEkvbnRmbnl0YXlWSFJYdFREaDdHcUxoOWFubjhiK2NkRzI3TU04?=
 =?utf-8?B?RmZORThYL2YvVjdtS1dCWGtZRXdjQU83U21Vby9kWG12ZEpXbU4rWFlpZ3Z4?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e114cc34-3415-4e63-b0da-08ddde68e837
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:07:11.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZYf2NQkTT2sAONzRBZTGV5qhhOIyO0bftSwzIlrKXDnOZn8T7bL1WnNSY7txC433tsm1YqtXTDY6F6fn02akQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7815
X-OriginatorOrg: intel.com

On 18/08/2025 17:05, Sean Christopherson wrote:
> On Sat, Aug 16, 2025, Adrian Hunter wrote:
>> TDX support for using the MWAIT instruction in a guest has issues, so
>> disable it for now.
>>
>> Background
>>
>> Like VMX, TDX can allow the MWAIT instruction to be executed in a guest.
>> Unlike VMX, TDX cannot necessarily provide for virtualization of MSRs that
>> a guest might reasonably expect to exist as well.
>>
>> For example, in the case of a Linux guest, the default idle driver
>> intel_idle may access MSR_POWER_CTL or MSR_PKG_CST_CONFIG_CONTROL.  To
>> virtualize those, KVM would need the guest not to enable #VE reduction,
>> which is not something that KVM can control or even be aware of.  Note,
>> however, that the consequent unchecked MSR access errors might be harmless.
>>
>> Without #VE reduction enabled, the TDX Module will inject #VE for MSRs that
>> it does not virtualize itself.  The guest can then hypercall the host VMM
>> for a resolution.
>>
>> With #VE reduction enabled, accessing MSRs such as the 2 above, results in
>> the TDX Module injecting #GP.
>>
>> Currently, Linux guest opts for #VE reduction unconditionally if it is
>> available, refer reduce_unnecessary_ve().  However, the #VE reduction
>> feature was not added to the TDX Module until versions 1.5.09 and 2.0.04.
>> Refer https://github.com/intel/tdx-module/releases
>>
>> There is also a further issue experienced by a Linux guest.  Prior to
>> TDX Module versions 1.5.09 and 2.0.04, the Always-Running-APIC-Timer (ARAT)
>> feature (CPUID leaf 6: EAX bit 2) is not exposed.  That results in cpuidle
>> disabling the timer interrupt and invoking the Tick Broadcast framework
>> to provide a wake-up.  Currently, that falls back to the PIT timer which
>> does not work for TDX, resulting in the guest becoming stuck in the idle
>> loop.
>>
>> Conclusion
>>
>> User's may expect TDX support of MWAIT in a guest to be similar to VMX
>> support, but KVM cannot ensure that.  Consequently KVM should not expose
>> the capability.
>>
>> Fixes: 0186dd29a2518 ("KVM: TDX: add ioctl to initialize VM with TDX specific parameters")
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
> 
> NAK.
> 
> Fix the guest, or wherever else in the pile there are issues.  KVM is NOT carrying
> hack-a-fixes to workaround buggy software/firmware.  Been there, done that.

Thanks for the quick reply.  Adding Len Brown for intel_idle.

Len, you may recall that MSR_PKG_CST_CONFIG_CONTROL came up in
the following context:

	https://bugzilla.kernel.org/show_bug.cgi?id=218792
	https://lore.kernel.org/kvm/bug-218792-28872-5sylPIVpHD@https.bugzilla.kernel.org%2F/

For TDX platforms we would need _safe() MSR access for MSR_POWER_CTL
and MSR_PKG_CST_CONFIG_CONTROL.  Would that be OK?


