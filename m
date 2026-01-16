Return-Path: <kvm+bounces-68377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4076D38451
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1C36315B2D5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723FD346FAD;
	Fri, 16 Jan 2026 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TK2XgHmF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TK2XgHmF"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011059.outbound.protection.outlook.com [40.107.130.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F53A0B3F
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588090; cv=fail; b=dfPBgfkACKgd2js3jTSGFXNAvTOahHbh7NzfFJ4wqWuMo2vbRkFDWnkqtl9sJQeawEwCPUf55VknkHfKXc4VEhbm+d3KlJJR0hJzYYlIOIPvkWSbWHJMppcgoBloOpRDOfABOZdYJ6n+ajHHVxa2bPDyR5u2FKlLOzDwzUuf8Ic=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588090; c=relaxed/simple;
	bh=ThWkPV4AO7UEnuB/VkUz0Rl9mFlMdhvydOs4PhGJM8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lsjOkMqKS8lU/ToOxV33hDmK0JetLPZaqWIYk2Tda+IJSgWuuxf8pw6fV9BKdnd+g2L8LdRPAbGaRg3rHCu//l+M3KFnNecB8MA4bE6Wl6WyxRZWThS7bCI3/rVNnNbwtDj+kq4melqCV7KasNIyAi7w9BI5v8032dqhKLbEdlI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TK2XgHmF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TK2XgHmF; arc=fail smtp.client-ip=40.107.130.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BqDL2XIzzRxPj9m2699rj1Fz+Q5SD49R5Hfn53UhRZVyl/H8InoSG7nSSuWx/418uCcqtK6GCnnxBj7WEzxPLnB4iSc21GY4mqQY/Ta4xQAokMKDXjbLtGq6+f5rrOt8Tdjts6nRhmLTX8cymedXQ95Vo8XwMcp6T/hZSWPUB07nKuWc+l6fc1KYeRgD6RCfUPUvcs0g5x0idc22cz8xhYV+EC9oQyGGeT7MBPld1oC7d+TaRAJQKr7D5fCXFA11iXHRpJP5HY5mtpaMYvvMdKbaZWfE/jff6FhL0GCSC7cZAMZ6v1+OKCOmbfDs4aS/RMVdworngOi45Z9btCOMjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=A71IZSEA0pxm5nMhQRanxpETzR5rhsss+2Q3YOJQDpPliSohzRyWV6lix4OUZi8G+xqn084d7IXIkO5H4qRe894BojEpePCqfzDSH4Lrlv/GjAvXukWaqYBWIy71McCmNNECVRgLgXd3VYgezPqVovVIaaS/LQp0psgrDqOZ/yxDQg4yUV4nTbbqEMJ9rPyibBfBm3FUnx7Qq8EtXkMw4RBA50DT3ieBzkpjhMvP26eBrSeEYSYmpswPXtGkoJlNlo49JXN2zkCmViimQG1XTaxqEFGy5YsYFS2FUZj7cThRV3mqF7SOT6iRE5lxmU0eGGtC9MDphz7e/uGMx8mcHg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=TK2XgHmF8ZDZfeYryrrd6YhDb/tCY7aU99cZo8SJ9zMmlov/CYS6CXJyYYanhOJfNKITXDnynrbQL8Nk6t8YadG7OkyttnjqLIb1g1R+aceDhjWg1RH39cB6rGB5rCDXN+I7qIqfTGyWur+r2+kGG0yOCQDrZJpmasn7ndCAQiI=
