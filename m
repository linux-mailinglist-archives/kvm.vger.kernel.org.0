Return-Path: <kvm+bounces-34667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC2AA038F9
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 08:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F8283A2BBA
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554711E04BD;
	Tue,  7 Jan 2025 07:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wo1kUKUK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7AF1459F6;
	Tue,  7 Jan 2025 07:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736235915; cv=fail; b=d3TsJZLTG0heeGMlyKKiLEb9z4oeWNtwpvwpGDfxacUy8THIVmIa5yP5Ktpdfa6WN66SqFAq7Ng3AMPEDLa34zaSVbGlGl/TJoZmZhvmZBsYLJDYx0x9GPoMKJuutdzrnYVwDRZMFrdvzWHSl533q2Ph1Gtngi9wQ8WzSaQS69s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736235915; c=relaxed/simple;
	bh=cAErBrfQw3wuw1XYzblcxcXNGlT+hIYVxpMr5UCIya8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sWaZ0a+SeRt0jJctVEgeovU6vAZOZAbDnGrdmho0OgYkYLXRFOqsFVqqI24okxo0rfKWii+VC8jEl55H3xphu2awk8AU8a3Kpriv1NX407u8ps71Nx3yZWVl9nhdfVPsd4DGZTYYUIpwBFapk21DBEPWQ9PEVfsksBEtv+ZqPXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wo1kUKUK; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736235912; x=1767771912;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=cAErBrfQw3wuw1XYzblcxcXNGlT+hIYVxpMr5UCIya8=;
  b=Wo1kUKUKYhAV0W+GCWJuHF9OHO/DphUx7Z8RBJMndElWY5egKD73Ljq2
   geOc4XbaubKTSqKjs8dIP74ZUobvef8zUPdNOfWFqJqbhnAhpY6oT7wgW
   PqkrGoYmyrLgs9/N6GqN5LFJs/1V/lU/5b1rkJqgh506t0r0vrdfpoJMz
   +5CLIWC3nNKCafp5csqKEQpqtR0ky3Afiqd/QRpo6YUXzANupdmaCGq7l
   IxnDAQmwvylqMLR4mPbCLv1VNWLKoizw5TJc7F6ij12vFlsgh5g0hA4aP
   TnXbQbeYsRq7IC2JMlsNtknp6UT9fuEz6qfOiDQM7InbBGyOxI9TVhI4D
   Q==;
