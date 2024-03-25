Return-Path: <kvm+bounces-12634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D8388B556
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 00:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD1341F619EA
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBA783A0E;
	Mon, 25 Mar 2024 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LypqZeo9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2FA839EF;
	Mon, 25 Mar 2024 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711409533; cv=fail; b=M2xYT+Ctq5h3+SwkWf2Dek4Gg6QRORw85d5VZnsOlq0O6ZuCN+UZ8UrL14nFeIb8dLNwLf+FolaAcPaHmqXPcC+6YyR985glhDEahYMxzv580k8H1Loj0v9lOd1Eu4qK2fbCb0EHmcLz1kFZrWIVzhLCEYM9cnCQKpmilN1p820=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711409533; c=relaxed/simple;
	bh=1NoGSeqYn4pMgjaLNUqotxxxuCzLoZOr1CkbxVz6UX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QI4+76MZoUoLNBRrSYmGP49+dlOXV+1IDJU0vmZYcfDIHy9Jawi3y+/7equj4YjZlDAvml928WNeF3xVx1kuIxqj1gQP39p5/HJZM4LUi0h4i5VzNQ719+Bfces28lIyCPz3Egwk/Ai1R7joRCi1rl2VJnbsP0IxJTzssalUa2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LypqZeo9; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711409532; x=1742945532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1NoGSeqYn4pMgjaLNUqotxxxuCzLoZOr1CkbxVz6UX8=;
  b=LypqZeo9bRoYzs6L3cm3SlYNeLKmQ3uBs+t/IA0QPI0+2UpBAcU66b5C
   0tgUtn5E0znT0EHymfVt6F/k7yORxMhWhjNGC7q0u6fi+9DDp+sbQNS+1
   KFAD+1X4gAEYU7z9QCwHx/IKxNxBdI0lwEeg2tqLwUx6qypTu/PftYY/r
   1e5DDnf9o07CLD452hRexVbs8IV9A7SW2MLl/ZVNrY/GYK4wbcHaNJkNc
   QvRrRfiQpW6F4ck7tBDWN4fRdZuGwGOlegLLB+xez8DKnN9duS3KAC9ti
   fvHlODJpgeLyQBPzJXMoTl5e/XZhubD6E9dpGA1YRSr/AmxPfnKHU2/wE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6549721"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6549721"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:32:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="16161429"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 16:32:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 16:32:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 16:32:10 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 16:32:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m00N5Kn2PBuwypHfwc8avAavEC+HQGGfoerFGp1DcQoML0u6SWD/EowerVQNBzeSLNjExPeKbfGbc5/ykAWIsyvVsVZgPzjIejrRp95Cn27EI4kOwU+IJK3GBZge04FFlsDm5dR7lOmZPQdkV09/+LDlfCKfqyDml26IDBV8xJ/jDGL6z8q0tS/TSRf2/Z/JxKOPWTS9gpyCKZccXnVz/C9MlBaMNGBp8zYxvFPzlbDdhgJ/xEmI/ja9jpcSHNlMheDyII4CseXoQNlJG+MOKzMrgFh4NLVa5qs2RouMzsSeWHkCIS9dRK3nng6H786lPn8xuzO+T7pR30GBXUOleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NoGSeqYn4pMgjaLNUqotxxxuCzLoZOr1CkbxVz6UX8=;
 b=C0CoTjeYrLrduZslcoD/kei1TmYfQPORt+rjg0ewbz6hhq43nFVAjznhSjFvP5pIdK3EzuDOsCv01i5VFmGrCP9GvtSUtlDV4iGA8jtvjWeEN7omnFDWmbbwcqVKVtDKbBtBHLlPyhqmLblvH5XIX6ktkU6+02um4v244m7H6JUYDNLWY1aFtt1cKTZ2p/ij/JWiDG3Rx004UqUznoGqsnPcHW2iSrCJhNg5K7I9/KgrliXSahMPbrFu+mZDm3Z9lrb0CO7AlFI7RhsMxPZWcAhYgKHDAVDt3529wmQ6fbvyDsawlgN6lyWZXTeD1TtQDhAxq0PA28lHZFcseVxoFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4917.namprd11.prod.outlook.com (2603:10b6:510:32::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 23:32:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 23:32:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 11/21] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Topic: [PATCH 11/21] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Index: AQHafwymOCgz1tiB+kCJh0Y6tbvmJg==
