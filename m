Return-Path: <kvm+bounces-16782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FD28BD9C1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 05:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DA741C2207F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 03:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7077B3FBA2;
	Tue,  7 May 2024 03:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ZYI3X9YM"
X-Original-To: kvm@vger.kernel.org
Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0614C94
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 03:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.247
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715053008; cv=fail; b=a0ymfkiIDHmi2VyKkkQCFRFk8/t2XTZDFxUQo4znIm8Gjo4WLwts46l7qFIXWlvpKIlkM2p0YLCmhyHS0OMoNYZTAFF4EAN4qJj7oElh0HeMs4l9eVBabzXNMWK0dVPVHxeUcNzx6tlH24Mlea0+YUWMJMKzvTy9d0Pe0RGT5AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715053008; c=relaxed/simple;
	bh=SjoMZ5sB006xp+KZoYXuBGFzqgzH7dw4QoCvnh6lGL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TxvvFywBU85pWo9+Hqw7EcGgtL5F7F56tehFE9b2CmXW0awKxWwbZlYQUIAFw5EY78G/HLvw0JYnXUTwhrA6f1zlLKYdaDel/fm0vgJ0yY54n3YGdpelRbBGeLjfoJNZfBR12eoL+C4gwxavEyloGCsXDTuoOrb5SZBDYUkTp0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=ZYI3X9YM; arc=fail smtp.client-ip=68.232.159.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1715053005; x=1746589005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SjoMZ5sB006xp+KZoYXuBGFzqgzH7dw4QoCvnh6lGL4=;
  b=ZYI3X9YMzdckXWlL7OSPW8qiCpKcRFMy7fwWyHbvzFP+hi7vD6D8g5Av
   mFrs4FoAVaFeDnTAYlhuzofHASslBNIyV+C8ItBBlcxodbXf5V6IkLy9j
   WpFD+RjSJ9IkEluK6fzP8nBQn7Anw0EGfZcEW4K+kZ13/QvWy0WdyHWR0
   U0fAGEWcLU9W4g6R5sy5PgjQA5e35tC9ARuKVepwoCyAEYA3y6yq+3yhs
   Tds/SlqNZsNs52oaG5aoxRxJ6LS+c2cMvzjmTz7Syi6aV3pqO6qMTSjzJ
   6Uuxedjx7B4xdILSZ1LVXkm2fqvH2AjwKttifKaxnnYQtsrT0j/bi/nR6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="118723771"
X-IronPort-AV: E=Sophos;i="6.07,260,1708354800"; 
   d="scan'208";a="118723771"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 12:35:33 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN1ix3OnSSOZ1cR7ADt7LsBRO9ctJDWkzzqvRZj6xkmSjEsdxtRgGRhNmyO09dAQT6H85Qo/gVqiCFUeAv6K2IZOlquNRp0MKN8WaFMIiiEXMo/Hu6FqmwNrknXFJdRfq/d+kIDBaSc3F8jn6U4hFbwCKsBbxD6maU4TBBJzfhAA7XaxRK13h+5K4QP0uxZlTNTbe9hcR0MxgXF6+9b9DnG58OgKMavorVAcgcrDoO9y8HPQZC+YfhFzcnksQW6XpFY7KPCCktzDfTia1/hqsiW2wQfsoIViiD9JSxzyPAIUtORF2fUfIORjn452xh7wPNHjf8vAPdbXgdMIjIjEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjoMZ5sB006xp+KZoYXuBGFzqgzH7dw4QoCvnh6lGL4=;
 b=LZ535CVcq6E2+/JHaVjDXiGG4Yo3SdGXDbuyyPOdLVXXbqbULIGaoHofKekhJ8aVQ7z0wvbxkRWJXVt5DSEh7RrPW3qIPR4ekuCxrYI1Jzo9UMFlIbiyZTxQaPAz1LibsK6RTgBRF6t6zvXrtm2a6vDsi9TH91eE8SMact3LTY6gW9qDvG8faibXIdF1BTc4tTR4RI/jbhcezIzhw8s2czqTFMk0TsoX42JiEsLGeAD/drIbCNH/67v9MVvTZZdynYHecUyeXSq47f9RNFw3PnvlUFOxY9YcmS91KzT/mG0YilqtGt96Vwhl9Ew/ILyDlyuy61idhY0Q2HVggCWX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OS3PR01MB10264.jpnprd01.prod.outlook.com (2603:1096:604:1e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 03:35:30 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 03:35:30 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Masato Imai <mii@sfc.wide.ad.jp>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, "open list:Overall KVM CPUs"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] accel/kvm: Fix segmentation fault
