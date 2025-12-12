Return-Path: <kvm+bounces-65865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29771CB91E3
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2A4430F1E81
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4AE3254B6;
	Fri, 12 Dec 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qr6MuryA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qr6MuryA"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013051.outbound.protection.outlook.com [40.107.162.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AF31B81B
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553038; cv=fail; b=m2tujhFgfA4EvHIFcVzrelfqC7dOIGdUBo1MtYYIWio/QtJZJTt0jqCzLecPrf+c0V9nl72gWBJvglsmIpkvXIe2xFaQ9RbCJb80HLRY1jIcY4aHAHy78+stwi705iFUPj+MmXGFL0hqoXcouBV0WY7FF7kjDJ2+V/ccVt8C7A4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553038; c=relaxed/simple;
	bh=MFb8H1b0PSXGsgP6rE+rfud1cI66sjWK90YCJa8VGhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NBcEuXLtmuEYHZCNg/wkRJ98/ZkAMwvO3kX2CcGu0OOsoySpmgMjkxzVN8jnxZstVqi9kkk4KO4c0ZVsJsJ/nru8Ro8S93W6z5r1Jc6UtPC+V8W3A2FMstusnwNg6Aac7gDdOjzWt8fNAPQ6kF5hpOZsny0ZIVoJaW5IlyiQMKc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qr6MuryA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qr6MuryA; arc=fail smtp.client-ip=40.107.162.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vO+xSquGG1HhdoamMKo+Uk9x5MjuhdZl9K6+NN0dw6A7ZJm//Y2cq/W46t9LTekOVTyjO5ltuPaTz7wguaTLR2msv/allprY1CbA/psG8XGbt2ObQXWETr8aDG03ov83lP23z9H9y/gG/1MrPLLJRTX1iiN7V9tA4uR/0OOvRQgCRlOTHQaNSbaA3XPCU4hN9UEzPV0H32dvs9NLDcT7fL7aSNpQBwfGL55FralEI0jxslZQwirgkYyOPQqrTlxA+wLg10CNhKasyU0JJHOi+MNOhOBDlLVFVrSy6+PFIo1qlDvzCj2ewThJZjKLFw0NvWJ6W0wfgtse3lRbTGAyHQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BZLTzQhIwJYVXFwL1Z2gJ8Oom1IUpX9RPWp0aZ0H08=;
 b=p6cd3nij9r/KuEULKKtQDVIP+oga3XVYcIcRFQ3VKF6goQ/HBfat+KDX9GeEpZk0sHWeSgGg8ATuyG90pNekjyNWEo+/euET6GFI/dUcc7zKGkgFTkhM13vwcUyx/Orb8gQ56VDt0Enelb+qB/sRCQoHbTfalGx2+o1BQUs6YwntLYfy1qsJEK8JT3ZQHbBe3eynTnOpaeoOWsvv141+eelJRuLkErKYW4CZgk1d+0JnRw5GSQ2B1IIXne3Q3NL3CCc/tdFdmwJYs783BO5tFu5WALcZdW0gt5JGoqal1eq6iaGOi2HmAIltuQHAJcbAIXxD3wKGLDmhmcm5GiyUrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BZLTzQhIwJYVXFwL1Z2gJ8Oom1IUpX9RPWp0aZ0H08=;
 b=qr6MuryAKkNdIqRGGjvx2ldEaAd9/H+2kR99MScGhVzOym0SwNvbGkZ1T9/Wtau5aaV7+v35ik2Oab3mLkk5gkD4HNd4E4BMWPSapY2wYdSeJ6IINdbG6rNYMYSVp2OZ8sWxHYyZk46aLoTYaQZ8AvzxqipO5jgfcKRrKJQDJDY=
