Return-Path: <kvm+bounces-68371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE34D38447
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6BC6309C6AF
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCFC3A0B0E;
	Fri, 16 Jan 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RhJr8uxM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RhJr8uxM"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1B539C634
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588059; cv=fail; b=iUK3JbQrtBX54hhXezPjGJk480h9xoG9/8iMv/i8s5ifTqQZ8nCxoA7l/wznGuRIzgvbPkZy3L1fP2dfj/t5xB4ZFJ9RIVHF5N/iS5rCf7WFhqFLu1ML0J90SJHUyf67tVfWQw4PUQxvZ6SbhqtshKefIJ5DcLOLnGPhI5G8YgI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588059; c=relaxed/simple;
	bh=Ls7WwpWyCkSRBkGMwcEEmJsyGK0ijpuQz2XjFM+PC34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cbgIHavL8/xmendVljMMZgOWkxrJpoBY4d+VJGwYGhF6reQGkxHzsll6gmqrI+/nucyJe7U5Db78QjuNr+DAxPOaAKcsfImIRnlmI1QaSYuClhF/ggfXz2g8Ig0voTEQsCHXqNHyyFPJq8NQnwJZ/aT1RPSn1J8bV/YCu8cyhNs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RhJr8uxM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RhJr8uxM; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LkuYGlBi9yiPpZszmg1kKE9HSzWFINzmHtylz/ZczjGew1ziocob5kTPleujw5VoEzI9gCwM/b4WDamjmkwo7F69o41ng1PAOKO0Z+w2lgUUIhSMb9qel6be0aNWQoTnvAJo5pETrYhH442mINmT1PxQRUKHHMbMl0IMbwG1vOOcldUX57LcsZcKNP5TkRLo8OA1xlBXzZ3uU2l2WemkSGe0BRYrE7DgPC7ADHrd1AspGZzEyFeKDN3izxJUhb88DCxVqKEIjsEtUTPLQtVjYwGm+yFVxGndQ6LCTwN0QrA0hVBDpuAYOj6vne0jc3FZj0BchROi0IczoPsckET+iQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmapXM9HD4+VC7s5wetNjcOZwtM08/s+SCdvZAEGxt8=;
 b=CxSyka4vZJeH6U8hzL2UmHeV6qTvCTmXPDJzjQViQV+Yi2DsLEEZ79xeBW1w1mqQW2OTeSnMuc7F6Zx94dFw6dV0iRy1uDLMD/Oo3q4PrBktSmF9f9kOi7WpPno483GDZMPTL2rr5BgKqRJg8prjol4Ka2xCABT+weyZ3fk4qb1tabV84TXk6MfYDO81Xmz1VPrxrgsnj7nG7NiCD5qLjNHBJoFxUbexjI9zt15gEF4n8vZXBVCZItQZnUseOza3PjDXIYuyqHYZ7gE4vnggdkZmpkBhELgu/Hc6hSWxv6+pdmKfrtcuCgli0PmonfYOM8bip557eTJvM4SYLrjkbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmapXM9HD4+VC7s5wetNjcOZwtM08/s+SCdvZAEGxt8=;
 b=RhJr8uxMp8+T/FsgJyyNS0LLA4MtsPtc3SuzS+l0GtixV1nWzcD4pHW06eHEKEAaTeHUQTF2Kf4WRg9MvO1E8mvvi7tk9Vs6Pkl6nPcZJ5ahGIrZ8lPkKjbqy90Gz3GvowstoYlfTZrZECzd0kQljV5YsK48DPf6QjXckelcY1s=
