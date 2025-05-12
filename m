Return-Path: <kvm+bounces-46267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBC8AB469B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1439119E08B0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4FC299953;
	Mon, 12 May 2025 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dzDfvdlh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A1644C63;
	Mon, 12 May 2025 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747086259; cv=fail; b=os2Yp+bm7XFQvANqt6Cn0jjIE5wUX/3iUKufmuQwVSi3W23FCEL6QVu8j3U1vU2ZjLEbsVLMLY2isphlcWc7qCPKfAUwkADP31XXiqQmOBWAtqYIRA893AufisboJe/YfAUCboyynWoeXLi4iNfVz41QfmN87lmZMdZCCmnRrrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747086259; c=relaxed/simple;
	bh=eS2bE1EJCjxZMFKjpgdzSh68UqRPR+QYJTdz/P40OqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JGtAVUb2HkiHRqpoG0G9gqOoIp3dcDLTDEpDlmCLdpgHc2F8vyFoL33v03DEjuBasxj5rFVhDX0PQOo4ykbb3qyljbtFd5tbGC+GyMLnPzhJCDv/eaKcQO2j5wiKWEGdbJyK497yz336hldE/aLlZD47aL/uqpB19rQf/3ZfIa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dzDfvdlh; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747086258; x=1778622258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eS2bE1EJCjxZMFKjpgdzSh68UqRPR+QYJTdz/P40OqA=;
  b=dzDfvdlhuKMWfhGBVzS3fsBwrkZN/FMtVqPLEXM6UPE4IYCDUFvVFlna
   MnZHbABEHQ7sszdUJ2p/GkDTfMJ0SXOO68a0XRfPik+ZFtH1RSRHksBFT
   w+nu+ipVlRSbsOeywwkCTpFHubClqpLTClvlEDGOzer7yeoXseY8hT8Ru
   5Gsba2AA7cHmkKDDuEgK9X5pmFWgw3LQR8bKGFRIKEDYsRiAKa2k3krKF
   YOgIBXKKxzO28zgIWDZKWAOavwA3dgrIynj1teI11pnPnmtBXakIryBig
   SKGZScmNFmFvHhLEMPOnC9hlMHYBJ5wtwQq4KhHi/wE3/iTVo9qaNHIT5
   A==;
