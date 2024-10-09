Return-Path: <kvm+bounces-28231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FA5996812
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFA94B2220B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B930C1917D0;
	Wed,  9 Oct 2024 11:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJ0rpVHS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF918B465;
	Wed,  9 Oct 2024 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472238; cv=fail; b=g3hB9w6WO/XLeC3Ts4+/2mRyxvnbeZCiDuUzKTICE5lv4XzvW9LYHnUFtBJD43oZDaNplKcMSTeWAO/bYeCbKmX2+JYP8j0U6MsRagr8KL1ndnsIIx5k1ktHFsr4RTZRQ6JQoiJBS8HkLFrKkg3XkwDQ89KTEOb9xCdW0h5REZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472238; c=relaxed/simple;
	bh=YOE3PV2j5CI/KesiUvpJTs188z5/4gLAPt3nBrbxKpw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VDhTz/2zU3M6gtUfabLq8HjrlxPMECC4+DPIxeNTBquqaCa7iKrVx3Co8+oTd2g+yMb6Q01zvMOmPW7Dfxv2BqcrrLPaITVqGkmDcB8s77q8GvbyhErWcSK7gOWmppV015cL96qqwhsOMQ8clFvYwvQRTLgRvjXvk3lFfmkKAzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJ0rpVHS; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728472237; x=1760008237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YOE3PV2j5CI/KesiUvpJTs188z5/4gLAPt3nBrbxKpw=;
  b=aJ0rpVHSgCRjySiGx81Az0oBMfYCBEPl5gfYNlnIqX0omlhNmRdgqdBk
   km9SFdB+vv+i8M1VC0yE7L2E05MNnMXBr7LlNn3xzbNSVSRuL+GgCpT6L
   UZMEFuMEm8yoWoTQjavNDZtoxGxyi4xYzkzNgScVt1HOgEoXS19VrWYnv
   ogW4sQSxwOpkQNkLNGKeoU3y89VTI8Eh2kKsR8ohH5I1u2f02EpLyDq4P
   FJ3Jjbq2wDR8VViKWlF0eZbAcAeKT6lNf/1T+g3isAEN3WIiCyzJsIMfz
   gQ3r1EYxtfqwpkmT05AP7i6ib/yYi8dUZC9KJx06b8urBd6emYqVosNpg
   A==;