Thread-Topic: [PATCH v3 1/1] accel/kvm: Fix segmentation fault
Thread-Index: AQHaoCmotMx52+wos0+svcDPRwqlhrGLHq6A
Date: Tue, 7 May 2024 03:35:30 +0000
Message-ID: <0c3c1e7e-c8ab-c11d-9327-aa1c094ceb1a@fujitsu.com>
References: <20240507025010.1968881-1-mii@sfc.wide.ad.jp>
 <20240507025010.1968881-2-mii@sfc.wide.ad.jp>
In-Reply-To: <20240507025010.1968881-2-mii@sfc.wide.ad.jp>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OS3PR01MB10264:EE_
x-ms-office365-filtering-correlation-id: 8d7bfdd4-0850-48da-e08a-08dc6e46be63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|376005|366007|38070700009|1580799018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MVFxcUFxY2JieTdGb0IxK3NnQjhSeG00TXFFUXZ6ZXFyOVozQitzeERob2N6?=
 =?utf-8?B?cEs2K1lDempUWjJzVko2cnBMZkFxUXJNd2hHbDRBVzUydGhyQWQ1cE9JbURn?=
 =?utf-8?B?eUVsMkhSdGtSR2tadU1YMEFnS0hPVXZzSXQyYk4zT0htaEhGdkdhL3Y2eTBv?=
 =?utf-8?B?MzM3b2dsbFBUN1BjV1k4cGlpUFhieExUYUVnQXhVMFgvcENGY0JCaWdjWTVN?=
 =?utf-8?B?SFgvbHlrOWJxR2pCWm93RW50WVVIWXgrY0duMEMyai9GeTdISW9DdWRtekhD?=
 =?utf-8?B?a0gxMkMwQjlvbVM2dDJnNWphQkoyN3dwNDI5SU02SlMwd2FqMjlTNERhNkc0?=
 =?utf-8?B?Y2Vwa1hZRE5TbE5LNDM3dmF1K21qd29tTVNpdUI0SWZCNzhpOXZaK0crb1A1?=
 =?utf-8?B?bGhJbDdKTjR4empFR1BvUTJvT2JqZGhJaGVsVWtIUmlSL3pBdGIwVVEwekdo?=
 =?utf-8?B?NGhrdGM3Q1piSWJsQlE1VkRPTTJWZnNWdXZPdjh6aXVCU3UzQkZWa1IzWmNj?=
 =?utf-8?B?RkludlhHNWVtVEpDNk54dE8wRi9CVXB4UGlWZ2czdDltMTFjYUk2OHgyZHdi?=
 =?utf-8?B?bUFHNS9IKzVJejBta0NiK1MvOHhzN29ZeFFEdnVoOCsvWWxDQlJ1V0MxRTFS?=
 =?utf-8?B?dVVoVDVkUHZrTlIzOGJGL0tZakxncXMxRzBnQmpmbS9uOWx1NkxFS1FsWCtH?=
 =?utf-8?B?alNQeW85clNqZ1VDcDBubEt4SERYaENUS1hMY3ovOFBaRHNmcWFuUjMzTHQy?=
 =?utf-8?B?bEpjS3ZHU0djQm44ZEVoWHVoUHBEaTdBRUROaGlONW1Zdi9ER0cwcmQxb0VP?=
 =?utf-8?B?ckkzREdoeE9zODVrcDVTUGtOM2RYdUVqK3ZWdkZBSkk5dlNXMTh0SVREeGJS?=
 =?utf-8?B?ZXdjU3RhT2h4TjR6SFd4aW4vOTU2RmdVSkRiK1YyT0EvOW50ZGJkSmgzRDdw?=
 =?utf-8?B?Mlk1WE9yN2xwa1kwTUlXL3dPMmJzTUlhTUJyUnVQcURvMVFoL0RGT1YzZktR?=
 =?utf-8?B?dzB6SjdnalFObWgrRk8zaDFnZWJKRDhtSitrYlRRTFVvOTZ2dWMrMGZJTVE3?=
 =?utf-8?B?SDQwVE1QNnJpWXhVcC9XZUwxQnVSWGppd2VaOUR4dk1meUlMUytlU2RzZGdK?=
 =?utf-8?B?MUUrU3E4Z0taTEpITWl5ZCtyQWJ6RG42dGxrRWtDWXJodGgzcmxmWFkrV0hH?=
 =?utf-8?B?TnluZ3FvVElTenJ0NUFlK0pYb2lIU2ordERwLy9EQ0FYNlpzejQ0d09LblBG?=
 =?utf-8?B?K3FuKzRKdFJrSS96ckgrMHdXQlhWUmxqUFJnaGlwWFNMajZuVFNSbmRLNnE0?=
 =?utf-8?B?NWRMYXl0Y2VRd0tubGVFYndzb3dFNjhZa1l1c1puVVFqUmh6MS9RS1M2VkZM?=
 =?utf-8?B?TWkyTDhyU2t0dEpORmhmZGdIN3o3UVhPcHJLRE5nbVZ2MER4cVVJbll2Y1gy?=
 =?utf-8?B?M2Z4L09UTDYzdnJRdFVScDZ4L1Job0J0VTl1L29kekJ2R0FjVndtYXl6RWZP?=
 =?utf-8?B?UFJBOWZXczU2TStBVjF5b0tzZmtrUHUxZHk0dWFkUTJBNzVGclhFTG5hUTlS?=
 =?utf-8?B?RFJSYlBYSExPTEdpcWh6dWNUUWtvclRGSE0xbnprUmFmb0VLcldqejIvNGpj?=
 =?utf-8?B?d2pvQXdibWhtMWNlSDhqbW9TWHowQmlObnA2SUorbU5ZNzc3eVVtOUFEd1NU?=
 =?utf-8?B?SWU2TEhISzZwR3ZXQlNNS1dyY0ZjTStvNThVSWxrSW44bVJmaVZpb24xbFVm?=
 =?utf-8?B?VkFpenE0YTNSUFdHcExrS3JRdGl3czdORjB5d1FlN0pScXU0bExTTzd0NjNL?=
 =?utf-8?Q?Bgtto3wSZMAuRFfay6OKMHRWiSd/m/86oMOKE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009)(1580799018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eitmcVdTYXZzeXJSWnFiYlcxUUtpK01Ka2Jmanh0TGc4cXpWTndibG1SRjAv?=
 =?utf-8?B?T3JBSmk4dWhSbmFQWC9YeWQ3aGUydXdUUFNCVVBSdnprQ0Z2UWVGSHFHR0NJ?=
 =?utf-8?B?THhxOFhPRy9tY1NkeVBBRCtWaDJiTWVRTzdxSHJzNEtiNk5tamJBYzdVK3Vn?=
 =?utf-8?B?bDc3amI5bVRnZHcwbXlwMzBtUWM1R00rRTBmQWkydDFGVEFieFJCOHltblRi?=
 =?utf-8?B?Y2tNQ1FNNUxGZU1xVkoyK0ZXNG5iYkx4Q20vK2t3c3pydjlSaGNZYUlBM3Rn?=
 =?utf-8?B?MnNyMTdmVXJzWUU0S0o0aU9oN2hkcGdsTlRQLzBLbmVXZGd0YktzakJpL2gr?=
 =?utf-8?B?cXFOWmtKWStLNzNOdnRBMmJGazR1NlZ4WTZsa2YwcHV2TWwyYWpoNjBucW9C?=
 =?utf-8?B?ZkhSSWVPaVE5aXNmck9FNmFPUUJzQ3NueTc1NmpSZEJ3VHlBU0RrRXFwenFF?=
 =?utf-8?B?UXpvMCt2MXRXUFdxQXdZOFJpTlNjOWRjakRoaUZGMFNKbi8wMzgveUtVZUpJ?=
 =?utf-8?B?bC9JamFCZWlHTHZYdldsNXVwdm5DbE1EMXJsZTFiR293aUx5VVZ5eDkyZEJO?=
 =?utf-8?B?L0R0SnIya1VqN3E4TUpHamlLeGZMcTZTejhCbjFNWXZHTlFpbDhpa3QrNVJZ?=
 =?utf-8?B?OUQ3NHN5ZHFNM25UbS9TWDNMOVYyRkhONFVocDVWckR3a21tSkJ3dDJuVTZz?=
 =?utf-8?B?ZGl2VUY0K2txVkVieDBXbWNENVFQWTBoQkNFZHBsNVl1eldwUkN3NHJ0bG5D?=
 =?utf-8?B?ZGY3Ny81RklhZ0RZd3pGMHRMbVdVaXVRUlVUYk5lZHZRbXg2NTl5c1JMZ0NF?=
 =?utf-8?B?NmZ1Z0U2UFVNWS8wTlh6L2xxT3Urd2lRSkRQRjNjQStmbUJPZzRmcENweGlC?=
 =?utf-8?B?eFNiNlluZ0N5L1NOVDl1VncvbFJZK3lQVUY2L1kxUlFmL0xlZUJ5RHpsaVc3?=
 =?utf-8?B?ZWVpaU1QZDJySGhEcDcyeExXWnNTYUl2T29aTDR5NzN4TXRtczJhdmlhNWhO?=
 =?utf-8?B?RlgvVnVjTWp3WlpiLzNleG50eElaV0ZER1Jrb2Y2NThIUlNhaytmRnpHTmdD?=
 =?utf-8?B?ZmZ5MGN5N01KTHJiZzBzakdtM3ZUTFJrTkIvbTRpdUkvN3hiK3BYNDdNL3hj?=
 =?utf-8?B?c0RhY05mRXJ3Ui9vRjV1akRCYlJHY2NJZkM4U2FhWVVIUWRlRjFxSHhTd1Zi?=
 =?utf-8?B?SWNoZFlTS2FaRmtGb0UzWFZEY0kyMko3a0VVM1o1bVdPYUlid25ZZGZyNWJG?=
 =?utf-8?B?ZVdSN2dzcVlNUHVyM09paGVXV1Zuci9JQzZZWEZiRWZoc3VmWHNCT0Z5YXo3?=
 =?utf-8?B?QlA2bVZQNGxLVDdZa0hYc1RxK2k4SVhuT1NYZGVFV3hWa2c4cGdQd1gzUFBn?=
 =?utf-8?B?Y1NJQjQxbnhGeHNtTE8zVXNBYld0YVJFYzhwRXJBR3VwdHprc1c5ZVlWYWNB?=
 =?utf-8?B?VkUyRmlVUFBFM0NLdWt4L0RvVlhEZ0twOWdUNlVzSFhxYSs0dlZNNmJHUlU3?=
 =?utf-8?B?UXBGMEhiMUZHOGtSbXp5Q3oxc0U0aWdGU205a09ndENvUFZtQTY4VzdnNHZh?=
 =?utf-8?B?SXN0a0s5Z3FMem1WQjZIb1NyaFlOSlpHV3dabEQrSmdWZXNZL01KcWhqbFA0?=
 =?utf-8?B?U091RENVd1VCN1diN0drc2JRRnQ1eVFVOEE0WVMreGQzZkd4Njcyb1hyWHFn?=
 =?utf-8?B?ZnRFWDZ6VktGV1hVeXp3VFVqSzZFY0hqN1RyYmVkVys2U0JWZlNqWXl1NGQ1?=
 =?utf-8?B?eEczVkc4RDJTRG9MbGhYM056Um01VTRORktNZ0x5R3NlWEFmM05BOVFDeits?=
 =?utf-8?B?UFhDMFNQUVdMOUluQlpEQU1GSE16T3p5ZFFLeDVsUzJyL091UW0xU2JpdmJk?=
 =?utf-8?B?S0ZKVmdGNTYyZ2g5eGZ6Z0tYTFdQRENOcmZEb2x5d2NWM1BwV2RUS3dla3F5?=
 =?utf-8?B?K0dKSXprcGc4aWU3bGhlQkF2VFFUKzRLd1BQU3ltZHQ1UFU4STZWaFJkY0tl?=
 =?utf-8?B?WnZHcE9hM3l3N1B4Wm1ZNDF0aW52NWdSbVFERXFNSjU4dDdyV1lFZGFmNGQv?=
 =?utf-8?B?RzVUdWhWY0Npa3Bwci8rSHZ4YTdpQ29TQ2VQbDdJYmFwVGlmOU0vL2lNNmdD?=
 =?utf-8?B?cVR1b2xNelJ3WkgzL2REQjBYZDRnbGhQOTdPS2w5ZCtWWXZkNm5Yb3Zqblo1?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3D6B28D12CC454084C95E8DD41B0684@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/FSKm+oRGlrDtiy46O5QLv8pxlnfPos1Afldbh8VZF59yS0VouJ7qxblcwaBBH65Bz4r/pyTYArnS9zv9zbg8nPQeogixQFR7AcdM5261S+9aOFRwNhU7lsjOIIlKVpneFtuenNfpYqRuSye2iVrx8QoDIy7j6LFSMKk8i70VK/nqV6E0ViUvqs6lpANjA2bfVInRa1ev1QuEGsZWAzmvd7V7cuchfTaqN86p5yIOx1ICqqRsKA4Uicuceh8PhxpuRCVasnKFZZM0kD3SB4mPb1PBP6NgvUotHXIC+rn+WSqs1n3hZb+VmFTWyJkpzycsmi/7nHVxhR1w+3qBZ7ToITmtI5Fw3yyKPiLGqFIJzpipdngMhEI4purVZmOvrW6ZrUHzOgB1SfBEaNzuWrUFvcB7ZKwwwEMg7MgS9YuODhHGaOlkhXaKTFqYK2P1xmTomXFwIzro1xr6AXn/pSdXRn8+YyjGkiZXsxh1fKfh9AeLwGtiW6tbmZkIf3VPy6eocP4Qy9ntQLmRO3z7pNOZDppHJh3LN5EhUlzhy2VsJ/tg2fpRnW6+yxKcCAhicbjD/COT/llkJRS0/4wCERwrvG2t2FH5T380e2W5+emPoDIyPOY9VK0emFGsgh+3lph
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7bfdd4-0850-48da-e08a-08dc6e46be63
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 03:35:30.0266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJG0+mwoSRIQfsL2szdNvXiznuOamBktQMx8p1SiYl1QLszDaTWU7sUMmnrHhD/plWg4VSpcP8WhKuUgS6L79w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10264

DQoNCm9uIDUvNy8yMDI0IDEwOjUwIEFNLCBNYXNhdG8gSW1haSB3cm90ZToNCj4gV2hlbiB0aGUg
S1ZNIGFjY2VsZXJhdGlvbiBwYXJhbWV0ZXIgaXMgbm90IHNldCwgZXhlY3V0aW5nIGNhbGNfZGly
dHlfcmF0ZQ0KPiB3aXRoIHRoZSAtciBvciAtYiBvcHRpb24gcmVzdWx0cyBpbiBhIHNlZ21lbnRh
dGlvbiBmYXVsdCBkdWUgdG8gYWNjZXNzaW5nDQo+IGEgbnVsbCBrdm1fc3RhdGUgcG9pbnRlciBp
biB0aGUga3ZtX2RpcnR5X3JpbmdfZW5hYmxlZCBmdW5jdGlvbi4gVGhpcw0KPiBjb21taXQgYWRk
cyBhIG51bGwgY2hlY2sgZm9yIGt2bV9zdGF0dXMgdG8gcHJldmVudCBzZWdtZW50YXRpb24gZmF1
bHRzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBNYXNhdG8gSW1haSA8bWlpQHNmYy53aWRlLmFkLmpw
Pg0KDQpMR1RNLA0KVGVzdGVkLWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+
DQoNCg0KPiAtLS0NCj4gICBhY2NlbC9rdm0va3ZtLWFsbC5jIHwgMiArLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
YWNjZWwva3ZtL2t2bS1hbGwuYyBiL2FjY2VsL2t2bS9rdm0tYWxsLmMNCj4gaW5kZXggYzBiZTlm
NWVlZC4uNTQ0MjkzYmU4YSAxMDA2NDQNCj4gLS0tIGEvYWNjZWwva3ZtL2t2bS1hbGwuYw0KPiAr
KysgYi9hY2NlbC9rdm0va3ZtLWFsbC5jDQo+IEBAIC0yMzI5LDcgKzIzMjksNyBAQCBib29sIGt2
bV92Y3B1X2lkX2lzX3ZhbGlkKGludCB2Y3B1X2lkKQ0KPiAgIA0KPiAgIGJvb2wga3ZtX2RpcnR5
X3JpbmdfZW5hYmxlZCh2b2lkKQ0KPiAgIHsNCj4gLSAgICByZXR1cm4ga3ZtX3N0YXRlLT5rdm1f
ZGlydHlfcmluZ19zaXplID8gdHJ1ZSA6IGZhbHNlOw0KPiArICAgIHJldHVybiBrdm1fc3RhdGUg
JiYga3ZtX3N0YXRlLT5rdm1fZGlydHlfcmluZ19zaXplOw0KPiAgIH0NCj4gICANCj4gICBzdGF0
aWMgdm9pZCBxdWVyeV9zdGF0c19jYihTdGF0c1Jlc3VsdExpc3QgKipyZXN1bHQsIFN0YXRzVGFy
Z2V0IHRhcmdldCwNCg==

