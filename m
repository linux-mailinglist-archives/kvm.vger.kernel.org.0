Return-Path: <kvm+bounces-66356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F48FCD0A6D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9714330E9DDF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7707936212D;
	Fri, 19 Dec 2025 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KAvT+QbM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KAvT+QbM"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292ED361DD9
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159633; cv=fail; b=A/OQl5Dj1NS8APEM2voSEsA6BAJFT77sbmBUrD8OFzI6BhhTnJA8ZGDMXb7g/LP6HE1cBPFVEozGTgJFlvmtDRBqzDeSRGzJiWiRJjTpMbpDLvXO/sVhqfVabFymu6KC0xPVAMpD3xb51Mkx/tdF9fWV6JYLwRFAcp/wz5DZwBo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159633; c=relaxed/simple;
	bh=RTTFKL4hbxW5nAbmdFlXCxoKKF48BPj88xvuXd5VPH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=khDg8OAM2TvGah0K+pLbEYOTrPGuZSusl6WeC2WY0NnMpx6nuDHdr1QflZYABXRHrZS/cJ4JTuJWlBTT3YoGYewkeL0rQrI6YQroQCg/xWjLYO1LiTPm1VX8lhovFv3aEtZc0nQyofs3MYj/4TWjpLXMe9CJ+una6kX/rsfkjYI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KAvT+QbM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KAvT+QbM; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MZ9Bv0vIirrJ2i5Q6FL/NQyvwejr4/44FReZ+lrKEJzD7fRIqk+Sj8A+eFKb0Mm2uAaTf86DIkFNUYjspSmcMmeZwsGDYXub1r3Q6nAQuIEHwpotuldXnAqE8Hp6aKydn69yqCwOYJMVj+Y55YuYNs1hAVDcXyIw4Nkgm2JY9H7NApHBo0nLVOH2RXsytN1UBMOQ0BU3yu8bvOfR1srLGPC68h81z8j/qVfz4Ba4eVx4Y/Sjs24ufozurqURGmz4mRW7Ftv8yGSduSq0+5ESRuJMYN8+3pM74lPMRldQ21rhuqO7tEukLc779v1T/NWEw7b9oyxaQ/L1g8OmQUdBSg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDX3LpI8H0tuL4vPdj4xoFgGrDsc+iCFQ+vFCQbuNjU=;
 b=TQEinhjNFZ1oGr781AXAIYdAmAoGVhgUHuyrLaXxFQ8OJqSJ4+cuPfFS0IVaLa0/1dn8iiGhFmfgKnNyGtngco0BCcuGJqsN05EHwtWWH8fOWx9qO+X5enIp9HVxY/vU7ewBK/oqIeoM6Wr47Nzxzs9XMtXLAFQDB/0PIE7HNGKb6XkDy3Ypu9kbMQTJXEnccx58P0Yk/9Y7yuN/gE4b9O6RFh26SB2ADfkf6bFcujmiLGuU07obGa/IyKIkI+8HSP6OP3FF5cT8+RbJKG+gp86TU29QGma0uCCoE4vrZqwXqZz9sdbC221NXUu/3k85liPHXlyJB+Z1anv5PmpkVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDX3LpI8H0tuL4vPdj4xoFgGrDsc+iCFQ+vFCQbuNjU=;
 b=KAvT+QbMtV3KV+LxQ71dZUl0S58QgxMYOycFOXKuXtJwkfo3BUJh8IeQ4xalCAnbL65kPQp6NrMDJzSkRhwvH+xwCGqLiUYlSLNN8dqMDLArhvsWSNx0t0/O+Huxz7yxi21s+Efl34mI9C+A/iUTp3aW8yHly0uxIlpQ51yU4NQ=
