Return-Path: <kvm+bounces-34625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22835A03012
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D1A1885E0C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E421DF961;
	Mon,  6 Jan 2025 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQIJrztu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5C19B5AC;
	Mon,  6 Jan 2025 19:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190038; cv=fail; b=DmDzw1QOKc9pPaRrtran8GffmH1urWv8oIp+ZF3IlxC/Y3uW/x3pma+cGGxYntYq0Vuxhf8yewljoaRklgA3DbdH7wzyLNfFlP4jzkCizEo+SMfiU05c436DXmsggDP4mFN+3t88NdLSVzJ+M7b7A4akHQpBU7hnT3i7IvIGeuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190038; c=relaxed/simple;
	bh=cFvrgZvs/ibtNXpGruFlMR/fybcDfuJU3lFsDneNGwI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ldJNeUwB0BSEPiQm1JWVEQiapGN1MKnzjG63bHCqgUQQfZMAH3dnZeMJporfq1qA18pYRZ/H7rkTl8SQ18ibWuhyoY5Sbddl8LUZkTTWHZ/gCDx+yeASrkW3ZDfBMZMaHbgYKlEp2Nc07RQ1nrCM1B5p+5wM7Q5ZLmNa/BWp98g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQIJrztu; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736190034; x=1767726034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cFvrgZvs/ibtNXpGruFlMR/fybcDfuJU3lFsDneNGwI=;
  b=XQIJrztuWidUMCx934Pe9fNRY9GlCAw5Rbe4mzvP3JH34VfcaardtfGK
   YYOaWHY2/iBSbxmETfEuDcYISvm4eZJcmq6IV5DLQiJeX0NVATRH9av7m
   LKtY1sPyI6sbFPbj/ucrZAvNHiziXWZ6tHpNVK4dpjbQMzs7XvgMs2tc2
   P1LOgskAYE6vi470v0H67lAdzAFHh5OSnUY7xcutIGubklWXFDho3HmQK
   L9EWZSOK0NsCd6NAEHN0/GBpuvbd45d2q2HPzkUvBW3K1LgDbmNxGb35V
   qoODQCu1uEnpyvSgxpw9vrV71heJ3YmXi8p8NeEEQDJhgSY1nUD7IesWt
   A==;
X-CSE-ConnectionGUID: POAQYVV+SKetoF8406rPwA==
X-CSE-MsgGUID: FzY7UUCJRVydgBhABs5m8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="35647520"
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="35647520"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 11:00:31 -0800
X-CSE-ConnectionGUID: lfYxKMwoRaevlQuS+gx6zA==
X-CSE-MsgGUID: gluX4kdHQMGAIkNifK5dvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="102344355"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 11:00:31 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 11:00:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 11:00:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 11:00:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/n0d9QKXuIbnd4gJ/1667ogDSedtr8VZanYuxIZ+cIFA5b0NYGw5YGPdfq+GvtYbKOz6fvAK1NjE15JiLbnpDBCNf8K4pYZCvblJ/iltgpF69+7YT+ZlRVFeXAr6O2cY2BgNFFlY8E821eaB5Fgbp2xVt9UdLU/WCX2a4XI5big/hXiGg/RMgdDetzIk9dOWEFJ9oLCd18Xm8zpnqCx9P4d+xZxams+bBLAnExjEOlyj+dKVmVwrwC5KDzJyRFqoMVClLZ9tBb5zw8D+VSORZWNn3RRA9Ka6Sfjk2ZRqUTrdjEPdGYXYCC6vbhlfBEr0iwHOajHZWwR0Kq+wMxiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFvrgZvs/ibtNXpGruFlMR/fybcDfuJU3lFsDneNGwI=;
 b=Ff6HjDAniF0QT3E/mZN2dV5IXFuh5VhPE29D7es3dd7uC0fqdy6otIv0P6qe7F66Bw26IBSCvQ5nKsSVrf9xlsU/Ys9lHjXbU+O1pYwY+j0avqEPqLP2wbqmfem8v6cD89SifvWuiwIedyHZ98qV+Y1nFQrBeD+Vjy7MK0C531IhbS1jRP43BgiFlEWy9dha9/kXc9TJnFyjyylvHpL6e6kIG47/ykIzzyiS9o+lgNWnIjpKXHB4GHIKoHw4QaBku9oBcCXtcU0bKz75wrpYt1yTQ065DR5mmBXDN2wiKOAzmhMRgF9JaBYUDL2ad32ssTxzeeNCH2d53Lm/Lhap8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6812.namprd11.prod.outlook.com (2603:10b6:303:1ee::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 19:00:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 19:00:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 11/25] KVM: TDX: Add placeholders for TDX VM/vCPU
 structures
