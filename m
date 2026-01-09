Return-Path: <kvm+bounces-67596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7551ED0B815
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C57A93025498
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6BD36656E;
	Fri,  9 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UsPh2BmP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UsPh2BmP"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013007.outbound.protection.outlook.com [40.107.162.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25CF364038
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978353; cv=fail; b=LBvg0iyN1WI1mu9a5HXNnAFtymSIf/SQCAyeGM5SfBUVNOYHODnBTwAKWdF+FtwLAh+fKs32cnbTrnDza+zjD0UL0m0MyeV3dNrdwQc5AWzQsNu1/hQuhyKCbi8Z0ZnkuCBeYy7qp+U7eSYJh6JxM+r6GiIE9fG2F8pblc4+kBk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978353; c=relaxed/simple;
	bh=460Za8gtuS10S2Cmrp2YbVNSUyOIUqweXAgsOtrEnZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ar5FiIVhkFNSo1A2NtejR6Ux+4pszDGzRer1BfnwQ/hx60R7tJs2ETwAVVSEX4qFbL8n2YkgUQnrpB6hdxhqBXtJJLNa+JXKXBkcwAtSGKsqkl/JO4+OxT81YUq8z2+UGp4AKGZ6+E4XZigYQWrt9Es7X3coRWeBgFHQAXhy9UM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UsPh2BmP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UsPh2BmP; arc=fail smtp.client-ip=40.107.162.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vzZp9dAekCvk3dOXxj2YBl8Qp1yLaPuhsuXqz1ilBTU0kN61UuP4BprWHjQ5ZccopJD46k2r4bF7w6P5ipv9dytffo97Rw/4FreM0lThgSShl6s0fWO58xflcZ07FtmdSGUE08E81R1gIbzAzM1Tm5udrRkXSN5pPspOHs5nWcXTBJKXvsT4irtFaIQTFtr7iqd+SWO7EPHY8qRyTho+W/6rnWMVCtiVv08gcYkNMmLpYbgftfQChA84pEEzkGjFDGE9xiwB6tzVNJUE6vK1ELEyR0JvB91HSjYmossx3u91ZJWzcsj8GG5QglywWhlBaAZfPKf7QeU++Tb1nrBzvg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JfrBcQpk3npuLyq+5fjnRtaruM3WQmk9jrRpqCXTBw=;
 b=limLFJH9qpyKb1Ht+jBGOkfOw/luqgVnA0QTnGk4CCjbjdnzAJKGApP85KQ4KuWPjiYw2+8fnh1+rnTYq7rI22ggNaEhpGdY+2zSEtCth3GI8U87UFRIgit16Ar/yqQMDkk4MdjtKKFdZkrl+5PuNevl9SM5O+IgF2zVlYx2nUZSsiI3U2X/HKorj8yqW7MCsMkolESHbeutr+zg5Dowp6c6PvaLE+9L9wgSD/MNsgyeGhY/cXmkylQhiObxvV9SZla/yXugT1LMeflr4b6XY9VCnz4UNRsyGFQmGj0LodHWJdArnGI93VIxTal8pkOwFfWRDP4HnhU/kFAGZ9dmmw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JfrBcQpk3npuLyq+5fjnRtaruM3WQmk9jrRpqCXTBw=;
 b=UsPh2BmPYHYHYQV+40bvYW1I8ENwpDvV1bI9UviQTTgf/AdaS7QS0G8Vy4jlN6Z4Gc2Fx8Hc9aFyYKWwoUMFqTeNGLgM4EZN4Tryy+RfO5ypeYwb9v+Z00rQp+XTYaxurtFpbbRKXTX5lbjxo+D85yT1zlSpZ3QHvfchFo6Z7Dk=
