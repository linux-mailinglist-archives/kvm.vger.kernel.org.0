Return-Path: <kvm+bounces-53323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61735B0FDD3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 958CE3AA2BB
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 23:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D22F273816;
	Wed, 23 Jul 2025 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="al8uNzyt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08504282F5;
	Wed, 23 Jul 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315011; cv=fail; b=THDmARZWlFjZnhx5GvtxWU1FaPib3MPjEL4izPH3g50ToYqZeMT8Tu6ZSspScWAsmzK2+27lUlFXQEcl/Swa83WDzD3wx9dgMPJQrlVkrdESiHqPq3/A/jcjVOMMncnjAcKxCuL/E9PE42dTk1FtpYjXKBaJO/AtPbVIjeidsZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315011; c=relaxed/simple;
	bh=6ZItpAGVsO9Rv0HNrFyylKNG0bw4iu0UVzh09l0jHa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PNrWaRa3QGBofE9jYi5F18N5PfdNl/CdC/dZS8KuFVSGxWRWOuB9Yyw4FNzIuuGIW7G0QriSRo9OpA/U+F2g2AATSCT9joHvsUh3CR/wX88gj/YZs8t1NiIVOcqcIszvZmNxtpRkIJ/7u6bNWmANGcczClKehLYQni7981M54IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=al8uNzyt; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753315010; x=1784851010;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6ZItpAGVsO9Rv0HNrFyylKNG0bw4iu0UVzh09l0jHa8=;
  b=al8uNzytxprPvd/FOJ+tNcEjkzVujJn7ILP0hlIjocb58VnAq4jOVwTI
   bupwNtJVvwe9Pm2GVaC/yZJktSdhu4F3wO6HfQfywOMyGG2WmSK/0P0FN
   X7PnHkefbitjRHKlJiTs0SGT+/am7nWYJzuoVvrlEnvcxNuyueWrDrpda
   LpYoRWlnblq6jKHbyoHo6nBuiwf7nTDKCalSyl5ucHDAKiGJ+m33dIdi2
   zqoTllvLHXwgKInJKxMIitUbVAHr+oC42vobmoClKwVPTiFWzuIRATmH5
   5zKVLjTBuFbQ2F/SC+5wie6tlKLqqEYh26qztWCjyy9XnYAifVKejej0f
   g==;
