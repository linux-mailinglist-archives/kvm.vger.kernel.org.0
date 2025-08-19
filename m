Return-Path: <kvm+bounces-54947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C5DB2B7DB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F40F31BA234D
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E548A2D2494;
	Tue, 19 Aug 2025 03:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="BDXupjNV"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012054.outbound.protection.outlook.com [52.103.43.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6E61DF75D;
	Tue, 19 Aug 2025 03:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755574953; cv=fail; b=d1tscBXMpOoTcYa1KWTd8PXPi1B6dgzjzPXZxo22evQUn8urvH6ulG+m12FeYSR7qJKBKp64N24DhlLshPscQo9TiF8+xWY5eaKRKZtgAJ+ochUyUuPu9IDeiEXAD5KJfsjF25+sTEuHGcyURmqIRxlDZ213Z/6By/BTNKP4yK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755574953; c=relaxed/simple;
	bh=/yXBUAy310RwMAL5bjQoVuYkmAOBrAnDUl2NxGB08gM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m/hQH28n8eA0RWc2sHhr37F1McvPTkmd20I2hHg16KsfAR43s8L2IHLV51I7DblaaBq9Slj7ZPGavNhJx6FSBjwCv8+RSB6qOef4IWEG4maTjEZ0EC74FdVKG0Z5Pb/AHECtpmmHjhqxBt6MlxTMb3h5AkAE778n1rYvXaMP1dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=BDXupjNV; arc=fail smtp.client-ip=52.103.43.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdFOLSDL/SCiqgi1yIJkwf+617g90FHolZV8BHz2sU9kWJ8QS7wGpdbEpNy1uAxyTsDZA18+4uMtaQGHWNUKlk9PRqpdXppXKAR8ABFaED8neB8ZH+QqDekBwlU7eFo4OcCXn2G5Xzoj+N0lK/AtgcEICdmk1HF5nH4Et3Rieu8+SlFUxHqJ9d5o9xrVY7ewb8wQr8LFDfNPQdQOfDpfQKHLSmU8U2dI3rg3f+1WZU63G04zZHWrCyCk1pzQAyDGLx+jlf6/iBkg1VcfCcqP+5q4j889xTz4oWbLZ4b63ESmj/o0gUB8NM+nnPElofwUzZXRNJNYYmQQbZmOCUTwIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7wVTo0AZkcJk+vvnhstoxozjRdWAE45Bt3lPCBBPfM=;
 b=LgglJobVQDXmR+jToyQSLdspt6uJGbfVHDN5969WlkEOMY9McSsB3brZBLbI2/7B16DtCjw9OrA3f76yl68pHGtl1UJ7iFucnBkHxWPzQJMP5wqSyPJHsYj/pvQ7vy009qQQrUKo223tiKBKv0dmAmy7FT2fEo9rld4QNh+v2R9XiNCxNFGS6c6rB5X1pDLD6gS4FWD3IoKVwv3FN29dPx0fpGggCuelxuhdcrCixeZRUdmVl3vMWDedympgcwG/xIT4Mw0c4CIQdMHybTXjzl4GIosLDqeFHSkJj00e/O2jRPekyKKl+7ROSTl55oBc4XCLZqpiCvVfWzbz0z/Nqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7wVTo0AZkcJk+vvnhstoxozjRdWAE45Bt3lPCBBPfM=;
 b=BDXupjNVCQgAkYMMsxETjbTxjEdjhz33Pqk65cc1FoPjJOI+uoBEMLJTa8ToMh2xmOOXT3xpji60/GZ2WvtxcpLltaKmimA4Oyetsb62zBIbxhsjhVZ3k6b1Mb2G+E4SxQJNX7e0xAH1KLsrV9tzBCgpOOTNNZYIItTYwRwmorjKDTLZ3Z587qCLly78mwcrPSVE+NdnqjcHMeWIdhYQG+0QPoWEMy/oATHoLpP0sH5/k4ruE7GuwWgylCLpL7Ha3SG9tD/v1YjkyVXL5w6vUj5hsd3FZPhvidKgZbl5dMlSLOLhnzq1XHZsNy49laK2zuSZuYOBULT5sJQl7ltRjg==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SG2PR02MB5602.apcprd02.prod.outlook.com (2603:1096:4:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Tue, 19 Aug
 2025 03:42:27 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 03:42:27 +0000
Message-ID:
 <TY1PPFCDFFFA68AEA4D51E4FEB1C9C9807CF330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 11:42:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] KVM: riscv: selftests: Add bfloat16 extension to
 get-reg-list test
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <40e52ff7053401a2fcb206e75f45ebc8557fc28b.1754646071.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <40e52ff7053401a2fcb206e75f45ebc8557fc28b.1754646071.git.zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4P301CA0017.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:2b1::18) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <b526c05b-d7a4-42d9-9067-5f14b5be9e0f@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SG2PR02MB5602:EE_
X-MS-Office365-Filtering-Correlation-Id: d917449f-4147-453a-3998-08ddded26a65
X-MS-Exchange-SLBlob-MailProps:
	qdrM8TqeFBtg1x3yx1r6QKZAk6LGeuza140YguyADzWyUc9LH+4oa/gXfumtgXmSxggxD7LeUvy0TZxeYg1AtdjkgJla/8u88y4eRWUPPKTnexIrmfOHRBszPaFBFqJdVrhNHZw4TRyqQjStXoUlh2SWdv2bh+Yrkb/81PwVxvyfU6GJPw/dEJFHroZcQ0dzTBeKhmLpJO8oFPenGMbZjNcpC+ZJ9ZvRDNyAGkvOkod19iFyr1IFlYgpc6oOhmENe4WgzH+NYNMs2EopeY0uY95uqmNDpuLtzLcoE8dDJ/J5knFSFjTshYwPmTIJpsJRpfncU2ZK1IAC3sh2Dz319tAFL3C3iXQFHw+yD6owrEhfXj8xslDLBx0kpZxBzSJkcW2KRC9twu9cC7mJFiwPujWPHVcmaQrzM3yIHCve+Hka93DnPRwI+B3k7vh9kUD/wFsMcPYkhpC56d5aktXOgCZ7P1cTZ5VFctxMtPDaYR+5/AXL2f1gqIrckVWkzqeSzQ2+HsZseGquZK3DNLs0Xl3Xlkn57dHZGZ+MqActVvcsy+zNBBMg3otOIochEuewc5trhm6sZPRxQ1i5QP5qwT/M186+wm8Leq8ZApcN6jtlqLN73irJmI+k7RqyV3XfDwjWsCOUE+pZaO8WwIC4E6yzzWZfie2CilIWZKDEnYM4Y6R/IytWLGlwgVPWOXLYgqnISN8Y+gXRpcgjuPOWUvSMHbqnb4IcawguOnLBtTx0Q8gIHX4QMntCz+SIiu+xTtkzrHwOUGoZCdzsKD093xO+l6HwB/Zr
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|5072599009|6090799003|23021999003|36102599003|8060799015|15080799012|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bllSdnB1cDBpYTZ0RnpoK2FOSVdnNVlPUDJXYlUxSjZOZ0RYNTBQTDNuZ2NW?=
 =?utf-8?B?cUY0OUxHeGcxdXE2UTFuYnJXaUlvaVllcnFMN25TUVRJL3V0Z2ZkOFVJQndN?=
 =?utf-8?B?UkxwcTZUZ3NDdExuMFRQMTZZNXV4RG80eWhhZFVvNm5kRlo4ZHhjSzgwOTl3?=
 =?utf-8?B?S1VqVnBNVzNpbFBmeWViUHNVc1daQVN6V1F2UlZDSGc1cFFuTklsWkM5S2VF?=
 =?utf-8?B?aWR5cHNFL1pPclhCQkJNRSt1cUNvZE5lV0lUbFU1Yi9QUm1LS25TbUgrcUVQ?=
 =?utf-8?B?dGZhNllEUFhhNlFuTi84RVY4NnlVbkxGOXc5OWlsYXVsdndHSEtRaVpmRVhS?=
 =?utf-8?B?TDNSWFdINHk4OUVDMkFiakF4Y0xBYVkrYlJtbFhVczFOWlJOdUYyVzFjT09V?=
 =?utf-8?B?V3Nidm1nSjg1ekZkRjBHcEhQSUtiZTJmcCszR0dVT0dUdmRRRHZYV0F6cVc4?=
 =?utf-8?B?SXRmK0J0RDlRU1ZVQ3p3RWJKT1RvZkw5dGlQdXNnOWcweG9pVFQ5clJLZUw2?=
 =?utf-8?B?eFBvT1psS0M1bEprNkRDYnNaWmZDRlY0Sk1LaFNoSGZnMk1wQm9OQWVnelFN?=
 =?utf-8?B?ZTltZjVQTE1FdlR1OW9jQkE5NWJrMytFbE1QRWppVm03VjB3d2NWZG1XMzYz?=
 =?utf-8?B?MmxyRG1iZ2FkZCs0VnVJSVdhVjVzZ0hYaE5DUy8vUzQ4T2ExUWwwQWxySksv?=
 =?utf-8?B?TkRNQmVrZTMxQ1c5N056cXhUZm9LaTVPTXkrb3JuMy9wL0VyWGpNSGIvKzUr?=
 =?utf-8?B?Mi90b0lWRVB0Q3FXR3daQkFpYmxLMlBFZEpJTEY1MEFJd2tBejB4VmllSHFy?=
 =?utf-8?B?NlZWR3RJVEp1ajFINEMweUlwT1oxN3dLTE5PTDZLUzVkakZBZlpJNU8vV05J?=
 =?utf-8?B?Wno0cW1NYmtiZ1RnZUJyZ2NVSStGdjJlWlpKWGx1aDNMaFJNSzVjTmt1bHE2?=
 =?utf-8?B?Rk1ZRGR5NTNUdWs1Q0svU3RKU2RTYXcxTlZWMUNTYTNuOUdsaThXM3NoNFFj?=
 =?utf-8?B?WGhzRVp5Y1lMRmY1b1BkWTEzbXlOb0dqd25rUi92MkRiRmpsRDRYcDUwZEJ3?=
 =?utf-8?B?MC94d09rMkt3b1Y5V2tMUWJaSkFLOTNQaDVjOHArQ3B1ZEU0S1Z1RXA5R3JT?=
 =?utf-8?B?WWxsUXhYZGZBdDM0d1M5ZzAyUGhBTFJYYkFvSGptcWFQdjBvZzJCdGhmS01Q?=
 =?utf-8?B?WWNuc1lGUklYMWJ0R1ErWitrTDVWTlNUcjJkLzFKYk9ic2FoSWlyeXAwZ0xv?=
 =?utf-8?B?R1Bld1p6M2w5KzhIdXBuNmpnL0kwZVhQNE0rb3ZzWlc2Y0tvYXJacFBkN2gw?=
 =?utf-8?B?NHY4bE5DNFZVM2w4clhURjh1cW9iZENVbS9MQW0xY1ZKZUFvdUtRcGFqZkdt?=
 =?utf-8?B?dzcwbklSdFJqc1VuNitrdVRPVTdvZGwwOUkvbjVZb0RZczZ4WVdjUzY1RXZp?=
 =?utf-8?B?U2hCazV6bHJnbnpVa2hIZWhIRTJkcis0WkI4K1VhOENRRTRlWGhFcm5kanBw?=
 =?utf-8?B?YnlBaHlDYjhPcWdGWVNuR2Qvckg5b21lUDBDcmxVL3oyd1dvVFV4bllSRGdC?=
 =?utf-8?B?eWF0Q2JUVGl5YXVTTGUzaGxzam1QZVRLUXV0K1FFM2MvM0VnNmt4enhKY1Vq?=
 =?utf-8?B?SFpVOUsyVzVNa3hwV0sramg5WGJUUmc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlV4MXhleXZadTZ4TzVBV05JS2Era3dWTGtENVFyRTVqa3FDNUlUeWR1Vjk4?=
 =?utf-8?B?aFgvNUFZUlJqaEZYUWpXOUlhSjlXUTBLRTJFZTdpVG54aGxaNm1pK0xvcEpU?=
 =?utf-8?B?cVpYZHByQlAySi95OHJpelBZSjdzTlJUZ2k3bGlkYmVzMEFNakErYTZUcWJW?=
 =?utf-8?B?MDZxRFE5VE9OMVpKT3doYjhYL3lYT0U0TmRqZllEeWtReW5WaG1Ba3U1ZjZP?=
 =?utf-8?B?MWlKRi9qb21LZnZvVG1Nd05PaFpKWncwTVJnTERpRUlpSDdLZjZTN2c2NEVx?=
 =?utf-8?B?SVU0blZIYWh5UHp3RnVuODhuQ3RMSjk4NnQxb0R0NDZ3TThiUEhqRmpCS2RD?=
 =?utf-8?B?VnNWRTJ1bzdlVkhyQ08xb2RwenhjZDY1YzF1TzU4bUtMdVN2RmIxUHdtQkNx?=
 =?utf-8?B?dzIxSnJkU2ZQSHBVWkNLdVcwR0ViUENsTEZ1aC82NjdVMmVXcm8xZ3o5TzRG?=
 =?utf-8?B?b2FtR2s4ZG5XZkdWNEZseTVmc28yRmJqS2NuLzczU3hKTVFHQ1luQ1JBc0Jk?=
 =?utf-8?B?ZjM1am1QWjA2eDBTa29JQVpkK0dERUJESnpYenpzWHk2VEpSQTlmV2VzSDdE?=
 =?utf-8?B?YzJMQWJ6M2xqK0liblhCVkVGcjBtR2pFS1FtV2JhczZwUnh4UjlucUZLbG5E?=
 =?utf-8?B?V0pqTHFNTFRVdmVGWjNoUGlueVJPbVdHbzVQMGI2cHlSenh0ekpSWit3eE9T?=
 =?utf-8?B?WmhJNTVRNlhJK25xUEdZUU93SExCcVhidnRaSVQ4aU9PWjFMaFdRd3NGUyto?=
 =?utf-8?B?RG8yaDZOWjhLZFhaSmVTV29QQ2daclJOZFBNWW5Ocm9wbVN5T1FPT2d2c21n?=
 =?utf-8?B?VW5aKzdRKzQyZmt6NHQzL0V5eUVpeFdCandBVCtmRVhaZUJXSktUS2pIbk5E?=
 =?utf-8?B?VThJb2dTRnZGVldjd3B1MFV0QmJYbk1iSnhtYzU0R2VhdCsyOGEzV0RFeS90?=
 =?utf-8?B?WXV6YmJ3R1pkNnIxelg2anVDRjZJSmpUR1ErVE8rNEZKWm1kYWVOdGlscUVR?=
 =?utf-8?B?S2NSd2hjeGZOYVZjWHhCcWlSTkFoVUlXOE1HWlVlckhOU1RBTGRkTWlxQ0xP?=
 =?utf-8?B?Q3pJOXVGbVNOcWJSOHlyVitXTmRud2l1MnVWWVRJWlAwZDhPWWVDMkdEbDJI?=
 =?utf-8?B?WmhNT25HQ2liaWJLL1E4bWlHWFNPNVJ0Zi9NMlc2UDA5MHJwOEN3WVZsREZV?=
 =?utf-8?B?ZkwvY0IxSWdhYnJTSEhtMmIycTVhUUdUY3J3UzhYWjRaWDhNZENjZFhQV1VQ?=
 =?utf-8?B?VzhzOGc4QkZzY0tMY295aUNqeEtJMnNoaXF2NEV3ZnJTUE5qUS9ONkdUMlVr?=
 =?utf-8?B?VXh2eWk3anJsZnFpWWdRWlMwb1phcUZickM4ZnYrUDYrNGVMQlJoQldNTDN6?=
 =?utf-8?B?blduRFdjeUZkOFFPUG1Tb1JpQVhhek1QTEpPSHFlZVdNQktmK0ZaVHVPUUhj?=
 =?utf-8?B?b3ZnYjh3YXJMaDlvckIxTXI1OFoyQmhJYkNHMmZabnUzdzJhbUtUcnZxVjEw?=
 =?utf-8?B?OGZkYUxHZHVJMVUrVm03cVpOYUpid3NEK1NSTnJSdVB4YkpiZFgzanZPYnVI?=
 =?utf-8?B?eExLUTZuSi9hS3ZBK09VTXRacFFyMjZUcElENCtTRm1wVWR0aFdiaHZyM2hH?=
 =?utf-8?B?TzRpUElIUWtlNVY4NnFHRVU2ek1MRi9XUFNwSFg0QXBwYjJPN2tiVHJPUUN1?=
 =?utf-8?Q?LIyakziT1sF+r2BoWM0K?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d917449f-4147-453a-3998-08ddded26a65
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:42:27.0539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB5602


On 8/8/2025 6:19 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The KVM RISC-V allows Zfbfmin/Zvfbfmin/Zvfbfwma extensions for Guest/VM
> so add them to get-reg-list test.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

