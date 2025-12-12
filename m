Return-Path: <kvm+bounces-65848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BC587CB918C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2EEBE3014BC0
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B360831B81B;
	Fri, 12 Dec 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OMxdSzLk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OMxdSzLk"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013054.outbound.protection.outlook.com [52.101.72.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FB230EF92
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553028; cv=fail; b=Cpx7JqLHo5xduPESsJU2OYY++sX5XGwhWQwnVjcks+2VoEaJg5w0AdNFte1uNWJFXc86w6o6nUiXiRRxOg7SPLda6eJGcjRZYmy1pZnms6VZta+TvXnMEn/WPGUp/4SSWY5T5xByPREuxeSkKzsSWYNuZlfQV8mfuWWZ9n4VYpc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553028; c=relaxed/simple;
	bh=C8TlmCVv0+b+JxsVSbQqJL01vqbFM7S1Q/FR5Fq2kxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k9HVrBDhIXRXvwQhhHEiZJ5lhMfQ5WP3bWJjW0DW7WMwqERy+iNG2wCNH4sjaHRkzBrKIbZGi7iwVHaGV+rjmO98OzI1WjdIh7m9G7gvQ3W2UdZ3ShFC/Fa5pQ02fN1z69AtzY4/xYAJjj1caA5OYEVirTHOUgCkNWayqygWqDk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OMxdSzLk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OMxdSzLk; arc=fail smtp.client-ip=52.101.72.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GWYBjdA7/kNVoUoEDj4qDx27Ib3v2jr7DAI3LZqaAZ/ftWoESDz/LhuKiE4X2sj1oL87JIRIwj3QrVT9wwFjh3iyNMCHtw32A7hnGEVQiFUw6NvDADuprB+ZOnnCRC4eXrdgAnkacU3Ljl65q83xO3+n1tdccemll/4qCnB/EdogN8IZ339yKXThU8+W8HaTmiinMYxadiBgkdJAbNm/pZwxWnn1C7Mw21I+UPgPjK5IfMLKsisTdQXu0QwZKWMT/RaI60VGtMJRDIfTXKCRlfeiJz+Rsg9ggN8In0npCmoqKHR9GqzomXrYQvoByB+Vye2896Ck8T6Cb/dPU0mGJQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d179Z+yBnyuExV+EA0Ne8N4wXUECov8yPyImZPoBcRM=;
 b=e4dgtqUxtMaLU7eqWT1ny3eailOKKTVpATm9hH3jN4A6X9elRXUZMkRyGSNjH2cKqKxzdXfE1BVcPmVQWgnoViyimBz3M8t2oFbAdmtHTBFl0/Yfgc/O1BVlg+gInJFfzuAPI+ydVe298UArGX4PVlDmGPfV9j8wQm4Pjff5mArY2ytAPiubuu6JEJ49vk2F+in8ZVh3e8BL4naQ5iJBbK66lOj4s16i8445JIE88dD9aOu1uzCgXzCpuj1jUzNAQUhcsUYcyJaACYT7xUJH7X3KYdm3v03MgYpKOwzS+S9CtplnakvFcnJDP99vscE4QBBdohu0ObE7t7XjhNueVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d179Z+yBnyuExV+EA0Ne8N4wXUECov8yPyImZPoBcRM=;
 b=OMxdSzLk2UKpfVKZnIePscsZKuVufJ73DdYGhaaT3FA8r2WXB05K1UfGVS1EIDxrgOKRN14lguFFg/R+zoAgOry1TfNEZuXxgyuZojHixQpU64XL4mFXPhDn31hzSJCCfIUMGMTEv2HWE9y2hOFkTPEi7xKiaFGnPf2xX2DPgns=
