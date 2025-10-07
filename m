Return-Path: <kvm+bounces-59577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3F6BC1F02
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 17:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9523A3C4E6F
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 15:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036F02DE200;
	Tue,  7 Oct 2025 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QxkTequf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QxkTequf"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013016.outbound.protection.outlook.com [40.107.159.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B291CDFD5;
	Tue,  7 Oct 2025 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759851361; cv=fail; b=UdKPHOr3TUwsnrxHy2T753DYMMtzi7iuBz4YB2Y7X/I5Bfn99uConQONwHhr4T1dxwsLkXD5t07xNcmgUMZ40JLls1j130i1GuPDOaX8k/xwFhBNSOXq9zneSwdCYEJAHe64DwMgZfNj5o18WTPorV4p6qj3yR0DBX5PRo60VB8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759851361; c=relaxed/simple;
	bh=5cmrxOYnMhgY4T78VF1mfpAiL1sDO8ojM33GKLYM8Ls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FeNmLSe0qaeKyACMSBPpGlJSpOAiiVJYM73Vq3PDoXez7DNi0E7YDqRkjIGC6oTPiQeu0fUbL1cPisFmVrx59lDy2jx9R1tU10x80b9zq1HAg96h9wWDombjPuHaZwcShI46ckEVyRfoPl605bkGbGp0N/V54mBAUeeYiyjqd3E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QxkTequf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QxkTequf; arc=fail smtp.client-ip=40.107.159.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WGj2JqBoEjAMB+c2x1Pn9V6PR8iBdBptOhIJ2zwCbG+kPZRIBjKJPrBn/fSI2fY9ZYopu+1+NP4SYpro32OilatRI1xkkYOQqDO9FPhRRCL1Gl5JS39nDP2EDHTjU6rF5HPEcCLhcJRBxgLcVMcEZw1fTNim5rg9xqjhBy2ujcfsAc3V8FcvjGoGzaE9Lhr+sgdn2lhHfbweLHfMCxM5oQswVx93cOv9d1lIqz1zN0BW5pE+Bmj0Kxg8CJO6uDGoHezAxdZEZdtvaqe+qJjZImmsJObio5KZR+tyGTx6Zm6LQpeNl8Zcs7yTxYukPTCmHcivDZ9RsvRJeiUt7K+Szw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEqYmqIZbfVY0YXKsD66bpQ94f0RbuJqeJhJxdP/pxM=;
 b=Rztn4fSDpOMLEVXsdQhSuBh9EbkgcOv04O/9FpcabL8YrzJGKIQlNwo/9qDfuZ6YsjrhfHAAm06t/Xc+bO2KEoRsP0ZBfCoD1kGRR370MVVsMvpITt1Yr/nQOs1dQSRuMzeRqIpr4zb4LIz64q/q1xqwgVt+X/YJ8muD6xaLDmeDaDrYknznJSbrbHp5d6HKNsly+sDCH0myjyBQ6e3Qbz64XYkigXzgtWJrcWlLi8moix6RRQoVZ1XXWuTHxyq0wVtwaK3E6HGZLjdXe6LHEk5ddsyeIlxPluhGfepmRm5OMmsfxsSkHApYxmGz6BuJB5/2m/Az5Rs3FVSd/Atk+Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEqYmqIZbfVY0YXKsD66bpQ94f0RbuJqeJhJxdP/pxM=;
 b=QxkTequfka5T6DBnKeMDwYj0zXWs66+EUbXmtDyTuVcxCfEORJtCqk+3d7GuMGb3YmeIO/OiF0jV5/T7e6gbKx56bwGTuXkguiR4EweQVtmOpGHlRSxc2j940jFNYyg8Q6TdTaEsumcvDVend9J1L3bsXOURO4oy18jIr9pIb2M=
