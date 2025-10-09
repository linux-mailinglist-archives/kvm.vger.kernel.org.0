Return-Path: <kvm+bounces-59720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B404BCA41D
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 18:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496CA19E70F3
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 16:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D271923BCF7;
	Thu,  9 Oct 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TcqY/hvD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TcqY/hvD"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E8E2264DC;
	Thu,  9 Oct 2025 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760028928; cv=fail; b=U/o4bpd7S2FXY7S2Y1AqMjDaz2qfaYk8WpoanE3gJKerNAKMM+NnSKqNUHG6ehnIXhGWfG2S9QPqD+0DSSa1oIF5bj792hG6tecqqFlHzyr6Po+5tx44GCP+o1Wj59YwCDAvgm9h3EFSUGVqEblASjASiH72yB7RSw8MI+3Z9OE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760028928; c=relaxed/simple;
	bh=kIg2fmlCnCoDet1SmM15f2fjTUpcYgQnookAa31I5gw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qsk/McQLpN3NatNWyrc85B/pHJduvZ7e2rs0+zBnjbjUtRMIOLwPCV86pXCKiU43AQqNJYHrctr+iWfz8/EJiCuO/aRO80Y+JZhRYBW4gMKxq/i4TsZepCDx6Vnk1Nu2v/Rjd9NWzpdn3tiPVYxJ9tFCnjZwWQ6w1xBoUA30aTg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TcqY/hvD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TcqY/hvD; arc=fail smtp.client-ip=52.101.66.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TQENvdL1jCefoRekPgiIjqZn7fVCUrncz0+YaG+LH5I1AraCdW+lu8SEWhtb45WMJ/cGRWyQ1PNog8ijiyEdfEnA7+da0Cis9AEVtpwPShbT/bUY54KC/r4lXzJZ+vpcZDGWhgii/Jo6GTlxCYijvS27m40Gz7JF8rQ9cGYFsboHebquCQqxwqoF5fNdQG1jlRYOOIQ0lOr8Qo98Ig0FXdz+kvwc6X5IwbGcKmThI0sGJUYpCpM6SvuMmzte43km3CTOuOEnGUAKQP6b1BtqJ6QHLJx5cPawbtVC/mjxusrnpOI4ac9Lfn6SIWdZZfwE2EEk/YL4aT0EO3ukeEdC4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb5Q2Ol0YLbT1pdH6xGpYSlcDHd3kJho7DfzzI4Uj9w=;
 b=VcYvpbTw4ckzF9LGcwdRLgCoADm7zmCimJoFGgJ1Rf8q2pQNWKECBzbflCqWegSvpQgGDur/4LZMWgYAa8WGQPjpzUU0LitZDE1u9JxtdiXTlSlt+MrWxWrhtKexSSc3xiM9d6ovqUD4PfPYS0P2OEmL2l/7DgFqkldIrgphT3OlQieffAmtP46btimuHTB4TNEM92QP1U/uurDmgy3d/JRhKezPDqxTiz6f/LHLDZk8H4bnXntG4nG2lJZGB3DAp138Olkgixl13JO+qDgRwljopetmelAhQ13z34lmUGqoocGqALheV73sZToW/DstjgwnHHi70Z4rfhyR78UsgQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hb5Q2Ol0YLbT1pdH6xGpYSlcDHd3kJho7DfzzI4Uj9w=;
 b=TcqY/hvDz0R5/WMPuoz99MdW+BefqN9hfliGmevWWDbCdG0CAz/YsL5TqaLnSqGu1UjDZElP4+TtZWVR4IziV1cHTLkeQAFdhwc2Rpo1bO275pwTF2zMOhmvpGSphIPR6SifCuAysyfp1JKAV2MfLCIqbhX9FJzVPd2SXwSXIz0=
