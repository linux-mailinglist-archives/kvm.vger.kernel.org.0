Return-Path: <kvm+bounces-53707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B03B155C6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A73D93A7CF9
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFED6284B46;
	Tue, 29 Jul 2025 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XaImTeS5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863101F8725;
	Tue, 29 Jul 2025 23:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830882; cv=fail; b=umJk+7P7N9q5T9aQepvcGAVcWIAwscK9lkUJkxekBC8Dba9iOW8fQDkCQOooilX88fQHRyUm6aXmWrwPWvH60ufMiyRT2bDptIJTVU7COMlp+7aFMWrRHYdLluJdN9dvT64+gh9W7yVrcg0Kq6N8MUKb7vm85QhutGpTmCiIlt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830882; c=relaxed/simple;
	bh=o09Lqxz8gU2ckEQ1alKqkxVzLZCbj7IIzYaQyT7aw1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bVq0HALZ4Cf30t3Z2UdJIihEVSZOQrTkNO+GaXxcHOTObRksSOBtxMW9HXJireuFWVhuiHvoQTtCjitz955LGp0WkINDoRUXOOaVxp/jMMd3tse3eAiZujfDao1tBNQVCBDffGpJpDioMRBqjC3BesSXFuYzEP9hvbEtIB5hiFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XaImTeS5; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753830881; x=1785366881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=o09Lqxz8gU2ckEQ1alKqkxVzLZCbj7IIzYaQyT7aw1I=;
  b=XaImTeS52lJPEN1haSRfR+tqrv6KcirBO1wrnbTW01+7ioSMUnrEsROR
   K3U9rZl8+ou/QDqfxbgPcuFkzq+YDBELvyfJeyhHR9WYo4iK/uoisnOaE
   fTNTlbtDDVbYLA/tDqV5oUwWTPJ02D3Kmt0TzLE1Y65usnUg0V+/TkZcW
   NSTt8Ryn35kgsevyD61AD9LTawgWaqzmq+V/8Z7TLb1jyCrCZGUaWVxJo
   mOnRKKUoEB4w1sTIMmmkNiDm+T8A2q38fYm+YdjAH4jn4zaPL63yRU/iB
   XAbF9CdkTFLfNNxDRqYNLtXAfBzkqsdNzd2bAsIEzV+oV03hUQd8ixnxJ
   w==;
X-CSE-ConnectionGUID: aE6I08y5ScGG3H6xvP3bgA==
X-CSE-MsgGUID: U6xFWYKBSPmtpZt1hXBEeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56267825"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56267825"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 16:14:40 -0700
X-CSE-ConnectionGUID: ffHGM2/WQuicFoDJq7wXEQ==
X-CSE-MsgGUID: 8pHldXULRvGKznkjw2wrpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162550392"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 16:14:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 16:14:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 16:14:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.85) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 16:14:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5TQYB72rV+BA9Lh2Y/2xbP8I3ZyPTjTrjdCN5zbSyhTUyVM0R6qsPGZtD239O4gKLIURbLxKw7/N5+Fd3DuaHdATT+oVPgzRrKnWU08AtaHlWAtAVuULPByk/MDYd8g4Q3/w31iRSrPXmH1fWj2Qk1bSswEn0HqNVfYenD0DtDQy6vkOmLlH1UeWAdJAmZ2RBAvJTsuLEVU1drNi3aPoiM7uFcOre+lFXKXsNZwb8W8RDc+kTlvZwsNv+OMpWa81JKsYngpSBp663AONKT+17L0PgJeCpefjHpomKPT7OS5IWI8AxZ5IFK8dWCYskWzbB3oZFsvPapkLNpFOqxruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o09Lqxz8gU2ckEQ1alKqkxVzLZCbj7IIzYaQyT7aw1I=;
 b=ZBlww+t2O+rGmHi2fR+7XpKfevA2E85PgAxgBWXvuTevoAxABtkFgxD4Eng4ygAT4FTnvqSVWaZxMHkjTBrRsLVY8R0P4/uUNUd52odHM5qRBYYReyNZ4zqtlugMz5BFe4cNlDh3L4lYFWLRUvGGiIFhLyPKRBg4j8BYIgfvj9swiYSEnfXhV1v3fMBiTEhPOBr9WaILfyD0nJKsxLqHn5DIlFmfajSbuP8NztS+uGtxbTlPmEU0DrQJ3rPYohxKFaMRDp9/C/Ddmb+I4km8uwVgdTTmbGKA3bI1jmql+wOfQ4aVWKQ9Iz9h0FhIEykOTEdvF8eoNFocOK1S1c89Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ5PPF8B3F23403.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::842) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 23:14:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Tue, 29 Jul 2025
 23:14:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "Annapurve, Vishal" <vannapurve@google.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maz@kernel.org" <maz@kernel.org>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Topic: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Index: AQHcAL+7V9fiN+6xT0aRmIRaSyEMmrRJrnYAgAAHnACAAADmgIAAAu0AgAABhQA=
