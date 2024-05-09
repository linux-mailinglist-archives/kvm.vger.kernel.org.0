Return-Path: <kvm+bounces-17114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA408C0F62
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E88741F21419
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 12:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6927614B09E;
	Thu,  9 May 2024 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hge+1P7W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759714A90;
	Thu,  9 May 2024 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715256661; cv=fail; b=TyYwPFe/wJ9XtKujBGN0wHE8z59t4am2HIglrCXWpfrMT7xW5Y30thp2QH6ia3ifD/jjN+Jm9CiBwdKvdAb+IdYBzR6d2vykQANOFsRy44trpu1Ry2lODXG5A+au9E4oMqE8o+h+Y3OuW26v23Ov8zyc1E3jlOYxeR7O5SChPcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715256661; c=relaxed/simple;
	bh=NVQmzBWaevjrsKccqJETs2mm7HeAADEzOVWr4sFjzKE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K01iZuxz7W+35kUfiVVW4J9ATV+HvO2uSRGztwYjRvjkVPQ5hw9z3UM8ZzqJhRk8VZ0tSX7JzMCM38+F7jc0//KtjjYCUtNa3UAE4ZSRjtdBzUyxUVjAxpdPxPItYFfJWQZMhkxgS5m0aH1b4F/aBlGgfFW5jyGVqXfeYrNdAjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hge+1P7W; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715256660; x=1746792660;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=NVQmzBWaevjrsKccqJETs2mm7HeAADEzOVWr4sFjzKE=;
  b=Hge+1P7W8RZ/wAGLDEtZrAjoB2P6nWHuieVpvKHbydLrtElZ7YbQEZ1x
   2IV/IR9876kMCIMJbQM7A3IF8jJdEaz3U3SkFqx3Nzf8bGASzItT8uYnz
   JXJRvw1KXJ8Ic0xXZjEBWHd70wlPIS8Gh+S3DPJDGyTwpXbxsUy2q5CCe
   t33Xs2HAeYh2X+t5ljJIYwPpCa3WRBVjt1yTVXXsL5JxAqrfG7AKDNhJ0
   QLshzHRl5BRZ9LQEguF2K7baNVl6h9SM6t5eNF+noV75Wixh5+U3u4r+p
   3GKQr/CIDXIM2az4BqK0eea8Z0tspCst7xiqkm9sRfuSiNA9faLhEZC8S
   w==;
