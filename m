Return-Path: <kvm+bounces-66375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F390ACD0C5F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23D0C3140212
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF733659E3;
	Fri, 19 Dec 2025 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ebgdihy2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ebgdihy2"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013055.outbound.protection.outlook.com [52.101.72.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A5F36213F
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159645; cv=fail; b=QAyXVwzpmGn1zKnusag7Ge/bMRUM5yFbaC0tB9WM1ZkcWyudNyA6/CpsybPQXqXxheSFORxMw45L38k4vwrDk7rdagtTcAc408klAcC/eHaDZ9bYiBgm+4bumADOSAM0Lt1omzdRzuq+GaJalfWIMRR6K93o6iCujTrUYV9emH8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159645; c=relaxed/simple;
	bh=4iKOFnwf0vhmZd7oG/ZtpmX8NtUtf84VYh0vf2M3nq0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehiCLR0WWvnyIE2rVORIBurHkpksxDZIGEeNI+4H9XlZC96e0clnU/3TE4Z+PV+ezEXCICJd3PyLvqCEfiiuvaoIU0T7aKl8rdOabmLLCk06HtJiLgLqe1t+2la0aNe2Yx0PUG0QXMSi8KttCh0PM3M9UW8dscQs9ZcKowahilQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ebgdihy2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ebgdihy2; arc=fail smtp.client-ip=52.101.72.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AJOe1Tp/TqaRPSiTOm1uJ2B33MkaeaizOMuU9f6eDjJkTUJWk/F4soKGM5QVE4EVsqjJA4qcRfbT9Qeja4+SgSUtFIYjGpLM+Z/uVhzf96wPFcPCOMCyGXQDfn2GZ1BqhrzwcbfKvI4Jva7LsiDukEPRl64IeM8p9HizWog19no2ATzvsnr9T47TenKQ3WkZCQbmh12PkE7hG+IDOboqhl3hw9rtuZVo7WsJLHbcgMaF+yD4y84LoCAOCFXwbxT50BAtHEeaFpQB+j3qnpvu894i//SNhy/MxYttpq+hnCqAosx0VqLehZ75KjdW2SSS1dJEOYoC53yvGjj+hNSDWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pGttd8074+tbyXKYMUgZ2/xkMXovMw3k1IsrNT4Bc8=;
 b=HEn+eQn89F2eVMv2xuQi0PoZmp48DwbIcQmkdRRtgmcrtVr03hcYqd7pKCD0nOU6kD92h6YFTgq8tuSIS3M6Pbkx3g6p7YHFbpsI85ZtaH7JCXmSZ1GAH6GeipKmFM/e5+V07vDZRlC5ZW4/Bi30FKdOEJsg02jz4SPESKQYgZLi3MaSeJ2y3T2GyWUpteL4PiC6Jy0xmX2iQntNE0CVcyoWCoj38+5s6vgJ0H3LLdZkI7ZlkQfpvCPpN7nwL91F8d8HT/yzIk/BvFOcPC3Qv2U+r+OBGUbszt9HhUolXjui8PBRjk1cbzpxbXNNB6Y1g/+p5JRVtbKbkV7BnG8zSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pGttd8074+tbyXKYMUgZ2/xkMXovMw3k1IsrNT4Bc8=;
 b=Ebgdihy2hPkhoSa1jAT+YkbQWdeGsFqQZ9V417XaX+gz/c0FcDTAort+VyKKU94P5N3c1P0kcpk5zXKi21nGJiEI+lrXYYCetl5I8fD4v0L3HOFrnnF/qkVjX82p344TVaonudOkhXxGef/sc+tMt76LUnz2fzavAgGMGVlrQ8c=