Date: Tue, 29 Jul 2025 23:13:58 +0000
Message-ID: <42a1dcc7f8607e526f09c758876e5967eb0e42ae.camel@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
	 <20250729193341.621487-3-seanjc@google.com>
	 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
	 <aIlRONVnWJiVbcCv@google.com>
	 <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
	 <aIlUbpQlYqaSO6wr@google.com>
In-Reply-To: <aIlUbpQlYqaSO6wr@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ5PPF8B3F23403:EE_
x-ms-office365-filtering-correlation-id: c79f9e4f-33c4-42cb-ff61-08ddcef5990a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ck5Zc3ROVkNnNEVybDdLd0dxdlordTVDdzZSaEJhMzNYT01FWXUweUhZTzR3?=
 =?utf-8?B?S3huaFdEUEpBQlNuQmFXWWEwYngrNG1BUjR3bVB5YUpOV2VWd2tLbDgyZEZm?=
 =?utf-8?B?R3B1Wng2eVRvL29Vd2FCZE84Z1VMNnBRbVVsSjEyKzZmUzYvTzhTRkdlaFdO?=
 =?utf-8?B?NnU0M2pHVGRlbTNSaU1qaHg0ck51czdWTld2WkZhWWtGWHNZTWh1VkxhNDBG?=
 =?utf-8?B?S0lrSEVlK0pkSnptcHc3V1VCMEljaWFmb3NIcnFMWEVZS21LcmFMdDhWc1I3?=
 =?utf-8?B?czlFRDNLQ3RHVml3L0hhaDAzS3FKZjhJREQ3Y2N6V29kVXJqQlFyWGEzRkFF?=
 =?utf-8?B?RHhqT20zNDc1REVGK3ZocWFkTUNEWFlJN0hyVlYzRlNaSXFITGFnZXgrb3FZ?=
 =?utf-8?B?SmpoQnNkb2kwdUg1NUhick8weUlCeTN5T1I0QmM2V1IveXBYSnVJVkRENHhm?=
 =?utf-8?B?aGtvY0VtUG5GaWM0VkNYVS9lQVJTcCswK0lwUEp2N0g0dEIxcS9IV09uUXVl?=
 =?utf-8?B?OGVNbWExVDY1NllXOW50ZFhqSlRQOTh2Vnd4Q1dGZFhqUjJSL2lkbDNDM1B2?=
 =?utf-8?B?WkJzQUdacmR0V0dTVnk4R1Z0dUxUTWZoNm96V0daWktFNG84VVV1eXRza25n?=
 =?utf-8?B?UjI5RHcxL0pyeUc1RXlMMGFGNm10RlVjcVlWeUtVRDQxZ3c4MGFoVEM2bEcz?=
 =?utf-8?B?TVluUHlOR3BidTkrdFJZZmxEd3FWN0RmdTVvYVByeVJNeEJ1S3RNcWRwQzFY?=
 =?utf-8?B?c3oxenlIRDdmS1VpRFl2dkRNdUVES2c3a29FYW00Nnh0dzNKeXk0UUF3eHpN?=
 =?utf-8?B?OGJqMlFDZnZpbUpuOWNjMGVUMkIzWndZd3ZjcEJ0MU5pdTFPOFFQRURkYis3?=
 =?utf-8?B?ZTJ5Q2hUTDFTNzRoRjlCRDZZZkFoQXdGdDlIZTU2N2tVNkRZN3MyUDBwQ3FW?=
 =?utf-8?B?TFA2aCtPSlhrQzVkcmJvbHR4ZTZVeVcwZ0dSQXpLQUhDQnBYM2RsTHVjMWZk?=
 =?utf-8?B?cW5QaEhxWEtjQU03cVc4MXZXdVJDOEpRQW9EaXNSeHRoSitoTFE4dGM1amIx?=
 =?utf-8?B?cTdOa0FPVng4cEVnOGkxbHRqTzVuaFlWUWRzMjBEc2FWZmNXU2ZrSXQ4cytv?=
 =?utf-8?B?WE8vYkNyZGhZUGJqeDdHNzhreG5sT1U2MjdXWUV2SjlYQ00yNmsrZmVQSEVW?=
 =?utf-8?B?cTlPN2tYOUpmdVpkN1pUbkFpUzdTaks4N2VWbDdlSjBsOTBLdis2RVpFYnhB?=
 =?utf-8?B?OFpSdVFXMUhjRDVCRjVSZW1uc3F5WCtZMlQyVWFET1ZLcm5PNXRQUTREK2hU?=
 =?utf-8?B?cVAwclVJRlpIdnk2S1ZwNjRGdGUrWHJFeW5GSjh2UXdHZS9Pdld2VjlKSnU0?=
 =?utf-8?B?YVFDK3pyZTBDTTVTZldneGNuU0JsUnVJazNjdzZkM0ltMTJvL2h4TFdRSjRT?=
 =?utf-8?B?eXhMTlN4QmhId04rUmJ5QzJmOU9PdWtFMFRyNFN6VDIvalFMem9oK1ZwR3Jz?=
 =?utf-8?B?WDNoSnhpQWc2Q1NDRDgrQjlUb2loZm4zMkJMSEVDRUNMSkhtZmo3WWs1ZUI5?=
 =?utf-8?B?QVg3eDBqMzFRZS8wcC9vRmNmcmk2U0o0bllPOENyYnpkT3BYakE3dWJEZlNM?=
 =?utf-8?B?NmhlZGFzaUQ3NCtrMnhuVDVPRGI5eGJnVW5xVllTclVsaFpqUldIeFpnWkNp?=
 =?utf-8?B?TmZiUU5CaStZdGtZamkxR1NyajBVZlJ6cXRDeHN4cHNCZmpoK0ZOaFZuaGJK?=
 =?utf-8?B?c1BZYXVWMmdLRVBiYWMycEF2cWptaHpYL2xNNEdzUFc5V1FLb1dCcnNEaFlh?=
 =?utf-8?B?bmJjcWFtRTNPdG5GQzNrc2Z2aGFFazdPcFlXcnNjK1IrUU82TmtoeFZ1UzNM?=
 =?utf-8?B?YmdUaHVlYWNPUnE4djduYTZ6eTIxcXZaMUhBNE1INkFEeDIyQkx0dHZpODNk?=
 =?utf-8?B?U2RNNXR5a3g5RTlicENDUXU3NnlCWHp4SXBmdlpIWTBSdXBBT1o2S2FVWGtp?=
 =?utf-8?Q?8eIJ2umY4/P2YEns3onTLzPC43kvgM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2dyS2hhVmJjRzkvZ0owa0x4M3lKV1hhNytjU3pRVUpFckt0RUw0TjlXdGxr?=
 =?utf-8?B?Q2l4OEpJWGF0Sit6dW8xQmZNZVRSRDVmS3RFZy9ra0w5V0RsK0t1b0UwRVd0?=
 =?utf-8?B?QlBib2t3S0NCc21RS1JZQ3FrWG1yVmtEbGtEVk1GZ2MxaEpVUk8rRUUvWUQr?=
 =?utf-8?B?ejhReDZ6aWxtK0FyeVlLczhMUjlIaWwvKzNrbWJGdnhKaW5BUlhDU0RhdVAy?=
 =?utf-8?B?S3hrcVc2enhjNUIzZWEvV0h2bEVXQXlKNFZmalppeUc0bWU0L2ZMRGh0SGlw?=
 =?utf-8?B?aVJoUWlyelZlOHFLcVJxdUs3cjE1RUkzaHYxcTM4ZHNqTEdWSVpKaWRTME9v?=
 =?utf-8?B?TDlTTElwb3ZtZGk5aFJSVXZ5TGRPK3grK3lUMGhsY1ZXdFZLWkZ6N2xZUkMw?=
 =?utf-8?B?SmJhc3hZMTdFcWZDUXpBanM4Z2c2Yis4eStaVG9RaVRrcXR4TEhleDA1Tyta?=
 =?utf-8?B?RFVocnRKTnZKaStqcGMra2xvYVhFVm5wOFgzaXlJb01lOW9WMFg3c3o1NWJG?=
 =?utf-8?B?SllqdHhwTE9HRGRqYkU1dkFmR2dWeHdkaWRlTWdGWmFvb1MvN1ZvSlV3TzZh?=
 =?utf-8?B?RHcwODk4ME5UdFJPRHZaSDJuUHJMTWc1eU94czBxMFozSDhBMVdveCtjK2ho?=
 =?utf-8?B?eHZNTlhTTFl2cUJYbXU5QzJLbHczNHVZbDF4Z210emFYZ0tpUmNzZ3RWL2VY?=
 =?utf-8?B?S24relRkV0Q3cHg0eENqSHV5ejdnc1M5dTVRZHRBa1B2ZHFnRzAwSlNzcTBl?=
 =?utf-8?B?dmU2Mm5IaHN5Q2dUdGxaLzltMW9tSWx3bHA3bFJzUjhTQWZzWHdNU1dTZVRE?=
 =?utf-8?B?NkRGVFFrNFZqYkg1cy9KSDcxa1pUTldkODgxa25GbzVkSHB5cEFoVHFlcnlS?=
 =?utf-8?B?R1Nld3ZWd0hOMzB4aDRhTlRnY1h6Nnp5WVprNW1oSUszdmk1Y1ZSNEtkRjFH?=
 =?utf-8?B?OUVFdWp6dk54c3VFK3lLbzFRcmcvSytpa1NyNHJSVytXRG4yOTl6V0RMcVZQ?=
 =?utf-8?B?MGpmam5zTGg5eTRlbU1NemZYR1VlamJKQkhYVnNNTTVXZXJxRXVrQU93aExP?=
 =?utf-8?B?cDUyS0NhSGRxTTlrbnZVMXVzSkhkazBRWDlHVjhZbEFmbjdlcHFrZ2c1R29J?=
 =?utf-8?B?dEtKY2lTS3lwUEJSbnRTYms0WjUwK2I2NDBqdnJYbitHQmRwWnZFcEN2SmRs?=
 =?utf-8?B?UFBiKzhxb0VZdlphNVVMdmZLUlJ5S0Z0eW9nM2o3RjNpdXBVVFk3d0lUNlZv?=
 =?utf-8?B?dlB1TlZ0UHBTNDJMSllraiszMEJKaDFDYVF5eE5ZQTVVNnNkKzgvcTBKUzlH?=
 =?utf-8?B?UnNTZWdnalZCcUV5Tk1udXRQRTZWZHczbkc0S3dZaERBa1V6eGRRSEVyUlcr?=
 =?utf-8?B?NzViN01kVjNYdDFHNnV4ank4NFBWZ2VMaUMvdERMblFDcGhOZitHUExHV0xX?=
 =?utf-8?B?TzkvRkV2eWovOXRJK2VQUlAxRVdOQU5VZDk4U0lYRGxwMlB4d1lhRFA5TElO?=
 =?utf-8?B?TVBncGhLUHc1L29ZNXEycVN6c1U2aW5POXkxdFp4TGdGejVMQVBDWXUreWh6?=
 =?utf-8?B?d1hOeG96QmpaOE9LOHR0NmQ2WmthV3NPakNycVlrN1pjQ29iT3czc29BVExk?=
 =?utf-8?B?ZzVpY0ROSTJhVngwN1BhUG5LeEh5QVU4eWtrTFlXUU15Q25HNkQ0TUQ4QWZV?=
 =?utf-8?B?SnFpUlIrYkNwWTI5cUhMZzdQWTBDWlN6NW5UWFJWYkUzZU5rRnltMEF2V3k3?=
 =?utf-8?B?bExLcE1tQkF6K0JGcUU0VTBZMUFVczZVVDhyVnZ6cGNxM1RWemJjZDdGZ0JY?=
 =?utf-8?B?NlVuUXNSL3d1eXlQdnFHOVEzTWE5TFdIR2dSODJHS2N2elgxbi9jN2grbjRw?=
 =?utf-8?B?dmp1akRlSFlFTFpjYmZ5YTRJamloQWJFZ0hYL05WWnVJcUJ1Y05OL2g0c3hj?=
 =?utf-8?B?TGFRcnMwSDJTV2QyTHE1cEh4K21zcVFVSEM2THhZdTdUeXE5aFVYTEpQUUda?=
 =?utf-8?B?NzNrMnA2M0JKSVBrUkZNTUZHejFWUmRLNG4yc1Q4aDduTzFPMTQ0VCtDRVc5?=
 =?utf-8?B?TXJYNGxDT0FGZTJjRDBLM04yOVlwdXZOTzV6d2hrdTArY1JMYXNZRjIwRUht?=
 =?utf-8?B?UXg3SWluSndoemcrYjNxdENQeWR5RVlaemladlNGNHJzcXdoekpWNFdaRVpt?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34195B5F029EA542B353B52DC32BC8D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79f9e4f-33c4-42cb-ff61-08ddcef5990a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2025 23:13:58.6124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlwSFb5WHIOIk8M/enxP7ZDeyyWwvm95W6ERGUhhWbC15Q5I2KwUjrSjbmkZP3+j2eH9PlIOZf1sCRX3DlQby9tjYlRiCHxLt6pBMXXR0xs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8B3F23403
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTI5IGF0IDE2OjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IElmIHVzZXJzcGFjZSBydW5zIHRoZSB2Q1BVIGFnYWluIHRoZW4gYW4gRVBUIHZp
b2xhdGlvbiBnZXRzIHRyaWdnZXJlZCBhZ2FpbiwNCj4gPiB3aGljaCBhZ2FpbiBnZXRzIGtpY2tl
ZCBvdXQgdG8gdXNlcnNwYWNlLiBUaGUgbmV3IGNoZWNrIHdpbGwgcHJldmVudCBpdCBmcm9tDQo+
ID4gZ2V0dGluZyBpbnRvIHRoZSBmYXVsdCBoYW5kbGVyLCByaWdodD8NCj4gDQo+IFllcz/CoCBC
dXQgSSdtIGNvbmZ1c2VkIGFib3V0IHdoeSB5b3UgbWVudGlvbmVkIHZtX2RlYWQsIGFuZCB3aHkg
eW91J3JlIGNhbGxpbmcNCj4gdGhpcyBhICJuZXcgY2hlY2siLsKgIFRoaXMgZWZmZWN0aXZlbHkg
ZG9lcyB0d28gdGhpbmdzOiBkcm9wcyBrdm1fdm1fZGVhZCgpIGFuZA0KPiBzd2l0Y2hlcyBmcm9t
IEVPSSA9PiBFRkFVTFQuwqAgX0lmXyBzZXR0aW5nIHZtX2RlYWQgd2FzIG5lY2Vzc2FyeSwgdGhl
biB3ZSBoYXZlDQo+IGENCj4gcHJvYmxlbS4NCj4gDQo+IEkgYXNzdW1lIGJ5ICJUaGUgdm1fZGVh
ZCB3YXMgYWRkZWQiIHlvdSByZWFsbHkgbWVhbiAiZm9yY2luZyBhbiBleGl0IHRvDQo+IHVzZXJz
cGFjZSIsDQo+IGFuZCB0aGF0IGt2bV92bV9kZWFkKCkrRUlPIHdhcyBhIHNvbWV3aGF0IGFyYml0
cmFyeSB3YXkgb2YgZm9yY2luZyBhbiBleGl0Pw0KDQpTb3JyeSwgeWVzIHZtX2RlYWQgcHJldmVu
dHMgYW4gRVBUIHZpb2xhdGlvbiBsb29wIGJ1dCBub3QgdGhlIEtWTV9CVUdfT04oKS4gVGhlDQp3
aG9sZSBpZiBjbGF1c2UgcHJldmVudHMgdGhlIEtWTV9CVUdfT04oKS4gWW91ciBwYXRjaCBwcmV2
ZW50cyB0aGUgZXB0IHZpb2xhdGlvbg0KbG9vcCBpbiBhIGJldHRlciB3YXkuDQo=

