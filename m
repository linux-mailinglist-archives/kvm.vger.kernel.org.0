Return-Path: <kvm+bounces-67621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE965D0B86C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 294CC3027274
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B06436656A;
	Fri,  9 Jan 2026 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EVGzF3MP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EVGzF3MP"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010050.outbound.protection.outlook.com [52.101.84.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45F8365A15
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978393; cv=fail; b=ug8zjU06Ez4TQNNJtJHqn2I/FYgT72nNMvrrmVPoMCvxVPo3KLmLCJztJNECtbZfvWquCZM90PONo1N35jZ/kMTmDjd7fN2JIwNtoIknxLuF10HPGPPgI3MFuE4+BNLXt0oB1Kr+cqjmISJkPrtpHkHvg7IYeNKNkIbtz4cO3Ks=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978393; c=relaxed/simple;
	bh=q5gy2AaVDs8MCE7rhPEQzIRf/wVd58xdLeoqYlYvpO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=edwSSBjN9Nw/rJ49egjPGOraBiwDc51zVCrJCcpGOS7ftrc8yGG4aWcKk84HebHfBsJcFHeefHuGBPEsv/XSW6+s1IaDUrrwcMxZwS9eV9wZRbCpw1yw+BZN+3ZtJ22InwWHSTNzGp5wSAdH0tlluhp6O4GcazkF4KNe04LvASQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EVGzF3MP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EVGzF3MP; arc=fail smtp.client-ip=52.101.84.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VRhUXkctvozKAMQ85MbJ6ZVy9Lx4y3RY7jFx6+hIkp8YL5YnMxnn/FJC5OKpIgbrWszrps03WCwjhWK+/k2yMCZy+W0VzGyv8HH8VL0uK0xH+SZoBPhccfoYtPP++0Gl1U4+vOSeGm4Wot16oruBf/FhAq3et1CSgHM63r8V3Z+Vp7lIJFxn5cA7+4RRV0QM8pnsl0zAogedrOFUSjOtL0OEGao0YfZENT5d8t5pi21DDb/AXPOPcpryrbZoECItm/dQils1xF4Q1KwjEfCdkVacU0zX3q/CbejEk0tc8WdFsRb+jiEx4Cf7hDb/z61YJ1R3ByzzPQxNWAXheGou4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=AAMbM8hW/CE8J0piTTg0EF18njvADeAINKFLUrhlayDOFPKR7Nk+x0fCNMc1BsFHmHd0hZMIRHmjctXeOeUXMeY1rVxenzZJNypfMpeRQ1i6c29mfuKYcZcFfEb7W3l4KqBTBvfEGAZ/TaXsjzPqjtylJHa0QxasMclPYeALL17p3n6jdozIiRUKBhKU8ZFRColqo7/BZR8eR03B1Pj9DEH/u3AjvX3Gnn38pkvyx62W2lkYoskETQaDx5f5LK/CDk/UArfJUiKtMmqr4MEiC1zIV4xDSqrQ5vrGYkFcW8XSFkq3dFJQO6P4CWK7G/PWhUscB0pQ0O1NoFtILy5nOQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=EVGzF3MP03xQO35+YWL3sCikR1z+IZfxd1X2WxiYARnKdJGDS7ukoL+pbCIUlhZNjDYq5kJZ4EhS3upV91M+sNlyWg1d+X0l+IgPc+GKlN1OkPiK7ErXRS7WJbc5apBGUHBNflgue1bvEaBXjAUJB8me7D1Y8XO8RNNPrxrRXGk=