Received: from AM9P193CA0008.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::13)
 by AS8PR08MB6200.eurprd08.prod.outlook.com (2603:10a6:20b:292::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:50 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:21e:cafe::9c) by AM9P193CA0008.outlook.office365.com
 (2603:10a6:20b:21e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Fri,
 19 Dec 2025 15:53:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EV1VX3tXgzcf8n7/2pRA6JcerMaLkFwaLFp2jlnGDgGWziOI2FsVOzMSngz3NLLMW1qNfv+jrqZvNlU435En3e7YZMdrANrNUBitIKyWprm57myrhMP6Jrk/FvrdapFnGT/uujm++GMVbrVvHlNi+OQQfXnFDFo66c77QtlSNciD2vU+bpa9U159OCYP8GfZViyM/l6ycn8LetujwEInwHmjOFzbWf5JDBrbEoqRA4kAp+3DIJng0f+tXkVpREJ8GErg+vRqTYGGBcGYNccvcfqtFFK0mqF67teofNmkWJqPZxoJKqnTNCH46TCqGpTDILgqILgYCemgUtrKPLSDog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pGttd8074+tbyXKYMUgZ2/xkMXovMw3k1IsrNT4Bc8=;
 b=EkXLwaAltDNuYdj+EGaDb54MtotWLlD9LGJXProQHJEGrbRM6QJXZXUSOWyfFQk8jAWD5C7L2Nc+CIJj6SGTfC65wvDV+flYxAGIn2X3geULKWLBQtmG1fpbSFkaEnHcrm9RyfLRlIA9d8SEs52y6SCQfdyWAu+Q0aXSGL3BoFHjtyR5lt87mM3LHNOGR++6OhkfK1I1xFLZFnRZBJkRuQlQn2BCSJQE0lYPZ6u3brzXHVb9cnYTjYhhgqdmQtOMcGqcurM+sL3feqPHqHGbNYDP05DMsKyi8mw0khrodM6bjE/nqTTBiU9YMHZNUnNHTibW6nOlcISNvFLFFGLcuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pGttd8074+tbyXKYMUgZ2/xkMXovMw3k1IsrNT4Bc8=;
 b=Ebgdihy2hPkhoSa1jAT+YkbQWdeGsFqQZ9V417XaX+gz/c0FcDTAort+VyKKU94P5N3c1P0kcpk5zXKi21nGJiEI+lrXYYCetl5I8fD4v0L3HOFrnnF/qkVjX82p344TVaonudOkhXxGef/sc+tMt76LUnz2fzavAgGMGVlrQ8c=
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
Subject: [PATCH v2 18/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v2 18/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHccP+CeOzJoZgO2EK10cX6hciWJg==
Date: Fri, 19 Dec 2025 15:52:42 +0000
Message-ID: <20251219155222.1383109-19-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|AMS0EPF00000194:EE_|AS8PR08MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 488a550e-3fc9-4424-7d4f-08de3f16ccb6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?v62MyR/FlF8s7wuWUgFmrWFtEuzXM86cqnAkjAuaAe30YM6lkbISrvylNJ?=
 =?iso-8859-1?Q?ina2YMWH6dqez71uLUM0BTkTCN5c29MZZnro/hE3E2Zv1DxuJ2kk6di2Tx?=
 =?iso-8859-1?Q?0Tov1aiWS90wwCJ8KGglAaCH753Ra/VoBHtCO53a/RiSYiUvZNOqqTsrOR?=
 =?iso-8859-1?Q?u8SmPm3I1HiYbRGaKkTcs8ICBw3ihSHA6lRvK2tE4v/qNepsZLQM9p9U46?=
 =?iso-8859-1?Q?rdQEvHRFVfWqc51zG+9M1izey6DjiFXq9yK+wOX1vhBZHCFdOBHCJA2I3w?=
 =?iso-8859-1?Q?5gLjGwJdqCX6PX/iinDXUNVNzGFk+rgASIbLWueBZpMFCXEcOvzz2BY0zs?=
 =?iso-8859-1?Q?IHHIpuO0m7Z2otemuZeWJ3VPS2x8P7Wb0r0MwSTnRHio68tl/+LcMIAhaR?=
 =?iso-8859-1?Q?ZrQJQpi4cEgsR/emTvie9u1G8PDFQJOu9YhAtirR9M4STG2ILGkUH1nUtm?=
 =?iso-8859-1?Q?/m5hkEuU3avsqyp3tlstEnEr4IFQrMEYzXUUn3OPRuq1iAu35OlPKZ/+oV?=
 =?iso-8859-1?Q?lKdJNITdX3sILtqojd+czVKDBYDDg3CYMsRx0eEjtnrfenrpQh4GXJW1Z9?=
 =?iso-8859-1?Q?vKbkXc1GVUrHo9lP+TFqkIB81NkkjnQXjA+0qBxkOyASScgGYA92ZMWBhJ?=
 =?iso-8859-1?Q?jWaM6XTsqrP4HbS5vkB/Cq8vlN5jGeR8g03cTVlxkb3F5kvT5RrsNV9SaB?=
 =?iso-8859-1?Q?716PmdHT/V00SSR6Mkt3DNI2p1xXlgXKEw6neGUavT1W7jSE0emV7dRW94?=
 =?iso-8859-1?Q?hjfQ4m4AIZdzg/8z162+8QndKI0E1ss3UfLzwBNXuzIkCddnzDti6gV33I?=
 =?iso-8859-1?Q?n5zdGkQOwVkmZiKPxJXPj7zltsg+qOCKNxPDa8g6nOXRXE8XkshWNHF7BH?=
 =?iso-8859-1?Q?0CdSBES2LUsQLW6l2/MrV2flQK9L8G0IHrBRW1Fy5sKHwDCnxhXndkbXFh?=
 =?iso-8859-1?Q?GWM63WH+RYl/Co3eTxnAiGt6VWzlc/s3N19w+d0QSRPyKof7CfzQCXW6Ib?=
 =?iso-8859-1?Q?nxWCh89cavn/aQrZi8K8UrOMTqS6myeWhoz9kMFOXIWJCgpfYpcfuYhw2/?=
 =?iso-8859-1?Q?yHHfEZxHu8pzF97vSo/gS4qoGv5imkB0fzJ8aBGEPHzYi49MJwMK+0tZqr?=
 =?iso-8859-1?Q?UW8WtjwIvsgx19X+BX0dFXPJgRkzgWK7G2pQ0U33e59gniU7ojFkLTSRXH?=
 =?iso-8859-1?Q?0wH5WcBnbhlNnN+hrApDNvh4SCuBw/2ZVCbX2oVsKicpVz1MDBgt1gLrMl?=
 =?iso-8859-1?Q?ogCdeEpyXjYT7MRpcvSDEMIpxvbB6MFDEHkbSXqvrdZ8SclHyWxrzuGGxx?=
 =?iso-8859-1?Q?bFipY9oUkKBQ9QX6x7R1bJLsj30eJr9rWJtQGP7jU5jdTtnaPKo66ZScL4?=
 =?iso-8859-1?Q?QzGCHqCjK+QKyNy0tytff5vctx5PvwaEebHSe92zbBb/9LEfXHyazChMoO?=
 =?iso-8859-1?Q?ho04xBj6wXg8cGnpnP4R9NvPx+V9O+tDlHh3QYiKzMOtPaLrfLy7ePgATf?=
 =?iso-8859-1?Q?tFkV6MIeqhluv1J3FVtlg1OPXQ6tKZI/28XFKSZFiudZnWvS3b1jh3BkEI?=
 =?iso-8859-1?Q?Csjlai3Q3Sg3zB/cSWjMsTe9zCK0?=
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
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	640d166f-c008-49c7-be6d-08de3f16a582
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?5hJG2kae9RqAeFhA/a5iILbqajMz9yTA2Xyf5JW66ZAqOMnzy7HXVP4RnQ?=
 =?iso-8859-1?Q?n14xwaplqeQyJHhWfIwrx5mIRBLnyBrZ8JMM+0CmxozI25H+wfR1Egbb7R?=
 =?iso-8859-1?Q?ijzpprU/3mlTnQDCARCKxJUR07Jhk8aGiHF7jahqlo6rucx7ZpYSBT9JAw?=
 =?iso-8859-1?Q?3o3af/x0+24uf0cTsNOMxCLv6WXcHsa5N/rIG8itMfAI0NK48JjvyzQbZL?=
 =?iso-8859-1?Q?utpO/F2KZnT7LlwR2AUsTRMJ5LiWjE0fyrPXE5kmJO0e72pu+lUBS5ALeb?=
 =?iso-8859-1?Q?yKJqQMZLi7I0nCjWLk/mroKN8LGPPoW5uVD2IfswZRh25Cl6FhW5Q9B7KW?=
 =?iso-8859-1?Q?Sw3XWanDmPHgDWC/B7UbUX53jIA7nbkUGuPBcBUIqH3c1JIgNj3xnjxhaA?=
 =?iso-8859-1?Q?YnSbbQm93L4X9zilT4/A1tmnK1wQIY5QedAjuEx+PkgbL1sH/6t5yqLzH0?=
 =?iso-8859-1?Q?tzE+Id7Xezya6gfjDZeM52zmdcx/sz10rDnHSvUW5jwXw9zgg5qsBcEQcS?=
 =?iso-8859-1?Q?eoXrcwcihpJH3RS2gosi72hDgYo85veaZHIdnmHh5dyBl6VKKyx7FajIXg?=
 =?iso-8859-1?Q?0JHTg1I53vi2ROCdAOdPvjrNCR1Asz+Mtqcf4pUL/fy/CP+zuO8m4piyfO?=
 =?iso-8859-1?Q?ADJwP5Eai53Fdc4SnuV2KwiVfIi3NzOl2McnwFvnYy3Vibi1+F8SRhzPdg?=
 =?iso-8859-1?Q?kn+0ZD31Z+TcTVtYFtnV03yjiXoNrZpJF3rgTZDqWc4W3/QDlp3TLMwVMi?=
 =?iso-8859-1?Q?ErhOqBpIB7Q3O+2X0ybvHhG9tX8NkAfzhFsDvtr1yupmT/0fbUm0KnbWYv?=
 =?iso-8859-1?Q?2FCM/47GRcjvyCZrFspj9FzzvqUz2EZGolaRq9X6oqAEoF05QPFYdxnsxw?=
 =?iso-8859-1?Q?fI28xyn/lPpYvR+WSDQteGCGXOK1TkBf2ChOmzwPJNBTK7keNxVGWh6kjC?=
 =?iso-8859-1?Q?zbP+IlVcbz0zuekgURcsnu0Zwz2qHVu+HdTkHAMvbg+bkLQaN6sitBonwo?=
 =?iso-8859-1?Q?9mRJr9+qM8cNgP2alx0rjNq3j3f9Vom1+Pfc8ytLYn0cSy29Mxe69qeFIP?=
 =?iso-8859-1?Q?p31N2abb9gwJ7RkkPkunuFJ+cwPKN8F/blFWubvgLWcoJjDzYGTDhuhMSx?=
 =?iso-8859-1?Q?GnR/ApIgONWW/M1xxhcTGSsOoJZBhks6YvOYRU5xhI/hl7iE4cfUTJy0g+?=
 =?iso-8859-1?Q?wGkTIolAuMcSWZ8qO3+twTxe+9zGcNb8HImrxOdua4gm4x5UluclBeKyON?=
 =?iso-8859-1?Q?Jq947+PtNZhNGhs4ERCgNkPcfIvjewCtWXxD6XV4e3AzYXS/2wPlcTvR6Z?=
 =?iso-8859-1?Q?40h1PDzxp2xYPzsStvs8HF24LvNV+AeDhZKSLUkdmUY0KfmvwZPbodLLYN?=
 =?iso-8859-1?Q?S23gztpnZdMV1QYTkraY3c5VGekp2FX+nT50hlZuC7spX/7IcvdeDe4FX4?=
 =?iso-8859-1?Q?oV5M8e8SaxQmla9SXEYhQGaOTnnLk3O/WJCslO2hdrPU5MS4PZzvB5gZwM?=
 =?iso-8859-1?Q?6w6wWNO0f40xkmPBCjV2wKHrGlXM7BZI+CD2GA7g46ck/5KZasDAz24hYw?=
 =?iso-8859-1?Q?5Nzp9Xp6Xx+upLrC+48uwbVZo1d7miPZxP6bfPrC4mVXzJbeA2965c6rqm?=
 =?iso-8859-1?Q?iSl6kp6H0caEY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:48.8552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 488a550e-3fc9-4424-7d4f-08de3f16ccb6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6200

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the KVM's
shadow state using the set_pending_state irq_op. The directly sets the
relevant bit in the shadow ICH_PPI_PENDRx_EL2, which is presented to
the guest (and GICv5 hardware) on next guest entry. The
queue_irq_unlock irq_op is required to kick the vCPU to ensure that it
seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state is called from
kvm_vgic_flush_hwstate. The effectively snapshots the shadow PPI
pending state (twice - an entry and an exit copy) in order to track
any changes. These changes can come from a guest consuming an
interrupt or from a guest making an Edge-triggered interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's shadow state in vgic_v5_merge_ppi_state from
kvm_vgic_sync_hwstate. The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 159 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  46 +++++++---
 arch/arm64/kvm/vgic/vgic.h    |  47 ++++++++--
 include/kvm/arm_vgic.h        |   3 +
 4 files changed, 235 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 46c70dfc7bb08..cb3dd872d16a6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,165 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	struct vgic_v5_cpu_if *cpu_if;
+	const u64 id_bit =3D BIT_ULL(irq->intid % 64);
+	const u32 reg =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid) / 64;
+
+	if (!vcpu || !irq)
+		return false;
+
+	/* Skip injecting the state altogether */
+	if (irq->directly_injected)
+		return true;
+
+	cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	if (irq_is_pending(irq))
+		cpu_if->vgic_ppi_pendr[reg] |=3D id_bit;
+	else
+		cpu_if->vgic_ppi_pendr[reg] &=3D ~id_bit;
+
+	return true;
+}
+
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We
+ * (the hypervisor) handle the pending, active, enable state
+ * save/restore, but don't need the PPIs to be queued on a per-VCPU AP
+ * list. Therefore, sanity check the state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq))
+		return;
+
+	scoped_guard(raw_spinlock, &irq->irq_lock) {
+		if (!WARN_ON(irq->ops))
+			irq->ops =3D &vgic_v5_ppi_irq_ops;
+	}
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, reg;
+
+	for (reg =3D 0; reg < 2; reg++) {
+		unsigned long changed_bits;
+		const unsigned long enabler =3D cpu_if->vgic_ich_ppi_enabler_exit[reg];
+		const unsigned long activer =3D cpu_if->vgic_ppi_activer_exit[reg];
+		const unsigned long pendr =3D cpu_if->vgic_ppi_pendr_exit[reg];
+
+		/*
+		 * Track what changed across enabler, activer, pendr, but mask
+		 * with ~DVI.
+		 */
+		changed_bits =3D cpu_if->vgic_ich_ppi_enabler_entry[reg] ^ enabler;
+		changed_bits |=3D cpu_if->vgic_ppi_activer_entry[reg] ^ activer;
+		changed_bits |=3D cpu_if->vgic_ppi_pendr_entry[reg] ^ pendr;
+		changed_bits &=3D ~cpu_if->vgic_ppi_dvir[reg];
+
+		for_each_set_bit(i, &changed_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock, &irq->irq_lock) {
+				irq->enabled =3D !!(enabler & BIT(i));
+				irq->active =3D !!(activer & BIT(i));
+
+				/* This is an OR to avoid losing incoming edges! */
+				if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+					irq->pending_latch |=3D !!(pendr & BIT(i));
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+
+		/* Re-inject the exit state as entry state next time! */
+		cpu_if->vgic_ich_ppi_enabler_entry[reg] =3D enabler;
+		cpu_if->vgic_ppi_activer_entry[reg] =3D activer;
+
+		/*
+		 * Pending state is a bit different. We only propagate back
+		 * pending state for Edge interrupts. Moreover, this is OR'd
+		 * with the incoming state to make sure we don't lose incoming
+		 * edges. Use the (inverse) HMR to mask off all Level bits, and
+		 * OR.
+		 */
+		cpu_if->vgic_ppi_pendr[reg] |=3D pendr & ~cpu_if->vgic_ppi_hmr[reg];
+	}
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We're about to enter the guest. Copy the shadow state to the pending
+	 * reg that will be written to the ICH_PPI_PENDRx_EL2 regs. While the
+	 * guest is running we track any incoming changes to the pending state in
+	 * vgic_ppi_pendr. The incoming changes are merged with the outgoing
+	 * changes on the return path.
+	 */
+	cpu_if->vgic_ppi_pendr_entry[0] =3D cpu_if->vgic_ppi_pendr[0];
+	cpu_if->vgic_ppi_pendr_entry[1] =3D cpu_if->vgic_ppi_pendr[1];
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	cpu_if->vgic_ppi_pendr_exit[0] =3D cpu_if->vgic_ppi_pendr[0];
+	cpu_if->vgic_ppi_pendr_exit[1] =3D cpu_if->vgic_ppi_pendr[1];
+
+}
+
 /*
  * Not all PPIs are guaranteed to be implemented for
  * GICv5. Deterermine which ones are, and generate a mask. This is
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ac8cb0270e1e4..cb5d43b34462b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,14 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm) &&
+	    __irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid)) {
+		u32 int_num =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+
+		int_num =3D array_index_nospec(int_num, VGIC_V5_NR_PRIVATE_IRQS);
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -258,10 +266,12 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *=
irq)
 	 * If the distributor is disabled, pending interrupts shouldn't be
 	 * forwarded.
 	 */
