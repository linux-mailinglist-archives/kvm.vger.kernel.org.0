Return-Path: <kvm+bounces-21440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A321692F1C1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24D1E1F21FB5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034051A00FE;
	Thu, 11 Jul 2024 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElbsIMHU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40A42AB5;
	Thu, 11 Jul 2024 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720735895; cv=fail; b=auKHtZSfHtQdBYzfHLsJz041c+AJzX3qK7M2trXaL6+AZLZzgfQ6rUtE/E86V7KUQ/3J8nOWMLDWy4oBjPWWdL5qvCtvZ4GuLvxDXAFBomj/VpseTxQbzu8HtqMaKWHIOL7F8f7NBimXGt62jKbR3f1/88ZlcxGTvwIi+xIqQCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720735895; c=relaxed/simple;
	bh=jFjkKAq1tNoqMKr7n4/W8jj7e6htFgnFTQg8MrCZlao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d/JcxT3u67V5Fjy5hR+E0O0iOB8N90DLWJVuVNxvF9rymAOUKpUlJex852CIF/tpz3AFfbNxwRnjjvoL8nrvD2klCZBjcC4XxP+byWKEOrVjZDQ8AUtRhAUnAV41FSMUWuzsv5HySzEHcutrQMeuph39Mu9h8aaWhMeG/nLZWco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElbsIMHU; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720735893; x=1752271893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jFjkKAq1tNoqMKr7n4/W8jj7e6htFgnFTQg8MrCZlao=;
  b=ElbsIMHUnInwVjdM+1YVOnlT0qJuRuydHldEPBPnNPR2J7JewyY35MEu
   lyLEjg+aIwuczAXPQNNV3MAwujVJxnsuXNwhmgo1Bd2CoUAo+1mH0bAS/
   aUhkcElaeWqflvoPMxRgRM/kATfuOdwBkR+IdZVFvB2ZjiNlwWczZ/QN5
   yjyVtaCjdoRe9Jj3A/PGCaJQ+uzOCHQiXRa9PiEFDbzJgsa0o0sKVzJOG
   7JiVJqRDtgEryzhgD0LdD65U3Dv5iYavxzS6YJaZybST85JJPvZY/OtfK
   t+IiQrbpJnSGCfsUwZdstNEJKQKEMDsYkD/JVR8ijbmRhTCeVriWpWIZs
   w==;
X-CSE-ConnectionGUID: qG44c/enR2668cQdijvn2Q==
X-CSE-MsgGUID: Y0YbC9ttTsSi+nhH+PQy2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="43571622"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="43571622"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 15:11:32 -0700
X-CSE-ConnectionGUID: kmjxqSWPQtiXoY7rpGgvtw==
X-CSE-MsgGUID: xWmz/sGrRO2KVUqKKBZhkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="53638101"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 15:11:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 15:11:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 15:11:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 15:11:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THyAS3cwG2xkOashwF7C3qXgGDCDjZVo5OVzWt+Uw11cRIyC/iV8kaS/1HsQ5LNkI2ImjSjc94UFpoJp8/5W6wx3jP5qqrPW70m9wsnyRhvtDOK+xE/TqUpA8zmz8Ir+/K5LtTzma+LaYsNJGDzsNEkLfBOc/ITPgSueYYQr3Dh6NKr0KMQeAEpXzTzaE7tML8ynpPKhqA0mGvDfOwL8O7xvHIRgAzdnSja5GpZSAOLhdTL2CXAe18O31wWPOumPnDwHPpjyI5JDHW73K9/OCvTk8DqvsuGqv369ywSe4mUV6/1xKSD5uYVd5CzdAXYe6s/dYYUiRJGwz1RXPHK2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFjkKAq1tNoqMKr7n4/W8jj7e6htFgnFTQg8MrCZlao=;
 b=O6h4WCpnZg32fgpV6QCWUyWQGC+AGZMboZHD2GnDVZCxXyGm9shDnhYpKs48Rf/4swTM1xcHwUC8DVpneXvcAm+yt4uablFS69wy4ZHcLEzhj3tzdY3cWZxIs7VL5qWyh8lEX1zBWzhD5gA/oY95qw2ROZmWlyzLS+jEG1+PzmY5B3K1fCI3s+yXa1anrWzuI/e0fonIJUGA0ab59Hl1o5pJLulBUiE9mwphJrzQ5wZrFAi+g2ZzqFdmlpqTzx9b5ZxvQJy1mC7IyPqZw+SwtS32/y+e5Biu51yRGsXvG7Z5LxEN/n0q/5p/L7iS3F56MGjMOfe38TZofDOJVuBpdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Thu, 11 Jul
 2024 22:11:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 22:11:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
