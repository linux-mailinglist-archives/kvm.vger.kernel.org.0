Return-Path: <kvm+bounces-12295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A3388119E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0324E285610
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3E23FBAF;
	Wed, 20 Mar 2024 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNXSuk+B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEDF3FB85;
	Wed, 20 Mar 2024 12:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937501; cv=fail; b=glI1xsDL1JvETCvAQ8spJ5SZpXAMXchkooQ8x+0Yqo89P8XXH3W4b8mPQYyCx8nL2TN7nVRcqd0inrnLGwMtQt8H6Ze1l3Ncp6t5oqdaZYgGEUu9q7IOuj1OO8/3478vuWaNrBChQ56TlA5gKRkC8ylXDB/wGArKSiqAh0RDNS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937501; c=relaxed/simple;
	bh=dBCCUkB0mjK1YVzLV+3FFOcLj+hmMm4W0tHBrMpQKwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JP1P9yXqlTCiMwZ056vqF60aen0MasJ4pMQc2O/oVdINBwsZY9kKfpdbwoIC3tWyt/u8gZHi9EdRraMuENeywx7BCSP2m+JVLc6bEvlR1aUDqyAvzS6wESVvl4DJ7Kcj3fX9PpluoGcEuVYU9sgubOXFZck7nrEkp4KGY6vLD+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FNXSuk+B; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710937499; x=1742473499;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dBCCUkB0mjK1YVzLV+3FFOcLj+hmMm4W0tHBrMpQKwU=;
  b=FNXSuk+BTnQeALMbAhJGqPPrCJF92xEBol1CRDv5Zd+Bs62qwwcr+MVy
   XO7Dt6N2fHAi7oui0vDSVokIH/0i8OJocCyoXZXV92glQvJhC5u5YNJOw
   P3UB+qTJQuvq7AJOJKATmjl54D3BbEfAqOxhbVr/hsEo8FCBLgMb7e/dT
   uQc7pzQ4pVigtjkFffMRG945f4D2RQascHp2qnElT7wOCnmwzaYWGP+oM
   CZXg6SaGGOOgQAGIkGoWiNX+lypetqfbZqg3aNDlJm5CdFfNcyrRJsq8l
   orhYAfpjTPbV1PpsR8fuivpXyr6ll5UmmJDkEfkPpblXRzHvKeoo8OEzq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16400705"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="16400705"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:24:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14116482"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 05:24:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 05:24:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 05:24:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 05:24:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dn8GaF91pupTPtqWPwJ3D6HXdPznrTX4RaBemN5jwoz2GfUQzWaeA0Z0mCbzAw4vtssomgMNyI+rsIGPg1spuWBQlQJUtHiGC2RiWTOpecPZia9s+wdyVNs/gzZA96andsZaSvxNgz0GkFHWlrw52fibrRlVR4OapWq7DLGG5mxqmwW0if/uaN+E9uEQ2Sm/uip/0X5wnZ+KPkCBYWdpwdLpWq3eCssfaM1sdlHHs9rl+Yrv99kcrIQNHi2KtC2vSP/MPzxBFWe1VYZAuBjIIrjw21C9tx0w1JgDpBaB/zV2ipBpKIGseAn09Gy9IVV3kcFP4uJTJuSJEE4jqsS1cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBCCUkB0mjK1YVzLV+3FFOcLj+hmMm4W0tHBrMpQKwU=;
 b=YA7ZF9PZ9dpFsLle2yOupEN4Qgbi+xAl+65EacwEH/zpYfL5x5lNtm0oJwBIbM90JUspv5UV1WPrqazdP/KS7t6nw7orkGlkqFJX3GJhj3ysx9sev7Aa10eNiMz2j/5hFvckYVOHw1dmXqWl/9V+2CajTA6m2px4QcQOhVwcBht9tJw3roStVU5MFZAqL9YBE+CKEh7c5VjOS0ay+yWPNb4r7l+1hWFaTlOdTKMwv4UeWv0/klq+PIJeuCx2C2VZab/WAoCiyte/45iNVARuDcj2KHeFOxGe2BooZIsaS+Qa8Q3vw5GXC42m1a6wAPpDho1QDezE7aOSpOZziNfWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8157.namprd11.prod.outlook.com (2603:10b6:8:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 12:24:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 12:24:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "jgross@suse.com" <jgross@suse.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHaa8JL7v9VUJLZkEWqE5TMIeieHbE5oCiAgAcLigA=
Date: Wed, 20 Mar 2024 12:24:54 +0000
Message-ID: <a10578487c36a4530d880d4988734d9097e34979.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
	 <20240316004945.GL1258280@ls.amr.corp.intel.com>
In-Reply-To: <20240316004945.GL1258280@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8157:EE_
x-ms-office365-filtering-correlation-id: b29c0f27-b277-4441-5872-08dc48d8bfc4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ma6Va0UbcUfDqD29cmkLJGanA3HxVpnqcXSCxNFVOtCUUdjWBRY/trfLlT6ZMyleeVPzrOs7Ebo0/sBI0UZoO6TlnPXP7gWASrTcG04EI8ts5JclwavCD9Rx8vbuVQElJyRveapN0yVo+k+kRm1tAxGZE/5N7aVPkTKSffLUlN3BKIOvmOsq+bNgXRW9Ea2C9vt8AfT8Qr5c4LMDQolEBSE7Jo8dxiTqttkwXoM5ZMBtx1kiWi5UigOW0jLPOPZ7XIxhIf18wb9tf6LnUk1fSQINr4buVOoryTTNjM4WzaOctYEKAEr/RBdgis1uo3aNJGwk4JYSK9ek3fzYX7j4ox2Q1hlLkR4yZM634o85X2DCxJbFaU3atTlHl/3JDRBBxP0uQrTsPO7tgIpPfXMBYb+ZLHLteuwU3hegNuLX0zRuSOylGI4v4f3wvuPEr+LxzBYXHGz9wAiz4Rx4xuJIb2IS/6j/gqxGmryBP6sqFul01BOmySzaYi1CB0qo6kaC5MpamKlPAVY7Jc/Pqwgjzva6zumjZuHJNdVl0Btb+b38UoNHrBaRCaaxQ63oRHS2MqScOu1XlVvNxW7Y3eoTSN6UzKISnyQfGP6WDBPzfWK8YbGPb58N1LZkT8VHG8jDVkLMkxeDs4G/Ms15u2qK/L5+5tJwJ2Wm8Jp0EYDDpXPNsP29Ln3BzM+Ak7BQzYtSd8Iskoo7C35hibK/Ngnep3AFq30hZn3fyJW9BwXObzY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlpLb2VpbWpwb3FHdVFBQWg1blBvNzVmcHZDOXlPcGF3TTAyZ2Z1ZzM5NEdo?=
 =?utf-8?B?ZW5VeUozTys1T0ZUU1Q1dHlHNVY1OVl1NUpXWDJ5Q241U2NJMjFDN1lxUDhS?=
 =?utf-8?B?R2tUckVReG90emRGSkFCMFkwMEE5aWRLVE82dlNiL1Y3Slc3aU1OWW0zeW5L?=
 =?utf-8?B?Y0U0SjNzODlnV1V1WGFzSUh5MUJBR0gyTHhRODBUUXJiME5xc2VzYndUbXFj?=
 =?utf-8?B?TEE1ak43NDZXVU9Xak5XemtVY2U0cnF2UE44OEhRVjlvL25vM1cwR0w2WFZ0?=
 =?utf-8?B?Zlp1WUpTNkVFOFFFVCtwL2hQajIwRVJqalVaWVJaY1ZGNUJtR3kvYjdLdG1w?=
 =?utf-8?B?UVlGUG14cGJ3U2FkN1IyWHU0Tm5MaHJ2SkppWTNOM05tS2QvdndOcGV4aUc1?=
 =?utf-8?B?bGRVaFBtNVd5SGsrTVQ5eWdHelZvbmJuWlJrM1VOdDY0WE1Db1dMU01jUjli?=
 =?utf-8?B?dFhGTnNBcW4xbDVlN1RVYjEyZXhHNklJMjh4M1hmR0lkUmVMczBuN3JQVFY4?=
 =?utf-8?B?dUhhS3lucVF5dXlGYWFIS0tUZlZYWE13VWdoMVVOd0UwVHJCNTByWjJzTHRp?=
 =?utf-8?B?L3JSdlAxemZ5czZ5MWJqUlpsWDVMNzUvVW9OOXFFS1lobzlpOVlyZkx6dEd3?=
 =?utf-8?B?VUR4WkVUZHp1SHBnMTdBQ1NDNkJsTldXL0QvaHZzTUdKamo5YXBncklKaFp1?=
 =?utf-8?B?bzFHSnpjdFZiVTl6U2lOOW44QWNlbDBaMmtaYXhzSDdiWWxZZDFrdXFUMkVV?=
 =?utf-8?B?RjViTHEzMEZ0TURjTEg3cTZ1d25VeUtmZFhDTEtJTHU5NGh5UzBuL3NvZWJk?=
 =?utf-8?B?MnNGNWxrOUw4dDdFL1pFM3V3UWlPamV3ZW9ZUjNVSkVMTW1ybkpBRElONjYv?=
 =?utf-8?B?aDdTdE1hbWdBUFlWMW0ya2lDVXB5MGFaSE9hRVlubXprd2VTUWg1Z1h5WE45?=
 =?utf-8?B?RWlvQnd6M3ZiUVhxYUROZW0yMlpuNWZxc3N1UlVOeDBXNC9GN2UzOWRvZzY3?=
 =?utf-8?B?YmJ1N1lLTlBCWFZmTTJmV3NOcmVyWExPcFFQYTlqZ3RQYUVLcS9uMlQrN0tF?=
 =?utf-8?B?dXRLU3JlTzg2RWwrdXlXSitYMWsvWElxVWdWdUZOQkpQZkx6bEEyMWg2Y2xo?=
 =?utf-8?B?SUVNUTJucXBpSDhyd1h1SW9NbHVJUzJKd3NkU2ZKNjVyK3hKM1dTOE9sdDlj?=
 =?utf-8?B?VitiRG5JMmt1QWR4dHRjeU8weGF4dWxJRGgzdkpVNE1qMXpCbzljNURqNUZV?=
 =?utf-8?B?djdYcHJYai9tWjVIU1RrUnBQbXVVNzluMytJNE94bmJEcm1vSE00Zk52L3Fk?=
 =?utf-8?B?K1pmWEdSWElCeXhzRXBtWmhmelJ6aGFUMm1YWmRsckFkMXIyZUlSSmtHd0NI?=
 =?utf-8?B?cW5QSUN2M2JhdURhV1duQnJtbDJUN0VEL041bmpGS0MwN0R6ZUdJVWkxVWIw?=
 =?utf-8?B?RDgzSEpwaVBJaW1VcTV2M250WU80djR1QmRnYTBVVkxxMlg2VkNhZVVnN1NX?=
 =?utf-8?B?TWJ5OXpRcDVTMkQrRFdJMU1KVFJUOFVaOFR4dnlRYXFiczhtZnVxL2xnSVpV?=
 =?utf-8?B?MkEwZzNsUEE0eXVuWEJlUm5QZDlBZ2lyZHd0TFFTNmN1bVlzSEJYUHZ0K2U3?=
 =?utf-8?B?S1pYQkVLcEoyN0VsMHBwckhHVFhuRk04SHk2N3JlM2xHVFl1NGRocUVZQ3Rj?=
 =?utf-8?B?TGt5U2p4bGlwb2JJQmRyb2lNeFYyS1d1bHRIeFdDcVk0L1lyVWY0Qk82ZnYy?=
 =?utf-8?B?UlNUUE9DNVR1Mlh4dXZXQ0ZCY2ovRlNId1RzcVYrUEYzdVJtNE96KzlUMEx2?=
 =?utf-8?B?K2VaYmRhMGFvUHk0VjFwc2g2bXYwQUpyZnJ4bGJkeitmSTdWYm44UW1iUVhU?=
 =?utf-8?B?TS9XSzZJMGJtZTg5V1g5YzNxMmxNTU9vSW1VQjNrQW9ycGl2bXZibkxGSVVB?=
 =?utf-8?B?T0xiT3FWQVd0OW0vQXN3aGc1SGJ1UE5oOGsySk5sRy9jNGRVMFJkRTlzMEJL?=
 =?utf-8?B?WGN4NUpGSnFHNjNLT0FaWHpHWXNZcENRV0E4b0RPRDZ2WjZ0akl5Ri9yWFli?=
 =?utf-8?B?b1MyWmt5Z1FRd2dnbjNNK096TThVTXF1NFMxSjdPYS9RZDE3Qy85R29hcHh1?=
 =?utf-8?B?cTU2c21vSVhycTVLQjhKSUx0N1doUnZvMDYzQTBIRG9rMHgwb2MyellMckIy?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2149B23C7CD49A45BAE81664DF7CF758@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29c0f27-b277-4441-5872-08dc48d8bfc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 12:24:54.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0/qH9I/45Ih1hkLla8LsRvKWfqvlV57GxFOiDXP67EKBDv/mTmG/IKQMWixcL0tl6mIcUjipZKfnKrRbsOVew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8157
X-OriginatorOrg: intel.com

DQo+ID4gQEAgLTI5NSwxMSArMzA3LDMwIEBAIHN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFf
ZmllbGQxNih1NjQgZmllbGRfaWQsDQo+ID4gIHN0cnVjdCBmaWVsZF9tYXBwaW5nIHsNCj4gPiAg
CXU2NCBmaWVsZF9pZDsNCj4gPiAgCWludCBvZmZzZXQ7DQo+ID4gKwlpbnQgc2l6ZTsNCj4gPiAg
fTsNCj4gPiAgDQo+ID4gICNkZWZpbmUgVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBfc3RydWN0
LCBfbWVtYmVyKQlcDQo+ID4gIAl7IC5maWVsZF9pZCA9IE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lk
LAkJXA0KPiA+IC0JICAub2Zmc2V0ICAgPSBvZmZzZXRvZihfc3RydWN0LCBfbWVtYmVyKSB9DQo+
ID4gKwkgIC5vZmZzZXQgICA9IG9mZnNldG9mKF9zdHJ1Y3QsIF9tZW1iZXIpLAlcDQo+ID4gKwkg
IC5zaXplICAgICA9IHNpemVvZih0eXBlb2YoKChfc3RydWN0ICopMCktPl9tZW1iZXIpKSB9DQo+
IA0KPiBCZWNhdXNlIHdlIHVzZSBjb21waWxlIHRpbWUgY29uc3RhbnQgZm9yIF9maWVsZF9pZCBt
b3N0bHksIGNhbiB3ZSBhZGQgYnVpbGQNCj4gdGltZSBjaGVjaz8gU29tZXRoaW5nIGxpa2UgdGhp
cy4NCj4gDQo+IHN0YXRpYyBpbmxpbmUgbWV0YWRhdGFfc2l6ZV9jaGVjayh1NjQgZmllbGRfaWQs
IHNpemVfdCBzaXplKQ0KPiB7DQo+ICAgICAgICAgQlVJTERfQlVHX09OKGdldF9tZXRhZGF0YV9m
aWVsZF9ieXRlcyhmaWVsZF9pZCkgIT0gc2l6ZSk7DQo+IH0NCj4gDQo+ICNkZWZpbmUgVERfU1lT
SU5GT19NQVAoX2ZpZWxkX2lkLCBfc3RydWN0LCBfbWVtYmVyKQlcDQo+IAl7IC5maWVsZF9pZCA9
IE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLAkJXA0KPiAJICAub2Zmc2V0ICAgPSBvZmZzZXRvZihf
c3RydWN0LCBfbWVtYmVyKSwJXA0KPiAJICAuc2l6ZSAgICAgPSBcDQo+IAkJKHsgc2l6ZV90IHMg
PSBzaXplb2YodHlwZW9mKCgoX3N0cnVjdCAqKTApLT5fbWVtYmVyKSk7IFwNCj4gICAgICAgICAg
ICAgICAgIG1ldGFkYXRhX3NpemVfY2hlY2soTURfRklFTERfSURfIyNfZmllbGRfaWQsIHMpOyBc
DQo+ICAgICAgICAgICAgICAgICBzOyB9KSB9DQo+IA0KDQpIbW0uLiBUaGUgcHJvYmxlbSBpcyAi
bW9zdGx5IiBhcyB5b3UgbWVudGlvbmVkPw0KDQpNeSB1bmRlcnN0YW5kaW5nIGlzIEJVSUxEX0JV
R19PTigpIHJlbGllcyBvbiB0aGUgImNvbmRpdGlvbiIgdG8gYmUgY29tcGlsZS10aW1lDQpjb25z
dGFudC4gIEluIHlvdXIgS1ZNIFREWCBwYXRjaHNldCB0aGVyZSdzIGNvZGUgdG8gZG8gLi4uDQoN
Cglmb3IgKGkgPSAwOyBpIDwgTlJfV0hBVEVWRVI7IGkrKykgew0KCQljb25zdCBzdHJ1Y3QgdGR4
X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcgZmllbGRzID0gew0KCQkJVERfU1lTSU5GT19NQVAoRklF
TERfV0hBVEVWRVJFICsgaSwgLi4uKSwNCgkJCS4uLg0KCQl9Ow0KDQoJCS4uLg0KCX0NCg0KVG8g
YmUgaG9uZXN0IEkgYW0gbm90IGV4YWN0bHkgc3VyZSB3aGV0aGVyIHRoZSBjb21waWxlciBjYW4g
ZGV0ZXJtaW5lDQoiRklFTERfV0hBVEVWRVIgKyBpIiBhcyBjb21waWxlLXRpbWUgY29uc3RhbnQu
DQoNCkJ0dywgaWYgdGhlcmUncyBhbnkgbWlzbWF0Y2gsIHRoZSBjdXJyZW50IGNvZGUgY2FuIGFs
cmVhZHkgY2F0Y2ggZHVyaW5nIHJ1bnRpbWUuDQpJIHRoaW5rIG9uZSBwdXJwb3NlIChwZXJoYXBz
IHRoZSBtb3N0IGltcG9ydGFudCBwdXJwb3NlKSBvZiBCVUlMRF9CVUdfT04oKSBpcyB0bw0KY2F0
Y2ggYnVnIGVhcmx5IGlmIHNvbWVvbmUgY2hhbmdlZCB0aGUgY29uc3RhbnQgKG1hY3JvcyBldGMp
IGluIHRoZSAiY29uZGl0aW9uIi4NCkJ1dCBpbiBvdXIgY2FzZSwgb25jZSB3cml0dGVuIG5vIG9u
ZSBpcyBnb2luZyB0byBjaGFuZ2UgdGhlIHN0cnVjdHVyZSBvciB0aGUNCm1ldGFkYXRhIGZpZWxk
cy4gIFNvIEkgYW0gbm90IHN1cmUgd2hldGhlciBpdCdzIHdvcnRoIHRvIGRvLg0KDQo=