Received: from AS9PR06CA0626.eurprd06.prod.outlook.com (2603:10a6:20b:46e::35)
 by DB9PR08MB7818.eurprd08.prod.outlook.com (2603:10a6:10:39a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:43 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:46e:cafe::48) by AS9PR06CA0626.outlook.office365.com
 (2603:10a6:20b:46e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BE06DXCmZCi7lpnn7j1fp2/0jy2aVpU4su/MiVSIOT4lhNQNicyVJkiXFRjoJlIxtxKiyWir++lI46+O+N0ZiWqxIP8FvBxzcK5jYBfb1f1jsODpH1lwkEEduiH5gU/CSgS71H0CfQfaJkDe9TXyBeSfNpof0i9E724voGug64hpPn2lnH1V9wqF/v1+eNWywU6SU5JcJE4W8AAC7iWLn5w2GpNvnQYJYW0I51KFpUpozgVxj7swGZ+SQ3fy11rKpeKwK9YmaJfOWgjawMug/lpNA2yk6tfBbFbq+tH0M23lUw5DH6NOlxTKt6kuIycmugrSUaiZWzVAbWuocv8rHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDX3LpI8H0tuL4vPdj4xoFgGrDsc+iCFQ+vFCQbuNjU=;
 b=NQGuxNvq2jpUGQDsV7uropXYOKwMsSPStC1FZKAZPmfprtTrJGQKGmtIrH8wTZreQEVfmK0yEu9brhlvf6T4HtoQs5KgP3DiFifmZOTETUZYhzYjjyKYAPdmzAzG/JizFzVWshb1ytHjzJ1PJvf/ZnXFbTDjcTI7RTZhhh7uRgWzeB4pYxYalYH5Oo+/f7Au4hbSW97HvGA9GTRS9ROGN88mbvemtxJhpChxTiWr3VJguT1BV0dwGkAMuFrnZ4Eqe3sN9Ufx9SVW5/uMB5KdUNvORpL494xDnp8JYYLLlENTOBQHrxucnFao3xUqXmlLMagH/GvhGOhRLoMKR4nA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDX3LpI8H0tuL4vPdj4xoFgGrDsc+iCFQ+vFCQbuNjU=;
 b=KAvT+QbMtV3KV+LxQ71dZUl0S58QgxMYOycFOXKuXtJwkfo3BUJh8IeQ4xalCAnbL65kPQp6NrMDJzSkRhwvH+xwCGqLiUYlSLNN8dqMDLArhvsWSNx0t0/O+Huxz7yxi21s+Efl34mI9C+A/iUTp3aW8yHly0uxIlpQ51yU4NQ=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:40 +0000
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
Subject: [PATCH v2 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v2 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHccP+A9IRcfxPZdk2mRUGIvQQNAw==
Date: Fri, 19 Dec 2025 15:52:38 +0000
Message-ID: <20251219155222.1383109-10-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|AM3PEPF0000A79B:EE_|DB9PR08MB7818:EE_
X-MS-Office365-Filtering-Correlation-Id: 599213ca-37c3-4fc8-50df-08de3f16c8e2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?xQnzVgwlJonBI4T9MgqmZDODDMLZTPZCjMX8asbx6NHKmKS+x/sMsJqTGH?=
 =?iso-8859-1?Q?ZPzzw6C57RW79NZqgmPneX4Cii80pxSpZDRVo4D7UZV8GgpBTZlCxTMYqo?=
 =?iso-8859-1?Q?/zVeiA3917+OP7SEYA5NktVKU1yYMeI2SsmCg//j3V4QwrMdAG6zfyDwvZ?=
 =?iso-8859-1?Q?lxNp06oSoVJ6tuP9wr2UXFRyGBySNnM+hrbEgd+xz9qaqyLKSb0jQzk0XU?=
 =?iso-8859-1?Q?GEZiYIOmnFZjQ9Dasfrrfy9g7/yEsA7s3c5jX2G8zSVia12AxzNpl92JVa?=
 =?iso-8859-1?Q?8zsHN6zLt45IaaYyh7NF8WzORzXB4lRJh8xni6tx4/7M5HxMTiZcDuuCY6?=
 =?iso-8859-1?Q?e6xeXkBnuqcIWsl1KANGj8a4Yul03BcdB+wdv7ZMamQB2lgC6epm5+Onqi?=
 =?iso-8859-1?Q?3YICzIQB5Km5KScb0x1EQTyMGY+5zTB3L9eSvOWfWcTl7zbb7Nj1aTx0tl?=
 =?iso-8859-1?Q?UGIS1ReNvXFYHnLMsWXCPwRhsI4SPNslETXuRLTCGcQKW3q1OhGjGkbUly?=
 =?iso-8859-1?Q?IBnS+ovhafK0QVTfghvQPb9atMMCY9p2U3kXRAWDeWazG7BqzYaDDTN1II?=
 =?iso-8859-1?Q?rNAdOmgoJ9puw6N73mJCqaGMg0/vJ8SLHO5llaeZ4GeiObQkWeg60/3YNE?=
 =?iso-8859-1?Q?BAlgsZyIBB0QzKbF7MkSpe198fWxLgZfot0aMu2ye7acqRKlbI7kkUMcQp?=
 =?iso-8859-1?Q?ypT+Vwwglsw6b1GxveWZnXfkdfFzrJdYm24R1CpaS7aZ9lKY86pf9+B9Qg?=
 =?iso-8859-1?Q?danFRShgtRn6B5KFTojSr8qghbA61GkcBsUQ9/SEJ0c6htRUpts4Pwpyfc?=
 =?iso-8859-1?Q?b2DjSG+vjMGAYU+nT/R/PtMfntLZLSYlGwyEpjuK0+csTmRF9G7EYaIEA/?=
 =?iso-8859-1?Q?PdKyU1FMepaO4KbAUPK8+AD5TVU7eOb5HLF5kxMrj2pvxDE1f3zrrZsyFf?=
 =?iso-8859-1?Q?DfShjKuAHEBLFzXC9qNkZ8Sh1jFJQjwFVuyLnJ67EGVIHDcF8I+p36Vzq/?=
 =?iso-8859-1?Q?EmywuuPxFgBbKCQHGxDfb6wQ5mi9h98lsrnGo8gjYF4twPdAQFHdbwu/7D?=
 =?iso-8859-1?Q?EHzXux5V6/BgaITu3C8di0v6PbDFquWeHuJj/ISqshw2zcb6h9W5CLC1bB?=
 =?iso-8859-1?Q?Ji9VBKf/TL9LnigQHcbokt8FFULericev2t/o6JL+ceAy47RbPjEWRS9rL?=
 =?iso-8859-1?Q?T6HqacHXeqIZ+Uv16a4AKtUfZKrsY12Zn8fSNUBbbIdBHacdpnEZ+GaOSj?=
 =?iso-8859-1?Q?INOXSpn5ZyhswWCjXnb0cqGpMoG5noWlAItB3+Hsxmv2gGhs9Q5WyUcR4y?=
 =?iso-8859-1?Q?oqz8KOQX4hSCkZZoB3IoRFVq/WH+Gtex0qenei0PSVY5wTPWC379DWJafK?=
 =?iso-8859-1?Q?tlmTwTFjvNfi4cRE9awfC8pMxOuLsGtXo5iRNjfBNIezscdMLyXhlwRA5z?=
 =?iso-8859-1?Q?liEgD2SsHH4iJJHBY4yJMhRPt7IU1YOYJ59rhDNutxDRY+31wCjxLLpAi2?=
 =?iso-8859-1?Q?qgSnLId1vQ7uFg9KvOtFgPSRBn24OePIHDHeD+Hb7jrT+EcX94aJ+2eTB4?=
 =?iso-8859-1?Q?iC5QMPfdiZ7NruYP8D1XQXMDlU84?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6cb33ed0-cc12-4ae3-5b3c-08de3f16a3a4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?eV0RR/sAflHs5vWS6fXS3zo1BTbl5T+8ItBYi9104zfvi4938+C/FZDdnS?=
 =?iso-8859-1?Q?0nutZs76auMnWYFyUPPf3q+/NXW/AfhE1c48Y4nioUhtxEdA4l/iMe40n5?=
 =?iso-8859-1?Q?mJ1eaRRhN4TweyBmOWhEKeIzg5cACXK22vSBL47UYew+0NrTmqRrZaQOK6?=
 =?iso-8859-1?Q?+Ss5s5hCZSyLz2rjjEEJ++l4fhCN4VCwuY5BLy2tWF2lugT+MEE20mhu/w?=
 =?iso-8859-1?Q?Vk2MBp1ZS3LfiG59bS+9WeBB8vu9cp8WaxndLTBl6B0N7NPTWM8TVu5ynn?=
 =?iso-8859-1?Q?mSi40YqyWnOiLvX4pf2zhQLJ/P4PspcHLUIRVMEyiGKkA6WeyQNVXeH/fg?=
 =?iso-8859-1?Q?0CgQzLJXeRJfThW/YPC7TTYgAJuAgBtkwDjgLssrLuhu+lruVIEh4wcZ6Z?=
 =?iso-8859-1?Q?v8f0eRVd9M62Li5SucXQyGO8Xei3aQtV5YiDuPHxmvAYobCgjn9F3Ee7Gc?=
 =?iso-8859-1?Q?Zs0ZVQ2FhdfNDO9f9ccQWPU61we05LKCRhouhfIuaqabkrrbLxbcEJBnSt?=
 =?iso-8859-1?Q?oKiBwkVPYuwq3h8X0DJDBqg4UskHCb3jcdy9Af15wl4XkXDekgdOrmyhom?=
 =?iso-8859-1?Q?FkrhS5VU6C8nzJvi/SBmwzzJshCZShDEJ8yC2tMzdoSoIiAQIz2skrImPg?=
 =?iso-8859-1?Q?ACtQ1p/BgsvTjG5xpSgI3KHDXwiPYm+FVPXW4/q6OAlxouRL9pnvpd7uhC?=
 =?iso-8859-1?Q?6OtBNCPSMmZzY/ndYXTolmJ43WDGMx8joUeeWDAV77HvxIrfAFELFNFGsB?=
 =?iso-8859-1?Q?TWFHRXjCsP/rW40boJ0gxFlYQhlWFVLL4MGxbl50cSfLb6F+XDJSbrKc8v?=
 =?iso-8859-1?Q?TBg/JXA/MZ+tZX5XO/QPPLHC/w8ICsz77rkmRn1BOpBRKWgeQFQsMtdyq5?=
 =?iso-8859-1?Q?1ubGhWqvU7gE0ODsYw8+lKJRo9m2iWyGUrCC8ybxXQjONiQ6XwKaK1OWM1?=
 =?iso-8859-1?Q?oAV5sx7PAJ1hPcU05todKRmxmjLnrlamuj8hJ8+cNu9cMOvWgaaQ925zm7?=
 =?iso-8859-1?Q?AQ5labihfp5S7G8wKagTRj4833DTwePhyT0F3NWcazqs0N/qnTc/7wB/nl?=
 =?iso-8859-1?Q?oGDb/2xqFZHNM3yG0WhQuBZ+Z04hjOFUvyPItJL/kE4qzYldNKiJGllQUE?=
 =?iso-8859-1?Q?RBjZ+Y5P7aqU/3xVeIat5qDxV0LnLhYwglRkvOi6f0EiEY5G04OXmfHaFc?=
 =?iso-8859-1?Q?A93uoPHYinIDbZtUXry8n1DVSmuOe+8ZadMNw0v3sYrCTU0oa00IG5nMaC?=
 =?iso-8859-1?Q?kodFfbsJ7Qk0rFuxEpMnVs6hHXAfHwmi4OkGU+GMaRk2Sg4QP4EhkhRilH?=
 =?iso-8859-1?Q?Lhw8rByc3musuaqUwbdOR70kYdCfFKf5grbne1ZM5iXaKEyiwDcnxla8ml?=
 =?iso-8859-1?Q?GGRWDfZQKzd15JZMi5+dndKYnhjxrdlDZkA37+eUWBLftQDHyS2WaOC9KY?=
 =?iso-8859-1?Q?u5lV/hhd7Fx5ttyV9Jw1D2LMwUlmFnIB5kNgk0FZluMX+1J1MAuXkHu7FJ?=
 =?iso-8859-1?Q?WpWWVXqWV1P+CW/CfuPpLOdjAHsIQkXdK4vEWBT8tFCpAt8ktqEORcarTX?=
 =?iso-8859-1?Q?ie9RpKHjNlOsNRNnVzxfAuw7J6zfCQL/ge5HZSlF+2lmwFk9Kzeg4PT+KN?=
 =?iso-8859-1?Q?0tC3W7rajLlSU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:42.4292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 599213ca-37c3-4fc8-50df-08de3f16c8e2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7818

It is expected that most GICv5 implementations will only implement a
subset of the PPIs. GICv5 supports up to 128 PPIs in total, where the
first 64 are architecturally defined, and the second 64 are
implementation defined. This limitation applies to both physical and
virtual PPIs as the same set is implemented in each case, and
therefore KVM needs to determine a mask of implemented PPIs during
early KVM init.

The check involves writing all of the ICH_PPI_ENABLERx_EL2 bits and
reading those back again to determine which are stateful. If the bits
are stateful, the PPIs are implemented. Else, they are not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_hyp.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile    |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  5 +++++
 10 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a1ad12c72ebf1..ada752e97c6aa 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_detect_ppis,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 76ce2b94bd97e..80e5491de8e1e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -87,6 +87,9 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
+/* GICv5 */
+void __vgic_v5_detect_ppis(u64 *ppi);
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index a244ec25f8c5b..84a3bf96def6b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y +=3D ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index a7c689152f686..3d1d0807be6db 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -586,6 +586,16 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+static void handle___vgic_v5_detect_ppis(struct kvm_cpu_context *host_ctxt=
)
+{
+	u64 ppi[2];
+
+	__vgic_v5_detect_ppis(ppi);
+
+	cpu_reg(host_ctxt, 1) =3D ppi[0];
+	cpu_reg(host_ctxt, 2) =3D ppi[1];
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -627,6 +637,7 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__vgic_v5_detect_ppis),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
new file mode 100644
index 0000000000000..4b088588757ea
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - ARM Ltd
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <asm/kvm_hyp.h>
+
+void __vgic_v5_detect_ppis(u64 *impl_ppi_mask)
+{
+	/* Disable DVI for all PPIs */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+
+	/* Write all 1s to the PPI enable regs */
+	write_sysreg_s(GENMASK_ULL(63, 0), SYS_ICH_PPI_ENABLER0_EL2);
+	write_sysreg_s(GENMASK_ULL(63, 0), SYS_ICH_PPI_ENABLER1_EL2);
+
+	/* Read back to figure out which are stateful */
+	impl_ppi_mask[0] =3D read_sysreg_s(SYS_ICH_PPI_ENABLER0_EL2);
+	impl_ppi_mask[1] =3D read_sysreg_s(SYS_ICH_PPI_ENABLER1_EL2);
+
+	/* Disable them all again! */
+	write_sysreg_s(0, SYS_ICH_PPI_ENABLER0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index afc4aed9231ac..9695328bbd96e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -10,4 +10,4 @@ CFLAGS_switch.o +=3D -Wno-override-init
=20
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index dc9f9db310264..c602f24bab1bb 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -750,5 +750,9 @@ int kvm_vgic_hyp_init(void)
 	}
=20
 	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
+
+	/* Always safe to call */
+	vgic_v5_get_implemented_ppis();
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2d3811f4e1174..1fe1790f1f874 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -5,6 +5,8 @@
=20
 #include "vgic.h"
=20
+static struct vgic_v5_ppi_caps *ppi_caps;
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
@@ -50,3 +52,30 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+/*
+ * Not all PPIs are guaranteed to be implemented for
+ * GICv5. Deterermine which ones are, and generate a mask. This is
+ * called early in boot, so we can just write directly to the ICH_PPI*
+ * regs and have no state to preserve.
+ */
+void vgic_v5_get_implemented_ppis(void)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	/* Never freed again */
+	ppi_caps =3D kzalloc(sizeof(*ppi_caps), GFP_KERNEL);
+	if (!ppi_caps)
+		return;
+
+	if (!has_vhe()) {
+		struct arm_smccc_res res;
+
+		kvm_call_hyp_nvhe_res(&res, __vgic_v5_detect_ppis);
+		ppi_caps->impl_ppi_mask[0] =3D res.a1;
+		ppi_caps->impl_ppi_mask[1] =3D res.a2;
+	} else {
+		__vgic_v5_detect_ppis(ppi_caps->impl_ppi_mask);
+	}
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc29..15f6afe6b75e1 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -362,6 +362,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_get_implemented_ppis(void);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6778f676eaf08..c7786a2607ecd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -414,6 +414,11 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+/* What PPI capabilities does a GICv5 host have */
+struct vgic_v5_ppi_caps {
+	u64	impl_ppi_mask[2];
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
--=20
2.34.1