Date: Mon, 25 Mar 2024 23:32:07 +0000
Message-ID: <c02f66b87460f0fb5eb5fdc16eb607687ce72602.camel@intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
	 <20240227232100.478238-12-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-12-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4917:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8wf3kKUvQWQ1S1eRddKwQDJpQsrs8hhkXWGR4UF2+miMZBLmO9/Of+Up4+IMUGNuTEunV7AuZkCNgm+b20CAMWKdw5qHKpUBaFiR8LW8ZLcxj6E3a3USI2i3gPr28geNQcQpV5TKwKiP9+BsuhlBwdwIG7RdKU+j64+BJeJFGakewV9R93dK/hQcVk4Qh/hGiPiZNw98RyjsOoP8sHxeSOPPDcq61n+rHrmvmOKLUEHMw1qAHrJkRXa4jePTYLznI3idVmnunaWwAoosl61wGe92tGbyuk8uaOVhTho5FTKQymP1dAmzwsG43OHMIQdlBPZz6KHmnPSpxfpmOldhh/J/PmVZvQXKDdh4cBGMweldZBNqPVZ5bhS+wSidDxK5N0uHUsvSvavJnTpzh0ttRDqYErY3FLrqpghfXKWBQ19//lwoXHLcocLIv2TdCb3+X1jMyEZ9I9Och4QEgSBvM4NoFbfvaVBiJL53q9WOwtPedfuFCuGtvc/3hRyLNrPIPEZ+BjNHdgoNHFaIOb4b1vPN7j/2eJCW4/h+/wFM4vNUjPkKl2Dgb8WvX2hCq54NAcCAcPsVbzZXCQ0xrfj3ZcniBwUzihFT2KuOCclcn0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0FuYjdHcHZIYmtxZGpPVjNKZkl6aWVadnFzUTlhTUN1RjRXTW9xaEhNNzA1?=
 =?utf-8?B?NTE2eFNabHllWEdGT3lHYlpRZHAvZVJJYkdrSUdXYjhlU1FhSkdmbmRxVHAw?=
 =?utf-8?B?c0Q5dlpnd1dCRjV5d0hHR0l1cHZZRi95a09BMHFwQk9Qem52YmxwSmF5azNu?=
 =?utf-8?B?YVhBY1Z1eEVUT1Q0SXZCcnBnQlpBYnhzRmlZc3hHdnRrSzgwcGVZQnNNeGZr?=
 =?utf-8?B?dlY5TU1SL3ZuY0t6RmNuUVB6SGdZYU5QVkM0ZHlFeUdkUWFuNjJTU3FXcklW?=
 =?utf-8?B?K05kbXRVdzNRWFJwYWtyK0V6ekFBQ0pXU25rY2hLWlhoU2VTTnV4Mzg2NHg4?=
 =?utf-8?B?MGxVZzQ3MFkxdmRvV0QvaDlBOHVOcWdlVTRCWVl5U25rRDRtcjRDcGw0VlZr?=
 =?utf-8?B?VVNFYVQ0NUJpT3J4SGMwaVp2Vkw1Y1p6bU9tWklqeDNDUTJ2MkN1UTkvZENU?=
 =?utf-8?B?eUl6R0Z5SVJYSXBHQUNBV29IREFsLzViVHVXWnZGQVIxZ05EMHFiWi91c0h4?=
 =?utf-8?B?Y01WMTY0UjMzSWU1ZDc1cG5MVEtkMlBIQVFPaFQ0WFdxcGVMVDM5WGx6c0JT?=
 =?utf-8?B?bVBMemQxbWw5cmVPWGRBZ05qRDY1T1ZQdTJjY0dTR0VHKy9WUlpwVGs3b1Ew?=
 =?utf-8?B?VW9tZUxFNjFjR24rcVA2elZzTzRXeE1RT01JVm9xNzF0NWI4TGhDTE1VWjBE?=
 =?utf-8?B?L3NBWEpxd1hMMkhUOFg5VmJlZU9xaWc1T3lkSXZIRmQreDdtQUsydVdBVE5K?=
 =?utf-8?B?Vy90NEdxbHNNUlZoQTZjaHlRQThrcGlwOTJxQjhkOE9NS3UwYWRmUWpPM2RN?=
 =?utf-8?B?WEVpSi8wczU3T3FpaTZHYTgvSWUwckdrZGoveUlwNElMaSt2QzdZWFdkOGZr?=
 =?utf-8?B?VnhIQ3FzSmw3Vm1RVUpTN1h0TnhSM2NWZU45NGxBbFZVWXoxRUVKb0dHbHZh?=
 =?utf-8?B?QXpqRzZOS3NDSTlNYzNNdGFSV2dJT1FoRUVUYW5PYlQxdEoxU21sbEtiS1pC?=
 =?utf-8?B?YWVEeGhBRldodDQyTEFXRGZSMVBZV0FoQUhpdUdNTmtCUFVZYlAraTArR1J1?=
 =?utf-8?B?RWNJWmRpQysrTEdTRTdMVGpYL2VDNUpqTEo5aVBIU1NHM24xMlhsZkRjdTdU?=
 =?utf-8?B?ajZQTG54SjhqeUlSMDdRNW8zUXRQY0VIUTgrZENxTkkxWkoxTE9hUjVXR3l5?=
 =?utf-8?B?N3dhcDhqcTVZTTl5anVUVklsNThZa2szZFk2dGRLUWpGREdtUkZnZHk2Zk9H?=
 =?utf-8?B?NWVGK3k0RkZRZndyMjZiZy8rbUoyeHgzRXV2dkRxdzlQMXVqRUNrZHN5UTlt?=
 =?utf-8?B?SW1MZUtpb29BK1hFMFhOYnk4MVI5T1A0TjEwaDBmQW5FTm1nS21IMUhqMG1o?=
 =?utf-8?B?RVo5aFhSMWtrYjVESFdldWF3U1FWb0RUb2laUVBwQWsxOEpUM2JqcWxUdElz?=
 =?utf-8?B?YXExMnlMeUZHVVUvU01nVlBHMmNnM0s2cnZ0VE1xS1VBRzdERGFtQXg5UnRH?=
 =?utf-8?B?V3Vsb0hkQXdscnUrTWQvZVU2b2ZjSElmdUY3NkdLQnpQZXA5M0F1UnhEYk9P?=
 =?utf-8?B?OXY4cEdad09aVVlTc2FId2hpOS9wOFAyaWhOemVJRk5xZnc3M2V4VmJibWFC?=
 =?utf-8?B?MFNiQWE1QkRpcFhSeFhOekV2UWw5MDV5MlQ5VzdJSnQ0c1Q5c3JvZHZqUVpU?=
 =?utf-8?B?Yk1rSkwvR3Vrb2JqdVFIcVdHTlZmcXJWd2VicUdUUG1XZ0xkNGVyNnpsSmNj?=
 =?utf-8?B?TGlZUUMzUXM0VVlkWDd4MWVNanhuYW40bEJNTHJLWHZHN2FtaHl4L0liWTRU?=
 =?utf-8?B?VjlMaWg4b1o4WWsxYmtmYXZOZkF3cldId1AyT1BJWno3SjA2OEJhWW1UaUpL?=
 =?utf-8?B?Mk5ES1BTTVBaNlh3SDF2ZDB6SFEyd0hlQU1DZE04ei9oWXd2aHFqWFZGMXFS?=
 =?utf-8?B?NndxUDNOR2o0TWNMbk9QNit4Slk3RitMT0pWSHhFMWxodCtDTGVvOUR3czZt?=
 =?utf-8?B?S3JQVzhqVVkxRjhZOXZxclVmMS9KVDlGZXo0VnBWeG1iS1RjQytCL2E5dHpF?=
 =?utf-8?B?OXVBVk1XN3NGWmlvbGZZazRsNWFpaytVNXBySVBuaVRrekRJZ05VMXZLRFhQ?=
 =?utf-8?B?K08rbDB2aXBTcktDQlBQbGJUU3ZwYms2MHMvaXdmam9WSm8zR29tbk1jSzFp?=
 =?utf-8?Q?Us3AiHg4KHUY3IOdaYdGhWg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <881203FD7AAD984C8380C1580DE66FF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111fc0e8-415e-47ce-03a0-08dc4d23c96e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 23:32:07.7954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9jl/TScYu4qGlYLrferWtIBoJgp6CV+DIIE/iBBEq7xHjskbWI1EfiDZ9aKYLO1Ex7BSPq9Yu+FGs4j6V35FS27Xuz4smjN1Nm4Q35MGveQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4917
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAyLTI3IGF0IDE4OjIwIC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
UmVmYWN0b3IgdGRwX21tdV9hbGxvY19zcCgpIGFuZCB0ZHBfbW11X2luaXRfc3AgYW5kIGVsaW1p
bmF0ZQ0KPiB0ZHBfbW11X2luaXRfY2hpbGRfc3AoKS7CoCBDdXJyZW50bHkgdGRwX21tdV9pbml0
X3NwKCkgKG9yDQo+IHRkcF9tbXVfaW5pdF9jaGlsZF9zcCgpKSBzZXRzIGt2bV9tbXVfcGFnZS5y
b2xlIGFmdGVyIHRkcF9tbXVfYWxsb2Nfc3AoKQ0KPiBhbGxvY2F0aW5nIHN0cnVjdCBrdm1fbW11
X3BhZ2UgYW5kIGl0cyBwYWdlIHRhYmxlIHBhZ2UuwqAgVGhpcyBwYXRjaCBtYWtlcw0KPiB0ZHBf
bW11X2FsbG9jX3NwKCkgaW5pdGlhbGl6ZSBrdm1fbW11X3BhZ2Uucm9sZSBpbnN0ZWFkIG9mDQo+
IHRkcF9tbXVfaW5pdF9zcCgpLg0KPiANCj4gVG8gaGFuZGxlIHByaXZhdGUgcGFnZSB0YWJsZXMs
IGFyZ3VtZW50IG9mIGlzX3ByaXZhdGUgbmVlZHMgdG8gYmUgcGFzc2VkDQo+IGRvd24uwqAgR2l2
ZW4gdGhhdCBhbHJlYWR5IHBhZ2UgbGV2ZWwgaXMgcGFzc2VkIGRvd24sIGl0IHdvdWxkIGJlIGN1
bWJlcnNvbWUNCj4gdG8gYWRkIG9uZSBtb3JlIHBhcmFtZXRlciBhYm91dCBzcC4gSW5zdGVhZCBy
ZXBsYWNlIHRoZSBsZXZlbCBhcmd1bWVudCB3aXRoDQo+IHVuaW9uIGt2bV9tbXVfcGFnZV9yb2xl
LsKgIFRodXMgdGhlIG51bWJlciBvZiBhcmd1bWVudCB3b24ndCBiZSBpbmNyZWFzZWQNCj4gYW5k
IG1vcmUgaW5mbyBhYm91dCBzcCBjYW4gYmUgcGFzc2VkIGRvd24uDQo+IA0KPiBGb3IgcHJpdmF0
ZSBzcCwgc2VjdXJlIHBhZ2UgdGFibGUgd2lsbCBiZSBhbHNvIGFsbG9jYXRlZCBpbiBhZGRpdGlv
biB0bw0KPiBzdHJ1Y3Qga3ZtX21tdV9wYWdlIGFuZCBwYWdlIHRhYmxlIChzcHQgbWVtYmVyKS7C
oCBUaGUgYWxsb2NhdGlvbiBmdW5jdGlvbnMNCj4gKHRkcF9tbXVfYWxsb2Nfc3AoKSBhbmQgX190
ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpKSBuZWVkIHRvIGtub3cgaWYgdGhlDQo+IGFsbG9j
YXRpb24gaXMgZm9yIHRoZSBjb252ZW50aW9uYWwgcGFnZSB0YWJsZSBvciBwcml2YXRlIHBhZ2Ug
dGFibGUuwqAgUGFzcw0KPiB1bmlvbiBrdm1fbW11X3JvbGUgdG8gdGhvc2UgZnVuY3Rpb25zIGFu
ZCBpbml0aWFsaXplIHJvbGUgbWVtYmVyIG9mIHN0cnVjdA0KPiBrdm1fbW11X3BhZ2UuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29t
Pg0KPiBNZXNzYWdlLUlkOiA8ZDY5YWNkZDdmMGIwYjEwNGYzMzBhNmQ0MmFjMjhmOWE5YjFiNTg1
MC4xNzA1OTY1NjM1LmdpdC5pc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQoNCldlIHdlcmUgZGlzY3Vz
c2luZyBvbiB2MTkgb2YgdGhlIFREWCBzZXJpZXMgd2hldGhlciB3ZSBjb3VsZCBkcm9wIHRoaXMg
cGF0Y2ggYW5kIGVuZCB1cCB3aXRoIHNpbXBsZXINCmNvZGUgaW4gbGF0ZXIgcGF0Y2hlczoNCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyNDAzMjEyMTI0MTIuR1IxOTk0NTIyQGxzLmFt
ci5jb3JwLmludGVsLmNvbS8NCg0KVERYIGNhbiBtYW5hZ2UgaW4gZWl0aGVyIGNhc2UsIGJ1dCBp
dCBtaWdodCBub3QgYmUgbmVlZGVkIGZvciBURFguIERvZXMgaXQgaGF2ZSBhbnkgYmVuZWZpdCBm
b3IgU05QPw0K

