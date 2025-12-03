Return-Path: <kvm+bounces-65182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4910C9D74A
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 01:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CF7204E3E14
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 00:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB6E1FA178;
	Wed,  3 Dec 2025 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="byyjmdOl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9946B200C2;
	Wed,  3 Dec 2025 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723040; cv=fail; b=ow1VRaROCXoxyAUtKgyN25XFKYIl/yDy9kHLfgaIHgnau7XNVM7qyMYOaGoaTC1BB77DLwgFkkZ08DBlCL5XBO1UJ69NkNlXWp0e11k6jmcQpoJ8GivacbG5PvMmw2qsalMQGpucePtwQaJZyEk8XDeyMAycGxlUxPCUwsWzGEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723040; c=relaxed/simple;
	bh=Z7dsUNoLWasWUD77fsBxmGVtpo1CbsqSKwf575xQs78=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EveJNjPiNvTtgeNHr0Jz4s5neF9OvPRpTUjwHM1b15mtDkZfSLbkwSvEPd73FdB7ZV19Wd1iOYmTQ3Q5eYlTQKLXiDX5n7yKuWrJj/bFGhUiS654/5f/jHb5ufuNTGtL7eyEljS61DsRsUZ8PhFT0MvM0WHB3qg4pEnE6nxsrSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=byyjmdOl; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764723038; x=1796259038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z7dsUNoLWasWUD77fsBxmGVtpo1CbsqSKwf575xQs78=;
  b=byyjmdOlR4pyXrmKyILi0yxl6dArS4UOSyf6ObW75egPM25BlJsmFNmU
   8JqWCCi7FWBcICs4JbgpZzc6G7gEtRS9YF9+vd0jy73WwoKJlyfnpwusW
   vSDS0CRdkK4mQBMBybXGFOGTYU/Jq57nbiMKDw+91nlhP27sNvSLP1Cgm
   NGAVgSrj/QQyDSq6cDdiItNu43BHoTB8GY/85WlQlZrPKbef2MIujapwx
   Cu398HGCCfI5bf7NrdNYjEwi8sIUPgarzAfoYOUAaamV6GPEaGqV79KOm
   wDgzNOw59J7gFkqkOVGW5Qr6t1/DWPH5vJgKvwTgUxxsLctRbV9mxyxjS
   Q==;
