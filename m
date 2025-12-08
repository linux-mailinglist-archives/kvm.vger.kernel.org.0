Return-Path: <kvm+bounces-65505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE251CAD973
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 16:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 019EF30402FA
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 15:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E27B1FC8;
	Mon,  8 Dec 2025 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F8/qbS0P";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F8/qbS0P"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010018.outbound.protection.outlook.com [52.101.84.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA13DDAB;
	Mon,  8 Dec 2025 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207774; cv=fail; b=RvuSiMMjaujHv0hcPWl5AIKD1OiBdI36G0AjNKpDLH+tnHFDtBi6SULcbKiq0z9GUZfymlevD7/oFSHdQnQnKHcNR8jJBU3N4K+0iJu1aF02dtxqtVd6ICR6Gfjyo5KKMCqWXPmDqfejgdTap69JYHmi2tqSflBe1PyZ09Ke8fE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207774; c=relaxed/simple;
	bh=1SbgbAwAD3NcestFTVW8uL6Qx7Hn/V0Efz/M1N0ND6U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s7/QI8kLDW4GycRgN0kncWwo5BvG6ZenVl9j6HMMf83tj+Z6INbEO3BspT3o2orGIUAWnaqAlV8RH4yjrfmSxa/Q+oXy/rVhDwW3Puw2YqU/iLce6FhD2kiP0ybgB4Fxcp1IaFf8iy7rUOLFCzZXgEE56b3+N081TAGJN2Dk7Fg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F8/qbS0P; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F8/qbS0P; arc=fail smtp.client-ip=52.101.84.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WKFaF7UroWrMzRmNP3oOs1zgjERDRVZneC8ld8My+w2k1n1ZSsQE/TkLXHEvgcY8xmOdda4J4tYvoqX+XaluUuAM/TvyPWKO5kSXdFltq07REq1LLPgg6gBGp0OB6gdgUqm8ohzW89gE9FzcDEVA77Bk4BDzGyGWay0uDlqRge7MB3B0XQTdv3FZD1cMuGf7umO9W2M6H6VMvyp0oywFw6oB6gqUfRCrRilivM5H1SR+Knoe4YoBMt3A1MtJQn+QBZVD+RbpeG079B6RgwrvSdSJnKZfFbOKY0/SFx46uJyZ83zs0HUXXFgs7Q2uSvHEKg0b7tK1ikXOHniCiyrTJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Y5Yebp/LUsqR0poIh83GWwZlwrKSuTJvL5jfiSbFUw=;
 b=PzUuB3ObsgkOShyqDhB33El/YMqsYfOyK+BoK6fpxAeyvFLYYQjVffkn6VDcKiq3bPmNRY7DgeRTnFSrRkqqohiubht+YtnMndPGo+9vXo2lcWlR0ggS9Bn4/O+EKVZjeYlfwDFPXLhrDy5uFJKN6ZSEcYcHRuVLs1620+DptgqrJGiAg95xQ/R5m0j1/bHQzerPrrn9LASTZYt1T+CegCzysRXwu5D8yivj6j8N3xzgi+DKLaDQlsk07HMYVUOt1R5xfiYLuV/HaGxiL3Rvxev/frhmsR1ksUbiccZWUDu127jlijVX1XHb/QBJ3G+De7ixy50CBi8k5WXweAkGyg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=googlemail.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y5Yebp/LUsqR0poIh83GWwZlwrKSuTJvL5jfiSbFUw=;
 b=F8/qbS0PCf6h/EiukmZiWpqHFhNtuzhzh6M4lx/eVc8sTUq362jfsu2GqoQBotLLNsOUQ28oMwu54ps1Twjhly25BFbVfXDyWA0bEBnWF4VJyVU00Wyvq0e/Wd36/G82LwRrQRxCjVm5T26Ns22c78hhxc1lI0WgvWy8fIQgRNc=
Received: from AS9PR07CA0039.eurprd07.prod.outlook.com (2603:10a6:20b:46b::11)
 by AS4PR08MB7928.eurprd08.prod.outlook.com (2603:10a6:20b:577::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:29:28 +0000
Received: from AM4PEPF00025F99.EURPRD83.prod.outlook.com
 (2603:10a6:20b:46b:cafe::71) by AS9PR07CA0039.outlook.office365.com
 (2603:10a6:20b:46b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.6 via Frontend Transport; Mon, 8
 Dec 2025 15:29:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F99.mail.protection.outlook.com (10.167.16.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.0 via
 Frontend Transport; Mon, 8 Dec 2025 15:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXL/XOLhQz5mwi5AA16Z6Fq5kEJn5qC6dm9LT92ajG9qUk+GmzcJODypNHNDSJgdJf9uZ1ANnonPPaTeQF2vrIxURvoGBVNQuTm6XR9f/C8m0Xnrthe4lA4tWmj7SPR6TUF/NnO2zRi780Y9pmhvfvyPeDvxhL+nWICRoqrOBQ3FbNLaJ/eiCo+lAa2Q/8851olV+rpf2cl9WShuYxyTzPOusbd32eDx8mBrqkBnOQDwnFv7590spWk5B06IAw3BnnDSZ+4k4EXC2HNEWOEYkOtr8C1vgtiQK6PKP3a7KJ7RwZSSeMzeLKO62LkaJtEw6fiq9ozNNCELh+miLuyD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Y5Yebp/LUsqR0poIh83GWwZlwrKSuTJvL5jfiSbFUw=;
 b=A3q5wAuVP9IZwWD0MPnziYKqTsfqWgUvRUcvmAbwhCnW0EU7dwDPhlMmEJvy5crZwZ0SFVfgY83hu8kYt9s74ROp03P3RjajNbEX+phlwbLNY1aiqqM7LwyMjuPXLAuNVKvDZTVlaWIlJlle/C6wyVkBfSTgeqW5Ni/bld04XV9ISXj9PW6x+w1ciCZo44/kr9No7CdlUE0UCxSK/scq+SOc9wKiA+BQp60DNIKjNUgT0lpFGdFhIdCkg82Syq6+VVDxTAhIxe0IgzZZx1xNKISTmss8NMrV3gE4WaYYRA5j5y3pBYgQaYWpRy3BP/b9Foexp5RaNt2yDmUtf/nK1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y5Yebp/LUsqR0poIh83GWwZlwrKSuTJvL5jfiSbFUw=;
 b=F8/qbS0PCf6h/EiukmZiWpqHFhNtuzhzh6M4lx/eVc8sTUq362jfsu2GqoQBotLLNsOUQ28oMwu54ps1Twjhly25BFbVfXDyWA0bEBnWF4VJyVU00Wyvq0e/Wd36/G82LwRrQRxCjVm5T26Ns22c78hhxc1lI0WgvWy8fIQgRNc=
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com (2603:10a6:102:2fc::17)
 by AS8PR08MB9573.eurprd08.prod.outlook.com (2603:10a6:20b:61b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:28:23 +0000
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f]) by PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f%4]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:28:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sascha.bischoff@googlemail.com" <sascha.bischoff@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>
Subject: [PATCH 1/2] KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5
 hosts if required
Thread-Topic: [PATCH 1/2] KVM: arm64: gic: Enable GICv3 CPUIF trapping on
 GICv5 hosts if required
Thread-Index: AQHcaFdK1OWX2ouycECsixrfg607mA==
Date: Mon, 8 Dec 2025 15:28:22 +0000
Message-ID: <20251208152724.3637157-3-sascha.bischoff@arm.com>
References: <20251208152724.3637157-1-sascha.bischoff@arm.com>
In-Reply-To: <20251208152724.3637157-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAVPR08MB8821:EE_|AS8PR08MB9573:EE_|AM4PEPF00025F99:EE_|AS4PR08MB7928:EE_
X-MS-Office365-Filtering-Correlation-Id: b2f4e3e6-066a-45af-3985-08de366e9369
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?1wRfrdteE2mCVCggKF3jsKAwi9CrQMdX7p1R++Y2C3hnfe7A2CL+g3caGB?=
 =?iso-8859-1?Q?tlGTFvctGiAk/RKSkk+XRx1rz0d49f8Thch1IDet5dAgc2lIWxibG4IA9H?=
 =?iso-8859-1?Q?ts38GfbTKGitPUs3kEy60dDjqJUyGq1KElFDgok1TwOMA1T/DHSeJcAf0G?=
 =?iso-8859-1?Q?mgL/Au53aZx/hMpV0x90itV82GiEtk7f0YKcK77hmYNgLiJrRkAfTvPZrA?=
 =?iso-8859-1?Q?ZUr3WVtmkXzQm30lUlUP81uvuQas/dgR5kdEa6zi/5boqtwBBCP5Oq4WG+?=
 =?iso-8859-1?Q?QuWhqD0uFzT2ZM6XCMqfEoAQWQU9oBc2tBK5XJvr4wtgyJy+AcPeefFAWo?=
 =?iso-8859-1?Q?z3q1czX702m6rifH45/zbe+cKv1AV+APZKVZENT2gu5ZxCzvaRcI70etr4?=
 =?iso-8859-1?Q?Ws1q7PhIc6MkbUh8bJJM+EhX5q/qKA7J9oiP9sUnJQca90y/FJxTLN5hxc?=
 =?iso-8859-1?Q?ENBVLq+9h1s0VWohrNJ+VbiyoPlF0weehi8mCdr9aOVZvb1ny05LWGbap5?=
 =?iso-8859-1?Q?iQwvooCdOZg4DybZOY+ucdo+cSxOIwprd26ERye1jVYfaOzbkA7G9XUHyr?=
 =?iso-8859-1?Q?IULPU5EWiqnZ/T99OiO7XNFx/beGczO4XEA1QRtzea5qbbGMb4nARuq1XX?=
 =?iso-8859-1?Q?hh/KMLORDG09yihU+3F2JUrItH9J2m3p2ly+rwvjB+Je16zHOX226U8V9e?=
 =?iso-8859-1?Q?VLJb4rjLKZDVK7vlEmm1NZv5wgInwWklrO/jKPgcOOc9NRlfd+eL/Jld3X?=
 =?iso-8859-1?Q?IuwjKrBxJTLLB7Y3Gxigl/OsSt2hnPw7tJ/t5LautRDzeGiY61syL7wS1m?=
 =?iso-8859-1?Q?ueRBZ7cnXPdZr/Mn1e4zoDjTBw1zGO0Te3/pgp0OLupTnGOTM9+xywA/uH?=
 =?iso-8859-1?Q?6l11i+JOvuD76o9A+Ip7LDLx747CSxLwc3RAwWJv4QA0RV9aWNS/+nWbQP?=
 =?iso-8859-1?Q?v5bNS9pXUp1ZuymxazqqaFJUs72NdffIcbVtB6cCK9OBP9XygwawxUNdWy?=
 =?iso-8859-1?Q?ThAtDFb3gbOMrQRk35CP7CI94+hOsYHj2Z4LCXeSgoiNiSUPyvEPBxED98?=
 =?iso-8859-1?Q?X0NB+FOlchOWTiyA5ruah44Hk06RZYsh7RxbYd6W8FYd3tSZv0Mht4N/mL?=
 =?iso-8859-1?Q?iuoLzx1aldnoDiPmVKDV3mQTX8A6cBFpyqC+DGHAn+tpFMq4eY+UVruNVV?=
 =?iso-8859-1?Q?qpZwjqyLnbn6eDIgQMvDpI4GMQfc5M7EtbXFV/BT5bdv3MwMXJ4ADSzvJ8?=
 =?iso-8859-1?Q?2PqrShnEyI4+8vYayxzyHkXKx6DEJaa4VLThYrHXfPp53avG01gOhkiESq?=
 =?iso-8859-1?Q?0CYCpOaR92tOoW4uatpUsxQU4CeSvo+QGz5xRUD0ac9zqkuZ5f4msiPtok?=
 =?iso-8859-1?Q?tflNFELujtOws7L7uYcE24wl2eNOn/tckVVDByqANhJiG+WaCvlsPXkBEY?=
 =?iso-8859-1?Q?iDz5miirCc4EpmruD8MhacOtUEaP15AyeVKKQPGGdzGeSdtF8dYTZpZxRN?=
 =?iso-8859-1?Q?Ojg6HEtPabWvUn+2sxtt9bQyY+elSmTGOMiVd/8dnVlEwVYRl7Jk8g7BgI?=
 =?iso-8859-1?Q?MwS71iECBomj5G7g7vfEibD2rqP1?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR08MB8821.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9573
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F99.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9f5d2f85-61c3-4612-d343-08de366e6cc3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?qE1YFqS64Mhgu6wv3QKE+1X6vcDLssTBgUXXuI6iKfuxmhB2i2tzvvlZGJ?=
 =?iso-8859-1?Q?cvhUzSmoo3WKw3r4PthFbnpFEaee7i8MVxtfqvJMDPZcM80vy/U0ldbvgG?=
 =?iso-8859-1?Q?qzUaPcW1zEoC7OC6F+URd88K5BRcL6yQ/UzwVX1qV+aFFhhOcyYR5rx+9o?=
 =?iso-8859-1?Q?DxS2lxWd9ExnmU/e3gUTEhWo8anpGgxOgbN0K3fsCx+FShp5O07+WNUJbb?=
 =?iso-8859-1?Q?OYadAiZld5CuwBUwGT5oUzy7/evbxodY9T5UgkbvJa6WQPB7VtiU7QkRY3?=
 =?iso-8859-1?Q?5SM7A5XqnbTb3FqjwbaA0AmYGZ/+epW92rlXuQPUxHx1J5IGBJPrbQZlUk?=
 =?iso-8859-1?Q?QU2tW4gwHkdLTp/qa4gUmuRuu9ssmQPGHhewASTO+DBr15X+kwglOkFVmc?=
 =?iso-8859-1?Q?aJv8DTJyrteYTacqFBqWkgDgPXFFNcGScFRvvcLlSoAMv4pdcJ6vuDGfyF?=
 =?iso-8859-1?Q?UtzOnqqNxpGHNxrCX1e90xdCuAcjooQCdtPt3klcgmQ5+nQoJmjzOBY/EG?=
 =?iso-8859-1?Q?QdaSsrpKsukmVMoBlvPQsTOFll+YqDX/nk1onkiCk4h5MDlLiAVA7w6ZGy?=
 =?iso-8859-1?Q?/a5lQ/es4GEiGEwHr7WfVmamHFrCRLlcQGQBaZLovYB6VQZq9a001YazmF?=
 =?iso-8859-1?Q?A0uD+RI/XDyGbc/2va7ai7R+yYUR/OK9ErINYYKwVtu6VNDBvEeHmYt3qG?=
 =?iso-8859-1?Q?qlPkWsOVUSCLQL7hzPQ1VW+18BoxrsHn8wXzFaHGgSsRlm+4kWzzy9ucYL?=
 =?iso-8859-1?Q?m/epW5M9YBJ0F1WhIJ+pXqLsxXZyxdt/f8NBhOqtC6zL5MHpUWfrCtjsyb?=
 =?iso-8859-1?Q?GYgYh5EVUNEYT+q0S8adsPyeXLaDjTl0Fy3yKcydd3sNeQ6JIsLjffuwuE?=
 =?iso-8859-1?Q?ADVz+AATlkd4N4noA8FOqW2qd7f9oTLEZn17CIIpucdkcrymz+JeaqZkz2?=
 =?iso-8859-1?Q?y+J9tyEJQBvbGI7usk169SVlHhYSkxfWRw7IHNP86x6gu1qW9q+YAb5gU7?=
 =?iso-8859-1?Q?9GXKOt6xRsI2CnMS1P+qtXXppUXzZzoa+pIGSupCgZJIir3e49aoS0wyap?=
 =?iso-8859-1?Q?zWv6h2E0BeRABrN0q+qzCVvUkdQC3CX7spuYIM2+eoH6ZEJrsDjy1RXI4g?=
 =?iso-8859-1?Q?NF2RLvshSu57h9jj0Ju7M4bNJURAgA8BAAY8dRhappzolsfk9Ocsvb+E9S?=
 =?iso-8859-1?Q?FxeWU9h+nGLn0i/vMTSana0gkwyfZv2mgZWLS2mTzp7LEGtMJDmCV2K1U7?=
 =?iso-8859-1?Q?WvZupuQKFintzsXMNiuZifGpTwq4HG7YjsE9W2RAfK2WB5ZvgH7oNJ2LMr?=
 =?iso-8859-1?Q?DCl/kEy5ncNprNiq/Uwa6JsFgruz1Cw8tBHtFS22ddDx5+N+5TLvxztrQM?=
 =?iso-8859-1?Q?/nMWQ3oLrsPxhe5fTc/qrUtcVDaaQeQ4hyVGQo45A5+Zt+mVAAtp+bW05z?=
 =?iso-8859-1?Q?CTDBPhq9wYhc4nsl8xz3V3RzPM991RVo/s3jAjoK4kHgnGXSzx3aA2FvwK?=
 =?iso-8859-1?Q?a/exl4EHAm4MRSBVPmRUr3fG90Zo8f74ctxcKZ96Q53b58I2Gh1U14asmt?=
 =?iso-8859-1?Q?WCRH90tFVxRHwpJjcT+jRiAKAU7sDYWRgpV5ebdvxHp4U/MQdIXzVucAqR?=
 =?iso-8859-1?Q?N1G/cAZAd8pfo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 15:29:27.9636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f4e3e6-066a-45af-3985-08de366e9369
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F99.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7928

Factor out the enable (and printing of) the GICv3 CPUIF traps from the
main GICv3 probe into a separate function. Call said function from the
GICv5 probe for legacy support, ensuring that any required GICv3 CPUIF
traps on GICv5 hosts will be correctly handled, rather than injecting
an undef into the guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 25 +++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c |  2 ++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 968aa9d89be63..b06c72cd933de 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -879,6 +879,20 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_=
instr *alt,
 	*updptr =3D cpu_to_le32(insn);
 }
=20
+void vgic_v3_enable_cpuif_traps(void)
+{
+	u64 traps =3D vgic_ich_hcr_trap_bits();
+
+	if (traps) {
+		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s%s], reduced performance=
)\n",
+			 (traps & ICH_HCR_EL2_TALL0) ? "G0" : "",
+			 (traps & ICH_HCR_EL2_TALL1) ? "G1" : "",
+			 (traps & ICH_HCR_EL2_TC)    ? "C"  : "",
+			 (traps & ICH_HCR_EL2_TDIR)  ? "D"  : "");
+		static_branch_enable(&vgic_v3_cpuif_trap);
+	}
+}
+
 /**
  * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
  * @info:	pointer to the GIC description
@@ -890,7 +904,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2 =3D kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	bool has_v2;
-	u64 traps;
 	int ret;
=20
 	has_v2 =3D ich_vtr_el2 >> 63;
@@ -954,15 +967,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 		kvm_vgic_global_state.ich_vtr_el2 &=3D ~ICH_VTR_EL2_SEIS;
 	}
=20
-	traps =3D vgic_ich_hcr_trap_bits();
-	if (traps) {
-		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s%s], reduced performance=
)\n",
-			 (traps & ICH_HCR_EL2_TALL0) ? "G0" : "",
-			 (traps & ICH_HCR_EL2_TALL1) ? "G1" : "",
-			 (traps & ICH_HCR_EL2_TC)    ? "C"  : "",
-			 (traps & ICH_HCR_EL2_TDIR)  ? "D"  : "");
-		static_branch_enable(&vgic_v3_cpuif_trap);
-	}
+	vgic_v3_enable_cpuif_traps();
=20
 	kvm_vgic_global_state.vctrl_base =3D NULL;
 	kvm_vgic_global_state.type =3D VGIC_V3;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2d3811f4e1174..331651087e2c7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -48,5 +48,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
+	vgic_v3_enable_cpuif_traps();
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc29..c9b3bb07e483c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -324,6 +324,7 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu, struc=
t ap_list_summary *als);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_reset(struct kvm_vcpu *vcpu);
+void vgic_v3_enable_cpuif_traps(void);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)=
;
--=20
2.34.1

