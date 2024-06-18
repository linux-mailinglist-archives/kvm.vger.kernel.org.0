Return-Path: <kvm+bounces-19901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D881290DFE0
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D28AE1C230C8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED43185E56;
	Tue, 18 Jun 2024 23:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ntti4cmT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C517E441;
	Tue, 18 Jun 2024 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718753367; cv=fail; b=DnIODTE3jaJAns/4J2QbyzILsZ7BISoSxvinOvW9JKNq+3LYtZkhRZgaKFNlKgFt61LOh0QDK2TbRkOorjNkro+/WogaV9qeax0/MTwEqMe5w2tGuq5Lhd21ZcD9+cx72uejDMwf7IyuawZcvkhEdIGNh2YSXIRrP45TyqmhCJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718753367; c=relaxed/simple;
	bh=SAak2wQqrkhRorN3vzTxXoAJsUcfau33skRvyM7nzwY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OV5T6eLy1VExOKxHNlUzZSNAz5ewj82x6qYHb/KiQ8460PLlIWJ1a22FwdHyySQ7nyKfu8ydoass7G44x3xj5T07jnIwON3e/YmahWGCAsxiCzXgMor6OoLnzHH6OILWCp81kcb0FNdzU2S/1akPF6RMq3bo1jQlqan9zX35fGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ntti4cmT; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718753366; x=1750289366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SAak2wQqrkhRorN3vzTxXoAJsUcfau33skRvyM7nzwY=;
  b=Ntti4cmTXxVtsk23hK3MSYwsNvF2bPka7VChMTwWmeeZLqquS1gepI5J
   9NdvaqtwNm4Zh8UnFTuXij14hnpcer8/Nj06Su3+6+Ud+GBcCvP+THTbD
   JOB2XKPpMVa/gqcX2uA/zHFtXorl5b7rgFr7UKHqAenTk2WZSuLDEqRLi
   IVaxYWqkSArFGeiB06xVW9QreF8pkTD9IRcdQ/WhFHM5dpl4YKmfBU1jo
   PSD9tQuyWhITMes9qstBQ/5txvIWuG07J5o6v/HQoCmFO27g2dAKmr5Au
   Kk7ubFv49WQkgdQreFA8yDWxW8NNBOb/sJsFYAuedozdLjjRQDg2EZxaX
   w==;
X-CSE-ConnectionGUID: Bhuhqo1UTAmtb+EEG94kyw==
X-CSE-MsgGUID: 19V1XetCTQuppa8TosSShA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="38184646"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="38184646"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 16:29:25 -0700
X-CSE-ConnectionGUID: u4PTX9rySJS3VuYCbWWp8g==
X-CSE-MsgGUID: b5J9JqCUTAWWocXZ6+4JpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41815679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 16:29:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:29:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:29:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 16:29:24 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 16:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDESK1X3h5irMUZBQcIO5TP4tV+j7BwazMlB9+USDhItugCE48lIwITkSm9iLvl8NMBqHuP9OtMXCGkG81dWq0ZcvDA5HuFE5IixavKy/vlVXnE9tVaqaEyIuBAa0uiqEtyViLC/1SjXxYJfBPjIqDN4mKZOsEbCRYxS2SEllGQfNbkN/d3/1TRByWxarVzjAdBVdX36l3PFs5IbTY9rA7/SBDRLVTSc2imKd0H+QmFh2wzeK8rIhiTRCB/HY4/LzWxSJaQWkcLa3+FSJzD7IGPJZ4obSSgXZrYXLxCpLKjWI9526LbJBCpjVPEUFljqsNZtnQzoI3RL0zHSoY/QWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAak2wQqrkhRorN3vzTxXoAJsUcfau33skRvyM7nzwY=;
 b=Rwq14I+TgII9ABTvFl3GiXiU7fw8ACAlGWIhV4H9OyHOwrSaY+nS8raUfHHFcLJjhC7z7r0/ubppaTlSur0Ts8UB5RSstGzHHelyu8fAdxo/xu72I6k4AmnjziiUKaKXsuyERN2s25knt31Hc3puz7beyBSWQh1yyvEWVE7HHrNAK1pPlCJrsB7RdRdfNqYE/l408CM9YnDLezVfDsUZPm6NUAIfODGyG+x+xb2+HU6PIPySJ1uzUOb9BDS1f508fv48l9XV4nynD3375eaWRZnWTokbbnH/8I/6aWNJmBww+bRx6nVyneOoSeeEHgWMPWGVU+eInU4MzgZlzzrIhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8298.namprd11.prod.outlook.com (2603:10b6:a03:545::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Tue, 18 Jun
 2024 23:29:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 23:29:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 2/9] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH 2/9] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHav+T9GnguhKq+lEOVevT9AQWKy7HNY/eAgADK64A=
