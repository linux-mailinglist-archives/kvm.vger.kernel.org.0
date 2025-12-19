Return-Path: <kvm+bounces-66391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CCD6CD0E06
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35FA9305F32B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B81D382BF4;
	Fri, 19 Dec 2025 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="To775fss";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="To775fss"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010004.outbound.protection.outlook.com [52.101.69.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7AF37D138
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160851; cv=fail; b=G+3oqEEiQQFRTrYCkUKQgwErHgSQ7rYuC294a8kmnMuhmm83IMOybzzLSccECUC6K1kNx4eom9ChdQa3o4XyzfedSt8CPDWM6AEqvzSaZtAgZSVYRjC9BpVtEo/UyXzN9qKncINzn3wZyUbEMCgiitCSwEE1j1joS0es+JxpiNU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160851; c=relaxed/simple;
	bh=mC/z3qIGn8qpejCgXAIvzncZ+OA1/n60mRTsndVDWtc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T5e1W7qujaEn/zey82t2SF8KPp2nsnmtYI3eQtGVL735fkNg/I3ODbedqY9pEqVY0EBlbdM8scneg72mKf8cviEx++tpqortrJcaX3XjiqjIdNuIegc56yqUi7XDOCX9ikVjiCEDLzgqkRc1Py3dMcHFbpl2VRmkLLEnFOSfq60=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=To775fss; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=To775fss; arc=fail smtp.client-ip=52.101.69.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=P42zsnS2My42DtIqLEJjrf+wHXYOQFi4VRFyp/KHP7gg38V9156B4X3GUfS3TSH6uVOyUi3N6xO9hG4eNfKPm1L4H0St7tjC1DvmWI2mN/b1R8R8xLMhaMLTol/4yiKMgE1TsU1WQO7WgzOX+fJxxpwGEtq/jP4a/1lYfMPQqkjGaeZox7YbRcOicLzYsyh381NPocg3kmoFQeRBE3Ivufc6H+Fl2Brjzo4yPVFGDz6LBaZNGvDeCSB0S3Lz8iPJlfmEd3BrYa5bWqTUkKvAwKsuxfBj8KZkh94iJ83pcf8wweswP1k86nPOHqC/nwkkHYbRW1VVhQ4AP8JezXvhQw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nYnWGfuk/8to2fN4xszT4S0ZH3VaEju4sl7S2sPXN0=;
 b=tjUNxoLknElcuiwvvAMllo6bVMLAcFxaEfyQaAg1fNWmwHaKnr5neCorJuVLDKfZqOy3nYE1mtP6Rz+23jRhp+c3f2GQD8/htYI4LfpVUsjN+He+9NhFyhnpxD7sUsExDMJl3JOb8jUQMJRkjM8MF17GmFrL4hA8J6Ou//o3TM9gyezKAG4TPsZ5yY9FeqaDpwWY/Rq1e3I2ZCU9w5jVx8hQcoOKMYZHnGYfDdzIomFex/P9QIk5yLbwL5233N1ILRZ9ysx4lW2Ty4o/JnnQSDiVLwcY/asAyJIuyISqmQU5OlxPRY6ES/fZGV/SrBGhryxYVIeC6ApeqFGoxS8qdQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nYnWGfuk/8to2fN4xszT4S0ZH3VaEju4sl7S2sPXN0=;
 b=To775fssgrK/pbvoyxQZO3ihkM1yr6ohxKo2zRIevcjhOuJJcTtG3DgzQWh5xbLQ1tmBOemhS+wki792ZDRwCo+UvQ7911c5JtotWrwc0/fdBdgS7lujequLeOqeZDUQTbN6foG+EqfSDVao+n39m3/jZRJNGNa9fYT1jHzQ6mc=
Received: from DB8PR06CA0066.eurprd06.prod.outlook.com (2603:10a6:10:120::40)
 by VI1PR08MB10103.eurprd08.prod.outlook.com (2603:10a6:800:1ce::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:13:59 +0000
Received: from DB1PEPF00039232.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::a6) by DB8PR06CA0066.outlook.office365.com
 (2603:10a6:10:120::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 16:13:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039232.mail.protection.outlook.com (10.167.8.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfOAptMEdd4bqqmiO9gQyqAvPkEh2PVlhIJAeEF0kmf2MKCDu1OOQ5qQRzN1hVAl5I7KoYapUpAFoCRiJtXKHhEYRxKQmvLNLuLeKYAcw/WzMq8k0bZRhuY1xkUFi0mQzti+6Nbn/rUv1Q4HclmGFpaau4dOdIELOOYdKps5Yce2KwavSyKTE02bMITCNLWYPuYrpmTNUyRNyh3HsG3UTnFMlsGt+ZuaDYDsklZx4/I1fd/1KRaw8KJF4GLA5wZ1ukUUTOhsDUQAV2H+PprHlHLEW7Cr5pAiAZTtPXbPWaBLV2Gugf9enAC82JEm+35M2l/AVvlurcvs+QkeJmLMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nYnWGfuk/8to2fN4xszT4S0ZH3VaEju4sl7S2sPXN0=;
 b=ZiJs1sHeoi1d8vB53W6bdWUsbZNcsaWvcpxICgz1reJOLw44dZ5g//F5vkMERa/RmZAlr0YPncAR2oS2jDovjVsdq0v5L7bWtna/yUla02+8Xbq0P0P0IthjgvM1o0Uy0YUwKIUbY6ebhZEJU727HjKLzLqC46isaRRCm6YmX0M789IL+rEQmIP8jYVa46CtGr0V9UoPrBGxODCBtyWmZB+YnHDOU81QiBQMOrknOicDpMJ0JuRUJkGDujPdw7SdFyugHceEeB7kXE/8MC8ksOYLmLnWWnVQAx5dsFpp44nD1DkZtOeds589vfS7PQOS0zMMwCHPlDZ+h+z5X+na8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nYnWGfuk/8to2fN4xszT4S0ZH3VaEju4sl7S2sPXN0=;
 b=To775fssgrK/pbvoyxQZO3ihkM1yr6ohxKo2zRIevcjhOuJJcTtG3DgzQWh5xbLQ1tmBOemhS+wki792ZDRwCo+UvQ7911c5JtotWrwc0/fdBdgS7lujequLeOqeZDUQTbN6foG+EqfSDVao+n39m3/jZRJNGNa9fYT1jHzQ6mc=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:57 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 05/17] arm64: Update PMU IRQ/FDT code for GICv5
Thread-Topic: [PATCH 05/17] arm64: Update PMU IRQ/FDT code for GICv5
Thread-Index: AQHccQJVweIxZBphYk2ZooUUdR2ZsA==
Date: Fri, 19 Dec 2025 16:12:55 +0000
Message-ID: <20251219161240.1385034-6-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB1PEPF00039232:EE_|VI1PR08MB10103:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d4b4920-fa65-45c2-b2e6-08de3f199e52
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?J+H8sFA1bufxtP49eMjMX2wqmD3e5CcEdY1glr9dGl0hQFQrqNXGGC7BLN?=
 =?iso-8859-1?Q?/eQvoMjZo6eBDUNN4IJ6lZ9vAzcUge+eH0GweIgjXjAesseuMfuZ2P0b4/?=
 =?iso-8859-1?Q?58pDlrjKiOrf3R/mK6JttCR7iITnz3YTcvM6BjYatTgad2FvTXHK9lvlu8?=
 =?iso-8859-1?Q?XobxxTm80bq/jvNpxHe7uJ4tWE0jpS9uxvlanUJbw2Oo5ml+jkF4y/Eqs5?=
 =?iso-8859-1?Q?rLn29dbbOxkO6gsJ0XOB96cBxqBOWs4M21nXxeTpdXAY/3BbIVRo9UjS0j?=
 =?iso-8859-1?Q?dJvC8xaioEfgq1X2ANnW2nj5WEe5ZiHfFBwRERxDXa7IlDOnMPCpPaQb0J?=
 =?iso-8859-1?Q?qSErMq3SEUUjUozEexR2x5r9odYxh/KPlKF1czDsAqPaXp98EuYNe8ADxT?=
 =?iso-8859-1?Q?XArynvMXJOZjyOVejMYCF6BrRyZ5t2jl4YtfXURu1Jc/wenUUQL51yWoEB?=
 =?iso-8859-1?Q?ow5O3L4lMfoT01GQc2a0RLa3fvEBa7YrrivV13ebibxpKquiKnQkpd11Fc?=
 =?iso-8859-1?Q?w7/7ang1LibmfXiGGKJW+JZsXa5x1kQFhtzbpBMl1bRNIY5jPw1gGV0zmB?=
 =?iso-8859-1?Q?YFqD8LukA1klDtwl0SnLYbAvYiYaL9acRiWh2sbTASIlaihlxvZZ+L/jvc?=
 =?iso-8859-1?Q?DpkIhLSf52I82HlxOjD5++8SczHH0987pCBJ1qYKzJDHyijRMzffA6/tkN?=
 =?iso-8859-1?Q?AaL/JzOavuAV0yV27VLyih8WQ9Ivem0W38FU/tRQbZABRBi3PWUG7qjVeF?=
 =?iso-8859-1?Q?F2pZZKXUeDsr6xNj9cDu5u9OB7TzCxA70QE0iYJtE2DxtEy7OHiaoh0KEh?=
 =?iso-8859-1?Q?52egmegmPEWbc8ACdPq4eJZ6QHjKFVQQM3U+Bq6ncIIDajv9XDBNum6yX3?=
 =?iso-8859-1?Q?Ktzubg/gILps/jCvDo9wdZNNTzcUqeblD7hB5OBfamRExzzg10NZd4GRYj?=
 =?iso-8859-1?Q?zlDvjxQF+i92QA1lFQKzMr8h1x/pli9tMLNzwsxYajEjuORaO75a4JXXNa?=
 =?iso-8859-1?Q?KhI/qPn1z0VveXbJVj0ngZXDz2ISMJzd0TejFqXpwQcBtd6e9cN6eFoaKt?=
 =?iso-8859-1?Q?Fb2CIoyFcTJGaD7aBAHPu09SXipOwlHTqugIyYwst8Ch82Um9x6RzQdB+6?=
 =?iso-8859-1?Q?Fp407JVRl29ApaMxWPLnsesb/qgDU63Vw9e+i+E4UU7hAeYV/zoQ7r9n6g?=
 =?iso-8859-1?Q?nzlhcfQOwpoeUFt4MMNp5UxYIlDdCW38sOLwuoQJbAA4hF0vwUbPbCEutU?=
 =?iso-8859-1?Q?1GwAmJGnHL9aiiXaPMnqDTGtC6qjSskqYMijURhFrXkDW1aBuLcwCxNtn9?=
 =?iso-8859-1?Q?xN+KCgaySlVMB2KoFPfeOGmjLB5yLvgOIAs47u00re0S891nDfvw5UL01y?=
 =?iso-8859-1?Q?JYYCCeRzeKrJLHeOVAvD6jPMUqt1dWh+qOq/YXHsuZqZ0RUYZ+tiamjVb6?=
 =?iso-8859-1?Q?fQjYHFcmZwe3LaB1YQW6yv/quuv+vZRjAJ4/hqOTpGQyAPyJerpDazH650?=
 =?iso-8859-1?Q?p7F0BRM5MfD3focdirw+nD1ykwAqoM7O9kbHXzk2NqXJoMag9cRTPhS7/3?=
 =?iso-8859-1?Q?T9w2aP3qFrbGPAxV6QgkIKfPuqqS?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b2792bc6-fdf3-4ae8-f269-08de3f197952
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?0CPMDWw6G5yl+QnikhemgdVHdXwPow8+Y2GQp4M2siY87+GU2Fw1WJEycw?=
 =?iso-8859-1?Q?C32FIUP3iUhfBb2Ba+KTrtIyMF4OxskqmNOuUH8zxvV2H9kks818f/f57N?=
 =?iso-8859-1?Q?Cwd+01qleVtD3NDLUMTVZyeJRpiS/wMyJQPtbSlXDHS6CmOuXjC309PtSr?=
 =?iso-8859-1?Q?fORHJ55ujH3Nx2smqhBdnOIXopt353ir/+T+p+qxib9CRq6WqqM0JpSCmU?=
 =?iso-8859-1?Q?QiXHf8XrtmpKbyaxG4jssLE2iYyj7dfQyP4AQhm2wj31M9lya8zt1ke0Xz?=
 =?iso-8859-1?Q?BF/2U+zAORYeLVc2d0lyb4/8slBXFxJT5ODL2dNghpG1XtMfYrn/Kyxud/?=
 =?iso-8859-1?Q?66LcLq5QzcZKDQazxsJIXOBLQix/osITko6bSmKICWrjNmE2bg13Z2onwp?=
 =?iso-8859-1?Q?OavIhY6UNNJUbN5PHmJ/K1oLq+6AqTQ4gmdZbaHkLXUaK/qrg4sYrnGROP?=
 =?iso-8859-1?Q?euRAnjHSuqB02zD3/r+mTtcN/ztC/9S5cNhOfk3g59lOsC0Gh0pUsgLY95?=
 =?iso-8859-1?Q?Oh8eSZBuFBsklOYUIwVOaKoykn/GVEjo/fdSp82X3YQTO/HWwBvTq0aL7b?=
 =?iso-8859-1?Q?coj7NA0Tv9Mzg6AIBPcp4XWNkrnRYxhkDankzEdpphfx0E8ArRpDtIx/BD?=
 =?iso-8859-1?Q?QOFCKng6zUeuOj9ak9d3ocmvx8X5ggSC/S7x+8xADLSQZfARObHf+dceS1?=
 =?iso-8859-1?Q?JfCUTljHtmibMaSgzM1l9sXWQfhy+PGH0lHVAopygB8Y+dRpPNQKIIyoCQ?=
 =?iso-8859-1?Q?+M3AdjBV9EHxr97wOsWYpwsYUZG4pUq6bEkvMFKkDVBlLyN2dxqDPg6yP3?=
 =?iso-8859-1?Q?zkRqAvw1VQMtsvvYe0WON1k8fp1hbpN/q7QmEZRkHvCmTJYlxIkzhDQvp3?=
 =?iso-8859-1?Q?YwqmMuUV/Zopl92JpnJQ38gE+Xg+y3N1/OZftIc6TEcCN99+pLh+ImiHE0?=
 =?iso-8859-1?Q?kYAUCHnPQmXdUWUymAi3QRspcrntLIImbaB36RBKOU6XzeK5Ze3gZmL7Zr?=
 =?iso-8859-1?Q?sRXZ+4ubPLlFWscUL/T+Vli+qX8oZ5YaSKYhIl5Az09pcT+glrsGq20rqm?=
 =?iso-8859-1?Q?ylkUY6cRTWb0UighSRv3OoH2C1MhErcIY8leUV5jadAwPEfz6I/M7OTZ8y?=
 =?iso-8859-1?Q?wteyq9+jHpjTYRw3LheKOTqWnyk8O4qqqaKb/FxhjT5NOx7X3+jEyPUJtc?=
 =?iso-8859-1?Q?QzYILpvI2K4kCBvpaFrFMsJdR+dsJGgRrHh2yXlmCd5VYOJKSS83gbJvJF?=
 =?iso-8859-1?Q?dHJItG9FqhUuRQ7Z0smxUzH28R47hEjJ0LBpTwBdww8AgS9qk7S3rO/MEV?=
 =?iso-8859-1?Q?DV8qNEdlTWdoDQtmUTCT+TN0IKvJNI2PpR0/PJhn6WRnfsYRVLTNJnmy6c?=
 =?iso-8859-1?Q?EYeSz/XNSCT968l4G3bb3CNhB1PkI5lj8lXrcozSKDLmX5cfsrjmW4Vtc9?=
 =?iso-8859-1?Q?MkJIWuk0CiVJrFuzcTUdl+olwCD26TuRK/qXa5tVi1upKdrQOYuqlBC/6g?=
 =?iso-8859-1?Q?aRjIV9XHylWSrWM8tgCew5p1gCWVw7Rw0IdfZ65xaMft6q4cmro3UoKzap?=
 =?iso-8859-1?Q?HWbotXxEVi3b5BX1cYajWdA6NkknLWpSiF8c0b2avVb4zzXAk9liA/bqlA?=
 =?iso-8859-1?Q?LN47TWUPVU6A8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:13:59.5044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4b4920-fa65-45c2-b2e6-08de3f199e52
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10103

Update the PMU code to interact correctly with the GICV5 support in
KVM and the guest.

This change comprises two parts:

The first is to update the interrupt specifier used for the FDT to
generate a GICv5-compatible description of the PMU overflow interrupt.

The second is to correctly convey the PPI used for the overflow
interrupt to KVM itself. This needs to be in the correct GICv5
interrupt ID format (type + ID), which requires the interrupt type in
the top bits. Moreover, it must match the architecturally defined
PMUIRQ for GICv5.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5f31d6b6..1720cc00 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -197,13 +197,19 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *k=
vm)
 	struct kvm_cpu *vcpu;
 	int pmu_id =3D -ENXIO;
 	int i;
-
+	u32 irq_prop[3];
 	u32 cpu_mask =3D gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] =3D {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irq - 16),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
-	};
+
+	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5) {
+		irq_prop[0] =3D cpu_to_fdt32(GICV5_FDT_IRQ_TYPE_PPI);
+		irq_prop[1] =3D cpu_to_fdt32(irq);
+		/* For GICv5, encode the full intid by adding the type */
+		irq |=3D GICV5_FDT_IRQ_TYPE_PPI << GICV5_FDT_IRQ_TYPE_SHIFT;
+	} else {
+		irq_prop[0] =3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
+		irq_prop[1] =3D cpu_to_fdt32(irq - 16);
+	}
+	irq_prop[2] =3D cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH);
=20
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
--=20
2.34.1

