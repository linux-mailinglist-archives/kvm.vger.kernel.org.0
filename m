Return-Path: <kvm+bounces-65849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A08A8CB91A4
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09D9A309C3EF
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C42A31DDBF;
	Fri, 12 Dec 2025 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eDpBJAPa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eDpBJAPa"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011051.outbound.protection.outlook.com [52.101.65.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D355311C10
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553029; cv=fail; b=r0KJcQki+0GYXtFURUnWQpVOvOks7e4XOlpOufce7i9Q663T1K4v3l/RdNnDtR5VWvymJH0ZlZMlG7XmiIqoCwukYm6cljDROw2RkpM12/v8+ifXILtvJ1eO3J26fGKtc7i6lxzkwPRSi7AgL8n27a85XbHnHZtDrdX9+HxYFE4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553029; c=relaxed/simple;
	bh=TrfjCAgSKuwBkoz7+YWx0JzERW+AjNTg6Opv8M2+670=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HrVEMXXzJUibvlUeG9kSw5Boq4UZTuBjmawKOPA6AMAxaudN3r890f3govw3pErdSOy8eb4Hw50tcG++6636POPZNI4MWghq3eYrSXLM0XZMGb/QCE2mejhntLa2RHSjzCK2RkIRh+he/My9Db840x3fLs1lzJldVadY4RcAvD8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eDpBJAPa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eDpBJAPa; arc=fail smtp.client-ip=52.101.65.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W98eMJ8yDuoZyW3CZ6Fgp1YiZItbPI6tC963YcxHvAohsna2QwGLEPrDx3VkViCNMni1B6aaaqNrQJFt0vzgTw9A2t9i8vt1TC+1ipMq9KDKrqCklJvMYurdHoBN+W5ZULlttdVXWqcgyhIhqJKUK35kOxDjjN42GUAlEIbN7cQ9rdUcKcC/3H5bIEiOgILKQBJCrAB05v2FsaouAdvks1l1qKwWY/89QkGqBjaoiNEzFyT+ZUfqzVszixrLKwpB4/xYJY9hQJ3Xzqj7eJBOg+y8NLe0frRx9iz2acJUZrrTzBZQWzR0D7le2zCjL7k6wyXRMlKKBrE+RzxB75Q9zQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=bl6fiORCE2JJGzpb9MhmcJKsnc/C9Msy9TdErUs6GmJfMGbXHzFYq9sCWb0Hkdsf1Uin5ORXRLRxfzpHSSjgxawbBr+xBdOGTaLIP5GLjLcu7sFzd8atSY9Yytg8kJTfphrxQL6zHxnHXSW0BxJKAbORTROCvJy/1WK9gZZ4sjU+WD7iJ/EGhhI0nvtW8Z0rQ+LJZEEw28wjjctE+p31FO56f/lo9GPk6HuAdby1Ci9e0zH06Qe43O2XfklBr8Qa4QWBPBNiBwMswzs8zl0rJZxSelgi/KAteUrcphzatGdMqqseSvj40N+gtfMhHmHR8FLC7k06UyJgdDEhTvtVWA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=eDpBJAPa+wdjpB7N+70uEaPho6XP1nDojw06BYCn5pOIj4btPVJd7gVTGhzTxbngBYJjWIKxce8kIMF+a9RWMylvd99fIW7HLD6qJkU1y5EtG2Vl+b8S9f+J0yEd+JoFPEYZHcFmCkOYQOo2BGp1pMiijcRkwnZSMPiHxAqyiE8=
