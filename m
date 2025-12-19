Return-Path: <kvm+bounces-66361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 849C9CD0C4F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E1F430AA8C4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F41836405A;
	Fri, 19 Dec 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RdH1o7vt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RdH1o7vt"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013046.outbound.protection.outlook.com [52.101.72.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03C036212C
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159637; cv=fail; b=bkIdBluzYs+/fj/nD5PaoqMa4/2EbdyGzd6APC4/LjT6hhdHNWUYi7jZLIwz+md88+eh6An3JkfbiPMQfAb4g/HZlz/E3iKLDosBztZj6zILUQOnl1Cmb3boo+F59yTPbYcMVQ4Cxo7sn2E+O7u7/XbdICgHJKPVKVipW+cleHI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159637; c=relaxed/simple;
	bh=C+M/a6Ugwsec+SSJ5FMU58W4p9WWB0R6LTlhemIYsPY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OdbcGfqhFLDk+589J0yg+ur7MxOx/CRJbTo2zr5l0gKG/teTyU9L8V6t9t+Znpjt74LhilYz3FL2ZbsiQPS24uP+1Wc7MPR1vlQBPdljOynoAirA75MJ6vCeRCoNjBSy/rlXAo5BO+HfX47lr8ZBB5K89gPcacnM2fmdLxBgcHw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RdH1o7vt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RdH1o7vt; arc=fail smtp.client-ip=52.101.72.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=w1SNTAq6GmPTjshCGrPL6kY7AOAKZ/D54N0Rw5F9Nd5yqB3DZ7xydFXrU4lLXROPoQdrHA3s/8tTHtsz/sxRqg01naEBJIGQ0BRT+/LEhesW7fkb8E7aCNKWJGyXyNFj6tFKsX00rMdlT9XPs9QhtGhKY4e47JBTTcV88FxFGYTuwtL7cvP//cQOvbVEB3qG4ApnwUc5NcassxE3avZvfrDxdSPVPFhHft7yDjCA8RmYK7psRKuZnYRNgKERsByXHA4aFuJG+kc9C45A8/khzvwog9QdbCIrY2CJBD4E+QD7V5WShIdbpUUienJXW6f/cJB3x/T0W5tyMJDRwNRZ3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIyHl9Q6gTd+5ZQwm02Soqg3sh3Bhti/b6CDL44Y1Bo=;
 b=L0vqy4mFc1XFpT8LhZAMuntLHk1jGlxA9dqGa5aq8MkBUAPUxoswB1LsddUO87E5ILZ07PikQDFoEGf0XmUf9ReFXgDB7MY+5jM2OABy4P8KL5tWr+2nPY4tSraMheXeAI00mxCnv9qGttVg08Q0WARrou6P64gKN3W0AxWnHIimias1DWeA3FjS7gmbUhr2h7bsKKGcADGRK+g69A+RpoGIIozCXUFz6tkbQo3NAqzPsjLMy8qCEIcg6i3zHuYPS5VAZuji4YTnUeBTdSZktiHzSMgm4vQxm/ZkJRbXllqXOHkGFWP9xEJcbHyQaJvWGCwwqugQQOInKb/ykL1hhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIyHl9Q6gTd+5ZQwm02Soqg3sh3Bhti/b6CDL44Y1Bo=;
 b=RdH1o7vtY9KWYtcgtWUMnm6ZFBjVALz8K7HUivZejgIZHa/jjZxFvLsXnmWnPw/Y4jW5A4xqAR6tfaULF15ZZhSBXR7X48lKL5uoZwXp1XuanvRpCurfy9SV23wgf1ga0M1g0hxOi16Y8LEWjRiMngy3XazmbzaW7YGXcpVBiE8=