Received: from PR1P264CA0159.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:347::9)
 by VI0PR08MB10582.eurprd08.prod.outlook.com (2603:10a6:800:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:06:26 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:102:347:cafe::25) by PR1P264CA0159.outlook.office365.com
 (2603:10a6:102:347::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.6 via Frontend Transport; Fri, 9
 Jan 2026 17:06:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via
 Frontend Transport; Fri, 9 Jan 2026 17:06:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFeA51wTtx0em63t8FfWa0tO8w0YZAD20+jKYnJnwnWNkHZs76EvL8nyGXiGOpKzCaPHlVdkRTefR4DvFshpW7AHAzoMLO27xPerGGBqHUtjY9UepCz49cm2FDYkakuf91+b/NstzP2ZL1Sv/RyQG7WzAPYW+ttc/fELbcCAOar4CS9qDwzLRzh44CFubKczzHT/YfdaE9+9O9bPfNOmbNbD4yOEBdTkOueLL3cyx1151OKcXXrK0aQ1FKBg2FFdxvwUQi1mTW6v11OKcf2MJipH7BRQpwCi3CEu5SjQc/MxyGH7GKPGoMbdiTqOqCcKY7YgE+XB0E8TS32NdFKWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=g8/YQz+vleInrxBrn1fxvuWarIRLZScWZ1oNSWzOVQ232SK1p01ebJfFXPS6K2xWScsVPTNfmVUZB+aTSN9ixDpd/2NSJcpPIQDQfJYfy9L8YCuAnD9PwIpEc1H9Gnd/R/1cwF8cBh/b7OYO6J0Oizsktybe9GdeAQ4iMnLL7WjVyac9DxsR9uHmW6PzRB6vbzP4tVHq8e4GDPyrJxPHNdzzCJwy8n/eF+tuX6ETmXua003eNemEkV2F9I/fa2r6H1NUVroggrBpjBoefkkQcMZkKe5N6g3KggVLcy6ZWBKn6TlM6j34x5SiME3mQT5H7oTthNIxD1ZGwkNTqVaUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=EVGzF3MP03xQO35+YWL3sCikR1z+IZfxd1X2WxiYARnKdJGDS7ukoL+pbCIUlhZNjDYq5kJZ4EhS3upV91M+sNlyWg1d+X0l+IgPc+GKlN1OkPiK7ErXRS7WJbc5apBGUHBNflgue1bvEaBXjAUJB8me7D1Y8XO8RNNPrxrRXGk=
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
Subject: [PATCH v3 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v3 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHcgYoQsLHHOEyKkUa4XlSLksCwwQ==
Date: Fri, 9 Jan 2026 17:04:49 +0000
Message-ID: <20260109170400.1585048-35-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM4PEPF00025F97:EE_|VI0PR08MB10582:EE_
X-MS-Office365-Filtering-Correlation-Id: a253f148-5af6-4fc3-471d-08de4fa16c37
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?wD+ZSDiEwgQU7QHThJ6nglD20EoC3Z2uQIylwJUOFNdzaOMTDBH2IBcOwd?=
 =?iso-8859-1?Q?9m/XTVWEa8vNi09Niz5Ry9D9TtzT6oG/SjAbQoGQ7odFZEtlETzWBRuzhO?=
 =?iso-8859-1?Q?udF84f0ygjATRDN3Yq/48O6qLheSwRiObYWUojSRocBucGcEPeO7K0m3Up?=
 =?iso-8859-1?Q?Yo+9htYLhKEfONG91+ZBtd7xq34NqecuyCr4yyxJbrE1jRb2kBqpiAokCN?=
 =?iso-8859-1?Q?vNBEcJj03sb1xfaZ7fRC4a+3HfcN2hdKNUTKsJ37F/Pysm/wWing5l5J5s?=
 =?iso-8859-1?Q?y8Vx2MEv03aExB1DXWTgJSFdMOJS9rIThx72qTX9SQUcIol4ks9T63t6Jj?=
 =?iso-8859-1?Q?YYjY0iOhs7Dqz6G2NRuqoM4gbPEaqbeAt0tZwTyCXXeGM6URsOmNj/0VH9?=
 =?iso-8859-1?Q?WfZUGg3w1zoZ/VRCMUNHzFVCtnsy0fHrVRkJzY20Ecc/IGe/ArdGvU8lAt?=
 =?iso-8859-1?Q?BsyTdUPHWYaExYtkVPXXUdb2NAzF5ieLfA9aE2cMeApjNkVP3IqDVzhVFo?=
 =?iso-8859-1?Q?36QdysZZAQGvLDaHwn5XD2R0GX66ntBHlYoo4x7ccyYla4MeBzelHsxVd7?=
 =?iso-8859-1?Q?vZ/WNxb9MkwY95laY/YtDYvw2grIgaumvtD/SBNfJjYo5SN7ASCtrETTy3?=
 =?iso-8859-1?Q?9UKj83hCWz8mOoHfFWLXltETV18zc5gEqqptmkKRa4+jM+NekJbBHRM731?=
 =?iso-8859-1?Q?ZnyfIHjFIjnbZRqS6mEN4NGIa2D4D86msjvbnmKBnDyPRvPAeRu5LLSLHM?=
 =?iso-8859-1?Q?r6Z5b7caWDwgtA76JdgESlOfDNTvvCR6Ox1K/2erFblUNM6wFykM1W/KpJ?=
 =?iso-8859-1?Q?ebtdkBMSd6IgJzuUlN4slUxdovOVGFEHp0dYCr4CZmaigoLRTdL8poRDkI?=
 =?iso-8859-1?Q?NTeoC5bzjNhlQtxU58jIEdc10GT3aYb0b8PJfljvfm4gRFpxtUmKGJsrJE?=
 =?iso-8859-1?Q?RnYN5Z9Yg9/+6P6qbp0rJ567v1Oec0LYRZOYAUcr0kK/Klsry17mgujDBS?=
 =?iso-8859-1?Q?1ER8ofBFImJhLwfwW+dR+l3buosdYMbuGQFlxBmpk8PDdjqxBA7fHeS9dV?=
 =?iso-8859-1?Q?FJ9f+eOp++seCesNtPj993nN2qzW/soXiLP+/a46mBNWIoDGsOt/xIbu+r?=
 =?iso-8859-1?Q?WOxh6fzAqV4bXk4cW961Zh0/zzVom96TgrQjykiWW9tz4jDrgNS8ubtHDB?=
 =?iso-8859-1?Q?eTvJPJj1XPfqtnglHbKuWCeDe4AjPuypw1TFw1T3AOrQfsMcnRfK5F3aG0?=
 =?iso-8859-1?Q?2bTnAHAJlbiZFVYzQSUsF8/+NEVSj/zSODYl/NzBU3S5GK1RszYqCP+fYz?=
 =?iso-8859-1?Q?NYBXoI0Zpq4VZDMJKwfFBBE7fasnU5JU6oDzlrRjvTyxv/bRKCj76h6FnC?=
 =?iso-8859-1?Q?D4AeN+4SrOk1apTcgC54py9OOkkzCYH4b+VqACK67pZyEPmJH3fqhYf4h8?=
 =?iso-8859-1?Q?OcmNd9JoFz9HL5Zaq36Ta1MxzZ0wnvf7cmAuFzIt8PR0OPa7btzEAiZEgB?=
 =?iso-8859-1?Q?eAZru1YFdgxlwsnWZkRo0ChEONQ81W4gtGtqiSdkRKZ6cPW9yvpv9S+gpa?=
 =?iso-8859-1?Q?REU4wBcqurn8BzkbPGKohVogw4yQ?=
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
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5f81daae-ad21-42be-fe7f-08de4fa146f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|376014|35042699022|82310400026|36860700013|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?PRG05/QFU1+FHQOZaMRrPAybOqAa4MVD8zGEdGg/omjOQt4L0ZcJpJCNUy?=
 =?iso-8859-1?Q?R8ZYjExYGjI4/tO8KFx8Y7XJmQepagUU0GfbGpKJlTYnn6J6iXm6KHsV6x?=
 =?iso-8859-1?Q?z0rV1brUWa0gbyoyKOARVkUeFDnZCY2Qaz0ldqZ36XBjHC2eUMn1h4Qg9F?=
 =?iso-8859-1?Q?wI5gToVY20I5iy/+D5lLHs74TudpLEzkLoqU5KTzM6Ugw0gwTUnRNphnaV?=
 =?iso-8859-1?Q?lpKAnU9PM2fP+anHjiJtirt7sx0MVgWNzAbScuW4m6ewwGYYg8aJ//xevJ?=
 =?iso-8859-1?Q?RMArycosckqgONq/5vxJ7EKSbpMPKIAsxEN5Ec3D9Y3dOo+szR2pYrHBpL?=
 =?iso-8859-1?Q?YgznPcVqoP+tcaNGKINANSr+LSWgwgw5mQsGWnE1tjOhNygClnhD/HgAnj?=
 =?iso-8859-1?Q?zWID+FIjYdwJCRV4LEDCa2j7D7+URe8tB/AYzZwkmH8mYz+6S6ZMHv22Q2?=
 =?iso-8859-1?Q?vjCiJnMjnWTlKIMgHmWIe5v4MoCROW1GYIyYWs6qKGnoiMGKiED3zWW6AT?=
 =?iso-8859-1?Q?95O9tSCRz4v2JiRfRyfeBO24L6RXT1wReIA//x/4K5ab3xFt+NknQnaYai?=
 =?iso-8859-1?Q?4axBYt7O/EgtsudPQirLox6ODU/ajvK1Giu2uXv0tnZbKwOhlrhhuCxgw4?=
 =?iso-8859-1?Q?Ksoj3aZU8XuzSSTk7K9SnI+UG1DmgmEG8sNrqmHLn7rZ5wf+qZ3sbWmBNo?=
 =?iso-8859-1?Q?PpprkO3SBvAgsohjUauUqiRbCVdEUymyNcRiLuj2H1CBi/XR5lKuK8RCFM?=
 =?iso-8859-1?Q?opTI2AjK0rnrtjyr0d1aKyZFFD9wpaWg8JpTbH7Pc6Pg+bQPcZlY7zVXh3?=
 =?iso-8859-1?Q?LiIImC3+JgE6AU7wzxUfJHfVaD1VRTW+UAVdF6uU2ReIcgeWzgdMu6QL9X?=
 =?iso-8859-1?Q?sfxWL+An/ypvhny1WlS8CZuOEg2/JeIUG5AN6Snt6diyYbGdIpWbvhcSnu?=
 =?iso-8859-1?Q?DeXip0RSDpAmu2s6hPtN1MXpuCXLAxOqjLCZ/Nz8+V8qDHNCgxvQ7GR31V?=
 =?iso-8859-1?Q?vBAIXzNuMvggkQPSBiCI8kVVbNAPXU8YpqKn2I1N4t9J5FhvVhFkw70N/b?=
 =?iso-8859-1?Q?L4nkysmnZbg415K3uA/hGqMkj7dDvECzMIQlJtvwAFF5dA3MdBmIGi2q/u?=
 =?iso-8859-1?Q?Amx7hRynt4ftQmhsllSnF3e2/scHh/jn6ptEXDxm+yWD2uytXnL8/ZVYRa?=
 =?iso-8859-1?Q?VDu2zXrNN7SYo22YjvHjPGBsqU2uPUISNFHvWTLn21Hwr2/pcIYZWvMKZ5?=
 =?iso-8859-1?Q?Zkc/1kJPRkSFSgPbNjMWxNGhEjyVQ5T5U/Nr6PnGJL7LkO19o/zWdIztLA?=
 =?iso-8859-1?Q?0UJneiBau2ZE5lLtIZ6IvUfAcIXL+p4BXXoqfE76d+vHc3831fx41LkCpU?=
 =?iso-8859-1?Q?ju+pUev52xtQPmk9mZTWtUr1JaYPVwng4Ibi44YBZdQeuiVUr3puDUsLfL?=
 =?iso-8859-1?Q?K8cBX07hQTBDJ5IdEBBGKGmiVLmisqW86XFGAIBFKtp3PcDO5/nsQ2Y+LX?=
 =?iso-8859-1?Q?HJwtptUfiZptGtYED8hvyHGqdufhJ3JZQvEX9VjkPwZ0N/1jMRuwwIgPWG?=
 =?iso-8859-1?Q?7kTHBAVokpgF2VlRWNP0pdYMhD1Tl712PD3GPixj6wgYNvY4Pn0avWni7s?=
 =?iso-8859-1?Q?rejjnetZzayJQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(376014)(35042699022)(82310400026)(36860700013)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:25.6206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a253f148-5af6-4fc3-471d-08de4fa16c37
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10582

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 0000000000000..9904cb888277d
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c84..70845aba38f45 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1

