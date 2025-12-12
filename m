Return-Path: <kvm+bounces-65847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9EBCB919C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D25CA303A8C5
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C1331B800;
	Fri, 12 Dec 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f24uBfxR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f24uBfxR"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013043.outbound.protection.outlook.com [40.107.162.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4181EDA2B
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553028; cv=fail; b=NTsAvW6EIU8xxOua+LFrdU/WuR3sWwv/R0qccPOmGDsd4LkDJ9hLnu1TEdiKjDM5uRH9o37Apas9q2d4AUbkEICeolTbeaK8zCToGIoQ4BUfM9hJwK1LG7TEkDxrKlWOycQ3m2xmAsaNXxylPxO3AyJDKGujMGeqUZMD/cE9TM8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553028; c=relaxed/simple;
	bh=sscZRoe+0F9NkaCevgy1+F1s5l5ZaX4jC+YQsZ2B/Mc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S8gqsCZ08mfE+R/bbSoUQTIAiLSX1KwcTPCjQpGZxPV4TOSNB4AuDPOYg3DdfO9xicTh9MEkWQtkp4q6e8Eaip4EYgxp/rr6YRO0Ao9Cj21ANFSQYweVUjpuxZxvTwGPjeV/gmtMn0S4DAnlC+rULb2Dw/xLijmUkIF9rPM3CKc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f24uBfxR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f24uBfxR; arc=fail smtp.client-ip=40.107.162.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=s2n7Xi8Drr7VP6LdDHwRC1COgGmERWa/yWDJcof+MNxCPm2moYsCk+MxGRcCSamgPlyFJVGjy8aXGjIhIjbNnuQKQ+kjODcDbErUNO03Dd8hmF+YHM5PtsGzI93JjPD5mdx1pYcsuMp/PfU+IAXzetJWx8mYkg+3iDtbXUo6wRV+fsG7MPhDpHKwq3Oyg39qpMPb+vesWkcqdT422xFN/l3legqWVqc8SDIYxuoyZcNvqpR3AT3BKLY+54bUuzDUv03YgikqvlxN4UqRJk2+3T6xSz1Uk0RSQLCoQ4NgVT5ijSaS4IDJNIb3R61CbtPPYBlGCbNXUeDpxR2wfPOiyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lay3i2rYdc5bNcQSdHGcdN8t3HNyFM9WzdCSrMR2yY=;
 b=Pxm+8sN2ccbNN82tiUqtye+o0IsBr8FbtELPtrEwtecNAgj779kN+69KlDfy1pwwiBI+lA0zi5GRckFko7UYTibBONWqccl1VoWaaW+oOm3IBF0TozwYQvH8QPedMWa69YxraJ9lRnL2QfQly7j/GlA0/eVhGwHkHIDv8rRS6zxvEonS9Qw/PQ1vjMo63gj2HnJOIDNIeKmldyJw+xR1zWm+/eR1z3/vuVTtuFPeqjRTQ9Nt2PudLLWUKRyeiiOCHWmGTmDMaH2IzTcMy8baWacL2Xd+nTUiojm7OJguLX/u42m9inbmf/G70mmed1+8aCmRvhtonNHDzFHkR3jZHg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lay3i2rYdc5bNcQSdHGcdN8t3HNyFM9WzdCSrMR2yY=;
 b=f24uBfxR0SuBRQyUSxuSuNWSw13yi7cS00ahV45q0BDKBxl9tIlSGhX2fJR+AWcyyK6m4czlckJkN1CT0cBtqIr1vGA1erGZPRPyD02jns7+xbT/iW+lNdNPApiqKVIjEXEAuNO+4viEt1BaTEhsM6ONF+1wvP2sUgeeWxMulgE=
