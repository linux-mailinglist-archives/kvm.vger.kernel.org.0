Return-Path: <kvm+bounces-34175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F119F82C5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 19:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0904D1899F1F
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E789E1A76AE;
	Thu, 19 Dec 2024 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AUyOzinZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B5E194A60
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630796; cv=fail; b=eSi6dLpvzJ3N47jZth4U5b8bphHFUyld+sCz5pjk+mQDBDk8dRoQ6oWSTF1l7Ie6ZIHk/g7rw78gjUV3vNLUtxhXOOXOHs0Enz+eJM0B46plwdil8eKN/MKxa33A38L62KBP7qUC/oMO9m4qxosfwBc+fJd0WfCmGSbqgtn8uOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630796; c=relaxed/simple;
	bh=VaY19OUKL3uBZE4d2C2qnmUHK924qD92oCFY60lM0QA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QZ7L1VzFWMNDVj3+z5JBQeLkkGEPidzP9AmB4XoJgnZwj2ZTEHyL+eKpfbJ3vUbRuVIGq4HfPCsd0HfEGO6KYY1LmYIQuHuJEnHusCBseGHugzywYGP1Iot4ANb4gm1UeVx0nF6Gmk00cdhSGiNkmhFocJkishTaiduqm9NC1EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AUyOzinZ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734630794; x=1766166794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VaY19OUKL3uBZE4d2C2qnmUHK924qD92oCFY60lM0QA=;
  b=AUyOzinZ9f153g8gMUbwgwmGFLN4wNlZKdGiiim/j+hnss31by1pTAhc
   aeXZxVDJrfFbUD+/2ZfFfW+1cmQiDGH6GxCkfyruqCOt7R6VIjqWJbhX6
   LoJINUtIVsFyxsKnmgVc5FDGQYIhVwuOgC16wTldU3EIu/KwUTYErM69v
   HKbwzmfT7S7xroBmUR5k1PqKS6JY9fDcKyf0VNhDYiG6blPyY7cpixrgq
   g1Xh+Lp0eFuRSE9uUbBb8EON99gCCAlxV3CpZTTYOqCkSe8v2tj125zUq
   YbEzAKUZvNfU245AT4kjSnX7A/9SKZVLbR+bO3nTucP9ktZzDZimfyckf
   g==;
X-CSE-ConnectionGUID: RRXLDdsuTWWlf3lUFKIygg==
X-CSE-MsgGUID: peOdyVA1TVunr2RJfYI19Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="46576922"
X-IronPort-AV: E=Sophos;i="6.12,248,1728975600"; 
   d="scan'208";a="46576922"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 09:53:00 -0800
