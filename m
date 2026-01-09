Return-Path: <kvm+bounces-67619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9356CD0B866
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 867BD3022F2B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E003366552;
	Fri,  9 Jan 2026 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dCeVFGyV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dCeVFGyV"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013067.outbound.protection.outlook.com [40.107.162.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779B35E551
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978392; cv=fail; b=W60+xB6EVJe4BxpH4epjYtI8bTh2YANaPj829UP+WZunj5slHqnQT0W1SVK9YbSAHyCIXzeKYAjAHQmh/fcFyJ31vSDEpF2fsLmCzoRGkzf7CA7lVMJ3zyIZLc7FPw1DttHVEIiiwcRIH9BDa4DGTbba2ahdAuTv62TroV/+dK0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978392; c=relaxed/simple;
	bh=xcKr+GCQeSVCon/8vvY/8YGeJHcCY4SDVY9Bm2TcTak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EH7ydasEM2eVpdsQE5zk03tyGY94dIBHAptePcbD7wszFgBT1bzVivXFzRc4f4ppmhDkRlC++tPFqoSbGy5y0Vd29au8zqSxCI72T/u4W/GMXI7Q87LsHEuA7zEgBdBqzqTsK66oGFKSQMGHR8MJ+XE+EJJaHoNCIiFuLSW6Pdw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dCeVFGyV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dCeVFGyV; arc=fail smtp.client-ip=40.107.162.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=T0FhnhevuL135f1nuxbFmdT+B9QomsI3JukHOdMITaxetKsMDULlDOzUJXYm2WPBU3EuP3Js+oN0z8V9ZmPCB3aal78MbcpqnKlOyXzUt2+t2njkmGWbP1lCewbRpcr2FiCNFCPs6csryEhV19T41Ra2JfKWJ7IX/lUBmE0HoYRtuR4VNgZgKM/mdblQsDJ0w3VsRTaUY78degj3WcbYm869K7WhqHjOm/x5DhCoOjFIdg+jKdkldVx0u/qT7wWVK5o2HBMTKnEKMOEFxyjNy80C9gvSIfbEuDEJvUz6beJrGXhYk0P4+i1VDZ+Cj8EVLC1a7zvKl8hHrKoLbXabKA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Km6U4YBlS/nyn7ARPFzfkHsrTplXH3HvKw3/vaoCAtE=;
 b=G1GlE0Uzqxwsq9vdr4xE5eQZS6r8CznrKjlUkn10OiMuX4c6BmE3kaN9atM0/6JmSFfUhmEjp5Yw5+iBktVPgXuwGMNoJD0we5zqkuxZe5EfPRH8rp7xxlod78vJ0MnDKq/YbKvoHMEqEhnjyN1pLBG5I59+K0+S6kA25iajbEIZflzKJZLg/UElNJByC5WjadfZpmTnGFgOY1JUVQpZ4+G7uOS33B1TKkycHQrxnHwuw2P6FkMxUMTfDl+BWDrqc+HraKrgTibtPU9KKGEkvzB1Xa17tvIlMB0mnfkqGH3Qu2xhs8u9cnaTTvtOZ63vd2aqAjhd8j8p+bx8Rl7qtw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Km6U4YBlS/nyn7ARPFzfkHsrTplXH3HvKw3/vaoCAtE=;
 b=dCeVFGyV15xpT1KH4QKZwX5ZsQ9VMX+5A83cn9vDRhkdr5Pd5iytrioRDilRr/xyTaTl2rY4oaz2TYsamDSEYocK1k85yXqHdeyje7+6VAZF3tdCANRWJFs9p4wILasEyC5SBlEVEOCk4ObgxF+0755LCGk1sDWfxcpGM6HY+ns=
