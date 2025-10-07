Return-Path: <kvm+bounces-59578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 007E6BC1F08
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 17:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3C2EC34F886
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 15:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6F42E6CB4;
	Tue,  7 Oct 2025 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W974FT/o";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W974FT/o"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDDE20F08D;
	Tue,  7 Oct 2025 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759851363; cv=fail; b=EOTIdJ/0LO2JrKNoPiYLLlPbPi3htb1b93d57ZxidAw3O3SSqp+6RkpyNnvICPGpv4PR3qj27iLI/cLLNWrlWfQDOPve7ofAoCkT2yysJkYtYa6luPkLkuykZB6t5bt/hX65c1AkWKIoXYn6SxoR9GePP2QgBkFt4g71itNeOQc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759851363; c=relaxed/simple;
	bh=B6HWImSG5fswzWMi9ej5SBsXLaQOLv8aKESgRuZfq8A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W/Utuo82pv81eOCrQqfCUX/3pHgPZnD7IXgcfBUDPKAy5rq/QvO/PKNtpRBmBGN7sI5QJrkMKmcp62kpXkoyI7Qg+gMfriSsBNPyBMOncJx3qNf0Q6bT7DnsnOzS16oklEsqXy4cwgF1Sx9TtCjNGPzKz92UsrESJHRrhPJSOtA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W974FT/o; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W974FT/o; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iC0V5+oauQC6ceeuGQKo4OXjrANpnM/pCqBjqhoOjyBtzMc/thiUqOLmMpS1wjG10iku4KRVZDiJuy5FTG0w7KzpcJ0lDOBhCknmhkPruGGcczS5snGPRf++TOnKTW0UG+/GIE6hI2Ic2MYnnT1QeSgtP2FWKTWTxSDpJI9mOTMEOSPku93k7WI/4CtupgtLPYvcSYd9Lcehi0q9QqeJXBKJiIRDjPgeHE7+UYGNanBR/ZLaX0Ba7h0ShpZ8T4xHn4ARd23N5ZrUyH6Wn7IjXN0CR36y3K4RYVJpnawGch7vVykaiZlNw6P+XDDzLPEJFlMhQU2zy76ZR7RTYC839g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPxE5omc8PnGDMkQYi4U2Ijg3Zof/vWmYW68bYpwK/g=;
 b=vJJX4wwOe5CyvYB7YSBfcpgZ2hrtn8wsMe+YIhAr+tVbNm9OdkxS6c/CscYKlxPp0yhcQ8u0hjIaEmQPOv2iGQz3BZ7jGd+lN0dEefUcCcYMoYl/UJt/f5ngTNzpqUDifYAEE+HvW9ZHxsZ+6EwwDIa7OXZnDH/+wDBM4NVRZ6vw29ox/e8EN/ZBP8aR8H8emzW5xeebeAxJTW1zLk9Z+kDp15QzNYxV2Z/Jz7vxMaCwUEmB3xtw8kPdOdmbXddJsj0sWQ5sPX0DbRXVXHdbB8Nc8AaUmT4TH/lnnIf8I6d/DjtDvmkiR8xwFEdZRk05WFOVFfVLJTLWFyazBTNFJA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPxE5omc8PnGDMkQYi4U2Ijg3Zof/vWmYW68bYpwK/g=;
 b=W974FT/ocSNgYfVBe/0679yNpUMXPM7VPV8Uit70cZXKPwKxAWioh4OBhxh0TT3/3iadTiptqn3JNSQSyRSFSPeuNJLLmKDXL7SMYhukdTBVnR08qCNi9hLuBXDYjC2gr1DsVIy30j91H5759Rlj7KIS6rbyxlFG0c5zxh6+G7c=