X-CSE-ConnectionGUID: p9Mm4WCrSZyQkmG9VqAzFg==
X-CSE-MsgGUID: YEs8lsOnS3+PFyFCO2qp6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="49026811"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="49026811"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 14:44:16 -0700
X-CSE-ConnectionGUID: uWfKLKh8Q4SwujbTDggvoA==
X-CSE-MsgGUID: Y6MmGTnqTjqJb+YciOHoOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="137517010"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 14:44:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 14:44:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 14:44:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 14:44:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYYjPZVG9LBQVFdOy4Fs4v5FZpH312TRAJy9C9l5XoVr6VZLY/AqK/9Iu5J+xd75DFq3fJC7gBxlnL9vQAtoEh3cSflNsc+fAE3qyFHnZCHzVGE5IIOGybw6miw5S/19Vlc8iojmKZp/8tpAgv0/UIDjHixQZRM+80lGuvxvm3wpkoljnqWJU8K+8KoF02RvOdpzoJHNiSS1w5PZMCZwPxQLDgORpRCo/2oWtXmnImQZitf/Ueq3MMHOUABhlqMm0jpP89qbna+rKWzghh585BJQ//FZUIuWXWKMmMsEi4yMToZFQNjQEdUgG3hDgDMahvH5Y9iJ386/MyQAMeLdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eS2bE1EJCjxZMFKjpgdzSh68UqRPR+QYJTdz/P40OqA=;
 b=zQYN+z6Sr1FXMNJtgm6as7QOOA9ysBAX0jLFbf4YfwW4JCwcg2I/EWS5ZPGovzv7ukDoMsFKvOA7cy87R9UlI1i7rGMXIigxYIg91c+q8UHlU1e+ANBLtJrS75BnNwuu9TUIp1qEEM1IfoP71AoAHBggucKnrziVLTbQQd4KqQKwvJH/pkJJF22+wzJmGD6Q3Mi6TFG/kifLXW01i/0JqAtv8n9gMDAXw9PqUY9npXssrYmXSD/j445BuquHMl4cROC1MBF3OJOQfdIKAUTWknKAsmspnVR53AFdt98oHtePExBQePkKYVJ8Ll9Pt39668gB7CHLCDWTQA5oA0IzVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7933.namprd11.prod.outlook.com (2603:10b6:208:407::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 12 May
 2025 21:44:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Mon, 12 May 2025
 21:44:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan"
	<fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHbw3A+oa6IyFmYjE20iNGeetRU+LPPhxuA
Date: Mon, 12 May 2025 21:44:11 +0000
Message-ID: <f454a913de6233b3afaacac9a2284a8359e3a5b7.camel@intel.com>
References: <diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7933:EE_
x-ms-office365-filtering-correlation-id: c413426d-95d5-428f-5558-08dd919e21ca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SFFwZWFxQkNTblRXQ0N2M0RMcDJLYmkwNjhIRzE4YmFvaGdxZTE4ZHlENE55?=
 =?utf-8?B?dEttUFJaQ2hkUytIMW1CZUlkU2JYZ3dzK1l3SFpnaXcxdTdoRzNobUJvUklO?=
 =?utf-8?B?VUtjYmhLUS8yUzR3bUJrM3RKK1k4amlEeUYwTVNnbTA3Mk9MWU9pZEx2Lysr?=
 =?utf-8?B?RjRSa2RnZ1pNdngrSXJFdFBtRU5QMHozMDRKNTlHdXVuVEh5cXdPcTBwYzdD?=
 =?utf-8?B?RitBSzIwNXcvMkpMOVI2dWE3bTkvaDlmc1JrRnNLdm14VEEvVDNoV0l0aTR3?=
 =?utf-8?B?WXB1b0V2aDZ6TXBZOWcyaEQ3dE5aZHJVaTNoK25oalc2RXlGMHlWbis1MDBT?=
 =?utf-8?B?UzJRM0dVRkIxb1d4MXRaS3dNUGc2d2M5c0haR2szdUFTZTNLNmtqNHhQVlFk?=
 =?utf-8?B?QUpFSWsyUG9FZk4xWVNoMUcwWnVnU3o1NHpnRjdaMDBZKy93bWRaYzBMOVVU?=
 =?utf-8?B?S29ESmJDcjcwVGcwb05Mc0RYRGJCU0p2eE42cmtUMkxneEVST1l0blB4UEpx?=
 =?utf-8?B?V1lRZjNxRnlvTzBqNEVMUGlQWlpiaGt3STNxTm9hZ0E3YWRpdkRQUlFXWFZy?=
 =?utf-8?B?VjM3UUpXWlN2Tkh4aFJXVXpENFROL1RmbTlQZW0xTEIvczRDaWQ5WEMrcjlV?=
 =?utf-8?B?ZSs1b29DQTdMd2c2VlNDTEQ4U1BLQjIzVEQxcXdqSGRNUXF3Z0IvMlRVTXVS?=
 =?utf-8?B?T2UrTVEvYjlselpUNEQ0Yzc2TG9nNUxabm1mdElCWkpvWU8va0k1OFB5citR?=
 =?utf-8?B?V2NLUm5NOUxWTGRqaGkvZXcvSVZ6bDc1T0ljRUpxS0VvM2p4RXJUVFdzUjFr?=
 =?utf-8?B?bVhVajV3d3g1MTBKTngvL0xXU0tmaVFpTC95TVBhQUZ5TmExQ0dhaGd0NzhO?=
 =?utf-8?B?aHFVY0lWRXY1OU05b1lwTlh5SGF1bzVkaVpWc0xnNjRjaFpNNFpnMGFHQW80?=
 =?utf-8?B?OW94T1ZCRkhPdVlpYzN1QU5JK0srYVJPQ1hFMnoxRUlQbnVmUFpham5kYytS?=
 =?utf-8?B?MnJKYWFsZHI4a2dsY1RpQjY5OERkZTRiMFcvU1NNUXlSOE4xWWgvNjJHQXVu?=
 =?utf-8?B?NXdvZlpCY2Y0WkZjM25XWE1GUE5sT3FpbElCS21RMjZJSnh4MjN6OU5neFdn?=
 =?utf-8?B?REVEUFM5SXNHZFEvUStISkJtZlVvSUJmcE40d2RkSGh5R3JLOWRVSTkybHYz?=
 =?utf-8?B?MER3ZUNIY3R6ZTNBZVdxZWJNTmMwNFNOMVdDYit0dlNPYWd2TW4wcUdKTDBn?=
 =?utf-8?B?bGdtYTJ6Q05LQnF5aXBuS3I4Rmo0d2l5eGdFaTFTWEcvTUkwU21IRk9xTFU3?=
 =?utf-8?B?L0kxR0oyZXdLdTEzZFlkSVJYd2RlTE1adWdQUTdQQ3VHOGFPYTBiaSszYVBo?=
 =?utf-8?B?UXA4VFlIQXpBUlVnQ2l1UEVoYW5qMkVxTnFMVXo3ZXhyWVlMNHFEK2ljK05Y?=
 =?utf-8?B?KzIwN0txOUhQbkVFTlY0aVV3U2hEWnRvbDA5ZjBnYUtTcEtqQ2RGcHVGM0Nr?=
 =?utf-8?B?c1R3MzFaeXhhLzZYMUdHWm93YnBKWGxBWk1nT2FLWmtyR3R1MzdZRzYwQm1Z?=
 =?utf-8?B?WitLNjNzeW8yRHdUREc3L0lRTmdleGQwb3NZVVhHRGl4blR3N1hOUW9NVHJD?=
 =?utf-8?B?TDJuMkFRZXY4WEZhYlMyeHJiMGNxREV5ZlFvRkxocDZVdENUemphMEUzWEVS?=
 =?utf-8?B?TlpPZERGUnZwVGl3Ni9XUm5kQk5Sa1NEL0k3d0hGOUErN3BaNUp6MzYxeDhr?=
 =?utf-8?B?VjhXSUcrOGMwVW5DUTJYaDNGVHRUUFo5dlBiSGpWMGkxcTQwSzVjbjBQK0Mv?=
 =?utf-8?B?TFhkZEFCR1VVYjdLRVdnRGZSRDNxTDc5RGxpME83SklXUTB6eGZZbEE0bGNO?=
 =?utf-8?B?b2M2ZFhYQmFYZXgwTm5CWVpMZWZ2QWJIT3RWekJQa3AvSjZjNXlRd05ncnJ1?=
 =?utf-8?B?SXBBZWR0aHNNOCtMbXJabmdJL2RuZzhleTZXVEdWOW9PU1hNdDV6RGVFa0dC?=
 =?utf-8?Q?mUj6ZAOXkbm+ZhBDDvsbnEL2/aoQsQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkhVM3VqLzZ6YTkyUHFrZ2pLUE1rKytsOUYrNG13NWdyL3F2K3BYZ0Z6bzFs?=
 =?utf-8?B?d2piTHNIbGgxSm02UFRlcmRlNk1BNjVSL25xaGJLd3gwa1FCOWVBWGJHWTN3?=
 =?utf-8?B?S0t4aWp6dVRDSEV6ZjRGVDVzTi9NQlZBbWQ4TWdpMjhaeit4WWIrUkw1Mll5?=
 =?utf-8?B?SXpDZEg0RzRFUUR1VDdiQVVqdkFpcElwK1VtUTkvUjRhbHN4U0pxczNBRHVI?=
 =?utf-8?B?cVBmdjEyeGJkSms1cmhvRVZ4QUpmeTQzQ2xPNDZTQnFsOTgvcmcvZHkrYzM4?=
 =?utf-8?B?UnExblhtSnYyZlF0SlVXaVNwTmZvMHByNi9QVzdnR2FIM2NWV2FzNEl1eXlL?=
 =?utf-8?B?RVBaZ2RhT0lIajdhRlBQUkFWWENrNjg2R2M2OUhZTmd5UmdnTkJSUVo5bEdi?=
 =?utf-8?B?UUcrckNFeVZFdEdWWHl3VzB0dHV0V3gxNllxVkVwM0llcGxpOFFPbmpSRktF?=
 =?utf-8?B?UVZkNTlrQjVDWm1hUm85Q1dqYzRvdzBKNUZseWlQWHUzdFBaZmx0U1IxY1Rm?=
 =?utf-8?B?OFR4YkhFL0pocmxiV3owaWt4TzNkZE1RZnhWR1RyaUtIT0RKNjNxLzh5TStp?=
 =?utf-8?B?T2lic0ExM1VxY3ZJN1hLVVV5NHRESWp5SUZEU2hyZFVwRmRIUXNYNnVNQWE4?=
 =?utf-8?B?bW1hdHlUb2ZteFhiQyttbTg2TlppNXJwYnlOSDNxVERXdmtjeTFkQmlxNnpo?=
 =?utf-8?B?Mnl0UTE4NDhJYzVuZWtUVkZPdmVvaTU4cWhDRUVRRVdRSTZxUmljWDhzSlZx?=
 =?utf-8?B?cGxVVnE0VzlVTXZLbno3Y2ZleXEwVzVPZDZFRGVsamRvSXhNUmlLdlFCOUx3?=
 =?utf-8?B?YndsV2FEenJzaDlvSFIwRThLU09ZMVBLQjZtZERHZDhzSHlaemVmaTkxU1h1?=
 =?utf-8?B?KzdvcXlVakcwSEo4ajgyOUVIYVFvWnM1ZUpMMlV5eFZrQk9ieDJnN0xERnZu?=
 =?utf-8?B?cGtBOEp1M0dmOHl2RmVLTHo1ZW9SbUtOU0w2MUw5NkgzaDFtMWRqTFZnNUlS?=
 =?utf-8?B?SHdKM3FDSUk2bkN5KzBaMXF3R01XWjd0RVBUUnlpRTVBMGFPS09FVk44Wi9t?=
 =?utf-8?B?bThZQnJrMG9sRk9NZFRPUHQ5YVZYcmlodHlZVDBidTJlTWxhNmpsRnVFUEVL?=
 =?utf-8?B?QzN3NTZVQUdNSExUMXdsZU9DN0RsYzgzMGk2bjZuTWROMmpPRUM4WjZnQVVX?=
 =?utf-8?B?ZE1BNE40RkFvSk5oR0kvOGNNY200WGwya1R0YzFKTStIUWJxVC8rMlJsSFJL?=
 =?utf-8?B?WThaRHluaHYzOW44Rms1RDFWbFhvVjQ4SWZNL0VjZlh1b0gxMnl0SFl6YW5t?=
 =?utf-8?B?ZzVrMDFId2ViNXBQNEJEQ1dkeGxrQm5zWU5CRDkwUzIrd1ExVnAxQlZnZDJh?=
 =?utf-8?B?SGRmaDBEaUhpVHBuRUhtN3BxcEJoazk1T0oxRGZXdEkvdXdWQU5qMXVWT0tK?=
 =?utf-8?B?b1owUnp3RzR4bzBmVncybWd1WUdjd2l3a2RHeURJalB4akFLdzZpREFrbTJM?=
 =?utf-8?B?YmVlUnhwaXpuYVNHZU9qTkp1dlBuUWNyWm84dVpYd1RXV0tzNURzSkdwaDk3?=
 =?utf-8?B?RkE3Um9JM0hSVzkwQjMzNTVwRmVzYm9SWTRYNHkzVjlXQmtjZmlOSER1NWJ4?=
 =?utf-8?B?ZVNEcG1IbjJlUi9Va0VLSnI5bDZibnh0T29jcDBSaUMvR0pNekdUS3JyaGI2?=
 =?utf-8?B?ME5UbXUzVDZpSHc3d3dHaWY5Y1RXUHJaYlZBem1rcmg1dTU2MHRVaUVNT0Nr?=
 =?utf-8?B?clZySXpoVUs4TEtUQjlxVW4xOGxDMDVaaUx6djRlelZuQnNEb0VjWVNxSGFM?=
 =?utf-8?B?ZzVwSU9oaWp0MUc5YVovblA0ZHExZjFlK0ZSVVdHQk9IaXhWcWExemhyQnBU?=
 =?utf-8?B?RlE2V29uU3Zmd2hKTnZkWnUxWGFzVSs2QlNhcVo5b2VYUW5tbTZEckppNkxT?=
 =?utf-8?B?Qjl1WkducUU4NU56Y3pJQi9QVWVheXB2Z2d6b0ZSdmVuSnFvUnlROXZ6WVUy?=
 =?utf-8?B?UEVFSDZqU2JuYkgyeE5jSGtDNDk1Z0RRU202R25JNHM0ekVIa1VydENHOFRJ?=
 =?utf-8?B?WjZSa21iU1N3a0VJbTdFY1JzRGdBUGdtdHhuNVEwZnFDWXVKZVA5TEVvdEth?=
 =?utf-8?B?VTBIZDhuQUF0UHhuTTRySHVjbm44YWZCYnZ3Nk50NlRRNHI1NXZhVERRV1lS?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8DC3D9EA220304CBE0C455CEFC27406@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c413426d-95d5-428f-5558-08dd919e21ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 21:44:11.3733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z7hZIgyA40jmZIKsrGzDWWc6Kan62khSrps66hq5o8weF25ZlzbWSx932EpFMclDJhXROSJX/2+9TW91bzI63VIJjqni2zi+vZ1hfD893Cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7933
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTEyIGF0IDEyOjAwIC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IElJVUMgdGhlIHF1ZXN0aW9uIGhlcmUgaXMgaG93IHdlIHNob3VsZCBoYW5kbGUgZmFpbHVyZXMg
aW4gdW5tYXBwaW5nIG9mDQo+IHByaXZhdGUgbWVtb3J5LCB3aGljaCBzaG91bGQgYmUgYSByYXJl
IG9jY3VycmVuY2UuDQo+IA0KPiBJIHRoaW5rIHRoZXJlIGFyZSB0d28gb3B0aW9ucyBoZXJlDQo+
IA0KPiAxLiBGYWlsIG9uIHVubWFwcGluZyAqcHJpdmF0ZSogbWVtb3J5DQo+IA0KPiAyLiBEb24n
dCBmYWlsIG9uIHVubWFwcGluZyAqcHJpdmF0ZSogbWVtb3J5LCBpbnN0ZWFkIHRlbGwgdGhlIG93
bmVyIG9mDQo+IMKgwqAgdGhlIG1lbW9yeSB0aGF0IHRoaXMgbWVtb3J5IGlzIG5ldmVyIHRvIGJl
IHVzZWQgYWdhaW4uDQo+IA0KPiBJIHRoaW5rIG9wdGlvbiAxIGlzIGJldHRlciBiZWNhdXNlIGl0
IGlzIG1vcmUgZGlyZWN0IGFuZCBwcm92aWRlcyB0aW1lbHkNCj4gZmVlZGJhY2sgdG8gdGhlIGNh
bGxlciB3aGVuIHRoZSBpc3N1ZSBoYXBwZW5zLiBUaGVyZSBpcyBhbHNvIHJvb20gdG8NCj4gcHJv
dmlkZSBldmVuIG1vcmUgY29udGV4dCBhYm91dCB0aGUgYWRkcmVzcyBvZiB0aGUgZmFpbHVyZSBo
ZXJlLg0KPiANCj4gSXQgZG9lcyBzZWVtIGxpa2UgZ2VuZXJhbGx5LCB1bm1hcHBpbmcgbWVtb3J5
IGRvZXMgbm90IHN1cHBvcnQgZmFpbGluZywNCj4gYnV0IEkgdGhpbmsgdGhhdCBpcyBmb3Igc2hh
cmVkIG1lbW9yeSAoZXZlbiBpbiBLVk0gTU1VIG5vdGlmaWVycykuDQo+IFdvdWxkIGl0IGJlIHBv
c3NpYmxlIHRvIGVzdGFibGlzaCBhIG5ldyBjb250cmFjdCB0aGF0IGZvciBwcml2YXRlIHBhZ2Vz
LA0KPiB1bm1hcHBpbmcgY2FuIGZhaWw/DQo+IA0KPiBUaGUga2VybmVsL0tWTS1pbnRlcm5hbCBm
dW5jdGlvbnMgZm9yIHVubWFwcGluZyBHRk5zIGNhbiBiZSBtb2RpZmllZCB0bw0KPiByZXR1cm4g
ZXJyb3Igd2hlbiB1bm1hcHBpbmcgcHJpdmF0ZSBtZW1vcnkuIFNwZWNpZmljYWxseSwgd2hlbg0K
PiBLVk1fRklMVEVSX1BSSVZBVEUgWzFdIGlzIHNldCwgdGhlbiB0aGUgdW5tYXBwaW5nIGZ1bmN0
aW9uIGNhbiByZXR1cm4gYW4NCj4gZXJyb3IgYW5kIGlmIG5vdCB0aGVuIHRoZSBjYWxsZXIgc2hv
dWxkIG5vdCBleHBlY3QgZmFpbHVyZXMuDQo+IA0KPiBJSVVDIHRoZSBvbmx5IHBsYWNlcyB3aGVy
ZSBwcml2YXRlIG1lbW9yeSBpcyB1bm1hcHBlZCBub3cgaXMgdmlhDQo+IGd1ZXN0X21lbWZkJ3Mg
dHJ1bmNhdGUgYW5kIChmdXR1cmUpIGNvbnZlcnQgb3BlcmF0aW9ucywgc28gZ3Vlc3RfbWVtZmQN
Cj4gY2FuIGhhbmRsZSB0aG9zZSBmYWlsdXJlcyBvciByZXR1cm4gZmFpbHVyZSB0byB1c2Vyc3Bh
Y2UuDQoNCjEuIFByaXZhdGUtPnNoYXJlZCBtZW1vcnkgY29udmVyc2lvbg0KMi4gTWVtc2xvdCBk
ZWxldGlvbg0KMy4ga3ZtX2dtZW1faW52YWxpZGF0ZV9iZWdpbigpIGNhbGxlcnMNCg0KPiANCj4g
T3B0aW9uIDIgaXMgcG9zc2libGUgdG9vIC0gYnV0IHNlZW1zIGEgbGl0dGxlIGF3a3dhcmQuIEZv
ciBjb252ZXJzaW9uDQo+IHRoZSBnZW5lcmFsIHN0ZXBzIGFyZSB0byAoYSkgdW5tYXAgcGFnZXMg
ZnJvbSBlaXRoZXIgaG9zdCwgZ3Vlc3Qgb3IgYm90aA0KPiBwYWdlIHRhYmxlcyAoYikgY2hhbmdl
IHNoYXJlYWJpbGl0eSBzdGF0dXMgaW4gZ3Vlc3RfbWVtZmQuIEl0IHNlZW1zDQo+IGF3a3dhcmQg
dG8gZmlyc3QgbGV0IHN0ZXAgKGEpIHBhc3MgZXZlbiB0aG91Z2ggdGhlcmUgd2FzIGFuIGVycm9y
LCBhbmQNCj4gdGhlbiBwcm9jZWVkIHRvIChiKSBvbmx5IHRvIGNoZWNrIHNvbWV3aGVyZSAodmlh
IHJlZmNvdW50IG9yIG90aGVyd2lzZSkNCj4gdGhhdCB0aGVyZSB3YXMgYW4gaXNzdWUgYW5kIHRo
ZSBjb252ZXJzaW9uIG5lZWRzIHRvIGZhaWwuDQo+IA0KPiBDdXJyZW50bHkgZm9yIHByaXZhdGUg
dG8gc2hhcmVkIGNvbnZlcnNpb25zLCAod2lsbCBiZSBwb3N0aW5nIHRoaXMgMWcNCj4gcGFnZSBz
dXBwb3J0IHNlcmllcyAod2l0aCBjb252ZXJzaW9ucykgc29vbiksIEkgY2hlY2sgcmVmY291bnRz
ID09IHNhZmUNCj4gcmVmY291bnQgZm9yIHNoYXJlZCB0byBwcml2YXRlIGNvbnZlcnNpb25zIGJl
Zm9yZSBwZXJtaXR0aW5nIGNvbnZlcnNpb25zDQo+IChlcnJvciByZXR1cm5lZCB0byB1c2Vyc3Bh
Y2Ugb24gZmFpbHVyZSkuDQo+IA0KPiBGb3IgcHJpdmF0ZSB0byBzaGFyZWQgY29udmVyc2lvbnMs
IHRoZXJlIGlzIG5vIGNoZWNrLiBBdCBjb252ZXJzaW9uDQo+IHRpbWUsIHdoZW4gc3BsaXR0aW5n
IHBhZ2VzLCBJIGp1c3Qgc3BpbiBpbiB0aGUga2VybmVsIHdhaXRpbmcgZm9yIGFueQ0KPiBzcGVj
dWxhdGl2ZSByZWZjb3VudHMgdG8gZHJvcCB0byBnbyBhd2F5LiBUaGUgcmVmY291bnQgY2hlY2sg
YXQNCj4gY29udmVyc2lvbiB0aW1lIGlzIGN1cnJlbnRseSBwdXJlbHkgdG8gZW5zdXJlIGEgc2Fm
ZSBtZXJnZSBwcm9jZXNzLg0KPiANCj4gSXQgaXMgcG9zc2libGUgdG8gY2hlY2sgYWxsIHRoZSBy
ZWZjb3VudHMgb2YgcHJpdmF0ZSBwYWdlcyAoc3BsaXQgb3INCj4gaHVnZSBwYWdlKSBpbiB0aGUg
cmVxdWVzdGVkIGNvbnZlcnNpb24gcmFuZ2UgdG8gaGFuZGxlIHVubWFwcGluZw0KPiBmYWlsdXJl
cywgYnV0IHRoYXQgc2VlbXMgZXhwZW5zaXZlIHRvIGRvIGZvciBldmVyeSBjb252ZXJzaW9uLCBm
b3INCj4gcG9zc2libHkgbWFueSA0SyBwYWdlcywganVzdCB0byBmaW5kIGEgcmFyZSBlcnJvciBj
YXNlLg0KPiANCj4gQWxzbywgaWYgd2UgZG8gdGhpcyByZWZjb3VudCBjaGVjayB0byBmaW5kIHRo
ZSBlcnJvciwgdGhlcmUgd291bGRuJ3QgYmUNCj4gYW55IHdheSB0byB0ZWxsIGlmIGl0IHdlcmUg
YW4gZXJyb3Igb3IgaWYgaXQgd2FzIGEgc3BlY3VsYXRpdmUgcmVmY291bnQsDQo+IHNvIGd1ZXN0
X21lbWZkIHdvdWxkIGp1c3QgaGF2ZSB0byByZXR1cm4gLUVBR0FJTiBmb3IgcHJpdmF0ZSB0byBz
aGFyZWQNCj4gY29udmVyc2lvbnMuIFRoaXMgd291bGQgbWFrZSBjb252ZXJzaW9ucyBjb21wbGlj
YXRlZCB0byBoYW5kbGUgaW4NCj4gdXNlcnNwYWNlLCBzaW5jZSB0aGUgdXNlcnNwYWNlIFZNTSBk
b2Vzbid0IGtub3cgd2hldGhlciBpdCBzaG91bGQgcmV0cnkNCj4gKGZvciBzcGVjdWxhdGl2ZSBy
ZWZjb3VudHMpIG9yIGl0IHNob3VsZCBnaXZlIHVwIGJlY2F1c2Ugb2YgdGhlDQo+IHVubWFwcGlu
ZyBlcnJvci4gUmV0dXJuaW5nIGEgZGlmZmVyZW50IGVycm9yIG9uIHVubWFwcGluZyBmYWlsdXJl
IHdvdWxkDQo+IGFsbG93IHVzZXJzcGFjZSB0byBoYW5kbGUgdGhlIHR3byBjYXNlcyBkaWZmZXJl
bnRseS4NCj4gDQo+IFJlZ2FyZGluZyBPcHRpb24gMiwgYW5vdGhlciB3YXkgdG8gaW5kaWNhdGUg
YW4gZXJyb3IgY291bGQgYmUgdG8gbWFyaw0KPiB0aGUgcGFnZSBhcyBwb2lzb25lZCwgYnV0IHRo
ZW4gYWdhaW4gdGhhdCB3b3VsZCBvdmVybGFwL3NoYWRvdyB0cnVlDQo+IG1lbW9yeSBwb2lzb25p
bmcuDQo+IA0KPiBJbiBzdW1tYXJ5LCBJIHRoaW5rIE9wdGlvbiAxIGlzIGJlc3QsIHdoaWNoIGlz
IHRoYXQgd2UgcmV0dXJuIGVycm9yDQo+IHdpdGhpbiB0aGUga2VybmVsLCBhbmQgdGhlIGNhbGxl
ciAoZm9yIG5vdyBvbmx5IGd1ZXN0X21lbWZkIHVubWFwcw0KPiBwcml2YXRlIG1lbW9yeSkgc2hv
dWxkIGhhbmRsZSB0aGUgZXJyb3IuDQoNCldoZW4gd2UgZ2V0IHRvIGh1Z2UgcGFnZXMgd2Ugd2ls
bCBoYXZlIHR3byBlcnJvciBjb25kaXRpb25zIG9uIHRoZSBLVk0gc2lkZToNCjEuIEZhaWwgdG8g
c3BsaXQNCjIuIEEgVERYIG1vZHVsZSBlcnJvcg0KDQpGb3IgVERYIG1vZHVsZSBlcnJvcnMsIHRv
ZGF5IHdlIGFyZSBlc3NlbnRpYWxseSB0YWxraW5nIGFib3V0IGJ1Z3MuIFRoZSBoYW5kbGluZw0K
aW4gdGhlIGNhc2Ugb2YgVERYIG1vZHVsZSBidWcgc2hvdWxkIGJlIHRvIGJ1ZyB0aGUgVk0gYW5k
IHRvIHByZXZlbnQgdGhlIG1lbW9yeQ0KZnJvbSBiZWluZyBmcmVlZCB0byB0aGUga2VybmVsLiBJ
biB3aGljaCBjYXNlIHRoZSB1bm1hcHBpbmcgc29ydCBvZiBzdWNjZWVkZWQsDQphbGJlaXQgZGVz
dHJ1Y3RpdmVseS4NCg0KU28gSSdtIG5vdCBzdXJlIGlmIHVzZXJzcGFjZSBuZWVkcyB0byBrbm93
IGFib3V0IHRoZSBURFggbW9kdWxlIGJ1Z3MgKHRoZXkgYXJlDQpnb2luZyB0byBmaW5kIG91dCBh
bnl3YXkgb24gdGhlIG5leHQgS1ZNIGlvY3RsKS4gQnV0IGlmIHdlIHBsdW1iZWQgdGhlIGVycm9y
DQpjb2RlIGFsbCB0aGUgd2F5IHRocm91Z2ggdG8gZ3Vlc3RtZW1mZCwgdGhlbiBJIGd1ZXNzIHdo
eSBub3QgdGVsbCB0aGVtLg0KDQpPbiB3aGV0aGVyIHdlIHNob3VsZCBnbyB0byB0aGUgdHJvdWJs
ZSwgY291bGQgYW5vdGhlciBvcHRpb24gYmUgdG8gZXhwb3NlIGENCmd1ZXN0bWVtZmQgZnVuY3Rp
b24gdGhhdCBhbGxvd3MgZm9yICJwb2lzb25pbmciIHRoZSBtZW1vcnksIGFuZCBoYXZlIHRoZSBU
RFggYnVnDQpwYXRocyBjYWxsIGl0LiBUaGlzIHdheSBndWVzdG1lbWZkIGNvdWxkIGtub3cgc3Bl
Y2lmaWNhbGx5IGFib3V0IHVucmVjb3ZlcmFibGUNCmVycm9ycy4gRm9yIHNwbGl0dGluZyBmYWls
dXJlcywgd2UgY2FuIHJldHVybiBhbiBlcnJvciB0byBndWVzdG1lbWZkIHdpdGhvdXQNCnBsdW1i
aW5nIHRoZSBlcnJvciBjb2RlIGFsbCB0aGUgd2F5IHRocm91Z2guDQoNClBlcmhhcHMgaXQgbWln
aHQgYmUgd29ydGggZG9pbmcgYSBxdWljayBQT0MgdG8gc2VlIGhvdyBiYWQgcGx1bWJpbmcgdGhl
IGVycm9yDQpjb2RlIGFsbCB0aGUgd2F5IGxvb2tzLg0K

