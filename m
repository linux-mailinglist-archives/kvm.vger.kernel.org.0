Return-Path: <kvm+bounces-47002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A705ABC4F4
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B4A21B607F4
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BA32882C7;
	Mon, 19 May 2025 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLtcZIaj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB3286406;
	Mon, 19 May 2025 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747673648; cv=fail; b=ofhTMeJCu6+0oM+3EE9ExIU3wZI8lpKm0/88G9tFw/3K8zvUer9iinn4H9t0cGIFgrM7EW2PP0bPsyGMImMAuKnQ3HIs3Qig7KM87aPuj8XGGMjcRqa6zSuvq4Gc1thPPsgx6To2UmqFuoOnvyWUE8m1unQXiNeM+Oeu95N7UhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747673648; c=relaxed/simple;
	bh=gdl9SmjXpqEOxe3mqV2Yzf7VuLoSyyUlBydEhh+Igrc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RUmkimsWbFzyjsqY9uH7YLqNVZ+o7iMYRxKV36Vk1j5mqfUO7MqMg86OzkrfgO9yXcZ2KGN2sj2rm4LZ5OXnjpzPDGrvhUA5pSnHgS1/peoUcC96buDNwtyfZLRxN+1ABI7/dcgr3pJH7zKX6e5R5DWjr7f5C088ZdKrgc3WCDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLtcZIaj; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747673647; x=1779209647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gdl9SmjXpqEOxe3mqV2Yzf7VuLoSyyUlBydEhh+Igrc=;
  b=hLtcZIajrdwUBHz4MFsBUjUrcH/mhlsd9EiL76ORn9SC43LqFh/tLtQv
   Ya6fr2AOMUHWOXWWPc5HtcMrKKoO3ozLFbsC9dYVI3RlJ7EOzoCRkebVB
   2pm8Fym6+B5jvxHvdaOUFgWfoELXf4g6kV02xFQWupLXGaRGI7C9njh8/
   W1z4xDbR6F2R9ATFXW0kp1VJqSa9P25akucGi6ruHFaxo+yro74lxGf/K
   t76d1L0OywhtYzxf0KFGCh7YIgvDRwCTj3y9ttMvI7dC3+RgG+7yFPjdH
   dG3tT99IuICIGqP0Y0XxiSex6E4d6H4CPM624uP/XKE3EmD8lGLzpsrdv
   A==;