-	if (irq->enabled && irq_is_pending(irq)) {
-		if (unlikely(irq->target_vcpu &&
-			     !irq->target_vcpu->kvm->arch.vgic.enabled))
-			return NULL;
+	if (irq_is_enabled(irq) && irq_is_pending(irq)) {
+		if (irq->target_vcpu) {
+			if (!vgic_is_v5(irq->target_vcpu->kvm) &&
+			    unlikely(!irq->target_vcpu->kvm->arch.vgic.enabled))
+				return NULL;
+		}
=20
 		return irq->target_vcpu;
 	}
@@ -836,9 +846,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_fold_ppi_state(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
 		vgic_v3_fold_lr_state(vcpu);
@@ -1045,8 +1057,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1070,6 +1084,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1106,13 +1131,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && !vgic_is_v5(vcpu->kvm))
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d5d9264f0a1e9..978d7f8426361 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -132,6 +132,28 @@ static inline bool irq_is_pending(struct vgic_irq *irq=
)
 		return irq->pending_latch || irq->line_level;
 }
=20
+/* Requires the irq_lock to be held by the caller. */
+static inline bool irq_is_enabled(struct vgic_irq *irq)
+{
+	if (irq->enabled)
+		return true;
+
+	/*
+	 * We always consider GICv5 interrupts as enabled as we can
+	 * always inject them. The state is handled by the hardware,
+	 * and the hardware will only signal the interrupt to the
+	 * guest once the guest enables it.
+	 */
+	if (irq->target_vcpu) {
+		u32 vgic_model =3D irq->target_vcpu->kvm->arch.vgic.vgic_model;
+
+		if (vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+			return true;
+	}
+
+	return false;
+}
+
 static inline bool vgic_irq_is_mapped_level(struct vgic_irq *irq)
 {
 	return irq->config =3D=3D VGIC_CONFIG_LEVEL && irq->hw;
@@ -364,7 +386,10 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -433,15 +458,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -481,6 +497,19 @@ static inline bool vgic_is_v3(struct kvm *kvm)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 500709bd62c8d..b5180edbd1165 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,9 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+/* GICv5 constants */
+#define VGIC_V5_NR_PRIVATE_IRQS	128
+
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
 #define __irq_is_sgi(t, i)						\
--=20
2.34.1

