Return-Path: <kvm+bounces-32486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F919D9020
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 02:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4644B28C5E
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4438E10A1F;
	Tue, 26 Nov 2024 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUv8yXHs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30FBC2ED;
	Tue, 26 Nov 2024 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732585430; cv=fail; b=r3azukfeBI89+ACkPAo8+jNGjjC8pcrhksVm8K6rxaVAPJUgSPjq8Vfu1ZJF1BsnsL5ljho42ufwT+Eq3/gWXY+fHfLs769pT30CmO4CtvEDFzAJ7oS1Q8BNHmiMwQS8DfIVK4LWNgnoHKWYeEEqhxtV+9gn4U7J90FUL96I9jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732585430; c=relaxed/simple;
	bh=lIaWJJOjIjyphlwwIlHg+sj3aJ1DTr9EEPqc1Kvducw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eQ3DE5SISo7Vp1jyxZ883HR+L7nZyWLVAIIvsB5HWpj1gLrJK1wvP6/RGB5WimoCQgCa0UcV9D7S5FjhEeJC1jIks2zix70Co217bOvhslSj+4Hr74CNil+9wIT291mTBAwjyZuPzwbJJdeDThmsKe/ahZIM4yinRfuTMPav5JA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUv8yXHs; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732585427; x=1764121427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lIaWJJOjIjyphlwwIlHg+sj3aJ1DTr9EEPqc1Kvducw=;
  b=hUv8yXHs+B5fuT4poO9fY2m8eyt9nsB5Des475ThNqicM1Fbzf8Wu9qc
   Hfwu2SHiIJdZEvc/KR3wNafrBb2c6ybkNcqqFkF/mTSqBwIMY5jJU1CMQ
   /NSV3MK+5LMZ1xtUdDN8I5hLhNhkcCyQUBC/oBGoe/XtuRG4Qa+se0qPy
   QpBbg3gEsYQRrF9Luy2TZZOgeQ6IhknksQSwe3y7nPXw4BG3glz8MprtI
   vJFOZislrzgsLh+s/jr4XJhejyMt0ITEitEBGzTYXueUKo7peTP09j5NS
   JUzleYJRJ3HRm5i/bD23HMgg/Ud+BUIO416EZC8fmxpKq9TO6GmUHCOsE
   Q==;
