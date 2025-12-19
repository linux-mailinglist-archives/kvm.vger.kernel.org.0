Return-Path: <kvm+bounces-66401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A7BCD0F56
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0A571304D8BE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6223845C4;
	Fri, 19 Dec 2025 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YHcBJ6kG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YHcBJ6kG"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013003.outbound.protection.outlook.com [40.107.159.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0729637D12A
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160857; cv=fail; b=F7oLqofWKOMdadFWCdJ5Ees8H0CF7MUcMU8IuGPof5E4VV/qVlIqOH88PtNzQojEa1bxrzU4ln0DIap/SHyCFxfyb9PRAYywXTDYRNnXUTs4nhMJwENjTGUKzhsKs6LOQmBuvvsB31UN8xQY1bw6DLiy8Kg5LwfEtFL29lgyKVE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160857; c=relaxed/simple;
	bh=CDSjXgXQZObYhzTL4OA1xNz/8A4JaQv0w3wwUKnYZGo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kN738NdiQZ2T36l4SI4VFYVgyb9epR6Vjl6jwyr631X+3vJxUPmTVEortwr06l0nPazi4LQy8S8PXIvokc7Jf21FyaM8aJ1xj8kf4OYCdhLgPSxv2AyWlassydilMT7l/WsFz6khpVSOt+uazFNZtQw5e8L3sXie/mgO//S2J28=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YHcBJ6kG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YHcBJ6kG; arc=fail smtp.client-ip=40.107.159.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=No9xhW/8p5qPQ8X9yTNSBTDZ7mgsm2AgDEj7fweG5k8Zd2oHIhrQ8VsdWoCr5SeWDlI9isoMqFqv3bzqhvJ5Vcz5giG6et3NLdXhJGlZB9nny5xoGn1qZ7vdY0dAMo5A8yVJhah1Hpw9QhL6PF07i3S1PGhzfhfKzjJDjpJkft2glYE0aK/Yy+uoxtrEn3VUFhKQSaIgISWsbvJHgy7yCWoPEKe16Cl9JY59DAO5vaf7L9uFqoov5bCo0OPnCRYHqqmtwdZrMzK6dZom9InAW8sZjcQdxEwkbscKZj3wE54HtN2vKK2oncVjIkzJHxyj3RlEkzpHOL6BOq869TkvjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbZxkBezUT/cGay+MSA8qvq4KIds1iW9RmlOdh8Io+s=;
 b=jIjdIRi3w+gZKxaZxNqV0qmFZyw4WeLSEZblOTW6q0ONf2HYtiHe/YNszQnmw1GfX8rHazACxgTfCP9as9bLO0xCt13ZkR2t7Ve7wcZJkNA0dfQ3gM4c/Dz7Z0M/PSUFRZdB/TavRi5p38Hwwha4dxTKPXWylNeX5MhplH6IRHqvAHX5xy2VDnUXbQ3/KbSsKR+TZc4hCymh1zdYrybgsdSmwT0kDkS3ZuVljrYNbKfmjRTPX7d74hOaU2XMr7HyimimJ1zVRUW4cYWugxVG/kwmoIz4sXs1p/TqZPUHAFKoH8tbGyFeNyNGOLP+iaGnx2q2Emu6BLezPs8sbX+G0A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbZxkBezUT/cGay+MSA8qvq4KIds1iW9RmlOdh8Io+s=;
 b=YHcBJ6kG31c6qFS75+1brekBo36rZUvmN4JGpagiSodJF0Fyr0BDDSGSqf7e5bui4OkUiKnGj6Nj8r6M64+W6DpRChItgUN7ekAWxPuMz0K10uHjGsPhz6e/n/HTX1imP7/8HraRmI3WcL8eWCGLshI8O9J5mHFIPqF0q3BI1is=
