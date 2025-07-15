Return-Path: <kvm+bounces-52543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E956B06858
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09EAF1AA09D8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6462C1586;
	Tue, 15 Jul 2025 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCdMvuR5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024582C08AB;
	Tue, 15 Jul 2025 21:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752613614; cv=fail; b=mOcG5SSFW3PO1bbat1HJP5x0tKhhXpwCHTebGQbQ52zTrVXjimeE/bRVfbAHG10sMXSSlPbU7XSx1/XxDgxacwTCw1nJP7kVC9J5AXgFpDIfbrL/oTdH0ylU/ff4EV8CdY3LPRRUOYB7FnA1XjiFbXZQHcqjqYrqMDK/BJ3nuas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752613614; c=relaxed/simple;
	bh=hgFA3pGUX/YAJaNdB/Oc/OgiVM5feX5AJDGUOivkPRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RudmrJMRZJuOqUxKLHS51CselFLixyrGA5P2ILMeEvs9+2lIDtXv7fJI8Ony1lSjHvwQPl0NnbZtMORkDv5w+5PbS4fXZ7KcCHx6REj5A66Dq6oARoAMS2Qs02HHF/8ouXseFCdFdpFwVE8rNjCWHmEifiYqXBjl6yiHtqoVhgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCdMvuR5; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752613613; x=1784149613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hgFA3pGUX/YAJaNdB/Oc/OgiVM5feX5AJDGUOivkPRU=;
  b=HCdMvuR5W4rppMt1MNvJHeM1Iyr6auMcvTySH9MmSoTmWZN2TpHCEsOJ
   4tx4x6TV8AuVW6xN7VsznLZWJYmn0XbOIRd9RC6J3BUKpWPlIPl/ZWmy4
   1t3QKTHxfOEKN1TRvUZ3uuUiPBjtZbmkDbdcBpEYtvwPwCxvCStMNJSuu
   z53AhFmERc30ULy6jDhyCilwTtSTCVEZT+CXiJLNPhJ8z13m0+FP4g/gl
   rCxBhFL5bEwoFecbQaeum4OiHM5fIU4qtbvwSjOdTKkaMiNHL9k4isIr/
   2gTQVoP9L8ZJ+X/CsvML6aBEeO0aj9s46osnu35F+6ZSM+mpcbx7tpu7W
   Q==;
X-CSE-ConnectionGUID: ln5zmYkBQsyYmjbvLIzdwQ==
X-CSE-MsgGUID: C5eSDMKtRkOohyiGU9QOFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65545165"
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="65545165"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:05:29 -0700
X-CSE-ConnectionGUID: LGTj/cZWQSOv9NIkqI6r8w==
X-CSE-MsgGUID: 0pfAXaNRQgK88bBxdNHpQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="188305755"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:05:29 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:05:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 14:05:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LbnAhyPOSZ5OJjRGtxeX0sPBN2Xa8gm3mfZbokzc2k7VsAMBXpL6QALmSSFF+OPX5Nb3sqgMCILBvwDxZR+hCRED8ATY9DoARYSISNLC1HF/QqencifDMKbFBRJdXR6RvPcycki0UveE9xYMSCO0aO7SV+9hJU9ua7kc4xS4pG8/2KhXwmzw4QqB93NE1nyAHW21gCq7/FsQcRd2eLmT9DEk87vK1uIT1rSUqwtbrf7LGpwv6oAe/cT7YCtOeX7vExZg+qggrhjUD9i+PGzRmTyC8jOHA8YpCEZunxe7op6dTiIw2illPX54a7zlP/SvATrwqBxl+tyKJJFe069NRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgFA3pGUX/YAJaNdB/Oc/OgiVM5feX5AJDGUOivkPRU=;
 b=icfUsgbezvYYM4wikYQ7vN4VtZCpTanOczNQLBjhN27RpQE7uYN1bbvD0afvtwo8zvuXR4p7BDv6NCWInCG3AdS53n0hZgt/SHnzR6GfkD63JbQId2rfvn10LIJW8PZL5lF9AmnsNeNwY/AHSfXVZ4xkpw7VIzvWbvwYTXaK2hXARbyzEcjWyptvMoR0kjXDT2JQTnjdddOGpOLcuu8fXP0QwVe1YC7JFUftVmwFY5ONhY0PaWO2mlvtGjQg3+SYrY/eOm3gyVHZ6rfLgIcVRTGfpws8ACw1wXZ+ybAsrWHfIq4SZh8boeT6b/MuJTAGCxlbpOJFuwJISwIkHKjWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 15 Jul
 2025 21:04:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 21:04:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 3/4] x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