Received: from CWLP265CA0423.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d7::9)
 by PAXPR08MB6399.eurprd08.prod.outlook.com (2603:10a6:102:158::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:27:34 +0000
Received: from AMS0EPF00000190.eurprd05.prod.outlook.com
 (2603:10a6:400:1d7:cafe::37) by CWLP265CA0423.outlook.office365.com
 (2603:10a6:400:1d7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000190.mail.protection.outlook.com (10.167.16.213) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yia3SeZChxcd7auXNlUdDB5ZsWuwrOauM5Fdo3syKIC5NMm9me/QDiE/SDzBLl8eKzQbBrBvrNSKIsbHPN3Q7RAs8poshp/1CMGkFbcfBmuJMhmMD+fgthJyXKjcJYgv9sh/Wbkw4cskFaOsnRJ/wjIO0Ak5TVw+jo8cnSwjSckaIjERaM8Uk+6uODHHVZfNzR4Z5c2FcxZn1oD2+xHrggpqJBZVDOW90ejiysX6R3KtRHCAbRvNDXOChErldVHz6dSs3faxofyBrHMfAhCNfijvnqEoR/IPkU7qGxvWQ0ZYAP4fwichoiU9wMNgjOR9yVDwEYOQVwVIMH8TEXMqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmapXM9HD4+VC7s5wetNjcOZwtM08/s+SCdvZAEGxt8=;
 b=vUHQbEv1kRjea7PKTX0en7MVqI9Fj0OsZhPBQXV8GnnLu9x+73yZb16D4Q2EPd3K6LhthFPfuexVxv4KzKnigeLTnuOw2KqwyfkwxsTvZwK6xLLofzF/0SDLS5VPQmoxx0shr+i2reZP8qEbJtX4P3fOaNsDmLk2ZR/zFTHQgU8Pv/aSfe6bOW5Ih4vFHku6pNLMuUX1BadmrofT5ar4LelZ1qBWMc5qdkJ2kWYoqLWgE5TY0oK1dr7pTko31UW0J1iAd+TTuVlg4QnjmID2BdxqPSQzCYJ6NFZWprJjwDydISGR7cvOkqV+xaWyibcqLY7KfDwy7sCLiPWHVwp5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmapXM9HD4+VC7s5wetNjcOZwtM08/s+SCdvZAEGxt8=;
 b=RhJr8uxMp8+T/FsgJyyNS0LLA4MtsPtc3SuzS+l0GtixV1nWzcD4pHW06eHEKEAaTeHUQTF2Kf4WRg9MvO1E8mvvi7tk9Vs6Pkl6nPcZJ5ahGIrZ8lPkKjbqy90Gz3GvowstoYlfTZrZECzd0kQljV5YsK48DPf6QjXckelcY1s=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:29 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:29 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 04/17] arm64: Introduce GICv5 FDT IRQ types
Thread-Topic: [PATCH kvmtool v2 04/17] arm64: Introduce GICv5 FDT IRQ types
Thread-Index: AQHchxWhhhGKHAjYa0imviDrIrk6bA==
Date: Fri, 16 Jan 2026 18:26:29 +0000
Message-ID: <20260116182606.61856-5-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|AMS0EPF00000190:EE_|PAXPR08MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: b817ac06-d6ec-4d66-98f0-08de552ceab3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?UhDV7s0lqJsaRWaJAoeD1z06GV2TmnNZXsMz7Z0Iup3R9EMm158bpd4ZRz?=
 =?iso-8859-1?Q?8dYj6aMmv1snsaS/gWRV37XY+knL5hlXtcrDp7QL0DuNaiMTjIM6V/tRRg?=
 =?iso-8859-1?Q?VukwrJRfMNt0AZog7zMImNTb/stLOXUsyjh9sOO2VBx/vWF/DH+NGqWtuA?=
 =?iso-8859-1?Q?BEif2dl6o6aQ8ATMIClg6kH9+h5cGif8qTjWy9Vp9CGP5DJ5znWznKVrEX?=
 =?iso-8859-1?Q?rZCKVKF9ATZLFgWO3SRnE8rdesTrDutRC6aP+NTHjFmvJfbKzIvRki/2OB?=
 =?iso-8859-1?Q?YxSF/TxEdismCUE0exSqX7uB7jbRsSgCD+M+y9/OpOI09X6koF54m29L27?=
 =?iso-8859-1?Q?zKXo1aKs2lk8zRz7fuRWX3EiD2MI4HbKDrJfwRj/LJ7mAGrHybXFwFcXwU?=
 =?iso-8859-1?Q?h8SV2pg1IEzoC3WzJNQymwHKOhC2hRtrZe21Syxpjut3Ab6MKrXnBSBhAL?=
 =?iso-8859-1?Q?0hKWYKwflkI0VGQKMs/N5SS3slu+BlACqYqUTQcCdRlWDZ/fHUCHLEc8uG?=
 =?iso-8859-1?Q?gQ+MIVSnc4exbZwPmopEWnSNTjyoUHeRjY7oZCj+k8ANikYFJcqTEHmzz+?=
 =?iso-8859-1?Q?JM+IPrGtadXyrP/GQ506jDF+D+dFOvDzJf1+Egu5LA6G0/x0/48djjus6P?=
 =?iso-8859-1?Q?vPmYt81Cu/udKhdiZGfjH3GGbwlg+PQNbFPzXQaf17NEj1iOY0rohTypjY?=
 =?iso-8859-1?Q?SyBRImD5xyTfMCFTpXEMnRd2wIWbxK9NYsAILVJ2/xNIyEtq3p7PUE8ZUE?=
 =?iso-8859-1?Q?ri47VttoVQsujQcscwLvlR1gfhCLg7i21W5AZcbgDEtnkfvfhFDwLB+Gjt?=
 =?iso-8859-1?Q?ISxiXfLtFE+DQ5CIwFYaYo1YcpJqlpmb+rJ1gnbsOENhrXRBuV+Aa5iw++?=
 =?iso-8859-1?Q?zG4HwCZ9qf7ibjYG0cXvKQfUiaQrlC3YKgMJG936GN687upLJUFWScq6aN?=
 =?iso-8859-1?Q?Nch1yl0iN0TMNKZ/xeVoHDJfSCJKgUqBD1OSFU0gtv1nKnwDZQmVsE/uUc?=
 =?iso-8859-1?Q?Vdr1Lud8W4TRuXUO1GqvgyNbyG3OTjZzGgcN6SFMGBnM5495UPtdv+RlpZ?=
 =?iso-8859-1?Q?WWZsdulZnP/gNdcvL280lRPm0aS6zESqVcecB0pv1gWVqpP4PF5nSVzEJa?=
 =?iso-8859-1?Q?XShKltTSYDVz28k63m/tyqPCLe64mtpxrl5IS0UdRwEnIMbuWyseGPsNx6?=
 =?iso-8859-1?Q?w/GpcAvzrBJmxhiM/f1qqKnZKwHpPoPzVq/Na9Kt7lCATEmPxyiFYHfiIT?=
 =?iso-8859-1?Q?luWQQGH8nul018ug7qyg7LLxAJfHcERaM0HIKGpaiLkccSVVPISx/9/MHv?=
 =?iso-8859-1?Q?vUFQtqAUF91fhnETVklGjRqDrRr9yv/TmNUIgwSbaGx0KdACTtT6m137iG?=
 =?iso-8859-1?Q?FL6ydoJNCy2C7c76/obp4MHi5eiHXpSMb8xk4XW1H3e0Aoyq5wxRYgTw3q?=
 =?iso-8859-1?Q?UVhtHNhoqotuLs/LnOYm98AztO6ivxdXb2en/J5EexPY6qhtHfiIJQHHqy?=
 =?iso-8859-1?Q?w499KAS6GmYGz4kN9A5t8spXc0jDhZUrTuXUrK0U7Xhskf4iXi/t6TkVTq?=
 =?iso-8859-1?Q?IyqFOqlbRxa20wjFxl22VHtU+ozw+BV0sC8JPbBjwVoSvpi+A7HDaQNsFx?=
 =?iso-8859-1?Q?fajjiZ4ZICk2/G0b+y3SRYO5sr2GYWOdiplxq1Onl3T/n9yrTunelXJI+z?=
 =?iso-8859-1?Q?4NTFrDp1Apb1eL3GSP8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000190.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bf62466c-b5a2-4095-1606-08de552cc43e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?+//sbNotbY+MupzQR1rzYh/IvK3/2xVsAR0emXyxCqZloBjsnJ6sJBEQX7?=
 =?iso-8859-1?Q?y5NaseruBrlpF4vJD39GVGt27+KQzwcgzKIyyJ2UCUG3vjWiC5hg+ZjXjA?=
 =?iso-8859-1?Q?X39bMlkzVu7APm7GvWpL0Ds+USfbh+PkTy8xPU14P5DfWrGd1ioHWZpuKx?=
 =?iso-8859-1?Q?U387Wsh193pZP3CwszzjMhzU+e3exHN2HzFzcm6D6lpdbUNe4cJFyyg+fZ?=
 =?iso-8859-1?Q?sEbct0s5szR6as1sKRVTLI40jsAY7but+G3zNuNJXMv/PxUwyJIo+7+FBW?=
 =?iso-8859-1?Q?BgtL/KO+54oPipevArWn3kSZhOaW1qnEmrnixnXwQEDO346grnDhBHs/EA?=
 =?iso-8859-1?Q?gPbRANBBvTqGCjPVhzVrGyYSO9FstKWESLXhQ5TRQXNokgQLe8oHMwXtpZ?=
 =?iso-8859-1?Q?0OB2DGIVS4jksnJO3E6sqajWdkLxDjdtFNHuXlGBUy6A12ilA0SIEJ+2vH?=
 =?iso-8859-1?Q?To0UXsoR5L5C9bxXSuvHc/8WFytbLg8nslnWnCGJVYxyzKsq7bpV/OC8Pe?=
 =?iso-8859-1?Q?nN5YOpaZeiwV0UaUkeUmstMHTIGwAfm9BYNTywvh0MvEEGL6cLCD4lmYgn?=
 =?iso-8859-1?Q?4ETD4rTk6oY0Kud7JZ88Y9xx0SYP9oZq6hNYZbYUIMPyb45CMC+pDBTJCv?=
 =?iso-8859-1?Q?vl225tYfpovDvLu3n2XuDC3JWW6xfE526vg7BREtFCBZlqFkNRnsonf59T?=
 =?iso-8859-1?Q?Z6Bs/MXcWa1BZ51j40Ddn7MMQ0owjQcC0749MgSLTuWELtjJr7AchTXPcz?=
 =?iso-8859-1?Q?R6H12ouymCQWxT3oN5GZYmwT1YSnNhjmp0hJe5k9iL6YCMhkSenCS7qlFq?=
 =?iso-8859-1?Q?2xqU8psacq+zoGDchm1uU4xwvfYFVB7IvTEnwK5m79aF62Z0Vr63UryBOc?=
 =?iso-8859-1?Q?nVALLm53O2XpItLxpQZwT+n7DxopXmhtjph6XmGklDBr3FZkY/3HQ8XLCW?=
 =?iso-8859-1?Q?Qefii02pzHJi3d06vYDWXI5evdUCHnmMPWrZqqEE+TZH8D2XYncrVf37qO?=
 =?iso-8859-1?Q?MOWBWJa4roUbWO+uqovxRewpzrQWMm22qu7CQI2c4yhzfW2JSuizsI/8pt?=
 =?iso-8859-1?Q?j6uE6qq8gy167XTBWEKN0tewchOfW3zEnhuoAT2AZR8ay9XCdMSd7Ppvxp?=
 =?iso-8859-1?Q?EDqofJfFqclWBmQSuDpIi1Vkpl8cAyLHLzoc/AUouJZDslluCxNmP0ACLH?=
 =?iso-8859-1?Q?E/lQ3muSu+hVHr9RUoT9zKg10Z53mJIuptUGaqBZZiJGo5khtaK4eTK8K/?=
 =?iso-8859-1?Q?TvqDT2mkA7d4aN+EAkInSHx/3BV11xxDeWyDuJyYBkGXDjw7tSTosqkGEs?=
 =?iso-8859-1?Q?KXVyeeDaCbPP1xMUmikte48xBv5kVShpMzRVf3Q4Xcljw52L3fx8llPzA2?=
 =?iso-8859-1?Q?uf0FMj//v+fOF0CnzpzCoIW/ZNzW2kBtbavwcu4iBuX4nCwOG5JX3T9zgl?=
 =?iso-8859-1?Q?5xM47xylWAO8qFVbCa6vt3vn/xCy14ct4hHkvPi8Uhw4omchun+wUW+nj8?=
 =?iso-8859-1?Q?yM00HSJkI51XUUcmFPP/dmbjs0dvV2hQ3QhQTeTK54f9tPeLFimDA6yRzf?=
 =?iso-8859-1?Q?5I6gv6rzLLLU5t2nqb2ICzhdeg0Ez6IGpmSGzeHX0hPukfb4G5h9EbC5hK?=
 =?iso-8859-1?Q?sFa4b+eF8BFC1s7jARDcUj8O5RvwANe4G9pQy8o+m9yELRwT4DjCFDQv+f?=
 =?iso-8859-1?Q?thL/sEYlLyIUfGMF1NN7Q3kxb2sLz6EwnFc9KkvPBui2UxfGvWJuVMOFam?=
 =?iso-8859-1?Q?wDtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:33.6745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b817ac06-d6ec-4d66-98f0-08de552ceab3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000190.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6399

In order to correctly describe GICv5 interrupts in the FDT, we add the
GICv5-specific FDT identifiers for GICv5's PPIs, and SPIs. These
match those from GICv5's device tree schema.

NOTE: LPIs are intentionally omitted as there is no way to describe
them in the DT, and KVM doesn't provide an interface for userspace to
drive them directly in the first place.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/kvm/gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 991aa912..f534ea5b 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -10,6 +10,12 @@
 #define GIC_FDT_IRQ_TYPE_SPI		0
 #define GIC_FDT_IRQ_TYPE_PPI		1
=20
+#define GICV5_FDT_IRQ_TYPE_PPI          1
+/* No LPI */
+#define GICV5_FDT_IRQ_TYPE_SPI          3
+#define GICV5_FDT_IRQ_TYPE_SHIFT        29
+#define GICV5_FDT_IRQ_TYPE_MASK         (0x7 << GICV5_FDT_IRQ_TYPE_SHIFT)
+
 #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
 #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
=20
--=20
2.34.1