Received: from AS9PR04CA0032.eurprd04.prod.outlook.com (2603:10a6:20b:46a::6)
 by AS8PR08MB8633.eurprd08.prod.outlook.com (2603:10a6:20b:565::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from AMS0EPF000001A9.eurprd05.prod.outlook.com
 (2603:10a6:20b:46a:cafe::4f) by AS9PR04CA0032.outlook.office365.com
 (2603:10a6:20b:46a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A9.mail.protection.outlook.com (10.167.16.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlJtIUbC6umFvtHrdGInA5wN6bIPqMjsveooogmx6h1kXj+VUUoZ0d4UXIO5B8u7HH7lyTfN0vNPXhF7lmAQC9RNiFxyPAb/PJ8sCBzYWR+C5pttqhYmCLCilkRkeJBLqGpCFbpUczNqBRPVugIaFBKTBQm8RHfHExcDZs4Yn8z8mZoJRWroG3V/ST0WYXVDrnHFUdf5WcXug8zqA8OlJv5ZMfrPlvlZrWRNHSqvgJKgIUUslsI+P9OZNxjd2WRpgcsM4LNbeBtw3BhMthXNDSL5agCp0Yq1DY8yrgb9p6wjb7jTW9cMDhJKxXjho3CLCB5d6fffBBFSmsJ6JPOytQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=xx7nJ9ieg4VAx5ltGOPuKYfDu/3+JP3Cc3ry//KD+KLFjOHY8Bl48TK9z1bcL+Oz5WkBg6+CY5VJkqjIij9eqfN65QrOVymBgLOvgVDeQUGfu9mn43osSe0Ctv2NP7doweURFQ4NWS4L1QECNw3qyrbWZqaEHkBBOsaJf/T8qjcFdhCFFhuY4goP9PenMzaRtkylZHK+okXW+1bSx5FplKaulpy12ELc0iyTjyEqYamuilkH4EEx2nZSicVBqvynMLTQ0kvyKS/fLBeJpfzk/gOH5pZEk0B5F6AJ+sAjYGB7+/SpTbLfVWjx35x2GV+qsJpYOP6s2ASnZiJCEZ/muQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=eDpBJAPa+wdjpB7N+70uEaPho6XP1nDojw06BYCn5pOIj4btPVJd7gVTGhzTxbngBYJjWIKxce8kIMF+a9RWMylvd99fIW7HLD6qJkU1y5EtG2Vl+b8S9f+J0yEd+JoFPEYZHcFmCkOYQOo2BGp1pMiijcRkwnZSMPiHxAqyiE8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB9756.eurprd08.prod.outlook.com (2603:10a6:10:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:22:36 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:36 +0000
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
Subject: [PATCH 03/32] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make
 RES1
Thread-Topic: [PATCH 03/32] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and
 make RES1
Thread-Index: AQHca3slg1T7oL4f6kyHlgq+4E0Bzw==
Date: Fri, 12 Dec 2025 15:22:36 +0000
Message-ID: <20251212152215.675767-4-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DB9PR08MB9756:EE_|AMS0EPF000001A9:EE_|AS8PR08MB8633:EE_
X-MS-Office365-Filtering-Correlation-Id: 092f26c1-c2d1-4ac6-ebc2-08de39926ec9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?aFCdqq7cZ4X4xUESmicRwTPvx2ipgRiQ62qAjoOUkvcc7opemRUepygHt+?=
 =?iso-8859-1?Q?Ciri/P7n9C6aXa20oR/WuvP+qgC9Gv5A8suzib77DvpLTcPr6UwLVnB1sH?=
 =?iso-8859-1?Q?JPr0FWLrRYGnew7XglxGQv4TxVvKsqepNkDigET2QpMDT3odovl0H0o7zI?=
 =?iso-8859-1?Q?dIBgp/KfJpBoL/IINMGCcgW04jwjvQXC46pXIUo+wMPeqin/Gq/fFE6Tgy?=
 =?iso-8859-1?Q?5+8GM9kFtReX5f7PrqXBxCurPZFA6dXzQWf08P51xIVWNatGMeC2xPdL4R?=
 =?iso-8859-1?Q?x+pqvPd2coRipWxooGgFMixN9DGJTq3oUiihN9kVkSv2gX8fKJkYnPf8nD?=
 =?iso-8859-1?Q?0HuhgB0sQzGcZGyQ6aq/bjmNMa7MgnnWS6TDbsMgGFGsPIykZB66Hl//zk?=
 =?iso-8859-1?Q?nyBtRy4Vt83kIKRzo1jQykCgTaXKz4s3Bx4X16fQbNaCP5j5NTmTD92jXQ?=
 =?iso-8859-1?Q?0fBlnf0AcujEeNGcHaIu3HEzlmaW8ZjyNHI5p5qlOeYNESIf3djeD4IMko?=
 =?iso-8859-1?Q?WHt07uV97W6G5VKSTia8rtreyIw+RnbyFRsw5RSk9iyOVO4+khfvpNUUom?=
 =?iso-8859-1?Q?SgjfKEXKQtb81ykTytvRJKubb0WEJhScCdBTcsne7OOVC8K+6gt75saI4m?=
 =?iso-8859-1?Q?ARG3vku3eGhz5BndXTC+k5fQhqWVE/e3rd3Zd4+B29X9n1M15UtakcVxbn?=
 =?iso-8859-1?Q?eQw0uOr8P6gjcv+KlhejRFCLXoFbux8HXF6M0wEvGDUiNk6n77+EpvBMhc?=
 =?iso-8859-1?Q?YQY+I5wbwx7ZYwy9Wy3lEkmscBUFS8mut+pOGnA5/jM6a6Wt6CDcctXVTS?=
 =?iso-8859-1?Q?J+y4/FAfYc4L//lmYhw7mJdsYzpWs5PCVKlXi4p6A0DnuTKiWvTCP9t82d?=
 =?iso-8859-1?Q?GBlctH45LUlH949WibnO2Xg5MkmQiZ+njAKQwJG+XY53WQaVrTiSDwvNNt?=
 =?iso-8859-1?Q?lKExuDfX6zYO0wMcY9J8xBZo45+g1EfHOWHx9iUMtR/BQcBSnV8gnnbakj?=
 =?iso-8859-1?Q?3a9cEDe8zz8oro1ko4KExlFkaJLDS50dvbhS3Q8O/sbA/IR4Wa3LoSEQi9?=
 =?iso-8859-1?Q?w1oRsdl+/E54jpC9bWW6C6Y3DOvyj+oxlAS9kUUL1OxNpVSO3BTybwtSMH?=
 =?iso-8859-1?Q?c62rfguba8r1XILy17myowW8DrcXW199GqzlpWIkSjIPU75zpVAPXo0T4U?=
 =?iso-8859-1?Q?W490yD2mmIiN7w4r4wjUuUY8zua8Qxgqx9rG3zXX0NYhFvLksiUwaYiYnk?=
 =?iso-8859-1?Q?vSDNGxaCQE4i0XDqb2x39QsrMxZ4o19Bq6fsPI8lrL3z1xdLhuqH0/TACn?=
 =?iso-8859-1?Q?nRPk0+/zT/AZ8vmPb8cBSveiv2OLa4NAgS9shojuXpAQyjwhbVz97EjrlC?=
 =?iso-8859-1?Q?DKxw8J7GdMGfLoqpizXL8bUg0Q7SME+geamp7b3DXRi3XbfPzKw1zaqBUV?=
 =?iso-8859-1?Q?hAX6SCl8pYZ/PaL686NjBP3O7D3kgGMzTLDzEdrpb02DGuGy3SLHvP0tSE?=
 =?iso-8859-1?Q?FJNDk4v2eVDU2WipHHpcUvm/so1cdvcubsMNipYyxYnk66yTjIU3puHDA+?=
 =?iso-8859-1?Q?ZIByoR6V4C5nYM4bk9RqFGZe6i/E?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9756
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c2aa99a7-5d43-4f65-3d5a-08de399247a2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?2G37duPWiVJJx/chQiv763E7+2eZK+davG5Isn1SfbJOlT3ONAzJPkYF9F?=
 =?iso-8859-1?Q?c10x/t+M9b6V1iZgrQ660HPiZpLzCCC75jp+MINdz3ddqdGeZ5MaFSNlJS?=
 =?iso-8859-1?Q?8N/aA/EUh8rGajRGiaZ51TTomd9DiMNu/hTC839mks1dY1OHT5TyFiJbO7?=
 =?iso-8859-1?Q?cMnPlOa2PkJm9XtHJNGZIoLj6A0bA5SpkIDAYw3vnbbfrjI6deDpmq/5CB?=
 =?iso-8859-1?Q?FlJDqOMA/r2gP1yIPfeFHfePDf7aqrryNSflbqU4sv3Ik7uCUsUk7vcgky?=
 =?iso-8859-1?Q?77uv4CWulAKR8A7KVdBOCnKvtvJybZTwulGONlW0Fmgzh2OodTNk/brcCm?=
 =?iso-8859-1?Q?PbXJ8kryN8LgoIy5brtAa9YpjwqsZCzGt1jTkzcLCrmj3e4Rp6PSjAl8N0?=
 =?iso-8859-1?Q?Uqsu7fjVAf0WpKS5cBgzrFz2g3n2Sx8mu++yxjXPuq0fdd1DxjQ7X64e/8?=
 =?iso-8859-1?Q?A9Zid4T3n+1nQ1ONI6i1OoUuRuvM2TQQU/jOTQ9xhKav9o2XqPv6QamN3q?=
 =?iso-8859-1?Q?S6PVuqARaLJX3i4Dqkd10rAEfKPpdGlKTtizDcdKCgu+P/SbW6vmIDZcEj?=
 =?iso-8859-1?Q?KGpr5AIjmENR8/7qmF7hPjLULh8WMySusym5BgjapL1qtYEwh1FMX5owbn?=
 =?iso-8859-1?Q?mW5c4IsZpVCcobz8T/TdAoqq7X96YF5JDKfwvzyXWt0A+gSDVWXIP1Mwkp?=
 =?iso-8859-1?Q?iCimQRXrn7PN1QnfiInyHzvpCS9wzIZ7n4KJljHNKZ8+GHZ+KUV1DEIyl8?=
 =?iso-8859-1?Q?p3shMEwd/ids4ft+lc7LoP/FVxDQ1j7UvsSlUzR0Xa3PJcD75pMxOHb/G1?=
 =?iso-8859-1?Q?wOLMi7mfKwBLsFGFfSAqrGIyMEQJaiiVlfVsgcWhf0OSGiQGKw4gcIRfv7?=
 =?iso-8859-1?Q?CY1vgJDZe4ZvdMhCyCMS6g8jGI2FCAW6Zo+MrAiA40OQSG8kWKSe048O+K?=
 =?iso-8859-1?Q?iD6gDGgFUQ0mVyUu5Y6KKpmvXgpdTCAiIFTo9RI5p76HW3coe0K3ZHO0Ly?=
 =?iso-8859-1?Q?MnwwaWCdZDIrkuh+2FnoSzDF2/lG42EsqvxcBigiRae6Y2U/tZZyml/hOS?=
 =?iso-8859-1?Q?AWbw8quyqqsFX0gvxgrSGeVHhHNeI2ORZpiJtIUcPKCrMMaX1M+G4vP8h/?=
 =?iso-8859-1?Q?rlAEvjTepJ0EdLpQzQCkFTf0OAIfwL7aRogD3Lr9K0DG3+IPmb57c1Z7t5?=
 =?iso-8859-1?Q?t4CuxhD/Eoqq+LsVFMqCorwlnD/qfyXO9T017xrE1vKszWRoW0GhY4yIHH?=
 =?iso-8859-1?Q?uMJhCHSDMmu+crUJb6pHRgmdj9uRWw+LMRFXduT3wIJaLM72cDqTawIk5v?=
 =?iso-8859-1?Q?0RMyCSDt77gZnb84mTQq83M9H19GZqJlCgy5FfTTPXVHCd13yongQqcKmZ?=
 =?iso-8859-1?Q?rv1NLazvMV7O6yg2iGst1v6FX3M8E7WV/cCqAU3mNppjrDBsfQSwNG/BEY?=
 =?iso-8859-1?Q?0guNJvET3Nln0jvWk4sTKH2NnjwU4IF7u/Mh1AQ0mWknb+mJ90bNmI8weD?=
 =?iso-8859-1?Q?lPXSf5gujJEzBJ+pkriQ9bG9cnno1py6o+wuc79F1f3hhDhhIyRXIKERnY?=
 =?iso-8859-1?Q?f7OPGY4zpP6NP3PrKr9SB/rljdM3I0N4AiDiocbf/rQkg3sTCzQqTYfsyf?=
 =?iso-8859-1?Q?2PxgHzQPKaYzI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:41.9040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 092f26c1-c2d1-4ac6-ebc2-08de39926ec9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8633

The GICv5 architecture is dropping the ICC_HAPR_EL1 and ICV_HAPR_EL1
system registers. These registers were never added to the sysregs, but
the traps for them were.

Drop the trap bit from the ICH_HFGRTR_EL2 and make it Res1 as per the
upcoming GICv5 spec change. Additionally, update the EL2 setup code to
not attempt to set that bit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 1 -
 arch/arm64/tools/sysreg            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index cacd20df1786e..07c12f4a69b41 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -225,7 +225,6 @@
 		     ICH_HFGRTR_EL2_ICC_ICSR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_PCR_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_HPPIR_EL1		| \
-		     ICH_HFGRTR_EL2_ICC_HAPR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_IDRn_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_APR_EL1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d64..dab5bfe8c9686 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4579,7 +4579,7 @@ Field	7	ICC_IAFFIDR_EL1
 Field	6	ICC_ICSR_EL1
 Field	5	ICC_PCR_EL1
 Field	4	ICC_HPPIR_EL1
-Field	3	ICC_HAPR_EL1
+Res1	3
 Field	2	ICC_CR0_EL1
 Field	1	ICC_IDRn_EL1
 Field	0	ICC_APR_EL1
--=20
2.34.1

