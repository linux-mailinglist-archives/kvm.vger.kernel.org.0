Return-Path: <kvm+bounces-60828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD8ABFC6EB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 16:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7E9D667F52
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5650834C9AC;
	Wed, 22 Oct 2025 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="icq2X8hF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="icq2X8hF"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011021.outbound.protection.outlook.com [52.101.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB034B40B;
	Wed, 22 Oct 2025 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140783; cv=fail; b=AjxmA3DMlE987Kagxk8s1ioVVin4UoJUhES6fFEY1N1cMbECBCxLmBimFYGy2UtVYdy0YeuXLzg69tcGKERZYnKb6p9iqhHm1UGit2VpybEnzN23w6iKI7+/A6bDzbRBaL8QIDaaQEVZwMtKWusbN5iLtswJSyg8Q8qesxD6zmE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140783; c=relaxed/simple;
	bh=rCxCis+Id2nkopGp1NvQJrU9A3X4mH5V7qg+y7GsbJc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GgjYz5SephaO96JGwuDGV2DSxb3zxdtcRSA6NWuKffijBbjtqSW8fIKi1A4xNAz0l6yW/FGuAH7Cssv4ho5iXzOLZcxLmrw9R0kt4J0aQ7XAunlpNbRxx4WxJykG3+hwcQDvcuyO/qM/V1YrCOQAyJhEHV7J/ZdzZybSyJ8iNr0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=icq2X8hF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=icq2X8hF; arc=fail smtp.client-ip=52.101.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yxYpW+cVdxzscWXW8akSXUK1Bd86H5bwgA0IF/Ob0KozKXTd1J4T4/4V0mrtKwGQR38Tkgsq0vfejUmFCjRsT3SXUMtesBK7w76Hf8Fi0BDjCtrglZxyyvQmmIes5hRV2pkD37+KiU320t+MLhqU8ucadCRi3KqwMWo4XhsZThO8rdhuZjmbqpY2yI+nuQqTcDrjuK4JRkklEIQ0/Vs2t99CYyRduICnJ4DVoZJtWdzY8nfnuRzSJ19u1pSxgUh1AU9dJDlbWBaCAi44mOZVeqfl53v87KJ0B6EZoAM8fcbIMIWrEpEZuxq6ERSnyt32ehL9QY/Zub72+RoMElTu5g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSfufmPkBD6dFJODWzCBf0ARHrNVuSB68xXyngUA5nk=;
 b=xDU86iFk2YnllbzAJum3gsfprNarp68llU5ReoXAqzNXKOkKlNTb8izNtwDWbKiL6tXOUim+LoCLoX56gAksr7rUfFIMS3kYEOvHAysXNA0uWNHx6Ccok0x/IY0Myen9F4ZPEKTpg0TkKK7RxRYzmfqjWZ+CaZudo6iBq5OllUmxokSddVjIo+kIzRKmSrlx+NkQcQwZNIT8VVK/2dQOujhiNbZmEHUIlfVwCO3eg1cXICyldi3lc5sVCmkpj8JFF8dVTH9mWXPbY1D/zI/uZ2AHuZm69uccu5VpvC4m1lKYgCDD+oZ9MzPuNAhzXk1a8xsbbwamzZqh+DKr5xIW+A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSfufmPkBD6dFJODWzCBf0ARHrNVuSB68xXyngUA5nk=;
 b=icq2X8hFl1VnV4UmtLmCo8382vYkiuyhLXr3qFfiB7DrutblwfXQ8kh1dR7tHIgJb9GGzHUOwWzSkBLLWWf/JrppPeIWwEW8C2VQKZkv6s8ohu6O9wGXJLFPQOvW4K8VOampS9HhkcsTZo3dtm9lJZU+Twk2X9mKX1LsCQwx84o=
