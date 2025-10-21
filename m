Return-Path: <kvm+bounces-60650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5477ABF5988
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CD8BC352CAE
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8D32DC78A;
	Tue, 21 Oct 2025 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HlJvnP8a";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HlJvnP8a"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013017.outbound.protection.outlook.com [52.101.72.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D7832B986;
	Tue, 21 Oct 2025 09:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039954; cv=fail; b=dXYpXISPowqcF6hxgFzbDpHgOW+7w7pHt8nZhH6loCPEMzryXDgmsza0V9iOUBluvfna46pFiMKK5B41/jbnKF11qWU2HZ+IHHzjx5MY6nM2KbJbQJP6kuglpevTVh3s0KjeCMHsuspRMmzyTHQmNbG5Nzky0WgayEPE2jlqwLo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039954; c=relaxed/simple;
	bh=QqFFGGPpYqFag+7FYwO55ad89kUuQbLrdoBj+0TkTaE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DDMISglXdZ2UM2Oi25CezL8o3Dd9dHLoQ5O6O4MwJJdWts2NsFbQl92kfI8sSS+WRa1DoLSMtscGYq8vBshmUbpFn2LB/0cQlvaVpV6nLK/fIHPQH4ZcskkHh6GPB2r2E/GjJ9ZmwJM+RAwX1HfCnho4uVTXW/CXudQ0ej1AgTw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HlJvnP8a; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HlJvnP8a; arc=fail smtp.client-ip=52.101.72.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iWsMhTx2pJT3hPQ/bPf1UGT4BwhiHxOXEHEhXHEoaxVVR6d3eqadfIRpzcHHAs4m1G4GMRBGRv/5ZkjZzlqfbzKhi5N0t+UdXNYtLDxxcp8iFBEau07Yg+ViOvm8dV/B6N1FWtR3tg42w2v01p2B7SspVAtGeUMWktQkpcvo8Pipzw/pLkRfngOUU5IBJUiK+XPkirEsfkkUmGmzcKPBQS1b3hrNtObFbXiL+ZwnrfQM1/7xIPKTbJBqc8TV+8NwssCeQOtoml3pKR7BKh1jlbN/MAO1Xy2wGQBiRDU2gtaL/1Wzqi1ESyOBcSAkPKLy9NPZ2L8nS8oM7cSQqi5bjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jtk1iCQF9NJq3dLVCcVHJOY3hSIrAkRjIA6sxVp5j7Y=;
 b=B6aPitgAfBDVbB8msqV8axqI1XC8AZpmhhUVv6aIuNfp1MCvaZ/GU0y8lmE8qLWbXs8Yz1oOmtzE8CdloqmDmhrcw99CEh8N/DQbS5msxOArUlWAW4IoY8hmZoZ3wqa9/eurWXIyqXXFNKWZJqEIvQFazQsMBy5ARbh9vL7RKW7tBSrd+09aRioozdR4ehJLfwZH8BxYICNwmZo/22iSTcnt39ltklJ2Z8i3SIdFeshGURda5B7uFfZyljWM7TDOvTPoW4XYRKq1CKq+r1v474WqCo2bgS+D/NoTxZZrTiUCoUqHL8af4o+xfmckbGjlw1ZsdHJLBdQlXh8wXT+k1w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtk1iCQF9NJq3dLVCcVHJOY3hSIrAkRjIA6sxVp5j7Y=;
 b=HlJvnP8aYGm0NUnNeQqNgSFEJshy6sXREcEaJB9hc1KQr0098997bBkooD+pPmU4GAKHnFPcQiEz53Dn44ErXHmuN2BjXvVaHpq5QjzVHQWqxm7FxKw3/qBDOt6cUoIC+wRCMYRFmH28mfVUCMQN4upOjOWmeFLYBBNJGLy3efA=
Received: from AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35)
 by VI0PR08MB10848.eurprd08.prod.outlook.com (2603:10a6:800:211::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 09:45:45 +0000
Received: from AMS0EPF000001A2.eurprd05.prod.outlook.com
 (2603:10a6:20b:28f:cafe::2) by AM0PR02CA0228.outlook.office365.com
 (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.16 via Frontend Transport; Tue,
 21 Oct 2025 09:45:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A2.mail.protection.outlook.com (10.167.16.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Tue, 21 Oct 2025 09:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cc0/f3TXdCbwZtUqwQn/MLOaOGdZ3QHB57Asr+8VSjEurVBcTcRax2ssKB8ggyNbYtfBuAdkehkT+kJo9jR7jJm9EgY1vw8xas7sxBVKYBMz6DvUgi5Jy8oUQVhb/puZhXlMmRF6DWyBIBn0h+b1D/Vei6NGJK592mJKuQ+DATQojz07GKC7fhqN1M+MwjsMqfER8FY3eqxmesSymJ6GtSjrQz1yMLYe8ngnZj0i9UY5CvXEZKnLv+shfhII3r094fMKi9+gvPgdAsLQp7qY9UyigIKY3phflN4D9m/+96P7emTa4iYFKzQ18lF5d0Eb4rUnzoP0pWIcdy+SMMCt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jtk1iCQF9NJq3dLVCcVHJOY3hSIrAkRjIA6sxVp5j7Y=;
 b=nJM5HN66k4W6zzR1iB6ABRDGW3UT0eXufFqTV50DjahpA36iw5OG+k7NS13Zl+F7+FjOf6nIJCrhb2v5qGraeLFslGgmhzdYchDs+5Ihdr0c/5IqGAqRSK+eZrHKyrClrQktbtbtdT7h2hzjiQvNSbu2QISzyLMcqcaCkAu0TeoSu+8EzUfbzz6zO1yzYYoQf7dOPg9K7VrdYf+s8rBSyarfe9oDFPbNuj4YpMydkquvknyMu8c5NWZ17rCa6/TiQzpfNbb7O7yKg4z7jnnn36fax4Y5kLqsYMhwL3EtJbNTGcPx9j6UElbnEuC72puynksX94qoUxwTcrGunikieQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtk1iCQF9NJq3dLVCcVHJOY3hSIrAkRjIA6sxVp5j7Y=;
 b=HlJvnP8aYGm0NUnNeQqNgSFEJshy6sXREcEaJB9hc1KQr0098997bBkooD+pPmU4GAKHnFPcQiEz53Dn44ErXHmuN2BjXvVaHpq5QjzVHQWqxm7FxKw3/qBDOt6cUoIC+wRCMYRFmH28mfVUCMQN4upOjOWmeFLYBBNJGLy3efA=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by DB3PR08MB9012.eurprd08.prod.outlook.com (2603:10a6:10:429::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 09:44:10 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 09:44:09 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey
 Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
Thread-Topic: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
Thread-Index: AQHcQm9AdzTh5xpCJkaD94gmRntpYA==
Date: Tue, 21 Oct 2025 09:44:09 +0000
Message-ID: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|DB3PR08MB9012:EE_|AMS0EPF000001A2:EE_|VI0PR08MB10848:EE_
X-MS-Office365-Filtering-Correlation-Id: 5270352b-2902-45c3-c1e0-08de10869a29
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?FkJ7rHu+WsMsp4v++Uh+L7aUXYcMMHH/0S1b1jFYS1Ag6yeW7B/8GLVx3V?=
 =?iso-8859-1?Q?n+ujMpixacmMbfH2pUrs0a+evzj4nWNrPheJ5V1yAvxoM74uYH5gGDvdlO?=
 =?iso-8859-1?Q?0q7QTz6C7SSBcs4THqw+VfXpXiEmKS8BTfctig4PCBzF6qP5K5lKuIytbk?=
 =?iso-8859-1?Q?ObnQgOtZOkijcpCIZ5i0nDiLwlDkF4UfsjLKy43gKg4cPhBol+e0CrLhDC?=
 =?iso-8859-1?Q?zt9Oiras28liwGPOCAZsgdvI3Z623MlZpDQg9nJ1s5ibGVATvTPQIyzu1A?=
 =?iso-8859-1?Q?zWYeuWhXEdaUWdsavGXCapODpDbe0MvnisVKikfBe0t2OBP3pKlBVZ1q27?=
 =?iso-8859-1?Q?ocmmW/CESYrCIFPXeWbx2zYPoixUMxYqXwpV97KtIfvDB19nSI1kWBtFP6?=
 =?iso-8859-1?Q?fZFrb47TEY4LlBOCYZ8Hg82X/4Yozg1RXcN0KXBvZrRNXJujXOMpA7LcKS?=
 =?iso-8859-1?Q?kcjmIxkuvgAuyIqdmSAyZYO4eZZ7k1+WJXdgsaF20UMDxUqNirVlRtNRz9?=
 =?iso-8859-1?Q?1PtlNtY+DGRt8SXPtDUJWVcuDLR9j9+B1BRxlueYHf5zBP3KptmWAcA1VW?=
 =?iso-8859-1?Q?4MTbFNUC3QqUBVT3qRxpXyRpNMTAqc3+BlxNzrtMHiuuW04wx1xirO+wPl?=
 =?iso-8859-1?Q?LhTz4s38letIVvrAMp/BpXsxKsi2C1nnaijFNMIfohm5w67fVNCirznfgs?=
 =?iso-8859-1?Q?GmNoB0yME1IIgF88ZR58zEl3aZ8wfd+jDH1VmROFBs5IpJnzDBpAcQ6QA2?=
 =?iso-8859-1?Q?jNsJ7udwgvvebSxjbZtMpg6FV/JrebW1yiSR/nT2hqfX8PibEaFmUtmVKG?=
 =?iso-8859-1?Q?lZJ7gfEBTtXDLRtMkZHWjXs8q5jRTmhdFxhP1Cw9fSlslklZpZz+ajUmDS?=
 =?iso-8859-1?Q?1JDLpAdAp2uwtxs+d6VSpn02EHSUyVi2OUe8mrIaG6UgFtZVz7oJhRp1yj?=
 =?iso-8859-1?Q?YQXD0j2DVUuFge0b6TQHkUddUdn+iKjTNH9IIHhqh+FDepXiv3fxarF4Xa?=
 =?iso-8859-1?Q?CBi3qCvhR8ep49/4BdgPGlpul8zUi2sRh6Y0wu9yQVNAAvZobh/8qhMHM/?=
 =?iso-8859-1?Q?M6qgKGwNtWOmuO9K3twvMnpX0LKjanDNIDEIpgN4DfCFEHiPVJll7QCBty?=
 =?iso-8859-1?Q?RChRcEaP0mOPWB6cuhH9MTMQqs9L1f3QOW7fQS4qlfqROdmpOofAJQTrso?=
 =?iso-8859-1?Q?hOLvD/Ekib/Qeog9e4Sys7s7/OA30+bPNXcdFutNAWPfKwidMCk+mIaKDG?=
 =?iso-8859-1?Q?sW6CNvGY5r2SfRjvPgPuFL76m0/IRAWTZXwXdN/ayB7+mqHDTlhfh1fqD0?=
 =?iso-8859-1?Q?lnsX19jFTd/ZA1fdz3CxvFHOxbAOAttBWzthcTfgTiOch0lTu8BlzdDCUn?=
 =?iso-8859-1?Q?o4OkebVSo3LbHDocry7U9jMSNlwkeKJZBkoOJ4edtrRSUPiXvQy82bh3I5?=
 =?iso-8859-1?Q?99QK0cfPf/GObYsZQF7BecbnAxMFQ4xObHxef0YE53dG5UAcLKrSzLEJjR?=
 =?iso-8859-1?Q?jjgyGfz6Z9k1SN4YnyeH8iI8oLIs896dVvkjSVwDUo03DLkZCOTLVGR98u?=
 =?iso-8859-1?Q?tkSYU29slGJz64kXsNeLPB+d7wBp?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9012
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f3b8be2a-4fba-4158-e9e5-08de10866298
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?elkTFT7qgM7fRvTK1kGrLjHd9MbzmOD95+A0O4C1OGqYfhKx/rklTmHuH4?=
 =?iso-8859-1?Q?XaxACHWosjOItvWiNeRB+t5VlsL6qNak6StFj8SDdDezNq9j3vmayRCQOj?=
 =?iso-8859-1?Q?bpAwAE6XydwAcKfFNRhIAdJDNczGkLTbrNa9J8tP7C3GShlwn/snOw2cJG?=
 =?iso-8859-1?Q?R1V7ZcsCZC7tjpuKhF+CqLq8kRMoaxFGZUisx7cwjDvnbOrJNlXA7a+PVs?=
 =?iso-8859-1?Q?i/33Yz+HMFGPvlE217SE+KCZdYQ2TgX4EDQwoUEYiN1o0cPL26VCNhAvN/?=
 =?iso-8859-1?Q?T/SNNtGARBFa1DyJ55LFjkGKf0ux5XVIWLxU49NssNq4QF/Zt5uTDoMKZ7?=
 =?iso-8859-1?Q?ICzBrGffZ+imVQT7Pqd/Cz+q8j1gB/upkcuP2TT44GA3O83EGd5ogMiZLs?=
 =?iso-8859-1?Q?6OWOyZ1Mu5Hrbi/FwzqnAL1pQ02v1vhJueLOYVpiBeGoRgAd23/ggrNfgi?=
 =?iso-8859-1?Q?K0MPqhhUd6suYPcs02uTc6x8oVs1Zw8dLQoHxSektE4Kp9BhKS6aEj7L8v?=
 =?iso-8859-1?Q?G0VXFaGlxutxOiJIChCuFqgoiwlOrVktH3T6dgmwQOMl+CSwfpmt6nMfTB?=
 =?iso-8859-1?Q?GJoc851eqQm1xnaAN994gBr09w1DlRjPOKKEdz1c03+80OpzP+ijrx8QK5?=
 =?iso-8859-1?Q?Sout7Zptdktp7yo+BTz2EnEshRFdXOtiTkoYSqGY26ccASa1a22Iw9RLNV?=
 =?iso-8859-1?Q?sS5GD5/LqCC3JgGSdPM3oEzNCkYk/hMlxxAh2mwjRYrcT+HmVWY86Lj+J4?=
 =?iso-8859-1?Q?DCeer6JaIhUGykNaX/XPZ+fFgGudsbU++BJmudHFg8AMu2i314EhAAJ/00?=
 =?iso-8859-1?Q?5gbnH+GbAOVjS+9aQAb8RVtWf7kp8l71vhJc8hEPmtI7PTuCrhLVld7bMY?=
 =?iso-8859-1?Q?U/ElohElNcNL7sFrwH3hW5/29tuS0+lruaE9/4foQLzD7LnEopXZ7EHKZi?=
 =?iso-8859-1?Q?t7/HWd6rkGNXnjiCUCYMxodewfgsZZ3uDiDuXnVLDIna2fDMj7Krpt437N?=
 =?iso-8859-1?Q?eddqQRHni80ToKhieFod7kdf3NMksTU+oRRywaqdWfPRWB76rJdDmc/p41?=
 =?iso-8859-1?Q?tpjf5RNnWBHFfl1zrkeXMVmYRv+ghQF6VraPZX4Gt5Syc+qC+RXXKMCOe0?=
 =?iso-8859-1?Q?5O/10X8g0sHnIeSthI0Lxz7xUibuRYSHuupkL/KrBwNqP8E10y1P+C6Fh1?=
 =?iso-8859-1?Q?OXrhLQm9HUZeVt4VJNII1hvtaJY1wIwr4dNP2cXVdThOVVAGG4BTibxfmw?=
 =?iso-8859-1?Q?ppxKKfmHqGMGiXGu8WPTz1r7flKPNudYhTzid7nOP7j+L1WufNyCJsNfdN?=
 =?iso-8859-1?Q?zLgfn7YujLF5R4IKx57a9nPKUPc6o7SPzTgyd0KqfnAH72vJwqT3esWPHn?=
 =?iso-8859-1?Q?73EWL0r+lyMAYXI4W1+MDoyjHwt0yDFiw5lrQXyMzY/nikKv7HRmRGrDL4?=
 =?iso-8859-1?Q?IGyVBHB1WrBnkHv2goSO8ZQs2id0aRG8m0IRXUXrknH2icW11Y9WUO3OhO?=
 =?iso-8859-1?Q?KsVxAjzbylqOMwdUAJEZSLxvFHZ76qEaI7/hSkgADxt8g8k/EWIerPADTm?=
 =?iso-8859-1?Q?WoCX8bs/Cn4Vr1Ujao/MAWauBgZ/ztst2fVBmWuxHYP+gwmTm1xPdJFz7f?=
 =?iso-8859-1?Q?8AqwBYeGBepWg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:45:43.0315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5270352b-2902-45c3-c1e0-08de10869a29
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10848

If there is no in-kernel irqchip for a GICv3 host set all of the trap
bits to block all accesses. This fixes the no-vgic-v3 selftest again.

Fixes: 3193287ddffb ("KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-=
v3 or v3 guests")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/23072856-6b8c-41e2-93d1-ea8a240a7079@si=
rena.org.uk
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6fbb4b099855..2f75ef14d339 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -301,7 +301,8 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 		return;
=20
 	/* Hide GICv3 sysreg if necessary */
-	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
+	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2 ||
+	    !irqchip_in_kernel(vcpu->kvm)) {
 		vgic_v3->vgic_hcr |=3D (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
 				      ICH_HCR_EL2_TC);
 		return;
--=20
2.34.1