Received: from DUZPR01CA0336.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::21) by VI1PR08MB10242.eurprd08.prod.outlook.com
 (2603:10a6:800:1be::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:54 +0000
Received: from DB5PEPF00014B9C.eurprd02.prod.outlook.com
 (2603:10a6:10:4b8:cafe::6e) by DUZPR01CA0336.outlook.office365.com
 (2603:10a6:10:4b8::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 15:35:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9C.mail.protection.outlook.com (10.167.8.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 15:35:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZ8pF3rervoWGUw0ZuW+GnfwZhNCCZwY6XzsHpv6Vv6j9uOVjOYz1jZZqu7W59swqHfNaR38s8uftbbYQPc3lLSiDdGiCX+mqGZkFfXQfrEW2Az1FzgvctoHmnEL3Ej7mFn6v8I3L8pttXanrMGcAGGY+b/xnY3rtI7qTYI9eTsYswhMQ/qSwTWIjEhkEa2MX0x2meCYHBOwivZOoxbp09ALz5qneKbMmVpMgUA6D3biMgxxTfbMGDmWecMVFjAjmYe5rjbSmkxJ76zRfJqz1SAkXXY1U8ssybhcoXIso6/WCZ+hgys96WH6jekwMn+P8DXfXCIWvmaLp4U47T+zBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEqYmqIZbfVY0YXKsD66bpQ94f0RbuJqeJhJxdP/pxM=;
 b=BBJPmrn5ubaHpGCKB61MFoHV5zWWNtQH3TsrsQE2oRUydZPLe+KFFQp+bJhyx3xRnRRi+cneBf4uSIu4cEHIlcE28VldAkKue6RXErTSVDCnWyM9TyGxU/FWr8gLB6d9h5eqwrgJ2Xqwef8T4KRo8hP6FTaefzgcfmk5zqdELWpnfjrydlqEUSFEUoNTd8LvmNzLkupLZYwl6yeKko2MpA+MJ4HZf2VsSaxuHYmaQvCY5DLchlTOYvn08aghLUISEiufh89nt3Ttdt5hb2vzWDnmv8x/JnkGUeOXMt/+6yq1r71/J8XvTiT4IGL/b6t4MQJFZxg/eG0ihipnVbUbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEqYmqIZbfVY0YXKsD66bpQ94f0RbuJqeJhJxdP/pxM=;
 b=QxkTequfka5T6DBnKeMDwYj0zXWs66+EUbXmtDyTuVcxCfEORJtCqk+3d7GuMGb3YmeIO/OiF0jV5/T7e6gbKx56bwGTuXkguiR4EweQVtmOpGHlRSxc2j940jFNYyg8Q6TdTaEsumcvDVend9J1L3bsXOURO4oy18jIr9pIb2M=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by PA6PR08MB10593.eurprd08.prod.outlook.com (2603:10a6:102:3c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:14 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:35:14 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with 'Feat'
 descriptor
Thread-Topic: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with
 'Feat' descriptor
Thread-Index: AQHcN5/5lSWDfFM9m0quOC/kafkicw==
Date: Tue, 7 Oct 2025 15:35:14 +0000
Message-ID: <20251007153505.1606208-2-sascha.bischoff@arm.com>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
In-Reply-To: <20251007153505.1606208-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|PA6PR08MB10593:EE_|DB5PEPF00014B9C:EE_|VI1PR08MB10242:EE_
X-MS-Office365-Filtering-Correlation-Id: 99597c52-457f-47ef-7aba-08de05b73337
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?27Kp21X3zt3k6nYi0lB9MYXinTnKijc0mOO2E9LdfKY84jqI2Z7c4zWNZT?=
 =?iso-8859-1?Q?buh3lGLBXgSjagEUqftxjTJd3qw4b0P9+3Ts/bnUmvrQJbgkEk3CrYGvnf?=
 =?iso-8859-1?Q?8EC5Kro4kdmLmLNKZZ3RkIoyySYUOGV+SURC8hFcZHmGZlrjUXwvr1G0DW?=
 =?iso-8859-1?Q?1VAIPiwfp+w21l6FiyZgY4/aY7XMFjWT7HaBvZ3YtjrjsITJQvNl25nkG5?=
 =?iso-8859-1?Q?aBZujRgpoaCey/C40aeuGyYtQhvbetIBN+dDQt83VRv7uTZAVi6zb2E0ul?=
 =?iso-8859-1?Q?uJ+6O+WETvDJ1VOPZLJtLn4UPgUzrWqMKORu5Gmi4QSaWRJMG4t+F01M53?=
 =?iso-8859-1?Q?gLl9HkpUJX0wXhE+DIRoU3MI6WjQWxRoGwD/Um+WNu2+LeDlau1CZChcph?=
 =?iso-8859-1?Q?Wu7/nYawDZWSQtd56cvua5k1+0dbgiYMTIipyicEbgq9UlNmlJiNrxii46?=
 =?iso-8859-1?Q?jR/v+9EeExoGhN/tgtrBJMiA5eS3UOGfKLYm4Bp/XRKDxkvrTnaeprAqwB?=
 =?iso-8859-1?Q?Xf1frlTeOx0BORzPuLfxg/kibrACbAN4mtI8H3jdJKgO/z71RhbUnc1OLv?=
 =?iso-8859-1?Q?xhTArf4XstEcBJiGlHXkGzdBJwLLaZzquqMY1alYULVuBDlXL5ZPhZCvOa?=
 =?iso-8859-1?Q?Z/SuWcEhsKoVfXNOCCd6p9RzpHpQEKPiUcnAwNP33SdRyFKyhEKf5r9zEx?=
 =?iso-8859-1?Q?DIBXSNDTCaBxVX+zn5nt7F5dCURiBE1ILgF0dXGQP1baDz/O8WXmLBOh6z?=
 =?iso-8859-1?Q?ES+NA7UiD/YT+RzX8eVKnXalDdKg7GrQ9IdDCpqUC0IuJc2i5hU5e0A4He?=
 =?iso-8859-1?Q?9AfbJ3qJhei7RhjdrJIz6KDZC+mVea73L2tzAWLgIidG2aESyGl2mLYabz?=
 =?iso-8859-1?Q?gWlgd4BUwoSHN3EtYtr2NGLokTB1WmplG0ueo5JnqQtsC/nR4snR3e47t6?=
 =?iso-8859-1?Q?aE1y1QwUno0Dff7hCDyIJyNizdMzO1JEOucwCjy6meKi6nOFB4lPrl0+yL?=
 =?iso-8859-1?Q?wL0Fned6qle/lpMzJisagXJJN/2kGyjtNiqzXCEQoPtDIU2hXppCxG6EeF?=
 =?iso-8859-1?Q?cilfjy7JLeOtOcJRWPbofb+8S0U75+oEBSihv5rZYp6H6ZvZb+z+YvegQH?=
 =?iso-8859-1?Q?7V2MMsu8+8/d/nLb2xWm/ngKeLLFo2+JAYKsx0qnnxjvcxlzxRoFERZib/?=
 =?iso-8859-1?Q?0f2yOz3D1qBaUyCxAic0qaR8LYxM4+fXtxBFMANZFO+0ppcRmm3OTT+SwA?=
 =?iso-8859-1?Q?W8tDKHm2mwatstPDdF76K1CBUyozRtls4WTOwNa/EkNhiU5SbeCKa7uQOX?=
 =?iso-8859-1?Q?k/Wl4FxE1yQYNEfoloe90Ivj+mVHk3+LQyKWuBum7m5Q6Lf6AEr7U9kh+A?=
 =?iso-8859-1?Q?NTxVA0LJcica2kmwQ73JCFZLQqfCI3rjD5NsXmLAQSTQ37NS8qebBRLX70?=
 =?iso-8859-1?Q?v8YoSMmMfO3lfhXwc+OCMY0WN2AKBlx0KSyGZsKHdMdK1f82g4Woihcp/C?=
 =?iso-8859-1?Q?ML7YLlHVsv9yFpcAro/TM+orrFbeF8SbpBrkbpt79OuJAlrkKoegF1xDbF?=
 =?iso-8859-1?Q?i7CNsZEzTikYqLLs2Cy5r07DnJ7D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10593
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d938974c-6d49-4b8b-3631-08de05b71c1e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|14060799003|35042699022|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?OnS1RNPakNqp8z3nG1PDm4SR//nTW9xnDSAKM+kQK4eJRj30ohHBo/8W3o?=
 =?iso-8859-1?Q?PDgyrmYAWZiItrzG3ay6r3CvuNF3HmaeyXUPBnIUE0vqlPgjltFmXjN288?=
 =?iso-8859-1?Q?RdV7dyaHPVowaK9o58nkxaK+oqPb/XFiuwZN8ARN82WzHoO+EYbiIHJIMN?=
 =?iso-8859-1?Q?s8zRCr4xKFWvvp2eFid/xTrwyEm4L4pm+vJlY4IEDK4ZOhW8q5dzHL+UEt?=
 =?iso-8859-1?Q?qren9yv6yvftwsDt/CGirB5wxNBVIXKPkatknkD0ySGcgLVQgjMMrw6zu0?=
 =?iso-8859-1?Q?o4VXpGP/fVj6STX3NX3eNKKCrsPSJU5A42Q4rvrKdgkCpUvKqLSNjucenO?=
 =?iso-8859-1?Q?P7xxx9KVekYfGTQuUECTobvib9htseDoKTOi9w1Pph0O8NGpBBwnpIEhBW?=
 =?iso-8859-1?Q?ZXj/z6ArHQj8jnFLo9wMrteJGUX52H6E/BPH3gfPnw3FZRZz8qQMCBI1v0?=
 =?iso-8859-1?Q?8kMqinZcr85NZyG12A13Z/GBgV7gW2/n54uk7atSYsc3Of7Iu+CkGfBUqW?=
 =?iso-8859-1?Q?b5dBsmaesWOh4bTk3hCicZIt2x4N/y9tXwW9X2FzgSkUyZPChip5eAiNP1?=
 =?iso-8859-1?Q?+6C6ufqukNQ6A/Fwx3IwnanDnFgEptfCx/AknDAU9kKuMpzaH03MQqkDsY?=
 =?iso-8859-1?Q?+wuntIS544UJhTtNIhmHqDJtxgn5dvgv7QFaOyNJWKemiN8gxq4BlFSucA?=
 =?iso-8859-1?Q?2fE09kbkq2OX6CG7mGJfvJZCDsejld7caqO5cuid+xNBCGr8753dv6Pqao?=
 =?iso-8859-1?Q?gNTHi8GqgQOUkEjF6qoaxGy/f1LLkr+85bvSFiLbQPsvaNtT5feCl+GYWa?=
 =?iso-8859-1?Q?7JTuo3Iyasf8FQ2LejndkONHeFR+4fTqRr9mgTLzYTXTuCgnFCi+oBSpf8?=
 =?iso-8859-1?Q?6tbKrVgfE6LXXqPUoR/derQbIjx3Y4677/DMJA7qXKwYauejIm+Sd3xjR2?=
 =?iso-8859-1?Q?OL+kehlZteqeBvoMpunef3uEyrsfj2/J7n6tBL4UocfkyBUSysXjz/wpOI?=
 =?iso-8859-1?Q?m2aWfRhnhoublV/RP5Fx7oiybYXghO7vz65iQ2NnB9KRmm7iSxPmY0mxs5?=
 =?iso-8859-1?Q?8+BMguc/ghp/R0x872vkjygBFoU8k6+ns3y9C9vBz0SRYLFB7E63QB7f1x?=
 =?iso-8859-1?Q?nyS1ytklFb1bt99c8bq/DQr7SWTFl5Lwo729xoG9Fe9YxmJlXVeIB3BQuJ?=
 =?iso-8859-1?Q?NYRWJuH2xjv0rJlGe0DGVwfdvG+4gQFJuhcDxiOM+GLHIopY98TIGj0snZ?=
 =?iso-8859-1?Q?5l7SfMS4MPGyTKveiMxt3xx9ng8vep3Q8/upbWCH3KdM+rptb5Ar1KI9Md?=
 =?iso-8859-1?Q?pAX1H0jrAc7F0U418iAqh/2ZrGjZvIpmy5zSV0yOnSPEvFtzGUdo4xAKNh?=
 =?iso-8859-1?Q?FP1EJ0RwtiFIBNOVlLA/JJrtYIs9b5WJtCkHGELwDEk0b6uJhvHgHDwtS5?=
 =?iso-8859-1?Q?srLS4EKamYJ+d59cztvv5z0gzEoZ9/rRI1ZbxwcvW6j/FS+JqlSjn8+ERX?=
 =?iso-8859-1?Q?nO0K9SFYZCSwSb7ZMR2b6ZVEX01vJSWjoScICqryWTUVCtbyea7ECt6F86?=
 =?iso-8859-1?Q?tYJHM/SQZ1xOVhxL8iXl1gtVy8mv5x/re+hgeU/0elR4U0zHLjGIcmroSi?=
 =?iso-8859-1?Q?X6kDpi8Gl4iFo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(14060799003)(35042699022)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:35:52.8534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99597c52-457f-47ef-7aba-08de05b73337
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10242

Some system register field encodings change based on the available and
in-use architecture features. In order to support these different
field encodings, introduce the Feat descriptor (Feat, ElseFeat,
EndFeat) for describing such sysregs.

The Feat descriptor can be used in the following way (Feat acts as
both an if and an else-if):

        Sysreg  EXAMPLE 0    1    2    3    4
        Feat    FEAT_A
	Field   63:0    Foo
	Feat    FEAT_B
	Field   63:1    Bar
 	Res0    0
        ElseFeat
        Field   63:0    Baz
        EndFeat
        EndSysreg

This will generate a single set of system register encodings (REG_,
SYS_, ...), and then generate three sets of field definitions for the
system register called EXAMPLE. The first set is prefixed by FEAT_A,
e.g. FEAT_A_EXAMPLE_Foo. The second set is prefixed by FEAT_B, e.g.,
FEAT_B_EXAMPLE_Bar. The third set is not given a prefix at all,
e.g. EXAMPLE_BAZ. For each set, a corresponding set of defines for
Res0, Res1, and Unkn is generated.

The intent for the final prefix-less ElseFeat is for describing
default or legacy field encodings. This ensure that new
feature-conditional encodings can be added to already-present sysregs
without affecting existing legacy code.

The Feat descriptor can be used within Sysreg or SysregFields
blocks. Field, Res0, Res1, Unkn, Rax, SignedEnum, Enum can all be used
within a Feat block. Fields and Mapping can not. Fields that vary with
features must be described as part of a SysregFields block,
instead. Mappings, which are just a code comment, make little sense in
this context, and have hence not been included.

There are no changes to the generated system register definitions as
part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/gen-sysreg.awk | 148 ++++++++++++++++++++++----------
 1 file changed, 104 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index f2a1732cb1f63..c1bb6d5087a99 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -44,23 +44,35 @@ function expect_fields(nf) {
=20
 # Print a CPP macro definition, padded with spaces so that the macro bodie=
s
 # line up in a column
-function define(name, val) {
-	printf "%-56s%s\n", "#define " name, val
+function define(feat, name, val) {
+	printf "%-56s%s\n", "#define " feat name, val
 }
=20
 # Print standard BITMASK/SHIFT/WIDTH CPP definitions for a field
-function define_field(reg, field, msb, lsb) {
-	define(reg "_" field, "GENMASK(" msb ", " lsb ")")
-	define(reg "_" field "_MASK", "GENMASK(" msb ", " lsb ")")
-	define(reg "_" field "_SHIFT", lsb)
-	define(reg "_" field "_WIDTH", msb - lsb + 1)
+function define_field(feat, reg, field, msb, lsb) {
+	define(feat, reg "_" field, "GENMASK(" msb ", " lsb ")")
+	define(feat, reg "_" field "_MASK", "GENMASK(" msb ", " lsb ")")
+	define(feat, reg "_" field "_SHIFT", lsb)
+	define(feat, reg "_" field "_WIDTH", msb - lsb + 1)
 }
=20
 # Print a field _SIGNED definition for a field
-function define_field_sign(reg, field, sign) {
-	define(reg "_" field "_SIGNED", sign)
+function define_field_sign(feat, reg, field, sign) {
+	define(feat, reg "_" field "_SIGNED", sign)
 }
=20
+# Print the Res0, Res1, Unkn masks
+function define_resx_unkn(feat, reg, res0, res1, unkn) {
+	if (res0 !=3D null)
+		define(feat, reg "_RES0", "(" res0 ")")
+	if (res1 !=3D null)
+		define(feat, reg "_RES1", "(" res1 ")")
+	if (unkn !=3D null)
+		define(feat, reg "_UNKN", "(" unkn ")")
+	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
+		print ""
+	}
+
 # Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
 function parse_bitdef(reg, field, bitdef, _bits)
 {
@@ -132,10 +144,7 @@ $1 =3D=3D "EndSysregFields" && block_current() =3D=3D =
"SysregFields" {
 	if (next_bit > 0)
 		fatal("Unspecified bits in " reg)
=20
-	define(reg "_RES0", "(" res0 ")")
-	define(reg "_RES1", "(" res1 ")")
-	define(reg "_UNKN", "(" unkn ")")
-	print ""
+	define_resx_unkn(feat, reg, res0, res1, unkn)
=20
 	reg =3D null
 	res0 =3D null
@@ -162,14 +171,16 @@ $1 =3D=3D "Sysreg" && block_current() =3D=3D "Root" {
 	res1 =3D "UL(0)"
 	unkn =3D "UL(0)"
=20
-	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
-	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")"=
)
+	feat =3D null
+
+	define(feat, "REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
+	define(feat, "SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " o=
p2 ")")
=20
-	define("SYS_" reg "_Op0", op0)
-	define("SYS_" reg "_Op1", op1)
-	define("SYS_" reg "_CRn", crn)
-	define("SYS_" reg "_CRm", crm)
-	define("SYS_" reg "_Op2", op2)
+	define(feat, "SYS_" reg "_Op0", op0)
+	define(feat, "SYS_" reg "_Op1", op1)
+	define(feat, "SYS_" reg "_CRn", crn)
+	define(feat, "SYS_" reg "_CRm", crm)
+	define(feat, "SYS_" reg "_Op2", op2)
=20
 	print ""
=20
@@ -183,14 +194,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysre=
g" {
 	if (next_bit > 0)
 		fatal("Unspecified bits in " reg)
=20
-	if (res0 !=3D null)
-		define(reg "_RES0", "(" res0 ")")
-	if (res1 !=3D null)
-		define(reg "_RES1", "(" res1 ")")
-	if (unkn !=3D null)
-		define(reg "_UNKN", "(" unkn ")")
-	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
-		print ""
+	define_resx_unkn(feat, reg, res0, res1, unkn)
=20
 	reg =3D null
 	op0 =3D null
@@ -201,6 +205,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	res0 =3D null
 	res1 =3D null
 	unkn =3D null
+	feat =3D null
=20
 	block_pop()
 	next
@@ -225,8 +230,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	next
 }
=20
-
-$1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	expect_fields(2)
 	parse_bitdef(reg, "RES0", $2)
 	field =3D "RES0_" msb "_" lsb
@@ -236,7 +240,7 @@ $1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" ||=
 block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	expect_fields(2)
 	parse_bitdef(reg, "RES1", $2)
 	field =3D "RES1_" msb "_" lsb
@@ -246,7 +250,7 @@ $1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" ||=
 block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	expect_fields(2)
 	parse_bitdef(reg, "UNKN", $2)
 	field =3D "UNKN_" msb "_" lsb
@@ -256,58 +260,58 @@ $1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" =
|| block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Field" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Field" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
+	define_field(feat, reg, field, msb, lsb)
 	print ""
=20
 	next
 }
=20
-$1 =3D=3D "Raz" && (block_current() =3D=3D "Sysreg" || block_current() =3D=
=3D "SysregFields") {
+$1 =3D=3D "Raz" && (block_current() =3D=3D "Sysreg" || block_current() =3D=
=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	expect_fields(2)
 	parse_bitdef(reg, field, $2)
=20
 	next
 }
=20
-$1 =3D=3D "SignedEnum" && (block_current() =3D=3D "Sysreg" || block_curren=
t() =3D=3D "SysregFields") {
+$1 =3D=3D "SignedEnum" && (block_current() =3D=3D "Sysreg" || block_curren=
t() =3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
-	define_field_sign(reg, field, "true")
+	define_field(feat, reg, field, msb, lsb)
+	define_field_sign(feat, reg, field, "true")
=20
 	next
 }
=20
-$1 =3D=3D "UnsignedEnum" && (block_current() =3D=3D "Sysreg" || block_curr=
ent() =3D=3D "SysregFields") {
+$1 =3D=3D "UnsignedEnum" && (block_current() =3D=3D "Sysreg" || block_curr=
ent() =3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
-	define_field_sign(reg, field, "false")
+	define_field(feat, reg, field, msb, lsb)
+	define_field_sign(feat, reg, field, "false")
=20
 	next
 }
=20
-$1 =3D=3D "Enum" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Enum" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
+	define_field(feat, reg, field, msb, lsb)
=20
 	next
 }
@@ -329,7 +333,63 @@ $1 =3D=3D "EndEnum" && block_current() =3D=3D "Enum" {
 	val =3D $1
 	name =3D $2
=20
-	define(reg "_" field "_" name, "UL(" val ")")
+	define(feat, reg "_" field "_" name, "UL(" val ")")
+	next
+}
+
+$1 =3D=3D "Feat" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {
+	# Don't push a new block if we're already in a Feat
+	# block. This is to support constructs such as:
+	#	Feat FEAT_A
+	#	...
+	#	Feat FEAT_B
+	#	...
+	#	ElseFeat
+	#	...
+	#	EndFeat
+	if (block_current() !=3D "Feat")
+		block_push("Feat")
+	else
+		define_resx_unkn(feat, reg, res0, res1, unkn)
+
+	expect_fields(2)
+	feat =3D $2 "_"
+
+	next_bit =3D 63
+
+	res0 =3D "UL(0)"
+	res1 =3D "UL(0)"
+	unkn =3D "UL(0)"
+
+	next
+}
+
+$1 =3D=3D "ElseFeat" && block_current() =3D=3D "Feat" {
+	expect_fields(1)
+
+	define_resx_unkn(feat, reg, res0, res1, unkn)
+
+	res0 =3D "UL(0)"
+	res1 =3D "UL(0)"
+	unkn =3D "UL(0)"
+	feat =3D null
+	next_bit =3D 63
+
+	next
+}
+
+$1 =3D=3D "EndFeat" && block_current() =3D=3D "Feat" {
+	expect_fields(1)
+
+	define_resx_unkn(feat, reg, res0, res1, unkn)
+
+	res0 =3D null
+	res1 =3D null
+	unkn =3D null
+	feat =3D null
+
+	block_pop()
+
 	next
 }
=20
--=20
2.34.1

