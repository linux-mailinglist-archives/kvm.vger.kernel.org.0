Return-Path: <kvm+bounces-67600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A6CD0B8B1
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 445BF3127D25
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94B2368260;
	Fri,  9 Jan 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hr/d3PK1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hr/d3PK1"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011024.outbound.protection.outlook.com [52.101.70.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2496364EB6
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978357; cv=fail; b=VF2TYd9jegwHa7YwIfx8Y2hll3ZK11MMTKk9lEM1XRmSEyeBI4d0uQiUMWE+lRGWJ4ZhHhuJIPQghatGxwhKXCktBxqCxnDDq+DrQMBP0UKcV0PbAxE5DORHt0LmkMHsxEVuAWH4P0Es/8io3gEpuZCZwmTHY64iaI6fZxLhMj0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978357; c=relaxed/simple;
	bh=h597a8h7auJoOaHQao9zHro+LmvzRNUMYr9kMaid+ZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uMU9stXecZebvQEcj3cptpHPIvmDl0PaWnJl4d7EnpWaGwj9WYmoyedSQqmKH3xITVegmttOf8w0C06Pr90sjICQ66EhUkAJ4xEXlL3Q1SJIdlmo4qZOjB7PvLzkQKfZQ4qJgi9hkcp1G4so0QRFs/8A+JYkK0IQRHiEofqYBcQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hr/d3PK1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hr/d3PK1; arc=fail smtp.client-ip=52.101.70.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hdXtHj54NydZFC/aES7UYZNWWZOKa695QqGY9nkMwxSYByIZ4uv5JqGcklHwCs/iurPqTNypO7lNgMYX+6uAtHGTC03UczSNY1W99AeT0zPKfytEIK41htEq86+M1Fh2ovCpZc3viVBY+3Mdw6US1YFWjw18UshEo1UVFkLWWZYpvzkx46mni8GGxKYNOHht/2SA26bk9GhxJbO62CBIva9fcNhJkMaqg3CHz7UYrUwp/6ymX9w74F9UO4GNFV92Dqtc2c6HuhSn63NRZCnbb4EiMnKcQW2bnaY3htRt1cfUoi5vPet2hPcl9UWE/4MCW9wyRfv1Q7IeVi+G1Xy/Bg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45IE8jSutEZYKxd8ynn3Wr4IkHus0uo93z+87a4ziVo=;
 b=aoNG2dTFTNjqLLh4twB/S3saF/jlWEgtdNT19WLGtQJC2HNmZjUXPECZ6Lf2AjOSMMybCpO1Ea9cwspTrHt+Mlc+iOdAmWJtsfflX2XLUSb2X7zPYm1IdIaB/KedAMqd4MB4YR2OzEik1nXbrR3XZJUGG4EFeXu52cPn+hCucUyWTfOIq3hj33a6FR9ZM9IRakixojELUKBQR+lLTz0OM01xSLx+8+8szqrrUG4d+/JfKv+gZL4GLmiG9GxzikPsbpuuIV2+a6RdAe9PvPkkFYn9Xwg2knxxBFXi8Q0tsf8BWobj+FIdg4/Nj+kFFJC/x2ad2vZvko/WbbwoP1/x6g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45IE8jSutEZYKxd8ynn3Wr4IkHus0uo93z+87a4ziVo=;
 b=Hr/d3PK1565f3End35QE0zA48Q+K9LU4TC2CCa6OmL8LETC+JQnteV58LyCCItsNgTABT4tPpUsHmmn6celY1CIKA/T7e8sS6JnfbUSw2qNIE/6A/ctfRINEWYkRXA5sbN4TJrriNSn3UgKXCAC7JR15OP8/eIyEjFuDITQXysA=