X-CSE-ConnectionGUID: eFMecg8sSFSrTBv0Ocz5hg==
X-CSE-MsgGUID: F17OaTvCQrWUN9zwD8bXwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="67040992"
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="67040992"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:56:50 -0700
X-CSE-ConnectionGUID: efF3SXJ7QwS+UhuKXrqzDg==
X-CSE-MsgGUID: 9QNsbZAERdCCS15QCvZYvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="159103797"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:56:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 16:56:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 16:56:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 23 Jul 2025 16:56:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QARUJXygBAy9nwI3oulcMuHy87LoBOejPuDSyaK8irYWxj2fh61SKOVajrGQAXP2xHrcyedSEkwWOw2P65w21iDF/GUzrojSLvJCKRQH/5fk6kHEPn7b+Ozz/hsW4nij4Ac90cxaTIu2M2LTJl4ywUtKQC9EOGpW/nU5+aeAl3V0/mYaYi85VVic26Hqrjqy+DOaQEPSWdd1jKJT2Q4rpIPZytSIZCTa62qCkAqc6rEvrt5nZrkjhsjhZ1pvTGCXsNL4jHWSOjLk6I4b65k4I83uwUqkJMfRx8dvqUpnKXr3PyJkW2ZEODULNodXbOU0UMMcgoqyGEm7gUuRQPWRFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZItpAGVsO9Rv0HNrFyylKNG0bw4iu0UVzh09l0jHa8=;
 b=X5E14hAg1GmKB1zNkU++7NsZoJ582UW13W6nkumG+Fy3lcGJ7pC9kSVkUR3jySzaTwAUazpkYV+I6CMHIsl4Fa+RJS2/EzfhyEhxwwBqbySi2WxgJXHPOP7ZQ12MvTaWowpfBHCehZsBtKsnPiBzw6P8D5IQZkPz7mB/e+nSXPlK+pNNLVusSK4Y+3Y4EGMs/R8/pG2A/CZI9jQMyK8+W8hGm6LL0jB1ZsarJ1d7QU/gpo/DIYkGI+sDqdCR83Ec39onMHfJp1CpsPMm9xBGuBHZCpMpk01OZc5N14R/BBCEZiVx+hJ26kl6YWE+l2zxSO8ofMrVGKMuA72at/FX0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB8788.namprd11.prod.outlook.com (2603:10b6:208:597::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 23:56:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 23:56:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovevc+bw9PokmM8lb9WadM7LQ/vkEAgAAI0YCAAAHUAIAADQaAgAB91gCAAAcfgIAACGuA
Date: Wed, 23 Jul 2025 23:56:45 +0000
Message-ID: <0b2a23d7c30e91e47cddd3fc7ef911249c5d8531.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
		 <20250723120539.122752-2-adrian.hunter@intel.com>
		 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
		 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
		 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
		 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
		 <10af9524189d42d633b260547857516b49f9dc8e.camel@intel.com>
	 <8da9c9c9c53707ec805ccd1b7f8091081e3455e6.camel@intel.com>
In-Reply-To: <8da9c9c9c53707ec805ccd1b7f8091081e3455e6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB8788:EE_
x-ms-office365-filtering-correlation-id: 6539230a-0366-47db-0e89-08ddca4494ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aGo4VXVaZ1JSMnZmR3RNTkdjWnd4anlVbDJFT3dqQmFrWTR1cXNzU3FqRVQy?=
 =?utf-8?B?dVJlMWJiQTRpSW1vekEvWDc2aU0zTi8xTzhONDFWbVdTckJjMEQvQklGTzhJ?=
 =?utf-8?B?UjZTY3dMaG9PSHMwMDMyWHFzYVd0R2xIZE9TNTV1emIyTVpUd3lmKzJ6dk8y?=
 =?utf-8?B?NFZzWk1rRWlleUpWOFhOeUhmQXdjQ2lQcExqOXVON2hYcm9LanowM0grK3Yr?=
 =?utf-8?B?c1Y5amR4R2J3aXZ5T3YwUm1OdkZXVTQ3dnhiektZSTN6MFd2UTVrdmxMWEhu?=
 =?utf-8?B?S0xaMGRXdkxWRnl3ZGFmM25hTFhMQVIyNjJOSWtCbmlpMEF4bm5ER2JiYmZ2?=
 =?utf-8?B?eWlzdEU0dEQyRC9VTDBTUGZId2U5d29JMEhUcSt6L0N0REt2eTJvUmlXV0ln?=
 =?utf-8?B?RmY0R2VObXFaSks1Q1A3T3ZENERCdWZ1Q1ZBYzMva3hxd0VQWFZsNGNLZlVF?=
 =?utf-8?B?SllWMC9hZXhDNnJ4QkFOOVcxbTNTK0tvc3JoUTFycHdwSWFObGY2NTE1Mm1u?=
 =?utf-8?B?cDVKdmFEQnpLazZ4QXRoelYzZmdTM0N4dFdEaGs2eTEvdWxBNjkvdTFOUUZ4?=
 =?utf-8?B?R0kvSmZlUVpsazJSUVNUeUdBbkVnTlVZWFp6em5MQW5CV0hxTGdNVWwwNFBD?=
 =?utf-8?B?SDdZWTJaWWErYUlMUWxUUXFXRGkyVENPcStsNUZkdy9CbE1DandURk9JNUdX?=
 =?utf-8?B?c2U4K2dYbjN4dVY3Vkhoa1pJdjZrUnVsdWE2VnNnRWZLcFJiV3hzZlJnMHJG?=
 =?utf-8?B?OXM0S3M0NnlQM3ZybG5sRzF4QU9GaERBcjRvL3Z1anpUcThCOGpRTmVmL29Y?=
 =?utf-8?B?ZmQwU3ZhbDRTRmtKZkFNWWY1bk9ocjdQRStYWmFNWWlsL3piSVZjVVNMMnJo?=
 =?utf-8?B?RUc3clgzcHliY1B1TUxWdEE1bnNZMkdhUDZCVEJXTCtYNmFCSUZkNTMrSEJj?=
 =?utf-8?B?cU84RExGNHhXVWRTQUFyRWdXdU1KUmhMY0VFLzVjUnpDRVJFTzRLNnNtSktP?=
 =?utf-8?B?RFpxYTVpTjBxVGJvNjZwUXNncmNSQWZzaHM3QS9lcE5WODdWbXBmb2dQa1dx?=
 =?utf-8?B?VjkyMjZHeWVNSFZybVVKOTQrZWFneVMzL2d1V3pFdm9VYU10eVJqaWZJUnRY?=
 =?utf-8?B?clR2RklEQnJSV3A1ZllVRVVEcW4ySWZ4ak4xZW55eEdmZUdUMWl4NmpIeVF3?=
 =?utf-8?B?TlhVZVM1RjFvY3BKR3E3Tm9IQkh1ai8rL3pNS3lmbWZ2YVRsb2lsQ3k1K0Vh?=
 =?utf-8?B?MW1RaTVFRlozdnhyYzhJUVpvOTY5VWVITDY2bDhiakc1aUx1WGZENm1hMjJa?=
 =?utf-8?B?d3BXaHd2U2FMMGZmZlFsZllVVkRoZUJLeHNoT3dpK2NqNllUYVJHSXVNenk3?=
 =?utf-8?B?VU85MGpyUWVuc2ZXWlc0ZGdOTDhSUmZEcUlySjBKOVpuczYxeFk4aCt3ZWJv?=
 =?utf-8?B?V0tOVlpKNnZDTWsxMzZSYkFybktjZFdWYzRXbk83YWs0enVkbGMwWm1ZKy81?=
 =?utf-8?B?TFY4SHpQaDdoN2I1Sk40K3dSKytGNFU2SVpCTVRIa1oyRjlWbytxZFJFVUFQ?=
 =?utf-8?B?TWtERWNpVHN1QThSNExWaUsrZklhaVZrdzFuMjc5d05lMlJwQUhjeDF5SjNm?=
 =?utf-8?B?dDRoR3RtYm1FVm84cDdXcVpNaWd5UXdPVkEwcUZpN2phTVZIQ0RYeGhSNmJy?=
 =?utf-8?B?N2orK0VES3VrOHl5RFJtSlgvZ09WRytsMThqamFJSWdMdVE5eCtVZk9tOUNE?=
 =?utf-8?B?NGswUlZTNGcwV29SNVIwRGIrTW9nSG9GL1o4LzBySzA4clJTQk5qNmVSK1ZC?=
 =?utf-8?B?SmF6dDhRdjhTVHgyQmkvYUh2OG9JYWpnOFpHdE5RV2EzdnVReERlUnZpd2RG?=
 =?utf-8?B?dU5rQ1V2QnRUVUdURWJBeG9NcHNhZ01IMnBNUGlkaGpUY1VUM0RsNktSbUVv?=
 =?utf-8?B?K1M4VDdvL0RFamhHZWhCa0kzeDNQYTRIR1Vsb0JYOFVpdXZ3Z3F3OGJGMXhn?=
 =?utf-8?Q?YzocAz1W5jUAm2VHAh03TU76OjhOvA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3B1djF6R0NPSjgzeTJBNk5WMUE1V3lIR2FDTzQ4NUV2aWJjTlIrcnZYeDls?=
 =?utf-8?B?Y0phZ1UwWTZXQXZBL1pBRzVxb0NCUEI0MWpkUGRlaWliaWNnbW5VV1R6VWFS?=
 =?utf-8?B?TWkxYmVEeDRsUmlOQ2ZGa1BhaWluZDFaalRWYjRra09XMEJ5eUFYa1dPVmI5?=
 =?utf-8?B?L2NoQjVoQmdRYXdFR2VwMkppb05DMmRIVVQxNDdiN1FEUlZDTUVBdyt2SW9z?=
 =?utf-8?B?eGtPbjlNR3VjNWNZbitNRzd0cDhzL0JtNW9IR1J1SGpLSDBTb09QMUk5NHhY?=
 =?utf-8?B?MG9uZEdjck04TjFsYjNrb3IxOUx0Z3p3VXFsMlFqS09rUVEyR21ETlYxWVV3?=
 =?utf-8?B?dXdXbDRleXBkS01nTHN5Y3NaWk5KZG0wYW8zS3dPVnZIcUZpbVc3ZzBJek1G?=
 =?utf-8?B?b2c2b3RpdmFrVXQyWWQyYW1qTnd1bzFZRHpobFlnMkluYUYxSHJzMzJpWC9D?=
 =?utf-8?B?d2pYd1NLa1VBU3BFNFNrdzA2Zm5lU2Z6MGtyY3dXZmlTdG83TExLY3Uvc3NS?=
 =?utf-8?B?am1KbEZLUDRDUGM0dHQ4UFp1OTVEM1dFNWdzL2FGNGtqYmlyWVZiRmVkdjBo?=
 =?utf-8?B?TkVQTHMyck1ISHlyM05lUGtsZWpDdkVrY0xQZEg4Y1Y1dDBjLzRsZCtNZ3Yz?=
 =?utf-8?B?bGdpRjJTbjlmSjRXSUx6ZjlqOFBYUEhXQzNjVHZVVDU0b0IrZjJzSm15OXRC?=
 =?utf-8?B?M3NLcFc1WW9uQUthdzZRV3d5cUZDMExhNUFpZlRkQk9LaHVnYmJlYndLK0Jn?=
 =?utf-8?B?VzZxL256MUhrUE9CazV0TlBHaFIyV01ZVDZDWEJ6SDRJL3NvOGhvc3ZRejB4?=
 =?utf-8?B?MXVDYnZFZzR1N3JjekIvSGlsMkNMSXhWT2ExRDZnNDRpMkxoRDJlbGRFbkhQ?=
 =?utf-8?B?V2V2c1ZHS05JRno3eWt3SEFEZ0JiaXAvdG84Q1kxS0ZiakkwcDFRclhKWEZV?=
 =?utf-8?B?MmxHaFpPQ21McGtFSjlwU1pseUFBQWZoZTJYOHp3T29BRDhueW8xUitJbkll?=
 =?utf-8?B?MHlKQjJSUDJsVmlKQlh4TmxXSWNVUXhSTWlxNHFoT2hMZ3NxZytBSUxoZzJK?=
 =?utf-8?B?MDVpbWxuMUJBcWRqYWdLUWZGcStQcE4xcy9ibjBBN20wQXNrdHhjTWxCLzhw?=
 =?utf-8?B?SThlOWlpZjBJeFNHUjVPSXpmamU3M3gvMGIyMHR0ZWdRdnRXaHlBdlRpMmY0?=
 =?utf-8?B?aWVjQ3NVWWtNKzhwWHhqVUFOR0xUdit2VlRhZU53eG5hQXdLYVFCa2ZLMEhk?=
 =?utf-8?B?cGdmR3BjZVZ2dlhmcUp4VTBmU3JqM0ZNQ090RW1MRVhmeEgxR1pkVWRGNzlY?=
 =?utf-8?B?T2s0ZDE2RTBNbHVML0xReGxjaDByRWhIT0ROTVNrQ1RydDJSem9RTjQvaFg3?=
 =?utf-8?B?dHdUYXZiU2xtK1JwMThyLy9IMFNTanB4Ni9wTGdqelpxOEFEN2pnZXJBOFI2?=
 =?utf-8?B?K0xMYy84RCt0YUtrM3pyNlYxcUx5UnZTRDRTeS9SektjeUU0cTc4Vzh5cFlL?=
 =?utf-8?B?WTBFUVRRb3RPampXSG16cFNBTSsyM3ZOeTZKeXl2TlpJQlluSFNhWXJSNUYx?=
 =?utf-8?B?aWNLalJtdlNCcXg1TGI3SFI4dkM0TEs3dlduemwzU0MrclpVUVBBYVRwL0pR?=
 =?utf-8?B?K3RXNTJMZlBON0g3bG0zUFVtaHFCaEtlNVN4K2trZHBuUW15b0dvU0dKN2JP?=
 =?utf-8?B?dzFIN1VUdytLMVJpNHpzdndnS3ZIVFYrdi9vNnhFaW1iNlI4cmRTMVozRHA3?=
 =?utf-8?B?OXBxUklaa0pLMWpDeVcwZm9SejVxQVdRckpxOEx1ZGx6WE9HaEtUVVVjeUs5?=
 =?utf-8?B?cnFwMUJoSDZnTlBuQ2JxVlZsTithY3ZhWmw2VU5SNnJZZitMWkwwa0Fvejkz?=
 =?utf-8?B?QjhLOVVZVkpLMWNLMHRzZENkVWxlUExIQml3STJyRWdYRmlLcXJCQTlVVFRE?=
 =?utf-8?B?NVFkWlgvRzRUYlhsWXUwbFlWaXFBU242b0IwL1N6OWFWcXpwbytGUzUwYVNC?=
 =?utf-8?B?cUN0S2czRlI3U1IrbGw4N3dGSXVDenhBOS9sUkxhaHI3bis1Q01qYVJTcWJa?=
 =?utf-8?B?NENrMCtOY0daMGxDUTZWZ1lmYTdwK2JKa2Z1cE5MMVRIV3EwRGYzalFVTzhK?=
 =?utf-8?Q?jCFO43Jw1dQJZHRYfJL//6qkL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FE12C0E08301D47A18CA85C98AEF7C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6539230a-0366-47db-0e89-08ddca4494ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 23:56:45.9151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1HDKH+QftVCk9dU/LZzuDji6e3ZI67SsgqsTeZSAaRj1bzHFH3RjdtBhg0DXpyPQO4NY0xVPfHRq5VhuplSv5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8788
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDIzOjI2ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gV2VkLCAyMDI1LTA3LTIzIGF0IDIzOjAxICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IFN1Y2ggcmVuYW1pbmcgZ29lcyBhIGxpdHRsZSBiaXQgZmFyIElNSE8uDQo+ID4gDQo+
IA0KPiBJIGFncmVlIGl0J3Mgbm90IHF1aXRlIG5lY2Vzc2FyeSBjaHVybi4NCj4gDQo+ID4gwqAg
SSByZXNwZWN0IHRoZSB2YWx1ZSBvZiBoYXZpbmcNCj4gPiAicXVpcmsiIGluIHRoZSBuYW1lLCBi
dXQgaXQgYWxzbyBzZWVtcyBxdWl0ZSByZWFzb25hYmxlIHRvIG1lIHRvIGhpZGUgc3VjaA0KPiA+
ICJxdWlyayIgYXQgdGhlIGxhc3QgbGV2ZWwgYnV0IGp1c3QgaGF2aW5nICJyZXNldCBURFggcGFn
ZXMiIGNvbmNlcHQgaW4gdGhlDQo+ID4gaGlnaGVyIGxldmVscy4NCj4gDQo+IEFzc3VtaW5nIGFs
bCB0aGUgY29tbWVudHMgZ2V0IGNvcnJlY3RlZCwgdGhpcyBzdGlsbCBsZWF2ZXMgInJlc2V0IiBh
cyBhbg0KPiBvcGVyYXRpb24gdGhhdCBzb21ldGltZXMgZWFnZXJseSByZXNldHMgdGhlIHBhZ2Us
IG9yIHNvbWV0aW1lcyBsZWF2ZXMgaXQgdG8gYmUNCj4gbGF6aWx5IGRvbmUgbGF0ZXIgYnkgYSBy
YW5kb20gYWNjZXNzLsKgDQo+IA0KDQpUaGFua3MgZm9yIHRoZSBwb2ludC4NCg0KWWVhaCBJIGFn
cmVlIGl0J3MgYmV0dGVyIHRvIGNvbnZleSBzdWNoIGluZm9ybWF0aW9uIGluIHRoZSBmdW5jdGlv
biBuYW1lLg0KDQoNCj4gTWF5YmUgaW5zdGVhZCBvZiByZXNldCB3aGljaCBpcyBhbiBhY3Rpb24N
Cj4gdGhhdCBzb21ldGltZXMgaXMgc2tpcHBlZCwgc29tZXRoaW5nIHRoYXQgc2F5cyB3aGF0IHN0
YXRlIHdlIHdhbnQgdGhlIHBhZ2UgdG8gYmUNCj4gYXQgdGhlIGVuZCAtIHJlYWR5IHRvIHVzZS4N
Cj4gDQo+IHRkeF9tYWtlX3BhZ2VfcmVhZHkoKQ0KPiB0ZHhfbWFrZV9wYWdlX3VzYWJsZSgpDQo+
IC4uLm9yIHNvbWV0aGluZyBpbiB0aGF0IGRpcmVjdGlvbi4NCj4gDQo+IEJ1dCB0aGlzIGlzIHN0
aWxsIGNodXJuLiBLYWksIHdoYXQgZG8geW91IHRoaW5rIGFib3V0IHRoZSBvdGhlciBvcHRpb24g
b2YganVzdA0KPiBwdXR0aW5nIHRoZSBYODZfQlVHX1REWF9QV19NQ0UgaW4gdGR4X3Jlc2V0X3Bh
Z2UoKSBhbmQgbGV0dGluZyB0aGUNCj4gaW5pdGlhbGl6YXRpb24gZXJyb3IgcGF0aCAodGRtcnNf
cmVzZXRfcGFtdF9hbGwoKSkga2VlcCBhbHdheXMgemVyb2luZyB0aGUNCj4gcGFnZXMuIFNvOg0K
PiANCj4gc3RhdGljIHZvaWQgdGR4X3Jlc2V0X3BhZGRyKHVuc2lnbmVkIGxvbmcgYmFzZSwgdW5z
aWduZWQgbG9uZyBzaXplKQ0KPiB7DQo+IAkvKiBkb2luZyBNT1ZESVI2NEIgLi4uICovDQo+IH0N
Cj4gDQo+IHN0YXRpYyB2b2lkIHRkbXJfcmVzZXRfcGFtdChzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1y
KQ0KPiB7DQo+IAl0ZG1yX2RvX3BhbXRfZnVuYyh0ZG1yLCB0ZHhfcmVzZXRfcGFkZHIpOw0KPiB9
DQo+IA0KPiB2b2lkIHRkeF9xdWlya19yZXNldF9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0KPiB7
DQo+IAlpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19URFhfUFdfTUNFKSkNCj4gCQlyZXR1
cm47DQo+IA0KPiAJdGR4X3Jlc2V0X3BhZGRyKHBhZ2VfdG9fcGh5cyhwYWdlKSwgUEFHRV9TSVpF
KTsNCj4gfQ0KPiBFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfcmVzZXRfcGFnZSk7DQoNCkkgZG9uJ3Qg
dGhpbmsgaXQncyBnb29kIGlkZWEgdG8gdHJlYXQgUEFNVCBhbmQgb3RoZXIgdHlwZXMgb2YgVERY
IG1lbW9yeQ0KZGlmZmVyZW50bHkuICBJIHdvdWxkIHJhdGhlciBnbyB3aXRoIHRoZSByZW5hbWlu
ZyBhcyBzaG93biBpbiBBZHJpYW4ncw0KcGF0Y2guDQoNClNvIG5vIG9iamVjdGlvbiBmcm9tIG1l
LiA6LSkNCg==

