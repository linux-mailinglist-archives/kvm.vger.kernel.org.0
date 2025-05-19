Return-Path: <kvm+bounces-46990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEE9ABC24B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:23:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E0F03AD0A7
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A630A2857CA;
	Mon, 19 May 2025 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CBeX3cDW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017126B093;
	Mon, 19 May 2025 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668206; cv=fail; b=J/jn469ss5rs0E1WRz38KJPhDQvXXpUJoGqPwfcsREWFC7wlJkbT0T8ZqJKWjZJWP2l19L8GTdzYs7VO6fxhsizNNhher/Q5PbLknIzsDF2vyXQrv4vwceC26tyJdM0SJr8SihcLpQNTzFWdRXiy0hv/2ttzUJ8WS4AGoj+g/kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668206; c=relaxed/simple;
	bh=RPcDKYBP43/eHdvTsp/iMbsxeNQtFii3lXJhKSQntBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u69NAFduEuQZgqhsRjuiQlmzSkYFqkbSWzGnaAXAr0u+LwDSEz1FGu2gs2S+xO+JOOXT/mngIi4quGdgnDx7mLqux71Do3SnebaGWbkF5s42TI0Tt65IxK/Mn4HmXv4MLwJNQtvOZqHBhd4wGhhEt4vBOmPVJlKKbSAbCg18zGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CBeX3cDW; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747668205; x=1779204205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RPcDKYBP43/eHdvTsp/iMbsxeNQtFii3lXJhKSQntBk=;
  b=CBeX3cDWBqMy7WBbnOgcOr0BifYrgvZ4Abipn1GvnYz48v3n8Xvw/WeJ
   JeyPltEzMd13HidH7l2H+oUNfHkh6PKqtKXPKzBl9jxFipeBa7lWcnpH9
   Q+yu11rwEagdCq6EBV7I/vvyxJRfwlDf207ufdOaWbAaJ+zNC7oKHJdNm
   V2ePhTPFmfKChzUbW+B3bbC0enAhF1lq3lTG1v+uhLxsop89ETdoCmgb9
   AA9DEJ71B0XEKCYgACBU0s/WZhhpC1NZhkUGDXmDD/MzBDYQr6UVyu2dx
   PDJ+eQAshl8BRR2zFr8+hod3E1Hv51x3CXiQEUDJmoD3uqQ+7j9/+1yKo
   Q==;
