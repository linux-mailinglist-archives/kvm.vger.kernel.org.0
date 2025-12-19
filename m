Return-Path: <kvm+bounces-66362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE43CD0C2B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 988F93130E09
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879AC364054;
	Fri, 19 Dec 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H+xl6lA1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H+xl6lA1"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011036.outbound.protection.outlook.com [40.107.130.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B065362132
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159636; cv=fail; b=SPEnz3GORqfn9AJPZQ2+zCk9m+y6H/3a3cmlem8ZVeBpFfUoL4n1ry66wsqaStz36enDA73TUdaxPrES9mtZb/l8UBEnf4vIqPtz9KkL2g/wg2h7GXLfjw5USDUkScUb9bckorHBBg3W6yMEgQjeBwQBSRpj1MqoJNe5UHqoAx8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159636; c=relaxed/simple;
	bh=MojO9LzltCZJhEukGk0mHHO3zaHRPhpKKWWD+qNJBfg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PmkkAV5QtdAQC0hhpyEPp1ykiCiRIi/u0HD24uN3yIrKg6lyDIQaBBUH4pGFATgY1LRz98HgfRYoZ2DHf5E0AoMqPOsvrLRx3gTZ0EfC2uaEizp2VqvLWunVnxdmJnnDzG9iH1DgdQ1FbIbFwbK76A7ShQlwxWkzT9sETJk4PjQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H+xl6lA1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H+xl6lA1; arc=fail smtp.client-ip=40.107.130.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FO+wWbj8dGBuijhF7nwRnrZlVC6PcASHXwep57b4QpucU/CN18pmL2SpgjVfCn4oPWVhPtvUQDqI8+/i63PG0lRufP6T9uqX3uIPJuJ3RWQDyBY+GpNgsRy30W6zoLDObIS/ElC/bygr1odb2ug9p/MAtwABkmEGdi90Lp04u1JXIkKthMUk3k4FOFHku3BMhyEP2sXsLDP9YugA5VcD8LzxtJJpfO5dCbAXPQZLrnD/T8fBxTCRFQvg/cxCkaMtjFenJckuQs1xCCGbRmg8FJAvifcPuFN3WxxNTox2TX9A7W4A98TkuzLbcX0Q1W8bvRyBAFNDSeMNGc8ZBZ2q0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiDR5ZjQdZ7mXM4UPLCu3SvsU/0x4yLnOKxqNWLvhCQ=;
 b=XLYKks0bqMGancdEJH9d3lk7wFMxau8F8VSCF4DonnEG/pGUrb3lfELjHDWo2dNL5RKIL/zavhZ/xs76BvluKv9wQyyvIdK+UOpg0ykBs4zubEs0rDVwtD2uWew+V2hyBgyndzEw38s9zUt0tVdrJ5ff9ngprExvIhJ9hPtRYQ8m8nfLClU+/QHKMQh4fFeKQ5bDL7VOnD3f8b0HvyTv33ucoIVy/a2o1Mr1qxQE1dGP8ld6btqfqcK5/pWkcdN+g4pN2o/NCHYmCKJUiMJaANzpICnsYRPe7DGYjiC/f+QhEZbTdG/IV4x8Rd2luxWpFSIvt+8MgtQZcoD4WjZP3g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiDR5ZjQdZ7mXM4UPLCu3SvsU/0x4yLnOKxqNWLvhCQ=;
 b=H+xl6lA1ImVycZgrl8+zJUDCUpHWPRe3xl8WmGtGvSIS2EKY5jLilkcYiUp16GyUvj2t9aWeTfSrO3tZiUeVU+mwot4p54Z4X9pTnjYvmurNH/FvCcvysUFVx0F1HpK4cBnm9oOFqxt3/RLnHTgxsOuQhyAmZlKcLLEorEKGAy8=
