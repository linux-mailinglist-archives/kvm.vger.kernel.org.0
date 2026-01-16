Return-Path: <kvm+bounces-68383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE44D38443
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4BF803015465
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B7E3A0B2A;
	Fri, 16 Jan 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Erzbz9wG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Erzbz9wG"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011057.outbound.protection.outlook.com [52.101.65.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077739C63B
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588128; cv=fail; b=uGCKiM7r7W+7ano9ErEwvc2QyiTHLqBsOq/IPzp2QCQoTZOFG3jvG9vtGWObC/Q09+uRgIWJEnl7z3amUxOWQvSoTCps8Fq0XTvRLwbP+e1+oaaD3Czq5Gb1p2g01vBufJs38VtuluabUaRbhE65nx5jqk9ofg9Jy6JIOvr6MiY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588128; c=relaxed/simple;
	bh=phPj4XNcCxX5SBozQRqoBrtgVu0iy9NojEr0AKYPHuc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jxCyUY5k7Y+OLrfK+qmb/4a2CDCVr6pvoIf8U7xm7Uf2ql+viGUhz2k0C7ms+WTWb2N4t59JBqMDAHZr7YNAm1xLzsW6q7cGOmKugaYBuVRdptkBsqMVvyPqxrC0aQ5dObs5fvg5TKRWLkF97lF4ZIysZ9l/KY526X3/9GUMANI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Erzbz9wG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Erzbz9wG; arc=fail smtp.client-ip=52.101.65.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m58+OZjrw5jkyYmjPEm/ySOwFYr6t666hAAXigCCWyH7zfvdMlwkyceBpcc2chybLJ3IhLMaQ7B4X64DBsRedpqU9tS1hDWptN5gJSrRkkvrHlUvL4UjAKsdvi34MujqyFmJ6ptlUvkwbpNlrEHXaEQ8rKsgBNcgnlvb/5iG/4vdkVnTc2z9mQ/WGWwPWChtv01nDsvDVOZhOjrkSBRVdzAMjMj5PDsPCpPxr4xVK+Ft/OVcNHVYy8adTqWRXde5blXSK03hZkpOxPSYrDhf9OxBXnjCKAdn6Xw69o5wJOBg8kqwPfRd2NTdL04ZDQl9BSt02qiDYU9vpdF7SzFnIA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUPMBui6NfX8FOT+Fk5BLwqCaXd46+SVyDo2H69K4yc=;
 b=KvtBXtYGFpAG0AefrxBZPd5s0yLqIfBslDz61HOn59L2Rqi2M8ljuwQxHbtmLOoVHR2NJofLivD0DKL/FMlW6xGEgvJRMTJZTF5bTxbzEm0SBg9xSkD6g736aZ0UdAJu065uwZoHleB1uVOT3WEZ/yJx1mXGTqM11XkHjD4bnaSsDZ4ADUWlT0cLNcQrWZh8nPRMRQUCblzur7GkmAGf5wx0V2+ftwN4m+5wzVvXdIZYncTI40IyQC0v73HBIFd0QqZiKctVvYhtTfeIe6pshbmOHxwEXmirWd81QcQDZQc5wYkxZXali/FqMf+4rFLe8XSPlrWnrIbfI9gmZbhozg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUPMBui6NfX8FOT+Fk5BLwqCaXd46+SVyDo2H69K4yc=;
 b=Erzbz9wGyBgmfNLzjlEkEYjXYMRw4OnwLzU2i3e2UCEYWtSmYbZTVDEyaCk5cbBwle5boSimUBiWAVlk9/VLNnJci+VQNGQTe4nIMdCeMBHqJpsIg+j+IPHSRDhRuS1UWR9xR+Z+5IQeegryK6Oelazo+XdeGk1prrcFHsLrX1w=
