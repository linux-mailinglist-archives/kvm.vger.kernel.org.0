Return-Path: <kvm+bounces-51632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 402ABAFA982
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 04:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DF1916A47A
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 02:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0AC1A316E;
	Mon,  7 Jul 2025 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VMeI1DdO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABEC4A3E;
	Mon,  7 Jul 2025 02:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751854156; cv=fail; b=jpbK1lHeYc1m61pwCdUz2gUDcXL9s2/5FHYuGRYNl3FIQd75N94MRgBg6q5kzGYqHLbHLIxyBBehZ1IjEtpnnDZ5HkAzJ19LwseJ9jz74MMSYs3Sn7wa4Mb/YANlSHZsX0GNpatuEDIWuoU2S8IZ684VG/h9kMqOIv4UW3OLzUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751854156; c=relaxed/simple;
	bh=+YLEAZI4UkGjN1SLpBq0OOWcB0Xx27wz2wGp0hZrZWE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I5eXWqV4yNoEDnIqoqNnuByWGNBxRi7Q0WVYQT3R0UHJs2VfNC8krzKSu+0LWq5HoQDgFpxJrBqtIkqIkjKHOvwLYYXpUVWuo9J9JJVceWNATEwKnzw+UHkfGrvSQK3TEup+oVzkXQu1S6DN5+XSw/DweIj4sQBQSYoHjJMqI0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VMeI1DdO; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751854155; x=1783390155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+YLEAZI4UkGjN1SLpBq0OOWcB0Xx27wz2wGp0hZrZWE=;
  b=VMeI1DdOVcuXz++WbMiWqnDoeTZMb2g+6hZXxJShR8rHWGvb8Ob7K7he
   ii4ZMX+N7G1tUCP5ALhorb/dajTu3FQZ0pr3b3BJX6Q54argyYHcFJ1Cc
   OpObXmTwrp6KkqMZoVW3IKNcby5Ugrty1+4vqP5jImo1ZuWLx4RMYOtUk
   xR4moeRWhRLCLcrudREqrZXMMENlDAJ/6WQ4CkcxzKrwOkBInOmWxXGku
   6yjWaITPqeVeHB09eZB3v49l4Ld9F6Lo9T57oEuAGf6MQV7U9Huah4sKK
   RVUh2flioc2rXDvKbUINX60avyYixY0uj4VIKRGNYsOn+tsk4GnHjVC2c
   A==;
X-CSE-ConnectionGUID: 8/yRi404QWKXOgVI3ALyNA==
X-CSE-MsgGUID: m+AP+U4iSsqzedlI5zAfkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="64661547"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="64661547"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 19:09:13 -0700
X-CSE-ConnectionGUID: NSOwQfG3RsakpXX+nCHkSw==
X-CSE-MsgGUID: CROd2IujR7GIbgs0RuSs/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="159112058"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 19:09:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 19:09:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 6 Jul 2025 19:09:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.76)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 19:09:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADDJiTChM4Mwil7qoM7XkBcJh2DfJrVdkppJDq0Ffs960D19k5aSjHHWE5rQHEDfFo00A1nFB7AkKxA6kxSix7Q+gpvm3lwKOQAZP3kPbf3WB/1qjzSUxVpF1hywb4mbpk25e6YLThpcW5MGsRajlZGt8sFEcj2QXVWSHxJSI49S47gpuo8EqtsLOfQJ8JK9Y4GR/+5MyKa3G7CcdjYrQ6hmRVBCHNRBpN+ZfBI4GO3GRhf3Jhuy32uqHRQNyo6LJF/qX49PAa+wjMqxS1VM2Pu9VdsgsDarY3c1XeEfgfcSnNR4r7EYumlJj5UvtOftJ/az2aDiF9nB95ygOaoc3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YLEAZI4UkGjN1SLpBq0OOWcB0Xx27wz2wGp0hZrZWE=;
 b=oZ6KPhWBqUHdIic0pEm4gBUmKmPGvu29nI1LOcbaEZcnCT2G7QWjLbFoTOep7VesGHBtPR5VAQcTkKaZAq4K7vv0NXIFOsmddGJ7Cl0hHzfYCDa0eHr9SPzqUpqmJd6d2CQXdeuPu4V7lwmreyWxeieVkzwNm+AGoQ2MnI5DVadyUB3I68K6dYMUmXWPhFAoH3S9HUGyDGMMNLn/IuQhEa2KkYKFfEHMf3G1Ow6n2BKbIs4b3axZxAjLuDqh5hy3gvw3nOs8vk5s0VUgKea22FCFrRXpO8a7oE0+FIpziqigUXIq0a8LjEvfwyDrnCiKYGKoWF6YXc5SPvCCrH/hKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PPF4AE904FD9.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Mon, 7 Jul
 2025 02:08:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 02:08:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb7DBrR/UgIkK6fk2IQ4TiGChw67Ql78mA
