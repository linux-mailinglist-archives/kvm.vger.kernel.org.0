Return-Path: <kvm+bounces-66372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6EDCD0BCE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B04473054F7C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72DF361DDA;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fELUAAh1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fELUAAh1"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010039.outbound.protection.outlook.com [52.101.84.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A5E363C5F
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159644; cv=fail; b=gohHokDs5abgHRLtT8htFFMZ80lsnY2tW1qk1elaOBjOzwI0JUgnvccAibMWlALm3/QnOeJneUyHijAVhCE7HurWoOeu0YTatSQjoCjsLVrX29T38Ki15IYau8ZSIb5He4l2nEu8kvAKrcBUxH8nxvkILwsJ0oWcX7AjL8wMX88=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159644; c=relaxed/simple;
	bh=aw8wI8GK8wODlx4yJ3VfKYcr8G1Fo/mlj8nMqdysTmQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pPeZGUNqfi2p77KDJN4K+2qqJGpzZb9LldznhmRzTLO4P2UB2CKl8UnAHvWGyUIZ+Y9HRCBgtNOGKC7ZrC1WGm8TOOdvnyGAaNSZU3cPmZogCKRJN1Kv1FLoQ6ygbefckQgkU8rNs32ImPgm37cV+nXENpwZxrRzqGAInQrCdDY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fELUAAh1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fELUAAh1; arc=fail smtp.client-ip=52.101.84.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fONyFlx3Eiwf7E0AAvvSPisy51NZ/6k54xcyNTfNbULwjapAlSoSsypTpyx/SvC4ySDi97UioDrCLL9/+C3C5a2P3iUbxRLUTyH3WPG6TkFLxKaszftcwAGZJlQnKZ/Yv1FvbX5iIU7UEkdogiFu6Ak4qKrd344Uhuu0Ce5dV+Nvg7jvFzrUmx3ptbrrLEkO6J00Ugm8yCrf8uOBpARI0YftSHu5Em7DTHN3BJdIqIcwed3laCyhmJgNGsjDiITTO2zZs5bOWKRY6silI9/1jCT+8yZGlDuLXj8x2+VUHhTGkpCg++vTKbjwoMji41jkA2ZI7muu8d6r72W1BJnWpQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLt/WIJSxpAAFOAInRZToxr5GjdFhMSI7CJoxQ+UeuU=;
 b=PXzAycLYzInhU9gJO7rwpOcbdT+sI4Ato43K9CcEfMbhv9eJwWNXfT3vCg0izidA+iezTGWImPtQ0nFtsHMLLwZwEn9rg9w61QsJgWtQzCqAFKleyrj2Go4ldsJcZ6r/F5VUJ2rYnmGlBWxdNotnF17u8Qkm9hzVb6VgZiuEwK216ie3stA4pLdwY39+CwRZQEYxyBFJiaRJtcgQy1is3MT56Y8dqli+2WHIGMVG4jdHsC318rY6kOPxLChDarvNr+vqvRZ5UeEHwCXBM+02eynr2LG2/SW8G30zYEiKisis1sNrozshLsjtXJYUgtc+vXHo28ZOsfjl6D9i2ewu3w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLt/WIJSxpAAFOAInRZToxr5GjdFhMSI7CJoxQ+UeuU=;
 b=fELUAAh1XDLgvoDCV05PynCsCg4OG8ou8sG++wFEIpHal2EREUg60ExwWRvDNWAEVz0Efw9SZfW17tNokdk7Y+nU9EQ3qlKTxF78XuRAj9IYveKCFoaEz8ePs3h4e6JKOYyUiF3MCP92JQQvGUPsbFs6V8Z4MOknFtNt4r4QN1o=
