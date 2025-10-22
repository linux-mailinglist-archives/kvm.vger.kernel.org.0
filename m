Return-Path: <kvm+bounces-60826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A957CBFC456
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A7DD1A60D79
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADAE34B665;
	Wed, 22 Oct 2025 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKIVlwFZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKIVlwFZ"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013020.outbound.protection.outlook.com [40.107.162.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9B34B18E;
	Wed, 22 Oct 2025 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140779; cv=fail; b=QYHCyYj0fxDaH64zGeqN344goj8I8J0CWFC5LhOMNf9zebST9giQjdMqsHlWmKkTuAR7TNnJlVNEkvFX9JgbjCk6r+Y4N0Q9Ki9WxTJ/wQeJqbJS3ZVV/oIQvheUaFJ/SMgH5qyG9K02GIkjaxjHeHq8jE8/MmhIg5cyfH1dWZo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140779; c=relaxed/simple;
	bh=jDB701XfYFeaMENvgKIf1DkNe5xTJu6lyToN24zr3c0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kFfoBa8omVDSTGGK0EUeK9Iq9ZTwbBKGZ4XB9san+JidY5MaqkSvFkJpY0msKJ22aitM483x0w2kIt2ZSZvx1MJsg0V3ISKxBVoS4BqdWRy6vHizlZMsFh/ZtXM0Jf/gETcm4NjPKEOdPs7yWvVUEcx+5S4nl3C+p6ilu21rroI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKIVlwFZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKIVlwFZ; arc=fail smtp.client-ip=40.107.162.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AOB5iV8NMcBK9DAUB1ofThRjS03d0lDmm6AyBhl5n/kMBcsl+mjyy0d250Bt3Bdy7oNhZRGJ3MOFB4d71IYhadydLkSPh1mjF9wexMSaabuX3gLx//h/JlN02xbDr3rMhbkR+cjF5vzhhhIfzauvild85QM/9WVxTd1khvRYuNeIAqdUUeTekgH5+ZV11CRKfoliDKCKky1qzdybrOuTgqa0pyg51F5Pb4HMfj3PIy2xO/uZE7dn9nKFFMOu3OvSsNUgMtHbfizKupvDSEBR49k8PpCm2fK1kDlNEU5KiITmQ1uabyiCX60PRG3yozkFmcz5BcpW2CkfQUQi0ArSyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8R/Vs3cn3rBLCgtk7NMUTKNsPqIst2k9Qiu3mCQYyqE=;
 b=iPqyJoZ+hL3ADZrlJ0qe/gdD2M0FOoo1XzazPf2392loIHyPsjMxhkOCouRSm6RwT19rJ74vjQJIDM4lKeVBuRjo1WPY7zLamcTi+j/NnR60Anu6XjNashQThxtS3vrRrzwNEd3gzhYGbwS8tZ1T99h5vbXAtKfpq048d88bAX15b/1YFkbqdz/XE5QhbgkWdqq5wufC1IOz4KupJk64iq+8tW8n8SGCnzRBdbxwSXWdiBQCMje+6KLzzI6Tr3OrI8MZuLuR6TCWT31ptWtYXurTw/15stIVqaVnBm+mdX+VsvPBbT0WUV0Wl0ljY8V9SqBYs7Rw9iA61Fu11I/r7w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R/Vs3cn3rBLCgtk7NMUTKNsPqIst2k9Qiu3mCQYyqE=;
 b=OKIVlwFZa+TprxRDHW1IrfD26PQxkC3RkoBjalKQkrx756XpsVXeg4s8/KouQXnfH5vFD8Xk2/Sd/VQBwtmlrNdcOrqAo9dF5drv0PuU8rv8yxQ7BukaG2ITMJ3hWSmAlnQi/OZpPpNRxYr8NJqRHWa01e4CXANct1QD1X5RUNU=
