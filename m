Return-Path: <kvm+bounces-41415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E292A679BD
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5938A1B36
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFC2210192;
	Tue, 18 Mar 2025 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKqdMRfO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7566720E6F6;
	Tue, 18 Mar 2025 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315526; cv=fail; b=CSKJZB1o6fc7YUj03x6D5wqGzFaTosKRF5XtYe+NeUc9SFlzeANH4pk5PTzD2VM+tUALGS5/2ZvMHLfey46G1O4ChC4z+pr/AFNlrf61D2h364542p+6J35Z7yPdvGm1IEL5HrLOdQWJXuzUk2ivKWnrizsQD1h8DmS9Gi8KYgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315526; c=relaxed/simple;
	bh=l9ojXVoU30qTLsu7z8xv+TFiJ5sj6BcZ/TY2T9ko//s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qdwNwmDNHNDC28k93p02qUlMXBZBXUiMPcFzmnrvaBNQ64SBh0wG5pxGncwEEU96+cDtc3CdS+ZJKjKBUO1hEKU/NIdg5SaSWVi91Kbd9xR1qpTf9pSIDV8TISau1wHb/PkJ/QaAFuBhobN/SHuFjdOtp7neIPlnDg6QmWYyFxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKqdMRfO; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742315525; x=1773851525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l9ojXVoU30qTLsu7z8xv+TFiJ5sj6BcZ/TY2T9ko//s=;
  b=eKqdMRfOldb7K0z1797Qefbn32bt/9KOnIeCeAr5qCBPg940O8M6mfQF
   bc4ByYmPsMC5ydqJ9I+UBCRAF94Zbbv8nO+dhUpeo1YVNVHNzCdiysGey
   dnt9M+NuGEGy2pGOYCqGIFzg0Fx1gwhhYxnGx2lVFDWDawtx12USd4uD9
   NSMI6aLAGGI7TOzY0EbihbfzeLvsXeWzegH6fzAqMIJO8ac7dT6WoOvQ5
   ACYqw4iDZNOGlPXq0Nq5ToWXJ8w2nBix2j1DeKaN0lKZhncg1BVFMwEoh
   N0QERGzt6Qsb4PMWdFZs3p8a4+Yic1v3RInxH6QjW9A5gZtv7+NqnhbRG
   A==;
