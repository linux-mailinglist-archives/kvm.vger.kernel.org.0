Return-Path: <kvm+bounces-68363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DAF1D3840B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D9073302DB0E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E72362154;
	Fri, 16 Jan 2026 18:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DvF805/1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DvF805/1"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013023.outbound.protection.outlook.com [52.101.72.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F374346A05
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768587230; cv=fail; b=gn6QM27zKjN1zwOgnrTAHb7DP7JGFxNYecnk71xrOkOgl1qAqAZxChBkAkHQzowxp0I8ZdzrhUhD1yNKiYIawb84tCNuz5RYKX/qm6pZteTmaWKLBNApNa04BRfUHd+54PIjeXLt3l6S6cP4+sdGpkioE0DUV5VJKIW5xy7zykI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768587230; c=relaxed/simple;
	bh=ZWP8j+WqHrDBUuMQ9aK/rkjRaXsK2oiz+DmZCUg8M70=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bWA2FM9hQOp3JmtQggHV/OPwcDSxmB3Ji/rU0FqrvxxTHY8EbErLBfTvv7dZEiDr+ubllEagWk6CpQ/sWvnitbQhGXqV2nTNH9LuvQtSjolf0A1WdcatodxJsabf0UD6X3yVMln+GJGcwWv/3thP5UxwBu3G0bXR7cNsNBKwl/8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DvF805/1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DvF805/1; arc=fail smtp.client-ip=52.101.72.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JA5C6qyreaSH5QrQYteOI3hlWGrpzw4yIpEaZrDGcxyaYc6cZmEh/X7oCevaBJJm70NP0jTluaiQx+/GgIaZj81t6dQdDmAj/swQ0XbaRGieMv4Zir6RXuHH3SeMObPQoxM4ciD9GUGaiP4z+2FjsOxyMCtiawjtABmPgKL1NomBb6ug2lau1b/zcmzyv1TCK9kJJfH0vDo4TmnhRETgStE2wmq5GeJ9Vb5Ay2WiZtvjPei9zh4/R7oo4ylWRFsbTwfLc4jqZUXpy7TyuNeCk+Bd23dcmdCJUnOYEXWabxEUYYsSosEv2vd5OfSSoI4ymrX2ExT7rfkismTStpbwcg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWP8j+WqHrDBUuMQ9aK/rkjRaXsK2oiz+DmZCUg8M70=;
 b=els+lyUQ9zIn4V0SpxeUBK1puuEtrjp/D33A76HsB2LmMzjjki5lUH9a+vO7vOT82X99d83qERmmFbrmV38TEXzj2rlOEyIVacAdIJ1ZfVfwO7zTKw2P8jKnDzHS2EWvLz8HC0if141Co5iLs+jgMHqY6tqwnBEHFCzw58yrAZ9lRtYkeeLmpUEaht6eMVq9mI7W6EIKLNfYTNOffno8TStrvl2F4Zkav9vj0EGQAifI/irxJ6XHXFQOvETeNeVB5KBTnzfUVM2QZgYK1jSsAHG0TKfoj/O0ycVeCBMTcDEZo/bpxqN8IiFpKNsC1DVkqvWmn1S2cLk75QqvVfk3mQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWP8j+WqHrDBUuMQ9aK/rkjRaXsK2oiz+DmZCUg8M70=;
 b=DvF805/1VsWXTxGUazXffPMV0Sn2Zq2GfBnn+lIQ+sZ4cMfLeY1BL7C7O2JutW+4AGw0e7S4JbGT97XlrfYtXuGX9nFheOc3KzrEtqndDgorfpAWT1kq816o8OEbF03i4RKfT+M9vcoXRuZ43zPSLgj0ypyPjIyFMbOpb5el4oc=
