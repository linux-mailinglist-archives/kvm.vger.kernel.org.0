Return-Path: <kvm+bounces-66364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D047DCD0C19
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C055931098BA
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B6C3644AF;
	Fri, 19 Dec 2025 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TGuaEa0F";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TGuaEa0F"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011006.outbound.protection.outlook.com [40.107.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A758362135
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159638; cv=fail; b=XDtvxLoHUfxc7/NOJbdulwQHWSpnoTJ4UL9PMdZ+yLP4o+++bVQikZYuCuaGp5IGuaWmE/7RdoxrfSCKzJHSme1PVL6tFa6KIexdU94mm3G11jMYOagV+bBGujmfKXafx8P0pjCKcDmyC9yvy3iLoZk7zIifTRLahyZNr0/u3Mc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159638; c=relaxed/simple;
	bh=2zMDeNFDLn08xXCYbXOGDRD2BKOcqrCQbsdwhEWmTm0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VH9ngi7GqVK/yXL43TJPmw9fIzwnmd2BYcPwqdRgxjsOCTUCWZ/FQ4wrInHhKxIs1xtdfcVPmfDoifvSn17FvJtkf+GY4s964gPkbe8fP33GpBJs1rOO3QQdy4HgqENx1YYN9JBN5lG3SPl5PjNNd1Dv8gPkz7T1P+aa+RCx8Qc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TGuaEa0F; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TGuaEa0F; arc=fail smtp.client-ip=40.107.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ypol1U6hOhm3xXn8oOJnWELGeOKPqNYPTmw2G6T8s4h/be27ynbjFS5ynSNkkHVFvHfJixcKHE0ldnhSPenJyUrtoxpUD2W0ETA8cA1ZIplNlEwOdg6wLBA4hD+FK0LVc18qQk+kUDph+MxL+SfTrrPZFeVsDerE+dI2V27MwpeoU6rpjLt3WZlF1PY5OaMM7mXqhWfLkvFaNd0z9Bmr3hbYUKaRK6+rBnAgC5v7HjgcBTSHX6n4XCk3gQPKhNB2ibYUOKqaixpl9fOHOZjiDcRach7Nw8RMTTCq5+j6addg5o3lRcaVnyayfPYBrJjOhpiWOq8hZkEaVhKN/6chWg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCRWJMvEG3Qan2u1lUwOBHjdvVcYT1Ry5UC8mABv9XA=;
 b=QjlSnnXjc8TfNVjoXUXT+cJzOwXEP0DgLF2b6zFQTq2t+pBaiMj75E9L56qp1EeQcxc+nr/utX69oc+lBTpBHkwQt0SUgH2byhjwSgT76Qp/hH+4GM1FJDkrTYcCr6g1hiIN/wpjUTxKQNPdTuBTekPIRcCtGM4wFEbZAU4JzTOZSt5ZmaT9GJT/UlXT7pl5osIqwEs0CE6uBJkTcybGs0YxXVsDym88qR8RV0OvHfkDG6rLH+m59CuzNBLVKv04eIGHNb4yYvF9g5UpqtcDi14adqT9rZSX6sWNpBEOAiSrr/Jy8lrbnm+5Cwt6znscKr6IH41aWDhoYG5yzhubcg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCRWJMvEG3Qan2u1lUwOBHjdvVcYT1Ry5UC8mABv9XA=;
 b=TGuaEa0FKfJDM3IyoU+ekZ8Fy1ViDAdnkNVrCtxINC7Yj7HIIitX/ZhG5cpO5wNnG+VXOLNms0fET3sYM6d9lc2/zB6XWS18J8X4WpXeTj0niIejVrxb/TvIjVt7hQ/r0dbraFbqJX8EmAdPOY4+GOLpsHfanlvIZQ4j36N0YEw=
Received: from DU2PR04CA0218.eurprd04.prod.outlook.com (2603:10a6:10:2b1::13)
 by DB9PR08MB7582.eurprd08.prod.outlook.com (2603:10a6:10:306::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:48 +0000
Received: from DU2PEPF00028CFC.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::cd) by DU2PR04CA0218.outlook.office365.com
 (2603:10a6:10:2b1::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFC.mail.protection.outlook.com (10.167.242.180) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6qZB8vj+A9c9aeJbFxLnrJDhv9RcR0XZyZ5lfbD2BRBtvCpzmQPhsd4HBsimNpeRWWq90miOGU38MIB9toBxARRWHCLrKIqfKAJa8p42zmdgOcrp/7aYyzoKLUaJ0ouyk3kwzqtW47G8vPXdd92fTIgfAZUoI4L+JdEjSArshDB4ZKs8Rclb2XPsnlX59tfltpMUgRCiBbpQYLfLLvgEUQpei1elfWFRDnt5DsMmZIx6KnerCrdSsSiADa/Uh1eXCGIJn9miTxKnwqTkIbmLHf8hyqN5WRuCdd0I4kvEopq1CMjhkFk8V66ej34fY7qQ3dC16q8hwR1t2X4B+JkdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCRWJMvEG3Qan2u1lUwOBHjdvVcYT1Ry5UC8mABv9XA=;
 b=zEkB/yMS658kBik1KcKgN+fRogXhikgiaQa9hDCsSUcqWoH2+5+McwzPBakmmE2kiSLrl147r+U3xw3NNw+4JGD2huP+NW3GTmGfticXtu6xpXkNxvRs03jfHPlAMjSO+YNTN9Lt7wMqSL+JdWOvOjoZWC+P1ty7xuDMXgouJtgMybYo9dhe1DMHXcCZvg32l9s/guEZ1XiLHfk1sviaClEIDlWLoBoBW1xbaEZsAGLfC4p9ZjO+QI9NI+la/qsBDbpd0KLfrfTqFvg3ikbLID/g96HD57aqNobbt5ATve7NGBGkSWo7cVjmwfQ4vJIt+uG78GxElgkq5OpBtIZyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCRWJMvEG3Qan2u1lUwOBHjdvVcYT1Ry5UC8mABv9XA=;
 b=TGuaEa0FKfJDM3IyoU+ekZ8Fy1ViDAdnkNVrCtxINC7Yj7HIIitX/ZhG5cpO5wNnG+VXOLNms0fET3sYM6d9lc2/zB6XWS18J8X4WpXeTj0niIejVrxb/TvIjVt7hQ/r0dbraFbqJX8EmAdPOY4+GOLpsHfanlvIZQ4j36N0YEw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:42 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:42 +0000
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
Subject: [PATCH v2 16/36] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v2 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHccP+CoFZT2ZyfTECdJrBWZTh1fA==
Date: Fri, 19 Dec 2025 15:52:41 +0000
Message-ID: <20251219155222.1383109-17-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DU2PEPF00028CFC:EE_|DB9PR08MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: aaefe839-89b7-4e58-ffaf-08de3f16cc20
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?n5JBgXuu1hV8WPA+f8d2ur6F3fcgt28avX25Fomc/0tsv3WoDULMkGItdc?=
 =?iso-8859-1?Q?4DCHiv5GDQ/IgMPRI4em8yEaIaWOPNk/s/Ip7LryZH51L+otqFsuX6PumW?=
 =?iso-8859-1?Q?VED/FAGk1v0yy3IOOELX22Uf1UOLHW56NKtoHZtFACZjNucBUURs0o9smI?=
 =?iso-8859-1?Q?J+dYoDqe6ZaMsdE6pAxatoyPAUn555NEbKAR6acZ0wcqLpS19s9Bo2/9Q1?=
 =?iso-8859-1?Q?EQg6emD8aB3x5Ci2SGgvNNlxaWHZDJhstjPSRIG5b4riX8OVlvJwWvz4DR?=
 =?iso-8859-1?Q?URLIfYrkdNJsyCGhLA+31y1SoUjQcwr32Vp4Ve6z6lZXd4BP8dJ8Djhe7Y?=
 =?iso-8859-1?Q?hGLMCAS0qDrtjHm+5N2BJ5oRnFip+hcingwz04jJSxuIL6m/Vy/HqM/XYc?=
 =?iso-8859-1?Q?/iwub+FAODS/O6JyBSqWwNQYvdadFh81+JNqgRA4rGB+D7pX9usMIoRlWR?=
 =?iso-8859-1?Q?3zsK2kz9NsltwGK8PonlUoGtk6pUt//ps0aldQ45jj5yJlepCaEvuiT4uj?=
 =?iso-8859-1?Q?4U0Xzx44GeopBTTGYddlrqp77AoeUBy/uP6eXbdtSIrBWEM50GUl49cn63?=
 =?iso-8859-1?Q?rUZWyBirukhbYxYM5U2i2O/gnG5PeMPHWJ45K0oHESfRaGAfq/NPf70jKg?=
 =?iso-8859-1?Q?2j2kd6fLLtLvPO+caJ5GZ33OGTPqGbcST5YbzE2QrZS78etxf8PoKRuiDL?=
 =?iso-8859-1?Q?p/IwxRXmK0HEKnlK2xSnNyNWWvGm05agDf2YbESRHmR9fQG7qWf84Wy9CN?=
 =?iso-8859-1?Q?VV1hDMatitvb8jtd+pMP3jMtQzu72QVRQQ+xDcYUWfiTfrTBRd+G5vcvo9?=
 =?iso-8859-1?Q?FXMogDXwxKHg/7IinetQbCI/LX75QJ8Gc7/Y09qGjf8EzcierPDmmH4CHT?=
 =?iso-8859-1?Q?s8Pul8zUKTO5ZuCxg2qo3MB6UtdOWQwgtSnhtYg52K3G6BU+PT1PsXD+xY?=
 =?iso-8859-1?Q?kyIE8nOXSZ/5KP+YuBk9j3beHZAiLCOiY2Bqv8TXDgHDQRYk+wroA8Vy6/?=
 =?iso-8859-1?Q?GkryCBJ2SZuENZxME+qcIny3SVBQLX/Wv6eNi824PoL3VpRHzEhyaddoHP?=
 =?iso-8859-1?Q?vB//wTdp/AxJrTTAAEkfwd3ZikoVJXYMYOiFq5Fk2ioG9WVx8IRZnRDf/W?=
 =?iso-8859-1?Q?YO7hYz8w0bJqoMr+taPUSwLEHvXLkefGv6Q+KcAR735gj7UwUkEr2vqYJN?=
 =?iso-8859-1?Q?FZHCPIpEDovfYjl0YUT+n0TYXMYR3OfnDj+NS3e7DJMuExmHoo6vRqPpyx?=
 =?iso-8859-1?Q?E+4AURLC56yMi8jWBja68XGIdx+I/tBW8pWLBbKIrF4WUp4krkhiczehFF?=
 =?iso-8859-1?Q?iQ47ZGC1LVoYC0AQtEJ8O+wHSTSK4Rynapy7Eje1iJ7eq0E4WBPA8SYYlm?=
 =?iso-8859-1?Q?Ah3FBGoo8oLE6lmWnoa5A4MX4FO+dblXAGQ38QaehgZlXfoeNF1kc5VRdK?=
 =?iso-8859-1?Q?0P+BGm46h7Qq4Q/CiPQFAT5kay1Zyj2tvHKT11UZ/LHJ+9PgIsY0AJyoY1?=
 =?iso-8859-1?Q?EWe6adCwCRW/mPq9zVbbW898yi3rJIEIRPfONyUJ/T/uY0NXWhOtlLhFS3?=
 =?iso-8859-1?Q?zOCQ0/JGx010UIfpfVBz6ybuVASL?=
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
 DU2PEPF00028CFC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ae9f2bff-3c49-4de1-2d34-08de3f16a51d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?PxsC7P85XBhONSp2J1BUz2x+I2Z/gsiWsVBUuBhRiYbSYQv7BdxSjSgVfI?=
 =?iso-8859-1?Q?WTgFOPs0meIHtP7gtNtiQn+I5fkd+K/zegWI4nm3XahKZGdhApc0kpIDk0?=
 =?iso-8859-1?Q?swCwmRoeKfcOToo9HL27uBcoOhz6+u/lEfyVh4FeO9vMyWWL/G6txjPyb/?=
 =?iso-8859-1?Q?rxhSq+lP9pViS+yDiN5e7Uk8fYqugqWBCxE3giRZKal5+V/s7nm7y2oMGl?=
 =?iso-8859-1?Q?TcuZmjTNeWIxZRWb663JIcDiFGI78eWNtHawD1P/3JkdVJYv3j4QGyhFx+?=
 =?iso-8859-1?Q?AF5Gad28HnoBYStgyECsubdAIll9b2MT/F3G7+83j0gTdT4CKbP7tys5Hr?=
 =?iso-8859-1?Q?d8cRiI2tjdVakJ1R4ghrdf2GmNoWBHvaN6dVv4zvcul5vEdaLo1WXA84+4?=
 =?iso-8859-1?Q?DVLwh7egRWcT01Z5HlYH5mO/RVbwDObDXiP31JIpsEBAuLHxF9Myd3uxCH?=
 =?iso-8859-1?Q?QxtrDRdAfxoImMlBLCjIjWYaBcqPDfE19Tea2E56wBFHVEkzznXewxm04F?=
 =?iso-8859-1?Q?X5IU9Z2NzypiRQR40CxFR63pnNsGAe8plPFynfX9+n5QBiJ+nU+uj0acqF?=
 =?iso-8859-1?Q?eWS7su9Oa5JLc+8kzZvxbvpfw83qDjQp7sf51mynqJnkgSAMi/MX/sUaS8?=
 =?iso-8859-1?Q?A3crKzDGYy2OklW5qZX08EBhWa99AnE5lTsVZeisqZpKXMQRNTLGS4ZRJj?=
 =?iso-8859-1?Q?2cDjABMoA71tro1zW30m1DJivhXH//fYEx+ekFMF2fHIA/u1WLj/NFcllJ?=
 =?iso-8859-1?Q?dzYrXN6mmyFfCah2J4dhSOqTrEy+l5Y0JTsaZ7p0YIzW929MO5wXMB0m4Y?=
 =?iso-8859-1?Q?VxtIfPy7Ohb77wCYKtLLhAD4WYC133LfPH4NeyxUrSv1l/PK0RQwczVBXj?=
 =?iso-8859-1?Q?bDYmVmPGgupwUPStU+LMv/rWzaKTvP5aDZxLIwcBg3nNfl25WZ77Um1SkI?=
 =?iso-8859-1?Q?BXmgxG5EDxXEi9O9ByBerIq/O2aoSYwv/d9gWzaKeMcYDOQq2ItTHplHCA?=
 =?iso-8859-1?Q?xcg+lOZ6KX4RmOdvzqWH2hMZsq0bmStT29M190xxHtPLfpfY4cgMcbe3tC?=
 =?iso-8859-1?Q?0If/kgc7psAAg9PwziVn808g6TULAEILrbHB8tTAfVEKCsRGWrpSkd4FRO?=
 =?iso-8859-1?Q?bYZ7NuyxiKQTDgi+2BGzU20Kmt5O6WKHc8oy0ANmZaHXRz5Lk/NJA7FzaA?=
 =?iso-8859-1?Q?b5fMUmWKbIP2aGreIRY7QnCqQmCOFy0x9Cv4oxeELib+qrC2txMWNOmOl2?=
 =?iso-8859-1?Q?NN9QCj16nHwf2LJwbbpL/OSwjnwYDCrz+87BwGcIdt5LOp2VYyxF2WB3TQ?=
 =?iso-8859-1?Q?5GQfCDyQJhRsdjb1Z/of0vPpRZHaE1C34huggTO+6SFYDD9ypHyRQJtJTM?=
 =?iso-8859-1?Q?FodzAj8ycAM1rz1xCLsFvjjqWwRzWrFGfOX902z4wEBg9S8IRd0Z3HKXDe?=
 =?iso-8859-1?Q?2YjVFPfa0oqHMrs3f+Qm3J7jXFKS97/Cw2AOKFGvJjhvf6UcSFHJ0d2Tmt?=
 =?iso-8859-1?Q?PBcI3zI+zQdYc/MNslL9dJNCbsF2pIEYBVMW12bWM4yhUT0Enn9iGyIooJ?=
 =?iso-8859-1?Q?e3YsWRv2MNGqyBFBJqCZkDvljpJgMlIvSLHCYSBbqoR3Uh7Z6y/oWtT6De?=
 =?iso-8859-1?Q?svOBUaDoxo8rU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:47.8564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaefe839-89b7-4e58-ffaf-08de3f16cc20
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7582

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    | 13 +++++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 include/kvm/arm_vgic.h        |  1 +
 4 files changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 168447ee3fbed..46c70dfc7bb08 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -83,6 +83,28 @@ void vgic_v5_get_implemented_ppis(void)
 	}
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi =3D FIELD_GET(GICV5_HWIRQ_ID, irq);
+
+	if (ppi >=3D 128)
+		return -EINVAL;
+
+	if (dvi) {
+		/* Set the bit */
+		cpu_if->vgic_ppi_dvir[ppi / 64] |=3D 1UL << (ppi % 64);
+	} else {
+		/* Clear the bit */
+		cpu_if->vgic_ppi_dvir[ppi / 64] &=3D ~(1UL << (ppi % 64));
+	}
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1005ff5f36235..d88570bb2f9f0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -577,12 +577,25 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
 	irq->ops =3D ops;
+
+	if (!vgic_is_v5(vcpu->kvm) ||
+	    !__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid))
+		return 0;
+
+	if (FIELD_GET(GICV5_HWIRQ_ID, irq->intid) =3D=3D irq->hwintid)
+		irq->directly_injected =3D !vgic_v5_set_ppi_dvi(vcpu, irq->hwintid,
+							      true);
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->directly_injected && vgic_is_v5(irq->target_vcpu->kvm))
+		WARN_ON(vgic_v5_set_ppi_dvi(irq->target_vcpu, irq->hwintid, false));
+
+	irq->directly_injected =3D false;
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 	irq->ops =3D NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9905317c9d49d..d5d9264f0a1e9 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b9d96a8ea53fd..17cd0295b135f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -219,6 +219,7 @@ struct vgic_irq {
 	bool enabled:1;
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
+	bool directly_injected:1;	/* A directly injected HW IRQ */
 	bool on_lr:1;			/* Present in a CPU LR */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
--=20
2.34.1