Received: from DU2PR04CA0087.eurprd04.prod.outlook.com (2603:10a6:10:232::32)
 by VI1PR08MB10031.eurprd08.prod.outlook.com (2603:10a6:800:1cd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Fri, 19 Dec
 2025 16:14:01 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:232:cafe::b3) by DU2PR04CA0087.outlook.office365.com
 (2603:10a6:10:232::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via
 Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sq0GI5tVc9ht4TTXH8qRGZ3abrDxz/K8PxZPNu1nuUnHj2/8mjg/8Hx0ZO95M2Vrqy8mqGaU1V5cpGbRFknrmr8xdpThtwUsKKAHvqcNrbPi3GSuQhKI3K4a0AsJcSeaDpPrRHFlphsYZ5rj8c/Vhoh7LLRW9g2z+ON6rvb73txDrJwZZOAyF8OKWUypSh0uBuqZNOasn0Tem6ftiPZ59yrXVqNgWiQ1V6Ft+96uM6Sf4HRE5TaoNR0fZLIrbrYKeBoT+OvxvLYNRGXJ2o9YzSvv3UlJwiUZvNfJ7qUu7O57A3YWoT2I9RtfKRrEVzRCL9YduZ4F+yPbvDaUxbg0Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbZxkBezUT/cGay+MSA8qvq4KIds1iW9RmlOdh8Io+s=;
 b=B7PhFuQlsujwRubgEYJqn/qxUbBL1TnWxNGm+rf2G1wz6V9BtoOCjfAhBIPNG+gKzNUucDSoy7yLQagTa/+gRY+fskCBcyQYoa0ihLAKhnOoNparZLfxpsby5h331gacWnX25rIsenvmkePHz/fhXNqIx/tHl5bQSiPcOnSWFUF+mSINJ7pLNb0UwT9YV1Wyz30MiR3SSdy2OH/TkZqALDODJuIEWGsLw7JogPbQ/q2xDbS/DRNWnfZ9CCFk8eNa4XSEr7AYjZQl3sft0dDZVVduVG4MSg1MdtM2x2V6vrC9xNoCLTRLNEDraUogIBH4HXFHOyEki3KTZRVbHYVCfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbZxkBezUT/cGay+MSA8qvq4KIds1iW9RmlOdh8Io+s=;
 b=YHcBJ6kG31c6qFS75+1brekBo36rZUvmN4JGpagiSodJF0Fyr0BDDSGSqf7e5bui4OkUiKnGj6Nj8r6M64+W6DpRChItgUN7ekAWxPuMz0K10uHjGsPhz6e/n/HTX1imP7/8HraRmI3WcL8eWCGLshI8O9J5mHFIPqF0q3BI1is=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:58 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:58 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 08/17] arm64: Add phandle for CPUs
