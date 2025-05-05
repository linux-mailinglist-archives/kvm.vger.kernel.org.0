Return-Path: <kvm+bounces-45411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4EC8AA9098
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 12:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A51F37A2CAF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 10:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412B01FECBF;
	Mon,  5 May 2025 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYh3853P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1217736;
	Mon,  5 May 2025 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746439739; cv=fail; b=Lwl3CZN5gcgbLSUguyaxDTWTJAcbMSMV5A5T+dwZJ/8OvoyhAcAMAEE5pmMjVYuwK0f52pSJzMU2JFOb9qSNIg04dpx/7S/W/AJRWBMqUoZLLGaDrCH1z87ZkZQMev+7Av3LZqIg6WHyaJBqb6/NFLTj9f/N9cKEmVmDQHeJbRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746439739; c=relaxed/simple;
	bh=lUHK5asVCmMK1Y8/wpihXLnPW81G9bpDQArx/a7lSHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B1YOmuW1b1NeiYRZ68aJHYl67C94LRgEGTqZsMeNENmdtu8f6zgRO99nvrGiVP7lUonSL3IZT8HcPNC0Lfe+InV/z5Q9/IItcoeAA+Sdb1aLMQZn5LAv+2bX02JErhc4A+F+Jc83Nk+zxM5uEe8W317f7wNtXe2CSDTDOxRMTwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYh3853P; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746439737; x=1777975737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lUHK5asVCmMK1Y8/wpihXLnPW81G9bpDQArx/a7lSHk=;
  b=KYh3853PhV6lrpV/8Nqr5oXSrFXm4pJA3srAkTKD9UqHWz8l76wkttiE
   NijdrVVMfTd7a/BYzbr0y7dgoJvsYmPfWy4sv0kdwxZpPFh0L304ytaks
   P9nJyAQjn4Dhm9MRglsl7gNQlDw0hIOFzEGZjEyWq849NIYnGlQYGis7O
   hJ/7cqKVmjVRMZKrFKApjNTknDsPUXXSG/D3F/cM4a9yacVLfdz7eojIz
   bPqdoV8Mc04Q3U6mkz0Jv9aCuR72Of84yIDmC3LGyGhPvCt6OKyLQ9kQS
   zMB0UG7bT5XCSY03T8dTykheQVYy7aAL6/ls8/oIPBKLmFnU5TMR8tK5B
   Q==;
X-CSE-ConnectionGUID: nOg1ywQ2R+KikA/pVqVh7w==
X-CSE-MsgGUID: stZuLcHpRom10H3UxF6RAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11423"; a="58702032"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="58702032"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 03:08:56 -0700
X-CSE-ConnectionGUID: xByZx317TJOMw9z8iCH85A==
X-CSE-MsgGUID: ma6Ad35wRqm+jFbwTf7pVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="136188825"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 03:08:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 03:08:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 03:08:53 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 03:08:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so5uEWTOE3CwG8guVOuPbkPNPoVbhfDrKKpVojuzM4EqJCdind5txFvu36RgVUG0tFiR+3QxYJWo3iHFbRwdVm/nyL2EsxF6NRGtqCLO9CYVuT/wLgy76rmURvpL/kB+jxF5oxtwkI+tRpo4rMuoMIU+yFP9eBOOpqB//QX6iRbtSkknQXcATeakPAYXvhFzjSFWzer4VXa4UPYCRf3NVBWu2aOOEPhesp3PAujs/D8KkmDBHsEaGKJdu1NaHPq8uZUOrjcBmSLZbA80YWOMX/p6dEooERrIKZ3+3r8C9U0DIjvzHTrEoODLZacjKBXJUW7CRbs05mFvyTkjGtNXMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUHK5asVCmMK1Y8/wpihXLnPW81G9bpDQArx/a7lSHk=;
 b=q7wE/8cmb+jlNVLIUIMrJTvilXVjSvMZ73z9RP0ksr4fKB6NtHJcd6B1fBMbO2221HNJ++SjGZlVTERg7S9j3l2j7DgNvWEn1pUvJPBqj4GSbZteTdF2flwCv90TJzuuCilZQVaI30hHNSvCo4JzfjufYwcgrncIj+GMovuvpnCYnelrrRF3qEMaTdcL2f+e7LT0E2M9udAkmE+pNEBn8STlUG68qiyL0iq5/ZAPr+54UVD0nJ7nispKuXhvuy1eh3bXN3deNlvHXStaJl+dcnjojkjPWROz1lUSgWe0muSlE8EGOz7rymUWfLZLu90XbI6DEtOF94U7ov6W0JGEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4442.namprd11.prod.outlook.com (2603:10b6:5:1d9::23)
 by PH7PR11MB8011.namprd11.prod.outlook.com (2603:10b6:510:24a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.25; Mon, 5 May
 2025 10:08:50 +0000
Received: from DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9]) by DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9%4]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 10:08:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 01/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [RFC, PATCH 01/12] x86/virt/tdx: Allocate page bitmap for
 Dynamic PAMT
