Return-Path: <kvm+bounces-66369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC427CD12D7
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 761EA300A876
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5193C364E81;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TEigv7mK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TEigv7mK"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012054.outbound.protection.outlook.com [52.101.66.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07E6361DCC
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159642; cv=fail; b=MoRcG7GswqfpPBrqBzYdIUmS1rW4jF+8FZOHGnVu8gsNtpKCiYCusTyHA5U56xpMHKOmaV4YSv7+hLlcEfXDyy3TxLuYr299r4OOq52suAtoouFd7NjDAoegW0rXpQEe4OOE/3wIz4hl6IfaFp0b7lcZgL3BWLHqiAMDqrCBGh4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159642; c=relaxed/simple;
	bh=KXpY5rpqH2FmU4k4m7K55hZCoG4JUuhwctcFqnUgE4k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hCuP9O/xRvm8vXO97t5OIrGzfJcgyEj0ipLFlneCH6oSWC8Pm9Zx+DB3ZzKEDTHx4WVKpRAgvQQF3KkC4b7rBmIYDOtJkYI+N2we8x4ZVdNNlxmx25T110Wpho3sCLYsvQ6r9CSZGvZuedrtp67Kx0oGkjZZ+IrP/xb1maE7N34=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TEigv7mK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TEigv7mK; arc=fail smtp.client-ip=52.101.66.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Q3yoqHCpH0nJso03vciXdy95svN0yJ7WfziAodzmPDqdrka9qeQV5AoklEG+u+5lTN6OXsvxjvkxTvR2A06EWsyCgj7Rv7Hcc8zEUCW+YGPzYKnOGXc2i99zf82ymIEUXM2tzLhqAP8yL4w27N6Nt6+jrDtBSPQFbBd0Pg4NUNXe4U9r4NZCo7ukHvuYTTOaYIgxF5EDRc0upq5pgzjIs2DjGr3omvmjiBTlon1HiFEnS7qX0QYzZJQ/w0JuNH/ed8HAB9E3dzRjG8/EvspZ4MlP+yvv2AdfwkhoO2VjFjCejtbhZoph4r/87KyDb5lkG/Ex3dqHoeWkp7fsCUbRAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XegnCf7EgrwSI8BVEAcbR7oeU+WPnKDqpaoBNH7QH/M=;
 b=Tl1jPkBQ63jlPW9ZNbRG7CLqkRs2w04QDXs8T4/B+vl9xr8XG8oiq5FlceoeVLHpYCep7FUVL+nsQTyuJZJBV+THpIhW6vpIbGTZ7Ym+snDxQHJHI9/EgwuWVrnO4umcBxAaHI3YC6/ASapUz42c+PhGAMzDcCxbhD5k79gJcbW1zeD657k31cNCLUGU3tuwZdxAYWc18J0M8dmDLYWR1uyCpC7HymtEQ/COsTyIg6T6boG1AsF4e8butoYtrvCfapnSfReKU0Mddx8XIW0OC6RdogaG/w5iF6u2omAtT46CGygo3a+ugKHBdOsAJS5Qs5/1ehW7s3aHjJfZ6RqMbA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XegnCf7EgrwSI8BVEAcbR7oeU+WPnKDqpaoBNH7QH/M=;
 b=TEigv7mKIAlukn+7qtitZ408+bz8iBLQKwwnDwhjZACCVSojIgF69TCZVryYtoS0iLAj3C17NQDMFwS0uiPeUoAuz8cwjPO4KXB4maDVRMERBPyCmVbnzEYC2PdzVlT4PTCaoqwHPIPJ9zAmMbKKYYicUm5EbBfpjEBOoCP0XHg=
