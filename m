Return-Path: <kvm+bounces-66368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5150CD12D4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1664A3006A57
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A76F364E83;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rJnKCYFl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rJnKCYFl"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013047.outbound.protection.outlook.com [52.101.72.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD3361DD0
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159642; cv=fail; b=jmr22yNcAju84375oFcRAW68ZMGEQoPndN5mu9EQ8t3u6PHZaPS9nZvsob1aX8zNs4AqtMEToyvfuI3iI8VKqmYxVgUDRXDdJvCt1MnYmnxBKmfQhlct1utxlzbAVnbxhU7P1HlYJKqD/x/amdEDGXbEHbNVyGdZgb2xCVDDU3c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159642; c=relaxed/simple;
	bh=1G8FG8zezUBnaaE8xh0eGs7BNAfRVtlorQkOiexO6jY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KNGiG/Y6qgNmtVaccBKDKeoZ/cIUzUfo0Pdcy+sF3QLcaaaAOMPanPHbkkCfPN0gPPT38BSwBHb/Vn8BtgRD9LiiRYHrpAu0nPmxeqx8y/ziW22NMd80kNDTVcoqxebZx08iGRx/BUNlJZ3IweGAgZusiMNUNGkuEyzKvl6x7B8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rJnKCYFl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rJnKCYFl; arc=fail smtp.client-ip=52.101.72.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=c4KQD464iQ0LhuJ2h5CY45R/ROS0rmDnvx36KBAG8O4M2GAx6NvoQ0DuWh9EZQ3NSfAXzdVD0jBIyESjNG2OIlgrwbqf45yAJiWThykEaTVyMRxBf0C5hdEDGQJ7m1BEy2jZ9cEBCZgjtL4DhmorgTfgpwh6z3I9W4+D/ZTY16ieIM4/mPIrp+v7vPDxlnrye8Vp7gwgXHXf7bg8IEAyJ4E0tSkqmskVCbbvoRBPoC5YUm8u9PHgCFP6hWbjU5TEWYUI/xr03oD3CimMsTgCdwrkRPxf0VHfYEYmWQs/BDffTRonKz88lh8tF+sBc2zHztgEaY7XdeF8DCE76mK9NQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaZ5ehkz1iCwjtml0e3TkilvXdgzE3mY6EO3O5xZXOA=;
 b=ah1XEEuJXk8QlMrW4ZFMbBd5zbfgp6l+mnOwMY5Z1XBd/DwNxw4MPeg5S0EpK/86WQXCz6NkaLYozJTWdK2OIt1t8NZwWvmZV87BDmkq399zoZ/EuZVhB6PfgzrxvNV5AJsomL1D/q9r9e0FFXS46UqvcYKJGY41CoHt2PqGj6VM6fNtvv1jNW9WSZgeZhl8tXpmK/kAav1BJJRVRuH17PurqWB/rXuZgXjtL72C0T8EhvNw8X9P7sjx5rGsk43SIuoP4OeOt2PTr0Lnx6/47s+9LAOTbPFuGQtUwKDTdLZBE13T1BndZ9Kwhg0fv072BMeZSJUw7lhgU7l0oArgVQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaZ5ehkz1iCwjtml0e3TkilvXdgzE3mY6EO3O5xZXOA=;
 b=rJnKCYFlg+wq7eepw3jwXuDg8bMcrvE4E3dM79QH61xV4/lYZZyZCc/mEB9kSDFcx99k8Kcj+xys94m5EhWAWVtTVxj+Gu85bZKj4RvoWJjTi93UV43W3P+K8CfhQzOA9/VVKNbTyDYlKRL5XaOtdF73DcoSXUEj0hA6jA4CglU=