Received: from AS4P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::18)
 by DB9PR08MB7559.eurprd08.prod.outlook.com (2603:10a6:10:306::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:46 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::7a) by AS4P189CA0028.outlook.office365.com
 (2603:10a6:20b:5db::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m56pbeaNQPW2vuMciIfU72oRvc5aC61lYK0wHQIGytgMp1gsfPnA35EE2GgRBrfUxX54uiP/MU+pyFFTUG0uvDe+0oA72JRoleIyCLfdGFlD06iPWkzbAnmKdhMw35mGN/W8Nv08c13B9I3/UHts/GTssY3i9VHLqwXlB4bpOOyMTg5zBv5pA7WhLxCb+GwNWFCCBPm74nbz/VAveUxZ4Ryq3Cvb0mfuVzLVdSK/Bi7pAz5ITQp12VLirFDp5fVDFZnVGD2CbSfWB8/GvlcE/Z81QCVcIxx8ti5+LwWHv3kCmitm9OLRHIWDM1xHt3Z9jIRKRSZ6JvExLV89JeS3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIyHl9Q6gTd+5ZQwm02Soqg3sh3Bhti/b6CDL44Y1Bo=;
 b=dE+9c66WCb79WQMUOgnKK3FqZF5fl5w1SNeUPJqYqMWbuECd7uz+VL6erarOqomBaVrL8oVzyPrJ6gRSlnr1G+OJSFu+rAleYO5dK1pvWshl7jdQpztNRQRQZwCK7nQzdxu3Sau8aOzPg7CniFwO8c8RiCYPKjdkLuBDzivjvvqZngLGbXB24gbR/s6vOODx2GlSXgFrkF/SDYZsQBizyUaaHyR4f0nfKXTKrkFyvhJuA44SbyMwF/ZWaFdCuxAkzNX5EQatgjuVeZuSOeOF27BNLVI5EE97Shs0aHH5Rk7vgIeVp+b4MTAEbE9B6hmMgegAF7aXV6Fc87JorJaGLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIyHl9Q6gTd+5ZQwm02Soqg3sh3Bhti/b6CDL44Y1Bo=;
 b=RdH1o7vtY9KWYtcgtWUMnm6ZFBjVALz8K7HUivZejgIZHa/jjZxFvLsXnmWnPw/Y4jW5A4xqAR6tfaULF15ZZhSBXR7X48lKL5uoZwXp1XuanvRpCurfy9SV23wgf1ga0M1g0hxOi16Y8LEWjRiMngy3XazmbzaW7YGXcpVBiE8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:42 +0000
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
Subject: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHccP+BGZDC+5Twx0q4ysOAVcN8GQ==
Date: Fri, 19 Dec 2025 15:52:41 +0000
Message-ID: <20251219155222.1383109-16-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PR3PR08MB5676:EE_|AMS0EPF00000196:EE_|DB9PR08MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: b78927be-49b5-4bfd-ebf9-08de3f16cabc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?F+XWJQJLmcSvxAdIdqMynd5X5yURtawlQYe/A1va8hT+HMkGKyC3VcPNw2?=
 =?iso-8859-1?Q?dBI7fnqwLPqehCjRvNc06X4tFsyNg+vwbGbgK8tYBqyg4TmzTYop82F2ux?=
 =?iso-8859-1?Q?0VAzy4pNWqj5YB3YirZTQAXmtFzj/nwacT+EZUFqbuo0pEjLwnjQvczoDp?=
 =?iso-8859-1?Q?pTi+Zd2/6cZU8A/r6bGJ+werTO0rCzC27rKyT+ISjz07dJ37+C4dGjjx5l?=
 =?iso-8859-1?Q?1Tv5lRP7zGu6a+SYyVz3U3xOy7lxtYBuY58k94UGQX03eitmAbsxCLWLkr?=
 =?iso-8859-1?Q?o47AamFJK1IXWjbowHV09bJs50IfX1sxRdS7CXfidqwywKvpCui/j1vIzw?=
 =?iso-8859-1?Q?mYJYhqEso5zQ996NR4ZHAPr9j+/mAua89FQedhS7s36C9HCP1Py4KFpe8w?=
 =?iso-8859-1?Q?S0YhKz/FPnJqwFN4bpvVXuIyS2ClyoqKh/q+FpHAgUaFmCWt5sfhWCxTba?=
 =?iso-8859-1?Q?+PVHHT4a+Ij4gxSlk4Etkm6+LUnMIiM18G471jYldE1y71nSxUZgzoSBvO?=
 =?iso-8859-1?Q?TQKUb1TWiVo1Hcp+xRk7VRAKjpjDGlzum9xgOUpgYqRTUpied7ZFD+fFJV?=
 =?iso-8859-1?Q?Xb1D9UKcqYBTCSms765lniPoJHDbfbp02f8HBV9IpXyHiy6sRCfVI7tO7t?=
 =?iso-8859-1?Q?oVCd1cnZJP3JrgEiW8O0YpCcgKuNbzlDj0l/8Mig66goJ0dUxRbX8lG5tC?=
 =?iso-8859-1?Q?Y1pvwhh8dh0ygcHxPrOu9I3GKsfacWHlVKuS+X5ef2bIdHNwSbC874hFGJ?=
 =?iso-8859-1?Q?+tXfYsiH4c9Yn/eXtahPuPp9Jgszf/XI4p6nho1U+niMOMoy8HXViiTTv4?=
 =?iso-8859-1?Q?FZl5dxr9EyRsAuIHLbl1N9kEWtjv5p5mh4s5nahLY7v/I5dcN95uxmQMkT?=
 =?iso-8859-1?Q?uHNjZBhVCM4AAdqLFDYisEOwHTcDvrrMSt02CEkCAlhpQ/pQH8cq7z+g2C?=
 =?iso-8859-1?Q?IDlJe6tw4TnQ2dtioJ07Zw2uLE2W/Hn89pqmmHxAPsqJ1Be5zuEiAdNzjH?=
 =?iso-8859-1?Q?lshzu8EecbQEsxBvzVvd9KF+0WBbo+t5LVJtrpoPugDbYne9RVPa+IEXof?=
 =?iso-8859-1?Q?2Pu1GnIV1w75q9XJtyktE0LvzTVdyfGRN/t7WwaSaQyt483urSwJa/dZpR?=
 =?iso-8859-1?Q?P0uf+ye6hIAaAijkhviR3BGktDRoruiUDpIHuPQ91eVaRwditGv7oywmx7?=
 =?iso-8859-1?Q?rmFBLXX7Q160/sWdQUlJ4aC/AFqEd6hTak6EaXfkfZkolpLpG0/HXwcti2?=
 =?iso-8859-1?Q?LQ1z75i1EABKnPLeismSBpHwZp57BDKtPQA4HFAope/dKAhwqZnNr9LUsL?=
 =?iso-8859-1?Q?oW9HbFSUVamil9fFt8tX3qmmATuhvL5Z+JGcE3eL+uueXaST1Y5KlVqZu+?=
 =?iso-8859-1?Q?uDA6kHkK++u+QY7tFhPEGHTFKDDG/FHUh0mT6JkMJZX8Ai6Vdg7kbI90L7?=
 =?iso-8859-1?Q?KRkeMhMoI888mtyDzINL4MvHthzLC45ZugmNO8SR0fGM3DPxtNzELvCgxP?=
 =?iso-8859-1?Q?1nv8MduRMctrS91qqLzRjjlRKvOkHOIYx+SzCJn3pNiX0SWXlZAAuz6lDB?=
 =?iso-8859-1?Q?UBaMBHt8dEvn1GRpIIGf9EuXbq6X?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5d40f34-f58c-419f-cc86-08de3f16a4c3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/EmYlKD3vLTPYHY2CFPfnSQjRxC8zIuzd0SrJrnOmCy/KW2+8IEtEuzgfS?=
 =?iso-8859-1?Q?oeFgp3owv4cxk+sRo+Qe2JFosl1gRt4de/moEWX7MvDsI9SwsrmE8ooiQS?=
 =?iso-8859-1?Q?Md5J6Ycf5yUmcJNSciXh4x4CQn4s/EPd9C31LQWQNrFbhMxVQstXvRm0lP?=
 =?iso-8859-1?Q?UPxzwwmxikBOs+2GhKWfonCcK8ln1+IfGwsiXJTsTb4VblO0KuINkfn6dc?=
 =?iso-8859-1?Q?n8wwLO5it7MUXoxAKiLSpglNUokKN4izDBu+E2IjkO4igmoeEiuJKOtZzy?=
 =?iso-8859-1?Q?vYh0b8C+o6Aybv+82r0oPtEedYYHiIY+PO9tXnY7YVqW4pqVkB3sf9EcxM?=
 =?iso-8859-1?Q?JyMvhi7uEFRiM4EyQSHey8YfaEQqTHZJoBYcDkPGvo9UIFzjLxKMwnyVyL?=
 =?iso-8859-1?Q?z047/6IPwFIdaNtYSS0SpbDDBaq5g+scq0Xc6Q8P5PLXtm9btSBPF0xa0F?=
 =?iso-8859-1?Q?XHrlNBbK4kMq4d+LzKtsclM/TUOG4ES6hPh/Cffs6o49i9nW/5NQzUtOdo?=
 =?iso-8859-1?Q?6HLLBMGFSlTtYnedbPrgi65gafyX7hop4h+4AmfCgF/kwtxi14cUvFZPhp?=
 =?iso-8859-1?Q?Dh+uNKxrtFPsAxRAOT4aqCMpplJk20NPIcX8603u2vvSjgRlSC8vkQdi5S?=
 =?iso-8859-1?Q?OMdv+eMoGEbf6hS08hDuSRZxaKHo4e2Yej9tCtxae82hJFXZuKG++lrFAu?=
 =?iso-8859-1?Q?QfuV3HO2CSouO1dTT1niA2TKWNGzUiMcQw1CVCspyOK6c/ogPMyGcgTkqt?=
 =?iso-8859-1?Q?wx9w8CnI5Ozq52wrSF+msUsYdhUNdq1L2nngMlQ8nRDemTZI17m+Mxjqc/?=
 =?iso-8859-1?Q?I8qzvWsCOb9iZqJ3K91i7jbHPU4ntUr+rVPJskexUqIImN1k2bZmzfzD1U?=
 =?iso-8859-1?Q?FcQ6UDbmvpMZgrkg8oiNDqCUFag0NChkK7FMdYfUt1kUa7L3NBG8Sdg0s8?=
 =?iso-8859-1?Q?+oyV76fgaWDUiVKJtQPvZxIfzEi4+IjKwy0rfhnatc6Db3U9xn4lqGO9GE?=
 =?iso-8859-1?Q?HwKicJLmevD88ncOvRoOeszsGbeP32T6fkCTyE1HIhknikotXy3ItPYaJM?=
 =?iso-8859-1?Q?HNsnHG0LiWCiKJoc7dAWrqhx7TxSAuNKzfp6TmQZ7YXiTfswaTjLMu4ffz?=
 =?iso-8859-1?Q?qj/dGnzClqd7IDFFUJkb4djZW9ULPWl/lGHE6Db5leG4kJgqE76tUtL88R?=
 =?iso-8859-1?Q?7yeW+O1LTArI2IUWtb/+gm2GdaBNyFs2qWaTyoQ8l/jNxLlY6OAF8G1vky?=
 =?iso-8859-1?Q?OqfI7Y9520wJ5mMnV4sXMvx2YCw13hG1gTWJpjS0v73YvaaKMQ2/UWnvTk?=
 =?iso-8859-1?Q?WeNuCyV1pmrvsPAszsDvG4XLWo+hyxhvkB0Kyu0ZNmEje0rYfMC/Fr6DKd?=
 =?iso-8859-1?Q?lpuQHDJG1SYUqqKXJJLglmCWGzrI37sRNfelHba0ukyE8wy4iIYrFRBUrS?=
 =?iso-8859-1?Q?MmtT/ztKzVvr1ahFmFqNDIyZlrmUn4AJ/fDh+QktQk0aYVKys2OsodQ9rw?=
 =?iso-8859-1?Q?XHQfzBo5Mb0Wf/QPR/Kiq/s0HsrcwEBhtPf27WLgY3hx+w2u9z30mUU39W?=
 =?iso-8859-1?Q?Gvk9Q5KqqqUZbFJoVNsF+zNiMfbw9zs5bKb55A0bDFx6Dn5J9Rwr/f5H6d?=
 =?iso-8859-1?Q?vexGspfiZ07nk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:45.5401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b78927be-49b5-4bfd-ebf9-08de3f16cabc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7559

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
 arch/arm64/kvm/vgic/vgic-v5.c      | 77 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 144 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index c23e22ffac080..bc446a5d94d68 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cbe..675c2844f5e5c 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,30 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_set_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_set_vmcr(vcpu, vmcr);
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_get_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_get_vmcr(vcpu, vmcr);
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 1fe1790f1f874..168447ee3fbed 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
@@ -79,3 +82,77 @@ void vgic_v5_get_implemented_ppis(void)
 		__vgic_v5_detect_ppis(ppi_caps->impl_ppi_mask);
 	}
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, true);
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_restore_ppi_state, cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_save_ppi_state, cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2c0e8803342e2..1005ff5f36235 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -996,7 +996,9 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1005,14 +1007,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (!vgic_is_v5(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1034,7 +1038,9 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1094,7 +1100,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_load(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -1108,7 +1116,9 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_put(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index eb16184c14cc5..9905317c9d49d 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -363,6 +364,12 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e3e3518b1f099..b9d96a8ea53fd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -444,6 +444,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 68ddcdb1cec5a..d2780fc99c344 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -354,6 +354,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