Thread-Index: AQHbu2NVXPZivQq+BEGwfZ+MMLlhLrPD1JwA
Date: Mon, 5 May 2025 10:08:50 +0000
Message-ID: <d831a4cf92fc2e514384989a9c35b07c4bc1f546.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-2-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250502130828.4071412-2-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4442:EE_|PH7PR11MB8011:EE_
x-ms-office365-filtering-correlation-id: 1505b22f-0e5e-45ce-d167-08dd8bbcd57a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Nk1TcFBRU0toaEVJR01JaTVlOFJCbGMwY1RTT1EwY2RpNzdZcGFwTFBzZ2xH?=
 =?utf-8?B?d20yS0FZYnpuc0dVUlZNanRVcDVWUFc0VW96aW5LRzVkNnUvZ0dQRFgyQmxU?=
 =?utf-8?B?d0tsa1pMVFh1VUIxOWYrY3lZS3g4b3RERXZIUDhvdStMSGF4NmxLQXdGRTdJ?=
 =?utf-8?B?WHQva29GUVpnc05TK1h3Zy80bW81eE15bjNuVWwvQ3lCQnJETlVCNjNuRVVw?=
 =?utf-8?B?a3lDVlhNUzNQcERzaVBBWk5LdGVBRnBOT1k4SlMrSFgvRHN1cGhEYm0vNXM1?=
 =?utf-8?B?MFl1OHR5c0pBdFRVSWkvQWYvL0tVZlFNbHdOQ0hxWnVSWXc5elRlVUpEclJG?=
 =?utf-8?B?Ky9USlFaVmowOGZINWZLOUMwaVp6VmRPblkwRFNQUTVFQ2pNU2QxYWFiSHA4?=
 =?utf-8?B?T0craEI0eDB0dVJkdzFLR0dDcy9QcXlpVFpLV1lBVWM5ZktnRnBkNDVqWjNL?=
 =?utf-8?B?WUlocnBwMFIyOUt5T0JUVlIrTWdkaTJpOGVxQlZ6Y01qNk85Z3h0OENIbkNw?=
 =?utf-8?B?a0NyYzZsTGgxZnlhazhsK2VYOGhQb2dDQjJpSnRiSThScDhWdE5TRHY5TGpa?=
 =?utf-8?B?WU13S05zcHpFV0VaSXp1YSthaGdQYUhkaWNEREJkakUzMnUwanpMQTVpQTk3?=
 =?utf-8?B?c2dHa0ZnazhEbmpPeEo1MmVweVhMSW1iWXFxTllzTjFwbCt4czRNeWIvWm13?=
 =?utf-8?B?WUc4Z0FWVG03UTQrRDgwajgvYnZ6a3RhZk1LbE1rRGgwNE8wT3hoSzloUjlZ?=
 =?utf-8?B?RW1DNWxXKzJaMFFGQU1GWFo4SUR3dCtsOEFpVWU5QXkxcEdROVdmSkZhU2xa?=
 =?utf-8?B?R1VSdEFiSERyL2VaeXhJd2JFa01UdWdBNkY2UkVpNnUzbm4vbjdaRDVZUWtM?=
 =?utf-8?B?S25nK1RUaEF2d0lKUlNWVXlLZ0YrSFBNeXZsNy94L3c2WEQ3TlM5ZWp4R3ZR?=
 =?utf-8?B?MHVicENmejlQcmV0NjBlVDdabkRoSVcyRUxsTjdJdzdnS0hraFBuZGY2d3FJ?=
 =?utf-8?B?YVZHMUVqdUZNalZBbUNkallxMDVZQXlyT1JqdENNSHY2bE1IYzdJa2NjdXYw?=
 =?utf-8?B?WFpvU0xMNmxJMHA0b0FZWXhqUmVLdWVVa21RdjJBelgvQVdBM1hTNTJoVS8y?=
 =?utf-8?B?d1BVa1h0SlpPVWpISGdiTXNoTEpXVmRkZG9ucW9xbUxUbUtkY004TGl6aFZN?=
 =?utf-8?B?UVVIREI4MUdvWTQ3SDZTbzd5R09nSTVSUEQzc3RuamRxdWMyL24rNUNtOUFW?=
 =?utf-8?B?WWxuazd2YUVYLzdGcmU5L1hnWjVTR01hV1pVYUd3emN5NmVCMmZ6Y010RE1q?=
 =?utf-8?B?cWdoWHlNdUhaOHBHaG1RZTEzc0M3OHVla2NMQXNkTzNiZCtvVjZ1Nm16QUkx?=
 =?utf-8?B?RC83UjZiMk5URGN6SzRtMm53R3VpMHJoSVBYc2JsQ3NwaTh6aXE4akRBeERx?=
 =?utf-8?B?TzBXRnlub3p6WlNnd05wUHd0Z3QzZ1VESjU0MlRtRHlreGlybzM4T09jT04r?=
 =?utf-8?B?UXdNRy9BVjJpYnBodGxPL1hadDIyWWZRN1MySnZJdFRzSHVwS1orazJ0UzZG?=
 =?utf-8?B?Q2pBNUF4S2FjcXBCRGR2b1V5WFN4R2JNUVVDR3Y2WWxuaUpVbXJFUDhmMFln?=
 =?utf-8?B?cjFYMjdjY3RjL3ZDWDRQd3NOeHozd1poRGdRa2dSYk9YOUxIQ0pGT3Ntemtw?=
 =?utf-8?B?QzVXbTViWjBUby9MamZvYVpISVVuL1o3Z0pBaUZyZEdLeEl3d0J1dzN0S2Vy?=
 =?utf-8?B?Qy8vZE9mRXErWHBVMDg0T3V6dnJGYk1Tc2lwR3lMVmtsY1ZhOFJ2RkRLeTRQ?=
 =?utf-8?B?L1pSWFlRekplVXE5VlR1aGs2S2txQU0zbzE1SGVnWk83YURCSjFZY2tBczFV?=
 =?utf-8?B?dUVGWU9OcDdqYmRYbURUUnRSMldHbWRZK2hjMjEvK2JWV0QySDBCUDBjQUp0?=
 =?utf-8?B?ZnVUYndQWFZWd1pNUjUyVWM2U2FDbVVEbmhNVVA1blVYejJyY3oremJlRzRT?=
 =?utf-8?B?c2tud0JseXFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4442.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QS9QR2dvYlJkZGxXalkxc1NoblJrTmtySmR4N0NKWG5CUXphRWNKRmNySHNI?=
 =?utf-8?B?eDM3MEZXUnY5OTN6Q3E4aUdUTnk0QnQrM0JFZ0tZbFUwdFhaSmpZNVcrcXdI?=
 =?utf-8?B?TUkvT0pSMFNTV3pwTmJlYUNyUHdqNitaUytYQWpEalBnNDRpVDg4eFlGancy?=
 =?utf-8?B?KzNoa2x0cENoaHFuaDZwWnliaW04UWVVdmVubmdFd0FjbmpnOFdHYjg0dEo4?=
 =?utf-8?B?WnkyekYvZ0cvbFQ1N3U2bHNwTytWU2RJWWRBbzJyUEhCcEtsRllVdjBlTjNC?=
 =?utf-8?B?eTFiMVNIQnhwSkVZTkZhaXdFRG5JM2tmTGJrN2FodUhwL0ZSRjdhWkdtemlS?=
 =?utf-8?B?Q3YwTkZxWjZvM0g4a2pWWW9qWm5OSGtkNWd2QTdaSVlDbkRsaHlrWWFFWkIx?=
 =?utf-8?B?NDVTSm1WZzQzUDJ4V0c3dDRmdk1sMU9CNHlqUnVrcWgvei9hOU1sOTBUdi9F?=
 =?utf-8?B?L0pqNDZIeWFZRnBZUDZRM0NXbW4xUWNpOXhqZEVZSlpqcSt6Y2VDZXZGY3RE?=
 =?utf-8?B?QUphc1g3bklMVVByVm1XSC9ETDJuZ1h6aU9nWjN3N2pXK3N3cXJUS3JNY0Q3?=
 =?utf-8?B?MW1BRHF2aGE2K3ozNUVqWExKSzZFYStvYWthN2ZEa2N6MXZ2VkYzeXRyZys4?=
 =?utf-8?B?QzhwS0d6N1huQXpjVkJDZEV6bjZ3MjU4ZFExOFA4TmpnQmg3UExoTG1KM1Jk?=
 =?utf-8?B?OTBjOFJpS2pmVzlBV3BpKzZYUDYxT3dzR2tMczR1VHVNTk5JSENjQURqcjdp?=
 =?utf-8?B?Y2NMVHdXeURFaXJNbDQrTTY1YU9sNlY5RFNLWittWWVuUXplbUVKbXc3ZFI4?=
 =?utf-8?B?VEdCY3NFdHdPeG8vL2s1a2V0eGkybTAwYjQ0cCszeVlZbHJ6RnBuU2V0OURT?=
 =?utf-8?B?WTlxeDF0NEJ3UXVIZ09FMitoanI4Qk5iU3Znb01ES3pONTkyU0pPK1NOaStG?=
 =?utf-8?B?UytFUEM1bU9ueldIWC94bjBveWMvbkE4Q3gveVFMMitMUlN5Y1FaVmxNOUIv?=
 =?utf-8?B?cVhYaWU4Z2tQcE1kbVN2UW5CRnhLbGtZQjZVREcraVpGTFZLZXhoai8rTnk1?=
 =?utf-8?B?aFVQc3VBR1E4Y2R2WTlaeUhGMTBYYUYvQ0VhTzdGSFB0Nmg3aCtpUG5IeVFv?=
 =?utf-8?B?ak1aWGRJWHphd0xHV3hXcHZQaUxFNEM0RkpYRU4yallQeXJaclVhejlXYTU4?=
 =?utf-8?B?SlJodjRDdGNva3A4bmJPVCs5b0NqVE5BYkhRSFQyZHJOczhCTFBkTzBpTjl1?=
 =?utf-8?B?bm43dW5IU09JdDFjOWt3eTdjVzhFb0I4UWxLNEFYZDJldnZYVHRTWjczeXlN?=
 =?utf-8?B?Q3Nyb0JUV3V3Rit2VWtTWlJvSHpmeWYycnQzOHBROUtCQVh2K0pFUGh6L2wx?=
 =?utf-8?B?WTRjYXN4Qk8xbG5iNm5TY0JscWlIQVh2RWVwbnNDZUFHRjVOcVhWM1hiWlow?=
 =?utf-8?B?b2R5N1c3WGZHZGlzSktNaTc3REx6cklVUld0cXRHOUR0NEdKSHExNU5xcHRt?=
 =?utf-8?B?TlJaYTlYTFBMVk1PcXJ4amdBWEI2NkxyZ2NINFBVMzlFQmp0Z3Mva3hqd3dn?=
 =?utf-8?B?dytSWW9ueksza1RnYSs2MldxT004ZW4rV29hcnFVQkNXQ3VpVk5xTjdYLzI0?=
 =?utf-8?B?T2daa1E4dHJvejNLTFRHQW1qaG9qTWoweW1NTGY4WDRJcER0Y09sOE9HM0Ew?=
 =?utf-8?B?VzcyalpOSUlHYTY1T0VzbG1Ia0tqRXFHWU9mVld2QzJPelNjRFFTMzFONWtY?=
 =?utf-8?B?ck1QdnVIRWxGenhhODNqdE11b0dBcWhLekM1blhzVU9vVmJ4RlJoTXFWT201?=
 =?utf-8?B?bVF6cWZPb1ovaWhobitKQm11bVh0dGc3RXYwN094NDI1b3dVMzd3R01ZbUk5?=
 =?utf-8?B?TklHZVh6Y0g0Zmo4UndNSU1SUThWeVdiWXhER2NWVDBiUGlMM202bFVRQ1Yz?=
 =?utf-8?B?ZVZTTSs1Ni9qN0xlRjh0TThuNzlDOCtKVytoMkt0blBIcFVXWVdSV25PY1J5?=
 =?utf-8?B?VVR3QmpHUEVQY1BCTG1nT1BQRll4S1JpaG5nYjVjNlNIckp4aGdhbTdKT210?=
 =?utf-8?B?WFJDREgzdWZadk1NMEJmaVJvdlRIZy8xek04UlJMdllHQ2EzZDBxZndGN2My?=
 =?utf-8?Q?P+ROdiLO7QzTcPkJvsykgmMf8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AE305EEF42B7645AED676441F0E1032@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4442.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1505b22f-0e5e-45ce-d167-08dd8bbcd57a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 10:08:50.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zvsl1A5bySoynGs63dJFvFtw5RKhk/ETvUvXte68npnxEWi0QmgRS0j9veJFxVAaodogfUTanwYl2G3RAhquJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8011
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTAyIGF0IDE2OjA4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMN
Cj4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KPiBA
QCAtMzMsNiArMzMsOSBAQCBzdGF0aWMgaW50IGdldF90ZHhfc3lzX2luZm9fdGRtcihzdHJ1Y3Qg
dGR4X3N5c19pbmZvX3RkbXIgKnN5c2luZm9fdGRtcikNCj4gwqAJCXN5c2luZm9fdGRtci0+cGFt
dF8ybV9lbnRyeV9zaXplID0gdmFsOw0KPiDCoAlpZiAoIXJldCAmJiAhKHJldCA9IHJlYWRfc3lz
X21ldGFkYXRhX2ZpZWxkKDB4OTEwMDAwMDEwMDAwMDAxMiwgJnZhbCkpKQ0KPiDCoAkJc3lzaW5m
b190ZG1yLT5wYW10XzFnX2VudHJ5X3NpemUgPSB2YWw7DQo+ICsJaWYgKCFyZXQgJiYgdGR4X3N1
cHBvcnRzX2R5bmFtaWNfcGFtdCgmdGR4X3N5c2luZm8pICYmDQo+ICsJwqDCoMKgICEocmV0ID0g
cmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDEzLCAmdmFsKSkpDQo+ICsJ
CXN5c2luZm9fdGRtci0+cGFtdF9wYWdlX2JpdG1hcF9lbnRyeV9iaXRzID0gdmFsOw0KPiDCoA0K
DQpDdXJyZW50bHkgdGhlIGdsb2JhbCBtZXRhZGF0YSByZWFkaW5nIGNvZGUgaXMgYXV0by1nZW5l
cmF0ZWQgYnkgc2NyaXB0LCB3aGljaCBpcw0Kbm90IGluIHVwc3RyZWFtIHlldC4gIEl0IGRvZXNu
J3Qgc3VwcG9ydCBnZW5lcmF0aW5nIGNvZGUgdG8gc3VwcG9ydCByZWFkaW5nIHNvbWUNCmZpZWxk
ICJlbnVtZXJhdGVkIGJ5IiBzb21lIFREWCBmZWF0dXJlIGVpdGhlci4NCg0KSSdsbCB0cnkgdG8g
dXBzdHJlYW0gdGhlIHNjcmlwdCBhbmQgYWRkIGFsc28gdGhlICJlbnVtZXJhdGVkIGJ5IiBzdXBw
b3J0IGluIHRoZQ0Kc2NyaXB0LiANCg==

