Return-Path: <kvm+bounces-69079-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LoUJyfudmkQZAEAu9opvQ
	(envelope-from <kvm+bounces-69079-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:31:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E1583E6E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6E2433002902
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4BAF30BB88;
	Mon, 26 Jan 2026 04:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="ALM7Z55e"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012051.outbound.protection.outlook.com [52.103.66.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990911C5D72;
	Mon, 26 Jan 2026 04:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769401884; cv=fail; b=GFVphbiUOMKPIqkxUQ/9U2/2X9vIdV+LtLGWbYokOKg0IV4Lg+x6mtn6VP//TGlrjZAaAMlfixdiwxYtD3gBoYZhTdmFpHAhLUGIMrLe+GYTRqMGsWAr4yiaKN0aYqidFcMKpHhrb8crw7vhdCHzs+dstA6YeGMF//73J2u51ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769401884; c=relaxed/simple;
	bh=xndf1ryPNuw4dpNyGQLq/tkzSMiS08i0u6YON2bVj3A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=leC//SC1HAIWdNm253YZA8Vuiu8YRIWJUchGccQzRyXV1HcpS2vkk0wbOyYQOokkeGV498Z1T6T0rtSVYLr3Ddqh7/ijVD45d6I9KAgYSWUpLGVSGWWcJqwuUfBKB0T57w2iQschgNY/DST7F3wZphKLL/phX9dG1FTD8kolhLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=ALM7Z55e; arc=fail smtp.client-ip=52.103.66.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYoMrGFinOypvt+kUbcPeZapEAS0NwkmE3vcUmxQEHXTY92s04jzPme1+arN1L3r8Ani1vaDHBSazFPb12CYLe9viSldszfZBkJgOH/Nvx9x8DQbfMU56zeERcMOAD1tymm8AiyTUpJqP56MHJgGRGmcm4zUw4FU0Q9ve0AfEcwKyo0Zf79d797gqCY0lVkAY7hSHlzyWwXHOAtOoD9+hsQEnwE6uRZEym5ZPQBWicttYGg5q7vkBdjKS7TiWailh5XTNo80HyQGti5ZfmGfiFVHAOFJZgS0sz1ktDmk3MtIbDJzG0GDLhzCLKrLf4uL75I/JlKMzouvEzZOP5FvoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRH2Hbcc/UxcPYfeQfKGE1xEss5lo6gwLvohMwbx5k0=;
 b=v4eXscFi8xfIcD8mafCShZOeYOZJED54tk2XIVK4rUB6Th2h+MM0kVit0tk942ebi4kIGtAIb8/7Q45oDNZGr5IxTs6rDnEClCa4xYNxS8miFugp87SvAcUguL4vRjCq87r6bwJrYm7SI0GsjXUT59qsD/oflcICy4E/cR8Gdztk1efY/3X0Y6EF2sBph8xliFCl0fza6IRxIIhp/vq72rZ70XEnObDU+3jfXp7IQPTwYZIGNwvhv8W8dIk5D3PtO/37j59JOsrXPqFv/jcdx6DPG1EjEdB39bBzMVIijHfYhOcWs+a/itMqNE0L79bE6EotA5ed65HdLnNmYjcXiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRH2Hbcc/UxcPYfeQfKGE1xEss5lo6gwLvohMwbx5k0=;
 b=ALM7Z55eUvI/Row1bRA36KSLBUfcdVfYv2X3hwsfr9jHaXJezCiEs+B+/yhVyb/e6V+dYPe6+8GpmY6l4P/XQ8FBHhqrasG4tHz5gwQB4LxaChxl0oxBNC46UxPamW6XM9/+QNZp9pwV2YRN0yoZWHf/8ickfdMJ/sFUCHf3gwznQQtdCvYRMfsvHJ+m3D3cG5zJeTp8565RXve7JTR1WH227svnd8othNhchIfaoA2ZvRUe5RSqqzE3bMuS4oG007OxEmeGXiNTk3lrWjc6S4ST4DWz/1vTVbI8ePVCKgKeM5xpyn5LzeiiBGJ+s5jcofNTKpBZ7JWLh7vr7RPVig==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYSPR04MB8267.apcprd04.prod.outlook.com (2603:1096:405:cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 04:31:01 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 04:31:00 +0000
Message-ID:
 <KUZPR04MB92652C4D69EF09E324916DE9F393A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Mon, 26 Jan 2026 12:31:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] RISC-V: KVM: Fix null pointer dereference in
 kvm_riscv_aia_imsic_has_attr()
To: Jiakai Xu <jiakaipeanut@gmail.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
 Jiakai Xu <xujiakai2025@iscas.ac.cn>
References: <20260125143344.2515451-1-xujiakai2025@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260125143344.2515451-1-xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <bd62e925-acd8-419a-8875-764af17cbcbd@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYSPR04MB8267:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c5b8ff-cbc4-4cb9-77ee-08de5c93b52d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|51005399006|23021999003|15080799012|41001999006|8060799015|12121999013|7042599007|5072599009|6090799003|461199028|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjNyUEVDQWV3Mk56R2RTRGp5M2xOeG5aYks3UHlaV0kzZExKRHByN1pUTmFG?=
 =?utf-8?B?ODVYaE8vV2k5eUNHUm5HUk51SVJETTZsSHVGbHlKSTU3MlMxNEExVE9QZVRR?=
 =?utf-8?B?NTMwYysxN1lzZGJacXU1ZDlQaVRGYmdraHZSNXJ6UW9tRExoTEhRNW5qWEJH?=
 =?utf-8?B?RlYwa0twUXdWMEZyTkZhcThBNS9IOVJOSkdmWEI5UjdzVnlkWTVNdjZZVzhL?=
 =?utf-8?B?dDRObmJSWGVDMFpzc1N2azlGWnpUQ2hmaTZJckhBZTg3dlFWcURnYkU0cjgx?=
 =?utf-8?B?WjF3enlZZEU2Rkt2c1BUY05rM3JTQUlCa0lvWTZscndpM21lcVA4SGlkMmh2?=
 =?utf-8?B?c1RqZTIraG5tYUkrV1doQ1ZPN3NVakxLcUZKRWxWU0hyNk0yUVlIcE1kb203?=
 =?utf-8?B?NURUWnpmQWlFaWRoVnZqQ1k5NncrVFpIQ3RWMVhsa25zOFRKUlVUY1lUUWJz?=
 =?utf-8?B?TnJ5VWpNS1NtMWlXVllGcWhsN3FoTXBIQmpRa0h6VUxuS2VnaXJrNzlZcmIy?=
 =?utf-8?B?Z3ptQTIxSGhyT0p4dGlpWlorT2JzSHcxUzFNZDZZa2JJUjhhVzAzMDNVL0lx?=
 =?utf-8?B?MUo0T3U5RVkrdlljUGFDUWRGeSthYVZsL2dPSVRzSkJFVllSVVdSMmptak1k?=
 =?utf-8?B?RjJ0WlJSSnRIWmg5WTJOM0x6TzE2Mko5bDJkMndBcU45MFhua3lCY2tYWHZE?=
 =?utf-8?B?MDVCWjVjeXJWOFRkS0JMaHN5L21mOVE5SHM0ZkNGR2ZhRDEwU3FyUUtLSjhq?=
 =?utf-8?B?S1Z2Y2dXdkpvQTh5MVNta2dGQkZxbGwvQ2JtZzZUZXl4UkpyQlMxd2U3Umdq?=
 =?utf-8?B?YUF4M1VwQzlwTHljVm1rMHB2YUxGTlh2Tk0xMEs2SU5TUVFsT0wrRlVhQWIw?=
 =?utf-8?B?Yy9TWmpaYnorN0xIYkpTL3FHV3Mwd3Zla2lmRkpCU1h5SWxrTjZVeDVmR0ps?=
 =?utf-8?B?Wkg0WVlHa0ZUMnlHeUlOMzJVQUVSZWU2RHRqZjc4VVd4NkFiZUVZdjJPeFRx?=
 =?utf-8?B?aGpSaHdYOW5EcEJJVDdSbmdsK0ZFK3lDUCtOUmVSRkNPVjNWaEhPMGJCNm1v?=
 =?utf-8?B?Mjc4NlEzYTVEK25XWHJnZVJ4c3h4Rkg5Z2FlYWk1QmJaQ2J6ZWR3UWRvaUsy?=
 =?utf-8?B?M2w1anpycDhKOUcrQitGakhQZGtWbUxYMWJGQnN0VENlb0dreHFSanM2VHFK?=
 =?utf-8?B?WnFMQWZpUktjWmJ1bFl5ajF1YllQYU9idGdqaVBoOUg0K3ExRnhvZUZ4WE1q?=
 =?utf-8?B?RE1Gb0xMUDJaeGlwOWhZOGRFa09teFkwNnhPTlIrSDM5OUFRT2ZJQ3FETzFw?=
 =?utf-8?B?RXpBa2cwN0dOck5xOStkV1V4TmRJb2JBeERudGI0KzZwYzAzU0UzUU5aNnRs?=
 =?utf-8?B?ZUd2RWtCL3ZkOFo3dkJHTkFNcnJOelB4bm9VT21GNkxqamRmRXpnbkk2cmZ0?=
 =?utf-8?B?K0FqaXJGdmZpZnFid3EyV2NlQ0F2emo0aU8xbkFHa0VzVnJlVUN1Q1RKdEZm?=
 =?utf-8?B?SUxDaWNTZXBhd21oaGVuUkxucGxsaVhoYjBCNWFBbUFiRk1YczIwMzMwbGhO?=
 =?utf-8?B?N3RsY2xONzVJSDl3UEE1NExydndnQk1FNXg3ZWd4Y0J0QU81QjNKUjgvZSsz?=
 =?utf-8?B?cUV5YUtWRlVyQ01hTGR2KzJLMjFYUGY5VHVIUlpwai8wditMMGRzdUkyYUhM?=
 =?utf-8?B?T1dXeFgxSE11WVJYejNzVCtGVHZZUGl0Nkx5aFNERnVBTGR6SElCdFpBak5X?=
 =?utf-8?Q?soIPbg9y+DutR2OFVs=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmIrWWc0cUIyWjVEeTNyeVpvTlRZbFVaa3dNemhyNHhrZTdHRDBOMWNtOXhx?=
 =?utf-8?B?VjIyYkNic1lhN1JDVk1BTlFzUDB0WUJELzBhVFVHNkJLOWRoZjR6Sit4T0U1?=
 =?utf-8?B?QjdDWm03aEluQnlORVZQeXBVYTNmNWliSGRRMldxcVJJbitZUHpIRTFoOEpN?=
 =?utf-8?B?UVJ6K1cvNkQ3M1NYMVJMV2t3QXFjQVdGVWdlNGI0a25naWNMU2lrYU96eTAx?=
 =?utf-8?B?c3dFS2plWGNLaFlXRG1hQ2wrYm9oZk5HdWFRSDB1VUxSWjdXd0U2NUxBZi9r?=
 =?utf-8?B?Y2NrakI0Q0p2U2JKdkxRWEEyU1BGU1JaaG9ZZml5azBnaEwzd3VQNHZMWGlO?=
 =?utf-8?B?Y201NVdrUGRFOWl4RjlDS2o1WWF6UE03dmlHOFVSNnJtM1JmNGNvM1Z1OU4v?=
 =?utf-8?B?Nko0dzNHNHRNOC9RYkxMR0N5V0dEWm9XOEp1TTkzNHJzWGR6Q3J0aDFFRTl6?=
 =?utf-8?B?SW1vcUc3UXhjSVZibVkxYmxnNElQaVhOVnh5N1VqQlJKeDdrNG9CdENHNC9P?=
 =?utf-8?B?VXhOVEE4Y2dKemZZL0thTUhSTDFFTlFFR1pwNlZHSmhEQkRVL2p2TmhoeHVz?=
 =?utf-8?B?SnlTNkxHU3RadjI1K1d0aXRtMEpaU3h0dTdZN2taZEN5aWJFaXB3b1ZibWVL?=
 =?utf-8?B?eE5oTFZrMmo3VTIzSlhJekZ5SHArZXptWjBreEdQVEpWaG9Oakx0OUtiQW1Q?=
 =?utf-8?B?U3M2K1gvVmR3S3lMR2QvQXFjTEZsNkkwTVhrRFVjM0JpczFlZVRqRklqY2I2?=
 =?utf-8?B?bzlMYVcvbWtzTVBoN21FYnY4Yk9uZ2ZmSjlrcUxyRUlTbFVZQTZQYVQ0ZWM3?=
 =?utf-8?B?WXFlUUhLNUpQOW1nS3ZNU0tCWm1wbFRpbjhIYmY5eGJtYUdDWi9Vd0J5TFgy?=
 =?utf-8?B?amtOZS9ZbStEZ090emhWbURwTnI2V0FhU200S3NkN01lNjRhSU5WeDIzcjVD?=
 =?utf-8?B?U25OVkZibTdTMWMvYzVmT2o1bUt2bXVDMklVRCs3TTF1Z3RqMnFNUjNSc2JP?=
 =?utf-8?B?UU1sNXg0Y04yR2RjMmZCLzQ2cExnMk9wYWJzRVhnMW5jclliUDhMUHRCaWZo?=
 =?utf-8?B?T1pvQUE1YjJwaGVnMTZaRk51djl3MllwSmtJSE1UOHZhWFZUMElkblB2YU84?=
 =?utf-8?B?ZUFueW5NWVE1c3hOSkVjR2hObTQyVFpQZnhyejdST3pheXdvTTdvZjdJRDQx?=
 =?utf-8?B?TE0vUHZST21xZFo1Mkh6M1d0dUFtbm9hWEpmYTV3WlBqMFc4dFEzdm9Cdnpn?=
 =?utf-8?B?TDhXRXBrNjN3Y3AzeWZrL2QveUtJc1pURVpKNyt4d0ZhaWdjQzNhN3NpZFZT?=
 =?utf-8?B?THhLMVFBd1IvaHJIWGdiaGxQaVU1K1dkWEV1SXczRXVQY1dvazFOZ25nVWMz?=
 =?utf-8?B?d2pPRDl5eXdnL3dLSnI4TGE2NVQ3ZTNPYkxSeTlRcmpHUTZwWHBEdUttektO?=
 =?utf-8?B?d2FhUDl4c09KZGE3YUtveVJLWlc0QWdNWU5jTk5MemJKKzBvbzREQjhtcURL?=
 =?utf-8?B?QnZwbFYwS1BldWJYcmJibTNtZGFqN295NS9uaHU4M1hnampaMDZ0eFVuYk8x?=
 =?utf-8?B?T0lvOThWVi81ZGwzeTVLL1RPVjhaQzB3Y3Qxd28xbXhsV0JoMUlVZVVicWJq?=
 =?utf-8?B?ckthczJESTVyc0lHdE9TNGtidWE3SE00V0J2dzJXdGFvMFRENnYwbDB4ejRy?=
 =?utf-8?B?bGh5eTdQa2Q3bE9oWUpmdG9kdGFMbi9jU0pCelZKSEptYzRKMHBWSXZoRk96?=
 =?utf-8?B?bUI3V1U5TDgxZmcvWUkxNlJlM0d2QW4wWlk5RnF4NXZteVU4M1ZUWkpwSDhm?=
 =?utf-8?B?NWVWR0RJRTVNeHVIRkRRMXNNNGNVNG0zc1FaY3NzVEgweDY4c1RYSW1FVysx?=
 =?utf-8?Q?zM6TID8TE4J/M?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-515b2.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c5b8ff-cbc4-4cb9-77ee-08de5c93b52d
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 04:31:00.6858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR04MB8267
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_MUA_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,lists.infradead.org];
	TAGGED_FROM(0.00)[bounces-69079-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[hotmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nutty.liu@hotmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DKIM_TRACE(0.00)[hotmail.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[KUZPR04MB9265.apcprd04.prod.outlook.com:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 92E1583E6E
X-Rspamd-Action: no action


On 1/25/2026 10:33 PM, Jiakai Xu wrote:
> Add a null pointer check for imsic_state before dereferencing it in
> kvm_riscv_aia_imsic_has_attr(). While the function checks that the
> vcpu exists, it doesn't verify that the vcpu's imsic_state has been
> initialized, leading to a null pointer dereference when accessed.
>
> This issue was discovered during fuzzing of RISC-V KVM code. The
> crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
> AIA IMSIC device before the IMSIC state has been fully initialized
> for a vcpu.
>
> The crash manifests as:
>    Unable to handle kernel paging request at virtual address
>    dfffffff00000001
>    ...
>    epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e
>    arch/riscv/kvm/aia_imsic.c:998
>    ...
>    kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
>    aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
>    kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
>    kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
>    ...
>
> The fix adds a check to return -ENODEV if imsic_state is NULL, which
> is consistent with other error handling in the function and prevents
> the null pointer dereference.
>
> Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V3 -> V4: Fix typo in Signed-off-by email address.
> V2 -> V3: Moved isel assignment after imsic_state NULL check.
>            Placed patch version history after '---' separator.
>            Added parentheses to function name in subject.
> V1 -> V2: Added Fixes tag and drop external link as suggested.
>
>   arch/riscv/kvm/aia_imsic.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index e597e86491c3b..cd070d83663a9 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -993,8 +993,11 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
>   	if (!vcpu)
>   		return -ENODEV;
>   
> -	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>   	imsic = vcpu->arch.aia_context.imsic_state;
> +	if (!imsic)
> +		return -ENODEV;
> +
> +	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>   	return imsic_mrif_isel_check(imsic->nr_eix, isel);
>   }
>   

