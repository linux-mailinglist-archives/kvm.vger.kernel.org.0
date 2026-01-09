Return-Path: <kvm+bounces-67602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 320FBD0B8B7
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B365312D656
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BF8368283;
	Fri,  9 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AIvQW4BZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AIvQW4BZ"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013013.outbound.protection.outlook.com [40.107.162.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D4923B604
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=l9Zh+VdLI4wccK2dAD7FCs8yYq95T1UuBewnuojhyf0rer4y5UAWFOHjAu4+jTZxFzLjdrzsKXgkt4xfcVVE9C8QzC2jMtDARTemXJNrSdpTkfW9AJn6pWXsp7tGpThicN7cpwRA6kDC/0ijzykEfRmU/wLGWwNE4OTjuMbSrC0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=EkPOX/zXz7iuDrrtsr/irj1600RkG+EJH9oj4J3jFOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q1YHYe3Y5pao4ihxZ7bLcSk26JeWmkiVgQZSam12vfWAKwAHl7nJ9FmyXX/AXQVfIkp1BrmSxsdfzHbmzABu9HguvpBX58OwlZEok/UMsFnw1TbZtZQuzTlslq8gE3IRP30PvE3w97ZToNz0GB52C33tmKcL6l7LPJs/IF+q/Ww=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AIvQW4BZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AIvQW4BZ; arc=fail smtp.client-ip=40.107.162.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=USZRqL3IUgnoCbofmwwXtOtGGEq7r/vdwLDkc1DIucrEOBF3dQz+MGOvB1Y2bRTBLlu6/+wnPTU8VvxxWmh07/oat2Qwk7UHsIX23/FoK0zTUG6psSy8Lhrp17VZYNdiVpggYVTsxQUpvKwHjA9MeKUL9X+IaLVFSPB1TVF7xNOF6kLeHzs+/U0fcJR7rY8oIeceWzkEV7vcXEBoPh1hwwh+ufZUB8Y6EyW0/6gd8LLIyGOxN7k/oZZaqxHbNcPgKfIcNRaSIj7icadc2OU3tCqEUh0Lr1uHtM9RHawcKhALAJQpjwwmgzXJ+7S3mKF7rLe8KCVtNMoyWIpSWJhCXA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6MxUbQk87oY0mdA1u518h8MhDeC1oSYgwR4LDlwAiA=;
 b=KV3HRzZkay1QexiOGcR729qxoVzjLUHFIZfj4JLdHo/r/keeZBenK8fOndDioqyDKDAqN7PFeSg7rcLfDpCOhV3+HO9AHNXB6uX6eJzqe9qrkwNn4+WwklYgQ0p8TJAMSoJRQrJ55psM912FI4kv1j+M3428Wjas1taAGLygGRSvJ436XuFbBdz204WXCcdaHXABNmOE+fA9HxlTO/iZIH1HBsw86j9VTUGzLrfuYL2LEl3BVUU3zlfuzCvLAamvZj2mzbukYKCNxXFwo1uzX8w0s1jvjRv0BtkZcvpwE3ELIwEYiClDKi0362A/UcdGcWBhIqRmpDHK9lNXH3UY6A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6MxUbQk87oY0mdA1u518h8MhDeC1oSYgwR4LDlwAiA=;
 b=AIvQW4BZpH7iKH6CtuMelT1b3d/TYvU5cdOJ43qM4AtFoRqSrKGm1sP7iuhIJiqf+wgKPnrWrpa8OgS6YXTQoIBkdJgOlNtQzaksNtYjC+fJaEtlhomcZfqoBxNi+AeS2WoE+wndMA4V1sIJ0ZxmxqM7EDIYyqGYPk5uiTsGaRE=