Thread-Topic: [PATCH v2 11/25] KVM: TDX: Add placeholders for TDX VM/vCPU
 structures
Thread-Index: AQHbKv5AZdevBGzySUyYaNP/hO5MBbMIa3AAgAIZCgA=
Date: Mon, 6 Jan 2025 19:00:22 +0000
Message-ID: <c76df53168e188209f03a6552ff91282ea8f7456.camel@intel.com>
References: <23ea8b82982950e171572615cd563da05dfa4f27.camel@gmail.com>
In-Reply-To: <23ea8b82982950e171572615cd563da05dfa4f27.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6812:EE_
x-ms-office365-filtering-correlation-id: 7a1885fc-4000-48c2-49e6-08dd2e845f15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K295MDlhQmQ4ZllmcEhIL3hTUlBpejk5NHNVUE01eVNacDBJTTRWcDFydXVC?=
 =?utf-8?B?WndHT3dDKzFrUzFYKytqWXpwS2pJSHBSRzhCZDhWS0Qrd0U1WXV4UmdQREpL?=
 =?utf-8?B?MktMeGhGMjV1dlh4Si9nWnEwc3RoNk1lcEJtc1lzcjJia3dMQ0Z0MWh3dnUr?=
 =?utf-8?B?d0t3bm9RK0JkZFV6TFB5WWh2b0VzVEdVT2lKbXpsLzFONXhtWnphWWtJb1VQ?=
 =?utf-8?B?eUhYa3k5Vi92ZVo3dlBEalVjSzB2d0piYnNjUmtjalN6T09meVdHeUQ0eVNZ?=
 =?utf-8?B?NE9wWTdrSVpvNHBQdThETlNjNlFFYWhLdGtpVDZLcWhhejcxTXhJV2dNb0tN?=
 =?utf-8?B?eWdUQUJYbVRsQUluNXFFa2taZlhrR2pTcGw4azZQZ2hNVkp3VnJGK3RuWHNG?=
 =?utf-8?B?ZlVCWEp6NFhPbzBMY2hBY0x3bkpwaUdIM3AyTlFIOFh2akpkZ09zaUFRd0dK?=
 =?utf-8?B?VVFCbDdwbHBiYU53bzdxZytLSEYxT05DTGZPM0pZVUs5eEVlcnVEcUNuUXRm?=
 =?utf-8?B?WWZ1cE4wQm9FRWVHaWd1Z3JxRnRaRmhPbCtrb3hmekprRnFHSW9lSmEyY2Qx?=
 =?utf-8?B?QllJd1RwK3VhQ3dBTDhQMGRlbm9JZnNyUzZETVJxTFNBd1dEZVI0Znp1ZkJT?=
 =?utf-8?B?Z2t3cS9qczZnSzFIKzdaRTAvaklPQTd1WFZYTFkxaEpVOFhqaktkcjZCd2Zm?=
 =?utf-8?B?UkNZMSt6bW5ORmVhdzBYWG1wWGh5YkZWLzNMTlFJWUt2bU1mbVpGRFZ0Ry9x?=
 =?utf-8?B?M09RQVlOMFM1OHpqaU42MGlFWVhhWXRYR3VheW5SbGJmQitGcmVCRTkwWUFP?=
 =?utf-8?B?VU9CTjBBTWxZTUFPWjJsQ0pLZGtOekdQOTl3T1RzUkdtWmEvMDdXcGk3Qy80?=
 =?utf-8?B?b01BNFl3eW1hRk9kYm5qT1FFWDZpdXUzQjE5S0JhYXh6TkxnTkdTUjdoMEF6?=
 =?utf-8?B?RWFSVXY2cGtoaVR0czRGSUYxemJ2Y01TbFBVWWo5aERIRzFnN2syWnc4NWd1?=
 =?utf-8?B?TzJpdEU5Q2toWWxjd0Fmek9vY3VsOXFxNEl6VzByUDhhL0JpNTlmZmJOWVo0?=
 =?utf-8?B?S1dmS0owMVhiVlU4dVZWSXFzMi9rTC84d3c3ZjBFRkNYUW9NUHZoRDVLU2lX?=
 =?utf-8?B?K0Q3bEt5MHJvNjN3SG1yNDdkcE1sWHd3OGJNRmJKN29RcEpMaEFPaTUvNmVS?=
 =?utf-8?B?a1l0K005eW1SbmwzcEdqdm5JQWxwTE5qQzFvdnVPZzFaN0h4dnc4cHBGaWVs?=
 =?utf-8?B?V2VSaEFVZjAvL0h5aUhtQlFldW1NLzRiRUNrUnVqZWdPK0R0UEpxbElobm84?=
 =?utf-8?B?Z05nbnBrMVViQUlFVFpYZXJBcEVPSExwV3Q5aVU0M1pPNk5uaVBienUwWWdI?=
 =?utf-8?B?MlNyRkQ4NFFlZG42QVhGbHkzREt1bmkwbmU5UmVXMzVaU09NSXFUWWgzNE1n?=
 =?utf-8?B?RmVoMFZWalZrNlpUV0lLc2tmVzdmZVE2ZkpDcndHY1NueGhkWS81TzVmdy9z?=
 =?utf-8?B?LzJsRmJHeGdxNzQrN0tOMHhRT3BkYnNqd1RWZ3dKN2RvVWdwbWtLd0hXbjFk?=
 =?utf-8?B?TnRPNURhZnU3MmJTcGxIWnJvT2xjSFFTYWJ1Slo5ZkZ4OVdIcGUyVk5uYnNL?=
 =?utf-8?B?SXlXTk9hODN5dlRrZjJvTXZOZkIvTVR4RDlBWDFZMUNNaXNaeGJkamtIQ1dX?=
 =?utf-8?B?aXBUUEg5OHVDUzF4RnNHZjA2cmNENHduV0paRGxGVGxMMUQwRzMrRDg1dVgw?=
 =?utf-8?B?UW5IUkJNOE84MFhzTG1pUHVwM2tJaXl3eEFNRFdQamo2c0dVSFBZMzZ2YTcv?=
 =?utf-8?B?ZlBwQ1Rpb3FhMkRROVBpaEtuWWZ6Z3F2bWtHbmlNSS9iMkZjQmI4YkRQQ0lQ?=
 =?utf-8?B?TDRiVW1VN2l1WFQrbVMxd3hMZU9jNVd1bVZwaDF3ODZ0bHRqWEZCMEpuNEha?=
 =?utf-8?Q?J5S92jZW8Ej0EvwPr/AEfiXXna8tfejQ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1RucTF4VU1oQXRVdWhRSHZCclBhVnAxRjU0RHNvekRBTGUzenBZTzBIUnJD?=
 =?utf-8?B?cnhhRG5wV01WOXl1RVBFYVJyU2VnU0ltazROQ0NaU1RHOXZ0ME1PZTNUL1kw?=
 =?utf-8?B?RjBYUk5odm8ybkVxL2xpWWZJaWh2SzlaN0xhcFlOSUVlK1JqcVlBTzdFemo3?=
 =?utf-8?B?Zmh5blZncU1sZWhKRFdHaFpyVzM0bDhNdnFKK2x2Q3gvTkJyY0JtbDMzRjlh?=
 =?utf-8?B?eE55dU9VTVVwaWV4M1hWek93S1hJTzMyRUhmOEJqeGV0SkRvTXR0bkNhRE5k?=
 =?utf-8?B?WVRRaVVkYytQU0xsenVyZlhQYVpuYkdBVXNWcExleWVmTm5IYkd5Z0hLOUxY?=
 =?utf-8?B?aXRYVEdOSTFPak5YSzVUbmw0cDN6UXR2UUJLOG1qbjhQZG1yWENhakRLeXNl?=
 =?utf-8?B?WjJUL255aDkwOU1pR2RYMDZTV28zRGllWFQzZTRKK2NmZ1VxY20zYnQ4bWo1?=
 =?utf-8?B?VEx6RDdMM1JvR1BqbVZGNXZObXB3dW5HOERMd29oakxmckREdmNMV01wblF5?=
 =?utf-8?B?c09NMzRZNlhaKzJWRXlsMFRDVGVWaS9uMFBsbGQ5QzJlWFRSM0ZabzVJNkZz?=
 =?utf-8?B?OWRuWlFqVUU2dkxWcDBvK0ZxWUF6ejFZa1NPVmltdEsvbXRTVzRheE5Cc1Zh?=
 =?utf-8?B?QlJRdUtuSzhxemFGejMwMzlyUlBaM3krbTN4UmlMT3RCOHMzaTcwcE5BcGhp?=
 =?utf-8?B?Z0lCTXBiOVBwcllVRndTSGhHdDl2dGY1YWV6VkNleGlQaVE1M2MvZm1VL1c3?=
 =?utf-8?B?WWxaV1E2cEpMQmIwdkdyTTExQjBrK3MvbGkrU3BTZGEwV0FscTk4S3pUMFly?=
 =?utf-8?B?bEovSmMySHUrYjJLWGVHZ1grMEMrK2dsc05Hb3VUMEZrVFI3cThBUVhVQk8y?=
 =?utf-8?B?c0RuZE54N1hjcHRGSmJHRDVLRUdVWjBGS1V1a2NPVjVHRVhubXhlV1VCSXBx?=
 =?utf-8?B?SnNYRXAxTVozYTdMbms2S3lWMDJiUHQwb3BkZm9qTnBNRjVpVnYzRXdLQk1E?=
 =?utf-8?B?eGwyNTF1aWRiN0FpbnV4UmVVbHBGbUFOb1dKZ1ZDYnQwYUFOWlVvVm9NVzRU?=
 =?utf-8?B?Z0U5cHlEUktObTRSYUwwL1d6aGJiVnJkZkNhaEdlaEpWY3Y4a0duZFZxR05L?=
 =?utf-8?B?c21pcXg4OXY0STUwdWJtdFBGYTh3aVhyNFUvUjVrZ1dYQkE4UGJlWkZOQm5M?=
 =?utf-8?B?UytyVGUyNmFDYmxOS2VieXJnWHdrM0x1cVFYNTlNQnUvb3Fya0JUNHNlZVVY?=
 =?utf-8?B?ekh5eEt0TU5GaTRCOXc1SU5VV2p6ZkFldVNNalAwVCtLWE1yMXBnWGdEWGZw?=
 =?utf-8?B?WnNXMlIvL3FLZW10bWJFdWZ4TWRrUFNmb2I3d2p4OXlQK1VML0p6SitPdDJ3?=
 =?utf-8?B?UTdkTjVYb1c3SUJtMFpNdFRUaXZVdXhiVmRManZ6LzArNEhSbUlTbWdXL204?=
 =?utf-8?B?ejlrWVQyYS9WaG9EOFQ5UnVTU2tQVEVaU2NwS2JPRGErd2QvMVljNHhUMElo?=
 =?utf-8?B?WlBINWtya25jQ082aytueFFMUXpyT252ODQ5ZldGTVZJRUN0SmxickRWRzlw?=
 =?utf-8?B?UzUvbU5oMHcrbUt1T3JOSVhoVXdxSHdXUDd3UWZDZDJ1M3ZVUFlrb0VnNkoz?=
 =?utf-8?B?bktDNk42UnBVdEd1OVVXMnlBQXdGSzUwcGtnOHI1ZjY1UndmT2orVk43UERI?=
 =?utf-8?B?Mm03VDJpT0tOc28wT2t6VFhoRklUV2pVdW1peHlOdFNrWmQ0dmZ6aWNCUnNB?=
 =?utf-8?B?bE93dWhWSUd2Qi84OXV1VGtpZVNIeFZwYSs1WGgyWlI1QnVubzNZdkgvbUlm?=
 =?utf-8?B?aTUwdWRsWTdmeEM5bVl6OHF5cFhRQUl4TE9BL25Ba21MNjJBZDMwZG4xS3dk?=
 =?utf-8?B?RUxhRHQ4bkM4WUY1K2dleWdZNkpsc2IzRDEyajEyRllscVFsVmc5TE00Q2ZX?=
 =?utf-8?B?cWlCOVlPQzhkOEdKdU9TaXR6YkFoMnNsTGVWZ1F1ME8rQ3QzUk9DUG1QZEF3?=
 =?utf-8?B?bzZyeTIwbVZUMGdNRXRvMU1FOElydnhZaDBxeTcxTCs0K3p4akgvVG9mMlEz?=
 =?utf-8?B?ZzhBdW9RdTJ6QWoxUG13QjYvSnNUUFJjcnFjcTBaSWJIUkxEN2JZWXozTXBs?=
 =?utf-8?B?cTNGNVhwMGd3N3BtRTcyZE9nWTJIaC9aRzY2NEkxa1NRYlVNczZ2RmVFZXFK?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAFEA40BD7C87C45B47F50E59FA24A54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1885fc-4000-48c2-49e6-08dd2e845f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 19:00:22.2038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6Xja5mruHng6yvf59SrTuCxB+KR+bwOuDN/64XZev2B/6+YpOMnGx4pL1e9pO3di6pbT+HUwKP4amQJMZYbfvfyP+tmmupU4w7rIGHEHps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6812
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTAxLTA1IGF0IDExOjU4ICswMTAwLCBGcmFuY2VzY28gTGF2cmEgd3JvdGU6
DQo+ID4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IGt2bV90ZHggKnRvX2t2bV90ZHgoc3RydWN0IGt2
bSAqa3ZtKSB7IHJldHVybg0KPiA+IE5VTEw7IH0NCj4gPiArc3RhdGljIGlubGluZSBzdHJ1Y3Qg
dmNwdV90ZHggKnRvX3RkeChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsNCj4gPiByZXR1cm4gTlVM
TDsgfQ0KPiANCj4gSU1PIHRoZSBkZWZpbml0aW9ucyBvZiB0b19rdm1fdGR4KCkgYW5kIHRvX3Rk
eCgpIHNob3VsZG4ndCBiZSB0aGVyZQ0KPiB3aGVuIENPTkZJR19JTlRFTF9URFhfSE9TVCBpcyBu
b3QgZGVmaW5lZDogdGhleSBhcmUgKGFuZCBzaG91bGQgYmUpDQo+IG9ubHkgdXNlZCBpbiBDT05G
SUdfSU5URUxfVERYX0hPU1QgY29kZS4NCg0KU2VlbXMgcmVhc29uYWJsZS4gVGhhbmtzLg0K

