Return-Path: <kvm+bounces-26177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 018BA972659
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 02:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BA9DB237AD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CBF61FE1;
	Tue, 10 Sep 2024 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfvsHue7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8871B558BA;
	Tue, 10 Sep 2024 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725929407; cv=fail; b=BJVv/j9OdjMFwC07XrJgHr6xMHuqK4WC5gK3hMTBslaEFb3x2PBNUd6mQZCSh98eP9Edk66GgrKRKFRunqml5w9Z8IGcevQGyOpvGSFqjqCTGU90gj+2kdzPAfNnO/BAavL+P0vdrHAm+zQH7r5VTHa7FzW2qWzsVR+lmUFmwhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725929407; c=relaxed/simple;
	bh=C0iQmq6oB5MoXZ6qgoBHghVUMNrSrITrm3MIT+EUkVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l40BF2eQTn9aP13ch4O2Dm/8cYyRzmxAbdox3I6QvfmjVpr5pSarCY7GgWyRcb7BWzxNJXR7K2KzS6Ra7ZYgXKjH5bSWcJGGOvfdt8Or1WvK6p4NtJXu+m9mTYjL463GKPt7xLqeviirIrYWjZ40tQaDMWRVxMBusecvRFkxcc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfvsHue7; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725929406; x=1757465406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C0iQmq6oB5MoXZ6qgoBHghVUMNrSrITrm3MIT+EUkVA=;
  b=OfvsHue7Zp8/pZb4JU0Ox1tGzfXf6HbFYT37SOk7N5vzZwCR9LErkrbR
   WiJmSoUsoAworpRUN4R6IhYLu7i3MbPTNusl+L43UYQKZ2I/e+xg1YqNl
   r7ym1hBLaOu+XUC3UM7218ok9PvvCN23KxokgxwAV4KovgW96AS1tTKeC
   wThqn3ywSCym30FfTic/aBYON4xm1q8qImYkNaykx5GReJi+pIvNDTi7/
   viIeE/zx1FDkol6NKVsUcFUMr06jUwbKVfCK7F9Ct0atl9h0OVxKOiGYj
   hIz13CfWse7+CEn2tiGtNcbBfiVVJc8OUEriOCd/XrBMTLN5Ka6uLrZTP
   w==;
X-CSE-ConnectionGUID: CW9Uif44RxmLMclqnnGJrQ==
X-CSE-MsgGUID: nD2OKkc3RYu+4MDflfGG5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24598095"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24598095"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 17:50:05 -0700
X-CSE-ConnectionGUID: RKHMmXo/SZiV6+MFICgwWg==
X-CSE-MsgGUID: 3RVqKIrDTb6zWtTvU7KA0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="70967709"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 17:50:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 17:50:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 17:50:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 17:50:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 17:50:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CF6aFrq09y5V7SDvz40eekUfOzOKyn+Yxn43hh6mSfi+0/j2adxbYXn3na3Tllyw+kZVJMb+Df8w9/fgVZ4bulQANVhnbaczhfm8u2zY93Gb01KIruEDRp1j5uSF2hJmbiMMzID+skuK8Wdpf+91Y5donXyWnsnUT53jvu0lwpg5EEiYxgajYx1kUyhYhfUvPsR65kp0Xk0Bl8X8R6clXLuSjj+7jmWVdHHk/59T6H+43cbOf/0kob/g5ueaNAqJ61BUn1hGunckKSLJufWcg1OFQwpERDFXZNhoMM23BMsxOd51AxGQGNPG+Puokd1CkVghpIf76WSdwBJp7pdVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0iQmq6oB5MoXZ6qgoBHghVUMNrSrITrm3MIT+EUkVA=;
 b=MRor24U0lKk3kXHVgSw/BeDvQXHEIKo2t688tOi+eXU35DdlJ0+RfMy4yygpNBDJUuuvNvl7Tfy2dUhsndaUATFvL3Fgjm4fIM8ck//lvlNRKucj7/IxUf0HzfZ4YK7cJDmZ58VRr5BmW3Gu+ZXOPXcFi6vBpQZKqrnUJsJaYpfWXKa9IMP/e4nI9A3jp0Qf1s52BzyagpWTiI15jZkgpTEaw4FLrqAA5kWQuILKv45IuVzlF4FyGPDfZPrVGta+Lm4yihmwXJovsTmQUD5e10D/8M+JPISlOC82DyXr4KLitWaxPVWchidVvQJXSvBeLHddpJ32ce3KBEnljM2/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 00:50:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 00:50:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yao, Yuan"
	<yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIAAA0gAgAAT6QCAABdPgIAADnEA
