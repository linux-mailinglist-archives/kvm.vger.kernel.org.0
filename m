Return-Path: <kvm+bounces-65508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8809FCAD982
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 16:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A4823079E86
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 15:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CFB2ED866;
	Mon,  8 Dec 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDDdgXMM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDDdgXMM"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010000.outbound.protection.outlook.com [52.101.84.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D52E54D3;
	Mon,  8 Dec 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207778; cv=fail; b=eLPkxz9bP2uIXg3Mwt8hmVkQt0tdgmeEAy9UA3+tq1Ox5qTq9THAQ1Rm33/uBxOo+7cTSyGWZlpeqkMAxccpe4ppWHV8IAFm/daqnB8+2gRyjlqN9HtvoXlaA/0WlVo3PvskuwnD6TgEw75DwkzVwogSlFuVXKGQmQLsSyYkgaY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207778; c=relaxed/simple;
	bh=wrs3bCok7wcIfP6Gp+80t9I8A99PF6n9THlzINLko6g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bHcoP5wXlURfaqJHqKltqiBJ7/XRqEC8VExt5OA80V6NF8C45XdKPHTeY8QkGbODbDykOEacdCP40N9hIA2bFsNm7femRKC695dK1dQTmOwGa3SVLtm+vEMPAcnU+wg3mmYCnlszE3U6EiPA68xpNLGoUzTA5FDPm/6v5yIOqS0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDDdgXMM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDDdgXMM; arc=fail smtp.client-ip=52.101.84.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=g54Htv7beXsK/hL1Je9qae2ppv1Cfz6H8eXGvA6bzW4B8ciEwI/p6EqP1IBw3phKY6rwvOTryQTQVmh2q8Evo2Qlk+gWL9MUQwYBR7gwTXofBNLPC9qr8Qszb+p+vv0D8BVX4+9w2j9NTP+EoucNlM+jgH0rbOGWT95SAuUDbMyIq0K3q/eCzlN8ZXdnITbCwh3tsBUxZkTVvCgjo3Ui9kPggksF/pQisR2q5nBCWFdO4+tDf8uMPJhUNyPCq9FK4hHkO2BYrbQRf2+52OtTaeYLlAg1do7OFXaiDoXaXpDjYHuv393s0Fc/yEIwJjI3lzdrmUus/IXhv+SyRADJZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=jRHpSNX27F4jk/YNFrrrG8yNmmbUzGNjxfgDIDvNL3+b4kB5BIqkYEDcEPm9jSdNR7u/Fe7/Qx/804628vkzlEfKtOiLkyb7dg7mU4UmJUjTgDpoIso3wQ8ieYQq9SZMi0VUOpuODqwJQfEUoC3bSyOyX3zFIzfT070xHND796t2jfcze5XFoPT005nD9ERkaIlF2a4WVJffoBZb1H5eRVCJN+tltDfNOAk53u+wTnhpTeT8ydfmz6HcVsJId6ijKATqh7pzYhpWqnJ42ESUqt1fiju1I2ONaihOm5YzI6Vfj1igycAuzG6HRD29CWWbRTRJ6FmiUQI7SAkmPWnWIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=googlemail.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=hDDdgXMM6wf0jvaPZE3E8iDizLclPs6W3fp2T7wxnnOJCm7aOnA1qr1OyIh74QeoZh/kOgoo3S0q0aTDBCgN5N678fzUf8IKL5zXN2u/c/E08UgebK40F9jO/X7CZG6jtp/XK87u+dXK6ZL/p6NUKwcGWxIsfK8IKkvK2fNyehk=
