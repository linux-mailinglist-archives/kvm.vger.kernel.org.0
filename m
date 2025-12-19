Return-Path: <kvm+bounces-66385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00373CD0DEE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0F6B3100EB3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832B337D527;
	Fri, 19 Dec 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IRJr7ba0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IRJr7ba0"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012058.outbound.protection.outlook.com [52.101.66.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CFE37D11D
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160847; cv=fail; b=XA62/yAfTAITmeEP0m8tAt4tCc8j/EUg5Dnz+feYspX9KgV8/bhaBfjnPYMpW33dEd2ubBb5EQS999lQ+BeJQIPQk/pawHypkn4j8M6nAqdluLtvE18HwzNZlChK0kHNSKbZHaZuq110Eunw+Mu1R4zZfQI98ik/UZtnMOjSISI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160847; c=relaxed/simple;
	bh=XdxSdRE4Bq3orpgxonHmc39rWTy+57tB1PJr79sAQBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NLkxq9TH6zLKVKLTMkjpsMMY9/Y694Fw+iMIpyskP22acetR5B1Jv90jDERLwZfL55RvV3a1VwpeT3DNftg68Ne7WkYzIh9/kK8kTpH4DUN0VUPII6X1NH87Eu+AGgC/409BHjZhHxqGVQ8szPS5jDNivqaIW12gtRED9Yljqb8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IRJr7ba0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IRJr7ba0; arc=fail smtp.client-ip=52.101.66.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UqyvgKyIQ7wBAqyhs6sozToKFsonyUb/4gAhbQqb5fcynDzHdhFotx0l6ckzSO3KBZ9GkkpzujCMb400M27QdElotbvVdHMfLqdbmojb6L+yI3OpJdymUyCB0+AnmAqyQBDqqkH311qqWztTpatUyST8flGyHFEZSN4wq3zCB2zdd6tUPWrTWIQJ6ALkV6mdGnlNsa1Kl3XF5xEvDrT6POFr2ShJECV9hyJ+geP4Qwpb5knZeOqBvEMHoREo5Qb4tVrP+WxQfqx0O5DayyNlGu/0iuQdgJHD2jyNbl3VQyOo+ZQxUXSDSKrb9SfH9M6qIFEmg6PNH2N3CNzjXYw+9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBaDQOHlj3m0wzdxMCuAB8iJvtPsr0w592FEPzt3Ips=;
 b=V361+d0lO6GuUpJsSPIX+9xaFoKLYXsaObEeioDMT9YibcWtzV+x64HUrei7KmMjmOA2QG1MSkaMicaCdEmVU4awtkCuIY0eLI16W+hUDm3PbSFUbD2PaXsuT1EAOds5Kfv/fQXbqwS2LpDMgw1Sv7xSA2mrBP5vIrGIUFU8Oc1/EQgE/dvhRvJ3sTAKkXlIEucJiUJaUrVjfKjrEPpczNVvAbhWtRYmpTlG2w2XFHyxL9efYmiyW3zK7ruyUGdWjR5tSw/xMclTiwfv/85QpdOU40a3dfqTrdVTkuuiIfQvw7zwLksEZhJpTCodiWyuz7J+28NFA41LehJ+UXRQMA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBaDQOHlj3m0wzdxMCuAB8iJvtPsr0w592FEPzt3Ips=;
 b=IRJr7ba059XpbQDpFsZokUAKHGiJGgAuXf4tE7KDx/CsxmFrZp3Xb9VBDZA38n7KZKNWR0yZHhpB9mA0S6rFCrFgz3hcwGcM0PGndGVO285IFe0PqUcH/2MMRIozMyCTjMHpFrZkMC3gpiieeRwnk3erCe3hKfnf9vC9lwAGE4Q=
