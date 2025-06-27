Return-Path: <kvm+bounces-50972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F658AEB3D3
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21DB41C206FB
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC142989B2;
	Fri, 27 Jun 2025 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qKGR4Yiy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qKGR4Yiy"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011025.outbound.protection.outlook.com [52.101.70.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95826AABA;
	Fri, 27 Jun 2025 10:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018982; cv=fail; b=hnEFcW+qapLz1G4VHPa1OQ4b2X2Yuo00Eh7Ip129Zgm7cbQoWZxWaetg+PeQ59cAFRiqR4zcdp4lTVWR/stvDnMb96sE3sf44bHXaLwzKeiZchuni+bYC3ZyhKurSEwpE/MNEp+c9toDkhhXwaLlsyZKxKquFp0ohOfXN1WuhTQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018982; c=relaxed/simple;
	bh=8Iv3JvzuK+XHqxiTndtOKisr8VyObalSy4Law5QxVTM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cwBQid8E3W/E1sDDln8Io1QX/QckCJYKZtCASJq72U70phpSSYILcR9HvzWCiU4VOB5McB2Hg/97ZG7MMxRjg4VKrvE5gTIGNnrZKsh1wib3IM9tycnfiYDsiWe889e+d3tG4l6rFJU9SqaN8kwpZf+eCN0Bd54eLCe8f99sss8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qKGR4Yiy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qKGR4Yiy; arc=fail smtp.client-ip=52.101.70.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jNEBRFgzu+msy1W+KeNpQY9Ao/VucvpgswOdqCV0I3y1iLRW+NqFHAKx4lf9kHwdPb/1hWlBUAOnNy43bZ1U3n/NNWKeKERxmKK7dpX+SxHOvN55AJtGCWjDU/EzFeVUxNW7IrCcNX+kqF+dRK7XATwUp/bIt1tbV8hGA1bp09kp/YUXLCTjbBqawiDt0yUEwM6ZQbiInIJ+g5yx1hICDeF5NGHlDzvIU2b7xXsFW4GNRZgvsW95Mk30XU10NwvwCJVwXVyr/MPJ0uU5sKqZm81koa5pIp5vUXeP+ugZgyHZcwRY9Ke0BKn3VEoT6bwnT1AZzZRCJ+I3DazB7LQFOg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIUBzmiBW1JBCjFDPPEKevEQfV0uHE4Z8+dJA/Aly/E=;
 b=EZTrwxu5tz88SAgXWHR4u0qUUmtMDDe/8ulCn1q9KOQEAiEQRwTdlv9ObivHF4J53qSSNLDRWtEWbQDkhTnfH3pry8Y6PUoMTq2NuzyzhC62ZndU51O/P8yEEoDQxjEzbFbxOIevBKbh7QN8+7ibTraasE3OzzLzwxk6Plfj5SFmudF8fwwHAEj6v6G4+XidBBPVeMaB1Pr78yFNwlS5/3UdLH/2ZqFIqsmTqx1YQWzT2r6TbCAvsqCsmMhkBlH4znR0yHmZ5PyiSZsW8005SImy+Ve5RlyDt8TsnDbP1YIi6g9GM78lwLEwsN0wS8W0+WlcaCq7dy8KacTaSVLnQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIUBzmiBW1JBCjFDPPEKevEQfV0uHE4Z8+dJA/Aly/E=;
 b=qKGR4YiyRDDb8I4D4ESHfpi97Tb+Yp8fcK5ALfgclW9Fld0jkZCajM9oCbn/1Gp8OYQnCJ9/48fcexldtkrMCzzix8GHmwyErCJlUGnlRVcaU5noLoRkQtSP/MfSOhPc2zZFC7xxNG+G+WNLYF6vxG1WyIbn2oNIgXR1De34qYg=
