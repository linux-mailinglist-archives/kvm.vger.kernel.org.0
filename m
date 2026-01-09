Return-Path: <kvm+bounces-67622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EE238D0B86F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D0F81302B43A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261F5365A15;
	Fri,  9 Jan 2026 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OLgY0jGL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OLgY0jGL"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013015.outbound.protection.outlook.com [40.107.159.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A5F35CB82
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978394; cv=fail; b=b8/9/hd2rJlFJBqoTc6bLFdCCoGbLqLLY+fT+gWYQZzIkVUgZScqfPu4Y6ZVwH4wwK05EpbaXps0li8+uMxSm+Zj6xhKH2UYjonRDtPzR3JBHkKeTAyT/+cgKGpJDRDZRqcMPdcJlwXj5GCl44mVNpJt4yXscCFD1ywUI+n4Zuo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978394; c=relaxed/simple;
	bh=ARHHD5WJoNiUMSVO6TDzG2jBO8X0dZIC4ZByk7kxHqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XvVZrn2cubjx3TR+lZLLzm4+czAi8Gc77Js1wjhtq7rIq0qgT44NU7pAjkey0XubuL9TX4u5PKxah394vJb1Xb05Qd5f52xPTscFcpgIfSi/RAmk6JGNgrxmsdTFHWHXlYrXYbYCwXrW8QUjpcchwU3V5PFrFBkH6HoITprmThI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OLgY0jGL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OLgY0jGL; arc=fail smtp.client-ip=40.107.159.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X9b2uHu43XHzRn2JVZz2aDO9ggP4EZURPw+AnL9ODRLnR4IKnjm73bf3+PdWHwGzsxwzeBQQ20B7MOOWxlOQNJB4MehVVZFesBUZKwn0IjLfdyl5RdSHTbVfEuHRtVnf35QtibhRinYpW0h1eANq3ZlGXONA67Rlo/tsbdLlz5C+YmFKowcuyj6Mc8GGw10pTU34hqdcQ0a2VHzmsfWbTLgPARn+O/yWepeVTCC/ASCw6fMg0kO3k8oTGTBLE21XlaajNxlor6jId5xVH9Nagl9Y47uBIOgu9LdZcbEDnnSwzVnw+3nA/g+bEzHgXYS5ptgbXufpi9EsAZK6EiWFfA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jvsiska/SeG5TSDZuR/qkZPQRKjaLIZFVYZb7Z5CDWY=;
 b=ad4en7vgIx7lBBeuOOx9gFhlteNshzVTxfCd69rvqnfXR6NPHTg1NOtvvWTL79nvToziy4djEm15u6lMQ6FSmWb7XhAeQ5VWcGIw1m0yGTnPTzevS47zoOTDQFRxJF5Li34BX2gQLfLH3hwMLCEafhYQbNFZ9hVAtvv1E3f/L+lMaWEeOKU8B+2vYOkyGjaqClscTgLvzkKr6H5bgXOOpQNIHH4K8FfW+v/wXVBqCo6viqjJtFhAR9ktNtGoi4y0Sf9unXpRZ2shWVNCD35IKPBJt5hNt0SdN2/HPbms6RmVUbRYTI2nZ0M1jfrhPhYKsZNCqAbAd1cnNwthvX8xdA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvsiska/SeG5TSDZuR/qkZPQRKjaLIZFVYZb7Z5CDWY=;
 b=OLgY0jGLQPxH4t6Jz4fizy1znZLxqOhUU1/keOxtChvaeOnwUVYLHBl/cQMQ/e12eUbMRLJMqc+4azAQyMKkxG5ys3YAeAl6LVQQ8f800iDLAPM8yJd+M91RaixA8GAFUv6nwhYVvZ/U02gjL+nqWSw4w3Bp4NW9vMeG1eeok6Y=
