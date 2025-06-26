Return-Path: <kvm+bounces-50871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB38AAEA58A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FA3656429C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160602EE61B;
	Thu, 26 Jun 2025 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9+V2rG9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE09B2EBBBC;
	Thu, 26 Jun 2025 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750963331; cv=fail; b=td5BaRowdHF/rUhYAEMk2SHRfCfbBuJu+1/rtEFX9tNVaCCRWY0etIk8v2Nm9WrUoAUTrdG4fyWR6moRCP/IuHH/ZOeJ2ze4d7+C1fUHltsPEL4R/8UcsL8nSG9z2uJswMUAAfB27U1exIiajPky08hVSXnx2t1IVIx0/5wnk2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750963331; c=relaxed/simple;
	bh=9wC67jrYacklocDgz0CLV3gHiV297v1fI3h5+pgAw2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J71SkxlHijWvufD7k4Cz/68rnV+zwB6i8yZWpLagMcrmVtCEdi1aKBQbQWQA5zpX8yYDsNAigv84YfAphkPjV5W/s4hT4WjLwrceRJ/OKCy9XZm1IEhDi2yNfSWRfwOuu3N3mje7e89gvP+iWb4SFIdE3hZbNu9uLOrdHOmF1Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9+V2rG9; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750963329; x=1782499329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9wC67jrYacklocDgz0CLV3gHiV297v1fI3h5+pgAw2I=;
  b=Q9+V2rG953NW9YL4S6nivoDtD4EFp1XBL1pvo+b9tAfbCSgsc8kw0WoZ
   HK8ajO3j47xsxm1G/nlVO3YypaM3pIp9k04LmrSg6+XvkWlxLSJdXxkFF
   CwRI9QkPW9s3zUTC0Y/NhlvxIIl3yvIrV8nrgFWTGl3IIbe6HTKW5F9fl
   BHEsYuRTve8HYspGDpseaLGkASiz6YoRV7t/S6CsKvNJCyTvtRuQ7PFwi
   5Xxtbr1wAfDUZIIPhzCrjytCoQrChnfaupwaDkUQp1vYIwqsYllC/JKQu
   VaZmJlM+lXGohtq87blmt3rd8greLU52S3WOwHXag54qf8fgzk5XW2nzC
   g==;
X-CSE-ConnectionGUID: bL04c9nMS0mMOH0avS5pmg==
X-CSE-MsgGUID: ymlVXvtPS/abM4gf/wddFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="78708021"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="78708021"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:42:08 -0700
X-CSE-ConnectionGUID: JgxhEwZNRgieExZsk/Um3Q==
X-CSE-MsgGUID: yuXtf49OR9qtLWOuz0W2dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="156884005"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:42:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:42:06 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 11:42:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.84) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:42:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5DXT2W56T7+MnpBv67nXR5E7XsgGI7uo0Bx3/m480pjCAj5Y5wpd6zAGeBcExxyItiHRVZ097F3brCWpMcCBt2BC+kK7K0/0qpuyWExC+ixSrpOpQHezqfZbdFTSQ0/Z8EPFL2T7ui6AixHVzoX/0hccbDFCqC5gKZ6P6+SWVGqKn4vSpT+JUQ+oVaGmbG2aiYXHOF1oYNWuS8KL17I6cjXVLfLcOcrSGXP6rbzNkAj8EFIpMz0Jcx7VIRFvoZJfk4CJcXZeAGYr4+9W8R2Hfp/Rms+rF7nNSPEZuCL259PrJYRo3VkWqy2YPJxsfJAqAyxIHe5kW5W9PKE8krfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wC67jrYacklocDgz0CLV3gHiV297v1fI3h5+pgAw2I=;
 b=HGJ6jlThwCnppZM2up5hB/WFnWU0XdiOTkNQu4mlUgtmVAvNI48pyDjaoZXhUPh4ssGRy8BQLi/iFnwiVuQQ82OygfLcrPS1iW+xCj5UzC8JgPdOPNaIP96xc4seSjjHc4F+hHpSOGjUMEGd4Enr/X8OcG4XcdfNpsPpMtiKhB/f7XrVu5CGbcH9lb8sJPz2cZh2NyYG3DI1YzAPVsTdV91AjEDoeENWGWibIslC4+AVXKZPByLW16AGJ4iYdoDrZbjgJ3TKAyUxHvvhx1v/ecNC7bN55U0Pp17QVgsp65A5tMzsH/6P6H3wN+g+gQ66lIk/HQrPMk7S0JTcndOfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Thu, 26 Jun
 2025 18:42:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 18:42:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ogHnrnjyvYK5UawKKchMn8Ng7QVuv8AgAAL8oA=