Received: from DU2P250CA0012.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::17)
 by AS8PR08MB10269.eurprd08.prod.outlook.com (2603:10a6:20b:63c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:59 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:231:cafe::bf) by DU2P250CA0012.outlook.office365.com
 (2603:10a6:10:231::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:13:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:13:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGdG4DE00mUacYXIud0/PFSuKMO4CCleB4f4yeLSjU3sqPKE1qU3zT+xXQsKqlsSUD3XZOnT5K/xJJpiRSZqpilFU8uQIUdZBWqdHtohklC+UEW3Gj0Uw7p7aQBMDcFqNku/cGEWM6fLlqkJs1UsWdLeDViGe0S8Xm7VSbMqPGcMl80shtIS+97ntmRhd3EMFaTLFzvRtc+Jm9FhZAu4COKr4Gp7j10y/UgqFj1N8KYV1CJHJllZcBCRVASGrbV3UfDafjONuLMi3f6t+oR6RAAMWBkHBqTLmmks6VR8lSFsdJqnC/rww3PC8YtlOJjltf+rJd5fd5/1O8oYQxAMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBaDQOHlj3m0wzdxMCuAB8iJvtPsr0w592FEPzt3Ips=;
 b=wnPNIFXzr62gKOeGlQYwctzmZfE+pEFHmVV0RaJVZFCQwZM7D1SRCTzAo6SjsoVsa+7HKukL0jJSVtheYqVNkoCmo100UW+FMwuRccQ7TVVRq0u9yRhatJH5HWq8w85kHyA4HEoiHofUCtT0kVTv1L1+7lHhzeR9YY3E4zW3E3OhXSiVmdP3CIIG+Cibrojm23hZCTrQCzlM9d5Z1pZ8foWm1FEi6QHSizkZPFcDmh4KmRWa4XuYcY1w/AJ2vmXY0we0Sv3NG4NDNa+ESvCOsa/nu0/H+eojuEZg7b5AQ0Gj2k1GzxxFa3+QEo6QjR4R+r8GRQjc5Rs8myZvFrBVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBaDQOHlj3m0wzdxMCuAB8iJvtPsr0w592FEPzt3Ips=;
 b=IRJr7ba059XpbQDpFsZokUAKHGiJGgAuXf4tE7KDx/CsxmFrZp3Xb9VBDZA38n7KZKNWR0yZHhpB9mA0S6rFCrFgz3hcwGcM0PGndGVO285IFe0PqUcH/2MMRIozMyCTjMHpFrZkMC3gpiieeRwnk3erCe3hKfnf9vC9lwAGE4Q=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:55 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 03/17] arm64: Introduce GICv5 FDT IRQ types