Thread-Topic: [PATCH v3 3/4] x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
Thread-Index: AQHb9Wnm+f2SNWTN+k2Td4dqLS23DrQzrWmA
Date: Tue, 15 Jul 2025 21:04:58 +0000
Message-ID: <940052996ae004ea279b0610241bdf4b7c555067.camel@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
	 <20250715091312.563773-4-xiaoyao.li@intel.com>
In-Reply-To: <20250715091312.563773-4-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5782:EE_
x-ms-office365-filtering-correlation-id: a3d50c6a-abd6-4b0b-5b63-08ddc3e3420e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SE1ZVEZ6UDErdkRtRUJLRFk4OTkvVlBEcTk1S2FEU0hjcWdkcWdNMzVUZ25W?=
 =?utf-8?B?TWNPVlYwZTNqZTJMVjh6c3Y4a0Z5dmRVSlpWQnorNzFhUSt5U29RTXNQWFpr?=
 =?utf-8?B?ODBYWGlEeFQ0N09Id3g4VVNQUndSQXJOWU9OY1FDN1hsUEFtYVRVemgwYTZF?=
 =?utf-8?B?ZDRzM09ObXMyM1ZURHB0OUw2djBJODRoK3VEZjhhaktWSU5GU2RUSWt0bm1k?=
 =?utf-8?B?cHZzZjNZQVNzSlFLeXFZMnVMdUFycmZVVWxuVXkxRWFubzhZc0FVMXFDVlRx?=
 =?utf-8?B?Q2FsUCt0Nk4ycEZpTnhFWXJ6UU14WnF0UzdXdkJrK0tpYjJKOVZ1d1JkMG4y?=
 =?utf-8?B?Z0o0c3FNS3NwQ0ppOWx0bS9Nb3l6ZTgwS2xHSzM0UHE0S25jeExlYk1vMkRl?=
 =?utf-8?B?c3RGNStqM09GUU5pOURzNTIwdTRBSi9hbDNqUTlPRVc3QlRkQXNMdXYrUjZE?=
 =?utf-8?B?emxqSUJMY0RTTDFMaHR2dGtSa3FZbmVyTStRVkltYnVTUUpCWUZRUHVMM2t5?=
 =?utf-8?B?bUI3dVNUR2l0UHltRk1pZ2wvMGF5by9JekU0Z2Jxak5uK0ZqZzEvV2NLR0pG?=
 =?utf-8?B?Wk1Kb2VtKzZXV3kvRG5vdFExYjlZTHBHT3JmbDQ1WitnT3pIQUY4N1diaE9J?=
 =?utf-8?B?ZFZkWkt4V0dPeTh2Q2xiMDJPUWNqNXkxK3JmVDlyYjhnelZFcnlrUndxS0hm?=
 =?utf-8?B?STBkT1FNeEEyck1tbkNINlV3MzRhK0l0ckRDRzI2NVBmejY0ckNUVFZQS2ZG?=
 =?utf-8?B?U0htUCtjQ3FyS1ZNc0lRS0RqcXV1YzdSV3R6RjNDQmZleCtQOUZUMk9KcTZp?=
 =?utf-8?B?Si9PKzEzdm96K2xYTHBIVnpMNURybytybE92OWdOcjd6OTJEOWhGbDdSRGNO?=
 =?utf-8?B?V280SEpnMklZamZpK1VIR0FKazRYSG1BOVdCYUV3TFJhd204T3BoNDN6ak9k?=
 =?utf-8?B?SXZiK2JKQmZFQ0JWNlRiMENvcHh1ZG10d1RJc0gwNDU3OXpEWUt3aTIrSDVx?=
 =?utf-8?B?S1FlaGtDbmNVRkR6TEw1cmFwYkVIRkhpODlZR2c1L3IzelorQTFxM1ZDK0hG?=
 =?utf-8?B?TUIvb1hndEIxVDZJMW9Md0p0TUFRdmRKTWlnL1NEbWN0bytLWjZGQmRGVXBt?=
 =?utf-8?B?a29keGRMcFZad01FSmhyaS80cHdVMkNaU3VmN3Y5bCtFaGNZbHlOOEwzMzNi?=
 =?utf-8?B?UlpzMFM4RTRrVU9TZHF5VnIwL09TZFg2QXJkUjFjZWR3QjViK2NnTEtVMjhm?=
 =?utf-8?B?KzRHdEk0S1RaMkI5QVRLVTlTQ0wxRmNqL0VyVy9mdVZGcVh2Mml4MjRvMGdz?=
 =?utf-8?B?T3k1TEgycnF2Q3k1Z29icCthaDRsdWpnakRkZG1scmFwWUhhYXZ3WTRkam5J?=
 =?utf-8?B?QS94SXpsZkllNkY4RTlHdjRLOFBzdW9yYUhpRGl0aGpTUmtEOTZhWVJDNlQ2?=
 =?utf-8?B?T3JRODhUMlFranZkelNJRDFFTUhiaDFsWk0yT0FqdEdqbmt5TVcrTm9NMk1Q?=
 =?utf-8?B?RG43cGdaZWNrSFU1Z2pwWTFqWENDckVaSXIxRm5abDF0MFpibXVXK2JiTnYv?=
 =?utf-8?B?UTkxOFhPay9BU1lJMSs4SlI2Y2srNVVaeTFVYlRIVEFoVnJoZUY5ZFhMcnNC?=
 =?utf-8?B?bExjOW1kaUhyUUpyMFpvSHpFOXMwTml3emt0Vi9HY2orQlI5dUdZa2lvd3lj?=
 =?utf-8?B?d3Z3cmpBMjZER1FpVjZ1NEl4YzZyNDdUVVJHYWNJRzNNeThJN1JORlhobTVt?=
 =?utf-8?B?ZVZxVk1vQ2p6K2IyVGdub0p2UE5Vem5xclpqWnNZbUlPKzRIalY4ZCswNWQx?=
 =?utf-8?B?ZTBLWU1LL2VLMTNVVDVxVXhCYnlYTkMyUHN4UnQ1VXh2TXNZMWdXWS9KZlRy?=
 =?utf-8?B?T0I0RW5RYVJhSlczTUZPeGtTNWlBMktIYkpLbUd4MkJRU2hOaDZ1em5yVUU3?=
 =?utf-8?B?QmJ2OG5OYXl2dG9LTk1qMFg2d0xnSlk1N3U3aExDRU96ejFFWWIxREFnUTBu?=
 =?utf-8?B?dEwyaFJvVjZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0xwUUZ1VytuZUh5bkw2OXpMdFpxQXdSdkZXLzNYRjNKTzZ2OStITVM0bC9Q?=
 =?utf-8?B?eDdZZlBwUWZ5b2VMVzhFZCtvK1N2RHJzUDhtRmJ4L3dPbGhEWHpiVjljanIy?=
 =?utf-8?B?eFJtUUlIQ3hpczdxd1dXNXhwMlhTQVJ2QzFLVzdTYWtRNGRNZjI2azRoZU9k?=
 =?utf-8?B?T2Y1anZKZlRlcTY1dFZHS01oYnBFcVJkVGF0S0tlcDAwTDVtMEZqQk9JM2E5?=
 =?utf-8?B?U00ycktQUDlTSjRIOXFmQXZLWndZM1JjbU1uUWR5M0JsTjN6cmFHT2toa0JQ?=
 =?utf-8?B?RXNoSlZBekNRd0xGelY5NUxpb0lXWEVyd2UzYkI3Zk9sNlhDVC9xMzlCWHBB?=
 =?utf-8?B?b1VEdjk5YVlxbkxTU1drdjk5azVOellpekg1REl6RjdVR2hESGZvV3JYZ2Rk?=
 =?utf-8?B?SEZjWkxlcS9LQ0FsZ0xyY0l6a0Y2cWsyZTNJVlNMRi84SU9lSzBiNzFneHRp?=
 =?utf-8?B?bzJHWnVMZGJZRGNXS0xhK05XR2tCWFIwUkJUZjF6dks5N2JwS0FMa2ZoSDg1?=
 =?utf-8?B?M2swcjNLbWpFNzh5T1lKRnhWcE41ZnU3U1gvQkhTUFFqcTNkVEhsQlJDaXAy?=
 =?utf-8?B?WEVyMTUrSzlhSFJEMmJFZ2hONTl6V2xoQlE5dERab2lPcXdQd1Q2cE9La2ZN?=
 =?utf-8?B?NHBKUmRsbmhiMXBQbVFhZnIxU2o3elhITitqcXE1U05oRk9nRVpaeXd3S1dx?=
 =?utf-8?B?Zjhqc0lNY1J5L0s0RlJHbUZsVG9QU29SM0ZxNzZqd29JUkY4MmUrUFI1bHZ5?=
 =?utf-8?B?OHRxZUFKNHNIdkdlTFpjdHliQVBNZTB1ZmdUcnBNWk02NFcxV1lUMTRHakVT?=
 =?utf-8?B?QjQzNk5QT01rNnNUV1E0NkIxRjQzb0xUTlBjRzZ2MitwNzV4Y0FHNzlwV0x2?=
 =?utf-8?B?QWhLYkRUdVdyTE5VcDgyVUkvTTRuYzE2ZnpreG1DenhoaUk0NS9ST1hEQnAw?=
 =?utf-8?B?Z1ZqdzljYktTVUQzVHJOczM5M2NVTFZjUG1oOFpUVGJkcWlpRFVYTEp5Skxu?=
 =?utf-8?B?WHdSM28wZXBleW5XeThJcmJNWTlRbjdxanphc2t2TXIvSjF3ZkFvTDNSWGFs?=
 =?utf-8?B?dEl5dzBRRjM0cGpENm12Z3ZWM3d2T1hjSlpoVExKbUtBd2xrRkx3K3Avdkts?=
 =?utf-8?B?dnFBVS9hOWpucENzdnIrb01XZEhpZ2tIcGRDaWhWZy9UVFpTQTVjT1FrYVI3?=
 =?utf-8?B?blpvckdMU0NKRDc2blZDL1hhNlBRSkFJeGtPMEZwRlFoMVZwZ1lJZnBwdlJ6?=
 =?utf-8?B?NHRUanNMVEZ0eHVPaGdUVlhmb2psc3NsaUswNU82OFZRNmFlei83Mld5akhS?=
 =?utf-8?B?VWN1NTBUNk41N3orYUJTeTFORnY5bWJnSXkyQjQyS1FTandBazFpNHBIZmdT?=
 =?utf-8?B?NU1WNW5QZ2dsUzdHOURTZWtuVUlHVDAzcGNXdzJxRTBuWEVtaklUVGZESk9K?=
 =?utf-8?B?RFFkV0tneVVvUWFZMDN0R09GWXUva253VTFwZEcyWU1QVmVTeVFiN0J0SFpU?=
 =?utf-8?B?VzdqeTZ6SnJhKzlFd1FNRklCVGwvWU9VRURFZWJYNGNRMzJ4S29uQjNaclRq?=
 =?utf-8?B?SWlVNVdXTm5iQkhwa0hZaGxoQmlZSlIyS0sxMXJDbmVMSkIzUGNkYm14ZnZD?=
 =?utf-8?B?Z3BYYk52b3Q0bWJpWW9LUzBPMU9WaW4rV2pyb3pMMS9KWVNjTm9iU25udG51?=
 =?utf-8?B?VW5kL3dpSzlWVVYzVlJWSEtBeDNwRTZ0VHV2QnYySVh1N3FMUFlpaC9mUnZ6?=
 =?utf-8?B?YnJaUGx0bzBNZ3dmbitXaUl4NHlBdEdKczdIREloSURHTFhvWGJIWHZRQkhF?=
 =?utf-8?B?VU5aSkRoUmFpdVo2RmxBRDJNYUdmYnpiNlNVblE2QVYyR0xsT3pVU2RLeEZZ?=
 =?utf-8?B?VjVFR1lGRkY1RmY3bEdJaXlQYzZxUnlVOVNsWExrckF4RmJCaHo3VnpvaDhk?=
 =?utf-8?B?eFF6Wi8vTHF4RGJxN0U2MURUeGFDaWJaeGRUbnBRODdCS0VaZVBzaXN5dGN4?=
 =?utf-8?B?WGJOZkhqamhjalZ5bW9BbnU1ZWpkVnRyRHFWTTRnUHQzYnBncmhGN1JNMzBv?=
 =?utf-8?B?SFFKU0tPa25zcC9Tbno5UWN0MlpyQTR6c2M0eHJnWmlza3dmRTFDS2F3MFRz?=
 =?utf-8?B?TEdwYU9sSFpRZXJYUm9GUmZCakRxTjVFS1c1VXlURlhZUUdNUzU3dUJQN1Z0?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F53DDDE5F46F648AC1132CDBFD7B39B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d50c6a-abd6-4b0b-5b63-08ddc3e3420e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 21:04:58.9504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIa1VWoiJh3ZrQc0vginwSP2lCfoMNComw0RWZ9Wdmpx+4apdqkwmxODyaAk1yH0ZrTBReL7ftW+yOm08L9VH+XrBnhOYt/Za7WxsCdrd/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5782
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTE1IGF0IDE3OjEzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBU
aGUgbWFjcm9zIFREWF9BVFRSXyogYW5kIERFRl9URFhfQVRUUl8qIGFyZSByZWxhdGVkIHRvIFRE
IGF0dHJpYnV0ZXMsDQo+IHdoaWNoIGFyZSBURC1zY29wZSBhdHRyaWJ1dGVzLiBOYW1pbmcgdGhl
bSBhcyBURFhfQVRUUl8qIGNhbiBiZSBzb21ld2hhdA0KPiBjb25mdXNpbmcgYW5kIG1pZ2h0IG1p
c2xlYWQgcGVvcGxlIGludG8gdGhpbmtpbmcgdGhleSBhcmUgVERYIGdsb2JhbA0KPiB0aGluZ3Mu
DQo+IA0KPiBSZW5hbWUgVERYX0FUVFJfKiB0byBURFhfVERfQVRUUl8qIHRvIGV4cGxpY2l0bHkg
Y2xhcmlmeSB0aGV5IGFyZQ0KPiBURC1zY29wZSB0aGluZ3MuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBS
aWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