X-CSE-ConnectionGUID: Mxm0rxjrRH2dpwFVKFGOsQ==
X-CSE-MsgGUID: SNEgMY8sT1+sydiq1SjhpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="70565973"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="70565973"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 16:50:37 -0800
X-CSE-ConnectionGUID: JIlWXMeJS1e85YjG81Iw+w==
X-CSE-MsgGUID: +0vFtXOjRQyWGLHu9OWSOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="199475206"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 16:50:37 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 16:50:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 16:50:36 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 16:50:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xR/EZyjqDnIk6zO4TKYVDuvWBKKxXT626tFpsgPgYVG1/YXwNTxDSePTw207b2EyAbXuWY/nsrLLDB/P3oj5TULcme7BGWzaArKDPnQuPTZAd7SBcGWygL1G9FXrdx2QQR/IQlBvJRIK9gSQMC49LDR6reIPwOOU8lt5h9P2k9gD+acf+RAQCwAFPxHj/3bRsrKwAPYyNJ3SZkLg1hVIGRLZduNMXwBpLmsMjqr7UEzjvMnY+b5MSAHEfOEL9woAT3m/d43tI47N10olNlAf86Ap70oVzvKAyK1KfrBcUbmcPMjLlX+QTyKL+YeXkX/rC9HsJLRzBiiaVT0VfBb6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7dsUNoLWasWUD77fsBxmGVtpo1CbsqSKwf575xQs78=;
 b=l3Z1kO4pBUhkeZ4jBcWWnxD3o39j8a7ajptOPU7GgGg1B9Fp+giX+81Npi2LjfzHVz9oWZR6bOca6iqoIlZvLq1d06W941r5Y7p/Hy5T0smRI6ua6E3h12tBOVb+9/GB9IjC6HyqTrJf3FZ456t/GL1ggS5aJtKTEGnv9+f3h3LTBLC73cH7rVRDLgkhRvtMiANFS1vEJZ2zlRKQrC/Em/BgSb56NzxaPUYqqFxEMxa0EqPDTFUQi5fzAbQ+7FBMNQvel1nk1Py7RL1+3dUMcuDuieOfH92MWXif+v6CGoMnWubPc6c5Nxp8DfEVY6oHm+5wNysVA0F6zJuwv7jukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW3PR11MB4700.namprd11.prod.outlook.com (2603:10b6:303:2d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 00:50:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 00:50:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>
CC: "shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kohler, Jon" <jon@nutanix.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcXjY65nOVz4wgDEaWpdjNjSzcGbUOG28AgAA+9QCAAAkLAIAAJLGAgAACdYCAAAyTgIAAigsA
Date: Wed, 3 Dec 2025 00:50:29 +0000
Message-ID: <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
	 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
	 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
	 <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
	 <aS8I6T3WtM1pvPNl@google.com>
	 <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
	 <aS8Vhb66UViQmY_Q@google.com>
In-Reply-To: <aS8Vhb66UViQmY_Q@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW3PR11MB4700:EE_
x-ms-office365-filtering-correlation-id: c52f2317-ccc1-4f39-aa65-08de3205f480
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YWQ0WFhOdVZsWkJXT29OZ0V0V1l2UTIvUDkxUXBqQmVVWnROL1JRZGV3ZDNl?=
 =?utf-8?B?cEZVNjBYV0duMDh6QzRmZlVjQmdYbWNocERyYWZwbXhBTVF1MzhqbTRBS2Ju?=
 =?utf-8?B?V0tGUEc2REpzM0tOdGJ2RjRsRWtjaTArTCtlK2ZQTkJDYmdFQ2xKTHlPSktS?=
 =?utf-8?B?dWJ4UTArSVR2UHRuV0tKaEZmVkxVU1gyYndKVmhYc0FwbVV6dERmRDI0K2pT?=
 =?utf-8?B?UmdUdW1kSlJjR0xkcTAyS2dxemhnd0ZkVE5yWXB3VXdEeE5QcEE2UmduL1Zo?=
 =?utf-8?B?YnhGVE1mcE1vampYY2h3cUZoOXJaWG5CMTVRMWUrKytnQlJDcU1ZVTdvb0ky?=
 =?utf-8?B?NHdlNU8zWE1CTHhOQTZVeDJpby9ySmFCRjdzR3RTTEVUb05ka25SWUNwclJJ?=
 =?utf-8?B?REVOMXlyZTN3dWl4R2FiL1RNUTh1RG1FckhNanpBYytxaWNoV2hpSEQ4TDl0?=
 =?utf-8?B?VStRdXZ2TnRBVitFSlpHTUdsaGxsZTg4L29PWk1saWdJZ05iUVpUR2p2QVFm?=
 =?utf-8?B?VnJJZGV6TWtVTTNLeDlUM1dNTElPRmhwYXgySE1ocFdYTytXa0x3RENUUjNw?=
 =?utf-8?B?Q3F4ajVmY0xZbmFGdnJHYnlzZDlERENKYXJ3VG90NGlld0krYWVlUk05dEt1?=
 =?utf-8?B?VmhyNlNheWtLeHNBbUc0S3oyTmZLQjgxakZoRHdFMmgwcjBRakM0eGVPU2oy?=
 =?utf-8?B?b0d1RHI1Rk11SytGWWJEVGdmcnhnWmk3MDdmZkhDMVFSNy9mbTVIVytQRkVI?=
 =?utf-8?B?cGlGNC83RmE5VzcvUzJZZW12alpwcUJSandUTDhPV1A3aGlReXJjSjUybEt0?=
 =?utf-8?B?d3hpWjRCREs3WmwwYnVIc3FGYTJQcUszYWhZUDI0Z1dSSXlTTS9SWFpzNzEy?=
 =?utf-8?B?eUlGZ2gwQVUvMXI5bGZ5WHNJRk9pWm9XM0FOU0FGQVdOVDBUdDlUbGIvTFEy?=
 =?utf-8?B?WlRqdXRKeUpnbmV3UkxpYVN2L001cmtVdm1ZeENBQTNjQVphRnZrc2hOejNJ?=
 =?utf-8?B?NUVUNWtiZGlMTmloWk45MzZ6dytwZ1lTazFCNll2VmtCSk1lMFhpTlJOVW9m?=
 =?utf-8?B?VU4yWEkxS29hQ1B5dnVFWTBIbVFGUHk2anppaTlqUjhZczBoUThRS1B5VjZ6?=
 =?utf-8?B?V2VJenl0dWFtckNYMDdXSnpYTVYxdHQ4K2hjdHh3RXNHNkJDdTVzZ1FPdXBE?=
 =?utf-8?B?VnZNOUVXNmxKV2hqSnBTUXp0SlhqUXEzV2FqL3FOWHU3WHpSMEFzQjVIZUUy?=
 =?utf-8?B?TXhhUGxGeFdQcVdnRGtrR3BRNUxkYXlYUnZJSXpQQ1RGM1k0aHkwdTU4VFNS?=
 =?utf-8?B?ak1QZ2VrbHEzRzF1UzlvSmpjcmdVT2Z5bGw1RVcwdW55cDhWeHVUMUVFUUJZ?=
 =?utf-8?B?WWI3WjNsLzVBM01Mdml3U21VYmhhT0ozQy9lcWQrM1dFV1dnTzVoTGRlbndY?=
 =?utf-8?B?RzhIOGdSWEdIRG5KODNCQXNoN3dNdzZiT1dOaVhuWHQwUWdXWUNnZStoN0ZT?=
 =?utf-8?B?Q1hnQXdDVnQ5SnpyRVlWdUFGSXpZOWJMUEF0TFZEVlAreXNYU1l6SmFFalpY?=
 =?utf-8?B?L3lzVmFoVUlHRGZZNnF0RFc3bS8xc0dHU3ZJYXR4Nlh3SExVM0hERWhqT0tY?=
 =?utf-8?B?K2RFZkpkWnFUcjhIY2dQMGpXN0lBanZKamw0MUwyeXdnZ25VMURvREd3NHFU?=
 =?utf-8?B?azFaM2pjUW50ZElINUlVRVZzWXRaSll2WTFRK0Vtd1NKSmIveDJEYm5IU2FR?=
 =?utf-8?B?Zm9iZWhaWlV2MjBIQkp4VEo5YmNtM1R6cHBEbC9MaUtjYXV1WW15d2laN1o2?=
 =?utf-8?B?M29XNXIxR0pVUmxtU0M3S29laGhyK1YyNEVMVFIrZTVZR01TQjQwRUp6QWQ5?=
 =?utf-8?B?VVFMV2FqQ0t3R3RqMm1hN3hRU20rRTd3M0lscEZSU0VZTTlvUlo3YkJteUpy?=
 =?utf-8?B?K0VaR1BCbyt0MkwwNWJGTGFEeCtydkhJU2QrZWRzUGRmMFpNcllnc25raHhM?=
 =?utf-8?B?YldmeGpIR3JpR05MZjU1aXQyV3hKR3dTOG9wTXVXUEhvYTNVZS9MUE4yMzdu?=
 =?utf-8?Q?FPVvwM?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk5NK2MrRG1JZW4xRDNjWHZsV2lTcWozVlZYTkYrOFI2WWlKQnAzS2tZQWhv?=
 =?utf-8?B?MTR3cGN0c0J0K1ZPdzVpS0xNelVnd2hZLy9ncHRhU0ViK3dkcHJ0Q0hkSGxk?=
 =?utf-8?B?RW90Y21zRU9RKyswdTV6ZlQzdmt3UW16Qko0eEhWbnM0eWRHWTZwYVlZMDU5?=
 =?utf-8?B?YVVxOW5DdUliOXF3ZkliUEFGaUUyMysvNENkZVRDOW1Vb2dVN0tHSDgwUHpy?=
 =?utf-8?B?SG1zZTJvOEEyQkFCdEFsL09IZVE1WU5TNU12TE8zaUptZmhiNVRxT2d0OEFU?=
 =?utf-8?B?MUdYNE81ZldrQW9GS3IwTmxNSEp4Z1JrWlJOL1Q5TWFIM3hCVjhzRFpBZW4v?=
 =?utf-8?B?YmJLZjVkek91QmpPRzJWQjA5Vk44bkNDNGhNSGpvZzNwb21Mc3l6dHEvdlZQ?=
 =?utf-8?B?MktpNG1Td3pGNTZOYmg1NE9JcVRQWitpK3VqTHZNVzZhTnNDdTlUOTIyTHRW?=
 =?utf-8?B?eEFtNno3VTNjQXFMNnY0RXFwMWw3Wm1RaTh2UXVaMG05RGwzVnk0NGFSV3p0?=
 =?utf-8?B?TUxqeHpkNjdZa28zQTRYZ2p1N0tib1dOMUpaS1ZMVTZNaDdQUWJ0SWlWRmdN?=
 =?utf-8?B?d2kzcVoyQUJYR1VreG5OMnEydkxZenJ3cFk3UkFJU1ROK2ZpR3hOSWlXZEky?=
 =?utf-8?B?RXRieXdGaVNiOVlZREs5VGdmdnMvSVJ6b0hIL1JyQ1ZFUFp2R1owZDNrVUls?=
 =?utf-8?B?Q3VUNUtCRmJNYlY2OXJMWXppQ0FtV0pPK1lYYlBCUEdxbUtWTy94a29oL0tS?=
 =?utf-8?B?RktpUmxzN1pJSXpkbUJ3YVlTS0tBeVBINW9FVHJia3FQMHozdnJjYTduV1Za?=
 =?utf-8?B?cDgxc3k4WlhlK3NqUnhydnhtZEpaUTVxMnNUY0ZWWWM2a0JabkdzakN0OWh3?=
 =?utf-8?B?WWhubTVwSmNLQU00NDZxS3ZpVUFGendWL21IMnZWMEozQUc1RncyMW5rRzVx?=
 =?utf-8?B?dk5CYWlMSDd6YlBSeGNDdk0vMUZCb0hoN09HeHdpMHNkOWhGYTJpeEgxMUJk?=
 =?utf-8?B?SnlCcjdveWMvem9QZEZVdTMzdFFWQzNMdUY3VTVFSGxEems5bTlkdmcyRklw?=
 =?utf-8?B?OCsvS0pGUTNpM1BjNG5MRkpaSmtKdVBMbEl1R3kybUk4V25RRkc0RFl5ZWd4?=
 =?utf-8?B?V0VaSmoxN0lvYkMzM1d1RzhJblY0ZUxHbG1ncWhnRm1hbmlSV1A3YnhuWFVW?=
 =?utf-8?B?T2lSL0JpYnZJREdCU2xwdXU0VGRLMlYwQ3dSMWNuQnVCOU5aNmRsTUlwTHo3?=
 =?utf-8?B?Sm94cVRUY05KTlcyTGQ0T2liaXlpbDJkanllVzdOMjQzS3lqcXRYZnFlclFK?=
 =?utf-8?B?OUpYVTdKOXdwRndERUtPeHVyazVveEN4ZzMyanNSYjFWYURVNkQ5akVQMXZj?=
 =?utf-8?B?b0g5R01lZDE4SHpTOHBhNmFQZjZwRUE0U1FJN2EwTkc3eCsrR0FIdEMzd3p3?=
 =?utf-8?B?d2d3bDZDQlVnYU1HOFlCaDhpcVdxdmFVSHJZRnIwVlRoYWZSQ0h5eEFuL0lL?=
 =?utf-8?B?RzdMRGxJMzVwY2Z4dzBJOUtHbGIzQlVTUUl0Wit4UndjdUVnOUo0TCszSCsv?=
 =?utf-8?B?b1VoTU9tejR3K1FwQ3RTWHFUVmNZSk1nVWtoVjIzdzcyN3M3OFB4ZU1QUEVl?=
 =?utf-8?B?WjBxMzBDUWN5dk9Sdi9uN3FXMkVHbU5RdmFhQ1JJL0JsR3JSeWNnckRaajVY?=
 =?utf-8?B?RUxCOXdTUFFqenhHS0dRckIyeVI2WjFZU3hwRkdqVE1TR1pidGNLdUZJVjVx?=
 =?utf-8?B?UVVaUGZwYTdjdCt2cVducUIzb1Z5S2VLN2F4YU94YXJjNEorR3hUNU9lZHpy?=
 =?utf-8?B?WUN4OXByVzlwUlVFczNMZVFiZ1B0bWVwTW1PdUxHd0R6eFk3OVU0dW03TU4w?=
 =?utf-8?B?UUpiTit2SXR6Wm5laFVHMGFmczhoZTlvV1NlSU9yU1FRRTI5bXBuVm80SWtk?=
 =?utf-8?B?cnZrVUphYVhXNXNJOFcvWVdVNjRiWFZlTGNKNFZBa1l5b2QxUDNBcTZhbWZ1?=
 =?utf-8?B?VExaYm5NYk1OTlpsV0NyR3JkS1lXSEdybWxGeXd6d1ZFQ2RQalRpTkQrWWVo?=
 =?utf-8?B?VVU4ZFkwWHF6Vitnd2R5bU5ldkhyY1ptOWJJeXZHWlY2WEpFSFNnR0Fsakow?=
 =?utf-8?Q?WsxLnGAa8+YgVcaxPk5nYYr01?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94EB7FE8F1C3FD4E914437AB307E6060@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52f2317-ccc1-4f39-aa65-08de3205f480
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 00:50:29.0903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1deBesr4yT9bLaXfI6SJ4jAP/T6bFJksjgHepPxW9hxFkAHfcHWG9kW3hw6ww5rYlBBVeqtzPbs5Qr5PC7Wyug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4700
X-OriginatorOrg: intel.com

DQo+IC0jZGVmaW5lIEtWTV9YMkFQSUNfQVBJX1VTRV8zMkJJVF9JRFMgICAgICAgICAgICAoMVVM
TCA8PCAwKQ0KPiAtI2RlZmluZSBLVk1fWDJBUElDX0FQSV9ESVNBQkxFX0JST0FEQ0FTVF9RVUlS
SyAgKDFVTEwgPDwgMSkNCj4gKyNkZWZpbmUgS1ZNX1gyQVBJQ19BUElfVVNFXzMyQklUX0lEUwkJ
CShfQklUVUxMKDApKQ0KPiArI2RlZmluZSBLVk1fWDJBUElDX0FQSV9ESVNBQkxFX0JST0FEQ0FT
VF9RVUlSSwkJKF9CSVRVTEwoMSkpDQo+ICsjZGVmaW5lIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBS
RVNTX0VPSV9CUk9BRENBU1QJKF9CSVRVTEwoMikpDQo+ICsjZGVmaW5lIEtWTV9YMkFQSUNfRElT
QUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUCShfQklUVUxMKDMpKQ0KDQpJIGhhdGUgdG8gc2F5
LCBidXQgd2FudHMgdG8gYXNrIGFnYWluOg0KDQpTaW5jZSBpdCdzIHVBUEksIGFyZSB3ZSBleHBl
Y3RpbmcgdGhlIHR3byBmbGFncyB0byBoYXZlIGltcGFjdCBvbiBpbi1rZXJuZWwNCmlvYXBpYz8N
Cg0KSSB0aGluayB0aGVyZSBzaG91bGQgbm8gaGFybSB0byBtYWtlIHRoZSB0d28gYWxzbyBhcHBs
eSB0byBpbi1rZXJuZWwgaW9hcGljLg0KDQpFLmcuLCBmb3Igbm93IHdlIGNhbiByZWplY3QgS1ZN
X1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCBmbGFnIGZvcg0KaW4ta2VybmVs
IGlvYXBpYy4gIEluIHRoZSBmdXR1cmUsIHdlIG1pZ2h0IGFkZCBFT0kgcmVnaXN0ZXIgc3VwcG9y
dCB0byBpbi1rZXJuZWwNCmlvYXBpYyBhbmQgcmVwb3J0IHN1cHBvcnRpbmcgc3VwcHJlc3MgRU9J
IGJyb2FkY2FzdCwgdGhlbiB3ZSBjYW4gaW4ta2VybmVsDQppb2FwaWMgdG8gaG9ub3IgdGhlc2Ug
dHdvIGZsYWdzIHRvby4NCg==