Date: Tue, 10 Sep 2024 00:50:01 +0000
Message-ID: <639496dd9507b09e83d728de0ee9eccccf951da4.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
	 <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
	 <Zt-LmzUSyljHGcMO@google.com>
In-Reply-To: <Zt-LmzUSyljHGcMO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7400:EE_
x-ms-office365-filtering-correlation-id: 7beeb5fd-f0d1-42bf-9e59-08dcd1328073
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TUZSVVRHZGJWM29Jd2FDVnB4ZkhmNVBtMmpSbndKdkQ3VjkwQWhPS3hPdjZ4?=
 =?utf-8?B?aGhZUlZ2Y3dYZDZhdnFYWjlTenlQVTBCbGxyTlhsNFRYMGhPczNXNHd4SUp2?=
 =?utf-8?B?Q25leHdjWmVlV1RkdDZNZjRVWUhUaWlXcDcwRmltbHNtaXpzdXpHKzdTSVhI?=
 =?utf-8?B?V2JTNjhNZVFpbXZqRXFqL2ROZG5hWk9oOXd2TXRVeHhEVTFJd0FOOXVBRDJL?=
 =?utf-8?B?SnY1aGorZE5oZE9sd3p5eEhXU0pLUVN0d1RKZkhzNWwwMlNjNXk0dzl0VXAw?=
 =?utf-8?B?Q0REcG5DSmtYbVFEZWdzVTE5c3g4YWRWeWJzZ3cwMFJTa2RXZUhPVkxCSjBu?=
 =?utf-8?B?ZzFpc0Z2Nlh1Y2xzRWhYeG1Rd004ZnJLMkpGZnVtSjcxK1JDZ1YrQXZRWGJm?=
 =?utf-8?B?L2NzcWhGdmg5S2grdHcyY3dZa1pCR3M0VjdEang1MDJEa2IxeEh2cFE4MTE3?=
 =?utf-8?B?TWZ0U0JYU29HeEZBcTZpeUhFcGhNUjYxTkdXa0RCYWJ2M0l4bm1TajdGYVpa?=
 =?utf-8?B?cE9mc2dzazN5UGJkQUdMSXN2QUlIelY3MjlJSy9zZ0U0dGtHRytiWVhTQlhq?=
 =?utf-8?B?elM5YnFzWm0vQ3dxQW1vY0YxS0xiaHF1L0dYNXlXbzgva292MlRGbS9MYzln?=
 =?utf-8?B?czdHczh3UWVQdU9YaEN5czNXYXBQeVpoSllNN2ptRHBsTEZaTjZUa3lKOVND?=
 =?utf-8?B?MnorNU01eGVxQlRXVm5SZldrWnQvREl6VGJJNUpBdVdoaUJLZmxuVUZqaVhC?=
 =?utf-8?B?MDhHbnBVNjRYcXhiOStoa3RYaTRLWmVPT1lkdW1zZ1J3WlE4NXZWUzZZYXRx?=
 =?utf-8?B?Z1hYQjFlT2tBSWNDcnRORk1GRXV3VEREVUg3clQyZEtQdm9sY1N6WS9lYU1D?=
 =?utf-8?B?WkZGMG5aOXZ6NmpzYmd4N1hpRjBHSTVmNmpBbDFOTy8wT2JSVEwwNlhJQ2Ir?=
 =?utf-8?B?ZFhFVmVvTVFqT0xqVEszK0dKWS9EVHVHTEFpOXVlTTNjWENGS2hvWVBZNUEy?=
 =?utf-8?B?VXNuajVKUUowM0pLRGRqWDdMeGthNTNxR09CS1NCU0JKTkZGQW5TOGdudm81?=
 =?utf-8?B?U1NXT09TQ3dmZWQya084djlmeVoyUWhwOWFzYVpUS1p2N0FxK0NqRUkyR255?=
 =?utf-8?B?L0FCM0JUcWVOZjQxYnY2UmpvZ29rQjI3MHg0VWdmVDZrKzhUQmU3ZGRtNkRy?=
 =?utf-8?B?RmkyQ0xtZVFVc1FmVUVkMDFXeHRLdS9wWXpyaTFCMU0rdUhlNU1NRlB2YU9M?=
 =?utf-8?B?T1l3bCtVWnZXMlVvanI0dlQwVCttM3ZWZ3JqTlRXN2RMTFBlSklhN3ZIcWgv?=
 =?utf-8?B?LzUxbncyZjhTSjhNVHlmbmY2eGltWDNQS2ZkWFVPdGdzV0xoKzBjT2R5dFh1?=
 =?utf-8?B?bmd0ZGRreDB4RnIvdklDVGkxRWIwcnBnczdFQk1NVVhLOVR5eWg5TnhVbW53?=
 =?utf-8?B?MnY0YWRjTVJaK2tIK25LVjU0T05FOEN3ZTdVdEgvaDRFZ0ZHWEJTVEN5RGhl?=
 =?utf-8?B?OGl5M0ZjN2QwWHBHNVlEMld1dE9wOUZNVzhtb0RrSFpIUEJNbkl1elMvWVp1?=
 =?utf-8?B?UEhHb2RQK2k2ZElqaVB3VG9sQzZSMVBwMVViY3QvaVFGc0Frcml1M1pFdDZ6?=
 =?utf-8?B?SmtHMzdFVGhDaStyN0xGZ1JQeWdZVms5TUdQRitxMXJxQlJhOWRxeVBpaW9v?=
 =?utf-8?B?NlYrZ3VUODE3WlZEY29kN3k5aHFDNkVDZ0Nudm1jRzdOTlNiVmxQSkNwMWZU?=
 =?utf-8?B?S0VTWnFlcWNyYjNoYXRPZFFXQmVwRDRra0lWSm51TnBLN0tVR0cxYkQ4Rnky?=
 =?utf-8?B?amJIcGp0VWpXK0RCK3BhektpZWswQUl3OCt4bXYwMDBBWnY5cmpSWk0reHJq?=
 =?utf-8?B?RU9sT3MxM1JYMk52azEzbTBkS0NtSFpMMmNFNk8veUpPUXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnZ4c3BwRzhOdTNsT1g3WmhpUUQvb2M1NHBoRkpGUzlVZllqcjFhMjBUTWE3?=
 =?utf-8?B?bnpTRlA2WmhWb3ZxMTJnUDdqZis3MTc5SmtNUmtMZDhHbWFOYU4xb2N6ajVL?=
 =?utf-8?B?dTdGNUNxdTd2VkdxREdnbXdZU012akFMVDhqOGhWNlRndDVmQmVJUmJxdXBE?=
 =?utf-8?B?ZjE3cDV1OGd1bUdXMHQwdVVEOWpvY0phWVkwVGZpRkd5d08vMWdVTkdQZzJj?=
 =?utf-8?B?VXBQQlMyZlV6djkwWVBmdXp2aEllSXVDTTVoZldVc0gvRGFMSURaZWJOcThz?=
 =?utf-8?B?V2xZMGgxdm9NeDljVklYNFh2YmE1c1MzUkZnc2tnb1NSRnlSVXdTdHN5ZmRr?=
 =?utf-8?B?WXFjM2ZXMUhuUmw2dVVLVnpDRFRDU1lwSm9xT0RpQ1RJeGhMb2NIT2JXYlFW?=
 =?utf-8?B?SEpyWC9KMGEvZzhSRTlqZythMm5MalB2dVRBMlB6SUpUQTR5ZVgyRmpQcDF5?=
 =?utf-8?B?dHJ4TVVzNEVrWUVtWlplcHo0azQwTDZKUGJBbzlFUFdlcmRlNTE0Uk9FbVVx?=
 =?utf-8?B?YnJYZmFzcU9GK1pycTdackc3a21zcUNTMkEzZXp1WVVHZDdFN3kxNjEyVk9h?=
 =?utf-8?B?UnNIbHAyNENZamhxT1pFN1o1elhKa2x4NGRIeUpHSXdKaXFEMDBGdlhmVm05?=
 =?utf-8?B?UnZ6a0FsR0xwajVJc3RuNklvak1IS3pCN0UwOEcva2xqb29tYXp4L2VRUFNr?=
 =?utf-8?B?VzUyNm9pSm52R2ZWZUp6VklnOGI2U1FlcThNZzVsZXI1c1lpT2J5SVZrOWs4?=
 =?utf-8?B?bk5NMFdjSUZGbk1OVWVYbUh1SDl6YkJoUklxZGtQWm5OZVNJaDU2UTNDcHk2?=
 =?utf-8?B?bXFtTkpXNVhUbGhtVzR6TC9waEsvbTR4d0dlT0kvQ21FTFNCN2RPdWd0Qlow?=
 =?utf-8?B?bU9TNW9wU01vWmRtYXZwVm1POEQ1S2tXczRBZ2hhbVBzMEw5clU1T2RSUVgr?=
 =?utf-8?B?S0QyTDdrNGw5ZElYTlloeHNMMU9Gbk84YTE0bkdRMzNjdGpNRU42SDZaSXZL?=
 =?utf-8?B?d0ZPNXFYaHZKcmxkZEVuRCtJc1JSWXBMWHovVTZtY0JJVFQ1dWVUQjVVWjFr?=
 =?utf-8?B?cnJYMVY1cWJBc3ZWNFJxVEdENWRDQ0dhbzFXWUFrdzloQVdxazAxSXpVVUdK?=
 =?utf-8?B?NE1IdUY0M3dTUXBuR1dETVpzb0UzSmR0d05vb3dDcVlablBtUHpiamFkVWY1?=
 =?utf-8?B?VDg0MGJUR1FiR1B3RlFzV1NPTXEzVmZVeVliZWR2QlRmWDdpcjNzRGhyWTVW?=
 =?utf-8?B?M0phVEQ0eUVLVGpoemZOWTlGOUZoQjhFeWpnb3EzV2t0L3NjaHpsdjFYQldS?=
 =?utf-8?B?a3RWeFJMQ2dJMFNEK0tqbXpDWmw5eWVQMVRQRXZGYzVETVo1RS9uYUhBVkJa?=
 =?utf-8?B?N3N0ZTE3VlF4QnF4dkpMZ0cycnI1cHh6UEw5M3hNcCt5bGp4c3ZtQ0ZsN2Yw?=
 =?utf-8?B?SGkwRUFoT3N5M1M4Z3B0Smc1aWxLQk93NDJ4bXNVS3cyOVF3K2FCYWZlblhD?=
 =?utf-8?B?YkpCYk5yTGhlQTRQN3ZMZEpEOFhQWVhUUGkxdlZxd3VIbjkvNU02YW55VGRI?=
 =?utf-8?B?bW1CWkdYMHgvZ2Q1N1RnRlFUVkpDN3AvQytheGQ2ckdmQVFIV092dUROMmcx?=
 =?utf-8?B?dlBucE1hbFV0MmpXM3Z4aFE5Qk8zREZCTS80YWNhUXB3MmJCaEp6T2tzcE9G?=
 =?utf-8?B?bE9adTF6Y2ttQVBKSFRaV1F5UTBkYTY5YlZab2pjOC9lT0FSMnVNZ1NtbTk5?=
 =?utf-8?B?dnl1a2N4UTJnNHViMWM4S0RJM2ppTHZkMFo5aWVUMHd0RFlzVmtDN3pXTTE3?=
 =?utf-8?B?SC9iN0dVa09ubmlCREhZNlhSMyswZTQvejJrTktUdmhETldVaTVmOGRnUVJQ?=
 =?utf-8?B?WUc0OVFLNXJHN0swZXRUclA0ajlWUG9CM0FwUlZIM0FNa2tJaHdZMmlyM2pD?=
 =?utf-8?B?azB5bk95RzEwd2hzeDBZRGhVZ3dqT0hhVXM2NFpwbzJKZXJMOFY0blZMV0NT?=
 =?utf-8?B?TWtLbFNCcHc3MVdMekE3SllDTXRoQlVpY2tpRk8xUi9yaW9WTlUxNHVWR1Bn?=
 =?utf-8?B?WXJPRDQxeUVvSFBiQ0kzeU50SkdWUy9POW8raGdYMnF6S3RXR3BPZ1dEbWZI?=
 =?utf-8?B?SnVtWk5zeFc0TmVPSjBQci9lU2ZmQlVNTUQwSGtmSXR6WVJyU1EwbUIzVVht?=
 =?utf-8?B?OEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B95141D637048941B7A6873B14E7B75F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beeb5fd-f0d1-42bf-9e59-08dcd1328073
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 00:50:01.3123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1+ZXxfTIIqfreghRbYCfuV7dYWJFdxvFvQMxHRsHcAuE05iGBBLg3z8O5+ObrApFBHx1Zmes3oLZUDbToHbU/ccreo5MFmJSv8LSepG65g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE2OjU4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIFNlcCAwOSwgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBNb24sIDIwMjQtMDktMDkgYXQgMTQ6MjMgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IEluIGdlbmVyYWwsIEkgYW0gX3ZlcnlfIG9wcG9zZWQgdG8gYmxpbmRs
eSByZXRyeWluZyBhbiBTRVBUIFNFQU1DQUxMLA0KPiA+ID4gPiBldmVyLsKgIEZvciBpdHMgb3Bl
cmF0aW9ucywgSSdtIHByZXR0eSBzdXJlIHRoZSBvbmx5IHNhbmUgYXBwcm9hY2ggaXMgZm9yDQo+
ID4gPiA+IEtWTSB0byBlbnN1cmUgdGhlcmUgd2lsbCBiZSBubyBjb250ZW50aW9uLsKgIEFuZCBp
ZiB0aGUgVERYIG1vZHVsZSdzDQo+ID4gPiA+IHNpbmdsZS1zdGVwIHByb3RlY3Rpb24gc3B1cmlv
dXNseSBraWNrcyBpbiwgS1ZNIGV4aXRzIHRvIHVzZXJzcGFjZS7CoCBJZg0KPiA+ID4gPiB0aGUg
VERYIG1vZHVsZSBjYW4ndC9kb2Vzbid0L3dvbid0IGNvbW11bmljYXRlIHRoYXQgaXQncyBtaXRp
Z2F0aW5nDQo+ID4gPiA+IHNpbmdsZS1zdGVwLCBlLmcuIHNvIHRoYXQgS1ZNIGNhbiBmb3J3YXJk
IHRoZSBpbmZvcm1hdGlvbiB0byB1c2Vyc3BhY2UsDQo+ID4gPiA+IHRoZW4gdGhhdCdzIGEgVERY
IG1vZHVsZSBwcm9ibGVtIHRvIHNvbHZlLg0KPiA+ID4gPiANCj4gPiA+ID4gPiBQZXIgdGhlIGRv
Y3MsIGluIGdlbmVyYWwgdGhlIFZNTSBpcyBzdXBwb3NlZCB0byByZXRyeSBTRUFNQ0FMTHMgdGhh
dA0KPiA+ID4gPiA+IHJldHVybiBURFhfT1BFUkFORF9CVVNZLg0KPiA+ID4gPiANCj4gPiA+ID4g
SU1PLCB0aGF0J3MgdGVycmlibGUgYWR2aWNlLsKgIFNHWCBoYXMgc2ltaWxhciBiZWhhdmlvciwg
d2hlcmUgdGhlIHh1Y29kZQ0KPiA+ID4gPiAibW9kdWxlIiBzaWduYWxzICNHUCBpZiB0aGVyZSdz
IGEgY29uZmxpY3QuwqAgI0dQIGlzIG9idmlvdXNseSBmYXIsIGZhcg0KPiA+ID4gPiB3b3JzZSBh
cyBpdCBsYWNrcyB0aGUgcHJlY2lzaW9uIHRoYXQgd291bGQgaGVscCBzb2Z0d2FyZSB1bmRlcnN0
YW5kDQo+ID4gPiA+IGV4YWN0bHkgd2hhdCB3ZW50IHdyb25nLCBidXQgSSB0aGluayBvbmUgb2Yg
dGhlIGJldHRlciBkZWNpc2lvbnMgd2UgbWFkZQ0KPiA+ID4gPiB3aXRoIHRoZSBTR1ggZHJpdmVy
IHdhcyB0byBoYXZlIGEgInplcm8gdG9sZXJhbmNlIiBwb2xpY3kgd2hlcmUgdGhlDQo+ID4gPiA+
IGRyaXZlciB3b3VsZCBfbmV2ZXJfIHJldHJ5IGR1ZSB0byBhIHBvdGVudGlhbCByZXNvdXJjZSBj
b25mbGljdCwgaS5lLg0KPiA+ID4gPiB0aGF0IGFueSBjb25mbGljdCBpbiB0aGUgbW9kdWxlIHdv
dWxkIGJlIHRyZWF0ZWQgYXMgYSBrZXJuZWwgYnVnLg0KPiA+IA0KPiA+IFRoYW5rcyBmb3IgdGhl
IGFuYWx5c2lzLiBUaGUgZGlyZWN0aW9uIHNlZW1zIHJlYXNvbmFibGUgdG8gbWUgZm9yIHRoaXMg
bG9jaw0KPiA+IGluDQo+ID4gcGFydGljdWxhci4gV2UgbmVlZCB0byBkbyBzb21lIGFuYWx5c2lz
IG9uIGhvdyBtdWNoIHRoZSBleGlzdGluZyBtbXVfbG9jaw0KPiA+IGNhbg0KPiA+IHByb3RlY3Rz
IHVzLiANCj4gDQo+IEkgd291bGQgb3BlcmF0ZSB1bmRlciB0aGUgYXNzdW1wdGlvbiB0aGF0IGl0
IHByb3ZpZGVzIFNFUFQgbm8gbWVhbmluZ2Z1bA0KPiBwcm90ZWN0aW9uLg0KPiBJIHRoaW5rIEkg
d291bGQgZXZlbiBnbyBzbyBmYXIgYXMgdG8gc2F5IHRoYXQgaXQgaXMgYSBfcmVxdWlyZW1lbnRf
IHRoYXQNCj4gbW11X2xvY2sNCj4gZG9lcyBOT1QgcHJvdmlkZSB0aGUgb3JkZXJpbmcgcmVxdWly
ZWQgYnkgU0VQVCwgYmVjYXVzZSBJIGRvIG5vdCB3YW50IHRvIHRha2UNCj4gb24NCj4gYW55IHJp
c2sgKGR1ZSB0byBTRVBUIGNvbnN0cmFpbnRzKSB0aGF0IHdvdWxkIGxpbWl0IEtWTSdzIGFiaWxp
dHkgdG8gZG8gdGhpbmdzDQo+IHdoaWxlIGhvbGRpbmcgbW11X2xvY2sgZm9yIHJlYWQuDQoNCk9r
LiBOb3Qgc3VyZSwgYnV0IEkgdGhpbmsgeW91IGFyZSBzYXlpbmcgbm90IHRvIGFkZCBhbnkgZXh0
cmEgYWNxdWlzaXRpb25zIG9mDQptbXVfbG9jay4NCg0KPiA+IA0KPiA+IE1heWJlIHNwcmlua2xl
IHNvbWUgYXNzZXJ0cyBmb3IgZG9jdW1lbnRhdGlvbiBwdXJwb3Nlcy4NCj4gDQo+IE5vdCBzdXJl
IEkgdW5kZXJzdGFuZCwgYXNzZXJ0IG9uIHdoYXQ/DQoNClBsZWFzZSBpZ25vcmUuIEZvciB0aGUg
YXNzZXJ0cywgSSB3YXMgaW1hZ2luaW5nIG1tdV9sb2NrIGFjcXVpc2l0aW9ucyBpbiBjb3JlDQpN
TVUgY29kZSBtaWdodCBhbHJlYWR5IHByb3RlY3QgdGhlIG5vbi16ZXJvLXN0ZXAgVERYX09QRVJB
TkRfQlVTWSBjYXNlcywgYW5kIHdlDQpjb3VsZCBzb21laG93IGV4cGxhaW4gdGhpcyBpbiBjb2Rl
LiBCdXQgaXQgc2VlbXMgbGVzcyBsaWtlbHkuDQoNCltzbmlwXQ0KPiANCj4gSSBkb24ndCBrbm93
LsKgIEl0IHdvdWxkIGRlcGVuZCBvbiB3aGF0IG9wZXJhdGlvbnMgY2FuIGhpdCBCVVNZLCBhbmQg
d2hhdCB0aGUNCj4gYWx0ZXJuYXRpdmVzIGFyZS7CoCBFLmcuIGlmIHdlIGNhbiBuYXJyb3cgZG93
biB0aGUgcmV0cnkgcGF0aHMgdG8gYSBmZXcgc2VsZWN0DQo+IGNhc2VzIHdoZXJlIGl0J3MgKGEp
IGV4cGVjdGVkLCAoYikgdW5hdm9pZGFibGUsIGFuZCAoYykgaGFzIG1pbmltYWwgcmlzayBvZg0K
PiBkZWFkbG9jaywgdGhlbiBtYXliZSB0aGF0J3MgdGhlIGxlYXN0IGF3ZnVsIG9wdGlvbi4NCj4g
DQo+IFdoYXQgSSBkb24ndCB0aGluayBLVk0gc2hvdWxkIGRvIGlzIGJsaW5kbHkgcmV0cnkgTiBu
dW1iZXIgb2YgdGltZXMsIGJlY2F1c2UNCj4gdGhlbiB0aGVyZSBhcmUgZWZmZWN0aXZlbHkgbm8g
cnVsZXMgd2hhdHNvZXZlci4NCg0KQ29tcGxldGUgYWdyZWVtZW50Lg0KDQo+IMKgIEUuZy4gaWYg
S1ZNIGlzIHRlYXJpbmcgZG93biBhDQo+IFZNIHRoZW4gS1ZNIHNob3VsZCBhc3NlcnQgb24gaW1t
ZWRpYXRlIHN1Y2Nlc3MuwqAgQW5kIGlmIEtWTSBpcyBhY3F1aXQgaW9ucyBhDQo+IGZhdWx0DQo+
IG9uIGJlaGFsZiBvZiBhIHZDUFUsIHRoZW4gS1ZNIGNhbiBhbmQgc2hvdWxkIHJlc3VtZSB0aGUg
Z3Vlc3QgYW5kIGxldCBpdA0KPiByZXRyeS4NCj4gVWdoLCBidXQgdGhhdCB3b3VsZCBsaWtlbHkg
dHJpZ2dlciB0aGUgYW5ub3lpbmcgInplcm8tc3RlcCBtaXRpZ2F0aW9uIiBjcmFwLg0KPiANCj4g
V2hhdCBkb2VzIHRoaXMgYWN0dWFsbHkgbWVhbiBpbiBwcmFjdGljZT/CoCBXaGF0J3MgdGhlIHRo
cmVzaG9sZCwgaXMgdGhlIFZNLQ0KPiBFbnRlcg0KPiBlcnJvciB1bmlxdWVseSBpZGVudGlmaWFi
bGUsIGFuZCBjYW4gS1ZNIHJlbHkgb24gSE9TVF9QUklPUklUWSB0byBiZSBzZXQgaWYNCj4gS1ZN
DQo+IHJ1bnMgYWZvdWwgb2YgdGhlIHplcm8tc3RlcCBtaXRpZ2F0aW9uPw0KPiANCj4gwqAgQWZ0
ZXIgYSBwcmUtZGV0ZXJtaW5lZCBudW1iZXIgb2Ygc3VjaCBFUFQgdmlvbGF0aW9ucyBvY2N1ciBv
biB0aGUgc2FtZQ0KPiBpbnN0cnVjdGlvbiwNCj4gwqAgdGhlIFREWCBtb2R1bGUgc3RhcnRzIHRy
YWNraW5nIHRoZSBHUEFzIHRoYXQgY2F1c2VkIFNlY3VyZSBFUFQgZmF1bHRzIGFuZA0KPiBmYWls
cw0KPiDCoCBmdXJ0aGVyIGhvc3QgVk1NIGF0dGVtcHRzIHRvIGVudGVyIHRoZSBURCBWQ1BVIHVu
bGVzcyBwcmV2aW91c2x5IGZhdWx0aW5nDQo+IHByaXZhdGUNCj4gwqAgR1BBcyBhcmUgcHJvcGVy
bHkgbWFwcGVkIGluIHRoZSBTZWN1cmUgRVBULg0KPiANCj4gSWYgSE9TVF9QUklPUklUWSBpcyBz
ZXQsIHRoZW4gb25lIGlkZWEgd291bGQgYmUgdG8gcmVzdW1lIHRoZSBndWVzdCBpZiB0aGVyZSdz
DQo+IFNFUFQgY29udGVudGlvbiBvbiBhIGZhdWx0LCBhbmQgdGhlbiBfaWZfIHRoZSB6ZXJvLXN0
ZXAgbWl0aWdhdGlvbiBpcw0KPiB0cmlnZ2VyZWQsDQo+IGtpY2sgYWxsIHZDUFVzICh2aWEgSVBJ
KSB0byBlbnN1cmUgdGhhdCB0aGUgY29udGVuZGVkIFNFUFQgZW50cnkgaXMgdW5sb2NrZWQNCj4g
YW5kDQo+IGNhbid0IGJlIHJlLWxvY2tlZCBieSB0aGUgZ3Vlc3QuwqAgVGhhdCB3b3VsZCBhbGxv
dyBLVk0gdG8gZ3VhcmFudGVlIGZvcndhcmQNCj4gcHJvZ3Jlc3Mgd2l0aG91dCBhbiBhcmJpdHJh
cnkgcmV0cnkgbG9vcCBpbiB0aGUgVERQIE1NVS4NCj4gDQo+IFNpbWlsYXJseSwgaWYgS1ZNIG5l
ZWRzIHRvIHphcCBhIFNQVEUgYW5kIGhpdHMgQlVTWSwga2ljayBhbGwgdkNQVXMgdG8gZW5zdXJl
DQo+IHRoZQ0KPiBvbmUgYW5kIG9ubHkgcmV0cnkgaXMgZ3VhcmFudGVlZCB0byBzdWNjZWVkLg0K
DQpPayBzbyBub3QgYWdhaW5zdCByZXRyeSBsb29wcywganVzdCBhZ2FpbnN0IG1hZ2ljIG51bWJl
ciByZXRyeSBsb29wcyB3aXRoIG5vDQpleHBsYW5hdGlvbiB0aGF0IGNhbiBiZSBmb3VuZC4gTWFr
ZXMgc2Vuc2UuDQoNClVudGlsIHdlIGFuc3dlciBzb21lIG9mIHRoZSBxdWVzdGlvbnMgKGkuZS4g
SE9TVF9QUklPUklUWSBleHBvc3VyZSksIGl0J3MgaGFyZA0KdG8gc2F5LiBXZSBuZWVkIHRvIGNo
ZWNrIHNvbWUgc3R1ZmYgb24gb3VyIGVuZC4NCg==

