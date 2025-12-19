Return-Path: <kvm+bounces-66402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CD20CCD11B0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9018F30D9854
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706333845DE;
	Fri, 19 Dec 2025 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V6cMVo2D";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V6cMVo2D"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010001.outbound.protection.outlook.com [52.101.84.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070D3845BE
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160861; cv=fail; b=rmGw219OHEacYP6IesozKuzqfvOQxacF2L+bP/FHGW8BbDrk658DvbFwPWddgNYiCg/HZyh6UtpZbnptTgsRVCs6IsXMvcT1tPWXe4g+3EY2bp2qGRPBEvJBymjeGviBvLM1yGP4DgdqIDTMQ4R6XQ624Oqc6KlRne4thYLgw0w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160861; c=relaxed/simple;
	bh=R6hcmL7BjLe6Uv6BxeCK8YapvGMrqUwId4kqvglBM6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DlnqHDo41wa/sl7uzHsweOXmN3i2XMm8pdkvgltci78viawxjd4zgZlPCvFv/xeMOOCgAl5H1mP76kGmrEcrC9B79ZnlT+Ly2CVu5WmCMO85v2lTyLjFUAaX9L56KjW1qUnN86Upo0iu53DE6jnP09bioVmmvFbpS8Y75wvZe8o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V6cMVo2D; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V6cMVo2D; arc=fail smtp.client-ip=52.101.84.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WrSG2OSbgeYXc/F9qYJdGBGPE/qiiCeYMy/qf88c7LrzjcSiwFMoeQYJOdqcZazDG2X95G/l4ZAkBJLRuMEzHKmapQgDUx8D/i5ofSqLwD+l+1cR4rOGuw+KZ8ygENhJ3Pf5GIvHSJ7mdB5AqA3z9G9ExV8atP/LADnlHLwv03EYumVQ1/unnYGd9BaeCeVwW62byGysCnXDj7CGvUOC9V4px5yqlbiimYZPltYqL71nmou87GdEWiv3jZ7nRWrGJ38aCz3qxJ+hbeX3FGWQ6GJOboiWhAYkWNi1ym1Lrj8WlCbVhUx+vKIRFfmvys0lXruCO4Yi2x4zNlTOMUr9Dw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmycHXmRv7BnEALTVgC0lSujYZbm6fl0luncZvFT9/A=;
 b=YC3H65B2tjlRv6F1VD7c8Z3Z235epm+jcu/n23xuzrAZ8snVtSG1mLuV0mo/IFaZ4KC+64JKZJKhXywhDk5Hx/6Z7MD60Al1rZY/EuQLU0FWi3H/k1rOYN7GciBjC2pixKLC6RX+uwDfER8gFBbhSnhENpEezccCUNXDEIEpxg9Ye11flrnz4ybWd9PIEkWCUWUKPsbkBiBSmJOqFvqHB0GtpP+SKfFYn2WFH7D6ZKrq6ozZ3KaABcnNzJiyTX57PmcDepGmdaSKaMmNAOrVASvBr98n7WpREca6p/oEi7XhWoQoD7EkJ1Vf3wEKlPuJqz3QmoC6RC18AQ+VeAXYdw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmycHXmRv7BnEALTVgC0lSujYZbm6fl0luncZvFT9/A=;
 b=V6cMVo2D4WKdhrjgFS/N2SyeqI1I5vkH/rUtRN38jWxl3TnmbrW1JIGECKEXFsoUzW6p+dXQNCrpqYvwF094xK1a/X+8RSEsSfGyFcV3C9h1gP6yJpFSuDrB1+t55i2i3iDQAqs0ol+sxQdG96DL5Dv36BgGycREsty4M0cYGwc=
Received: from DB7PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:10:36::29)
 by DBBPR08MB10461.eurprd08.prod.outlook.com (2603:10a6:10:535::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:14:01 +0000
Received: from DU2PEPF00028D00.eurprd03.prod.outlook.com
 (2603:10a6:10:36:cafe::23) by DB7PR05CA0016.outlook.office365.com
 (2603:10a6:10:36::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:13:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D00.mail.protection.outlook.com (10.167.242.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=troJksCZ1awcVWAdI6nBVkW/NqaoDSZQzPhqh1OI9lbApaaDf6bSFM+3CwG9BmNCUBVBnAFRJudhc8AMEA1RBNXF4ueuvnToAd4n+/ctRaheGlbRcEdb9ftKWRgkCWlsvfxaObmydcgy+jTC2Z4BXG1L/PKDCJZkwu5AMYxcGgc0OHmmUoy1dhSiil5aL4iZ1zoPdn9wOzer09sgUzQsRfJHtex2nZwv3osX14oTd9rO+tjXthGy37ymbKaqAR1RfJ3gPTHAinMD06ZO7h3bfQCkBbU2c7MD16G5aJA+OYDK02ERl7hJsGXfYw/cVRcLI5+C36PoyeJTC+VyFwbiog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmycHXmRv7BnEALTVgC0lSujYZbm6fl0luncZvFT9/A=;
 b=vV9IvAPFN020DgCvI2/cvA30ad2NSywCXL8wrVCOrKvQmt/ypwFQvFmC88xUTlsXd3y7aLjVATeOjGwQ0UTNDlUhSbm4i/067fL0DHksM47Cs71oMVIqi8i61cnyPxPNF1guB69hQSVl084N08LzegiOwzWhj5GlbQYXZC22VAKKUK41aszNQo6C1UMS/c3WA+6pIZD9XYMWH3S1BgJYnku7sdHCIjZL+zCeq8bo5hdryoiwQHKXJuZPYWFlgD1Q9Cehr6zsou8PZhDq9ODYOeFZEtRjCpQdsRxnqcAkERzGaKxKD53XXWSB15XLKk1dQdzFe0QrZ6fqTAIxNE4Fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmycHXmRv7BnEALTVgC0lSujYZbm6fl0luncZvFT9/A=;
 b=V6cMVo2D4WKdhrjgFS/N2SyeqI1I5vkH/rUtRN38jWxl3TnmbrW1JIGECKEXFsoUzW6p+dXQNCrpqYvwF094xK1a/X+8RSEsSfGyFcV3C9h1gP6yJpFSuDrB1+t55i2i3iDQAqs0ol+sxQdG96DL5Dv36BgGycREsty4M0cYGwc=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GVXPR08MB10452.eurprd08.prod.outlook.com (2603:10a6:150:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:12:54 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:54 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 01/17] Sync kernel UAPI headers with v6.19-rc1 with WIP KVM
 GICv5 PPI support
Thread-Topic: [PATCH 01/17] Sync kernel UAPI headers with v6.19-rc1 with WIP
 KVM GICv5 PPI support
Thread-Index: AQHccQJV/ZPL2MfS8E6/ZGYwdch7eg==
Date: Fri, 19 Dec 2025 16:12:54 +0000
Message-ID: <20251219161240.1385034-2-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GVXPR08MB10452:EE_|DU2PEPF00028D00:EE_|DBBPR08MB10461:EE_
X-MS-Office365-Filtering-Correlation-Id: fa01b5bd-9543-4a73-7d94-08de3f199f14
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?SmN0B/PjjjTpfRX2L0MrYimF7dzMInrLs874wI9FaKMLXwZ1cTFT6u3hZi?=
 =?iso-8859-1?Q?7CCkECYoUcWhJt8/zYwd1B4reIPgRZ3vRLGqBj0yLSV/YDhnNOOL8nbUVW?=
 =?iso-8859-1?Q?uDt0JqkrsECHSZLbgiD4q8C9j/jvb25tXuVS3f/qgKnIb2wpmg6plEjLXi?=
 =?iso-8859-1?Q?AV7a+2VDlJjChoHDAGk+ruLGGnNsNc04alMLq8cvFavhUr6WkLQzAxsEUA?=
 =?iso-8859-1?Q?6y6vwZFB76vPXXI6tTM+mLvyFTDzUogP8Lt9obz3jq4Ixj4p0ETis5xND6?=
 =?iso-8859-1?Q?oXRVbx6mbEbwLS0xRNFYAby4dUzCOGyFrR7CO8gAKikhBPDN5cqbFJjyL3?=
 =?iso-8859-1?Q?pf1+K3s9eVHaeqRx/n+2pfNNQX1VSi1NfXy1GjEG97FlGyrY86rq5mGzff?=
 =?iso-8859-1?Q?/kI8EY3Bh1R3y5tCgM+HaxHa1zDwScRoGYOcjxmgltn6QpK2FDlbOrJZPK?=
 =?iso-8859-1?Q?lTjGJf7LPE0vwUdWXYHR3q/od5MzsVqfVD0R+K6ZJRoH1Ngbf9TW963AbW?=
 =?iso-8859-1?Q?uf1P4rdzYnS+zApsLdpdccgiUDUiWtxzsbyPzsR+UZyzxkMNxI8fa5bInk?=
 =?iso-8859-1?Q?0xpS/DMqBLd4duILLN9vlDg+nlddW5WAOVy0xVeDgJh4q8zfSvb0IMTAT3?=
 =?iso-8859-1?Q?BOq18VQg+nxvE6IWBh69L3cuzXEhJKSixGEIKcQbTSDTdvpjHFl2nYKoFD?=
 =?iso-8859-1?Q?lss31mZXTcKiB8TE0rS+pETRf5ClKYL7JQ2ksxTwcMLHk8CDvwnzqWRUmf?=
 =?iso-8859-1?Q?eUKv9SLpJRPnPtauLH/QQXlZNfQcic7/zv8XEBbBNpTUlWuGDcm/qj1FuR?=
 =?iso-8859-1?Q?QJjclrP1viZBE82I2mb2K4ILNGj1ur7NRvXEb9PBVUE1XZUBUUVspX0hSn?=
 =?iso-8859-1?Q?Q4sYsWNLvrYgq+D6nv4EIyEodXwFg7g94e3kVZ9o8iz785GJI5uCkyOgYJ?=
 =?iso-8859-1?Q?/3V+/is37LdLWt/kNpVJvCasKlS+rFj2uvGjEFTKbVfJ5voYQKnrPLGnJe?=
 =?iso-8859-1?Q?EAP3L1hw735TM3QdEjEO/TYfk3vy0xeqnRtjrj0TtMNb0bKs1xcAuS465D?=
 =?iso-8859-1?Q?eoXjLcVg1YRJfsOdDO5V7igx4kY9+tZcWSvFnPT+UGiXTcycbPEIdGISmv?=
 =?iso-8859-1?Q?svZVTDfw1CKLCtjcirJ6C+cMGMTaZyHJCbGTsK1cShcJhNFJG2hVbBXfUF?=
 =?iso-8859-1?Q?eMVgF/VzYYy+BVWkaR4UitBo9HUcUnePGES25mJJP/2leECASjLh/oL9BS?=
 =?iso-8859-1?Q?rx20En/qMZvUIemiTgpmXDCNFPXimqDhirHwvcI8t6gvGbIhHkC8VVhZKn?=
 =?iso-8859-1?Q?UMLq5T/Ou4ILuNw1hQTrqNbGwKSDPVKjhGppKxwqYFscngJaMx/+AEhVBO?=
 =?iso-8859-1?Q?zHbfcR8lfDDR6IvMgmmd36tS41Xk+tmcfOyehlQaSdOMPsq1IOJUZRdITi?=
 =?iso-8859-1?Q?d3D3K3MeRvz5B6lLpml0pUO15pUGwH0LFCzJOLRvv5OlCtmUaX0cKUxkxv?=
 =?iso-8859-1?Q?xVG0O5+JUBu+vvY7za6yjnnnQajJP3FoNO8EZJmAHiaLahgs3esBdR7M20?=
 =?iso-8859-1?Q?pVz6z1xhBDKsFnSCtFnZAgltIk1j?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10452
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	32e0041d-19a9-4cbd-8dc6-08de3f19778d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|36860700013|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?EUqBfYwf60c8u64LK0HOzfRRk6v+Lb3x6ALJnzHWicotXzBDq1HMW6kfif?=
 =?iso-8859-1?Q?bUl/MiV7Ujk0YkdFlm19O7Z4nrSweZxC180lDbRKn3qEzL9hWYv4aJ08x+?=
 =?iso-8859-1?Q?OVIzaZlWWPJpmGClEztz+DD4vhn3NS36G2+aD0//xKC1jwtsb7rk0sV2IB?=
 =?iso-8859-1?Q?ZiBhIY5Cfg1H+1t3A8lLbLelJ1PW16dRufJkBl1PCQpk9+50uHZUkTj1Ni?=
 =?iso-8859-1?Q?cqe7gfku5GAHX5E1KOv1Xtn8aOgQgJvj7vwjPKQswr4dG7YPhZfJFAFUMh?=
 =?iso-8859-1?Q?oxSMp58kOOxaTBQSVeT1IwqKUvL+rLPJwZsxmh6VP2+mg6hsVI/IbNYvjk?=
 =?iso-8859-1?Q?5ibYjf3IsNRnaW9cc04TsDQaEFbpsKygIjhaWR4u2Wrzo0uodwFWmvjELD?=
 =?iso-8859-1?Q?wsJP4YjG3Lliq16nDj8nk1SeQQNaq21JYPJ9cbq9K3CZ6ktXlxw5ZEbf7c?=
 =?iso-8859-1?Q?NPL7eOR2cwQziCG99vQ9vAwXGgpn4p2/RlbHKvqMJQuXZJtVly1T3IcDOX?=
 =?iso-8859-1?Q?FXY3VjluRNZUiDsFC5mheBrHkBptBDyRYBajh5Z5LSSnUEGWxFgE50ExV/?=
 =?iso-8859-1?Q?3+tPOjeMh0ZyUXV0yjGoBBj+uTtZhAVOj2KLtgFYJyrx85eUyZT5Gt5X51?=
 =?iso-8859-1?Q?Rs1vKMiEO/x8rrWThtDesWey+cKmGV1gQ1CuBEA+Q/lIIK4QBL56jGkVNl?=
 =?iso-8859-1?Q?+po0qizCANwtLcEfLG5GvIWhFExuqWUYfKDJ6Bnff9rqO5QCUfUyGE/OeO?=
 =?iso-8859-1?Q?y1uPp+s9WMdCoFkn1uyhUBI40K449iMWkypC8QGhCeykpjJpYmnqO942zI?=
 =?iso-8859-1?Q?tYq+cxZuIbyVhY0YQUMbQFlZg3uwGC/NhFbSFHDeVVSKxWfCZiJ13N9NV2?=
 =?iso-8859-1?Q?8AIleeXO+OKEVWmJXIXgAwAxdnz5yrNfmFSN6dPDlgSv/Z3b8l8vRRnEjT?=
 =?iso-8859-1?Q?PXW75AmcUSrgyK1BhHqwEpmlkrtljD5YxHJcbuS/ovHL8PNarWx/WdteyN?=
 =?iso-8859-1?Q?bdC0hDWaV9ccv/mtpV+ZmOagrj9V3iydM1eVVlfjzGyqnwTBj/r+E/gc5q?=
 =?iso-8859-1?Q?3uuj80wky08160w5KFvgOVXlSN1vZ5vu3/PlPi63NvzD91noFskAAYDZY6?=
 =?iso-8859-1?Q?nP327sh8OrWmDyS6c3M2v1OtjRwkslh4N3Z7JlsP7KoCr9dmdFbbO0Y5HR?=
 =?iso-8859-1?Q?LquVx2UPgG90cfSZvQN8OwHxbGPlzwQv4C+z2WNitML4fjStyBCs7SYzrN?=
 =?iso-8859-1?Q?F7GERlDVNTRIpQePdP7OOoKGwF2In7MTuIPuc39R3qovNfLgP+vc7Y6arO?=
 =?iso-8859-1?Q?YnMscv/J21oElFKIFZZ5My8O06xkHTiL25QyaXLcHMDT3byCq66zcbti0F?=
 =?iso-8859-1?Q?GCWTZ+7+YV3jHWTx/OPU21Y+YL98nsp0Vsh8wSfCSJGRynpg7nqmiSDir5?=
 =?iso-8859-1?Q?ABJQdO6PMfdC6fQmHGFOC4/Cl0AZyeyAExfH0XVwZ8JShPvhBVPlGoxtG/?=
 =?iso-8859-1?Q?7fs15QEVZf7Xl8HpMZp4Z9zHrSnkDvq3+W0epaJK8MQl+QTssotPnTE164?=
 =?iso-8859-1?Q?z+UhxFg/KUganvu3C/GLxEycsgUtaj8VDOQd5XvOtuky/aWMuOTbzdTipF?=
 =?iso-8859-1?Q?MFUuCWRbYCTnI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(36860700013)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.7756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa01b5bd-9543-4a73-7d94-08de3f199f14
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10461

This is required for ARM GICv5 support. At this stage, only PPIs are
supported as the creating of the IRS and ITS are not imlemented in
KVM.

This change needs to be refreshed once the GICv5 KVM support has made it
into Linux. For now, it is based on WIP changes.

Change generated using util/update_headers.sh.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h    |  3 ++-
 include/linux/kvm.h        | 18 ++++++++++++++++++
 include/linux/virtio_ids.h |  1 +
 include/linux/virtio_net.h | 36 +++++++++++++++++++++++++++++++++++-
 include/linux/virtio_pci.h |  2 +-
 powerpc/include/asm/kvm.h  | 13 -------------
 riscv/include/asm/kvm.h    | 27 ++++++++++++++++++++++++++-
 x86/include/asm/kvm.h      | 35 +++++++++++++++++++++++++++++++++++
 8 files changed, 118 insertions(+), 17 deletions(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index ed5f3892..1c13bfa2 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -31,7 +31,7 @@
 #define KVM_SPSR_FIQ	4
 #define KVM_NR_SPSR	5
=20
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7a4c35ff..f7dabbf1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_SEA          41
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -473,6 +474,14 @@ struct kvm_run {
 				} setup_event_notify;
 			};
 		} tdx;
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID	(1ULL << 0)
+			__u64 flags;
+			__u64 esr;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -644,6 +653,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
=20
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -960,6 +970,10 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_SEA_TO_USER 245
+#define KVM_CAP_S390_USER_OPEREXEC 246
=20
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1195,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
@@ -1596,6 +1612,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
=20
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest=
_memfd)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
=20
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7aa2eb76..6c12db16 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -68,6 +68,7 @@
 #define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
 #define VIRTIO_ID_GPIO			41 /* virtio gpio */
+#define VIRTIO_ID_SPI			45 /* virtio spi */
=20
 /*
  * Virtio Transitional IDs
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 963540de..1db45b01 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -70,6 +70,28 @@
 					 * with the same MAC.
 					 */
 #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO 65 /* Driver can receive
+					      * GSO-over-UDP-tunnel packets
+					      */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM 66 /* Driver handles
+						   * GSO-over-UDP-tunnel
+						   * packets with partial csum
+						   * for the outer header
+						   */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO 67 /* Device can receive
+					     * GSO-over-UDP-tunnel packets
+					     */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM 68 /* Device handles
+						  * GSO-over-UDP-tunnel
+						  * packets with partial csum
+						  * for the outer header
+						  */
+
+/* Offloads bits corresponding to VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO{,_CSUM}
+ * features
+ */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED	46
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED	47
=20
 #ifndef VIRTIO_NET_NO_LEGACY
 #define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
@@ -131,12 +153,17 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+#define VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM 8	/* UDP tunnel csum offload */
 	__u8 flags;
 #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 0x20 /* UDPv4 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6 0x40 /* UDPv6 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL (VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 =
| \
+				       VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6)
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
@@ -166,7 +193,8 @@ struct virtio_net_hdr_v1 {
=20
 struct virtio_net_hdr_v1_hash {
 	struct virtio_net_hdr_v1 hdr;
-	__le32 hash_value;
+	__le16 hash_value_lo;
+	__le16 hash_value_hi;
 #define VIRTIO_NET_HASH_REPORT_NONE            0
 #define VIRTIO_NET_HASH_REPORT_IPv4            1
 #define VIRTIO_NET_HASH_REPORT_TCPv4           2
@@ -181,6 +209,12 @@ struct virtio_net_hdr_v1_hash {
 	__le16 padding;
 };
=20
+struct virtio_net_hdr_v1_hash_tunnel {
+	struct virtio_net_hdr_v1_hash hash_hdr;
+	__le16 outer_th_offset;
+	__le16 inner_nh_offset;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index c691ac21..e732e345 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -40,7 +40,7 @@
 #define _LINUX_VIRTIO_PCI_H
=20
 #include <linux/types.h>
-#include <linux/kernel.h>
+#include <linux/const.h>
=20
 #ifndef VIRTIO_PCI_NO_LEGACY
=20
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index eaeda001..077c5437 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, US=
A.
- *
  * Copyright IBM Corp. 2007
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 5f59fd22..54f3ad7e 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -9,7 +9,7 @@
 #ifndef __LINUX_KVM_RISCV_H
 #define __LINUX_KVM_RISCV_H
=20
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
=20
 #include <linux/types.h>
 #include <asm/bitsperlong.h>
@@ -18,10 +18,13 @@
 #define __KVM_HAVE_IRQ_LINE
=20
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
=20
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
=20
+#define KVM_EXIT_FAIL_ENTRY_NO_VSFILE	(1ULL << 0)
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
@@ -55,6 +58,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
=20
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -184,6 +188,10 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICCRSE,
 	KVM_RISCV_ISA_EXT_ZAAMO,
 	KVM_RISCV_ISA_EXT_ZALRSC,
+	KVM_RISCV_ISA_EXT_ZICBOP,
+	KVM_RISCV_ISA_EXT_ZFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFWMA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
=20
@@ -204,6 +212,8 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_FWFT,
+	KVM_RISCV_SBI_EXT_MPXY,
 	KVM_RISCV_SBI_EXT_MAX,
 };
=20
@@ -213,6 +223,18 @@ struct kvm_riscv_sbi_sta {
 	unsigned long shmem_hi;
 };
=20
+struct kvm_riscv_sbi_fwft_feature {
+	unsigned long enable;
+	unsigned long flags;
+	unsigned long value;
+};
+
+/* SBI FWFT extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_fwft {
+	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
+	struct kvm_riscv_sbi_fwft_feature pointer_masking;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -296,6 +318,9 @@ struct kvm_riscv_sbi_sta {
 #define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_SBI_STA_REG(name)		\
 		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_SBI_FWFT		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_FWFT_REG(name)	\
+		(offsetof(struct kvm_riscv_sbi_fwft, name) / sizeof(unsigned long))
=20
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 0f15d683..7ceff658 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -35,6 +35,11 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
+
+#define HV_VECTOR 28
+#define VC_VECTOR 29
+#define SX_VECTOR 30
=20
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
@@ -411,6 +416,35 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
=20
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg =3D=3D KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size =3D (__u64)type << 32;					\
+										\
+	type_size |=3D type =3D=3D KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type =3D=3D KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ID(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_KVM, index)
+
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
@@ -468,6 +502,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
=20
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
--=20
2.34.1