Thread-Topic: [PATCH 03/17] arm64: Introduce GICv5 FDT IRQ types
Thread-Index: AQHccQJVfE0cajhtak2b/QVRtTXmEQ==
Date: Fri, 19 Dec 2025 16:12:55 +0000
Message-ID: <20251219161240.1385034-4-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB1PEPF000509F1:EE_|AS8PR08MB10269:EE_
X-MS-Office365-Filtering-Correlation-Id: f56d1341-80e0-42dd-c3be-08de3f199d81
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?TEYCaMBE/bIHi29ex3VCcgmFKnDcnsawBAGSFBbata8MwaQp3OpaNkTzfg?=
 =?iso-8859-1?Q?5NdvfC6b40uHaHAcFj3MEnikR9H1PWwcyUmaypUiw172zB9RY/KWsNcjmu?=
 =?iso-8859-1?Q?slrxPQeqde6ywXg0baYhHR1TelzmaIhDGXtfxKLIMvdbzhaRbow3N8IEbX?=
 =?iso-8859-1?Q?BXbXXw14dZemLKNivjHmawJxD5n5ICyBRPbN/5BHnS81etXElW6WhfCKO/?=
 =?iso-8859-1?Q?Nn+qzqbQxSfICAUQ7rlYRRuYKTG1i7j2vWpnenah9IhLre6UzGtsIZwlra?=
 =?iso-8859-1?Q?dOsV+4zvQ+uhOvvjPS29BU486HpLIhRkXNWx3WFf8BprRguQL9w2e4dT66?=
 =?iso-8859-1?Q?gfQJDgSEtlGvG1CBquEBSMe9BeFqGOxYkHpq0eYrTGZBVIMhJ71BOXYLOC?=
 =?iso-8859-1?Q?nzeE9vM29ghQ+zarQpqJ9tEzzuTzgMU/2NXhyBRqeXjKz4UHVLCNDcfJrB?=
 =?iso-8859-1?Q?22MsgzAzbThsQOMq8cNQFo+hIRf345U7h/eNZH+SlsXS7rSw4LhSpw/hps?=
 =?iso-8859-1?Q?5ohPIHTxnL3Kn6vsFN+5KY37b27CvIhnkdV7MT8s6kF0pU5mDeuC6sH9c7?=
 =?iso-8859-1?Q?EmU5N/jBGaBFKCYNazG+R3/3YXaz3skTuiSjs1413lQqsu6OqOdgyAS1rM?=
 =?iso-8859-1?Q?zlDjFfUH52k+MmwFwEz8P1Nspo6iWRG8gol0ULhGXHx198nRrnIlcB2470?=
 =?iso-8859-1?Q?gv1akPhNdKIgjCdYrYo0uKVsP5So/R9xn3aaUBGA6cFhfEBU/ACd9rhv3e?=
 =?iso-8859-1?Q?cPv0t82OpkB/BgRF1VUui6iaDyJ9Bhv77C44+tbD5ZgY2JK0j6nNnLtFtm?=
 =?iso-8859-1?Q?Qtv771W+7SikCGSSe+D2Ix0X55QxoxqrjGGBvlMcIGH1QdpbWCAdHBJkAC?=
 =?iso-8859-1?Q?Yiwqmv4M9gIDGPcyTyHa8WKv9PTCAc0+5KRBacVeah+8nLQqpEmPgnqumz?=
 =?iso-8859-1?Q?XP31JUWMzEFoaaZrjgQ8/zMfnmcz7xErW11x3IsL2V2iv/IFSU2ay1QY6w?=
 =?iso-8859-1?Q?u3FZxPl4X6GoENylBQ0PE28CmE5Czg++hvCqgzjlQFwdzjtSg6Gx7ywUjv?=
 =?iso-8859-1?Q?As1m1lwDUaSx5xJL98Jg95VOTqw8b+v6XfunsZATwBKYXG48R7NS3THBzd?=
 =?iso-8859-1?Q?3qEeVDcJlO8xNo3HBpqkjUEjCmBuJA4hkbv9keodnXMe/J35kaAO+68r12?=
 =?iso-8859-1?Q?Bpgwc9zgasik9z3y1Y1aGC0BOP5SPiu8MiqPuQQP7oOx8ytXh/r04Ho6Bc?=
 =?iso-8859-1?Q?+qEUhxynK2HhmPOCrG1Gdhncu852P5hjHsYQsIgzzipGomTklmdxlpA9dS?=
 =?iso-8859-1?Q?kCIE8klXYf3ZmMfvaWN47hbgtHPUcPpaMO/0nwV0xM4lN9Q3IaxUuMeCKM?=
 =?iso-8859-1?Q?GhQE1CQkt9B6T4g4l2rwyGy00RpjrzXh5v2aWd3nRr2gzhJ2orx1KdfNq8?=
 =?iso-8859-1?Q?1Npb17bzh7E2N+f49mU7cKAl5EhMeoYXg2aX3xhtq4wY3dsZAVeqSwpCPb?=
 =?iso-8859-1?Q?9ZyEx787By6Pb2ie2U9skOwuJh9CBi9lcOb7DGE6YBQN5xirZMquHuTsC8?=
 =?iso-8859-1?Q?3NpQ6TJUNu4TmOCfQKpUTsBg4i3U?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	89eeb635-533b-412f-635e-08de3f197802
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?4TTekEGBAWyq0XFLtlIsCEFYJ9LSKHymAuexsAhxpqKpL4pZ68NEDQOFv/?=
 =?iso-8859-1?Q?fEAMUtWOG+tqFjild/j5T2WgCAxC80p1Hy2xvs+SaMtf2vIBZCRGO8U03g?=
 =?iso-8859-1?Q?KHrk2NWjJkWG3VBGo0DT9hgTUBpWWn01Kp3y+5EwDMpI+ecMSNreaBy+vt?=
 =?iso-8859-1?Q?LpybQlyNGCiib57Xy8NxH9Fm7BsvG/ilmTymOU/ppi7HrJyEAfzGhBd3yl?=
 =?iso-8859-1?Q?LIKA4peqynxiW/eYyQHFlNU0vRJDGxnYaXkhnImNCRMaBJIO5amxgs6Cyp?=
 =?iso-8859-1?Q?119k4qVxYHj+U7LMVBQaSerRvTEMo9mtZCOJ/OeMfx/rT6Gtoux1A7L49q?=
 =?iso-8859-1?Q?taQYdbsTJKLivc3evfJCM1NM+wX0Wj8rQn0dhVMAm3CrDrl7yHk5aje7NJ?=
 =?iso-8859-1?Q?vHh4gcCPNd1zrAqJcsoNlTF2wpzxPLjjUZRTPbNSKkJccp3kgNGXarZhwc?=
 =?iso-8859-1?Q?7R0L47fNk6NXaymX40C5oH4bpFiwAri8XH5NM26jiTj+eda719+mafw+aH?=
 =?iso-8859-1?Q?AQ2ZLHu/XPqNNXhW824EKlL+mI+8p+w5SyVcrEMcK78ToKsT1Jp+P1JVae?=
 =?iso-8859-1?Q?WRC7GqkBtcvjuJjofcyM7W4Ng/z/nXoiodWzz5f3vIiqIIF09Btkj5aHwN?=
 =?iso-8859-1?Q?GztErAdKBTXY2jqh0xJk2wAp0X2NhawedsV3s0kOEdRJmGt4BcFJh/8Rih?=
 =?iso-8859-1?Q?z96zRHHHO1VGu05AqRHlsLHpiPRcIqwPXMRnf21/AOeIkq7+Nk39MXHnWk?=
 =?iso-8859-1?Q?J5At7lYZfGAFzR9oqQea10FDxjC5XlRtLaT5W/Ild7NGx8+VKtl+SL+ktl?=
 =?iso-8859-1?Q?tP0SgohmX4BITxNWQ3BuRuidx2YJ8n2Ud7eae6w/VqSi6hooZkHUrtC2cb?=
 =?iso-8859-1?Q?7vUoU2sA1V2L2+V7nK59+5lg91z7CxsHbtgA/5cozww6AHOyPRTiz2pVde?=
 =?iso-8859-1?Q?Xvei6vVPttihs8DjgJuXg+ZgQkTegmJ3wksPpCUDNBdQ0vmieA3yr+lKHH?=
 =?iso-8859-1?Q?3/gyH0QCBbolAZZFHeZjsbf/fdswDcJwHx7l7o0WZ9Q1Ljn5zAY9IkfKXA?=
 =?iso-8859-1?Q?+OnmCbfFVLP5wTJ4zJnyok04Z2qqcMeU+hC3soTqWKwY2SC/VSLuvV2rCw?=
 =?iso-8859-1?Q?OfTW0qXayKgNKw/Q722/pYR1HoSFebcA4C0tMfS8ebHQTeKPEdngrfAi6F?=
 =?iso-8859-1?Q?pSRp1goJ2A3Y3B5AuI0aIN37R2etIKqZ2F6z7Ze56zCZ+w0k449imM0UT2?=
 =?iso-8859-1?Q?2cVNrxS2aoaoPVNMYuH+U4znUacCnmtiebDArzazIRzbR0PS5b1EtzNgMr?=
 =?iso-8859-1?Q?TDPk6d8ygYN7HFkDUVSsULSo90rIcYxmECWMwOuLqa71yCWDv0MNEzrcVn?=
 =?iso-8859-1?Q?oQE074Kxgmow0M7xDpZjZML98sHc1Pky2DL3BtTwOcxmozCI1XzA+oq7uv?=
 =?iso-8859-1?Q?hVxBRbfqCBAhCxiQgszszh7k8YgJr0ilHHtydBv3Km15y3JP4Ct7D2ACn0?=
 =?iso-8859-1?Q?JYOntK97z6MWhn4VcP86UFklg/+0TTHfgH3z4aOHJIBdTbBP5anDcREpQV?=
 =?iso-8859-1?Q?K+uophYbfJjX3OOGpY45rXtDPoHoRM/AEwy2HGVoUJecxd82LyVwr3EICL?=
 =?iso-8859-1?Q?h/S7FVYmCmIVc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:13:58.1343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f56d1341-80e0-42dd-c3be-08de3f199d81
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10269

In order to correctly describe GICv5 interrupts in the FDT, we add the
GICv5-specific FDT identifiers for GICv5's PPIs, SPIs, and LPIs. These
match those from GICv5's device tree schema.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/kvm/gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 83fbf89b..dd7729a2 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -10,6 +10,12 @@
 #define GIC_FDT_IRQ_TYPE_SPI		0
 #define GIC_FDT_IRQ_TYPE_PPI		1
=20
+#define GICV5_FDT_IRQ_TYPE_PPI          1
+#define GICV5_FDT_IRQ_TYPE_LPI          2
+#define GICV5_FDT_IRQ_TYPE_SPI          3
+#define GICV5_FDT_IRQ_TYPE_MASK         0x7
+#define GICV5_FDT_IRQ_TYPE_SHIFT        29
+
 #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
 #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
=20
--=20
2.34.1

