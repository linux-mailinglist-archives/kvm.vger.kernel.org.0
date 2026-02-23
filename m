Return-Path: <kvm+bounces-71447-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDhmNwLhm2kp8wMAu9opvQ
	(envelope-from <kvm+bounces-71447-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 06:09:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 76682171DEC
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 06:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2519F301D315
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 05:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6403344DAA;
	Mon, 23 Feb 2026 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dXqZgz4g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAC63191D0;
	Mon, 23 Feb 2026 05:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771823357; cv=fail; b=VmQ5FQtz0rgFGiz1uB4PYUuOcKAkEyyHCKFBktE74GhegVOi0tRF6tcJ2nMwR77Pi5j0oQVkKBqNgIBabE0dkfsbCobn5Y1cRFTgsoC/7X+INrupVHli372H0sc/t4gwM67dZwafRwNB5P5NVoum1/KSHVHpX/bwcYRpW9uO9jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771823357; c=relaxed/simple;
	bh=dmI3nLgXXS3JOgvWARp5ZYcV4MtaAw5Ba4m8dLd6pqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EQkZxb0DIgpItF+1xSYmmziY+ESwbdHLfrc0kCFg+mCrt57o6fKtt7q/aCOAbDkCgHflHWwJUYJ5OayB1wXRsjzcl9A8OJSOBJI5eE+l44QlYo42IeWA0VCtUbhGEP909aPKYhruO3OPsDYfI7b5vP/wdQmunHTSE6mooXyfolc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dXqZgz4g; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771823356; x=1803359356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dmI3nLgXXS3JOgvWARp5ZYcV4MtaAw5Ba4m8dLd6pqU=;
  b=dXqZgz4g1cQxY8dHcMuT+vFMsu6HSRKD1UQ7f3WhyZa4vkhv17yXIFMP
   wCbEvfK2p0JjbUNAgEtt5rBFkWkT3sp1/ZOVB9F5PBmL8heBay9qAV9eD
   tbIoRNNv4C/37tsKNEnm5wxJJlZ5tbYAPZ+Zz/XoDlgLzi694VXLojWuy
   0GtNVvRCqSoX9Fw1KHf+4/nx10fjzVIquQsQNJRkiEmxVG4B71gdNeDeR
   MN+Ph2oqL2cyN4AHwTdjRAqwyJw8K2UYrTTJYeF0HhlwZyw09PpMqE53O
   EUDTBC6DgaX4c3A5eW9MA94Ozx9fKDfOmkYIohoNz6MaN7udsdWbPtSn+
   w==;
X-CSE-ConnectionGUID: oXf3own0RTySzqzlJ8kFHQ==
X-CSE-MsgGUID: VHx+T8XOQpW20qGR01fMpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11709"; a="72852710"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="72852710"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 21:09:16 -0800
X-CSE-ConnectionGUID: D5ZFb0uMSg+EDIhcDuzFsQ==
X-CSE-MsgGUID: qNItZxteRhSUgjfjYiWf5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="219013267"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 21:09:15 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 22 Feb 2026 21:09:15 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 22 Feb 2026 21:09:15 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 22 Feb 2026 21:09:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=maufwOGN0RQluklob32wQVmZXKcYpFAlnTYqEBqI86/zJbFk4tN+XNmCnDp63BGUxvDj3peG0hPOH/TEdooKEpQILQ44idsh0VLUpCWRo1eyNg70smSOZGCBxZx6g+/wAHpGpQmGPEFhOKsaW9n38SijLGDWn3jHuHmk8+0gPDicgMh1nGz0TGSrcSdYjAMksM0DO+SDvB1cufmrQutte/Bca5aVDHTMw28JyGiHUhDUR590fgP4drH7zaF5dfLFjOaSD6pqlC0w2foESOSoz/T2kIYAMibz1YVRJzwSBOK8LSMY3vPWoqb4nkUnBeDGlTlzK4cAnmPNt0gJwhbsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmI3nLgXXS3JOgvWARp5ZYcV4MtaAw5Ba4m8dLd6pqU=;
 b=CH+Vk4giyb1bpcuLz2tgl4iRXdXdkDivbUyj9o3BAtPfj329ovhCIQ0Kw5vUP7NTJOldV2jSWy32+h2bjcduGgJjDQ2mrYwcN+T6kWwYsWXi32259naKTdiJxXytolxtHmVMAZ7LBVfoB+h0oo2zHIO7//EapvfsGU4949Ys5IHLljyT/gJcdzWbwth7O0o5MHAZgl/3/5ENcCqA+8km3c+cssmBPKsIIPdzRYgc5eHVDFOVY6mqSL0IssI3vAQRyzkfGeSP+y3RxXq79PjlSbD1WtehlwG0G2HAsxN/vsjI5SI9oyk+aUh6jkQEr6qCDwbqhc75nxsGPalZ8SrThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 05:09:10 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 05:09:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 20/24] x86/virt/tdx: Enable TDX Module runtime updates
Thread-Topic: [PATCH v4 20/24] x86/virt/tdx: Enable TDX Module runtime updates
Thread-Index: AQHcnC0C9pL0eRcGNkuohikvchZcs7WPzLkA
Date: Mon, 23 Feb 2026 05:09:10 +0000
Message-ID: <5bd8500eba9a8e83491c02ae84f81b55ac09dacb.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-21-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-21-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SN7PR11MB6604:EE_
x-ms-office365-filtering-correlation-id: 022f30c1-6bb4-4cd3-0f85-08de7299adae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TW8zbFRkR0ZxalZHNVdKSS9QY0hVZmpTdjFMM0JJVm5IOElkN01EU0RoNldN?=
 =?utf-8?B?WVZqVTB1TmZtYTBQNWk3TU9reWtmUTdxNUk4SnNVT0swNUo2L2sxZDA1YnBD?=
 =?utf-8?B?eVkra3prVUx4WTRNTzVQQkhnUWRxZW9DcmVSRW54OE5ueHFYMlpQU2pmQXZY?=
 =?utf-8?B?SGs5OU9QOTBtYlBNUS9WTlVEVnB5NzRWTzhNZ0Nmck5UNXlsUHlZTFdhcEN2?=
 =?utf-8?B?d3lTOGFkZXhxWHRBTWVsOW5QeWNaTDMxMmpCbUxaSTNBUmI0aVkraUJNMGtO?=
 =?utf-8?B?QTRuV1NWbmQyOHpON1NjSWlGTVVsYXFOUjdBUzZCMkp1Y1ZNOU9La3hqaWhn?=
 =?utf-8?B?SlVaZ2s4RE5GZ29LVTZpK0FhMG9sQ1ovWHhHQk9HOEdaanRyRUQ1dzZWQ1Rr?=
 =?utf-8?B?ZjF1VVVQc0xYcXJpYVFvTjJSTVNlWDB4dWtXUTFvNE9aVkxjZnNFODdDbm1V?=
 =?utf-8?B?WHh1M1duVnVPODNUY243V2tyZkRxOUd2YVREUkpFdHdxRnZ2QjdHMTRiMkF4?=
 =?utf-8?B?bkl3cU1EQTdTUzRhZHJwNEhuQW9sSFMxZmQrY2pDRTAzNWRLK2wrckhLTGdM?=
 =?utf-8?B?UWpHTnh3QVhtazN6Y2YvdnNYRUJIYjNPcitLMHpnYjBhVjZXc055ajhDdWsr?=
 =?utf-8?B?N2RPRmVicjJTckRJYzJybWI4SGZUU2VNMFR6YTdWY1Z0OC96L2lCczR1bmVF?=
 =?utf-8?B?cFJxQWtyWWlybG54SHIvS3VjRjhTRktZdWVhMTFSd0o3RTYyTERqOElqTWpt?=
 =?utf-8?B?c1dua3FqSFZFU2tsMGxnbWNBbWNGSWcwUi9yWEFvenZYaU1qMnBRK1IxMzh0?=
 =?utf-8?B?c3p4QVBpdFdRZG5JcktyTmRCMkJvS1RkVnJwdWFSSVdmbzVQZTUrZ08zbGFO?=
 =?utf-8?B?RkRQZnd3TnAybzlMVUdxT0dGZFdzTFV6VG51ck1vY3VWcHdxQTVjZyt0MXg2?=
 =?utf-8?B?d1FLdlQvV1h2MEE2ZTlRb3lSOGY3QmNiZWx5M085dlpwZEVjWWtuOTBYV3Y3?=
 =?utf-8?B?bXp5aW1ZcmlLT0FTYW8zdktLOW4xZ1pjV2ZONFkxSzFNZVFHODVaOFRtQUJ5?=
 =?utf-8?B?VS9pV1ZnbXZlNy9SSk0xeVpsV2l1d29IdUFRU2dGUFV5M01FWTBuQWtES2NZ?=
 =?utf-8?B?Ulp5SzZpSTMwNWFEbDdFSjZRM0crdXNPWDhuMWE0bVVUUzlFUWg1R1BCL1U3?=
 =?utf-8?B?VFdVdjdRbEdCRXZpdmlMR3M2RnFSTmpZaGtXZUxwRVFxMHNyS01zNnU2L0V1?=
 =?utf-8?B?VmlZOWFYeGZlNUJKNllaa21ZVkxJb1B4cGFxczRDZ3RjdSttU0tZeVM4WkM1?=
 =?utf-8?B?dk1JWVVNMjdXTnRCemxXVGIwZ3V4WVZMQVp5T2dnUjEzQ2pIR2d2MmtBWEhj?=
 =?utf-8?B?MzlLeWhKNlBKOTNJdjdkUkpOM1VsYjRVMmJpc2xKaEtxT1JGSHNidllQUm9i?=
 =?utf-8?B?Z20wMmtjTG9OZndSc3NVNkczOUFCRU9IS2RpY0tIMHVGeEptQndLaVMrcWpX?=
 =?utf-8?B?MTNFRkxsR3UrN1QvTEY2a2N3WUxEMTgwcXVXOGtZWXlDNll0dmpabWMyclVp?=
 =?utf-8?B?WWdHbzN5anlYT0V4ZE9taE9rU1g0aFhCeGZITHF1eWs3a05GN1ZlT1p1NVZO?=
 =?utf-8?B?N3ROL1NhWjh5VGpLNnZTaGdMbWg1L1hjSmxCR3liVk8yQTVJRzFUdVRkODY5?=
 =?utf-8?B?RDJXMkh6Sm9KZVZySHlWZFNPTW1VTWJuZXpMWCtBNXVWL1RSR05RUjNTeEcy?=
 =?utf-8?B?eXhTd0VBZitJWlZuRzdkdlNpR095MGIxc3RQYlc4Y3hlcG8wY2xUQzd6cEtz?=
 =?utf-8?B?bkh0RFlMSktXRGIzTWU1RXZyT1h1ai94anhXdlBuR3pqbXAwRjBUMTRoSFMz?=
 =?utf-8?B?bms4VG84OEVrRUVQU1VwNVloZW51Q0M0cEFJVHNRQTZ6N2J6K29ZeHpqbUlU?=
 =?utf-8?B?L2ZNQWpubkhxK0V1WDJaR0RTVm1idVdQMzJNV1hXNnVXLzdoeTZCR3pPMDdD?=
 =?utf-8?B?Yi83SHQ1SWdNVDJ4djhkTjBMVjRiUWt4cmhWTk50d1NHV3ZTWWFEMUhCeEFx?=
 =?utf-8?B?SDIrTTYwUWRqcWdJcDBGZ0hOQ2k1dDU0ZGp1NEF4WWhFUHAyVUVCa3ZJQUNH?=
 =?utf-8?B?Z01pdWNDajNvK1NkbHlFQlZ0YnlYMVNJYXBqbVlmSEFYR1ZqM0JWTk9GYjhW?=
 =?utf-8?Q?gEO1rz7MRc16rxTLuXHZbtg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0pIaEZ4SGJFdHZWcUhqd3J4bkNGNis2M253ZlkzMDFzL2JDeHY5QzhIeVkz?=
 =?utf-8?B?dUVUR1diSTA1NXVCMVpERTMvekNvbXJvdzdLRWJ1T09iWVZ4L0tOakZ1SWtz?=
 =?utf-8?B?b3VsR3BKVnRMNTg3WkVVTmo3Z0JoSFVONUFxMUg5TVl5UjZBbVdyejd1K1Fx?=
 =?utf-8?B?OFJSSnhWZnlWTUdGUjZ3TWRldUZ3LzdOcWdYYXJvYjh0cVBaK2k4Q0RzWEZM?=
 =?utf-8?B?QlhJY0VWdTRQV1hTUFdYcWY3S2QvZUlsNnVtMkJ4Slo3a3N2Mmx4Q0dFWjhR?=
 =?utf-8?B?TkFQM1BhRTFRMUNKamxzWEt6VjJrWk52V0szekM4VFNrV3ZmNFZna2J3SXdW?=
 =?utf-8?B?a0oxMFBMTU9XR25kdHlCaFU0UGpxTzZDamNRTThCemloa1ZZVUJSVzJXNE4y?=
 =?utf-8?B?TTZmOWlUc0xUVTl3ZDlzTzdEb1pBVFVxOGVaaGhmQjJZQVR2enN5WjdHZVl4?=
 =?utf-8?B?aHpKbEQ1WkpDWTNjbktpNGM2NW41azl6Q2oxYTVwelJvSHVwMU1mcHdndWtQ?=
 =?utf-8?B?RHJPVnZOSk1TTmVnbFgzUmt1UktPd1hVMElRWkpGVG5LVWVpZVhTTzBXN0dG?=
 =?utf-8?B?TnpBcDJFT1pkK2p3ZlFUVkJTUWtmS2U4YUxFSkFjWXV0a0dwdXE5dHRmOEt1?=
 =?utf-8?B?Y0QvaVMvMzZ0RFpjRnV3QTlWNUFycXNMQytjL2xScmpJanFtcVBUaHdaNjZH?=
 =?utf-8?B?Uy9zZFZHTytpengxQ3ZyZis2d2hyYU1iTGxVOFZjODRMN1AwUUY3SVBQM0hs?=
 =?utf-8?B?ZUFGUzk5ZlRMaytseGFCM1NKS25VNXRSbFhNTXRUK1dReWVWbVZnWmZrMVk0?=
 =?utf-8?B?Ri9mYVdhTTJOVXFLNTcxalU0UUY0R0JmTnEyQXp5QjNFOFdneHBtL2NTT1RY?=
 =?utf-8?B?aWc4TEtXdEdYRGlieXJaUCtuZ0JkNjFwMUxNSy9PM1Q3Vnl6bm1uUWxqcWEr?=
 =?utf-8?B?Y3hrNExRcmNEN1BDeXNScXRCRDBsUndOM0VtaXJBeFdOc0d6QXFabjRqR3VU?=
 =?utf-8?B?OGI1QU1GS2dJN3dubkd3NEExV1c1OFdLSk9KemRXMlROa0NJV2dXbXJjQ0xQ?=
 =?utf-8?B?em4zTnN4bU10WXRObkFQbVA4MjBVRkFSMyt4T0ZNODhTMytISXA5Z1dMMmdO?=
 =?utf-8?B?ejVYSGRrQmhzSkVySkpxM09Va0k2dVh1UHRyVnZEd016UzB5L1loWEZQayt4?=
 =?utf-8?B?UDlraWFDaEZZYUEvTWRYQ0ozTjlDK1YxN3h2NG5VRDQzaTR2dWFTMXRyY21j?=
 =?utf-8?B?TGEwcXRETkNTQXlpQjhaQUpHTHg1cVNCOUZiaUpuWG5xZ3pHemJoek9KMEdw?=
 =?utf-8?B?MGRXejQ2SlY4R3NPbU5JU3ZPM1FhekhHRkhmK3JZb3dZcnlqUDdUR3JsMEsw?=
 =?utf-8?B?OVFncWF3Q0FkUExFbEVGZXgySWQzUE0rVS9TbGUxTEpFalErSTdwNWRBWUx6?=
 =?utf-8?B?dlFUMWVFeElxVkJXWEV4TURaR1d6S1R4TFJicy9qeDVZS2RJc0dBc29EN2dn?=
 =?utf-8?B?Q0lQTGlLUXdzaGd0NHlVZlJjU1RqMzJDYzRQUWZDeDRxQW5oTjFVZzJQeDlK?=
 =?utf-8?B?bTgxSkNOTXg5TGtSRTlTVFNHNVJPL0RLSWllVEFUaVAxaUhmNjZ0ZHVoMEln?=
 =?utf-8?B?bndnMXFjL2t6SG1KRHQvclRwK3RBY20xU2xVZnR2WUFDY2xaaU5PaDIzTnVv?=
 =?utf-8?B?QWRXc0I3bVZueGx0V0V3blVpU2djZkFFY1lIRXdEanJtaTE1WEhoaWlaSThD?=
 =?utf-8?B?Nkd3b2VzWElhVUVLZ1d4Vmw4N0JveUQzbElVWDBOUXpQQlEvcFZXWCtRTTdX?=
 =?utf-8?B?YmVuTDI3YXVjR1lLd01Vak9mbjg2K21qUURwN3Y0TG9jL0UyWE9BNVdBNDlG?=
 =?utf-8?B?c1YrMUVBZDZyWjhiSi9GYmlzbWxLVURjd2I4V05GMFpYUlhCSUtjempqK0pN?=
 =?utf-8?B?UzhaNnJuZzR2NFdHWnNsVGFxSHBzRWpicjd6LzUxRTY3K3BUSU1HTjVqNnB2?=
 =?utf-8?B?bFVPSnc1QlEyRFJRTk0vWURlWFpDay9lUEIzN2NkcXhtVWJhZUZDdEVsYjJl?=
 =?utf-8?B?akkrWkc4ZWR4UEZVR3VsSm9jaXpEQVdCVFlEY1N2QzJxVWZ6Skd1N0dzU1RL?=
 =?utf-8?B?OFlkaHVnaDI5bnFwOUg5Wmtnc1Q3TGRYTVpmV1dDL0hmK2Q0MWNyaUwvRDdv?=
 =?utf-8?B?ZVNTaWlhcHdZQVQyM1B3NU5tUUtjK1JMRU1pcDQ0cUUvUEdERFpsNGhlR1RF?=
 =?utf-8?B?cUtXZURVc2V6RmtVZnhBcU9rekFMVEYzQ21vaEJoUXBJTkFoQUZIUTZ6Zkw2?=
 =?utf-8?B?WWxCS0JwUDJ1c1VMcy8wdUZsYkIvV2VTQy9BekNiV0h2UWd5bkZjZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6497776FF094B34E8AF9B24ADA157930@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022f30c1-6bb4-4cd3-0f85-08de7299adae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 05:09:10.2395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7aKOp1K8+BiES26whCslo70uxrtKFlX5tLSH1bzBT2M7X/Ft/O5jxnMGk+PqgTv3dbEeKc+OZjSgVXIDCAUPnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71447-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 76682171DEC
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gQWxs
IHBpZWNlcyBvZiBURFggTW9kdWxlIHJ1bnRpbWUgdXBkYXRlcyBhcmUgaW4gcGxhY2UuIEVuYWJs
ZSBpdCBpZiBpdA0KPiBpcyBzdXBwb3J0ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaGFvIEdh
byA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogWHUgWWlsdW4gPHlpbHVuLnh1
QGxpbnV4LmludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFRvbnkgTGluZGdyZW4gPHRvbnkubGlu
ZGdyZW5AbGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gdjQ6DQo+ICAtIHMvQklUL0JJVF9VTEwg
W1RvbnldDQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggIHwgNSArKysrLQ0K
PiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgMyAtLS0NCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4g
aW5kZXggZmZhZGJmNjRkMGMxLi5hZDYyYTdiZTA0NDMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3RkeC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+
IEBAIC0zMiw2ICszMiw5IEBADQo+ICAjZGVmaW5lIFREWF9TVUNDRVNTCQkwVUxMDQo+ICAjZGVm
aW5lIFREWF9STkRfTk9fRU5UUk9QWQkweDgwMDAwMjAzMDAwMDAwMDBVTEwNCj4gIA0KPiArLyog
Qml0IGRlZmluaXRpb25zIG9mIFREWF9GRUFUVVJFUzAgbWV0YWRhdGEgZmllbGQgKi8NCj4gKyNk
ZWZpbmUgVERYX0ZFQVRVUkVTMF9URF9QUkVTRVJWSU5HCUJJVF9VTEwoMSkNCj4gKyNkZWZpbmUg
VERYX0ZFQVRVUkVTMF9OT19SQlBfTU9ECUJJVF9VTEwoMTgpDQo+ICAjaWZuZGVmIF9fQVNTRU1C
TEVSX18NCj4gIA0KPiAgI2luY2x1ZGUgPHVhcGkvYXNtL21jZS5oPg0KPiBAQCAtMTA1LDcgKzEw
OCw3IEBAIGNvbnN0IHN0cnVjdCB0ZHhfc3lzX2luZm8gKnRkeF9nZXRfc3lzaW5mbyh2b2lkKTsN
Cj4gIA0KPiAgc3RhdGljIGlubGluZSBib29sIHRkeF9zdXBwb3J0c19ydW50aW1lX3VwZGF0ZShj
b25zdCBzdHJ1Y3QgdGR4X3N5c19pbmZvICpzeXNpbmZvKQ0KPiAgew0KPiAtCXJldHVybiBmYWxz
ZTsgLyogVG8gYmUgZW5hYmxlZCB3aGVuIGtlcm5lbCBpcyByZWFkeSAqLw0KPiArCXJldHVybiBz
eXNpbmZvLT5mZWF0dXJlcy50ZHhfZmVhdHVyZXMwICYgVERYX0ZFQVRVUkVTMF9URF9QUkVTRVJW
SU5HOw0KPiAgfQ0KPiAgDQo+ICBpbnQgdGR4X2d1ZXN0X2tleWlkX2FsbG9jKHZvaWQpOw0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIGIvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5oDQo+IGluZGV4IGQxODA3YTQ3NmQzYi4uNzQ5ZjRkNzRjYjJjIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gKysrIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5oDQo+IEBAIC04OCw5ICs4OCw2IEBAIHN0cnVjdCB0ZG1yX2luZm8gew0K
PiAgCURFQ0xBUkVfRkxFWF9BUlJBWShzdHJ1Y3QgdGRtcl9yZXNlcnZlZF9hcmVhLCByZXNlcnZl
ZF9hcmVhcyk7DQo+ICB9IF9fcGFja2VkIF9fYWxpZ25lZChURE1SX0lORk9fQUxJR05NRU5UKTsN
Cj4gIA0KPiAtLyogQml0IGRlZmluaXRpb25zIG9mIFREWF9GRUFUVVJFUzAgbWV0YWRhdGEgZmll
bGQgKi8NCj4gLSNkZWZpbmUgVERYX0ZFQVRVUkVTMF9OT19SQlBfTU9ECUJJVCgxOCkNCj4gLQ0K
PiANCg0KTml0Og0KDQpTdHJpY3RseSBzcGVha2luZywgbW92aW5nIHRoaXMgIk5PX1JCUF9NT0Qi
IGlzbid0IHJlcXVpcmVkIHRvICJlbmFibGUgVERYDQptb2R1bGUgcnVudGltZSB1cGRhdGVzIi4g
IFNvIEkgdGhpbmsgaXQncyBiZXR0ZXIgdG8gY2FsbCBvdXQgaW4gY2hhbmdlbG9nDQp0aGF0IHRo
aXMgaXMgdHJ5aW5nIHRvIGNlbnRyYWxpemUgdGhlIGJpdCBkZWZpbml0aW9ucy4NCg0KQW55d2F5
LCBJIHRoaW5rIHdlIGhhdmUgbXVsdGlwbGUgc2VyaWVzIGRvaW5nIHRoaXMgc28gSSBndWVzcyB0
aGluZ3Mgd2lsbA0KanVzdCBzb3J0IG91dCBldmVudHVhbGx5Lg0K

