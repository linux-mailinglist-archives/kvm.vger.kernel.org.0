Return-Path: <kvm+bounces-67153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4ACCF977B
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 17:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F63A3019848
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 16:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F181C33291F;
	Tue,  6 Jan 2026 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sErae/Wl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sErae/Wl"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011058.outbound.protection.outlook.com [40.107.130.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0776246BC6
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767718401; cv=fail; b=m3A88SWmu5/yEdO5E4bgWKqBvmfBpg/7ootJC0Egkvb+6AQ7ToLreU7NX1EKUaBgIT2JcA6zymuc2b9p9yzzWxxy3d435/0CF8IoyBb+AM0Y4tzqHRcVrLAZxaTDZshZV/BGkjQqG/QAIXzfZbUUlbTBznpvJ964D+wABPogiQE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767718401; c=relaxed/simple;
	bh=5DVXzVyYIPvKAsK8eJ4C2mzHgIX0SpSY8oK1S4u4kT8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KiB35mvQJBppcnqUspe1eLLQiUW8xop0W5ptcsO+MR/FF0BJADm3iFvXkE2NhJV05pbiqIA9N3+DCnZIJiH8P0jxBCyO2oMGN5/b/SOGRRRrrfrdTgizsBpw7mmTemPoEXUXpJdm6T1yyAGVHsNtnzKnZJ6MQM053qxxIFM661g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sErae/Wl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sErae/Wl; arc=fail smtp.client-ip=40.107.130.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TkBl5B7gbsy9UKIREcGMdXSFCK3XBvbv1aPW6UWm+DGTOeXwqqIuybDWMCBWQXcIF+eeAmtqDfjEu7jJ0f4H1vAN133QHBjZEdUwv1RctrzQ+5GYiyxV8mZ9ya0iXbgIE10GgHl08hvZNO/6jZPqRRL5lFwfAp0ow4g4ZZTvhOw3e6NJz7gMVzD9VRnVNQm4ym+wiuXj+OV4uXGo9tvn0z+ytmp9BvBUlKR3IS08QZEhJf893vh31PBVKYB1lTb8Vl+Qr4b2JLKIdM+2Dk+kApX8wl2aYc8QxLKehoz4T6nIrX/ISotrP5nmyoLTPukMZVNMZ3liYea7ut/e7D4n+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wn67vVi4gfCcHGxL4z728Pxv+oRWEagvqzSCdj9MQ9o=;
 b=zEqQwReN3lkC4MSQFVq+j1b60AvpiBH5URKOn2jvHJOEr70v/KzktIqNmug/ZGufz7En8jlEnm/yEgX6cRg3+U11IA9eV5xxH5+ZHyGf/lKtqvE+vnVe/TF97shzuwyYviryPnh1xndQ/gsttfrIzmay2S0mOm73PAmYeQm9wHs5DBis2rkX+EduDxxhU5LJUFoNTFuAupgAjAUuyZ+SPilsdjvqlSva+8Gog5eGkDB2FNKbFNolru2cTDGbpwEdq+cGvxqjaWO/q0nvK/DNuvQCyhJZmWWhD5BQ73B5FwOIjqsCLsC6SIAuOG74c0urMb8vLBTHU3sO86FhpBpyUw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn67vVi4gfCcHGxL4z728Pxv+oRWEagvqzSCdj9MQ9o=;
 b=sErae/WlDJp/Mh8CR2CrX1HSQKEzGjhyrBx/CDX2zVFcNdOCgyFnPthHMHX4ZFGa5TCO+1Aby8/SV2z7He0l9HZL/b+aQJo+cBasuLIjU4G4H+7icNdynqBSZOq1ADBqLaycUTjpaJjPNDX9AogDw6ZBZjoUZ+qHsgMbF9Pc+hs=
