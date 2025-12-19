Return-Path: <kvm+bounces-66383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A2DCD0BC5
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:07:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1BD8B304B3B1
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB31363C72;
	Fri, 19 Dec 2025 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mC5eaM1A";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mC5eaM1A"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011056.outbound.protection.outlook.com [52.101.65.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0535362143
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159671; cv=fail; b=PhPwLXbxe4kkrhjYfyg5BuE/5knuLPxKU2FojlS9fzLJ65n3t/dRK6bQHL8+GUVzeksi2UGyHVdGQoBMVWvy74Y1U9ifD1oqjE0Ri9o7ozJY3YOS4DCvJ4x5hn7TlOYcAfKBpW/gfEACEW0ybUQGxaXxbmv4e8VGQGAiWCuWtTs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159671; c=relaxed/simple;
	bh=8RLzt4QBBMCufQmLjTgakMTEnc1FfOJVyrLUtdQ5PTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g+HV8keaoeRR8V7YdkXUK3v0dW1y8D4Quasi3oTa2Ack3fGVTZBEWYjigTM/atdZ1tDWUjzXuEh+7iSJVkX6GwZD2B8zpfyzK/SxqqwF6eJjl8xvhDLLTPuzlQnOdn7VtfyAZWp9n2jW13LNyuno91R390t5Vn4FTTdkpWb+75E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mC5eaM1A; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mC5eaM1A; arc=fail smtp.client-ip=52.101.65.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m04FaYzP/r9zww9tllDqSDjsGFYoU3pK3rl8oSkqS6zWVqe4bhknmo0nC6AuqvMHmgN6NSxKfjVFoF2N1HnB7XuSLjyHGmuUSC9X/0jPdzDb23WVKtQTydH+6Nl6W8vQALYtz8cTZJwDNsvwRjNdlSzZ5SeMKFvlogbV1a9jtnvOBwKNI33fhoU8WGCkGlh5+HTlFbjOnGtsIG/W9wtBLDO6P/NDnFSqQF2t62OrKfbgLB55O+jGatX7rd4Qf/7Svq1mQHXGgfEH2lYjUb9mYO3k6v6dfxMh+t3EyvG9e93XKz43P2BUweCpls2KcCwQjnrMA79OoYjLf2ThVh0DLA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=DHwPOOzHbduTNLs68Wub8isVzTXd0wBmeXgU6A32tg0FdRJ9/BMG4H5A7Jmy+W1pvc+Ax6vyVXiX9K7KaUjDbEF9K/DwmeCm+kN2w03J7oUEKas2lL1WUbpKDz01SkufI98q8fCNBWFVY4OWaEa0z+Zajv8mdLpKiTyEH411HAjM+MqZ5zeVXxFRyNh6kLwNnvozRtyObhhsRPURJruH9kSfBO1tG1VI+GoARCfwC4d7nOVcoXXNmunT4ZU11wEaj3GsG2Xu59UaJn0JIC8sFudUrwwABirvvPV5SfH/+7fu4mpoMwX3Ad39F1sRAI39QKnzJ6pze42yX52fw4jR8g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=mC5eaM1A3vYrMWHTqfoG17YANXtBIDQCr5Zfz+XNNbUnVeG75vlXGM7JTyre79RUzGn27uvA0depZQyqvhF0C/y25BT5igi/2+ffVxVNPJvzbfR/bkRzkDBQ2ShSfxnUwtLU4kHElXwh6e9MDTVIW3xNsoesCYY4efT3gELGMdg=
Received: from AS4P189CA0061.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::10)
 by AS8PR08MB8633.eurprd08.prod.outlook.com (2603:10a6:20b:565::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:54:21 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:659:cafe::4c) by AS4P189CA0061.outlook.office365.com
 (2603:10a6:20b:659::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sa4Wbj9enN5/TSDrPEAta+ROtKRul6xDCye1+JaCcyBaFvS7ImCw/h7oZi1afWfr6842vkl/NseYWW7BatAYFfhZ/WaA2Y75MWv1kEJSq2qzt62xPAj4SpXDbkT10n2PWSjnNBLrPF7nLv6r4BbrYTnLmXDC35i5mg3CKc7KUCnnpSDDBq4mbM1kJVgJ6j3/nuT61M+hXpD9TDSPoqQtXaobNoOZUlk1X5lBm0+4onfBozkPsOh8hJJYU+do0ex07pFNgsrvgoUCpq39GH0PArszQw0EwJVHSJYXmIjQRM6QttkZI4mTXYTW9fCPn9ElmiSS2/lpNj5zrauYhbwTuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=JxrCW2lybWKAtrNve0kREY1s87G6zf3JpHwQJ0qrvuRaEC9VbR40jIWX/ZNd/ohKEeI4W8Iyby6MX3xOX3/ylWCgufnqwH7EBh9rsSdaOOmaHh1iJ2DNLWNwDmjmIyQjZ+ZB4Y2qim0yXPb0uGbNyR4NB2hTAZXXJkCvD8oNXO6fF7xgph8HHjdjtvUxqxY77//+UnGuPEpZRFhHcouZ1u6ByFow6Oz/Yj6nzW/pk57AMZ0KFDSFBtIaQq6kskK0VvifilloLrHTBDEl1PDAVmvY+4AccNQtIz4QU5I+xVckZWrFL1Lmr+7pDinN1DSQDey4PfXvZoj7jtbqaNmYCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=mC5eaM1A3vYrMWHTqfoG17YANXtBIDQCr5Zfz+XNNbUnVeG75vlXGM7JTyre79RUzGn27uvA0depZQyqvhF0C/y25BT5igi/2+ffVxVNPJvzbfR/bkRzkDBQ2ShSfxnUwtLU4kHElXwh6e9MDTVIW3xNsoesCYY4efT3gELGMdg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:19 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:19 +0000
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
Subject: [PATCH v2 35/36] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v2 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHccP+G1U/4ccFGo0S9ZvLCqyXGiw==
Date: Fri, 19 Dec 2025 15:52:48 +0000
Message-ID: <20251219155222.1383109-36-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AM3PEPF0000A791:EE_|AS8PR08MB8633:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd75324-24ed-4a38-6b44-08de3f16e01e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?b7Naxmb0FMbOkIlj3Avbefipa5ECrHhqcXRQSPKrNh6fqAwT5HcnQTl2Kp?=
 =?iso-8859-1?Q?mCJ5//0YgyL4fmjAz0DTCblJcSzHb7GaP95sn5OaCwNjJ8jw2ia+NlYzDR?=
 =?iso-8859-1?Q?mvpoVeTvDGVYNrlsJUEguc2eo5o48HJvBLFHMQtMUFZkhHV82t8Iunl3ye?=
 =?iso-8859-1?Q?A+Q4I6oLwXuAyFi5nOeoRvXki0BQPtYy2zew7qIkU4LnHRwQYvsEzbQIlB?=
 =?iso-8859-1?Q?gQ7XNVaRs2taXqL36nxRSNn5O2Bge1FyySmo4Y3OAenxQOTJG9Z8i3PNlO?=
 =?iso-8859-1?Q?lHCH+AL6DHx7xhE2nlgEslPRrudzKtTwZj28Igr5vjMxOP2ECJPgtew+pc?=
 =?iso-8859-1?Q?7s7ev7aq1g7rW3X21nh8xcIYMKLjdhUND15HnDeUDf8L2qUIOURoM4ILK+?=
 =?iso-8859-1?Q?hhVc+FR44uXWvuwrqEI8tf6JU0fSRKHicvARkNnGkQY5QjOP6aZA2FcZ8t?=
 =?iso-8859-1?Q?EHfECoWVIMhAd5QEFSdxwAANjMNN55UVWnYtRHn5DEvF6HIM2JaeeDsvZO?=
 =?iso-8859-1?Q?pMqcBGc2+EePbWUlTunqOmEUl1WUQ9rLdpudfYKtWm7OV8lEPE6FF8leWs?=
 =?iso-8859-1?Q?0KYPrUCa8L2LibYeWXFeBefjAnqMfupgrNWCYd9U7a5uq1vL0frj4/FgsR?=
 =?iso-8859-1?Q?RC8bLIZRL64tss8xAgiB+DE1Pm4wRi/PFB5D/72PggmvoXeAN7B3xj5l30?=
 =?iso-8859-1?Q?HLMXiz/Wpj5+vhLsB2dKk59Yn1MiZA/V0LGAqk9xZt0zDPqzCwhLiT2l/F?=
 =?iso-8859-1?Q?BTo9dc8FvcGpIxM2Fbo4yEeelyLKrCtTMfUaSQhqcoqDjZDNdX79LsDMAG?=
 =?iso-8859-1?Q?kihKbvQKCX/jiHCQDrMkFgT4H8MfBE2tfFVKaG5S/EoqRybpqsek8nNSRN?=
 =?iso-8859-1?Q?/pD5ooajFqbgy6DvHLUGkdekXT2JJ+UdWaKx3A/10lbuZD28UNxL5nxof8?=
 =?iso-8859-1?Q?B7ZtXwfTkUuxRDjjl4Z3kCQYo3tvA80s/hFUa26KhQ61xceZi9I2dcKFbn?=
 =?iso-8859-1?Q?2ruJD9LsFNpj+FDFaYC6tIuN7Vqo3Z/k62FaO9EwyZnim2YE8Kazi0XM6f?=
 =?iso-8859-1?Q?IJs7X9wkxvaY/myrUTDbp4/CXvljSYEnwizhTyIlioQeIdG2MA+XmIQkLE?=
 =?iso-8859-1?Q?sU1gZHBMaIeYNfggsqCXESOjZ2w2Tiz0T/ATai7ds3YLw9wFD/60lAL+t8?=
 =?iso-8859-1?Q?raYq0SrItIQKkmV8zAyV7vtOzrOMgcZbtrJoGNLa+P9lbPpVfxl/dBrwa8?=
 =?iso-8859-1?Q?ctEfQgipYjO7AGP+v94FNAjiPRqAo1rubWRlhzELHJAgg9iy4Yte94hLyG?=
 =?iso-8859-1?Q?5I/5+FSKDMvrbXX004fu53T/gJwt3WNByYrNG1K0j6j7UDUekSfY51kaxL?=
 =?iso-8859-1?Q?nNNNvfK1w1MDUQO29/qFp44QS7cwiV/1+YQEGoHGUFy0utIzD99X6CbtCo?=
 =?iso-8859-1?Q?OVPl3mS7MY0vrr8xCDu+wn0dEzm3rUWeaSWxb0NVB92aRdsNxCDN/4kB4h?=
 =?iso-8859-1?Q?xJBVXwxWXf8X4pPTfhUj3p+xQt4aZn+p854LIn6OVTXI9zcHym0LLBGt1v?=
 =?iso-8859-1?Q?sCv09jVoYsxCLnwSvysMxgAoHYwh?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b397af56-5a5a-453a-50f2-08de3f16bafe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?hYNsSL/rxTcNghKMSu7Lp9jlH5+WJNZEPWTzhXq++Xx6q9mDd+Hk5KTHCE?=
 =?iso-8859-1?Q?ODbN/rYa11r2mtS2ifmxrE/dkfB0FlGWY0Thp3l0j8UTqtccnuAQkIMclK?=
 =?iso-8859-1?Q?4BygZzSts7EoiD8ivqNRTyA7f7BOi8ysRjU4ISLaItUj4UOQ2J7yICStjH?=
 =?iso-8859-1?Q?LS8Ug8WGb1Vx47QiNvO6RRXAj81WoczEknXE+CmaNWnSvA5aGAwGER3P1q?=
 =?iso-8859-1?Q?2eTz+ncdSQVIF59nMsCedHf+kW6GB/nd1DaCype4DkgVCZ8Jh+6J1aON2U?=
 =?iso-8859-1?Q?ephmMU6CotFAzqrCzRfB2esdxjGcjz/+eZSVg807xV0DBYqL7eGWV25thW?=
 =?iso-8859-1?Q?3f3dg+9Z/4ZGjyysqyhoOkf4Hx0hFXksw5tzKNGuspeJUuSlKReZzU9lU4?=
 =?iso-8859-1?Q?XtbWyudGSX7HFyRvtXpJ+tEYuxStqvDMk7J9TpOpLGmN01jaaWk7W4IXVb?=
 =?iso-8859-1?Q?Vea1aBY1f//+Rh0O12vOU5nlrfGvDVl5Qxva2c98wUFacvn2EoDxxUEqlU?=
 =?iso-8859-1?Q?2LzodrjdiX7xHxfmVu/3PEvklbo/LTeRK9E1IvalV4U92RZ+2EbD90iCqL?=
 =?iso-8859-1?Q?VE3imfbeSjtCH9gXDT4o0TEqymSN9XvuRPf5Tx2l42708AJKeIwWRDKOHd?=
 =?iso-8859-1?Q?lVsi9Rl2XKq66bQa42RFS6rHbur9kWFuE4BiQCX1oI+9spyPBhGMPf0URa?=
 =?iso-8859-1?Q?67difj/m2+IlmyK3Xmgi6QQwroL3pkdO5VUtpkjg/0tIWjY8Z87H8+1lUe?=
 =?iso-8859-1?Q?gd1YxaUY2UJ8KnMwiVs6iZbpBrU9eV/6BECZRJaPvUwMIFxSJU4n6p90bV?=
 =?iso-8859-1?Q?gX0R2kw+v5fTjp0FelwPtDZBdBr5fGab0F21aV2thiayRLiIqs4lXPYUPy?=
 =?iso-8859-1?Q?Oz01wZmVq9O6/+nHWMc8QxoENyWLQAQhTkyQPw+0FaHFlryW3l2jCFTTVe?=
 =?iso-8859-1?Q?VT5T2nMZmQyyrtbxoCeXO5JNX5qRv6LirSFYhSSf27PypyB9wsH9KHLn0e?=
 =?iso-8859-1?Q?aDlzeSOjM90Vu6YwftU4WMgYSWLraicPKxi+eCpv7yegOSBWlMRVeOUY4z?=
 =?iso-8859-1?Q?EH/r3NgWSu+5Uy8BqjDyVWcWXbuac9oOXAbO7DyaIoG07vJmVDB9RWpuBy?=
 =?iso-8859-1?Q?+MIDDTxnSArxehEXhCtlolVz4t4+/pPCAHkP7hFtZwObS7ErGHFc73aw6L?=
 =?iso-8859-1?Q?FPX1EYBb6PGekpHqu+rai9bwemV+hQym5Mwz5+ZiBnVYalHms8roKCXKHm?=
 =?iso-8859-1?Q?xZ/9sgOuE+jBoRsSKKVLLJAQ13zpCOIpJfuPcJwNsyxJ244ge/GiQYGbHC?=
 =?iso-8859-1?Q?7hsgLg0J4XDW7NpWn50m2i2rbv9zWhqP+0X8sYUF79kVewEVlo2ZRISPyh?=
 =?iso-8859-1?Q?rsH9h0WZ8kp0/ZySejIeXqaW0ps+7fZ/zvxrFVNSeuTiN9YrnFM5hWy+sB?=
 =?iso-8859-1?Q?kHVSoKPNQKMPPrLVxwwnn+fTmnc2D9EDoDfX3f9fe4kR3pdTZEX7z3aeOe?=
 =?iso-8859-1?Q?7HrnfUmo1Wg/hYalPSs3Nzv0khEZwUo1tj9N8TE99PcRkiz18KP5reXk2m?=
 =?iso-8859-1?Q?kLWPGvNyu4RyKhS46oZUjDhd5G9PFXxUq5uOyjgvTO/nZu2lKm3QrOcQ5O?=
 =?iso-8859-1?Q?6B4g1wqbm4ekY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:21.4121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd75324-24ed-4a38-6b44-08de3f16e01e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8633

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to recieve interrupts. The first IMPDEF PPI (64) is enabled and
kvm_irq_line is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 248 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++++++++
 3 files changed, 397 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index ba5c2b643efaa..5c325b8a0766d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -173,6 +173,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 0000000000000..5879fbd71042d
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include <arm64/gic_v5.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+#define NR_VCPUS		1
+
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+	uint32_t gic_dev_type;
+};
+
+static uint64_t max_phys_size;
+
+#define GUEST_CMD_IRQ_CDIA	10
+#define GUEST_CMD_IRQ_DIEOI	11
+#define GUEST_CMD_IS_AWAKE	12
+#define GUEST_CMD_IS_READY	13
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GIC_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	++count;
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable PPI 64 */
+	write_sysreg_s(1UL, SYS_ICC_PPI_ENABLER1_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+static void test_vgic_v5_ppis(uint32_t gic_dev_type)
+{
+	struct ucall uc;
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret, i;
+
+	v.gic_dev_type =3D gic_dev_type;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	for (i =3D 0; i < NR_VCPUS; ++i)
+		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
+
+	vm_init_descriptor_tables(v.vm);
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	while (1) {
+		ret =3D run_vcpu(vcpus[0]);
+
+		switch (get_ucall(vcpus[0], &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * The guest is ready for the next level
+			 * change. Set high if ready, and lower if it
+			 * has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq =3D 64;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq &=3D KVM_ARM_IRQ_NUM_MASK;
+				irq |=3D KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+
+				_kvm_irq_line(v.vm, irq, level);
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
+				pr_info("Guest skipping WFI due to pending IRQ\n");
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
+				pr_info("Guest acknowledged IRQ\n");
+			}
+
+			continue;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	TEST_ASSERT(ret =3D=3D 0, "Failed to test GICv5 PPIs");
+
+	vm_gic_destroy(&v);
+}
+
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V2 or =
V3).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	uint32_t other;
+	int ret;
+
+	v.vm =3D vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	/* try to create a non existing KVM device */
+	ret =3D __kvm_test_create_device(v.vm, 0);
+	TEST_ASSERT(ret && errno =3D=3D ENODEV, "unsupported device");
+
+	/* trial mode */
+	ret =3D __kvm_test_create_device(v.vm, gic_dev_type);
+	if (ret)
+		return ret;
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	ret =3D __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EEXIST, "create GIC device twice");
+
+	/* try to create the other gic_dev_types */
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V2;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V3;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	pr_info("Test VGICv5 PPIs\n");
+	test_vgic_v5_ppis(gic_dev_type);
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	int pa_bits;
+	int cnt_impl =3D 0;
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (!ret) {
+		pr_info("Running VGIC_V5 tests.\n");
+		run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+		cnt_impl++;
+	} else {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	return 0;
+}
+
+
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..5daaa84318bb1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SELFTESTS_GIC_V5_H
+#define __SELFTESTS_GIC_V5_H
+
+#include <asm/barrier.h>
+#include <asm/sysreg.h>
+
+#include <linux/bitfield.h>
+
+#include "processor.h"
+
+/*
+ * Definitions for GICv5 instructions for the Current Domain
+ */
+#define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
+#define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
+#define GICV5_OP_GIC_CDDIS		sys_insn(1, 0, 12, 1, 0)
+#define GICV5_OP_GIC_CDHM		sys_insn(1, 0, 12, 2, 1)
+#define GICV5_OP_GIC_CDEN		sys_insn(1, 0, 12, 1, 1)
+#define GICV5_OP_GIC_CDEOI		sys_insn(1, 0, 12, 1, 7)
+#define GICV5_OP_GIC_CDPEND		sys_insn(1, 0, 12, 1, 4)
+#define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
+#define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
+#define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
+
+/* Definitions for GIC CDAFF */
+#define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_CDAFF_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDAFF_IRM_MASK	BIT_ULL(28)
+#define GICV5_GIC_CDAFF_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDI */
+#define GICV5_GIC_CDDI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDIS */
+#define GICV5_GIC_CDDIS_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDIS_TYPE(r)		FIELD_GET(GICV5_GIC_CDDIS_TYPE_MASK, r)
+#define GICV5_GIC_CDDIS_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDDIS_ID(r)		FIELD_GET(GICV5_GIC_CDDIS_ID_MASK, r)
+
+/* Definitions for GIC CDEN */
+#define GICV5_GIC_CDEN_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDEN_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDHM */
+#define GICV5_GIC_CDHM_HM_MASK		BIT_ULL(32)
+#define GICV5_GIC_CDHM_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDHM_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPEND */
+#define GICV5_GIC_CDPEND_PENDING_MASK	BIT_ULL(32)
+#define GICV5_GIC_CDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPRI */
+#define GICV5_GIC_CDPRI_PRIORITY_MASK	GENMASK_ULL(39, 35)
+#define GICV5_GIC_CDPRI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPRI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDRCFG */
+#define GICV5_GIC_CDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GICR CDIA */
+#define GICV5_GIC_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GIC_CDIA_VALID_MASK, r)
+#define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GIC_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GIC_CDNMIA_VALID_MASK, =
r)
+#define GICV5_GIC_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
+#define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
+#define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
+
+#define __GIC_BARRIER_INSN(op0, op1, CRn, CRm, op2, Rt)			\
+	__emit_inst(0xd5000000					|	\
+		    sys_insn((op0), (op1), (CRn), (CRm), (op2))	|	\
+		    ((Rt) & 0x1f))
+
+#define GSB_SYS_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 0, 31)
+#define GSB_ACK_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 1, 31)
+
+#define gsb_ack()	asm volatile(GSB_ACK_BARRIER_INSN : : : "memory")
+#define gsb_sys()	asm volatile(GSB_SYS_BARRIER_INSN : : : "memory")
+
+#define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
+
+#define GICV5_IRQ_DEFAULT_PRI 0b10000
+
+void gicv5_ppi_priority_init(void)
+{
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR0=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR2=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR3=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR4=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR5=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR6=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR7=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR8=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR9=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
0_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
1_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
2_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
3_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
4_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
5_EL1);
+
+	/*
+	 * Context syncronization required to make sure system register writes
+	 * effects are synchronised.
+	 */
+	isb();
+}
+
+void gicv5_cpu_disable_interrupts(void)
+{
+	u64 cr0;
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+void gicv5_cpu_enable_interrupts(void)
+{
+	u64 cr0, pcr;
+
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);
+
+	gicv5_ppi_priority_init();
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_DEFAULT_PRI);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+#endif
--=20
2.34.1