Received: from DU2P251CA0007.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::9) by
 DU0PR08MB8162.eurprd08.prod.outlook.com (2603:10a6:10:3ed::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.8; Fri, 12 Dec 2025 15:23:41 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::11) by DU2P251CA0007.outlook.office365.com
 (2603:10a6:10:230::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMVlWZYXK4+wQlyAXWGNZ/I78PksG0VUmZxQT2xoPL6LZz6HSVOkoCh7ptFvUvBlJIHQ5Uvhnc4WSpBFEll/StZ8CbhNnhg8DNIvFNxD0AW9q7O80cYYRiDvhxM+JwtI/iCvkWfHM6SJ47qdzZkj9nZ3HXQWmAnk6SWo/x6hoM66kc0Xr5LApNdPL2WCegpBpCT2fZw+KIRkqVzRhTkrjG20mYiI0iqAaM2ddNX/qT3ExX/HAi7JSvIa8+u9pYWLmGAGx0oaNnnA2JdMc6CAz2VjlZGR522fFobomlz2OolcZk02B4G4nrKNigtVjgoA+6C0wglm5EyCXOCu8i75Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d179Z+yBnyuExV+EA0Ne8N4wXUECov8yPyImZPoBcRM=;
 b=F1u1qZdq7D+qm0E1fyjPArMi8remOW6uxngyf8mlMapyTJD3ftKvkIJGHHkDefG0l4UeyHsmgxjajKbmZ1KFRVTNWfMorMaDizPsuDO1t8hXOaxkEpXTtnaTOHSzgxn7ubsp+wxx8aT9doss9OSnKvfN2svBBS5vM0RhpNC2blIFK0nLCGP08XoGS4bnR2DCvSe+Wci9n7t/37tp/19R/qdBbgptgXCK5nW9mqZhYVEbX4Y+T7yNn0xSbBfqFeTIjh8frUnOTKVhq8Ex/uH9MbCZHxxpQCE8/6+dzwDtF6d0Qs57pxGK9r9yFO6+K88uj+QPO1UArUY6FRUgoZFkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d179Z+yBnyuExV+EA0Ne8N4wXUECov8yPyImZPoBcRM=;
 b=OMxdSzLk2UKpfVKZnIePscsZKuVufJ73DdYGhaaT3FA8r2WXB05K1UfGVS1EIDxrgOKRN14lguFFg/R+zoAgOry1TfNEZuXxgyuZojHixQpU64XL4mFXPhDn31hzSJCCfIUMGMTEv2HWE9y2hOFkTPEi7xKiaFGnPf2xX2DPgns=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:38 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:38 +0000
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
Subject: [PATCH 08/32] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH 08/32] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHca3smZKPKwXa5tE+9vldB7S5h1A==
Date: Fri, 12 Dec 2025 15:22:37 +0000
Message-ID: <20251212152215.675767-9-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB5PEPF00014B90:EE_|DU0PR08MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 850b94a7-7644-475e-2e8b-08de39926e06
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?OhIRH2wJVAy2xp5NXr8aBuHFa/MbCUpyLSIWlEWCzx/hXe4mo//anpcGch?=
 =?iso-8859-1?Q?QsKkEkjyxkA/zOXOXFBcMSPh7Lgr38LKxwMPcJlr6wseiJhPqY3oeEovwy?=
 =?iso-8859-1?Q?GXhA/Fb64DR5oK4lpPTEcq5EutN81fhCPU5j2cdlYD9MBOuByz5LxzU58D?=
 =?iso-8859-1?Q?uRK9+vgk31PBh8jSlWo7Ha0w4uHtdrpdfhpxFZFJjtDBMxVv/fi3cNOfVu?=
 =?iso-8859-1?Q?CZ2Pbkfwi9vRcVF2a3+uOPeyhaZI1Bwrm3oU7W2gtJq+fJLT25nwik0wZT?=
 =?iso-8859-1?Q?w23dUDnU+WZrkNFT1nQuy5RdLDD7Xz1VpCeyqLq8/C2F1mE0PckkI6dAGb?=
 =?iso-8859-1?Q?TAfDDxmoorxsZDAqchTj8EcdSahgEhx3LKHZDP4pH72kispIP4SEWmCPuf?=
 =?iso-8859-1?Q?pmcfbXp0cHSamN/H2i7d38/JkYqfgcdImdr6aUYreRjmTg5Txz2P4HtnvE?=
 =?iso-8859-1?Q?MtQYHaeyqobR8iii2YUGUMFl+MkLacv5xeW/T1KDaWMtlTKdQVkaJEz4fm?=
 =?iso-8859-1?Q?SmVxLPzcYXgq5qKj8va05Mj7shb0JoZ2IBj+fQSoF1XhD/jZo9Y64o6IQ0?=
 =?iso-8859-1?Q?BhW3+FNgxRnD0aU9CcBmAwDS2Ia+QMmtq/Fqai6ec2jqi7dAqn487nC4OS?=
 =?iso-8859-1?Q?t5J9fa8mSgEkOX9aRmZ9ck6bD/TyWzwGkyGWjIloTn90I70bItX8x0dA04?=
 =?iso-8859-1?Q?jvOg/CHGtwuCm2Esl29/PIIY3lfiklWbcDEDjaG3sNS7SEmENqD54C48/G?=
 =?iso-8859-1?Q?si9ZWfAD0BwQa0juB5xgeGZr99R27RLzM31yQU+/f57vrVNnCg4PQWEl7Q?=
 =?iso-8859-1?Q?/4WgBwc1sZixkvlZ5ZlWuL2ybBKXXCpz2j4R+qSeIhMN9aqECwCIcdCjhL?=
 =?iso-8859-1?Q?0yDbw0DQUj5KjMqU/utVMA7+QOhW6WgyOjPeT/d8R2JbvD5k8YcT7TinVu?=
 =?iso-8859-1?Q?UxauKK/1pHx5W71mDnbXQpapUgYcNVDxEEnTqx18QFNUG+EiufGNjnvESX?=
 =?iso-8859-1?Q?4Axnp/tFyjmldnWwtCF+oLkY40CeJ4lNSYsutxY6ZWqyXxFvvqstza5dHs?=
 =?iso-8859-1?Q?asMgqyjXCVzz7+k3fHKWXIdmEV3IGQzu/6iJ6Oi04FMGCZM15QffCBnDzi?=
 =?iso-8859-1?Q?K/3pCE02xby4EqPs+WailegvsPMRW6g5D+PeuwOt5dmqgBWc1A4iysu1Ds?=
 =?iso-8859-1?Q?DszDppuVjkFsSIOtptLU2ItkAenQ7jg0P9TFcdf/aQytWVlUdOiuPiDb34?=
 =?iso-8859-1?Q?Va3dT0D9pJ8f9coKAgarxSFwcNZaUJwkvu5CDO5kwN4K3acPtUDdj9T9Nx?=
 =?iso-8859-1?Q?atGb/PgCglIfC9VHuzIXvYCfv3CQXLO9CHsvwd3mKOTjPCrXQl8ECglp78?=
 =?iso-8859-1?Q?8VTGABHfgDkFxGwVgLJuundwrOUB5nhvHzbfsfKnGWfyRm2pC3JoJaOTGr?=
 =?iso-8859-1?Q?HT1mZCJtxWPraQVtSSB6aMfipoPe6WBqaRvNjMvTalfGNDRMIeUrGn56wO?=
 =?iso-8859-1?Q?9j2oMln7IY3VZPZrGTxeeSS7YyXuSnYca5xbnpCUd7nQWnavmAWw/hf+2V?=
 =?iso-8859-1?Q?ycnhv/jxMDDLe7Q6sUnXupHaLh0N?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1f8ddd8-5527-4bef-8107-08de399248bd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?16ZZ7PaRiOlfi/VpsKsSp5bJt1Emy/ShRiQuNK3Xdzp5jeyJ5/fYR3ZHV7?=
 =?iso-8859-1?Q?imBogYoV3VQ5+0s9GjEXBnCCvwrkpaESZow67htC3kbeicFPEPtoAQOmFx?=
 =?iso-8859-1?Q?kNyHZBVdgANOztbsjj5UyyQum13ydiEqWGxrCN8oLyvJV1bQUhzT3nNgKn?=
 =?iso-8859-1?Q?AwaedhIfoGs7GFbsivk0THq2YRIq4YQr58glBcJMLaPJ62JHE456ZMW0dY?=
 =?iso-8859-1?Q?uQtQ+7iSjYDJn0zLcgD5oXVgNOwrqVaQIqR9teKW/dt3/ImrzjJbWC6UhQ?=
 =?iso-8859-1?Q?SJqSAI6Ua1U/fJFjdVM7ppoaY5dmDqy6yvhTAXlqGA8rKyC5+ee40yy1FZ?=
 =?iso-8859-1?Q?/zHWkCUKChxZMu0IJxBWcr1TMaSKVXkiFx9GHLP7keGAVsHlQLridN0uvt?=
 =?iso-8859-1?Q?JF13BZsMttnpxK8/PZmzEC+0SHQZjGLu8pKtkMvSfKjHYxaEIwxSjKJlqz?=
 =?iso-8859-1?Q?ZkdBN0PvvRV0koQYePvFYnD6dBA3O+A+MxP7X41FQLYHFQ5VazwPTiiXW7?=
 =?iso-8859-1?Q?XEMmUzOjQ7DnrcQI8Hwx4yHPXQiATx2ZPucL9XTPJ+uJotXDzY339vZgwB?=
 =?iso-8859-1?Q?UNFwQ7W3h5IX243PIHRxBqVDsUDq6cxGx23exedoGfZywoAs8lc3MTfdNR?=
 =?iso-8859-1?Q?34CT2utYMSRo8szi/zpEWTkBvGCIZNWOHAetY3GxdpvyBbNMM49kGKasV3?=
 =?iso-8859-1?Q?C/6ukiPz/Yws7OGWhfUDf1j8wLxX+nJH/utCYRtIvKSMgjxxt4E6sH3rL1?=
 =?iso-8859-1?Q?zGLPMkGB2YkBUTuR0RhmWDVKkHI+654zxn/uGhBU2QKkOK3igDDsYfKAYn?=
 =?iso-8859-1?Q?TcVSzh8rLLaYJfm0WIUlS1ad1E2REj/UNUGdB7Eyx/zrpGaT6PDcb5dRx0?=
 =?iso-8859-1?Q?UgH5icW6BZCXStETbRsFMX6GVHXNaCr77/sxoPqKxXZ6Hu07FJ0JrPnEOf?=
 =?iso-8859-1?Q?ifFxqfftGqz9A1WPl3u1oNBM4vGDuev+C2jGAMFkg5mxzwW5pcGgmYNrVd?=
 =?iso-8859-1?Q?JVNMXv8jWfmOA+AYXKUZXMt3LaHP/MRGGarik8jysgAFIp/GBZgfNABc/1?=
 =?iso-8859-1?Q?xQscMb/X1tGtKXMIpVUqaXxm9/Sy/jqu1lVBp3/U0QGSG6B2jdk13Uwuv5?=
 =?iso-8859-1?Q?kx8cyv4EtTQsJwPgYiT/Op11TvbX/ec8HgJXI8zkrF14Oc7LTkoWSbn31i?=
 =?iso-8859-1?Q?lo2cmPnLmtcN6pq/mgVxzV9O5YxzN8yyJREAGn7vxFgpN6rK3rdw365CL0?=
 =?iso-8859-1?Q?JCqOuKgPUVytoUXflkBwAJ4CRnLotFmto9qPwVU0FawBYurglHVObBUPhA?=
 =?iso-8859-1?Q?MCNUl2wVFgtL1DlSM9w7vuQ+d7/hGFYzj8g5bAxSCEDVbMGAfYFX4omz9L?=
 =?iso-8859-1?Q?+daDHKOFbmFjQMTTu5ykBteJl82rxp8prjvweUTW1btCOGulMywfeenqvF?=
 =?iso-8859-1?Q?9HNXEK7933uk4mBJZPO2066lSdd9QL6BB/r6nsaG4O1qsLLHp6wEMZPpHR?=
 =?iso-8859-1?Q?Q0FuAzu7wQ1OMSLWtH3pwKftf3EnWe+MwJiEkmhSDS3ShHCOAfcTKjZEzb?=
 =?iso-8859-1?Q?mJbDp5yUZ2jBAcrru7uaCF7cX8waSWWRZKpCZryKwDI2g4w0RfGhI9mbSJ?=
 =?iso-8859-1?Q?/bEqXWYdZP40g=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:40.6016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850b94a7-7644-475e-2e8b-08de39926e06
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8162

