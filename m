Return-Path: <kvm+bounces-50753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1836FAE9066
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 23:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AA3C4A7BA3
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 21:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B9926D4F7;
	Wed, 25 Jun 2025 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M5riJK0J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82951FDA92;
	Wed, 25 Jun 2025 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750888007; cv=fail; b=upanNgAGWrEoWerNE0v4AgIfNA8Ws/kGSs/OpLWipbLlbmH5NG3h2BUsSTizgCZGVOfBURdnAY+azNHFGo/j6IXicY/BkJk0Y301bGHiU89lGGBk+sWbdG0zeTxaINZhVLnWcf3TTTuW1zil7kAwlMA5E08GIg5V6BxIp2yAWfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750888007; c=relaxed/simple;
	bh=khZ8XzDf6X7C9LWIHmbDtKI1mY0G88oqsH0Fu9u3uZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=egWQ2V/u9yWVMSVR7wwHBkeS6zcybDyI3haYsl0b8vhf1ojTQCy5odMaE8KsXfxHrwXtrJONxAj4yJ8D+T0gK1tVMRAm+oPFyJUQ8y8PHMGG+IeQN7WvmKZV8TPktFMjKZyV6A/IZMfIpR/OUHL+zmiyRcI3p11sOzSKUtsSuZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M5riJK0J; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750888005; x=1782424005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=khZ8XzDf6X7C9LWIHmbDtKI1mY0G88oqsH0Fu9u3uZw=;
  b=M5riJK0JdC5G2OKmwglGgdffKrbdcUi6r+l153LOtJ5yrQTzrJ7ahdhZ
   I+6AX+bIA8RXhLhsfxYrxb+QtIEA1rmxu/ukr1O6IH6JVDPGGV/sHnjfn
   esfGCddnSUW+TQGngspvOnIutW+sTikWNAeWRp9c0Jz+KCnt4I1orvCQR
   MXpzld8iu9suE6hPLLR1f29aKGrKCGZjM7f6rFz1uzWxGJY9X3ki0tPxE
   AJ35WhBiu0uq0Kx5I34F0KA51SmuvToQQWOL3wdnUcRv/X+w1fFmZ/wg+
   h+MJV7Lw7oIgLXi3D997NmZvq/woW6NWLEBm+PwiR+PIWnB1pb7Vg8TpN
   g==;
X-CSE-ConnectionGUID: R7oCAdEAQJy/O9GkjP6R1Q==
X-CSE-MsgGUID: VrcUBhurR7KaWsDGAANbcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53316762"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53316762"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 14:46:44 -0700
X-CSE-ConnectionGUID: Yz0Pe8VnQ0eRR19vbE5ncQ==
X-CSE-MsgGUID: 2VUEbT7HTDqgispBQEpKQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151947232"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 14:46:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 14:46:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 14:46:43 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 14:46:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvX2okzRCeuBzBqQE/yinowux12j1tCNAtET//8htMLzkf2Ip2VedOJzuJ67XZ3Q/mQkwz7EMLLGdAlNjDCzwC6Wc89nJIqoVHut7pCJ2N+VwliUsBQpzByospjBS93tzM8GfD1IqwekwVpeHmHNQOyLHJMJQa2qH7sb3vv0b2WmTGz3+xrkR8+gowuyIhYeqZ9OHUFk0gOpcBEcHmd7HGwdDevPDCxbcKaUGbhI6b0CQFv7p9oweADUT4+R8iSaLtCRrZ++wQwXggbq0/ffW7dHnof/djP5ZKYV9mXidvcSTmhODDnuDdJnhILQOl1fEhwPHm3y4Ky/+9w2puKx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khZ8XzDf6X7C9LWIHmbDtKI1mY0G88oqsH0Fu9u3uZw=;
 b=nn9pXooR/mZgcSKY+OXLa4KCZeOVjP1zPVx+iyC1RYfUNS0TZ6E31ZqPXbE/WjQFmzqx1P4cj+Q3snkagIPSZ6+pj5n2oic/voO2hCqirW3mhTVq8M5+WWobih3TXm/8YVaZA3BrTPRJ9d+XGnjpwg4N6AI6s4XGvL3VtgRymbCEHRyA0HmX1dGU9Ldus+BgWQfWJIf2w6atAok9Job/no+gVn5kCmMICJ8EJbpDAILtv6dDir63g4xXt6N7boEzyXCQ8wBdi3W5OARtYQT/Rk0mUOK4OKhSI/LxfXQ5gD39vrXtK8j6bmKgvZ3V2GcyLRwoupMXUfpoAJZz5r+/1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Wed, 25 Jun
 2025 21:46:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 21:46:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgAAyUwCAAAf/gIAABWUA