Thread-Topic: [PATCH 0/6] Introduce CET supervisor state support
Thread-Index: AQHaszmBJohBiOz+pE69mz1umIxaubHt9r2AgARM+gCAABRjAA==
Date: Thu, 11 Jul 2024 22:11:29 +0000
Message-ID: <7df3637c85517f5bc4e3583249f919c1b809f370.camel@intel.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
	 <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
	 <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
In-Reply-To: <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5242:EE_
x-ms-office365-filtering-correlation-id: 6b3f0c7c-0b59-451c-36e3-08dca1f669fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cHdwQ3drSHVJR0xTQjIzeVpJSXpvL1VtQUxoeXZrczh6MXpuVCs4bjFlRXkv?=
 =?utf-8?B?TERNbUR1ellSaUJRQTZTVmFMbTZWTnpuVTlsZ09tWkRLcENHNkJzQ1FZclE5?=
 =?utf-8?B?YS9jQWNndjZ3dklIZmoxWXk3d3hFVkdjS0pOS0RWRUpPM2FHNStWTXU4QTVh?=
 =?utf-8?B?TVg5ZzFuaGRtVUdHaFlRTjVlVkNWU2hIZGFTck5qSjEwNEtJZTQ0UDlyRGJO?=
 =?utf-8?B?SEFKM0ttT3ErbjRzelF3RnZPVVFXcHlsWlYrOGMycVdOWlBOQ1llekk4UkN1?=
 =?utf-8?B?bi9CVlJoN2F5anJOSU10TENjc2pwazdZZXNtNldiVnV5OXFVSEZFeGxLTCt0?=
 =?utf-8?B?L2ZwdE5idmtxNW5NaFM3N1duY3Z4M1hZY09xZGc3VkZjVjVQZjdDUnl2WGhX?=
 =?utf-8?B?NkJhbThJNGpvNFRtOVFrT1pBd2owS2dTZHBFNUpCWUE5akFoakNCdDErdE1F?=
 =?utf-8?B?b2pvcWloa3laQkF0RDlST2dmR1JrQUpBazBmQkxmQzZPbnhiT0pDTHhEUjZi?=
 =?utf-8?B?Q2tMaVdBODZlNG04eGlZdWk1NHNPYnBLOFE2QWsrVE03K0RsNlkvVzFtYkZS?=
 =?utf-8?B?aFRQUE16SmRGSFkzRzZkT29ETm5paFBWK1EzaVNsYUFTYWRnUExnREJEcmE3?=
 =?utf-8?B?cmxtdVZHU0xBVmxQcmR1Ty9oMjZlOFBtcExjQzF5cmRld1AwZWw1ZEg0R2tU?=
 =?utf-8?B?TVVEWFlmTUFjZFhhOWtYdityR3E4NUc5TVQzM0Uwb1gybmNPTzFQdzB0Sno3?=
 =?utf-8?B?TFdqZGNEWW1hVStDZ0hjdVZid0pSUnNUdG9lMnhxdFRpWStOZHkrNDhGUFda?=
 =?utf-8?B?aWFPR3pwQnM5RHhteXZFZnBYYjZiZ0ozYzV3Q0hxYThuSGxJMFhlbnFyT0FV?=
 =?utf-8?B?cVJuR3B4UFZSYlhCbmJ6cENPM3hEcGd5VkFpdmVkMmtRcVZMejYxVFNRcERa?=
 =?utf-8?B?Y1YzNjRlUG5sVTNYekx3Uk9xbExTblpLeEo0WXJlVStENzlMZENrVlAzMUlF?=
 =?utf-8?B?cG0xV3FGc29OYVhWVENjUGZoUW1xTkhtWWtFVDc5b1B2aDRUV0hETDBRbzRZ?=
 =?utf-8?B?TTlmUmxVZDAwbTNVQVBEY1dPaVVhRU1oWlFLQjJ6cWplQlM3c0dMTDdGQ2VQ?=
 =?utf-8?B?RzFsUFIzZkxpbFI4SlhPc01Ha0QxTkZNTUk5KzExVzNLZ0QwSmFJYnh3WGhM?=
 =?utf-8?B?dmYvbzJYek80NjlMZzZTQ3RjS3FhZnZ6MHZRTktqNnIxYnBCMjUrcDJnL2pi?=
 =?utf-8?B?M0FCdm80ZkNFbU4xOXlOTjN5ZXFONnBVNVBrL21KYzZWWEttMEM3cXZmZHNI?=
 =?utf-8?B?TFpGY01Id2RFWHdvdldEY0lzTHZETm9IUzE0NjFRdzllRllsVXFoVEg1dWdX?=
 =?utf-8?B?TXE1eUE5amV4d3hCMVZaZUhlc245M0o5S1dJVmFYb0xJemtUTkEzOW81T3lN?=
 =?utf-8?B?UnJ1Q2hSTkVTUVNYM0czVkhOdGdLRVB3RXFHWWp6bk5wU2pRRlFId1NueGUz?=
 =?utf-8?B?TDYrRW9XbVkwYU1pYnFWMEwzUWNNd3F0TThRYmtMeGR1b3lsUjZ3ZVRsL0NN?=
 =?utf-8?B?VzBZQWw0WEJqRDhZZHRyY2NKa0lVM3ZCUkVUeUdqZ0hVTjJkQ0UrbHhvdVlh?=
 =?utf-8?B?TlY3WHFKWEtsVGV0c002MVlMWVJBV25CcVFuZGlndUtBTUtEeHdmRTBxeERG?=
 =?utf-8?B?Nk1QQnNkbzNiZStkSUpPbVliczBWc3lLK25oS0pRcFF0MUw4RmZIdXoxVWpr?=
 =?utf-8?B?VjRJa2lzb3pVN2FvbGlXSytTQ0pPdUQ2Z3BleVErZjZ4REFQOTlnQ1VpSHQw?=
 =?utf-8?B?R21kVCtHV2FmSHRxM2RWamVMc0VxMzN5MmlkbEN1T05makVyMlVpTUdKVUNU?=
 =?utf-8?B?SUJKZDhOOU1VSUc4Z3oyLy96YkoweCtGdDEvZ0p1cis0L0FWRFFkWVBDd2ZR?=
 =?utf-8?Q?w2tqpDg7MSE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFVOK3VyN1R5UEkwVkp3cVRlNUtGdFdwQlo1TXRJWW50SldyUCtvamFvK3Mz?=
 =?utf-8?B?Slc0b3cxTnZLZHRDWVZuUXREazZVQnZmWmhKY2hPeWNvZWgwU212OEZ0R2E1?=
 =?utf-8?B?d0tvVitqN3pkTnNDZzI5dU9nakxFV3hLYVV2cW1FU2Z6VllkOW5lL0YxSEdr?=
 =?utf-8?B?TVlzckhVNnhGVkxFWWxreHVDYlNHcUhZVjhtbk1MVExTVWtUN05QYSt5Nk1B?=
 =?utf-8?B?TFE0NkplUUJ6MVkvV3lESWFJcGNrVDhqUjlhT3E2ekVSWG52SU1pdFVOK1Y5?=
 =?utf-8?B?NUtMSTUzak8vYVBnNWgvdzJKZURsNTZ4dVFVNDdtV3pIWDdOdlFhSHRndXFs?=
 =?utf-8?B?SXhjaERmVExJT2xzMG9VOCtYbEtCQktnTXhvRXFsVmVWSkFhakc1bHp6WVhL?=
 =?utf-8?B?QkhHRm5pRmlzQkh0aUl0VGlKTDcvenozSHMwNk5KK3U0aUZMcmZWRUw5SlVm?=
 =?utf-8?B?dU1xcTQ2UWZoTlZqdXBqZ1RXaGsrR3I3dVNGT09ucFFaT3IxTHJqeVBsR0FI?=
 =?utf-8?B?dEZLNDZ6b3lpb09MTjIvU0s3b3Vmc0NmQ2hGVnc2bVoyYmRjK0NjdEpIOEFt?=
 =?utf-8?B?K3B6NDRKZ3ozZXduU1BTNUh5ZEdmaUdPZFJlSHIzTlU2TW5raDV6d1MwOWhl?=
 =?utf-8?B?VmRXQmMyUGpnSlgrOExWdmFhWDVWTlExakFqUnpTd3NDRGdCOXVOcDQxc3g0?=
 =?utf-8?B?WWJQTUppSkgxc3AxSWxTejQ0VUFkaWxTVW51WkZJNEtndlg2SE0yb0k1elVG?=
 =?utf-8?B?L09rWmJsZmd1NTRkSjl2V2w5VTRJUVFmeUpMV0NhZDFucVRJbTc2MXNWMk04?=
 =?utf-8?B?Nm1lTlo3ZFRwWHl1N0RsOHVtQmpGdEdlaXVPOXYwdlpjZTVJQ2l4Wi84S0dV?=
 =?utf-8?B?dVpnVENzZTdNWVZOd29CMnJJWExXUFEwT2UrZStnMWl5czFjZXJrNnpCZmlz?=
 =?utf-8?B?OTBmdW0wZWZPTG5FSkgraWlkc1diUWhRblo3ejUyMURkUHVJV1lKWjNzRVdO?=
 =?utf-8?B?Z3BSdCtUNUdISW1pcVFHT2dIMkp5TngvWVVlS0Rwc0Q2SGFzYmNZWnBPOGNs?=
 =?utf-8?B?MjZzZitOM1lDMkYwNTNjVi90ZitOZDVVTGwwdzNqRExOcEU4U2ZBSlh6NTkx?=
 =?utf-8?B?cEI2Q0tobjJTUjBDWlo3YXQxZFEwaWRueWVUU1BuSUhkME1DOW1QN1BmVkNF?=
 =?utf-8?B?QmtKWUl5NjdvZmJpTitoUFRnQjRFbXloYmowYUxwQ1VlbUpacmFlTVNOY25F?=
 =?utf-8?B?R3NnU2dOVDR3dUk4cURQTFc5QTkyakZrRjZFdXhYb2lSVStzLzhMZDVxbm93?=
 =?utf-8?B?eXJzc3BrWWhKcXRJamJabEJJTllnTUxnRmpKNnMraXFpVDRFR3RVcGVPWG9M?=
 =?utf-8?B?N0JmdjNJVmhyZm8zUnBFMlZJRHV0NmU3L2dGSnlrc3pPSGJNRENvNEdzSEpO?=
 =?utf-8?B?bmJXZVlJTWcxVjM1SDF3Q3pxUUVoeDhXQjRlNjZvTDhPTE41VWVEb3lBU2w2?=
 =?utf-8?B?SytGdFA4LzNsVFJORTBoa2wxR3VhRFpIa1Mxa3YxUmJMcjRUNTY2VGlZNTdX?=
 =?utf-8?B?T1dVdU0wWUx3di9HT2hnSUsySWhEWkxJRjlVaHp2T2dGNHFFWDN4dXhCSEhG?=
 =?utf-8?B?cjcyTmhGTFFnMFRIZVJZSk14U1k0Zk16cFR2Mzd4cnNYMHpBTFpnZGdYOXZE?=
 =?utf-8?B?TUh3UmMxOTRMS2NGSHRwM2ZhNXdRb0wzVFVqenFZNXkrOXlSM2R6MVNSUk5I?=
 =?utf-8?B?bnppVGJNVVVsUDhraGM1OEdDeXJTQ20vb3U1eHNuakM4RHB3eTg1SDFPSEUx?=
 =?utf-8?B?clgrako0Ylo0V0pGb2R1THk4U2w2TkdTVUxFNVdjNVlONGxMMTY2VE9VdWNo?=
 =?utf-8?B?WFBUK0Q4ais5ZyszdGRCbzJDNGhoV2d2VHBMZkFNdUVxVXUxNlM4RytPNXFZ?=
 =?utf-8?B?dFJTTEJsblliaEVPTHpYK2w0ZnNlZHIva0pyS0tESmJZbGpDMzduMU9ZWWZF?=
 =?utf-8?B?TjVydXhXTDdxNkN0TzU3bzRlQUNOYklTRTg2Z3J1L3lYL3JTQ2lTZUEzeUhs?=
 =?utf-8?B?NTMxb2NHYnZrSWEvUEprdDhaclZ3ZFJ4d3RvdTVYZVVMNWdZUDkrY0gxQWd2?=
 =?utf-8?B?QTV2MUIxeFJKbDRONVpwK2FQQ1VTSEFjdHc2eXhyNVJjUDNsaE1IR3RXSGtZ?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC259570C7071141B67AEC96D27D2902@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3f0c7c-0b59-451c-36e3-08dca1f669fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 22:11:29.1496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4UbdkS17eEhrYeI4LBfNnbaCqf/twcFlNds2M1Xy8PTBhKnNzP6d9GRfT/AC8KcPJR+tfyfO3DPrL8givm9AEEWXOO/+6GyerbdNgcJL7X4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTExIGF0IDEzOjU4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