Received: from DU2PR04CA0172.eurprd04.prod.outlook.com (2603:10a6:10:2b0::27)
 by AM9PR08MB6132.eurprd08.prod.outlook.com (2603:10a6:20b:2d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 17:06:25 +0000
Received: from DU2PEPF00028CFD.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::6e) by DU2PR04CA0172.outlook.office365.com
 (2603:10a6:10:2b0::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:06:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFD.mail.protection.outlook.com (10.167.242.181) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:06:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGUmoE34K+D6ZTQadERUMIAN0lAHndHPfbZaGJ1PzrzsrFpmeJ3XD0bUbe1n3DZ99ZzR5nsuV0DlDSU7OUdyP8+5sFUtAWpv/tEQ7DfJjvxZpaNUyzPo+jeAfut5o/L26QqZSJrqiBtgcoq7UtdSMi+OQMUaWx6nS8Q/VXR57TLHQHHil++wPVIbX2z9RS38VD6n9nQ9A4u9gLw+RrFMbK4l4KIeDGmwgYpZdnqaEcIwMO//EYwYoxMWrky9nohKDLwsxxgq3OTe+v3HYg22Q+OjN3mqwX3uxHdUIXq8hcjrPozVz3TZAxA+0Dk69Uf5LjDNINxTJoJz5x/1vFuErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Km6U4YBlS/nyn7ARPFzfkHsrTplXH3HvKw3/vaoCAtE=;
 b=MJcN+i99WWKmUPIw9DUl3cA/pi9FedkHNceEEbbw0nwPfZuw6mE0/Z5UilQueekKYs3MCkp+r6KemNkxFzD47sJ0Vk7krr4E49NBtlNzA87rrZ0mWYUfMwxS+TRsIgrTfveNST4RhcGhxt4NJyxvQNTnSt87R2ct9jwlJ2klmg09Rb8YdtPj6dA4oW74EEoigXe+hMnKcWAOJYQgmC1iHQmkm5pS7me/fdeaVGmyrNQ+/0sKTN0o426CGGXkSESlQP5CNkxtg1DH/StpBmkXcQQvyn6NaMSjtdOkGA7sDyrlH1Nii0hwdlZpnZn0zATKqCpm8zYCf/hAHZf6skbtoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Km6U4YBlS/nyn7ARPFzfkHsrTplXH3HvKw3/vaoCAtE=;
 b=dCeVFGyV15xpT1KH4QKZwX5ZsQ9VMX+5A83cn9vDRhkdr5Pd5iytrioRDilRr/xyTaTl2rY4oaz2TYsamDSEYocK1k85yXqHdeyje7+6VAZF3tdCANRWJFs9p4wILasEyC5SBlEVEOCk4ObgxF+0755LCGk1sDWfxcpGM6HY+ns=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:22 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:22 +0000
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
Subject: [PATCH v3 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v3 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHcgYoQepJuy6lpaUqU1zEWcLjP3g==
Date: Fri, 9 Jan 2026 17:04:49 +0000
Message-ID: <20260109170400.1585048-34-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DU2PEPF00028CFD:EE_|AM9PR08MB6132:EE_
X-MS-Office365-Filtering-Correlation-Id: 9deebe9d-64de-4b28-9371-08de4fa16c12
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Yg+OJ/3jkq66vGeb633rqcZMlSiqjhsRk3mjkHGupGE2QVZ8vuyRrP1p+7?=
 =?iso-8859-1?Q?nst8HnUA5BbILbbOQNOIh9uYPFBrMAMJFsZY/6fQ8hdJDcpDpKD6F4croQ?=
 =?iso-8859-1?Q?rmPl2MAQhrRVxWogLVIMJ3TITJaHvEsVMiZ+Xs33G1Nv6QfNTyGUySGJnE?=
 =?iso-8859-1?Q?Yqy+Y05MkB6s+/icgW4hsm/qt9cLSp5ppYk8DCFzas5OWDjjHM6i4tdIys?=
 =?iso-8859-1?Q?tCxF16cbWT1ThWZUqDAyianCjjjsGATJqrh1MY1A2SMGkaf36Y9SA0ulPD?=
 =?iso-8859-1?Q?Whf74O08abBk5wXjHPmnW6OGbWURQnjfhXc0CSLmK3tMIzEIJitfd8RF3t?=
 =?iso-8859-1?Q?l/exSPpG0M8G7plK4tfatmvnaJeeb/j8jgUs249Qr8e7ITZ1ehgYWrQUM0?=
 =?iso-8859-1?Q?efZ+G7M1Bc59Ejj9dafLOjt7zbt+NaO95EYaiQ9+EyGvQCvUhlFIazO/qH?=
 =?iso-8859-1?Q?sBWIpX2+EtzjpWuKhOZQk0QMR93ouzBwe5K4cbPlUZbM+UlLrsrxsoQhPK?=
 =?iso-8859-1?Q?niJN2V2pHBSLRkJSNxpAqXFJuaEVqDQEe6kmhaOSQ4PyWJbSt63WVR1Ott?=
 =?iso-8859-1?Q?B65KdXuWwO5HMfxRasKEPwjyhodeTHhqwbbUbpzW1FJXf/whsWyChaUXxV?=
 =?iso-8859-1?Q?0sdALHNu3W2UsQcTz9bwCo2nwzrjOCad3m8925GynZy9H98uiO/243ygSc?=
 =?iso-8859-1?Q?xVxFKPBLH4d7vnZgvI4Viy3sPn7q/wUaFchb+tWfkV3y5Jpo37V+O78Jiv?=
 =?iso-8859-1?Q?ty1RIWDbOe75PHwI5DS17taKCK4PgxPBU6lW5AR7V7rEkNlnj7uF5CqHqR?=
 =?iso-8859-1?Q?e+GudpjisTODp3xohNNoWj3HilEhFvUiNUtngS88+eDdcFlodCGr/J3OFn?=
 =?iso-8859-1?Q?4GH5gIch6kr9bygT5OS2G03S160z9AuAkKvL2Kj72JqFdmInbEHHJVlKGc?=
 =?iso-8859-1?Q?fMJ+nUzaI59grTutPCEZ+rPg8UqDoVidYL/ueG7rv+QSmt3dQu52IfHp5Z?=
 =?iso-8859-1?Q?GZ0Rzc8cq2wRT9Y2x88WHvmmPbhGBXj5xXPX4tHltGZMVh6cgopzIhKfyW?=
 =?iso-8859-1?Q?Q9hi1wD1B7/pHtxiiRYGoxKJ13DZ6oy5HEK2haZDI6089TmDzwJhVonAop?=
 =?iso-8859-1?Q?6NmTybAc3IQvtau1jF2wqEGsSwfcIIo/R+/tlmK91GQGgZV50qlkOogiPs?=
 =?iso-8859-1?Q?YB+0z8hlo/8CDNTICdl6fW9VkklcgayIqJ41RxRmsGqH3wZn1lr40UsJ2R?=
 =?iso-8859-1?Q?ra2WsQ0U1QNoYZ+09Fis+RUpDU+Qw6Z7KYxYUF3Yi4NIT41pKhXCkDYa4A?=
 =?iso-8859-1?Q?LmRaKnKUIuWBVCnUSAQsgXRhOmode8jyBVDTFMDnI4MPwhhaChY6l1Y4wW?=
 =?iso-8859-1?Q?TFiSHr3hPdWGaiG+YCqaJ1Umidx9Q3zZLDGsL7Jtt/CuvsnpVL3I66C5Io?=
 =?iso-8859-1?Q?Hyphaz5X5TP8LS7UKunICk10q/qu5J+jaLfbWsHx9NvbgH+ygHlcAt9po8?=
 =?iso-8859-1?Q?GQ4RZxWCVhqpo48ShPtfPgdx1aJnGk17r4Ov03eChsEZYbG75JsSe/1DW7?=
 =?iso-8859-1?Q?dQkgDrl5fbS9w6ZVot4t/fZR81pi?=
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
 DU2PEPF00028CFD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	196a8417-f1ad-41d6-8d32-08de4fa146c3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|36860700013|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Jq04hMwi3tCVK9/roP3pf390nc0ICqH3dUTbt8I9jcVkkAt0zF80r/bH7e?=
 =?iso-8859-1?Q?9NzbHO+KO/PclRzOPEFP/a+COdZR2Q+webwtdgeZCdF7MSX2fwF/NbWB+k?=
 =?iso-8859-1?Q?5Q9rz8OjIHtFv+KpAGbzmPQXFZlyZuV7sV7CGv7Q3o/QcUPmNyT78O+SXP?=
 =?iso-8859-1?Q?CwEkAULg9C0mk1scqGOkG3JoKEWuiUz6iJ9SaUDkTCtcTl5hEAwDChasoM?=
 =?iso-8859-1?Q?TPWLRxUwbPsrAmI5LIV6w5mWJGf0NpgMU9e8S6ilPmgwqtnN69tdr7lpNg?=
 =?iso-8859-1?Q?P1uG0FTSWHv0MKjftT84k4lYdNYd8CZ1PfxVldE7phAwmXLY889OVqmazc?=
 =?iso-8859-1?Q?fpmqlEsi/xzWnHq9Yj5V28J7GICkYSVRzMKJ5WxwIyHt9PTXSdbQ8em2Yh?=
 =?iso-8859-1?Q?KkDvPW5sHwfHqwiIJHToeb57ni/ubrrQ/qXyDRyW02oyS7NsC9izivAUaa?=
 =?iso-8859-1?Q?9h8s1ZV6SoFFFI+3B9E2r5vwELNY7iURfrQSwsN9+d0ejCQZyXynLvXNX0?=
 =?iso-8859-1?Q?+2MCNNlNbvxOMl8GwDRAxSJgRTIK4BY7DoahmRf4+9gWsLhsQqcf2OEN1Z?=
 =?iso-8859-1?Q?0K3bJ0cqRPqt4Zw0s37byldlws7k5LK5a4dn7s3RYJqsq18IBnr7S2gvzf?=
 =?iso-8859-1?Q?ZnlVcjxMMMjxCex9t75h/xYEv4SkAV3CYGaw/ONN+S5YjKlk5LLHi+rhxG?=
 =?iso-8859-1?Q?VJIoNktMI20LhF9nUSWv19v/Bj6ninNoPAmOk3Ns7hYFSkKG7z5OGhVRTo?=
 =?iso-8859-1?Q?kiJBrWN1quzHCLNx0hgkXKtETeU1SqvRD+sNh3DRZj+vjFZIRtGATbNLg/?=
 =?iso-8859-1?Q?Y0CpL1LtavENnjoDHwJDuReLV7Ce9242BWOuhJDPFvvubDIezberCYQZQW?=
 =?iso-8859-1?Q?bvgCtxMTAspuCHV7tXAJzo8ZWk16anHrmjreXYZRwtwR7QZ1M9Just7gnJ?=
 =?iso-8859-1?Q?iAV4FywQdKw5MBCCcZrZPlPtoQyZ238Et0Jrq+90U5nsNz4Ns3vIiUVzki?=
 =?iso-8859-1?Q?rPLgaD5qZUHC5pZo3NIhEVOMPquR4LYNyDr7u0USNPx9waasMxrl0aBIDx?=
 =?iso-8859-1?Q?bTiAVjgsBrr52EItHsJCYnZyOH6R4+N61DTU3zy2x/vb6C258Q+jBbD6J3?=
 =?iso-8859-1?Q?9CVfcLEh2yEj7v7gFondQXaLBLakMK8P93JKS2olGsI2iKQkH0gCdNWTNZ?=
 =?iso-8859-1?Q?Yr5KFCw4j+mJ6+m7HGH6VaNMDaD3EQeYf6UZc054uHOzVsMOesA5Z/40u/?=
 =?iso-8859-1?Q?DpUEQKC3OrpNxUl4/Ix0854lsgbo7BwgzXhKnCkST2PX91YwX+ADDYhK9W?=
 =?iso-8859-1?Q?bR//HNp1V8iYz6zAZcHBjkyNaYo4paSQG+uEwP/3gqN7pGzJlg32uILowk?=
 =?iso-8859-1?Q?rfFKh2Xoddhn6w5wn4p1B442nmLnS/S7QqfquRQriiGKRPMLmZ69EXyXtD?=
 =?iso-8859-1?Q?majHi86AXnoBrrVKHBz8xzz8/yjGdQVQ/R8yyaju7+hXM0uS4PCnf6anMg?=
 =?iso-8859-1?Q?j+GuhHvMMvRScy2n1prIi508JXuzslSfOBbbkYQgTPo5Ib5N2BwcPlwlD/?=
 =?iso-8859-1?Q?3zPAgzmVvV85+F/AMoMPrFheke9yPHrRmcQjVXA8+mvY/HL7nie0SPWsGo?=
 =?iso-8859-1?Q?uqhJsx20cyWo4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(36860700013)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:25.3616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deebe9d-64de-4b28-9371-08de4fa16c12
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6132

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 39 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f3d2e2088606b..2664b33871e9b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -12,22 +12,13 @@ static struct vgic_v5_ppi_caps *ppi_caps;
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2;
 	int ret;
=20
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -35,6 +26,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		return 0;
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -50,6 +67,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1