X-CSE-ConnectionGUID: YWDUmkbpShqMKBpwjXMlbA==
X-CSE-MsgGUID: jbojhSvxQGiml/Nw1fjwUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="38351374"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="38351374"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 04:10:36 -0700
X-CSE-ConnectionGUID: WfcZ8z2QTMiaWQbvL0jj1g==
X-CSE-MsgGUID: vJxofL6qQpWXZKx9MsjR5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="80724442"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2024 04:10:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 04:10:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 04:10:35 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 04:10:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 9 Oct 2024 04:10:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 04:10:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ovk+f+qaK6IQ6YO2rklDVYp9o+p5inkWRkbkHyvQ2DvQxocDDFc+HF8baVkDsuDglV8/NcGGQ1n039f7WyOz3/JFpTB6cC4fxlC+/oSeHejbWi4pREqveUG/ew2grcim3EOEmMgCkvD8rvc5j2UjaPkk2J6No4tNhC/QqfV4OsWxAZnpx9F7CGhIUroDPYerVetlrk2nVP9p+dEGZtwtGJmomYZQ7jhKwIKgcMZR25uQmxqUfypJsXFJu8XGsZtVT9CGSqdjrxaQyrhJTJcTAYEOL5heZWb1zvP0TOKtsYbs7DpUzr8QGSU/TbEVTLcwXN7niFczL9GtYTjjRupsJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOE3PV2j5CI/KesiUvpJTs188z5/4gLAPt3nBrbxKpw=;
 b=elzlOUmIY3azyauDvfTwNqqe3THKqyRoP0/0nA6lBqnVcmIM/z9sOwLG+V5mZuBqQjugZSw5vziJ+270KUGC5Fxg2fD+zO9iDKXNnJaeZ+2EQ6LN+0HcZtZLv1XYCceNiNNxfdJL0TWFQ5ouncJygXQsNZIEVkpCUWjhSZIoodnk6keFKobDDqwpGlkDnFRCbff0H/I/afjdYh2mm+ZkNkaHwTFpwAdQUz+9cGv/2ol6EVCl3arVCxw/UkfrOeh7CJqQYHOgFDUPKadGXImcVY7MXT3sePCyYLzp2xRwUEdfxzcqy2LrklfcIFqHxeD+WVwtzpIX93tei4+8ZjIp2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7779.namprd11.prod.outlook.com (2603:10b6:930:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Wed, 9 Oct
 2024 11:10:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 11:10:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJqOf0AgABuTACAAAERgIAACvwAgAbdloCAAC7wAIAATPiAgABqcYCACDbNAIAAClYAgAA04QCAA2yCAA==
Date: Wed, 9 Oct 2024 11:10:32 +0000
Message-ID: <a642dfcd0f20773dcf06149b6d2e7969af53dcbf.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
	 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
	 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
	 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
	 <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
	 <d3fa4260c50c8d4101f8476c1cc4d6474b5800ce.camel@intel.com>
	 <9514d5b8-73ba-47c8-93a9-baee56471503@intel.com>
	 <74a88c3df6e51ab8dd92fdd147e4282bfa73615b.camel@intel.com>
	 <271368d1cf0d3b3167038a01ba9e9d1e940cb507.camel@intel.com>
	 <71403e4f-f7a6-4d7b-8301-0c4f16208179@intel.com>
	 <c00d6fd92455640430ccb5c7750cc91ddfecc3b4.camel@intel.com>
In-Reply-To: <c00d6fd92455640430ccb5c7750cc91ddfecc3b4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7779:EE_
x-ms-office365-filtering-correlation-id: cc6cf5d0-ed56-4ac2-3013-08dce852fe19
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YXpoajBGTElqZ2I5bk1hSEhGWGpudHFUTW5CYnFsQ0NkYXk4OHFUUGpXaGZK?=
 =?utf-8?B?WUlDOUY2dGdKT2VyT2tKeUFoWFd6OW1hSE8rUFprNmFDZjhCd1dlT2pUbHly?=
 =?utf-8?B?TFcyZ2tDSHc2N3poOWU3N2lUNnBnc2s0UzQ3QloyM1cyYTFZaW1BT05VVys2?=
 =?utf-8?B?QW1yTEZYZmd2RTNEZ3dWSXlTTlBiOGwyd3g1NXIvbHZrZFU1QmttZGloMUJP?=
 =?utf-8?B?UjFhU1Zrd0toWnhtWDhqTFp1S3RvNjhuMlRIRUNIOG9ZL0NZaCtPdHR1akhI?=
 =?utf-8?B?OUNlUG1yaUZWNVlKLzhaTjArVHdZNHhGZTN3UzJYb2FzenhVVkxDVVJEQW9y?=
 =?utf-8?B?Y0pqdjBWQ2RXSFROYUhCWWdHUWtpRU1OaXczbUNIZ0ZrT2hxV1dFUWh1SmtL?=
 =?utf-8?B?V3ZxWjZ2bHNtOUZsRWZHSkN5UEVUTDhWVWhzMlRKWDA3TUdKQ2RIbkQ2QWFQ?=
 =?utf-8?B?b3JQY2JndFJxWVNreVVVRnk5Zkhmc2xxMHdBK3FlZzlkOXRrck92aDlpL3Zs?=
 =?utf-8?B?eEJiYUgwSllGa0ZIN2Fna0VaZldiTUc4NndrNThWNFI4QnQ3VG8rN09xVytB?=
 =?utf-8?B?OGh0SFQzYXVrMDJ3bG91YU1leW9LcmZHQk0veHBIUGNwcmI2MGdSTEZoZW8r?=
 =?utf-8?B?QmltWGxMekdRbENQUGdURU4wTlQ1YUNmR3VqTlo1Mkc5YVpTTTdlKythRVQ2?=
 =?utf-8?B?T0RmZEZNNFJCMWNLKzZtNTNkSTR3R1dUR3pkNmNPb2N4ellsMkJEN3cyUUUw?=
 =?utf-8?B?YVU4dHFqMzhFdStTcHlreG1CaXlCOVBtNnlIZjBaTjRTbkFDZjcyWWhldVRy?=
 =?utf-8?B?Z1I5TU5aTkUyRFUzdTk3Q3hyb005RkQ1VGhrYVpReXdJSXQ2RnhibHdGdm1j?=
 =?utf-8?B?WmtzcU4rb3RmVDEwMHBkbnlGaVNhcGMycDJvMFBEazNiaVBCY0hOaWhIbTc0?=
 =?utf-8?B?cHJwWEZ4S3U4NDNGM29aZ1VkS0JwTlh4OURyUGVRbllJNWNBUTFiZENDTVFm?=
 =?utf-8?B?dlJFYjBZeWdRVk8rc1gxVWlsZnkwTmxMYnBQVk1TT09MUFdOWDhsZnVmK3Fp?=
 =?utf-8?B?bGtGa2JlakJKOHRVOHM4YjdzeVhDZDRjSFhyTTZBY1BjSFZxcXg1SWVaNDlD?=
 =?utf-8?B?aUFoZDYzN3ptc09DZktNV1FvdWVzM2R6eHR4RVhpYkp1WHVyanZxbGppTjI1?=
 =?utf-8?B?Wm95djRGRkE1VWhKWkZDTWl6Yml6SS80bW5mZE1GSko0V0p0ODhaTTFHTXZV?=
 =?utf-8?B?UG9qTmFBcmMraE1VM3RCZTd4Ti9pbXBacEdGMVB1MWQ5L3l2OVZlVWQ2c3cw?=
 =?utf-8?B?Snp1RFVWL2pTRXowZFZYRTRoSHhkemROU0xEaDZBSnlBMVBiUUlyZjJYcUVS?=
 =?utf-8?B?LzBPUWI4RjJwek5NZDNvZW9uS21BcUxsc3c0STJLZUtVVmJIQi9DYy9VNjls?=
 =?utf-8?B?bE9Qc1BtUUhpcTAzaEE0RFNXVGZFVFcyT1FCb2VHTW1MUHRmTE82NHU1KzN3?=
 =?utf-8?B?RzFHbTRPZ0hwd0RuRXloaXZma2RHYTN5eE1rZG9uQmtoeFBmUkFGOGQ3bUU4?=
 =?utf-8?B?b1JiM2ZCbyswUklGNU9ya1NlMFFUYVBVUlh4M0FvWkpLbE1tVkZNZlhXZk9h?=
 =?utf-8?B?OFIzL2ZuS0hLVVFqdGVDTmxKMWRJVkZ6UHplVmlVc1VQV2JzRFRiWnZTbHhY?=
 =?utf-8?B?VzZaeUxpaUE1RGEyS0dkajFNRUw2NE9qa1czN0YxQnJhbjhoRHFsRUJlSlQz?=
 =?utf-8?Q?wItBY6vEYBRuthzqVJs/+DOHkt6yBl+69j1p+oS?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGxsUmk5eW5YSnAvdlZFbW1vd29DZzlUbENHTXczdm5HVHlpamJDR29TNDdl?=
 =?utf-8?B?K3Q0bFRMcWRWV2hBUnBaMkYyMmRIZkUwVlNtVk81Uit4OXF4dE1iWnJOR2VE?=
 =?utf-8?B?ZmpNZzFoemZEK3Z0NnY5N0RrbkFMNVFTTlNWRzFsUUd4dWRENGF6bWxhQ1VY?=
 =?utf-8?B?R0tGRU82WjhrbjdJcllvMlJnUmplQk5EZ2ZMNEdORis5Z2d4RE5VZ21FRkNB?=
 =?utf-8?B?ckY0aCtMSGZNWmplM2NTanFXN2J6ajdraHpiOWVxdjN4VTErRkc1SXZUb3Y2?=
 =?utf-8?B?QmpyLy9MZzg4VkVEY2ZUaEZTRk1uZzRPbHFtME05aFdHV1IrVkNIVVUwZzlK?=
 =?utf-8?B?V0xmYUpOMXhFT09BcjIweHVyakFCL2ZKTTQxOFZPTTQ1YmNMeWdOdy92N2hJ?=
 =?utf-8?B?ai9NR1dOekptR21LM3lSSXY0MHMyRy9JaFcrV3JwM04wZEtQdlFIdUtWMGEw?=
 =?utf-8?B?UDY2TzZHbkRNcktuVGI1dW82K091OURFMkJGY0xlQXF2eHExRjA3M3hHeVIy?=
 =?utf-8?B?RklGalBOaGhaS1JzcW1QTDNWSmlaNjZjUnVzMllTMHRNTnVMUjdVd0NXMWRl?=
 =?utf-8?B?cmFzTVZLK0pGbEtYY0VMeEQwNVJmdURwRXpQYitKSXFHVWwyMW81S3RhdXhX?=
 =?utf-8?B?bStrZDlYVW9uTnhhVG9SRGRXOXZVNjEwT3p3ZDc4TWlyY2FYbnN0dlJYanl6?=
 =?utf-8?B?QVFBRTdCVU9tVjNPQlRyOHlrUndsMzB6eTJaeW5EQW9mOG1UWUFKNGM0ZEox?=
 =?utf-8?B?d0xITFFQQVhTc3VJKzgybEd2N3pBT2k5SUNhQTlqQnl6REZ2Z2xJblQySnVr?=
 =?utf-8?B?VUt5dCtxbEdLcjBFYnZsdFIvT3ZjQzRERi9KYmNjb0FlcTgrN25nN3VkaTdm?=
 =?utf-8?B?Vk13bXJBS3lqcTNPRko2TlFmOFhnWjZUaThLU0FUWjBFRGE3ekpXQnNQbVpX?=
 =?utf-8?B?S1VTL29QcWNxM29vQU5CZ0ZoYzhRZm9sMndpM1ZiSmVwWFp6RFcrNVNUdnFW?=
 =?utf-8?B?aWw0NTNpZTk4bUoydUxBVnd5TDlsNGFmZndpQlJUM1J3V21sbjZZQ2daRnp4?=
 =?utf-8?B?ZmovSEF4d3NkZ0ZySXM5cFBGS0hCemg0WUxyV3hlbzVSYmY5Q3ZFWVhZSFpa?=
 =?utf-8?B?VzJkc0l4L3Z3aThkVnBnUWFFRHdvWkNiTTZNQjh3REUrNkRsdW1jUE1FbEpW?=
 =?utf-8?B?Q2xwbHJwQWplZUdSbzZvN1RGVE9TMGVnb3hvcEJIaFNkNVlMZlJqbXpVcTdB?=
 =?utf-8?B?ZTVKWW5BNFQ3UTdWcmRkQmtWNVZ5L3g5bXBCMWhvMkZrOUIwKzhxMEUxK2xj?=
 =?utf-8?B?aU9FR1ZSRisrVFJXKzVNbUovYkNxZGRaKzh3WWl6aXdFb2hmTUpvUGtYbGVJ?=
 =?utf-8?B?b3hWTUFsaFdhOVNuSktYZVlCb3EycXhIRWdiWXJBVkVIV09tZDIyVDFXcjB2?=
 =?utf-8?B?QngrZXFIYldkb0ZvMDVxdEZGdnFvb2VrVVdIYXRpamtqUEh2ZTcxRnd0bytF?=
 =?utf-8?B?SkQvT2dxTVRUbVN6aUUrRGpGQnVkb1JzUGRqUE5kUC9KcEZhUUw2RTEzc1g2?=
 =?utf-8?B?TGltM2ZaMWptR0ViOWFkZmZxd01Sc2FrL3RWU052REN4eEdMam83aFkyMDkr?=
 =?utf-8?B?aldSdzZrVENrS09zbW9pK1NVaDk4aDJFZldhLzJRNjMrTmRtd2JXMzJHWlhI?=
 =?utf-8?B?TEJZZCtSZDU2UEJSSVpkWW40cVV5Z0QzU0pQZUxRVWRkQjlJL0oyWWdUWGFn?=
 =?utf-8?B?MzRoa3NpK3VmY1hTNk1ad3JtalZKTE43YkxkSWpWV2JYcjhCOVV1NmpaQzlZ?=
 =?utf-8?B?SmorTHYzUWh1WWkvclQrblJZWEx1RWJhSUhwTTdFQmRBS0g3SmRwenV1cEVm?=
 =?utf-8?B?U3k5WTNleDdRS3A5VEJ1eGwzTTIyT1AvQk1FQVJHWkNDOERLL3RmTm96cW05?=
 =?utf-8?B?V0dnWjFSWnQxNkJWVFJ2Mk1ac2tOMmI2aUxxYlV5Q3FCRmtEZVVEOTBwQVB6?=
 =?utf-8?B?d1g0elE3MjQ2WGcyQVJuZWQxNmJERmV5dFZvWEhhSmtSMkdZdnZ1bGpDUjd0?=
 =?utf-8?B?QUxIT3NVeUxJUFNmcTZoUStEM2cxME9GZ2FRTE84MGRpWTI1YVFyV0dKdW9C?=
 =?utf-8?Q?kY+Q6owR2tfcftq9okrPJmg+W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C14290421085BD4EBDEA57785D19C626@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6cf5d0-ed56-4ac2-3013-08dce852fe19
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2024 11:10:32.7218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCZvUpV3VTnXfeHryWPklbkzwHMYSf/eoVQxN+dvm5iKCl9bTjyj/lZluLa2YU+yX8MMYiy7nHUnBJGiEHhksA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7779
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEwLTA3IGF0IDA2OjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBTdW4sIDIwMjQtMTAtMDYgYXQgMjA6NDQgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDEwLzYvMjQgMjA6MDcsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBXb3VsZCB5b3UgbGV0
IG1lIGtub3cgYXJlIHlvdSBPSyB3aXRoIHRoaXM/DQo+ID4gDQo+ID4gSXQgc3RpbGwgbG9va3Mg
dW53aWVsZHkuIElzIHRoZXJlIG5vIG90aGVyIGNob2ljZT8NCj4gDQo+IFNvcnJ5IEkgY2Fubm90
IGZpZ3VyZSBvdXQgYSBiZXR0ZXIgd2F5LiAgSSB3b3VsZCBsb3ZlIHRvIGhlYXIgaWYgeW91IGhh
dmUNCj4gYW55dGhpbmcgaW4gbWluZD8NCg0KSGkgRGF2ZSwNCg0KU2luY2UgeW91IGhhdmUgY29u
Y2VybiBhYm91dCB0aGUgdW53aWVsZHkgbWFjcm8sIEknbGwgc3dpdGNoIGJhY2sgdG8gd2hhdCB5
b3UNCnN1Z2dlc3RlZDoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9jb3Zlci4xNzI3
MTczMzcyLmdpdC5rYWkuaHVhbmdAaW50ZWwuY29tL1QvI20zODc0MDgwZWYxNThhNDcwNGM0MDgy
MjU5ZDM1OTRhYTBhMzIyZmM4DQoNCi4uIHVubGVzcyBJIGhlYXIgc29tZXRoaW5nIG5ldyBmcm9t
IHlvdS4gIFRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg==