Set the guest's view of the GCIE field to IMP when running a GICv5 VM,
NI otherwise. Reject any writes to the register that try to do
anything but set GCIE to IMP when running a GICv5 VM.

As part of this change, we also introduce vgic_is_v5(kvm), in order to
check if the guest is a GICv5-native VM. We're also required to extend
vgic_is_v3_compat to check for the actual vgic_model. This has one
potential issue - if any of the vgic_is_v* checks are used prior to
setting the vgic_model (that is, before kvm_vgic_create) then
vgic_model will be set to 0, which can result in a false-positive.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c  | 39 ++++++++++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h | 15 ++++++++++++++-
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a13..a065f8939bc8f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2024,6 +2022,20 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+		(kvm_has_mte(vcpu->kvm) ?
+			ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY : 0);
+
+	if (vgic_is_v5(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_GCIE_MASK;
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+	}
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2221,6 +2233,16 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	if (vgic_is_v5(vcpu->kvm) &&
+	    FIELD_GET(ID_AA64PFR2_EL1_GCIE_MASK, user_val) !=3D ID_AA64PFR2_EL1_G=
CIE_IMP)
+		return -EINVAL;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3202,10 +3224,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc29..bf5bae023751b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -455,8 +455,16 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
 static inline bool vgic_is_v3_compat(struct kvm *kvm)
 {
+	/*
+	 * We need to be careful here. This could be called early,
+	 * which means that there is no vgic_model set. For the time
+	 * being, fall back to assuming that we're trying run a legacy
+	 * VM in that case, which keeps existing software happy. Long
+	 * term, this will need to be revisited a little.
+	 */
 	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
-		kvm_vgic_global_state.has_gcie_v3_compat;
+		kvm_vgic_global_state.has_gcie_v3_compat &&
+		kvm->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_ARM_VGIC_V5;
 }
=20
 static inline bool vgic_is_v3(struct kvm *kvm)
@@ -464,6 +472,11 @@ static inline bool vgic_is_v3(struct kvm *kvm)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
 }
=20
+static inline bool vgic_is_v5(struct kvm *kvm)
+{
+	return kvm_vgic_global_state.type =3D=3D VGIC_V5 && !vgic_is_v3_compat(kv=
m);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1