Received: from DB8PR06CA0051.eurprd06.prod.outlook.com (2603:10a6:10:120::25)
 by VI0PR08MB10917.eurprd08.prod.outlook.com (2603:10a6:800:252::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:29:28 +0000
Received: from DB1PEPF000509EF.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::e7) by DB8PR06CA0051.outlook.office365.com
 (2603:10a6:10:120::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Mon,
 8 Dec 2025 15:29:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EF.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Mon, 8 Dec 2025 15:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cJxBPb9JBs4vxBewLk6CyAfEdb239v+ZzlwPsZaopQn4GUbJvIrllQHti+iwngi/GKfRcrJEMI58M+MLTJVGZWvBidsqre3kBSxQIKxCnIqZL1HACGnZ6AFFkI7mYWZmicU0VwGR+ch0Y30nraC8qq9wdn2p7GQKQYhZ5kPvbA/ly5QjL8AE2QpKsakZLPpavSOw1svaVtucEZSv+2fiEaIbMOpq9uzNfDKl4VqGpBylVSmc9iO5jYsPMDnp7CFO3jemYj2wxhRhhwdKZdMVgRhYPWY01+bY/32enIeaVXbjvp9CGn91hmGSvZ4m2F5BIV+paF8rEcqdyk10KbR/Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=HXyYVIJPafz55jXrv4585Ii1eQ9+pfDMyeV2Jv9B71Nob4VNN/5+fP5qbX+w7p2L6mwJbfKJLrPPuHsgcmtvZJnUJXlSyk9oYtGsdE2WpdM/ZzCBiNKMVeRb5FP0Wc515aPiNbDrhQICnZb1+Zy3X8V5qHXKu9S0qhi3xWcCGVpigy3SN9X/WgM2MYAib9Ohk1PH8nKwap2z8yKDHk8UyvtsmJ9PM3aJx5GehQn5137n4/HsVEMhYnqSpcT15G2gS32C7f0iz1AZvGg3AYToWv8aX8mEMQdiGRGxERpy8YUb+IebXXquIbmU1izC+OrTAE5JXAlUL3SIohDgHs13bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=hDDdgXMM6wf0jvaPZE3E8iDizLclPs6W3fp2T7wxnnOJCm7aOnA1qr1OyIh74QeoZh/kOgoo3S0q0aTDBCgN5N678fzUf8IKL5zXN2u/c/E08UgebK40F9jO/X7CZG6jtp/XK87u+dXK6ZL/p6NUKwcGWxIsfK8IKkvK2fNyehk=
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com (2603:10a6:102:2fc::17)
 by AS8PR08MB9573.eurprd08.prod.outlook.com (2603:10a6:20b:61b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:28:22 +0000
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f]) by PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f%4]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:28:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sascha.bischoff@googlemail.com" <sascha.bischoff@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>
Subject: [PATCH 0/2] Enable GICv5 Legacy CPUIF trapping & fix TDIR cap test
Thread-Topic: [PATCH 0/2] Enable GICv5 Legacy CPUIF trapping & fix TDIR cap
 test