Received: from DU2PR04CA0217.eurprd04.prod.outlook.com (2603:10a6:10:2b1::12)
 by DBBPR08MB6186.eurprd08.prod.outlook.com (2603:10a6:10:204::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:28:05 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::48) by DU2PR04CA0217.outlook.office365.com
 (2603:10a6:10:2b1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:28:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sLOr8MfiNvZe1VsHDIDwQnQy4GQhsOmXQyECEUBsFup5fPVDKm0kgzj1CScEkXD+zaDBgupVIqHWm7owXMg9G0dYhgM385CjermtFJ55FNGzr0i43YEMtBVR/t1GvfE4dOffh8XZGugeSVcA4tPYaYIAaHZlIP4vsvWebBvQaOkL1xmaaNAMVx18Wtc+olCpUYPYquxvdqMGAoO418OK5eZ/S2azFDeB4Zap28JDMYxc7Sk8ajYgJIxx0Non+3La2pjyaXep+zmiFE0Tnoj24L2t1TorhOjWKa7ZrY6QnXAaKOzhz+cbxNs+/A9VMX4Fn9/GWgXdz1k9H2FULO3HCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=djNET/3j2liKXeIzFVwmJQgZnY+KkjLuNlXvSDhyhwLqisXoPzXfyPSt0xwYvAQ8Bspkc2u0ra1f2uZu1pzuk5ICIxvS+MNEp1RDVp9HWbS0iJd9Ap59V6CYH3cmeiHAB4UoUSIRV1SLtSczl6WBj8DyY4o3PXNcvGJL4UMHchR1y5VgmrEPsT6+Fdpk8+pCG71Hri27Lp1s4FxCgQtnMZSfgzaEXBLG/qyrKWckyMRLmYvPRKKgOi1vG1kaoJuxHwXHyWrpuJONziYWPyYvxuPbgzm25LN56ZZ09zEtnm8FX3FXdibMGUE18SCWZG5TqbBIUUj4yFEU75hc0hThbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=TK2XgHmF8ZDZfeYryrrd6YhDb/tCY7aU99cZo8SJ9zMmlov/CYS6CXJyYYanhOJfNKITXDnynrbQL8Nk6t8YadG7OkyttnjqLIb1g1R+aceDhjWg1RH39cB6rGB5rCDXN+I7qIqfTGyWur+r2+kGG0yOCQDrZJpmasn7ndCAQiI=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:02 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 10/17] Sync kernel headers with v6.19-rc5 for GICv5
 IRS and ITS support in KVM
Thread-Topic: [PATCH kvmtool v2 10/17] Sync kernel headers with v6.19-rc5 for
 GICv5 IRS and ITS support in KVM