X-CSE-ConnectionGUID: oDn964RoT96+D2fIyEg/OA==
X-CSE-MsgGUID: cSWdnzsGTAW1rCtmX/XGVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="52206001"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="52206001"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 08:23:17 -0700
X-CSE-ConnectionGUID: 8bnOCONJThOd0WdvO+qcvA==
X-CSE-MsgGUID: 2hpyluRrROamYKY2EJP4kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139900488"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 08:23:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 08:23:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 08:23:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 08:23:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s52+8n7aGRgCIaIWk5o8WM3TuciJw3s0c7aHXsWJaoVuM5+dQ/93aYJc6IarWPP+C/Nr8iJ6/En21MZ46MYEbIwSzWyv9TzRJYvx6tVYRrvSEc2QN0EdMHRHcYAm2wA6KgYY6F8PwrrPYKtunECcw6QN5fc+p6OY3qncy6HJoykQujprgh2VT1atg0munAN4ILS7b0FlXB7cmg2wtvSLJehkyMtljg/J97f6sr+6a2lSesZOQuCETsgFWlEc3ee5B+XPwN/M63wCFY1DYeXvuM/uC7Ohy7ZnY861SmKeMk+Z/wl+YmDU4kVq/U5WF7kklCd/tTUkpM2uyMVIc4Zyfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPcDKYBP43/eHdvTsp/iMbsxeNQtFii3lXJhKSQntBk=;
 b=WSJRE9T/BUvf4mOBJ9y8PAbgRRiVQktjX/9GO+nlk5++9GkucPLLlJtE0J66gQP18DRN5+h/rNOctV4ZsO3bBtDfMpN4MRmToPng8iB0jbqV241D3prG3ITIxMy3yVncpSBYDH1KlHRhDsQGkCub4fn6wM0IxIR5mmyWUG7JDIXPcLGpZMbUQEkDWq51QQsZOzVr/bozCdeI+KtnWDRdAe5QQsF9jJTwA2YGCMXpkd0hxz7y0JEo2ba4SrXoYjHucS39rHJFxjWcwLRCl1+UGCJf7EUzGgTWPcSe+Q2t6FpDh/refc4YkMNVElUQKBABAUogtaLANNKg/ATvhPbgNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4687.namprd11.prod.outlook.com (2603:10b6:806:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 15:22:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 15:22:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
Thread-Topic: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Thread-Index: AQHbyGdiXv6lSo2xSkiHY9GZD31B8bPZ9FUAgAAZ3wCAAASjgA==
Date: Mon, 19 May 2025 15:22:25 +0000
Message-ID: <34609df5b649ca9f53dfe6f5a134445f1c17279a.camel@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
	 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
	 <8f9df54a-ada6-4887-9537-de2a51eff841@intel.com>
In-Reply-To: <8f9df54a-ada6-4887-9537-de2a51eff841@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4687:EE_
x-ms-office365-filtering-correlation-id: 2ecb17bd-99d7-4342-f596-08dd96e8f601
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZzNZNEJBeW42MUxFd3h0MXc2YVBUblF1SW43cnRrOEs5VWxCS3c5NVFvcldu?=
 =?utf-8?B?Q0FodWYxWTZTTTZnS2FaL2pNWUFIT2Z2bWFZOUcrZFhkTng3aTlTNzVibmc4?=
 =?utf-8?B?QzkwVHZqRXJ4amcvK1haaDVEMjE1STcrV3E3WEI3RjgxSnh3Q3lFQkVxMDFU?=
 =?utf-8?B?MGhwWDRCTTJhNjBUeThLczNqejJPWFppZytKbEdTTGZ0cXdoSEU4VzBoRExF?=
 =?utf-8?B?OXV2dm56U24yRzF4d0dtdW85U3cxcmw4bE9NZ3ZFelF6dG9hMVFUbTNadm1J?=
 =?utf-8?B?cU5TL0dUYm1kMitmaS9UL0hUdG9GMSs3cXFqRUlrenF1TWo2aUdOL3J1SlpC?=
 =?utf-8?B?ckIvNUxJdG1nSlY4Vnl5M1pnbXFTZXI5WEF3cUdxamVwRHZ0blhTZTk2c3ZU?=
 =?utf-8?B?NWNzZnR5b01QZVk3eWZSaWlTUzhCVnNpcEZuUFBjcmQvSE5zLzZJQUYzUCtn?=
 =?utf-8?B?M0tFZ1I0TTB0bDRvSjZJMVlzWDF6dXF3OG5SRlMrMHhoMXl4d1JXZVBOWjFN?=
 =?utf-8?B?UXppUTI1YnNkdFhBS0dhUnFRTGIwOHBOdVk1MGxjN05QVUtBeGlPUWlKMk1i?=
 =?utf-8?B?QXEvemtUMWFrRVVkK1d0QU9qRlpJR0J1eitYQWErR1J5aVNKdWhlRkh1ZTlU?=
 =?utf-8?B?N3U3VXE2T2FEeHlvM3dSbjR5VXQva2ZWY0hZVXd3SFNmUFBHUXlaNUt2aE9o?=
 =?utf-8?B?OXVoaWtseEI5Z0xROFZEd0RpQ05QNDVDT0I4d2c4dEdpMXhHN3hGc05EMFV1?=
 =?utf-8?B?UlFhY2tkY2pyR0pvaExOYThPcDVSK05ZaWdOOGlIRFRtM2hSZVBBSDdneiti?=
 =?utf-8?B?d21RWDNuRkU5Wkt1TUE0RzUvWVFiYWhObzdwNVl0clg2M0hJRDhaT3RCY3VU?=
 =?utf-8?B?a2tkc2p1VERadWZycEFxVGtHZ2pDZklIazZ1N0dVQU9DSDVzUVRheVd5dEZO?=
 =?utf-8?B?U0ZTMDlhRXZCWFdpQmdFYUVIektMcCtFOEJSVXdOVzRhWUY3MWkvTEVpZlBi?=
 =?utf-8?B?aTE5YWdaTEdIOU92d3BoZlNPS0VmMWRVa1ZDVEFLNm83ekZpODdJQXR6ZGxt?=
 =?utf-8?B?cFR5OUZ5ZDBGUGxPLzI3eDJXeDJMU2ZZNy9wc2ZCaFNZNm1mOUlwSDVLa2NN?=
 =?utf-8?B?bWxKdXF1cnZoWVB5WHp2UGJhMjQ5MUQ5dEpyaFZnaFZOb3NvN2pRa3czMTVl?=
 =?utf-8?B?Z1RSSzVxL1l3aWU0LzVwekNYNGZVRGtkb0tSenZUUk42UjFqUXEvODh3TFFt?=
 =?utf-8?B?K2gzS0s1Y3RhUWRIRlNtWmUyMG0rNndla3VRazh4V3hydHpnVFltdGNPMW5h?=
 =?utf-8?B?WG9valdUemNyRFpUenpmK2VJbTNSOE9pVkU2cXFXTHdSTXZRK0lRdTNqNWky?=
 =?utf-8?B?eDhITHhEQkJ1WVc0cWlpZHh5VmRWMEcweGxueksycnM1SllTT0tza0kzM2RY?=
 =?utf-8?B?eUI3Y2NjUm9lNVRpbGlLLzlsSGtINFgyZmxFbUFtUnE0VnpDWWpPWE5vS2ds?=
 =?utf-8?B?WUxpNFpBT0V2R2svckhVK2lTamlsSXNBRHliMGlubWUvandVcWVnWjduQ0J1?=
 =?utf-8?B?b0J6YS96eEU5K2lPcEtMZG93NE1kbEpPbzZuUTdWZDFkQnUrdXRLemRkOGRw?=
 =?utf-8?B?OW5pOXVOVnZuL3lhdW9sblpBa0J3dE5nVnB5cFlVS2RqZjdrZmQrd0lOQm9K?=
 =?utf-8?B?K2F3UTFuRk1Ec0Jianc3WHdSN1BuVFFycUc4bFkvTldJaTJ4YW5NSnpBVDdL?=
 =?utf-8?B?QVhHMG41eVVFa3dRWEJNMncrQkUxb2V2bkpKUlo4SXFHZ0RWN0Y4ZkN0c1Ix?=
 =?utf-8?B?QjFnRFllbmc1N2F0WllCZFF2dGdlWVV0VzZxWlA5RXhnS2NwN2JVSXlHc2dt?=
 =?utf-8?B?TXhsbDdZckZrRHEyLzdUSldZOGtEaWVPYkhZVEhQM1pvZnE2Y2xFZ1l6aWJy?=
 =?utf-8?B?UG1hNFUzTk9FOTRuMFhyV1JwdmpLTDlITmxuaGRGdDNjd3lSNkRoQ0RNdlpx?=
 =?utf-8?Q?PfSCfPqXpJnBYPdsXc/vMbHkvPqkSU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXhFZzVJTmVVeGlsMDU5bjR4NjRkdEcrVHBzT2Z5Yy9Vbk01aWlzWHhDNW5Y?=
 =?utf-8?B?ODA2T2xjcnJ0bzNMRk14andTR0ZpYVdaM2hZTHVkMm5pMGdmYVkrUUhNeDMx?=
 =?utf-8?B?MmxOaE4wUTBRSVNXQ1Y3bGxwMWRpQmtLQXV3TnQrcGpldUhYYTJYVzZXN2Mr?=
 =?utf-8?B?dEZobVNOcmRzcEwvUEtkbDNtemY5Y0R0ZmsxZzZCSFU1dVE2MGwydWNmOFY2?=
 =?utf-8?B?WG5QcHZyVEFvUEV1Q2JmbHprL0QrT2pmSitDcnk5KzJhUU51dUJqSkJPQTUv?=
 =?utf-8?B?TmVaTXFrWDN1WXR1WnZNS1JIckhvdmgzS0Q3TkVDRGU1TEpjYTRlM2tyckll?=
 =?utf-8?B?clZlSk5Ra29iREdIaTBIaGcrRW1jVlBTenk4TGVNRFR0dVlZK0dmaFFpVksz?=
 =?utf-8?B?eGVKR3FXcXBnWjAyc3hCcU9sY0R0WjR4bGl1b1Z4YUcxenRvbDZZYUJURlUz?=
 =?utf-8?B?ZVFsMjl3Z3JLVlJiVm5kL3Y1V2ZraE1JYjdzUFlKdmFWQTM5QUt6RG53OURJ?=
 =?utf-8?B?dGl1M1hoaWp0NWJGb3AweGx6NXNiK1RFNFk5aE1tbENHQmhuTkt5cm1rU3BM?=
 =?utf-8?B?UjBuRk9oRFE0bndjbzJETFZGKzl5NFZxMERBdEFkMkJiSUM5WDEwZmMzMFY2?=
 =?utf-8?B?dGtmMkw2ZCtIZitDQ1hKTWE3QURaUHlCUUZxTnRlNUEvTEN2R0FMeGh3YXNh?=
 =?utf-8?B?MWFVd200UVcvNkJvdnBrakV0RlRIcUlwZE1tZE1qRHVJTVVESlVzRWE1bCsy?=
 =?utf-8?B?aytObDRqYnozTVpwcTRQSzRGbXBXcjBCRGNFNW5LKzc4Nk5rQXdPckwvT1Vs?=
 =?utf-8?B?S0Q2NzQ5U0pkblJaeHRuTjRtN2pmWEJhRnFnQUZGRGxNLzlXcHZRaW1pOER1?=
 =?utf-8?B?ZmQralA2UER3anpuQTVTN1VXVHVTTElHTk5OUUQ2dDU5R2Rta3lPSEZEcHht?=
 =?utf-8?B?QlBDVmZHbGIrenJ5UWgwamM3VjlIS3lGdUkrRXB2SlNqTkd2Yjd5MGdLZWNm?=
 =?utf-8?B?ZTR3NlR6b1BpQmo0TGlmQksyS2RMbCtjRnFCNlhhRC9WeVJnQXl2QkJMc1RM?=
 =?utf-8?B?ZWdpckpCNXJYUTFBYkJHaEtjQXlVdlJHQ05WVzlaK0ZYOHFMaGxoR2F0M1R3?=
 =?utf-8?B?UVQwM3FwL05DNDlTWi9TaGFKbis1T0pPQW4rUWdyb1liUHhZTEIrcmRUMkY1?=
 =?utf-8?B?ZUJSSHczVGNmNVFZR1M1ZkladFF3K29aODBSL3lRUHR3R3VlTVhWRzNEdGRH?=
 =?utf-8?B?MC9vWllick12NjQrclQwMW1lU0tGWjI0Z3NlWXc5WlIxMERPRTV0STgvSk12?=
 =?utf-8?B?b2R5NVhybXdEd1B0OXd0NTV3M0Zibkc1d09SQzVHYytkUE5Damc5bEVCMEo1?=
 =?utf-8?B?b0cyZ2RXanB6QkpyZWs3WFh4bkxhejJoditCNjFqRHhJbzBGeVJnNVVQTTNk?=
 =?utf-8?B?aTVXdmJJS0xoNTdyVDUxUGFJTm10NzBoaUhaaVVLaGVrT3Uzc254NDFMd1Uz?=
 =?utf-8?B?Q1hlb29JVS9wWDU1T2R4M3haYnZKY2dyQmZlMzVuVmhHdzAwY2JqL2cxb0VF?=
 =?utf-8?B?MzlQaTlkcnpQa295L1VlN004a29sREVyR2x4ZFZVZGpTM1JCd096aEVxelVp?=
 =?utf-8?B?RW1LT3drQ2dEdm5ObXVJVjByVU16dUp3RDJRcWVCR2J4Z2V3dFhFSmQzMStC?=
 =?utf-8?B?dFNpaWZSVTN4WmNobTFoZHRYM2FxeUxsRWVjN1VlR3BmUlkvSG1LY0RWOU5a?=
 =?utf-8?B?Z0p5R25JcGIzTnY3SUZlMk56ajRKMEwwbHZUWHMvclJRWC9WQ3dyU3FZa3hG?=
 =?utf-8?B?WjhVZUNrMHFRNkQxcXh0MkszVXpQd0EyU0o1TUx3Y2lESzBlOGpkRm1HNzA0?=
 =?utf-8?B?dkJRL2lMY09HUUZrWWlBNHBPVUEvb1dJd0pzalc1Qit6ZjNmc29EczhkM0Zs?=
 =?utf-8?B?d3c4UHI3RGxESUxaWVEraXFqRFE2Znl4QmdycFdndVBFMjUwbzNhSkN0RTZm?=
 =?utf-8?B?SDdVaEt5bUxSb1gvcnFUdnNyejh6c2RzdzhUNUhrZWtGYnBEemhpSDV3UzFE?=
 =?utf-8?B?REE1eHVMQmViSE9WZHVHa1pJSzByb3hicnJyV0YyWmVSMlFTZFZnbnN6MTl4?=
 =?utf-8?B?WHZoQkM2TER1U3BQdDBnL0MycVR1emFjZkNiVXNwNkhGQzZXaURoK1RZSisr?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E455DF55398D3648B5F0619C8E7BA858@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ecb17bd-99d7-4342-f596-08dd96e8f601
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 15:22:25.9924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5i+24J8TSMfjWTtvJLs63DAiEHv+wDyARbkAfkSTrTjXVwK0nYhE1pqdxUS70HtFMm15H7D285kcENLKTPgrqXMiL+fRpUmZTS79xwME4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4687
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDA4OjA1IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+ID4gV2FzIHRoaXMgaGl0IGJ5IGEgcmVhbCBWTU0/wqAgSWYgc28sIHdoeSBpcyBhIFREWCBW
TU0gcmVtb3ZpbmcgYSBtZW1zbG90DQo+ID4gd2l0aG91dA0KPiA+IGtpY2tpbmcgdkNQVXMgb3V0
IG9mIEtWTT8NCj4gDQo+IE5vLCB0aGlzIHdhcyBub3QgaGl0IGJ5IGEgcmVhbCBWTU0uIFRoaXMg
d2FzIGhpdCBieSBhIFREWCBNTVUgc3RyZXNzIHRlc3QNCj4gKGJ1aWx0IG9uIHRvcCBvZiBbMV0p
IHRoYXQgaXMgc3RpbGwgdW5kZXIgZGV2ZWxvcG1lbnQuDQoNClllYSwgdGhlIGNvbnRleHQgaXMg
dGhhdCB0aGlzIFREWCBNTVUgc3RyZXNzIHRlc3QgaGFzIGdyb3duIG1vcmUgYW5kIG1vcmUNCnN0
cmVzc2Z1bC4gTW9zdGx5IGl0IGhhcyBmb3VuZCBURFggbW9kdWxlIGlzc3Vlcy4gQnV0IHJlY2Vu
dGx5IGl0IGFkZGVkIHRoaXMNCmNhc2Ugd2hpY2ggdHVybmVkIG91dCB0byBiZSBhIGdlbmVyYWwg
aXNzdWUuIFRoZSBURFggc3BlY2lmaWMgTU1VIHN0cmVzcyB0ZXN0IGlzDQpub3QgcmVhZHkgeWV0
LCBzbyBZYW4gYWRkZWQgdGhlIGNhc2UgdG8gdGhlIGdlbmVyYWwgdGVzdCBhbmQgZml4ZWQgaXQg
Zm9yIGJvdGgNClZNIHR5cGVzLg0KDQpGb3IgVERYLCBzaW5jZSBpdCdzIGFuIHByZXR0eSBlZGdl
IGNhc2UgYW5kIG5vdGhpbmcgY2F0YXN0cm9waGljIGhhcHBlbnMsIEknZA0KcHJlZmVyIHRvIG5v
dCBydXNoIGEgZml4IGludG8gdGhlIFREWCBQUi4NCg==