X-CSE-ConnectionGUID: +SoLwiXsQwmguFgRPqoE2w==
X-CSE-MsgGUID: V3iLnvi0SGiOmnRdT8EUhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36284592"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36284592"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 23:45:11 -0800
X-CSE-ConnectionGUID: z3IRozeiS/irViGF/3lTPA==
X-CSE-MsgGUID: YAyaptN0RBiNk+oD9MVXpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103179867"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 23:45:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 23:45:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 23:45:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 23:45:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JexiAnEn4M1zekbmxUR+S+tNtEUBWAG8oXrzEVjTBmvPbYI0w7GQuiW/xSiGL206Tag9fKpgCWYTt2DBjoImWsKwCLP+WqYmnuYIWtJD9+E1NOn3KeF1HTM3CnqrmQNVQzRzo3n5tITTX4zU0I1pulXtOe4WIaqWkFb3Ph2+/4MSq/o7zasNPy0FYoBbwXgINQ+a4/+qLXanlp4F9sDm2LuNcr/PB6Zk6qAMO05hz7zL/ftb58GwqTJkkYDmSGhS6pZcQ/AlsB+rFzollcwHFBKxQHy11kshUAMMWkGrFVNrRuWTajGljdiom2iR+5FDCXxVI7l3dWV9pVZz8bH15A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKGcM9qfnMStXqlkanxxuILfaW9UF0duXWoAuQMH2VA=;
 b=u+p8UN+w+ach3iAq5Esw/55bxoqMv5ed4KCm5/O7R5HeJ0IzjsbhlNWqOoyVZ2DuNxnatt5DqGNxmAbGHHDRFu4xdwMWHanSKm6vru7xPUtCFU3rd40BFnMxuFsX06/qJlUVRkPDZ7E8myAaNUpv9f4XuJdacX1yPUZdHCIwTzYmrOOT+oGnglk6B1veL1aVMfaqJP/YHIpctkwctsS3oZerpgxLSROufv78nEp0aeQIjoLNUNcjmPPz0oD5Cm+FPsWk4ravtAkhXHj95nkYhcW1fWYpGguhY/YSVnh5ft/6WcH/eDGsbYXV/FAzCx1js3QpIedsL09H8EJb4H2bLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by IA1PR11MB6346.namprd11.prod.outlook.com (2603:10b6:208:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 07:45:03 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 07:45:03 +0000
Date: Tue, 7 Jan 2025 15:44:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>, <dave.hansen@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v2 22/24] KVM: TDX: Finalize VM initialization
Message-ID: <Z3zbRYnyUmVWvxFO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241112073848.22298-1-yan.y.zhao@intel.com>
 <fdcab98a-82d3-44fe-8f4b-0b47e2be5b7e@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fdcab98a-82d3-44fe-8f4b-0b47e2be5b7e@redhat.com>
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|IA1PR11MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: f35598a9-f974-4e75-6816-08dd2eef326c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NENoR0g3a2EyS21aQTJJUmx1cmZXVUoyL0k0aXpmcnBaaytaM3Y3V1lreDlP?=
 =?utf-8?B?L3M1ZEp4bHhtbjdvTmhQbDdCUlJLNDhXcG9YUXBFQitFTnNncXU3WnVpa2tM?=
 =?utf-8?B?ZE9hZ3dsY1NvVDRMcGNhZDJIZjd4S0dGV3VyeTRWM3JISDBHK21rZ0VXMnVa?=
 =?utf-8?B?Z1lFRDZOdS9RTDZIcDlmSVYwSlFzY2FQYiszNmkvMjU1ZWlsaUVGUjY2MVJ2?=
 =?utf-8?B?a0djb3BFbHpOVjh2ZEJsT0VjSlYyMFgyL041SnlXWXhjT1h4d0JWTmRUdWtZ?=
 =?utf-8?B?U1ErbUhsckVUYWp3NzM5NHBHNXhIVG9FN3gwUWNydTNWYStmM09TMHhISnds?=
 =?utf-8?B?RDR5VXZSYWhySVQwbXB5Zm92RWVNanNUNnFFTTZ4czI1TnZ4OGdEalN3YTkz?=
 =?utf-8?B?czEwMEZOZDlsa1dtQm9Dc3pSSGM5MlBsZDY0YUs4MHR5d203L0xFTHdWa242?=
 =?utf-8?B?VytZMEFGUHFqY0s5OWlCd2ZSTkkyZXhNRU1YamRVYituMVFoMHlSQVlscnhO?=
 =?utf-8?B?NG16aUIwbEpQNWVEdTVkV2ViOWI4RmpzUjJSYXlGUXdKVExiT2RWRXR1R1Jo?=
 =?utf-8?B?YnEwejBLT3BaU3F1WkxzUHd2SHJ2OU9kZ0kvb01mbWlDbmpEbjdJTGw4b25V?=
 =?utf-8?B?bSsvZ0VDVmFXa0JHUWVjMkduU0xEM1BpaWh1K1dxUkEyWU1neWNpRUNsZEJZ?=
 =?utf-8?B?Qjc3RHlJQWRaRXFTNHdSWW9CQW5rMnpJOFMrL3k5a1pmWXdjSVFwaHhoMVho?=
 =?utf-8?B?ajU4VVRFbUY4VVBrcVZFNEpXNjh3ZzcwaXlvR3VPZk9sWEp2R2w3ZG1nbmdH?=
 =?utf-8?B?N2RMbFR4SjJJWVdSK2pZb2lnc0p0VDE5clNqOFF3V3NRRTZrYmtMb3d6Q1Nm?=
 =?utf-8?B?WmVMcjVZeVphMDRvdDNRTUhzRTgxai9SekpzRkJLVDBtQmZWNHQ0WFlFS2E1?=
 =?utf-8?B?ZUhJQ1BtNHg0dU51STMycXg4bVNwWlJJdFF0QlRqbzBkWnd0Z1pqRFJIZGMr?=
 =?utf-8?B?d2g0WVRhYzR6U2JjenVSa0hib1drM0pPbTNLbWxwRUUvbjU2bFVsNXFHTHFB?=
 =?utf-8?B?R0RoaFJac3pMY2dta1JUNVFQUERURTNiNWhnWGhCWUZmYjVoTysxTzZQVUVK?=
 =?utf-8?B?QmFma0VsM01KaC8yTW5FYitxUEQ1dmNQckthZTlaNmdYTFMwcVFkTzFnQm8v?=
 =?utf-8?B?bTR0R3pMSzZvczhDVjg2aTdzalJjbkNTKzE4Q2I1Q0NSVVVreDFJSDQza2tN?=
 =?utf-8?B?R3Rxanc1a1huT3RIT3JObFJqRGhpczFDQmFSSmhuQTN1ektrbzRWUDhBTUJm?=
 =?utf-8?B?SmtmdDNTbmhTbXFKNTF2M3dBOFdyaWl3SU5tdlFZdTIxb2krQWlodWdoUTdt?=
 =?utf-8?B?OGd6SVFrTW5VcGZnR056R1J2MFNqWWNwYndSQ2QrVnp1MjU1L0gvelhRNEJB?=
 =?utf-8?B?K3pYeWhwMWZhV2QyZ3RNWE41dWUzdEhmaDF3M3ZxZFU4amR3eC9VUHNhWVVZ?=
 =?utf-8?B?aUg4UWt1MHlxUm45c2xjYUwvaGVsRUdmbWhWN1NZZzJYaXdqMnl2R21nZzQv?=
 =?utf-8?B?MkdXTHZuREhVN1M3KzNBTDVESTRiWlRKVVNwMUlEL2g0clNGTjdIeGkwUG1G?=
 =?utf-8?B?QTUzRlZQZy8xdGRna0ZTdXRPZUNpakdGNlRsSEZPTXp4SnVGcXIwLzNsODFJ?=
 =?utf-8?B?TnN3blJrMURGR2FaSVhCMWYxb2szYjVnVHl3UlMvNDhoVXdPRWpsazZqZ2Jr?=
 =?utf-8?B?WXNTYklkamJJOHMrdktoQ3FUeXI2N0hmYXVINS9HU0krUmdJYlZhUytGT083?=
 =?utf-8?B?cVpGODltOHBQb2NmUHJDd1lJb2UrSkNkVkFTZk5kbk1aRkJGdC9KOVJUMDUv?=
 =?utf-8?Q?kozhfspXwiueK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXU1RHNYRlFlckh0YTgvRFh6eGZLZVpZNXE4Z3A5UWhhTk9Va0lUY1JTVy9q?=
 =?utf-8?B?Z1YzQmhEeUE2R2o1b3JzSzI4UjNZQnF1dm5tS1lwOXpSbUMvMjltT1Q0R1Vi?=
 =?utf-8?B?REQrNVNsY3RGd2NrZndpUFFTcDZuVGNSTWNHK3E5VXZMQkpSd0pvVDhiN0ls?=
 =?utf-8?B?ck9kM1NYazhBVjVaeHIzOWZMNW80RklwWG5BTnRCRjdyazRXMVMweGc1RnBa?=
 =?utf-8?B?Vng4dXV3RFBXQTY0MmtHYUl6QmhqU0MwdENVRHhIeUtGZ1BNZHZnTysxSTlw?=
 =?utf-8?B?czMwaDNlSU9iM1RHNzN1V2VWZWhQR2lCYWlnamVpLzdmekFpNFNpUnk0Ymc4?=
 =?utf-8?B?WHp4d3pvZ2cxRlVSV3N3Qkt2eDFRa3RjZnlCSUQ3ZGJLMkVQU0MrSjd5OWJk?=
 =?utf-8?B?K0xkU1RTQWhweHljVmJ4RkkyNXloVWJYaUgvNk8wb1VZaUd3VGFqSDN3aURP?=
 =?utf-8?B?eVhzVXU2M1JvaFlvQkgyTmpFbnhiVCtmVENtSUFId2Ftd1RkT255eFNFZHJD?=
 =?utf-8?B?Qk5MZEM2NnN6aFYwc0pWZUpmK2JETTkwbGpLVjBReXJZdkx4c2hBemxlZmE2?=
 =?utf-8?B?cEhIZjkrSkk3ME56Uk9RS2U1cGRjYkdIL3ZJQ21ja1QyVm5HblBpdktSdExx?=
 =?utf-8?B?K2FvdDVoZVdSNVJjWXltQ0Uzb3VXbEJ1emlQSllpeVd6WHJYK1l2ams3V2Zr?=
 =?utf-8?B?VTVsZzdyWUtPQ0RIckpjVEtEVVpGWGtOT05QbWNUSjR6d1NiUVpWbWtlcnBo?=
 =?utf-8?B?Ym50Wmt4dkVzRXRJWlkvcXl4ZDVxUHdkaWo1K09MSW1PYXJqUFJ3Z2lNc0Rj?=
 =?utf-8?B?VmVramR4ZTNpT0U1bkNkM0t5MU5uU29hWkxweUdoclFvaTdPd0tyZWFxK08r?=
 =?utf-8?B?dGdUbERGREJSNjZHcTZRM3Vhb0xvWXU0R3F0RE5uOCtuTzdrU1pYU2FlbVJz?=
 =?utf-8?B?VUx1aDAxcmpJZHpqSlo5WS85S2U2UjZoeG5RWDJqUWVXejJKUC9hUWQzL2lK?=
 =?utf-8?B?QUFEcDBBekRvZkNSMTRzL2IxeEZETDB3enZSdjhoRnJjblpEMTV6WGtGRHFq?=
 =?utf-8?B?TXhWTXgyLzRVT01sVFBXaWhrc2ROd2dHWG55QytoVVBlTlNxTkxhS2k5R3Jo?=
 =?utf-8?B?dTZDY2ZaL0FVaStEV2xDU3MreEdHM2RXTzBhVzlsYUY3MUVFTnhPN2ZrRVE3?=
 =?utf-8?B?WlUzcExyNzlhQ09xTmVsenU2THdCQS9aRndpRno4OEovOFhJdXdWbGlIZFRU?=
 =?utf-8?B?ck1kN3U0U09lcll3L0lRQWNGTVhTQ3dWSTMxVVlEN0s2QlQ2c2VRa05FOStV?=
 =?utf-8?B?eEJMa0dQVVhFeW1MbGpQSDZOYUhKQXFyUDBDWU1sMXpER1FaMGs2SWlWZzJZ?=
 =?utf-8?B?M0FBNllxR1lLR2srT0ZkY2M2K0szWCt3ekJRMlUrYi9kcWZubmdjUFc3V0Nh?=
 =?utf-8?B?cW5yOTRVVjRlZ3J4L0ZjMlUwMk9zeko5QUhPL0RkYWRJZFFuZ0ltVDJHcFdS?=
 =?utf-8?B?YWg5V0J3NXZmbEcxbFlCckZjVEd3YmJnR2MrK1R4a2FOa09LZ2tjaXJzNWNG?=
 =?utf-8?B?d3llWGhwQWdVcXRNeGo1ZCtmZXgyNlRUS2tVakdXSWdqUUhZTFNzNHYxZTdU?=
 =?utf-8?B?d1JVZ2RzU0JKWHBuTWZ5RkdMbVROa2VDUUNsZndMam1FRGhUNkh4Tm1teGhl?=
 =?utf-8?B?dVpjRWdvVXdTS0gxQTIyT2JSUkwycjE0MUFxSVJBSEdTcythY2pERUlUL0RN?=
 =?utf-8?B?TTVIam9iKzRzTWUxWitXVjBSMk1GR0JZZFRnY3F1STI2ci9YZFZPdFh5dmRT?=
 =?utf-8?B?UGZFZk0wU25OY2dzNUwxTG02VFduaWdMT01QZUsyenpJTGxhTm5UL3lveG53?=
 =?utf-8?B?U01Ycm1sajdPTzIySS9FNUplV0JQTFVEV2g0ZUM5MDRIcnpFam1uK3ZiOWND?=
 =?utf-8?B?ZjNTRy9CYk1nSHFqN2Y5dXI5MFQ1VkRUYnBIaGh6Vml6d2V1Mko0VHhGdER6?=
 =?utf-8?B?eEtrWUluM1hCZGJFQVVuLzAzSVBKOWphYlBHN2tYWGRTWEZpOU1sRnc0SVlt?=
 =?utf-8?B?QVY4bjJQVk1wank3bXkvTnArNk9pdi9MNHpTZ0lZWk9vcHZvc2ZYb1dOQXJJ?=
 =?utf-8?B?bWZXTzlDeFJqdXFrRjZUVDQvaExVUjRpQTM5cGxlcmltNkNFZVhyc0t1U0po?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f35598a9-f974-4e75-6816-08dd2eef326c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 07:45:03.5659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdMj3iUJrRIRhA+ulghB8axtZTPyPVOiTbEGk63wIXSTwfikUEib476aJ/uFFHOBbL0Be4ZkAqmbuu2+qDo6lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6346