Received: from AS4P192CA0045.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::25)
 by AM8PR08MB5650.eurprd08.prod.outlook.com (2603:10a6:20b:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:06:25 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:658:cafe::d8) by AS4P192CA0045.outlook.office365.com
 (2603:10a6:20b:658::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:06:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ajao9Yl7T6fCcI2P0whqAoq2wOjZqEQ/d1Mv8LEIcjizkWC7w1Hr05EaPzhtsYxjmSsGXW/OeIOge8KYWRj7wlITSW4/5JD3J90Wc5mwfcepiPVXHXrmLATrzCqQzJPmt3fhwWLTszZYbc7SSe5zC92Lkaw/i1udlDAKxR5awWKDdKJ7UKgtiDyB7p4Nfi35isbkyOOlUFVzZMTxLZR9iHEKzLU2mUW1hPkMSIl5P1+LrkrGVZFWUE8xGN8/HBbBwqMIASluw8Rzie/pRrNv+Imjdzumlt2w9eWHDxUkqvWSohIfDGcz7Xo3xjaZ59btM/V5/tWHdDqB50Em2yBezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jvsiska/SeG5TSDZuR/qkZPQRKjaLIZFVYZb7Z5CDWY=;
 b=r/9vR56HokCZVDe+JKXErOvBEVA7KiFfjALP2DHMp4eFNBknADrphiBttFYCU1VHxhza1A12uxbo8zYW8M4FggvKFSLwefBHG9AFfWdk3JLZjHQRLXQmK5v3L/rA6/kHMTk+Ij04XC4NOUiA+32B9Fjnm8z1HOV+JjSHwOhu3sq6/52HJuv+Yl45J5tC2d8yR/fIC0IYVCmM8kFzN06gqjTMCACEEkaksyxYyBHPNGPA1b+tjlLemi6ePUB9n+r3kmebD16IuHJX2fjUMegcVW9iW/U0TGsd0LI7I17i9kFfpSsuFvuRFGcxXSbmMMY7rq+J1qjJMg+iw3INrch+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvsiska/SeG5TSDZuR/qkZPQRKjaLIZFVYZb7Z5CDWY=;
 b=OLgY0jGLQPxH4t6Jz4fizy1znZLxqOhUU1/keOxtChvaeOnwUVYLHBl/cQMQ/e12eUbMRLJMqc+4azAQyMKkxG5ys3YAeAl6LVQQ8f800iDLAPM8yJd+M91RaixA8GAFUv6nwhYVvZ/U02gjL+nqWSw4w3Bp4NW9vMeG1eeok6Y=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:22 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH v3 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHcgYoQ4jf4J+tJYUK4LhAuiKLqJw==
Date: Fri, 9 Jan 2026 17:04:49 +0000
Message-ID: <20260109170400.1585048-33-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM3PEPF0000A793:EE_|AM8PR08MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7cc111-1221-4235-8b7d-08de4fa16bd7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?h75vqlWpVolu4+RXBvbB0APEnEFklvDyDxVHKj1fVcYV2tKNVr4Ke5ekl1?=
 =?iso-8859-1?Q?dT1+eZxwbussfl4293C14ObUPzd4wgRhLGLS9Cr8VsytZupceu5ozJQR5n?=
 =?iso-8859-1?Q?ogp+bFtqd/7fOfhioB52SHYVgty9LoTP+0mAu/BPpBOqvqKv8XNbCycfcE?=
 =?iso-8859-1?Q?PSWj6FXkSFoyjAI8aNizo/AF6eTY3GDvcE4bggjrTBjknrQzt8W+PGGno1?=
 =?iso-8859-1?Q?gYMocbGxDMOM3mbCaSnm0fOvvQSK7NlvYizZxoTGa3mHJ26V9/wekugUwH?=
 =?iso-8859-1?Q?oPxVzsrZSJudss/lPLYjRh2dq+hNCK/GTZxuWlLkZkUgaqucTWwCoXPRPP?=
 =?iso-8859-1?Q?DymzAVTqUUyrYmDaeC0MlqACM1PWM0oR7DmejcwJB6YP3+lHpv111Iexxa?=
 =?iso-8859-1?Q?b1zcdmgE+2SLzYaisRoKoQuMs7rav/6df0OMWSMmcHGbzIPXbovPNTZykI?=
 =?iso-8859-1?Q?ndrUcMzjbo4a+KdVWjXv0HtiEfDeNU025x3yVnctwIymXoI3OxiLcrA06y?=
 =?iso-8859-1?Q?sQDr2ZstpQFU2H1QTT7UvuLyXe3QzjShzHSa8bpg4Xie68hObD9jq0FN0J?=
 =?iso-8859-1?Q?2/c60lHmphF6m7uCCKC97i/8zQcT4DeZDQv6qxdDFAiqCP2M+GM55iqirB?=
 =?iso-8859-1?Q?dYuFFp1WEj9VkWOt+nFKExkP/+g8QLNE6w+ZyLUkefx0IXCk92zjoEQgVi?=
 =?iso-8859-1?Q?EDwM9sBPPovzZHEJmBBqYButRaqcQZzphwoSKsHLUlYWTfk4i5YBHLKj7p?=
 =?iso-8859-1?Q?NNmVkxrPFUWI1t439/nvqCtOh7DNm9AAu2PmrQz+h4nqnQ4UWH9bPsMIek?=
 =?iso-8859-1?Q?3B1u6pN2G9rSbkZIWhTxeExlZ2FEUGesV18uu6bHWFZWw94jJch9d76Uq3?=
 =?iso-8859-1?Q?ULhFxSMUD5n1ipSSG91kvpwaOhvwmeLHpZqbIhyoHZF9vXpouh46lwpO2+?=
 =?iso-8859-1?Q?xt4DnZg9ILpIyxYBS0zZwlICFN09/VUT3mNipmHTOkYS57RNReMqTshKuP?=
 =?iso-8859-1?Q?pHV3yPSn/RderWpWiFi9KpJN2xcYUKZJPgBmgoTpro36IEVWsL35iurLsJ?=
 =?iso-8859-1?Q?H1lyLrETvG88iWGjwP3//wO6uDvutpDxjFE0rvBlgWchSKnuqyo9MClY3e?=
 =?iso-8859-1?Q?LwmWQnSlX6TLpyNZ9umqro22LlDZ80XsmDiFE5VW6b9ZfZM++s0GhEDnG9?=
 =?iso-8859-1?Q?+ghI6w1ysH+fM0PGkIJz5w0ZGZnnvQhs6aeNAuyHShqZyVI0GpjlIwdYMo?=
 =?iso-8859-1?Q?Ufs4w8JTBRAXw/a1Eh9SdI7yJRIgBGHmP8X6vIwvcoOkQh0D6rzX7eTgsd?=
 =?iso-8859-1?Q?zhi+TmdYms4Q+V056AtCVdd3b5FADAy9+hKrVmq/Dd5FLM9TB64+LL4Lwy?=
 =?iso-8859-1?Q?bruYQbokSxT/5mZtVxxvA9DEZXvzwe0MIVA0IpkFDKBT9c+TkuJ/679sTK?=
 =?iso-8859-1?Q?2wwugQM3zuPva6NEpWWhQBfrcFPearqWDICS9avUDsU2Qrj1vFz6E6slfO?=
 =?iso-8859-1?Q?1wo0fLQxYCQUxr5uLFUU4b9sPGCZACLzb8MWHol5wYplZH7Ak9bPxrGIw9?=
 =?iso-8859-1?Q?RxPJvn1UK0T3mRk9I81d8Heq7eT/?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c3b0488d-e9f8-471c-60ea-08de4fa14688
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?S2bQyqy6WKNBtxf5sNkwSxkST/tismsiweg9lq7nQIUZ6y7uYVMka2e3w1?=
 =?iso-8859-1?Q?6+b7qIy1+zmu7sCAISOdnHgkkcYXHBPPls/NRe5yRE3E6Hrbti5ar7OPe4?=
 =?iso-8859-1?Q?86OdN1QzCCSAblzModQFSHITY5Urk+YUcn4AxDX4v2ACma2EQcWrpBD1o/?=
 =?iso-8859-1?Q?vdHSBIy42ZN6yJMTZz1VaeqIFx5cVm+CBCs1zvYA8YnnpQFi4KqnZknMjm?=
 =?iso-8859-1?Q?wlmaVRPuzWMfsyGvzsi2GlWvXmNDP1bHu5gIMbvgI3pkEAAhSLDEvbW9ym?=
 =?iso-8859-1?Q?hDEyn592dgE0ryrA0R25iCfuTf7rMdKpnpqhcWTgPyeUJ5miKAKaTZ2gLc?=
 =?iso-8859-1?Q?0fXKbVgQXPo/MsrUmFT3GjiZrq0TYlDh1O7eRV/AvX8bhJZfcSaNBNFM6l?=
 =?iso-8859-1?Q?OG327RUSGDBgdDWmh3WSEIhCEa6ENiytm8srtkjbWSrHYujCBwtsU4iWy/?=
 =?iso-8859-1?Q?swgf+t3Ky5viaSrO5xJ/6wOyrk13emy/KyVuFObBlHVwpNAEKR/XMFIGK2?=
 =?iso-8859-1?Q?HfbPuns8ZsWMqr0DjW+QbvzQlD8Q/DMA093QykVJ38NWKjymjJZF3+blg0?=
 =?iso-8859-1?Q?nwU6kFZ8NC3yWY77iAee0u8qXNZtQSak/4we63QR8shCDlDCAaC/S6s7YE?=
 =?iso-8859-1?Q?xi7Nqopu4iLvY0RONBcfZHObVV1ETyBR/2pp0mp51FH9Yi+IhTAqzAMj5T?=
 =?iso-8859-1?Q?qTyoIQRi237RMwor2tvF979sIkqOjUGWuwRVWQd4fsP2c+x6afKGnpmL1C?=
 =?iso-8859-1?Q?vRj2WM47oFY3ksB+h80FZYDpVQ//rsWQStQAAFNomc0C0Navd7IXcKQuC6?=
 =?iso-8859-1?Q?PH/pgVGSZso5Z9I0Je6XN26BgwqsWe1vIgYbPwTeaFrgp3rq6ZAsLYzpZm?=
 =?iso-8859-1?Q?OQqZoV6cO/G7njxnY8CtFyr+hMwxvMIAUGmHGJ4L98WeajxE8CcaWT7Kmn?=
 =?iso-8859-1?Q?vGZD6Q39rpqeK6TqwHuqjavs2mp+Fo1vu4Q55BQtJmnkMxsSQ4ya+orL/s?=
 =?iso-8859-1?Q?bzYPpYeaBwwnXJeiVxC2DRfrEbPLW3AUJiG6h0N4aBIy8Isb9Br7W8GQC2?=
 =?iso-8859-1?Q?wpgj2O5RtfUJuI+G54jPVHDI+HGLTQhEFRzBDd9MdooOs8bZXOGxkW1TwO?=
 =?iso-8859-1?Q?DjkSoecbQMwiLbaWeHvDbt8syIVQZapYnWH6MCZNP6mTo8Lzytv2oQbZdj?=
 =?iso-8859-1?Q?AL4fXsIEuCHpW+GUKxNe/3YwwIQtxQ4lqRBENNkv7lnGlDCc8N2W5Ly3xL?=
 =?iso-8859-1?Q?80FWlfGjyxyooHNW1dAXxWHREWbvjjiO/g0dn5AC22WhW6BZHgi8NCpUko?=
 =?iso-8859-1?Q?Z4NMFbqUc7ZqYMI1horGKzvn99H/PK5X59dSOA9gI6icz7uxvxF3i3GoBi?=
 =?iso-8859-1?Q?XORtJKj08cnOhDB0+zzngWEly7R1d2Po9+v5IEoRIkTxnOVEOqcWcjhuMf?=
 =?iso-8859-1?Q?JEgTb14ZBgCHiokhog4OYUD7kTosR4THDGtMu9CVBDVKKBE5r+Dmb1QEXZ?=
 =?iso-8859-1?Q?2n6v49DPTf1HTtc743pQOm6CwPW9Th6HmsKbEIXgT9x2voUMJgx26FTMZv?=
 =?iso-8859-1?Q?dqIBZeEPyd3mt/97wTBvTkpntigsgYKLiyXXbWmFwstCTt9H3gOyTOBV8u?=
 =?iso-8859-1?Q?+3NqqEhAOgFPU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:24.9890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7cc111-1221-4235-8b7d-08de4fa16bd7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5650

Now that there is support for creating a GICv5-based guest with KVM,
check that the hardware itself supports virtualisation, skipping the
setting of struct gic_kvm_info if not.

Note: If native GICv5 virt is not supported, then nor is
FEAT_GCIE_LEGACY, so we are able to skip altogether.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/irqchip/irq-gic-v5-irs.c   |  4 ++++
 drivers/irqchip/irq-gic-v5.c       | 10 ++++++++++
 include/linux/irqchip/arm-gic-v5.h |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index ce2732d649a3e..eebf9f219ac8c 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -744,6 +744,10 @@ static int __init gicv5_irs_init(struct device_node *n=
ode)
 	 */
 	if (list_empty(&irs_nodes)) {
=20
+		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
+		gicv5_global_data.virt_capable =3D
+			!!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
+
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
 		irs_setup_pri_bits(idr);
=20
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 41ef286c4d781..3c86bbc057615 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1064,6 +1064,16 @@ static struct gic_kvm_info gic_v5_kvm_info __initdat=
a;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	/*
+	 * If we don't have native GICv5 virtualisation support, then
+	 * we also don't have FEAT_GCIE_LEGACY - the architecture
+	 * forbids this combination.
+	 */
+	if (!gicv5_global_data.virt_capable) {
+		pr_info("GIC implementation is not virtualization capable\n");
+		return;
+	}
+
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 21ac38147687b..c9174cd7c31d0 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -53,6 +53,7 @@
 /*
  * IRS registers and tables structures
  */
+#define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
 #define GICV5_IRS_IDR5			0x0014
@@ -73,6 +74,8 @@
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
=20
+#define GICV5_IRS_IDR0_VIRT		BIT(6)
+
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
=20
@@ -288,6 +291,7 @@ struct gicv5_chip_data {
 	u8			cpuif_pri_bits;
 	u8			cpuif_id_bits;
 	u8			irs_pri_bits;
+	bool			virt_capable;
 	struct {
 		__le64 *l1ist_addr;
 		u32 l2_size;
--=20
2.34.1

