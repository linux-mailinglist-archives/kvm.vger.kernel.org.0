Return-Path: <kvm+bounces-59940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C184BD5F39
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 21:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 776A718A04BC
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF3A2D877E;
	Mon, 13 Oct 2025 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n5f/O5JZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E251D5CF2;
	Mon, 13 Oct 2025 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760383891; cv=fail; b=NCiSbwtWzfyBzhYRYoj/f6jwhvW95rlrxqSNtCZqjcZvuGEdCTgdtwwC7/T6+1EpIcNkAX73G31r/+zoovk/nwLhcSzKMLmxwqPKHh0SdWyO/GNYQjCu2LnoRLtp4kozDHUOcWvObG2R8iuEwZpKSrMGZ0wvhgQHJYV7AshFJyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760383891; c=relaxed/simple;
	bh=PQmE+7zKXwAGbHslaqHgIl7iKksjC0ELVAwCnBMEJ5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ujVt3VP0rYydD0Uxge2c81xzSgX60r8d7kogzTXQGuWnZa7OnFJRMA6PNExtCDf0SxMivtN8x5g7G9Zk6pAoLyN9USAMyS0NLp4c2fYJe8w9tRuMeOqa4u4eTstG8Yuq4/oI1LJQL67+nzaMekzIl1ppLeTlSyWfN78Zp7oE/lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n5f/O5JZ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760383888; x=1791919888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PQmE+7zKXwAGbHslaqHgIl7iKksjC0ELVAwCnBMEJ5Y=;
  b=n5f/O5JZQ7kezraohts16GOxS3eK16xI7lEi3H5hUJlndeKJCeYpolrG
   Ysb3STMJDVeBSlYUCRj87TgRH1Aq0XgCEXA3R3Hi2h1yMogJ1O6nIRJxl
   fzZWrrPZC8nKGqQX7fmzuZhNAEyiGZdhnPSu/Vk6haViFjV1dmrwAvwCG
   SJAftrSiqNnHhtRduTv7J3UxhY9YqDbMoKxD+KA1/2U+ckGxdSmxH9pMD
   qgTkUZ6wsSity22NM4hu0zQn9TUXVGSzKi8OyqFDdSMivK9wMVL2+Sj5i
   Pvme7/77apt54WSh+QNhzixob9xW0+Ebi5bep4kCIwoolaj0QMkvAQzqv
   w==;