X-OriginatorOrg: intel.com

On Tue, Dec 24, 2024 at 03:31:19PM +0100, Paolo Bonzini wrote:
> On 11/12/24 08:38, Yan Zhao wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Introduce a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
> > KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
> > 
> > The API documentation is provided in a separate patch:
> > “Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)”.
> > 
> > Enhance TDX’s set_external_spte() hook to record the pre-mapping count
> > instead of returning without action when the TD is not finalized.
> > 
> > Adjust the pre-mapping count when pages are added or if the mapping is
> > dropped.
> > 
> > Set pre_fault_allowed to true after the finalization is complete.
> > 
> > Note: TD Measurement Finalization is the process by which the initial state
> > of the TDX VM is measured for attestation purposes. It uses the SEAMCALL
> > TDH.MR.FINALIZE, after which:
> > 1. The VMM can no longer add TD private pages with arbitrary content.
> > 2. The TDX VM becomes runnable.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > TDX MMU part 2 v2
> >   - Merge changes from patch "KVM: TDX: Premap initial guest memory" into
> >     this patch (Paolo)
> >   - Consolidate nr_premapped counting into this patch (Paolo)
> >   - Page level check should be (and is) in tdx_sept_set_private_spte() in
> >     patch "KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror
> >     page table" not in tdx_mem_page_record_premap_cnt() (Paolo)
> >   - Protect finalization using kvm->slots_lock (Paolo)
> >   - Set kvm->arch.pre_fault_allowed to true after finalization is done
> >     (Paolo)
> >   - Add a memory barrier to ensure correct ordering of the updates to
> >     kvm_tdx->finalized and kvm->arch.pre_fault_allowed (Adrian)
> >   - pre_fault_allowed must not be true before finalization is done.
> >     Highlight that fact by checking it in tdx_mem_page_record_premap_cnt()
> >     (Adrian)
> >   - No need for is_td_finalized() (Rick)
> >   - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
> >     wrappers (Kai)
> >   - Add nr_premapped where it's first used (Tao)
> 
> I have just a couple imprecesions to note:
> - stale reference to 'finalized'
Thanks for catching that!