Received: from AM6PR10CA0028.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::41)
 by PAWPR08MB11455.eurprd08.prod.outlook.com (2603:10a6:102:512::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:45 +0000
Received: from AM3PEPF00009BA1.eurprd04.prod.outlook.com
 (2603:10a6:209:89:cafe::bd) by AM6PR10CA0028.outlook.office365.com
 (2603:10a6:209:89::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 15:53:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA1.mail.protection.outlook.com (10.167.16.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cx/ILA5rfTFJriLWx0g73HFioiCKSOwIy3pw/V0l/ha148Vr/NMZUZ8b07q8VAvxwzYOIl07XKc/cR1TZsKfBUg17uMJ92gCLuezBBhjCBqOcEzEGarx0PLtvC2Rj9C2ZBA0JmDeE27qDVGTbYBN0xTTncKxgLK6VyJRSy2zrniOSCvNXwPP4C5qNePzLr5+v4HTNtnf1fvx4VWEAQ3zNN9twffzeKmQ6O4NyKDRF9oiuHLm2HOoWC2M1qlZC4PLqKkg9NbYNkdKBoyl3plnhfNHfDMzEGbqk69BtnOKegIyF35iQMijyoZZu0mm3TXXJ7OEuUzo5822Chuthis8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiDR5ZjQdZ7mXM4UPLCu3SvsU/0x4yLnOKxqNWLvhCQ=;
 b=ZUbLKDueEx/6aZ9Fc7jOHM+EVp0ap2NKj/pk4lXIeIWFZAEhskBSFp306Z9EWUVdd5vfKHhr0tDYw+tXyhCpRel5tN9S21+hO1ptNJnxLdWpljadcr0xMz6I2uI2bwOpxUJEdhvrePU94dk6mAfy/VSzbNK+5vuKLNblFREp49zlrdIrDLMjTGOi+fcPjNAH8dzf4V61JyPubYxzFpADJyekJNRwKr3kDaOxcFPQafqdH/o57/TYvQEx07j7mtdorJKXEHSxjB3D5UiPMVL3X++0YyjEqc5Ygkz1CkuxWbvF/bapXo3lyES16E83fi4Ztpvb1mjuhN3oXE5F9HsP2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiDR5ZjQdZ7mXM4UPLCu3SvsU/0x4yLnOKxqNWLvhCQ=;
 b=H+xl6lA1ImVycZgrl8+zJUDCUpHWPRe3xl8WmGtGvSIS2EKY5jLilkcYiUp16GyUvj2t9aWeTfSrO3tZiUeVU+mwot4p54Z4X9pTnjYvmurNH/FvCcvysUFVx0F1HpK4cBnm9oOFqxt3/RLnHTgxsOuQhyAmZlKcLLEorEKGAy8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:41 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:41 +0000
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
Subject: [PATCH v2 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v2 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHccP+B6txkb6ovaE2rEd1hmeoylg==
Date: Fri, 19 Dec 2025 15:52:40 +0000
Message-ID: <20251219155222.1383109-15-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|AM3PEPF00009BA1:EE_|PAWPR08MB11455:EE_
X-MS-Office365-Filtering-Correlation-Id: ff6bf0c3-ecc3-400d-6c0b-08de3f16ca67
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?vLz4TEtjhvSpARaqQB436wERd4+Rr8eTCHjI59Qc6vkEfTgFx8dLuyN6HA?=
 =?iso-8859-1?Q?3ZWB+r7Va62lBW6G+yIbGtMwvCoYxlujd4fNrMJZKHG6damgg5d6+GinjV?=
 =?iso-8859-1?Q?LTJK8BPDZ64i7KP8C0nG0SmDFcZten8vPwno5NuAH7wLQA0uKbDRfLWa2/?=
 =?iso-8859-1?Q?/nPlVwHfUg145hGiaAy58LY3bLKH9F13cRuXJiJhSDhbzzYaaH+Y4qg/7n?=
 =?iso-8859-1?Q?phbpEtQf8Wa1uQK1+FIgVRjlZPYOqPScNv9t7qiCnA5vMKXwV02Ela0Q/T?=
 =?iso-8859-1?Q?AcINHsANie5K1/hE4SXcDa4z93gZzx+kosm9UftXBHf4hLv/Q1Ie3dI78a?=
 =?iso-8859-1?Q?05vFs8pHhgG3+sJso9mUFcZoE4+hlgcpkIzyFRPZ1yDNmm2+zU/tWCKLVi?=
 =?iso-8859-1?Q?3KysUU+z+lymv2goj/mwkyNOsuILNbuoT2xRLETMbsJbD3wPTAqETf2mPF?=
 =?iso-8859-1?Q?1Fbgw0L5v9VfSA8lZEmDGiKstCw1Ge/2PFIfegRhC0WtE9uiKfC48PHKV2?=
 =?iso-8859-1?Q?KcAdn1zYayR/s9WMhHOoak3m6r2dIodGOuWjvy72FYfPsgWJ1qt540MRYd?=
 =?iso-8859-1?Q?QLs0L0ZwFWJ9mt2A+i7LdhxdG3UKGuSy9KH0FDHtMOFle7oKuuqc5Ot3uY?=
 =?iso-8859-1?Q?Mx+KAu7psqH2QFrTqPO8NLhUY36F+O/cm3gdjCV8sebVHVoV3Fj9G/BHkL?=
 =?iso-8859-1?Q?TeVEnB5xO/aV6V8iKWx5kUgPnDIQ9YawNLbmx6F8dWZYbgPkN4Crk8yFxN?=
 =?iso-8859-1?Q?cwD0rFz3SgEkFa3qZ06M3woVKlQzyxTr5A38i84Db3z3M1gEuwC1CoWGJ6?=
 =?iso-8859-1?Q?HXDVoIIeN8DiALyCVqxashzk0PdIAG0PWW8jGmt+sDEqn0J9o0OydSlVLH?=
 =?iso-8859-1?Q?fh0b9pIk6EWNRJ5D/7hR279eFHHmnqvZciVZ1H9GfvhxsCnKiGVOf/3GgL?=
 =?iso-8859-1?Q?YdvMOrgzhKtZvt8RPqhD/40tHQYiB6pbRCqU+ojqohhHuJ9QceN3rQ4LwY?=
 =?iso-8859-1?Q?mQkFh8UIE6IBvcPqR/kNDXuYvM7vTfaDjj6fj9TFdeZCyHOolRpukdsg0q?=
 =?iso-8859-1?Q?ny2E1RVirVEvMsqMHmbdIgp0OiIdiOGAd+IFPGtOGE3+1Lok8DhmgX/Ym6?=
 =?iso-8859-1?Q?+SVRnlFmwzE9YG/s9wsXXiurnt36Et8qSqBQetu7vbGhjZTPAUr646tO02?=
 =?iso-8859-1?Q?/V+ENPV9jW5bwOQDBe8DJYxHAZn19Dq/v7/oCEwE9c+GIFPFyEi0Dkw/hW?=
 =?iso-8859-1?Q?x+ZmA8eTyRJEcqJyeR9PlTKrf4ensu13QKDlq4NRGvp8hhhOmbefSeuOop?=
 =?iso-8859-1?Q?bNwfsOPuvoVUgyyorKQq4kRv63rZw8ILePwZtfJrYxLgxwdgYzCVQttwZ3?=
 =?iso-8859-1?Q?qgHRu3+3zyvINyVTB6COPM70mGAFa3u79FZux6AyBb/1UeaKUspuLAcv+X?=
 =?iso-8859-1?Q?sIQ0iwh/2A3cf7wRVIndlbR4KOHUpOdB49jntUsywFZiq1+eAoKG3sKDiR?=
 =?iso-8859-1?Q?9h0fDfVnl58Nlh8YeLhQsx8pvq6JNCWRWdccTvzUwOT8XZyKHoxtKlwFvx?=
 =?iso-8859-1?Q?s21u1sJb4zX5xUm+lM46yzss+nua?=
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
 AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6cefbbe9-0cdd-4c9d-11ce-08de3f16a493
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|35042699022|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?4t6xmDlGENDrtlcXVDjocJZ1oVjGALQxUZZlp10wPfCkE6OrUoIWrEGerH?=
 =?iso-8859-1?Q?bPeJP/2jx02H/clGgwvduDJyYetdKjEjwuKu3mDosRDyeuVX5xnUB6jNth?=
 =?iso-8859-1?Q?ox1f+xpVvSMPiqfGGzDT5a1kWzSjZjBaSogBHfGP22HOFQExzDq6YA/tFw?=
 =?iso-8859-1?Q?A5pfBIgJVKQHBG5v4VcpsdS0z6C/3o6iNdFv9EFKbqcXFBm8BcOAam02/j?=
 =?iso-8859-1?Q?O+NyJzqKlGh1EW1KnzocyO+g8aIAn+wDJv/VSobCqvsOWHvFDdemUWu0s1?=
 =?iso-8859-1?Q?5z/v5dE8FKC8d9/aOq5GmcmILOKhLIjSlUKM5uGrU2ZfVre6F8fTxg7W3V?=
 =?iso-8859-1?Q?ncFQyNfXi7j41p+kZANI24PHnWJLsWZuQmbcvSNfI/RIe1evo/VtXCRLZh?=
 =?iso-8859-1?Q?KNE6M20A5F0zS5NT5Y/2+gdZLxKZfuFpfOn0cI6wrShVSjwe6K5v0+9Qcv?=
 =?iso-8859-1?Q?5do4b0F+vrHe38gm8wxFgn6X0saoG0ruj85NxRRNpkaLgHT/Hkp/ENaZnK?=
 =?iso-8859-1?Q?bKSab5J6/kEhBbRO3ID5JU0Qkpc3QHjp4oS8Qpi4KybC9FtvXQZb4tu027?=
 =?iso-8859-1?Q?HuHf6oycOgfoArRkCNA/qCuLTPTk0AWnHp8sJUq6MwFnEPt691FB9qHgXO?=
 =?iso-8859-1?Q?d9ttA3KspYr/G2uakA6jMvYDCfFPwMCLStjhd+V8rpYo7FFJ2ENinc6MjN?=
 =?iso-8859-1?Q?8Cyb417yuNoF7bIDOWU1GpPnzFP6SVwvucIj6JZWTzll+Trox3KP/nF/mK?=
 =?iso-8859-1?Q?9fyf6/60a8fIaO+CsUGvmM26aIX4tn/f7+K1PHmg+/VY++OUJL8dgLBT0t?=
 =?iso-8859-1?Q?wQPycrJXh7YlmLvCm4HUs6H1F7kAQDemo+R9Q8JrBqucfmoYeSqGpCsBsk?=
 =?iso-8859-1?Q?IiawpWnAeyOFwF+qHP3GWOTkvvZMom6MY0INNvTgqlqiIgkTnbFn8iGopd?=
 =?iso-8859-1?Q?cwTVTvkmbGRZCxgGvWBazFjk/sblcLp3fGgUWB7FJ9fnoarkx0xV4HvK7h?=
 =?iso-8859-1?Q?gSg4Gzj7X+4eV6sCY0YBH3HMNdVWRtRK1ylD4AssV7sLNOX+qYtpUJvnTs?=
 =?iso-8859-1?Q?bsFdE/oEqHhoXwSzxqjF593ihMe5WiEWnvZKkOi5KhBqpD/z+CW8KCOvxF?=
 =?iso-8859-1?Q?AXfxkTdCkPmp4N7lY5TaFNfoWadt41GF1HyAuLnW/eNkRf1gQiyi/2MzAK?=
 =?iso-8859-1?Q?o5g4H/NUfGTSZWC0JWGdPlau8lgGXurXY9uWWlnH0HXJO2HNlbXAM5x4DK?=
 =?iso-8859-1?Q?yCEj8Okb1N3wTuNm6MFNOWPh5rkpEjDmjF7Rjvysmp3zQcgnJrxikav3M+?=
 =?iso-8859-1?Q?WijkI4wonHn+zP6B7s/FVESbw/wM62IaFtDyQf7cknl6PGfPnTDRXwUbeK?=
 =?iso-8859-1?Q?bVDohbL2ZO1omNF8eIMluL74P1qruhRcJiWILYBHg7brJRk8pAjtZL1CA3?=
 =?iso-8859-1?Q?tDQDyULq5myCDd4DI3ySIAi1WnUMYcG3/gZL/mUTGo4vkk/NrKIgyWG3e1?=
 =?iso-8859-1?Q?S5Td11c8SDy24OkbG/QDo4x3onYG+Vh0CZ8bFI9tjJr/B+qCazW2rJ5PqU?=
 =?iso-8859-1?Q?NPuWvD/N85MmgslyCScjIWi7otOQfb5ZH3sjf6IkV1q/pL17ntRb3UKYV3?=
 =?iso-8859-1?Q?2bSL7zpzZDNMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(35042699022)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:44.9843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6bf0c3-ecc3-400d-6c0b-08de3f16ca67
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11455

Introduce hyp functions to save/restore the following GICv5 state:

* ICC_ICSR_EL1
* ICH_APR_EL2
* ICH_PPI_ACTIVERx_EL2
* ICH_PPI_DVIRx_EL2
* ICH_PPI_ENABLERx_EL2
* ICH_PPI_PENDRRx_EL2
* ICH_PPI_PRIORITYRx_EL2
* ICH_VMCR_EL2

All of these are saved/restored to/from the KVM vgic_v5 CPUIF shadow
state.

The ICSR must be save/restored as this register is shared between host
and guest. Therefore, to avoid leaking host state to the guest, this
must be saved and restored. Moreover, as this can by used by the host
at any time, it must be save/restored eagerly. Note: the host state is
not preserved as the host should only use this register when
preemption is disabled.

As part of restoring the ICH_VMCR_EL2 and ICH_APR_EL2, GICv3-compat
mode is also disabled by setting the ICH_VCTLR_EL2.V3 bit to 0. The
correspoinding GICv3-compat mode enable is part of the VMCR & APR
restore for a GICv3 guest as it only takes effect when actually
running a guest.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |   4 +
 arch/arm64/include/asm/kvm_hyp.h   |   6 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  32 ++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 119 +++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             |  33 ++++++++
 5 files changed, 194 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index ada752e97c6aa..328be86d36d51 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_detect_ppis,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_ppi_state,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_ppi_state,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 80e5491de8e1e..c965f4e178cee 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -89,6 +89,12 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu=
);
=20
 /* GICv5 */
 void __vgic_v5_detect_ppis(u64 *ppi);
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 3d1d0807be6db..e640776ca83ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -596,6 +596,34 @@ static void handle___vgic_v5_detect_ppis(struct kvm_cp=
u_context *host_ctxt)
 	cpu_reg(host_ctxt, 2) =3D ppi[1];
 }
=20
+static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_save_ppi_state(struct kvm_cpu_context *host_c=
txt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_ppi_state(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_ppi_state(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_ppi_state(kern_hyp_va(cpu_if));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -638,6 +666,10 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 	HANDLE_FUNC(__vgic_v5_detect_ppis),
+	HANDLE_FUNC(__vgic_v5_save_apr),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
+	HANDLE_FUNC(__vgic_v5_save_ppi_state),
+	HANDLE_FUNC(__vgic_v5_restore_ppi_state),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 4b088588757ea..310e49a2e6f45 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -25,3 +25,122 @@ void __vgic_v5_detect_ppis(u64 *impl_ppi_mask)
 	write_sysreg_s(0, SYS_ICH_PPI_ENABLER0_EL2);
 	write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
 }
+
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
+}
+
+static void  __vgic_v5_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	__vgic_v5_compat_mode_disable();
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+	write_sysreg_s(cpu_if->vgic_apr, SYS_ICH_APR_EL2);
+}
+
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_ppi_activer_exit[0] =3D read_sysreg_s(SYS_ICH_PPI_ACTIVER0_E=
L2);
+	cpu_if->vgic_ppi_activer_exit[1] =3D read_sysreg_s(SYS_ICH_PPI_ACTIVER1_E=
L2);
+
+	cpu_if->vgic_ich_ppi_enabler_exit[0] =3D read_sysreg_s(SYS_ICH_PPI_ENABLE=
R0_EL2);
+	cpu_if->vgic_ich_ppi_enabler_exit[1] =3D read_sysreg_s(SYS_ICH_PPI_ENABLE=
R1_EL2);
+
+	cpu_if->vgic_ppi_pendr_exit[0] =3D read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2);
+	cpu_if->vgic_ppi_pendr_exit[1] =3D read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2);
+
+	cpu_if->vgic_ppi_priorityr[0] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL=
2);
+	cpu_if->vgic_ppi_priorityr[1] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR1_EL=
2);
+	cpu_if->vgic_ppi_priorityr[2] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR2_EL=
2);
+	cpu_if->vgic_ppi_priorityr[3] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR3_EL=
2);
+	cpu_if->vgic_ppi_priorityr[4] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR4_EL=
2);
+	cpu_if->vgic_ppi_priorityr[5] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR5_EL=
2);
+	cpu_if->vgic_ppi_priorityr[6] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL=
2);
+	cpu_if->vgic_ppi_priorityr[7] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL=
2);
+	cpu_if->vgic_ppi_priorityr[8] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL=
2);
+	cpu_if->vgic_ppi_priorityr[9] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL=
2);
+	cpu_if->vgic_ppi_priorityr[10] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_=
EL2);
+	cpu_if->vgic_ppi_priorityr[11] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_=
EL2);
+	cpu_if->vgic_ppi_priorityr[12] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_=
EL2);
+	cpu_if->vgic_ppi_priorityr[13] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_=
EL2);
+	cpu_if->vgic_ppi_priorityr[14] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_=
EL2);
+	cpu_if->vgic_ppi_priorityr[15] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_=
EL2);
+
+	/* Now that we are done, disable DVI */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+}
+
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	 /* Now enable DVI so that the guest's interrupt config takes over */
+	 write_sysreg_s(cpu_if->vgic_ppi_dvir[0], SYS_ICH_PPI_DVIR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_dvir[1], SYS_ICH_PPI_DVIR1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ppi_activer_entry[0],
+			SYS_ICH_PPI_ACTIVER0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_activer_entry[1],
+			SYS_ICH_PPI_ACTIVER1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ich_ppi_enabler_entry[0],
+			SYS_ICH_PPI_ENABLER0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ich_ppi_enabler_entry[1],
+			SYS_ICH_PPI_ENABLER1_EL2);
+
+	 /* Update the pending state of the NON-DVI'd PPIs, only */
+	 write_sysreg_s(cpu_if->vgic_ppi_pendr_entry[0] & ~cpu_if->vgic_ppi_dvir[=
0],
+			SYS_ICH_PPI_PENDR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_pendr_entry[1] & ~cpu_if->vgic_ppi_dvir[=
1],
+			SYS_ICH_PPI_PENDR1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[0],
+			SYS_ICH_PPI_PRIORITYR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[1],
+			SYS_ICH_PPI_PRIORITYR1_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[2],
+			SYS_ICH_PPI_PRIORITYR2_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[3],
+			SYS_ICH_PPI_PRIORITYR3_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[4],
+			SYS_ICH_PPI_PRIORITYR4_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[5],
+			SYS_ICH_PPI_PRIORITYR5_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[6],
+			SYS_ICH_PPI_PRIORITYR6_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
+			SYS_ICH_PPI_PRIORITYR7_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
+			SYS_ICH_PPI_PRIORITYR8_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
+			SYS_ICH_PPI_PRIORITYR9_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
+			SYS_ICH_PPI_PRIORITYR10_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
+			SYS_ICH_PPI_PRIORITYR11_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
+			SYS_ICH_PPI_PRIORITYR12_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
+			SYS_ICH_PPI_PRIORITYR13_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
+			SYS_ICH_PPI_PRIORITYR14_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
+			SYS_ICH_PPI_PRIORITYR15_EL2);
+}
+
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_vmcr =3D read_sysreg_s(SYS_ICH_VMCR_EL2);
+	cpu_if->vgic_icsr =3D read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
+
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
+}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c7786a2607ecd..e3e3518b1f099 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -414,6 +414,38 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+struct vgic_v5_cpu_if {
+	u64	vgic_apr;
+	u64	vgic_vmcr;
+
+	/* PPI register state */
+	u64	vgic_ppi_hmr[2];
+	u64	vgic_ppi_dvir[2];
+	u64	vgic_ppi_priorityr[16];
+
+	/* The pending state of the guest. This is merged with the exit state */
+	u64	vgic_ppi_pendr[2];
+
+	/* The state flushed to the regs when entering the guest */
+	u64	vgic_ppi_activer_entry[2];
+	u64	vgic_ich_ppi_enabler_entry[2];
+	u64	vgic_ppi_pendr_entry[2];
+
+	/* The saved state of the regs when leaving the guest */
+	u64	vgic_ppi_activer_exit[2];
+	u64	vgic_ich_ppi_enabler_exit[2];
+	u64	vgic_ppi_pendr_exit[2];
+
+	/*
+	 * The ICSR is re-used across host and guest, and hence it needs to be
+	 * saved/restored. Only one copy is required as the host should block
+	 * preemption between executing GIC CDRCFG and acccessing the
+	 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
+	 * it is the hyp's responsibility to keep the state constistent.
+	 */
+	u64	vgic_icsr;
+};
+
 /* What PPI capabilities does a GICv5 host have */
 struct vgic_v5_ppi_caps {
 	u64	impl_ppi_mask[2];
@@ -424,6 +456,7 @@ struct vgic_cpu {
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1

