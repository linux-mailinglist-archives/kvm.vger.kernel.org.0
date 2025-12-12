Return-Path: <kvm+bounces-65866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CF3CB91F8
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D417311C403
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301D732572E;
	Fri, 12 Dec 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LnXpx8fn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LnXpx8fn"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013065.outbound.protection.outlook.com [40.107.162.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6F316909
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553040; cv=fail; b=RmNTtqdaR7wsyPfUn4s2pA4vKENZcA5JhMy+m0VVKcZzc0x8poL9vSxsjHVKfKaoqkYRyZOmbjXNJ+IXOV8gsulvK5GXR+bjSSJeAPNnUfqnDI1YRv6qw+3SGgz4bMROO7p5d59HlRbiQSBtTL8i7jw1B2zbBMenZAM3aPy6NVE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553040; c=relaxed/simple;
	bh=6zjnw7IOAEjqmPncB+BOQHhGemci7JxfWoAzUoQhMFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rdgPI3Tn2a8JCxJ+JjQH4zNMYp8xdeddA//EWiJOAIXvqFs0j25OEqiZXqyqyj99L0PTlOyR9Vghu10rgUOY8XKn2/P5qXBDtkCQygMaLsLHFpPLr+FF0X9aG4xMRvAHDrX4z9gobbnkUsp3LHmPOEDXPxcMMmNi8RaklHVtxEQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LnXpx8fn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LnXpx8fn; arc=fail smtp.client-ip=40.107.162.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oCFxwx0NvxN1VYTP6gQcKHWGWQlhODlEvzClZDy2hiBS16Lkumwk9J9EL1Bgb58X0LoPXtaKB3fKoYw0NXINUxZRosC+MNVhhkhar6tPArzWjY5d/ifggbnQPeyuvvcX7j8Cc4UYbYqo7ME8hKQJfFvaXsFY5WxooSz08rddHd5JvihBWztilBvAMYANeVePLrgcYj89PdPB7QcDWAez1t18BEMo4rPLEiaDKLR30e6BZAHsieQ5o8qOE38PspQ+OSoeATNkT2u5W6hIfQKOJAyHVhZXvZcfKmouhLDXjg7Bop0DTo00tmQnP/5p4LW+BiSkUJI2nHr2+9EAHH2r/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+np6maSbCI0VdzHTXiKscuBqZaTlxBUkisxpvCh3D7w=;
 b=kzksn6blaT+WaUW9DRH8WFZ2fFOcXEusVwylvCwVeFnGAK5/RQRBi9X1M4M9qLhQOQY6wZJonQVlZI/uGQ2R06WTafviI3glDFtzQ3AMOtfraNI/fXD5/EZB4UVbnsDYjuuT/5ks/ZycFZNcQCK/JjJdQOciMfXlXlEGgvqXdzcWfQpJSEbwitfXBBrevUAZfmUSkRFefzqntWqi7BWHRlFvLlm3BPO470WPe+Scc4q6oOhCip+BQW8F1eOO+edcBlIQ4tdTZ6lQ9JMn5icfCWlT5XrzsFAzYCNiSKM5WWwtgc0Q2y7sdi/NhXlmyJ7z8iyhEuI3Zq49YJaRq15pwg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+np6maSbCI0VdzHTXiKscuBqZaTlxBUkisxpvCh3D7w=;
 b=LnXpx8fnAFFvA7zHh6TFqhcj1moIBvxL/SfdzjI2i7bS8r/XlWK3XvhkGSGUcmQAlsRDweK608XhzHi/UnndIcPMalKRvOcIK3Cf0LHyr60QIDHekrY5l+yyGKTbynuWrpCstzpqz/z+jE0r16q57JnUXIvGOE7EhGu0Jfk0va8=