Received: from AS4P191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::18)
 by DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:28:38 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::6b) by AS4P191CA0003.outlook.office365.com
 (2603:10a6:20b:5d5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 18:28:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOsUfBFel95ejCrXhYB5wUGm/R/NaOyBuPGAw69VgCqXoGhfgGUzHH3PwmfHSCTD6Dp6hUyM4JlSI1TbA1ytI6OPsmug4Ohz5pRtGLav1Xpy5W7eU3QB3SL6wpSUO/ws3V7rn3WrdAsmYeStY6VdNFGycuG1o53GC8X48Gb/aau21aPOI0TJ1Z1qrMwann88NMTme8tzUW2UmtGCQl+aus0qBy70lnozquD4hs7+4YuiVTq7Hyd0Y/UfoBp72N12EmquyYyxKjoS4yPZg8haR7XzJWTdzdzyu+WT4VYpQuOFg+9eChlMQ0TIZ0yz49KJacJqGhmEsO+1pi/MBNHjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUPMBui6NfX8FOT+Fk5BLwqCaXd46+SVyDo2H69K4yc=;
 b=DnRCKpnh27CRPmGFOs0TOc5uyTt7YsjtHISpkCntbFA11N7i+MBR9APmB7uGtRn+Nb3J7ilubNVIgdOfNIEqsoAdjvzaJhhJSroRghck7Ipvn7uzWfYXxeSTgnkCJOpJ9BVwZrGdwAgFJ4P1sC0EKkuO5tXjUAoADztYq/hFx5f/bQwL+mgxziNYniBTE4ntPCVPWEEjNNPhczt50Mvr25wxPGXhYOhhEMjEmU//7PRxThqUZEumhcmhy4FKu6WAKqxxZ+XrxXD0IVHl/q/8g8AzodrIwAkhWUUjHLNoIbynQpMYil7oV2eC0pwMz76Xxn9BcaGSXJnMfhAN7x/Kig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUPMBui6NfX8FOT+Fk5BLwqCaXd46+SVyDo2H69K4yc=;
 b=Erzbz9wGyBgmfNLzjlEkEYjXYMRw4OnwLzU2i3e2UCEYWtSmYbZTVDEyaCk5cbBwle5boSimUBiWAVlk9/VLNnJci+VQNGQTe4nIMdCeMBHqJpsIg+j+IPHSRDhRuS1UWR9xR+Z+5IQeegryK6Oelazo+XdeGk1prrcFHsLrX1w=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:36 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:36 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 16/17] arm64: Add GICv5 ITS node to FDT