Received: from DB9PR02CA0003.eurprd02.prod.outlook.com (2603:10a6:10:1d9::8)
 by AS8PR08MB7862.eurprd08.prod.outlook.com (2603:10a6:20b:52a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:46:12 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9:cafe::4b) by DB9PR02CA0003.outlook.office365.com
 (2603:10a6:10:1d9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Wed,
 22 Oct 2025 13:46:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Wed, 22 Oct 2025 13:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yorXMOdgP6X/bkBcYC3QL6jEUhWtn7zaDZGh9k/UG2HOgbCrrXHTIkhz8cBNmi85YYrLZFuWD7EQ3/OwQa8G1aK80Ydb3kiAz79AsBM+qrCqbsDAbhsXrUogjzkOwTotqjKAFgyMIGezYHVqa5VPhm2vJyN1bOtmVEbeI6T0PkHJow/LFlnqgunr1O92WCa2l/dbyj+EEQmCi98IUelH1E2JjM2IvP+ZKWpuyUgh7tZX2k8tluGm+7H1+yRzBrbzwmcvC820Mk6Fa+MiHRKFwmRzPBSVAfwE0ziN2b3dkQGxrZixb95yIEkQIPi7JWxYkkSGXbgKlG5qkVAAp5xV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSfufmPkBD6dFJODWzCBf0ARHrNVuSB68xXyngUA5nk=;
 b=VbN2qflP3uLABz6pjBVCvjeFFHC05hZ1k8ZB1HoZpkFxNjaAlObLAwuO4oXRnpsog9C4cak488maOnQ4Ifapfwwssrpq1Uqu5Y/4l199iP3lkLpk5GqjlLZUGuHGadux3EkkcRQdsxhmdTQAn7VxGkytqYrILHm6JIkw2GEgvklROmkFsIcn4lCt6u9VLXQg5p3+rsrmv8CWxONGYc0Xj3kF5yXiNoMSfu2ThsFO66USdzwFZUrFmjN4pI1ePm6xuwGchgVQVapqkS6DchSqQAd6UtyfOyIovwmh+tCqDPWJvVIzNE9WGY2J5gmO8YgrSyioXM+GnTJvbBEg6wbgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSfufmPkBD6dFJODWzCBf0ARHrNVuSB68xXyngUA5nk=;
 b=icq2X8hFl1VnV4UmtLmCo8382vYkiuyhLXr3qFfiB7DrutblwfXQ8kh1dR7tHIgJb9GGzHUOwWzSkBLLWWf/JrppPeIWwEW8C2VQKZkv6s8ohu6O9wGXJLFPQOvW4K8VOampS9HhkcsTZo3dtm9lJZU+Twk2X9mKX1LsCQwx84o=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by AS8PR08MB9244.eurprd08.prod.outlook.com (2603:10a6:20b:5a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:37 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:37 +0000
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
	<lpieralisi@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v3 2/5] arm64/sysreg: Support feature-specific fields with
 'Prefix' descriptor
Thread-Topic: [PATCH v3 2/5] arm64/sysreg: Support feature-specific fields
 with 'Prefix' descriptor
Thread-Index: AQHcQ1ol6c0bgO87lU2AbrGEAnGqTg==
Date: Wed, 22 Oct 2025 13:45:36 +0000
Message-ID: <20251022134526.2735399-3-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|AS8PR08MB9244:EE_|DB5PEPF00014B9B:EE_|AS8PR08MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e6dfae4-9dba-472c-c496-08de11715ca7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?JaPCxjzPpGpKnGigFREqnd18JbctTRXCuAjojtO6UR2m0x9CVB2Hxj/Jih?=
 =?iso-8859-1?Q?TxqCr75pvuTZKNED6vRcqL2fSbOA0U8uwb+K5PHbivvr4I3kcpa3eIU2Bd?=
 =?iso-8859-1?Q?l4Y3Pp6BWfavfy2ehAXlfi5Kfnhp0lNQyz63oVszJNMMPyxiOkrT4/ZPUw?=
 =?iso-8859-1?Q?sNj0Qvxyj+qtgnNnT4ww63A+GwWLzB0SZmUdTfIW8pI0ix+7rTpuaexFNx?=
 =?iso-8859-1?Q?4vl9DOdhyUW7ptJdtdkPkH1EoB/O8YkzgOulkNd97jUuRhjTJKgejzpoOv?=
 =?iso-8859-1?Q?QoxC7WkEUGamrOpeghqT+tPnqtXgEUCXzLSYGXnUJF75yBkCe5+1boAnR8?=
 =?iso-8859-1?Q?xGWtrWCHQvi3xY/nZC1R0FBWBlPl8rgz5WuRQaCJw/yOv+o8/4JGNsg3Cd?=
 =?iso-8859-1?Q?ZoOS6+mZMr9JjEmf7CAnUC56QL/eYwyqWwVBUAdx/Wuj+36D+9Nh5UYTOb?=
 =?iso-8859-1?Q?CR3WErvVUb54uxdD+CNRGyjn0fiWGrvyawzPd9KYi55Xb+Fp2cLvXJ2cXW?=
 =?iso-8859-1?Q?3LkOXHISupMO9UvZNDcr8YI2OtyzbzAKqYJi3zWDfn4SAVGExl3C/SODqJ?=
 =?iso-8859-1?Q?Iic7kEyaKcwAYoUfF/22aAbnHQ5sC3g9I6Bd95aDcwoebRq9sHhk6i0wDp?=
 =?iso-8859-1?Q?CW3jZ0oqqEOx95NaefLJYBIhI58zB4+EDB6aPsXJvLfwl/6QUKlesW1mRP?=
 =?iso-8859-1?Q?96HJQ3P2wC9tu+vTfPa+uEfK0k8a9x7MaEFWydxqaJ9olHkfjcUJeJp1rY?=
 =?iso-8859-1?Q?NM/Ti/55ldAqMKv9mtJJu0lEaX6UlVxF2bZOzsusYsrMuxfDI2EHbpnKUo?=
 =?iso-8859-1?Q?QX4T3r8WHinvwJbO9XIuRa2d/iTn+ZEmFsOtWmsUPLfgGxevG7HMwiJB/7?=
 =?iso-8859-1?Q?mqd07BHpaEZK6MjYh/1HejsYqG13nv2e82m9jf4teDv7F29och0uOkXkKa?=
 =?iso-8859-1?Q?R005KMcc9sEQAW4UZ1w+pD46pug7bri7MX+a0pzOw9v4flABzJD2Rj/bSA?=
 =?iso-8859-1?Q?xlcglbayoqKw/okS7LhwP6iRvB8BSd+ZMjCFBedMkFR9BfEcVQQKO3Ixne?=
 =?iso-8859-1?Q?E9PYEiZ5K/kXmKMR+kNYrnCPV6orQ7V9sszXRNZ54H659v1QHSdgu6yhUf?=
 =?iso-8859-1?Q?QFizXSGgJPKizggTeVnofzB7Vqm70O1OiiQ3siyI/HZ8lkislLufei7tC0?=
 =?iso-8859-1?Q?EOkYJLDPNPo97wJlZ/xts2laBDSkZv0U5p17Koc3ibnzwQCbPxdIXrwWpQ?=
 =?iso-8859-1?Q?utLAavyFELEWgIwMkPKfovMkk0pNrRnj4RaZT3ckUR934zY9pqx4jiQeuW?=
 =?iso-8859-1?Q?Ns+0BEd+WbWmqg8PJnc1ZXoqx8gcKvfs+dT6x3LLxna1lLVjarnUX0g3pX?=
 =?iso-8859-1?Q?+5euFNch6uz6jakK5V+9IF+GRxphf9TXkOpVgghKKbKgGGut9pakJn/t9d?=
 =?iso-8859-1?Q?/tSvVM4p7pUw2ty8RcUq7HmJ+5aTNA3o67lxVSi1A4nG/g70aOZ41e181V?=
 =?iso-8859-1?Q?UA2fgJkOkanJMcvkP/8uxaPr3tpTZgcj4UmeewzySFG/F5/qU99RZUWw5Z?=
 =?iso-8859-1?Q?eMKMx7c7dlIRT71o2IDkqsd5F+V+?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9244
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ed128ab2-285a-4450-3ea2-08de117147f9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?DZLtZ+z/WCoPoJqT+UWDOsfy2zo2xhAQX4KBQDT9WjvGp4cWYhKTYWdX93?=
 =?iso-8859-1?Q?+QL17XxacKvOCmTC1x+4qZwQXVqtB0tlU5i361dlkQgV7owk959k/mvRCJ?=
 =?iso-8859-1?Q?fzIhNLj/dYWE7q6pvluiaCp8n6rgcRfQXOLBM2sYjtzx2NkQiiLYY9ydtm?=
 =?iso-8859-1?Q?ASg6XDXY3BPkxMEyKxhb/FhXXm4wocKFWckqpgbvXbiAuiuXVP8tFNeHon?=
 =?iso-8859-1?Q?qC22r92DJFCkpz/YYQkEwYWUNkpCoEePtndAAavMZQuOY+GXAsVuvZRPBp?=
 =?iso-8859-1?Q?iuKmMW47syXg9YIKfKiVxYCMunj2dQnAXdGoM5ZTuNeEgkzuMaff4jHVHU?=
 =?iso-8859-1?Q?tWp2K0QLQP09FK97p+if6/skYnSb/TFQQQvrnvVYMBGqmtckSmQhGqFO3+?=
 =?iso-8859-1?Q?FbjjBtB66OlQIZvlfdfS/sKHUkUmi0/ngsV5lLXKIE/aMak77gGV/il3fL?=
 =?iso-8859-1?Q?avZ+XklBE9mRg6l/Eoa+UPJuQaDcYYUf5h2hbnC0platIsNynCxa+nXZjy?=
 =?iso-8859-1?Q?pcZNvTBtw6WwafbOyRnzhSLItKOz+e6YiiCnRnVOQSkCBwrTYBctIti6VB?=
 =?iso-8859-1?Q?WL9SBsCr+qx7Vw4i96T8mHFqrnYQ7bLZPTbuMcMPUQhRHilCbgGVybLJo5?=
 =?iso-8859-1?Q?3pKEQp1TtyMib/z1/IyXlk2L1IzZoX9j4hlTPOM2NjacmAP6aNOmcZjv8U?=
 =?iso-8859-1?Q?iv1xqUZSIHbP91JpgDS71R3PvIWNIHkuTq6qmBR4XLIuQWzZv3RxAZbFYt?=
 =?iso-8859-1?Q?qtjR6SqF6uJHaW68ytMnKbiOAW1KscTrSYo8Xi2lVlZTn5Eu5NRn0F/qNm?=
 =?iso-8859-1?Q?TT34Vdc8PrBjntqt5w20fmlQ3v1gDCVeWeXwN1Sf+m/EUOgynHORwhkz6m?=
 =?iso-8859-1?Q?NgGridwtW1d96LikH7ceqR0WiNG/VnUE85TbMhOHYNuyVBV5Om3sXiO6aE?=
 =?iso-8859-1?Q?LMCRMgAuC+dTp1WA2b6ogKhzlgzH9jLMoDRkQ4UplMp9Nr7KZpKXG1gPDr?=
 =?iso-8859-1?Q?pzPyStABCc9QRgT9tArnkbPe9HaLsbeo7edO8jdckWHEJGt29R3nV3bV3y?=
 =?iso-8859-1?Q?WszUfb6DxfyZi8FrCys8sjXNteP24sC+6QGAwQtzpLo0dbUo1Se+vzVCXL?=
 =?iso-8859-1?Q?VFly692rxnLPQQvH0RW+MbnYynaKcJNW5OvamzASFl89qDd17wMLlL9pvn?=
 =?iso-8859-1?Q?O3LPBkffOp8/myKSC0pKVPxhq72uW90v1zr8uun3f7BH1ZMmSklR/ppRqf?=
 =?iso-8859-1?Q?wcV1dBObIdqMlNkDS6dBG2gxc4VDS3XWgxzJZISvhFyTiDeGYBFdZlHX+5?=
 =?iso-8859-1?Q?X57fuj2KcMiF0tqkC6YV9EMUmGVssZGd1YdXWVCjhC1/CpiGlzCfQXZ2Ro?=
 =?iso-8859-1?Q?W2JvNl0Nu5XEmkUOvNzf5rfymkem+4LbuaU+OmyGXXYoSOGEVNWPOnba4e?=
 =?iso-8859-1?Q?k9gGY/1WPF1Yef6MKhBQHz+VO/jclGKJvKNDSL2fc1U2YRIDySnysCtf7y?=
 =?iso-8859-1?Q?rho5Nq3buJjL2RhBpQr4xSFYjiuPUBjWcOJZNDmjhyTd2vyQeLc6vaw9Zh?=
 =?iso-8859-1?Q?lAWcbL1KjOnHhKpk9NV9nLD4k5pDixcv5Jngv//N+W4GySGs/DbcnQGTt5?=
 =?iso-8859-1?Q?2CMSz3aNNnH7M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:11.5484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6dfae4-9dba-472c-c496-08de11715ca7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7862

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

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
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 126 ++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index b5e5705ddbb5..3446b347a80f 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -44,21 +44,26 @@ function expect_fields(nf) {
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
 }
=20
 # Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
@@ -128,6 +133,8 @@ $1 =3D=3D "SysregFields" && block_current() =3D=3D "Roo=
t" {
=20
 	next_bit =3D 63
=20
+	delete seen_prefixes
+
 	next
 }