X-CSE-ConnectionGUID: YEqDi5HRRQWqJ9Fm3unR7w==
X-CSE-MsgGUID: ANyv6rIwSJKRGQvbLKbztQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="80171551"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="80171551"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 12:31:27 -0700
X-CSE-ConnectionGUID: CF0SqIHpQfWJOxOWEWb91g==
X-CSE-MsgGUID: FZbjAr/2QdK3PNo6LdUczQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182112008"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 12:31:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 12:31:26 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 12:31:26 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 12:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vH0lU/odjIYDSRcVR1PHdsdfIUFzCtjVnu0BVmgtgq4E2MgmtVTXuaKzcDaj53WPHseijn/V5yEaY97cUeEOBTzFNXaeOm/OV47oCYW34+bEq8Mp6mVCGUxq2T9eI4am3oOtAMevaeLvzCcSO7/a24IgRu7oHZnURIOCitarzJDCQShW2Qe6sEX6pyY+KpW2RoNUqrLYW7IFYfCbiyBlgGXJMHowmEpvKkQ8xMz6EqI6yueTKjVY/qRy2ZHPOG5k7AOqsYj5DxuHY5xoxnlQxDgP+9BmvPz0P+06SS87zb/1IpHAm5VS8CQaHNX8Dqod6HMxowdnBT1AT7vkdPPbTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQmE+7zKXwAGbHslaqHgIl7iKksjC0ELVAwCnBMEJ5Y=;
 b=cNsB+zyWJJMwnq8JN8N84fRB9Uut4FGjw5+WY1NqXFo6QkS8U8+PGs1PkxLFgTFVbcY89TJlG2iXSL4C1PR4iRBpyojNmFhGgZsoIgO3ODkrCunK6fFNrUfQoYB3S1iVVqCWoHTnYfadbWxAbzihWcx7LNTamqBeBrMWEkV0+hMvdj2fjsaSLnWiUEdEvri+Ud9+yF9pLYAH2a/Hqn9/4733ocZ5l6gz0Zkt0bV52tI7iMezYv/jUO7UP/rshIhQlbkTeoStvwa7RBRnR5qt5s9NAPQOTM4DycOYg+dZzlzSDN77pJQ0GVo7sa9j+sWGRqHXgLtkjiOB98wQNLwMRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8020.namprd11.prod.outlook.com (2603:10b6:8:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 19:31:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 19:31:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Thread-Topic: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Thread-Index: AQHcPG9+J7Pdwu/FJEewYPJK0ygzLLTAdwuA
Date: Mon, 13 Oct 2025 19:31:24 +0000
Message-ID: <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
	 <20251010220403.987927-4-seanjc@google.com>
In-Reply-To: <20251010220403.987927-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8020:EE_
x-ms-office365-filtering-correlation-id: 9152929a-693b-4314-9cf4-08de0a8f18e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RWxvRGY3OEF6SFVyWVU3ay8wOWt5WXdDVkhyY1RkT1ZLQXpZZXFZMklCRStR?=
 =?utf-8?B?ZUtncjVQK2JlYjRkMkx3NUJuSTVpb0szMHByVkR4WTFhKytWSUFrOWRvUVh5?=
 =?utf-8?B?Z0ZhZHBTdnVnN0FHK1ZQU01ydkRkWFNYMnZ3ZG4zTVM1SEIzbnRCZkY0ZmhN?=
 =?utf-8?B?dFVkWjc0eFVrSFozYlF3MElsa0JnR3JWak9tNGtxSjdGblJEbk1pc1NFUTF2?=
 =?utf-8?B?VDFxMEhlNlg2MjUzNGY4RFFaa25DV1cvSlFwY3FMdE93dXBkanEzMDlHK2t6?=
 =?utf-8?B?WVBvUU96S2ovSU9hanhDbjAzdzFJQ2JRa1VQa0lxbTExKzJ4amlBaTJQY1BP?=
 =?utf-8?B?QXphNHE3WjRCdTYva0VwelJjbS9rSkN4U1RkOThWdEdRQ1hIRmJxS0EyZVpL?=
 =?utf-8?B?cE16WjBnam5iZ3JHY0VlQ0FGVlRnMjd2UUpHNXpXNFl0ZllEZ2RuMi9lYkha?=
 =?utf-8?B?MHg1dXMwSnRwNFVyYms0SzdNZnorUDJVbzhEMlN2S0Uwd04vSUJzMXQrUHN6?=
 =?utf-8?B?NFI2aFdPYkVJMnBKRzN1OUREKzcrUDhLYWhyVE5NWk91VHAveEN5b2VXMFY0?=
 =?utf-8?B?Z0lpKzlnZDdIMTFNcHozOGpuYlBQd2YraTEwb3V1em5jaDE1ZXdiUyt2a2RJ?=
 =?utf-8?B?TGhzaXpHRS83b3NFWEJlVkRFdThKWUVFbGlybmc1bUNNNG1FMVA5Q3NIaHo2?=
 =?utf-8?B?Rnc5a201RGNyMHRnQndOS051S3hjYjl5elpPQUxLK3lxYXJtdFoybEplekdt?=
 =?utf-8?B?YXZQTUp1QmU1Y2xrYnZnN1FUWnNNVTdwajh3UGNjK1U1ajdBQ2FpOTJJNExC?=
 =?utf-8?B?cmROT0pCMWF0V0pMRGJRaVFyUDNUN0ptUkZMT0xtdjR3WEtrVzlDTWZ4N3J4?=
 =?utf-8?B?WmJtdHdEWWh2MEswaWtBcTRNVHUrcTRoanFpajU0MEVEMENuS3hQRlBhWVpi?=
 =?utf-8?B?RnFlNm5jT1lDNkdLNVM5QitXa0JQUXpQTS9hYTEvSngwNU9uVXhiSEtvWWxy?=
 =?utf-8?B?T3dreFZ3VjNhTlB6OWJKN3lvK3BpQ3M2ZEovUWwwa3V1K0x4ZWx1K1Q2dVBv?=
 =?utf-8?B?Q3gvcUpTUXo1TnU5dXlTckhGNzR4U2tJZWx4SmdhUWJJL2YzalFUdFZGakI0?=
 =?utf-8?B?V1R4MDMwL1hOOEcxTSt0YkhraHNJWTlwYm1nQm9tck9OcFYxbU1JcUovbmRj?=
 =?utf-8?B?djVvUmxhTGxjbll4ck9IOUs4ZDVEMUFwMlJtNVdsbGZSK0l3bDkvNzlXRTkz?=
 =?utf-8?B?eGhwRGI5MHR4MjcrUHVKOFU4Y1g1bFJsd1dpc3BndU5iRDMwNmxuMlBRTEJ0?=
 =?utf-8?B?QXdZUVZYZFlhZ0xnRUt2ZU16WmFOZEtIOC9CTzk2NU5KZXlEMllIL3BuUWdt?=
 =?utf-8?B?cTNzTXhTRlk1bFlTS1VNckQ3bE9PNW9mTFgzcEFzU1BuNzlRZFFmTG9kT2pD?=
 =?utf-8?B?TEd4cXZmdmo4cVJKcWpWd2czRVQ5SEJubE4wZHJ2c0JzQjF0dlNPMkFJVlh3?=
 =?utf-8?B?V1BoSmJhSC9oZTZpT1Nvc0VwcURlWEs0TEhRK1RqY0VNL1pFV012R3oyUkEx?=
 =?utf-8?B?RENyV2VoK1ZVUnczU2hEM2sxaEJXSzNxdTVRUnZvaTNrV2ZsV1lzRDN4NTB2?=
 =?utf-8?B?dkd0dVVVVktSMDE3VmRsZU9HcFpyQTlpLzVHWlBLK0dwTlhldXFUNTZydzF0?=
 =?utf-8?B?ZzJpU1BnbTVmMGdBc1IvUGVZaVF2cXIzNTA4MWpDTXY4ZXplUFNEYkRmOWxm?=
 =?utf-8?B?VDBtelhCeVhFZlpDcUlLclhwWnI3TFYwWTNXM1RGc1YyeUZ6aEdmcWF3WkNR?=
 =?utf-8?B?cTlDclN1WmlxUjlUWHVUSjBOc253TExQNW9yVUlBRzE3R3VsaDUzb1pKSXls?=
 =?utf-8?B?cFZna3hHQ3pkRHVBYlNiRnJXd3ZDQ3loQkJwV2JHdTVyWWtMM1hVMFJ0NU5B?=
 =?utf-8?B?dFNwQU5HTWNhZXI5QkVkYndWMTM3ZHZlUGxBUVh6SjdKUXNFaWhQNjg2NXJa?=
 =?utf-8?B?OUpxbkNZWHBJYmZ5YzQ4THlsK3IvdmFTS0JUNTFFSkFITlA2UWNBMFNQSSsw?=
 =?utf-8?Q?3cBA+j?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXB4cllHRjZEaFJkZ0k4dmpCa2FGd3lUWUt3T2dONXFMaFI5YUlOMlZLR3lm?=
 =?utf-8?B?c2N4eHNzWnFGZGU3Zy90WFZ2WXUvQ0RwQ2dGM29EUk9uVmhNM1d5dHRyNmpI?=
 =?utf-8?B?TUEvTytyK0lMcm9Bb0xHMjA2Z1VUK3E5NkQyNWtLY3o4bWpmTEF0NUxaTy9K?=
 =?utf-8?B?UlAzVG1RQ04xMWM4SHlhcmwxNWpieEJ1WUNCdVhUaXNrLzNyejAxZmVVR1d6?=
 =?utf-8?B?Rmk1ME1MNi9RaS9YanBLTXpCYjBubUJ3bkZBdEhRRTN5NDVQVGpUNmlrNC9k?=
 =?utf-8?B?c3VJMjFzTS80Y2tGUlVpR2ZGanVFSUJIVzRhY1puazl6M0pyVGR5YWdabnYw?=
 =?utf-8?B?SFZiczhUeEZWOWR1c2IyNmt6bW5HUElhRFVTR082ZFluTk9xcllMTk5tVVpH?=
 =?utf-8?B?QmQ5UmJ3QnQ1dWEwWmo2c0hNWk96ZWZMZGJjbXNMeVdGMGZDNnRhZ3VuaURD?=
 =?utf-8?B?ejFWUk5EclErOU5iY0pSRFp3TDRBK0J2dGE3clN3SXdCU2FMeVdwM0hieWEw?=
 =?utf-8?B?TXRDRTlUUU1tdmpmVUZoVk1PRldsemFPQWdxQ1J3a01jbnNQallkOFNwQ2Zj?=
 =?utf-8?B?aWNKejM2cWJITWtFRVBqZ1RRMDMyZDVpaGI5N1NscGNYUi9EK1RRWjZlTmt6?=
 =?utf-8?B?amwrVDZlOG9tSzZEQzc3ZVNtT2s4alVXczBDWjgwZ1BtOVhKa0R1Y1NjbS9o?=
 =?utf-8?B?RW1XOS9ieG5ZRkgxUmIzYjFHNEZKN09IelkrQlg5WlpiNjZBYTR2VFRqUG5R?=
 =?utf-8?B?b2xoNFdPeURJSmVGYnpMd3NMR0M5TmZhcnRjc2JzVGIyVFVNWGdUNjlSWCtY?=
 =?utf-8?B?UEE1aDJ0b21yL1I2VnNUY1VQSzA0Tyt2cnV1VHJ1SDV1ajVvQ1NEZjJhMXZM?=
 =?utf-8?B?Y0pqZ05zQ3czTkQyZ2RxVmtXRjBSb3I2MDNmYWNIMkt0VHQrKy9tbXVlUlBm?=
 =?utf-8?B?a2lPSDAwNTlvVUpJRGpUZXRQaGg3YStPaG4zNGRvRjNaOCtvTER3N0l6NU55?=
 =?utf-8?B?TkhDd2ZWZFIyaStWQUFWbEF3dHRZeDVIZVcyQ0p4azlRSUtBaXkyTEJ6QUJQ?=
 =?utf-8?B?RHZLMkhLeEFDZFV0aFlNY1RtMEwrYkR4RlpjL08wR3RKNkVET0VoOUZyZnJG?=
 =?utf-8?B?cmgvSk1sM2o1UFUvYm9JY0tPckVabExrZU1JWUg2NjQrOXpwVVRMQjdPbXh5?=
 =?utf-8?B?SmhVa2hXRlAweUpFNlNBaUVWVXE5WjFGRXZZWVdaSFUvam1FbXdadHNmbCs2?=
 =?utf-8?B?NU9ZYVR6T2JiRmlGa2dMaWZVNzZaV1RjYnExUmNUSHVFZ2lneUZuWEx0Zjhv?=
 =?utf-8?B?cWhMdk50MEIxdlB4OExzUWdVZnVqeG1TL0x5eUtLYWY3WFMxYVNYRjUrMFda?=
 =?utf-8?B?OUxMRUxLR2NuZVhYZG9qV0l1VmEvYVBOTmpLclh2N2hlcDJIaVhiMWliOURx?=
 =?utf-8?B?aEdmcEw2SFl5cWd3U0RVNVc0VSt3U1IzMzBkQ0hxOTgxaXhPdFdIZDNnTGpt?=
 =?utf-8?B?K0dyb25xRVdnL05TMWo2Y3ptVWoxVG40dDBIWCtPeHB0amVOUnRPWHl6RTJx?=
 =?utf-8?B?NEJiWDRzT0hKN2tqQld5SEZ1S2FvUklMUVM1RjJBemc0anorTUo1MCtuWi9Q?=
 =?utf-8?B?VDVVWmxabG9ZUDBRMUtYdHhtTHJWendlNFRSQ2dWSnNjZFM5UkhhOTNYS1Ar?=
 =?utf-8?B?eURmMzV6UkN5MjVvWXNpZWNsbjlkZTl3Q3hJOU51eGNnNlFnSVA4dzB1UWNF?=
 =?utf-8?B?a29iZ0pWUjVSVnlzcVh2YnZ1TWJZMjVGRWRlTFlDZDdLS0dsenhPZW5GT0Mw?=
 =?utf-8?B?cDROQ1JZR0g2dWFGZm5zbzRkYlhlcW56MGF0a2VzVGdwV2pwRHExb2V5WGxG?=
 =?utf-8?B?dmtiaERZaTJHN1I5cGJOaGJGam00V3BnWVUzUEFJOHc1OHc4d3JTNkxDeDlO?=
 =?utf-8?B?QnBWQ3VCN0VxTzR4YXp2YTU5RkpPVldETjRHOCtzREw3VDc1Y2NvZTBhNzBh?=
 =?utf-8?B?QnZnWmt2d0hVWlBYb2dpYzF1aW00cVFDWEZkbHg5Szd2Mm1nblZtMFdJWVh3?=
 =?utf-8?B?dWZxZENSM3E5RUFkcjgrUzJaOW00OXZzbERac1hVUENsOWMyRUM0b0V3cWJi?=
 =?utf-8?B?Ti9rS3pwQkNVTFl4WFhUbW5lU0VzbmRsb2ZXNmtOVDk0SjBKZVZKcjdZZnBR?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4730C06754C8634D8B9D96C1FDE99604@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9152929a-693b-4314-9cf4-08de0a8f18e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 19:31:24.7174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8zBZEv+GiIc6+KSsKv0ET0JvTxWc7KGA8rYM+IS0PAcXQz6q3A+2hGLEX28pZsV6scWl+hn9zfpIpVQk9biNCXrIwa14avbClRmUu+55RhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8020
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTEwLTEwIGF0IDE1OjA0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUT0RPOiBTcGxpdCB0aGlzIHVwLCB3cml0ZSBjaGFuZ2Vsb2dzLg0KPiANCj4gQ2M6
IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4NCj4gQ2M6IFhpbiBMaSAoSW50ZWwpIDx4aW5Aenl0b3IuY29t
Pg0KPiBDYzogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBDYzogQWRyaWFuIEh1
bnRlciA8YWRyaWFuLmh1bnRlckBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hy
aXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gDQpbc25pcF0NCj4gLQ0K
PiAgc3RhdGljIGludCBfX2luaXQgX190ZHhfYnJpbmd1cCh2b2lkKQ0KPiAgew0KPiAgCWNvbnN0
IHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRfY29uZiAqdGRfY29uZjsNCj4gQEAgLTM0NjIsMzQgKzM0
MDcsMTggQEAgc3RhdGljIGludCBfX2luaXQgX190ZHhfYnJpbmd1cCh2b2lkKQ0KPiAgCQl9DQo+
ICAJfQ0KPiAgDQo+IC0JLyoNCj4gLQkgKiBFbmFibGluZyBURFggcmVxdWlyZXMgZW5hYmxpbmcg
aGFyZHdhcmUgdmlydHVhbGl6YXRpb24gZmlyc3QsDQo+IC0JICogYXMgbWFraW5nIFNFQU1DQUxM
cyByZXF1aXJlcyBDUFUgYmVpbmcgaW4gcG9zdC1WTVhPTiBzdGF0ZS4NCj4gLQkgKi8NCj4gLQly
ID0ga3ZtX2VuYWJsZV92aXJ0dWFsaXphdGlvbigpOw0KPiAtCWlmIChyKQ0KPiAtCQlyZXR1cm4g
cjsNCj4gLQ0KPiAtCWNwdXNfcmVhZF9sb2NrKCk7DQo+IC0JciA9IF9fZG9fdGR4X2JyaW5ndXAo
KTsNCj4gLQljcHVzX3JlYWRfdW5sb2NrKCk7DQo+IC0NCj4gLQlpZiAocikNCj4gLQkJZ290byB0
ZHhfYnJpbmd1cF9lcnI7DQo+IC0NCj4gLQlyID0gLUVJTlZBTDsNCj4gIAkvKiBHZXQgVERYIGds
b2JhbCBpbmZvcm1hdGlvbiBmb3IgbGF0ZXIgdXNlICovDQo+ICAJdGR4X3N5c2luZm8gPSB0ZHhf
Z2V0X3N5c2luZm8oKTsNCj4gLQlpZiAoV0FSTl9PTl9PTkNFKCF0ZHhfc3lzaW5mbykpDQo+IC0J
CWdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KPiArCWlmICghdGR4X3N5c2luZm8pDQo+ICsJCXJldHVy
biAtRUlOVkFMOw0KPiAgDQo+ICAJLyogQ2hlY2sgVERYIG1vZHVsZSBhbmQgS1ZNIGNhcGFiaWxp
dGllcyAqLw0KPiAgCWlmICghdGR4X2dldF9zdXBwb3J0ZWRfYXR0cnMoJnRkeF9zeXNpbmZvLT50
ZF9jb25mKSB8fA0KPiAgCSAgICAhdGR4X2dldF9zdXBwb3J0ZWRfeGZhbSgmdGR4X3N5c2luZm8t
PnRkX2NvbmYpKQ0KPiAtCQlnb3RvIGdldF9zeXNpbmZvX2VycjsNCj4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ICANCj4gIAlpZiAoISh0ZHhfc3lzaW5mby0+ZmVhdHVyZXMudGR4X2ZlYXR1cmVzMCAm
IE1EX0ZJRUxEX0lEX0ZFQVRVUkVTMF9UT1BPTE9HWV9FTlVNKSkNCj4gLQkJZ290byBnZXRfc3lz
aW5mb19lcnI7DQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+ICAJLyoNCj4gIAkgKiBURFgg
aGFzIGl0cyBvd24gbGltaXQgb2YgbWF4aW11bSB2Q1BVcyBpdCBjYW4gc3VwcG9ydCBmb3IgYWxs
DQo+IEBAIC0zNTI0LDM0ICszNDUzLDMxIEBAIHN0YXRpYyBpbnQgX19pbml0IF9fdGR4X2JyaW5n
dXAodm9pZCkNCj4gIAlpZiAodGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCA8IG51bV9wcmVzZW50
X2NwdXMoKSkgew0KPiAgCQlwcl9lcnIoIkRpc2FibGUgVERYOiBNQVhfVkNQVV9QRVJfVEQgKCV1
KSBzbWFsbGVyIHRoYW4gbnVtYmVyIG9mIGxvZ2ljYWwgQ1BVcyAoJXUpLlxuIiwNCj4gIAkJCQl0
ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkLCBudW1fcHJlc2VudF9jcHVzKCkpOw0KPiAtCQlnb3Rv
IGdldF9zeXNpbmZvX2VycjsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICAJfQ0KPiAgDQo+ICAJ
aWYgKG1pc2NfY2dfc2V0X2NhcGFjaXR5KE1JU0NfQ0dfUkVTX1REWCwgdGR4X2dldF9ucl9ndWVz
dF9rZXlpZHMoKSkpDQo+IC0JCWdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gIA0KPiAgCS8qDQo+IC0JICogTGVhdmUgaGFyZHdhcmUgdmlydHVhbGl6YXRpb24g
ZW5hYmxlZCBhZnRlciBURFggaXMgZW5hYmxlZA0KPiAtCSAqIHN1Y2Nlc3NmdWxseS4gIFREWCBD
UFUgaG90cGx1ZyBkZXBlbmRzIG9uIHRoaXMuDQo+ICsJICogVERYLXNwZWNpZmljIGNwdWhwIGNh
bGxiYWNrIHRvIGRpc2FsbG93IG9mZmxpbmluZyB0aGUgbGFzdCBDUFUgaW4gYQ0KPiArCSAqIHBh
Y2tpbmcgd2hpbGUgS1ZNIGlzIHJ1bm5pbmcgb25lIG9yIG1vcmUgVERzLiAgUmVjbGFpbWluZyBI
S0lEcw0KPiArCSAqIHJlcXVpcmVzIGRvaW5nIFBBR0UuV0JJTlZEIG9uIGV2ZXJ5IHBhY2thZ2Us
IGkuZS4gb2ZmbGluaW5nIGFsbCBDUFVzDQo+ICsJICogb2YgYSBwYWNrYWdlIHdvdWxkIHByZXZl
bnQgcmVjbGFpbWluZyB0aGUgSEtJRC4NCj4gIAkgKi8NCj4gKwlyID0gY3B1aHBfc2V0dXBfc3Rh
dGUoQ1BVSFBfQVBfT05MSU5FX0RZTiwgImt2bS9jcHUvdGR4Om9ubGluZSIsDQo+ICsJCQkgICAg
ICB0ZHhfb25saW5lX2NwdSwgdGR4X29mZmxpbmVfY3B1KTsNCg0KQ291bGQgcGFzcyBOVUxMIGlu
c3RlYWQgb2YgdGR4X29ubGluZV9jcHUoKSBhbmQgZGVsZXRlIHRoaXMgdmVyc2lvbiBvZg0KdGR4
X29ubGluZV9jcHUoKS4gQWxzbyBjb3VsZCByZW1vdmUgdGhlIGVycm9yIGhhbmRsaW5nIHRvby4N
Cg0KQWxzbywgY2FuIHdlIG5hbWUgdGhlIHR3byB0ZHhfb2ZmbGluZV9jcHUoKSdzIGRpZmZlcmVu
dGx5PyBUaGlzIG9uZSBpcyBhbGwgYWJvdXQNCmtleWlkJ3MgYmVpbmcgaW4gdXNlLiB0ZHhfaGtp
ZF9vZmZsaW5lX2NwdSgpPw0KDQo+ICsJaWYgKHIgPCAwKQ0KPiArCQlnb3RvIGVycl9jcHVodXA7
DQo+ICsNCj4gKwl0ZHhfY3B1aHBfc3RhdGUgPSByOw0KPiAgCXJldHVybiAwOw0KPiAgDQo+IC1n
ZXRfc3lzaW5mb19lcnI6DQo+IC0JX190ZHhfY2xlYW51cCgpOw0KPiAtdGR4X2JyaW5ndXBfZXJy
Og0KPiAtCWt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKCk7DQo+ICtlcnJfY3B1aHVwOg0KPiAr
CW1pc2NfY2dfc2V0X2NhcGFjaXR5KE1JU0NfQ0dfUkVTX1REWCwgMCk7DQo+ICAJcmV0dXJuIHI7
DQo+ICB9DQo+ICANCj4gLXZvaWQgdGR4X2NsZWFudXAodm9pZCkNCj4gLXsNCj4gLQlpZiAoZW5h
YmxlX3RkeCkgew0KPiAtCQltaXNjX2NnX3NldF9jYXBhY2l0eShNSVNDX0NHX1JFU19URFgsIDAp
Ow0KPiAtCQlfX3RkeF9jbGVhbnVwKCk7DQo+IC0JCWt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9u
KCk7DQo+IC0JfQ0KPiAtfQ0KPiAtDQo+ICBpbnQgX19pbml0IHRkeF9icmluZ3VwKHZvaWQpDQo+
ICB7DQo+ICAJaW50IHIsIGk7DQo+IEBAIC0zNTYzLDYgKzM0ODksMTYgQEAgaW50IF9faW5pdCB0
ZHhfYnJpbmd1cCh2b2lkKQ0KPiAgCWlmICghZW5hYmxlX3RkeCkNCj4gIAkJcmV0dXJuIDA7DQo+
ICANCj4gKwlpZiAoIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfVERYX0hPU1RfUExB
VEZPUk0pKSB7DQo+ICsJCXByX2VycigiVERYIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIGhvc3QgcGxh
dGZvcm1cbiIpOw0KPiArCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7DQo+ICsJfQ0KPiArDQo+
ICsJaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX09TWFNBVkUpKSB7DQo+ICsJ
CXByX2VycigiT1NYU0FWRSBpcyByZXF1aXJlZCBmb3IgVERYXG4iKTsNCj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQoNCldoeSBjaGFuZ2UgdGhpcyBjb25kaXRpb24gZnJvbSBnb3RvIHN1Y2Nlc3NfZGlz
YWJsZV90ZHg/DQoNCj4gKwl9DQo+ICsNCj4gIAlpZiAoIWVuYWJsZV9lcHQpIHsNCj4gIAkJcHJf
ZXJyKCJFUFQgaXMgcmVxdWlyZWQgZm9yIFREWFxuIik7DQo+ICAJCWdvdG8gc3VjY2Vzc19kaXNh
YmxlX3RkeDsNCj4gQEAgLTM1NzgsNjEgKzM1MTQsOSBAQCBpbnQgX19pbml0IHRkeF9icmluZ3Vw
KHZvaWQpDQo+ICAJCWdvdG8gc3VjY2Vzc19kaXNhYmxlX3RkeDsNCj4gIAl9DQo+ICANCj4gLQlp
ZiAoIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfT1NYU0FWRSkpIHsNCj4gLQkJcHJf
ZXJyKCJ0ZHg6IE9TWFNBVkUgaXMgcmVxdWlyZWQgZm9yIFREWFxuIik7DQo+IC0JCWdvdG8gc3Vj
Y2Vzc19kaXNhYmxlX3RkeDsNCj4gLQl9DQo+IC0NCj4gLQlpZiAoIWNwdV9mZWF0dXJlX2VuYWJs
ZWQoWDg2X0ZFQVRVUkVfTU9WRElSNjRCKSkgew0KPiAtCQlwcl9lcnIoInRkeDogTU9WRElSNjRC
IGlzIHJlcXVpcmVkIGZvciBURFhcbiIpOw0KPiAtCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7
DQo+IC0JfQ0KPiAtDQo+IC0JaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1NF
TEZTTk9PUCkpIHsNCj4gLQkJcHJfZXJyKCJTZWxmLXNub29wIGlzIHJlcXVpcmVkIGZvciBURFhc
biIpOw0KPiAtCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7DQo+IC0JfQ0KPiAtDQo+IC0JaWYg
KCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1REWF9IT1NUX1BMQVRGT1JNKSkgew0K
PiAtCQlwcl9lcnIoInRkeDogbm8gVERYIHByaXZhdGUgS2V5SURzIGF2YWlsYWJsZVxuIik7DQo+
IC0JCWdvdG8gc3VjY2Vzc19kaXNhYmxlX3RkeDsNCj4gLQl9DQo+IC0NCj4gLQlpZiAoIWVuYWJs
ZV92aXJ0X2F0X2xvYWQpIHsNCj4gLQkJcHJfZXJyKCJ0ZHg6IHRkeCByZXF1aXJlcyBrdm0uZW5h
YmxlX3ZpcnRfYXRfbG9hZD0xXG4iKTsNCj4gLQkJZ290byBzdWNjZXNzX2Rpc2FibGVfdGR4Ow0K
PiAtCX0NCj4gLQ0KPiAtCS8qDQo+IC0JICogSWRlYWxseSBLVk0gc2hvdWxkIHByb2JlIHdoZXRo
ZXIgVERYIG1vZHVsZSBoYXMgYmVlbiBsb2FkZWQNCj4gLQkgKiBmaXJzdCBhbmQgdGhlbiB0cnkg
dG8gYnJpbmcgaXQgdXAuICBCdXQgVERYIG5lZWRzIHRvIHVzZSBTRUFNQ0FMTA0KPiAtCSAqIHRv
IHByb2JlIHdoZXRoZXIgdGhlIG1vZHVsZSBpcyBsb2FkZWQgKHRoZXJlIGlzIG5vIENQVUlEIG9y
IE1TUg0KPiAtCSAqIGZvciB0aGF0KSwgYW5kIG1ha2luZyBTRUFNQ0FMTCByZXF1aXJlcyBlbmFi
bGluZyB2aXJ0dWFsaXphdGlvbg0KPiAtCSAqIGZpcnN0LCBqdXN0IGxpa2UgdGhlIHJlc3Qgc3Rl
cHMgb2YgYnJpbmdpbmcgdXAgVERYIG1vZHVsZS4NCj4gLQkgKg0KPiAtCSAqIFNvLCBmb3Igc2lt
cGxpY2l0eSBkbyBldmVyeXRoaW5nIGluIF9fdGR4X2JyaW5ndXAoKTsgdGhlIGZpcnN0DQo+IC0J
ICogU0VBTUNBTEwgd2lsbCByZXR1cm4gLUVOT0RFViB3aGVuIHRoZSBtb2R1bGUgaXMgbm90IGxv
YWRlZC4gIFRoZQ0KPiAtCSAqIG9ubHkgY29tcGxpY2F0aW9uIGlzIGhhdmluZyB0byBtYWtlIHN1
cmUgdGhhdCBpbml0aWFsaXphdGlvbg0KPiAtCSAqIFNFQU1DQUxMcyBkb24ndCByZXR1cm4gVERY
X1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQgaW4gb3RoZXINCj4gLQkgKiBjYXNlcy4NCj4gLQkgKi8N
Cj4gIAlyID0gX190ZHhfYnJpbmd1cCgpOw0KPiAtCWlmIChyKSB7DQo+IC0JCS8qDQo+IC0JCSAq
IERpc2FibGUgVERYIG9ubHkgYnV0IGRvbid0IGZhaWwgdG8gbG9hZCBtb2R1bGUgaWYgdGhlIFRE
WA0KPiAtCQkgKiBtb2R1bGUgY291bGQgbm90IGJlIGxvYWRlZC4gIE5vIG5lZWQgdG8gcHJpbnQg
bWVzc2FnZSBzYXlpbmcNCj4gLQkJICogIm1vZHVsZSBpcyBub3QgbG9hZGVkIiBiZWNhdXNlIGl0
IHdhcyBwcmludGVkIHdoZW4gdGhlIGZpcnN0DQo+IC0JCSAqIFNFQU1DQUxMIGZhaWxlZC4gIERv
bid0IGJvdGhlciB1bndpbmRpbmcgdGhlIFMtRVBUIGhvb2tzIG9yDQo+IC0JCSAqIHZtX3NpemUs
IGFzIGt2bV94ODZfb3BzIGhhdmUgYWxyZWFkeSBiZWVuIGZpbmFsaXplZCAoYW5kIGFyZQ0KPiAt
CQkgKiBpbnRlbnRpb25hbGx5IG5vdCBleHBvcnRlZCkuICBUaGUgUy1FUFQgY29kZSBpcyB1bnJl
YWNoYWJsZSwNCj4gLQkJICogYW5kIGFsbG9jYXRpbmcgYSBmZXcgbW9yZSBieXRlcyBwZXIgVk0g
aW4gYSBzaG91bGQtYmUtcmFyZQ0KPiAtCQkgKiBmYWlsdXJlIHNjZW5hcmlvIGlzIGEgbm9uLWlz
c3VlLg0KPiAtCQkgKi8NCj4gLQkJaWYgKHIgPT0gLUVOT0RFVikNCj4gLQkJCWdvdG8gc3VjY2Vz
c19kaXNhYmxlX3RkeDsNCj4gLQ0KPiArCWlmIChyKQ0KPiAgCQllbmFibGVfdGR4ID0gMDsNCj4g
LQl9DQo+ICANCg0KSSB0aGluayB0aGUgcHJldmlvdXMgZGlzY3Vzc2lvbiB3YXMgdGhhdCB0aGVy
ZSBzaG91bGQgYmUgYSBwcm9iZSBhbmQgZW5hYmxlDQpzdGVwLiBXZSBjb3VsZCBub3QgZmFpbCBL
Vk0gaW5pdCBpZiBURFggaXMgbm90IHN1cHBvcnRlZCAocHJvYmUpLCBidXQgbm90IHRyeSB0bw0K
Y2xlYW5seSBoYW5kbGUgYW55IG90aGVyIHVuZXhwZWN0ZWQgZXJyb3IgKGZhaWwgZW5hYmxlZCku
DQoNClRoZSBleGlzdGluZyBjb2RlIG1vc3RseSBoYXMgdGhlICJwcm9iZSIgdHlwZSBjaGVja3Mg
aW4gdGR4X2JyaW5ndXAoKSwgYW5kIHRoZQ0KImVuYWJsZSIgdHlwZSBjaGVja3MgaW4gX190ZHhf
YnJpbmd1cCgpLiBCdXQgbm93IHRoZSBndXR0ZWQgX190ZHhfYnJpbmd1cCgpIGlzDQp2ZXJ5IHBy
b2JlLXkuIElkZWFsbHkgd2UgY291bGQgc2VwYXJhdGUgdGhlc2UgaW50byBuYW1lZCAiaW5zdGFs
bCIgYW5kICJwcm9iZSINCmZ1bmN0aW9ucy4gSSBkb24ndCBrbm93IGlmIHRoaXMgd291bGQgYmUg
Z29vZCB0byBkbyB0aGlzIGFzIHBhcnQgb2YgdGhpcyBzZXJpZXMNCm9yIGxhdGVyIHRob3VnaC4N
Cg0KPiAgCXJldHVybiByOw0KPiAgDQo+IA0KPiANCg0KW3NuaXBdDQoNCj4gIA0KPiAgLyoNCj4g
ICAqIEFkZCBhIG1lbW9yeSByZWdpb24gYXMgYSBURFggbWVtb3J5IGJsb2NrLiAgVGhlIGNhbGxl
ciBtdXN0IG1ha2Ugc3VyZQ0KPiAgICogYWxsIG1lbW9yeSByZWdpb25zIGFyZSBhZGRlZCBpbiBh
ZGRyZXNzIGFzY2VuZGluZyBvcmRlciBhbmQgZG9uJ3QNCj4gICAqIG92ZXJsYXAuDQo+ICAgKi8N
Cj4gLXN0YXRpYyBpbnQgYWRkX3RkeF9tZW1ibG9jayhzdHJ1Y3QgbGlzdF9oZWFkICp0bWJfbGlz
dCwgdW5zaWduZWQgbG9uZyBzdGFydF9wZm4sDQo+IC0JCQkgICAgdW5zaWduZWQgbG9uZyBlbmRf
cGZuLCBpbnQgbmlkKQ0KPiArc3RhdGljIF9faW5pdCBpbnQgYWRkX3RkeF9tZW1ibG9jayhzdHJ1
Y3QgbGlzdF9oZWFkICp0bWJfbGlzdCwNCj4gKwkJCQkgICB1bnNpZ25lZCBsb25nIHN0YXJ0X3Bm
biwNCj4gKwkJCQkgICB1bnNpZ25lZCBsb25nIGVuZF9wZm4sIGludCBuaWQpDQoNCk9uZSBlYXN5
IHRoaW5nIHRvIGJyZWFrIHRoaXMgdXAgd291bGQgYmUgdG8gZG8gdGhpcyBfX2luaXQgYWRqdXN0
bWVudHMgaW4gYQ0KZm9sbG93IG9uIHBhdGNoLg0KDQoNCg==