U28gd2UncmUgZG93biB0byBjaG9vc2luZyBiZXR3ZWVuDQo+IA0KPiDCoCogJEJZVEVTIHNwYWNl
IGluICdzdHJ1Y3QgZnB1JyAob24gaGFyZHdhcmUgc3VwcG9ydGluZyBDRVQtUykNCj4gDQo+IG9y
DQo+IA0KPiDCoCogfjEwMCBsb2MNCj4gDQo+ICRCWVRFUyBpcyAyNCwgcmlnaHQ/wqAgRGlkIEkg
Z2V0IGFueXRoaW5nIHdyb25nPw0KDQpEbyB3ZSBrbm93IHdoYXQgdGhlIGFjdHVhbCBtZW1vcnkg
dXNlIGlzPyBJdCB3b3VsZCBpbmNyZWFzZXMgdGhlIHNpemUgYXNrZWQgb2YNCm9mIHRoZSBhbGxv
Y2F0b3IgYnkgMjQgYnl0ZXMsIGJ1dCB3aGF0IGFtb3VudCBvZiBtZW1vcnkgYWN0dWFsbHkgZ2V0
cyByZXNlcnZlZD8NCg0KSXQgaXMgc29tZXRpbWVzIGEgc2xhYiBhbGxvY2F0ZWQgYnVmZmVyLCBh
bmQgc29tZXRpbWVzIGEgdm1hbGxvYywgcmlnaHQ/IEknbSBub3QNCnN1cmUgYWJvdXQgc2xhYiBz
aXplcywgYnV0IGZvciB2bWFsbG9jIGlmIHRoZSBpbmNyZWFzZSBkb2Vzbid0IGNyb3NzIGEgcGFn
ZQ0Kc2l6ZSwgaXQgd2lsbCBiZSB0aGUgc2FtZSBzaXplIGFsbG9jYXRpb24gaW4gcmVhbGl0eS4g
T3IgaWYgaXQgaXMgY2xvc2UgdG8gYQ0KcGFnZSBzaXplIGFscmVhZHksIGl0IG1pZ2h0IHVzZSBh
IHdob2xlIGV4dHJhIDQwOTYgYnl0ZXMuDQoNClNvIHdlIG1pZ2h0IGJlIGxvb2tpbmcgYXQgYSBz
aXR1YXRpb24gd2hlcmUgc29tZSB0YXNrcyBnZXQgYW4gZW50aXJlIGV4dHJhIHBhZ2UNCmFsbG9j
YXRlZCBwZXIgdGFzaywgYW5kIHNvbWUgZ2V0IG5vIGRpZmZlcmVuY2UuIEFuZCBvbmx5IHRoZSBh
dmVyYWdlIGlzIDI0IGJ5dGVzDQppbmNyZWFzZS4NCg0KSG1tLCBJIHdhcyB0cnlpbmcgdG8gcmVh
c29uIG91dCBzb21ldGhpbmcgdG8gdXNlIGZvciB0aWUgYnJlYWtpbmcuIE5vdCBzdXJlIGhvdw0K
c3VjY2Vzc2Z1bCBpdCB3YXMuIFRoZSB3b3JzdCBjYXNlIG9mIGEgd2hvbGUgcGFnZSBzaXplIHNv
dW5kcyBsaWtlIHNvbWV0aGluZw0Kc29tZW9uZSBtaWdodCBjYXJlIGFib3V0Pw0K