=20
@@ -136,9 +143,9 @@ $1 =3D=3D "EndSysregFields" && block_current() =3D=3D "=
SysregFields" {
 	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
-	define(reg "_RES0", "(" res0 ")")
-	define(reg "_RES1", "(" res1 ")")
-	define(reg "_UNKN", "(" unkn ")")
+	define(prefix, reg "_RES0", "(" res0 ")")
+	define(prefix, reg "_RES1", "(" res1 ")")
+	define(prefix, reg "_UNKN", "(" unkn ")")
 	print ""
=20
 	reg =3D null
@@ -170,19 +177,22 @@ $1 =3D=3D "Sysreg" && block_current() =3D=3D "Root" {
 		fatal("Duplicate Sysreg definition for " reg)
 	defined_regs[reg] =3D 1
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
+	delete seen_prefixes
+
 	next
 }
=20
@@ -192,11 +202,11 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysr=
eg" {
 		fatal("Unspecified bits in " reg)
=20
 	if (res0 !=3D null)
-		define(reg "_RES0", "(" res0 ")")
+		define(prefix, reg "_RES0", "(" res0 ")")
 	if (res1 !=3D null)
-		define(reg "_RES1", "(" res1 ")")
+		define(prefix, reg "_RES1", "(" res1 ")")
 	if (unkn !=3D null)
