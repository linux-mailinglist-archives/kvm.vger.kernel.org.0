Return-Path: <kvm+bounces-41467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF401A68116
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 01:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 867A7189720D
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 00:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6894683;
	Wed, 19 Mar 2025 00:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bm4LdQT4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B838801;
	Wed, 19 Mar 2025 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742342978; cv=fail; b=LhstHIwMuGx5sBKU4bYJUwgLUcG8KuR5Ke8PGEWGD/3u4TyFaMcjLT/Gksd1r/YAG2uEX4MHbV8IPTZogfjp5AR5bwqtv3P1jMmmm8Y0Od6gMibPJsH9Met1hP3VCVdKkCjLrdfFn5Gtf+XX0kGsysOg9WQ2YXCQJZnsv99taQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742342978; c=relaxed/simple;
	bh=So1kX6YRNKfjlHFIvG98N8zw379dIFjzN2gxgA3zkZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IwA1wnDRnSU0S5mBI6k0n7tqeYUN/RNPWzTn31/dQiyd9rcwPPB4tvNxsq8Zyuxj0PRZBTv5S/fTQPyIxosKLdu/ewzt/Fheh/UGHqo444cZwBz2KcS1RLU4rQSLp2neY5rIRaFCR79s4vYu5AR1x1F2EpNlCHRSvqy6QS7BLBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bm4LdQT4; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742342976; x=1773878976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=So1kX6YRNKfjlHFIvG98N8zw379dIFjzN2gxgA3zkZc=;
  b=Bm4LdQT4XDyz9sA0SWAt5/mGm2ym/Eco6iiAYlaDwZzfhAly2x4rzwGQ
   Pa+dn/owiLZ9sIZ+R+yWKLrFiRSS7ACQWzXI3OrT+xoQyR5X2EirPM/QN
   jjSWPhUQfy37ayR1Plz4JbHEdA6yDU612IB9TEWmHcd4ifib4W+3whFef
   GgC5app3YRIq/JZAUyDeuDmw5vnoAOWsx940mxQXdduMJq6LY2VZuCwAM
   aqT0fsIHIyxTJIgVSH23SlUdL8+2RxXgt0NtnSuboS2TU6WZn69ydseuT
   srga1OQ/T/bdNcaleECx/gJZWzE4HFUdLvCCLFTqfG5aOE0PZu5x9XUsr
   w==;