Received: from AS4P251CA0028.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::17)
 by AS8PR08MB6535.eurprd08.prod.outlook.com (2603:10a6:20b:336::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:48 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::1f) by AS4P251CA0028.outlook.office365.com
 (2603:10a6:20b:5d3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISFWqJzeXH4SuajWjUQ1sQdPKf756qUKb3ZXlIGa3bad5/u7rThxUcd+HnduBm0dNZ9hWyAl7nmmqxX5+8n9G99rsXybPAfqqCOMD81wMgv45eugQnA6TVMkkZY+r32roDTadWI4/VLFPh0hYiWnP82jHYHxKacWfhRIhuEWQzskxCjOZsaWpp6pXa7eaoFiBzA3Ds2iReqbg3fbsT8Aok/p3Atzl1Vk+dm9rrE7QnT+uBABg+2MKFPHclqdcjoHvkQ8JHXbE2fTk8td07nwZvhFAZN1RHZ+x++ImhdFOon6/IQWXfbbDL13sjXhHu1/3cN6R2sukInz9x+W23Y1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45IE8jSutEZYKxd8ynn3Wr4IkHus0uo93z+87a4ziVo=;
 b=K3z2HXO2T1pqvMmAM8EOCg09Rr+gONWUOnkDRkB3feHkJ8vkdF88HUWoYkBTMysrATu1Cyly1SkY3a4QdaLJFaaZuVdU/sUfkSLRGLkF9e+4j7/l7Ec8OlRwWp0hrGTlW8JUpvpvGM4+baqYoTXJM5M0rysCoRqHIf+BATzdITbMmqM5YK+RASBN4bby4qsqAvPxrPhe2tu4sXj4wRv3OTXYOIGXIVsPzmIEPALRbgroIRg+4uA7IwQF1TCNIXURcqR2kmC3WidW1Xlr1WTWGIeAzZdlqwaFhUZsfO63wXPArZE3KpjG9HQC0OyqdcYytwmGb4RlvLL8v5BtiCfT1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45IE8jSutEZYKxd8ynn3Wr4IkHus0uo93z+87a4ziVo=;
 b=Hr/d3PK1565f3End35QE0zA48Q+K9LU4TC2CCa6OmL8LETC+JQnteV58LyCCItsNgTABT4tPpUsHmmn6celY1CIKA/T7e8sS6JnfbUSw2qNIE/6A/ctfRINEWYkRXA5sbN4TJrriNSn3UgKXCAC7JR15OP8/eIyEjFuDITQXysA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:46 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:45 +0000
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
Subject: [PATCH v3 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v3 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHcgYoN2VrSO8yfvEqEFNVRRzonIA==
Date: Fri, 9 Jan 2026 17:04:44 +0000
Message-ID: <20260109170400.1585048-18-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM4PEPF00027A69:EE_|AS8PR08MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: f97d1dfd-4aa1-4ef8-4ff1-08de4fa155ef
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?K/3sTDEk3wwwM2Hpf/3s+vdDEy1wbSMVLB2cXVJEy5C2rsv/9FXBN0H7pg?=
 =?iso-8859-1?Q?C5woAPMLV5geka4gN0r5qTWCysZJNzxeV2ItS7d+aukiZq/bgzP9V4hj60?=
 =?iso-8859-1?Q?okjv+h7jk94eNikzCwKb9/JlrWbdBcInoPB1Vtfh56na2fzXG+mzrnleBj?=
 =?iso-8859-1?Q?0HqV1/ZtSW6Khp/QdrnsV5BYMnYyr4kFQPjsMOQAFY3PctVKirqTJb69nq?=
 =?iso-8859-1?Q?JEo0/JXGcUSVO6ZoNf3MtCLmoDu/xp25p9VDXMhAPNTmMjihuUmwSxZwTw?=
 =?iso-8859-1?Q?4nBfd9sBjDEY7keGliNl7/4fcuQzPi+2gJ2gbaCd3224h6/WZM6QkJR6UP?=
 =?iso-8859-1?Q?4GzsPNAyUkcuhjQFicw32N1wt3w1R8t28EJZ62ZwAVcR5fT+6h8c8X4fvd?=
 =?iso-8859-1?Q?mx55PVmlmcXckCQlXMThGKdIRoc/heZl0ibPfaH84b7rPfHFag/fBYXxo4?=
 =?iso-8859-1?Q?yMSNx5Se/9wB2vcrJ4+W1qNCG2lfb53nL1kn9Srlt18OMhH02am6X1/kW2?=
 =?iso-8859-1?Q?k0tQ1kmSmhRBqdp15yHrPuRWhDNcFHE446+qAEuDiBs3XCMk60xekRZx1n?=
 =?iso-8859-1?Q?UyK/Za+4yvblgXQDw42rX1BdmaTHEKn9tCyqPRDYsHeQad7LxY1pJHGpSD?=
 =?iso-8859-1?Q?DmbjAuC6G1ri999YImdcUBWagH3RW67HZZJy1m1WzM2k92xlwKLAK0Gqo3?=
 =?iso-8859-1?Q?61di3wxK0is1t2LBBP6kCWpPp4ceL+D/sKMhaT48CNpYwW6CyluYXJqwgz?=
 =?iso-8859-1?Q?Qt2aXUfNoIwM5djNBqN4FWO72O7/Yl41MRdtI/7i6IpcwCrZ9F9B5Ft1tY?=
 =?iso-8859-1?Q?hcm9Od2B+lXwHEjN6eeYYtFTOlOjAxbIFjm1dB5OcGxHXl0FLe2Xv3vxh3?=
 =?iso-8859-1?Q?aWPBKcAKN4BZqyaYgN9CZkYedQYJ6FfI1LFFzhVPGiLkdqZACUJUdSpGxo?=
 =?iso-8859-1?Q?6TE/Vc3ZZ56++/u2L8cJH/EJOskqBtEzBMjheQTlTMV3E4FRERMg8MdUbb?=
 =?iso-8859-1?Q?0rtq26rtfBwKgLvVEReOoTDnA24K1jNP0YKYAMlBKN/zCSxAK+Gi5RsrZ9?=
 =?iso-8859-1?Q?fTo43xO4gANM6iEkCUI8ict7kEIllRtxCw4mPNWA0w6uHViXoGvZK2wxbu?=
 =?iso-8859-1?Q?xpMpPFxKecuy/E4pMxXkRjtgpZoWgfmwhJx1T4n82UVutGx7ft6NCfx74Q?=
 =?iso-8859-1?Q?BC92u19Xiz4K6dthfi2sh+qbBKJA1cXcq1gibhNQDOT5Iey4/AYW2e0Hea?=
 =?iso-8859-1?Q?JRP3f1dl8vbLdEywBEfINnacrafZdyDZgOkH4l8DgNGZdvydc/4niG97wf?=
 =?iso-8859-1?Q?KXcicn4PqQVWiI2BE3cSp10GYvz8KEEA2VqmqZX2Zm1xmcvICTUyziuQ4T?=
 =?iso-8859-1?Q?DwwZ79PSpSDC4ciyM1f5hH8HbzUDEnOsIAoKWOPHYyw/A91iYqyrFqmBhu?=
 =?iso-8859-1?Q?c137btNelq6afIIMjQEzYGqhysUEfnrr9fISk5VYZMPFXvLf979a43Cb1S?=
 =?iso-8859-1?Q?OBNXlR6xyFJEiLNH6lQ8pLvNgPdLT6Ae4Seu8O6BJOQT3dM6fBcdyj4qbG?=
 =?iso-8859-1?Q?N0jFyYMgpII1C6MAQfqLZi7nM7M7?=
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
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4c37370c-06c2-43fb-5761-08de4fa130ba
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?MchXiK9Zj3BImF/gyxrxhtk5n0Vgvv70xPn6NC6HGkpdRMKaa4sFSosHNr?=
 =?iso-8859-1?Q?eHIXYTDtz3ny+FLcWx69q85dIbVvOKpUuNr5sr0bXjJjJtmKhkm9ddRV0X?=
 =?iso-8859-1?Q?9X0e/7g34Ofawbx4cGIksO7pojzmnqTv94XNaTvHfNy+Y2Q/AXwRHl8xxn?=
 =?iso-8859-1?Q?B7FuVxw/e4MlbVB7FNROx9IsJm4T7puIrcWBtIABLT8RFfz3Pv0tnKRw3q?=
 =?iso-8859-1?Q?1u57CPGGt4M5MnZy/cfBaNOkHzsBnfK+rKyfqI+c+eJbgX37NNBgZwmZrs?=
 =?iso-8859-1?Q?4JmsuZP420fArNMwUJqEV8+jQPxDitZDZ7MCHuQ9XHjQh3B40uQF4Yw1HN?=
 =?iso-8859-1?Q?RLxIVpiNVDEZFZd8bUa3s+tqqP3Wi3eMtd02/N1ZXo9oI6V88GwGyW551r?=
 =?iso-8859-1?Q?CepTr/eeUvM8Ue4keC0kBs0Inu9ql/vPmrj0ts1xQsdyu+wOZG/q6yRkFG?=
 =?iso-8859-1?Q?7RCYjCk4ppas1hRHXIjr3XSQ0G7Lmo7nPwDsOImhrmX3wysd7R8OPHUdHG?=
 =?iso-8859-1?Q?BldGSGcjO40rwTAMg2Sw6+Fqpq8Cy9G5NWJProODKNRKbGrXeXbpNeLTUO?=
 =?iso-8859-1?Q?5e9l5OMvdQ0QVzn4FZY2dnmZ1CNPMard2NOdMZEb4sUo+wakfzpfuW4soF?=
 =?iso-8859-1?Q?+AZ7Rjkc7sNAt7cJ0VnZmzuUo4Sv9nsB+XayPcoNjUCjL8Zm1M7H1Dd0Uc?=
 =?iso-8859-1?Q?VNVwB3Fa851IwWk+XFiigfA1c3dDHwfudWna/Oh/Z0Xfr65WQgm9YUKGuB?=
 =?iso-8859-1?Q?7ewcC0p8SA/IgZ8A/9924Z1697lpu9RVQfA5us4qiJAr3J7d8YZpDwe33R?=
 =?iso-8859-1?Q?UWGjepq2p0XVVnmwKMD67bier26rZHpi68dRs5QNA2DNQJTTTGTeH478pZ?=
 =?iso-8859-1?Q?OgqAtC9qfl9mjWmMDf4YhqHNT7NX2zv7U29EaHJC4MJLQqbSFwWLyAGMQx?=
 =?iso-8859-1?Q?whtsCPaGWeApBF5BIFM3QLTIGkYFX4WFStM8kjaT4EZkPgmuaevTDmI3kF?=
 =?iso-8859-1?Q?+oPyoYBoyd5YeRVd0gG7QeGRytGjRA1/nSsOERLsMqDcJRhy69MLeg9CMS?=
 =?iso-8859-1?Q?APh20V3m40Iatt9dF4cGi8rw7tco2C2zkJ2fSm5qiG+pb06qvC1uya4ZDz?=
 =?iso-8859-1?Q?j7zCuVhygGmkZLXlgGtlUCIgljgnVelr/vdeBRktnKu9cG9RABIQYMsR5s?=
 =?iso-8859-1?Q?pVTCzyR89KA1s6UiMy++qiYsXLeNI5D/RsRL9WNjL516k7psgSXyOgyPTM?=
 =?iso-8859-1?Q?GsDKYXtH4EF9iD/beVI7P3fZQod5ifG0j78kvTPA2RiVUAMJJLBnd9XHdJ?=
 =?iso-8859-1?Q?v3hE3q6qrONPXcoPK+He9WpvWI4kQyZm/5W8LczMxIMKoqgv8iYXX7gN0/?=
 =?iso-8859-1?Q?0yjOy/e7XXPVJZW5rBL4BE3yTl6Y/B0PgL+gu03vkYMHcQkXDHIKVpK5vk?=
 =?iso-8859-1?Q?9+ZRCcy8BrxjIvkQABPVgPklkwCRhdnXHN5LyT61S6khraZdr26qw/KguY?=
 =?iso-8859-1?Q?1k5c7Z4EAi3YqUApk/8ByM67aJB7u8sGhm6qnJbxWyvTymMpvQevg+S1ps?=
 =?iso-8859-1?Q?gYjQBsTpv8T8iRYYj6QKqO2N9AWX/qOebNFLb9qqKlLeIVS7m+G1S7mzIB?=
 =?iso-8859-1?Q?jDaUkQm3pkJNg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:48.2243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f97d1dfd-4aa1-4ef8-4ff1-08de4fa155ef
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6535

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered. This mask is global to the VM as all VCPUs PPI
configurations must match.

In addition, the PPI HMR is calculated.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arm.c               |  4 +++
 arch/arm64/kvm/vgic/vgic-v5.c      | 49 ++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             |  9 ++++++
 include/linux/irqchip/arm-gic-v5.h | 17 +++++++++++
 4 files changed, 79 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b7cf9d86aabb7..94f8d13ab3b58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -888,6 +888,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 68cf60fc7aa0c..bf2c77bafa1d3 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,55 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	if (!ppi_caps)
+		return -ENXIO;
+
+	/* The PPI state for all VCPUs should be the same. Pick the first. */
+	vcpu =3D kvm_get_vcpu(kvm, 0);
+
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[1] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[1] =3D 0;
+
+	for (int i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		int reg =3D i / 64;
+		u64 bit =3D BIT_ULL(i % 64);
+		struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+		/*
+		 * We only expose PPIs with an owner or the SW_PPI to the
+		 * guest.
+		 */
+		if (!irq->owner &&
+		    FIELD_GET(GICV5_HWIRQ_ID, irq->intid) !=3D GICV5_ARCH_PPI_SW_PPI)
+			continue;
+
+		/*
+		 * If the PPI isn't implemented, we can't pass it through to a
+		 * guest anyhow.
+		 */
+		if (!(ppi_caps->impl_ppi_mask[reg] & bit))
+			continue;
+
+		vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg] |=3D bit;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+			vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[reg] |=3D bit;
+	}
+
+	return 0;
+}
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f3281bbf98454..50f5e3ffda6bd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,8 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+#define VGIC_V5_NR_PRIVATE_IRQS	128
+
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
 #define __irq_is_sgi(t, i)						\
@@ -385,6 +387,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct gicv5_vm		gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
@@ -571,6 +578,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index f557dc7f250b8..21ac38147687b 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -369,6 +369,23 @@ struct gicv5_vpe {
 	bool			resident;
 };
=20
+struct gicv5_vm {
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset
+	 * is a combination of the PPIs that are actually implemented
+	 * and what we actually choose to expose.
+	 */
+	u64			vgic_ppi_mask[2];
+
+	/*
+	 * The HMR itself is handled by the hardware, but we still need to have
+	 * a mask that we can use when merging in pending state (only the state
+	 * of Edge PPIs is merged back in from the guest an the HMR provides a
+	 * convenient way to do that).
+	 */
+	u64			vgic_ppi_hmr[2];
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