Received: from DB3PR08CA0031.eurprd08.prod.outlook.com (2603:10a6:8::44) by
 AS2PR08MB9809.eurprd08.prod.outlook.com (2603:10a6:20b:606::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:48 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::1f) by DB3PR08CA0031.outlook.office365.com
 (2603:10a6:8::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2tEjEzFfUG1kTF137blCntpdK+W/2NR/dVp4RgDnq28BsEcoYX4Jn5DRyYm7ACtgtxT1BppPBCxRtk+8CIAuFsbxV0T6ccKcFmduR3/fgcNbRO33BxReHxsKq/W+WjVfwRkUBDEpmbSS2fsX4NWdeGO4RGrH8GRryabC6pNj3BOdsh97MoN57RvP3X/0Th4cVKfddxay9d4bGaeG0/43B9W+CHmpsIgXmSLE+NB3mQXGaizMxGlDIYHwVAzd4Cai6yTY0+jhIB8Da3KSjqKg/LkE1pN0648+MhHY5cKvMJt9nRtnltsa18Wh99YKvtAwWX8jfrMZi/6za51MCbeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BZLTzQhIwJYVXFwL1Z2gJ8Oom1IUpX9RPWp0aZ0H08=;
 b=HPXiVfuAfhsaIxJ2z+kO21G77dw9OHEWc5ZKoGfT+0tVIV/OpogsbdwRCY23YsIp0daS7Uo4/5XDybuAjmvjw+oAkYYq5+nEEUNa83qcvOVCvkYCNWanwarf7VlVqSwUwXE1r9uBUuf3+ssaOBuz0sKDEw8gzuA7tduPbAzM1dxgmPO/ZUjjCIjsRSyRi5N7EqIuNEzdfuLtkJPin6D7d4GhcSXKR7xFELIww4lsrIQ6g+NLGJmocpTdFA37bFI0CiYwbL/mqp1tPcCVuK0Q4eYk7/UfsbgGQey3OREGimV2l+9P8u6cB5drtKmst3z0vrOTk7mRwM5aGujpI9brUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BZLTzQhIwJYVXFwL1Z2gJ8Oom1IUpX9RPWp0aZ0H08=;
 b=qr6MuryAKkNdIqRGGjvx2ldEaAd9/H+2kR99MScGhVzOym0SwNvbGkZ1T9/Wtau5aaV7+v35ik2Oab3mLkk5gkD4HNd4E4BMWPSapY2wYdSeJ6IINdbG6rNYMYSVp2OZ8sWxHYyZk46aLoTYaQZ8AvzxqipO5jgfcKRrKJQDJDY=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:45 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:45 +0000
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
Subject: [PATCH 21/32] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Topic: [PATCH 21/32] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Index: AQHca3soSyJhddOybEGL5pgflvH7WQ==
Date: Fri, 12 Dec 2025 15:22:42 +0000
Message-ID: <20251212152215.675767-22-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF000509F1:EE_|AS2PR08MB9809:EE_
X-MS-Office365-Filtering-Correlation-Id: af71dcdf-267c-405a-fcf0-08de39927209
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?mBNZM8jVJ/HzA6ogf5T5pTZbWVsRYtQl4sfnghMjUvYb8Ljn9nowucqWPv?=
 =?iso-8859-1?Q?26hfigABnUZPx7uKVSghQ9QFjWSrzKJmMaPy2+5vrIYlZFNj/ZWCgV8O40?=
 =?iso-8859-1?Q?8z6O1islZkWqkuSegNsnp4TJg3sgCpfwP256VGM4AqT4V9PaZLSl44C0zX?=
 =?iso-8859-1?Q?mV6d9nK6SNoh9oMPueTKJSEEsTf27qX5XK9AxBvxOQUe87ULlXMJXy+2na?=
 =?iso-8859-1?Q?KQEIQYl/7fhImhfCrd0dg5mE+Y4dZB8kwbcvClZM5H9XE+gdhfpJw/JEv/?=
 =?iso-8859-1?Q?uft+9oWO8CnXihFYM3hTRrFrxC+qhY7s4EpH9rBf6q1aWIbzN8cZOuXoiL?=
 =?iso-8859-1?Q?Q7XPzrFlx7MsfbC1erGSpIU5wBV5eyyEUodDH2TvrGAqCZPdCKL22NGvax?=
 =?iso-8859-1?Q?iiqKnhJ3t9nXEunDhozVWi1XV+IXh6ympgbjpiNtf2jtymrTUXPZUVrugn?=
 =?iso-8859-1?Q?Gwb3b4/6+y71a9XRBBuh1e5Gt2bpIy4QkHIfvgs6bIgkTTVaeJaF6CFl8O?=
 =?iso-8859-1?Q?Wh/qfwDBmA8dSe4hhcmT2bhkyIXfkU8pntUdfVzkzYV4qamrwRuxKeaK+4?=
 =?iso-8859-1?Q?n4T7+utJU9/9E1uzW3XwtTxAGNzScQwH8lwL0mgbaLLwjgLA/Lvu9ip/vI?=
 =?iso-8859-1?Q?8UMEtNq+5Zc+yEbO8fEan8+gSCXq4H97YA+sjTHk9gMIzY+MEkEscw+V9C?=
 =?iso-8859-1?Q?QRaGrhAbKDWV17OU6To3rceREVyjI5ZEjhR45Pml4vyGtF/+tHsJtzwoMs?=
 =?iso-8859-1?Q?ZqMwHeySqlea8+2urh5iBzQcb2IkBWkSzBLxoySBtFpPVyz3+JS+egOyv6?=
 =?iso-8859-1?Q?UHcAuKSuvuTCKCd6Ek3xOqslL8scV0BJ2W0hXtSNYIBPwYIT4W1I/Pnd83?=
 =?iso-8859-1?Q?7HFRb5U6UNUbVLf2i9BLu8+ZvCMEQT7s+VHzLf+a8+6Xw/CJT3Y9gp/9Gb?=
 =?iso-8859-1?Q?JgJdcpMIjiVsdzlR7niUDdClSvaU0V3nJ52E+LhOgern+pJBA+o9z6hWex?=
 =?iso-8859-1?Q?yHIaUHijs83pEwDvPPCZuyoMbawVYH7C6hrKu39iemKboFTaZH8iCcYxaa?=
 =?iso-8859-1?Q?BGI/Q8IpWvHs60HgBlAWjEvz/ykxO3z0e2Dd47NdDBOSNtr0XwCQfLQeNc?=
 =?iso-8859-1?Q?EEAwiu2lAOAPRxWptZNMd83A9nqqwsO6r6E+YGeg/RYhhJLv0ZqJafvFsI?=
 =?iso-8859-1?Q?5Ky3X++j719B4hs6v6bmnAws2Qjaspi44TChoeLPWwOnTfAwbG5bJnXWm4?=
 =?iso-8859-1?Q?OW3m0b74mPNj6MlZQsHeLZLBCuJLIjOeCIXg21V9jrBBzijbPKX8X5ysj+?=
 =?iso-8859-1?Q?rRmY97c4Rv05gLMj/U4vh4K+9EUMzjXRXKIcPUdYyHxPk2ES4w+StnGziJ?=
 =?iso-8859-1?Q?/cDq8DotlIUP2F9gV7yyamzZBLnGwd7mznfEFxWa/ZLIkUMFe0TKtpSDk8?=
 =?iso-8859-1?Q?BKFmdXScBJdPcu2ox4LUT4nluBWBTXe0+ORIL8pBqsSu5mGmgs7X95+kpW?=
 =?iso-8859-1?Q?PTsQJzyYz28CxO1WJYd/plbVLVV4wgK/ZRlMX8bDj7pq9mXl+WpfIadd3u?=
 =?iso-8859-1?Q?Fhgi9Hr6Y7hzR2/bxcn7VBYvdvph?=
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
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c08f9e96-4b68-47e5-3acd-08de39924d09
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?JxekT/ITj3ayLMydoowdDd7clNx8EYBIcgWILtzuH+IztYFeDtSHvHdrc1?=
 =?iso-8859-1?Q?sYpf+QAQsOVzqy0SG5HoAQ3VGQNcp1/mDFl1oF5JFRB81/dmAduD2ijUFZ?=
 =?iso-8859-1?Q?E1P6O3EaoE2BShQ21DyN1wtxKKb1hE8OplbDK9qC/G2LiMrrvfVwRjAN40?=
 =?iso-8859-1?Q?VllMHKCsqT2GI17biF/yhoVV4BeTH0ra9xG2h6yQbIGQhBV97N54xeYB1T?=
 =?iso-8859-1?Q?XjcTKh66PM1z2IB3l3cys2qaQKt3qrLVgzMQz/xvY0HQNgUIoRPiN+U41t?=
 =?iso-8859-1?Q?BjL8WBZ5eOr1TDstXx8Hk2BjdQOldmqLdJko9iRMtJ3AmW4Q/B95MQz8jJ?=
 =?iso-8859-1?Q?fME6J41lvNYIV50tvsb98K6Za8A+JlXCk6MO29yoaZXVE9pAIBPwj0sOld?=
 =?iso-8859-1?Q?cDm/zrUOjeRUotIvWv24STEonTMeFtI+7wQ9U6+2/mbpqLP789MRe7rQ5E?=
 =?iso-8859-1?Q?1Cl8ZKqDeDlJ2hW7Y9D5hFHItNrzueyCFktBACuhzP4OyciTFOe/FCKa3I?=
 =?iso-8859-1?Q?is5FuZOU4hYUiFKepYkqYqyv+/g1zz1hfaSOiQdjrThA+R6gKoW69IqyT4?=
 =?iso-8859-1?Q?jcohgoDIzrqVWZbSeTzEr8nelbptV78pQyZhznJgI4Aub1lVRoKrjTL2O6?=
 =?iso-8859-1?Q?dCuF8qv0tFIrF7AJ1ILOUlbFPanJHqnaGKcFH38CsLtXcvrdMACE62cffK?=
 =?iso-8859-1?Q?9tG3hHCyL3PiH/vqmZchy9mCx/vFnxF4Mh6GxMoRtpf56+31I5MGG/85GJ?=
 =?iso-8859-1?Q?RXbPeeAZRkQn9zapcApq7kVfyh0OYxzw6DZjSA6epktpbd9stJwQOV6ArT?=
 =?iso-8859-1?Q?pbAilivuM18I63Mqwlm+wGAZsssXimLlrXgInP7WbzhBNcduX7ZJRm1s+T?=
 =?iso-8859-1?Q?34YyK0uX9wTwKjnffRw5YOLr7BufhTWC1IJzsveFMNnf/jZYQHyTJpo7Mi?=
 =?iso-8859-1?Q?OSEYeNfCP/tyWp8ljT5kxO+JO0pVt7Un1q4Q8nuFnC9VCshrviGdceLcMe?=
 =?iso-8859-1?Q?+mE2syNIeMeiJPVzwRvW1G9n3/KCQINmwHMoAiH8IP7tgyKgmjHPvvSkNM?=
 =?iso-8859-1?Q?hWY/c05iRxxx0U4BE08V7jnsU+pm+MyiWFE8t+BDtZDKgsTuELx+jSG8w9?=
 =?iso-8859-1?Q?fsLOSznwYvS7M+Jj6bMFBm/otC0oPpJZsSiTh8vy1+R49Y5CgkcjhyMPJU?=
 =?iso-8859-1?Q?Hw7DLVVAphQNtrPrjjezGBAmM7S9N9fBttj+PJINpGVGzdNhJcp7cUBr6g?=
 =?iso-8859-1?Q?0nnSQZW8TNJhO32nsbU7t+Oj+7wYItIrsDI+urp9rtJKNV+0g9GcsjPFgE?=
 =?iso-8859-1?Q?f6KK2rYx6x2m1qzQwIP9a9wyk/guW6/xO0LdEygrEvU2MKMkKMjZQw/8dU?=
 =?iso-8859-1?Q?zzwhmLxHQQfe1mpiuIFF2MRlJ/WTtM/98uGZLZmAwam1CIbCpDPfO2l3xm?=
 =?iso-8859-1?Q?MY1Vg6SWYmiqQQn6fcJG7OdcCMk3nEKOCG8sS1UYcuSfO44WSGjtZkGC38?=
 =?iso-8859-1?Q?kRdlxBjCLvZPcamMzn26Dixes3nmCAaCBKEWhLRpypCWrqm5pn+ZoJZOqA?=
 =?iso-8859-1?Q?fqqhT4WL1QXeh7vwAREHI6U8FLVDMZvFVDo5lHzoTbysBo5YUlQoVEYkY+?=
 =?iso-8859-1?Q?gxj6YPXJAIPXE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:47.3345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af71dcdf-267c-405a-fcf0-08de39927209
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9809

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested
guests. Therefore, the init of vgic_v5 for a nested guest is failed in
vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 51 ++++++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 51f4443cebcef..69e8746516799 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,12 +66,12 @@ static int vgic_allocate_private_irqs_locked(struct kvm=
_vcpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
+	u64 aa64pfr0, aa64pfr2, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -132,8 +132,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -163,17 +166,21 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
 	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
+	} else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	} else {
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
 	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
@@ -420,20 +427,26 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			goto out;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				goto out;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			goto out;
 	}
@@ -610,9 +623,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		goto out;
 	}
=20
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 35740e88b3591..3567754ae1459 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -54,6 +54,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4b3a1e7ca3fb4..66698973b2872 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -385,6 +385,8 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5a46fe3c35b5c..099b8ac02999e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1

