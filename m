Return-Path: <kvm+bounces-56086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33570B39AD9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AF8E4671ED
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6E230FC04;
	Thu, 28 Aug 2025 11:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dY387rlG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dY387rlG"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010049.outbound.protection.outlook.com [52.101.84.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFE30F7E7;
	Thu, 28 Aug 2025 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378827; cv=fail; b=V0TMwbLD0/b0jt1y5mtkOe0q/MB/NowHl5fvhkinDDGBG3UK8HcBRH1DZ4cpobrVEpbbvOVWl48pKCOCvKEoIZkAjVobOZhyioiwqdG7Y6aN1VlP9oJ3eb/epR/UjEyullrxtusLkERVdrnQsKCoeVjGScnWwduohi9dxUPgOQY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378827; c=relaxed/simple;
	bh=DKV8tG1a04JOVnylCEBEE6WK4spxHGnvMyX+81TvekM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eGwtGQcKKLEYZ0u+ZrO0AIhQf62pRiuvNTrXrCJzFLdUW3h6Ag5JiLuA+hziwy5gUAZ+mDJAUnpxo/WKPEU8th0Y1yo3adOhpM2wyUpY/HjgGl5DdSFEELWHwpquGaRl+uTRfVjA/6gP1TXiMxkvZv8oJUtoHexVHmM35KmMSsk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dY387rlG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dY387rlG; arc=fail smtp.client-ip=52.101.84.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YtJNExgCJBbR6d08dC7EgITZoa14MGtTQ6l2OXkW/Tq/nrObQCsYDpufOP0pVAjQxasst12BltDZwed+uxtBNA0Q7UUGNl3KH0+1dwgDarfaP9hW6Pk4j+mX+Nh7mGWzobWmks9Nd6BcW10Z9+UlTse+FAC4I/LbYfeKsi8jaBTYGKuuaJW34jatq+v8kPkd1phZasIDsEeO724i34YGF7fRizB5dms0DtH34YslNnESSu2yk3k8DP20e+VkPalajBOG6ULjhUaeDxPp3iVXeR82R5xUSh2hOP//LcUKx3Q6JQtbFqTiVFvx8fAUQC76JUkQZ9aAcounpTZ+M9ReqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEpL0af+Z8PaP8LpKdAZrpCy7/eBUi7ZoSYJKtPy/kk=;
 b=N4OhUaKyZMdjnF3BM3QhIDuGGYglbdgNt1tdmzaFOnbfs9fk+BYPjr8CDujTg3wdmAN2/K/pGjh7MUBJNCKDOqg2HsR4gz/SSF1BZLDuIEqCW7OhMTNH8dA1Vwi+/CT+RZAM3efcUdreD+sp9rVT9bULAnoW/4ojrB58JVhAynoVwe5SzWUWByb3yjcQ5FhNHv/1mcyPuriBPU1Ygnra7VlltSCRjgOkcpz9XXTcMaSlgP2F+kboVLflpvaJ7EIldcyAPdExqoYSyhVrihxXf7UsYbzJT+/K1iyxSPNF0MbWvti7a8kNHmUdalIn0C9SHl27Snd8bTjBLJ6FG89fhQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEpL0af+Z8PaP8LpKdAZrpCy7/eBUi7ZoSYJKtPy/kk=;
 b=dY387rlGuO/b3sIldtR6iopPj46aEH2bePYdiH/myya3zvZQ3jdH0kRFwic0cIFaRENwLtPhXdr8sx/eWVG47PNz7vs++ePrJI7EhLsoad2+/okV1uh2h3RIEe2zciIwkc/3+sIPgakHuEU2+TEnlVInAp7yAKqiD0zYfCR4FsE=
Received: from AM0P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::32)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.14; Thu, 28 Aug
 2025 11:00:16 +0000