X-CSE-ConnectionGUID: xlegZh4IQw6Tm9/rGL0PtQ==
X-CSE-MsgGUID: CaehGXLxQI6sFPhcdXjJKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="22576161"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="22576161"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 05:11:00 -0700
X-CSE-ConnectionGUID: C1fdk97wR4KNmkPEhEgeeA==
X-CSE-MsgGUID: 7lnnAjaxQQOGBtSVmDTxUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="66658729"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 05:11:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 05:10:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 05:10:58 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 05:10:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfSpCU+/ubbMmt5Uez/Exu3fqKoZ2CzMXgNJnfWTlWBAX/iy6LdpaJEK0WMIvZy4Cybr+emcecQxEncNzB6bGHcB+LneGZq/KXjMBoKR3hPihxNwoXizjFw2Jqy6omglqyO8N2Kdx0/1tALOButE7z+5mbwBbY4tvsr50GDqnVWtt5/8fb6H2Tmq2bty2+WZ79punKCuZP3heFxSQ5JJUtSLDcQNpCFTjEIavSXyndOXJZBcr2T3m5F2F9UGpDpNTE91Q5H6W3UVr3CTvMbjAJWCJzSy8u1QycGZvSS/PNfTTUfpV3d0uMyq2y2KXpYRGEcTXO/Uw2zBLVYMa+BWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVQmzBWaevjrsKccqJETs2mm7HeAADEzOVWr4sFjzKE=;
 b=UCQD5L4+5kPE1tUM8yloHZ9snPpECVL3UgfNk3maBSjYRT94aWHo8/wrVmGfyrVWHKgHQXezzCr099Zg8VOUUAUrKfBAFxF+i7Zc/2Tn4JbpzkY8568ix3UO93On4vf1cQT2Gm/FkBiS2NNl3BZA4pOCTtDEtVuS7FiGhBP1RugGNjcA/c67nkujxcChdKUheT5M3RL5Pf1kR+8MDp9e/Mo2yBNIpGpp9zjDt9xr7zuvy0XK6ALFZ7UPYeQSSpHFfzcW/aXaIBmK5EmDBXbFwJWQvAL3zE6UiU4stjYBnr+54/gvyWD/N6zWcQQBBd8tWENyPldCk+9aLMIGonNpOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8046.namprd11.prod.outlook.com (2603:10b6:806:2fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Thu, 9 May
 2024 12:10:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.048; Thu, 9 May 2024
 12:10:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Topic: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Index: AQHal2oZ96dGW+wLWEKQlyVIplybDrGMCVGAgALbu4A=
Date: Thu, 9 May 2024 12:10:56 +0000
Message-ID: <d58005fc50fcc1366b40f7ab5e68c94280307c53.camel@intel.com>
References: <20240425233951.3344485-1-seanjc@google.com>
	 <20240425233951.3344485-4-seanjc@google.com> <ZjpXeyzU46I1eu0A@google.com>
In-Reply-To: <ZjpXeyzU46I1eu0A@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB8046:EE_
x-ms-office365-filtering-correlation-id: c4a0ee5c-782d-4458-30f7-08dc702114e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TnlmbXhjdEhMVHZGS1Z6dnk2MVZqTkpJV092T1lERlZrd1JhRXVvazFZNnAy?=
 =?utf-8?B?QnM0akx6Y2tab3hWd2M5N3psWWxnWFRvQTBQR1NGazZaTXJ3ZWxVaHd6M2Vv?=
 =?utf-8?B?bnJXbVNhWjlQM0svR2hqNTI4MXAwMVpOMkMvcjEzL3VUNU9rNDgwRW5sNE9t?=
 =?utf-8?B?TU00dVV1VlRFVVJGemExb3M4Sk9peUh0c2YvREROVHdHVWlKclJIRTllOFJK?=
 =?utf-8?B?ZjF6Qkhhc2wydWptdnZlZ1c3VHFTb2dmdi9ISk1DaU8zMS9PQkpxMjY5c3Ex?=
 =?utf-8?B?amlZWGpUbEs2MTczc3k1MGJtRlM4VVNNaG1UTnNLODA4aVg3R3FnRkZxWFU2?=
 =?utf-8?B?SUhzd3d3MDRsRWhGMFBkTGttYzFOdW81S0E3VFJ0a2t3K01tVWc4bFhKUy9W?=
 =?utf-8?B?MExaTGVuMU9DSXdKajJJMHQ4UC9kc1JiNVZxeFlCZjdsQS92bTFxME5KdFR0?=
 =?utf-8?B?YmhJUWx1T3pmYWJDR3hNL1dtclFjNDEvTHJzdk1udjE5Vk1zMWlxYnlvTmRV?=
 =?utf-8?B?VHUxd09CMk5ZMXk0N0JBKy93L21ESjM5czZTQWRIZGswOXZEcGNRakllUVB3?=
 =?utf-8?B?c3M5c09NbTdVTGVRR2l6cDZ0KzU0YlBQcGdBZXJKbld2VHdDSjVONkxKeGly?=
 =?utf-8?B?ZnF4d0dzTXcyUjlkZHcwUWp2T0RER09zUG56aGNucmFIeWVRbUYweEJ1cXM3?=
 =?utf-8?B?QUttc1JQYkxicTQwZmpoTDdjWjZLV1ZqRkxFU1hCTzlzTEU2aHVTZG9KMVJO?=
 =?utf-8?B?UHR1VU92dC9xUUpHSXM1YWxRVEtIWWs0RXYzU3d3bXdsOTArWFA0aGpVTGZN?=
 =?utf-8?B?S08yV0J3VHR1QTYxVENhd0QyZzF3dThSZCtsbUh5cG8rcndiZXh5OXc1OURK?=
 =?utf-8?B?SVhCZWQ1dmhkd3ZTeUx5aEZqelZXWnJNVmJnaTlFVk9Zc21lQkc0bUUzSnBN?=
 =?utf-8?B?bUZKOUlYaUllZnJHK0paYzNJdURPZExBN3cyNFpxTHp2VnoxT3N0V3ZDUmhz?=
 =?utf-8?B?ZWhIUVhUR1djVzd6b2JtTDhQc2gxVmxMZW82Kzk4TWhsTmlIMXdxblBLNnJr?=
 =?utf-8?B?MkNxWDl5UGhFSGlIWVNqRTFuMGhsaGlzNkNSaFhORlZRQzZ4OEVjdFc2S1dD?=
 =?utf-8?B?cU5PWW05MnQ4M3o5VDZFbzZ2YmRNQU81Y040K0VVTmhkblpLWkd1cDVFT2FO?=
 =?utf-8?B?c2NEVWVYT3BZaFdaYVpOWkdRMTM5NWd1VVRodEZ6d1NDejhZbHovWFlnSTZZ?=
 =?utf-8?B?MHVUdWdaZXlOOU9RVzZmditVa01vWHVSK0c0ZGVqTjlmOWQ5QlVKQitBR0Jw?=
 =?utf-8?B?M0Rlam5KaWpuNUhDaE5DWlBlNnVQRHhNNEtrQ09XYklHcmxFYUtYME9PWVRs?=
 =?utf-8?B?RUpISjI4bDZNNDhxQzR3U1l0U29iUjk3QWIySUpqbkhiYU5NbjRMN1AwRG5G?=
 =?utf-8?B?UUNQYjY3a04xcUxJYUJLRFB5UHJNZGRETUdLVFp1Nlg0clRUMkJvWHVzalpE?=
 =?utf-8?B?L2lFaVRMM3lnQU5uTG5WaFZWOEo3SnB6aGlOYlYrR1FFWkpuNDFHM0kyRldC?=
 =?utf-8?B?NWtLN0ljLzA0cm9QbEgwWVJod2xUZkhXT2RQM1dLS0M1UWdvNTZZckcybmRq?=
 =?utf-8?B?K0xmNFF4ZVpiTGhaWWJrR1pCb1g4R1F1OHFTajhIZzBQMy9TT21QWXQrbjRt?=
 =?utf-8?B?ZGFWdzhBekJqMUhQajdVV05jWldvS0Uwd3VSekVHRzF1SEovbERJaU5hL0RB?=
 =?utf-8?B?ZlN6Y09rMy93a0RqaHVpU3l2c1lKdkZYMmNPNDlMMFFXeE1JaS80bTFDYy9X?=
 =?utf-8?B?Q0dSTGpvT0YzMGJOK0VWQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWlxNTJOWml2ZnphMDdoVHFYQU5GWm5sQUlIbUFXMERtQkdxVkhHRHZTd3RD?=
 =?utf-8?B?N3M3KysydGhoUG9MS2RmVGZLL3F4VG9tMmdnT2NrZXF5Vi9uWXo4K2h5TDJS?=
 =?utf-8?B?TkEvSGZTbVMvampmaU1nclBxNlpyRTUxY2JpdHpUQjFPUU9DaHdLVUEyd0NZ?=
 =?utf-8?B?VVlmYklIekRpbDFTQWhZZVU3c01EOFNwWGorb1B2VFZ3YWwreDJaa1lJbDhY?=
 =?utf-8?B?VkpqY014MFNnSlRwK215eWJJQnE0emZMS2I4SXBLSjRuT2FUNHlPN3RIQWxO?=
 =?utf-8?B?VElOVTg3WjBBcnIzVlUxV2IrQ01kbTA5VnBkUkJNaE0rWXhyeWlUeFR3WGdY?=
 =?utf-8?B?c1dCTWptSEx6Mkw1dEl5RW9wREl4Mlc2Y2x4R0RFZ3lCQUdISjNXYlBRaWxY?=
 =?utf-8?B?QlZPUnVtT0RFLzVxaE9aZ1lpaER0Q0x6akhmcDE2K2Z5N1NVMlJSOHFVWHlj?=
 =?utf-8?B?T2ZTS3pUYjhiYlF2aFZ5RWtkM0lDbmFEMHFtV3dtcVJRZmh5dFdJTXRuZFhu?=
 =?utf-8?B?NnhDcVFscldqcVBjSzJZSjJUdzFHMnJ5NUdxbXg4NW50ZDRUNG9uQUtSUWpO?=
 =?utf-8?B?aUVtajNDZUxRZUcyR003QUpqODhHdWhkMGcxdjJaamt6ZHNabzRNN0FFSW9q?=
 =?utf-8?B?VXNYZTlIZTd3S3dScWdOMTJJUU5VYk5BV21teU0zQlJNM2lUbEpQeHVyTU5B?=
 =?utf-8?B?Z1kxZjBXU25nZk9KdlZpblprUURTQU5sN3dvTEZUV0NLWkZlQVNaUVd4TEkz?=
 =?utf-8?B?c1h5SmZmSSt4SHJnVW5iY0pBU0ViM1ZkVkZVOFNGVDlqa1VvRUZiZXhpQ0hC?=
 =?utf-8?B?RGpJakFZejZCRXNsTExudU5nSmFrME1wdUF6SGxoaHQrZERNTmordDkxUlcv?=
 =?utf-8?B?anNkUnhncm5YOEFGbktOOVQ3aTJOZEdia1BPaXRjYU1ua0p4aW1TYU1ndGpq?=
 =?utf-8?B?RkdSU0lUMHhXY2crSFZFcnhqblIwZHBDYU5pd3RTOXQzemRDSUNmaHNyTjBi?=
 =?utf-8?B?aUpYdGV5NUcrbm1odmpZekpwczV6L3V1RGRlUzB3enNyNjluT3g1MHU3Z3JE?=
 =?utf-8?B?VVRnb0VnRnBHTGswZzYyQWNVbExDMGxma2NpNVkrQ3M4ZzZZTk9KSHQwZHVU?=
 =?utf-8?B?dzJML1ZERzU1L29reGRiUlUvdjJzaXk5UWtmQjhtOThUeEJkZFBYSVgxMTFX?=
 =?utf-8?B?ZVNzV2daU1dUd1lrUGxBa2JsUC9Ga3BwZFk1YzhqWVduOCtEU1lpTnBETlBm?=
 =?utf-8?B?K0xEOGhoaTl4V0ZSd3d5ZHpZYWpyRXFYMkV6dGNaaTRSblVqRHpZTlFXYkxJ?=
 =?utf-8?B?RldHMjl6QWhQdFpicmZzbFVyTzZqQlQ3ZS9BL2dWU2dmWjlFM3o5RHdwVGhz?=
 =?utf-8?B?a0xQdC9Ec05FUGNSRWh0eGlMOWxvUDVoZE0vcmRFYnR2bE1JcStJYnRBWXRN?=
 =?utf-8?B?TnU5Q1VhVXJSS2lML0RjUkttSWd0M0hRZnVDMGlsYlpIcnoyS2srU0Y0cUN3?=
 =?utf-8?B?VXNWWldPcXFwKzlLSHZtWVdDeVB3c1pYVm9NWXp0SkJLSlBURlV6RWlpSEM0?=
 =?utf-8?B?bk1WN0dxS29pUk1ZM2lHVCsyZzUvOWtTeXI4dHRsNnpranAxOTl0R2tQWnY5?=
 =?utf-8?B?Z3dsRlhCcHN4L3p5UGV5eVVMM0dIZFZEN0RXaE1qaC9jZ0tDQytQb1FIZ0I3?=
 =?utf-8?B?ZHg5Um12b29xZlNjLzVZZytEayt6QUlJWk5pZlVBMWdqTGZLL0l5TXlOa1Mz?=
 =?utf-8?B?RUI4QXl6eVFIcUltd01JeUtlT05uMUdQS0ZQYkxsZmVTbzliMEdMOFM4bHhV?=
 =?utf-8?B?b1J1RDBPTm0zQ3BTSGVDK28yTUd2VHR2QzBKbFltUERpUE9GSUxBMGdQZnZm?=
 =?utf-8?B?TlhleFgrWVQwN2xlbVFFSVphUWNZSll4ejlEU3c5akJ3NXZONXhNMEQ3OUpC?=
 =?utf-8?B?K2ZGRHJoUWRJK2x0T21ST1RrNVlKYU12aDZRL0lnakVSSlBFWS9qbVJFSU41?=
 =?utf-8?B?aERrS1Zud1JpSnVYK1Q5WUZEenZoM3NqL0RTNmFvM0E5T0o2VFUycUx3ZzEy?=
 =?utf-8?B?cUdleml0N1VOeFdla3ZKSnRjVGt2b0hPNFNBZkxGVDk4ZGhHWmJZU1dzSmZu?=
 =?utf-8?Q?44RKlCxaBQkvMVOeb4upJPF3n?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE4416A3CB480444BDC8D99087F63624@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a0ee5c-782d-4458-30f7-08dc702114e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2024 12:10:56.6261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HLT0gxwox6x9Ee0Fr/r7oAqwhGvR5sIP+NffuMxa3vY1ZwtfVQ5YrAQ1qzXTcXfz0Ha4hFExRE6/9IeCxa4ixQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8046
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTA3IGF0IDA5OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAyNSwgMjAyNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiBSZWdpc3RlciBLVk0ncyBjcHVocCBhbmQgc3lzY29yZSBjYWxsYmFjayB3aGVuIGVuYWJs
aW5nIHZpcnR1YWxpemF0aW9uDQo+ID4gaW4gaGFyZHdhcmUgaW5zdGVhZCBvZiByZWdpc3Rlcmlu
ZyB0aGUgY2FsbGJhY2tzIGR1cmluZyBpbml0aWFsaXphdGlvbiwNCj4gPiBhbmQgbGV0IHRoZSBD
UFUgdXAvZG93biBmcmFtZXdvcmsgaW52b2tlIHRoZSBpbm5lciBlbmFibGUvZGlzYWJsZQ0KPiA+
IGZ1bmN0aW9ucy4gIFJlZ2lzdGVyaW5nIHRoZSBjYWxsYmFja3MgZHVyaW5nIGluaXRpYWxpemF0
aW9uIG1ha2VzIHRoaW5ncw0KPiA+IG1vcmUgY29tcGxleCB0aGFuIHRoZXkgbmVlZCB0byBiZSwg
YXMgS1ZNIG5lZWRzIHRvIGJlIHZlcnkgY2FyZWZ1bCBhYm91dA0KPiA+IGhhbmRsaW5nIHJhY2Vz
IGJldHdlZW4gZW5hYmxpbmcgQ1BVcyBiZWluZyBvbmxpbmVkL29mZmxpbmVkIGFuZCBoYXJkd2Fy
ZQ0KPiA+IGJlaW5nIGVuYWJsZWQvZGlzYWJsZWQuDQo+ID4gDQo+ID4gSW50ZWwgVERYIHN1cHBv
cnQgd2lsbCByZXF1aXJlIEtWTSB0byBlbmFibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIEtWTQ0K
PiA+IGluaXRpYWxpemF0aW9uLCBpLmUuIHdpbGwgYWRkIGFub3RoZXIgd3JpbmtsZSB0byB0aGlu
Z3MsIGF0IHdoaWNoIHBvaW50DQo+ID4gc29ydGluZyBvdXQgdGhlIHBvdGVudGlhbCByYWNlcyB3
aXRoIGt2bV91c2FnZV9jb3VudCB3b3VsZCBiZWNvbWUgZXZlbg0KPiA+IG1vcmUgY29tcGxleC4N
Cj4gPiArc3RhdGljIGludCBoYXJkd2FyZV9lbmFibGVfYWxsKHZvaWQpDQo+ID4gK3sNCj4gPiAr
CWludCByOw0KPiA+ICsNCj4gPiArCWd1YXJkKG11dGV4KSgma3ZtX2xvY2spOw0KPiA+ICsNCj4g
PiArCWlmIChrdm1fdXNhZ2VfY291bnQrKykNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4g
KwlyID0gY3B1aHBfc2V0dXBfc3RhdGUoQ1BVSFBfQVBfS1ZNX09OTElORSwgImt2bS9jcHU6b25s
aW5lIiwNCj4gPiArCQkJICAgICAga3ZtX29ubGluZV9jcHUsIGt2bV9vZmZsaW5lX2NwdSk7DQo+
ID4gKwlpZiAocikNCj4gPiArCQlyZXR1cm4gcjsNCj4gDQo+IFRoZXJlJ3MgYSBsb2NrIG9yZGVy
aW5nIGlzc3VlIGhlcmUuICBLVk0gY3VycmVudGx5IHRha2VzIGt2bV9sb2NrIGluc2lkZQ0KPiBj
cHVfaG90cGx1Z19sb2NrLCBidXQgdGhpcyBjb2RlIGRvZXMgdGhlIG9wcG9zaXRlLiAgSSBuZWVk
IHRvIHRha2UgYSBjbG9zZXIgbG9vaw0KPiBhdCB0aGUgbG9ja2luZywgYXMgSSdtIG5vdCBlbnRp
cmVseSBjZXJ0YWluIHRoYXQgdGhlIGV4aXN0aW5nIG9yZGVyaW5nIGlzIGNvcnJlY3QNCj4gb3Ig
aWRlYWwuIMKgDQo+IA0KDQpEbyB5b3UgbWVhbiBjdXJyZW50bHkgKHVwc3RyZWFtKSBoYXJkd2Fy
ZV9lbmFibGVfYWxsKCkgdGFrZXMNCmNwdXNfcmVhZF9sb2NrKCkgZmlyc3QgYW5kIHRoZW4ga3Zt
X2xvY2s/DQoNCkZvciB0aGlzIG9uZSBJIHRoaW5rIHRoZSBjcHVzX3JlYWRfbG9jaygpIG11c3Qg
YmUgdGFrZW4gb3V0c2lkZSBvZg0Ka3ZtX2xvY2ssIGJlY2F1c2UgdGhlIGt2bV9vbmxpbmVfY3B1
KCkgYWxzbyB0YWtlcyBrdm1fbG9jay4gIFN3aXRjaGluZyB0aGUNCm9yZGVyIGluIGhhcmR3YXJl
X2VuYWJsZV9hbGwoKSBjYW4gcmVzdWx0IGluIGRlYWRsb2NrLg0KDQpGb3IgZXhhbXBsZSwgd2hl
biBDUFUgMCBpcyBkb2luZyBoYXJkd2FyZV9lbmFibGVfYWxsKCksIENQVSAxIHRyaWVzIHRvDQpi
cmluZyB1cCBDUFUgMiBiZXR3ZWVuIGt2bV9sb2NrIGFuZCBjcHVzX3JlYWRfbG9jaygpIGluIENQ
VSAwOg0KDQpjcHUgMCAJCQkgICBjcHUgMSAJCWNwdSAyDQoNCihoYXJkd2FyZV9lbmFibGVfYWxs
KCkpCSAgIChvbmxpbmUgY3B1IDIpCShrdm1fb25saW5lX2NwdSgpKQ0KDQoxKSBtdXRleF9sb2Nr
KCZrdm1fbG9jayk7CSAgwqANCg0KCQkJICAgMikgY3B1c193cml0ZV9sb2NrKCk7DQoJCQkgICAg
ICBicmluZ3VwIGNwdSAyDQoNCgkJCQkJCTQpIG11dGV4X2xvY2soJmt2bV9sb2NrKTsNCg0KMykg
Y3B1c19yZWFkX2xvY2soKTsJCQkJLi4uDQoNCgkJCQkJCW11dGV4X3VubG9jaygma3ZtX2xvY2sp
Ow0KDQoJCQkgICA1KSBjcHVzX3dyaXRlX3VubG9jaygpOw0KDQogICAuLi4NCg0KNikgbXV0ZXhf
dW5sb2NrKCZrdm1fbG9jayk7DQoNCkluIHRoaXMgY2FzZSwgdGhlIGNwdXNfcmVhZF9sb2NrKCkg
aW4gc3RlcCAzKSB3aWxsIHdhaXQgZm9yIHRoZQ0KY3B1c193cml0ZV91bmxvY2soKSBpbiBzdGVw
IDUpIHRvIGNvbXBsZXRlLCB3aGljaCB3aWxsIHdhaXQgZm9yIENQVSAyIHRvDQpjb21wbGV0ZSBr
dm1fb25saW5lX2NwdSgpLiAgQnV0IGt2bV9vbmxpbmVfY3B1KCkgb24gQ1BVIDIgd2lsbCBpbiB0
dXJuDQp3YWl0IGZvciBDUFUgMCB0byByZWxlYXNlIHRoZSBrdm1fbG9jaywgc28gZGVhZGxvY2su
DQoNCkJ1dCB3aXRoIHRoZSBjb2RlIGNoYW5nZSBpbiB0aGlzIHBhdGNoLCB0aGUga3ZtX29ubGlu
ZV9jcHUoKSBkb2Vzbid0IHRha2UNCnRoZSBrdm1fbG9jayBhbnltb3JlLCBzbyB0byBtZSBpdCBs
b29rcyBpdCdzIE9LIHRvIHRha2UgY3B1c19yZWFkX2xvY2soKQ0KaW5zaWRlIGt2bV9sb2NrLg0K
DQpCdHcsIGV2ZW4gaW4gdGhlIGN1cnJlbnQgdXBzdHJlYW0gY29kZSwgSUlVQyB0aGUgY3B1c19y
ZWFkX2xvY2soKSBpc24ndA0KYWJzb2x1dGVseSBuZWNlc3NhcnkuICBJdCB3YXMgaW50cm9kdWNl
ZCB0byBwcmV2ZW50IHJ1bm5pbmcNCmhhcmR3YXJlX2VuYWJsZV9ub2xvY2soKSBmcm9tIG9uX2Vh
Y2hfY3B1KCkgSVBJIGNhbGwgZm9yIHRoZSBuZXcgY3B1DQpiZWZvcmUga3ZtX29ubGluZV9jcHUo
KSBpcyBpbnZva2VkLiAgQnV0IGR1ZSB0byBib3RoIGhhcmR3YXJlX2VuYWJsZV9hbGwoKQ0KYW5k
IGt2bV9vbmxpbmVfY3B1KCkgYm90aCBncmFicyBrdm1fbG9jaywgdGhlIGhhcmR3YXJlX2VuYWJs
ZV9ub2xvY2soKQ0KaW5zaWRlIHRoZSBrdm1fb25saW5lX2NwdSgpIHdpbGwgYWx3YXlzIHdhaXQg
Zm9yIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSB0bw0KY29tcGxldGUsIHNvIHRoZSB3b3JzdCBjYXNl
IGlzIGhhcmR3YXJlX2VuYWJsZV9ub2xvY2soKSBpcyBjYWxsZWQgdHdpY2UuIA0KQnV0IHRoaXMg
aXMgZmluZSBiZWNhdXNlIHRoZSBzZWNvbmQgY2FsbCB3aWxsIGJhc2ljYWxseSBkbyBub3RoaW5n
IGR1ZSB0bw0KdGhlIEBoYXJkd2FyZV9lbmFibGVkIHBlci1jcHUgdmFyaWFibGUuDQoNCj4gRS5n
LiBjcHVfaG90cGx1Z19sb2NrIGlzIHRha2VuIHdoZW4gdXBkYXRpbmcgc3RhdGljIGtleXMsIHN0
YXRpYyBjYWxscywNCj4gZXRjLiwgd2hpY2ggbWFrZXMgdGFraW5nIGNwdV9ob3RwbHVnX2xvY2sg
b3V0c2lkZSBrdm1fbG9jayBkaWNleSwgYXMgZmxvd3MgdGhhdA0KPiB0YWtlIGt2bV9sb2NrIHRo
ZW4gbmVlZCB0byBiZSB2ZXJ5IGNhcmVmdWwgdG8gbmV2ZXIgdHJpZ2dlciBzZWVtaW5nbHkgaW5u
b2N1b3VzDQo+IHVwZGF0ZXMuDQo+IA0KPiBBbmQgdGhpcyBsb2NrZGVwIHNwbGF0IHRoYXQgSSd2
ZSBub3cgaGl0IHR3aWNlIHdpdGggdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24NCj4gc3VnZ2Vz
dHMgdGhhdCBjcHVfaG90cGx1Z19sb2NrID0+IGt2bV9sb2NrIGlzIGFscmVhZHkgdW5zYWZlL2Jy
b2tlbiAoSSBuZWVkIHRvDQo+IHJlLWRlY2lwaGVyIHRoZSBzcGxhdDsgSSBfdGhpbmtfIG1vc3Rs
eSBmaWd1cmVkIGl0IG91dCBsYXN0IHdlZWssIGJ1dCB0aGVuIGZvcmdvdA0KPiBvdmVyIHRoZSB3
ZWVrZW5kKS4NCg0KSSB0aGluayBpZiB3ZSByZW1vdmUgdGhlIGt2bV9sb2NrIGluIGt2bV9vbmxp
bmVfY3B1KCksIGl0J3MgT0sgdG8gaG9sZA0KY3B1c19yZWFkX2xvY2soKSAoY2FsbCB0aGUgY3B1
aHBfc2V0dXBfc3RhdGUoKSkgaW5zaWRlIHRoZSBrdm1fbG9jay4NCg0KSWYgc28sIG1heWJlIHdl
IGNhbiBqdXN0IGhhdmUgYSBydWxlIHRoYXQgY3B1c19yZWFkX2xvY2soKSBjYW5ub3QgYmUgaG9s
ZA0Kb3V0c2lkZSBvZiBrdm1fbG9jay4NCg==