Date: Tue, 18 Jun 2024 23:29:21 +0000
Message-ID: <a3fe0e3a4869282e9fc440b3be498f06c60b351a.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <43c646d35088a0bada9fbbf8b731a7e4a44b22c0.1718538552.git.kai.huang@intel.com>
	 <6fd59803-252d-4126-91de-e65908fca602@suse.com>
In-Reply-To: <6fd59803-252d-4126-91de-e65908fca602@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8298:EE_
x-ms-office365-filtering-correlation-id: 56f6372c-c754-48b1-2a07-08dc8fee7b64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ZUNUdFBJblBvRSs2TFo1SHAvbkJvdFoweEdtQ1pod3FMYTBHaEJXYzUzUU9L?=
 =?utf-8?B?ZWpUekhWSkV0MXE5emRpMHhQVk1NUmFFcXJtQ2tmd1kvaStVb0d2N1Jrd0tR?=
 =?utf-8?B?ZENVODVzYkNVK0NHenpJNTl6UWMxOW5ldDl0WVVSWEVlb3JpMFpIUStTV0Iw?=
 =?utf-8?B?b0FRbk1Fa2FUNzNEdU9OZ2pyNHBQcHkrZGxYOXE2N09mWW1YRmljUXE4VXhl?=
 =?utf-8?B?NFR3K1FCbDZrVFBYL1dVT3JTVFRrZytNUG51K3AzRmFSMnJneEVaOU13ZFRS?=
 =?utf-8?B?dGVXUFBxSVhRdDdrb3ZSLzFLVHhQenFnRmhONTU0UUhFbWpscE1MeXdrak45?=
 =?utf-8?B?cm5BK3IvbElkU2JRTllSZkhDcDJUUDdQVEtYL1dsN1ZZemEwcCt5VHVNUXhu?=
 =?utf-8?B?dkxOUVR1cHhadmx1VlphY2hBa2xScDE1S0FWMXdETExhWUllOS8wRTVzTkVP?=
 =?utf-8?B?ckJ5dllsMU91UFJ2OEFPRzU2VktxY0phSHNqTnZUVURjaER2QkpqYUxYeEZm?=
 =?utf-8?B?THBhR3ZEWkg3SGN2VkhadDBvczZHZ01NYTJDSnZaY0lKVC9hdjJYNlhQekZn?=
 =?utf-8?B?WkxQSzF4QUtVc0RrL2JjR1FCVEwrYXZJWmFVZzVVWURkdmhYRE9Mc2FiVTl0?=
 =?utf-8?B?M1B3YXJmSlJQa1dOcC9Db1ZYWWRxSXJSSDREOHVuRy9RQS9sOHowSnVlMis0?=
 =?utf-8?B?WmpkNGkvcUlJVmdPQ1Jpa1loVFZzRlRrNkJpUHYzWk8zWVRhbkY2T0grUml1?=
 =?utf-8?B?ams3L05teEpqOW1idXRaUUNCKzhEWDFrM1dNZHdaWlhzQllWOFNXSlpyVk9X?=
 =?utf-8?B?ckRiaTVZaDJLdjhzUFIrbmdIK0FnbHN4VmhIbkQwUWhERVFjdzdXZVlqV2E2?=
 =?utf-8?B?VGRLN0d1WHFGZVQ0OTlTV1Y5U3dPcWFMTllwM2dPdHFUdGtNN2JOblhwYWsx?=
 =?utf-8?B?emtuVGRmUnZhVk1BSENJS3lMeFhkbDFIOEpuUTB5RXhhM1VQOGc1bjY2dGpy?=
 =?utf-8?B?cytUbS93eEordlgrNEtCeXJTQkY4d2R4M1pxWXZINkdQak1NQjJ4S3Z1Wm15?=
 =?utf-8?B?WUNLUWg0TU1BNGlkSWdlWWtkZGIyN3dXcmgrcTdiSGZZZVBmSUdYVE5zZ1Vr?=
 =?utf-8?B?Sk9keEFmdmxHQ1FOUDV6dXVKUHFCWHFSaVh5Z0hMNS9SN0k2eEVzeWx4L0Ey?=
 =?utf-8?B?eXRnaHBtYjVqM3JSUnVSdHphQjhrZzIxb2FMUEw3TEJqK2hrQ1NBZVdkNXc5?=
 =?utf-8?B?dytJRGE5a2hyTFVBaFhGWFNrUmwrbHFudGNlNXk2QlJqd1VUS2J5UHdEUU1K?=
 =?utf-8?B?a1MwNXVmUjRoVVpXT3g0a01QQWhiSUpPWVJjaWpGeWYzZ3lIRk1OdXYxL05x?=
 =?utf-8?B?UnVkTkJYOWRibTFpUG1Ta003UGNBZGQ0dWRlZTAwd29KZk9BVk81WlJmV3pI?=
 =?utf-8?B?NEpQWlhjRS9mNTA0K3p5SS92WWMraWMwY1FrTy9ydkc4azl1cUpIUEVLbWpR?=
 =?utf-8?B?anIwMGJnREdsMFVZZXFTcVlCejZHbjNhSEYyZE05SkVSYXBHZFdoK2pJYXlS?=
 =?utf-8?B?eEdZbGo5TW1NL0RXSmdpdTg2MThMU1JDVUREQmdURGRZQll6WjQzbnd1SVJH?=
 =?utf-8?B?VnQzQW5nU2RmaGZUTlF1RndHNkJSajd4SmtrUzk5c2M1czREMHc0M21kMDF2?=
 =?utf-8?B?cGRpTUZhVTBteisxaFBlQ3U4Zlo0Rm5CZERqVlpFMGEyWi9ueGRMbkltR1Rp?=
 =?utf-8?B?dy9XL0tTS3JDOFJnUEdRaDh2eFJWQ2w0cHdCQ1JmR01kQlAwV2gydjhTRldI?=
 =?utf-8?Q?epDyh5QpQvpP1FgYU1jdpK4MM1PuXZ4rPI/ZI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3JTdnRkaUpid044VGNiZ0dnLzlxUWhURHV3WEw2WmVwdVRuR2dwaEt4bHRX?=
 =?utf-8?B?d3FvK241VlVMM21GSG9XS2FmOUt2SFFVVGdLMXdDNWhmd2lVVmhnWnJJMzVZ?=
 =?utf-8?B?VGFWdEdCTnI5OStkeFVLUVl6YytCYS9vOGZVMm1CclB3K05kRWFuemF5Qnhh?=
 =?utf-8?B?VmU2U2h4MDNoa2YvdXIzcDJScGI4ODRKcW5wSzRWL2J6UlhNR1JxaXZqWlpI?=
 =?utf-8?B?QzlKUy90Z1R1elZ4Z2lIZXhJOVpMS1ZzNVJoOFZZWXk2MnM3UjFpRkJsZjBn?=
 =?utf-8?B?aS9xWUE0M3FYWWJPVDY3bG5NNWtjb0pHc0lWcWNZeUErNEpWZTkrZFZBajAy?=
 =?utf-8?B?T2IrTmV1cmYxTG1mcFRvSlBuM2p5Y0lVeVFWOHN0bEp0MWhGZUFzZzNNY2sz?=
 =?utf-8?B?RU53aVplQUlIL0taMzhIZHAvMEk4QS95NktBa05maUZFNU12bWlkN0pveERa?=
 =?utf-8?B?THM2QWtWQW0wcDc3TjkrV0tnbVVYWE80V3hPYzN4UTlRRGxwbjhORXQwUDh4?=
 =?utf-8?B?WmdQY1N5SmJpcEJCSW8xZVJPZktwUzhQWHNFS2I2TTlxSEZmOWhBSDBpQVBp?=
 =?utf-8?B?THgvRlF1bWk1RXFkZHJSTHV3TUhIQi8yRFI2UEh0bFUyVXNsbHV4dno2L3E4?=
 =?utf-8?B?Ukk4RFBKaEQ2REJQYjN4TTZnbm1XRWpGMENnZk41Z0RPb2lkNGZ5NkVKbFdV?=
 =?utf-8?B?amhBVVUvbVNFcURQcW01ZTE3d09xbXNWV3paZGF6TStDTENNZTBlWGtuKzlI?=
 =?utf-8?B?djhJcFBKMmhtRjhQbmJzLzU4NzExZW00bGtQNXJHYlFFc2NOL2ZwcTkyNk5K?=
 =?utf-8?B?azJxeG5sT2duWXo2TlNMb1NXNFJUbFJjMFo4cU1jRVRxRmR6LzRRTXZRTk9a?=
 =?utf-8?B?dXNsNiswUWlVL3ZMTFpqWHBOaXZNY2tuOW9NMjZUMElsR2lVSVEyaHR3MVBl?=
 =?utf-8?B?N0ZPMWRVYzJ5RGF6bWlHbnhMcWppS0NMbUMvbkZFVFhDbE9Sa0hZa0FXc20x?=
 =?utf-8?B?U3BtT09ZWDZyNFJyd3VHenIxOCtYWVlZa3lkeFZ1bFJNZm1SeGFieTFQTitH?=
 =?utf-8?B?NFdpWTVMenA2cCthaUI4NDEzNUVFb2hnaXd4alJGNVZmUkF4MXFuY1AzMnBz?=
 =?utf-8?B?MUxkV2xmUE5OUG1nU3ZINURQT01vdW9yUDg2TS9oWU91c2pqRVpFREppYkVz?=
 =?utf-8?B?SmxpSEVqbVgycGhXVHhPeUZZN3FSekFtOURRd0gxcGNzUW56dVMrLzh4ZC81?=
 =?utf-8?B?UzFKK0xnOHRNK0dHWEFYWWFPTmVIT3VISWQzc1VZNWxpL09rSU54ZXBCTE9h?=
 =?utf-8?B?Rk9NUldBbExVSEFkNmYvcVNlWFdMOFQyTFBwdkpCQjYxVDdiaDM2WVV2Yjg3?=
 =?utf-8?B?QjVrZ2JQbGFlcEhCQ1Y0bHZPeEpFTjNZTkZTTEhoOEFxNUQvN0ROQzB0eC9n?=
 =?utf-8?B?L2tCSHVFMjl2dHdOcXQvSEkzUVBNWWFyU1p2VzhnWmpVSWVyanlpS3B5Y3lr?=
 =?utf-8?B?VGovcVkwUkJzRGR5MER5VDRIYzFWTjJXTUVTN0ZZVWJnQ0tLOTE1ejNVOGhw?=
 =?utf-8?B?WDNhUW9yN280WjhiUkplWFN2bk5vVG9lRmxadEtkbkpLbWpaNHVOL3NoMDhK?=
 =?utf-8?B?Z2M0RGs0ZHF4RG9VSDFlbFVKdzFZcVVXdmZMallqaXJ3bnIrOE93bkpZdlUv?=
 =?utf-8?B?Z1ptcU4zZjNvZ1p3S0xSS1dHQW94VnM4aHNXbU1rQkd5Mk02cGxqVXcyN2FV?=
 =?utf-8?B?VDFKR3MwbzU4QzB0c3BCVHpNTHNqOWRiSkhPelBaUTk4emd4T1VSVjMybmRO?=
 =?utf-8?B?dEovQW1Ua3BKbnM4MWNYU2VFZWNZWE1DRktySmN2QmJMZS8xNVNkM2sycTlY?=
 =?utf-8?B?aE1TeGV2d3RXcXBmUFp5YUtUL3I0bHA3YzVzNzVFYzNnNWd2MGJkcTFZWk90?=
 =?utf-8?B?eXBROE5wSXZ0WVVSaVpVMndSMUxIQ3BNY1VUYmJzbTNBTXBPTmlaalJnc2lq?=
 =?utf-8?B?MFluNnZaRFpuUHUzS3lBZ3ZvUnZDcE45WkJjaXdHMFBUQ1VzTU9iOFd3dk4z?=
 =?utf-8?B?MkgzeGpYMUQ5Y05rMkNWODhDbHM3Z2dsWElCV2RKeGVvL1FZcEhnZ0d2R043?=
 =?utf-8?Q?tMBFtKtMt04vCnUwHulauJakJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D4786EDCD1BF644A2BC6AF9A9145563@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f6372c-c754-48b1-2a07-08dc8fee7b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 23:29:21.4596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/AvMSppEZNbujTzAGbLabZlq44fX9VFPNMzaEBT/zCmX0On0GWNgQ8eGU74A1RYgYK28yr23bKPfbMOASg8Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8298
X-OriginatorOrg: intel.com

DQo+ID4gICBzdGF0aWMgaW50IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lk
LA0KPiA+ICAgCQkJCSAgICAgaW50IG9mZnNldCwNCj4gPiAtCQkJCSAgICAgc3RydWN0IHRkeF90
ZG1yX3N5c2luZm8gKnRzKQ0KPiA+ICsJCQkJICAgICB2b2lkICpzdGJ1ZikNCj4gPiAgIHsNCj4g
PiAtCXUxNiAqdHNfbWVtYmVyID0gKCh2b2lkICopdHMpICsgb2Zmc2V0Ow0KPiA+ICsJdTE2ICpz
dF9tZW1iZXIgPSBzdGJ1ZiArIG9mZnNldDsNCj4gDQo+IFRoaXMgc3RfKiBwcmVmaXggaXMgY29t
cGxldGVseSBhcmJpdHJhcnksIEp1c3QgbmFtZSBpdCAibWVtYmVyIiBzaW5jZSANCj4gdGhpcyBm
dW5jdGlvbiBjYW4gYmUgdXNlZCBmb3IgYW55IGFyYml0cmFyeSBtZW1iZXIuDQo+IA0KPiANCg0K
T0sgZmluZSB0byBtZS4NCg==

