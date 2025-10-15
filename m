Return-Path: <kvm+bounces-60051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE38BDBFF0
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A02F3B6DAB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04012F9DAF;
	Wed, 15 Oct 2025 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GVguHyAM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7322FB979;
	Wed, 15 Oct 2025 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492126; cv=fail; b=rPvOrwG6aj6eZHro1w9qbk5XEY4HavjHETUFvOBREwUQvl2n9qQYcDrY9/AaKr8nGDiiLOEevSu9txQ5IOlKbjSYS32Zj7ew779ReoZBqYBw8DWVlNYJ2HLpm08kbrotE4+Ckaywl5+xoOHw9hLWCn/o+Rig5fn49/iqfLOoOOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492126; c=relaxed/simple;
	bh=wTvijz/ZGUuIluSjY9T8fBd8eQMXrSMfVssqvAfBigQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WFXX9HorJ1JOhi2UxheKwSz00WA2j6htuPK7nB2Kg6eylHwf6jN/0X42DPJKEVpBlQ7XFjqiumeFpBA6ksiKsAsF2kV3V6K/eaavLjz8QWJ3lZjNHp6UBUx8m6DItCuSwNuqHCIaI5UfRbLihobSvCQpV48nEo3VVDPt1AKsB8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GVguHyAM; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760492125; x=1792028125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wTvijz/ZGUuIluSjY9T8fBd8eQMXrSMfVssqvAfBigQ=;
  b=GVguHyAMkQKxycSue2kogO5dvJ2Z4474wfUR3S3wLEZ2FoZbimoSEtp3
   mZOwY12Ohfv3OMznH9u5hNtTOejBghu+X2sZFdACzxFWjrZWebqxJO3Dq
   vU8XoPbKMsCD9Rgg57GtETuhVngg67axffulc3FvFS1JkUNvuXH8rbwyK
   i7VCM3AhMEhHLsNvDFAc2086Lj1OOBIHmfYSPlPfS9ZTifT3z9uAMHBYz
   XznF5Acq5q2mI2bH1Gr67xYAoBVY00Q49Ig75dRVZX+fgp6We36jolDuW
   3+jjSia2Hxo1bqVL5UmAGSb3arC98EFTD3QSzwdhygKyQ24IvnC50YqSw
   Q==;
X-CSE-ConnectionGUID: baTUpfhKR/C6XmQhA6r51Q==
X-CSE-MsgGUID: O/OAa1XoSAq96wF6IKsZZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="61867637"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="61867637"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:35:24 -0700
X-CSE-ConnectionGUID: rcdLHpfXRGW7lxkcLfrAFQ==
X-CSE-MsgGUID: dPHCfBYPR4uBVnhV8jXYzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="182814338"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:35:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:35:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 18:35:23 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:35:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdjQL5ULN2CIuzE1uTyAjNm+p1hDE72UlZbx/dFEq0cFaaRbpR28lSl3OKvFPW/PfshLTo5OoodoZCVis0Zi2LXBDL+l0Uou3+yb+gxTN89FgYxy58HibK5TKojnu4IwjVj5G0NBPtk2v1wOC5IEN4R+7ytRoAptJg/rDxD9y2JO1oGTFb3PbJxhEfjdodXvQzpNTiuf+JUA7jbz35akLK7wOt45z/s+Ke/CDrpCgu5kovslt9UZUCZPuPQ3GRuw9KcX96UaQcpMMRMuTvomhbQokFXfWCcuaSMuj6CH9WCCzzlnyQOju+FSavtG2P3TruzdSOaaLhcnC8utzuRLsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTvijz/ZGUuIluSjY9T8fBd8eQMXrSMfVssqvAfBigQ=;
 b=IB83Y8w+kLYmPW3WHh5nlVK5civAOxFVFJmUNrhyvZuN8k7CLHHrUQ3Ohec8NMkkdYE+yqHI4oP27OAEhTDG4a3mxoaksDLbH/oqa6rVG0L7sTVSsrw6irOq1Jz+Bp8PyGz6W2Y+bMi0x3JNrnsTb0xGbYznCsS9RHtEwyaUvH/AR6TsxN5ksPacJp8VIZl1/oBpi5rg/CIDYOcm/Upgox094mVM0ZgZ6bHYQOKUXuPZosfBCZWiOMVe87DbtgsKvDBuTOeCeNuX6/3qdCxNMjqKtNFL9T80yycP05BE/jNpWT//I0eP2UDeYmTR77Z66u+l8cFcE43JB2uoUgfJ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA3PR11MB9133.namprd11.prod.outlook.com (2603:10b6:208:572::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Wed, 15 Oct
 2025 01:35:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 01:35:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0s1whGFHeVUeSuikKt1/NBLTClf6A
