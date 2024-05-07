Return-Path: <kvm+bounces-16940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7A18BF124
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 01:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D25D91C220FA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 23:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD8313C9C5;
	Tue,  7 May 2024 23:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3mDOX7N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C3080C07;
	Tue,  7 May 2024 23:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715122909; cv=fail; b=GazWSUIb60O8dV8J6KpALy4HptMnSK7lcncu5pqK1b1wkSL1VExJYDMUIQRBRlJ8QPeHkgk9L46rLdeSsf5IbUXn82Dk3lLj1bPIZpn44N98knrzFYQWM8F9P4hmJXhE4lpV+oZ+Ha/r0nYUAqnsOjLrcOMqxAoMRP0p7/8HYRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715122909; c=relaxed/simple;
	bh=clN56MK1tcG9WmbCmLdF15UWbF6BdvUt6fcECUrbG7k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L6XB9Wbr9YJ/KJoFPYlbZxhWZbECZ7w/eDXZ1rK7XzS0vzeizSWaWtvU2R1rBpwqsCfrUw6DFZxitA/1j+IHXL6k2nwR6P6ossndofU4UG20iPAGghm1cdkTZ3asI2rKUyBS2DFxUuG8CnVHJvVNRqgmwVcy0fvudQ65PXHciwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3mDOX7N; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715122908; x=1746658908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=clN56MK1tcG9WmbCmLdF15UWbF6BdvUt6fcECUrbG7k=;
  b=j3mDOX7NPcTREyKqmZFWn2RBbbbPpZUB56m/gnqfwEjgPYnhi8bfhPLQ
   wQjKWEEVs57t5tQpp4dmfMRjlhF64z601/PfuK+CsxFoutTx/etwd47gB
   +ZmY/AqRshiN+NZonNDbPlHVcEizInAlVlkOGxrhXpuxqyofkpsF+tO2i
   f0CHsNR/k6FMujA+APbxwLiyTn24XwegtQFURQzMV0DxQXw0OhiVMaS8G
   1jnC3taFxGGFuVZ5SinAaoMCD4A4ZafvStDhulI4+DTLMYNROHm3+iMPQ
   GcgDbZVKVGPCtq6hjBZebogRKGRQbk57o2Dqn3EXBGmoASXrZwbfKqn7h
   Q==;
