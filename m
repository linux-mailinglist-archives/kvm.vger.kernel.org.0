Return-Path: <kvm+bounces-59722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3285BCA42E
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 18:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EA4919E73C8
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 16:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEC4241679;
	Thu,  9 Oct 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZgY0jHrg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZgY0jHrg"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011020.outbound.protection.outlook.com [40.107.130.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFB7230BEC;
	Thu,  9 Oct 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760028930; cv=fail; b=k53NczOKdGROwnkBrkHaw0T3RcO2Ww3pRb6ii9B5DH2y7WWs5E9aLXva5BbUYjd2FcFJ7si5xxywhoIN68v3kP3PoLljOyJPsZCovrCiwc0VE7s1YKBxktelIfl5X/0RBET0kblcLR08hcukH34ob86giUxTr9qhUTc1aZK1gSA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760028930; c=relaxed/simple;
	bh=Ar0l2bWi423MKpPZfNZNu/Oo9tH0VmY2XMmTgkq1Jvw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bE8YSLKroJjzGaqHfqyYls6iDyAKgUlx8A5j21DAiDW4GEGf0B8ByQOdblcwpqj+MzDXuRHBldZscTaJ0jnVBkrzRDJ/bBeRUhHYMJ1+KLQCNOYiXLh8FSF9aC+Msaw6ONGKjUm1x1BEuWi1MELqT/zZ/pe44QZ02asH9RlQyAo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZgY0jHrg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZgY0jHrg; arc=fail smtp.client-ip=40.107.130.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f9iWxU7UOM4NJfKFlh4gcm3tIzisvG+gpYREEfPC8tk5e7WjlK0HvTwVGDtyHIIAFw7GNh4P7AmBYk/fbWq473Y/h3pQIel+aG/BwdeLQrSOwpGtMlAU/CnJruuZy/yLEGRCtjJxoXfYO8V2Vf1LgSH6e3OGJPvUMTzXh4q8nERjrXvoOIOXhczXTC1JNeekNLwyMHRAOrEDFzQ84edk+Ax6iUuutNa2ayrufWBQCI3jWwdLwFXaLNYR/C3Hbspkmc8VaQ+nPLDRkL7woxhWxA6kHT+ztcxuCQfSSk+93i/PtOFj7Gck9l6nK5nTjVCrkaZf93A2ZvznnMZYLS07zA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ge6ScMR5iz029wS5YWmPkEXH15DZcIDC4jbtyoau2M=;
 b=lpJe9KVFuZ98aDs5fqSywPUTY/GowTbMpXrXUe8zPpC7tX6ua6K0bNT4XNGRAASvb0OfdYv1Tw6+4KtoqmHaEYcCMzn51aFXZrLu4/rtr1YtCfPAmJeS4fRVejxg+DFV8sKtrZpkQ6dn+FGaVkbOEmf9PAx0V1F2YmwWYxF9kUtIC3Tm1pEZ1WfJgM7XQxXB7wufxANMvaFcyFSMSW6A0ewuqbFU0UCpCKR3Lfxxhw8GceTpBZUrzbZ2dLPz7Z4oElU51a8AenApoBZylTvjKOBBvaMUVD8LfRgEFnjq9gtvJ6NuqwfskxuvFvDIvVsT/xejwiXuSjyXtMkCPKXomw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ge6ScMR5iz029wS5YWmPkEXH15DZcIDC4jbtyoau2M=;
 b=ZgY0jHrguDUrOG6d/14xXOGOxq2eeXBXWZvGFTsSCTUEzIOZntruEo4gU7iD0V9OkteKMKG/ywl0UMNFExLNXV/Yb26mlWPnZIOCnnJ4G57woBOFtzIRagbGz8H+cmqunE+zLUBaLhP03rySnsRz/swdwUgepKep7otEbk6Bcks=