Thread-Index: AQHcaFdJi092p79CtkuLB9s/+novxg==
Date: Mon, 8 Dec 2025 15:28:22 +0000
Message-ID: <20251208152724.3637157-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAVPR08MB8821:EE_|AS8PR08MB9573:EE_|DB1PEPF000509EF:EE_|VI0PR08MB10917:EE_
X-MS-Office365-Filtering-Correlation-Id: a84cd8d9-77d3-4b41-d540-08de366e9360
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?xRybtCPvqAxJ9M/Fes4kL9pezwEoELSG8x1pe4SvGzz15BTMaaromlnyhL?=
 =?iso-8859-1?Q?fQktxLDUv1nM3lYeLhl2xILs6Mxxvu9qnpTX40Ty6eohLif4yYABp1cWXf?=
 =?iso-8859-1?Q?6mSKXBf4KrUNhEgUiKPIhHjdWmmPJWp+pq9vao6BBpI7xag7ALStKWYiIs?=
 =?iso-8859-1?Q?YmcPvICBudo5pITxvnjmx7dmjg3wmy+sp+BXPBJ4yIEO6eLa7Qod1nRwj2?=
 =?iso-8859-1?Q?CBcnAicI+NnqLKMcOE1vvdjaEZmkZzn6lm/dEWsIO6ui1egA/Qur0A389a?=
 =?iso-8859-1?Q?vr//MWjyMVpp9+cR09f7qUy0EyBy94yLNiHMYQS+R0h18s4ur4PJCi7B8+?=
 =?iso-8859-1?Q?CrI5Us527CX1oBx4ygHBEyiCJ6caktBsaVV12exySaxXclCdOKmjg7ebea?=
 =?iso-8859-1?Q?jkhOzdrTkJEcpBIRZRaqrfilitx70axKnLH73EsW1a2i5qWOMGbf4F9KGY?=
 =?iso-8859-1?Q?uAFHZLOkqdOlshED6PwEwDXEUAnjRdI0Puie8S8aUm9/naSsmFX3x9WbVW?=
 =?iso-8859-1?Q?6tMdXDG5QKNBIAQD0vWJTVnVGEN0G1vjlsQ97plztCzStFkfbIl0zhoGHP?=
 =?iso-8859-1?Q?/12Nad97pnDAc7LhkX8nBeaYYMxch8ZfJDoOfl/2B155sMuHOBZzmrwxOx?=
 =?iso-8859-1?Q?e9sRuxVZ1fa8iH/UmlLgmQZYtzM2Kof/pOXqy3olQClqgsaDX2tR6bHrL0?=
 =?iso-8859-1?Q?mcEKTRz/z7cy0AQOCyOEpYe5KYzUWdD+BCHtWdkxaMiYocN2sXRXDQ3T9h?=
 =?iso-8859-1?Q?mGzuUoeEY0ayCKXcIy2B9RI2k7R8f4ebpULjdOTCf1PQ365gqq5rsqeIU4?=
 =?iso-8859-1?Q?HSk9nBZGHXnogNGocbvDWfwuQkBzQkTxu7buKAxvVI5EVTPrJljjqTvQJY?=
 =?iso-8859-1?Q?YFpWkLlllaLMdvw/sFQmuSjwAaTsqritE+xK9zXdK6EF1llUF6JkT+XOZK?=
 =?iso-8859-1?Q?ttP6K6XSD+xguhAqmlJmGLOqeQYDbjdcnSEEfJuulgcylfJT11zUdGWFW6?=
 =?iso-8859-1?Q?z38UoUAZOYMOhdDDMB8RsEmrxLVF0IxLGcEedzE2Ica+juydbTRY+dFAr5?=
 =?iso-8859-1?Q?1Sp2SPHqJrx+oMN4iWNN2JnFe6PdC9NjZhNqN+/oE5Cx1Bay48fpnYyaI7?=
 =?iso-8859-1?Q?IywR5Q8/oRBOkXBiItQG4GtaIYroBTcBPcBmMnDjOp/3O0MK8BpnnGp1yy?=
 =?iso-8859-1?Q?jZlO7HsP2okZjVU/NFfZtGSPIxL1CM+8ck5tFN8aqceMTA6BWcf/+MbOJP?=
 =?iso-8859-1?Q?83DEtrTPLU52wocNebzWwYFMxwFMJx5sEkg0put3H0Y81Wv1Bt0m1sNBg2?=
 =?iso-8859-1?Q?Mb2PB4446iN+HNT+GZ6wctWu+7m03fp6j19y0EQ4ZMH9/VLGx4Ej4uA5gY?=
 =?iso-8859-1?Q?3plPqkpimC4tQy20DMG3Jy3bBITT6YuO3zaqrRYkaj2KcundbweOvvSijr?=
 =?iso-8859-1?Q?clpUyyIjXBkMe2yhT1B6VbtUg8bQUuux6WOm1i35/NHMbMPhaQaNs9zgCT?=
 =?iso-8859-1?Q?YthZNluYTXyQZx4ZS88fqkCFBf8DqMYfryz6PLskngYDUmFDSN0RpSXZ0U?=
 =?iso-8859-1?Q?6xLxx8yayf7NtLQ7p7+mjLgTFfFi?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR08MB8821.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9573
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd8254ef-2052-47a4-010d-08de366e6c38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?VoCEXcMurXwJk2K0rPRFukU4XgqPDa45sxapIq5oCS+BOGMfFgu9PACYAI?=
 =?iso-8859-1?Q?Xoswwriq5Nj5D8Y2vbx9hGiaazFCX706r8bnq+zuM2F5rupcslsaoe9raD?=
 =?iso-8859-1?Q?HBdP4jkukTsHA9FxY18jULBaef83/Vp+JLBCmhHtTilTqHqDgxvoDQdxDx?=
 =?iso-8859-1?Q?TWFxhQQpU2uXJA1uBmCSek6xIcROqDnM5WekLPItYxx6eqywaaHlqRd2CO?=
 =?iso-8859-1?Q?4xZsEdAhfx/bU49KeKJccauCTMJgJeHIZArDWro5FyWriEGCX7eY58nx6J?=
 =?iso-8859-1?Q?5u9lKcjci/1bw+SP2JuglFYvrVy3ZJzseRW9l1hS/v+8Y4921xPtaQmWhO?=
 =?iso-8859-1?Q?ZpoA/KY7DU2ghiTfK/6oAbZJJqFrN3ssFq8X8/Z/SKlW8OEqj0o9I4WOUq?=
 =?iso-8859-1?Q?QOprJwVzJPENqTXVPJnjGnueJnGCrSMYFnw6Ft/LHyUfxkfAIt+lxUWTte?=
 =?iso-8859-1?Q?dJxOR9GBHS/PkXj7CRoOaaUUlfDHVH1ZmQMio3bzvP9F4ExiFNZlrYi/6R?=
 =?iso-8859-1?Q?Fzmf85gPUp8h2k6j5PA5X+8Ehkyo+uD4oUx/nXuBJHnt61Rk/I+1Jtpn+q?=
 =?iso-8859-1?Q?/wNRilIiuOrNHEoJBFgpE3ZG19GlcyTcVJbZ4EoC6ZnyaA+XF6dgP5AoAd?=
 =?iso-8859-1?Q?+d8AoEHVlM6R6uO7kNKTmWi2+MR5oFHluS/udWmrc2mEiOWTFuAeHdNyl5?=
 =?iso-8859-1?Q?6qmmlZJlgS0QAhc9lJB8278yCwK5EiAH8PuwbcsRvNfCyzJMD1ttlkTbL+?=
 =?iso-8859-1?Q?VJR9jDny3KX1v5OAiINbn5v2XwXppibtPGC6ltWTUDL7FbyvkTIFNj+vvP?=
 =?iso-8859-1?Q?1MdhpsgkJR0mGY40h+Q3V3D2bLupJcY2zrAErNq4ZkFIGHvAx2krVnvbE2?=
 =?iso-8859-1?Q?endZf1OJ+RonxZt8UgCZxxJM2Ev+c71oMhfVDT524YNYz3oleBsBKhtcVW?=
 =?iso-8859-1?Q?f2N4a0UcOIshQX4vBIm3ZY/OiyxWvVTKh6bk6gSmHZhgrAc7Dv3lFhZ05j?=
 =?iso-8859-1?Q?Tfjd/5v4wiQtnuhI02oGKAefteBrHv63tFIaMSJyR+s4u0Y4HvFcjTKklB?=
 =?iso-8859-1?Q?pJ3WShCpKA9qPd7hZ1UTINyZit5SNw+jDfMpaMtTA9MlhGY94xKEDsQK/A?=
 =?iso-8859-1?Q?W1eH71lnhhnUund3t9bIyVtzMHDWy+bE6qmsXTS564F3KfylGilaAMdi97?=
 =?iso-8859-1?Q?Ohq4cLIVS5YCdDm/KUUz7mw9gkr0dV4MH4jmDd8sTGvhFwVBBsOgOVyfN2?=
 =?iso-8859-1?Q?HGSk6CNWaAAbPp8OrhF0sYUTKqoQIjtNC2wzgVU8NIHKVvhVKBr6qwmX/4?=
 =?iso-8859-1?Q?F7UaXhr4XBKZPDurbu6lvGBW2Xf+rcb7+UBA9rUZTNFnflhhtvMsCLY4yY?=
 =?iso-8859-1?Q?JGGYlZE3KRt5QySZtoAej5+vMUdbESXx36jz7QXrY2FwR/lylUoPG+zX3p?=
 =?iso-8859-1?Q?srANfzCrQJwJCeHjqZNTNCTsklPZZNF6Ux/5Q6LYtaOzehNSoV+7138sJW?=
 =?iso-8859-1?Q?zGroQqzMoxiQSS2Ch6Jl0CaJJR/PtUTjutSkG0yKEBw/O5Og+fG601qsJm?=
 =?iso-8859-1?Q?ZE0axmsvpSgOAP1GLcWoATJQicKkBm5Dqp9SG1/gjgoLTPt8blsde4M3Km?=
 =?iso-8859-1?Q?RTvZkvpS6X8x4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 15:29:27.9118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a84cd8d9-77d3-4b41-d540-08de366e9360
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10917

These changes address two trapping-related issues when running legacy
(i.e. GICv3) guests on GICv5 hosts.

The first change enables the vgic_v3_cpuif_trap static branch on GICv5
hosts with legacy support, if trapping is required. The missing enable
was caught as part of debugging why UNDEFs were being injected into
guests when the ICH_HCR_EL2.TC bit was set - the expected bahaviour
was that KVM should handle the trapped accesses, with the guest
remaining blissfully unaware.

The second change fixes the specific cause of the TC bit being set in
the first place. The test for the ICH_HCR_EL2_TDIR cap was checking
for GICv3 CPUIF support and returning false prior to checking for
GICv5 Legacy support. The result was that on GICv5 hosts, the test
always returned false, and therefore the TC bit was being set. The
issue is fixed by reordering the checks to check for GICv5 Legacy
support first.

These changes are based against kvmarm/next.

Thanks,
Sascha

Sascha Bischoff (2):
  KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5 hosts if
    required
  KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for GICv5 hosts

 arch/arm64/kernel/cpufeature.c |  8 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c  | 25 +++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c  |  2 ++
 arch/arm64/kvm/vgic/vgic.h     |  1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

--
2.34.1=