Date: Mon, 7 Jul 2025 02:08:54 +0000
Message-ID: <7c78bc12a6393a7821f613a1ca98dd711a66f668.camel@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
	 <20250703153712.155600-2-adrian.hunter@intel.com>
In-Reply-To: <20250703153712.155600-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PPF4AE904FD9:EE_
x-ms-office365-filtering-correlation-id: 2a4891f3-8d25-4df2-c531-08ddbcfb3998
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NmRtdUl2N1VTai9ieEhGVnMwR0tpcU9yZGNMazNwT2V2L1B5eHJBSG5OcExn?=
 =?utf-8?B?b3B6NmQ4M21xYVlIdXl2Mm9kR3RBY0FCQUhRQmtGRERkbWFVeXNQeWlkSjhH?=
 =?utf-8?B?N1FIaUNuaHZEbStlb05vQktlYmFhSWZDeGlSaEJVaFJNRVFyR0FUQ0ZWdnpM?=
 =?utf-8?B?cGMyVEx0OVVKV1dCNUpYMWhXQjRadS9oU2xMWm5xYkNCSHp2M3I2NmN4Wi9X?=
 =?utf-8?B?NDRDK0xrcXhHWk9sTkI1WWd0L2l5RGVXQVJDMVNsUk1xSUV3WGJnRk50UnFx?=
 =?utf-8?B?cnJvL2JkVXgxMXdRMzl0cHBuTFBUTjB0R3VIN2lGRWtyWTdLa0NkMWF0UXlj?=
 =?utf-8?B?QXB5L0xXVzdlZ3pFSWN4RDMrTVJ5TXlrT2pBdUp5NHFKQ1d2eEJDNjU0bUNj?=
 =?utf-8?B?SWJRbHYwQ1hOcUNTL0lKdEhCU2ZmMWdxYVdQVHFvcXk3Yi9XOHJkMkhQc0xF?=
 =?utf-8?B?QjNkcUZ0MDJ0V0pxS3drUGhGckNtNDZObHlHcDNDZk9jVlRRU3RwbDhKNitZ?=
 =?utf-8?B?enZBb1lSY3lnMnhBQ05zYnZoTjBDL0JuNkJnNHIvb2FxTXIwSE9PNXU2MSta?=
 =?utf-8?B?eEdna0tTUmNnMHdSZGluUVpNb2YvR0YrdE9UWjNObVZvTVNaK3BydEFCbnEy?=
 =?utf-8?B?M3kxR0hLb0R2WjJsQjEzTDA3MGhHL2RRbHFCT2JoamVRYXNFeGM0VUo4a2dN?=
 =?utf-8?B?WGdBYm43ZmZJajU4UXFKOEZCU2R3K1Y5TFJEalhMeVlIL2VLVjZhNE03d1lM?=
 =?utf-8?B?QUFKNlFIcEJXUmlxNTV0NWZwTFUzaytMRzllNUlJd0hmeDJwRE9FbVNxR3lD?=
 =?utf-8?B?UGs5bDI5TmQydW95WEt2Y3piWmVjRlpCeWRwTVlwcXRnQ1JaaXRuenozNGdx?=
 =?utf-8?B?aU9ONHo2UFhNRk9lUjRsOGJrYnlVam8wNlowTjdFZjc5TmtwV0hmZFV4N0Ey?=
 =?utf-8?B?eWNHdFpsRE53UzNWS2RwZUFheUN3WENRY3hDdmJkcDNwenZHZWliWEpzOHh3?=
 =?utf-8?B?clZ3dzQ3TU8xMXpsMUkxcWNzb21iR2dCL1dLSHk4bFppaHEzTEZTNVpBZ1h5?=
 =?utf-8?B?VExyTXo3OUpiR2RmSUUwOStuZ2p4SGp4dWVtWWxnWkoyQXU2YzR6Sm5aQnFZ?=
 =?utf-8?B?N3VYUmlJUWZ1TmRHdFJmM1R5UHVGc01CQ1Y2QTB3MFdOcVhqUEJ0WFVsQUhS?=
 =?utf-8?B?dnJQN0sxUE1JRGlaTzV4MS9Db3NSbTBhNlBxZmtiSFErb0NCa2ZLYzZSUDVu?=
 =?utf-8?B?UGJmRU1POE1mYXZuQWJmRzE1WEpnUUpCTmQ0N2JTMzVOTDF2Y0NUazZES3dw?=
 =?utf-8?B?S3oya0xGdzJhVENCSXFtM0tjWDV4aUp1Smd3RElWTVh2L1hQMTlMNS9Bdk1r?=
 =?utf-8?B?ZE96L3dEbE56NG5wTUxkNXdnaVVQS3QyWmZRSjV6QkRZWmFrSXN4TGFHUitJ?=
 =?utf-8?B?S2VWYVB5TEpKSkNhZVphZUF3b3h2OUJCMkpCQnRVTTE3eWl4dnBuRVRCSzZw?=
 =?utf-8?B?N0c3OWJVaXN3ejl2a0w1dFdldWhCd05YR0pRZVN1VlZ6VG1iZGxKbWFWbVIz?=
 =?utf-8?B?a04zS1lBVHIraUlvT01IM2dSakZxMDQ1Z3RmVUZuMnVHa2pmcXY3OG1EM0hp?=
 =?utf-8?B?RGZqd3pycUJDZ2pHKzBzRVVVWWRJZGJnVkFUekh0aDBXQk90Zks1NUVPb1Iv?=
 =?utf-8?B?WFBKcEZlckgvVmJ1bnovWEVlQ2h0eGtpSDhLQ1JXaEprOGM3YmQ4N3o2N3Mv?=
 =?utf-8?B?QklzTXRZc2hhRW10d2F6bGM5czRKVUxIbVAzeTBjb0xwc0ZjMTRjaFJ3Y3Rl?=
 =?utf-8?B?cGtwSjI3OGdxWXBzL3RNRncwVW1mRDB4aG90SHZsSnM3b0gxYVNybmJaQjRS?=
 =?utf-8?B?RVB6Mit6MUxBSjF0c2k2ZWx1R1lVWmtCY2JhQ1FjdmhBdTlnS1VDOUdDV2tY?=
 =?utf-8?B?cFprRUNtVnBKRXg4NXNqaTNxYkZvR2RVeTNyNEdoU25HbVB5T0t5WnRMZjAz?=
 =?utf-8?B?eklkUWhZUEdRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0xoQlVuMjJubG92M2xBOS9GYlN1S0tzR0k2WHllanlTR1lieE9Xa1hhU3FV?=
 =?utf-8?B?K0lMRDl1QTV6bVRiNEJRT1FVMC9hY2FyR09DaGhSN2pCN1FxRWRLUjRJTm1W?=
 =?utf-8?B?REFrNkJuWjRwUzRMa3A1L0QwUWdaU3piWmVZcThGY2IvVFVvL2tHaGZtMGxP?=
 =?utf-8?B?bmtSb1pUeVQ2NmY3ckpwQUJoR2JubitBRkJDdWx0M2QyNmVwY3ljRVQ3VFlu?=
 =?utf-8?B?T2wvUGRjN1FXZlZOeHhtcTYwd3JOaVFOUm96NHYvV2hVZmlNVU9lelNKM1JO?=
 =?utf-8?B?OFBudnl6TjQwa3RFdmdFOUUwL0lnamE4N042UEk3UnJvL3UvNUZpN1ZDZ0I1?=
 =?utf-8?B?SEt3bWd0cnRBOXBwOUZGMXNhVVUvWTdyWTZRckxNSUZCR2RnZkROU2t3QkJ1?=
 =?utf-8?B?ZENkOFFwSnIrbjRyMXBiTVUvRSs4d3F5MFA5WWVnenNDaUh0SnJlQnFVc1hI?=
 =?utf-8?B?NklITU9YWmgwSmUrMjFBOFNqVnoxQ3JIN1F1VFBuL3NOWjJyOVVXemtZWnBo?=
 =?utf-8?B?R0FMbHNaNXF4VmhDaXNoWEZocTBrdjF3bzdVNkZHZkZ5OUZtcjMwNmZMZmxz?=
 =?utf-8?B?Tllmc1hBOGl6ODBLYUxQdytYaFEyU0x4SW9HZElpWkFRVGZyOXprOXBHT21o?=
 =?utf-8?B?SHl3ZkFhOTk4WlNUVFhaSktzemNCaHpZMFV5SU4vU28vYVROZXlzVXY2b2FS?=
 =?utf-8?B?K0VoeWRBN1A1TVgyYVk2di8zcUNCR0VNNjBsTVYraDgwVkwxSEZ1Z1ppZzBJ?=
 =?utf-8?B?aldaRU9FQ1BPSTgyQjVrQjZKOEdhenprUzVraWlYS2JVcVg3RWo3ejJ2Z2g2?=
 =?utf-8?B?eWYwK2RwZ0NxY1cvSmttZExaNCtXMGtiZ013TksrbXV0MEdLcS9GcndieG5I?=
 =?utf-8?B?VjVJTjVnU09TdjdXRHdYL1YvWUxHU0hWRVNIZjdYRmZNclFxWFdIZjRpTllq?=
 =?utf-8?B?T1lvRldQUUxxZkZSUUVzeWQ1VGNtMXlKMnQyUFZXZWpnSUV2STVJYmtoU2xi?=
 =?utf-8?B?MmNUc3FIVnl6cEhpVWw1TmxiclNPbzJab1VvUk8xZTlTUU96c24yYTYwOFNk?=
 =?utf-8?B?ZDg3bmYxRmRJVVk3dC9xRnR6T1VSYUF0WnRsL0hnMWUrSkExTXdvSkdBalBm?=
 =?utf-8?B?RnFBUzNLalI5eWNMMExyZHdQdEtzOFU3TlNIY1ZjSHhteFIrRktzbVZJaHlr?=
 =?utf-8?B?LysrMDhrUzFtNkJGcmsxZnBYVHpEaXZTeGYyVHpoK24vdklxL1U4MTQxeGpN?=
 =?utf-8?B?WXhZKzNsT3ltbWh5TlhhODFIVC9TWG5yT3lHNmNrTGc0RnJyQ2FtcktGcGFD?=
 =?utf-8?B?TGNsTm1Mb1Q4NjdDTDZzM1UvUjVNTjB0cGtTM1ZCeVhoNEFuYVFlWU5mM2xT?=
 =?utf-8?B?M2xPQ015VVBKWGo1NzRJYTNjcjMrNk0xVURiUWs5WldtQ3hhM3BNaG5CQ0cv?=
 =?utf-8?B?YVk3Sy9HRXNjT1EyVS9DZ0xTeEpRUWpYMnl5V1B5SWdkQVZ0MGNJMkJlWmFa?=
 =?utf-8?B?WnJ0eVpnOCtaTkk5WWpTY0JleUkxK2NGeUFGWTJSQ3V3cWEvUVoyVVdtbGNz?=
 =?utf-8?B?eHhSeXZaekhtaGFSdndGWEdCTjNvQ2xEL04yZFZsSDlURHluVDZGNGFMalIr?=
 =?utf-8?B?YUdsTmFMZDhvMzVYUmVwcGxlTFdsQ2RwUlpwTzdsdFhESXlYekUzZ2VkZ3h5?=
 =?utf-8?B?Yk1jamFlK2ZHc2xuOHFXZGFRbHpDdFZOWkJnWTk1bDk3NWVhNXZ4VTFpUFc4?=
 =?utf-8?B?WFBYV2RObDNVQnNJc2xzaEZSL3o3RmZXaXU3dmxmVVk0cW1BdXBORmcyQS9P?=
 =?utf-8?B?VWt2VjFaNk1wQTJLbkMvZjMxNDVMSmF6NlJGcThhRFlBM2tjN0dRUWgraEh5?=
 =?utf-8?B?R0FOVzZWN0UxYm9BRHB6UHloN013bkM4aW5IYUNLN0MxV0xZMno4VDlZblZ6?=
 =?utf-8?B?U1hVNGRNTlhEM3FDa3pTV20zUXRqSDNtNThtNlRRd1NmbjM0MDE0RnZObVNJ?=
 =?utf-8?B?WU5tc2YzQTJZUEZUK3YvTWtYQTN2Wm45dmdHWEVjeFpnbFdCM2NEVzNoeWFj?=
 =?utf-8?B?NlNkUEFDTkJlcXZTQnA1bmIwUE4wUkJ2dzFiQVk4alBXbi9ZcWMzU05naUlG?=
 =?utf-8?Q?r93kFkS2CpHtP6IbHBUqCM274?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE0FA95DB6C33B4F9B5C0A0E9D3B8475@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4891f3-8d25-4df2-c531-08ddbcfb3998
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 02:08:54.5350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 42gwJxJWI+r1ajJ0Dy/G3okYIAtdgWuUQw2rOG7rc6PiWHsBa9V47L1eICO7p2pYlTsD1s7VLXN8X1JKtnOyjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4AE904FD9
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTAzIGF0IDE4OjM3ICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gdGR4X2NsZWFyX3BhZ2UoKSBhbmQgcmVzZXRfdGR4X3BhZ2VzKCkgZHVwbGljYXRlIHRoZSBU
RFggcGFnZSBjbGVhcmluZw0KPiBsb2dpYy4gIFJlbmFtZSByZXNldF90ZHhfcGFnZXMoKSB0byB0
ZHhfcXVpcmtfcmVzZXRfcGFkZHIoKSBhbmQgdXNlIGl0DQo+IGluIHBsYWNlIG9mIHRkeF9jbGVh
cl9wYWdlKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVu
dGVyQGludGVsLmNvbT4NCj4gDQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo=