Received: from AM0P190CA0020.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::30)
 by AS4PR08MB7478.eurprd08.prod.outlook.com (2603:10a6:20b:4e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:53 +0000
Received: from AM1PEPF000252DA.eurprd07.prod.outlook.com
 (2603:10a6:208:190:cafe::94) by AM0P190CA0020.outlook.office365.com
 (2603:10a6:208:190::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 15:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DA.mail.protection.outlook.com (10.167.16.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 15:35:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfFmK+DiRjf7Itn3wrrmQRb0lt4c4ob2BtZP5vXN84bxF6wrfZBlZ9woFpFsgCgYutLfTIQxKqDRdfPYXp3U5vwEzghenjR9spJ4YBaONu+VygDx6vxkEtfG4ERLKP4UZq6PXVfxRo/YWic2SUpqbpQLG2nZvtgmUTxa0YCsg9o5l8+zcdNYpWiClMRDDWe9i5nLPW+39AkFXO21EGvqCuFreYLQMN30ae1ibDbvw+jIjIuAX04rlJON8pSNNr9PdnqlfK4uEs/+5fb2hL0PnVwCuUrcN5s6O9OYodvHO1TKEyACvGlwRuoNKXz9rQ4HSYAMdEFQ+hVj/V06GA+yGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPxE5omc8PnGDMkQYi4U2Ijg3Zof/vWmYW68bYpwK/g=;
 b=Qft5sIA8cHqzDvDRtL0U/lP20mYz9zObmyNCVmwg+r8vzpbYrHxZgzXJV8XX2LosUnhlfnn95nct3mrEqspBb2YGoNfVy8FXx+Xjk0/ElYn+rF318SPJxLc8Lso8xpsSvBO25aZhz+V5xO8cJsiMBReKQJ6+qMT7KVVlFO8PINslfQKsTZFX1uFOCkLvVwdja+FS0ER0z1Kac1c0zqle40t+XgJiyMlFzPTdbC4qt3mMRuZHPL0OJBZmW2cO8oAA/IlR/YAf/ZLrr1usdqGsopBzAghzowBn9nefTW8hJhfjvjPLLEZBPRuVDuPdvZeka+zKFd89gy8KY9QCsNr4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPxE5omc8PnGDMkQYi4U2Ijg3Zof/vWmYW68bYpwK/g=;
 b=W974FT/ocSNgYfVBe/0679yNpUMXPM7VPV8Uit70cZXKPwKxAWioh4OBhxh0TT3/3iadTiptqn3JNSQSyRSFSPeuNJLLmKDXL7SMYhukdTBVnR08qCNi9hLuBXDYjC2gr1DsVIy30j91H5759Rlj7KIS6rbyxlFG0c5zxh6+G7c=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by PA6PR08MB10593.eurprd08.prod.outlook.com (2603:10a6:102:3c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:14 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:35:14 +0000
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
Subject: [PATCH 2/3] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Topic: [PATCH 2/3] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Index: AQHcN5/5pM74vroA00KtAM4qMTcklg==
Date: Tue, 7 Oct 2025 15:35:14 +0000
Message-ID: <20251007153505.1606208-3-sascha.bischoff@arm.com>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
In-Reply-To: <20251007153505.1606208-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|PA6PR08MB10593:EE_|AM1PEPF000252DA:EE_|AS4PR08MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb92087-1a01-4297-9f6f-08de05b73368
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?2r4rfNG62jh8ySGOVh4W2ib3zLc+1t7diOB9tsRacZhJxJ5fcKGhiRkvdE?=
 =?iso-8859-1?Q?DeYee063iFaQKnH2jAWe/JOvDzKB8tSZoWL2j9KF6LervOHidHq+QzbK5g?=
 =?iso-8859-1?Q?eH5XrIq4YKfep+FSxgILx72SZp1doj2bGPNy4sJU6VjI5pvd/IM8MLFNg6?=
 =?iso-8859-1?Q?WmyBEB2yjA4SiAJNvhqabDzpOnSqNkixi7EFNte45arG1ITXv0qpwTJMCx?=
 =?iso-8859-1?Q?P8T9gqVzUE/7g50LsLwJvgdhM9ycqRSVJncsoo9APeM8G12RTV0Y6iTh/M?=
 =?iso-8859-1?Q?1mGnCz10q6YZYhQZKMC0PbGzGr6nWApinwukprCMS+43j5d3Ydh2Uuw4bc?=
 =?iso-8859-1?Q?rJ3uF6j5AkxrvaDjoK90Datx+C5gvFflvloNtn3/jepvsWHY8f/5tvGGRk?=
 =?iso-8859-1?Q?5NtsbAyQzrWEGd+lhXI5zXPE5V+GxY52TTOmTIW4/zUru9wjO2wUndXwSK?=
 =?iso-8859-1?Q?JgUeIwQbPwVwLNDBaf2zy6flJgT9fiIjxeogf3MvZfa8FegeOYhSO9Vl1J?=
 =?iso-8859-1?Q?IjiYxm6KKjpvW7WO4WvOTq4BejYpeRI1ddooMwD7SUgd0AiI4+PUYN0Qdl?=
 =?iso-8859-1?Q?iigeHMKfLiMvi9BKLY/hQVl8Mz4aFW1BcYDu+NwAeCg4rvwNQEcAeGS8Vd?=
 =?iso-8859-1?Q?RxDFy3vm/meyIkqSW3+O0lZ/3HnfF5z72cfPTM4tuvLminH5KwOh42qN5h?=
 =?iso-8859-1?Q?nBEy32y+6Dh8G8Z+8a/x7sL58lvebQuHBwXEwKjx32nBboul9BVCF8QjJ2?=
 =?iso-8859-1?Q?W+sjy2vC/C810CiilENthAMq6zEsOPGs/NmpO/7w0Yg8SdMl8kkWFxmYzZ?=
 =?iso-8859-1?Q?DGZwf73BHS4CJ1iWaoVgXJDWr6IWqJ2r6s4F3LwVlgSRVj924JvV9r7dIv?=
 =?iso-8859-1?Q?SVDXLkNuP934eJKEp15caRVWds/w/Se0IDhcpbrmdRkL52VMXOVtyMOojA?=
 =?iso-8859-1?Q?z0QUzvT15SkOQ1a9REVBsSt5GJ92YqdUHeWDHYPPTZ4iqEKyk5MlrMkkrW?=
 =?iso-8859-1?Q?f+fhVVd6fXcdjzriSodTp1/8jTPq44+zcosYLrDVTBm2+v0kt8wGrx9qYh?=
 =?iso-8859-1?Q?JaT4hZBZJwLg/n9yHYAs++dRULBJUSNSci1+jzn9vamB2o/NRSmWsTAmLy?=
 =?iso-8859-1?Q?QcEltjyRDq3OcZCu8pPBEzFTD3eKGHCikeuff3KCPT97JJ/XrwjELk60GV?=
 =?iso-8859-1?Q?ch+iKX1weY688TYj7BuMlZFoy7kaZp+E3r1kaUql9CIJtfM9xq4GKOb7L0?=
 =?iso-8859-1?Q?PeW8e1T57L8uQpj/8CporTsHCol9I7K7TtExO7A/+DOHx1MOcfjdSJ9Dio?=
 =?iso-8859-1?Q?VeylPE/3UUsY2ORruZDw4juPdahkDy5q/jD/sTeaaX7O3HTU0ZCUDllKT8?=
 =?iso-8859-1?Q?7XjKJcFRsmWeV9PL0yr4rfO8n3NnCpJz6GvpAE6zyhwi2huqSDzplEbNTI?=
 =?iso-8859-1?Q?9A1ouimRpvRhFc9Dncu2UoKvFa4xgtIugRLJstP7WK/EX83sK2t4ttNLKL?=
 =?iso-8859-1?Q?GfyFrko/pjzygPS+g6bTF3geipOVtgFEoH9yhxGLpyE9c9vDWs3Mc8Zdnp?=
 =?iso-8859-1?Q?ApMHjbOONy2Tt2R80xQd84uQuNFZ?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10593
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d5b870f0-8f5c-4fcc-853f-08de05b71c56
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|7416014|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?z/FkPu4EJAT/J8VFtGfNMKmYDtyrhvV8/4xHgI2TEXSeYLhJNJTT/2k7ZM?=
 =?iso-8859-1?Q?IDVeazHJeivlSDMQ9/ESG9jd6+jmz6Jk5O+YbmGc1h4J+ftbYSYjP9nCoW?=
 =?iso-8859-1?Q?UIf4WAbE4aHs97YR0/UWMjcP2YSRqcFg/HU9c1kiMrpis9/foy0n87uUZv?=
 =?iso-8859-1?Q?ycDuiKNrYX3fHxg1VidweHYV5acmeBdMYCc6TcGSgwFM11iZX8IaU2KAXU?=
 =?iso-8859-1?Q?lZgGcrG49n8ftLp7WzlYyqEGTQqN42w/N8SBd2NeuRTdeDHlGm3DQVtNyJ?=
 =?iso-8859-1?Q?QiMrjb1M4vk4SVunJMe/8DXA+wAeV5drE+b1uJIssHyccRDC7D8+Ja/Mxt?=
 =?iso-8859-1?Q?v3hWJ/MX6DVm40527FInG4MSkvI08cplWwISYx7FY6ZKbAAATtoWd8IIgF?=
 =?iso-8859-1?Q?AfHQZDxrzbXNTaJcMp32dxOX//fp1BbFAyP8vxISIzhGiDyfk+CIsP13H+?=
 =?iso-8859-1?Q?cfLn4zbY8rC0QSQegRPwqW/FDZJUkMs9i6NnN8Xt0fDHbZB8QOWJuYjJ+b?=
 =?iso-8859-1?Q?xNDpbUpfQBtXQMDXtHrZ44RVy2SQr7vAhs0/HeeI504s+/DyIhSsswzo5Y?=
 =?iso-8859-1?Q?5nyjzCf6UFsBNSiSc0E9qOT+FcNPlFwBGFqUS7GqXBFy45x6laVxyY9cgt?=
 =?iso-8859-1?Q?fy5niYrKeeCK+twy6FYHz/6pA1hEhZjIblUDSozG7rcxpe7Taj+3e6erwW?=
 =?iso-8859-1?Q?ghHV/Vmlt9+OrvutkAhakbWUKFJTB7yaY9IpP+cG1dW+iBApIGPNTmY4mU?=
 =?iso-8859-1?Q?loN1pWqHwGgWsjZlUOnpGsProxgONlsgrBJkpE14oRkZFUJBhpo33yr/Cy?=
 =?iso-8859-1?Q?xGPFQke9UpdfnT9JbqGOiA+LXZikCNNGmy7JYP4ULIsgtxFOCae+Rwa38g?=
 =?iso-8859-1?Q?4DIBidvZ8sgycCwcgWS0W1HMyp9uBPsNR9OVsng4LxRgz5YyhcDEQRGsF7?=
 =?iso-8859-1?Q?H0jH7WtPqB9VvCgWWxFIh43w7f6haZMBJngFpf8M+TlRJ3hoyx4LhK/LBA?=
 =?iso-8859-1?Q?KmRQBEsNexY04NJVePvgqtI3GIT0RfDvCFETQLAVuGqx8hNQyts4hHeGcs?=
 =?iso-8859-1?Q?Pi2QdHZ1gV6J/caEaMo/1YpYOPQk8EcaKj8WP2rYe0Jw7NtKb3kTNDwKCv?=
 =?iso-8859-1?Q?ZqNOg8LcMs+DTFNNGlsjPVmyY0/yMFlZtRC6DYh19P5cGTHI2KCQpSfiyG?=
 =?iso-8859-1?Q?9F0qv9zjFihzXC3tgQLdlh/aUirO4iw9xob9UNIz89zs7yGOZ9OxaJ2GH4?=
 =?iso-8859-1?Q?fF7xwMUsB7vjxVsRsNFKLOotGA0yXgImv6pyGzdvINNyoV2YMCirQMPic/?=
 =?iso-8859-1?Q?y4UOd1/QziEVdJVzk7Uw43s4rtqOx+BkXlUsjW8of+6zzDwgwXTDc8aZHh?=
 =?iso-8859-1?Q?NyXcsME66kwO+EWUVWjBOsNuGAslNve5f+JWEpAWyADJFjY+zcCs9MEd01?=
 =?iso-8859-1?Q?gktzHUjh2O8RhImRF+PymXIyqr9foSElB4KcwKXryDt0XXLik+LJkm0p9A?=
 =?iso-8859-1?Q?NatfX3KjzBongcuCVnA3NQlAidl6BswYLOGpDYU9GNLRrZ+Uhx9wDTK8hK?=
 =?iso-8859-1?Q?+I0XLPs6RW8pO8CEOq339yjUAEe487q+rDWdiljuIR6c8utYSYqiH7/aRr?=
 =?iso-8859-1?Q?CBRfdTCGQRr5M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(7416014)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:35:53.1941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb92087-1a01-4297-9f6f-08de05b73368
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7478

Add the ICH_VMCR_EL2 register, which is required for the upcoming
GICv5 KVM support. This register has two different field encodings,
based on if it is used for GICv3 or GICv5-based VMs. The
GICv5-specific field encodings are generated with a FEAT_GCIE prefix.

This register is already described in the GICv3 KVM code
directly. This will be ported across to use the generated encodings as
part of an upcoming change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a674..a2bf8a689f968 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4668,6 +4668,28 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_VMCR_EL2	3	4	12	11	7
+Feat	FEAT_GCIE
+Res0	63:32
+Field	31:27	VPMR
+Res0	26:1
+Field	0	EN
+ElseFeat
+Res0	63:32
+Field	31:24	VPMR
+Field	23:21	VBPR0
+Field	20:18	VBPR1
+Res0	17:10
+Field	9	VEOIM
+Res0	8:5
+Field	4	VCBPR
+Field	3	VFIQEn
+Field	2	VAckCtl
+Field	1	VENG1
+Field	0	VENG0
+EndFeat
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