Received: from DUZPR01CA0133.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::28) by PAXPR08MB7350.eurprd08.prod.outlook.com
 (2603:10a6:102:227::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:49 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::59) by DUZPR01CA0133.outlook.office365.com
 (2603:10a6:10:4bc::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jiT6TC4PLJkKjSGR+tco6eJW6sZdBcTwCoG2WM+3n/1mC2Miy9XkjljbhjGaUxNV6vDPkH1hhcAtQiqGcmypA63HcdV/ca0Uok/6Ket1O693pqXDzkA2J0oLU1q6l2YgCM1EXDOWXw200hZ0Uat8/QAf+cXh3adQBJACwffg9jEe6+Phtp73FGtsSs+MuvQxqFjHymW+9n9EseHU3mVBzMLKD9G2y+++/3sSxew184myijaOp8cNqZJBWWvF55KVvtMxMBgWjD+/fX5rlGUd6yUTgMgMHvV9xz9YBZ0usUamj/GvqRAVCVYvSVT3M5bXuQFquCHms0sUi5a6NNHWZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XegnCf7EgrwSI8BVEAcbR7oeU+WPnKDqpaoBNH7QH/M=;
 b=Kn+sEtsbCiWsP0G3QrEM5kxnr+0tMC6eIPG8xxVpTzy+5LSWrMBH63n44rzYvBSqQKnAaKOI/EGy3OseLz85Cu5jEff5ROCr5LwCmNwboUBLKd3ihkFQzZl7x7VByPMCosdh0cEqSDg7PkzRSdf2C68pFineyjCQS3C2fHm0d2ocyr9iSj8kwT33pyS9XmeaKWSPzhQKaSeiPK7Qp2gdb/gN0SLtY3R1QH5LKhsFuMuNGPVa2wgqifLcHHI7X5HPUH5hUAXTforRwbt5iZO0SVf7w5O5SAti6LbxEutrTyfJnAcQzQeKg/QtnRre9eLg23IZIFHoPgmOcKcoz9zKyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XegnCf7EgrwSI8BVEAcbR7oeU+WPnKDqpaoBNH7QH/M=;
 b=TEigv7mKIAlukn+7qtitZ408+bz8iBLQKwwnDwhjZACCVSojIgF69TCZVryYtoS0iLAj3C17NQDMFwS0uiPeUoAuz8cwjPO4KXB4maDVRMERBPyCmVbnzEYC2PdzVlT4PTCaoqwHPIPJ9zAmMbKKYYicUm5EbBfpjEBOoCP0XHg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:43 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHccP+CYg5kbO2rxk6vK6+w3RGKYA==
Date: Fri, 19 Dec 2025 15:52:42 +0000
Message-ID: <20251219155222.1383109-20-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DU2PEPF00028D01:EE_|PAXPR08MB7350:EE_
X-MS-Office365-Filtering-Correlation-Id: d221fb70-ec6e-4fd3-0fa9-08de3f16cce9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?W6rIK2UEMvNMf1QXmV/l1HBhk+PJIKBGCjKS9jShDS8IIso1lqJoZnqtIU?=
 =?iso-8859-1?Q?Lf77YFOA7+GuwsowDKJsdAX3vtuSgAPHhxpthUc+t9s3Qh87hHirHtU3o9?=
 =?iso-8859-1?Q?mzQPdss7sOgy43FdsRe5oOKSRa0vHjkEoYtmt1XF75cRPvpK++fEv3wdGP?=
 =?iso-8859-1?Q?NBHXOQmTRH3VX4u6IGnv+vGewXKMyBRgUw9qggtcNBNCKufLlbPbklkWqO?=
 =?iso-8859-1?Q?wY7rw1MddtgOWG+VeGIHblrJP2KlX9jRhAJ32A4GbyQAAtJVbGD5+ecMM4?=
 =?iso-8859-1?Q?mxxXS24mnhFxBYb2as7vAGDCdkEHwTZELX5em6yS6hlOWNWwrEQnhG/uT6?=
 =?iso-8859-1?Q?vJzsG9peRs1wfTs+ZRK6rU+P+vskGdrpuIc7iKEi8zCUnscL3mJlhSXArH?=
 =?iso-8859-1?Q?vmlJSKV6B9Kqq+9nKgatRA5zaxWTMqel7G7eKkR6r0ZhS6kNqW0Tp2YVg6?=
 =?iso-8859-1?Q?MBx9ZnYJbTFSyvcesNbcARZdomcn7mcIlSq1XUYS9A14cVSv1MbhTjSOWl?=
 =?iso-8859-1?Q?pKBj7RYhZYERHtIa7suUXIt65yRLlfcc8TD413ZHiwKblAnNpR3cWFQruv?=
 =?iso-8859-1?Q?5azmDj1yyoC3apq5lQO4shtEBunbVYe2DtXFgci1e9Hx7dAL4y0ci2OgGu?=
 =?iso-8859-1?Q?RER4w0pqSvWwBVv879dBVQQkwFioeXiSlSrwrM65HF4Ab/AKjx1U6GODdx?=
 =?iso-8859-1?Q?MU0U4BIqs6G92JX8938FCvp5YHeSVNQ50yYmfIOm8ZPvoRhvRMKb1fM7Ky?=
 =?iso-8859-1?Q?KxztiHx9RkQZBJIXANbVxLfujFC14JbGR4exFifbQDUFZTfXkya1cosIWS?=
 =?iso-8859-1?Q?liXtBx6U+9W5ge/TNGA66P2yZT0EMkzLQkC9G2imvGdDve0w1OvpnPu0tn?=
 =?iso-8859-1?Q?WOZHsng/8yuKGAg2uTraQcHPy6psL0TUiQLnncLjmKFSoKN/1pcn1s0oKw?=
 =?iso-8859-1?Q?aWEofNkVOgb23n28WpB2s21ibV0cjQX3Usw2FMWFqVHV2PDQGhpzj2XyJk?=
 =?iso-8859-1?Q?mztXjlO/93aZSg+uvVwsBCedBCI8/KDDTEJmu/LYdPTSx6dXFEJwzjGEeD?=
 =?iso-8859-1?Q?BEhfDBcMLpR1lo869Mk6+PF2f1wVeUImWl3wJTxlHhKEqwGdZbfh5rWPQO?=
 =?iso-8859-1?Q?PegxSC7r6OSs4NKiSSxDSEf3vBOP2qitcYZ4t5f4p76aqI63nQ6sgxOcDL?=
 =?iso-8859-1?Q?8s2JiHE7PtH5fINYWsQzFIt+LYk6twPbTUonSR5inHGwpjmqgGFCWlOkmO?=
 =?iso-8859-1?Q?MFyZOmgmHjIAh35any+zjaOAvt63i5nreoUWsm7Ft9Ys6Am0cnVucQi6wi?=
 =?iso-8859-1?Q?Y6N7s/+HA715s8iWsxZdzPM6KzDxfxvs0pNIir2FArN4C4iL3SoFDDwe0d?=
 =?iso-8859-1?Q?kOfmuGgjFXSaEhL+uRMtPFNSdJT90K45DB22LmsXj6Ai6y4NOmQk7Fa7Qd?=
 =?iso-8859-1?Q?c3Z6NrvW1nDl8HIkjcalaxNIUerX9LqsTv/iGVzBLDFGSjiBy1W0i0FuH3?=
 =?iso-8859-1?Q?w1tqVvRoL2kOqbhr2XVgBO4V/RDT/QyVGZqkoUxw+7o988diIRM8xNBywF?=
 =?iso-8859-1?Q?ttwfCROM6LOrV878ZQkccRhPyY9s?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	32df5701-7a21-4498-4fda-08de3f16a5c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|1800799024|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?4MPzv5vFFS59vGJEFR5IiTH1ylxXX16HXG9kzUju/XlwMC9tfkbHdx1XpK?=
 =?iso-8859-1?Q?EnVRf412r1NjhRQ8t+ZJFxnS0dn6LulOYruwlW5/IOc26jI0VZMiOYPJgZ?=
 =?iso-8859-1?Q?mpwb7bQj8rh/eZbqYBs6VRO1AZJaJanHdD4iQrOhHfqi8nSGSRXAGrdcJc?=
 =?iso-8859-1?Q?d9hakjc8kRRabPhBDhryaoMtkP+5wQSXGXVzaHwn6VEH6YuiuKZZ5hzmX6?=
 =?iso-8859-1?Q?cBqDhAEl5VJh8k8u74ZYJK+gpEAFmbDmlddNQspiDshEKQcEMxZXSbtIL3?=
 =?iso-8859-1?Q?TuDnftKwMJSJMvLlkUeJnsMRKjRsuMFYrET7rKpY3Y5n2/CD/81Oet0Akv?=
 =?iso-8859-1?Q?dSDQCSy/Qahjgpt+gZg2ct9QUDHr6M414Jp6ZFgRPRAxRUgQnZ348gHaV5?=
 =?iso-8859-1?Q?MTPH0ghWus8htZ+0C2wxEYyf4GAO8jN8oNlvuLcac/XIx3+Z+YTR+JVNEj?=
 =?iso-8859-1?Q?1iSAnKx1Ahs+k6Y1k+ht63TBKq69E/99AoCbMBc8PNI+aiesLtS8QZ4kL2?=
 =?iso-8859-1?Q?FqMa69+A/dHFJEJO7nvBlD+l++SmLRB4pKeZANN9VvYzzragkJ7r9zT7aF?=
 =?iso-8859-1?Q?fVAxLv5bAZpnAhJG1Mhk4qzGy/UDHMuvGBQttkwSpeuPRE8dZyidSC/h4N?=
 =?iso-8859-1?Q?N0rENDWBTL+J7SPXcMinIccxdFhD9Enr3JsaoZCb/0ISlhdqeR+NlJVdwg?=
 =?iso-8859-1?Q?RnTpg/wQtZMvDDEK/XlJ6y4A6veUNd6d4YpkiC5pklAMlRhssonfijdTEI?=
 =?iso-8859-1?Q?72aTMYaMOAaXhGgb+dOxAVftmUmXUd6z631AzLJQKBMRJUGOWNxR/+gMBE?=
 =?iso-8859-1?Q?ITryqCZDJysP1xd59onG7naWHGQWBwW/2MHj8jJS+w9W+PfM3Oi+xrrdQK?=
 =?iso-8859-1?Q?tv6C/x5RCWjM/YkH8iMHxjFxlIaVUejh6lCtsmk7S/uFDweTISitEb1I6i?=
 =?iso-8859-1?Q?zuPIi1R34QT0+UwX+goU1cCedDeX+l2Rzbvr5KxYWvrwLrfd3AUqTEYZVP?=
 =?iso-8859-1?Q?CBNnXKbDXW8EbkuGuEin73QwmlINsAvB6OrInTRAJul3mCrOUFnKYB//pw?=
 =?iso-8859-1?Q?8LzgP7VJ74bQdyqC/Ve+YGZq9VA8yZ5f7OcEoNLrLxNflK5Hsa1c8BV2Gg?=
 =?iso-8859-1?Q?nerhSBo8PbfbMlx6PNJnVLpDwxR2N7TN3g6Bx4uE9WtKuAj6tyFGYoDCFZ?=
 =?iso-8859-1?Q?IcZRUMdCSi3IlwmPgapTyof8C07VDrwiSFhIrTFYGoU44fg64qx24gYtp0?=
 =?iso-8859-1?Q?dy89EdWHiGtSv6quVgpgkCZgp0UdZm1sCF8zyhu4vG7cO77GNgXgNSFuh9?=
 =?iso-8859-1?Q?Z0V3By+CDmlCeq1FsFR2kv0u9h4G9FXaUU0/BDLurYGuocNClWgeX0g573?=
 =?iso-8859-1?Q?TRWake7EV5IRvfQ8o+ElQb4EtfAip0pDAQqJGlA2PV49hqX6bFYxr2WT8k?=
 =?iso-8859-1?Q?BDVXdCFKUBYYvsNxAxnS7mmzh2xfpuPTUxZXi6RC6t5QyVfJ9Iw/IGUi3U?=
 =?iso-8859-1?Q?83LASlp9zDcUV5p9lQOAtNoj41dOh1suq3A7EB2rlIe1SsOm4kC8quJYsK?=
 =?iso-8859-1?Q?hvPGEF36rt0ymTX7zz7vYLB5QRFfzDoIb0M6lLlfGRFVM9Np08KC6N6pJb?=
 =?iso-8859-1?Q?wy69rDT9vSt8o=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(1800799024)(14060799003)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:49.1762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d221fb70-ec6e-4fd3-0fa9-08de3f16cce9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7350

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's prioirity is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state - this is skipped in general operation as
it isn't required and is rather expensive. If any Enabled and Pending
PPIs are of sufficient priority to be signalled, then there are
pending PPIs. Else, there are not.  This ensures that a VPE is not
woken when it cannot actually process the pending interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 121 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   5 +-
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index cb3dd872d16a6..c7ecc4f40b1e5 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,31 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 highest_ap, priority_mask;
+
+	/*
+	 * Counting the number of trailing zeros gives the current
+	 * active priority. Explicitly use the 32-bit version here as
+	 * we have 32 priorities. 0x20 then means that there are no
+	 * active priorities.
+	 */
+	highest_ap =3D cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+	priority_mask =3D min(highest_ap, priority_mask + 1);
+
+	return priority_mask;
+}
+
 static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
 					  struct vgic_irq *irq)
 {
@@ -131,6 +156,102 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
 	}
 }