X-CSE-ConnectionGUID: BwfcdyA8S56UaEUXejxHKw==
X-CSE-MsgGUID: Cq1fBbVeRU+MakRTCoxmoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10820329"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="10820329"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 16:01:46 -0700
X-CSE-ConnectionGUID: 5Tycql2GQZSnKMMogEWDRQ==
X-CSE-MsgGUID: H9Dlw9kDS/yCOmNvzdt1pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="28648291"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 16:01:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 16:01:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 16:01:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 16:01:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 16:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVV2HbN7xRIHCgzhSchHIKNvC9YHCyZn8m0ilgbHEBDwjbD+F7TW2b6/w1tVcB6XTx+GyvgNZTbuAox66F6gjjep03WB4HV0Otj6mwi1LUC/qW8eMFu4TYDLlv4U8TmsJdfrqkzHk8LcRz5tu46EVFzzFfThsHt7+C+SusmlP13JdPezDE73E2FwE7xw+z4/3NuBDNjJ/A+EsSK+51UNOEOO3EuzyI3LMN/ASBqeVQUjW9KYh6py3S8fLlifjAjIFyQdnLSoTce+olrobH8vp0PAbVSDL1PPSahUM5SDqfNiwwn5wpaAda7zdjYdjYQQZL8Ltz6oI0D0mZRNGu/1bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clN56MK1tcG9WmbCmLdF15UWbF6BdvUt6fcECUrbG7k=;
 b=YNmC8ZlYsNbSaRxmuUFrwL2W4PpHwZUm9sAP0O7ZCJPW+thnxAFIwTyjCm+0efWqlpdw1OAQlWRanZprcSjxrjaw8kvyQPQamAtvb3Fs0CdewmarFnq85h57Kj3BrJYYDXc38m8aesFiRcdWNGg3t4bvruPzoxa3CAVlMkshEgHhs6aX/6ka35nZ/mSEToAPfaxEseVMB62n+A8WUPK+5H+BfD2Y95WgLvfORRdxVoLob+NyfzXrw8Ov+p4EMRAu+lgYTjpWUkfobmRoYZ3t3+2OkE8+J+ErbI+0sSkgcn9Te9M3TwmtwexONiw1ZAluP2osDsjRLrmyRpEmYeJ3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7666.namprd11.prod.outlook.com (2603:10b6:806:34b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 23:01:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 23:01:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo
 features
Thread-Topic: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Thread-Index: AQHah60wsHP29hDi6kKJ9JlK2WL9i7FfKRuAgC1sloA=
Date: Tue, 7 May 2024 23:01:42 +0000
Message-ID: <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
	 <20240404121327.3107131-8-pbonzini@redhat.com>
	 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
	 <ZhSYEVCHqSOpVKMh@google.com>
In-Reply-To: <ZhSYEVCHqSOpVKMh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7666:EE_
x-ms-office365-filtering-correlation-id: 4062e448-0e61-4a50-7d5c-08dc6ee9a939
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MFYyVFIrRnIrMkQ0Zjg1cTBGd2ZoYmlveXVWdWVpTDhkTm50R3lCMGRMZ2Vj?=
 =?utf-8?B?aGxUTlhZdHRUNy9xMWxtWDRiMW5zVlJhS3Mrc2xKbkVKMUpJckNYa3ZsR2po?=
 =?utf-8?B?NGh3dFMvbmlLZzlsTTYwekhDbnEzcXVNd1c1MUZJSEoxUHZWUEtCQUhqYkls?=
 =?utf-8?B?RUZNN0N6MHBOVlJHT01qbmRnN2w1UE1ldVprdmdGL3paT3pFTHFuL2RLWWl0?=
 =?utf-8?B?RFkvbFNscGV5UmswbnFyaTQzM3RZQ1BwUG5nZmtYcTJsd2xrdXpPYVFNb254?=
 =?utf-8?B?NzQ5cDhyMkNSOWJOQnU1SjhwdldDT0FKU0RxVkVoc0oxNklmM3A2Y0dyMTFL?=
 =?utf-8?B?eTdmMUNrQ0hGT01CRWF1c0xYZkQ2ODNGZFVRYkNnTkFmdUJMT1dvdnlYeEhW?=
 =?utf-8?B?dDA2TnRnendyaXdZb1YyUDJUNXgvQ2YyajQvbHdLa0ZLSE9wS2hrUVE0M0Nx?=
 =?utf-8?B?aGJpeGszdnV4b1h6bEtQY2Fadi81K0lSYytXNExENnJ0bmpjenpMUHcxYnpQ?=
 =?utf-8?B?V3VVYjhyb3JjZ0Y4U2NjaEw3OHVtNzVkTVk1QUJqaXhNWkdnZXZXdmNaNlVu?=
 =?utf-8?B?U1NXcWFOZWRWeFlhU2VRMSs2VU13K2RTbi9QWXJOcmdHRzhMSU1WVDI0aXJI?=
 =?utf-8?B?RTQ1TWtDeXhxUnZsWS96UHhQNWtqRU8rb1JkRWd1UXdMTlB5YUNqNzZRZTh5?=
 =?utf-8?B?bmVyTks4Ym1QTXdnUTQvUitJeldYSWc3SGZNVURTclZDeTV2VXdiZkdTV2xK?=
 =?utf-8?B?MUM1bmdxRnVNRmw0VEhzVDF1VzlhMlBxVEdyTm5FY2ovREJTQlRWeHZ5clM1?=
 =?utf-8?B?TFd6NHhOWlJQc2RMOUIyZm1EODZxVXljUUJpYXEraHF5M0JKenhpMWM3Vkpy?=
 =?utf-8?B?RWZ3MHgyWmR4QU5vT2ZUTm5FOFBwMFR6U3o0N3l2NDVZa2hPR3M4U3FDY2lL?=
 =?utf-8?B?dU54U0ZIWkU0ek1QMHhVSWpZcDNkL1NjOTByL0doek83Mmx0NTVKNWM0ejlh?=
 =?utf-8?B?ZXFONVF2MGkxTWdGQnViVWpRMWFDSms5SXRvVldRMy9aRGpVVEc2YlFJSmFN?=
 =?utf-8?B?UEpjblYrLy9xV2ZyNmdZeU9rSUVOaEdPSHBjVFFpK3VQL3ZZa1JFdXdwbk5C?=
 =?utf-8?B?cm9VTEMwUThwb0NiUDk3QzJCYWF0VjV6c1BwRHdGd3c5TFcvWmxCUDhFY254?=
 =?utf-8?B?S3RKWHNDY0RLYkJtcytoWnMxK3lzcTlFWE1wNVVlWFhBMUlNZXJTSDZXcDBk?=
 =?utf-8?B?OVQwWXlZWXF0aFdkRzM4T0ZkV2w4cm1qbS9waE00aWZYQ0ZvWGllaVVTZGMr?=
 =?utf-8?B?dVl0RTJ4SVlubS8yUFNTRTVsOXpOKyt6RGhyK21hcjNuK1l5T0hXMlIyU1Zy?=
 =?utf-8?B?M2xSWFdSeVVtWHYydUJrVldyWjRrSFIweUF6b1lJOUZBbjdOREkxVStlK0h3?=
 =?utf-8?B?YVRBc2xVS3IxTVgyU3NtN1l5bEhsRml3UmZQMUdYU1pkZTBaMDlxNHh5WUNV?=
 =?utf-8?B?UjF2cVIyZ0MrOXJjMXhFVll0SU1pc3dxQWdETndiZWZPSHdNSndjT3pPVVB4?=
 =?utf-8?B?MWFuejBTR05hNmxMeml4aFFaTzNHanE0a2pWL0RNODdqZ2lkNHNiMUkwRnFH?=
 =?utf-8?B?NGRCM0Z0RnphMkp5ekxDbEFGbXA3a1NGL0FSNEhrbDRYSGtQWWVwL2p3VFk5?=
 =?utf-8?B?bG9qdmY0T2NlakxXZHF6MlBzQ2dSaS9YNjVjeGVVWXpXbHRrbXJDRDV3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2NpQ0RncE5la214Q2U3aW5OZzNwNU5CanRpd2ZXUklKVkErNmxPOU9HZlkw?=
 =?utf-8?B?TnJHNWtUaENXallkSG9ORlVXeWRZb1N2cTNXbmtuUFExU3NzaHgyUkdEMU4x?=
 =?utf-8?B?ZjdPV3htbUF5ZnErSnJOUXlFTEc4OUdOalpOVzZDNUd5a3F1Z2tsbVQ3b0RP?=
 =?utf-8?B?ZStQYSt5a3Y3ZGJVd2NQREd2aytCNDN2Nkl5bUc4RzR6NUtTc2hZWExEblIr?=
 =?utf-8?B?SHJHY29JTncrZWtFUndYcm5ZK1Q4R0I2RzhCenNoMkk5MStneDVidHlNajNl?=
 =?utf-8?B?UkE3UUZ3RUhSNDF5eC9HWXkxcUQ1dHZsemRHZ2VpUkxQNTJMdjlKaVIyS3Bl?=
 =?utf-8?B?cmJIQytuYlBoWXpSYTJkMmhuNWViREtneEtycTFlSzlQc0ExNXRUdTdPYUpr?=
 =?utf-8?B?MEgrcDJQTTJ2UTlJSHprMEVjS29SVHhzT0NWRmV1ZW9DWU5ZVEhITHIyNW9X?=
 =?utf-8?B?cEJ0VkJZYlFraVl0bkVvczU5UkFkKzNYOThiY0d3YUhlakU5aWRHZUNqZGQ4?=
 =?utf-8?B?aXlWY2RndXZoZ3NUNjFOR0Y3WDYxM0YwMlpxRUtJYWY3aWt4OVhPMG5mVW1E?=
 =?utf-8?B?b3NtbkVTZVgvUzFQNVNiOFRwS25BMFVPWGNXd2tSVmRJSGtxZ0VIMWM5YkZT?=
 =?utf-8?B?QzIrOGhhV3gyU3Z3N1dVbDBpcllVeE45enNsN3A2bWVoeEtjaURYblBub0ZN?=
 =?utf-8?B?NGdPRks0cC9KZkFMaXlCemxPZnczM2swY2tZa2VSUWJ3dEd3Rlg1RFVxeVpp?=
 =?utf-8?B?Sm9HUGY5VFg5ekhYWGZ1a00wUGFZTVdCT1l4Y1FOTXJuQkNiRnBDbGh1dzJl?=
 =?utf-8?B?UUcwaVpmdlpJbDk1TEZ1VUtOQ0dGa1ZUN0NzS1BSV1RFL3JBRFRyQkx6Rnd0?=
 =?utf-8?B?L2Nrb0tWNm1XaTI0NTkrOUlOZDNVMi9tM2pSVExUVkM5OG9rMVFQRnJSczl0?=
 =?utf-8?B?TUU3RXRVL1ZzdWkvL1ZJdmo5djBGS3BsZU1lMkZ0S1ZOZS80MTEwM1doRlE5?=
 =?utf-8?B?Y0RVbXFrb24xOG1NYWl4dk1zUlhPOVRUeUlWMS81ZVNQTmJxT0JqZDh6cDNQ?=
 =?utf-8?B?Y0ZvQ25DTlVNWnNGZjBrYWRoZUVjV2N1bXhOTnowcEk5T1dpOFN3aU9wVUhm?=
 =?utf-8?B?Zk9TTnJJVytEUTFiNVg0L1Q3bmpzYXEyeFdKWm5MbmVPeUJuKzZuZWlxMHor?=
 =?utf-8?B?N1pCQkRwWjNMSEI5cjRTbjJFaHk2REphekZ2SkdjbXFoU0JXZGpvR05mWHVE?=
 =?utf-8?B?NnVMY2tGU1pnbUczRFA4eU9xaFZndUc2eDVuODU3MGpjb1B1VllHQXg3ZGli?=
 =?utf-8?B?QkNxM04rajc5WmY4RGIzbWJVV0tGditibjQ1dWNrSDNDSXY1UCt3bnJ1bnk2?=
 =?utf-8?B?TzVLcTMxZHZ3L0NYQmhLQlYxbXdMWFFBNUlUM2ZYbzd4RFJUNjlMWW9OMlpn?=
 =?utf-8?B?V3MzVjFjOWtJRWorSFlsSlFlVjJFOEdLbUpiNUdLcUJjTW45eS9xQkZac2tB?=
 =?utf-8?B?cWQ2N3hja1QySkdTMkZ5NWREeCtWQTJyaDdlSHFjYXZpNlRacFpnekFtME9Y?=
 =?utf-8?B?VHBGQW4yT1U5TnFBRG5CMHJHbEpQWDRyZVdvV0R5MTV0a2NCNkt5WDhXN01U?=
 =?utf-8?B?QlJDQUJ0Q1pxQnJRUE9Ta2F0Vk1lb0V5WWNXVUZ1ZERJSm1KSFJPeDcxb2RF?=
 =?utf-8?B?Z2c3TVNxVWkrUjQ5QkdxOU5pVGJweEZoaE1VMWQ1NjNmR2xtd1VZZkkxNldY?=
 =?utf-8?B?QVlhSFhSNm9yVXZOUjljRjVSN0FsL2lFWHBadDZzTXJCOSthUWtsekJTQk5B?=
 =?utf-8?B?YUFpVlg3R1VFR3oxSUgxVG45WTdRZVcyclJKaVUraStrYmhCUjB6Zit5NlJ6?=
 =?utf-8?B?ZURISU03aENRSGVQV0k0RXk0VGlVTjlWRlJsQ2NLS1BUSlpBVnIyc055TWNv?=
 =?utf-8?B?VVJyM1pSUDdFSDNiRUtRN0FKVjZrYS9GR0NYN2JKdXRBYUh3T1pMdGJsM1dR?=
 =?utf-8?B?c0Z2QlplTU56ZTVDK2cveXo1dlJLcTB3MVdXaHFtM0ZzMUdCVkRTeFZOS0x4?=
 =?utf-8?B?RXV6d3RFKzI5cnJ0c2RmamxIVWh2UDJ3cjhVaTRYeVNtVTZlTkVGTkFoMzRn?=
 =?utf-8?B?OWRWUmdXUEpqSjkzWG9SaHFRMmtFc3VtcTU0NlhJUUZOK0E3KzVjeTZaWTFV?=
 =?utf-8?Q?luJ52L+gCAM3tHvCRetiSFU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED41090F88569D42A8A76E17BDFF4378@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4062e448-0e61-4a50-7d5c-08dc6ee9a939
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 23:01:42.4984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j20maJBI/1uMQXLcphRTttZJlv2alb1XeHS6s0pzhQx7OK3g4eoY3yjbesD2+crQm3fm7Ck35Gfmt0GMAJljIzLYOhMo7+CtuyHElwhJxZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7666
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDE4OjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IC0gR2l2ZSBvdGhlciBuYW1lIGZvciB0aGlzIGNoZWNrIGxpa2UgemFwX2Zyb21f
bGVhZnMgKG9yIGJldHRlciBuYW1lPykNCj4gPiDCoMKgIFRoZSBpbXBsZW1lbnRhdGlvbiBpcyBz
YW1lIHRvIGt2bV9nZm5fc2hhcmVkX21hc2soKSB3aXRoIGNvbW1lbnQuDQo+ID4gwqDCoCAtIE9y
IHdlIGNhbiBhZGQgYSBib29sZWFuIHZhcmlhYmxlIHRvIHN0cnVjdCBrdm0NCj4gDQo+IElmIHdl
IF9kb24ndF8gaGFyZGNvZGUgdGhlIGJlaGF2aW9yLCBhIHBlci1tZW1zbG90IGZsYWcgb3IgYSBw
ZXItVk0gY2FwYWJpbGl0eQ0KPiAoYW5kIHRodXMgYm9vbGVhbikgaXMgbGlrZWx5IHRoZSB3YXkg
dG8gZ28uwqAgTXkgb2ZmLXRoZS1jdWZmIHZvdGUgaXMgcHJvYmFibHkNCj4gZm9yDQo+IGEgcGVy
LW1lbXNsb3QgZmxhZy4NCg0KSGkgU2VhbiwNCg0KQ2FuIHlvdSBlbGFib3JhdGUgb24gdGhlIHJl
YXNvbiBmb3IgYSBwZXItbWVtc2xvdCBmbGFnPyBXZSBhcmUgZGlzY3Vzc2luZyB0aGlzDQpkZXNp
Z24gcG9pbnQgaW50ZXJuYWxseSwgYW5kIGFsc28gdGhlIGludGVyc2VjdGlvbiB3aXRoIHRoZSBw
cmV2aW91cyBhdHRlbXB0cyB0bw0KZG8gc29tZXRoaW5nIHNpbWlsYXIgd2l0aCBhIHBlci12bSBm
bGFnWzBdLg0KDQpJJ20gd29uZGVyaW5nIGlmIHRoZSBpbnRlbnRpb24gaXMgdG8gdHJ5IHRvIG1h
a2UgYSBtZW1zbG90IGZsYWcsIHNvIGl0IGNhbiBiZQ0KZXhwYW5kZWQgZm9yIHRoZSBub3JtYWwg
Vk0gdXNhZ2UuIEJlY2F1c2UgdGhlIGRpc2N1c3Npb24gb24gdGhlIG9yaWdpbmFsDQphdHRlbXB0
cywgaXQgc2VlbXMgc2FmZXIgdG8ga2VlcCB0aGlzIGJlaGF2aW9yIG1vcmUgbGltaXRlZCAoVERY
IG9ubHkpIGZvciBub3cuDQpBbmQgZm9yIFREWCdzIHVzYWdlIGEgc3RydWN0IGt2bSBib29sIGZp
dHMgYmVzdCBiZWNhdXNlIGFsbCBtZW1zbG90cyBuZWVkIHRvIGJlDQpzZXQgdG8gemFwX2xlYWZz
X29ubHkgPSB0cnVlLCBhbnl3YXkuIEl0J3Mgc2ltcGxlciBmb3IgdXNlcnNwYWNlLCBhbmQgbGVz
cw0KcG9zc2libGUgc2l0dWF0aW9ucyB0byB3b3JyeSBhYm91dCBmb3IgS1ZNLg0KDQpbMF0NCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIwMDcwMzAyNTA0Ny4xMzk4Ny0xLXNlYW4uai5j
aHJpc3RvcGhlcnNvbkBpbnRlbC5jb20vDQoNCg==