Received: from AM0PR02CA0091.eurprd02.prod.outlook.com (2603:10a6:208:154::32)
 by AM8PR08MB6499.eurprd08.prod.outlook.com (2603:10a6:20b:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Fri, 27 Jun
 2025 10:09:34 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:208:154:cafe::bf) by AM0PR02CA0091.outlook.office365.com
 (2603:10a6:208:154::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.19 via Frontend Transport; Fri,
 27 Jun 2025 10:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XuV18Yd7GEbGwbbiDMrMNXxYsEEOpHKds8qfC/bRWI9Jk4rfhUgYOfN8RRVtB/0Yq2YLUCYT2CRHQkSfUwGp3NWzwHmSHLaVZp8+tPzx9r2FzOY+W9kxKPJQZ39gZeyiq/GmzKxBLmAev66PsIUyauypFt8JJkUaqVKKs9ncGwPyf/8wuv4QdoGM2l1unq4SbFvB2jkAkyT3NvTHIbI/y9nht/FANmOawLXXAR9OhmVuRnt2QeKiT0Z13CGJkbISEq/7rM7sAax7SSfqPAtFZQz3HCfU/jVGdL4+wW35qCcaj5MkPLzUkfSIhF+xcEWmBAr4ZBCgmpt2vqsLSBScIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIUBzmiBW1JBCjFDPPEKevEQfV0uHE4Z8+dJA/Aly/E=;
 b=u0T/xY2bpgVa5qN5PdaJx/X6r6o9Zl8nnDEcTUQrpJOiMFr+E5r5XzCo/pax/RHN6zbZuAJwy3yN4/3l1RaJeFyUIzb9Abpv0Uf/A+sJnFphIiDvLI8vvl6fiqR6URd3dksxgeBc3leoct4bJZy9d+yXRWkdXWE0+jCkTS2XEzQ84BvlM4r2tjgfyWTwtQxtpUuBB63rdT/gkdueArmUT66oZHT1jdTGpy69S6+OiKjD0Xh2XD6FOHnxN0/GtNuWSUJdN6e+6J/h3DzEa+WXvHiEt08GIxdiUpnJ79ZjeD32Lx93MrtSx9EgL4uVz/dzGvRO6oyF+MCkI2QKW6cVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIUBzmiBW1JBCjFDPPEKevEQfV0uHE4Z8+dJA/Aly/E=;
 b=qKGR4YiyRDDb8I4D4ESHfpi97Tb+Yp8fcK5ALfgclW9Fld0jkZCajM9oCbn/1Gp8OYQnCJ9/48fcexldtkrMCzzix8GHmwyErCJlUGnlRVcaU5noLoRkQtSP/MfSOhPc2zZFC7xxNG+G+WNLYF6vxG1WyIbn2oNIgXR1De34qYg=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by PAXPR08MB7466.eurprd08.prod.outlook.com (2603:10a6:102:2b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:01 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 10:09:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH v2 0/5] KVM: arm64: Enable GICv3 guests on GICv5 hosts using
 FEAT_GCIE_LEGACY
Thread-Topic: [PATCH v2 0/5] KVM: arm64: Enable GICv3 guests on GICv5 hosts
 using FEAT_GCIE_LEGACY
Thread-Index: AQHb50uBP6i55Bg74EyTUn1xFa6B4g==
Date: Fri, 27 Jun 2025 10:09:01 +0000
Message-ID: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|AM4PEPF00027A65:EE_|AM8PR08MB6499:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bced817-8fd3-4285-8d22-08ddb562b6d0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?3+E6PIcuehLuims72Ly2wGg7zjb/um8Dd4GsUUist9lXHKlqXHIyID0WhS?=
 =?iso-8859-1?Q?adf4GGlRSHzS0pdqEu1MpMtnZ1LNhUtqZnUoz5N3tUBj7pk4VEmPB6uSJY?=
 =?iso-8859-1?Q?FrimQI/KQtT+ZOZRUbgi5NQMuu0Sn2pOuXEdqK9WzI3zppsxW9dSaZcRNL?=
 =?iso-8859-1?Q?lR3Sct1RffIxD5tf14wwMqGjtGm3LnmQ5Stl/vfm4ovS9VElx6PbwMI8By?=
 =?iso-8859-1?Q?45sSsEQVh7rp1Tun4i4UV5URBLfr2JM7Q6JQjVnddGksa/B9PT82bV8toW?=
 =?iso-8859-1?Q?DMYjUWmne11dpYP5Gxb1Jm9Vw5cX4FH6oUgmf2fdanZVwtUXWRbGPiUv+L?=
 =?iso-8859-1?Q?JhE3IKEX9E+hQLDNowbI6tX78W/WAbgw/+fKRVTcn8emDtsRa9mpEBxPdb?=
 =?iso-8859-1?Q?nWCOnU1QPlkvHStPCjkdtui1F2Ok4mzzy0F5hJuy1iIsTFccLEK1zZyWJl?=
 =?iso-8859-1?Q?OtRm3tW8YaI8KhlrIhvMJBE6NIiq659PSZvflRBy6BQG+8wZ+88QlKNvrh?=
 =?iso-8859-1?Q?Q6wYYM7ruYnFpdHaEgQwGV/yNXXhIA2Tec6/oIl3UinNuVr5O2xP37nRIl?=
 =?iso-8859-1?Q?NxA/eMLXFmZ0H4ijH5HnnLtRGWEX9RWqjLUzd45PsmMZrmpEEsckRSjVWm?=
 =?iso-8859-1?Q?UG4EObpTNBA2psQA6ZQHRK+3Evuh2PVqnG59u4PBwy4tgTtT4WbLRWsH6x?=
 =?iso-8859-1?Q?6LIVFhV8HBUX4NElCP8v9aU9jE4lb4jPbK3PwaLN5mFUIWquzwX07+XnhT?=
 =?iso-8859-1?Q?ghjypO6rBQWAQHOD8Fe2mXrgfaMobAnVZsrSdA7qwHxe2kKZat7TqPAaKA?=
 =?iso-8859-1?Q?TV1JYVhZ+Zayg14CpzEInNKhSOmCM8VnZoB3gEtM8F6jm8FRgCFEJQIsQX?=
 =?iso-8859-1?Q?zLCV/KSchHdrugcfbkXLkiXz2XzzzlvbHCstXsr8Bi4Y1QmnkNtVBlcMKc?=
 =?iso-8859-1?Q?1/50x7LBPnfJ57oQpN3C0POdD7rYqxkwbvuaxJvH+bTswFfsJofWW6ncT8?=
 =?iso-8859-1?Q?+Zc2ux5U7YcDGEk+WzL+MikhvqTOwQgsHKveoahi/aqiqgLlh2j8L7QDd5?=
 =?iso-8859-1?Q?utZuTUih+DIsIuW2mDKScoxGebDXoqGl7uHuNBxCOkYA09XlF5Y8h4poKw?=
 =?iso-8859-1?Q?nHqcyLWSfo4f6RPnlQtsNkPQkb79qOGvMJI820fm5KJip/4uRdoDE33Fmc?=
 =?iso-8859-1?Q?tG2T82GSnVpIDbEDpYrrDN9vhS6EhGSZ0+zSEdQkUhMAREYb4njDrgQcGd?=
 =?iso-8859-1?Q?T5rM1lfRcfTEjA33Deo+7kkZR4V2Rs02CvIbxJ7ZVNOOWbEU/34w7suCW1?=
 =?iso-8859-1?Q?Z4HNmq04gw89TEp8rF1piDgv7xcsBvVNvgFQTVw89+pxt4Ef1wklO/5sEc?=
 =?iso-8859-1?Q?6O19zvRC5fCuDAvIUs9SMVaNAmJw1WrTmeeJT+pPaLn5i858bLufxqzKYT?=
 =?iso-8859-1?Q?fzJbl6UTjysJvliBlwjcNiE7/C2KJ9//6GKtaG9LR+A2P0iKMJNBWy3BMy?=
 =?iso-8859-1?Q?wNhSSRWS1eA1rMlNaWKySioVAcejFMEsBX2EhomnzJ8PO/RMyhUAUJ3oey?=
 =?iso-8859-1?Q?tnHAjuw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	94c9de44-9771-4597-658a-08ddb562a38c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|376014|7416014|35042699022|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?VmUd8iWUhiJcPuuYGC5JAzs76do0WNyvmwHySXbsbuKu9zLG7Z9hRgVc2q?=
 =?iso-8859-1?Q?a6X/6cZ1AI0pyFbZ13bN5tRb2X7w4VlBE4Ftvf7ZzgdG4H83otQx1nbPdj?=
 =?iso-8859-1?Q?wv1zZYfeBuZD5EID4iBMYqpm7iT9Xg8ncXR0tvDTDh66+nEK3bW34fSh1K?=
 =?iso-8859-1?Q?2Uv0QNKoRS3A9GhYue+9LKtq6ayA2Unc5v/HhQMN+fvrQ0a90Dnb3Vyj/D?=
 =?iso-8859-1?Q?WKGCUpp0/+Xy68mZ0+7NEjFdsJO/oT1sIwgQzp0+/ONT0XNMZSVuRDACyu?=
 =?iso-8859-1?Q?IpW5/78Y6odLmvOsSH2I8cFSdlUChkefPrg8+MWAJT/xj4P8gV7Ku1/ere?=
 =?iso-8859-1?Q?ys/OSSWkEjUcheNSbUcqUCt8JpmInMh3z8EA8nultBJ/a7AVJ4F7feBkv+?=
 =?iso-8859-1?Q?EtXXOTcQRXOhk0NdtzmlMFWz+QJ4FzilxVrzmZyXkusJK17E2uU7IHcEnI?=
 =?iso-8859-1?Q?sShY9DGEaVES4newLOYYBTkpZIWqvrBPX6L+2hjOSA3bmPZHWhCcH/Zo8f?=
 =?iso-8859-1?Q?cnIqReUFwgLgVFb2APkomFmA+ThtDZpjTLwQA5kCjOsFaemPFcqZMhDgPe?=
 =?iso-8859-1?Q?2Wx+P8SE7sHtQCjDty0i4Ps+6+4nPqw2mw9MG5N9RJD71C8sMZK5q4A2lG?=
 =?iso-8859-1?Q?AXG2oxoT4c7oFDtDAR+KXPV9JGaDe+9PUermNmpIk7JQMVXfs7ruoVk5w8?=
 =?iso-8859-1?Q?pXPNrm0zQ5bNN3QAfWl4EjFjjvtYuq4oRZ+qsr7HrG7swDRdwLyo07Hvfb?=
 =?iso-8859-1?Q?FZAZYb4tLuIhSOoYG438hvuPwFwyBQ8dXhw8tvLiYwgwMQNqPhmlh6+wfD?=
 =?iso-8859-1?Q?HejHeo4BzzMpa2w8OYTIfJ/sPozbh/1RSo66G0O+vXwfBk0PUgeBjMzRls?=
 =?iso-8859-1?Q?0nogHwOdERCbTSHZTMT4q0JYOX9S3F9NaSOqe/jbcb9qKi8huD1uOjdxep?=
 =?iso-8859-1?Q?TQa5V1OSUEWiFepZ3CO0g3F3ZWGakB9syQQDicqrwNewgp1QdvpolqnXib?=
 =?iso-8859-1?Q?4VjL/hW3fmK8yt6/Uo5/cC/aCn4AaxkLASnSZFYQ5K4wxKwT+qdyWunKkD?=
 =?iso-8859-1?Q?kfea5ZVtAaCsnE8ZK/gGSdLtQ4Vl5Zy4IqU0ARMN36LChxNvYHoR7a4NQQ?=
 =?iso-8859-1?Q?jFQZgnh3CEMn4jYuFxMmaxyqu7d6Lm0aCN+hot3snPePOkjoFdx8wgAs+a?=
 =?iso-8859-1?Q?YQJEAxQFLc9ovCKQDCFUMBBxwGWw+EHubkf65OPB/7ENps9PXU5Ahj/OrR?=
 =?iso-8859-1?Q?TUsGJmtrYqL0yLYLdCimMy7yhOiZxHZQs9g91sHEJaVTHn6KON/GeYic6u?=
 =?iso-8859-1?Q?Q/ceNsb+HclWFtfNQqxnwOeFmU8I3e7QW4Jxq7i0naGoi3JFNSIIHG+mRg?=
 =?iso-8859-1?Q?Sc7r9+i3xHOa2hjhypBCdf0iIvfRoLf/cQuxwLVOMKMo+ab/x8js3BsCTM?=
 =?iso-8859-1?Q?pDjBL2lsWeWhQALS+/IChR6J2C3VOwPKsbDT3DCEFF3jiCsOheQKND7sNl?=
 =?iso-8859-1?Q?yOUuHsBlTyJO2VHrGHHdlsPaHl+YaIP/f8ydK5q7yAYB44Uv9tkYoHFj0T?=
 =?iso-8859-1?Q?ep6XDlm7zB91Xh5e9ce3C6YioTDIPTF6VZUrUptl4oJGjuGAmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(376014)(7416014)(35042699022)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:33.4095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bced817-8fd3-4285-8d22-08ddb562b6d0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6499

Hi all,

This series introduces support for running GICv3 guests on GICv5 hosts
by leveraging the GICv5 legacy compatibility feature
(FEAT_GCIE_LEGACY). The main motivation is to enable existing GICv3
VMs on GICv5 system without VM or VMM modifications - things should
work out of the box.

The changes are focused on two main areas:

    KVM GIC support: Enabling detection of a GICv5 host and
    configuring it to support GICv3 guests.

    IRQ chip support: Ensuring forwarded PPIs behave consistently with
    GICv3 expectations.

Summary of the patches:

    Ensure injected guest interrupts behave correctly by deferring
    deactivation to the guest, matching GICv3-native behavior.

    Set up the necessary GIC capabilities to advertise
    FEAT_GCIE_LEGACY to KVM.

    Add missing system register required for enabling GICv3 compat
    mode from EL2.

    Enable full support for running GICv3 VMs on a GICv5 host when
    compat mode is present, covering VHE, nVHE, and protected KVM
    configurations (excluding nested virt).

    Introduce a probe routine to enable GICv5 when FEAT_GCIE_LEGACY is
    detected. This consumes the gic_kvm_info populated earlier.

This support has been co-developed with T.Hayes, indicated with
Co-authored-by tags.

This series is based and dependent on [PATCH v6 00/31] Arm GICv5: Host
driver implementation [1].

Feedback welcome!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20250626-gicv5-host-v6-0-48e046af4642@kerne=
l.org/
---
Changes in v2:
- Switched to a lazy-disable approach for compat mode
- Merged compat mode enable into __vgic_v3_restore_vmcr_aprs
- Moved to using GICV5_CPUIF cpucap, where possible
- Cleaned up helper functions
- Added Reviewed-by tag
- Link to v1: https://lore.kernel.org/all/20250620160741.3513940-1-sascha.b=
ischoff@arm.com/
---
Sascha Bischoff (5):
  irqchip/gic-v5: Skip deactivate for forwarded PPI interrupts
  irqchip/gic-v5: Populate struct gic_kvm_info
  arm64/sysreg: Add ICH_VCTLR_EL2
  KVM: arm64: gic-v5: Support GICv3 compat
  KVM: arm64: gic-v5: Probe for GICv5

 arch/arm64/kvm/Makefile               |  3 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c       | 51 +++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c             | 10 +++++-
 arch/arm64/kvm/vgic/vgic-init.c       |  9 +++--
 arch/arm64/kvm/vgic/vgic-v5.c         | 52 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            | 13 +++++++
 arch/arm64/tools/sysreg               |  6 ++++
 drivers/irqchip/irq-gic-v5.c          | 50 ++++++++++++++++++++++++++
 include/kvm/arm_vgic.h                |  6 +++-
 include/linux/irqchip/arm-vgic-info.h |  4 +++
 10 files changed, 191 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c

--=20
2.34.1