Received: from AM0P190CA0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::36)
 by DB9PR08MB6682.eurprd08.prod.outlook.com (2603:10a6:10:2a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:47 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::4c) by AM0P190CA0026.outlook.office365.com
 (2603:10a6:208:190::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2RnHdV0bSlcJXRXikJXuYx9XQFKhvRqHUpvA1Zcjkx3dWgnOMz35vdbdZiPmRpFydR+gRRMlBr7s30YHfVi98sWZg8mVtlCkP37zOwxCRDk9OZFF+vIGclRoqFU53borOtUNF2Zm5zEtsVvyUyxro2Up8H1aTCze5kjmDl9HSX/lsEFCM19HgM2mf1iZY7CblZkxRffwn2Tk77exAtCco9nslJKnshrckTGevEIx24QuGA3z72V2zv80zpAwzTxAE/3gxnOUYbtEFpmTe328GUsX+YKCLPYruutv0MAk9BpYgb7nP+BABO+qRUYhMiCORZ1U+OxEvbMfiMxZTpQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+np6maSbCI0VdzHTXiKscuBqZaTlxBUkisxpvCh3D7w=;
 b=kp9tO1uO5RkmC2uS+qpdwyiflHEu+2LfE/Og2zkKU1hyg6Ckn5bAinxWvHvF2rDxzpDfzSFIhOh87CV7Mh0J8BfqIDoUsIRGrN9Dt8l9gMAU5OOoPU9pAT6rxubgVtoLMhKQccRsYX/QywwFmcSy8qNkpdLbviIyRzm65didLPE07OPNaySaNJNMmuN7MQqTeNtSMbpfQ2uK0zrW/QRVAIKTs09RR/79gL0K7NmpRAmQS544sNqRYXOpqkEYAkmCidomT9UacIU1McfgCXTI83QKWxFGoNkpmq5BqBNydGm0zKosP935zAN/6NPPA7IWeN7Eoq2yqmvxNt5rAI8H6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+np6maSbCI0VdzHTXiKscuBqZaTlxBUkisxpvCh3D7w=;
 b=LnXpx8fnAFFvA7zHh6TFqhcj1moIBvxL/SfdzjI2i7bS8r/XlWK3XvhkGSGUcmQAlsRDweK608XhzHi/UnndIcPMalKRvOcIK3Cf0LHyr60QIDHekrY5l+yyGKTbynuWrpCstzpqz/z+jE0r16q57JnUXIvGOE7EhGu0Jfk0va8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:44 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:44 +0000
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
Subject: [PATCH 20/32] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH 20/32] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Index: AQHca3soO4YPElcpYU+Ipr93pIfJGA==
Date: Fri, 12 Dec 2025 15:22:42 +0000
Message-ID: <20251212152215.675767-21-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AM3PEPF0000A794:EE_|DB9PR08MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 425f198a-3c2d-4fc3-ee67-08de399271d3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Jg4/6TXmRv7Kc2P2+kVyQxxTWd2TFTNtuEhHiddYdSiMIAVHT8zVCyV2n6?=
 =?iso-8859-1?Q?omJKF0QggK+j1zNuTVikFYgTcerrkWlFNuWcMmhrN3xiSAgBSdhRa4In2d?=
 =?iso-8859-1?Q?DnwdFf2o55yISdwA/8C88WiSZXGvmoEm166Ey5i3XUDFgCbgacQ4bOP7HK?=
 =?iso-8859-1?Q?NLKsrKJYWJQdhhw6slcEa1QFyAbyXHXx5qidhqC3b4m8VSlYg5Z0GE9vZm?=
 =?iso-8859-1?Q?D5p9KAHQv6CoSHRO5f+aKu0TW1c+GlIlatsfrnLAHD+yFm1RplhVAeaeVt?=
 =?iso-8859-1?Q?O+ChFXyMprGlSYXzCamKL4TMA905zPaEHtJPE7sXNk1gV3hSgl/UNrO4aW?=
 =?iso-8859-1?Q?F7tRts4o0VWsUxV+qeDkT6QhYxZm6UtET74vhpQBSPHsRZ59yEIEMIdjte?=
 =?iso-8859-1?Q?e7/dHNp2lyq1iOWnp4SacU6IVyDtBlbj/0qssBOckg/ZjiROhZfje8Y7TC?=
 =?iso-8859-1?Q?RxshXHmY/yv2ITYU78aAbETROrUEXgWy/sFmG2a9+4Q31nK+IHhcTeRtje?=
 =?iso-8859-1?Q?ka6ULVWJ67XfKPhyxvtcWsT05IKsivy8EL5JJ0rtwFIDVXAZWmQbHJ+Fvn?=
 =?iso-8859-1?Q?r4EoM1QcXJ3h8yHgBu9sh+fUwErL7ihPv8P/7D4Nc6UcTEFf7WHKIyHGkg?=
 =?iso-8859-1?Q?29ro20m7mkpzzj80DghD9EPL2elc4iH1I1pXN6MUwbetiz//fmfD7FCRnl?=
 =?iso-8859-1?Q?ooo/uhDD0EbuveqjdDzNa3Wgs9hqyZLdMqdlXIXwO9wrQ/zGnlrNPHX6/h?=
 =?iso-8859-1?Q?e6EZGYfOr+zEnTwbEfKA/SzR0cuNikWTRNrmEFXAeAvgQZcUfGxHu8s3PE?=
 =?iso-8859-1?Q?LD0EWbsRQK6xm4vWz+nYfMowwdjwPOrBCSgpHpBHjDHZ3AC/7fQGWxNg2R?=
 =?iso-8859-1?Q?H8GwB3ZEG6N/yPP240vnqPRJtrDd8o5JrLY6MsegwGpNc1gpVZgIC9Lbiu?=
 =?iso-8859-1?Q?8ZjvynPhifKkjacNfqlJMOqQ/bY+t6kgVbzKXv8A0E3lREfABZJmRG/oMu?=
 =?iso-8859-1?Q?Y584R1SgpPPpngxvSD1iOc0UCNvHEftrbSV6hHsMvvaceotwCxd24UxZ59?=
 =?iso-8859-1?Q?oj9Dq1lxyNMC44TkmojKR7aDggGepvAI9h3fVglmBKacbvrAvUmU8UerM7?=
 =?iso-8859-1?Q?6FDRH74UrsKW/2ApUtRJWjEKphE83S2CMOIMo/VDKwBBsCeDlnwghOUeFt?=
 =?iso-8859-1?Q?8wud3X2WslrumzGkdJN+6JXowf/JoDdyfadFRibRAc+lmnIgClAjk5fKYZ?=
 =?iso-8859-1?Q?cPDzOZ9tFh9rw5FAeJk3GX0Zgc6we0JO57+SgM7ZifYoSjdq4Ubevn5PQL?=
 =?iso-8859-1?Q?/fst1iUw/BPY7AxohUeb7sCnR0EYdUa136pUTYP4hSD9jNyXZ+Psje1CUU?=
 =?iso-8859-1?Q?gQIwXp8ag6exkKe6jQrFENHz+3h4dYLDkFxXzaPp8CRj5Hr8xoWcwRxgHY?=
 =?iso-8859-1?Q?V73cj7y301CysWWi97yuoH1DqkRObCsZH7fguklqnjj8XCFZ1tadh6gJ4F?=
 =?iso-8859-1?Q?VrCIXxrZ8ykLBb6ve2a43SDahSBHruW7pee1JW+SUDiq0nWXs6OvRv3ozS?=
 =?iso-8859-1?Q?DEFMSzcGVD5IBXr5ZYtDJ7rKpA3R?=
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
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	689c1460-facf-4b5e-4921-08de39924ca0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/FsHYVSCtoJ/AI0I0sOCIKxlNsViOXCpz4ZSpFx3yEtNNO2huHx+3h1WVl?=
 =?iso-8859-1?Q?/nO+dWXY3habyZ0a5jYw3ultk9YW8Ni/0gSvJxxeXmz1kw5Qykzf2PZuiY?=
 =?iso-8859-1?Q?Gb3/6mY7Jb03wE7PKNS9rc/58Cjp9b83706BOBnXlyjHYTiOievfviZ29j?=
 =?iso-8859-1?Q?QrRyryp3+s10GGumjX+WCokazfRlzy8sXfHBqkC+p/NiwGPT2wILb4MwiA?=
 =?iso-8859-1?Q?09qgmEubp/ZRAx0rWEA1ka8P8Hrf12BbPCUqvjNjJ76Mya+JvmvT92cTWo?=
 =?iso-8859-1?Q?1BF+T1RyUJT5AMH2uRRUvRVWh8G+tS3Eoz5J6dhA6IMDU6E+gJqGjdYr2d?=
 =?iso-8859-1?Q?CKd5FnDax1peiCknz1vMmNA9B+XTUO8njus5RAXoJfPWtbtdQYyOb5FH4m?=
 =?iso-8859-1?Q?p0wgrsLOQ5PS6KDjCvcotLlduy9TJEZq46SdJB5d/mGdJ5gIIOR3LIurBK?=
 =?iso-8859-1?Q?S0TXjO7o1eJ+N6JF5jnwNzcjT6qla/XCGuLFam4p6ezqR3xvOe34CMXojW?=
 =?iso-8859-1?Q?giJ0yDwbOQgohBVFGl+fbwsP7o/jXKAc1jRe3Usep4EPdVtfhYj6KVCCzC?=
 =?iso-8859-1?Q?1ABoDQp4xCwHT5j3qAhSOinLG+1Ta0hPxuKndCRp7ADZaGtqwiNYLpasZ5?=
 =?iso-8859-1?Q?7zOPzYuKhiHvCTDcgghI80E5J4E9uYbHWf7xx5L/G2BVU5dG+EhJfgLPOO?=
 =?iso-8859-1?Q?6XAsrUp8dDEbm2lRqwDOL1H1WzTj0KInlp1H8zgBVjEq5+7iyJe7sT2Vl3?=
 =?iso-8859-1?Q?regI+mbVz6+tVjdhEXFIVop8gXiUjhLG71uI8GW+Iy6zc4mxPpsIhRvPHs?=
 =?iso-8859-1?Q?9r1NFm0MCSiNOslttIz9rwj3mpMwunaZHmiVb933r1MfHECvVjWoxPU673?=
 =?iso-8859-1?Q?G437aypP5IkIjgmqXN6dkCyv/CBoupVLipQq93YTQKZ7o/fmhiykQDI3uP?=
 =?iso-8859-1?Q?QxsDzWL4/EmxJeGsJqlhfcCCIXiN/Aipgo7UC8WNJZYJTJieMJ8PGfDUJn?=
 =?iso-8859-1?Q?IeozNIVmVxAACYqmtQfHa4n3UEce/XVKJV9+DSkmqoU4tfCeusK6ZyNA96?=
 =?iso-8859-1?Q?11q627vCTwmQvdUtaxjWxFSo77nyCRvSNRDhoYLe/JmdzTRlIpH3nALf/b?=
 =?iso-8859-1?Q?75v228kecXN7MAtZGQIxCxUUh4EpoQNVxm2XYJTEBCJNM4PT6TQCBAmGMB?=
 =?iso-8859-1?Q?ILcxODz+EIrT5fUNDqzcmpl8oKA9tIqJVVWBolTSWPHQNTx8YmZT3WptI0?=
 =?iso-8859-1?Q?2e+fKMHlDYvuzqT/mE3Mx+HklyNimBdVbzFb+OAdTrS2wJa4mK1dqsjfTn?=
 =?iso-8859-1?Q?1oZJSaSE6C0MaKNJmiyf2PSXbN6TmOnjnx5W4ihmWUR6SoEKVgrnl0bXPZ?=
 =?iso-8859-1?Q?w7iU0gbJ0uxeh84m9kFwcW45782j3E4yAOdWEUepQgaVAYFyChDlRyda0c?=
 =?iso-8859-1?Q?Emio5QVnpr3B2horasa2bYkoWgKkko/eflIHL1YT5Lz36LxKOQhyZOvZz8?=
 =?iso-8859-1?Q?SJc8p3ce+DgltXms/Bw58R1tfrRUq+ALt82lg7EUVAsWbV8EkgiKtwBZTs?=
 =?iso-8859-1?Q?4lq0qAmiycY+feYwgcKZ/g6X35ne7AeeEtljvdADcImjZ9ZEpE4yWEh8IZ?=
 =?iso-8859-1?Q?H8f4QU7H77/0I=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:46.9973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 425f198a-3c2d-4fc3-ee67-08de399271d3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6682

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restruction will
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 21 ++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 01a3abef8abb9..460a5511ebcec 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b7cf9d86aabb7..22f618384b199 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,8 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 #include "sys_regs.h"
=20
 static enum kvm_mode kvm_mode =3D KVM_MODE_DEFAULT;
@@ -1426,16 +1428,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5d18a03cc11d5..62d7d4c5650e4 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1

