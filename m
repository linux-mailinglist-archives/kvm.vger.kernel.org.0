Return-Path: <kvm+bounces-50973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6672FAEB3D6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3FE83A838F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D6329992E;
	Fri, 27 Jun 2025 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fuHFPJwq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fuHFPJwq"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010058.outbound.protection.outlook.com [52.101.84.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169F429616E;
	Fri, 27 Jun 2025 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018982; cv=fail; b=WZecqVrH5o56cCJFRJs9LU/xiQm8ob0IDSr09EG/6GYSRQd4vLrL7/6aq0UWAyx91N0f7KDnIzdXgSR3iSxmptxeZbjEM/VpT5mmpumxJmh1P9aPXdYsbEpPQbQuuWAlockJ4j/6HwqrNtE+6Ej50kz6Z9e4Wm5BtKJAWhRRims=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018982; c=relaxed/simple;
	bh=Y9s6FXTaqdGL5TT/mPauXRU0Xr9wuoIEoAjPAbgmBcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vETJCl1H5eC3yGeKewu2ivdMD2okr7XEbpz2S20/g+e71MM2+fhlYee35i6LX6mmSPVkX4imoWcTysVqZLrZqkTkfviTvVYqlPS4pNonMFwXBkLlocGphLtg6z8AGRXWctY3rpRNvfEYx8qyAzz0A/Z4+yURoZu5jypFQTaUJRs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fuHFPJwq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fuHFPJwq; arc=fail smtp.client-ip=52.101.84.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kXqM6V2WfS/126Deklx2mFsQhEaDGHC12HWiW4fCkdz9nEArECZS15KCtqybHvBv2Tg0SCRVrv5wOyLRp4KGNMt4uQ+4SqaZNs6p8SM/bGmeqHNDOEaif/oXCKykGILCZKz1cN33AbeZn9qHE1hmtBvbhH4dz98+Slg1IjWXlVXEtqAI+ubqaOJaIFgXvD+GG/eD6Wq6CFHyw2n4apcrCngKfyewL8axqebInk+AQsPusmgQGymM4qK628A1fux7CPQzJgnJLUHg7/6xOGnMrjfCUVy43AC1d8d1yBRysfwzzDrFDwG2Oq3WULE4WOh2f/eHf/OgBRGJnLtBnOv8wg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZQwQjvdWCtGPu5BJTSZTLRXPZJfEyo/12XPHgaOmxI=;
 b=T/+2LNmthaCWigQh3mP5SSB0M4q5cKCBItnyL6HnMKz+qy6Ax25vTC6VTH10PzMSHUVmRkRdX0IquNRgGzvdVO2LuWbtd9/k7fzuBwI6GyeS5ztVs3fnaDO0kMjqiM3MKv8J5B1exLuGXl0yu5vCaHpcttHO8gj4SM8a7OMZYgNMZbZp0hHJUCCGHjYLlflIg5kzKbEkNafNoUPLnfCc7e/zmDdwP7ski+tIWoNNZt5YB0DUaSHIc9odc2seeDjmGowwSzD4LKhXqfd62g3EGAO7s2718qJH0ckBG3C6UmCtBuqceZtkqmMZT9u2M6fH382mLlPLPiUPQlEFpmG2Sw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZQwQjvdWCtGPu5BJTSZTLRXPZJfEyo/12XPHgaOmxI=;
 b=fuHFPJwqND8KVYf4RQj/VnCt9VeUujMrOU4zxWCwcI6xDjWPx06cnqxMA9U8kl1vgk1+z45ajWn+RsjMY63CORSg2V8dx/U4+u2sUzZUtpUg3Y0Sc4mZ4svWQzrZGxljkT6jI2dQBAwLulA5wxPbkXDZSad3Z9GQ3RNWu1YisWE=