X-CSE-ConnectionGUID: iitDjAhsQIyDJVQj/mg3RQ==
X-CSE-MsgGUID: yr8ntLcIQsyj1RmqkndUUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98099425"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Dec 2024 09:53:00 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 19 Dec 2024 09:52:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 19 Dec 2024 09:52:58 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 19 Dec 2024 09:52:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrERp8t+kwlkyIi/Y/TkZMwFirZofI98ZPgHUIYwpCzGtGrlQYYiQrzKJMTDa5DNwGc8ecVzgK70v0VMe4hrOicnIh/ddAp1yiDpKbN9C01JyFsgtZMOjlDp++QAfu+byMSTXEilZQBOw8W3TQlRHj8uoN+YZcV8AvVKJrB1UtV2FBOP39ltLfYg9JWWh+Q0dTtZlS08i4+CmXnTSACthqv0MLcSZk+89wnjopd0rv9/L4mPBEgG5TwfnSurxN5ogV863M9yI4jdAzwIcBDqAjxnGIoMPslBOTrd5L+yJx6ChFVlRAkCNl4jZhm+on8TZiVlEA2TKHEFNulhx8tzGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaY19OUKL3uBZE4d2C2qnmUHK924qD92oCFY60lM0QA=;
 b=nPGRwrmcjUf6Cq3R8q0r/w1JTbrX+PxIkuG/k9fs3iyLzzOxEYDzVXAYd9QoTpWM/jk4GEwxJhHpt5il6P5SySuKHmyyj525eiPC17O+0MjAjCf3VnmZgIR8YFfYMWUbPBkMzwoOirSzy+3HeUyst3o8DjOyRahanXUyzHo0RoiiexQqqtXCEXWT0igokBDn/yKGU2tRQi6Qi8mdzirGLbpdurpL1l+poy8dGqPEJMVdUBeMWzYTwgeuW4pCbHuIxc2Yg/uaac7R7Ph3Jue54IHM+wSqm+ZSW41bpg3cfc1yeVpVYza9M23buQ0OOq0cFVjgxo03HrnJzArUpfQppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4933.namprd11.prod.outlook.com (2603:10b6:510:33::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Thu, 19 Dec
 2024 17:52:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 17:52:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Topic: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Index: AQHbR4iHazsMJxPtGkeCIJI86qO187LZjbkAgAVIvYCAAPE0gIAJ9kIAgAFI/QCAACwNAIABsF4AgAAKQoCAAQECgA==
Date: Thu, 19 Dec 2024 17:52:56 +0000
Message-ID: <a453369c6ef3a0f93376348a0c4a0bbfe1ea08e4.camel@intel.com>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
	 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
	 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
	 <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
	 <Z2DZpJz5K9W92NAE@google.com>
	 <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
	 <Z2INi480K96q2m5S@google.com>
	 <f58c24757f8fd810e5d167c8b6da41870dace6b1.camel@intel.com>
	 <Z2OEQdxgLX0GM70n@google.com>
In-Reply-To: <Z2OEQdxgLX0GM70n@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4933:EE_
x-ms-office365-filtering-correlation-id: 770782d4-f8e6-42ac-174e-08dd2055f810
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|3613699012;
x-microsoft-antispam-message-info: =?utf-8?B?SWVCLzY0NzB2ZlEzaTNTeTBsK3BqZXFUNFVrVUM3TW5oZjh4dzB1UlNEKzlE?=
 =?utf-8?B?cFVxQ3o0RUprSE0wYW50K3JHU1BkZGlvTEZFVVJJY01lRkgwVDNScnY0QW0y?=
 =?utf-8?B?QnRDbkdGb0c1czdKTDNrTnNNWFora3NrWnlIMUtidzZFSnIvQnd4d21keUdC?=
 =?utf-8?B?VjhMZytkSi9mdUkrOVJlY3NRbkp2dG9IU1ExOUJLK0o0ZFVsa0ZxUjRhTE8w?=
 =?utf-8?B?WFhpNmhBZVZzbjZjTFk2MGFJVi9DUXc3MzdJWWRKbG1tUUhRUURJTGt3d1VE?=
 =?utf-8?B?bmFHZ0lQb0lPOSt0S1ZaRFVCRmQ4Umhuc0VUV3oyc2lCcFMyU2o5VXpLOUNt?=
 =?utf-8?B?RDcrb250YVJYVE9JUlJGZFN2MC9PZkNhZlIyOGVyaVIzcnBoL0RDb2FKRWQ5?=
 =?utf-8?B?N1pxQm9OcHl1RTJvYy9TRkxNdExnSVYrbHhYdXdPRnRnbUFxakI1eE9qYkwv?=
 =?utf-8?B?MStYRGJ1TjVseXVBWjl3emJ4T0NCb2hZME1vdStRbTRmNG5iYm5NdkxTd3hS?=
 =?utf-8?B?cjNpSmF4S1NmenE2R3ZRcDFyUnlIQUpPa0IyTmNhcUttTUZmU0FXb1NyQS9j?=
 =?utf-8?B?cXBTSWg1RTlmMDRGUFBjbUVnSzFaeVRJcWIvLzJpR01sRzU3cGEzUExka0JQ?=
 =?utf-8?B?SXEyd2FJcmt2OGxHRDhGa2hhSjFzcHhTVng3eHB2bnRobDZiQmowVmExUXdw?=
 =?utf-8?B?LzVhOExJZ1Q4c2haakV2aTkzZ0VsRStJVjk1YXM1QlVSZlU5OWZVZk8wYWZ4?=
 =?utf-8?B?NFFrUXRGaFRQRWltZkR5M3hkemFObmZCS1VOak83VW5TclhKdTVpOXFkMkZw?=
 =?utf-8?B?bmc1TXRNTTBscnh3S3kweWl3Z2V3VVFYNHptM2VtSFpkSStpMm1icTB6NlVa?=
 =?utf-8?B?RncrcSt0bkVkK2xTb2FMbm5GVzhqdW16ditqblBuYmpxWlkzU2piM29hQzNP?=
 =?utf-8?B?dTFEZEJoeDdiSWxyVmxia1dGS3hvNGZMRE45dlcrbHRVUGF2N3pkOEJuNHZV?=
 =?utf-8?B?bkNPcFNFcTBaZ21mTExRYjNhSnYyVVJLQWhGYXhtcXBRVldJZmRBU1lmaGZh?=
 =?utf-8?B?TjA2TzRCK2NxNnJpT01UWGZKRmRDZll5WWdramN6RDFCMDlPKzAxakJzekNk?=
 =?utf-8?B?UUhuNlpPT0hpbEpYQ3ZuVnYrdkV6WkZianJUelRLZVZoU2V1bmEzSzNwNkxw?=
 =?utf-8?B?U01sc3RMMkhzYzAwWmJHcmN0QklEWWNhME52bW1VUnRoczBPelFTRmU0SWZu?=
 =?utf-8?B?TUdPb3JBeXF4WEVVbnk1OTVyUU5IUEdMai9LbWUweU8vU2UvWkVBMHNNa3VR?=
 =?utf-8?B?Ym5VeDkvOE9PNmFlMnhGbUYyWXZMSXdLQXhwc3NYOGNPYlphU09HR3lQR0Q4?=
 =?utf-8?B?dW1KUWFRaWxKVHhiVGVKK2pseTBYWmsrSkFDUE1NQmZEU2Fxb21wUUIyNncv?=
 =?utf-8?B?OXhYckJJbFR4R0ZjNmJGcTFiYjNHM2lwOU5idHFQZms4Y0dUUGQyWkdMK1Jz?=
 =?utf-8?B?aGtrZTdER2h4dk1XeFZFcGJXdjM1L0RLMFFqeExOL1JaVDArTmtiVXpXY3hJ?=
 =?utf-8?B?a2tIUG5LN2Z5cjJmbmNCMXM5REF5OXdtMDlmd3lVeUxHL1dVbkMxMWlwVksy?=
 =?utf-8?B?RTJiWlg3S3lKSlJ1aDkwcU8zMUo3ZW1IbFhrZ3FjeFAyK3dXcXRiL1kxbjhO?=
 =?utf-8?B?MDB6VUJGOC90ZXZlTTc0MnVBekJCbDJEWXFWRlF1MUFWcWEzRUptdEFiN0Z5?=
 =?utf-8?B?RC91ajNrZWUyandhWjBnOStQM3JHQjgwc3o1YjlzVWgwTkZId0NHQ1pCWE9k?=
 =?utf-8?B?NzgvU0FVOGNzcXFIR0g0N1JRSHdMTFU4OHoycGpNV2gydnF4UDI4ZXlkMml0?=
 =?utf-8?B?aDQzUk9wZlJpQmwzWU84SVZyaisxYmM5NnI0TDQ1NWJia2kzUStiNUU3U0s2?=
 =?utf-8?B?cmQrbUhrOVhjZ1pwUVF4dlBGMnZsOVlyNjdCQlVHaGlPV281WkdNVDNZdm1I?=
 =?utf-8?B?RjdyUUFmUzRBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(3613699012);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGdDK0ZKK2RXS1R6U1lSQVBZdkFLVXJ5SGVDOTc1aDlSSlp0ZDNqazhuelFG?=
 =?utf-8?B?eTBoM0R5eDJxNUp5WE10YXl0YUtkV0IvSjBrZjFqa2tENE91M3J6WDl2UU5r?=
 =?utf-8?B?NVZFNi91RGpjY2FIMHIwcnd2S3BDMGtUQ3lBUnJvZEgvZGRRNEJpaUJOQVRs?=
 =?utf-8?B?REY0eTVacjNFNXBoMExrNGdGejRQL1NNeld6aUhIMVp6eW93VzJyVVlZVHE1?=
 =?utf-8?B?YnpGbCtUMW1ZKzNwOHdOck5CSXFadGpjMnRrbTZKR0pCbVRCME9kaDVFdUUy?=
 =?utf-8?B?c0pJeDM3YnNiRDQrSWxnNU1rTVNuejZ1dEdCSmkvMjhBa3hoNXJEczY5M1Mx?=
 =?utf-8?B?MnJycGQvdS9obllBN3lzbWVQV1YrTVVqQ1gvKzR3N2RQOWJHMkZkbURXd0Zk?=
 =?utf-8?B?YS9nV1NIZlE2UU42UkRxV0hmNDY5YWFrOUYwK1ZTL1I3NWpOb2Vtai9lQlAz?=
 =?utf-8?B?UmdQRnNxeWYxa054eStOU0lUTGMzbHpmWWhGVmoxSUhDK3Y1N2hWWEJISmVm?=
 =?utf-8?B?UGxsSmhWVkJnVGlVZXFVKzM1QXV4dWthd0hwaVhvS0plVVN1YW9TSzFBbkU5?=
 =?utf-8?B?c2w1U1FEWE03dHpjWGVTcHk5bmJwK3ZLUHVlTmlvUmY5V2dsQmI3bThDREJa?=
 =?utf-8?B?SjNTbkZJM2ZkaGhiNEtZSmlkSFpzZUtYUzRCUUsrUCt5Y1A3TnFrVW1LM0JO?=
 =?utf-8?B?U0swdytLVFRIaUlsMTFNT1Z0QU9HMjI5QUVjQUVpUEpVTTJKM041QStPa0VL?=
 =?utf-8?B?QjBwWDdhcnJzRjRzY2w3NytOY1V6QVpOa21ibXgwZyswaE1DaUhGV00zT1Fw?=
 =?utf-8?B?SEM3T005NkZBZ2JQaDM5VTVRWFdkaHBXaUpZMUJIVXpLWVA1WS9hcVozWk9N?=
 =?utf-8?B?bVBxU1VHNnl5QXk2blVqYm4zMEVwRjdtcjYwaGhRUXIxdm16alVJeUd3OFcr?=
 =?utf-8?B?a05XbXNXa3dhbWFsZGNCWDRyMzRJL0xEYmpNcUl3aS94WWFuNmxVbHFPalM5?=
 =?utf-8?B?eWM4V1ZreS9WcUhWc0lOemNyb1dkUzBzOUtrOHR5MGZDSVAvMC9ETFduaFN1?=
 =?utf-8?B?N0lTeTNxLzJXTTYrWG5lU2tPTWFraUVjQXZiUHFtWWJyejM4bDQvNUhjME41?=
 =?utf-8?B?bnc0ZXIyWW13cWpPWHo4NGE5eGNnZG50ZmlRVTcvVEcvbm1RcjdhaHVzNHdx?=
 =?utf-8?B?OFpDcnN3bGtwcVRjUElkRUxoSjArQ0liMlpIWk96Y0JKMXR2dGZCNWhpeTRK?=
 =?utf-8?B?dXBZbEI5UW1GOFRqVmJ4YUJEc21mNHVSbEFaYzFod3pLN016aGlIQm1ldkIy?=
 =?utf-8?B?b3R2Sk5Kc2szd3BpeGMrQ0dQWW1CZ3ltbXdFRk9zdWNBVlJrcm5pM2Q2V0hX?=
 =?utf-8?B?Zmo1QWRVOWt4S1Bzc0ErM3hmMUorOVZPTG1rbzVWdW1JV3NKRU5xb0YzWnJB?=
 =?utf-8?B?c0EyQlhlMjlHRXdxdkhVOUNNOHNZajlLbXpwd1UvWlBLZjBxR3dGOWtlQnJu?=
 =?utf-8?B?UC9CT0VVa2hsRkp5K3QveWNhbnAvSXp4WUpJaHVZU1pDQ1NXYzJ2Y0pQUG9H?=
 =?utf-8?B?MW5PZVNDYjN2Y1lxZFlKZDZqQXE2ZW1MZk1TY2JlcklwUUx5N0hUWXNpc095?=
 =?utf-8?B?Qms2N0J6b1BmMStmK0N5UDYwWUxRUysyZzdXRDdXQUZiSDhCRGJYdE1aWUQ2?=
 =?utf-8?B?YWZ2RlJIdk5WWjZjZXljYm4zdjhWSUR6OHV2WXJrNE9FdDYvUG1haXdvY3Vm?=
 =?utf-8?B?enM5TGVSV2R2OHFMbFdxdWgvRFZqVnc1Skw1NFUvTUU5eXFuZ1hXZW1LSFJC?=
 =?utf-8?B?WWZ4SDN3RTVBVTFES0dPR1RDblkwVVVzK3FyYlZIYktpb0E0bTYyWnBaYWlx?=
 =?utf-8?B?dHdIL0d2dUpIc2NZclR1ZVlPcHNWcDJJNmJnV2crMUxBbDRMeURqeDhYcFhy?=
 =?utf-8?B?MWR5ZnhmL3ZVL2R5TjNzM2VBdU9pd1laWlcvVU1pVmhJYmMvbzdud2lxOXZY?=
 =?utf-8?B?VENEajdOSU00MmtjTVU1a3E0T0d3Mnd6eXRJa1BwM0ZzQmE4d0NxbGhydkdk?=
 =?utf-8?B?V1RUdjE4SllXZno1WlY4d2l1QVA5OWNZVHRjZlRKT2Y5NWhvV3dWcFJNRUc2?=
 =?utf-8?B?bTFoSWFGN01uVVZRcDhtWGsxdzcyWUdBb2RkbzlIT2VTM05SQjFFbzdyMGg4?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <387C61A5611F844CBB7D80AB202A5B73@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770782d4-f8e6-42ac-174e-08dd2055f810
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2024 17:52:56.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qeassWnv6872k1nsK96UKZyMYGQpTJjyFJeHIHo+iPr0n74YWDawa0Un76v6C7rP0AcccINn9PInlT3WLejrw6yUSV+dMKImmlB+gU/LVaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4933
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTE4IGF0IDE4OjMzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFNvIHRoYXQgaXMgaG93IEkgYXJyaXZlZCBhdCB0aGF0IHdlIG5lZWQgc29tZSBs
aXN0IG9mIGhvc3QgYWZmZWN0aW5nIGJpdHMgdG8NCj4gPiB2ZXJpZnkgbWF0Y2ggaW4gdGhlIFRE
Lg0KPiANCj4gQXQgdGhlIGVuZCBvZiB0aGUgZGF5LCB0aGUgbGlzdCBpcyBnb2luZyB0byBiZSBo
dW1hbi1nZW5lcmF0ZWQuwqAgRm9yIHRoZSBVWA0KPiBzaWRlDQo+IG9mIHRoaW5ncywgaXQgbWFr
ZXMgc2Vuc2UgdG8gcHVzaCB0aGF0IHJlc3BvbnNpYmlsaXR5IHRvIHRoZSBURFggTW9kdWxlLA0K
PiBiZWNhdXNlDQo+IGl0IHNob3VsZCBiZSB0cml2aWFsbHkgZWFzeSB0byBkZXJpdmUgZnJvbSB0
aGUgc291cmNlIGNvZGUuDQoNClRoZSBvdGhlciByZWFzb24gdG8gcHVzaCBpdCB0byB0aGUgVERY
IG1vZHVsZSBpcyBiZWNhdXNlIG5ld2x5IGludmVudGVkIGJpdHMgb24NCmZ1dHVyZSBDUFVzIGNh
biBvbmx5IGJlIGtub3duIGJ5IFREWCBNb2R1bGVzIHRoYXQgc3RhcnQgdG8gdXNlIHRoZW0uDQoN
CltzbmlwXQ0KDQo+ID4gDQo+ID4gVGhlcmUgYWxyZWFkeSBpcyBhbiBpbnRlcmZhY2UgdG8gZ2V0
IENQVUlEIGJpdHMgKGZpeGVkIGFuZCBkeW5hbWljKS4gQnV0IGl0DQo+ID4gb25seQ0KPiA+IHdv
cmtzIGFmdGVyIGEgVEQgaXMgY29uZmlndXJlZC4gU28gaWYgd2Ugd2FudCB0byBkbyBleHRyYSB2
ZXJpZmljYXRpb24gb3INCj4gPiBhZGp1c3RtZW50cywgd2UgY291bGQgdXNlIGl0IGJlZm9yZSBl
bnRlcmluZyB0aGUgVEQuIEJhc2ljYWxseSwgaWYgd2UgZGVsYXkNCj4gPiB0aGlzDQo+ID4gbG9n
aWMgd2UgZG9uJ3QgbmVlZCB0byB3YWl0IGZvciB0aGUgZml4ZWQgYml0IGludGVyZmFjZS4NCj4g
DQo+IE9oLCB5ZWFoLCB0aGF0J2Qgd29yay7CoCBHcmFiIHRoZSBndWVzdCBDUFVJRCBhbmQgdGhl
biB2ZXJpZnkgdGhhdCBiaXRzIEtWTQ0KPiBuZWVkcw0KPiB0byBiZSAwIChvciAxKSBhcmUgc2V0
IGFjY29yZGluZywgYW5kIFdBUk4ra2lsbCBpZiB0aGVyZSdzIGEgbWlzbWF0Y2guDQo+IA0KPiBI
b25lc3RseSwgSSdkIHByb2JhYmx5IHByZWZlciB0aGF0IG92ZXIgdXNpbmcgdGhlIGZpeGVkIGJp
dCBpbnRlcmZhY2UsIGFzIG15DQo+IGd1dA0KPiBzYXlzIGl0J3MgbGVzcyBsaWtlbHkgZm9yIHRo
ZSBURFggTW9kdWxlIHRvIG1pc3JlcG9ydCB3aGF0IENQVUlEIGl0IGhhcw0KPiBjcmVhdGVkDQo+
IGZvciB0aGUgZ3Vlc3QsIHRoYW4gaXQgaXMgZm9yIHRoZSBURFggbW9kdWxlIHRvIGdlbmVyYXRl
IGEgImZpeGVkIGJpdHMiIGxpc3QNCj4gdGhhdA0KPiBkb2Vzbid0IG1hdGNoIHRoZSBjb2RlLsKg
IEUuZy4gS1ZNIGhhcyAoaGFkPykgbW9yZSB0aGFuIGEgZmV3IENQVUlEIGZlYXR1cmVzDQo+IHRo
YXQNCj4gS1ZNIGVtdWxhdGVzIHdpdGhvdXQgYWN0dWFsbHkgcmVwb3J0aW5nIHN1cHBvcnQgdG8g
dXNlcnNwYWNlLg0KDQpPaywgc28gd2UgaGF2ZSBhIHBsYW4gdG86DQoxLiBWZXJpZnkgaWYgdGhl
cmUgYXJlIG1vcmUgYml0cyB0aGF0IGFmZmVjdCBob3N0IHN0YXRlDQoyLiBFbmNvZGUgdGhpcyBs
aXN0IGluIEtWTSBmb3Igbm93DQozLiBDaGVjayB0aGUgYml0cyBtYXRjaCB2aWEgdGhlIGV4aXN0
aW5nIENQVUlEIGJpdCBpbnRlcmZhY2UgYmVmb3JlIHRoZSB2Q1BVDQplbnRlcnMgdGhlIFREDQoN
ClN0aWxsIHRvIGRlY2lkZSAobm90IHRvZGF5KToNCkkgZ3Vlc3MgS1ZNPTAsVERYPTEgaXMgdGhl
IG9uZSB0byB3b3JyeSBhYm91dCwgYnV0IG1pZ2h0IGFzIHdlbGwgYWxzbyBjaGVjayBmb3INCktW
TT0xLFREWD0wLiBXaGVuIEtWTSBmaW5kcyBhIGNvbmZsaWN0IGl0IG11c3QgcHJldmVudCBlbnRl
cmluZyB0aGUgVEQgYW5kDQpyZXR1cm4gYW4gZXJyb3IgdG8gdXNlcnNwYWNlLiBXZSBjb3VsZCBk
byB0aGlzIGVuZm9yY2VtZW50IGVpdGhlciBvbiB0aGUgZmlyc3QNCmVudGVyLCBvciB3aXRoIGFu
IGFkZGl0aW9uYWwgcGVyLXZjcHUgInZlcmlmeSIgaW9jdGwuDQoNCldlIGNhbiB0YWtlIGEgbG9v
ayBhdCB0aGUgbGlzdCBvZiBiaXRzIHRvIGRlY2lkZS4gVGhlIGN1cnJlbnQgc29sdXRpb24gb2YN
CnByZXZlbnRpbmcgY29uZmlndXJhdGlvbiBvZiB0aGUgdHdvIGtub3duIHRyb3VibGVzb21lIGJp
dHMgc2VlbXMgb2sgaWYgdGhhdCdzDQphbGwuDQo=