Date: Wed, 15 Oct 2025 01:35:15 +0000
Message-ID: <28434cbae5f2eca42f783d4ad7a52206b6b85ed2.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA3PR11MB9133:EE_
x-ms-office365-filtering-correlation-id: 91a0f94b-017c-41de-feff-08de0b8b1771
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?elJPWjYybitla2tyTlg3T2Y5eXBMaTY3bkErMW5HdFB0MHV5ZkE3QWJENVBB?=
 =?utf-8?B?aU43dlNBSW5sN3FiM1VaK3d6Q1A0d0haNDZpTzJ0LzJlWm42c2NSWkZuWmdj?=
 =?utf-8?B?UWxtMk9kRUlUVlFYbnllSWd4Q0szMkdZTHMwUFhvODZ3VllrWjFYeVFCTE4r?=
 =?utf-8?B?R21QWXIxYjFoTGI5c2hrL3EwSG8xLzhpamx5OXBYUEd5SHBDdFo4WUlVVWJY?=
 =?utf-8?B?N3RTU2J4SkdSeTNQTzNud3dYY25kN0xCNGhzb254Qm90Y1FKbi9ENkFQamFC?=
 =?utf-8?B?dGQwK1JOYkMyQkZDK3l1aVFMR1NzRlZrUDJIVElMbzFHK2lUNDY2Y1V5Q3lQ?=
 =?utf-8?B?OTZHZS9MVFVDSTlFTUdOYWlrSnZWU2dORG41M3NlelZFakh0WjkraHlyQ1JY?=
 =?utf-8?B?ZTJTcVlJVHNJbnRUZG45a24zL0IxYTNnVG9mU2lsaWJFOTBYWHo5NGpJMTc2?=
 =?utf-8?B?d1R1M0dvMEZEMmlpMFNPRm1CcSswd2l1cXZ4eTlheG1uOGdhSG9RMDNJalpM?=
 =?utf-8?B?RjhDaGJMTmpYRkVMbDJ0QmtzQWJjTTh6V2w5L0YrakNaS3NoVUI2d29adU42?=
 =?utf-8?B?LzdZL3R4RUhvMlowOHF3QUpzd2NCNmJKVnR0QVh1VGVvNnhCU3lPbDZXT2hJ?=
 =?utf-8?B?ZGhjZHpDTk9Nd25zY3pUWUVuTm44ZUJZZ1crSlBtdFBqajcrdGdkbTJsWW5o?=
 =?utf-8?B?eFhIc2FrMW5KNGh3T3pMZHg1OTZQcTYzczk3Kyt2RWFWYm1ORFNNOXBOQ0ds?=
 =?utf-8?B?MS9jZGxpbkM4ZXBydWg5SmxlLzgrZHVGNnMrY0RTRzFXOWhndi9Xa3lVMEVE?=
 =?utf-8?B?YmxzUFg0dWc3VEdnc3ZnaEZxNlI1Qys4T3A5OEpFaDVCNVpzbHhnRVBNVkV1?=
 =?utf-8?B?SU1VcjlFaGwrTFEwelo0UnJHMXduSCtZeXNPMEs4ZmdYVGl1WVBscDBSV3l4?=
 =?utf-8?B?OWhaTlJzRTFJakhkcnBPZ3d4YXlqM2s1YkFmOUZMNzU0Qzc4OURlaWtJQ1Zi?=
 =?utf-8?B?eU9uL2t0M1dtOFVZTTdObDM1Yzk1bHlXOEdPaDU0dlYrbS9NOGVDajFKb0pw?=
 =?utf-8?B?MFJ5MEhMQ0dSaWtXUXdvci9ITU1hd0YrRkErVXg5aXQxVmpWY0lKTTNUZWFX?=
 =?utf-8?B?a0UvdkJhSlE1SzU2MUxLb0xERml1eXBlK1RDOEJSazJvWUZrQVZ4MzVNSW1J?=
 =?utf-8?B?ZW1jZmN6clNyS0tDMm1qMldxQ3JQT3JTaHdueFhhVmt0SkhHd0JWVTRYSXZG?=
 =?utf-8?B?QXlhM3NaemhUT1V5N1Z1NWZlR05MMTJMZkJPaFBXbFNwakxJT2gwUkJWblpj?=
 =?utf-8?B?MGdlNS9lL2tRcSsvLzVkdzRrR3BmMldXZTBQL2pQSVhMOXlmZkJXRTBrc1BX?=
 =?utf-8?B?WjhnOHNaL2YrUUpyUm8vQWliNWpObmJEenNTSnFXQkIvdStHa2ltcjR2R3p0?=
 =?utf-8?B?d3ZjWXFuTVBJOFFKcEdCKzNuTWZ1UmduVHh1M3dqVG02aXF4c1h5MWRBbXpG?=
 =?utf-8?B?UzFDQk11ZkhHcUwrMDZSN2lTQWNmUHYva0UxNkhOejBBcmdCcW9tTjA5MmVW?=
 =?utf-8?B?eGcxSXhBSnJBdmR6eWhtMC9RS0hOcDdOeE1sM2VFMVpveFlSc08zdkpPOFpq?=
 =?utf-8?B?c2NnNjRhaFlzelVYRDkzODVtTjhtYWJqV0NkVk5tK056cWN4clRqYkZDd3Vo?=
 =?utf-8?B?d0x6QmdHR1cvOXRWQjNtbjhaQnMxWFhMaWNaL3JlZlNYVHMyREJuS1pRQkFx?=
 =?utf-8?B?eWl1OHlkaXBhODRqV0c5LzlTbHNPK2czQXBmS2ZvMXJCSEo0ZDJSRVJqb3pw?=
 =?utf-8?B?WGtZNzgwbzhZcVQwb0tjYnRXbjBuRitpeWZ2cnR2QVRnRnFSM0gvVEwvUE5T?=
 =?utf-8?B?cVJyZXJUMWIrNS9nYm5pQ2dXOG4xTFg4Rm1TUHJXZnArUW9uNDBQbVZOcXBj?=
 =?utf-8?B?d3JDVkJlN3ZIWmY3QkpxVTcxNDAvV29MYlB0UW56bDdjV3gxUTdvNi8yVzdG?=
 =?utf-8?B?MDFQZFZBbnN1UkI4dHhYaFUrSXBFM0o2c2VsYVJPenUzOUFGUDkzRWlCekx2?=
 =?utf-8?B?YlBsdXVzeFBqejk3eTV6ODVYQlJaRTU1elBDZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0ZtUEdYZHJQblpSbTJQMFZYVXRaUkZiWEZkQkMxcHBDclp6TmgyVVp6YnZT?=
 =?utf-8?B?VUZsNnFJc1h2Q3MrcXloQlkrQjJrcjVsWURjYmhvUXNsVW9rb002SDBPNjY5?=
 =?utf-8?B?WTJqN0lDZFdxSGtPT3Z6VmJKdkdkUk4vc1BNQnpEdWI2ZWtEbjRXSVBsdHZ3?=
 =?utf-8?B?VjJ4YmU3eUVMR3J2T2RSRGZsdnRnYVg0Nm5IckxhVkZpdUR1SUordGdXVXI5?=
 =?utf-8?B?ZVErV2hoM2J4SmRHTHk3QXFPY01LZjBmOVl2R0dvWFVLSzZrWHNZTUdBWDhN?=
 =?utf-8?B?VnJvNlV2QkxLM21NRDRMVDduOEdnNy9TUmx6d3kwaDN0bDd0UFA3bWViVkhh?=
 =?utf-8?B?MkhLY2pNVzFWa1hmRnlIZDgrMnBuTlNFc3l4bHdJbjhLZ3RBdW5VWTRUbjVm?=
 =?utf-8?B?K08yYWs3TmhtZlZoRUtjaW83RDJlbjF4WHBVVUdTbHY4cW1Db296QkpqYzl0?=
 =?utf-8?B?cE9hcjVkRzJ1SzU4RTcvZWRMb3FPb0NSR0Qwd3lBOVl6L0RSL3NUOERxckov?=
 =?utf-8?B?cFZWSTBnbDhHK1o3dnNwbW5OdUdLZ3A1aXNrZDJmeDloNFdleWM3RzluOHdL?=
 =?utf-8?B?SUVmQzZoVmlrbXB4RFZlK1JWeWpNS1dERjdReWVmajVoZDQzREpwV2FHQ3FW?=
 =?utf-8?B?TUlnY0NmUHdzaUhQYW1xbGZqR1VFaGMwK3Jyc0dBVVFETXljRHFNSkVseG9W?=
 =?utf-8?B?RFljamlMSm9xaXBHcmxQcHU1NXdwK00vUzhFV1YrSjc3bWV3N3J4blAzNEdS?=
 =?utf-8?B?VUV3UXlTUHAzM1dwSkJHTitYVFVrcDdUTjZyN1ZFZTAyanA3cnhXWHdyY05w?=
 =?utf-8?B?NXhKejlYNXRVeTN1cUE2cmdleTBON1RydFZndUQwZU9BNStpOUMxOFR2ZWgw?=
 =?utf-8?B?dTJEaXE2eDZQSUEzUGlzbWVNQWhOL2RZaTA1UEF1Ky9Lb2Y1K3Q5SC9YQ0Iw?=
 =?utf-8?B?U1p3ZkgxdGt6aWhhLzVxOElGdXRTWTh6WlBrODRzZ3crWHp5RktLV0hWbkNC?=
 =?utf-8?B?TXlmOVdjajBDbnVNY1I4VEx4UHhWSGl4VmU4YXdQajJzVExqQmVZd2RWRFV1?=
 =?utf-8?B?a1I4ektOQ0dwTklzT24vNk9PMDNrZ0NwUkpqUnNKRWp6ZmtCY0JtcGd6LzhF?=
 =?utf-8?B?SlZjYml1R212ZzVMTGZsZkltRElUVFhuY0o3RHBNZGhDRTFDZEQvR3VRQmhJ?=
 =?utf-8?B?ckZKdEFqNnJQcDVkM0ZYRzhUTWo5UXlORE9NQmZ3aGpxT0pBY3NUaUdPdDBs?=
 =?utf-8?B?cVRCVHd6SDBrUjQ1bkdMcUkzUGZiQ0tFVzZyUHl0ZzZBOG1SeGw5VXRvamdC?=
 =?utf-8?B?amJJSnFZQjNIclZsTmtyV1pOVHZwL05GTjlpRER0R0hBY1R5dGpjaEVkdGNQ?=
 =?utf-8?B?MzFlVHZ0MVo3NmlVTExpcStJc2hJS2k0WVZ0L2VhYXA0TVJSUGRzdkhIWEln?=
 =?utf-8?B?UVlZN2VEMzVmUXorZnVJT1FGWFhPcFZCRTBtYWtHc2JXZndrTE5FanVYQmVG?=
 =?utf-8?B?MXd5VDdCTWxFNUJTWTJQNmQxNVhuNS9YaWJiRnpFSVFwNGpQWjFsbWM1Y2Uz?=
 =?utf-8?B?RzNwMUFwQ3F4SlB3SExWa1M0S3piMWVSUkorbkl3ZkQ5aW5MVmtCNVh1U0lL?=
 =?utf-8?B?ZGFtc0NTTGhSczR3Q3hJcEY3YVBXUGxxaVg3aEx0NVQ4U0VyYUlVeU91VXFu?=
 =?utf-8?B?NktBTjhZYVRQRnBEMldld1lpTW5iQSt0azNrc3NWUTVuS1lTNUUzV3RqSUtG?=
 =?utf-8?B?Vkx1QkY1VjFJL2Q0cWhHT2NoWGtTU0l2eWdsYm5OZlNIeGVIbnNROGNGU1B1?=
 =?utf-8?B?YTZPR3pxRDFLL01Xb01aOGI5TVZVZ1pWeG1LNVFLdEY1d25MZFEzV2tqeWFj?=
 =?utf-8?B?RlZGQnphd2tpYzhRT0lPdjhVc1JWSEtzMWhBRmRPcFFQb09nd0ZBMktOSi83?=
 =?utf-8?B?RmtJU3Z6aEVMWFBGZmVhd3V0YmdFRG5MT21LaHk5YUplejRJTTVOSXhYQnJy?=
 =?utf-8?B?Q0ZDV2FOdnA3OFoyMEFRZ2M0WnQ0QWRvMHdQLzQ0RHo1WENFU0tpNG5mNHBz?=
 =?utf-8?B?M2FKMWM1VFIycHdJMG4xZkxiVXcrNVFTZWZjTzYwUHZ0SkN3MTdKNUE1cDV2?=
 =?utf-8?Q?6B9FzfVNsajkv4UWzn4ccRcpc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6195EEC09B02C348999E93BE74A4F605@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a0f94b-017c-41de-feff-08de0b8b1771
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2025 01:35:15.4495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLr/VmJSYm5fxa0HNikI2uQagWbRaK85BcA+UjGhDtN3rHnrZ7nrqhK6KMpBtPc7iiVRu+0OVEyQEjCQ4onPfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9133
X-OriginatorOrg: intel.com