Date: Thu, 26 Jun 2025 18:42:01 +0000
Message-ID: <b368fb3399d1e64e98fb9ad6a7a214387c097825.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
In-Reply-To: <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6359:EE_
x-ms-office365-filtering-correlation-id: 66816e23-3519-4b86-c6c9-08ddb4e123ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVV0V2tBWFIwMWx5NENvK0xqUGVmVTlBVWhNM1NqZnpGKzRVVkRGTW5uU1hu?=
 =?utf-8?B?UnVVcFlCTVBRNWpRZ3c0VlFPUnlReVB5UEZaVnZ2NWZ2YjZJcVBwZ0NydGwz?=
 =?utf-8?B?VnpzcEF3dXh6KzdKNXZid2h3SjhPQmFJbnh4Q3RiMGhiRjduczF2RUM0dHdV?=
 =?utf-8?B?YnpNc2ZOZnRCcmFpalVLNWcySVZ4Q3p1eE8xY0RlSEk2KzlJSkV4VDF3dkhs?=
 =?utf-8?B?eVJkSWlVcCt2NlUwdm5KM3F1aEU5R3dGZEFzaGNmRnRuUTN1RVZCWDFwcFhu?=
 =?utf-8?B?RHA3OUtMcXUyelRvUzJsS1hvR2t5RWROc1g1T3U5aCtDU0g0NW5zRzBxSk96?=
 =?utf-8?B?UHY4MCtSL2kvUDhVeFNVakJaL0JwT241SGZNQ2NiT3hyREZCdG5jMXNmMXR6?=
 =?utf-8?B?TXZhL0U0ZGxZMk5kQTVOVzZpbktBalNQUktjMmI4Y1BzUjA5K3BMZ3J1V0Uy?=
 =?utf-8?B?OUFLSTRoTW1BeVJIZUU5TzNVbURsTm8zSXNtSFlmcGdQWU1YSGEwZ3pscGJC?=
 =?utf-8?B?T1RQTEd2ZDlOUjFpc0tWVG42MTd0VFRPdko0eDM4dmg1OVlOMWxQYVh3eE1D?=
 =?utf-8?B?MVFTNm52QmUvMG5qMFNuOTZRUkYwUXFBaXNkcE4reTlEZTRlNm53djJBZTds?=
 =?utf-8?B?L0NSMEpDa255MXB6Ujk2M0NmLzEwOW41c09Sajk5OEdyc1VLWEZvdzREV05I?=
 =?utf-8?B?ek56anZkMGFVTzZQZW1SQms5RVFIMnlCejZ3ZTJhQndLY29JdTE4dlJ2MGx3?=
 =?utf-8?B?c0t2NmpRRkJndzJMUXRWZ05jam5qdUh2TGtJR1ZrditIa25lYUNWRWVPSHhi?=
 =?utf-8?B?VUY0bFk4ZE9tQUNOc0ZVWTYzUEpoYTZkMDdEbWlvVmlGRlA5OFhHSFMvSG5m?=
 =?utf-8?B?Z3h6alNGWWg3QlhKT1ZoZHFQU0pDd1Z4NDFmNVdNR3UzUWtsa1dBdEF5RFlJ?=
 =?utf-8?B?T0ZEQkZMZ1dRYmFhcWtRU0tLeFp4a1d5WTM1QW5xUnU3MXoyMXF1bmhPMkhS?=
 =?utf-8?B?Z3lKVDJ5UUlvK0RzZjQyNDYvNWhkSHZDUnhGcFlBVStpNDZ2Ykk4MVJiTXAv?=
 =?utf-8?B?eElSUFN5YVYxUW56bG0waTdPbGNHV0ROdFZLSnhNMkNWbHM2QlZUaVEzaTdu?=
 =?utf-8?B?SHV3bUJpY0lOb0xSSGVHZzNESVlKWkg4aWpOaFcxVUZrblMzQzJ5U1NaM25J?=
 =?utf-8?B?WHUwdUQySVlIQlJubWFFeXljeEMzV0dUaXpvTUdpdXJvUGJWblpUY3FlNFBo?=
 =?utf-8?B?VlgwRElUMXQ0ZWk1em1vYWdFVktUdmhyY29BN25RU2NPZWxyK2dEWTM2cWpZ?=
 =?utf-8?B?aEJGeXBjbVFSK2ZTRzkrOWpUblNkVmRxN3Y0a3lHQWlyVTBjejdBVEhSeWlE?=
 =?utf-8?B?bkJobzRvRXdQY0YvR3QzRGllOUlZMDFWN3Ric255R2hzYmZZRVNKUlRtYklT?=
 =?utf-8?B?ckZxM21Ra1kwTU1KNFhxRmM3NUxrN3NTdlVHdUwvTjlxRCs2MFNxdnRLMUpM?=
 =?utf-8?B?cFIyZjcrVmdGMHova0RjbEZuMU4xU2F5NmhRTm5TZzZwNjFsb2U5blBKZ1lr?=
 =?utf-8?B?dk51NGZhV28rc0xCOUMrNG1mK2xjaGNZYzlEYlVxQXNZdGxLZDVEZVJpOSsx?=
 =?utf-8?B?R2x5aXVSWmg4elF0ZVJRU0hDblpiSWZjQ2wrMmZpWmRCTU52RnZiQjJiTXhU?=
 =?utf-8?B?V21BMm92ZFhLNEdEaVZ3dmtCUE0vUXlleHVpS1IxNHZOZytvQmR1KzFva21p?=
 =?utf-8?B?dWY5M3d0RW1mNDRqVWRyR0NtSHRpdmREcUZUSXJtcWdtLzZnM0ozVnpxZ0pK?=
 =?utf-8?B?RVNGbGlISzhqVHNLbEVRM2drMFNvWTNZMzZ1eEM1UDlrSGNNWVdQZTJvK1NU?=
 =?utf-8?B?TG8xbjhlMHZjbzcwcWljNlJrU1dUTkVhN2tTdHZWeXdWcFdVYjdFSWtpNGhQ?=
 =?utf-8?B?cWk3Myt4cnhHVjVFaFJOTTJNa1RYR216Vk93bkJJbFVxVmNEVnlhcURucnNi?=
 =?utf-8?Q?nUpyQGqFLmmIL5o+IxW2GlTFI5xzVk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2pmNVhEYnV4RVB3UHYyTzV0UCt2OWtEWmpwczFPVnVmUUFlbUtLQURTaTZl?=
 =?utf-8?B?QVVBZ2c3S0V3Z09VcW1WVm5EQlhzaWlkWnNIMktoM0dnQnFoVGJtRVRzK280?=
 =?utf-8?B?MGVQclNrMzlKanVOamNaL2tyYjlsZDF1RXpkbHVueTFkcHRJUndIZ0dDdU5m?=
 =?utf-8?B?cmhvdUJ0Rlhzd1RCdTJWNWZVR2Zva2diTTk0U1c3dzRhcTVzUmV5Wk9PdWJh?=
 =?utf-8?B?TEc3SnVVS1hYZmxlVVlkN2NlUlZXMUx0ZFJMNFhwZXE1cTlxSGFKTDZ2c2x1?=
 =?utf-8?B?dXdYU2Y0MkZJUmc1QWdRS3hwYUNjQjlaTHF2eFZobnlIYlE1RktNV0t5OGNn?=
 =?utf-8?B?Z1k4YXlTS1VjaW9zOHNiR0EzZWxMb3UxY2szREd6YmxTMmhHRVhueHdvK2xm?=
 =?utf-8?B?cFA4dlBlQjROQnVTRjVEYXk4TkE4dUdQT0RSU3NZaXpNYVJBVmRsNEhvS2lo?=
 =?utf-8?B?d1FINmVhVzBpRVM5YmZxaDRJMW5YZmowUE1ZUXJKWjV2TTREZC9NMTkyZXJ1?=
 =?utf-8?B?RWxqQWlYMWhVSndGNGdFZkVTVnNEaW5jTUF3dC9xWEhXN3N1L3dSejJscnIv?=
 =?utf-8?B?cmVhWnhJOURkODVEU2FXMEQ4aFBoTUd6MzUwcGZ5Q1l4MlZDZ2p1dW9ldGdK?=
 =?utf-8?B?RGthWlNValdiTDdETHBwMndDQlB1SVRYT3M4RFZjT0hCcVFqMzhOOUlxU3o0?=
 =?utf-8?B?ZjExQnlVMkpqQWZadHUvNTRUZlZXOTFKSGJUcjhzdnBJM0N3T3F5SG9LMTZB?=
 =?utf-8?B?cHpHWElxUUZESXlNb21QdHJBQmxwUEFzbExOU3ZNTTUwbjJDZEFBZWhiNlo4?=
 =?utf-8?B?S2ZXd25ncHhaZkxkV2VVSlZoejdINFozMUFveUhDZnVSRWNhazVqaWVEL21B?=
 =?utf-8?B?WUJaaGFNdGM4QUpneXNYRFVkR29QUUhadVlXZGt6MC9xT1l2VDRObGZzNitB?=
 =?utf-8?B?aE5GR2pIS2QzVjgvKzNCeUR1WHlSRklUMmtOK1dUeU9NbGcyNG9vTXVFays4?=
 =?utf-8?B?VU84WHlJejI5NUF0bk9FeG9BVk9rdjdtbTBBN2c3Y2JJTFlDRzNqbHd0Unkz?=
 =?utf-8?B?UGtMSThZWWNTenlsMEIxQVMzU25yUjROVUxKMlpWVkRPUUoxTWJ1eWdsRlR6?=
 =?utf-8?B?cTNvQlcvNWxjMUpjTlpSeWptNG42eHdJR0IyZzFZbnVNKzZpQkpRZGljOUVM?=
 =?utf-8?B?N0hIR2RzVjBjNXoraG9nRWV3U1grSHMwL0lXTlhtZTgveENYVUNtTzZMYWdD?=
 =?utf-8?B?MTdKcGJwMHJvZmprSStMNEV4ZFNuMWgwMTZzb2x0aXhzNTNBU1ViSFNMdzA3?=
 =?utf-8?B?WFl4bjZtbzUzM3ByVGRMdENDV1paZWZ6bVNRYjBaak0rcGc5WG9jWjVLSHdX?=
 =?utf-8?B?VnlFNjJ6UXprdnRqUTkyditZUjMwTTNPN2YzV3JtVmVPWkJWcE96OE53bDNn?=
 =?utf-8?B?S2RYQnF6b0JvTjB3QjByVFJBaW9uQ29kaFRnWlN6dHZadmVqcHRDZENsTDZP?=
 =?utf-8?B?VTRDaUF5VWlZY2ozczhNVklpMWNPNnh2UVNmOXZtMC9ISkF1TEtucmNTRW1P?=
 =?utf-8?B?amVkSVdVYnVBNjJNYmVmZ2tGczlicE1xZWszb2xPUDBOM1BHbVVBRjZ1OW9N?=
 =?utf-8?B?TjVmR0dQUGxyaFdPQWVzS084OVBxeWhpUmptS2pPMUU4dEo0ZVVwS0pHeGYz?=
 =?utf-8?B?U1Zxa24wdWpyaVdpQkdzelF5L2RadjhMWVE0clNnMzZOL2tPSm0zNjB3eTRt?=
 =?utf-8?B?ak1UTk5McGc3N0tGZ09OU3BKOUxHZjRjVDFlUFVRaVZiOHRhbHFrQXVBUUN6?=
 =?utf-8?B?M2grVzRJalYwSEdscyttUlpsazI5VmpXME82akFMUjRiZWtid1hNSnloTWxh?=
 =?utf-8?B?R29LSVlRcTJQTGRSckg3WHhnYWxmZnBMU2lQZ1FjNkVvU1BINVl1NVlKdlZZ?=
 =?utf-8?B?TmR4Z0kvVWEzaU9IbGxheHYxd1ZBVmlKWmdBZ1dDTDFYNG9CNFBNb0J1K2tp?=
 =?utf-8?B?U0dZcmFsODIwOXdubHl2eW4vSkI0WS9YNTcxdXE3akh5eUpBeEt6bEs4Q0FK?=
 =?utf-8?B?OHlseFRVamI5SVBPRURlSFo2WmdJamdzRDZBM2FmR3lFL2FHUDZqZnJ0SHVq?=
 =?utf-8?B?ZHZSZXR0WVZBNS9JUmovbU1zeEx5NnBBdDhlaE43WnROMFhPNlZSVGhtOEt5?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25C8E81FB238374588AB69B066BBDD6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66816e23-3519-4b86-c6c9-08ddb4e123ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 18:42:02.0012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Gz3HGCqa/HvjIBqqIyNyYsVpfvHUkdgYMhtamlZeLa4oQQZZmUTMeMvpje+X1A+g3GL2OM0oXAES3JJTVw9+vRaCLblaOobjdRUm9qvQRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDEwOjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gU2luY2UgdGhlIHJhY2UgaXMgcmVsYXRlZCB0byBzdG9wX3RoaXNfY3B1KCkgaXQgZG9lc24n
dCBhZmZlY3QgaXQuIEJ1dCBpdCBkb2VzDQo+IG1lYW4gdGhhdCB0aGUgYnJpbmcgdXAgQ1BVIG1h
eSBub3QgZmx1c2ggdGhlIGNhY2hlIGlmIHRha2VzIGEga2R1bXAga2V4ZWMgYmVmb3JlDQo+IHRo
ZSBwZXItY3B1IHZhciBpcyBzZXQ/IE9mIGNvdXJzZSB0aGUgZXhpc3RpbmcgbG9naWMgZG9lc24n
dCB0cmlnZ2VyIHVudGlsDQo+IGNwdWluZm9feDg2IGlzIHBvcHVsYXRlZC4gV2hhdCBpcyB0aGUg
Y29uc2VxdWVuY2U/DQoNCk9oLCBkb2ghIFRoaXMgc3R1ZmYgYWxsIGhhcHBlbnMgYmVmb3JlIGtk
dW1wIGNvdWxkIGxvYWQuIFJpZ2h0Pw0K