Thread-Index: AQHchxW1roMllt3PUkmu/NDEDjkYog==
Date: Fri, 16 Jan 2026 18:27:02 +0000
Message-ID: <20260116182606.61856-11-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|DU2PEPF00028D0F:EE_|DBBPR08MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: cfe5b8a0-9ea8-4091-4d08-08de552cfd58
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?PD2lCnv6ZDpURdGWq2txPbIdTQgbHN3+YKfHxigz2/LSz50DGTQPkm9gTl?=
 =?iso-8859-1?Q?VnVwILmFKGr3qPx/K2NO52juPRYSU7IhuEdbOaJh8iQhttrqsP2d9Wj1KX?=
 =?iso-8859-1?Q?BHcBtgKdSYoTB+JQAV3YEDpC3cnPQYyJDChFi3pa24Sbl9csHbRO8GhrlD?=
 =?iso-8859-1?Q?Gds1ylvUpi9EMyx1PKww+35qgSoJfpUD2Q1z2uPn3M0xKHeT2t9sXLsCUX?=
 =?iso-8859-1?Q?7/nwhPUENhUeksQiJbJKUf6XodXwqKnUv/bhmHokVwkg+As64t+9aF9osB?=
 =?iso-8859-1?Q?BXgwQoYND81UanWOoG7V2UBkTHLZNlQYcocHoz4G+X9to8UI9y+w2Byx+n?=
 =?iso-8859-1?Q?ajkDXjtYBela2Pq7ehSxxfidvTd6zkg6EAMNs7347SxlCCAd7qts/W0I8R?=
 =?iso-8859-1?Q?wyjEAaXTX7vAFx5jyfYE8eDVMylabatllQTUf8AkWlJFO+Bchcaq312NYB?=
 =?iso-8859-1?Q?R08hmgcVv+B3lF8P0QkHsdTx91q2rVqDeEoDyJtonFR7vFGNIwUOLzVLpT?=
 =?iso-8859-1?Q?LaqUmF8OhRqpYpvvT8mHreHmZvJshXeoL/F0KXAsy3RBeb92vF+B9jaTXH?=
 =?iso-8859-1?Q?awfP0hAspan3LE6l/R6h9A+lKsPorm2cM1xWv7PRxALsbFIVYMsUvSoZMt?=
 =?iso-8859-1?Q?0b5qMJg5UFoSTT8qqSyAINhb/8aF0RePG0CNOy9q9Un82BDbgybEfWCv3V?=
 =?iso-8859-1?Q?9sEHs2xY5R1qXgXzy4osMFJW+gPI2jE2qFuYAWcZThyMBLQL10jH3b91PB?=
 =?iso-8859-1?Q?0JN1Ono4W3SU7E1yY1osEUdCdjzgVQYeSOBvahfMnC5iV1QP+Gu0zpeTHC?=
 =?iso-8859-1?Q?2qRYdui+0Wn3e/XzXZwDUZXy8PTaF+J5NZJrVwqM3/eCR607XG8VazoqHg?=
 =?iso-8859-1?Q?Lp2xCUdRsfhQS4Dg1EyxVCwCNwWA7UKsVVmQF2aGEdNyPepXzoaeWQpYSd?=
 =?iso-8859-1?Q?vINYRhcNjCPMVZvkQ9ekwEKAHwjXFEtZxD6xn0l2ypP/onIqo+aThRdB+B?=
 =?iso-8859-1?Q?XmypEGwGbML0OrSfGBt+vMRQY3zLOd6b0fYyjaOile89mk9QosDrwhpUPi?=
 =?iso-8859-1?Q?5IaWzQ/tSOsf/utjjnuFPpuvZxgJ9xxDs697lkTFaxywYeubsENruH228T?=
 =?iso-8859-1?Q?OFqsI8aaRk4D5nHvCwvs/+nw9IYzugNu1sfj3TarHEMqUnRH5lvba1Ca4D?=
 =?iso-8859-1?Q?3AzXiGMf1l8n6r1NB0joAxrtvqxKPWziIP962IuBU1IxkY8srTaTP/tTbq?=
 =?iso-8859-1?Q?jCGWmvR/O7CYrCQxj5cciTyQVBzM5ns4qj5TviMGdWHqzX3dSfJrRaayib?=
 =?iso-8859-1?Q?+hQ7SLr7C/UnM9GTmupQr5fpCWCzrJW8817iFi9mtgx06YAgIA+Nnrl0Gi?=
 =?iso-8859-1?Q?z8KOkPf7J5HMUpWwHA4TKdEBbXndvRybTY8ko8Ud1qPabjimG/09uCd3Pg?=
 =?iso-8859-1?Q?zmz1VgyHjZbZ6U4bp+IAL+Uaz/CXgYeDTE+f5AoAQoKgd28eT3PBvLn9XW?=
 =?iso-8859-1?Q?5Qm/J86BPa1/o5Uj+BWUyaA/GmIILId1tIr7rj+Mc0eshAo6keQmfNwKL8?=
 =?iso-8859-1?Q?hgORbJ3JZ4ngb9DDx9Frd47FuLxVCn3zaPbBrpu7CL+O3WtVouaqs6WaKG?=
 =?iso-8859-1?Q?ojziob5DCJ0Sh/GQkKvH2Xg6A5pXBYwtZVvZt72WieAi93gR6NxqpC7fEX?=
 =?iso-8859-1?Q?3KcIBP32ZTKGWx2yd2g=3D?=
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
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4387c333-59ac-4068-ebc8-08de552cd7d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?7m3mUGmOWg5UQyrcvPCL+BTWWVU0Zfq6xA2Hmkz3TvE9d3m6adonJe4OhE?=
 =?iso-8859-1?Q?SQYPHLyYnOWAjyshKLV6pXA572ylAUT18VorCI1RKuW0hgA7YsryIzAN09?=
 =?iso-8859-1?Q?MNCqPDpzOVo+fQVknAuPkzfC5Bz3Vr6tLx0PrH7QZZinLpnSHn9QQL6bbm?=
 =?iso-8859-1?Q?fevNda/Uj+aZnG3YzvPcNGNL860xIEMD2DhDnOvRy0R5/uPBz/+xa3y9ZL?=
 =?iso-8859-1?Q?p+QPVq2iqtfSVwjEdtjha1ssSGS2OdbF/LaGdBN21VCcYnRd6sDqNJJhqa?=
 =?iso-8859-1?Q?dpAwq1LrUmteSI3y302wbZIyIiHt5UBVdlzpdH0IDHic6DDL3ilFdBEivk?=
 =?iso-8859-1?Q?5kXJF7WTnoCM9V7HZegDEakFQX2esnpjtRxFFLfmXmRW1hrKspfy/vKEsn?=
 =?iso-8859-1?Q?gBQc2y2ejCMKvEBfNRdPgEYEYBa9+sBxRGaxqVkLQJ0ZSm2vA7XYMtudN7?=
 =?iso-8859-1?Q?8xKp/BlJWKXg2njOYTRpG1pLCUWaLTiyWd6o1Pewve1vRNloXNxZllkJUq?=
 =?iso-8859-1?Q?Fgw3B0cht/J09UaAfEVbH+YY1OhW8oB27e+oAHxlQNKPZHn4AMvBYGsg7G?=
 =?iso-8859-1?Q?Tn0SulmTF3Ji5o0wcnIIYymWDstEeRkPMZhOiWkiNVSWUCPv4FMjBfHjFD?=
 =?iso-8859-1?Q?6O21h5txQf6yxzH1fn7jX8zEExDJ7EWLbUxq6OSO/gDVFngz9KDenmY9JP?=
 =?iso-8859-1?Q?vJci1g/JRen4rmhAtO614CBWsDOv/dnzIYOaApUpGStEUZ6RdvgBnGnup1?=
 =?iso-8859-1?Q?8pQtSDIbFDm/uokN2Tw/VmHxE5w2OSQXTpJaSfFaAIlh9XUHpdiV7In/CC?=
 =?iso-8859-1?Q?R9CddQkrFcZ4w3Gxye5MDDozrzhJ7WROJ8qBC+fKtXrozAGKpRSdIpC5Gu?=
 =?iso-8859-1?Q?fpm6cAEGuXNanO2dn9Dg8/Uh72PEBm8mORKTZq8uArZMxVGD8oUWXpOvas?=
 =?iso-8859-1?Q?CW5L+asmNFSYPcj5IUkQCoKxMTX8GKOoO9LmfCs1HrVE4E4KEpJf6X6gyj?=
 =?iso-8859-1?Q?rweAcMNLtEwVuYnt/KAhr4xf29f5OlUxdcgaWwMFxkRQ3YrBCxd9gmzrC/?=
 =?iso-8859-1?Q?fV1vl7n9+TUTBodi9iEA2oadvQA9Io3PPH+whNDihOETd7Ydk37vICA6+q?=
 =?iso-8859-1?Q?p4+m9Zx4XM950x8wC1qqGvM1ntiRFx64vorzZcWq7c1a/LxD0vLBsiiz0I?=
 =?iso-8859-1?Q?a6v/ZNj1rI2BXjVq38y//rkuNGdZuMV5TE0sAco/3tppx7qZEdrZsJuAjh?=
 =?iso-8859-1?Q?4oC5V0Ncq/r5sCFQ783QhmFVpBck7uk0LccK5KUxCLuCGgYn8PHnIrMIKH?=
 =?iso-8859-1?Q?s2BrHxHDXTkrTBXLTdFa2LBGfyl8i69CxuaW3pOw5Qw0cy2SfTmmrzfUSk?=
 =?iso-8859-1?Q?var/WQv3icLCT7a3gLdlOnApkRTzvqRraBkq0T8zBjmmoT8ilIamxA8s1S?=
 =?iso-8859-1?Q?cCrcbh1s0n24fvJPP7MVp5GJAvRE7Jsecn5+4Cd5bLcoUA53Cf8Sd3wPl7?=
 =?iso-8859-1?Q?vdVbMY0/DLwSSaxHuUjcGHRkPCvN87PGp/SVZ9a3Qh+rk83r1e47pbvfPv?=
 =?iso-8859-1?Q?X23Lu1fN2ydRShf72OTfwM9NgE9UcvsC/aHZ0WHD+1Vc9udRNvQZBGXxvD?=
 =?iso-8859-1?Q?0FLyy8BZDkwpmIiy8slgwageORYj/v3Vl3ycIt7weXUTvMzvuoDKq3H42d?=
 =?iso-8859-1?Q?gW+jxmUH1+cXdciWMD+WImsSkY1+lVzeRx1tB9zI5RxKSLPuDN9utj3Cq+?=
 =?iso-8859-1?Q?65hw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:04.9514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe5b8a0-9ea8-4091-4d08-08de552cfd58
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6186

Add in the additional changes required to run GICv5 VMs with IRS and
ITS support.

For the IRS, this adds the ability to set the address of the IRS and
do save/restore operations for the MMIO regs and ISTs.

For the ITS, it allows the ITS device to be created, the base address
to be set, and again for save/restore of the MMIO regions to take
place.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h | 9 +++++++++
 include/linux/kvm.h     | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 1c13bfa2..6572514b 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -97,6 +97,13 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+#define KVM_VGIC_V5_ADDR_TYPE_ITS	7
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V5_ITS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
@@ -422,6 +429,8 @@ enum {
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
=20
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f7dabbf1..14292051 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1210,7 +1210,9 @@ enum kvm_device_type {
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
-#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+#define KVM_DEV_TYPE_ARM_VGIC_V5 	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS KVM_DEV_TYPE_ARM_VGIC_V5_ITS
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