-		define(reg "_UNKN", "(" unkn ")")
+		define(prefix, reg "_UNKN", "(" unkn ")")
 	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
 		print ""
=20
@@ -209,6 +219,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	res0 =3D null
 	res1 =3D null
 	unkn =3D null
+	prefix =3D null
=20
 	block_pop()
 	next
@@ -233,8 +244,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
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
@@ -244,7 +254,7 @@ $1 =3D=3D "Res0" && (block_current() =3D=3D "Sysreg" ||=
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
@@ -254,7 +264,7 @@ $1 =3D=3D "Res1" && (block_current() =3D=3D "Sysreg" ||=
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
@@ -264,62 +274,62 @@ $1 =3D=3D "Unkn" && (block_current() =3D=3D "Sysreg" =
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
 	delete seen_enum_vals
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
 	delete seen_enum_vals
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
 	delete seen_enum_vals
=20
@@ -349,7 +359,47 @@ $1 =3D=3D "EndEnum" && block_current() =3D=3D "Enum" {
 		fatal("Duplicate Enum value " val " for " name)
 	seen_enum_vals[val] =3D 1
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
+
+	if (prefix in seen_prefixes)
+		fatal("Duplicate prefix " prefix " for " reg)
+	seen_prefixes[prefix] =3D 1
+
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