DQo+ICsvKg0KPiArICogQWxsb2NhdGUgUEFNVCByZWZlcmVuY2UgY291bnRlcnMgZm9yIHRoZSBn
aXZlbiBQRk4gcmFuZ2UuDQo+ICsgKg0KPiArICogSXQgY29uc3VtZXMgMk1pQiBmb3IgZXZlcnkg
MVRpQiBvZiBwaHlzaWNhbCBtZW1vcnkuDQo+ICsgKi8NCj4gK3N0YXRpYyBpbnQgYWxsb2NfcGFt
dF9yZWZjb3VudCh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5zaWduZWQgbG9uZyBlbmRfcGZu
KQ0KPiArew0KPiArCXVuc2lnbmVkIGxvbmcgc3RhcnQsIGVuZDsNCj4gKw0KPiArCXN0YXJ0ID0g
KHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChQRk5fUEhZUyhzdGFydF9wZm4p
KTsNCj4gKwllbmQgICA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRfcmVmY291bnQoUEZO
X1BIWVMoZW5kX3BmbiArIDEpKTsNCj4gKwlzdGFydCA9IHJvdW5kX2Rvd24oc3RhcnQsIFBBR0Vf
U0laRSk7DQo+ICsJZW5kICAgPSByb3VuZF91cChlbmQsIFBBR0VfU0laRSk7DQo+ICsNCj4gKwly
ZXR1cm4gYXBwbHlfdG9fcGFnZV9yYW5nZSgmaW5pdF9tbSwgc3RhcnQsIGVuZCAtIHN0YXJ0LA0K
PiArCQkJCSAgIHBhbXRfcmVmY291bnRfcG9wdWxhdGUsIE5VTEwpOw0KPiArfQ0KPiANCg0KVGhp
cyBhbGxvY19wYW10X3JlZmNvdW50KCkgbmVlZHMgdG8gY2hlY2sgd2hldGhlciBEUEFNVCBpcyBz
dXBwb3J0ZWQNCmJlZm9yZSBjYWxsaW5nIGFwcGx5X3RvX3BhZ2VfcmFuZ2UoKS4gIE90aGVyd2lz
ZSB3aGVuIERQQU1UIGlzIG5vdA0Kc3VwcG9ydGVkIHRoZSBhcHBseV90b19wYWdlX3JhbmdlKCkg
cGFuaWNzIGR1ZSB0byB0aGUgQHBhbXRfcmVmY291bnRzIGlzDQpuZXZlciBpbml0aWFsaXplZCB0
byBhIHByb3BlciB2YWx1ZS4NCg0KPiBAQCAtMjg4LDEwICszNzcsMTkgQEAgc3RhdGljIGludCBi
dWlsZF90ZHhfbWVtbGlzdChzdHJ1Y3QgbGlzdF9oZWFkICp0bWJfbGlzdCkNCj4gIAkJcmV0ID0g
YWRkX3RkeF9tZW1ibG9jayh0bWJfbGlzdCwgc3RhcnRfcGZuLCBlbmRfcGZuLCBuaWQpOw0KPiAg
CQlpZiAocmV0KQ0KPiAgCQkJZ290byBlcnI7DQo+ICsNCj4gKwkJLyogQWxsb2NhdGVkIFBBTVQg
cmVmY291bnRlcyBmb3IgdGhlIG1lbWJsb2NrICovDQo+ICsJCXJldCA9IGFsbG9jX3BhbXRfcmVm
Y291bnQoc3RhcnRfcGZuLCBlbmRfcGZuKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCWdvdG8gZXJy
Ow0KPiAgCX0NCg==