Received: from DU2PR04CA0052.eurprd04.prod.outlook.com (2603:10a6:10:234::27)
 by DB9PR08MB9828.eurprd08.prod.outlook.com (2603:10a6:10:45f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:55:21 +0000
Received: from DB1PEPF000509E9.eurprd03.prod.outlook.com
 (2603:10a6:10:234:cafe::e9) by DU2PR04CA0052.outlook.office365.com
 (2603:10a6:10:234::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Thu,
 9 Oct 2025 16:55:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E9.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Thu, 9 Oct 2025 16:55:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9aPxrI982+WqQeGOtPLTS3yYapi33o86hyjnHRzO7wkPowNbn1nraSmjME8Tnau8zU62nUVurnOeNphoQCs2SekeOfPLFZF3cGxysoKo3gCkvH6zEhebzCq5+tefa4Y+PtzSij9ZN4SuwduZmc9QkHl+H/sqDRt/F32V56ZKz69llwsLqtqYvmBOLQVFkrlEUWKiL5JUIneow5n2c2z0Cvv0FKosM3Uqzw2HfV4UNQ1hjO+zztY21KwXD9bfrYejxNAFGN1OUBiNgt1ZTfZOLm+HxJ/EAuP1s1oPRWSOH/1ckQagU/NyJygPDbUWmeRYFyGYD51p9vv9rMcaRjsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ge6ScMR5iz029wS5YWmPkEXH15DZcIDC4jbtyoau2M=;
 b=e/iZgNnUKKuNjJh9A/LXxtfsQjvxGkSMcXbnAnMzu+2MqBRLO08XlVJpFnp2IZ0Blj2AqQVB01LBVCLvtISPhUxwIG3etn9eY6S2ko0LIOY4qmViGGyU2CBQw2ZxRAAADfMs1vkPjp4gBvzq0F+NQjcCTDFr2D7XqCfma+dRcd6i5oS/5BtzELu/xdxNU0I+fA1UBfl2PY163izWwCQivE+M1YitQZ14NEjso6ZLGJaJEBa86aD9nMwPoXe3apWfFznwIJ7UunfYofu0XsMcyqvbqzjI9La9ZkLEA+KP9Y/6894rC0bRTKeqjfpOW9wNNHHdcSUqUCiWu067a5jxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ge6ScMR5iz029wS5YWmPkEXH15DZcIDC4jbtyoau2M=;
 b=ZgY0jHrguDUrOG6d/14xXOGOxq2eeXBXWZvGFTsSCTUEzIOZntruEo4gU7iD0V9OkteKMKG/ywl0UMNFExLNXV/Yb26mlWPnZIOCnnJ4G57woBOFtzIRagbGz8H+cmqunE+zLUBaLhP03rySnsRz/swdwUgepKep7otEbk6Bcks=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB3PR08MB8795.eurprd08.prod.outlook.com (2603:10a6:10:432::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:54:48 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 16:54:48 +0000
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
Subject: [PATCH v2 2/4] arm64/sysreg: Support feature-specific fields with
 'Prefix' descriptor
Thread-Topic: [PATCH v2 2/4] arm64/sysreg: Support feature-specific fields
 with 'Prefix' descriptor
Thread-Index: AQHcOT1sw/RLAN0XPEKm4HiHviet8g==
Date: Thu, 9 Oct 2025 16:54:48 +0000
Message-ID: <20251009165427.437379-3-sascha.bischoff@arm.com>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
In-Reply-To: <20251009165427.437379-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB3PR08MB8795:EE_|DB1PEPF000509E9:EE_|DB9PR08MB9828:EE_
X-MS-Office365-Filtering-Correlation-Id: b038a121-ea4f-49ea-d379-08de0754a223
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?WRxahRFSGsX6hgM88mbDj46YnA4o0Wnb0gcZK0y9okDjaUCXgK1vZLpuDT?=
 =?iso-8859-1?Q?Vi8A+nDO6W77kh8YnMF5vghsR8U66zOEl596VE2IZIzg926LfavR+ecV25?=
 =?iso-8859-1?Q?m3KBTIe9cSg8f+sxaQARCZWaBGe6t3Uv3oRd2kQpZtoJ9dF/okTGlIz0eY?=
 =?iso-8859-1?Q?JhK1BC2DiHefHpXTyNpu1IcPoXdrN2Xe0vGWN1ZmocOqouOGQ4+uNgtGOB?=
 =?iso-8859-1?Q?qs4egvjE5l7Mc1HW3yfn5Us28XAeyV6GHXNBr+aB2WUswyKnWEUiASRF2m?=
 =?iso-8859-1?Q?XUjP1U86VoSkost3vO+pV1t6wMD3ZQcN36WaibhI0QXpITDJtofewoJltp?=
 =?iso-8859-1?Q?aAN3u0XjqDgVfmSq8y1hTR377Jc1GkkKoOKOC/tyrEQvoJnyCP54z0PYRc?=
 =?iso-8859-1?Q?qk3cfgft9biZpepo54aqvMb1RqvO1Zll02aHSp8I/s3/MJXsVLQ98z9uKu?=
 =?iso-8859-1?Q?hsFfry+Jv/hKnAEK6eWE4us/Xt8aKFrOAwIMCVHGzBAKGB3NaH6asNHuM5?=
 =?iso-8859-1?Q?IcG+Qci2vXmCVqcsBIlg7NIkFyKWHNabjpMbPbanJexQsqdIHw5V6Ozksz?=
 =?iso-8859-1?Q?niY4M9DLAN1Ecg7kt9UPax77M4xIe+b9MX3fvYe7RhgRFTnCOJsJUN8Gs8?=
 =?iso-8859-1?Q?/qZBLS1XcJIwECymVQKFu99NWP3ipFPXFWkEE3ydlkkIgtQsIXfKDGzneJ?=
 =?iso-8859-1?Q?AHmkywp7LRwB9XdKwzneDMcVDpforXRV0DX+8c7r1R6LrdqrW2vpW8PIrK?=
 =?iso-8859-1?Q?AmdgooTg5n2u1GO252cn9Z5I+nYisJfb3acesH1qrtjc7i9eOJYYEvkRPf?=
 =?iso-8859-1?Q?SFzNFaH4aZF2f6/4YosmQytugwmo40cg8uqi9doVdcQqIVGbrsuPQcwMlZ?=
 =?iso-8859-1?Q?ACXQTCB2VeTg3eqFtizQz9If2O7mdLDj36wtWOlbeJfous8UOKQNWUM3Uf?=
 =?iso-8859-1?Q?T2wb3IUT45nZ5wkqWccL4X1hgQLV1yUec8wyf4WA4KXDKtquFpfYer08iX?=
 =?iso-8859-1?Q?UGIFO5jWaFeWfIGuZYKjxZwPu6R/1ISV4jxFh8dXymRa116ppHzms8SAi9?=
 =?iso-8859-1?Q?hTrcWmoJjwFE0I1iiPCXQdTFUHXuxubwZDcA2hrWtLln+rF2aun6tDGx1p?=
 =?iso-8859-1?Q?doTyuG230XsOdADI1lXoOxc1aSeWCzxiR5so3tHTRFAr6nQBbtOuuUeYbs?=
 =?iso-8859-1?Q?1BYFyIqtdGsmTmFuWQkVZfNaBkWaPSy2KPXWVYHARTIuADH3U5bFT8mIpD?=
 =?iso-8859-1?Q?QQMC24I2UONh/ClZuXGzKnq3sbEH9AcWaWtFwt9HO7S4Y4oiG64jSCozeA?=
 =?iso-8859-1?Q?X4OKLAK58r+cuPqPKldEcTwBMdQA0ECGzCLAREnx+GxPMSonzrHeyS7+pM?=
 =?iso-8859-1?Q?/KHnB8iHiW14QMec/nw0LSAPJV3echr7eknzdpMUAgRsX9crbscNTGWuHk?=
 =?iso-8859-1?Q?hJT4xIAJ6TeZjWdhpytXhUW7Gu67C9Ri4v1LdYIePviIzWgN3o8tiHC5Ej?=
 =?iso-8859-1?Q?60JE04KGQ7qJg5nVlQ4eX2c/2G6sZ+WqPM52rWlgGx22uSA+tp0GtjC8fe?=
 =?iso-8859-1?Q?NLhrAl4opUeUr4HFIZeMGyPdRFud?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8795
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16e13f41-9946-4eca-a314-08de07548ea4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?g4MAFXvU/USsbSWeaMazu8wS0KaTh1mGdQXJLgGsfcurxE4/mm8Yf8fdSe?=
 =?iso-8859-1?Q?QKbM1Hh2AF6XSE7lOlMDsJJxyViJwEyrQmYLSVlA5NrOHPnofQtvHvIdD/?=
 =?iso-8859-1?Q?8gdIJlCpD60O4IlPocIAvH9iMZf5rZPsOvDc8UoTCZ8S6Dac7TA6dr8yd7?=
 =?iso-8859-1?Q?wb6nZBLWuLgZCEiRxJKECHioHJ5nSeZ+LbXE268xrt5Efu/bMlRYaifhqo?=
 =?iso-8859-1?Q?RielquMJolS1H3xZZsobR67rWmxU5+8konxipFiqgdEjsPm/38INLXkdlH?=
 =?iso-8859-1?Q?nuCaAL7ETn8rIYVSM1+dPCI15t/AQ6eaXari5/Vu3H8K/eebql5gjHe0pX?=
 =?iso-8859-1?Q?SM+ufcR7p0vGFFTu+K8Zhg2Ip+SBQ8WTnHKTMShZHRln60rNxldGxkLt13?=
 =?iso-8859-1?Q?yRGVt6GXwZw3AOd6FTiCC0MXUsULvOcC7SXKcVQEL5bN3oG+b59Gzjv47O?=
 =?iso-8859-1?Q?LD+PTvct2nafhBOh6ZdgjwgYSInlw8Quf3vCERSYvLfnKiainC2rFTnZdi?=
 =?iso-8859-1?Q?C1HMc05CDSukHIfVNsIvo8qANSiCgkln0VxjPzi/i4FXbyKa5r7rdGMkXG?=
 =?iso-8859-1?Q?Eq9YDF7f+9RX2Aa0QWi3Qz/+08mYyQPFhBH0KlGn4gdwM0lS8RxR6DiEy7?=
 =?iso-8859-1?Q?/m3sx20HzvmfFVX+iU4f0ZQoHT9rDOtnKOqKVXmu6FhwTPUAPKWp5YGLGS?=
 =?iso-8859-1?Q?OC75urTz1YFaQWoGDvKb+ucResODhOMxNSiw560ji0lvPjJdt8KbRiTkPt?=
 =?iso-8859-1?Q?z5V9+Xcm0HzQRczVT/9PR7NjWQAT3w1P/c6AmW3B36hYEO/wlfjgI8nBdJ?=
 =?iso-8859-1?Q?nPdvB3c/H5/0I6TxDLKTEO86H7xiWiWhGLWgkGIHl0zLijs1GMhiY2pjoW?=
 =?iso-8859-1?Q?xDiQ3BIPeEVnfTOX9dW/mD4qla54uIDpXx1SQc69ceSaiZ9y3ko41x6O6l?=
 =?iso-8859-1?Q?80ymxlEVrD9dIG5ov9xVWi0B+epFFZI8A9nEzGt1ePBqa+z9JkHqrmQjY+?=
 =?iso-8859-1?Q?8qR22mD+GKRJi2OVgfb26AjmC1YKveJTBYfN+YPr3rk0Mk8lyFyY/ou7/H?=
 =?iso-8859-1?Q?4iUthLeeORMmRSU2t6ps8rnxxomAg08fZN0tRMID62T8o4oihiAIf95hF4?=
 =?iso-8859-1?Q?dI7kSYcnjy5FopIwPzadX4U33JowyXb6j7bq1rHXLn/g4hQBpzp/cJIVcz?=
 =?iso-8859-1?Q?krJEXx0MmArK9RGdj1jioESNjh2cJ3T5kkarVVXklvQ+7IR25XAJLlhSpe?=
 =?iso-8859-1?Q?yx/IfYFjBJduJzPqctUp0gUAgDULsSfBkARRCb0NoqTESkCMUCwe9oV1n6?=
 =?iso-8859-1?Q?lEfhegamF6R87XGyLY4dIw3ykPBbZ7qFmKtcSwgSvnvYs9M6PYm+ctLJDw?=
 =?iso-8859-1?Q?VA8bL7jc6VT/JkwbrbwBkn61itYAVJ38PR00GS/zmsoKv/2n8a9o4L14mg?=
 =?iso-8859-1?Q?hw/rWXb9xS5CvOBhpi6SpMOSvRSxHFR/mbtdFpSZVyPs2T8mam/6nOmGU5?=
 =?iso-8859-1?Q?bXXl+kdOEsFs/CqnMpHeiz8yrJ8guysLu5m3BjuUFiYyUP6RsnYyzOqZYW?=
 =?iso-8859-1?Q?n27BJTtNNFtRbkmYBrWOKy1VX+ZHI+H1SU/GRFw99bZeDHOo7XigxbD+9I?=
 =?iso-8859-1?Q?G6i//TNM7Wvp8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 16:55:21.0948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b038a121-ea4f-49ea-d379-08de0754a223
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9828

Some system register field encodings change based on, for example the
in-use architecture features, or the context in which they are
accessed. In order to support these different field encodings,
introduce the Prefix descriptor (Prefix, EndPrefix) for describing
such sysregs.

The Prefix descriptor can be used in the following way:

        Sysreg  EXAMPLE 0    1    2    3    4
        Prefix    FEAT_A
	Field   63:0    Foo
	EndPrefix
	Prefix    FEAT_B
	Field   63:1    Bar
 	Res0    0
        EndPrefix
        Field   63:0    Baz
        EndSysreg

This will generate a single set of system register encodings (REG_,
SYS_, ...), and then generate three sets of field definitions for the
system register called EXAMPLE. The first set is prefixed by FEAT_A,
e.g. FEAT_A_EXAMPLE_Foo. The second set is prefixed by FEAT_B, e.g.,
FEAT_B_EXAMPLE_Bar. The third set is not given a prefix at all,
e.g. EXAMPLE_BAZ. For each set, a corresponding set of defines for
Res0, Res1, and Unkn is generated.

The intent for the final prefix-less fields is to describe default or
legacy field encodings. This ensure that prefixed encodings can be
added to already-present sysregs without affecting existing legacy
code. Prefixed fields must be defined before those without a prefix,
and this is checked by the generator. This ensures consisnt ordering
within the sysregs definitions.

The Prefix descriptor can be used within Sysreg or SysregFields
blocks. Field, Res0, Res1, Unkn, Rax, SignedEnum, Enum can all be used
within a Prefix block. Fields and Mapping can not. Fields that vary
with features must be described as part of a SysregFields block,
instead. Mappings, which are just a code comment, make little sense in
this context, and have hence not been included.

There are no changes to the generated system register definitions as
part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/gen-sysreg.awk | 131 +++++++++++++++++++++-----------
 1 file changed, 87 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index c74d805a2aa38..0fbe1c7165574 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -44,21 +44,38 @@ function expect_fields(nf) {
=20
 # Print a CPP macro definition, padded with spaces so that the macro bodie=
s
 # line up in a column
-function define(name, val) {
-	printf "%-56s%s\n", "#define " name, val
+function define(prefix, name, val) {
+	printf "%-56s%s\n", "#define " prefix name, val
+}
+
+# Same as above, but without a prefix
+function define_reg(name, val) {
+	define(null, name, val)
 }
=20
 # Print standard BITMASK/SHIFT/WIDTH CPP definitions for a field
-function define_field(reg, field, msb, lsb) {
-	define(reg "_" field, "GENMASK(" msb ", " lsb ")")
-	define(reg "_" field "_MASK", "GENMASK(" msb ", " lsb ")")
-	define(reg "_" field "_SHIFT", lsb)
-	define(reg "_" field "_WIDTH", msb - lsb + 1)
+function define_field(prefix, reg, field, msb, lsb) {
+	define(prefix, reg "_" field, "GENMASK(" msb ", " lsb ")")
+	define(prefix, reg "_" field "_MASK", "GENMASK(" msb ", " lsb ")")
+	define(prefix, reg "_" field "_SHIFT", lsb)
+	define(prefix, reg "_" field "_WIDTH", msb - lsb + 1)
 }
=20
 # Print a field _SIGNED definition for a field
-function define_field_sign(reg, field, sign) {
-	define(reg "_" field "_SIGNED", sign)
+function define_field_sign(prefix, reg, field, sign) {
+	define(prefix, reg "_" field "_SIGNED", sign)
+}
+
+# Print the Res0, Res1, Unkn masks
+function define_resx_unkn(prefix, reg, res0, res1, unkn) {
+	if (res0 !=3D null)
+		define(prefix, reg "_RES0", "(" res0 ")")
+	if (res1 !=3D null)
+		define(prefix, reg "_RES1", "(" res1 ")")
+	if (unkn !=3D null)
+		define(prefix, reg "_UNKN", "(" unkn ")")
+	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
+		print ""
 }
=20
 # Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
@@ -132,10 +149,7 @@ $1 =3D=3D "EndSysregFields" && block_current() =3D=3D =
"SysregFields" {
 	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
-	define(reg "_RES0", "(" res0 ")")
-	define(reg "_RES1", "(" res1 ")")
-	define(reg "_UNKN", "(" unkn ")")
-	print ""
+	define_resx_unkn(prefix, reg, res0, res1, unkn)
=20
 	reg =3D null
 	res0 =3D null
@@ -162,17 +176,18 @@ $1 =3D=3D "Sysreg" && block_current() =3D=3D "Root" {
 	res1 =3D "UL(0)"
 	unkn =3D "UL(0)"
=20
-	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
-	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")"=
)
+	define_reg("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
+	define_reg("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2=
 ")")
=20
-	define("SYS_" reg "_Op0", op0)
-	define("SYS_" reg "_Op1", op1)
-	define("SYS_" reg "_CRn", crn)
-	define("SYS_" reg "_CRm", crm)
-	define("SYS_" reg "_Op2", op2)
+	define_reg("SYS_" reg "_Op0", op0)
+	define_reg("SYS_" reg "_Op1", op1)
+	define_reg("SYS_" reg "_CRn", crn)
+	define_reg("SYS_" reg "_CRm", crm)
+	define_reg("SYS_" reg "_Op2", op2)
=20
 	print ""
=20
+	prefix =3D null
 	next_bit =3D 63
=20
 	next
@@ -183,14 +198,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysre=
g" {
 	if (next_bit >=3D 0)
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
+	define_resx_unkn(prefix, reg, res0, res1, unkn)
=20
 	reg =3D null
 	op0 =3D null
@@ -201,6 +209,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	res0 =3D null
 	res1 =3D null
 	unkn =3D null
+	prefix =3D null
=20
 	block_pop()
 	next
@@ -225,8 +234,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	next
 }
=20
-
-$1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	expect_fields(2)
 	parse_bitdef(reg, "RES0", $2)
 	field =3D "RES0_" msb "_" lsb
@@ -236,7 +244,7 @@ $1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" ||=
 block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	expect_fields(2)
 	parse_bitdef(reg, "RES1", $2)
 	field =3D "RES1_" msb "_" lsb
@@ -246,7 +254,7 @@ $1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" ||=
 block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	expect_fields(2)
 	parse_bitdef(reg, "UNKN", $2)
 	field =3D "UNKN_" msb "_" lsb
@@ -256,58 +264,58 @@ $1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" =
|| block_current() =3D=3D "SysregFields
 	next
 }
=20
-$1 =3D=3D "Field" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Field" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
+	define_field(prefix, reg, field, msb, lsb)
 	print ""
=20
 	next
 }
=20
-$1 =3D=3D "Raz" && (block_current() =3D=3D "Sysreg" || block_current() =3D=
=3D "SysregFields") {
+$1 =3D=3D "Raz" && (block_current() =3D=3D "Sysreg" || block_current() =3D=
=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	expect_fields(2)
 	parse_bitdef(reg, field, $2)
=20
 	next
 }
=20
-$1 =3D=3D "SignedEnum" && (block_current() =3D=3D "Sysreg" || block_curren=
t() =3D=3D "SysregFields") {
+$1 =3D=3D "SignedEnum" && (block_current() =3D=3D "Sysreg" || block_curren=
t() =3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
-	define_field_sign(reg, field, "true")
+	define_field(prefix, reg, field, msb, lsb)
+	define_field_sign(prefix, reg, field, "true")
=20
 	next
 }
=20
-$1 =3D=3D "UnsignedEnum" && (block_current() =3D=3D "Sysreg" || block_curr=
ent() =3D=3D "SysregFields") {
+$1 =3D=3D "UnsignedEnum" && (block_current() =3D=3D "Sysreg" || block_curr=
ent() =3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
-	define_field_sign(reg, field, "false")
+	define_field(prefix, reg, field, msb, lsb)
+	define_field_sign(prefix, reg, field, "false")
=20
 	next
 }
=20
-$1 =3D=3D "Enum" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+$1 =3D=3D "Enum" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Prefix") {
 	block_push("Enum")
=20
 	expect_fields(3)
 	field =3D $3
 	parse_bitdef(reg, field, $2)
=20
-	define_field(reg, field, msb, lsb)
+	define_field(prefix, reg, field, msb, lsb)
=20
 	next
 }
@@ -329,7 +337,42 @@ $1 =3D=3D "EndEnum" && block_current() =3D=3D "Enum" {
 	val =3D $1
 	name =3D $2
=20
-	define(reg "_" field "_" name, "UL(" val ")")
+	define(prefix, reg "_" field "_" name, "UL(" val ")")
+	next
+}
+
+$1 =3D=3D "Prefix" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields") {
+	block_push("Prefix")
+
+	expect_fields(2)
+
+	if (next_bit < 63)
+		fatal("Prefixed fields must precede non-prefixed fields (" reg ")")
+
+	prefix =3D $2 "_"
+	res0 =3D "UL(0)"
+	res1 =3D "UL(0)"
+	unkn =3D "UL(0)"
+	next_bit =3D 63
+
+	next
+}
+
+$1 =3D=3D "EndPrefix" && block_current() =3D=3D "Prefix" {
+	expect_fields(1)
+	if (next_bit >=3D 0)
+		fatal("Unspecified bits in prefix " prefix " for " reg)
+
+	define_resx_unkn(prefix, reg, res0, res1, unkn)
+
+	prefix =3D null
+	res0 =3D "UL(0)"
+	res1 =3D "UL(0)"
+	unkn =3D "UL(0)"
+	next_bit =3D 63
+
+	block_pop()
+
 	next
 }
=20
--=20
2.34.1