Received: from DB9PR01CA0030.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::35) by AM8PR08MB6532.eurprd08.prod.outlook.com
 (2603:10a6:20b:316::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:49 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::b6) by DB9PR01CA0030.outlook.office365.com
 (2603:10a6:10:1d8::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 15:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PtHfhRAy9foETI7b/EJn0ztD2XAGoHNlMXXFd0+mucz9sLyHSkD0J8S6xwRa161+QBL6kR29BgCP5tpkW47z1/9L/ktVjT1TPmhawE2FNg+E1+QWekisOlYb9hNzSikluwySVIw7as5gG0mg2qYYk/rkuIO+vrV47JasbAYcHctHqU6adibno6B1BbCl6elb/0Ig1ZGVYmEp5h6bYvg+cE3Bt7zG4K8gfh6lVdZlTZAEmeTWXKKSgcGRznumRmWgMVGo4YnObtR47Zd3OMgmoJuAC+dEyyI9c/6ymrL7OP70ITmAf8xQb4jPbIDe82iAgWFRSJj27rGBpo3NxMeCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLt/WIJSxpAAFOAInRZToxr5GjdFhMSI7CJoxQ+UeuU=;
 b=il98HRhM5x8VhG8+1QYLLdOJOpp37njv4ZXGC6Hq4QtQYNYpiRLAvLUBLJNNp4AsuFSvRnN8UpbywyKRONScS4zhwyC0NU6WJNtXYNwEKDg+cTgS2JGB49zjyP7TnRFGLYSlOUhQBxgtprCiDB0kh3v5WRJ91pIX2dCJIi0k11Sk/8kZcw+/TPOssnDElM/zbfZHJHkEDfGqE2sng4RzlE3J1E1b6B9ijNNhs5vWbw9j+NqcR8Kect2LPUiHQ6Q4x5N0q5oWHaSOgIR+VXSrX2LgboJX8OF3nI1Gms/iqA9vbx08p+S59bKfdrmJxc6YCG1yob+PBkkdtNXrWzncyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLt/WIJSxpAAFOAInRZToxr5GjdFhMSI7CJoxQ+UeuU=;
 b=fELUAAh1XDLgvoDCV05PynCsCg4OG8ou8sG++wFEIpHal2EREUg60ExwWRvDNWAEVz0Efw9SZfW17tNokdk7Y+nU9EQ3qlKTxF78XuRAj9IYveKCFoaEz8ePs3h4e6JKOYyUiF3MCP92JQQvGUPsbFs6V8Z4MOknFtNt4r4QN1o=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:46 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:46 +0000
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
Subject: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHccP+EO8ljQOSF00aJPJpJBfjFSw==
Date: Fri, 19 Dec 2025 15:52:45 +0000
Message-ID: <20251219155222.1383109-28-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PR3PR08MB5676:EE_|DU2PEPF00028CFF:EE_|AM8PR08MB6532:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f2b62b-7519-4f50-2d3e-08de3f16cca6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?0io1YnY8sQPL6cnvaOZ/unrvFW/ACFwcGwJ6PM4LwKH/9zdEH7pJyHo+Bg?=
 =?iso-8859-1?Q?q5LkPF4+Z1XvA4jd3YW/CIeGBl0d9GiC22QZMgkIqVufdOZ3NTCkC8cEx+?=
 =?iso-8859-1?Q?+XUuQ1QUjog5yLC/ZkqSjsNmkcXp2LN9EHszKgNhhy3nA7Gi/JZoHXY/tx?=
 =?iso-8859-1?Q?GTdiFtb+e9BX7cB9DHCyPhBIt8s4gufLeLr4CUv77u60K12jBmijjiwQ7N?=
 =?iso-8859-1?Q?tkvMxcCoCp+gjrjeipcxnI4iyTo4h3rEiH3KjO0tJyJmirVED/6ZtulBZm?=
 =?iso-8859-1?Q?/RpAUc4gfy2aP4dlqV/Riz8HBtx/EHdxseAnwTPx5PSjsuSr5dZnQ46Vzp?=
 =?iso-8859-1?Q?d0bzubhk3UODN37wCqRblYjp/8HDq9XvAOd/k/e5Hlh+mS1XQYaHPFB4fm?=
 =?iso-8859-1?Q?YbTOWzVBCMDKmzWRF06U5C7379qosGk194V9RIwRzESOIA3CYamHvnJGcM?=
 =?iso-8859-1?Q?1FcGfotNQ68QDAtOcMADt2q6dEer6N17fWzL7QMTtx6G6/ZcBSWGO3dXAH?=
 =?iso-8859-1?Q?hVGIUM414Zrt0OXc89xlK0bn71nu4FdJjppwVOBQLCRJCbvitsVw1guh9/?=
 =?iso-8859-1?Q?RyokX8JzA6QaLsqLDKB0Pl6injNw5bR7kmZYpPyCUhWRO44FcF0iFfGi6V?=
 =?iso-8859-1?Q?7mq0H3sjP+2RSHhD4KIvCGEj3D9ulL0CUr33rgaWBNkmq6i7U1208PDpii?=
 =?iso-8859-1?Q?5bWzXnTovPiuV034ymbETXtC6MSlKmagBnfat7ZL8gd9xRs+o+a2/91p+o?=
 =?iso-8859-1?Q?CwHdANSqBl54bJLxKyYx6YaqqwIGf7WbtlHYmowQG623T5QIvtwmYXqL2C?=
 =?iso-8859-1?Q?web3wGPpv6ymVAAwMDoX9MbPXBHFeJOFnkMgFV+ITVUuXLuR0PI5QHXLPw?=
 =?iso-8859-1?Q?z+mCgRSgEog3qw2s8fEgvDBKdusxh0SQMglNqY7TF1Zh57nA+qoJo3zPpy?=
 =?iso-8859-1?Q?I+G5nuAbkep1C5DbriIs+2cE1k31FusIpJz6AEde2kd0IHcMOBD/+5uWF8?=
 =?iso-8859-1?Q?K48GoBhYytLQaFuYx87FzO6iwz0oJxT0mA+BoHcssIPAk/nkzcFoDt3NYf?=
 =?iso-8859-1?Q?Z2bLJ2rC+vAl3Xxpz0aPiRnDVEyaz+m7p5zrZ1ckF9qCasrINjL2lVFdJT?=
 =?iso-8859-1?Q?8n2rIS059BAUzWr6Z59IqAQYlyoW4nmZ8VTY1jcTbpZlB2E/mcuKqUBi/5?=
 =?iso-8859-1?Q?Kofi8dRYraONSQDylf0NJoT3WmmSWcOh6UONG43zcdJiuiaRIjSEtq9ZFt?=
 =?iso-8859-1?Q?QqSER1xnuS9ASJ54ZlQIBqkXrZKIDehFyjSp0Brt5ch5LTzPXKh/JeMGaD?=
 =?iso-8859-1?Q?K8/Ykunu5o1OvDdhgJ3L9tMGLNYRu1YdbTdrfmi7RLmeB/gNIMHMKXVE7e?=
 =?iso-8859-1?Q?daSMNjQ+CSmhWiMMApFcwIYgj6JOS8DEsK9imPawr6DSXMQkcMirLYDdOg?=
 =?iso-8859-1?Q?LXfXe6UGO7Ggc0ESmoHbxZnGbanR/446nVL5y0Zz32Qc2wXj//1uD4RFJo?=
 =?iso-8859-1?Q?xJGkGahSeXxtmT5PfAJH6U7eHk8SQ9qIYJ+eSMCVV6d27+qwIr1ZCPtPSa?=
 =?iso-8859-1?Q?5kd578ytah6FDk8L1XEIeiIHPKEv?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	470e2922-84b7-4cb7-3558-08de3f16a79a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|14060799003|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rXq7XWNNWZ4CQfpCWZa3OUEhTrm6KZxxCM4nM2Waal/BVlYMROLrD+9Nmc?=
 =?iso-8859-1?Q?uYVTjNPUYtCq1updRbXkgt1zqFR2T4pqFIXihlx/gLih4q8v4oPohy9VbQ?=
 =?iso-8859-1?Q?dkVjj8peDLMv4a1PK/8kqcALu65i4QQC7wVCUr9XtBaf2/bqX+uiMA9ctx?=
 =?iso-8859-1?Q?rEY96e6AEE4b+3+49PU4VqoFPuqYmGHGIS2vhLWR+GFZgnX9QIBpnJYd2n?=
 =?iso-8859-1?Q?tSn7pmZ5o/ujdCQ4KAqSUl4AI8cUoAb91DJLW7jLNpLuPFEqtXBWGwQm7m?=
 =?iso-8859-1?Q?D37HD0TVwaPhkZjtjqTJEJPvKtSzzmAMz9eywUEEJalSw4cE2s9pqPLqBb?=
 =?iso-8859-1?Q?nVZtbzJjVQCIZrVN5epBbqmaoXx7e2hSCf9P0DsB7+IK4fJFA0nC9GBKwJ?=
 =?iso-8859-1?Q?k4A7U/3E0LPevKop2Adi4IHirpgZfjsnbLsz+YIiqjrWv7C0toyYVDpYMf?=
 =?iso-8859-1?Q?ifQRcNyCgtXwLSFtlqtljUsB7wajvll+aLSuK69Md4tndxHvV+osU9DHnD?=
 =?iso-8859-1?Q?ciar+UB2Tjh2iPGH/WlP7PdnX4wzzVU5eUCXqvS+BZNZUaHjUDMCeks8qi?=
 =?iso-8859-1?Q?IIuSil4qO+7UqT6ImbDVLgh79I5jOHrAMKqkW3w/0Q5Zh1eDMKsqug65L6?=
 =?iso-8859-1?Q?b1+7rg0RCmnD0fimP1jEJiP75PzGFW2MJV/DkgLdClwJGrdNu81+vnr6F/?=
 =?iso-8859-1?Q?8qcn9C++PuXs3AQIn7eU9ZMI75fd8b6iem5M3+BhgmAEisQwubL3XXSOln?=
 =?iso-8859-1?Q?6ar2wH/66YRmecHJZt43Z5er6IkCkvup0BGSCfo/6R0PxljaHZZnQ4dIfC?=
 =?iso-8859-1?Q?Z9u90bLQsjoGJbfxuj4r15QHF7zrsDKofjBW7Isg0SDcAaU/YxYszQAe3l?=
 =?iso-8859-1?Q?QDcy+bJo2cpWUSzaF1yGfqn+P3DkZprlTqoCygjSx/4AEP/rQW6gpm0XpL?=
 =?iso-8859-1?Q?CrBTU0wQjm2eZ7vC7MST11+22x9Alrgzs0BI8kERFjtPiseO7lshG4kdmZ?=
 =?iso-8859-1?Q?V7CVj5/NFCUis4CJ17/aS7Ptz4LZ+XCVn1gKoaeb+cd3BkjHsvlJUS5ubL?=
 =?iso-8859-1?Q?duzpo0bFU7cZqkcreaLlHS+aaPHNokZNzAgcgWXvrSbG/fC8gLk7CNRCBx?=
 =?iso-8859-1?Q?7jT0tkrEJbdIzOiycCwtGFIIIgxDFZkQp4lI/EUCP5gC/S8doXz0rCB1Ca?=
 =?iso-8859-1?Q?UCSp8/iOsEAy3AwsNUexhieqOvsXm3xnTPY71LjCe5HMOPvv5PgXslK01z?=
 =?iso-8859-1?Q?nwlUc6ZHMPZKycrH450VS1TSDGZMHDhHRZWBlv7+cRrnhhqx2+bo3QSMCn?=
 =?iso-8859-1?Q?NbQUfnjBBGI6Z4/lSBOerS4obfN62QD1ywH93rOZR8qroLdHWDZFtqZG6g?=
 =?iso-8859-1?Q?Iq2ohrmGeAfr/7tg8r4Uf6jqKL9nlnZDV0Y+X5tEHQgsawLSahg9Cdz1lm?=
 =?iso-8859-1?Q?egjbLjZSIDoJZ0ZRAE7SHM0ieNDUeetXCqBMGVvmd/D/XNmDz6WjEXMQNo?=
 =?iso-8859-1?Q?UYHWNRt3+Lv+8FW43ZXw69dv1RseoUIYUJJpQxxkdjwfZ4ViNKwW56FRU/?=
 =?iso-8859-1?Q?Jx2VGNhDQJ9Ok+kQVgJ21HrV0oJo88Zty7J9zTLyTrFcfwi/S7xPVtIl33?=
 =?iso-8859-1?Q?om27xQr9PhMbg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(14060799003)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:48.7470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f2b62b-7519-4f50-2d3e-08de3f16cca6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6532

Make it mandatory to use the architected PPI when running a GICv5
guest. Attempts to set anything other than the architected PPI (23)
are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++++++++--
 include/kvm/arm_pmu.h     |  5 ++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index afc838ea2503e..2d3b50dec6c5d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
=20
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			/* Use the architected irq number for GICv5. */
+			if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+				vcpu->arch.pmu.irq_num =3D KVM_ARMV8_PMU_GICV5_IRQ;
+			else
+				return -ENXIO;
+		}
=20
 		ret =3D kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
 					 &vcpu->arch.pmu);
@@ -988,6 +993,11 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
=20
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5 &&
+	    irq !=3D KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..0a36a3d5c8944 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,9 @@
=20
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
=20
+/* PPI #23 - architecturally specified for GICv5 */
+#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -38,7 +41,7 @@ struct arm_pmu_entry {
 };
=20
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_NR=
_SGIS)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 =
val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx,=
 u64 val);
--=20
2.34.1