X-CSE-ConnectionGUID: Mo09XMkjSc+3vjzPs2JvzA==
X-CSE-MsgGUID: 3Ci8pHkmSKSs7UjnH8pduw==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="54146643"
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="54146643"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 17:09:32 -0700
X-CSE-ConnectionGUID: ggGVrmKPTmCWXIshbve8gw==
X-CSE-MsgGUID: 7mWH7NlfQPig3hHCAhrgKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="127086692"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2025 17:09:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Mar 2025 17:09:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Mar 2025 17:09:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 17:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/dnu0uqNyw+MbzGgdqNqR/bfxtypdRU4WIfP/w7ZdQP+9TjopVi4C69H9KyGVT22bVGGfGHzhwdyVy2sTpmi3VArHoN5aaCcb3AroytWy1wFDyx2Q1GzvTc2ioymN3Qa/I73A/WbgPNdq+I1Lh4KvzGUTUvffxo0pickDLlJNgZYTbs7ZewRqNspoQdObtYHf2hcUyJf2Qx7rWtANUtDapGB/4pH/4ublqkfaBVGiA0/P5NDAFxyUvXOd0YzObJbDJMLGBJze17vjVIRbj76FkH2L+sNPhPMzAFtoP2UKY/Gs3dBhiXd0f6fUSFds+mylcDBg3GUmx43lWa7PYDYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=So1kX6YRNKfjlHFIvG98N8zw379dIFjzN2gxgA3zkZc=;
 b=i0oydNX+60APiNnVkbBPNSgafq4IB2JNQwJu5eRGlrYshS5YRNg19ndkESiPpADdc7eqQ9VdVFcG2c6RXrXkanK9mAyo+r8zfnx5pr8s8Qzr2Ul/Ey1Cb1noGp3V8m3uXPnJB6qqHACPyKAWytl/z6bq6FRt73zP9TLDNLLNY4GGO4dLbEdJgYHaNCWgVFadTdCjzNgvwsb1iF3I9ogBQN/8Rv8iqGS5gdwJ7Y6lqUn5fBGabfipcgWcclMz/YX8K4eS27QLFldJ/Z22UiX7wuKqGb/piqzHKySHnQ0U9SWmzlPGmmH7iYNkB4DSzTXoo7MH4zeinxtlucYspZLGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8557.namprd11.prod.outlook.com (2603:10b6:408:1e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 00:09:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 00:09:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.03.12 - CANCELED
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2025.03.12 - CANCELED
Thread-Index: AQHbmGMlwU/PVq2qsUuN2AdZ/B3weg==
Date: Wed, 19 Mar 2025 00:09:14 +0000
Message-ID: <6c811b8cf80eebdea921db41d16419919cfa76ae.camel@intel.com>
References: <20250310161655.1072731-1-seanjc@google.com>
In-Reply-To: <20250310161655.1072731-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8557:EE_
x-ms-office365-filtering-correlation-id: a3fd0d3a-3042-41a5-8c98-08dd667a4860
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c25JS3BTQ3ZsYUxqMEtWaERkRVFWOUZ6L3V4OUhERGc5MTNSaG9rL0pUZkNy?=
 =?utf-8?B?Y3lPRWt1TzdTVFNmanNtRTJIOUtrUUxvZVdJREJtRjN0R0cvUmJKakxVbXhn?=
 =?utf-8?B?SW90KzFwMzZGbHFEY3R6a3FGVUd3VGtQQlBreWQrcTg5eFFQWktJTW4zZmY4?=
 =?utf-8?B?cGloVkk3c0dBVklkOFppZmhrTGZ4c0l6ZlR1K1BuNXM1QW5HUEtLY0l6LzEr?=
 =?utf-8?B?U1VzUzdlOHRiMTVFa2NJQUVLMFhSYzh3SFIvdlN0VjJ5N095ZGRoR09wL0dV?=
 =?utf-8?B?Y2tFdXBwM21SdlRuMWVKem41YWFZN1c5a0hnTVQ3aUsvRDJUTjJnNWtGSUgy?=
 =?utf-8?B?ZjYraFE5NUdhQ01sRm1XSVhuUlhWYllMcVhDb3Z0eC82cDluZzd4UjJSZUo3?=
 =?utf-8?B?SER6cjJ4S2NpU1F0TWxHZGRNSitOVytHb2E2aVFvTGZhaFpDQ1BtaEtzZkgx?=
 =?utf-8?B?Y3RHU0lPekgwV0FCM0xYNS9yYWtKVkd0Y3VGTDIveGZmaE8wNmFXUDNwc25C?=
 =?utf-8?B?NXJEaE01Vm5seGNMZ0VHMUY2SDlNckVXSEZ4QUNJRllJenIzQ1BQb3Z6RnFN?=
 =?utf-8?B?SDdHR25VZGNNV0lKNzlYZWRlQ2grdzJLcElxdXFyd3BKY3ZjR3poZzZZa1o2?=
 =?utf-8?B?ZnRLY2V6VXNHMUppZEU4ZE9UaXNPdTd6bEdJWXZBTWl4aDJHR2NIRjJHVjlw?=
 =?utf-8?B?TGFsL2tDb3p4SmV4SkU5M0NnYW05aC9RT0N1ZURKZjRjV0FqQzV1bXQyd2M2?=
 =?utf-8?B?UGsvNktGV0luemdXdUMwRG5SdnR3QjlFQ0d6MFFvUDd2VHJPU2FaL25SRk96?=
 =?utf-8?B?bmUxbHZKTGJJa08rZDNBSUxVL1hUVlpubVBTQndmYzZ4WHZkNWNFZ2lhMGJQ?=
 =?utf-8?B?WldJODlqMVB2b2Y0ZVNZaXRNVVh1RGRIMThrZUNpdUNCd3Q1UEhLRWR6TmNm?=
 =?utf-8?B?eDlkUFp5c0JzbEloTmpaYlpXdS94UlpZc1dUQTJmM2xYeFQ5TE9tYTJ2eExG?=
 =?utf-8?B?TTd4NEdNVFkxMy85SFkzUit2VjhrT1JRS09sUjc4bFBhTkVjRTFKN0VMdEJu?=
 =?utf-8?B?ajZPZlRFaDdQWXNzS3JjdGgzcWwvWU8ybHhvNmt5TjFsWHJKWmZoWWhESXBj?=
 =?utf-8?B?L1UxeXZUSHJlK285amprdHBVNkdDZjdWNlliNXEvam5kQ3UzMzBhVGhCbG0y?=
 =?utf-8?B?aWNPYzhmTjdoT1gwSnEyWUg3SjU4UjBYQVdTbWtZS3FCcHM4c1YxRnJQVXp3?=
 =?utf-8?B?ZFRjL20wTFRpSlp5aTZsRU9TMTlyYlBMYVl5TE9TbG4yT2E3cXYvcm5sVmNn?=
 =?utf-8?B?OUV0aU1qSXhNRnFVa3RxMmR6NEJDYnphTlZwRjJHSW4yUjJ4alVmVW41UzRF?=
 =?utf-8?B?KzEzcUpjSk1DUjNoZUI1TDdSL0J0aXdWWWNlaVZlRi9vb0FTYUkvMmVzdCt6?=
 =?utf-8?B?aHNURFI0Tko3YS9FNXJ4N1ZVS05Qdmp0L3dvZmgzN3R1cUwyWC9uUUppcFFs?=
 =?utf-8?B?YjJMMkx5Z3RMZEZQaFJHRC8vYWZrV1Q4N20vdnpaa0hoOEExM1YrQXRXOGNu?=
 =?utf-8?B?SEVPUXBXMWFVaFg2WGh2cERyNkVkU2RDNDI3Yzh2ZHZuTmYvU3dFUk5EM1Fx?=
 =?utf-8?B?UzJpTXZ5VmRPRkFZK05vU2hRcjRXcU9xSUx1OEwxanNOcjNMeWw1R2JJRU1n?=
 =?utf-8?B?S21DMHc5U1hRcnIrbWtBMHU0U2NUWWd4OWYvNHJqODh5UmxyRW9QcDgyWTlI?=
 =?utf-8?B?TDNXTlBKaU9GMXhsSEtIU202ZU5FNG9IdEhnb3d0N0R3TzV0QTZZdFVSbGJR?=
 =?utf-8?B?SEl2NUFrZ0NWWjh6M01KNHpKNXJJL29UaC9jdnVML3p1Z2dXOXMrU3dsc0ph?=
 =?utf-8?B?NjVXK0V5Z3U5WE1QMFIrd1UyVllrbFB0aW55bklJcGN4c09adER0emtZQUt5?=
 =?utf-8?Q?a67ZDKUrfKNjPWCVL2cS4wrEuO+Mn55q?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWJvNjd4UjZGMEdZdUtYOFJ4aUtodEU2WmJoMk1HdkM3Ym1QYVhtZjlFM3Ev?=
 =?utf-8?B?akhybmFJcWkyb0VPTExEb2dIb0pNZ2I3M00wK2FUVkV2SGR5L05yZGVPa3dI?=
 =?utf-8?B?SkxjTlNyTUlQZUg5R3k0Mm1ob1V1NWQzTjJ5QTVVZ1dYamJKbEFucEVDeGVt?=
 =?utf-8?B?bUtOQmU0WjJPV2VTQnhsWVo0T2M3bW5pNWY1by8wTy94WVp0OTlCRXRRbFRn?=
 =?utf-8?B?dm1tSlFralZVZFVaWVRiYktENG5Fb3NtQU1NaWpsL25EZkpwd2w0VUlvWTZF?=
 =?utf-8?B?ZUFoSElXU1pFcElOYUlheEo2QXN6UFRKbkxXUEtJK0g0a2czcXlOckNPclFC?=
 =?utf-8?B?cW1XZlFGQW1idHd1eGVNYmFmOEtmZmY5ZjR0S1pHOTZYYXp0Wm9vWGtyQ2t1?=
 =?utf-8?B?THZrWVhsU0xYSThtYStFRnFZS0lKM1p5RkxnSFYxWStlc0Evd2VuK3VUUlRG?=
 =?utf-8?B?WjRnM2thQlNyVEUweFo2bi9LRTFQeGxqYWZCZTc5YXp6L05Venk4UC8yeGZn?=
 =?utf-8?B?SGRJSUtpRTJ1U3V2Sjh5V1JVbnFBWlBwUmZQWWlvTHRvOXBOUVJVSWpON0Va?=
 =?utf-8?B?QUV2RFF0OFVwbmpOUk9ISGxPYmhVaHJ5Rld5QW1pRVNkVlF6MU4vd0I2eVJ1?=
 =?utf-8?B?QjVJZXJqN3plVHg5NlRtYlNJeXR1YzlqZEZaU1Q3eU1uc2hhYzJiRUFBaDE2?=
 =?utf-8?B?RHVPRms2cWZRK3F0THl0Zkd0NnY5anhmdmx6cm0yNFI0QngyUlpjb2lXbk9U?=
 =?utf-8?B?QlpTUmpSTllPWW5Wb2xQNjMvNWZhSWRSRHJIQ1hhQXpyR2FNQXd5dkpFb0Z3?=
 =?utf-8?B?ZDBwOEtnSzU1ZGZKZWdtTENzSWF6azRCRFh3ZEVxbDdmQ2ZKWE9paDhGTnIr?=
 =?utf-8?B?cEhKa3ZvSTVJRWgrQm00Z21kcjlyQVdVTU0yUThTUldPV1NMVHRwSXlZaDF2?=
 =?utf-8?B?NHlqSFY0SDhmdGh1bUF1NnE0VE9PdE1najlyWm5EZVBmOEdoT29mY0hyUnM1?=
 =?utf-8?B?Z2Z5OTRhOHNCRUpXNTk0ejNURE1ncXk3NjNGSS9RZmFvcG9UeEwxUTEwMS9h?=
 =?utf-8?B?dWVSY3ltZGpacnVVclVDZkV3TDFQTUhwK1p1WVlGRVNyUnp3TkNuaUxkMU9X?=
 =?utf-8?B?R1ByazQ2cUlFM3V6R1MxVzBrQkVSNStKUXpNNG5ybURlUlZIdW1WRVlsNHY5?=
 =?utf-8?B?M25tYjI4TEdkc1JPNUM1K3BRL3B4NWJld0ZTOXpEb3lVMXNyL1ZJVWpzOWFL?=
 =?utf-8?B?TlVRVGNaYjJtblFjWlcxK2l6bEpudnU4MWVJYmVYcVdOSW5tVjdjQnVjQnFr?=
 =?utf-8?B?dVZSRVJ5clpIV2F4MEhYMkdFYVdjZDczVHFlNGVFa3lGdWs1Y1I3YU1hMlpL?=
 =?utf-8?B?bnQxT2hPVldvTWErVDhkYzEwcG9ZRi9kWURqSG9GQWpBUGtqZUNQMkljanBl?=
 =?utf-8?B?QWM5VGJCem5JMC9EOGRNWEUvWXZTYlBVQmhCbEFLdnM1S3FENG5SaUVYRDFX?=
 =?utf-8?B?SXFlZVFZUFdycWRPTHZ2TUdNS0pSYnQzaHAvL3NhejYycUFPV3ZNVWduZlV5?=
 =?utf-8?B?VnFuVGNpc0Y4bk9sNFVqYW1YWWw2WFJVZk5TK2hpMVdMMExTOStQQzlQRTdG?=
 =?utf-8?B?S28wc09TVGNwdUxMdmNwK2JGZjJhWktKdDNtOXU3WFAyOUZGakx0bm1yeVJx?=
 =?utf-8?B?K25CTWdOa21odWFWTm5DVDZzaWEyMHRtYnd3aEg3YXZBYStzMFViRGlJKzBz?=
 =?utf-8?B?MzYvVnphZGhsSS9BZTRQT0p2SC9TWXBPNUk2Vmh0dG5TUU5WS3dIZjJ6VUxk?=
 =?utf-8?B?SkxQT1AwZnI4S0pHLytRbStDcmk3MEEvWGl4aHZsMnF6VWtVWFE1T1hSa0Zs?=
 =?utf-8?B?eTk4Y0E3ckQ2cDBXcm00RXhCUXhJUFlLVGhxNllYKzRqR2MwekhoSWwwR213?=
 =?utf-8?B?enQ0VjdKRDB4Z0FCb3lFdkxQNlpGZit2STRXT0pFN1RZSTJ4aUEwb3FuV2J5?=
 =?utf-8?B?RlNYNmFFNkhSM0FTWU5xUnZYZlc0T1J4Q0k0ZHhOaWtMMUkzQXFheERKUEhy?=
 =?utf-8?B?ajJFd1dSb2syZlVSWUl6c0xsclMrZ2s3aGlUQnVQZWFGc2ljMEMxY09uRXh6?=
 =?utf-8?B?TFlUTlV5M0F5eDBZa0NXV3N2cDE2UmZPazlNZjR4ekYrZWtDbFpCc1RqMHFT?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2AEF20278300B24190C76185E9438E16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3fd0d3a-3042-41a5-8c98-08dd667a4860
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2025 00:09:14.2680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhJDNGyRne7Lo5dIxjIVLXBFNupOc6Sx0yE/NSo5T2qps2N0t/9QzMPKZdr9l//mTrK35f3HASkXQaUJP07HNZHl/lmroc2RNQEnmgqwxeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8557
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTEwIGF0IDA5OjE2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBQYW9sbyBhbmQgb3RoZXIgZm9sa3MgaW4gRXVyb3BlLCB3b3VsZCB5b3UgcHJlZmVy
IHRvIGNhbmNlbCBQVUNLIGZvciB0aGUgcmVzdA0KPiBvZiBNYXJjaCAodW50aWwgRXVyb3BlIGpv
aW5zIHRoZSBVUyBpbiBEU1QpLCBvciBkZWFsIHdpdGggdGhlIG9mZi1ieS1vbmUgZXJyb3I/DQoN
CkRpZCB5b3UgZ3V5cyBkZWNpZGUgb24gdGhpcz8NCg==