Received: from DUZPR01CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::12) by AS8PR08MB10363.eurprd08.prod.outlook.com
 (2603:10a6:20b:56b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:46 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::76) by DUZPR01CA0010.outlook.office365.com
 (2603:10a6:10:3c3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via
 Frontend Transport; Fri, 9 Jan 2026 17:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LaGUwOXUL3QOBjvPg8rJa+cjfO7fRj4ge8UpWlIrlhRrfv1yrnD2hVnD/vXEGwG3MTEJtw2I2vya2YWufDdwGBC8ckSVwnQaCY9DRtyQ0WZChFhdhYTGYlkGQjR7Ux1csSwQ5e2k36gCRcl7LpjcJriSTZuRilB6vwb4z1UcpXamF+xWuqBEXiYiXZ5T8iJnuTGOVWiNeThKN1VIw/BpJGHaILaAk9aQ4VJazuSdjSW37AR4nQHOhcA4IdE8HMAZcDwWEPf+jwqxNUjgHKCE+giOCrkcSuz2Q5aIaktLK+HhObx3QE8cAAEtOF1YHx5r+sAXyeD9YqmWQr7B7MqBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6MxUbQk87oY0mdA1u518h8MhDeC1oSYgwR4LDlwAiA=;
 b=HWfsHLWRRowFHT0xVBmAL3+PGYwqpxPnNLU7axE8Hh19MJwgqVlo5fKziMDV12em8bUZqX/wwxP2qbn5jmHA+yQpH+ohAt4OmADoX/Zf7BKONSdfHw715RNMs+0q9qCYo2dtuPPfdABPNNYHdJfkGsxhIWPoRv+OrCy8S20HJ9oQmLy1cJ5xjv5otAYULyXLxM3Kt0XbZf0iIK3kyQaduZjP1J/AcShNgETJ9cuHTtnt6H+t5LZHj3M9JRkMPdJTly9xV4inHj5Ed2yl4aeMLKQ3rF4HkVzRemR7HeODZ+7t++QeygS/ckivyiwHxQu73BesyVBBrKlpEJPj0/maJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6MxUbQk87oY0mdA1u518h8MhDeC1oSYgwR4LDlwAiA=;
 b=AIvQW4BZpH7iKH6CtuMelT1b3d/TYvU5cdOJ43qM4AtFoRqSrKGm1sP7iuhIJiqf+wgKPnrWrpa8OgS6YXTQoIBkdJgOlNtQzaksNtYjC+fJaEtlhomcZfqoBxNi+AeS2WoE+wndMA4V1sIJ0ZxmxqM7EDIYyqGYPk5uiTsGaRE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:42 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:42 +0000
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
Subject: [PATCH v3 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v3 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHcgYoMHBJ9pbE75U+CUudUFu/FEQ==
Date: Fri, 9 Jan 2026 17:04:42 +0000
Message-ID: <20260109170400.1585048-11-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DU6PEPF00009523:EE_|AS8PR08MB10363:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad58f23-3919-4b71-97ff-08de4fa15479
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?jOgJW/Pf7JxTVXYc5mfDRklaC7xetWPwwNlnjLPvAm6QPs+JnshQrjJQWG?=
 =?iso-8859-1?Q?Qe1+bNFJATwPYdQvj0voPfzW5rihMmi3NIrM8n62OhiwZMrrCv+Qe/OzBx?=
 =?iso-8859-1?Q?zmoP67GjYG5O/M5ST7H9ZPCjHBwp7yKe0RGGRdx53fTjB15gss6GxrLqqZ?=
 =?iso-8859-1?Q?xyFdQJiXfh6AXrjCRnAw88DJlM/sVBOVcHHo4e8/WlmSRzklD6r1DlWbZm?=
 =?iso-8859-1?Q?A7kIbBThdzdtccH9fZvM93P0SmV4a1GklnliniIP8kxU3rmzJsl40ckgMj?=
 =?iso-8859-1?Q?7SFU8d2mrUbvfT68gihHBxfTURcY92df5o0zc97Cl5B3pB98im2nKYnSg9?=
 =?iso-8859-1?Q?1KFa4HOdDxc3EiLmmW5/6aiAq2qwm2EHarqY57Jiu44Bo6QJThRXdNz+VF?=
 =?iso-8859-1?Q?rQWE9We4ep7WFZEykxpuM0wCNzVsqYZpGdw+pj+DrdIR7EN/hLARd9FU2T?=
 =?iso-8859-1?Q?wxW1JfLOdh9ONYLKtkrtoDddtfyW2oufcfSwtmIqPgsPN22eRKNTDe5C+J?=
 =?iso-8859-1?Q?U++04ONYXC/fpGjJc924qCI/XEiXRtCD7pAx1bxsrvQfe0ys6msUt44rOo?=
 =?iso-8859-1?Q?/lonLVIulTeeC2t1LnxBS7cHiisuOJp6/+Dim/7pgdu914B5duYhZpEmTB?=
 =?iso-8859-1?Q?So7J0cPw9RgxDUlfnh88Sh/SccQ8Bg2Fn/fjOlQpQVWEXE3t2tb6vyTIM6?=
 =?iso-8859-1?Q?jv9cK5PLzEVpU6srKqclOvQOmtXZhlVLfpRoU3fvcMZIyX0VgqtnZJlucW?=
 =?iso-8859-1?Q?tRpIH2YxtcQY93OFZXIsyEWeFELSP9xr+51x/7HopcDKOQU+u05SECh8Dl?=
 =?iso-8859-1?Q?9xU17Nx7/YUOpUDYdpqOxFWvsZ4FaFBOgyHGgSPxMXA8s22+ke0rMFi4t/?=
 =?iso-8859-1?Q?sCv/Z7B/e+YW5WSok/iRkWnu7cwg56ISmWkmLzHarhVrSxbjID4LlQCMH4?=
 =?iso-8859-1?Q?tgWd3yyD+6yAEE7iX/THHJaDQhMgWllEN7nLP759wbaAQUco05o50sue70?=
 =?iso-8859-1?Q?e9PyFJIwxKiuULk0gHJA2KptqNZJU2L7X1SKcGcefzqEFtwu8RICqYvTy8?=
 =?iso-8859-1?Q?OB/z3d3R3ixl0gFm6ZgJzfvYlQcmWOQOFAhB0rPD1LR7CYaqHxcPkE6iMp?=
 =?iso-8859-1?Q?A5y//1r1CQ2/Km1oJHGQwZwWg9hpX44FXauPAYRtKq9Lrr/cFRwpUxcjAc?=
 =?iso-8859-1?Q?5X2Xxa+Bbk8X49QX/XmfvEQki8zBfZNkZWUB4JpeJCuI1g2bcuKxCvi0Iu?=
 =?iso-8859-1?Q?AETdFBIxVd35ZnyIAVQFvxnFDekFP478qX/AyTlNyRuUo4oG15wt1ODTah?=
 =?iso-8859-1?Q?oJNx3ujlZ8sV5cXOGDI3flbk11qfhYJ7GQlC4ARAEko3gKHaugZs3vBGCV?=
 =?iso-8859-1?Q?B751PRvo2mEgUioWNwKCr6NVhAcQ8oSsRsv13O44kp19O9z1oPv22+vj1B?=
 =?iso-8859-1?Q?3gOOnjO2crmB4TXEY7O/YbJu6TuEXZHS5EwTcrMYLtXEIWiQmOpIqM0MFb?=
 =?iso-8859-1?Q?kssvHcKBku9XDODmqMuh9Om3RvuIXjUdENi8uwnOSx6s1cFvPCHa1dmkd9?=
 =?iso-8859-1?Q?mNYojjv6XtfGfM9PQXLno1qphfUK?=
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
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	de9fa136-3356-42aa-2bb0-08de4fa12e95
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|35042699022|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Y7QsBuWh+2plJOZYIJz5LqxRhc6yhPU/gMXvHEvw1LT2n84wJiJUu9MnBV?=
 =?iso-8859-1?Q?X7uP+q8WRO4zT/OFsz8FZ5G8FdCgGJutOKG6I67QVtEQcGopiknw5XwRut?=
 =?iso-8859-1?Q?3QSRgYtJA7MOrcbUTG76+gIOG2mmKFUAgU/mZ+9Nn1twPINH7xu9dpxSMO?=
 =?iso-8859-1?Q?yPdgz/TPyJkKwIdKhJ7edPvy/N6mhA9KZcmuViRje1+vKVV4eVT9k9JRMG?=
 =?iso-8859-1?Q?JwVF7vCU2290agaPuHxvEfar7KxOe//NZDiiAuzy/bZKhR45wJoEwLWqhl?=
 =?iso-8859-1?Q?6M0fqfx6QR3JylvFBYEiqjK87ndyoAMph8A3M9tPvwF7XtEFU45lmWhVg8?=
 =?iso-8859-1?Q?C+iQ21CDQVKP8WfY7AlT12J9V//0aDeM9Q7WCF4Rir29364OqB6FtU1ex9?=
 =?iso-8859-1?Q?clBROJCfB7XG/KlDJdOsDeAftFy28qrm2DHCJqgEk7bPDo7ATgmLHDRuA2?=
 =?iso-8859-1?Q?N3txgkbOSUJJgIg7FO/XGZoWASgCUw7qrkVJCLXaH/xkQAfvvZERVm4gpB?=
 =?iso-8859-1?Q?nlB/HcIniETb1H1CNM+iy50+5Vo5FgPMRpH0YjGykGFVhGUSOLGTJoERCa?=
 =?iso-8859-1?Q?b1DlGzZ60tl+em4rQRlHndtm40c/1qkRZ5784c8l3WQlntIl0NUGGBTimH?=
 =?iso-8859-1?Q?ff4SmnP9gw0TJreve3DoiBPl/SzmPQ9tuqcUEyGrws1BqCKQ1xpV5BOWHV?=
 =?iso-8859-1?Q?PjUpmAFpE7i559EA4IDypyceEWzU6k8DAFEDUpfNyWf6dwCd7vwfUJrlhF?=
 =?iso-8859-1?Q?KZq1EsQ/u/HYchnCsX8dhaQAokh/L86sKaUjWr3CrwUTi/kM9jdY6px7C8?=
 =?iso-8859-1?Q?PnU5QWnvwTUvHxYUNpAFT7jBOl6UDf7+jkB06lVPDcVCJW1zzJhPbGaYSP?=
 =?iso-8859-1?Q?uTF6kqOQ7p9OaeXqHTCCOrI5gqxgAbVHkNjx7mFjUBqdYIcBn1VoMuzq1V?=
 =?iso-8859-1?Q?xeluk+bkCwS9d4QX2JUvydPN6foBpO+xh1bPdiLBCFXIqt+MUmFdUbyJ26?=
 =?iso-8859-1?Q?t970rmupuKR/7eU11m2aejbs4Rxh+xc/U2++LTIEEt7lhLHkzH5EkTRex1?=
 =?iso-8859-1?Q?1ntP8IqZcmOn+Dx0W1AS7FpZBNbuukg7gUZSxF1NVzDFKVksWJondrcpIZ?=
 =?iso-8859-1?Q?QUpLsyzgVcaUWoWwuI0m9RIkf+sqRlQeDTErZvzI3D2SFSm5wfl8Qp93Mf?=
 =?iso-8859-1?Q?+AeJGzEJeRSRA45K19MQ9nZfqY6/BHZ0VwIYaGWMDAuWJ6boEIf7pVNwSc?=
 =?iso-8859-1?Q?lga3ZVmv2/d2SsqZSiEJNc3lmSDd2gTu14DD/KmZnqRbjqke3TTODphVnX?=
 =?iso-8859-1?Q?HmW9ETvy455XL9pKSrTny2yHaP2W7dbgtZYbLnwfiKscTqtF1G5WE1aVZE?=
 =?iso-8859-1?Q?sSTJtEGlpE1SuWqOfEQ1Gh5kFqBqC7YzIweAHeAdZuKxBjwDoVOka6ARjB?=
 =?iso-8859-1?Q?WZ34i90Rkx8B49isdUYuNIQWfVLOFtqeaPgtPhX5k9T2qbRev1Qy2XoZiG?=
 =?iso-8859-1?Q?ml613Aq5xPRRqiS33ZaGukLTNEUev8nKY3dQLoYz+Rn19z9uRSSxDnfOMZ?=
 =?iso-8859-1?Q?S8gEjDxNC+vnAvg7CBSfMijT7ZyYw+Xavu2MGt4M1iYSqBRJPbppy4OJLH?=
 =?iso-8859-1?Q?/I5doZVs8iqtw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(35042699022)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:45.7648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad58f23-3919-4b71-97ff-08de4fa15479
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10363

As part of booting the system and initialising KVM, create and
populate a mask of the implemented PPIs. This mask allows future PPI
operations (such as save/restore or state, or syncing back into the
shadow state) to only consider PPIs that are actually implemented on
the host.

The set of implemented virtual PPIs matches the set of implemented
physical PPIs for a GICv5 host. Therefore, this mask represents all
PPIs that could ever by used by a GICv5-based guest on a specific
host.

Only architected PPIs are currently supported in KVM with
GICv5. Moreover, as KVM only supports a subset of all possible PPIS
(Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
present. The timers are always assumed to be present; if we have KVM
we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
always assumed to be present.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 36 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  5 +++++
 include/linux/irqchip/arm-gic-v5.h | 10 +++++++++
 5 files changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 86c149537493f..653364299154e 100644
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
index 23d0a495d855e..85f9ee5b0ccad 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -8,6 +8,8 @@
=20
 #include "vgic.h"
=20
+static struct vgic_v5_ppi_caps *ppi_caps;
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
@@ -53,3 +55,37 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+/*
+ * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
+ * ones are, and generate a mask.
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
+	ppi_caps->impl_ppi_mask[0] =3D 0;
+	ppi_caps->impl_ppi_mask[1] =3D 0;
+
+	/*
+	 * If we have KVM, we have EL2, which means that we have support for the
+	 * EL1 and EL2 P & V timers.
+	 */
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHP);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTV);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHV);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTP);
+
+	/* The SW_PPI should be available */
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_SW_PPI);
+
+	/* The PMUIRQ is available if we have the PMU */
+	if (system_supports_pmuv3())
+		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
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
index 67dac9bcc7b01..8529fcbbfd49b 100644
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
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 68ddcdb1cec5a..d0103046ceb5e 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -24,6 +24,16 @@
 #define GICV5_HWIRQ_TYPE_LPI		UL(0x2)
 #define GICV5_HWIRQ_TYPE_SPI		UL(0x3)
=20
+/*
+ * Architected PPIs
+ */
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+#define GICV5_ARCH_PPI_PMUIRQ		0x17
+#define GICV5_ARCH_PPI_CNTHP		0x1a
+#define GICV5_ARCH_PPI_CNTV		0x1b
+#define GICV5_ARCH_PPI_CNTHV		0x1c
+#define GICV5_ARCH_PPI_CNTP		0x1e
+
 /*
  * Tables attributes
  */
--=20
2.34.1