Received: from AM4PEPF00027A66.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::2e) by AM0P190CA0022.outlook.office365.com
 (2603:10a6:208:190::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Thu,
 28 Aug 2025 11:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A66.mail.protection.outlook.com (10.167.16.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Thu, 28 Aug 2025 11:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=azqX9xqk9V6cXDwRQxMTC7sAQYTmfn5RQmrC66CpYzCUv18khLjv7Tnjnv8HsrkmHu30dHU8yW6wuxDoet4Jx9SaI/N/AAi16icxFSRtVNfR3DvxTt37gQE0dayOQKP8YWLxjFW7NTx0kgkZIGgw5QsPn7xPQQJFI9fIDxCEwMIhSi50A2mgLTCztaO9R99sxBISD1JbZsrU31Gw8oRMfpRLbDRQPJm4iztlsN8N+pXROdCorBOqv/2pLZy8hC4DCmFyUtIEeRuIZfFGlw5JJYtQ5vkAojIWY5l/QH2WyBp9W6AFXWJUbUSWRudd8Dn19SFi3Nshpi/Xz90VKPYc/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEpL0af+Z8PaP8LpKdAZrpCy7/eBUi7ZoSYJKtPy/kk=;
 b=uaLqYj6F96dYPus7dUQWjRmI2Nu5S/1RTAsLslWxUpsi5Ecc1jYHOzsS+oJ1FK6Gr+Qdzs00i0zqAd9ctpPGNgj5QryrqtU8v2LzGhmLPe3DtdY/ORhlE+XgC9uewvUTS0p+TxTM9kn4/VC71NBVj6s29ZTn3nd1TNxPsTzm7tKLJFjJ+f7gqVMgUmyxXQXZAvjJVM4ND6bU3i1NRfnHX0Z7cGvo3eYFCnajAhwW6EGga1N13wEczo3EcRqVidAqSuAIdpmO+/ufLUsPY5aOnip/58E8C1XQTBflu53pqnvUSqejik+XXMZ9rhrETlM4XP0jYyH0l6l6whhwdhE2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEpL0af+Z8PaP8LpKdAZrpCy7/eBUi7ZoSYJKtPy/kk=;
 b=dY387rlGuO/b3sIldtR6iopPj46aEH2bePYdiH/myya3zvZQ3jdH0kRFwic0cIFaRENwLtPhXdr8sx/eWVG47PNz7vs++ePrJI7EhLsoad2+/okV1uh2h3RIEe2zciIwkc/3+sIPgakHuEU2+TEnlVInAp7yAKqiD0zYfCR4FsE=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 10:59:43 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:43 +0000
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
Subject: [PATCH 4/5] KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
Thread-Topic: [PATCH 4/5] KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5
 probing
Thread-Index: AQHcGArbUGghRYoLx0aKVKc+57j0dQ==
Date: Thu, 28 Aug 2025 10:59:42 +0000
Message-ID: <20250828105925.3865158-5-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DBBPR08MB10481:EE_|AM4PEPF00027A66:EE_|AS2PR08MB9919:EE_
X-MS-Office365-Filtering-Correlation-Id: d828bc67-bdbd-42c3-b35b-08dde6221204
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?n9jATBbf4kCgNAUPGRgWMn49BByZU50e7K3SGIPIVPUMJ6tuUSk3KGJcI/?=
 =?iso-8859-1?Q?vdITJXf/2fGj484apXnDKKJNIMhMhDBq0Y1yFhScsKD4A7548IeiIhmpG1?=
 =?iso-8859-1?Q?+GkC+nTpMbXW45g2ZWWNwc41ZbAQrcZ3yc5B3a0KTtnjm1rEEf7BkbiQJM?=
 =?iso-8859-1?Q?Ws3pc7MfoW0PCy8fQV9pMjLo7BhUws9PIHDcZMYoF8iSdU8kXgPpfNrkHm?=
 =?iso-8859-1?Q?X+ez8mmFgYfh87RKgNKl94pzROCWlx2Nagr1B+zrjUJ9GYTSK5CgdwlKNW?=
 =?iso-8859-1?Q?Vzs8ZqOXtDZBt6h6q/MS9PjAf2yGNjwSh3liASrylLwK1fFq6CiGov/QYY?=
 =?iso-8859-1?Q?PV4DybUadZ4CLz9CHKOJKzqvkTUsSh7ilbhGM9eW/KpG6hfJ1zbFExONAf?=
 =?iso-8859-1?Q?WkPUsBNBlUofTMcHlG+rA/CP8egVqYXuh1t+rgWnrFt89jbAwKuHWHYyVW?=
 =?iso-8859-1?Q?PlNcnYMDT28Z6JhNL9MwyiYQKidfsym65HL4Uqe8EaGWPRUMd5DcRyX5mO?=
 =?iso-8859-1?Q?qAhUaXssG9UKiXt9NcFDlNB9K+E8AgVinXD9lM59QajeAqdrXkhX3/NXH9?=
 =?iso-8859-1?Q?RTfEM0H45MeRwLSDg/efMuHtzW5+fbRBNg0Bu1LpRTMwRREtV5aMYUH89l?=
 =?iso-8859-1?Q?bWmvObN5zXezS9kASYC8SJotHfNWBPdd3aoWFSYri+QBhBdqWlEcTozu5/?=
 =?iso-8859-1?Q?XO9KdDm0sYgsvvMeDVBC+rig0piSogRHClvyaHe3PnxMjDgHyqnVh/4YCF?=
 =?iso-8859-1?Q?/PZsKMCrskOC+NW7DhPmqUFwBO0NLMc2v1LK8JYnJlTwN0VTewo1xi99hv?=
 =?iso-8859-1?Q?GcrJO2IHl2Z08U2MEUPytTERe8JYkSAJMkUnkU9Mrsmk2rktmHRz7bXqST?=
 =?iso-8859-1?Q?gGh3SSzNDEdzX+xpCaOmbDSFvpIWCwR4dzIbiSgBy/v4w5qFgmKAghao0U?=
 =?iso-8859-1?Q?5E54+4fvn/qhPnl+c54n2uttWAw5N6VLI7o5Ce587nI0oyO7hYurpuN/3g?=
 =?iso-8859-1?Q?23H+w3MPdLl1oaro0zIvuEeszxPX1Kv71a1vEFnk1Ak9Z2UwRKQXR8y+BX?=
 =?iso-8859-1?Q?JvL7ioeamiaAtYJj7dss6l+TSFce2mIfjeg8v4dTxLuSs8v6lUHnwwrlKt?=
 =?iso-8859-1?Q?q0x7rS24nanHMe2UyLXqczN84ibI0XNkA7zoKii4pCa7vEMCa3syWTQFBK?=
 =?iso-8859-1?Q?exZTvBhjpGlRDOHs1MT72qJSvGNz9ilKdj5TivVvfTWq2utsh0OMHUrmt/?=
 =?iso-8859-1?Q?+HHsAuIr5vXfWPpAABmwjw3V1H2LKwvbs4d23rZC2dqVsqepzV051S9AgC?=
 =?iso-8859-1?Q?UKvHku2fi1xbBfM/FhbWMPsBM9iyKqTT0/kdbYg/lTh0lez7O3Vswgi7Zt?=
 =?iso-8859-1?Q?jP9HD8qrQmxWEmu2qqhN2pMp8cY7Rb3I2kTIOWpWq14J55vLZCC33AIoKO?=
 =?iso-8859-1?Q?JXmJtiioUW7gqw4yDe3/ule1bX5MJe/qd8g80vYXhzdq+fogdXSnYw8kBv?=
 =?iso-8859-1?Q?F8Gw5H2BYa/NOYNegdr/i5vKs7DDSuiaoeU2bBDF3NUQ=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A66.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b759bf5d-5dbb-451b-5fbd-08dde621fe45
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|7416014|376014|82310400026|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?6/BI+6vCKmv9pWj7HAlqULnxL29VRbzQpUSJNBjQq4aE+lCPoUeDiJHPaB?=
 =?iso-8859-1?Q?yLFV1yay7nCF3FhZz02qEDNwWpUX2+Jw0F35a0gTe+JiIesJIEijdXdDKW?=
 =?iso-8859-1?Q?HkUQnD2V113F2Z2O+8hlVtUYmh05UJXZDSMGGU1K68sureahhUUGeymxAf?=
 =?iso-8859-1?Q?iNpNoVkDL8NqVEqMEdFRaKsI3y/D1WM6m32rxmw738uD7MoSZIjGtX5Kwe?=
 =?iso-8859-1?Q?IulQBhtkljUsjtvWsvwSvSA75f5GFe/ApJy/Bt/64Xjaa8gjVF3NnGAdxN?=
 =?iso-8859-1?Q?PPXLDLhbu0119sK7RvLfyZPHdqxwZAZk4hrMr2J9c4p42shWuwAJ2FUnrK?=
 =?iso-8859-1?Q?HscJT7qLjPedUwGC3cS6Dw3G5DX1FFdfOTcBTg52BMaj7ShaKy8cxSLVHW?=
 =?iso-8859-1?Q?j2Q1kaFt7pKUHy+07xSfpHia7ZMmc3JBYcjXc9OWpmhVJDaCZ+eDNQJdWj?=
 =?iso-8859-1?Q?RjFVjSa0rQr2A0ieTuBXNs3KqNTndf9/pwdZNZDIXbDJ2/Rm6NUILU4sfD?=
 =?iso-8859-1?Q?eNOED0zweGiSj/jwgCkJE+8xC+KlEM4f6m0hUqPH14ChFXyiXKx2pUSSc5?=
 =?iso-8859-1?Q?h3SWhlzg/VtBEXzj06Mfem7HRdf/XqzZADhL792svw007jVEdEgW27dTTi?=
 =?iso-8859-1?Q?E4grwF7rlOZMB6ZzMCROMI++XBerd4jGz74Dvrsgda8+blHc+5PFXD6+B6?=
 =?iso-8859-1?Q?dOtuAyWSpy+PXiBlPywARRwdcJiZdrHlImvW1mXkdqjUuqOn/rBSL+a7vw?=
 =?iso-8859-1?Q?VmDK1OzfCyr1cuuI3MduBVbLQfncyobbM13mq9N6vfbC8XKK9q4aUt2GUG?=
 =?iso-8859-1?Q?j5fp9YmTFZDVW9hha+8JuNbtw0hFgfUCmY385LzRE20iQk9ZNMEaay43Cs?=
 =?iso-8859-1?Q?Rt8Kq6QEuWUYq0L3zvxpE2q9IbDu4TJ7Wq8L5F1FQNB2hN0UPceWw8jKPF?=
 =?iso-8859-1?Q?T6hVj9hHT4K8P0aC4BIk+OqfjOMtRjIkhSNCk34ZqDq6YY76+CzG/CPTlj?=
 =?iso-8859-1?Q?QEUTb/Sv7tPFX3m1QZankbtuKIyu9VtuFbHQvoDPGhOLK39XNPHYTzvqR4?=
 =?iso-8859-1?Q?7r/Yq3iPB9CSW5FETQ5Jbwlfyi4MI6VCBr/kd8OqncsDiCwDoiV1WzloiR?=
 =?iso-8859-1?Q?3fH1Mt/PI8L7rs3tyECDCjE7IdQ0Z4CgBFGL3jI6IOIP0RYCOav9YfmOOC?=
 =?iso-8859-1?Q?wru8eFiLSHMGEVRgktNlG8th7BsfHfqQLe7qv8bDZMeGmmI9rzNF2QBpmj?=
 =?iso-8859-1?Q?+Ke6rW4pRUoisZ7riNdw+EM428/IbFxG7jVOZtOGKZ/jg0vGi8YhdmXIpU?=
 =?iso-8859-1?Q?e7OQbm1WYEjxZiV8BmtirxNtMwbfzKwfET66do4mtkXlmMMVMFo4XIi/Ce?=
 =?iso-8859-1?Q?KOWoIY2M9HmHk/nujFe7z/VB02blrdXTzQK0VnDX5Rfk3XM1a9+Iwpi6+a?=
 =?iso-8859-1?Q?96qizQSMm5RWZ63Lh8QnTOBTS/mhpB2OrMIxR7Mm4AljIrkbdpaWWksgrw?=
 =?iso-8859-1?Q?9ileRaNx2XUpOl+cDh8ooyfyq6llX6LFmSjLyth92dxusX/6AbKtQiGLnP?=
 =?iso-8859-1?Q?ceztRYOfhs045qOa0UmsBhxY+bYs?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(7416014)(376014)(82310400026)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:16.1085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d828bc67-bdbd-42c3-b35b-08dde6221204
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A66.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919

The previous implementation of the probing function had the flaw that
it wouldn't catch mismatched CPU features. Specifically, GICv5 legacy
support (support for GICv3 VMs on a GICv5 host) was being enabled as
long as the initial boot CPU had support for the feature. This allowed
the support to become enabled on mismatched configurations.

Move to using cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY) instead,
which only returns true when all booted CPUs support
FEAT_GCIE_LEGACY. A byproduct of this is that it ensures that late
onlining of CPUs is blocked on feature mismatch.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6bdbb221bcde..2d3811f4e117 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -15,7 +15,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	u64 ich_vtr_el2;
 	int ret;
=20
-	if (!info->has_gcie_v3_compat)
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
 		return -ENODEV;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
--=20
2.34.1