Received: from AS4P189CA0006.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::10)
 by DU0PR08MB9608.eurprd08.prod.outlook.com (2603:10a6:10:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:45 +0000
Received: from AMS0EPF000001B4.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::9d) by AS4P189CA0006.outlook.office365.com
 (2603:10a6:20b:5d7::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B4.mail.protection.outlook.com (10.167.16.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAJnRYl3KzrzL0EwZVDyNAzOQHmcirY65gkyDKlkYdOh/jIaZrMAkfzlGy9J3oJKixbXBr7Y0OSji7J83TdodidsZt/t5vs2E6VfUm18vXn9lbfO3Ng9UztkXdMJ2plbeWKKYr3tZfcAal+PC9EBAv6U3RAqHlQfVf3JCIRiLO3BwGIa971SB/eHvTp9nlcCMgyDmdX3BZagXaoZyrUMplv/0/hkHMjLbvtSnAqIZZ76zyS0jGFbuhk9VWnE4zN4VKkgtd7tsWQm4a2SGR8gWXtShK6/MkJry+sBF40VsEg12dR7ZxgQyRg6LFKYUuEMiQuN7orUA1n/un3/VbvHvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JfrBcQpk3npuLyq+5fjnRtaruM3WQmk9jrRpqCXTBw=;
 b=YD8/lKrOi0z8utZzZeAQC5g+qCEWJaoQ21u5Lq557kgOC4c/JBzv6MIMsNdhNi/eHc+XERYwpTPLzPp6kM75fWw/9cZV8XiCkeVxqIzgo2/LvJTGLLQDKLp0UfroPDynpHlWgxJYe9PdtXEdxFT9TtMzehB22pGmC9g36awN+StgoJzVt9ZbNg/bmHTqO6mb8KDhlCAwRrDZvq8XpHBlcGkEBpUJaTXsEbJhxhmXZWUGmdY0tL+0TXuT2gA/Gafaj9E924wcNpifo5RKHuNA5+XBc7DgncQyh78h2Yk3+WxjUygHFFSv38plWSKgYadb21RSUQ96Z1+92cFD4wf7zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JfrBcQpk3npuLyq+5fjnRtaruM3WQmk9jrRpqCXTBw=;
 b=UsPh2BmPYHYHYQV+40bvYW1I8ENwpDvV1bI9UviQTTgf/AdaS7QS0G8Vy4jlN6Z4Gc2Fx8Hc9aFyYKWwoUMFqTeNGLgM4EZN4Tryy+RfO5ypeYwb9v+Z00rQp+XTYaxurtFpbbRKXTX5lbjxo+D85yT1zlSpZ3QHvfchFo6Z7Dk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:41 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:41 +0000
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
Subject: [PATCH v3 06/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Topic: [PATCH v3 06/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Index: AQHcgYoLxvTWFGta9kWoLZkVr4xDYw==
Date: Fri, 9 Jan 2026 17:04:40 +0000
Message-ID: <20260109170400.1585048-7-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AMS0EPF000001B4:EE_|DU0PR08MB9608:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7465c8-971d-49e9-84a2-08de4fa15360
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?6ypdysRkYbpKxNEl0MiRtYIlIE7B9aDESPWnip/YgKfixEr6xzhzmcTLSX?=
 =?iso-8859-1?Q?SWvWDF+kL9HuZrUVxwBk1z/UNJudKeHJ71xcoq4EeN58GRTWz6SFtFt3V3?=
 =?iso-8859-1?Q?F7qInSPxYzOA4JtdMuiAVZPjS+76Eyj3hao46dao/m65i8+ixRMeLZtBuu?=
 =?iso-8859-1?Q?shi9B9jh4UqnTtcHK41HHY56N8mvkAXTpNBDf4hAVrvI6YzHEwH68nwpo1?=
 =?iso-8859-1?Q?oYAyVBHjZNyMeRot4zdtzDRoAqaFnXVDdjFe636NAZiUt2Eujvu4hWcIud?=
 =?iso-8859-1?Q?oJlEzRtB6mwMzLfs9zVJaESU0M7PjywQ6QQtu0qL+6Pc3XaUkmjJ54cOw1?=
 =?iso-8859-1?Q?rmh8UCI8mX0NulIlLXFkhwwFz4jqfwqECzHfVnpnrhMCPlz2tPUQ+6otGP?=
 =?iso-8859-1?Q?0UNpvY53Cbz+PqI7FhEaT06cRze+rgjzU+DWJDryB5QcU81TEUbe1JI0lG?=
 =?iso-8859-1?Q?gVwaYnJX8JDj8XrKniFweiQPBng29Vaq6KUZzI8aOQEP+DykTNB1XkPmfW?=
 =?iso-8859-1?Q?X1g9PkxIq0TGumr3KM2iVmkwzJwbCNUQcZBjzQXn+IT+NvFSCVOcA+3N8O?=
 =?iso-8859-1?Q?BHVEJvz0wvm9jQQN7bpDQea5vSIi8vGDU4RV9SIR8dJMvIDRQkelxY4AMn?=
 =?iso-8859-1?Q?qOy+jdhPGJ2ZsJNK2R/KXFyx0l28x9x/xshglsSDQlQ9KDGXPUGnyClJxO?=
 =?iso-8859-1?Q?qBYiWiBUs57bK+AolUdE4f5c7OGc9m0rAABXIIJZEpNpoHcy3TRGCnJBn1?=
 =?iso-8859-1?Q?v7aX2LdhiW6F+xHBnUtolXy7SZeTplsVhvUbjW36KJnp3QFfka1W747dld?=
 =?iso-8859-1?Q?BIPLnkF6Kw+cURh99oNyRtOj5nYLRQ5K009lYPoU0Y0S+0AdfFX/Olv8Ux?=
 =?iso-8859-1?Q?5mbiPNYo4yLb1J+CAHAVY3TQFlD3OkuFUuqWs+Na0fsoTPMXGe8/H7u7sE?=
 =?iso-8859-1?Q?50g0FBbasQtnB7T5sM0avFa+4qcyMQgqggwXEnXeEO8X/Vy2ewZYcwS7iq?=
 =?iso-8859-1?Q?p62Ph0adh/OfZbRV0aIdusSE8wAw7gW3nVvB5sGnDD1B2cPeol22WA3gjy?=
 =?iso-8859-1?Q?LOkhNYkrlBwI/XkA5sHQRrvgJ8YXFLF+c5qtXJEwRrdDygIf1l2Yhe8s6t?=
 =?iso-8859-1?Q?LT4U41uqs8v0jy9Wc5LVdDjXZL1QJSv0TiBVrb0FGxt6VkZzz11LuffpvL?=
 =?iso-8859-1?Q?2PRlKc+NkYCaYeVANUs/lE3+Ow3sdkLeXeIsQ8GQ+Ia6OkiH3Edwz9UztJ?=
 =?iso-8859-1?Q?1gpGRK1Ydh9nbtZe8btFGvH2troCV3UlRcSJHeYsYNxIRSfS4d+N4TplnR?=
 =?iso-8859-1?Q?On6n1YwjJDYJsff2fB7WcRbcE+uaEoa31YboDotNuCweaVgQa53TUkCrUu?=
 =?iso-8859-1?Q?R+G1xw/YsPN+qPvp1SIC5H2Yk1U54UDm+ehJFzB0EI7DAfNiDi4w2BMz99?=
 =?iso-8859-1?Q?CgDzesE79KgWpbqetqYQ/lPF/za6c7PAqhitqfgKjgVjsYV8l+Lzkka0rs?=
 =?iso-8859-1?Q?A8X+TKJiwwmWEjCjUAdcrbKT5RrPERIxt7B9Y5VVyb6bJc2a+deuDjylGc?=
 =?iso-8859-1?Q?sRb5XPBvB+pXGfN8Pdf7a9Dcfzqd?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5364ce18-4403-4117-ef28-08de4fa12de6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ZIjMdss1PLy0pJBfpMiTi1O9vopk6FjtUFOm850GczDTowWyhwLIeOGDDW?=
 =?iso-8859-1?Q?/vUd4g4oVcgr4AYAhBicCCPK6+66Bn+z+8NrxpPyi2l5fARwxrInyfoTtf?=
 =?iso-8859-1?Q?OxUqAa4Xu5AGKXAza/wYlc1mLZVpffi/IBK4Dm4SFXtcBfZJunKjMBd2cz?=
 =?iso-8859-1?Q?QpxFh5znpujDOsP72pgXu/KJIo6pbpdotIQBUlNJtE3G2HTEgpWIMgQ3nR?=
 =?iso-8859-1?Q?uU+TRyhaGvODH7D/6u+i/aYR6ilwo/rWIskYJC0ES0HIVMlF4jGB8FTYif?=
 =?iso-8859-1?Q?yoPadcJuM0VmladWt943G2QgpWQS7NST0PN6kk6cbiOQbhq60bfRH9HVp+?=
 =?iso-8859-1?Q?Mj4qQNg40m5YxGKAQY4L6W4cvkh18+xJ8ch4mvmhGqo3fJDt2SGeYD6jCj?=
 =?iso-8859-1?Q?cs7xe9jSujnZ6apmBHOSGLzYEjpIiulJ1ulRoUFT0GaNHz+R6TwdMsFPQ8?=
 =?iso-8859-1?Q?YvADTHHwzRxyveOecc+L18ag1TbhxOqDbQlg2nZkMCLM0XYR04vbalvRlE?=
 =?iso-8859-1?Q?42104Yb7mZtYnYwYIqXGMVms8Mvn8pU5cB/t4fA1Ng9L11HnQjkTFyVqWX?=
 =?iso-8859-1?Q?qQtQhIlIrDIJB2UJ2L48Zs/wUWA8ISrTVNWZKdSA59zFkdtpuQ7FBtvu9c?=
 =?iso-8859-1?Q?9D0h9nJZSnTl93LX7o4ybKeDQu9y9ESmb6TjoO/AJo8+r/wUpw6K/rOgqd?=
 =?iso-8859-1?Q?yDJewnl71v1Yf+mD1adkAm+A2m3nkKoV7jAFVTGdpAObdU5RHYlVoBB1Z/?=
 =?iso-8859-1?Q?Al0EW2clHGjWG601HV1lic2r4VunI2NeotmFkUGtOyYRN06bFaTCILsMlV?=
 =?iso-8859-1?Q?kpQOPxMMYWfGShwe8h4D9d18I+4gSOPJjTWJwyJsbMDS3bFgASx8FOZv9r?=
 =?iso-8859-1?Q?hmUszOFUaiuC+WES0Z+GnAv5VEyCpJ19tyFpYDzJ25/TFOq4xPdhQJm3R0?=
 =?iso-8859-1?Q?h0yB/5tPPKSWonNKmDCq2sfKpa9QgRcqdcSxzLfwng+K1rtBX/u0R8D0M1?=
 =?iso-8859-1?Q?EdLI8IEiD38ou18pJL7KCp9Y1qM9cUstBeD8tK4qY8A33YpLV160I7Pzsf?=
 =?iso-8859-1?Q?ZkVnuB43k4cIPxhD0H+LYJlOC5+HKHRVIlOT02oEdiT89PH4wKdgx9f/Mk?=
 =?iso-8859-1?Q?kHdHV7QRrwGc8q4R9vvuLPMSLspcPD7uxUSOqxcIOyXqlgPy15IKfORTJk?=
 =?iso-8859-1?Q?ULGMwK8gdpjJXcMQpz+Jz8/lH6vInpMdg97Rpch/zsTg8qtL62B49o3Wz4?=
 =?iso-8859-1?Q?LwXAKTfyf25FDLICmtk3xR4BTqFWzqOKoQOoOR7xckJHHqDw8tOqDjGbr2?=
 =?iso-8859-1?Q?2XxVCgu1DksiDkjeD4dX1/rSOlgowqzGJyPf6miUEjKC6zTd/PPuqDm75k?=
 =?iso-8859-1?Q?8Rmjwhpl1l2rDhoIB0h4lXPk2LcdCgvlnLKZUmuf3kHwuuxhvlmYBqlw80?=
 =?iso-8859-1?Q?roca/zZBoxoGnMB32PHWNJusVRpM+aQGfoSzhfWqOkdFm+3fA800lFRA+V?=
 =?iso-8859-1?Q?AzGADr3R9PPg5vyGYyg3HKjbVMLotAbPLnzCwmJZ8fjjrLIhRDpJZ8EQ6R?=
 =?iso-8859-1?Q?0dmDPXT1FsJmTfQ3YH5pTJeYia7leujH5jJFU1tUwJb2y7DQU9r8oxzUm3?=
 =?iso-8859-1?Q?wiE77OD0jDbk4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:43.9513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7465c8-971d-49e9-84a2-08de4fa15360
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9608

Different GIC types require the private IRQs to be initialised
differently. GICv5 is the culprit as it supports both a different
number of private IRQs, and all of these are PPIs (there are no
SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
encode the type, the intid also needs to computed differently.

Up until now, the GIC model has been set after initialising the
private IRQs for a VCPU. Move this earlier to ensure that the GIC
model is available when configuring the private IRQs. While we're at
it, also move the setting of the in_kernel flag and implementation
revision to keep them grouped together as before.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index dc9f9db310264..86c149537493f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -140,6 +140,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
+	kvm->arch.vgic.in_kernel =3D true;
+	kvm->arch.vgic.vgic_model =3D type;
+	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret =3D vgic_allocate_private_irqs_locked(vcpu, type);
 		if (ret)
@@ -156,10 +160,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
-	kvm->arch.vgic.in_kernel =3D true;
-	kvm->arch.vgic.vgic_model =3D type;
-	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
-
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
--=20
2.34.1

