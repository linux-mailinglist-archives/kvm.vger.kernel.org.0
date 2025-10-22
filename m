Return-Path: <kvm+bounces-60825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98796BFC6E8
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 16:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F92A3AFFAB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD6034C149;
	Wed, 22 Oct 2025 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iuLsdl7f";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iuLsdl7f"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013047.outbound.protection.outlook.com [40.107.159.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208C34B407;
	Wed, 22 Oct 2025 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140779; cv=fail; b=RJ88/cHxsYlUFOqVS1UMep4ZwQB04Ksns06ESYIOl4rxGdShKfGLvRaNSidS7AmUxOmNG+5SKmKavCoJ+zjF3lGmA8my3QcLp0NHkHERHsc/ufiWKxmlm4bcRNAqc9ikzRYokIXnBMGYHhNQ/M4xKKN9iObq+fguR4QqtTteR80=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140779; c=relaxed/simple;
	bh=X06gMD461mdTVf57RC2dU+k17CSPdalsYGdl8TjW9yA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hhCSRJYNl7fqFNRMz6Lx0HH/ywOnqlpSws3QlG8j+4kwc63tRXYKNxDE8CKHPULZ8CeYB0lZXWg+IDVumEj+SsoE7J8uPsyecUEASrv4UwUaDdy59I1wvs7kA0dHpIFhlvaXfIaAPlxwcnASJiMD38oY2GmeqahRpnAS2YWTZXE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iuLsdl7f; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iuLsdl7f; arc=fail smtp.client-ip=40.107.159.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=boAOTo6MIL90f5A7c/1DhZuxM+D2s63KsGwVaCKlSwKsBJ3GoBuQIK1hcJVVuTGn0qSTmQPRrbhsefzaAH8JJQhwpUamC/xj7s2SCw2Sa/w3dM8Nu6dfQahYv8cBedp6R9MwNP8ObmQ65MgoKe7ryNc1j54KrOqEBMU/eWdYggEMXCgO7iHOcgP/zZsR7xscobp0BU/7wbesCnt1nDpsyhL2DZIETwCo7CqNqLIuYHPX34k4gRK3in+STcrIgqEMiyEUS6fG/w+rXCmt8+ngVOpz4l1V11Omg2t1ANXfvMPazMXj07NP0oDYxJZiEkVKmascIPdbzw+UkAQJmrLABQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYnq9jUC49TWGk0yzVSPFklky2h5nx7fpCjRxs6WgiQ=;
 b=yW4mMCX8A1RlHbKK+cFd9L3+/up0ExgZ5ItJldGCExUCBQ9LfaE2fSw8EjuF++OzXC7tAzNj4zQbKRdOTqyLwYCcmMN3tivsbZfUex1my8idSc4AY4a8sUSd+Q6y1RIvjKZEmjAzRihofnp+z2VU+Wjon6gC2RnTFgnjMCcguL7AS/Zb09PEUMtHCKFxBeOc6wvk3Nz8b6rheps8GRrFA9eV3jjw4HmChXTLhdyyqa3PfMSQGWOfQY0eKYO5C5Ssn6S/yEsrk0fco+zkM/kylsAsCz+gv6MHy+93qhklQMlilU4AUoJ1+q3Dk8v97tV1UNbWi2OvQtdpjr7Hm0L4yw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYnq9jUC49TWGk0yzVSPFklky2h5nx7fpCjRxs6WgiQ=;
 b=iuLsdl7fsKwV7Q7ZE+jvdSicTQ5Bd5WNrqRCSh6WQuZpYYTkFnkZ/bd/1gzpttF3RdewaE4vcp5qpUWxd1qZa4yR2tXMmxujmOc50xzgRpju7nA9tmnl+eQi5zgs1D3ZtiohFrGFI8NlcZHY6/VqY5GqoPUQNn8EKXE9hP3GOy8=
Received: from DUZP191CA0051.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::28)
 by VI0PR08MB10655.eurprd08.prod.outlook.com (2603:10a6:800:209::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:46:13 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::2c) by DUZP191CA0051.outlook.office365.com
 (2603:10a6:10:4fa::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Wed,
 22 Oct 2025 13:46:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Wed, 22 Oct 2025 13:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N0gnCF/rSnYSI+t2TauyQhIX6Knd0p8I+bTdg7ZoylH3P3HaVxazxxNTPnVK3yenGbdbtimAP1v9+B/0vGFq80az1fdD+06kad8eI97HXPkVR4Grsp9psltmbxJtYi47uLxausBYUTkKe9weiCx4t9qTIwiQCp/zu+9l+ZTvUzXbRKafk608bEm4iCQW2K015dwzwVDR1wSDNUkgtWiBytHk0aaeC204aeFsByEhs4lKl+WHQ8a06BEjXb4ihPv3/V9kMniHkYNitdRQFKGUgg92EU33QuBjtuxPSS1+WHzMIPa1PYJuaPSAac6eHMuG01BOzKjIs5H9FLmNW7tL+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYnq9jUC49TWGk0yzVSPFklky2h5nx7fpCjRxs6WgiQ=;
 b=xQeGeguxPtCzkECnvMh40Fl0BAiWJFXsiiGOjvW1dr1KC7JEH8LDgSUsW4XaR34nNDbX6sFQwGpP7mk6hBy+MxoCPjb8+5nhszf96ROyisgGXEcwWnjqSSL8tA4SPKLvBoNpABEaYjxacJqwzdRyIFSSLE43leqJEMfXQOe/OHjClefg7e/qaP6wvmJPqGyZH7MEg7nzuOTP6it3Glj7MstO3YI6u4u3Z64nkGfhW2k7eL8dr1Bu9yCVZmJ/9Fid+m5y/dot9zX4iHb3AnWJ0IW/kRuNzlBTxXq2xcmSFrq8tG+QdKl33B8yPD5SFetc1Qg3GpOuO9PJbPyqXXDFCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYnq9jUC49TWGk0yzVSPFklky2h5nx7fpCjRxs6WgiQ=;
 b=iuLsdl7fsKwV7Q7ZE+jvdSicTQ5Bd5WNrqRCSh6WQuZpYYTkFnkZ/bd/1gzpttF3RdewaE4vcp5qpUWxd1qZa4yR2tXMmxujmOc50xzgRpju7nA9tmnl+eQi5zgs1D3ZtiohFrGFI8NlcZHY6/VqY5GqoPUQNn8EKXE9hP3GOy8=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by AS8PR08MB9244.eurprd08.prod.outlook.com (2603:10a6:20b:5a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:39 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v3 5/5] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH v3 5/5] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHcQ1om+yhSrS7n+ESq1YEnB9baEw==
