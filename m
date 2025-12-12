Return-Path: <kvm+bounces-65859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2D5CB91CB
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C00030D1B0C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC2D324707;
	Fri, 12 Dec 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mBK8dc40";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mBK8dc40"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011031.outbound.protection.outlook.com [52.101.65.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2C430EF6D
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553034; cv=fail; b=EY8Nvf8S51UC86RXNEYvbpBIKPO8XosyLlMTDwqy/3/RX4hqbXAyu2xhqctP1XFO+paiKYvnng75wuMKGkxkqoki/Xom5n5iHZrzd3puOaH3ZPupvs0SLokQUmTlxnZhavjoOT90vZPRapL8CO8PBv7zHuUmrkIbAUMZrpjw8t8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553034; c=relaxed/simple;
	bh=zxKpF85JyDI0XmuBbbqipvVyCOJGiU/C13kgeFIqgCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=osiO7yb4AS5nDm9eT3xZaOJTMOGGilRG5IjOcWSKJtt5IWh7crehnjrtf570KwWy90Ie//zeKZwG/Zl9VEBbPgHdrixOPEsOCMpJcyq29mS2jJ0UGjppZ0fvoOKIcXQeQ98MkXFs9Jqs0bfrSbQf23YaOkN3apCrnK5l8vMpXJI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mBK8dc40; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mBK8dc40; arc=fail smtp.client-ip=52.101.65.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d5XMmfBZBmsvnOmsZ/VKaxaoZFmQwZ0j+sv6z0pmbv5fRFmAsFsB0iJssMowPY/7UvxVv8ceCmNFFbnhVTCdO+/fKH58jGoBZudujfk06GgB96imj/GvZ5+ftBPQBj6XHLTqsbn5T6YLxZKO3x4Tdfnu7YIWAZkdL0YcGdwM6myuHN1Uv00bkxtnyGcHaTG8nDy/ZlFAM70DdLbFWj3fCiS8u/XumTw5NNJwfC74gMm1PLMpkfTfsxLP/4DMImOGquBvABMwx5t7z8V5dwWDzmHsYj+xSTq+w1UNF95PezZgtlXPjIMEXCZJDVR+3Q+a0l0SduZUOsy3e+S3L8hCFg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96RtqKs5bwSw6cpUCc6OQIKKOHam/3ZmwFUYaxiph8c=;
 b=kfKWq7GGrm6SbnN1wmGi+/gFzrwCff4kQFvODJoFfOQunJfQREbFLZANT3EwAErtK2LEibp7MJ6ZMF0A1fkll5rfM/5Rm5B8zRvhL/XPrht3VX3ImuVif+FmdZeG1aqzJaawHUA2452NI5SaKp8TFlkubtOJsiPw1zFbpwbMKewmBVgLNuC3v04zD8Lnyy7fUoGm6O0MyHzg2A2LDFbjaTdy4c4DZR987VvoO2qqstiH4xnaQa6wko8cyHh3zxu8KGhXfHsLs0JvcOHVaWL413S5nqLX6jQQOmX0vgUkq2+qE7QBW6zS9jqlgp5Pwg40igzRQQQLFYNe1qBgWFjuqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96RtqKs5bwSw6cpUCc6OQIKKOHam/3ZmwFUYaxiph8c=;
 b=mBK8dc40VRoGqsNwUmUngTeItusUqqgVF2838kxUVwbMt3O9BtHLxzJPlzZD8wwWpt1dhF4XT5EUofHC1wApKJZ2DctNgXDzka69lklH/qAGiQXdjNHAkvcgKy90KFGMTgcBIHvCaHzIk8b4px5Iy2tUeuVSh8YIbEbvK4iTtkA=
Received: from DU2PR04CA0226.eurprd04.prod.outlook.com (2603:10a6:10:2b1::21)
 by AM9PR08MB6114.eurprd08.prod.outlook.com (2603:10a6:20b:287::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:23:45 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::57) by DU2PR04CA0226.outlook.office365.com
 (2603:10a6:10:2b1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JGd/KJzaZjnL2LK31Yaf9qlbrWSnlscweqVooggCvtbuV/XuXyF3DIHfUftrKSMnKWv3aOeZbgTbsoVzWOZd35LVDYNlk/vJHl+QYt57CxcuN5EyzI0REZ31qaMYtrqJpI6V4X42UIquoicR///K2wUvTdDQ2JKw+OL6aI4QwZtWKc8LHLHYp7qAj2Pt/KrVorkJCFJlatR2wsmirbqyBartZmtN0kk6OWPLSVz7/D12Vg0S8d6M5FDM1RsRQEE0/SfIERN/cWXOC6AfG8MqjcEeJt/Dc6q9lN7/7eomOepziPbuAhMtIchgBl9nqMyltXG8wvJPhv/LBsQSgvgAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96RtqKs5bwSw6cpUCc6OQIKKOHam/3ZmwFUYaxiph8c=;
 b=zQeDhEdLwZev9ZcjYLRxUL23aeXCY0oxA1w/OdTSg7RWo2eItGOiSPkZculdS/VStWOZvZkcW+JUY5L4U8gdJxGlO5277AlTb8K7y/VjotQ4cPvAyX10OIiqhW8T5f7Iz953RiiUWFHrqFNxR0yze4OFPQf/UiOZ9Dv4FzdyXbWDNcmnRhnNpL+3C++LFIhpW6m8ZI9F0rQOzGEN5GU71CpK4WaADpBPdBUmAPTFCoV2WVxpmZOQgNRKBWSJCU7iH++3XiGRcYyYEfeBv1qGFguNor6M5fByecDS7ZrsUwIiQrGQethlDGD6V5WHZEYhkxJtIbvt3TGVbEBwhRuccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96RtqKs5bwSw6cpUCc6OQIKKOHam/3ZmwFUYaxiph8c=;
 b=mBK8dc40VRoGqsNwUmUngTeItusUqqgVF2838kxUVwbMt3O9BtHLxzJPlzZD8wwWpt1dhF4XT5EUofHC1wApKJZ2DctNgXDzka69lklH/qAGiQXdjNHAkvcgKy90KFGMTgcBIHvCaHzIk8b4px5Iy2tUeuVSh8YIbEbvK4iTtkA=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:42 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:42 +0000
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
Subject: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHca3soLX+ZjvZJeECiRPwCqFVv3Q==
Date: Fri, 12 Dec 2025 15:22:41 +0000
Message-ID: <20251212152215.675767-19-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF000509FE:EE_|AM9PR08MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: bb50a3f9-8954-4971-c99e-08de399270a7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ygopNYmr4Y6YakuVQxabg4ewp0W6YciUBqSS4syYbUzRMDB37jA4GDT+JD?=
 =?iso-8859-1?Q?jTF6GCJu8K81HfPihAkxKPmtgmVjcz89e3XAt/mCUvg2hokX0GA1lKdwYX?=
 =?iso-8859-1?Q?O4jVqEU3W71r/kdsX2RSwwfda8tlFMxGpSzQOeT7Ybb7sJ3ctGuZlxLJbz?=
 =?iso-8859-1?Q?blypzmh4ACaigDs/oXcdxJKZUfIS3dlBRZMPAlP9OhHM5f8LvRbodAguJi?=
 =?iso-8859-1?Q?o/vJevQq5Yqf9/aWKBTwsk6cxexFtaylstfKSMdMiwWdjvDVrGKHarU377?=
 =?iso-8859-1?Q?3r1wNYJ/R73t1Max/RlAj2lgVwqroFOcsD1TTsqyWgd9t8aSQLF1+3mA3W?=
 =?iso-8859-1?Q?/WkRrBCel+JECH7joLTvepZPBlh8Kjv4H3Q2pBAyvPfRP1t7ig1bOamije?=
 =?iso-8859-1?Q?5fH0cXuwDBOWBFpZs5SWTNQ3xRIMe919ZRFzp0XwSWOqxilgR+WyQ4uIXJ?=
 =?iso-8859-1?Q?Ln+dLY9o8mb/QuzydBTDkuEchd0Jxo8q1y4/4y7nOdlaZAisjHgzqsaduq?=
 =?iso-8859-1?Q?vXSL/ijlr8nIAzH5dPzZ3oFRQZ1XcldruMPyeuc/9M9CiHiTKAHTIgwVhG?=
 =?iso-8859-1?Q?m7XpAg20vKyAMFSt4HV0arYHmsjbBXA86XCYaE8SyjrfGS0gt2nnWTa4GX?=
 =?iso-8859-1?Q?Oql9PN2GpDqhLzQQgrKTuGH33kR5PGeLy71w4cz92cqJv33tc6Y8tBq9Un?=
 =?iso-8859-1?Q?GoiQW4IPAxz8GUS/s7J2Kcxb+PnT5skdj/vDBI2ZqlYeYHh/qEvhw8hSvY?=
 =?iso-8859-1?Q?SJw39ZhOhX+/9rGs1BJpQK01Y2anh6toKz6iKXd/MSsPrPizyhJE6H5B/u?=
 =?iso-8859-1?Q?KHVf3sMINiDQSWnMHIjDzlUo0BFIL45P/m7sy36e8J16MDhqHPPUMyEKWd?=
 =?iso-8859-1?Q?LhKIG85eaHIzUmJCwu4Ia4vUSpzgZppGi+yQpKyNSL+MLtCMbnmLn0z+vU?=
 =?iso-8859-1?Q?VpxMrFdh0WVMj5T3iLIzsq/C8/AiTvjPL4XPOdS7XP3HUL6QkYMp44x2IG?=
 =?iso-8859-1?Q?ucShJXs5nCF77zDk0tx5IQtT4kJuG5Ng6aeYva6c7r/Ee0Ij7fcWKsMsA7?=
 =?iso-8859-1?Q?hInZXhe0pa5VQo5V8wcgihTNMN/r9HUl+amxbD8oes5H9o6O3Bjwd5im/B?=
 =?iso-8859-1?Q?CwAMqSnbO8FybD4R0ZjE5vMzp2/Qmc0AdQOoW6ndWMmRJcSdnyLugMahBy?=
 =?iso-8859-1?Q?DeATy3vEbmL1A7/2Up5ReMn30Le4G4fg6Zt+8/RE+dvlJZuybI5/4Z0wFg?=
 =?iso-8859-1?Q?hF9EPtbZ+5+M2FKhpalwYkKuTYuRrALnzVgygoTnmbOEeHJrgHjakPvucc?=
 =?iso-8859-1?Q?2YPXOVqZzrCeyYnbk+efZPDye7QU0JqFHAMlH3gawQmCum/19oB0Wvie/9?=
 =?iso-8859-1?Q?JyHsT7ZIyBxQDzZdg2AucLCvx0R0zd9tDJ8ab5wmUL9q9OxnjRMAPzAn0l?=
 =?iso-8859-1?Q?dh9eH9JyXHyZk3IUdNosyB8vbCQE/I63jSGKWMmbMYqjQpU6OmY7oZSWTk?=
 =?iso-8859-1?Q?x3HlKl0QwWpolo29plmq5xne43DyA8sCo1zD78VyjsEWGDsNferbEvGe/z?=
 =?iso-8859-1?Q?FPdVrAkNkmedQ/4MTfkpvD0IaVeV?=
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
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	10e11765-273f-45e3-bb68-08de39924b88
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|35042699022|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rdLoHhiICOXuAisfx/iMugqO4iVYIVjheJFVGxXIN98n6tH7DGBW9wjeka?=
 =?iso-8859-1?Q?xDLTLVSK81MzV/9kZXp6yUaop1fmjZa4zNAIWGplfH3heSDOjYNMGBDWie?=
 =?iso-8859-1?Q?3fulKsoySXfTApmxT/kI6GGlZItu7g8jChTwIMvlWCgYvuOYnhKhhZ2nbC?=
 =?iso-8859-1?Q?kc7ivxrCIQ7DR277D/EtP0JagbnEyOJJCCR3tGTt6N7mgtL7/YSqVcuB0r?=
 =?iso-8859-1?Q?8Ew3/abfn8TT8gEA3fXJTfZGto0F+P0jVooFTZys6C5UjWnQS+Or1dnIac?=
 =?iso-8859-1?Q?zT2TOttVQHZVr1beTr8rB4ttu8MhJdY04T/HDNq3/SleIPgzLX3hoGwUX3?=
 =?iso-8859-1?Q?vqYzYAN5A5+zrNU5S51XlW1YF4hmvaqq/yaQL/4GwQC8kdPjRo9kX4pUEf?=
 =?iso-8859-1?Q?M1oW8GAgp7b1DugbUYXnmydjvTIVNUI780uTUoEF5HgllxQhCBmdUHWY/p?=
 =?iso-8859-1?Q?/WaAz6v5r8YkoKiBaO7zCNCOFV7AbANxopz2CU1h8eBtb1O7rRdOBbyshq?=
 =?iso-8859-1?Q?nohDaO0l+YU0LoieSRTFrVZJGRfeZtMoL0+QqR+TkUge58imyuDBcz9R8E?=
 =?iso-8859-1?Q?hpYgEi8V95PeqFm/7RLrqU3KMdZe44udo/lsaqpK3pyvC15hUOIe36P322?=
 =?iso-8859-1?Q?Hr3pxY8+RwxOHWLrORLUpe0/hlDDCqzGscOfG+x7japA1o5kTM53XM3QCh?=
 =?iso-8859-1?Q?XoPWwc8xaYEltBvPhy9GHvYNlLGbJU+7g5kFThavsR4QpU0w/rmh95IWzk?=
 =?iso-8859-1?Q?LAOcbBSqAwIqid/oJS5iEY0PMO/iX7JzU0/tubIWAHVnFhVikY5kR69UoR?=
 =?iso-8859-1?Q?dxtpQRTh0ZME7em9wMvhPomrkh/EXUXH5vDbT2V6AXD8Q2DLeSjDuHLzzH?=
 =?iso-8859-1?Q?mGGjj/TQ/sTpx3bZ1FvBSQRSvuDNWaYW6DJDLjmZj+EfMMxst21DltK1hx?=
 =?iso-8859-1?Q?eEJ7FPWmc/Cip1lKLpirLaZdq9XlUiwkEqhfH4MKxdk9mA+Mj7AE1aFXoD?=
 =?iso-8859-1?Q?EymspuTCJlCGhiW/QYOQOCKm7YW/gIlNAq7PYBj3T53daNjr51faT3DD+G?=
 =?iso-8859-1?Q?Xep9HuO++LYic3X/1Rhegx2EKE74TZo/RSsm6T0MTfmTkEqzGkv3PxPC38?=
 =?iso-8859-1?Q?ruxbN3UFZNd7EVtp+eKD5d7CFNJnt21UbgbRAO6QXiDWMEoKRTCC5asHMg?=
 =?iso-8859-1?Q?F5g5XCvAfksR7IN8o38RXqpOC5hs8waMNyzbjz5Key9LsEGQ2OYo+Nd+ps?=
 =?iso-8859-1?Q?MDQze6PRjADi+nR1mszet1085+83D8gyOV2NlggAOkxz/y6a/tvSJpqzJf?=
 =?iso-8859-1?Q?tfFC7EtoqhKMIQgzhxUNHu6WlnLURG8+wQMSV+6GExfECIjVxzvrq4EiVE?=
 =?iso-8859-1?Q?wX9CZLn+D7jr/MF8pVUzhWPRLyxA53fiCdeZ6pv5d3ZlgGe3+b220DJGWv?=
 =?iso-8859-1?Q?Gz8oa5RpdyYFSAY6Bns1ZSZeQIqJGtTMQ32r4INWZ1EkWbT1eX1Xb+rrqX?=
 =?iso-8859-1?Q?F0aADRklrXgZCsbR4BsdX9jcgZQT/h6xTZx67uSyyT4ZE5RejAe5agIThB?=
 =?iso-8859-1?Q?1zXS6YHJ5Md5mwOQ3xcoBGzExU0D4aOu5/+eJY5ru1m2sBu0843p8ZMFCf?=
 =?iso-8859-1?Q?WKBohZWjnMNqE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(35042699022)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:45.0106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb50a3f9-8954-4971-c99e-08de399270a7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6114

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's prioirity is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state - this is skipped in general operation as
it isn't required and is rather expensive. If any Enabled and Pending
PPIs are of sufficient priority to be signalled, then there are
pending PPIs. Else, there are not.  This ensures that a VPE is not
woken when it cannot actually process the pending interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 123 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  10 ++-
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d54595fbf4586..35740e88b3591 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -54,6 +54,31 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned highest_ap, priority_mask;
+
+	/*
+	 * Counting the number of trailing zeros gives the current
+	 * active priority. Explicitly use the 32-bit version here as
+	 * we have 32 priorities. 0x20 then means that there are no
+	 * active priorities.
+	 */
+	highest_ap =3D __builtin_ctz(cpu_if->vgic_apr);
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+	priority_mask =3D min(highest_ap, priority_mask + 1);
+
+	return priority_mask;
+}
+
 static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
 					  struct vgic_irq *irq)
 {
@@ -121,6 +146,104 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
 	irq->ops =3D &vgic_v5_ppi_irq_ops;
 }