Thread-Topic: [PATCH kvmtool v2 16/17] arm64: Add GICv5 ITS node to FDT
Thread-Index: AQHchxXJjOCe9Lat20m274CWLC5GxQ==
Date: Fri, 16 Jan 2026 18:27:36 +0000
Message-ID: <20260116182606.61856-17-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AMS0EPF00000194:EE_|DU0PR08MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: a7226730-4060-47f4-b15e-08de552d1177
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?zG14myLOE60ToorOnZSfnK3l51IdtpSYs56pR4U+ZqmITOdy6ItTs2NjTx?=
 =?iso-8859-1?Q?G0Z/f7XgIgAEuE+LxPk79atbfLlOiZXGIiWHI2pLh/94y4o92GVPw1zuD6?=
 =?iso-8859-1?Q?FlsP1YvqwnBjeFoE+aLBa5b+m1ov3/OeVDmAOh2aLLFuiIb7adzZm79L+B?=
 =?iso-8859-1?Q?qPSiOM0Gi03zLWBXu6CDcP3300pmyxOEufNRDpTvOprzrFLdOxgWbx8pLq?=
 =?iso-8859-1?Q?SmHFUICwPYIp+tYVe4/068znjC+jHxQIG109hLaRbPpUH/g7z+7ovipPsO?=
 =?iso-8859-1?Q?B0TO0QFqN6Eq6gyG7l/FGtxtjYKew9GeiaKhDMfOBjPheKBTPqeJxTVAMY?=
 =?iso-8859-1?Q?xBwYaFHXee4fCWHIbmK0rgZkZ12P1ziITL4mSV8rGu2hA9K0hiaZUVMRp4?=
 =?iso-8859-1?Q?rw8M0T2BXT/j/33I0QePyeuEsaoqetzHdS1MQB9N2c0JBMYw2RZD92lS/v?=
 =?iso-8859-1?Q?ABRNfsDW+MrMV8m2qMxpUWb7g9yiuqDMMuUOtOVzuv9WsbF5vJaPqbS8Aj?=
 =?iso-8859-1?Q?J6OzJbICSSUuOWImSmsTPX5Kd8Z/QGDCNnT9lQ/VLFYRuyhgsPQZv2d7GC?=
 =?iso-8859-1?Q?mfOUY+alvnZGJC/rEvGMj2vpw/akVT5456pTbUyJ4OAchpOzYOtoSxP6Cp?=
 =?iso-8859-1?Q?wj/nw0OYyPGLFWBBW1LCX0IiWyoXEbfC/MVOfiCgGJtDMYic2+Lg5O7CvO?=
 =?iso-8859-1?Q?882GurnzmP6/ln5Z1GYsiOOPfH0n7jp8S/Si/OOrJGlm9y5EZeqAckVNh4?=
 =?iso-8859-1?Q?doR8WGRQBu458zT87JWtmgFDaDpmp6+2bhPaGFGvuOC65fhDwjOlRhE0zl?=
 =?iso-8859-1?Q?CWJHh67Spa8T+TPoL0o4P6lKdUFhQ4srUTwmyiydm6m6ye2ij1PSWPRd7p?=
 =?iso-8859-1?Q?bmUOtKTcvsGfPeEizkNIjleHuiLxr4yy6dwbIDd362+YSICgImOZkkQe/q?=
 =?iso-8859-1?Q?riG52MFokG7KIKmaDT5L54+UmMmxz1lEXYjf7Drt60Bd8JyNncNCreRT3J?=
 =?iso-8859-1?Q?LHZFe0fszcrjuk2t+mYXZuo6IxqnhBdMXfGSC1rLcvTX+ZAy9qIPZsE8ct?=
 =?iso-8859-1?Q?h4MmpjHd1I6ZElkcTjsL6VHV0vRJ0oGjYUP8oCDSqTjU5TS9qP7JcjvO42?=
 =?iso-8859-1?Q?v+j5LVs4NfFdM47xQ+i4ORbeXxFvoq2fIhlO2Ge6lIqvcV4xEHss8Afxpy?=
 =?iso-8859-1?Q?33e38V3lV6ikVFUcYr9mdWB8/b76PAzvgRSmEx1iWPlM7Zb5zpUOBj2nLk?=
 =?iso-8859-1?Q?b+1yB4YxeKvpWV2iUwxH4JGKneLcFmUoayqAx+LC60ymybZR7cRriPU0+y?=
 =?iso-8859-1?Q?g5jdsF0WooRQEjh4qoTcIPsxxJZmBn9vN+V1/A9VhRgPnFR6BS8H/yDXXw?=
 =?iso-8859-1?Q?QF4dhCvdvnTbWOqE0cbkDn6zNAJuIV3eV+S+bFEZw4u6NGVe3iUZbwHSTm?=
 =?iso-8859-1?Q?0u+VyV2IX0XaVrJ3DDGw7ojU9AEh/mCfrCH4zmCSKW50i4LDiM/X4TP1fw?=
 =?iso-8859-1?Q?St1gtcCBBCPmcM966nNlpLAB1uSlzMDCUgUnaefc0MPVCadBiIHIqP7U+G?=
 =?iso-8859-1?Q?8XoQjIiLree6v31AM/eCmn/6VpEP3cBd1PfsbkUAJHKvTzfq7JZvo+EOo9?=
 =?iso-8859-1?Q?tnoKFuwwoR2sHdOjH5ca2VaUovMPOfbK/lHWRqFuofUT1aQoguGLioXayh?=
 =?iso-8859-1?Q?27UrYqUhaOVpYeShue0=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6b4ea9cd-3dde-4673-b7b8-08de552cec52
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|14060799003|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?NH92x7QYeglqsnmK08oW9+dRBcXWsRMwgAXcJ4B/qDrgdrgc+W9DQIW+xF?=
 =?iso-8859-1?Q?ve+bHGbOJjCSAIc27tZ+O957cA+TeLql9gKnd4xI2B1onfOwd7WqdZOVub?=
 =?iso-8859-1?Q?qBS3Dau4bvZycn0RHxcjwSn63Vf3UDIQqZHn7KIH7UMyP8ZC7dEfpnYxea?=
 =?iso-8859-1?Q?9twOHqZY4DQ7ZyoMSq0eZzxj7gYtjmoc2GARRTFpVj7wIhA+3DBGyQUvvL?=
 =?iso-8859-1?Q?ibLr69mgQbalVpMIEiQWPMuMm+yVu/f8jVh/tO5A4GrrpTfIl+d97bScWg?=
 =?iso-8859-1?Q?RfFuazbLJaA0J/O+N87tUIzeW3AVG6S44zMHlDbOeApw65Uaat8uujl7U4?=
 =?iso-8859-1?Q?p1XYLZJQAfHjQIKRL7K9CbpVNTaSS7zdoYXgKKlcvbpIkTGRRvC30Z4yLD?=
 =?iso-8859-1?Q?k2lCC/eiZPW23pAMVdB+qRX0L7J3gBG1RVkLl27ssGYwqe/KqCGCX53Gwf?=
 =?iso-8859-1?Q?BSWINZBXVetDq+bLrOk+nLk5JAPjiuutOCbK6P9x1F7gtNTXMCaerk4cnj?=
 =?iso-8859-1?Q?IQ//kr7Tw3lAQ9fqtD0wuVFI3npC+Fhwz4IXBowH8c7uO8bEM1q8+UwXOo?=
 =?iso-8859-1?Q?b6fjTdzex8JjTfdnPGfLrdARB7VtLydghD5rFlh+Njx3EObwqn23Zn9pBM?=
 =?iso-8859-1?Q?/5T39SB8HnOh13+D+LPKjxqV0eXdvYN7TW2XoN9XVBU95Um8thD2fgTfru?=
 =?iso-8859-1?Q?6OAVHX4dzDAoAeNucCx5SFr/5GQFyNjK7fay+ohUksGSj/SV2NHNq5wFGY?=
 =?iso-8859-1?Q?Laq8EkgV5SD4+I/7rX18QNrWGP6AfDh0GPiR42o064lBR83Lrrv0RxtkP7?=
 =?iso-8859-1?Q?vxBHrD0vK82iuEp8MUn6EFJQT1WbbCDdwFsWlDa3L5QZrUS9I5NaY1cXpH?=
 =?iso-8859-1?Q?HwZrUn0JyXorZl7F8Rzl3Km2STiIkYz3M4Ftq19IJKQ1j9Xa+m6XO7W2rh?=
 =?iso-8859-1?Q?wcB6V7DKXIlSF823flw2ZEKx4I40o6s7Hgf5OXGIk87m5jXyHj+dI5r8mh?=
 =?iso-8859-1?Q?AJWxDL/6netyEmEnDOdIuCsu6gKb3BRnjIHst5SqsJ9eLt3yEIGHrLM0ID?=
 =?iso-8859-1?Q?LmolQIv49lCuT8KwDcNR6JfMkkz9sfBjQt34hvN7v3yezNGtyChFlZ7oI3?=
 =?iso-8859-1?Q?btjsJbIUYBHPPSGPKyJ/C1pzMgIRu1jhFEsjIuP+QMoRObZnpqY1DVxudm?=
 =?iso-8859-1?Q?ppPnnpAV3DylYFa+Q8c9EqBpC6KSOk1UqcgXsdkji16uVXJnyhCLS/aww0?=
 =?iso-8859-1?Q?IDrloncyu6rNo5Mf8EpoEJ4CPKZyjQMqaiGdJmESqHAYWe7InHI52ND5yF?=
 =?iso-8859-1?Q?Vvn4V9/HuFmcwx2goouZ+eGmlphlZ2o1XqZJFfTraBra/+kEZ8IXP1Vupv?=
 =?iso-8859-1?Q?BopQI+sSm1NFbrJVjsW/lXkhsUyArgKtQhJY4VtjApyT8xAJzQXJqJYQi4?=
 =?iso-8859-1?Q?Sdb6GzTeta3DaQappIpHqNvfRSGd+fyDtH8Ss04KSfqgd9ux4ttysbqCHe?=
 =?iso-8859-1?Q?8UpmLfvqZYC7C5a/FHAu6D24hfa6WkXfBRVuJgzYkA7Pc+pSY3wVolaBDa?=
 =?iso-8859-1?Q?bJ7lkGmupK4nlg4HYMQTH8Tv9N+H9yxFxHaEMJLk5YOUmYuOi+JlXq0D55?=
 =?iso-8859-1?Q?LrXI7QMEzX1EkKDd5uw181kaaw3YnvoFkXzpkGTgpzfjmNkYO2p5O4l0J7?=
 =?iso-8859-1?Q?9ADUJvHxB/tcKFc4W+dm3tClCJsfzF2FmbzleI8x5JBveFiFH8K2dWgI4m?=
 =?iso-8859-1?Q?Epqg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(14060799003)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:38.7293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7226730-4060-47f4-b15e-08de552d1177
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9203

