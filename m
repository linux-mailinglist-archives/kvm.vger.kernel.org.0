Return-Path: <kvm+bounces-67623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C335D0B90E
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 20EA4306CBDA
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04E035CB82;
	Fri,  9 Jan 2026 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JJUpli5w";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JJUpli5w"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012059.outbound.protection.outlook.com [52.101.66.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65A336654F
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978394; cv=fail; b=BiiVX+sPvZ/xkfod3o6suokaN6gtmJ0YJAa6Cc900eKUmrmHoa90544zvSa3FR4gH1DE2h4aN9/CxII7OS8+s4cX2hpsP+0kvdKmMNzzOr4266/PVxT2QDSuFB9Fz32ZJoIOKX//ombRma+fDBD7sb/BEFSVs1r+qF16t8m1oLc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978394; c=relaxed/simple;
	bh=85tPGZIoInqi1WFhRqKs5Ie7noEa7CIM+0mDo7HD/e4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ds/pzpMY7+PxmQUsAHAv7v8V5eq/IVYohjM7MvoIDKx+JYn5cdCTP93FH22suInZFI1cq93cQmLt47bvelbKWKRS7jIXgQN0KOyaFc1geeW+k2cDyzLRkEmDY6xn6uqvDBpB8/26d7pRehwRtnk1QaW990DRj6S3HRmnQTnqqks=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JJUpli5w; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JJUpli5w; arc=fail smtp.client-ip=52.101.66.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VPgbEZV+tlGOfCi0JGANqBGF7htOYP2NxnsZDtOWsGDAz0bz9OXmEL6or3oy0LqkBFUuWsfECc5wfJ7GlocPsh9Ho7Rv43AlU9iH6xQ6Z/O6vzaTJflV6t5xVtg+tigJD/iLGE1v77UPpYEX8SZ0bYza/yszfNbA0kjh2reEne3RgXT9U7W5V918OMqckQgvmwZCmB94MMYuk5shfVt605NJMByiyGEp+0qbmCgkSMExm1nLiZ+sGq/jilLeE/2CfIp169HJpdZcjRXnASgs0lSOrNQeqgeik7vDXkTWk4vIURHexRZah/sapkJMOC8aDKfhzCFKqM3UXZwcwKGJ9w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+olz1oAhyAt35yKNHdaM326ge8MIavH3wafox6SsHY=;
 b=HPvyu40Q25MSOZJgm57qrK7JaH41oA4Rgt1wmwKuOD/tPDHVAlJjIo1uUlt6gfM3ey5qgf+v2ByolQzgwk4b+h4lCY/xyvP8JGtZ2CI+Q2XZ3Gj2hU2m+4AILNl+VWP3kt3x5xsv2Jt5KcpbBoAkvntYN9+7HdBvmsQWqijTJbkRbvlqdMiNTYvfMhGvkiUeqw1ONMwXB2+fqxXtf2e9B1yxz2tf09Pg07d5XU6s5dTpChp+sfZJ1KXq8LY+uubYBbUNVc3viw0JP+9ae8ghxagbHv751gB04vOKdJV7f5kGS5DRE9TqiJz7AlY12NFv2GGtT0Mh8cWQv5fvkRf2HQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+olz1oAhyAt35yKNHdaM326ge8MIavH3wafox6SsHY=;
 b=JJUpli5wSuSGrIphriJsQFAOaa+rA07qm3lnWNQIH2D2NuI9g7qzhh6ZcGql/4iNLBI6Rh1MKxYsJhjOa0KsW9etYg8K48uMdPOehjsYaqhIFgjLa/jU96da/fblNonKidmRuangAFho99nD+Ui3QHnUQA+QhA51QX4j6UnAdmY=
Received: from DU7PR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::20) by GVXPR08MB11318.eurprd08.prod.outlook.com
 (2603:10a6:150:2c2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:06:27 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::37) by DU7PR01CA0023.outlook.office365.com
 (2603:10a6:10:50f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:06:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:06:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4UYCQUy0yiDsn3U8wGImXvyRfXwKXfFbx47D7UkoBzfMHAZNO57Ti75BkC2ABR1IOqlmaOBzkP9Kk+5dzeWiKAURDctXrqDPmMx7kGVJVuFbfs8kOtF+r+hrrQL8Y/ZDoxqS0f4Jb4UuZwmiMLt4j245zk0qvPwCvDvWBy7Cy3MP2P9EmJ5iM70LSX5td6cUA5xQohR7S+egMYpo6L3IQ4F7e1y5N9A0PmZ4J7OkTxYxaDfB3pFDYwiK+cef/qsAV97CqV/QVKwdOAda+zSMKZ+dzrj2loydG/YJjvF1+zU7yDR/EodeE+KXtFQma/JmjHUwu2nj5oRkLG/UeFDZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+olz1oAhyAt35yKNHdaM326ge8MIavH3wafox6SsHY=;
 b=KGlEgh6xFOxT70InRAwSZA1URso3UCxDFOxF3k5T70gEX64wjNxox2vjg9ODAHHuuQPX5V1TaSI6a1piv15eL2rNj4F3yoNp83COQ6jZBTs5sKs3e9gRUViOu+LpHCAazE6qiioL/BxLrai7aLwiULDqCDyNjeciuqyU33eXmdjZ5tf1pzQQ9i6Ympy7u2EjRRc3GYsdEHWrAembXqf3AdwlRaPcpW44wFehgDmUjxsjOVwLhUbZKeUlDh58mUDmOihyC8S8YApiRysditWnlMZh63RA1ard9ZNGR/FCS/S7pFk4DNLFgXva6FMQWz+89490c3/jdSGnPxiopVlCIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+olz1oAhyAt35yKNHdaM326ge8MIavH3wafox6SsHY=;
 b=JJUpli5wSuSGrIphriJsQFAOaa+rA07qm3lnWNQIH2D2NuI9g7qzhh6ZcGql/4iNLBI6Rh1MKxYsJhjOa0KsW9etYg8K48uMdPOehjsYaqhIFgjLa/jU96da/fblNonKidmRuangAFho99nD+Ui3QHnUQA+QhA51QX4j6UnAdmY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:23 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:23 +0000
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
Subject: [PATCH v3 35/36] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v3 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHcgYoQGjV2cACAHkeEhL3tfe60Ug==
Date: Fri, 9 Jan 2026 17:04:50 +0000
Message-ID: <20260109170400.1585048-36-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB1PEPF000509F6:EE_|GVXPR08MB11318:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d301f89-b034-4658-1ce6-08de4fa16cfc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?8nLB8PZSVKnJL8N42vOooPWTDgiS2sYhKxY4ZA+rp7usU+xIcPU2kimDfJ?=
 =?iso-8859-1?Q?4Vthbt1ynIJiIJkJ0ws2e43Y/Cx45HHdiA0hjA58icRJj5ymm/8uPT7dRn?=
 =?iso-8859-1?Q?xkCJWy50KocuHUwHpWmSOWYN/tqlho6S3egSjYKv7HPNCrwZcfe6ybj4RD?=
 =?iso-8859-1?Q?Uq8HVVo213Z5szTclFbE23VALJ1HsqOJYTQdIjzjNpeNw2k/14Dd8vvdys?=
 =?iso-8859-1?Q?O/Et1qNbXenR2elP3GnEn2Cqu+64naAwrab8XJ4NTMLPc4wbnaJeReho0V?=
 =?iso-8859-1?Q?E6NAroC9ovKGJhaltOHYYAtgl1AYEb/tVSmhAQSIFZcNMX1zxkLrdnOqo1?=
 =?iso-8859-1?Q?tq7acLIOMQEO0dCmH9c1PDGzsR7zR/NTHmC1uMoEaSsoOF6e5KWKe8Dyd4?=
 =?iso-8859-1?Q?kfwDKHYxWPNo4iaUBJeBwOq5YFaAbbdpqO+tQWwYkVNjRa82Wp5O1PHbN5?=
 =?iso-8859-1?Q?Mctz6OcCs0CfM7MPOxAFxtHmYomStyom7eNCu8byNQHvdHKPTwswmoqkh2?=
 =?iso-8859-1?Q?68LBK+LziukE38lTl6L2Kv9WwdAXcUMa7Z4LuF1HNHumljuts2LDAAVReh?=
 =?iso-8859-1?Q?yXKleQCz0QhykYfmmOsRWteI6LQ/rGsOrW6BYYC/vXsBFELSeTfP83+LiU?=
 =?iso-8859-1?Q?xPW/zJKcv0xBur3qV0QFZVRT3EzOfj1ct/qYTBMeeiTuGW1KZ+8EpNILYO?=
 =?iso-8859-1?Q?zJrtaLQ5p1XWkXMzShEJD6//jLJxl1cBstFprKU9WSpzOppYwYTixN5UQb?=
 =?iso-8859-1?Q?/ST8mcdnxwaBMjFQVF0yP3RuZtWxZmp0MJSScEQGY8QSuoGWA/EjhhcYQV?=
 =?iso-8859-1?Q?98QZMI6M4f6wv3sVpLLx5anhoARdk7cvtoXQPOh08EGPEozR+WJ3PcpC3m?=
 =?iso-8859-1?Q?I5n2GX0M21zitzddv2lMxAKIurde7ire+IQMDr9Q16lADJ7NzcdGNIJssW?=
 =?iso-8859-1?Q?VchEu926VE5jQR5UPx8Beyh0uwm+n51Lozvs0JJpBPmRaUv/Hav+cWzqBT?=
 =?iso-8859-1?Q?/B18g+dRnOFrhLhqU2VRJC7dEnDNjYkwhjRREKTCCaI/2PeCWH3769shFd?=
 =?iso-8859-1?Q?48CRwRgcgHDuZqNeOjXntJRtgn6G2oYMKLKOACQ26CcA+wfUt0JM06r46H?=
 =?iso-8859-1?Q?5X7ysmbhKD2nOA+R0nM6RqbR6Y9sRAB2MxRzRgQl7eOBuYpi3nqkgVkRH7?=
 =?iso-8859-1?Q?7GP8eN3ubPhjIi0znVb0Q6MebuH82Fj4YmULXmumg3NdR2Yl6VS4Hc+LCR?=
 =?iso-8859-1?Q?lpUGNbR4gwAam7A+1ygZmvUM/hW1Gv0AN3MMuFTeImW6YGvWTXTOmZlKz+?=
 =?iso-8859-1?Q?rY1g8j+obwVrCdOCjcOnnZjMDzJHsLC71QwUWWT5xURyYAsXLq4c27Ez7C?=
 =?iso-8859-1?Q?IN0INNQ5fgxrV81b/klNOzf82XEqslgz4SGQIdTmjdf1iakAlu/hKQTjwg?=
 =?iso-8859-1?Q?Kb5ZvBFGtKpMfHBfWh22hgMvabZ0vHgleMW3xp8ngasVDacYumCLETcGnT?=
 =?iso-8859-1?Q?cuHupM7uyBIjQnHVUb6hrj1+EI3+PQexc3FQBlRUa0vDCJYQ8yZIgp5zeR?=
 =?iso-8859-1?Q?tL96gAajMkhki9dafe7AWbp54UV2?=
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
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2d300fff-ba16-4e58-9330-08de4fa14725
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|14060799003|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RdI56yGslbNkzCHuKRzupXCtzp3P14LkJl0qu8BO0v6SxNJvQtPy6R/0pE?=
 =?iso-8859-1?Q?pyAgsEMfpobhfAMUqq8vmGhY2un1EEtqbeowZ20jTuKjZjycMZee6lQrqz?=
 =?iso-8859-1?Q?g6zpczEM9KY2/JuB+Hzz9nNloPe4gsK0RMJqz8W0rwTGXAPJKnTzJ8PlzJ?=
 =?iso-8859-1?Q?aCK1QTgckGyGnKsUfLYxefwy1PH5BATOnu3zZhNWf89SBd3Kf99VJqdbFV?=
 =?iso-8859-1?Q?zpHfbiPDBhZU5INVodkwb2cayePZbVPWyGmxwPZHhk1dCsXk1cJiwX8LWz?=
 =?iso-8859-1?Q?ek8i8iDrVDiir3mX8CvBuikdkVZ2UmKW8uEMbmXt2LTitJF09pbs6RID1/?=
 =?iso-8859-1?Q?270dNn+Ntej5XCxMEtZ5kgw922pGQekF6CNX7lu0zgqhjefqVjk8H4vc7b?=
 =?iso-8859-1?Q?C7huOZ8sVA4Q9IMR6d3Bd8GX4h4LRuc4KExPP1JeKpX8frwply8dJoRgyJ?=
 =?iso-8859-1?Q?X5KPBEKQgIYUrIQKCr919GOIPf1xJG1EDskw7JX1GOwtzmzNITidP2vVrA?=
 =?iso-8859-1?Q?MvI18zkDMjlYgLel1vlg6aXSv2i5optGa+6hHls1eJMdv+mfwakL1Vls7j?=
 =?iso-8859-1?Q?Y+LFur8s1ppm/IkcNhMqQ3BmURaIlkTp+pf2B6F960Qm8ctg0XTl6xgpXz?=
 =?iso-8859-1?Q?GR2xZ94Uc+KDDxS5CxY1/aAPhGQAFBqofRBYlCqLHDYDkHq0NKrkGM47/H?=
 =?iso-8859-1?Q?V5mXLKse5IZZIcJozT9YRJK6XM3mNa40rinzhsWUyWQSSedbkUVCuONLTM?=
 =?iso-8859-1?Q?0ew/1lruMS8Neb1Red9vCT3FwbKAWi9lDg+nddjYCRr/VJperXQg6bZaaL?=
 =?iso-8859-1?Q?/gSIrL1t6LTPkoj1r2qnAM4wNA/fwd249vL0bH9S6hDBXj8+Qb85mH3hvd?=
 =?iso-8859-1?Q?8QpcqF6IqQQXImlcfbtioAUQ9J3Sfv0utrDbFUV2sFrmCqEpXEApj1qlGJ?=
 =?iso-8859-1?Q?a5BzM5KYeGhCIUSeUVpjAHL5vNJKJV+GT5tklfLKKW6TZCqbYBOYiEQ9PI?=
 =?iso-8859-1?Q?XYj6OGAseb0axd5VkCg4/D9vjaBIMZQmC5uZ6QisczLTen14UlaoXqli4b?=
 =?iso-8859-1?Q?PBLDOeDotpwBigZumEqNTqAEACscejG0nA4Urs+dnr+KoIpHO2TrqdyozN?=
 =?iso-8859-1?Q?UvTIrCZO2amOVLCQEOXSydRkNQJaHAwYX72khj69pkmKIG7iLtlIsvCIZD?=
 =?iso-8859-1?Q?xMh3+dCb3bQDJ+D+S8LtsZ4hjEfeP3asFQchYEhnv7S/sbS0RrB9E2wJqQ?=
 =?iso-8859-1?Q?PBH2hmFB93aAn65pzQn76EPym/GC1wETw7RTPntSi8IeJnCvGSDNjn5VGe?=
 =?iso-8859-1?Q?+rJqZu+oYMwcWntyEGJWlKve/tBnBL+KLFynfRq0R5+H26sTH0kp7UPJv8?=
 =?iso-8859-1?Q?MVLccETqoygRc6V80JFD9tPZ9ttePkUDWY5NrikVAXcP1TMLZnv1HYtJc8?=
 =?iso-8859-1?Q?cn1bouPEfHUELpML0hDQDDTfbsALTWsw36ZkT00TDD/2OGt0gT9O8PPfzc?=
 =?iso-8859-1?Q?/7Wi0eux3wnSdBOhNZeARu7rYzwnCj3HrIA65Mye8/vv5r4xmsX51H1D2o?=
 =?iso-8859-1?Q?Fmxnu3uXttJLfJns7ws6K8z4zO75pRAX5Klqj/GlcK7Pfa0P2uRcbfWPd0?=
 =?iso-8859-1?Q?o8omVsRE6Z8Xk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(14060799003)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:26.8845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d301f89-b034-4658-1ce6-08de4fa16cfc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11318

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to receive interrupts. The architected SW_PPI (64) is enabled and
KVM_IRQ_LINE ioctl is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 220 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 ++++++++++++
 3 files changed, 369 insertions(+)
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
index 0000000000000..34e7cd6340334
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,220 @@
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
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
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
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
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
+	for (i =3D 0; i < NR_VCPUS; i++)
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
+			 * The guest is ready for the next level change. Set
+			 * high if ready, and lower if it has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq =3D FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
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
+ * Returns 0 if it's possible to create GIC device of a given type (V5).
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
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	pr_info("Running VGIC_V5 tests.\n");
+	run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..89339d844f493
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
+#define GICV5_GICR_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GICR_CDIA_VALID_MASK, r)
+#define GICV5_GICR_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GICR_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
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