Received: from AM9P193CA0008.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::13)
 by DB9PR08MB9803.eurprd08.prod.outlook.com (2603:10a6:10:460::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:55:21 +0000
Received: from AMS0EPF00000192.eurprd05.prod.outlook.com
 (2603:10a6:20b:21e:cafe::b6) by AM9P193CA0008.outlook.office365.com
 (2603:10a6:20b:21e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Thu,
 9 Oct 2025 16:55:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000192.mail.protection.outlook.com (10.167.16.218) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Thu, 9 Oct 2025 16:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3grx1C1lTLoQs4dp1raEC7th9Erwfhaccf6lKme6wzIGa1h9dkQ4UcVgj9KFxkb8aS/38vpVWNLr+wW8U09LkhdrYeHw9yVRYVUQY23n99bobqz5TJMvjcggeshERxou3TPo1d9oMJUsxhVv46P5RfS9a1MCYC2FZUseTUQzBmnvFJ7HN1isAJgEoDpPvosir1uDoTqsLYdk++8ibJZthpdxM+9CZGHnmJXhJuL7VJTFPbIXGnfW3j5tp7kSO3ep7vgA1W0o/20GBVsk/C+pK2GfVfSAMr6F/7Hz10FC5vTNnJUgCodBdDrhxtvXpiPl1znTf1n+7EkY2K/v6egVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb5Q2Ol0YLbT1pdH6xGpYSlcDHd3kJho7DfzzI4Uj9w=;
 b=RsD22/BRaNmiBMOhq8MxhcWWoUypqWzhAhmGqHL9fNZKRg41POdmxXAN2wTOU2sxpIdp7K3ZD8O3G/kizOOa5vQYTZ9eiJOgnII6QgC5EJYorj2ZpObnIEYZ7fdJgXw08HHM0lfRAE+7+52QimTxROCkZI2Hnz6GVWEN9jOIt3iQbTSgZsXU374gYM9scw2SFTfKNpI/+DtXYsY0TLrUU2cJlOa+UIOsJKifIwuJxR1peIgTpbAwyul8N6A8QQnj901w8YwiMjlkNctP/HLwMubV1SeG7RfK8ME/tACe/kChlRFv6My30UFIjyHYESDXlZTUW5kQ5YMInIZZe5FkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hb5Q2Ol0YLbT1pdH6xGpYSlcDHd3kJho7DfzzI4Uj9w=;
 b=TcqY/hvDz0R5/WMPuoz99MdW+BefqN9hfliGmevWWDbCdG0CAz/YsL5TqaLnSqGu1UjDZElP4+TtZWVR4IziV1cHTLkeQAFdhwc2Rpo1bO275pwTF2zMOhmvpGSphIPR6SifCuAysyfp1JKAV2MfLCIqbhX9FJzVPd2SXwSXIz0=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB3PR08MB8795.eurprd08.prod.outlook.com (2603:10a6:10:432::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:54:48 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 16:54:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH v2 1/4] arm64/sysreg: Fix checks for incomplete sysreg
 definitions
Thread-Topic: [PATCH v2 1/4] arm64/sysreg: Fix checks for incomplete sysreg
 definitions
Thread-Index: AQHcOT1r6a65ndYfEE+XapMGdpiAfA==
Date: Thu, 9 Oct 2025 16:54:47 +0000
Message-ID: <20251009165427.437379-2-sascha.bischoff@arm.com>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
In-Reply-To: <20251009165427.437379-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB3PR08MB8795:EE_|AMS0EPF00000192:EE_|DB9PR08MB9803:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b8a982-1948-4e72-d7de-08de0754a1c4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?SclAl3qBCJIdwWu2u3EzVSZKNG3y9FOAU/7cIHfH4AWCGdJB5fGTuCDsb9?=
 =?iso-8859-1?Q?oJbd8ydaHwjCoSY1yucKSN2MMxDXkMZI3vkV9FKxtFvXmhFG3NsUw/UZK+?=
 =?iso-8859-1?Q?XCeWM+jDqY5m1pO/tE7VU6aO/N54qQcCJDiHJ1E7loAJHPVcvv2rJz6StT?=
 =?iso-8859-1?Q?ZmketWl4fXA8YLn+amgUB8azL4GMUXBlH+n3BeZIp490w4xjpFA89eFq1X?=
 =?iso-8859-1?Q?x56Ngu/dMqGir8WtN6o0wvn6SGIgbkJv0dFS4jeK/jeaH9+Fvb21K8XNnH?=
 =?iso-8859-1?Q?pXt1CXMl6goDSRfoPUnxJbRiZTki1rgjDDA3cn3p12xinPaAQOIjhpAVen?=
 =?iso-8859-1?Q?ZloSZa4VjaivM1eSnlP0OTuPGa2MLZwt5EHzdiT73rSmulpHFq+jcIA2oV?=
 =?iso-8859-1?Q?f6D0hUgTAE1z6/MGj7C3d9eJ59SfKQvj96BoWVagk+2U6apGBgfWMwNNk/?=
 =?iso-8859-1?Q?EgAKRuZFBmPhoA9EYW6bHcETWtCvU5uO/dCuaHIwQ9pqB94FgXxZNva3GQ?=
 =?iso-8859-1?Q?FNDAbC0GZQUcIKZtbhzg8WViLw9cJ5aO9LlJECEmB6Lt0Gk8FCv3mi0BAR?=
 =?iso-8859-1?Q?+7ejVDHgHLeGeHfUc2b5sDTfc8mVlaC5E/JpiFxWUgFOeLGZs9kt3wkfsR?=
 =?iso-8859-1?Q?uUbL7LN2gwcaYpGSLsMO1SlAY2ZwbZIIz+66ZTVmh5O1bTXO+AEJXWrm7f?=
 =?iso-8859-1?Q?Xc2gKopoJLj49YlD0IfXP78Ma1SOXzbOCr2lThjk3xbYf/CQYw1Nea4WQ/?=
 =?iso-8859-1?Q?T/wkNfpsWN/AlL7iRght4EaLHNL/agLnfG6nQs/O9EcsLeiyudrzujJAG5?=
 =?iso-8859-1?Q?+6j21+s2wBeVKnY/CU6mDUwEjaODj2ADWnRfNfFH6m8SZu5zOXs7JqNy2h?=
 =?iso-8859-1?Q?PCyzQNHI60Wf5uRbeBvwjlcLWnrPfBfDJ7pxJbB82CEBDkubf3YiI1GQ6P?=
 =?iso-8859-1?Q?ZtnyIN+jB8NNNpNdIObhT1C4pYQ8R/W/dMW68jUpKuI5NqslHqGj9+tJz+?=
 =?iso-8859-1?Q?bt2hHmRaITSJOS2BxcZ7rjcu7Fu7ARyzrNNTQtGXXHqs6WmCCssd33F5yf?=
 =?iso-8859-1?Q?peMUfGvs06hbs19HqCUYl5QJjIcEna31oBcuEmIB5Mc+tqRDa0am7PBRYs?=
 =?iso-8859-1?Q?xt4qS6RcSvAbJj8UWunOMo8tB5j7N4KDCtA4OE247xernnJ+9REUZL2KoS?=
 =?iso-8859-1?Q?t+7ZqLAyDfOQ6s6/eqOfUQsoU4edcTvMrlca2sr+mRWKRiAklhAy/QDMgx?=
 =?iso-8859-1?Q?oH6PMrcL7uszdzbFsFI1DTaYC7ZoL5mQfvHvIPQ17x28Oh70vzljg+gE2i?=
 =?iso-8859-1?Q?nUSycZ3ccIOL2yXG4EcnjVWnh8yMN5D8b/+jUD0QPB0saEK7UAAhaNtCDu?=
 =?iso-8859-1?Q?DCQ/JR7q+KRkbD4S5nBLzxpzNPFiVPQOf4ocO44+oIj4OdwChDq8x+Rn/q?=
 =?iso-8859-1?Q?QoMJPQY/YHweKM511rPrOiYTXd8TJvH1x3WOgxWZnstRmo5cO5AO+8Drpr?=
 =?iso-8859-1?Q?AfLsHUYZZZH1coqfcJZ8wSnC/nxn3i7b5w9VSfZAsXsYxk5IzlHKibRidO?=
 =?iso-8859-1?Q?tJLFRfkxLoXcLZkqEAnkwcY/xylo?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8795
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000192.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e69ff6c1-5314-4f90-45f9-08de07548e79
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?1+lPETLTKBPSw+RX9kjDaAG22oVNTXPgHo8dDiCZ2l110kokTLxd1MwXii?=
 =?iso-8859-1?Q?ZmX7ulHSio7Yo3O8HGOqi/8sZ+Vrk9+ZYxb/NxJ6qI9oAAVwmU2EmJHhta?=
 =?iso-8859-1?Q?hG5AFAnVQnO7sQIePWM3tm6IgZCtFlEzVJYGjoQdn7w/Lb74ohfJEw4he2?=
 =?iso-8859-1?Q?2er04cdMFB34GyEDjbJE9YWsXjynelZYe+dtKan1iFOLykl8AxEqN/spAp?=
 =?iso-8859-1?Q?ulnd7bc8MOw+j/pJnIQuB0vnwElMT5hIDhs0GPcIcQG6ean8YfQ/7m4F1R?=
 =?iso-8859-1?Q?UVs/LJQDsOHzplErtu4tGST1s0xO5zgFsM5TZSc7wgWtM4n0lMrEsIocGP?=
 =?iso-8859-1?Q?4NC8eYrwK+jOC1OwTOogCXTfPoSt01Lg9gSj0FCVCYW8HOsjGk/L+OahoO?=
 =?iso-8859-1?Q?FFFGmQkLb5OjAWHcXiKpbXqgkMrdrSDi2ffKzp1kgPCqY5K1h/73ZoLwVy?=
 =?iso-8859-1?Q?l07HI2DqCc7UpOWdI2OChV1BJmws5VjyyPW9yKetXQMxEoMeb67feOecYw?=
 =?iso-8859-1?Q?8eurY8m5jRQfqndoF7h5OZcae6gDX5e3CMjL2z+P2xP6vZwfRNP6d1iRsm?=
 =?iso-8859-1?Q?ym+tHWNFkUHw0/73yF2aswRGn3+tqFVYUI11ml/KX55dlhqm6sGO3XaWy6?=
 =?iso-8859-1?Q?4dvYlVs4uL1LZNvJ2EC76wkma/4D3teTN3VoX9mbqU194dhUzOafTdFoCf?=
 =?iso-8859-1?Q?Cr7t8fGpGQvgkbz1gXJvCrpduC9UYPDaOc1o4O9hMCvkX8qSS4FyI32FDh?=
 =?iso-8859-1?Q?xos0chvLd5s8vsLv2PA3YHdQeV0HdzQbO/gbXmVQQA2n4C2nIUAzYSuDbE?=
 =?iso-8859-1?Q?jxHRhk+HzMR/FCz2mGqLR/1RKKeGQbKa7FcOEW4oeqJVvBsgYo3fr+0pPa?=
 =?iso-8859-1?Q?164yK436xvTSizTUzFD6olD2mEgK+qXS8goJPjy5FwuBe/wTDOkZ13zk4a?=
 =?iso-8859-1?Q?aGh6tePxy+l0287G5h3d8y3iLmZ+cr2YGJlEvh58p8zuziT1we1IancEQ9?=
 =?iso-8859-1?Q?vOmDmVOF5xxlB3ZJDGOyPwwZld7rpGskXl0z7+xone9BykfjSTxJVaDcgz?=
 =?iso-8859-1?Q?BzplEHkTAAc+Cyzj5bARNhH8QWx4TL4PGVsLApwTvoJtpUuMatvYN+rzTH?=
 =?iso-8859-1?Q?kN7bkhmZ8vuGlZwkCTdjRKSfvCD2kZTyqHnJjVpHsIOeSyVO1AnaxQy9kt?=
 =?iso-8859-1?Q?2wuQfbfHI7OH7w3DcKbXvfme/xMhOZdSP0wTxiF+ZTi6aUHx3Zc2Qn1Gjl?=
 =?iso-8859-1?Q?+dkY6iBQF4067zR1DSE+kl2Ej/67hJD2Hi6RIRjp7wu4dL+P74yLsP1jKP?=
 =?iso-8859-1?Q?XyIv/TP45pg2QZtfiNAxrOtwWGptLz7oMyrrKGBa2xQBkMwyUG/bbMhLaV?=
 =?iso-8859-1?Q?pF4A4y+HbTh14pJm+civ06BPAH/LHM/tMuJhyuh5SNAPFwVMVRRBp+F6z8?=
 =?iso-8859-1?Q?XxhvG9EzWY2/9rWbbnDXJLC64YoaUcq3dsqjzC5ZBl0UFZr20KE4K25kF4?=
 =?iso-8859-1?Q?NUIOTqdVxPLw8DWV06kG5UopJ4LiEMjAFQJcXJu4ning9zmkcc3RaMU0qE?=
 =?iso-8859-1?Q?Xm4ECN0euj2NdZPkagEfoIYIKJj/c128ECgFcwhHUclWzeJo+RKVeu17d1?=
 =?iso-8859-1?Q?ap66s4454zU2c=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 16:55:20.4986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b8a982-1948-4e72-d7de-08de0754a1c4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000192.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9803

The checks for incomplete sysreg definitions were checking if the
next_bit was greater than 0, which is incorrect and missed occasions
where bit 0 hasn't been defined for a sysreg. The reason is that
next_bit is -1 when all bits have been processed (LSB - 1).

Change the checks to use >=3D 0, instead. Also, set next_bit in Mapping
to -1 instead of 0 to match these new checks.

There are no changes to the generated sysreg definitons as part of
this change, and conveniently no definitions lack definitions for bit
0.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/gen-sysreg.awk | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index f2a1732cb1f63..c74d805a2aa38 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -129,7 +129,7 @@ $1 =3D=3D "SysregFields" && block_current() =3D=3D "Roo=
t" {
=20
 $1 =3D=3D "EndSysregFields" && block_current() =3D=3D "SysregFields" {
 	expect_fields(1)
-	if (next_bit > 0)
+	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
 	define(reg "_RES0", "(" res0 ")")
@@ -180,7 +180,7 @@ $1 =3D=3D "Sysreg" && block_current() =3D=3D "Root" {
=20
 $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg" {
 	expect_fields(1)
-	if (next_bit > 0)
+	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
 	if (res0 !=3D null)
@@ -217,7 +217,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	print "/* For " reg " fields see " $2 " */"
 	print ""
=20
-        next_bit =3D 0
+        next_bit =3D -1
 	res0 =3D null
 	res1 =3D null
 	unkn =3D null
--=20
2.34.1

