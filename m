Return-Path: <kvm+bounces-49916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0001ADF9A9
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44986189344E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A330E281523;
	Wed, 18 Jun 2025 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTq5XbID"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6CC1C2324;
	Wed, 18 Jun 2025 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750288194; cv=fail; b=dk3H29+rt5RkRSREbiq1tb+Uw7c8ycQ8AGcrnsQvP7s7bxKPJItkdvSKOnwUgrjuOi3XyoQHFKa6nkn6zx5odK/1qCf1lNoJVppLDMh5LjtMU5wows9Uu/8IQPzViijFDgNwXO+XTZg1vW9dZrovtwvC0vl+YYJxaULCHq1Eisg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750288194; c=relaxed/simple;
	bh=sdpVD8dhZ6Iad/pfDhJoZRIaiY1LqlMZ2/VEIEtnyWY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KHyJWiA4f/Fqm15hHWQS4ZlL6K10RaBJh7atMQTc32Z5emrx8CnzXW1Q3aK3XgLB+lBPYfLLvEvApJKrR/wlMFsm6Hym3/SV+kktDX2FesbQDjwUEcqFXuEF7nxA7M5vr5xnq9l97IiFRtyiQkjV6axZppdhsLB6Aw2MiFW9Bxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTq5XbID; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750288193; x=1781824193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sdpVD8dhZ6Iad/pfDhJoZRIaiY1LqlMZ2/VEIEtnyWY=;
  b=UTq5XbIDBqWgpNh7TzhN9aA6FR+haZ5mbwHFz2EQEXiSjEkQ+B3EuZ3z
   QUsrkMHj3YyOOQvN1ZuUesZ6K76g3ylgVdNh2bXgMNw21pFJPn/jhl98W
   sJJdUOvhLEvcFB8FMHvV2cTHrGI9E1Soc5qSSeGbu778gJ8wGHKLfOXA2
   rZNZynOtvVURXExMPwZq/rRhm/loGoRxqO3STvnl7egkdk9aB5ePvUQP5
   lQCd7tCCvcPOD1d8C337Dp9jjBrFOh3tG43ecGU9X/DtaYzdN9IXqvpQT
   mw7V1Iu06wS7AuBuBo31/X1r7DNn0fpzNbT3tF6kLR9TWDqPw07yQuNav
   g==;