Received: from DU2PR04CA0342.eurprd04.prod.outlook.com (2603:10a6:10:2b4::21)
 by GV2PR08MB11314.eurprd08.prod.outlook.com (2603:10a6:150:2c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 16:53:15 +0000
Received: from DU6PEPF0000A7E2.eurprd02.prod.outlook.com
 (2603:10a6:10:2b4:cafe::ad) by DU2PR04CA0342.outlook.office365.com
 (2603:10a6:10:2b4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Tue, 6
 Jan 2026 16:53:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E2.mail.protection.outlook.com (10.167.8.42) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via
 Frontend Transport; Tue, 6 Jan 2026 16:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aN3xqglpIaLtBwD28nwSIa+eWRlPeIQdKTPq40I1Oy0rFjteIeQbFvFDfsRsTH2rkwOhaShpktaGaABF7jfpG4x8KJfeCexAWcHQSMGf8XJ67DkO5yDjveE3KvjQ0ANgo4IA64KPBgllbWfkMMMnK2SI2CYiCswqTsMeHBqGAcIsoTfFPycTDi+HO1ws13C/ivpAKtzaToW4d60HiivcccTtieaDKbcFxTPV/5h+9ep7vfeNVoBIQ3LeYy9yCBeFeXdKMgoHPpCe0M5g2K0wvjevIk/8Sxzt6WVSh5eBhWeXJI1p81ATBlI+eLwIU1uwGuL9BlgVjJDlbXTZ3pxHmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wn67vVi4gfCcHGxL4z728Pxv+oRWEagvqzSCdj9MQ9o=;
 b=LqHgFj5n8jOOfHCMj+5J3VUmzDo/+4eoCzq7pNpS2/3DxkF2Rsm/m1QbWX2u+ptPt0ns/gX5QFOFa9dZKDoB1Zi5+pNxgORtZPcEVUv8c2h42d8dwimW6HyNmcfhHqJyPrAimE23naWiv5f51B05U3MyBzz/3WMj7f6RAwMGbsQTKp8v93RKnK/1h30FBIoAsi6dw2sYoAfZWuVE0GCeepyaD8Ed0qXMs/RlZtZLRLvvWv+pnpDJlVjn2UZhpc8Gf1paWrToKc3FF1NYgERDOXKWWlQ8/J0e1Wzl6kVRdHqkCou1gMhaf4cPufX7FZPNhr3NkkS0mtxoxHGIIMIuvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn67vVi4gfCcHGxL4z728Pxv+oRWEagvqzSCdj9MQ9o=;
 b=sErae/WlDJp/Mh8CR2CrX1HSQKEzGjhyrBx/CDX2zVFcNdOCgyFnPthHMHX4ZFGa5TCO+1Aby8/SV2z7He0l9HZL/b+aQJo+cBasuLIjU4G4H+7icNdynqBSZOq1ADBqLaycUTjpaJjPNDX9AogDw6ZBZjoUZ+qHsgMbF9Pc+hs=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DBBPR08MB10483.eurprd08.prod.outlook.com (2603:10a6:10:535::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Tue, 6 Jan
 2026 16:52:11 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 16:52:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: gic: Check for vGICv3 when clearing TWI
Thread-Topic: [PATCH] KVM: arm64: gic: Check for vGICv3 when clearing TWI
Thread-Index: AQHcfyzNcmwPrlV5OUioeIpzLE3NuA==
Date: Tue, 6 Jan 2026 16:52:10 +0000
Message-ID: <20260106165154.3321753-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DBBPR08MB10483:EE_|DU6PEPF0000A7E2:EE_|GV2PR08MB11314:EE_
X-MS-Office365-Filtering-Correlation-Id: b55f57cc-c90f-4228-2def-08de4d441563
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?79ZwStmWT4l+tmmCeJVEIhY982RB8jcAlCOTZnu4Cv610CjBTa0QUMWOZr?=
 =?iso-8859-1?Q?eHFs8z2KTxle+Ht5SaIdV3zTNjxr+aC185GWPKKaXifaZJMBl1mIqwu8Hu?=
 =?iso-8859-1?Q?Oh1mXkki/GkxGqig/A1E4MXRRfClzzPThKMV9QART+O6bSCKURGrBBkLcB?=
 =?iso-8859-1?Q?Y3pzxYHUtbDBLwPW8Ryhhxq+Xq3gNvJYiK4XiS5InwpBeK/jzSvdmycmfz?=
 =?iso-8859-1?Q?Cwu/QRx2mTEhquFDMNcZg93q3tu0ys6BvGdmLMxlEat54ccDm97amsJZFp?=
 =?iso-8859-1?Q?7PSnXgRcwNoQAoWu1FWu2rjTVE8H0Y9o1nXtmOaP7z68muk5qF16I87fii?=
 =?iso-8859-1?Q?TrmZ66XkXU1e2r/HI/sLvTW/a/0SF1lZWTl5qvM8OnDsyoozHITex6P1ES?=
 =?iso-8859-1?Q?jh7Ub5Nw7tihq9azlEg0HfQWqfKJkNeXiPqqWgejAYhczc0yB0HJBot/wu?=
 =?iso-8859-1?Q?jO0mQ8IbkdEyK/7kHtoeg5nxJgMU5GRG9XMjd8h+vkpLyodG88JIyGRcFo?=
 =?iso-8859-1?Q?A4G8IwCdRxgkK0eQU32UMQXKciRKzjzgrTB9Bh5ETUoMHtbTq0S8RKK+/m?=
 =?iso-8859-1?Q?1bSYEpIs0sZguhFyu0M16l0C4B+ARudtqd3f/Tc4BkbkUTv/H6uurEpgxf?=
 =?iso-8859-1?Q?qsr5i+dECOy6oglrzpeDiMBbLOtG7T9qDYYmIwSenpcNm1eLJ5f30Ru28R?=
 =?iso-8859-1?Q?WDKjhrlIloKlaEnq75yBZxVqp3Aqozm8+vy27hGmdsDs8GVU2wuKAv2iZ3?=
 =?iso-8859-1?Q?BA/R3VfCU0lKu120wUua3mx3n7FPHzZ2MdnYGqhIhY8eMnuI+eharEocR8?=
 =?iso-8859-1?Q?O3/xiZu373qnF/6yI+dDE0IXVKZ3HKduQQV7aL5GHo4YG4F+rgGMpSdVx2?=
 =?iso-8859-1?Q?OWvJklvRqelEN7hBYLB++bY4eEV7mFzIgulgjSxfM9NIQIUENvOUAyyBEX?=
 =?iso-8859-1?Q?cqfa++nu1OqA1t8ShzfgRGGn0VTsW7L19QlckOeQEFHcPIZybMzoPqmZEe?=
 =?iso-8859-1?Q?E2K9KaCTSq0KQNOF8eYOgl2XTPcmPhEAzaprfVd4x+I9z/2BNuPdeLV1LK?=
 =?iso-8859-1?Q?86lJAmUSlhG5ra9VxwlxcDgPkiGn5Ki0sHUSnEwI4Y8cPvsSSVec+UIvY4?=
 =?iso-8859-1?Q?+G3sVbhvy2UWto2pz4aIbbs7jpv+aTG2CNRbpTIAA4WXtMAIjopsYZZyGn?=
 =?iso-8859-1?Q?pfssi1uA679SfT681g2vmTab+kXiwkhgUWy/LyyVSbSe4wWVzSiCYntMcA?=
 =?iso-8859-1?Q?OasUo5D08gSbg8sWAJONDv890JJFvsUhtIpXQLl7t6zS2iEDW9RfgLYoh/?=
 =?iso-8859-1?Q?gtPrOdGa3bp0YKyCvwoTWdhDyogV0YiWJZbkb7wEHgtZcSMC2x8qNUROA3?=
 =?iso-8859-1?Q?tdzy3vNz+yVmi09+W9SrQP+qLUVp6yvn8WbSjlWub3t1M0D6LY/lw2ATcv?=
 =?iso-8859-1?Q?sHTMmC6n2MplzZpoua0dr3t4sOtvy1Hedl0+33YDuaSodZyr8aHBpQUgnh?=
 =?iso-8859-1?Q?upBg4v2XF1RPv2XPpTpLh0cX0LVJ4Qd92Mi6i/WY9ZeHRxJR4Pa6g6IDpi?=
 =?iso-8859-1?Q?G7EgGCT7Ak6aJtzjYpsAXJOjUMVc?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	250c531d-823b-40cb-0f9b-08de4d43ef8a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?g37lQhRKSDKYYEFJB3CELB2UckHSVVr2jnhTjklKBJmXSpAwBL1iV4bUAd?=
 =?iso-8859-1?Q?/SX1yT7dOGqhGnmnEakDpoWSCiS2q/gu3snRjKQ7H1QzfrvwO2gDdOcdap?=
 =?iso-8859-1?Q?VrFe2LAZJnQKZkF+1HZ0ivA2s6h7+imAJ0LGKFDbFjMYbN/V4bTfgnR2C9?=
 =?iso-8859-1?Q?oGY7zJDJh9/KCSjoJjcYHe2rRbbGoBcxGT/pla0+jgT+iKJJtywo1F30Pq?=
 =?iso-8859-1?Q?VP4R8HPMuZ7zknx+QcKmPlbGUvt7VCgTl/8RMyrpKcDcHtdS9+62YM5sjg?=
 =?iso-8859-1?Q?XkqRomk90xspct2DMDXYCs/UxT/QPzTeI9ekZ2XZkn7PLxET5wagVBLX67?=
 =?iso-8859-1?Q?VKkP/ys7c6uZikqFjZxFXd9F6/Lv3IEgampIMysWbSz/7HKRu8TPwHk7DV?=
 =?iso-8859-1?Q?j4lLVbIwJCiuNx+42Dcje312cnBwYMWJKzSpLId9DlI7NcY/6hvlZL7Qza?=
 =?iso-8859-1?Q?3MoSgwI14L7vWKgbZUQkICcBemozEEBmxcfTUHWOegvLd2p/tzit0yCcTQ?=
 =?iso-8859-1?Q?P+U5LcTHyY+iJNHWksBkk+VPKW38EDc7UqgoUmRkZd2H3qyH2yS4fzxgZO?=
 =?iso-8859-1?Q?bn1dBPZiSOoD4QUp+IbZOpS/OFnRoW2y5Fepen8DljsufL8VqEDTZzzHIu?=
 =?iso-8859-1?Q?YVe2aJZUrwepkFfQ5/5y19GlrG/2KycIMtg97YvSYrk2o0sZ3DBg1Mgrav?=
 =?iso-8859-1?Q?Nk9qbw6S3+qIR+GRW5w8qy4QUtId1i3nw8hxYI5X2u22BxOnSg7cJdmVfw?=
 =?iso-8859-1?Q?m/OZDsAojRfBmq7mao472J4HJImbpiVNngMNOUKYDCB4vFvA93ihB5dP/8?=
 =?iso-8859-1?Q?leIvdTrhwTlQCNq9Ifdh2Ou6zaFbVYjA+ktfviIh/1Y7Y/FDWi5CAPNK0g?=
 =?iso-8859-1?Q?awTVcOvcSx677Inj4IKaxR021b3YqPBVM/LtITaaZ7l2Wmf7yGaLl6CfHR?=
 =?iso-8859-1?Q?UIi50i3YaA9cyoOVkOo34FJLiA5iQMlwDY0R2UTjCdyQpazI0i/1TAHVmY?=
 =?iso-8859-1?Q?P8iUrRnuX3QP/w0irxe+RZvcrrYJZ80pO7pEFFE+PZEtdvCgAddHp/mR7N?=
 =?iso-8859-1?Q?vg3Ke7tv2qzaEGEwu00c7b/LwegcK0bDpfVGhEnclBNtTbwTqv+mN0lvSm?=
 =?iso-8859-1?Q?abzLd+HykESzY9xmSp7tfbJyJ7KgNp7E/+dafFfdkEiMCATB524PMP9+ej?=
 =?iso-8859-1?Q?DISTVbhIXfVIKdMItuuySC9h1pxMfsE7Rn7UhEMv5CeGW90G2NVsOELiGO?=
 =?iso-8859-1?Q?UW92rsTtqneJLcUPdacExQqsyVWo/L5L8WI7zEf4eVXPaGYrvX9NqdY/dC?=
 =?iso-8859-1?Q?mxhg+soFZf4t5doidmPygjhXRKbiXUh1m96HMPgSp90xaXVhfbOMmhS/lS?=
 =?iso-8859-1?Q?Wd2AVyEiPyWowzPEZesMVxlj8Dz8L7cnLcr2xfamA8+W9eRkA5uEdeir+5?=
 =?iso-8859-1?Q?YB0goKXTPXDtj/zeXXWN1L/qjHmepUP8n9ABJU/WQxYt09tw10tRT2yGTo?=
 =?iso-8859-1?Q?gIz46G0uNO7oQMF9Psq/ddXlMNuQehBNiD711iL0NxY5Cc4UrzyyixCCDk?=
 =?iso-8859-1?Q?r4l94VD3Tkl1yV5haTuJv4DREL7oab6IPJQapCDImHjCAV/oMGSOMpW2eP?=
 =?iso-8859-1?Q?wiAe5WaYy/iRo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 16:53:14.3834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b55f57cc-c90f-4228-2def-08de4d441563
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11314

Explicitly check for the vgic being v3 when disabling TWI. Failure to
check this can result in using the wrong view of the vgic CPU IF union
causing undesirable/unexpected behaviour.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1de..620a465248d1b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -569,6 +569,7 @@ static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *=
vcpu)
 		return kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP;
=20
 	return single_task_running() &&
+	       vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3 &&
 	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
 		vcpu->kvm->arch.vgic.nassgireq);
 }
--=20
2.34.1