Received: from PAYP264CA0015.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::20)
 by GVXPR08MB11663.eurprd08.prod.outlook.com (2603:10a6:150:325::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:46:11 +0000
Received: from AM4PEPF00025F9A.EURPRD83.prod.outlook.com
 (2603:10a6:102:11e:cafe::d6) by PAYP264CA0015.outlook.office365.com
 (2603:10a6:102:11e::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 13:46:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9A.mail.protection.outlook.com (10.167.16.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.0 via
 Frontend Transport; Wed, 22 Oct 2025 13:46:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B74Fs/p7yCz0QGM7ujadCQQ4R/0IKlaCKBwkRpOdkzna7sY0/ItAuaKeL8D2FO/1xo31ouuqMVEBf291RCQjNnm3ETfyz8fvzHqDjHvgYBwXK4b6Ahvj+rHz/zDD7uTQbVNeIH/6ypROqsmEB2wxE5EVP7Y1vpwcsMddvwV7Pne4vKgriC82CRRx/GDtVl4FR9gbvHyef0l2KNl4NSPeZu+ejijH0FrONo6ET1XKc51WXqBs54yXCbcOzBEMyCv1fQyzwEGt092GmSx1hkynIbdQxVixXLTo5gqZ3bG0SWAEGRyIkEl+iX9wl8XJsftIXfY1XQvMtWMz7WeOlznPPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8R/Vs3cn3rBLCgtk7NMUTKNsPqIst2k9Qiu3mCQYyqE=;
 b=tf//W3hGNR4dpVlG9t9Ao/90VRBK4wanhaFXbF/jvb6PD2oXaeNvekVVKqnVQ5ooQQjwImZpotlAyE9uVGI0fVp8vd3t1Wqr61OhyKajUft68o+l5727XQYBMcnq0jNymAPfcDUo+FQlkFWmJZdiILsmUdR/0Jz9fTB3XQjdNFj9N06pATlnI+SOOYs0444nhI1jvzuysp8ZxJgmFVukvoEIahKBY6tBLREp1jWEHX+C/y7pW6lOcgNWnYS06T4US4SnoFZWILpAV6ZVBwxl6eyQgz9n+lsnM6J/GL1Vk/07NYov07R79mULCFF3LdL439msXHf6NrKSZC/tZjOo6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R/Vs3cn3rBLCgtk7NMUTKNsPqIst2k9Qiu3mCQYyqE=;
 b=OKIVlwFZa+TprxRDHW1IrfD26PQxkC3RkoBjalKQkrx756XpsVXeg4s8/KouQXnfH5vFD8Xk2/Sd/VQBwtmlrNdcOrqAo9dF5drv0PuU8rv8yxQ7BukaG2ITMJ3hWSmAlnQi/OZpPpNRxYr8NJqRHWa01e4CXANct1QD1X5RUNU=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by DU2PR08MB10129.eurprd08.prod.outlook.com (2603:10a6:10:492::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:36 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:35 +0000
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
Subject: [PATCH v3 0/5] arm64/sysreg: Introduce Prefix descriptor and
 generated ICH_VMCR_EL2 support
Thread-Topic: [PATCH v3 0/5] arm64/sysreg: Introduce Prefix descriptor and
 generated ICH_VMCR_EL2 support
Thread-Index: AQHcQ1okx7V9vTeEgEi7R1O58GbGug==
Date: Wed, 22 Oct 2025 13:45:35 +0000
Message-ID: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|DU2PR08MB10129:EE_|AM4PEPF00025F9A:EE_|GVXPR08MB11663:EE_
X-MS-Office365-Filtering-Correlation-Id: 26dad0d0-6fd6-4d4a-a22c-08de11715b5b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?XLBlB5eLNSrZhrtsFwJ2MZbUu75mloB+zdzmvTXw0Dwxrr7aZPOdkMsrN9?=
 =?iso-8859-1?Q?RuMRvqZY9sapmIs6E/H51wUwZc0pH3qgWFcB6smy6fGDyStDAZP1+/nv/F?=
 =?iso-8859-1?Q?jpxcHsKH4qBZ2yOszHxu9OhEEHJWWGgEVlR8dXNp5b3HLrjaqf/k9OKCm/?=
 =?iso-8859-1?Q?25HDrziPBNnMHnJIGQVFe7KsYSBkBtBckkVf3rK4AeZ60RWQmahHDlj1eI?=
 =?iso-8859-1?Q?HbfmYETrniIOvjv+Xb4cVTMJIljGeepsmqBiuXdVtVS8PGUg85T9P4Gcpb?=
 =?iso-8859-1?Q?fYiA1xLsY2AijHdtcnEO+y6fIierDo4Ai9D5mKehAxd954GkdC9jtz/CZr?=
 =?iso-8859-1?Q?zCHxM2IE3nk36zUiWeW9VbfnxQF6v7hvgN7VZoo1MX3A9NjV3IFQRPlinv?=
 =?iso-8859-1?Q?Y6bt90NmeMA+GnRj7Vz5O1+o2tHFdAVyPDCBJ17VsmVfTMW7xaK9uUZ5CO?=
 =?iso-8859-1?Q?5BfTKnUJL6eAsHMieDSRXEqZ8WQsEVi+GyL1oYaCSrUYRaBlNhYVkacYZS?=
 =?iso-8859-1?Q?bIigQYWEnRxYTc0jrJzRqjHL+5nUHGO9y2cgl0dg2aqqtKXqQXZIMXXYfd?=
 =?iso-8859-1?Q?1VELoGJ1vpt8SR0yM/nsVhT4AN+ikPvTn53+8U3ivypz/Ucn3JIl7te0f2?=
 =?iso-8859-1?Q?+th1tW5xe9TWQnyHk86TJVi1xo/qcXjQ/0AgdPRmZITU4tL5Mz3CD3WvDM?=
 =?iso-8859-1?Q?IMcmgUcf/917U3hDoXm3GE/OXAmLIgRhU/2Qz8USvJKbeBFfIAMjUn2KZL?=
 =?iso-8859-1?Q?6CVUoGz2Ta8qduBUUMJoEnX9TbxKW5O0JkDVVC96P6yOAiA/qOaI9KneDO?=
 =?iso-8859-1?Q?ao/IZNSjz9xtmzwV1g78vJe1YV3MCn0q4QiFObQN3kNeQjzKCThu4fgBPt?=
 =?iso-8859-1?Q?sd6xUtDNBHlC4QL2Z1+g6PTdxhpwnZ0YgQ0vdHGqfo7P8JLNckS2hK5mna?=
 =?iso-8859-1?Q?mE9cpky2KxQ7TPCXSfegbdv1EvDB6l0VtbOLHIdL4L/tkoL8aQpj2TzyHY?=
 =?iso-8859-1?Q?rPW9zRh3EKJ0pzIOXBwZlAKpQOs2uDwrRS6/rbGVY3UbMDTooJngC0Wa1Y?=
 =?iso-8859-1?Q?hmWonkFjaet7KsTu8JWmI1JVD4/63ZSN1lqLRynf6Kt+NPxaVGsV557mzN?=
 =?iso-8859-1?Q?1lRokS3l3guZAouNNqO7+TB8ThXikUXbgUeU9wte4E/E1ASelBRQd70hXp?=
 =?iso-8859-1?Q?aDFbCC7IGa4KC8wKsioJw3rieEP0aUCIdBeEhSnZqR9LZGMItxseC3MrKL?=
 =?iso-8859-1?Q?/8Nsjgb0xaVTLPy/Lmw3eqDa/oN+lFXD7Lu8FY7VcsoyzUA01QaJQPmzbf?=
 =?iso-8859-1?Q?jPynW1MyZPvBhkDL3QQ3jRnV+TSaYPf3jjbNdk/Z6Vm4W5ErxdKbPJj7Iw?=
 =?iso-8859-1?Q?Eu99hq6bC7/cfe8FXhv5XPe3xcHnFWc2/J8n67qFY+l+2Qgs49ByhAp3Nw?=
 =?iso-8859-1?Q?txfk7nM8KKeL76dMYPeqK0ULtCNfP8DQTdsPG/j9D0O6tyQXmLQHo2R9jw?=
 =?iso-8859-1?Q?wafFFbcH8Np06LpqXCo8BQXNdxx3BSdswuPdl1nelEmh2PuiP1KRzA6QLz?=
 =?iso-8859-1?Q?0/D5+OTo8li48iirKxIQ/gAYCkmTGWbRUm29/AixEuBvvEkChw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10129
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3836a927-b50e-44b4-41c1-08de11714749
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?yeRcdjhlBP1BlZGrEjNNohoLwa1EfBTYccILtPmVisgEycJp1f3hjVQ6JU?=
 =?iso-8859-1?Q?dK5qOY8muUSRobUorApX/zhWQUazNW3I6sNOKtkWWF87bkC0WsgNdYvV9Z?=
 =?iso-8859-1?Q?DCp9xl23YFG0Kf6icKSYejYE8Y0aUaXtqssDhsnhSXD2ia6kxYuZKW2qkm?=
 =?iso-8859-1?Q?pohK6DOyEeeLcd6O9rUIkeLhMGDyBVeANmqV/TXfZmck1/ThZw+s1M+4Ed?=
 =?iso-8859-1?Q?M1Svvl6tsdb09AFwNVhBYCUU03R66jagh5IvlD//UMYyr2gALV8oisBpJo?=
 =?iso-8859-1?Q?Wjz0QeshK6hgVmGYn3yQauD/X/opIea7g5a1NMIFnd69p3gmA1VMKrcnnv?=
 =?iso-8859-1?Q?3oXybejjUwqb2q0zP3O7XxfR3GoXgM406nUhgCRa6Mz5jXFDm6R082UBT7?=
 =?iso-8859-1?Q?2LSbErrROtEoEekCErybl8BkDotD5pVDkjq0UiyF8cr13Zq4A8/p5CNY83?=
 =?iso-8859-1?Q?SqTRRgSSMCbKlKvG6cZL419uXyg7smqp53p1zbnon0GGoCFoE5uZnw1H2g?=
 =?iso-8859-1?Q?cPBNdmoz+6Q12jvFFwkac1dpWhrbGF/a5r89DeWklPstIhQiwjTRI9FZdX?=
 =?iso-8859-1?Q?9Ao9u3dkiBRDvduWa7ULjUIjGWQ/HjgjBNPEzsiG4yUQGF/HELMJNxEX/t?=
 =?iso-8859-1?Q?rW9CpXamzuPRTXIwItL90cOQ9yC0SR/jcpeYBjhQ4MSIa9UOd+o7o/2Oja?=
 =?iso-8859-1?Q?SSwOY7ClzxpaNVjBpR8tKT+MNLga+TusBhpIZVoYsv3zcsVU6tfd9XfRqO?=
 =?iso-8859-1?Q?Iqbn3aqZFowuskMSo+hTqxaToitJ3r7d947hVG5nEVpEqQWoZqZGA1UL9u?=
 =?iso-8859-1?Q?Fl4PybpG7tFLHiZdCbQ+kaPb9GwH/ZulOivDcHVEA692AA0cgtG5juRa8M?=
 =?iso-8859-1?Q?JnmgF4V+D6Fo4ls1/lDIDfKWaOHcOnMmnOaYKHEvIof/f9yPt5pyC7ruNL?=
 =?iso-8859-1?Q?76XA7/6ZaDb9Tn2WWmgUFDeQDRddZJx3TcxnleAi4q9aLWUw4hGWHo1Cg9?=
 =?iso-8859-1?Q?FJqEn6yXHWtYqGyo08RetHzyrfuHMznlsu0EXtVF1CGJ0Q4xTiwhjeVx+G?=
 =?iso-8859-1?Q?UdNUH+X8quCJf1hWQ9oCJDFOs0OFN9/wiUnzbm66t0NdLY20Q5c+X8cswv?=
 =?iso-8859-1?Q?YONzQeGRgRfj2eNpS0fqPE6oiUoR8x140C9P9P9RGzTkpmYriSlZHWpIdn?=
 =?iso-8859-1?Q?IRkQ58/dNeh6G6A8Onne3zT41sYezIHlERAXWLb7jopERYcIGcJjMDmTys?=
 =?iso-8859-1?Q?IisVApdjOs0i4i+WlkUWl7EfqMnTrh25zo4TJclFHZn3kUI6b884Wnu88A?=
 =?iso-8859-1?Q?h8desEmTTTVbfmkFVys6DDhdD/GG8MYR3TTI/d0vbLJ8ZbOG6/HhAbrJ2z?=
 =?iso-8859-1?Q?G2RcWNVNUjQkARJ7FYarCHrx5LL7ioQ/d49ox7nLLMNlytORBMqiQwEbzy?=
 =?iso-8859-1?Q?UJQUSC+6Zg2r2ylVhfMAlhG79GXh39+/lM1z4Llxef4QPH65y3XB515ihH?=
 =?iso-8859-1?Q?Zh5zgTLyC4eD3wzAA14wtcizhJBSufWhU1LcZcuAtnDHyQayQ9nhQg+DVI?=
 =?iso-8859-1?Q?60gNh+rwxEk/pQXaxkihxiqUlxlSTgo9aBzdH0IMZ87QEjVA6fHBmz+OIr?=
 =?iso-8859-1?Q?D6xsjccEuyysaCBL7mvMR6oxQVEfOlpAwl?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:09.3861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dad0d0-6fd6-4d4a-a22c-08de11715b5b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11663

This series introduces support for conditional field encodings in the
sysreg description framework and migrates the vGIC-v3 code to use
generated definitions for ICH_VMCR_EL2, in part as an example of how
the Prefix descriptor can be used. In addition, it fixes an issue with
the tracking of incomplete system register definitions.

Together, these patches complete the migration of ICH_VMCR_EL2 to the
sysreg framework and establish the infrastructure needed to describe
registers with multiple field encodings.

Thanks,
Sascha

v2 -> v3:
	- Rebased against 6.18-rc2
	- Added checks for duplicated Prefixes within Sysreg/SysregFields
	- Split RESx/UNKN function refactor into a separate patch
	- Added Reviewed-by trailers for first two patches

v1 -> v2:
	- Re-worked the generator to use Prefix instead of Feat
	- Removed implicit Feat generation

v2: https://lore.kernel.org/lkml/20251009165427.437379-1-sascha.bischoff@ar=
m.com
v1: https://lore.kernel.org/lkml/20251007153505.1606208-1-sascha.bischoff@a=
rm.com

Sascha Bischoff (5):
  arm64/sysreg: Fix checks for incomplete sysreg definitions
  arm64/sysreg: Support feature-specific fields with 'Prefix' descriptor
  arm64/sysreg: Move generation of RES0/RES1/UNKN to function
  arm64/sysreg: Add ICH_VMCR_EL2
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2

 arch/arm64/include/asm/sysreg.h      |  21 ----
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  64 +++++-------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |  42 ++++----
 arch/arm64/tools/gen-sysreg.awk      | 146 ++++++++++++++++++---------
 arch/arm64/tools/sysreg              |  21 ++++
 6 files changed, 171 insertions(+), 131 deletions(-)

--=20
2.34.1