Received: from AS4P189CA0025.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::15)
 by AMDPR08MB11386.eurprd08.prod.outlook.com (2603:10a6:20b:716::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:40 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::24) by AS4P189CA0025.outlook.office365.com
 (2603:10a6:20b:5db::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzLwxSrXhy+wNe7nx8CYRm+k93Jp7HQKAlyvA1CzYa5ymxAhakgn6e5rG/KsvnPK7/EQSdH2J1rS9bmXBgcbjFNPP7vKqy7/Mu35wIAwYFIRRkzYqJq/szO2iqSPOkOQCmjjHtaAYqd7n2aVeMxnUV7NN1zZo25NemO9xl7j+W/RYZW8fxstENSl0Dv/fWWEN+xQTGebzemEmZPgGl65/vewrYlE2UwzchdiRJC+e3ihWPLsQM/KVs1kKqNxNj5F8i+2BY2O9F1arqKUSOMoeqwYZzO9IcYoJxY7Kf5tyTvAHUYcdp1opvFAab/bajbRy7ol2/VCYJWckW/P3e+I0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lay3i2rYdc5bNcQSdHGcdN8t3HNyFM9WzdCSrMR2yY=;
 b=kI/KGUWHnRJbDzCEXAx3y2QI/1YVg0SP185JqBaBObF2lbl7LwTvJQvBdTnALPLfSWQ1qWGKDTZ3z1ZCgNObp7QLQZhrOcxp23mW3hnYDteMr7TermOyX4eYpK8eQMo+TB5ToCIXKUBOwrATXH+NgrfB8qbD1uyowCnaddH49mBs4t7L8AOTs5BVT1uxzcKI7o4HKcTL+RhFCHzY68U+sUa7f9f74w6BUh92bipZhu9sa29Ob5zz4hCtNIRjVpsFUxlgq4q8xIAZARPdv948DEMcOqWvMxBBs/iNch7w6dO04f8HPXB/+ejYiYmViSo8EGQcpTHRtusbJHlSthq3rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lay3i2rYdc5bNcQSdHGcdN8t3HNyFM9WzdCSrMR2yY=;
 b=f24uBfxR0SuBRQyUSxuSuNWSw13yi7cS00ahV45q0BDKBxl9tIlSGhX2fJR+AWcyyK6m4czlckJkN1CT0cBtqIr1vGA1erGZPRPyD02jns7+xbT/iW+lNdNPApiqKVIjEXEAuNO+4viEt1BaTEhsM6ONF+1wvP2sUgeeWxMulgE=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:37 +0000
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
Subject: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Index: AQHca3slbeKJlkPOlUaF8+aOc+XY6g==
Date: Fri, 12 Dec 2025 15:22:37 +0000
Message-ID: <20251212152215.675767-8-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AM4PEPF00027A69:EE_|AMDPR08MB11386:EE_
X-MS-Office365-Filtering-Correlation-Id: 41ffa896-f192-4d64-51bf-08de39926dd5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?bak1UY+oEz+1enF/+7fF/DCzfhL6+TxonqFsinfHKVdCvjZO7RCWswiJid?=
 =?iso-8859-1?Q?3eN6q0UPMBDTkoj1NFo7mkVaGa2GTDmLDhbpohjDTcRfKrrxSjZVhU3Q+m?=
 =?iso-8859-1?Q?FO23eSlo27KRaqJBnDIQvRLqtX1W25+zaCv9hZ1LPBUS53GV99ZRg2973A?=
 =?iso-8859-1?Q?Aasulk/2x6uzBk1MNDFh79NhNFNtaPvQXSGsr4RgvbO7nwQZG8/TnrF1yh?=
 =?iso-8859-1?Q?i7ofzMP2hnYkFsBFxGi4bGDUa6E36vtECzF0ngnVtOXc1pN/qZgWd40IZU?=
 =?iso-8859-1?Q?xT2fldNx7d6cSyU4geJU5D4ewfNYp+yIwp/bEh6d92a+d0gPh3lK7j9KgN?=
 =?iso-8859-1?Q?0jwykGCod0lYW9AlbC1nwZe9FK/QVKjxVp0HU3fY2+viVfDsteyixlObo7?=
 =?iso-8859-1?Q?yCUwWC9ntzer21oI68IQ55el6lEk8UVjwy8RtxF8nz99mNEXag5U4EF3jm?=
 =?iso-8859-1?Q?8Mh+NK+iocPK6eZXgpSM3Bqdl459kMQaNCMF/u/EUbNcR7RjR1lHNkSZap?=
 =?iso-8859-1?Q?2wsEHtCs5rKNb3Yd9a7q00niKBEujcOdEpK4uS9hadfEjBS+jobho00hBC?=
 =?iso-8859-1?Q?LdqmKzGHLwIoeJxCA602e91cpkm+JMc+nVXiEot7+03sN1GIoy39++gu2i?=
 =?iso-8859-1?Q?dUMY12pHfmX4SjquIZO1czDASAo8/v31PIcbXprj7aNVICOZMBT7w9GxHW?=
 =?iso-8859-1?Q?UIm46pxVEpcJunT4hLjrhQObtcFAQUEcauvJFVLGwmc8gpqmTKV3oCRv9f?=
 =?iso-8859-1?Q?EhjEzD0yVm4zZLtB+1L2bF1r55+mJVrwt2HhCb+wd5A6xtBFiZP0wpEZsp?=
 =?iso-8859-1?Q?u9PWiBY+jysf5a8BLRkQvQwG9jqQ+MOmd9n/Kp/NV+SsmfqhibHBdvhW+6?=
 =?iso-8859-1?Q?6/VKGmL64XLgTLVsa0fF8b7EoqC4qAJWY+gp2F1O/pkTkBJ2zFvAbFLS79?=
 =?iso-8859-1?Q?YxeYlV3YY/fj64HaUq+ICtSK6hxy0mLH2uJ1Kl1MWFDLgr9kly1nAK39vk?=
 =?iso-8859-1?Q?9nVLrjb7RdLFfpVaoQvRLDhvM8GM/aFkQekvELgTI3RMZfLiixkwkEsrpT?=
 =?iso-8859-1?Q?yldgkxJpoFenisAR51SMPI4/Hij42h//LsB2Wf97Jn3mXNQb9JV3goFZzX?=
 =?iso-8859-1?Q?WHcKvgzEvS/EGdqGqT5AMmCULPZbXlgCpTTm8rpkceV3wp93nP73G1FkTj?=
 =?iso-8859-1?Q?l1TWBiZJvVyHoTNbbLgPoW+S74g0afUkuWjAin8n1MTm3gZReDpIJ21xwQ?=
 =?iso-8859-1?Q?GlcdjuPrD+NJcy0yFDtZVCRecLBU51AFLJ9CLQh0ks6lrCoyJct5pUOGZO?=
 =?iso-8859-1?Q?0Go0BiKiHWide9MI6MplDZ+TYIGlrZI+93OVNhVoY3YJfLJZuqV+oyJb+9?=
 =?iso-8859-1?Q?pUT+w6L/CvF/6MeULjKhSgfYAdSuLN83aEl5BW/8Dso0/OM2bU2R5wh2T/?=
 =?iso-8859-1?Q?HzVJnjY0d5S/n1odHeyWQ0DfFCe+5PGcingYJWdMEFfJf9K0rh3RwTvTus?=
 =?iso-8859-1?Q?RJa8xI+zZGF33hR0IsLuYKHGASt0d+Ts5MO7don2V7HALYUv0gwmww3a4k?=
 =?iso-8859-1?Q?6YagERRQ1QnhLcJjx+CW9DKp6vQb?=
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
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b995a7c8-05c6-438e-2363-08de3992488d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TGieoVyg09NK3vJcJ5pKRBvR7bKghXkerLrTyiIi84mqUhdldVj3Abep7b?=
 =?iso-8859-1?Q?riBoXKKXdkzOCb7AYNvAEdoaqHJPW66UieoEBRAKubfsW/YAWba9ajyLK9?=
 =?iso-8859-1?Q?hq6jMWfmx2ij0tSwxMCaXB94G1PlyoABUbzz1ZQHg1/0C8D/bWLHrUP+Ri?=
 =?iso-8859-1?Q?GLQBI7TWH6SNyMEGoIPnXyPopUqziKW2xG4zaQ6YNYumylQc5HHooSHZhb?=
 =?iso-8859-1?Q?Lj1RSUdlE5trGjQJ3d+NVxyZVgNSsQXbJIosvtsvjL98v1o/KWJnMA9y53?=
 =?iso-8859-1?Q?L2oYUHhlFu1oG92sZ2bQkyVh3S3IWby9WLF85lOpAhfY66wmobnnwWSW9O?=
 =?iso-8859-1?Q?K3EbWlhaeup2gxBgvPf6Y0Xse5r0sOjSe/MOTb+BT52tXBfNmtodINowyf?=
 =?iso-8859-1?Q?oML78U0TPl/vK264XU1AMCxSWsYU7gW3HwNVn5/giiscMzfaIc7nU/kJHC?=
 =?iso-8859-1?Q?oNKOlCbEJ0/JymFYq7NXkLFGFZppOs3LPa/uvE6AmMROlDLuueV2eVgKcS?=
 =?iso-8859-1?Q?TX+o+XhzEQfBLjpvgZ1090Zy2vh07zAkLxlC/gXjFCfFhhBEav4VY0jBSI?=
 =?iso-8859-1?Q?7Cl41hLq4CfIYMbrvbx/YVj2nfVOcLQT8pBYCvY96ogKXxAaXRjDOysU6/?=
 =?iso-8859-1?Q?4qY5Vh6ABxjVytBrtfsOshDqz6ZmGw97ARjgReNWX3IYcgE1XoAN5nWlpP?=
 =?iso-8859-1?Q?p6fu8Fwxn5AWtd8xa68pQWHoyBQlsWYuWKznbBNxZK1y+dglWYHwyeVU28?=
 =?iso-8859-1?Q?1yAW8mEaLwNpJfzCKuAjowIfo14WkxFEJZRXmZYZvrWsxU1Q3GA673TBEN?=
 =?iso-8859-1?Q?jdwYw+L8yTxTxIeqLzdEF2j+SDdgtt95zf5Niwu5AFpwIgU4kQ6cCatNJE?=
 =?iso-8859-1?Q?fK58VD4GNJntblSOC/yB8MNFTdmfFmlzEHIEMIterukIhvItym7Sx9M3Sv?=
 =?iso-8859-1?Q?rL1oIGU3ReyVTky1wHTxUtJTWCfcwjkWby4inlrlT2C6NQJd0i9xODUZBs?=
 =?iso-8859-1?Q?19y7NFjEyKG6gT48Mo3AbwClcm52oRPf2VsTuH2ONksnOnSTtt0rrjNSpE?=
 =?iso-8859-1?Q?k4iUGm4IlyAgUAhLXbdBIyosnreqgsX3prfN+Q+VyYKvHD5nfTis5S89ri?=
 =?iso-8859-1?Q?aW/RIDawpcZoJQKcl5uxQWH9rgW4pds/qfh3dQvt5Sd3rocs8Z+atGq7Oo?=
 =?iso-8859-1?Q?9qlruoQUJA8hUFm4cy2eCdcEubgevGHGmai7xKQzirUyu+qdSUIPlqNn7h?=
 =?iso-8859-1?Q?lsObtqL7stfw0D28/vBXmorUPtlZZyyeVyOeXOOJb9QEuFUCDnPqJS1I90?=
 =?iso-8859-1?Q?1hq0S1VPLEvyFz0RnS1ZAc/mprefFKHCLwyboeEfrC8/m8DdV2JG41+egn?=
 =?iso-8859-1?Q?STzXD9qxiZO1mPQrs8RmemYlyLvvSpKkiVbEvMnAMVH2CeT6nSJ+Bnln6M?=
 =?iso-8859-1?Q?2l5m3nEG45wYDArHCYmuPPv0BL7Lhg1+fsYrLD8RdSf8VSbfxjpOUuwKX1?=
 =?iso-8859-1?Q?pkdG2PY46xfHX9K/aYQ8WWb2fY9r6ODDPEg45JDrjfHN2aKIUIuZmELuVR?=
 =?iso-8859-1?Q?oEnts3rwSzA2u5NcAenDzippVoqUOB+kbbxuDV/ZtNqAp9cn+McPJZdsmO?=
 =?iso-8859-1?Q?OcaK4lBor7MVc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:40.2881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ffa896-f192-4d64-51bf-08de39926dd5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11386

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/pmu-emul.c             |  6 +++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 14 +++++++-------
 include/kvm/arm_vgic.h                | 27 +++++++++++++++++++++++----
 5 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 99a07972068d1..6f033f6644219 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1598,7 +1598,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab9..0baf8e0fe23bd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) && !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +991,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1142,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fda..2c0e8803342e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d03..be1f45a494f78 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,22 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define irq_is_ppi_legacy(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR=
_PRIVATE_IRQS)
+#define irq_is_spi_legacy(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
+					(irq) <=3D VGIC_MAX_SPI)
+#define irq_is_lpi_legacy(irq) ((irq) > VGIC_MAX_SPI)
+
+#define irq_is_ppi_v5(irq) (FIELD_GET(GICV5_HWIRQ_TYPE, irq) =3D=3D GICV5_=
HWIRQ_TYPE_PPI)
+#define irq_is_spi_v5(irq) (FIELD_GET(GICV5_HWIRQ_TYPE, irq) =3D=3D GICV5_=
HWIRQ_TYPE_SPI)
+#define irq_is_lpi_v5(irq) (FIELD_GET(GICV5_HWIRQ_TYPE, irq) =3D=3D GICV5_=
HWIRQ_TYPE_LPI)
+
+#define gic_is_v5(k) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VG=
IC_V5)
+
+#define irq_is_ppi(k, i) (gic_is_v5(k) ? irq_is_ppi_v5(i) : irq_is_ppi_leg=
acy(i))
+#define irq_is_spi(k, i) (gic_is_v5(k) ? irq_is_spi_v5(i) : irq_is_spi_leg=
acy(i))
+#define irq_is_lpi(k, i) (gic_is_v5(k) ? irq_is_lpi_v5(i) : irq_is_lpi_leg=
acy(i))
+
+#define irq_is_private(k, i) (gic_is_v5(k) ? irq_is_ppi_v5(i) : i < VGIC_N=
R_PRIVATE_IRQS)
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -418,8 +432,13 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
+#define vgic_ready(k)		((k)->arch.vgic.ready)
+#define vgic_valid_spi_legacy(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi_v5(k, i)	(irq_is_spi(k, i) && \
+				 (FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis))
+#define vgic_valid_spi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE=
_ARM_VGIC_V5) ? \
+				vgic_valid_spi_legacy(k, i) : vgic_valid_spi_v5(k, i))
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1