> - atomic64_read WARN should block the following atomic64_dec (there is still
>   a small race window but it's not worth using a dec-if-not-zero operation)
> - rename tdx_td_finalizemr to tdx_td_finalize
Right. I didn't notice it because of the mr in tdh_mr_finalize(). :)

> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 61e4f126addd..eb0de85c3413 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -609,8 +609,8 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  	get_page(pfn_to_page(pfn));
>  	/*
> -	 * To match ordering of 'finalized' and 'pre_fault_allowed' in
> -	 * tdx_td_finalizemr().
> +	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> +	 * barrier in tdx_td_finalize().
>  	 */
>  	smp_rmb();
>  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> @@ -1397,7 +1397,7 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	ept_sync_global();
>  }
> -static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1452,7 +1452,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  		r = tdx_td_init(kvm, &tdx_cmd);
>  		break;
>  	case KVM_TDX_FINALIZE_VM:
> -		r = tdx_td_finalizemr(kvm, &tdx_cmd);
> +		r = tdx_td_finalize(kvm, &tdx_cmd);
>  		break;
>  	default:
>  		r = -EINVAL;
> @@ -1715,8 +1715,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  		goto out;
>  	}
> -	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> -	atomic64_dec(&kvm_tdx->nr_premapped);
> +	if (!WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped)))
> +		atomic64_dec(&kvm_tdx->nr_premapped);
One concern here.
If tdx_gmem_post_populate() is called when kvm_tdx->nr_premapped is 0, it will
trigger the WARN_ON here, indicating that something has gone wrong.
Should KVM refuse to start the TD in this case?

If we don't decrease kvm_tdx->nr_premapped in that case, it will remain 0,
allowing it to pass the check in tdx_td_finalize().

>  	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
>  		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> 