Received: from DB8PR04CA0009.eurprd04.prod.outlook.com (2603:10a6:10:110::19)
 by DU5PR08MB10774.eurprd08.prod.outlook.com (2603:10a6:10:529::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:50 +0000
Received: from DU6PEPF0000A7E3.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::3b) by DB8PR04CA0009.outlook.office365.com
 (2603:10a6:10:110::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E3.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via
 Frontend Transport; Fri, 19 Dec 2025 15:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=INSZPfTidgZJCKoELhWNq5i38Q4LgyuS/Gen1igUpZboS13njU1ooKMB46vKYBvaWW3lOl4Dp+f92z912jg/7pwOuUsJ8VL73j3TMc/F6uV0YSa4Bc7gp0pFO+r3DNuzkmCHqdyze9uZDzJhIwbyxzMCfq2W3pLaPn3vRidiCROjG1tVkQG5khpTp5fZQpKqRFwa+mhXgNdq8OlYrtcyUwQmk9TDYpe8VlZPWDi8/3KpUx/bQP4Cl8JoMmvVtQVNwtj3Nw65og8Kjlxv5GDaNWQlm1iFgE9PikjTqCSzs8k92s/MEaIWAAQFadhPE8E3O4fXA/uZX6s4dorDptqi9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaZ5ehkz1iCwjtml0e3TkilvXdgzE3mY6EO3O5xZXOA=;
 b=FVAaSuiyN34LJ5NQy8buHwNQYQEFthdq6TH5E463COv+nMBUOeGPcX6M1sh35w1pg4gUypj4AHCriUsc55ewpalwmIA3+n98Pq/SKZOcbs2UhegJqqzrFyi/UjvB1VZdDLwTP2HpaqL2C5EFWgddumxg8fWyZn6pujShE2avbz0OCgYFQ9E3AfC9DlwwkgxH+QEgY7xKlle/YzQLN+IpcB8IKaRIBBrKD9G1wAOuc7KZfQuT+K2ChBA1p0Y63r/PfawS2+EsMnA/2P/bDfSSfAIHRB5u6AiHXNXouw8gpuAiTjY/nF9tAv1+gYlt/fBLkZn7dB1s9ncj9HuBJvgJuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaZ5ehkz1iCwjtml0e3TkilvXdgzE3mY6EO3O5xZXOA=;
 b=rJnKCYFlg+wq7eepw3jwXuDg8bMcrvE4E3dM79QH61xV4/lYZZyZCc/mEB9kSDFcx99k8Kcj+xys94m5EhWAWVtTVxj+Gu85bZKj4RvoWJjTi93UV43W3P+K8CfhQzOA9/VVKNbTyDYlKRL5XaOtdF73DcoSXUEj0hA6jA4CglU=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:44 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:44 +0000
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
Subject: [PATCH v2 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v2 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHccP+Cz6EmyrVVZEWilYQQydCYvQ==
Date: Fri, 19 Dec 2025 15:52:42 +0000
Message-ID: <20251219155222.1383109-21-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DU6PEPF0000A7E3:EE_|DU5PR08MB10774:EE_
X-MS-Office365-Filtering-Correlation-Id: 617539de-8eca-4cf0-4da2-08de3f16cd91
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?9hI6yTP52oorT91AqzZS5d6Qybma41UnF1tooZWoeK7WmevUJGNtsmXKgy?=
 =?iso-8859-1?Q?tT2w3IGOQ55movjeiCgnFXUiuid1dYypTGgf9rqz4QxTH2Cc+04kHHJf60?=
 =?iso-8859-1?Q?Nugm2x7gS/WJLq8lk1N6Q+nHh0UtQV/I95Pqz8uhMh1czIMgN4fStRacrB?=
 =?iso-8859-1?Q?Z4wkn0jEQwtVTkoeiVBnx+evYc3Ii/ltk7/ajZh7RKdHYi4grXodpW3C3O?=
 =?iso-8859-1?Q?jgOAOkh5Brww6UdCrdtDa1x99Ka8hEuZwaG0lnknPNXv28MnsvmpfHxHax?=
 =?iso-8859-1?Q?c/e2QghJkFXF6nDaawxGnnxO3+izqOgscw+9KkMqwEAirjy7LwlIfxEyAE?=
 =?iso-8859-1?Q?ppwljTK85+/7D/HZUM+dHTqxgVvMRyEyMFv3C2XABMQ3MX+Y4KNlfjry09?=
 =?iso-8859-1?Q?zGd1NR0MUIAUQXadXO26QU83YIDIra9kLy46wtweljP6ZIepwZOddp7T0c?=
 =?iso-8859-1?Q?Q5ihqaGzZOmUr6plcr9GPQlC89LcJqHy5JPYq252dSvxtjLnjcEbMp1SU/?=
 =?iso-8859-1?Q?blgiroi1JpTwry1m+mEnkfX/GXUUPLP76ESWUqXCIiLzcBWRoYepsX4BNV?=
 =?iso-8859-1?Q?HKGLK2QHgU/kJrSSYSDXKewoN63Eccf1XBXGh3Rdo98x8KZG3MRhpOoh57?=
 =?iso-8859-1?Q?fNCxm4s1DJ8IyT+blkzYmx3fXVIJguPHxDZfgrkT0w6fIVhPXS1znaOLPw?=
 =?iso-8859-1?Q?xKgBSn60EPZBGy1VRnaPr8YTnqLAc7NjhEm9api7eDBBLBEo+14o6jqVHU?=
 =?iso-8859-1?Q?9anb+hYgIviFQJsMGVm0PWgHcIIwnMUEGW8/D3pJeRHKOyE7LU14u6V660?=
 =?iso-8859-1?Q?t4gqd9A8Pn6IGfnQ47NcYGXut5V6DgC3eaXHe5wasn6BbNNu+s17/bADuA?=
 =?iso-8859-1?Q?3OgVjTQi8Er8W2rgbZhqdtLg2qFOR9/hvYFmLQwlheIr/CDnFyYfgPT38G?=
 =?iso-8859-1?Q?9AUGhdHzgpL9MQaGDUNguexURyzMEUAOAhURmRwo4Swbky3lqW/7eS2osO?=
 =?iso-8859-1?Q?ovxILhG2KgUBKKfSZfAYw8bX/VhWu7Jn7WTGGjpC3/4uXy20gV/gNGalBp?=
 =?iso-8859-1?Q?I59U4gVVdPbME8fs09SbxCvnKLmO6aFXtAVWwQ73K8tLI1TZXIGjHutSkW?=
 =?iso-8859-1?Q?9KcdIZ9bEwKPSm6B00/80rAv3kRiMeWIV92LZ4xCeMI/zFBpnmebez7bOP?=
 =?iso-8859-1?Q?qI3a80cZM61ylQfghsnRsXQvpHZYIZETVvMOPylnpdi5mcy/SX4/AJBEMK?=
 =?iso-8859-1?Q?U87HrOK3i84TTd+hOxuzP+AkD0GApuj4j1/diMyGNCH3w/dT/k9Rbzlb+1?=
 =?iso-8859-1?Q?AMDNLw+0l/DroYFyUaSAVIOk19nvgbRYxP5eHypccSYnTlFZ5U3GzROgzm?=
 =?iso-8859-1?Q?58BMbkhHPsRZMljIo2m1jx8knK06Rp0puLuXFmfnuS50fVzfL2bneGfrZJ?=
 =?iso-8859-1?Q?0C99FL+YF2Crxy8xslz/qwAoYtUNJClilS93t5J1n6BO85v0FSOSuYbBAK?=
 =?iso-8859-1?Q?c68prFki8f4TTCTnBWHLeDycxcHBmKpvnH3AswegNIbMvMZU/ZE5YjmYJn?=
 =?iso-8859-1?Q?BFpc2FaHeyWh3UteDUQsb04iQQgO?=
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
 DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	660c5c18-8501-4e29-7c11-08de3f16a613
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?XHoagOr4OeKSI7DtRj9VPrgfLEGS2JYMxxqvB13RoMwJtD3veReZimfI0o?=
 =?iso-8859-1?Q?gmtT2/YUkZMrgZ/4/Se02n6ZeyeaR18EyR8Lg6LylTAs+uPWZAKI7gsWw5?=
 =?iso-8859-1?Q?hIkOyFN63nNVFaZl1msdJIWsvdQx+8rP5E/BhAFKzEVaBbW6WQ40pjakfz?=
 =?iso-8859-1?Q?3KhWeK61PejrsQB0GOp9ivR1u/dBspCYpASxjecF/WgwqpKrtZnFdLcj7V?=
 =?iso-8859-1?Q?kBicX3RFM6OBDWX0k9/0iwn1W/1EtKj4t19tQ+1OIVuonDp/M68OPRbhcy?=
 =?iso-8859-1?Q?v/KOTfPM3mZtMUz6hlzuVn1UGcm/6roiYV7vHaUhdsKrCiryYdd7UwAMvs?=
 =?iso-8859-1?Q?wrZPFejZ5eHYE9gPuit/3cvdmpKa/Afx90C/Ggdv+nrPzBrmuRZCe7I/mD?=
 =?iso-8859-1?Q?Gx6D/8HPqaJ1zZ0XxmPG08I8ZaSMDYLLF84Ixai7JO64VCAh8WpZY1njgh?=
 =?iso-8859-1?Q?u6qroMMH3wZSdDyxkpgXan9ZJsE1ZUP1hjDrJT5cDkg7HYte9a/UcIRajm?=
 =?iso-8859-1?Q?e/fscwn0xK8uHriwscMuIXhxqXHe2Nb9ASOnFrDhAUMoqMblvx5dfFAh0z?=
 =?iso-8859-1?Q?h7z0JeqnlHG+EsBlovS6ijI8f999c3hT5fn8vHqZmS8rImL/p2KZ2AjWNh?=
 =?iso-8859-1?Q?O6/O50zYQzw6qEakDO/UDgbJGewTCMxNWK3/mWspl2EWvBbnoz7VG9+tWf?=
 =?iso-8859-1?Q?spViFk2SKRut7A6aAvv4jBmXB0Ppogz5g/mQsVFovNh5HXQ1NGw1MW7OI1?=
 =?iso-8859-1?Q?BuermEMLK9KlErehqlAGnKbE7rfrbXZYqRC0b7B8TtlbgBxPdV1IlVMXEr?=
 =?iso-8859-1?Q?bQVgh1HMGFIhTtg86YRi9RLEkORDSOpgAE1+0h0gYjk41C/eGnmUJ1yCwe?=
 =?iso-8859-1?Q?zrgs7r6Kii08t7bVIwNOvuSe4vPYBJKqwBKTjmLtY58Jlpusn/gqzvX8aX?=
 =?iso-8859-1?Q?UUw0UFmrXtvE7Dbba4TYEDNyDL7llE9OPU6jap7n01pv7skNNNlK4GPFym?=
 =?iso-8859-1?Q?I7+pXkadNz0gphGtp8J5pxvrT8JwnkSNuqRuCVyFjp0BLLHZmKeEEuEmq1?=
 =?iso-8859-1?Q?Ke7jpGdw4xHxSaYvkkAWlOvVLljuz/7ygqx73qspGrlBHgmhsBuu74ZgnQ?=
 =?iso-8859-1?Q?Vc5jN1dDhKCwElqyF7eU8EGO5/laAO86rk2/xShj2BXju+aFw4is9Njjmy?=
 =?iso-8859-1?Q?TOlYcX6tvxUDH5EDjQpZ9vNorzYwJndXqw45zAp285ffKUPF2f/agt0rx/?=
 =?iso-8859-1?Q?/TpcHDuRccIS0YMP+iCkonpHTdq9tvaurRiQPqHlu0om+9sCfsy4Yn0hzG?=
 =?iso-8859-1?Q?/y3yMp4riGtL+zvosawAXJ8h9Hxu0ozZjSFPNu9h/RxXpCwK1VO5bPawq0?=
 =?iso-8859-1?Q?/S3dGL1OuDQ7nXu0KnZlQ02uUEH7mUSl4BV0NVGVVvpi61QhJAScMxBetq?=
 =?iso-8859-1?Q?bMlCy/Ms4jnOnqOX0RhtPObjHmdBo6Eqgt0CEyzOOO7WrrmPE3DYG143pm?=
 =?iso-8859-1?Q?PHkqT8/QgzfeXB9Nj+BcIS6QViUWkHH6y1ME2czL8AgxE6CdyFcXuZs4ku?=
 =?iso-8859-1?Q?u8tnkRvN5K30VC4BkbAT4sXO5rTCTGlUf3kzuWLC2CuHS+Ja0VqNiYqtew?=
 =?iso-8859-1?Q?lEdNh/VYcs7N0=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:50.2880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 617539de-8eca-4cf0-4da2-08de3f16cd91
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10774

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so pick Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    | 41 +++++++++++++++++++++++-------
 include/linux/irqchip/arm-gic-v5.h |  2 ++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index bcc2c79f7833c..03f45816464b0 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -263,13 +263,19 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
 	int i;
+	u32 num_private_irqs;
+
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
=20
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
-	vgic_cpu->private_irqs =3D kcalloc(VGIC_NR_PRIVATE_IRQS,
+	vgic_cpu->private_irqs =3D kcalloc(num_private_irqs,
 					 sizeof(struct vgic_irq),
 					 GFP_KERNEL_ACCOUNT);
=20
@@ -280,22 +286,39 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+	for (i =3D 0; i < num_private_irqs; i++) {
 		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
=20
 		INIT_LIST_HEAD(&irq->ap_list);
 		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
 		irq->vcpu =3D NULL;
 		irq->target_vcpu =3D vcpu;
 		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
+		if (!vgic_is_v5(vcpu->kvm)) {
+			irq->intid =3D i;
+			if (vgic_irq_is_sgi(i)) {
+				/* SGIs */
+				irq->enabled =3D 1;
+				irq->config =3D VGIC_CONFIG_EDGE;
+			} else {
+				/* PPIs */
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			}
 		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
+			irq->intid =3D i | FIELD_PREP(GICV5_HWIRQ_TYPE,
+						    GICV5_HWIRQ_TYPE_PPI);
+
+			/*
+			 * The only architected PPI that is Edge is
+			 * the SW PPI.
+			 */
+			if (irq->intid =3D=3D GICV5_SW_PPI)
+				irq->config =3D VGIC_CONFIG_EDGE;
+			else
+				irq->config =3D VGIC_CONFIG_LEVEL;
+
+			/* Register the GICv5-specific PPI ops */
+			vgic_v5_set_ppi_ops(irq);
 		}
=20
 		switch (type) {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index d2780fc99c344..2ab7ec718aaea 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -13,6 +13,8 @@
=20
 #define GICV5_IPIS_PER_CPU		MAX_IPI
=20
+#define GICV5_SW_PPI			0x20000003
+
 /*
  * INTID handling
  */
--=20
2.34.1