X-CSE-ConnectionGUID: lSPfeOCoRDuE8FRl/Sh2sw==
X-CSE-MsgGUID: 1cZKGB8BRV+ccnhj3o/Ofg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="53381271"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="53381271"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:54:06 -0700
X-CSE-ConnectionGUID: P5DzDc10RXGorLYzNwK8GQ==
X-CSE-MsgGUID: PbW0erECTx2m8PSVKia2wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="144677314"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:54:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 09:54:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 09:54:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 09:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzxXES6UEi0NnuPoqd+jqG8uzgmFLzHh7ACW2lAO7pnMB+yuXvff5MIrQ9dU5Q++eS79z935ZUhhbfT8bY0L/EmashHmMNUJMZtbhn1+6IJJTk8OcA79XpTHPK0S0/2AevwVnnPKYSXcWgJ7v62MD1+OoYTKZIYwl0ooIaChCZs/mc3oHyyGNrHlR06Knx9t4aa2tnMc2mEJB0bwuxjCnpHnjTxh/cA2UWhifMT26w3KhhzavA+Qcj5zHIHm1vfpvY2gzYyyFFqFjQaag+j+vLbIJp3OLrWJv4kknFK+d+eIyPsvL/oQuVor6i/JYwAXqkRrXzJfgdyVElYLFtwhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdl9SmjXpqEOxe3mqV2Yzf7VuLoSyyUlBydEhh+Igrc=;
 b=VI18Mt/rq8O/HfebWWoTFkpABwEN7dpfAq2kdulC/ktx8+lsagKTnbs6K4CvYsHhOMosuQnwluHDtS1HeuCOrM8cfrhZ4GxOkqMixp/YwNG2zQV/Cm1GDYXCwI4/L/DTqNPCsnUPfkAgzMguI2WFeoRQdRcqGrFOv6zTAFuW8eaGavSliD6/1HHflHRUFfbWYmaPHN4rhHqDhL2lGn5uzgMiQxSNMoDbSu+OGIJctBm6OVYHMYKiHfG8qEUsoL1c3WcACEmqySKTZ4C065i88E97b6hXfwUVjjzkW8bwB10ZWdX84nRI0t0US+ZKW+yXsdEwjjP6BmYC8DHw4ufXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7454.namprd11.prod.outlook.com (2603:10b6:a03:4cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Mon, 19 May
 2025 16:53:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 16:53:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAA==
Date: Mon, 19 May 2025 16:53:33 +0000
Message-ID: <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7454:EE_
x-ms-office365-filtering-correlation-id: 594e2fb7-041b-49f3-832a-08dd96f5b100
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NDFMOUZtSnFMNHBqOEhqNXE1ZzRXUGlyRWtHWVNXaTg5UFVFR0tzNjRVVEMx?=
 =?utf-8?B?MC9aOVI0ZTJzRDhqK3ZndGdCY3o4S0dYSnB1QnVzb2NlOU5tamtjVG1nZVRP?=
 =?utf-8?B?MjdZaVFPbEh3MVVTUUlaNS9LSUtPSmJyeG02czM3Tm9kN0xpaVJpOTc0cjd2?=
 =?utf-8?B?WW9ibDFUYnQrR1JXL1JGS2dUQTI3YXg0ZDBIdzhzOWRmR0ZydXNmL2VjMmZs?=
 =?utf-8?B?U24wOUtHcTVZakVzZlBOQ0x5R2ZGdEVtZnRPS2R5VncxUllNYTJ6WjdPV0Mw?=
 =?utf-8?B?NWVmM1ZQTEw5SDE5MDBWV0FPU2RIaW9oM1ZiWTlXQk85Rlo5a3pHdTFRbjdr?=
 =?utf-8?B?TXVVWS9zajJ1Y2NUQjB4bTQwWndGckRSVmZlRnVGNnk2Q2VnLzdKcXdsZ1cw?=
 =?utf-8?B?bXBMZWVVOC9CeGlkSzZ5MFQvMWg0cXg5eDJMc3NNQVNPSlUwc3hqL0Z5eW1n?=
 =?utf-8?B?MEtTYXc1NDJ5b1FOK0ZZOGkzQ2FHMWxQMDlhd3Q5ZTZUdCt6UkpoYWNMR2JJ?=
 =?utf-8?B?a3FVQXl1MUhLemVjMGFJYytJMzB3blRTUTViV1dxSEVKT1pRODlDcWpkWWl2?=
 =?utf-8?B?REVqUWRXU0RzWHlNdG1TOHo1OWNVd1AzMTZJdklSOEtiY0EwRC9vMzhKNGtP?=
 =?utf-8?B?T0UydXBTY3RsSFp3OGlCb0xFdG4yQnJ0UmdGUmtVNHd4eVhlMXM1b3VYTGNL?=
 =?utf-8?B?QXZ4NldGOURXQUlxeG45WTN3WGpXanp3R2xobWpON3hFMDZSM2NnWnd3ekZq?=
 =?utf-8?B?bEVoa1Y3R3JjUEFOTXRDb2hLSVNpSWh4YVI3c0FLVmxMcXBYaEJhWXlvWjRU?=
 =?utf-8?B?QWdtdFJkb0RCWFlsTHZvVFk3SXduYWV3V3N1T0pJcnlsUXFPK215dWMyTGVj?=
 =?utf-8?B?V2RZeENYNWFIT25VZEtjTGVUVjhydzh0TVBINFAwYjcwZlV5TXpaOS91bUNH?=
 =?utf-8?B?aGFFR0dvYm5IZzk4NW43NEFuU0NHZ2lMVk9kOFp0UGhlNFVyRS9xVlN6MHc5?=
 =?utf-8?B?dWFndmhuOTR6QkpaQk9GNWVMZWxTdGE2QW83WkJoU1lVRkFXV0U4VEtyNGpH?=
 =?utf-8?B?aENTWWR6VVhLcURuVWNoSW1tRmh5dVg3ZHloTVRKejlzRC9LWXFzZGp2VUZT?=
 =?utf-8?B?STNsNWNJYk9mcDlpNGZUVUd1eldSTWFnc2cwR0xRYU45dElLMnZ3QzVHTFhU?=
 =?utf-8?B?QS90NElCMnlTNUxFcDhsRFNockxjYnFwM2t4dC8rQldKSGplK0VOODBhamc2?=
 =?utf-8?B?ZGRva29ZaEIyQTlaMEtLK3Nxa3NNRHM1NWQxZ25mbm1COVVQUTFwU2wvVzl4?=
 =?utf-8?B?SUhOVytWbWVYU2taQlFBbzkxelpxSytielRqWHg5RkYyU2NsZ3NVQmROdjRk?=
 =?utf-8?B?OEgzTDM5aEsxekN6VlMvN2F3OGxUTlp4RFBMVVdxOENaRk52OFhkNXFqVkti?=
 =?utf-8?B?N0txY0VpUmh1eUxjcFo1M1M5YWxOa2ZZZFNxa3dOMEdZTUVCZWJvQVgxd1h6?=
 =?utf-8?B?b3l6Wk1iYXB0UXlmdGxkbHg3Q044Vzk4TWhOd2xjSXh1R1d4Tmh1aU90UFU3?=
 =?utf-8?B?ZStpUmtxL2s1SVRQQktjZ2Y3R0txeHoyekVvMmFoN1FsOEEwSHpMMHI5L3Ra?=
 =?utf-8?B?Sjlyb3NpZHBjY1NhN2NQQTl6VVMrdVVjK2Y1ZXg4a0xWYjZxU0N1d1RlMDJw?=
 =?utf-8?B?L0FKdDJOdEd0TU5TWm5jZlBOYURzaHFybXV4ellZS2lXd3VKTitkQlZzMzNa?=
 =?utf-8?B?SVVWR1ZwalZIWVlaUWR5MjlFSjQ2WmVXWFVhbm9GekJ5TWxqZSt1Ui9UVG1t?=
 =?utf-8?B?TW9mTDhISnR0R2NNM0FGYnIydUlPWm1vTkhEMjcyT2g3RXVQSGZRQUZFRWdr?=
 =?utf-8?B?Wk1RUlVpdlJZK1ZlMG4yL1pmWWxvc0pkZzBwZ3JsYU5NZ3hnUFd3VDVwbE9h?=
 =?utf-8?B?ajdEQ0ZKb1laR0loYnlKT1AvaklpbjgyclJpd3JESWI2ZmVpUldjaU1Dbm40?=
 =?utf-8?B?bjdXRWpra1p3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zi9hYWxTUURURmQvN0Nsem1tTm5rdlBQcUtHWEFiSE9XOVJCUHg1ZGgwM25a?=
 =?utf-8?B?R1dCQUZBNWVmM2YrQjhldHZRS3pIYlNDNCs2dnhGV0RPemVjdElyVkRJMFlQ?=
 =?utf-8?B?cnZsRk9kc00vYkRta3NrcnE3MDRTTllYVlNEZnpvVXN0ZUw3ZzRnV3lQTU1z?=
 =?utf-8?B?TzQrdWYyTmo2UEdKRHRaZzVsWk5vRWdwUkliRzc2QWFYbW5ma3hMQ3kyK1Nj?=
 =?utf-8?B?aDJlUzN5R3d6M0Q1UXhoOUk1b0xIT1gwaHYybGkvVVlyT1FLVE9WOXdDOHNn?=
 =?utf-8?B?N2JLeVk0eFJxVlB2UVhRK2ZKS0g0dmM5VXlEQ1FhVFpyc3d2cHpwUTdIRjFy?=
 =?utf-8?B?ZXJxWlUrcjh0UDBodE5Lc09KNjNoU1JnUDBFV3VHN1NjMlkrQW51SGJ3dmNN?=
 =?utf-8?B?YWNnc2MvUFREZVM2UXNTaE9PQWp5ZVBmQk1PdHQvZHRGSHVLRnF2UU5NT1ly?=
 =?utf-8?B?WHBtaXhwSE5nNDZ2TW8zRUJCRCtTOVB6WnBUaUhyVnF0ck9ISG5SVElwdWNY?=
 =?utf-8?B?QUdmWU1lNWVNNy9qTDBoT0xlaXlXV09JRjRPTkZ0aGFpUzd5OTZ5dWI1Zjhz?=
 =?utf-8?B?RE5yZ3dvSGVUaWl6OWZVbFRvZVIySUN2cEdHOE14d29QcTdHZ1FIRmRuSGxV?=
 =?utf-8?B?VVBoTWtYZlV1dytKUjdTWUZiRHVVQmZLTXlGeTZScXR0Qlk2K1VqNHowM3Q5?=
 =?utf-8?B?MzFyOGRjSEg1VExWREZmaGNhcDNwakNiSldFZHNCVklGVms1WVJNVytwZ3Ux?=
 =?utf-8?B?ZFQ5YnR1ZlcxN3ZqS29oQXlLQXkwL0RyalBZTUF1eFE0blVROFJUcnd0K0Vt?=
 =?utf-8?B?OWZpZTIrdHVsZUVITld4YTdwRCtCRURLWHkrYkt6SFhJMTJtWFRwaUZZTVIr?=
 =?utf-8?B?VkpxWDgzdjk3TjVHY0htL1dvd09VT29ibm9sV1Jyc09MNndNZHFNcjR1Wjdy?=
 =?utf-8?B?TGIrbmFxTGdyemswYzJUR3RHOFlncENsR3A0UU0rVm9VTU9wdUlQemY0NWk5?=
 =?utf-8?B?RlBXbTlWeTBUYUdlRWN6R0hSQ1A0N0J4blRYMHk2WVpVNG9xYUpJVkRWMnFu?=
 =?utf-8?B?cyt0cjNGWWVPQlg2WnFsdHJSVFo5Y0hpdEFXN3hNM1pPRXl3bFlaeWtJR3Z3?=
 =?utf-8?B?NUlldk9sYXo2OFNNYUZjbEcwL0xITFdUaHhHanh6NUZZb2ttZFF6WGlQM3JU?=
 =?utf-8?B?N1JNa2ZGeXlqZFFEeTZTeFRsaVJGZHFmY3A3SkhMd0s0NEZMc3k5RGowOEF1?=
 =?utf-8?B?NEoxbUxacm54TXVaN2pSMytNMWJYWHF3YjNqaW9sQUI0Nld3ZklnQUdQVitq?=
 =?utf-8?B?Z25nZUNLdzlEQVB5REZLanBmZjZjYVN3elBxeEFaYkdIUWYxOWVsTExEczhH?=
 =?utf-8?B?d3p4NDUyaERDL25QQndrZVNBOUhDblJkZVhhNlg1eEJJdDRFUjh5VFNlZW1O?=
 =?utf-8?B?SjRXWVg5clVvYm1sSlUvWlNXbU1wQy8xUm10VjAyTkl0NE05LzV0bGtvMG1k?=
 =?utf-8?B?QVA2T09sak9kMnBlV0FZQzdEZXV1MVFneTUzc0lwdjlaQzdlY084L1AvTGhF?=
 =?utf-8?B?aEtOZnhvZU5aclB5eDU3TStQdmRQSWw0TUhCdzJwektubG1ZU09BdXFKUnVo?=
 =?utf-8?B?NVZqUWJrU2FUcm50WnBqd3lXU0hJZk1ZYjQ4dldsZjB1U2FEOFphUDcwKzY1?=
 =?utf-8?B?aWhPbVlPclhnd2pEUnpXYVhnTlNJMkF5b2FDZjNacWE4b09QUTJiUDdHajUx?=
 =?utf-8?B?bWZTc0o3akJtSUl2UlZLeHlTMGpWZDBtZU9hUnl5NEUva0djLzdranJDamUy?=
 =?utf-8?B?T2QrSkkwcG93NjMvL3dXSDhhOEhObk1pUXRjUVFpNnpoYkdTV3JiendPYW9w?=
 =?utf-8?B?bUVvbEE4QWdMa0tObW5MUklHRkhPdEpRYnlld1NvdjEvak5mL3Z5U21VSDMw?=
 =?utf-8?B?WUdIWEQzYXM4WHV6b0VqM3QvOTZXMnI4YUhLUVFoMHlibWR2RWQrdlptUjhP?=
 =?utf-8?B?SXBJaEkvd3Juckp3a09hR0Z3bzhrYUdkRkx3SUxoRGJaOVBDNXVNVzRuSEla?=
 =?utf-8?B?Wm9sTGd2MEM5dWdJcFNUSXp6MnkwSUdFRFBsQStpcVV2bGppWG5vZW44RHZx?=
 =?utf-8?B?RTFnVUxGUHdMSnR1cndFZThIU0o4eHRqT2hia3VEL0xSK1pjZXROSXRMajJP?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B2E9DE14E43B141A756BB439FACDF1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594e2fb7-041b-49f3-832a-08dd96f5b100
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 16:53:33.7122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz+3LX6YnaX83NrBHpRuaTJVtTYTH5z0BdPXOQCyqICw2bJBMEqWWOFcVDzPK+38k/sElmtyQ78+MNHZPFeFdItLFoecODCsJ8ii/oHBymM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7454
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjMyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBP
biB0aGUgb3Bwb3NpdGUsIGlmIG90aGVyIG5vbi1MaW51eCBURHMgZG9uJ3QgZm9sbG93IDFHLT4y
TS0+NEsgYWNjZXB0DQo+ID4gb3JkZXIsDQo+ID4gZS5nLiwgdGhleSBhbHdheXMgYWNjZXB0IDRL
LCB0aGVyZSBjb3VsZCBiZSAqZW5kbGVzcyBFUFQgdmlvbGF0aW9uKiBpZiBJDQo+ID4gdW5kZXJz
dGFuZCB5b3VyIHdvcmRzIGNvcnJlY3RseS4NCj4gPiANCj4gPiBJc24ndCB0aGlzIHlldC1hbm90
aGVyIHJlYXNvbiB3ZSBzaG91bGQgY2hvb3NlIHRvIHJldHVybiBQR19MRVZFTF80SyBpbnN0ZWFk
DQo+ID4gb2YNCj4gPiAyTSBpZiBubyBhY2NlcHQgbGV2ZWwgaXMgcHJvdmlkZWQgaW4gdGhlIGZh
dWx0Pw0KPiBBcyBJIHNhaWQsIHJldHVybmluZyBQR19MRVZFTF80SyB3b3VsZCBkaXNhbGxvdyBo
dWdlIHBhZ2VzIGZvciBub24tTGludXggVERzLg0KPiBURCdzIGFjY2VwdCBvcGVyYXRpb25zIGF0
IHNpemUgPiA0S0Igd2lsbCBnZXQgVERBQ0NFUFRfU0laRV9NSVNNQVRDSC4NCg0KVERYX1BBR0Vf
U0laRV9NSVNNQVRDSCBpcyBhIHZhbGlkIGVycm9yIGNvZGUgdGhhdCB0aGUgZ3Vlc3Qgc2hvdWxk
IGhhbmRsZS4gVGhlDQpkb2NzIHNheSB0aGUgVk1NIG5lZWRzIHRvIGRlbW90ZSAqaWYqIHRoZSBt
YXBwaW5nIGlzIGxhcmdlIGFuZCB0aGUgYWNjZXB0IHNpemUNCmlzIHNtYWxsLiBCdXQgaWYgd2Ug
bWFwIGF0IDRrIHNpemUgZm9yIG5vbi1hY2NlcHQgRVBUIHZpb2xhdGlvbnMsIHdlIHdvbid0IGhp
dA0KdGhpcyBjYXNlLiBJIGFsc28gd29uZGVyIHdoYXQgaXMgcHJldmVudGluZyB0aGUgVERYIG1v
ZHVsZSBmcm9tIGhhbmRsaW5nIGEgMk1CDQphY2NlcHQgc2l6ZSBhdCA0ayBtYXBwaW5ncy4gSXQg
Y291bGQgYmUgY2hhbmdlZCBtYXliZS4NCg0KQnV0IEkgdGhpbmsgS2FpJ3MgcXVlc3Rpb24gd2Fz
OiB3aHkgYXJlIHdlIGNvbXBsaWNhdGluZyB0aGUgY29kZSBmb3IgdGhlIGNhc2Ugb2YNCm5vbi1M
aW51eCBURHMgdGhhdCBhbHNvIHVzZSAjVkUgZm9yIGFjY2VwdD8gSXQncyBub3QgbmVjZXNzYXJ5
IHRvIGJlIGZ1bmN0aW9uYWwsDQphbmQgdGhlcmUgYXJlbid0IGFueSBrbm93biBURHMgbGlrZSB0
aGF0IHdoaWNoIGFyZSBleHBlY3RlZCB0byB1c2UgS1ZNIHRvZGF5Lg0KKGVyciwgZXhjZXB0IHRo
ZSBNTVUgc3RyZXNzIHRlc3QpLiBTbyBpbiBhbm90aGVyIGZvcm0gdGhlIHF1ZXN0aW9uIGlzOiBz
aG91bGQgd2UNCm9wdGltaXplIEtWTSBmb3IgYSBjYXNlIHdlIGRvbid0IGV2ZW4ga25vdyBpZiBh
bnlvbmUgd2lsbCB1c2U/IFRoZSBhbnN3ZXIgc2VlbXMNCm9idmlvdXNseSBubyB0byBtZS4NCg0K
SSB0aGluayB0aGlzIGNvbm5lY3RzIHRoZSBxdWVzdGlvbiBvZiB3aGV0aGVyIHdlIGNhbiBwYXNz
IHRoZSBuZWNlc3NhcnkgaW5mbw0KaW50byBmYXVsdCB2aWEgc3ludGhldGljIGVycm9yIGNvZGUu
IENvbnNpZGVyIHRoaXMgbmV3IGRlc2lnbjoNCg0KIC0gdGR4X2dtZW1fcHJpdmF0ZV9tYXhfbWFw
cGluZ19sZXZlbCgpIHNpbXBseSByZXR1cm5zIDRrIGZvciBwcmVmZXRjaCBhbmQgcHJlLQ0KcnVu
bmFibGUsIG90aGVyd2lzZSByZXR1cm5zIDJNQg0KIC0gaWYgZmF1bHQgaGFzIGFjY2VwdCBpbmZv
IDJNQiBzaXplLCBwYXNzIDJNQiBzaXplIGludG8gZmF1bHQuIE90aGVyd2lzZSBwYXNzDQo0ayAo
aS5lLiBWTXMgdGhhdCBhcmUgcmVseWluZyBvbiAjVkUgdG8gZG8gdGhlIGFjY2VwdCB3b24ndCBn
ZXQgaHVnZSBwYWdlcw0KKnlldCopLg0KDQpXaGF0IGdvZXMgd3Jvbmc/IFNlZW1zIHNpbXBsZXIg
YW5kIG5vIG1vcmUgc3R1ZmZpbmcgZmF1bHQgaW5mbyBvbiB0aGUgdmNwdS4NCg0K