X-CSE-ConnectionGUID: vTnEUQ8XRveBTWxBh/cBNw==
X-CSE-MsgGUID: XMIeS7/oThy7eJEoIfs4YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63883179"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63883179"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:09:52 -0700
X-CSE-ConnectionGUID: Ee4DT7XVR2G22eH5QVfrRA==
X-CSE-MsgGUID: eeOpm+y5S/yHBCfio/9DNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="173904006"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:09:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:09:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:09:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnZHkNZpsfEB4MXPDY9TbpZfzBCRLnSvD3eTj74McLXqTF+1v8+4wjbrAUWrdNeCVKSKDSW0xDxAU1nx0ih+ZtnCFZZzv8eY5vtCKX8djU/UsalAhCYYF4N4DDXIMOSH3fXkQwRoQh+OBm78jF+FIhGoQnoxKyai/cL5u5LXfhibTFnOTAbj6uds5DMGNcp4fSrDk4hzntXtBQRGwaCc1n5hWO76hNJhOX72OgL2sKJwao1WnE8idoQb93ND/4OkCMCm5yZ3Ejgq5Dmoouuq/GkYejz2Qn2oevArjy0b5x7RLZNzlajovr9I7eLW8HKUGBs3h2zkqn4K/6uGwOqc3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdpVD8dhZ6Iad/pfDhJoZRIaiY1LqlMZ2/VEIEtnyWY=;
 b=ECScYgVNQNTZ+IBaHi7Ivg4k2FPCGkb0bN8+g3K0Bxr4wpOBftPEjWYVFI81tBIxjjE0vMhwH4+QyO7jBY8hethyEFljuG+9HVHnjfvW2jOqSqoOKZcIILxk3eQHRcKjfFxDGpgwQXaZea8h0fVeN8dJfxrLLa9t6zv+mOnmgk0noMBzJ3AjS/MIFI6gST3vGNeyKsL4SoCyMxnCU33uLExUTGPtlG0kbrRLf0dbowc7CMK30iLa/cnbxwPIcVSef8iZcdL9MBpbrSU4y1cruTlxGC1h+KG3AqrYzE6JB1nnwXdhyyRD1ZvZNq5dbhWy2v30P4CRWXwN1gwvFBiz/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6478.namprd11.prod.outlook.com (2603:10b6:8:89::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Wed, 18 Jun
 2025 23:09:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.020; Wed, 18 Jun 2025
 23:09:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDpX31F9fykECcZZx9vdaxeLQJi5EA
Date: Wed, 18 Jun 2025 23:09:48 +0000
Message-ID: <83e34b6cfa1d25857a085db835a43459a1d6a97c.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
In-Reply-To: <20250618120806.113884-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6478:EE_
x-ms-office365-filtering-correlation-id: 8c7c9a2d-ad73-4981-5a7a-08ddaebd38f9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MmlrTElxUkZUK3lpZERwd1B4Mlh4aUlJMlZFNGdjSWRtUlpDR1hPbVgzOUl1?=
 =?utf-8?B?c0cwaXp2RFQ1MklORVVrK1VjeDlxRi82czNRRzVKY2JobkZObVVFRmpkQmFz?=
 =?utf-8?B?UzRFU1FaQVYvZ2RocWtDSXZmQXJhV1EwdlRGZDNCem5YNnJzOCs4Zm5FY01s?=
 =?utf-8?B?REpHT2kwMTIrWUhvRVNXNVMrMlI2RHRiRkcybitKQ2xPTkx2U1YzRWlDUG43?=
 =?utf-8?B?SGViRVJoeE9OMldqVVByL25BWVdjV2RXcUVaUW5yTGFKVGR0NEMzd1RnQitq?=
 =?utf-8?B?a0ZFOFV2VDhCZDFrckMremxYT3E5SHQwcVlsR2g0L3hPZDdDRDMrVGdxMHhX?=
 =?utf-8?B?aVRJSElORHB4QzkwQWpwSGVKM1o3RWdNaUxSWjNGZEVudllhSnBFR0hrb0ta?=
 =?utf-8?B?bTZmNnMxOFcwNkRhcU1Lb0Zvek9WY09MenUvajdiSktrOUw0eDE0VzhVQVhm?=
 =?utf-8?B?aVZCQjNCS3hoTVJjZEpUOGZ5V2J1TENiMXhvZnQyeU95STRqcHZUbjNkeldP?=
 =?utf-8?B?V2ZCWW05SzlCcHJ6RGRyY0ptR3dJTTZtN0d1S204c242dHg4aTF1d3pYYXZq?=
 =?utf-8?B?T29EZDcrb3B3bXg2S3IvSE9CcVZhb0EvM1E4ZW5xYzFqM0pZNkZ1bXhPb2Jn?=
 =?utf-8?B?V3U0TnFjZHg5OWw5a1pUc3NGVmVFSUVFOVJQa3Z0c2FVK3JlUUFYUEFMemlz?=
 =?utf-8?B?S0pzUnlKN0I3cFlpMm9DcGZaQkZSOGFBaHF1aDBsUkdsSTIzRHFVcFhhNzBt?=
 =?utf-8?B?NklKa1M3bDJSU1dncU1heFlNTTgyckUxbFg4bUhFd1NxYzV6Mnp4MUNreUEw?=
 =?utf-8?B?QTA0N1JyOXRMbDBBN3RCN1VmZ2pGYnVDOUJPL29VRDlSeVg5NHo1bmFPWnZr?=
 =?utf-8?B?dDNIYVA0L05sbzVrVyt5QW13S2NjbUUyL3lPSkJuRy9yTk1ZZDFraHNoNUFV?=
 =?utf-8?B?bStnTkFxc2NlYjFTN1JsbFd0cUQvSGxsQ0VleDhRMTV3NGxKeDd0cWh0QkZx?=
 =?utf-8?B?T3JnTXhuUDJyR1FqZE9OZXpXbW1nZlU5NGR5N0h3amVTZFhURE1tMll0bEly?=
 =?utf-8?B?djFuZFVrYVYxa21MZlUraDZqQnRsUThma2hoU2xjUWM0aU90aVJtendNaVVi?=
 =?utf-8?B?dXNuNkdDdGlMaHNFNjE3MXBvSEJiQzliOWxSQjdrMjk4RWMrTGRGdGtybXBK?=
 =?utf-8?B?cGFmaUVwclpqaHFWYW9ya0EzbDIvN1JWeXVNVnF5S3p4bFFpam5nbmY5Wk9p?=
 =?utf-8?B?OFUyS3B1OSt0bUN5WDNQUGVBcVBrWFc2UFlVeXA0dHdOcHhqWkJRZEVMcVNh?=
 =?utf-8?B?MldjM3lzTG8xQkcwV1BPMVJYakROUzVmVE9wbkVQUmpMekpPVC84QzNwcXgv?=
 =?utf-8?B?N0Y3L0Q2N0xBdzJWQmRjamJLb05PcmdJWVNzd3d0V2ZpWS9VU2hLV3VoUEJk?=
 =?utf-8?B?MmlydFhTTXA4WUdjbmZ4eEoxcTN6OVByNVpqOWhybFM1eFJxQVJ0RXZMZXlv?=
 =?utf-8?B?WERoQm9jM3BULzdyRDkvcWF0eGZ2R3N1QjVGOEI4NHhNN0JxSjZ0RlFWZm4y?=
 =?utf-8?B?OEptMnpCUzM4QU83ZjFwdWUrMVNwMElnbHhYYXRZR3ppZFA3WFBHMytlcTBJ?=
 =?utf-8?B?Tnl0TkFzUlRaMWFaZno0WjB3U3BjblI4Wnh5UXl1OWUvQjJZZEhycGd1R0ZR?=
 =?utf-8?B?RU5MbTE4UjRvdUlpUHZkcjVMWTNpdk9DVzNxWmQ3SURZSkcwd29CR3JPc0ZE?=
 =?utf-8?B?WTF0QlBWQjJ3MTB2c3NldVF2aE5ucC96L0lQM1pQemxZL25CVThhY2F6YjFu?=
 =?utf-8?B?R0dPd2lRLzI1cEYrUU1UdVlmb1F0VFp4b3lhM29NOC9zTEZuYkJuR1FES3ln?=
 =?utf-8?B?a2orNTBZWCtxMWIyaW8wSzduMWl0UDhXZjVGVGg1OEJ5Y2J6UGZTelBRVVMr?=
 =?utf-8?B?M1UzL3ZmdHFmWG80dmlVTUEvOXYyUXhQNDEvMXJ1ZHk5WkE4b0hrbDIwNVdv?=
 =?utf-8?Q?P+mOkZlYEJCEDVD40SWXaUJD0S/Rp0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWt1TE1uaDNMMTk4Uy9hbVRSeWlicVdSK1dXTlVPVzBrYWo5T0lLQk5QTTVV?=
 =?utf-8?B?VHNER3VGQzVWUTMzNE1qWXl6RzQzNm1NeDh0d0p3OWlWejhoZDI2Nks5c2F1?=
 =?utf-8?B?SEtZRjN6R0NYcURzMVVkdGl2NnBFb3lSRHYrUkN2cEl5Ny81MGlwN0JZbG5Y?=
 =?utf-8?B?Nm8rdVhDem90N3ZDaDZqekVZMmp6Zm9vcXBGZEJ1T3N2SGR0VzBvMExGTEhN?=
 =?utf-8?B?aDFkbEFBZ3I4VWxDNTJacXZ2bFl4d2VQcFFCaGVINGpLdko2bHF2M2ZCQVZx?=
 =?utf-8?B?WUtKcnBNMThVNkNaWG8xVU5QUGFWazQ4S3h1dnhPSkZ2QkRqcHFIMjJKWStv?=
 =?utf-8?B?QVNEY0hkUEU2S3NWS3UwVFFGQWVVSndSUm05d0duWHJhQnViZldvVHRwcUEx?=
 =?utf-8?B?emsyV2Ixc0FnaStIRmRwaGdHVHh6MzU2ZEhoZDRKNzFvUlgxdVJrRTU4QTFs?=
 =?utf-8?B?VTJOaGVHSVpONjJUaDVtZmNEMkRKV1hnQldqQTFjQ2NCTWtUN0lZVnpLU1M3?=
 =?utf-8?B?b1J0Y2k2T3BNMGtrczNsMW5EeCtDYmNRRUl1UVVLcVpaVGtqZG1mSzRraWJN?=
 =?utf-8?B?b2hGQXZWRTJ3cVBvOVRQc0tEKzB1NE1hUy93NlI4TGk2Q1FEU3VqdHNxYndV?=
 =?utf-8?B?VHIrTEM4dEpJeDk2eXloTlJ5cFJ4UU9pd2pSVkVzbHUwaXE1UU92OXdOdVBh?=
 =?utf-8?B?Nlc3eTUvQlZoV1VudXNVNHN4MVBMNHJpVFptNUI0REF0WG5seVBlK3FPZGRJ?=
 =?utf-8?B?TFBWNmpXbDdFQVE1VFV1b2N3Szcxa2VjVjFEWTgvODR3SWw1Sm9YOWJaVmEr?=
 =?utf-8?B?dXA2a2NPTWJvMHdTVmxWY3dXczhXVVVZYm1rSXRyWml6Wm9BSk9BdzBWWG9Y?=
 =?utf-8?B?N3Q0Uk9ud2ZjdWJoajk0WEc1UVp3OG1aM2VWZlF5b2R3RDhxZ3UzVnRDU01C?=
 =?utf-8?B?bzhGNytGSHYxMTVYcHRMSFlLQUlEYSsyemJuWXpvcGpjUXQ1aGkveEZPK0l3?=
 =?utf-8?B?ZkVyclhVUlpPYUROTkpoclpwaDhxTzgvdEZTY0ZHQUVIdWcwMXUrZ2NNNS9M?=
 =?utf-8?B?Z3c4dWJrNmovYUNnbWJUbzR5U1BCZ0ovTmdTYldhdjAxUjN3RTd2RWxVazIr?=
 =?utf-8?B?NVhDS3NMWVkvSEU4bVBVQmc2WVhYcmRKQWxTZ3M1WTVtZWxUeGN2bE9rMnN2?=
 =?utf-8?B?My9pcEVodlcwWDBOL2Y5MExPaXpnZTlVNHN0c3dDODYrWkdpTklmV2RTTTB0?=
 =?utf-8?B?VEd3MFJBZDNQbmpXdk00SEk4SE4ySXkyWHFaZ2d2MnN5VUlUUHVZRWhlZUhw?=
 =?utf-8?B?a0JCbXdtRGVHL3VqMnY5VG5VTG9XQ2U5c0FhVmxxQVlEMHdKV1VYSWF2b3F3?=
 =?utf-8?B?eGlmbGtaMjZvc29ReVRjMjViY0FaWmJiMW12OXNZZUVqRW12MFQxSlp5NjR4?=
 =?utf-8?B?Q3FXakxiL09VSXdaUFZGZ0NGbHcvMkJvNGgza3BQRk5rNGdKOTFudzFyR05r?=
 =?utf-8?B?c05NOWRuaERUZmxJMU5aWUp2ejhOZWRzZEhGQ2gwZ094VUtTV202bmRlR3cy?=
 =?utf-8?B?S0JKaHROQ2xWaTVnSU1SNXpmYk1BUlhDMHNTK1B3R0cyYnZFMlF5Wnc2YXVS?=
 =?utf-8?B?cStXaTUraWt4YkVydFl1RW8yZzNKWHlIMGFIWW1aSDBWeFZIQlROcjFmVzFz?=
 =?utf-8?B?aGRHUVZQckQ2b3FqUXhNVFI5Tkp0K0gxY0FRaW5YS3JTQllHdHhocmtxbjhS?=
 =?utf-8?B?TkY5RGplSUo3NW5kUm8wYlN1ZTN2SElwZEpCODNXTVpsTmdxUnBJMHJQcVAv?=
 =?utf-8?B?c3krT2FNU1I5VThPRnVDaTMrWTFFaWdlVHVyM1JMbE5YSEFCL0ZicmFOOVZ4?=
 =?utf-8?B?V0NCMTU5WG92YjlMNUZvN1IxUzM3VWlNcVkxU3puY1cwY3ltMzczbEE5ZGJn?=
 =?utf-8?B?Zk5iNlA5QlhqODdDbEVDV1lQdUhPUUZ1RXRheHE4SFpjMVo0aXJMS3hlcVFj?=
 =?utf-8?B?NnFzcFBtM1RIUWtoeHJKNHEwUEtiQ2tubGNZZmxqOG1yS1NCdG16bHhRYWlh?=
 =?utf-8?B?RHRYMHBJWjZrMWdMSkpMLzZrNE55SEx4Qkl1ajM4WnhZNnlBbTZzZWxHZG54?=
 =?utf-8?Q?M+VIMRDzk1MAV3kdm2hm+vtra?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DF35F13E9CB0348B60BA2C4295E321B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7c9a2d-ad73-4981-5a7a-08ddaebd38f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:09:48.4015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZCVgPR7a37qF2Gnakprjx41J+jXuhUAmnK0YSzMJwSbMgPJv47QEkBBzvZZHFY5wC/1poQA5degI0hHJcmUJCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6478
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDE1OjA4ICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gU2tpcCBjbGVhcmluZyBhIHByaXZhdGUgcGFnZSBpZiBpdCBpcyBtYXJrZWQgYXMgcG9pc29u
ZWQuDQo+IA0KPiBUaGUgbWFjaGluZSBjaGVjayBhcmNoaXRlY3R1cmUgbWF5IGhhdmUgdGhlIGNh
cGFiaWxpdHkgdG8gcmVjb3ZlciBmcm9tDQoJCQkJCQkJIF4NCiJ0byByZWNvdmVyIiAtPiAidG8g
YWxsb3cgdGhlIGtlcm5lbCB0byByZWNvdmVyIj8NCg0KPiBtZW1vcnkgY29ycnVwdGlvbiBpbiBT
RUFNIG5vbi1yb290IChpLmUuIFREWCBWTSBndWVzdCkgbW9kZS4gIEluIHRoYXQNCj4gY2FzZSB0
aGUgcGFnZSBpcyBtYXJrZWQgYXMgcG9pc29uZWQsIGFuZCB0aGUgVERYIE1vZHVsZSBwdXRzIHRo
ZSBURFggVk0NCg0KIm1hcmtlZCBhcyBwb2lzb25lZCIgLT4gIm1hcmtlZCBhcyBwb2lzb25lZCBp
biB0aGUga2VybmVsIj8gIFNpbmNlIG5leHQgaGFsZg0Kb2YgdGhpcyBzZW50ZW5jZSBpbW1lZGlh
dGVseSB0YWxrcyBhYm91dCBURFggbW9kdWxlIGJlaGF2aW91ci4NCg0KPiBpbnRvIGEgRkFUQUwg
ZXJyb3Igc3RhdGUgd2hlcmUgdGhlIG9ubHkgb3BlcmF0aW9uIHBlcm1pdHRlZCBpcyB0byB0ZWFy
IGl0DQo+IGRvd24uDQo+IA0KPiBEdXJpbmcgdGVhciBkb3duLCByZWNsYWltZWQgcGFnZXMgYXJl
IGNsZWFyZWQgd2hpY2gsIGluIHNvbWUgY2FzZXMsICBoZWxwcw0KCQkJCQkJCQkgICAgICBeDQoN
CkRvdWJsZSB3cml0ZXNwYWNlIGluIG1pZGRsZSBvZiBzZW50ZW5jZS4NCg0KPiB0byBhdm9pZCBp
bnRlZ3JpdHkgdmlvbGF0aW9uIG9yIFREIGJpdCBtaXNtYXRjaCBkZXRlY3Rpb24gd2hlbiBsYXRl
ciBiZWluZw0KPiByZWFkIHVzaW5nIGEgc2hhcmVkIEhLSUQuDQo+IA0KPiBIb3dldmVyIGEgcG9p
c29uZWQgcGFnZSB3aWxsIG5ldmVyIGJlIGFsbG9jYXRlZCBhZ2Fpbiwgc28gY2xlYXJpbmcgaXMg
bm90DQo+IG5lY2Vzc2FyeSwgYW5kIGluIGFueSBjYXNlIHBvaXNvbmVkIHBhZ2VzIHNob3VsZCBu
b3QgYmUgdG91Y2hlZC4NCj4gDQo+IE5vdGUgdGhhdCB3aGlsZSBpdCBpcyBwb3NzaWJsZSB0aGF0
IG1lbW9yeSBjb3JydXB0aW9uIGFyaXNlcyBmcm9tIGludGVncml0eQ0KPiB2aW9sYXRpb24gd2hp
Y2ggY291bGQgYmUgY2xlYXJlZCBieSBNT1ZESVI2NEIsIHRoYXQgaXMgbm90IG5lY2Vzc2FyaWx5
IHRoZQ0KPiBjYXVzZSBvZiB0aGUgbWFjaGluZSBjaGVjay4NCj4gDQo+IFN1Z2dlc3RlZC1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBGaXhlczogOGQwMzJiNjgzYzI5OSAo
IktWTTogVERYOiBjcmVhdGUvZGVzdHJveSBWTSBzdHJ1Y3R1cmUiKQ0KPiBTaWduZWQtb2ZmLWJ5
OiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCg0KV2l0aCBjb21tZW50
cyBmcm9tIFhpYW95YW8vRGF2ZSBmaXhlZCwNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCg==