X-CSE-ConnectionGUID: 8YNuRZ8iS4CUoR9KMDPyfw==
X-CSE-MsgGUID: 7YwGmnKhQmWQ+NGaKZX7bQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43216822"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="43216822"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 17:43:47 -0800
X-CSE-ConnectionGUID: g4BzMjoISjCuIFsmC/3NGA==
X-CSE-MsgGUID: m4hoJ8S8R4yHt/RyKvRbrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91393272"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 17:43:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 17:43:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 17:43:46 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 17:43:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COtJXKLk1Dtaac8oujeOMsyklZY2O886F4J8NjSfWpDNeN+j082GoxAx2XeKl94FFPdivFuwHalLdhDtU/NgH3ZOVvbail05i9GoMNUB2aTf5EhvaVV2S3tnfQ035TdPzFiYDSIH6FypBn5m5OLCUHGsdaal0hggwQS4PX29S/7P1hqBrwYcmxOsLnVP8a8pd4smvG+tT3jeCgtknsrVrkW+h2y8+8Zp+gxbM8Prtf5m3psVT6SdgRZBzyb3aIdIEgTd4TlvGgqcgRbwBtS6J/s5p5twSY1CaaMMxXUAPukZFRKwRU4YktOB3qqr6wBqWM3E3FLvjwiBdfjsBsu42A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIaWJJOjIjyphlwwIlHg+sj3aJ1DTr9EEPqc1Kvducw=;
 b=dXknL26oXf55mkxjF/jJxF8nPTWAdrIicQv/92qL0kX8f7tEorZmVXZ6JDYROl0PK0HKtLpfQ8vLnDklpL/kUfCqAB+3va/1Fbb/7Ru5fKvypZvryHPhAvnUklA8FLuN2q94ssI7GaP40Io5GDnOK22REa4dBF6tNicYvByxnCzZ9kgOkeYDozhSomlGzcUo2f2vT1DKFkKdqqcxviCRYPlYNWYeztcSUaHLD7Arp18LCl/YXDHwiQsT57zaopq6j8NQWm5tPymLMBvbkuE6arGx+VZvGDQntHSMw1z9W8FYsrC8V/y2QA/b75/PiFjqa7U0TYHu8VVl/87tfVaWJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8526.namprd11.prod.outlook.com (2603:10b6:510:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 01:43:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 01:43:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Topic: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Index: AQHbPFIlIBknYlpwZEWiEupj6OInArLHOU8AgADo4YCAAEuvAIAAMrkAgAAv/QA=
Date: Tue, 26 Nov 2024 01:43:43 +0000
Message-ID: <23312b6b74282e1582b6b371371664446fc27835.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
	 <Z0SVf8bqGej_-7Sj@google.com>
	 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
	 <Z0T_iPdmtpjrc14q@google.com>
In-Reply-To: <Z0T_iPdmtpjrc14q@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8526:EE_
x-ms-office365-filtering-correlation-id: 1344f795-031b-42e5-bf1c-08dd0dbbc296
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Wm5VRHlZOW1kVzk4UzhOMkdQU3RTN1dSK2pkaXFXcitIdWpQVmRpMUdhOXNn?=
 =?utf-8?B?eVBKVGJta2RObElYQlZuQWFSdlFOeDFoNlJGdUQzUFJNdC9VcFJHc3U3emJW?=
 =?utf-8?B?YlFHVktPOXR4UFFyOTcrYlNreGJWMWYrekpuaGtISXNxcy9nN1EyOWtmaTRM?=
 =?utf-8?B?Z25XanVGSGF1MzNrRWxJbmhkNjZXNXRCcWdocit6a0htdlhEUE84aHFMUm8z?=
 =?utf-8?B?dzhFWlA1NzZIbVBRazVNTUpUOTV1QVY2V09mcTd4NU84K0xZUUtkNHRCNUJK?=
 =?utf-8?B?d01EU1lOMmdTOHNvcDQ1aFNPVkVKQk5QazlUR3VURTQvVUpGMnZzRVhCd2pF?=
 =?utf-8?B?enNMNUxlYUs5RW1sUGM3ZjBLeTZDN0U4dUVnZmxPdlZabStaQ2twQ3dDTm1i?=
 =?utf-8?B?QmRweTBEMXBkZFFkYUZwc0RyYXBMUXJLMVdBVFZlbDJNZWpvVFA2aHdzVVJv?=
 =?utf-8?B?czBpcm45UytBMlAwWE5pdEtCTWZ5RjdHODVEcHBTelUvNTdQMlVaL0dad2M3?=
 =?utf-8?B?cVVNenNvYVF2OW42VW9DTDY0ZVEyaXdVNG5mRTBxUmxGNC9TZXJDOFU0N3Qz?=
 =?utf-8?B?eXNNb3U1Q2ErTmp6TGcvT0JUNlNIekRvN3FtV2ZUQllCUjFPRHpLbXE5YWw1?=
 =?utf-8?B?MTZrWWQvWDBVeHo0VXE3Qi9nbWRvYmVsaFFuSXlYZEJ4SEtFem5IYmNlWmZk?=
 =?utf-8?B?TUZuejZ0L2d4K09FR0lTbURhS0ovWTE3cFozZEJ3d2RrVGozQ1V3M1pRQVJC?=
 =?utf-8?B?R01ORk5TcXJDZGhTajBHNm54WW8ydGJ5eVhVeEV4NFJla25hK1pEak1hM0NX?=
 =?utf-8?B?NDNBY0ZWK0hyNDFLeGJycWNaaHhDVG81emh6OVBUY0l2ZXRtY3JINmU2M0dK?=
 =?utf-8?B?dkFuZW5EWmtxL0I0TVBTMWxLZFFrYU9SOVM1em44Uy95YWpEYkFxYjI4Ulgv?=
 =?utf-8?B?ZXVnUHM5UjdrWU9UUHJXbCs0ZzZ4d3U3M3VITml3Y0JnNGx0Wm5ZUWFjbkRC?=
 =?utf-8?B?dEFZWDJ0YmhjWThFbitWSUk1UjlYRDdPVENSMzk0UnZ2SXlyZXFhNFJJd2VG?=
 =?utf-8?B?Z3MzR3lMaDV0YzZwNEp3WUQyQlNjeWozNjRnU095UEozN3V3M0twWW12aEtI?=
 =?utf-8?B?WlViSWFTK3J4bVNnV3k1ZFQra3BsZmlUV2N4bVV0WVhkZHRiSjllMTNmSTdN?=
 =?utf-8?B?RXpZcUQ4UmtIV2h1VXZ5cG00RmJDM1p0M3VpcWJwd1YvSTF2MlNrWkphVEE1?=
 =?utf-8?B?Zk1nTlRIdkk0MzhERjdDZFhVRE53dmQrQWF2T0c3NmVnMjFrK2k1YlovdWJl?=
 =?utf-8?B?QXpzdTQzMWozUnljVUZkblkvUC9QdzVWM0lSN3I1djQrZlk5QTV2bEVLaW1z?=
 =?utf-8?B?bUZiZmYzaXozc3BYZnRKUGRFOFBkdjRoYm9KMW43SWhyU3NYdC9kZzdadngw?=
 =?utf-8?B?LzFRWmFKR0NpeWFkU3V3WGlzZXgvd0pSOFg5K2tDMUJyKzVhdW44RVVzell2?=
 =?utf-8?B?NFU1dmYvNFl2NzgvbVoveU04UWNNVjNUVDM0UmU2c2lWSmU3N0xtSGQ3OVEy?=
 =?utf-8?B?M0xNMVNBUHhzbkNDeW1iamJjcVpHU3lmdUhkdFhlbWZqZ2g1K1cxRlIxVGJy?=
 =?utf-8?B?WjlDczYyUFJqclJrOVk2WWFFQVJaV1Fndm84aSt5UHlQWnZ6Rnk0T2NiTUVW?=
 =?utf-8?B?Smg4N3YvWWhOMnVjR2Y4R2g1QTNOYVA4R2oybWpNY25vVU9QejNYeW5Ubnh3?=
 =?utf-8?B?MTYxTkhpK2xxbFI2ZlFPUXkxNWVkUThzM0NKV1MzVUlJT1ZVR2NpQW8xcjBN?=
 =?utf-8?Q?UrQfG0a+7VV30W2L4UKvDAdGRs9KL4f8c0sF0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFRNeFRuT2hOVGVGV3pPU0NUdnFleTFkWDV2U3dSMmlZbVVoc0drOEdUZDBK?=
 =?utf-8?B?QnozOFl0ZkVIRHllcW9ZUE9DSGU5UE5Mc3VyaG95S3N2ZmplSm5yUFpzTWNK?=
 =?utf-8?B?YUNQbTFaQVBjWmVyeDdTVHgyTmt4TUZUdW5YaTJ4K3dQaERQcmsrNmNMdkhn?=
 =?utf-8?B?N1MvUlErVGJmOVpnOWs1Vk5oRFNVU1pJcHFlRjVDRHI2a0IwRUt3aGZ3TEtD?=
 =?utf-8?B?V2JrV1lVMGFSbWw1c3FUVmNlTWtnYnlvdjJuNUE2YWJta1dHMjJ2Sk5RaGI2?=
 =?utf-8?B?WTM0NnBkbWRtMHhDbWVWZC9INUtobXZ4ZjliL2tPakd4QVhGazBCWEJya1I2?=
 =?utf-8?B?bFpweldYcDFoZzNOTXFEL0NWYTJ5TXpmZmJXdmtDZFloSGoyTVgrRFRlNWdG?=
 =?utf-8?B?V3VaRHRDZHhSY0ZZbkQxK3NIdm5uaU9XTkwxYm4rSUZSdXBZRGFGdmZpc2c2?=
 =?utf-8?B?N3pvMllNVjEvQnV1aHdEQzVhWEZuUnVQOU9Ib2NZdi9RZjRSQ0R5QzVWTmty?=
 =?utf-8?B?MTN1YnVPRFRHdlFLZFl5SVNXTTNFYXFhU1NtT002R3o3M21oUTNTTzI4SmpU?=
 =?utf-8?B?eWdLcE9PYURLTnFqeDlLQWxJU0E0aW1XNHp3TFZlYjZtTmtnUlRLTVZtc3FV?=
 =?utf-8?B?RjFVTlJrK3gyNHNheVZPN1YwVWdscXVuekJudWtrYkErOWpZdDltallORTJt?=
 =?utf-8?B?MXQzR3g5VWwxL3RlMmNKVEY3ektrdzRMNVZ3bGVzQmlzSlVhTnFoeFloeXJE?=
 =?utf-8?B?VGdyY1VUUVhiMU9qRkdZS2NhTlJIMTVTV011VTdNeVltOGJvMi9oS20rMUVL?=
 =?utf-8?B?OEhFUEtzNVB2VjFjQkVmdU5ia3Ric1RpL1hkYnAzK1pnZnZIUyt3eGlhVFF3?=
 =?utf-8?B?Nko3dE1HZjhRcm9lWUprZStwZTNFeFN1aFFrYU1YMWI3T2tHWjVpeHRIN3Zl?=
 =?utf-8?B?V1hrbnNVUk81UEhvQVlIeXdlU1E1REUzaTZhMXdVSTFUbGVCT0t2LzJrN0d4?=
 =?utf-8?B?Y1RVcG00Z2kxeE5haHBtdGdoWGJPWjhtM2ZnVm5pV1J3dk9qV3JXUVFrVW5y?=
 =?utf-8?B?T3hwZWNvWlVXaHdjMVZqeHFsbmlETUlCSVBMbTN6ZU0ycWNEcFI4aFZGcXB2?=
 =?utf-8?B?VTlHNHNCaUJoZ2ZVR0pUcklaRy9HaDlzTmtVdVdOL0RENUtZcEJqWEx5eE5N?=
 =?utf-8?B?Rks5cmFzZDNEZzJHak1mYzZrTWtFaXVJL1FDaW1KRDk0YnBmNXFKdmpaYkZG?=
 =?utf-8?B?UU1MY2wvYkh0blYyenRiWSs5UDVrSEk1bzNFSUprU0tqclNrRkJoTHNWdEV5?=
 =?utf-8?B?WC9UVkwwOUovWlVFdERUdTkrSVY1Myt5WDhnVll2dTNFUHo4ZVJ3VVlyaGo5?=
 =?utf-8?B?SnB5K1BYWnBCNXlkd01JY0dvVkVKaTRVQWg5TFpMZTNjTEtpNGM1eUwybVhJ?=
 =?utf-8?B?eEpBY21oRCt4YWg1TVRqREhueml1VmIrNGVnWkNVU2M4VTV6SCtOM3YrRzRV?=
 =?utf-8?B?UTJTK0pXcXZ2Q0pEeDhMd2hhNlg1Z0lJeUtXWHBmV0NlS3hUdlpaZS9lOVhP?=
 =?utf-8?B?VXJqK0E4ZkJDYmZ0amw0UmpTRUN1eHN0SVdDVUxzN3ZSbDdBbWl2U0NwY3Yr?=
 =?utf-8?B?aWE4WFVqaktYQmppYm9lVWUzdjFkRW4vK25wWDF4TWhLcC9ucWhocC9rd2dm?=
 =?utf-8?B?UFhXZ3dyUWc3UHEzMnhIRytUVDNxWHVXT1RHcWkrQmFHQTNsQ05BbzR6RnEv?=
 =?utf-8?B?dFlWYWkrUy9LdU90YjM5ZzB2eS9aS0hLbzNyemJjdFB6Ym5WZ1V5OUVUUEQ0?=
 =?utf-8?B?OXNKZk9ZdjJxM1ZCWXJ5eVJjaUpPWDRZTkg2RXVBUmJFZWFVbDhrK0lHVTRE?=
 =?utf-8?B?YTlJVEl3SHNNZUFZNkJWVTVHVzhoTGg3THZ3QTlDUjREeEt0ZHJobWFwWjBJ?=
 =?utf-8?B?S0Z3YkREZlMvWkZ5QWpBQzFON25XUHREcU5TMzBJeFJ1ZWFKbmhnb3MrdTVr?=
 =?utf-8?B?Y0VkQ1FxVXFmb2FUTVJlRzBUb0gyME0zamxMMFNwNGRWNjI3UEczVHhMNzBa?=
 =?utf-8?B?bStlcUtoMHpDOTNvc3FtRHF3SWJOdmxVZkRKRkNXaWtYTjJlaXI5OWl5VURK?=
 =?utf-8?Q?tEPTKZQuv+ytxtX1vdX66k1Uu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20A4F9769F0029448D040ECDAA67848F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1344f795-031b-42e5-bf1c-08dd0dbbc296
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 01:43:43.0988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VcKa3/DzNyhNeJUirkTc9Ci61yCOROP/DR1jGQ++sIjMHk6EYrco66SiaBrYrf7dFxsxFiDG6FEDsq5jRZGJ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8526
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTI1IGF0IDE0OjUxIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE5vdiAyNSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNC0xMS0yNSBhdCAwNzoxOSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIE1vbiwgTm92IDI1LCAyMDI0LCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gPiA+IE9u
IDExLzIyLzIwMjQgNDoxNCBBTSwgQWRyaWFuIEh1bnRlciB3cm90ZToNCj4gPiA+ID4gWy4uLl0N
Cj4gPiA+ID4gPiAgICAtIHRkeF92Y3B1X2VudGVyX2V4aXQoKSBjYWxscyBndWVzdF9zdGF0ZV9l
bnRlcl9pcnFvZmYoKQ0KPiA+ID4gPiA+ICAgICAgYW5kIGd1ZXN0X3N0YXRlX2V4aXRfaXJxb2Zm
KCkgd2hpY2ggY29tbWVudHMgc2F5IHNob3VsZCBiZQ0KPiA+ID4gPiA+ICAgICAgY2FsbGVkIGZy
b20gbm9uLWluc3RydW1lbnRhYmxlIGNvZGUgYnV0IG5vaW5zdCB3YXMgcmVtb3ZlZA0KPiA+ID4g
PiA+ICAgICAgYXQgU2VhbidzIHN1Z2dlc3Rpb246DQo+ID4gPiA+ID4gICAgCWh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC9aZzh0SnNwTDl1Qm1NWkZPQGdvb2dsZS5jb20vDQo+ID4gPiA+ID4g
ICAgICBub2luc3RyIGlzIGFsc28gbmVlZGVkIHRvIHJldGFpbiBOTUktYmxvY2tpbmcgYnkgYXZv
aWRpbmcNCj4gPiA+ID4gPiAgICAgIGluc3RydW1lbnRlZCBjb2RlIHRoYXQgbGVhZHMgdG8gYW4g
SVJFVCB3aGljaCB1bmJsb2NrcyBOTUlzLg0KPiA+ID4gPiA+ICAgICAgQSBsYXRlciBwYXRjaCBz
ZXQgd2lsbCBkZWFsIHdpdGggTk1JIFZNLWV4aXRzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiBJbiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvWmc4dEpzcEw5dUJtTVpGT0Bnb29nbGUuY29tLCBT
ZWFuIG1lbnRpb25lZDoNCj4gPiA+ID4gIlRoZSByZWFzb24gdGhlIFZNLUVudGVyIGZsb3dzIGZv
ciBWTVggYW5kIFNWTSBuZWVkIHRvIGJlIG5vaW5zdHIgaXMgdGhleSBkbyB0aGluZ3MNCj4gPiA+
ID4gbGlrZSBsb2FkIHRoZSBndWVzdCdzIENSMiwgYW5kIGhhbmRsZSBOTUkgVk0tRXhpdHMgd2l0
aCBOTUlzIGJsb2Nrcy7CoCBOb25lIG9mDQo+ID4gPiA+IHRoYXQgYXBwbGllcyB0byBURFguwqAg
RWl0aGVyIHRoYXQsIG9yIHRoZXJlIGFyZSBzb21lIG1hc3NpdmUgYnVncyBsdXJraW5nIGR1ZSB0
bw0KPiA+ID4gPiBtaXNzaW5nIGNvZGUuIg0KPiA+ID4gPiANCj4gPiA+ID4gSSBkb24ndCB1bmRl
cnN0YW5kIHdoeSBoYW5kbGUgTk1JIFZNLUV4aXRzIHdpdGggTk1JcyBibG9ja3MgZG9lc24ndCBh
cHBseSB0bw0KPiA+ID4gPiBURFguwqAgSUlVSUMsIHNpbWlsYXIgdG8gVk1YLCBURFggYWxzbyBu
ZWVkcyB0byBoYW5kbGUgdGhlIE5NSSBWTS1leGl0IGluIHRoZQ0KPiA+ID4gPiBub2luc3RyIHNl
Y3Rpb24gdG8gYXZvaWQgdGhlIHVuYmxvY2sgb2YgTk1JcyBkdWUgdG8gaW5zdHJ1bWVudGF0aW9u
LWluZHVjZWQNCj4gPiA+ID4gZmF1bHQuDQo+ID4gPiANCj4gPiA+IFdpdGggVERYLCBTRUFNQ0FM
TCBpcyBtZWNobmljYWxseSBhIFZNLUV4aXQuICBLVk0gaXMgdGhlICJndWVzdCIgcnVubmluZyBp
biBWTVgNCj4gPiA+IHJvb3QgbW9kZSwgYW5kIHRoZSBURFgtTW9kdWxlIGlzIHRoZSAiaG9zdCIs
IHJ1bm5pbmcgaW4gU0VBTSByb290IG1vZGUuDQo+ID4gPiANCj4gPiA+IEFuZCBmb3IgVERILlZQ
LkVOVEVSLCBpZiBhIGhhcmR3YXJlIE5NSSBhcnJpdmVzIHdpdGggdGhlIFREWCBndWVzdCBpcyBh
Y3RpdmUsDQo+ID4gPiB0aGUgaW5pdGlhbCBOTUkgVk0tRXhpdCwgd2hpY2ggY29uc3VtZXMgdGhl
IE5NSSBhbmQgYmxvY2tzIGZ1cnRoZXIgTk1JcywgZ29lcw0KPiA+ID4gZnJvbSBTRUFNIG5vbi1y
b290IHRvIFNFQU0gcm9vdC4gIFRoZSBTRUFNUkVUIGZyb20gU0VBTSByb290IHRvIFZNWCByb290
IChLVk0pDQo+ID4gPiBpcyBlZmZlY3RpdmVseSBhIFZNLUVudGVyLCBhbmQgZG9lcyBOT1QgYmxv
Y2sgTk1JcyBpbiBWTVggcm9vdCAoYXQgbGVhc3QsIEFGQUlLKS4NCj4gPiA+IA0KPiA+ID4gU28g
dHJ5aW5nIHRvIGhhbmRsZSB0aGUgTk1JICJleGl0IiBpbiBhIG5vaW5zdHIgc2VjdGlvbiBpcyBw
b2ludGxlc3MgYmVjYXVzZSBOTUlzDQo+ID4gPiBhcmUgbmV2ZXIgYmxvY2tlZC4NCj4gPiANCj4g
PiBJIHRob3VnaHQgTk1JIHJlbWFpbnMgYmVpbmcgYmxvY2tlZCBhZnRlciBTRUFNUkVUPw0KPiAN
Cj4gTm8sIGJlY2F1c2UgTk1JcyB3ZXJlbid0IGJsb2NrZWQgYXQgU0VBTUNBTEwuDQo+IA0KPiA+
IFRoZSBURFggQ1BVIGFyY2hpdGVjdHVyZSBleHRlbnNpb24gc3BlYyBzYXlzOg0KPiA+IA0KPiA+
ICINCj4gPiBPbiB0cmFuc2l0aW9uIHRvIFNFQU0gVk1YIHJvb3Qgb3BlcmF0aW9uLCB0aGUgcHJv
Y2Vzc29yIGNhbiBpbmhpYml0IE5NSSBhbmQgU01JLg0KPiA+IFdoaWxlIGluaGliaXRlZCwgaWYg
dGhlc2UgZXZlbnRzIG9jY3VyLCB0aGVuIHRoZXkgYXJlIHRhaWxvcmVkIHRvIHN0YXkgcGVuZGlu
Zw0KPiA+IGFuZCBiZSBkZWxpdmVyZWQgd2hlbiB0aGUgaW5oaWJpdCBzdGF0ZSBpcyByZW1vdmVk
LiBOTUkgYW5kIGV4dGVybmFsIGludGVycnVwdHMNCj4gPiBjYW4gYmUgdW5pbmhpYml0ZWQgaW4g
U0VBTSBWTVgtcm9vdCBvcGVyYXRpb24uIEluIFNFQU0gVk1YLXJvb3Qgb3BlcmF0aW9uLA0KPiA+
IE1TUl9JTlRSX1BFTkRJTkcgY2FuIGJlIHJlYWQgdG8gaGVscCBkZXRlcm1pbmUgc3RhdHVzIG9m
IGFueSBwZW5kaW5nIGV2ZW50cy4NCj4gPiANCj4gPiBPbiB0cmFuc2l0aW9uIHRvIFNFQU0gVk1Y
IG5vbi1yb290IG9wZXJhdGlvbiB1c2luZyBhIFZNIGVudHJ5LCBOTUkgYW5kIElOVFINCj4gPiBp
bmhpYml0IHN0YXRlcyBhcmUsIGJ5IGRlc2lnbiwgdXBkYXRlZCBiYXNlZCBvbiB0aGUgY29uZmln
dXJhdGlvbiBvZiB0aGUgVEQgVk1DUw0KPiA+IHVzZWQgdG8gcGVyZm9ybSB0aGUgVk0gZW50cnku
DQo+ID4gDQo+ID4gLi4uDQo+ID4gDQo+ID4gT24gdHJhbnNpdGlvbiB0byBsZWdhY3kgVk1YIHJv
b3Qgb3BlcmF0aW9uIHVzaW5nIFNFQU1SRVQsIHRoZSBOTUkgYW5kIFNNSQ0KPiA+IGluaGliaXQg
c3RhdGUgY2FuIGJlIHJlc3RvcmVkIHRvIHRoZSBpbmhpYml0IHN0YXRlIGF0IHRoZSB0aW1lIG9m
IHRoZSBwcmV2aW91cw0KPiA+IFNFQU1DQUxMIGFuZCBhbnkgcGVuZGluZyBOTUkvU01JIHdvdWxk
IGJlIGRlbGl2ZXJlZCBpZiBub3QgaW5oaWJpdGVkLg0KPiA+ICINCj4gPiANCj4gPiBIZXJlIE5N
SSBpcyBpbmhpYml0ZWQgaW4gU0VBTSBWTVggcm9vdCwgYnV0IGlzIG5ldmVyIGluaGliaXRlZCBp
biBWTVggcm9vdC4gwqANCj4gDQo+IFllcC4NCj4gDQo+ID4gQW5kIHRoZSBsYXN0IHBhcmFncmFw
aCBkb2VzIHNheSAiYW55IHBlbmRpbmcgTk1JIHdvdWxkIGJlIGRlbGl2ZXJlZCBpZiBub3QNCj4g
PiBpbmhpYml0ZWQiLiDCoA0KPiANCj4gVGhhdCdzIHJlZmVycmluZyB0byB0aGUgc2NlbmFyaW8g
d2hlcmUgYW4gTk1JIGJlY29tZXMgcGVuZGluZyB3aGlsZSB0aGUgQ1BVIGlzIGluDQo+IFNFQU0s
IGkuZS4gaGFzIE5NSXMgYmxvY2tlZC4NCj4gDQo+ID4gQnV0IEkgdGhvdWdodCB0aGlzIGFwcGxp
ZXMgdG8gdGhlIGNhc2Ugd2hlbiAiTk1JIGhhcHBlbnMgaW4gU0VBTSBWTVggcm9vdCIsIGJ1dA0K
PiA+IG5vdCAiTk1JIGhhcHBlbnMgaW4gU0VBTSBWTVggbm9uLXJvb3QiPyAgSSB0aG91Z2h0IHRo
ZSBOTUkgaXMgYWxyZWFkeQ0KPiA+ICJkZWxpdmVyZWQiIHdoZW4gQ1BVIGlzIGluICJTRUFNIFZN
WCBub24tcm9vdCIsIGJ1dCBJIGd1ZXNzIEkgd2FzIHdyb25nIGhlcmUuLg0KPiANCj4gV2hlbiBh
biBOTUkgaGFwcGVucyBpbiBub24tcm9vdCwgdGhlIE5NSSBpcyBhY2tub3dsZWRnZWQgYnkgdGhl
IENQVSBwcmlvciB0bw0KPiBwZXJmb3JtaW5nIFZNLUV4aXQuICBJbiByZWd1bGFyIFZNWCwgTk1J
cyBhcmUgYmxvY2tlZCBhZnRlciBzdWNoIFZNLUV4aXRzLiAgV2l0aA0KPiBURFgsIHRoYXQgYmxv
Y2tpbmcgaGFwcGVucyBmb3IgU0VBTSByb290LCBidXQgdGhlIFNFQU1SRVQgYmFjayB0byBWTVgg
cm9vdCB3aWxsDQo+IGxvYWQgaW50ZXJydXB0aWJpbGl0eSBmcm9tIHRoZSBTRUFNQ0FMTCBWTUNT
LCBhbmQgSSBkb24ndCBzZWUgYW55IGNvZGUgaW4gdGhlDQo+IFREWC1Nb2R1bGUgdGhhdCBwcm9w
YWdhdGVzIHRoYXQgYmxvY2tpbmcgdG8gU0VBTUNBTEwgVk1DUy4NCg0KT2gsIEkgZGlkbid0IHJl
YWQgdGhlIG1vZHVsZSBjb2RlLCBidXQgd2FzIHRyeWluZyB0byBsb29raW5nIGZvciBjbHVlIGZy
b20gdGhlDQpURFggc3BlY3MuICBJdCB3YXMgYSBzdXJwcmlzZSB0byBtZSB0aGF0IFZNWCBjYXNl
IGFuZCBURFggY2FzZSBoYXZlIGRpZmZlcmVudA0KYmVoYXZpb3VyIGluIHRlcm1zIG9mICJOTUkg
YmxvY2tpbmcgd2hlbiBleGl0aW5nIHRvIF9ob3N0XyBWTU0iLg0KDQpJIHdhcyB0aGlua2luZyBT
RUFNUkVUIChvciBoYXJkd2FyZSBpbiBnZW5lcmFsKSBzaG91bGQgaGF2ZSBkb25lIHNvbWV0aGlu
ZyB0bw0KbWFrZSBzdXJlIG9mIGl0Lg0KDQo+IA0KPiBIbW0sIGFjdHVhbGx5LCB0aGlzIG1lYW5z
IHRoYXQgVERYIGhhcyBhIGNhdXNhbGl0eSBpbnZlcnNpb24sIHdoaWNoIG1heSBiZWNvbWUNCj4g
dmlzaWJsZSB3aXRoIEZSRUQncyBOTUkgc291cmNlIHJlcG9ydGluZy4gIEUuZy4gTk1JIFggYXJy
aXZlcyBpbiBTRUFNIG5vbi1yb290DQo+IGFuZCB0cmlnZ2VycyBhIFZNLUV4aXQuICBOTUkgWCsx
IGJlY29tZXMgcGVuZGluZyB3aGlsZSBTRUFNIHJvb3QgaXMgYWN0aXZlLg0KPiBURFgtTW9kdWxl
IFNFQU1SRVRzIHRvIFZNWCByb290LCBOTUlzIGFyZSB1bmJsb2NrZWQsIGFuZCBzbyBOTUkgWCsx
IGlzIGRlbGl2ZXJlZA0KPiBhbmQgaGFuZGxlZCBiZWZvcmUgTk1JIFguDQoNClNvcnJ5LCBOTUkg
WCB3YXMgYWNrZWQgYnkgQ1BVIGZpcnN0bHkgYmVmb3JlIE5NSSBYKzEsIHdoeSBpcyBOTUkgWCsx
IGRlbGl2ZXJlZA0KYmVmb3JlIE5NSSBYPw0KDQo+IA0KPiBTbyB0aGUgVERYLU1vZHVsZSBuZWVk
cyBzb21ldGhpbmcgbGlrZSB0aGlzOg0KPiANCj4gZGlmZiAtLWdpdCBhL3NyYy90ZF90cmFuc2l0
aW9ucy90ZF9leGl0LmMgYi9zcmMvdGRfdHJhbnNpdGlvbnMvdGRfZXhpdC5jDQo+IGluZGV4IGVl
Y2ZiMmUuLmI1YzE3YzMgMTAwNjQ0DQo+IC0tLSBhL3NyYy90ZF90cmFuc2l0aW9ucy90ZF9leGl0
LmMNCj4gKysrIGIvc3JjL3RkX3RyYW5zaXRpb25zL3RkX2V4aXQuYw0KPiBAQCAtNTI3LDYgKzUy
NywxMSBAQCB2b2lkIHRkX3ZtZXhpdF90b192bW0odWludDhfdCB2Y3B1X3N0YXRlLCB1aW50OF90
IGxhc3RfdGRfZXhpdCwgdWludDY0X3Qgc2NydWJfbQ0KPiAgICAgICAgICBsb2FkX3htbXNfYnlf
bWFzayh0ZHZwc19wdHIsIHhtbV9zZWxlY3QpOw0KPiAgICAgIH0NCj4gIA0KPiArICAgIGlmICg8
aXMgTk1JIFZNLUV4aXQgPT4gU0VBTVJFVCkNCj4gKyAgICB7DQo+ICsgICAgICAgIHNldF9ndWVz
dF9pbnRlcl9ibG9ja2luZ19ieV9ubWkoKTsNCj4gKyAgICB9DQo+ICsNCj4gICAgICAvLyA3LiAg
IFJ1biB0aGUgY29tbW9uIFNFQU1SRVQgcm91dGluZS4NCj4gICAgICB0ZHhfdm1tX3Bvc3RfZGlz
cGF0Y2hpbmcoKTsNCj4gDQo+IA0KPiBhbmQgdGhlbiBLVk0gc2hvdWxkIGluZGVlZCBoYW5kbGUg
Tk1JIGV4aXRzIHByaW9yIHRvIGxlYXZpbmcgdGhlIG5vaW5zdHIgc2VjdGlvbi4NCg0KWWVhaCB0
byBtZSBpdCBzaG91bGQgYmUgZG9uZSB1bmNvbmRpdGlvbmFsbHkgYXMgaXQgZ2l2ZXMgdGhlIHNh
bWUgYmVoYXZpb3VyIHRvDQp0aGUgbm9ybWFsIFZNWCBWTS1FeGl0IGNhc2UsIHRoYXQgTk1JIGlz
IGxlZnQgYmxvY2tlZCBhZnRlciBleGl0aW5nIHRvIHRoZSBob3N0DQpWTU0uICBUaGUgTk1JIEV4
aXQgcmVhc29uIGlzIHBhc3NlZCB0byBob3N0IFZNTSBhbnl3YXkuDQoNCklmIE5NSSBpcyBoYW5k
bGVkIGltbWVkaWF0ZWx5IGFmdGVyIFNFQU1SRVQsIEtWTSB3b24ndCBoYXZlIGFueSBjaGFuY2Ug
dG8gZG8NCmFkZGl0aW9uYWwgdGhpbmdzIGJlZm9yZSBoYW5kaW5nIE5NSSBsaWtlIGJlbG93IGZv
ciBWTVg6DQoNCiAga3ZtX2JlZm9yZV9pbnRlcnJ1cHQodmNwdSwgS1ZNX0hBTkRMSU5HX05NSSk7
DQogIC8vIGNhbGwgTk1JIGhhbmRsaW5nIHJvdXRpbmUNCiAga3ZtX2FmdGVyX2ludGVycnVwdCh2
Y3B1KTsNCg0KSSBzdXBwb3NlIHRoaXMgc2hvdWxkIGJlIGEgY29uY2Vybj8NCg0KDQo=

