Return-Path: <kvm+bounces-44595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4835FA9F8A9
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 20:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 990E11665CF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C977B27A107;
	Mon, 28 Apr 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="b9/23kax"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021090.outbound.protection.outlook.com [52.101.62.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B27326D4E2
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745865208; cv=fail; b=O7rlPQUeyNyRKF2cXZFi/EhYN349SMK1svBv0vbzg6WduE0QkhH+ITKOlEQXYIgA0kQeqIy1QUSz+543buxyEKpvTx3kB8fkCgGuhVsMYpTkTwlmdH1C8Esa/eTXsju1NRrETuqZb4sKpSVoy3ogxQdK+7/ePupy4InId7aoFhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745865208; c=relaxed/simple;
	bh=aCLUwAzS0plgsoEufo7qeDddKn2uxeL25/c94cH4CYs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kkwVJy2WcLoz9jOUfTpQpG7ci73ZvvQWj5HzyshrjHZMMdpdIqMoLql7s/V+LfzojFjCMhr25xPnlW+Vyb6J/5xGTXnzBKVv6G2FBQTvvVYNUwFqCTxHNDrgicLbz1l6LtONV9gggzx86tw5QyqEIJw7ugPYDwjtJYVNA9DsFoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=b9/23kax; arc=fail smtp.client-ip=52.101.62.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OqP0lpkOfqO5ofXIJWmXqGi5b1EXqmOn0bbHoWU3GXFixaXSE/mZ07+0RhHnf9VIn036s1KOk4CzHqVwRgKkdDh2EjysTkb5mrEYiVp3UdylzUEw1e+wA8+5Fq3DmqEHEK9PSc6QIpCTQZRKLI3QDayS1YIuYFatq60tHIvDvyD0kK5bCfudC2lk0BWdozJgrYR+Td0o/iTjdILuLLC53M8OdsG2mgRTGqwOlb/pyGn92pfdnhg1nexh/ao5b2FL2D9xQJpeoqSM2WsU9HFMsvzZFkU5JyqiLHMi6jKJH9eeuunqi8iI6ABQE5rEhFu40z+dfN5VEpwmLE9+wjy3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BF98+iWw6S+SddbNEtMxh73bD8dO1jfw9PwcCASrTUw=;
 b=Y95DbHJJwrkHZSG/higls50jo9RAlPJDYDucF4v3t2vjcjEQGYrBCe58YgXSfnrnFjRKTZi6Nj4Id5DXdzNOR3ioMfWvUL3WSrN1aJITRAE3OXunj4Ln7nUIoPwZ7+yWDJmlVxVAMDJwjHous0DhYO8W0l+Fuw+FAwoyrfSQSpq9ZmUpBCjVDGuTLX2HhYTx7diXv0RiLlsGeF2Ga4dxd3Okd+Xg1j3TnNFrM9dfEIFt+57J9umXDLBJD7qWy5K0cwyOBplvL5YGUnK/rjdHpoGkLoNUN1GMD8SkrW1H/wh8/QkQzUHpdVMZqvc5cz65a1lQTM+frvMEOdyIGKImHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BF98+iWw6S+SddbNEtMxh73bD8dO1jfw9PwcCASrTUw=;
 b=b9/23kaxitO0lx/Sa9h5EXmHU5U5iLApNPbUAlDvshic1ZEtRd7CIPenWBE2sTz9uQklxYHCKouyx5MqW8xrjPR9Zn9ZHfMDZ4jHZ7ZTOj7L0GwgFYXAbpsMY6CPTweXqK9TSMX0aLQ7yqcoQl3bCiA7XLASxXTcZP6Kph401vQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CYYPR01MB8386.prod.exchangelabs.com (2603:10b6:930:bf::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.31; Mon, 28 Apr 2025 18:33:19 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 18:33:18 +0000
Message-ID: <4e63a13f-c5dc-4f97-879a-26b5548da07f@os.amperecomputing.com>
Date: Tue, 29 Apr 2025 00:03:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/42] KVM: arm64: Revamp Fine Grained Trap handling
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CYYPR01MB8386:EE_
X-MS-Office365-Filtering-Correlation-Id: 6acf18ab-062d-40f0-cc05-08dd8683259b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlRUVmsyL0Y2cUlsRjl4Q1o0eENySjJMZk5VK2QvR3RTUElKSkJ4UEhPN2J2?=
 =?utf-8?B?c2RrSUFDUHM4V0x6RE5TYWhhNFRKOUViQnBzL01EU083V1BoUldDL1BwdytR?=
 =?utf-8?B?a1VlOHZ0MVVTdWRIenY2T3hBNEZBYXdnSWZEUEY5eWVZMkNDU3JMakxrMmhC?=
 =?utf-8?B?dmJzV3BXbk93VVZoTmdSb1Z0aFVOYk9NYWRFR2syeVUxVzdSMnJSSmNGODlN?=
 =?utf-8?B?K2xQc2E4S1hrMk5WdlBycFg3cWVKWS9TYi96L2xqbjEyTHJVUmgwQXlYQXc0?=
 =?utf-8?B?aVUzc3BTd0I3bjhXcEhxeXZsdWZQa2pZSmd5MWtKT1QzZEpsNStuNUoyUUph?=
 =?utf-8?B?eWxiUm1uWjh4OEtQelc3aDFUcThibWIxR0JYZGNhMUpCeEY4dU5Td29FYXZK?=
 =?utf-8?B?NHo4ck9XMDdMdHJUcUlybFI0YWVOTnhnYjRSVGN5bDVkczgrS3hFaG9zWmNq?=
 =?utf-8?B?eGdSR0YvNENwMXhUbXYrUENJQmhYVUR1RlFSQXJneVlLWEtQTnFJS1l1b0Zq?=
 =?utf-8?B?V3p1WFU4UzBWQWxoZkZhc2ZvdVo4QW1HTlo4NGUrbnlWcERJdERFd0txZldq?=
 =?utf-8?B?T2s4ZHB3OWVrajhwQmNFUlJNNG9ja2wrSVdNQk5DbXZJNUppSS9PQ2FrVnhY?=
 =?utf-8?B?VkRwNzhvQ2pUR0JHU0lCeTFHb2h3VGFkOXI3ZXJoeGpNOHZtTXVocll5UUU2?=
 =?utf-8?B?cHVUVjlrRXIwamRwT1h6aWlwck5hc2FHTUU1c3hjdHpWeDRGNFhSK2NWakd3?=
 =?utf-8?B?UzJhQm5BOUJKVjBQMFBqUkJENzNtSFVldXJhdjJ4aFM3bklqbDFMbU4vWVhx?=
 =?utf-8?B?TjB0ajdDdnplZzZaRlgvaHJVaGpmTHhNNlZtY0IrUlk2YlZqV2I2b0RPV21m?=
 =?utf-8?B?RmxtOEcwRkwyeXNWcEppei93aXJGSmVCcGhLY0FsVlFGaFJKTXkxYWNrTzFZ?=
 =?utf-8?B?M2ErMTB5UzhWcnZNM0crUmRxbi9iRk1PbW9tN2M1eUsrV2lSTjk5eXNjNndt?=
 =?utf-8?B?NktYMzJuMUc0OUxKTnVUV0pFdVZkVEl2dE4zRkN3RmlGaml2VXZ0ZXBDVkFZ?=
 =?utf-8?B?M2gzVDd2V1RWQnRwZElpdU5iRWRWTUVkdXpPbk9EVEpwZWZxTnI3b0tXM3J4?=
 =?utf-8?B?bHhhcnlWdllxMHZnYzB5d3RZRmNod3BHNkEycnM4VlhUN2NMRHR3c2FObUEw?=
 =?utf-8?B?dDVQNXJ4c0Y3a29oRmFpM1lSUXlLZEFtUWhaaHZ0djNxZDhvQVMwRDVJS1Jn?=
 =?utf-8?B?UGc0R1lUM1dxcytnVlJlVU10bmVlQUlidXpPbEN6ZDc5cWV3Sm9QTmZwS2RP?=
 =?utf-8?B?UDJWcC9jTXowcHl1YWtiZlJYQzVuLzNXWTg0bzQ1U25ueHNOY3F3Zkd6SmZh?=
 =?utf-8?B?RGFUTXduQS9raDJLWkNFcFhmV2MrSUw1KzA2SW1ybk04ZmVqKzRkSWU2cFdy?=
 =?utf-8?B?TXV4Rlplb0FrcW5GbWhkb2NvakN6c3pGaHl5TDQwRmkzeUdEY0NQR3ZTeWhH?=
 =?utf-8?B?dDZXQzIvWDh0SmlTMDRuZU40WXNJUXJCbURXZWhsRE8ycWl4RTZyWmg1VytY?=
 =?utf-8?B?QzZCNWdtc2FJZjVvUlBJM09qemNEVDY1WXIya2g3QWFmd2EwamY0RHF6MXo5?=
 =?utf-8?B?V0QrM2pUQ05pL1R4SkUyeXJDNVNRYVFyRnVqMkhqSTlUamRLNXNoM2FrblQw?=
 =?utf-8?B?WmpUQTFNcUZxQ0Q4WHoybTNKS1NDRzBVVjRUbFJLM2xRZXVnYUgxSy9KSlFr?=
 =?utf-8?B?R0RTWGRIU1o0dzVLUDVxSGdRc2Eyejg3WDBjSEk3aGFoMHB5MHR2T2lQb2kr?=
 =?utf-8?B?OWprOFZrZHM0T3dabC8vZkJWT3UyZHR2K0VuRCtSYWU2MXE0SkF0SXUrbXpD?=
 =?utf-8?B?QXZBbjRCOHc3S1ZoQkFyd2NTc3RtN3RUdHFxbzRESjk2V0swT2tsMzJLY3hv?=
 =?utf-8?Q?R6ji9ze5gR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXpQVm1iVlJ2REYySHE3TGFkaGZQUVhkcFBuMGJ1SmVNdnNKeEdCa2VCeEND?=
 =?utf-8?B?SlVjcjFQRWJtcExvdi9ZWERHUFdvUG1ydWRLdC80clA2LzN4eVB3NHhpdnJl?=
 =?utf-8?B?K1AzY3dvdUpDcEtYUlFFa0JlZmhFQitJamZPV2htbDExWTJ4UTFXckhKdG1E?=
 =?utf-8?B?WkY3RUJFSjEwQkh0clVzY2JwelZFdVc0WlJwYVp0Ulcwcm90UmJDSGU0RjRh?=
 =?utf-8?B?djZOdTlJZXBqb1pOUVlrdGw2c0kxZ1EwZ0RPZ2xBNVF0alo5Q3BQVms1Tzh2?=
 =?utf-8?B?Zm9LMUZRK2ZWSFVYMjBhdm5jVndEWVVFdEtXVXkvV2tjb1J4eW9Ga0xQZUZM?=
 =?utf-8?B?ZVVteGp1bFVSSUMrU3JPTE5nSnNFT29NcWZMSERHNGp2aFNYYllXQkFWUWVi?=
 =?utf-8?B?c0RpdW1ySWxwTFFMb1NaZkE2d0oxamdOWG9CUGdlUVVCNnZMMDYrMzM4WDNx?=
 =?utf-8?B?LzFjVndoa2FXcGhacmdPR2NLVWF2VThqNmVCOGVybzlyUnZkbVU1RGZNNFhD?=
 =?utf-8?B?eWpTWnJjV2g5YTVVbDdxN2tUWElLK0I0d1d3Mk8rNHBzSjRNMDNnZnBDc0dS?=
 =?utf-8?B?SnhDbk54eTZmVzdabHNsSmNaSUpvM2tvMUluRjhIM3daRzFVQzJ0bXFvY3pU?=
 =?utf-8?B?Sklxb2F6dThBbWFRQm9vcDBCWVpGZG9ZVjVzRnlaZzVXaUFPY3pneDUza0JK?=
 =?utf-8?B?MFZCeXUxeHl3TUU3bDJseXhkakloTE9ZbXB0WkVVVVFCUVNWNXBVUUZ0bEtH?=
 =?utf-8?B?YWliVnlJcDd0S1REZC92b2NQTUhQMkNuLzVYNUZPZUZIKzBGaGlWalJkd0xT?=
 =?utf-8?B?Nnlwd3F5Si90dHprUDd6RitmUG44bkFvdHJWTm1vMmVLL0NFS0V4bElPQkVN?=
 =?utf-8?B?SkhwMXh0cUY5Y0ZPZGVuR0dBYUdHaVVDUDd0MzNsKzZYV1pLSlFQakpJckxp?=
 =?utf-8?B?aWhQYjNpNlFDbm04bU5hajdyTmxIaFN5R2Z5dTdOS2NNa3cwZFB4WCs5d00x?=
 =?utf-8?B?ZUpnbFR4ZUJJTUFsdGJCanBtbnhLaWZJYkdtNmJMNk8xZUdoODhoYWN4L2N3?=
 =?utf-8?B?LzFIZXlybVdickxueENnNWRmRVc1WmloWXIrNEhtQ3l2SEplbUQwejBEamlY?=
 =?utf-8?B?dFNvQzhyWXJzSHZpbWEraC9nME1sVTFWeENjQzBnSDdpZnZYRXdyWldjSnNw?=
 =?utf-8?B?NWRFcFRpUStadGx4SWUrdXVoV3NsTTJaRUN4KzFoc3JjRndsUmxXTWY4VFoz?=
 =?utf-8?B?VzFwTFR6WWp3U1ArbXQ4ZjZ6MHFVTDZUcWhIQmJiQi80c3RlRnMycU15cGZB?=
 =?utf-8?B?ODkzdThZZFVxV3NYRXN3NGJxMFBKbmt5NVkzSytGR2hqaGNRb0greGJDM2tQ?=
 =?utf-8?B?cGF0N3Q0dGhKZkY2bDA3ZzNZZU1xVUhNUUtKZTcxdVZhZVJRSzI4SXY4c2Za?=
 =?utf-8?B?dzAwamZlbDV3eGtlM2VxaytIRGtDT3dJdVR5SWZjdGllVzAzaFpKWnZjS1Rt?=
 =?utf-8?B?Tnl2NjlsVjljcUJTTUdvUWRyZkxmYlJhVEtHN1UrRm5oS2YwTldCb1Z2MVBH?=
 =?utf-8?B?VVNVSzNxc1FQdjZPbFROd3pyb1dGVWZtY1hIODVva0tiSndhbGlOYUx1c1Qv?=
 =?utf-8?B?dlR1cldFUlRpQ09xQlVKbVg4SVVnZ2VjbkFnZ21SK2VGZEIvVlVDKy8rWlNP?=
 =?utf-8?B?TklIYU1kUms0NGVqUDhHd21ncVAyQko4eFVBb2NrNVU1QWUrSjB2MWxaRnZj?=
 =?utf-8?B?eFRNVkk0a2t6N0Nzd2pLRWtZSzM3VllzSXJrRFpXU0grMHJXajNialFyUG1j?=
 =?utf-8?B?NkowOEF2TnEwWkRKYnNPbzE3cWFjQ3ZsaVJhSDRtYWhWbFhSMWZTdENpQjBo?=
 =?utf-8?B?MHlHRUNCNmJnNVFZMWg0Ui9OYlBwYTBVM2oyUmVVT1dqcFNNQ1QrM1AxMGNZ?=
 =?utf-8?B?R3ZRdUN0c0NybUU3emtCelNHdDEwUG85SVVnSE9GS2RxMFROZWpJTlZRbFc1?=
 =?utf-8?B?MnFSTmE1VVVBa1NDTkRVelpSdkwwMHZxbExIcTBOdzRzUW1USFBIQ0lncEE0?=
 =?utf-8?B?UFBud2FNeGhpRDdUNmtFekpNRjFJOEpRMHNEakM5dysrZGlXeURoV0RsRHRl?=
 =?utf-8?B?ZjBEUE02V3NRZHlUaWUwNGh0MVcrU25XMmlqMHJwOXh2WEdWY2h5RjAzOGVQ?=
 =?utf-8?Q?21SBw3Id1bzCqp+Z81bp9KcKOuRU6KvGXT2VNJHaOfVY?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6acf18ab-062d-40f0-cc05-08dd8683259b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 18:33:18.8026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9gAfupByUTg8WA5Xqza4e469E94aWqAU4/i+gLmi2TroeXa9F4mUIyacKwloFUrFdBbdqQELSxYrcuZIFeU/8f02yjMJbNQ1jQejS4w+E/R+aAG+QfXdyFLu0dFi7e1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8386

Hi Marc,

On 26-04-2025 17:57, Marc Zyngier wrote:
> This is yet another version of the series last posted at [1].
> 
> The eagled eye reviewer will have noticed that since v2, the series
> has more or less doubled in size for any reasonable metric (number of
> patches, number of lines added or deleted). It is therefore pretty
> urgent that this gets either merged or forgotten! ;-)
> 
> See the change log below for the details -- most of it is related to
> FGT2 (and its rather large dependencies) being added.
> 
> * From v2:
> 
>    - Added comprehensive support for FEAT_FGT2, as the host kernel is
>      now making use of these registers, without any form of context
>      switch in KVM. What could possibly go wrong?
> 
>    - Reworked some of the FGT description and handling primitives,
>      reducing the boilerplate code and tables that get added over time.
> 
>    - Rebased on 6.15-rc3.
> 
> [1]: https://lore.kernel.org/r/20250310122505.2857610-1-maz@kernel.org
> 
> Marc Zyngier (41):
>    arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
>    arm64: sysreg: Update ID_AA64MMFR4_EL1 description
>    arm64: sysreg: Add layout for HCR_EL2
>    arm64: sysreg: Replace HGFxTR_EL2 with HFG{R,W}TR_EL2
>    arm64: sysreg: Update ID_AA64PFR0_EL1 description
>    arm64: sysreg: Update PMSIDR_EL1 description
>    arm64: sysreg: Update TRBIDR_EL1 description
>    arm64: sysreg: Add registers trapped by HFG{R,W}TR2_EL2
>    arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
>    arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
>    arm64: Remove duplicated sysreg encodings
>    arm64: tools: Resync sysreg.h
>    arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
>    arm64: Add FEAT_FGT2 capability
>    KVM: arm64: Tighten handling of unknown FGT groups
>    KVM: arm64: Simplify handling of negative FGT bits
>    KVM: arm64: Handle trapping of FEAT_LS64* instructions
>    KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_ST64_ACCDATA being
>      disabled
>    KVM: arm64: Don't treat HCRX_EL2 as a FGT register
>    KVM: arm64: Plug FEAT_GCS handling
>    KVM: arm64: Compute FGT masks from KVM's own FGT tables
>    KVM: arm64: Add description of FGT bits leading to EC!=0x18
>    KVM: arm64: Use computed masks as sanitisers for FGT registers
>    KVM: arm64: Propagate FGT masks to the nVHE hypervisor
>    KVM: arm64: Use computed FGT masks to setup FGT registers
>    KVM: arm64: Remove hand-crafted masks for FGT registers
>    KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
>    KVM: arm64: Handle PSB CSYNC traps
>    KVM: arm64: Switch to table-driven FGU configuration
>    KVM: arm64: Validate FGT register descriptions against RES0 masks
>    KVM: arm64: Use FGT feature maps to drive RES0 bits
>    KVM: arm64: Allow kvm_has_feat() to take variable arguments
>    KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
>    KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits
>    KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
>    KVM: arm64: Add sanitisation for FEAT_FGT2 registers
>    KVM: arm64: Add trap routing for FEAT_FGT2 registers
>    KVM: arm64: Add context-switch for FEAT_FGT2 registers
>    KVM: arm64: Allow sysreg ranges for FGT descriptors
>    KVM: arm64: Add FGT descriptors for FEAT_FGT2
>    KVM: arm64: Handle TSB CSYNC traps
> 
> Mark Rutland (1):
>    KVM: arm64: Unconditionally configure fine-grain traps
> 
>   arch/arm64/include/asm/el2_setup.h      |   14 +-
>   arch/arm64/include/asm/esr.h            |   10 +-
>   arch/arm64/include/asm/kvm_arm.h        |  186 ++--
>   arch/arm64/include/asm/kvm_host.h       |   56 +-
>   arch/arm64/include/asm/sysreg.h         |   26 +-
>   arch/arm64/include/asm/vncr_mapping.h   |    5 +
>   arch/arm64/kernel/cpufeature.c          |    7 +
>   arch/arm64/kvm/Makefile                 |    2 +-
>   arch/arm64/kvm/arm.c                    |   13 +
>   arch/arm64/kvm/config.c                 | 1085 +++++++++++++++++++++++
>   arch/arm64/kvm/emulate-nested.c         |  580 ++++++++----
>   arch/arm64/kvm/handle_exit.c            |   77 ++
>   arch/arm64/kvm/hyp/include/hyp/switch.h |  158 ++--
>   arch/arm64/kvm/hyp/nvhe/switch.c        |   12 +
>   arch/arm64/kvm/hyp/vgic-v3-sr.c         |    8 +-
>   arch/arm64/kvm/nested.c                 |  223 +----
>   arch/arm64/kvm/sys_regs.c               |   68 +-
>   arch/arm64/tools/cpucaps                |    1 +
>   arch/arm64/tools/sysreg                 | 1002 ++++++++++++++++++++-
>   tools/arch/arm64/include/asm/sysreg.h   |   65 +-
>   20 files changed, 2888 insertions(+), 710 deletions(-)
>   create mode 100644 arch/arm64/kvm/config.c
> 

I am trying nv-next branch and I believe these FGT related changes are 
merged. With this, selftest arm64/set_id_regs is failing. From initial 
debug it seems, the register access of SYS_CTR_EL0, SYS_MIDR_EL1, 
SYS_REVIDR_EL1 and SYS_AIDR_EL1 from guest_code is resulting in trap to 
EL2 (HCR_ID1,ID2 are set) and is getting forwarded back to EL1, since 
EL1 sync handler is not installed in the test code, resulting in 
hang(endless guest_exit/entry).

It is due to function "triage_sysreg_trap" is returning true.

When guest_code is in EL1 (default case) it is due to return in below if.

  if (tc.fgt != __NO_FGT_GROUP__ &&
             (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
                 kvm_inject_undefined(vcpu);
                 return true;
         }

IMO, Host should return the value of these sysreg read instead of 
forwarding the trap to guest or something more to be added to testcode?

-- 
Thanks,
Gk