Received: from DU7PR01CA0031.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::10) by DU2PR08MB10157.eurprd08.prod.outlook.com
 (2603:10a6:10:46c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 18:13:44 +0000
Received: from DB1PEPF000509FA.eurprd03.prod.outlook.com
 (2603:10a6:10:50e:cafe::1) by DU7PR01CA0031.outlook.office365.com
 (2603:10a6:10:50e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FA.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sriZMr99RgQrjrGBxqjydVvbpDaQdXqsYsqEi6Ep0Y32Cf+lceaUWnpIFauMx4kq+A4QJ2wm+OU/CufPfu+3I6FtoxE33NitXO2/k06OEgoanmI5e4/CzSQAncyRQewgTuCK0IsDFb0Qy43YjtI6HNts++4Ar4jMjz1pfuylt8F/I932DfweYZ/GqY6BHwN2BHGseZAOUtRcIzrmiV84ojlyYMFGI/ks5odEncVHZ/o0a7La9pVrzsr+/xBkXzxS/ba+bfCVoYfGBav1tKu/Sf9jQPmn3E5/sXoI86MdMRIMCbhcWq9cnsoqHfjD1D2ukPxfnlqAl2n/IgBDjlQIxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWP8j+WqHrDBUuMQ9aK/rkjRaXsK2oiz+DmZCUg8M70=;
 b=Z0Fkl53dcKmd8Fz6sCMFBRuC4/nQpmvtCx1qOOzK6fssYuZPiIQF1XM7+EzI/nK7QLrlRoaLqq5zC//qrekhTgFZdoVMGIxp5QV7/ggW4A0CR+R1YI6Sv/Wpd1rAdkhEl9gc6C/Z7c85e6WLvVPqBOs+6Une/US/wTBOGpnH08nQMYsB9ncS3laRJwrwRxwvQNf3RPH11Y/lPQD5lYrHMAOpnd885C5r63sUvmo1UhTSIdfH5sz9oLn32hhiONTlrPP+iWJnbSN44WK9yjqaKM0g8c7ABNy864fp+OUI15xlT3FRjnKptiFjXoc8arw+AXkCz+k8LiBc03y0Vk9k6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWP8j+WqHrDBUuMQ9aK/rkjRaXsK2oiz+DmZCUg8M70=;
 b=DvF805/1VsWXTxGUazXffPMV0Sn2Zq2GfBnn+lIQ+sZ4cMfLeY1BL7C7O2JutW+4AGw0e7S4JbGT97XlrfYtXuGX9nFheOc3KzrEtqndDgorfpAWT1kq816o8OEbF03i4RKfT+M9vcoXRuZ43zPSLgj0ypyPjIyFMbOpb5el4oc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB7652.eurprd08.prod.outlook.com (2603:10a6:10:30f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:12:40 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:12:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 5/7] arm64: Add FEAT_E2H0 support
Thread-Topic: [PATCH kvmtool v4 5/7] arm64: Add FEAT_E2H0 support
Thread-Index: AQHcg6rkZVV4QkegGU6rDXH5Kwu+BLVVIBCA
Date: Fri, 16 Jan 2026 18:12:40 +0000
Message-ID: <c83e97aec2fd95548a5c4d2aa395b7fc09a9f38d.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-6-andre.przywara@arm.com>
In-Reply-To: <20250924134511.4109935-6-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB9PR08MB7652:EE_|DB1PEPF000509FA:EE_|DU2PR08MB10157:EE_
X-MS-Office365-Filtering-Correlation-Id: 9904677a-55fc-4b67-074e-08de552afbe4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UUh1VXFVYUJTbWl4R3p6eVdnN2RvbjA0b2tLQUcvRjBsRWg0NDJLSUcxMWVk?=
 =?utf-8?B?am1hcEVzVzVNUHp5R29tWlNtcFBFQ0h5bW8ybmxLY2ZOaWlwT0d2YlRjdldv?=
 =?utf-8?B?Q05TUk1SZVdaVEpPVzF2SzRFMkFIWCtPNzFsSjZCRDhEc3hyb1ZHZE81NFVs?=
 =?utf-8?B?bE8wc2lpcUI4VGRuUU9rT3MxREQzMHBCREpMV2tCZVJHMFo0R0dZRTdRQkpv?=
 =?utf-8?B?STFXK2htcUdDdDRYdTBHa0pXT1NkRjV0M2dpZGgwRXk2WW1UdTBjZXdOVGxF?=
 =?utf-8?B?MUUrTjk3a0ZITWpuZ0xONlV6TFZKMnNNdFRZVk1NNktPTk44empORms3T0FP?=
 =?utf-8?B?cGN5MjJTRUdGTkVDQWtzRW8zU3JHcUpnRjNIY3M1bStYNmpOOUw3VlozK29G?=
 =?utf-8?B?SGVBRHR6bTNSckhKMmpZRm9URWlackw3aFN6L081QVFneGhLeVUxNjg1eDlx?=
 =?utf-8?B?cHhnQmw3TjNVZmRkSkM5U01nMjJBcFhiVGFXb1k2OE9VVm85TkxNY01iaVFR?=
 =?utf-8?B?OXM2Ulg4U2p1R09UdmdjYmhYK25SV1BnSVU5cHZ0WkI2ZnBuMm5QNFhHTi9U?=
 =?utf-8?B?c0E4VE9xTi84UDEvejZIRUdtQ083VE1kc3RUY3EzUnpNeFI2TmYyTkZiVzA1?=
 =?utf-8?B?WEdJMW14MGNzMjFzWkpEQ1hySEtJeis4YitraWo3RUpyY1dNUlhNQ1R0SzNK?=
 =?utf-8?B?cURzUk82dUJYQVFZVDFmRmJPT0pZTllxOG11bDB1ckZRa1ZjZDhXK0JjVTVu?=
 =?utf-8?B?K0tXbFVCTlR5MnUvTTBmOU4rVU0zT0FxZHVCOHhRdDRBZFFYSEk5WW5LK3lz?=
 =?utf-8?B?c2F0S0hLaHdxZ2VOYjQ0OEpjL3hCZ2kycGN0ZnZ6eFFKZTkrS21GNnRUdTFl?=
 =?utf-8?B?NWQzTmJuc0dYcWNqbFM4SS9HaG5zT05YaVkzQndrMTZJOHRROXJUcmt5VkpS?=
 =?utf-8?B?Y2JvQXcwZW85MjlUd2VYanBSNG0vaU1YQ1pseDZuSW45SWpyVDg2L2J4SFpB?=
 =?utf-8?B?clBWWDBjOUtUZXoyS0toV2RqYzY0aDJLVUpURWZRTCtiNnJIb042enhGTG1n?=
 =?utf-8?B?d0wzUHd2YTNRRlcwUTFmeHZXeVp5dEIzS1VBWmRpQ3h4SGVscHFHQXVUVlhP?=
 =?utf-8?B?M0JHUFlsbk53b2ZNZ2NKMkVjS2tJekkxZ0h0U2lMYktGVksxZEJMeHhGdm5B?=
 =?utf-8?B?REJwQm1CeEQ2NGFyaDBjK2U4aTNDUDJJVmdpaVdOR0dnOEpIeTVkZ0FGOE13?=
 =?utf-8?B?MXFXeStRZ01oQ0gyL2xpaUVlZndnclVCMEh0VmpFNEpHVG5zV0pUa3piZkRv?=
 =?utf-8?B?R1A4bTlZSk50a291SzNkYUlJT3EweGJncjNoMlBRYTNkTE83N0Yyc1JjaGhV?=
 =?utf-8?B?NlVVcGM1bUk4amhBR3Y0WGNKSkVza29IMXE2bWprWGJ0WlM5THc1ckhyWU5J?=
 =?utf-8?B?dDdCRWYycjdOR1V2YjFHTCtLU1FsdXo4WHpFQWl6TmpWa0NlYW5VOUp1WGpE?=
 =?utf-8?B?NnZka0VxTFhCekVnM3c4cmhuZ0JSbE1wRmdTc25DYnYyeTd3b0s4OEVZSHNj?=
 =?utf-8?B?KzNncmE0UnhaL0w2eitrM2UwVkp4MFc1dTlCNkpPdVlRVGdyaXpLZjN5NlUx?=
 =?utf-8?B?K0puUHZGVDFYTkZJN0NvNms3aXFVQ2p2dzN5QXE4RkVqODQ5NzBEQm1VNGRB?=
 =?utf-8?B?TUJrTDc0VGxqTzJnUmw5OURnWWRhL0xkSEFHQXJoalphamFFL2lVVkdkUEpP?=
 =?utf-8?B?T2RXSFVLWFJPdE55clBFbE13bExwMHRZVHNVY01acnQzdTlpZGhMaGJyZDVz?=
 =?utf-8?B?UW9nUlFoL2dvOVJiUDNvK1dUTnZkOEVqZTc1TzhvUE9DNHRnMDBCWnNXZ1I2?=
 =?utf-8?B?WkdzcHVpSjUzdGJkelovN1pmSHdVYzVrTlBCU0dsZ3FBWjhVSFlaeDJsUDI0?=
 =?utf-8?B?U1MrRlZncnd0eE9BdkFCQlBuTXBvV1R2Q2E2UkxqWVZHaG96ekUwcDByeDE0?=
 =?utf-8?B?VmZRcURCZitGL2lQRUMwaUoza1NkZ2p3S0ZNTXpXZnFUam56aGxVdkR2L1VP?=
 =?utf-8?B?bnV6MUsvT09SUXlJb2FhQk9WNUNMU2pRQXh5dTc3ZjNFTVRoQmRVVmpxTitl?=
 =?utf-8?B?RGVac293RnlibUxmVkExS3BqU0NVcGg0d1F5bzN1MThsWDlvWWsxWWdTa1kz?=
 =?utf-8?Q?tN79DoPqqjY5kqFmpmNW8+E=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <50CAE33E63369E4A9FFC3A8FFA78E436@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7652
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FA.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6c0502d2-2bf1-4111-0aee-08de552ad661
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEYwa01WQTNyUzJLYkVlRXFqYW9JQTdSeWUxRDIycTNTQ3pRRlZsTUtQazMz?=
 =?utf-8?B?S1ZkUEdOemhTOEwvb3NJQUlPL3hUVVNSQk0vZEQ4aldRNEFqSjdCTzlyRlR3?=
 =?utf-8?B?SVdkSFY3eTJGMzlSTmpaVU5Dbnp5R2NFWTRvaGdGd0lUUkVkeEt5QWxYdlpt?=
 =?utf-8?B?b2xOWWFWRU11bnMveUtYTWdVMGZvR3lsQlRlcWcxWjY4bW04VkxSMVpyM2or?=
 =?utf-8?B?OHFEL3FXQlJqOXBwaUxmeko2bDh0bTJFTTA4ZE1CQ1FaWCtiOXRkeUVOYUpw?=
 =?utf-8?B?NzNWQ1pEQWMwbjRjQVZ0bHZ4RXBCZjdDMEVEb25IUldwU2NPa1FobmpvTUgv?=
 =?utf-8?B?b0tmczN6TUJxT1U2YkdqZzBPV0tyMFUxckpQM2JmV04rTnZJa3RiUTJGcGpW?=
 =?utf-8?B?SXBzcGdDY1JMYUFDT0hQcUpPRFhEdXNmSFNYc2Q0YW4vUXVUc0NoWmRad08y?=
 =?utf-8?B?UVlsM0Jxc3NGOWxlaHlGM1BGb2dGYXhxSFhOL0hpcHBzeGwralBnVVVzT1l3?=
 =?utf-8?B?Wk5QRE5PMEl1dGpSSjFiWUp2L2gwVjhEd0M4TDZscjlheVVpS3RhMU1UMlhF?=
 =?utf-8?B?Y2ZTNlFTU1B4OW9UM2RPSk9yOHFlcGtIL05BWVVqWlR0THhvdllGTnplNHkr?=
 =?utf-8?B?LzdPclZkRTRFLytJdE1XWXNYUDB6aUdTc3dpOG1jZ1QzSk9OdGVjR0xNMC90?=
 =?utf-8?B?QWwrOUx0N3NWb2xHMEZnRGtGYTVkSnFtVGNkOUhRUzlIQ1h6Nk90dW90OEJL?=
 =?utf-8?B?cTZ5UDFaekdkNENBK3hLc1VOWjR0QWJPaW5ndXEzMERPRjlyYmdXYmZMV0ZT?=
 =?utf-8?B?WnZ5UThMa2NSWkNaL0lrSHRSc01aOWNqQTVCRG9GTEwvbC8wR2xCQjl1Rzc0?=
 =?utf-8?B?TzgvNDdBMUVTVkhuT0daUVpLS2NDRWs5cHlvOU9mL3ZpMi9KUlhBV2hGcXJV?=
 =?utf-8?B?WG9MNEhUR1dPUFZXenVHOUNCbUx4Z05hV0crcURCaXNsaXB1dFNOTUVYYity?=
 =?utf-8?B?cFdUcFBycWFXUGVuL2ZqbXRkc2M3QVhmNCtybnRPemtVb1ArdlFjdzZpeWVY?=
 =?utf-8?B?MjJlUjlvUGJnMjN1VElzczlUd1FWK2VUV2htOGhaT09pMWpHTi94emlsL2Zs?=
 =?utf-8?B?UTJUVVFCK2Q0cjhubVpPbU9DK2RtT1JVdXNENWVCSnFOWkFNeWI0MmhQYUZw?=
 =?utf-8?B?eVFWdTJoT0t5d1M1RU40UEZ3RDFkZUdTNm56M0RpOWhFQWZDZGNYWmJPVTNY?=
 =?utf-8?B?Z09qVHkzZDlpV01pQWpoVWtidEY3a253QmtlTG9VZHNCSEhuMFZLbE5HZVE3?=
 =?utf-8?B?TmltMnJWME5nYkFuZ0VwYmtLdjVaUS9lNW1PN1RrUUdIRHFQYmk0bHVmSUFU?=
 =?utf-8?B?Q05XcW5GVndMNlE1TE5XbXRIODNQT3ZYdXdYS0U5VVlISDkzenlITDlvMm1K?=
 =?utf-8?B?UlE5QW1XNnFwM3BseEkwWGMydVlHTnh5cDVUL3k4alc0T0VIdnVxZ1VuZDFl?=
 =?utf-8?B?WE1RSjRra3BNK21pQTc0SjFXalZQQ3hiWFFzOXRLWVFzSk8yREY4NFdjSFlp?=
 =?utf-8?B?cjV6WlVtM3pnZTNIbHNLdjl4SG1NUDh4MWcwc0d4M3hqR1Y4S0VJTUNjMjJu?=
 =?utf-8?B?UDUwV3dPUWxicWMvbzVTNXFBVFJVaTZMMDJ4dXpsdkxSOWN5L054cmRLVHls?=
 =?utf-8?B?WGN1eUJJUUR4bXdTMVQ2R0tsWGk2MVptSWlqanJSUW9lWCtDUVc1Ri91T3ly?=
 =?utf-8?B?aGFVTmNveENEN3FSY3ZuaHVXWWNvSjV1a0xMS0Q0TDNDVERuTlA2YmpHZHlt?=
 =?utf-8?B?YXBRRy9RZDBDUGhKN2xkOWRiNm4vTERhT0F2VTI3dmJFQTZzdVRrN2F4UDdI?=
 =?utf-8?B?SGtWZmtxY0lLVFlHRDFITk8wSUxUOTN5UHpOUDMxTFdUVE9FbjFwQkplNTRX?=
 =?utf-8?B?SCtZUUU3cHlEMVE1bUdoa1QrNzJFTWdnWGQwMlBoZFJuQXhCUHR6Um1BcEdz?=
 =?utf-8?B?RmEvMTlpUmlOQzU3d1AvSmZHZDdyemNsQ01KWncvZE9rUlVLcDEvcktjZE4r?=
 =?utf-8?B?NThXa1J2NlVmL3UvSEtBZ1NWTGpsOEhOOGRlVjg4UmxWZHE3QWVxaHFDczE1?=
 =?utf-8?B?YTB0aWh6dGxDSTkxWkplQkdzNmJWTlduWElDZ1dnMzhnRjJLeXMwanlmbmoz?=
 =?utf-8?B?eUtIUXZMSXhXUVk2OFV5b2dueDJkbVAxZktmdHU0S1dnVUhNaVVWQ3VWOGlK?=
 =?utf-8?B?VGsyUk44a1QwSmlmTTR6WTZzSDd3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:13:43.5121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9904677a-55fc-4b67-074e-08de552afbe4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FA.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10157

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gDQo+IFRoZSAtLW5lc3Rl
ZCBvcHRpb24gYWxsb3dzIGEgZ3Vlc3QgdG8gYm9vdCBhdCBFTDIgd2l0aG91dCBGRUFUX0UySDAN
Cj4gKGkuZS4gbWFuZGF0aW5nIFZIRSBzdXBwb3J0KS4gV2hpbGUgdGhpcyBpcyBncmVhdCBmb3Ig
Im1vZGVybiINCj4gb3BlcmF0aW5nDQo+IHN5c3RlbXMgYW5kIGh5cGVydmlzb3JzLCBhIGZldyBs
ZWdhY3kgZ3Vlc3RzIGFyZSBzdHVjayBpbiBhIGRpc3RhbnQNCj4gcGFzdC4NCj4gDQo+IFRvIHN1
cHBvcnQgdGhvc2UsIGFkZCB0aGUgLS1lMmgwIGNvbW1hbmQgbGluZSBvcHRpb24sIHRoYXQgZXhw
b3Nlcw0KPiBGRUFUX0UySDAgdG8gdGhlIGd1ZXN0LCBhdCB0aGUgZXhwZW5zZSBvZiBhIG51bWJl
ciBvZiBvdGhlciBmZWF0dXJlcywNCj4gc3VjaA0KPiBhcyBGRUFUX05WMi4gVGhpcyBpcyBjb25k
aXRpb25lZCBvbiB0aGUgaG9zdCBpdHNlbGYgc3VwcG9ydGluZw0KPiBGRUFUX0UySDAuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTaWduZWQt
b2ZmLWJ5OiBBbmRyZSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4NCg0KT25lIGlu
bGluZSBjb21tZW50IGJlbG93LCBidXQgaXJyZXNwZWN0aXZlOg0KDQpSZXZpZXdlZC1ieTogU2Fz
Y2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCg0KPiAtLS0NCj4gwqBhcm02
NC9pbmNsdWRlL2t2bS9rdm0tY29uZmlnLWFyY2guaCB8IDUgKysrKy0NCj4gwqBhcm02NC9rdm0t
Y3B1LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNSArKysrKw0K
PiDCoDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgNCj4gYi9h
cm02NC9pbmNsdWRlL2t2bS9rdm0tY29uZmlnLWFyY2guaA0KPiBpbmRleCA0NGM0MzM2N2IuLjcz
YmY0MjExYSAxMDA2NDQNCj4gLS0tIGEvYXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNo
LmgNCj4gKysrIGIvYXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgNCj4gQEAgLTEx
LDYgKzExLDcgQEAgc3RydWN0IGt2bV9jb25maWdfYXJjaCB7DQo+IMKgCWJvb2wJCWhhc19wbXV2
MzsNCj4gwqAJYm9vbAkJbXRlX2Rpc2FibGVkOw0KPiDCoAlib29sCQluZXN0ZWRfdmlydDsNCj4g
Kwlib29sCQllMmgwOw0KPiDCoAl1NjQJCWthc2xyX3NlZWQ7DQo+IMKgCWVudW0gaXJxY2hpcF90
eXBlIGlycWNoaXA7DQo+IMKgCXU2NAkJZndfYWRkcjsNCj4gQEAgLTYzLDYgKzY0LDggQEAgaW50
IHN2ZV92bF9wYXJzZXIoY29uc3Qgc3RydWN0IG9wdGlvbiAqb3B0LCBjb25zdA0KPiBjaGFyICph
cmcsIGludCB1bnNldCk7DQo+IMKgCU9QVF9VNjQoJ1wwJywgImNvdW50ZXItb2Zmc2V0IiwgJihj
ZmcpLQ0KPiA+Y291bnRlcl9vZmZzZXQsCQkJXA0KPiDCoAkJIlNwZWNpZnkgdGhlIGNvdW50ZXIg
b2Zmc2V0LCBkZWZhdWx0aW5nIHRvDQo+IDAiKSwJCQlcDQo+IMKgCU9QVF9CT09MRUFOKCdcMCcs
ICJuZXN0ZWQiLCAmKGNmZyktDQo+ID5uZXN0ZWRfdmlydCwJCQlcDQo+IC0JCcKgwqDCoCAiU3Rh
cnQgVkNQVXMgaW4gRUwyIChmb3IgbmVzdGVkIHZpcnQpIiksDQo+ICsJCcKgwqDCoCAiU3RhcnQg
VkNQVXMgaW4gRUwyIChmb3IgbmVzdGVkDQo+IHZpcnQpIiksCQkJXA0KPiArCU9QVF9CT09MRUFO
KCdcMCcsICJlMmgwIiwgJihjZmcpLQ0KPiA+ZTJoMCwJCQkJCVwNCj4gKwkJwqDCoMKgICJDcmVh
dGUgZ3Vlc3Qgd2l0aG91dCBWSEUgc3VwcG9ydCIpLA0KPiDCoA0KPiDCoCNlbmRpZiAvKiBBUk1f
Q09NTU9OX19LVk1fQ09ORklHX0FSQ0hfSCAqLw0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQva3ZtLWNw
dS5jIGIvYXJtNjQva3ZtLWNwdS5jDQo+IGluZGV4IDQyZGMxMWRhZC4uNWU0ZjNhN2RkIDEwMDY0
NA0KPiAtLS0gYS9hcm02NC9rdm0tY3B1LmMNCj4gKysrIGIvYXJtNjQva3ZtLWNwdS5jDQo+IEBA
IC03Niw2ICs3NiwxMSBAQCBzdGF0aWMgdm9pZCBrdm1fY3B1X19zZWxlY3RfZmVhdHVyZXMoc3Ry
dWN0IGt2bQ0KPiAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHVfaW5pdCAqaW5pdA0KPiDCoAkJaWYgKCFr
dm1fX3N1cHBvcnRzX2V4dGVuc2lvbihrdm0sIEtWTV9DQVBfQVJNX0VMMikpDQo+IMKgCQkJZGll
KCJFTDIgKG5lc3RlZCB2aXJ0KSBpcyBub3Qgc3VwcG9ydGVkIik7DQo+IMKgCQlpbml0LT5mZWF0
dXJlc1swXSB8PSAxVUwgPDwgS1ZNX0FSTV9WQ1BVX0hBU19FTDI7DQo+ICsJCWlmIChrdm0tPmNm
Zy5hcmNoLmUyaDApIHsNCj4gKwkJCWlmICgha3ZtX19zdXBwb3J0c19leHRlbnNpb24oa3ZtLA0K
PiBLVk1fQ0FQX0FSTV9FTDJfRTJIMCkpDQo+ICsJCQkJZGllKCJGRUFUX0UySDAgaXMgbm90IHN1
cHBvcnRlZCIpOw0KPiArCQkJaW5pdC0+ZmVhdHVyZXNbMF0gfD0gMVVMIDw8DQo+IEtWTV9BUk1f
VkNQVV9IQVNfRUwyX0UySDA7DQo+ICsJCX0NCg0KLS1lMmgwIGlzIG9ubHkgY29uc3VtZWQgaWYg
LS1uZXN0ZWQgaXMgYWxzbyBzZXQgKGNvcnJlY3RseSBzbywgYnkgbXkNCnVuZGVyc3RhbmRpbmcg
JiB0aGUgS1ZNIGRvY3MpLg0KDQpNYXliZSBpdCBpcyB3b3J0aCBwcmludGluZyB0aGF0IGl0IGlz
bid0IGNvbnN1bWVkIHdpdGhvdXQgLS1uZXN0ZWQgaWYNCm9ubHkgLS1lMmgwIGlzIHN1cHBsaWVk
PyBBdm9pZHMgdGhlIHVzZXIgdGhpbmtpbmcgdGhhdCBpdCBoYXMgYW4gZWZmZWN0DQp3aGVuIGl0
IGRvZXNuJ3QuIChBbHRlcm5hdGl2ZWx5LCBtYWtlIC0tZTJoMCBpbXBseSAtLW5lc3RlZCwgYnV0
IEknbQ0Kbm90IGEgZmFuIG9mIHRoYXQsIHBlcnNvbmFsbHkuKQ0KDQpUaGFua3MsDQpTYXNjaGEN
Cg0KPiDCoAl9DQo+IMKgfQ0KPiDCoA0KDQo=