Now that KVM supports the GICv5 ITS, add in the FDT to describe it to
the guest.

This ITS node is marked as the MSI controller node (PHANDLE_MSI), and
hence MSIs are now supported.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index e0fb2547..c7e4f5c9 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -448,6 +448,7 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 		reg_prop[2] =3D cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] =3D cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
 	default:
@@ -495,6 +496,16 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, s=
truct kvm *kvm)
 		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
 	};
=20
+	u64 its_config_reg_prop[] =3D {
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_SIZE),
+	};
+
+	u64 its_trans_reg_prop[] =3D {
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_SIZE)
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -527,6 +538,33 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, s=
truct kvm *kvm)
 	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * kvm->nrcpus));
 	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * kvm->nrcpus)=
);
=20
+	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5_ITS) {
+		/*
+		 * GICv5 ITS node
+		 */
+		snprintf(node_at_addr, 64, "gicv5-its@%lx", fdt64_to_cpu(its_config_reg_=
prop[0]));
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-its"));
+		_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+		_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_property(fdt, "reg", its_config_reg_prop, sizeof(its_config_reg=
_prop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-config"));
+
+		snprintf(node_at_addr, 64, "msi-controller@%lx", fdt64_to_cpu(its_trans_=
reg_prop[0]));
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_MSI));
+		_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+
+		_FDT(fdt_property(fdt, "reg", its_trans_reg_prop, sizeof(its_trans_reg_p=
rop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-translate"));
+
+		_FDT(fdt_end_node(fdt)); // End of ITS msi-controller node
+
+		_FDT(fdt_end_node(fdt)); // End of ITS node
+	}
+
 	_FDT(fdt_end_node(fdt)); // End of IRS node
=20
 	_FDT(fdt_end_node(fdt)); // End of GIC node
--=20
2.34.1