Thread-Topic: [PATCH 08/17] arm64: Add phandle for CPUs
Thread-Index: AQHccQJWSIV32iijfUSGbUrZ7l/3Ow==
Date: Fri, 19 Dec 2025 16:12:56 +0000
Message-ID: <20251219161240.1385034-9-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DU6PEPF0000A7E4:EE_|VI1PR08MB10031:EE_
X-MS-Office365-Filtering-Correlation-Id: 2edae7b0-cb1f-4a9f-fea2-08de3f199f0f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?KysapLebfGkVJ8ipKsjxwtZ5Zbd0eoq4vlX+ViP8OnOt0BCvQwT/AmAu99?=
 =?iso-8859-1?Q?Vk1LNJ0nFjYLlV4JUjraaCETeznc8bvDDfqlEFv9aPAgxZwh3uPfrd0oRM?=
 =?iso-8859-1?Q?bOf/orh7UIuSnZda4C3ltmBfADnqghML7lcH+dAK9kA2qE/eMzq2x5YknK?=
 =?iso-8859-1?Q?LLZU7iMbk8IYRxdbV9DatPiQzmd8eEcN+4WTRB5Gj5HZS3OcvTOviaTy2f?=
 =?iso-8859-1?Q?O362ZSTkw/jlYSORGGYqshhEBfmV2MDp+OAceZ1LJj6qbd9sLELo5h3jQh?=
 =?iso-8859-1?Q?5UERrsAp8PmRNrZSJ+v6vrGCc/JwIgJkVtayqxXwBLhxU+WZW6dtoxxViQ?=
 =?iso-8859-1?Q?pGZmUM1VdWLk+riN0PUpu+yDtogxUAXWxj6iPV3YP4S3oMt0plStws9IN6?=
 =?iso-8859-1?Q?ZbvsT1hzeEQ/4bxRJi5dOalSVes4K+iqmRfwbM/85PWm7uvoeGrcN8Cb22?=
 =?iso-8859-1?Q?GdA+0jwOGur7ywiy/uFllrf0riPHYPCzkBEdB8SNiGEdAgVk8qT7oqFkyS?=
 =?iso-8859-1?Q?8ODqX3MLPo1jSFRCvD3JV+p63IpfbeZXQ/VVyXcWUZvN2z/YqVete7wvUB?=
 =?iso-8859-1?Q?8v7JYik76+x04cKsrxyySKLGpX2KENLd+JkKPrshsIBW5J0if5fIOQfMpX?=
 =?iso-8859-1?Q?oUAUw2wWMbp/WwjnVsnpE6L66iR70SUySIfya36XpC2/XiNV3LY0RXGKLQ?=
 =?iso-8859-1?Q?HfUe+sPRlYKh3H8iuF6Rb1KLPsEcOZoiPCjSKJHSOmKIFI3BBHbrT/+35t?=
 =?iso-8859-1?Q?GbmOkTSxs6XaPk2ZGf2DjUhC9WbU/uw1OgOmP0jEu7EPE8Hw/k+MCnWZxJ?=
 =?iso-8859-1?Q?xdzt8BG0glX1p3D7e7CGjql123BOdYS6+/3e75c4RDuoSbDku1oVGgu34Q?=
 =?iso-8859-1?Q?++tVjYMdjS2MW0LLz+9nBas/0wcxCync44Bz/7+ftLM8LEfkk4AZsv3n/s?=
 =?iso-8859-1?Q?mJA9oed7ucsKtykxbaLyf0isSzoieFKSLMX/9P4cUo+Ssx49X3zT2iBrKG?=
 =?iso-8859-1?Q?3wTXqRx0n4d1zEOipj+NYGZlimJVuBHbkypAQP0NYYVH2WeU2PE2j+Mhce?=
 =?iso-8859-1?Q?8oIATMuaQkBva8p7HYGo1A5ZRLvCbH+aLp8gqjhn/z9btyy41Q6S0bA63d?=
 =?iso-8859-1?Q?dkQeuDNX4riHV47RJ/AkcijZ8qqkSkbtPS9FVAVU73NdVlRKznvCfrYWl4?=
 =?iso-8859-1?Q?3yV1Q9WdGrFwC+x1/b5XBE4kdTTqgHsI9E2BrMFKmD1VEMqwTbGUbVQ/OD?=
 =?iso-8859-1?Q?qSNDLcDiK3Od1l8Ij04bljIFPHXyA/9xuKKu2U2Ro2z1F23QUglzvgfSwd?=
 =?iso-8859-1?Q?wHRRkxQV5XQXfhAfu37JdhwdGr8SbSm8GfaSyhJOHGuU+elW3SXcX+M883?=
 =?iso-8859-1?Q?ijSO3lBOYppGx9LV87iTp3E3pniqHZvZ9jC9SnT9RzernXBGdp63AqhR0w?=
 =?iso-8859-1?Q?SgKYSpW4ew0TV7aOQFcSDsQL0oRJTcsQruDKLPrl+7BPX7/8dMRKSxE/uf?=
 =?iso-8859-1?Q?VOy54/obWSDBRCnrZkIzBVxplVUsD1wSNbhS8U9wzMyOtM1oHuduaPwqfL?=
 =?iso-8859-1?Q?JrT3d8ty2Jg/R4ndKNrzmVuJdmcm?=
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
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd8e364c-6ae4-4123-bc77-08de3f197a10
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?dFxoobHfdlAbrmfXMAgPgc+agq9m2Z7sNpjdSrmPy8c0qTVJk8qt8Cu2u2?=
 =?iso-8859-1?Q?pxzHFSEhYrGYdbgEIrnXKyvo4kxOwxuDTlL05/aXyU/hcqMN47WPG+ANZe?=
 =?iso-8859-1?Q?bB03eA03Q6R/zJTW7eK/SGFydR2ILZoL0A7wKzjy4E0oRctskODsMVtDPv?=
 =?iso-8859-1?Q?ittavhTnqDl6/CJGit2kt19K+8Uif8h2XBMWoM8TXZQIJqyXWZB1IbiQzl?=
 =?iso-8859-1?Q?iD7o2HDKcsB1tqiq4hZ7zQgW9dXAZZnj5xBmVueLh1Zvy14ThRoc4uHf5X?=
 =?iso-8859-1?Q?jTrOiOdAEqFo0byTRrxzPXMvpRbdaF0CqrJLI08Idgx06hsj0CJV67tOjT?=
 =?iso-8859-1?Q?Cy9eReITNoAslQTRHYa1JyUUycFpNUYzU13m5t9QVdixPIZiH7KKwPweZu?=
 =?iso-8859-1?Q?5LcuNDp1R8WXvZfgRSScbLSH1whY9/VtIEdOSUXXoqhv5FkmOMJ4yyYohm?=
 =?iso-8859-1?Q?BqAmXELo7vWJ+R9WcKZUHFI+4O8D+AP8FuCV+dMiwyUqKnN/ofeqRp7b6K?=
 =?iso-8859-1?Q?0Z4LEZP26kGv+u+RcnMSbeXVoNE2qKZMc2cdS+M5Z44QX0oY58kWxpInwB?=
 =?iso-8859-1?Q?WmRyNNrQzmmNWO0/rT8+e+i6qOWxLJwS2YGp43Lh+gS/Eb3Z6GRuxbeoMV?=
 =?iso-8859-1?Q?bVJcO5P50uwTGG9IvskEj66fp0BeGg3vgp/fNCqbSsdhnFRbaF+sWbgs09?=
 =?iso-8859-1?Q?DQzvcbV9+mcE9zExaEWwJkqzTqxi1L87hoLoyiRhf91TL4o/wv57BOz71M?=
 =?iso-8859-1?Q?xzyQE0lDrHfmVOXjGYGjx0P0FVbVBOvo8sd87bnwGQsRbeISCjkMOa4k8y?=
 =?iso-8859-1?Q?TqOlCTwHmE6IiFhZ1L0fjabbN2ILffI79bhiZA8SuLkATshcIB3hOAmOKI?=
 =?iso-8859-1?Q?t/A6Qcz3Jy7EEcP4A7PIwuPD7YHKXcdHEhatU/bHSqNTV5mpySrOmnULD6?=
 =?iso-8859-1?Q?ICBRtb5zPS9+asAROjafhHLPRnrjfzwsAYaDtBHMks9eu3c+/w9UVhlkzF?=
 =?iso-8859-1?Q?8M+FWqx3KiJH57o01srf5oVJcGBDAPMMHDpAq+A66Hr76Bs792qEyR/Iwa?=
 =?iso-8859-1?Q?h09qX2MNjpD1NKBM6mbGf3ADHwStQ+H9T6NKbZeKyR85vfv9wB+T0v7Hf8?=
 =?iso-8859-1?Q?gXhgbaJrMPKdOS9MJWkYz6vaaxv0Gqmct+KFjeUmPhWWMqEpoLcz0cz3Yp?=
 =?iso-8859-1?Q?ogL0bdCFiqdvGoUNsew10WznhELpLD8m6TrUuN768kjNXJBGz9xeECK1yI?=
 =?iso-8859-1?Q?NpsO55cnX+d5h2TyICtcDd2LHCDmBDyxF1lFKS2KxzWRXAEYNTn3XLRrmC?=
 =?iso-8859-1?Q?/feI01kAGx6Qfpd/MbN9wHecl2JIQu5e4jW8OiafnTGOUCustLiWVDcuTO?=
 =?iso-8859-1?Q?2eJHcCSYqbkW0+OiI03/ZD5Y5KANAkF04/gyx1czyv6VGEyD/uxp5koOOP?=
 =?iso-8859-1?Q?rdOgmKmgE010US1++8h2Xq052cRa1DuQCtRVWfJrJxEADX/QeCCo5A40uy?=
 =?iso-8859-1?Q?vzCUTqq4Qq+Pl0FkpYKX46848WL1onPdPWbpDK/JXJFRBWswQPRamLdInl?=
 =?iso-8859-1?Q?+vLO0f1CkUF0PLKawG85HIer2Z9WMK+ETRm9YEnQ6XcFYvZZdfEbfAmbJ4?=
 =?iso-8859-1?Q?AA4gFxnk+h+jE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.7561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edae7b0-cb1f-4a9f-fea2-08de3f199f0f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10031

GICv5 requires a mapping of Interrupt AFFinity IDs to CPUs, and uses
CPU Phandles in the FDT for this purpose. Create a per-CPU phandle
when writing the CPU FDT nodes, which can then be used later on when
generating the FDT to create this mapping of CPUs to their IAFFIDs.

These CPU phandles come after those hard-coded for the GIC and MSE
controller.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 3 +++
 arm64/include/kvm/fdt-arch.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 98f1dd9d..44361e6b 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,9 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm=
)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
=20
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
+
 		_FDT(fdt_end_node(fdt));
 	}
=20
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 60c2d406..3c3bd682 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -3,4 +3,6 @@
=20
 enum phandles {PHANDLE_RESERVED =3D 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_=
MAX};
=20
+#define PHANDLE_CPU_BASE PHANDLES_MAX
+
 #endif /* ARM__FDT_H */
--=20
2.34.1