Date: Wed, 25 Jun 2025 21:46:41 +0000
Message-ID: <b9a17b7f6e85ffb4bc9f318bdfe0a952b5ae2445.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
	 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
	 <aFxpuRLYA2L6Qfsi@google.com>
In-Reply-To: <aFxpuRLYA2L6Qfsi@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7592:EE_
x-ms-office365-filtering-correlation-id: ba4e3f0f-aaec-43b9-4143-08ddb431c53b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eER6Ulk5NFgyUXRXZXVQQlBLMFFOcS9Fc1Y2RGJCN1ZtaVlkMy9QVmQ3OHJs?=
 =?utf-8?B?bmlqK3dLQkJwOFdWU3dPNkxkdktDY3hPNHY3NEoxTis4K3ZDNml0UnNVU01E?=
 =?utf-8?B?ZWpMY05XOGpMdEp1eGdNYWV2clRtSW00R1REQjBQVmtrMS9GU08wT0FiMGho?=
 =?utf-8?B?QStZTDhucHhpL1U5eFJUQ1F5c2dwWlZhQ2tnRXk5N1Z4eUpXbzZGSWxJMDhq?=
 =?utf-8?B?T1dXNllRME92VnlQSThwZ2VWM21RVTZYSjFjT1dURXZIQVkrRlZ5UU5WYlps?=
 =?utf-8?B?M09uWmhCWGcwTHh5Z2ZRR0xJUXc5Zm9SaW5aTnJxOEJzelFVbFFQN3hnWklB?=
 =?utf-8?B?aFBaMWoyOTdEYW5ubnJGaWFXNzBLSS9IS3E0d084eHVrTUV0aW1UV2RaMHhj?=
 =?utf-8?B?QUxMZjEyNU04NVJTZ0FoWnpzVTRrZGNRMWNldGgycnFVd05jNFZxVm55ekRJ?=
 =?utf-8?B?cXhCYmhTdlJ6bVJQbWtmZEVEWmNEZFMzQmpnRHJiU1dmdk0yOFhySWZMd0s0?=
 =?utf-8?B?QVBKRWtUaWdrSVNTUnlKRU5VejRvb25SdjhzREQ2SjNqb3VPaUhIeHdoY0k2?=
 =?utf-8?B?V0h5SGtMWUIyU05SUEh6MVMzQmZtdnlNS0VBQWdXaUM4dklXRm9pOVF4QmZx?=
 =?utf-8?B?bkIvRVJCRS83TEtwN2xVSlFtbGFSV2dmL2ppa2lZRUJJbkJFUDlERG1nZnF4?=
 =?utf-8?B?emRtVmlzUTdFOEk2OUpBL0JrTzkwZEFmQy9RVVlXMFA2MzBSeFhOYnJ1V2gz?=
 =?utf-8?B?c0RWdXVIS0kreVdaR1JuaytVMEl1NXovUVhrSTVMTllsUVRhRUkvTk5KRjI4?=
 =?utf-8?B?eFk4R2hqU3pBdHpWTmJoTi8vZEZwSDFQZ0RHK2UvTlNORzlScTVSVklObXZ1?=
 =?utf-8?B?TTNKeGxkZFBFdm1XRmFvWWtUWkZrOVFLNkROTmprdDBsRXdLWERuQ1Rqbm1H?=
 =?utf-8?B?VzJZWm5lQVJYMk4wOHFQSmF1dVQwZ1hBTENTVk1Na2x6RkZKR212LzllYlpP?=
 =?utf-8?B?NUZIM2x4blpUTEFoUVZzWE4xZGxvVmoyajl4REptWW5saFEwbkFJR21yRCtK?=
 =?utf-8?B?ZzRUdWNmYU1TQVNQdjhzZ0taY284OWhlSHBmenBaV3BtelIzNnFDTmU0NFVW?=
 =?utf-8?B?SVV2ZEhQSWg2NXM4RVZwWDBldnZIVnJRUmtBK0h1NjNEOTdKOVM1YTNYNzhF?=
 =?utf-8?B?OUI1SkRxOVRuZmU1aW5BWXlyU2RidkJGakNTU0kwVExUUlBCclZwMlNjcDVG?=
 =?utf-8?B?ejZMMjJBUkZIVDdJMm9sSFhlVDl4RmhqWkFaM1J4R01KMFBNS3IzTFBqVlJE?=
 =?utf-8?B?ZzZNeW9ta3R2K01JL1pOd3dLeVpVWitrd2laWC9GZlVyd3JYOEJ6eUpFOHox?=
 =?utf-8?B?RXdudGp0OVE5NDY5M2p1cGUvY0NNQ09xc09wNU5KWGNGcW9URmtRd2Fnc1ZZ?=
 =?utf-8?B?YTQ3TEUyYk1wd1FVZmtkYnNVZDQvWHdzVlVpS1Q0dUxZR0cwZWNsaWRmazlR?=
 =?utf-8?B?SFlCSHNxZ1lUSDZIN0VmcWVBUkN5VXN6YXk5bVJkUFRzQTI2UVgzamFqWkNt?=
 =?utf-8?B?VWlGcVZncGhNQjhBTkV6OVFCY2xDdjRyNTB2RmRQZ0pSTXl2SHViOW5NODgv?=
 =?utf-8?B?SlVXamFrTUNqUDBOc2ZITWhtWmIzaWZ4R1MxZndRdmN1UFppKzhHZVNWL2ly?=
 =?utf-8?B?U2tyNkkwQlhiK1dzUkwzQkFhZVpmMjFIdGRtb3VYNEV1WFJSRkhZSGtFQmtw?=
 =?utf-8?B?V0lNTmRGVUplVkxMa3dQOHF6Mnp6a3lxSmZxNGRXVVE2SXI2WHA4V0IxMjN2?=
 =?utf-8?B?bjRyNHhrNHo4ZFgzRTN1a0QxSGJxNWFTYlJuV29VaVk2VGFDRGhKa1JRT1dt?=
 =?utf-8?B?SCtJeHM1bTVYcm5qVTJubnM2WUhCUXpMdTJ4Y3RXcDBMSkVyamFDcWRCOTZM?=
 =?utf-8?B?QVVWSDMxQitzZkhlTEJqYVBTeW53UjZkayt5UysyaTFRSGhFazRLTEUwckVP?=
 =?utf-8?Q?2Y5DUTmSShBsc981FCJgnOdDqsePcA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzRIZ2JmM3VtTE9zVzBHc3FWV2NDa0xSemVRR2FmamtTUVB1dXhoUkVPRjBW?=
 =?utf-8?B?eDBYcVBCRW9NTUlDSlgzL3E4Sk16MWFXOXlXRTZMUWFyanl4SFNQTmx1Y2Fp?=
 =?utf-8?B?aU43dDU5bVV5M05QaXhnQTA4Z0Uwa1R6WWxML0tjUktWdm5nRDBYTll4U3RN?=
 =?utf-8?B?bWJEVWszM25keEptV2tyU21RY2thdjFPRTZkMEkydU5qbGFGN1drNmpaQ3ky?=
 =?utf-8?B?ZjRPd2lsYXJWaXZPRDFFNk9iN2xXcVl4a2c4M1RWUnJOY2pHTUZjdlBFL3Aw?=
 =?utf-8?B?M2VBS09ENGxUWVBCejltb2luczdhMTJjRWhNRTFsR2lxQXNPb3BxWHZFUnc1?=
 =?utf-8?B?eGlNN0ZmcTc5RHFHZ3BQRDlZZ2luWmZoYmswTERpbHZnOWtSd0RxVGwxczAv?=
 =?utf-8?B?SlI1QXhQTUpnUW9lQTVGYTd5UE5oR3RwaEdIcVUvUk1IU0xLWTRWWElzc2Vt?=
 =?utf-8?B?aktwbjJqeUpGSWJlNHE4WjA3bHczRXUwZmNRd3ZjUUVTWktXNmpldEhhS1hh?=
 =?utf-8?B?d1FBdE5nUUpwSVJ4c0xVTTdTMUtEcFJPUWU4bEhVSmZFUEJYYmhmelpWS1Bz?=
 =?utf-8?B?UVJhNFAxMUdMY0lPWUxPNmJoOGlMazBuMmVDdDRJOUZOQW1rMDdvT2RqK3JF?=
 =?utf-8?B?OHdvbjhyQmFUbVJqVGZuZmlldkxwT2xXUjRyek5yYit3Q3hDNGUwRXEvdEpV?=
 =?utf-8?B?TW1sUDhEMzBSU0FjK1A4TkV4YlpEL1VHdkNkL1psM1FIamNvbVhWa016eS94?=
 =?utf-8?B?OHp1NmIyTzNqRDd4eXlBY1BRb1djVUZhdGY4WW9wMHZzOVhNOUlOKzgyeHRJ?=
 =?utf-8?B?bEpxaUxMQkNkNEhrOEwxQlJiWlMrSU1VVFJHdVo3T0FTZkhHOGZhc0VNdERn?=
 =?utf-8?B?dldkdCsySkp1K1kybDZEMkp0R2tWR0p6N0xLRXltSWhQWU5wRTZobFZKLzdv?=
 =?utf-8?B?Tyt3UFN3TW1LWksrOVpxRTM5YzhZTW1YY2xsL0RTSFE4UzhKL0hwUXBUb1l3?=
 =?utf-8?B?MVRrZVh4enp1a1QrbCtjRXpCcmlFaTJtRUJoZkwzY0tOVGFHQXNQenUyaXI3?=
 =?utf-8?B?U042WEtsdVRyaGF6cFhTZGZsY1RoYkltQ3pKcDBTS1JpWE0yTDVIVnFqYU55?=
 =?utf-8?B?V0RFTFRDVU81eTBwNldIeGRCRGE5YWY1L2t6eDJKTStESTlNVzFEZEx5M2tM?=
 =?utf-8?B?ekdqWkpKM1BCZEp4TXZvcXk0d1Zxay9KVU95bW9BR083ejZPT3hTT0t1aGR3?=
 =?utf-8?B?QmpPZ00xTlpMUzRMYk5GOXZZendXWjUwMnR5MllYT3VFU1R1WEVMbzhJQXhR?=
 =?utf-8?B?UlBieGYwbWZQdDlYQmUzenRVZk9rMU1XeVlJRmgrdUZlV0FLZ2VDU2IwSGhD?=
 =?utf-8?B?MXNyVFdIRFJjOGtsWUlabGg4R3ZuMTgzdVRHQm95SXpPUWFBbmtBM2Racklx?=
 =?utf-8?B?SzRSSTRVZEc4OTRxbnd4T3hlQ1B3QjVGQVRORUtBOXkxZjJHZ2lXZlBBMGUx?=
 =?utf-8?B?K2lzTllMbGIvNHl5b1EzYVNEVnVsempkdVNzYWk0eThnRnRNOUpnK1NYaDNq?=
 =?utf-8?B?SzY5M3Z4OStPcDU3TFVOa2J6M2dpSXJMUkNXem13RE82OXl3aHhWcXBtVjJQ?=
 =?utf-8?B?b1owek5hZCtwZ3Qza0I5a1lHaVIwcEhqRGc5S0dTYjk0eWp2TEo3aWszS1Rl?=
 =?utf-8?B?RlZ6Z1hObXV0TzdJOUIzSU9RYXZyeHpZWXd5NWRMNkExQkdLbXZPYlhjZmlP?=
 =?utf-8?B?TS90M29KeU9pVldtN25sVWs2aVZMQlJNL3FIY1g3d21SVk8yOTZvc2RoZ1VO?=
 =?utf-8?B?RzVqR2ZoS0hzWDI5NURaSmtvVXlUUVV2MG1XTDkvcmgrdjFmWlNQOUJiMVB4?=
 =?utf-8?B?QTdYN2FXcVlNMzNUL1hzMHRoTitid1FZOEdaN25yVW9aOEJnZ2hRQ0hLNWl5?=
 =?utf-8?B?WURtVG9Mc0YyNkovWFpxanE3cUxwTmxnb2E3RFJoL2EvYlRka3p4YXlwVm4v?=
 =?utf-8?B?UDI4aWRJUlhRWWpJWGpqcWtHTGIrb1FsUFJMeWplZnkvaWhxME9hTXlOR0tZ?=
 =?utf-8?B?eTVWS3hPZ0kzUnZYU0QrMXAzeW84VTBGRW5LMFptNWRrcHYvNHUxaVlHUTRX?=
 =?utf-8?B?K1hBb215VzAyQUIzK096b3Vpa2lock9rd2tGL0Fyek9ZbGlCZGpPc3JtQzZq?=
 =?utf-8?Q?eJnz8puV4YmF9zsbdgIq5qI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D5357B208CFF24BA64E47DD4CFD7E07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4e3f0f-aaec-43b9-4143-08ddb431c53b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 21:46:41.1715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rMeFmlWlBBsSLQhtDYGzyuSjgaz/fw6S1UpZhDymzwmz230QenMz/1hWWXAVMfo6qKBCXuUHYbbW0p4oi+Vv4w1t70BI5WYSoCMXY0XDMHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE0OjI3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBDYW4gd2UgdHVybiB0aGVtIGludG8gbWFjcm9zIHRoYXQgbWFrZSBpdCBzdXBlciBv
YnZpb3VzIHRoZXkgYXJlIGNoZWNraW5nIGlmIHRoZQ0KPiBlcnJvciBjb2RlICppcyogeHl6P8Kg
IEUuZy4NCj4gDQo+ICNkZWZpbmUgSVNfVERYX0VSUl9PUEVSQU5EX0JVU1kNCj4gI2RlZmluZSBJ
U19URFhfRVJSX09QRVJBTkRfSU5WQUxJRA0KPiAjZGVmaW5lIElTX1REWF9FUlJfTk9fRU5UUk9Q
WQ0KPiAjZGVmaW5lIElTX1REWF9FUlJfU1dfRVJST1INCg0KR29vZCBpZGVhLg0K