=20
+
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long flags;
+	int i, reg;
+
+	/* We have 16 PPI Priority regs */
+	for (reg =3D 0; reg < 16; reg++) {
+		const unsigned long priorityr =3D cpu_if->vgic_ppi_priorityr[reg];
+
+		for (i =3D 0; i < 8; ++i) {
+			struct vgic_irq *irq;
+			u32 intid;
+			u8 priority;
+
+			priority =3D (priorityr >> (i * 8)) & 0x1f;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 8 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+			irq->priority =3D priority;
+
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long flags;
+	int i, reg;
+	unsigned int priority_mask;
+
+	/* If no pending bits are set, exit early */
+	if (likely(!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1]))
+		return false;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/* If the combined priority mask is 0, nothing can be signalled! */
+	if (!priority_mask)
+		return false;
+
+	/* The shadow priority is only updated on demand, sync it across first */
+	vgic_v5_sync_ppi_priorities(vcpu);
+
+	for (reg =3D 0; reg < 2; reg++) {
+		unsigned long possible_bits;
+		const unsigned long enabler =3D cpu_if->vgic_ich_ppi_enabler_exit[reg];
+		const unsigned long pendr =3D cpu_if->vgic_ppi_pendr_exit[reg];
+		bool has_pending =3D false;
+
+		/* Check all interrupts that are enabled and pending */
+		possible_bits =3D enabler & pendr;
+
+		/*
+		 * Optimisation: pending and enabled with no active priorities
+		 */
+		if (possible_bits && priority_mask > 0x1f)
+			return true;
+
+		for_each_set_bit(i, &possible_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+			/*
+			 * We know that the interrupt is enabled and pending, so
+			 * only check the priority.
+			 */
+			if (irq->priority <=3D priority_mask)
+				has_pending =3D true;
+
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			if (has_pending)
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e534876656ca7..5d18a03cc11d5 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1174,11 +1174,15 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu=
)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (!vcpu->kvm->arch.vgic.enabled)
+	if (!vcpu->kvm->arch.vgic.enabled && !vgic_is_v5(vcpu->kvm))
 		return false;
=20
-	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
-		return true;
+	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		return vgic_v5_has_pending_ppi(vcpu);
+	} else {
+		if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
+			return true;
+	}
=20
 	vgic_get_vmcr(vcpu, &vmcr);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5a77318ddb87a..4b3a1e7ca3fb4 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -387,6 +387,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1