Received: from AM6P191CA0048.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::25)
 by AS8PR08MB8349.eurprd08.prod.outlook.com (2603:10a6:20b:56d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.18; Fri, 27 Jun
 2025 10:09:36 +0000
Received: from AMS0EPF000001AD.eurprd05.prod.outlook.com
 (2603:10a6:209:7f:cafe::68) by AM6P191CA0048.outlook.office365.com
 (2603:10a6:209:7f::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.21 via Frontend Transport; Fri,
 27 Jun 2025 10:09:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AD.mail.protection.outlook.com (10.167.16.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUtUQvUBe0yJS9Ss2FK7hGTLwA88ItpP5Yrqbuy6K6ld+SwTR25P5Gs6OYKo+Z3Sy6JzSSiVyvGSOnhzEvw1grz2JwOsOVnX9CNUtyrKE7o8pmEuk+14jY8ToZQASpHDrYkLOlVkqaXxUyFLe9m9d0wSQfCO//dt6kjWgwgX50AIq7Sr3aYPM6CKx2e4LcvFxlaDJUgySGx5pKxPQBCXpwQMuAeiJYTPnoZO+6UhwxL21+FZ6ft3BhY5o9gYkBeW0oW8zyqSspUgOUX+NL81TeCoXsjER9dJjroQf1Tk3M5ig8Sey1aXisczdDhTqmcFznL3PKqUzxULFlwtQupKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZQwQjvdWCtGPu5BJTSZTLRXPZJfEyo/12XPHgaOmxI=;
 b=upqb/cO3lnoa3GQcKeodlKtE06q0aRVkuWhnc2+HibowCklVJLKh+P6gfrhoZOP+z2dOs0YYiuNDuZuRzRHWeJXHCKF9p7zcF2+xXf7SB77prDjfmVfumumuoXNQXJXw8+9/XvDhXx5VwwTMunSX4Bc0Dsm0PR+denNf1Z3+sYOZh6fZg6MeGwT/GzeYeY0MyVEHY9LKCAxhg6CUQ99SdeUJv3V0FUkPjv7Dx+OemOu8x9Nn4PlMYJM69ClFESK0eMOIWxXY5ljaNu2IhCH7IHqs55/NKhiYHbgEzeY27B3MxyV9azu8riVPwpvInask2i4DsYKitCBrNVRF4goDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZQwQjvdWCtGPu5BJTSZTLRXPZJfEyo/12XPHgaOmxI=;
 b=fuHFPJwqND8KVYf4RQj/VnCt9VeUujMrOU4zxWCwcI6xDjWPx06cnqxMA9U8kl1vgk1+z45ajWn+RsjMY63CORSg2V8dx/U4+u2sUzZUtpUg3Y0Sc4mZ4svWQzrZGxljkT6jI2dQBAwLulA5wxPbkXDZSad3Z9GQ3RNWu1YisWE=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by PAXPR08MB7466.eurprd08.prod.outlook.com (2603:10a6:102:2b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:03 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 10:09:03 +0000
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
Subject: [PATCH v2 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Topic: [PATCH v2 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Index: AQHb50uBnu7xTRQqEUuv9c5/3ycjXA==
Date: Fri, 27 Jun 2025 10:09:02 +0000
Message-ID: <20250627100847.1022515-6-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
In-Reply-To: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|AMS0EPF000001AD:EE_|AS8PR08MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c244f7-7184-4158-6008-08ddb562b88d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?RtaYfzbkUjAOKnzvSGwApP+9YV4vAMzud3lHS82rH9px7VPDuiUoMxL1qD?=
 =?iso-8859-1?Q?l1FuRDBKokfjjXqUiBBYZ5FYbYubBuZ/kIXYj1XfTQIAiGen+JZax+cfaj?=
 =?iso-8859-1?Q?KKGqrFEpkxghJUdVcVXQjKSftEpUia+CgZvg7HYitfCP2W2AOFT4ouMnB5?=
 =?iso-8859-1?Q?ln+vIvV5deWq+coHMqxNVtYLEtCN8iNmEoR+GuSzwCxCIjl4Vi8QDNj6/H?=
 =?iso-8859-1?Q?Lec5Xf//11gRH3mbwppfemYyQVSh4HsNwc3hkFVZ5f2cwPPcPuDnsCq49s?=
 =?iso-8859-1?Q?Dwsulq8xiX3RXqPM+lk5iFyXYZQ3IrJAFTsHI4jUTRctD6pofeD+5So6Wc?=
 =?iso-8859-1?Q?0GjNxUi7Zg/UPRHZmFwD+cRd85m4Auv4CDuyYcpdCdboCDoAH75/4qhChu?=
 =?iso-8859-1?Q?QwZ/D+UPkSVpZKyw6wCBb7Ar0gfR3JFjMpX8RNHEudzV56M+Uj2z55VT8e?=
 =?iso-8859-1?Q?Ycps+oBqE2fvppPUY/97dqONLkBNHfB8oywBn6Wrktx/6JOFDS8LN0Es3u?=
 =?iso-8859-1?Q?L70/owBl/RErUbGpAhYLRQpF8l9E9WL0+pAlwVbCPwOrRAKev4a5PNUu6u?=
 =?iso-8859-1?Q?FTyWJT5KFVoWNf2wPibf0r7Ot6pKoR8DXf+Xv7tICe+RElTpcyftOtznXO?=
 =?iso-8859-1?Q?o6n2t6Wm3IPl3CtIqbkUmas8WJk0vhzNz5VGPhMo3QpOyI9ZveROslJcVO?=
 =?iso-8859-1?Q?vT5ViHCeDmOPt2GUSs08MkJmS/tTSvXKlTKXp6wZZzReZxaWz2KRHo4Uly?=
 =?iso-8859-1?Q?k1pGY36E6WUR/OL4mAjnoHR7+sXRtxhUvronF7lN6DgqYikVOgyIBuqFqi?=
 =?iso-8859-1?Q?fm3Svod2Aul/O3bUdqBsH15QIN2pk4WwCx0Hhcst9cAKfLOH41i3Lnv35K?=
 =?iso-8859-1?Q?1Ug/uKQH9gUsY36CJIhzPAFaRpflCIkpt2qH6d4SdG+NCNUcaNXSI0TTHB?=
 =?iso-8859-1?Q?p4KwulMKKgk8C/W5n3W/7fkbXO1l96ITAh/fh+xw1KVcWwl/VLYSlvOEbO?=
 =?iso-8859-1?Q?zbd7DZSxaioyKE2gE4lkwyjSRaTMhScth94Qwd4LJYlwRd6/n/dX5amiOc?=
 =?iso-8859-1?Q?subPPtSCdZb5dGcXw5nT80W3zxfdqhi97xyiyd3K3ebRpt1nyIFm8mzlBr?=
 =?iso-8859-1?Q?Bts4lJrNy2OynAEV8+En1nP+SfAKVaEIkv7ZP98MLacFZw5Mt1ixuQAvkS?=
 =?iso-8859-1?Q?lrPkoBKYDHj4iFj49DlElwjCXNapyL8Kr9IpsarR3Mu+p1qYy5gOb0OrLt?=
 =?iso-8859-1?Q?iuyXum0ToKUNrv7u2t+7dyElp1MubegWe7URJ4XHDAahI8dF+y0OAr5jaF?=
 =?iso-8859-1?Q?4urzf6Y9e3hIV+kgm/E0O/1B15QQdcHb9l+kFzdYojzbZeYBgawW4Ssdj0?=
 =?iso-8859-1?Q?OaVA49+lTk20IFApy3t4dptxPwfSvKBN7FRQ/9t5OcCRz/sifCLxr1maI/?=
 =?iso-8859-1?Q?dqGByYu1YGqclKAKjSo0Hu+yYVcNzZKwFUFvsbMPZA67grff5G3HeQN1Q0?=
 =?iso-8859-1?Q?5s50qACAudpSkl2ray5vwpMMKggWZH7JcvMEEOimsKcA=3D=3D?=
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
 AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	05e4909c-b5aa-470e-6c74-08ddb562a52d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|1800799024|35042699022|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?fiwAZp0yx3ru1JOMGhAbLVV9t9UdgIFVk0djZXDJ84sy7uk+/eLEcME1RQ?=
 =?iso-8859-1?Q?knR/OVIYc4R/3G76/j/OborokWcocHtOgv+/9klZkY1NS0FNFcHg3B6p8t?=
 =?iso-8859-1?Q?A2i/oGnvAcBtOn/SLvwVSrQVYvYZ5bokwi0TLo4F82gi+1+FRapfjpzNf/?=
 =?iso-8859-1?Q?vYODr6oUn7KgGkvkCdvs4WafPz3d1yxJZmS29z9tTiX21l283M0Gu1TP9H?=
 =?iso-8859-1?Q?WciWspu5lNrDBwRItZ3Q+qSRI0QQz4nm5OyABD7Gkm2An2Vr8S8d3qTZ/3?=
 =?iso-8859-1?Q?v3U/0jovqz5+Jyc3ZwkUWdknJM/rNoDoTe3aJNcMvINFwjichYg+BJl6+/?=
 =?iso-8859-1?Q?dMf6Y1h2HRLLhOAZHqyVcWi9zxod9Zkvj8VG77J87s8FjkWtcgwNa7M0xn?=
 =?iso-8859-1?Q?r3KlFjy/Ekd1JiEOt2TykaPnrzZw0ZBBsHon4zPNoYoeE03yH3LEvTHABu?=
 =?iso-8859-1?Q?P3eKnQqxEawFAq7cjY+1tB9E3aqY9MiN/g2e0TEEeCM5323RE19C8ndmLP?=
 =?iso-8859-1?Q?tXIZntRUr/GvYoksEp2gzqaFfQRwS8Sk5JW5jslKyBBPR1XMqaWq/GNXcb?=
 =?iso-8859-1?Q?YJn6g5ZeklBnH5nWPQkGLV13zCfbEH6iZRX12qq14zuFW87teBsJaRicbP?=
 =?iso-8859-1?Q?FhyrhcekZeSwVHYjDIdI9ML0WuGD8Za0HZirh6+fhS+ZSKdMiBoCr6wp8W?=
 =?iso-8859-1?Q?aYKnesD8AHN+ajGzkzJRnn1oDu4Su0daKUTaET2L8ZetItzUwtvfN5jqfC?=
 =?iso-8859-1?Q?AEGflP4caZZtpBHwBgxjo0NjMyzIne7d9V8CObsEPxqFxecZHl56zmQtMM?=
 =?iso-8859-1?Q?IvnL2NxJKSt0tziBCRoTTNa3e/VQH0w1qI7J93wwcsIZvwpv4dFTmV7qma?=
 =?iso-8859-1?Q?mirqO4l4rP6ndSpUpEb/mmDb2BXJavcgJDxTltU8DhRx1KZIy8KMq1AO9M?=
 =?iso-8859-1?Q?ptv3u7Tg9Q9o/fxv9ZG8SJUxeRoGJ11G2/F32pigtSZCk15Pf1T8+Qh9Yg?=
 =?iso-8859-1?Q?+i3hZS8AuSa6QqitiyYxUV7e6YsTYPK+fi19zpSFqRHKWJ+CkP/4bYeGpN?=
 =?iso-8859-1?Q?24XiUBvUfkXc9DpTlBtXrIfVPcreoALgU15DpVkpW+vN2gyeu1/aldOVmq?=
 =?iso-8859-1?Q?MFGd9F3vjXhp4lXGana1Gpzir6boH/3bzIG2HKHaV5ODCqA7+j+icmaNQr?=
 =?iso-8859-1?Q?eL21o3bAJ2P1OkfdEq1TDytGjsXrNU6g+CwnFWKbJgawqsODBzfwpM+xiZ?=
 =?iso-8859-1?Q?QatN3ZJ72HHJLjXvplcVttkaIuV13ff9uGsTFRhGLRGbJzz7DryhH+ER5g?=
 =?iso-8859-1?Q?xYb1zXb3SLi3Nxh6PSLV0URZIOn6jN8h/CfgDsCry8yU1RU9EIt4Y0/WoD?=
 =?iso-8859-1?Q?1XjrjkgxNZ27KYPrLcxVUTmoQkogqPVtSJDA8xpOUvqTEKGB0AZm6ivW1Z?=
 =?iso-8859-1?Q?aoPe195po36Iz68lOn8Nng/iLiC9VasZol9sdEv0PxXcEIskdKewtQZa2x?=
 =?iso-8859-1?Q?cFofH7NRN64oss5jzwWeVaB0FKWZIfnNgXbTQ+Ds5C4ODnnTFWi7DyebNU?=
 =?iso-8859-1?Q?Mbe3aoVFcrtYmDQpuZ/Q4nQwLlEV?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(1800799024)(35042699022)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:36.3206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c244f7-7184-4158-6008-08ddb562b88d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8349

Add in a probe function for GICv5 which enables support for GICv3
guests on a GICv5 host, if FEAT_GCIE_LEGACY is supported by the
hardware.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile         |  3 +-
 arch/arm64/kvm/vgic/vgic-init.c |  3 ++
 arch/arm64/kvm/vgic/vgic-v5.c   | 52 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 4 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7c329e01c557..3ebc0570345c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,8 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
+	 vgic/vgic-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 1f1f0c9ce64f..72442c825d19 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -724,6 +724,9 @@ int kvm_vgic_hyp_init(void)
 			kvm_info("GIC system register CPU interface enabled\n");
 		}
 		break;
+	case GIC_V5:
+		ret =3D vgic_v5_probe(gic_kvm_info);
+		break;
 	default:
 		ret =3D -ENODEV;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
new file mode 100644
index 000000000000..6bdbb221bcde
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kvm/arm_vgic.h>
+#include <linux/irqchip/arm-vgic-info.h>
+
+#include "vgic.h"
+
+/*
+ * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
+ * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
+ * registers a VGIC_V3 device.
+ */
+int vgic_v5_probe(const struct gic_kvm_info *info)
+{
+	u64 ich_vtr_el2;
+	int ret;
+
+	if (!info->has_gcie_v3_compat)
+		return -ENODEV;
+
+	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
+
+	/* We only support v3 compat mode - use vGICv3 limits */
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
+
+	kvm_vgic_global_state.vcpu_base =3D 0;
+	kvm_vgic_global_state.vctrl_base =3D NULL;
+	kvm_vgic_global_state.can_emulate_gicv2 =3D false;
+	kvm_vgic_global_state.has_gicv4 =3D false;
+	kvm_vgic_global_state.has_gicv4_1 =3D false;
+
+	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
+
+	/*
+	 * The ListRegs field is 5 bits, but there is an architectural
+	 * maximum of 16 list registers. Just ignore bit 4...
+	 */
+	kvm_vgic_global_state.nr_lr =3D (ich_vtr_el2 & 0xf) + 1;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
+	if (ret) {
+		kvm_err("Cannot register GICv3-legacy KVM device.\n");
+		return ret;
+	}
+
+	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
+	kvm_info("GCIE legacy system register CPU interface\n");
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 23d393998085..4f1e123b063e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -308,6 +308,8 @@ int vgic_init(struct kvm *kvm);
 void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
+int vgic_v5_probe(const struct gic_kvm_info *info);
+
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *cpu_if =3D &vcpu->arch.vgic_cpu;
--=20
2.34.1