=20
+
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, reg;
+
+	/* We have 16 PPI Priority regs */
+	for (reg =3D 0; reg < 16; reg++) {
+		const unsigned long priorityr =3D cpu_if->vgic_ppi_priorityr[reg];
+
+		for (i =3D 0; i < 8; ++i) {
+			struct vgic_irq *irq;
+			u32 intid;
+			u8 priority;
+
+			priority =3D (priorityr >> (i * 8)) & 0x1f;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 8 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock, &irq->irq_lock)
+				irq->priority =3D priority;
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, reg;
+	unsigned int priority_mask;
+
+	/* If no pending bits are set, exit early */
+	if (likely(!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1]))
+		return false;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/* If the combined priority mask is 0, nothing can be signalled! */
+	if (!priority_mask)
+		return false;
+
+	/* The shadow priority is only updated on demand, sync it across first */
+	vgic_v5_sync_ppi_priorities(vcpu);
+
+	for (reg =3D 0; reg < 2; reg++) {
+		unsigned long possible_bits;
+		const unsigned long enabler =3D cpu_if->vgic_ich_ppi_enabler_exit[reg];
+		const unsigned long pendr =3D cpu_if->vgic_ppi_pendr_exit[reg];
+		bool has_pending =3D false;
+
+		/* Check all interrupts that are enabled and pending */
+		possible_bits =3D enabler & pendr;
+
+		/*
+		 * Optimisation: pending and enabled with no active priorities
+		 */
+		if (possible_bits && priority_mask > 0x1f)
+			return true;
+
+		for_each_set_bit(i, &possible_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock, &irq->irq_lock) {
+				/*
+				 * We know that the interrupt is
+				 * enabled and pending, so only check
+				 * the priority.
+				 */
+				if (irq->priority <=3D priority_mask)
+					has_pending =3D true;
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+
+			if (has_pending)
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index cb5d43b34462b..dfec6ed7936ed 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1180,9 +1180,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (!vcpu->kvm->arch.vgic.enabled)
+	if (!vcpu->kvm->arch.vgic.enabled && !vgic_is_v5(vcpu->kvm))
 		return false;
=20
+	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		return vgic_v5_has_pending_ppi(vcpu);
+
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
 		return true;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 978d7f8426361..65c031da83e78 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -388,6 +388,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1