X-CSE-ConnectionGUID: 8oRn3jDJTO6IUEwmz9wXAg==
X-CSE-MsgGUID: ow+ZvZX0Sh2s3hBlYnm0TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="43483851"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="43483851"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 09:32:04 -0700
X-CSE-ConnectionGUID: NF7RE/NzR56NuawyNQtGzQ==
X-CSE-MsgGUID: mNbfakA+QvKnJOCVHca5wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122798105"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2025 09:32:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Mar 2025 09:32:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Mar 2025 09:32:03 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 09:32:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoEGC4/PPBI5U/kBG/N0gOQSuxXzSum08mSynx68n5U8WoEXpnolC+mJxe0QgHhB9krJ7wygu6Ec6WGOryJzBJlTNzWxfyL4UVIpAnZPS3gkmqHkdbdaSCEOtjI/OMb4+XcUajQBbYcQ/wg/BikU9oYWOdNgh8Pk2vdC5xfUCIzUsk1JHDOUZC9sWv1CLa21pWcJIMDgbN5D+dhxTN9hU0ERgKWagdtrZyVoLjwHKUP243PTVbFM6zbpBstaBRf5KDkb/LBpEA0wy8J1S4DJQUl0hzY22+eHYQvsore5LIiic4qZ1LWwgE/mTacY/RFGG7UgL2+vrprcCw2nCZAFgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9ojXVoU30qTLsu7z8xv+TFiJ5sj6BcZ/TY2T9ko//s=;
 b=smiZw1I9yZQLVK34oKoMCOV6hqAwC3uv+9yQXNFMx8HByoIZxZO7oqZUGFWIONDgxkmmcp6mssLuDMo/7Fiid85e/TXgdfwjsQ/ACNyjwhXHSCzK6ODq4xXhJcjfMDIH0Ju/WSyulkyztG4YL5GOKUxfPnmgIuN4Jzp8Tw+ZSLgqART2rA3pFetMJCrPYviSL1yFYgWIXwrbnLsTQ7htOFci1sadR2k5YhfdZH7DNvawd1ctYkjaTwP95o8EyHI9oyhDSpdmbDYR49CagpMdKg7Td+9mhq6W6PAOS7G10z346JghBh9Iz6pUnYAzcEczNtNLfBr1Jh7GVERU6BaB9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB7109.namprd11.prod.outlook.com (2603:10b6:806:2ba::17)
 by DS0PR11MB7623.namprd11.prod.outlook.com (2603:10b6:8:142::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 16:31:29 +0000
Received: from SA1PR11MB7109.namprd11.prod.outlook.com
 ([fe80::b270:467d:3ba6:16f0]) by SA1PR11MB7109.namprd11.prod.outlook.com
 ([fe80::b270:467d:3ba6:16f0%3]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 16:31:29 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linxu.intel.com" <binbin.wu@linxu.intel.com>
Subject: Re: [PATCH v2 1/4] KVM: TDX: Fix definition of
 tdx_guest_nr_guest_keyids()
Thread-Topic: [PATCH v2 1/4] KVM: TDX: Fix definition of
 tdx_guest_nr_guest_keyids()
Thread-Index: AQHbl9AByrgNBfyzj0+bI6mwhMdi/LN5Bo+AgAAQNgA=
Date: Tue, 18 Mar 2025 16:31:29 +0000
Message-ID: <190c81a8159447ee527b7367051f932e5dfd08bb.camel@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
		 <20250318-vverma7-cleanup_x86_ops-v2-1-701e82d6b779@intel.com>
	 <5a9335bdf4fbfef9d34c448d1bd8f075e56f82bc.camel@intel.com>
In-Reply-To: <5a9335bdf4fbfef9d34c448d1bd8f075e56f82bc.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB7109:EE_|DS0PR11MB7623:EE_
x-ms-office365-filtering-correlation-id: 09262015-bcca-4224-878a-08dd663a55f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cGlUOFAzQ2hsMCtjSXFGaExXTUVNM2N2Q3RIMTlpeWxpZ2NLTzBNZU5QVzF6?=
 =?utf-8?B?ekxlYkdyUTJzOVhOcGlTbUMwRmJEMVcrVXdra1hMUFExNWozcmlHcXQwdE5o?=
 =?utf-8?B?Wm03SVhheDZRTVE2RjFYVDUvZ1RJemYyM0VzbGUyeG1QaFhaYzNEVHRIUnV0?=
 =?utf-8?B?YVl1dkhGUE1OT2hsNmtYalQ2ajRDNW9BMHh6eVQ4UDkzQUorN2MyS3ZXQjlv?=
 =?utf-8?B?WnNPZjd6d1FKODdUSG8zMVY4eGFpK05yejdzN1V0a3lMU2pOWUFzWnZab1Fw?=
 =?utf-8?B?cjVJOVpCeWI3MThBYm9NRWFVbW1EYUgzcE84bXU0S2ZXemhxbGllMHBHVnAw?=
 =?utf-8?B?SUpDT09hSmZhVEJ6SzNUSFBEVlh4dUhVbW53WXlDeXp3NGRDcjl3aDdzVGpu?=
 =?utf-8?B?ZlEwbG9yZ2lQcndJejJsSlhISUdaNnRiNFlSTEtFNXFFa0hYVm5ZZkhKbVhB?=
 =?utf-8?B?UElSZFdCb3FSeXNna0hDSFZ3ODZGWHhqTTFsMnMwVFJCNVpjSXBaWFM0Uk9h?=
 =?utf-8?B?QklCazBuQm5YQmhTUVVDZXI5Mk4yTkliSEdqUXhCZTVwVmZBaEVlaTFzZnEx?=
 =?utf-8?B?Q2pHRGQ3QXZGZGhlTnFsLy9oNDVuQ0JJdXpwdzUrajNucElMVnN1M0xUNnFI?=
 =?utf-8?B?UFA4ZTV0VS96ZEJoRldxRC9zZ2pPM3JtM1ppT1ZGcUZvakg5RHc2aXN3M2Zy?=
 =?utf-8?B?aXFrbVBTU0NGZldCaFBqSlhaNjNjVWw4bCtXSm12czVmelMvMFhyNW9icjcw?=
 =?utf-8?B?RWpKMTFtODc2Vk9LMkF4WDJuN0V1TElrSnV0RGVDRXpJeWdZR25xWEpqUzhh?=
 =?utf-8?B?QytzY3Z1U1ZhdjBrVXNLaUJqY2dMR2NZd1p0Vmxvbll6L1FMY1hVSjFKSWVH?=
 =?utf-8?B?TWdwZ050aStWSGJQdzJ6eXhPL2IzaEY1a1JEWU41WHRzbmRBcmoyeXArcWVw?=
 =?utf-8?B?WTlSZWMySTNTWVNLTW5qMkl5SndvbkNNaTNYUTZTdEpYQktBTjVVV2x4a2FR?=
 =?utf-8?B?ZlNweWdUSUlvL0VDSUJBcGVZSlNvYjhYd1QvUXdEZ2xDSFNOWXAvOGd6ak42?=
 =?utf-8?B?ZEtRVjhZMFB1a080QUVoUnNEd0pBelN3blYxYjl2cmdWWDRpQzZDOHhVNXpI?=
 =?utf-8?B?dzVWdDFvQ1U4MFkvZjBPdXlZV3lxTDBjdFVhellTMWg4Vy9sTnRoOTRaYnZH?=
 =?utf-8?B?STZPNURjWlFLeDEzSGdBUUFZSnZsR21jT2l6SHZrWGtSb1h6MENialc2bVhX?=
 =?utf-8?B?TmtzTEJnV01oK0JKelkrWGhNdmFKS2xzalVCM3dQZHhaTjllRE5LZjVWSEJF?=
 =?utf-8?B?UW4xVTl6dlJaY0F1TEpWczlYeEtnU3EzUWR0RzM5cWFScTcyOUhqcEs1aE5S?=
 =?utf-8?B?eWdEM2p5bkJJK0d2QVJUYm5wZVQzTHBkR3hIZlY1am1vQ202dTNQZWNQVG5D?=
 =?utf-8?B?U3ZFdVdWYnZBbGkxazkzSktkT1lxR3ZmNW1GMXlwUUZkSGVUTkc2S3lPWFpB?=
 =?utf-8?B?b0lUSWdIaVRqRFFvSExLWEd2S2tWQ0l6bVZPV1dTeDhSb2V2ZEFKV1JxcStn?=
 =?utf-8?B?aExMK09LdVpYbUJLQ3pObDNuRnlBWWZZQ0VLV2NRQS85MHRYb2xuN3VtUmpt?=
 =?utf-8?B?cFFud1NCRllLL1N6Ymo4MVZrWHR1WVh5Mm5mN3NkZExPcjhMNk5MM2QzQktY?=
 =?utf-8?B?WHZQMThqSDVjNG1paHZIc0pwMzdZYkl5UWFCbjF5RHdadmdrNEF2OUI1TTVr?=
 =?utf-8?B?amZsSWYvS3hIREw3azltcFNPQUJ0UG5yTjJZY0FOMmdwakt6T3FVSHYrTWNj?=
 =?utf-8?B?VGdxV1E4OHV4dlpTNWp5cHR3d1ozdFlKSmRsdFRYUXFzM1JCZ3pMUDB0U3pZ?=
 =?utf-8?B?R3IzR25IUy9vSC8zN2JnbitFOUFDLzNpYUJVR3UwWnEwLytSemRFalVvYWJv?=
 =?utf-8?Q?to6/stDcHEbQlxKbwTxCj3wTTT5hZQh1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB7109.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXMrSkxhNzU4eHprRkJtTCtQRllWdExtZkJGYjdFYzQ5NjB1K0M0a1ZweEYv?=
 =?utf-8?B?VU96TkhKUldCdFlQODh5TEZEd0pxRTN2WEgxR29vcVkyU2l1b1BGRkxmbkRv?=
 =?utf-8?B?QWpHaXdXVXJxYWlRRG93OHQzNDg4U0FTOHJBbTJFeERKczJOMFRxRUM0Q1c5?=
 =?utf-8?B?dW9VYWNJM0NMNDdLbkNCZkpwdnIzbVdoSTROSXduZTlMRlZPZTBzcW1KUjds?=
 =?utf-8?B?OG5CUDF4b2JXVlBZbjJ3cjhTSHdIWjBlbTcxZ0t0c3ZtaHYrdHphWjNJZ1Va?=
 =?utf-8?B?Sk14T0xNT0w1WDdEdElhQllDNVRaNDdPQUJySUJTZ1B2NjJDTDFiY1Z3K1dh?=
 =?utf-8?B?RFEwQ0ZMNGtGU25ZVHNyM3NVR0x2bS9pNnVkMGc5UHJTZ0lxbGUxZ0x1ZitT?=
 =?utf-8?B?Y280dU1LUjA1OVhkeDBOTUhRcklrbGQySk91bURpL0JmSUlxNVhVNzB4ZHd2?=
 =?utf-8?B?UHZlWFpEM08rYzB4WU1EUUQzeTNIRUNWMnBzZ0dmNEpVTE1lU3B4T3lDcjVz?=
 =?utf-8?B?bTZBL3lSckhxM05BYUJLeC85ZThPTE9PRFNVUmRjaUowY2RDY24rT1I0Z0x6?=
 =?utf-8?B?UzJTNGQ4MXdiSHZwZUhhbUJZNW4zRmpJQ2U1bDFiVG9kR2ZWWm1sK2JxcmRo?=
 =?utf-8?B?Q2hWRG1aME1JQWVycXJ0cGJnZnhxczBUTHY3KzBjb1lPRUxsOGxyQVBseDFK?=
 =?utf-8?B?ZHpKVC9samtmY3FBUjQ5ZmtkVk1iSWlnTGRhZmRjUGFVSTN6bWVrMk53Vmo3?=
 =?utf-8?B?TXdtaU0wZWVOMUZoMFJPd1FNaXV5M21MNFp5TVVlekI0ZmtaR3VWM05sOUZJ?=
 =?utf-8?B?NFdYWkMwU282bGlKc2ZYRTlBK2NjNjkzUjJRWGN4MjZvQXpBM3M5ZnhKY2tk?=
 =?utf-8?B?N0ZpUVdBbUt2Y29SSm5Md29sbnFTTllVcFRvaE1BV0JOdWZabTlOb3dURWxE?=
 =?utf-8?B?M3hnUWJFY0tIRk5TN1ZwcmowVGVYSkJNelVmMkx0YVcwQ05kTXVoTXJGanBa?=
 =?utf-8?B?QmdWSklwUzRzYkROSDErL2pOcEUwdFVZRml0NGc1eGpQeUhpQnhEMnRnakNQ?=
 =?utf-8?B?bG93MkdENUNvdmRHQW5pL1FSQThLc2dJQ2R1Yng0VTJxeWRuNk10L1NKMUpB?=
 =?utf-8?B?NS84eXFVa0JjOWl5b3R4VS9iV1VCRis0UWZqTHZWc01lNmlMR0ZNd3BlYXRq?=
 =?utf-8?B?cmd1dUx3Rnp5UEFVSHdBbnd2QTZEZzE5UXlOMEVUejE3aldWSS92YXpDU0Vu?=
 =?utf-8?B?RU9CWGJWYzhvR2JjRTdXeXpWdjgvUXVIRW5nZG5Fb1U0VmR0b2hVN0J3ZXhQ?=
 =?utf-8?B?dmxOT0JDSENCT2pUbjU5d3JKTWFBK1VnZVpGSnBoalpCdHlpdnozTEF6MVZO?=
 =?utf-8?B?eWtUaDRHWlVHaTZzQXRHRDRMM3AyOVJqYmZlZHUwcVpqd3pCSG9BQ0pvclkr?=
 =?utf-8?B?UGpMa2ZVbTQyNE5LdCtEd2hZMGVWQjUyeGZ2ckNHMk1PMmpkOUhjTkRTdjYx?=
 =?utf-8?B?R20yOGg3YWEzdWNWeEZHT2ozRVI4amg5cUVPVy9KK29XTm1LT0pva2R4aHNP?=
 =?utf-8?B?RXdyM3hrQ3I1MVlCa2NIWThrMFg3OFByY3FWVUo4enI4cXc4M1VQaExrUzhR?=
 =?utf-8?B?aWdsTUVHZCtVZjFPTHB6NG1lTnpmekVJOS9NeHFHUG5ITFJyWGpJRlVkYjdt?=
 =?utf-8?B?WFVsaEh0Qjd6bUtwSFpmZmhzQkpheTUrN3N0TnpDVy9iN2xFOHhna0JDNDgr?=
 =?utf-8?B?RDdQN1RLOWlVRU14cml6MnJBOFFiNnRJZUIzMjJSNlFWWFlpV0srQ0RCY3ZN?=
 =?utf-8?B?elE3TDRrcnpzY2VNMytEWitVanpaQzZLMXVqR1U2UCtQUXhuTUxINWt5WEti?=
 =?utf-8?B?aTljNFg1M3NiUXcvYVVia2ZMK21FYjdGQ2ZTVkxhM0N5YSt2WFpjU0ovcnhE?=
 =?utf-8?B?ZXhCa3lud2JMMXdNeERERlBGZHI1eHRISjNuM3BoTWZpTVQyMmRrODJvSGpE?=
 =?utf-8?B?OHJtSm1UeDBJd1hLRTVXSmNkR0o0WDYzdHNtNW8rNjBmQVI1eVFCRnRMQ2Vi?=
 =?utf-8?B?N3F2YmpOcy9jTTlqRDR6eTcvaDF0Vzl0N3V0dmJ5TC80SG1JZUdaeTN4bjFK?=
 =?utf-8?B?L2RWNXJBMVRhMTFuelM2bkNUZjhHUGFTWHBHN3Z3QTZRMEVsWlc0SmMzUnFu?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F1CD254BEF35C4C8ECE8A31F42555E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB7109.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09262015-bcca-4224-878a-08dd663a55f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 16:31:29.2493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T94q1njhUmSjINJQlEFdADtAPqTMTeCxhuIBmhEs7D7ebtn3bemJMjZreMTeBBafUfy9nVYJVczdUFkJHsJvHXzdFpvMTDRyHe1FEezSH1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7623
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAzLTE4IGF0IDE1OjMzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVHVlLCAyMDI1LTAzLTE4IGF0IDAwOjM1IC0wNjAwLCBWaXNoYWwgVmVybWEgd3Jv
dGU6DQo+ID4gV2hlbiBDT05GSUdfSU5URUxfVERYX0hPU1Q9biwgdGhlIGFib3ZlIGRlZmluaXRp
b24gcHJvZHVjZWQgYW4NCj4gPiB1bnVzZWQtZnVuY3Rpb24gd2FybmluZyB3aXRoIGdjYy4NCj4g
PiANCj4gPiDCoCBlcnJvcjog4oCYdGR4X2dldF9ucl9ndWVzdF9rZXlpZHPigJkgZGVmaW5lZCBi
dXQgbm90IHVzZWQgWy0NCj4gPiBXZXJyb3I9dW51c2VkLWZ1bmN0aW9uXQ0KPiA+IMKgwqDCoCAx
OTggfCBzdGF0aWMgdTMyIHRkeF9nZXRfbnJfZ3Vlc3Rfa2V5aWRzKHZvaWQpIHsgcmV0dXJuIDA7
IH0NCj4gPiDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBefn5+fn5+fn5+
fn5+fn5+fn5+fn5+fg0KPiA+IA0KPiA+IE1ha2UgdGhlIGRlZmluaXRpb24gJ2lubGluZScgc28g
dGhhdCBpbiB0aGUgY29uZmlnIGRpc2FibGVkIGNhc2UsDQo+ID4gdGhlDQo+ID4gd2hvbGUgdGhp
bmcgY2FuIGJlIG9wdGltaXplZCBhd2F5Lg0KPiANCj4gVGhpcyBsb29rcyB0byBiZSBmaXhlZCBp
biB0aGUgY3VycmVudCBrdm0tY29jby1xdWV1ZS4gQ2FuIHlvdSBkb3VibGUNCj4gY2hlY2s/DQo+
IA0KPiANCkluZGVlZCBpdCBpcywgSSB3aWxsIGRyb3AgaXQgZm9yIHRoZSBuZXh0IHJldmlzaW9u
Lg0K