Date: Wed, 22 Oct 2025 13:45:38 +0000
Message-ID: <20251022134526.2735399-6-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|AS8PR08MB9244:EE_|DB5PEPF00014B98:EE_|VI0PR08MB10655:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ed0dce-31a1-4745-fee8-08de11715d2c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?a3vpd8moGaR8arMPqY8Jkp3veEcJiDQlherupgmZx+5/cbvhayBCI4y/Jy?=
 =?iso-8859-1?Q?Hr4PpOMW3P3q+6ibC0dTT9YF+yfXeJ20Go3x5XK/bSZO9spwbCxis1eC2h?=
 =?iso-8859-1?Q?x1Ft3VgBKfOV9yhLw+aIpnOnMoJT1hbVTyxOUGTyhlsUXLfCHmd5FYZY44?=
 =?iso-8859-1?Q?gZaZaPsaShLUiGBTKItOKCExyUjSR1/wrxZ2l2g8uWzDji3dOShdpG23TD?=
 =?iso-8859-1?Q?+9Ja1ESL30OWFzTjxOq6D4v7dxusJSfWxxk15krfuG/klqDZBCjWzewxN3?=
 =?iso-8859-1?Q?Q9ZLacCfymFn3Ta+xHMmFYGmaIDi+YOpC7NWTB+7nrNXqAmFRY+aNnGlD6?=
 =?iso-8859-1?Q?NhT7/KgHjNwW4ADrnFj+h8vzcMCJqBhRvtqaBk9wg3pCPgGmRdeC1oUllp?=
 =?iso-8859-1?Q?W3mcng4RasM5ibobZeBrdTsqGdg9pFbEanV0LyQXKXoXGYL9e8vBzjiLoF?=
 =?iso-8859-1?Q?w8qjvD//z+3mtyxHgyoZCG2iO0/ZqeJnmMY5t937yZ5MtMI4Qw2bDiv6Gy?=
 =?iso-8859-1?Q?y19yQ/nLhBrblaCDtSjS4bgpulJCtxk8Y7ry5Cm/B8Onnml+v8p/iysp+a?=
 =?iso-8859-1?Q?LEaf3QIkdWF4yojaHITKeIUt8We+1dT0PsFC0XqcEQ24okrq/iZSSNw0ue?=
 =?iso-8859-1?Q?5aXFCQEntjd9FrK/wToxGIL5Oeaimn+xY2MZ68oO67ZPDzCHBDDWIQ4a+z?=
 =?iso-8859-1?Q?P3JuUVEll1GM2tVxfOhVhIR/3wbktev2xMmF3EhbdcjU/yUM2O1SIgouNn?=
 =?iso-8859-1?Q?1ED8lhZWlTdfI8S7pdQfFoIuXLOqvcSenCxG+k1SGoyCzy9cxboPrzouJK?=
 =?iso-8859-1?Q?/tGJi0SOZ2TB8pVuJHUK9qOYA0/gzy6yiprM4MDgeRv79PYelTkJ+7dUxT?=
 =?iso-8859-1?Q?GO6mgQZtyll1c4N5TS7dMzLvAWXzJ8nlswKeo5AKACzGI3niZDFIyPHFWv?=
 =?iso-8859-1?Q?H/uoSlp8osZKYuMcfWaftrbepfJT/riYZirOA+gniNWa8ohoYmto7+QAIp?=
 =?iso-8859-1?Q?UQjIP2qQMbjFHtMx3Be1X7gkJHxXod3dobP9g7IpBWqBRsgQgcKgzXPt+/?=
 =?iso-8859-1?Q?B6Jbkf6FrcAigdjeS2RyUJJUflZ0TQ4PPpko5nUQYqhuwUqTh7XQlbzbUM?=
 =?iso-8859-1?Q?QlkyzWlmKZ5TtAMtInfauVML4GY64k4/Cs9aewIqrpX221Y5fc9FFF7CfV?=
 =?iso-8859-1?Q?IlCY839ZSeLgugAs2fNRcUnw1p/rjyBmx4kCCcAAgy0J8A+R+wWwIQSFmL?=
 =?iso-8859-1?Q?NCiRR9sR99+/uU+3rJdjlZrcz4BzGSiFK6BBgQA2Ncza1pSYERfAxrCFj7?=
 =?iso-8859-1?Q?e8+9LyukD4g/yoD7HYQ1NzUviOq2RwFjGIywlXaWR1Atz4ycXtxtL0B+AK?=
 =?iso-8859-1?Q?LVJ3LYeLX9z/bC4B4qV7Yt700G3PKOJ1p978bwb5t2LtELcDp2yxa9hTF+?=
 =?iso-8859-1?Q?blj9MmJ7xlrB5LCWLdlskNeD/JZd6JJiZUgHyNMnVt0++8yRw/J9oeCmh7?=
 =?iso-8859-1?Q?1ZGuxGAEnOwjReJDuxEE86CYPLCVcxsM2YjpbnruvzN17fwoD944eFWj3z?=
 =?iso-8859-1?Q?OIkoHTHfLnpDIAwJiuQ5t2rpbivW?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9244
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7b778fbc-9b28-4125-4c78-08de1171494a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?vr2YmqHDkMR+N1sI70IPcmqNPWc09MhoBhjywktbb+fMbCPucbmjAf3hq/?=
 =?iso-8859-1?Q?2XoplhFtNFN+Cb5UpdMn+C8jy0GvIhIdNuHXnfAPnkqNLT85293P4hD5HY?=
 =?iso-8859-1?Q?bty2A0PegEO/tLo1aBnEXQZwgnCM5/FOhOcE2PnU7A5Yz9BxSEsXFJqvku?=
 =?iso-8859-1?Q?esfLnaLG7mgxBNAT5gA9jguvwDYq5sLS280PHQZHCa48BhyYPI50lP4xFQ?=
 =?iso-8859-1?Q?YZMcOOlKYbU9wpKbOK7MnDB16DY1R2huWBYS67/YN0v4AZseD028yIWPfZ?=
 =?iso-8859-1?Q?HxEjaTz9qS8j0SVFP29E7We4jqxGgwWSoB3EM/oR9XFdmAdErItqdE92zR?=
 =?iso-8859-1?Q?LnsmoGS1qWocbLlgX5VAhUEqlw5q2s19YWjKe4c3czGlxDwl24l4dUP5Wy?=
 =?iso-8859-1?Q?i7dmy5oCjFf+u9C+eS96fribou0T7WeeQEPllNfm80RlCkqRdLIeUKfbhO?=
 =?iso-8859-1?Q?wh60FoVFlCkhz9hEhM9Snk3FxRFS+E9JRAO6mC+nybfwEU/bmmY0cqgF7U?=
 =?iso-8859-1?Q?Q/PDb699LTN88J/6sxs7c54RlbqjJVbNuRnQHgJFNBfQf+Co4+dkGTXjKT?=
 =?iso-8859-1?Q?XlpTsOMbilNs3lbQKXcZK+oyfF8hjXsZlhgl99m3fN5LXijTiCV16Mnl8g?=
 =?iso-8859-1?Q?Y0kmRtnMTy/cjqg+lURRAiByFFKdCn+798k9nSq8NDhJzbsrhGhlJkZT/l?=
 =?iso-8859-1?Q?5nQfop6xpHFhypnj3bGgGSfHJUvy5+7uwgaxqBhPx/XRPAU0bgRoPAFuYm?=
 =?iso-8859-1?Q?FMdTlQef4XCD5hZNEQWZsXYWn+ytaPmq5bCnJQQlPiPzB6IR5a1Z4bYfOq?=
 =?iso-8859-1?Q?7ydLFLzVC7Uzpai0GbVkUP8uvphgTmVZuSTmhC15u53kfyr+BXuFbmCBp0?=
 =?iso-8859-1?Q?MvoV92gsAeJezMakMApQINsLfk+Xs7nvVlYJezN+HXC6hwYwSu28HcguSE?=
 =?iso-8859-1?Q?8ne9KRyJ80Eqk1+ghmNRbFlBEWXtS4SYGrUpjRh3Dn4MiAMPXIVaFkuhfO?=
 =?iso-8859-1?Q?hTpnzYx2U5vt1cJXMSWh/FIp5LmG9ZhqBEjKaub+3G669oyocHMM/mNutq?=
 =?iso-8859-1?Q?hh5TWoBlXOYdTwwFgU2dvEzIIdRR5yuutFMpDUflYBHV0sHtfmpfW7DFdO?=
 =?iso-8859-1?Q?hcd6ndQpc75zCnpRNhgjfrL2g0h1SLqXgvH7cK9DjarMM7/hWL1kEIWqCI?=
 =?iso-8859-1?Q?ULETbGH2oslXm0dvYsQzQ3ju/kRK2CmJhIQ6Ze/kZZK+FsI28QiSEgM/vQ?=
 =?iso-8859-1?Q?+s7E6QjWmn+UaJk0cWzwX5kde9tvpZnzxs0z2/5/2dkkLYeMp2CoxmxcM/?=
 =?iso-8859-1?Q?qAnckavgIdhnHIXKxHqZtkzLRMDUlNcGgw88GGxPcy/4QJxc29iM/MKZLc?=
 =?iso-8859-1?Q?RskC1tbOwa4WmGrQrFgz2mvltliTSvPeycNdK6gntoLG9ZkWJzrBnE5oae?=
 =?iso-8859-1?Q?luW18UIdFI7YrB71Jbrn0Ag+hm8jRpWLF7jTAqBW9rlF2gk8JtGpfagxJL?=
 =?iso-8859-1?Q?wMqxd2fiFlfVTkePRI6tA2QT5BKewy6t7ENbygH+WnfOLmF+b+RSTi4AGy?=
 =?iso-8859-1?Q?K9KpqaCd/AN8va1bKNymthruN3YTDvi7qmDG8l98WY2eZWdytplQl3VWQR?=
 =?iso-8859-1?Q?aDktX2jr+2IIY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:12.4287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ed0dce-31a1-4745-fee8-08de11715d2c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10655

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 64 ++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 42 +++++++++---------
 4 files changed, 51 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index c231d2a3e515..b8995cc56041 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -560,7 +560,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -988,26 +987,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index acd909b7f225..eac49ee874e9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -560,11 +560,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -637,19 +637,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -749,7 +749,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -797,7 +797,7 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr))
 		return;
=20
 	/* No deactivate to be performed on an LPI */
@@ -834,7 +834,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if (FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -850,12 +850,12 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG0_MASK, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG1_MASK, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
@@ -863,9 +863,9 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG0_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG0_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -875,9 +875,9 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG1_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG1_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -901,10 +901,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR0_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -914,17 +912,15 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR_MASK, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1014,19 +1010,15 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VPMR_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1049,9 +1041,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr) << ICC_CTLR_EL1_EOImode_SHIF=
T;
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1061,14 +1053,14 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VCBPR_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VCBPR_MASK;
=20
 	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VEOIM_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VEOIM_MASK;
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 7f1259b49c50..cf9c14e0edd4 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -199,16 +199,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6fbb4b099855..37a7bdf1cf2d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -199,25 +199,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -231,10 +229,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -244,13 +240,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

