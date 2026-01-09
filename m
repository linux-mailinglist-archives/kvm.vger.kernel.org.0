Return-Path: <kvm+bounces-67625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9196D0B872
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C1664304E423
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C00366DAA;
	Fri,  9 Jan 2026 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SKM9YB7w";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SKM9YB7w"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011062.outbound.protection.outlook.com [52.101.70.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C83659E9
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978424; cv=fail; b=c0ZRTtz6qD7bqnQMRJZQlOJNNMYoSSQewmsd5ntMLzGroH6llUjBNljdrJhLoYILBpGMGrW38z8EdQJo0iun3uEA+qVuPqqHCWR57rV0p09TvjDW7IX5bJfXggy4Wzl9RVwa8KEBB4fu2YgeqzbNa3gyOq4mPWOmts7yNS3o8BY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978424; c=relaxed/simple;
	bh=VTg43MgIOzuIoGaENHEhobkSyu43xj+9NwXz1JAX7CM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Laro0gTmsIDJ1RKoR5kngQSM9PhRBwCNwQPVWy8sQxdvdZpyP1rIaMII7ROKZGZrc2hiiP2we6yQCjCaUpqajR1XOXdhVCAtWhCEFiAKo+EHEPkXZNqkzRoRvm/vBMc2dxbUOj/A2pWXcLrsThwTeA53US7wBRfsrU9T85D0OBg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SKM9YB7w; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SKM9YB7w; arc=fail smtp.client-ip=52.101.70.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XqSPJ5NVbZfoTVaQIJsvTR17rbfc2m0SP4vfHl/ERtvJzX+VBd/6vCLtavLUUR+ERe8MSJxS1M3/D8FhMXcB4hcaM9wYRqx1s3ycxAv4Oa8HB8nX8KQpYvc5yHjbfKdpyZid/DwNhUDkCGvvauSr8iyleJpKkpmaQiqunbTxDK5Jtq73BLqamcsazGrwXD37++rlK1VUCd+loDx5TDhIY7vcKPSxhXz96P2GVw5IhnVaiH2u1jlO2dvetOD1KiU6C/eR0RojM65dwNwLAXQFbQ9MMC4wYWK6Udg7VD3QBuB05FAxERf3CgmTBl2key9XPvg3VE0R5kMTqrpQpWf9QQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rny9gROHt5tHRaks5cwh3/IhDc3kpgOTv3xg7Yxyats=;
 b=an12xp12FEfM8x6N71fkRzwaqz8xXvKYY+e+HRqoc0AiREqjdPp+EGpNOQsp3yXbFsIp+doku+9EH7EunhdWFljRt0X3Mg8HFL8UJuJZz8BBaUJt9mzgxeGPfp+sRgTKTuRD7YQawBh/3cQjRJCrILNo7emD3qfLSe4hu3HjG7NQMazyIbIwRMo9o5JftWE+iEvfOKJ9Mu4NgfKI2ELjsMJmnWSanWXDUzxOvpiZPB3O5vjDFuSP22m83/U43fh92REVHGUJm/RON6Th2st1gSk23ja7d/NyGgXHnZs77DVzhd1QFCKOGqaiB2l+MzbK0qldih0vxQIWNJiNdZ/TUg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rny9gROHt5tHRaks5cwh3/IhDc3kpgOTv3xg7Yxyats=;
 b=SKM9YB7wujv0TRMdB24153OqLSno6lPUDwn7MpxLUYrrp70tGk2bblaG24R57oqLVhvnvPJjC8m0SK/VGMc6jqBmL/+GG0s0Bz4gUKyizInm4qWTbdxB8a/uwB8eMJlfzUKYdVvvb9YTZqRLOvAYM99dEHrOiLI5rpxE6O8VJQo=
Received: from AS4P190CA0016.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::10)
 by DBBPR08MB6122.eurprd08.prod.outlook.com (2603:10a6:10:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:42 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::2b) by AS4P190CA0016.outlook.office365.com
 (2603:10a6:20b:5d0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFj+SLh1xYVvAz1n1WL8kjVoi20ncInqofmQ71KQZEx3DUiepDxOVOpV/JOHznr2RYoM7NUc6EVumUMvo6AARD7km8UvhBaehEajISC2v0itdX1W8DOV8MNTR+HKhCttGiuIZn1XaN5KZ92XP13/bh4b+v7kDUXCEpUqB2+TRr3I3+u9vVK7xqjFqzoM7SoasQsqZtv3agPueD8kj0uHTcZI6TqtrhF3bX60X8VBu5Ld2B4tOfoV+rEQFq4CeK/OBMiBVUu+3CoVNd/UNWy1++tGdLm54l9d74q2rECo7pPJJCtQog2AvCKyu/roa1nY1VNf4IRV5/Sj6NVontFmyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rny9gROHt5tHRaks5cwh3/IhDc3kpgOTv3xg7Yxyats=;
 b=qkUk/m7jXRksGE1Id01RSQf5E9Ss/Icq/mQrDn5OmJMUY/1t1p8RriLrVckQCJ4ydu6f5+2LWSHoLqIfGlk/+VJJQoHyEEAPjPI9kNtL+2l+PPkMm28ktuSzfrrS4KDZKTnFvfJ07eLf5ongZAJ6GHLlp/+QU4jdQ+Y7IKEhXTsdBQAS4KSoRNhD/UhOlcAeK1iEf1pYIBovML8rZL/nLM+AfmvOoDCVYYH82oFwU2nk2a01ou96TMvFtz1B+q/pstz4sBYhmwa7xniXtCiFpc/q3aCtkQxxYzYb8rWW2J2DNWbD6gv7qNUj07qgT2xD3tfmKoS8Zysc0pVT7XVwLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rny9gROHt5tHRaks5cwh3/IhDc3kpgOTv3xg7Yxyats=;
 b=SKM9YB7wujv0TRMdB24153OqLSno6lPUDwn7MpxLUYrrp70tGk2bblaG24R57oqLVhvnvPJjC8m0SK/VGMc6jqBmL/+GG0s0Bz4gUKyizInm4qWTbdxB8a/uwB8eMJlfzUKYdVvvb9YTZqRLOvAYM99dEHrOiLI5rpxE6O8VJQo=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:39 +0000
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
	<jonathan.cameron@huawei.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v3 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH v3 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHcgYoKQmAReHHObEiGZ+Gkrz2rHg==
Date: Fri, 9 Jan 2026 17:04:39 +0000
Message-ID: <20260109170400.1585048-3-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM1PEPF000252E1:EE_|DBBPR08MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: 68ab65be-ceca-4608-2ee1-08de4fa1529e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?8MqLWQNxix/VegjFcM2Kp8ldlz79x4L4ru1Jgm0eeVwkX7EcMA7l8x1/hx?=
 =?iso-8859-1?Q?QrtgDUBzqUHUiyTdvraTBqk5WI+T0uv86EiOCQfa6Vbi3vOLL6/RLN2+Vd?=
 =?iso-8859-1?Q?Uo8dXOmo5UPSLMKDb8Vln+g6iFvvLg4GKtD8GzMHhLkl3+Q+iAakTIxCwE?=
 =?iso-8859-1?Q?Kdu1Tsu6Vp63ObqJOpRbdwj4tVsclZCUIZs0YdrP14ZXHWz9JP1/NU5zzY?=
 =?iso-8859-1?Q?Ov39BnWyl7K0MhrX5bjTCkJqv13u523kcX9WEeu9pD0fjgeJ9zOUA6pNE8?=
 =?iso-8859-1?Q?/O1t+Drdo5qdTdjWeuAxRx8/keHL0aM1sUSdWnx+OTSEowp7Pszzl47DeJ?=
 =?iso-8859-1?Q?TV/oLCabGCLtTeLh+QDqacBx/TcjHdePJ+j6NOqwXPysPC5RSrdNxjpSzw?=
 =?iso-8859-1?Q?+CCdwpqLGOajcFocJ+JEsmItl+6jJCR+d/z+UYaLsn5svrt+paq3CTMAk9?=
 =?iso-8859-1?Q?9JAdmRQAwTtvtMMyPs5hQSFAMGYtcvP0ZCTr4Kv/rOfOdMuhnTCe+ponw9?=
 =?iso-8859-1?Q?a/5FuXoQIdy+kRoHtzIclJ52Vx1K63hfP8sQTn2+KLQgcaI5PHvycmYTWF?=
 =?iso-8859-1?Q?0V857jjuRBxLG8GV0VOYxbHekpxDm9k49FWGFAb6PAX8hv9n6WLC2w5KeN?=
 =?iso-8859-1?Q?OGpg9paXru7yaLcSY6oioa0s2h12jExVohfRDFh4lGvfCIh2iwyrZ54Zzb?=
 =?iso-8859-1?Q?BmURmB52GHj90PljOwsOjxAZmtaQmAJCCQ5Um9hR9CrU11A7XL+unotnmE?=
 =?iso-8859-1?Q?ZgXkTTTTC++4EriX1nMK3auYdxHmTx/IfvZGBdwkg2bklZjljJJCwSPnlX?=
 =?iso-8859-1?Q?LSGKUi4IxWGEohL/kxQI2E1sIdZUR0DUZU7CKpLuNMQlm98Ay6hyYAIyBz?=
 =?iso-8859-1?Q?UtFFAbXSlH7L07R84C+RdBpzplP1uPtZnEnQ4G28jNvQpdmwj3C+nIsT9a?=
 =?iso-8859-1?Q?WMorhaXSqmUBkhcwZWY1rVQ8hy3pe8FcnJgKnfI9odP60KF97YUJFRsrYy?=
 =?iso-8859-1?Q?VR51crow6QkHYSgvo4UYU2ZthlgJWkEv3MJBjtlKl932D/SgepCgvP1ySC?=
 =?iso-8859-1?Q?ss2Ro/Ei1ZMIG5c8VZhaMUeVUQgJNNoYotyaK/5Utg+QKrSg10bPs+XOfb?=
 =?iso-8859-1?Q?ppT4Gmbr6ybADcGRouVWirtFJD/lT269NeRzaGDzdbNS1oNqEGNrM2FRCH?=
 =?iso-8859-1?Q?K+rBkmZhk7ZgvP5+AklTQDyFDbJF2vjh4S+MRecmYBtCc5hkeYC+CamX0R?=
 =?iso-8859-1?Q?Tk7vaF7j3yoY27og2B8kqGkZd3ri9KSdBKCToKPx/xI5Sr21hzSEi98RrM?=
 =?iso-8859-1?Q?XYLWqr10kbEGaMASTTUe2HYyBtC9cLrB37wN+wD8TREtMgZpcsWDBAyl9N?=
 =?iso-8859-1?Q?e2Owl6Qoeht5LIZjjZlc4Nxo553oM/qERyO0WMxNnkg2ofjdFi7te+HL1N?=
 =?iso-8859-1?Q?0vw2hGiKd71OBeawgXMNdfQqCgNuzgz3jOSIrWBoQLf/MsFAYbn3K8NOEO?=
 =?iso-8859-1?Q?HCHkmeatTIsQHfiU2UgCSpHLwIHEFGROJy6vkVUmfbWuDJ9ncWG+Ounk+X?=
 =?iso-8859-1?Q?gvZ2JTInrg8men5ACApbVKkdnyGG?=
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
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0793b837-2648-4dc2-b5ea-08de4fa12d08
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?JOlodL9A7k+RtfucI4wj6RgJPnX7PgtGdgF7MIXuski20mdQuuzKvWixlx?=
 =?iso-8859-1?Q?kjkwu4Wk461nrWvKxwGWkvBPJ56sKVc+4X2v1hlJDEfG7hM/PdhbEBMzLM?=
 =?iso-8859-1?Q?dhvrC/HiY6U7aGKrNb6+As+uctGdO4W8EMQQ426Pppr24wNoq05hT36qDq?=
 =?iso-8859-1?Q?IkxumVNeUVnhKfzlUpgqfNNl4oEIxpGgsXyE0wchDJ64pXieDa5diaf899?=
 =?iso-8859-1?Q?ohriG5yEI0enC/8rXQ1lCTV2oxxDmaMgrnRrKAdZttVJgVBWuuRtEaeFuB?=
 =?iso-8859-1?Q?w+vuHVjLnl6zjly9KWQX8IlPD9NDgCzO+IQbWw1lFQGwgjz61xdkNIMePj?=
 =?iso-8859-1?Q?pdgNKJTNbTmk0bOqXfNEBDAjEaNSkGQrD/Sp2qid/2SFlH5mQ1f+PBDwxR?=
 =?iso-8859-1?Q?2tQcUKzDQtAnYLGJ2NzcvcRdCFxhoFImqIaBYM/ASPSnGV77QojrxruMAV?=
 =?iso-8859-1?Q?f5EodHXLvnmR5Ya4XPec2CtpxQIfvir5qLQziJMmA7Bnn8OaQ3WU+nONqF?=
 =?iso-8859-1?Q?wRYn8J/VKxbIbGTsrZ0oWadV6FpWOfw+S85csfn7YwNsM2ZWEEepuisJ6u?=
 =?iso-8859-1?Q?+JNUFogx4gm+3TvZba1W6QHVe0HulbyXSOpOLY5SeKRp0/+37ZNE3guPSj?=
 =?iso-8859-1?Q?tA1fLpXuv0dHwihn2/RYLuTGr9Vd8O5FnZ8DlDKQehqxPsPUe0eWYkcQ2N?=
 =?iso-8859-1?Q?aqv2AKUISUx1NJ0MlI7XQkNpRm86zAwCXaDh04eNiuSsyCSWrSRhsCCA0l?=
 =?iso-8859-1?Q?doQsizG6fVUbk6GtiJnTY9VTG+GzVWJuas6TZq+iiS0k5k1QTYXKm4KV6y?=
 =?iso-8859-1?Q?BKlTMHdLemLL92TWBclmXGplpW0niYPtrOGs3vWQMfX2OL+4TDS5zVE7ch?=
 =?iso-8859-1?Q?VygD1VqEZDDJ1HWqacXy9E9WHRnckon1bXS13IjBN9Ya9CVg4mxDkv3Q9A?=
 =?iso-8859-1?Q?PwLbO+ouQFWkOIxHXUkd6nko/eqAtmQToN2LKgyJFMeuSbtppjQ4E9LDND?=
 =?iso-8859-1?Q?/5SZPhCtgi6ez2IN7lr10K54WK6yA/MexsrRjh5ksnqMikhPpENw76Z3w3?=
 =?iso-8859-1?Q?9/uxhnx7mRzTwqUyiVAzrG5XcRb8nN0PldRS+ReASv+iQM715OAXs4sNGl?=
 =?iso-8859-1?Q?X+txO2agH2AHluw9062RI94jgeXZVIHl75KUI1jNcVlha/Plv+F2rxvDvc?=
 =?iso-8859-1?Q?lpjHq60vKl9vL5KGGSVhthod+3jW7QFgo0YxbtiIaBI/IPei8TGUpAWDAc?=
 =?iso-8859-1?Q?NnCQbCaUl/SDX7a3K1JKOnXovbmQogt0U5nDMzEBYubhPTGBiOTkfj6XTU?=
 =?iso-8859-1?Q?ge2jZaopIWDH7lYnG4eAf0+I2PHUpKYJIhCY+qxwEe/w/GxN68VKJ2qNFI?=
 =?iso-8859-1?Q?Bvfukg6J3jic5i8SenzsrVV++Q3EpkFNFlm4rZGmRwlJxw9eQVdaKo1z8J?=
 =?iso-8859-1?Q?5zksfhBjqO5lwgdn6mubbm98jmHt6VHJR/FtZB5baBvSaUNaR/hjwLK7qG?=
 =?iso-8859-1?Q?3xfPKgEQ1klN+XMBQ0aqqswYe2V5ZmhPkLCctgSBHZCgkSYD4vMFWiHXbd?=
 =?iso-8859-1?Q?KsvwFWRLTsoD2vU1Rrhi9xZfykn5M3Drh/l34IP7C3TrMks4DgyP74uPGa?=
 =?iso-8859-1?Q?9G7aMoXL8yLY0=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:42.6704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ab65be-ceca-4608-2ee1-08de4fa1529e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6122

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 68 ++++++++++------------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 48 +++++++++-----------
 4 files changed, 50 insertions(+), 95 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 9df51accbb025..b3b8b8cd7bf1e 100644
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
index 0b670a033fd87..ff10fc71fcd5d 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -569,11 +569,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
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
@@ -646,19 +646,19 @@ static int __vgic_v3_get_highest_active_priority(void=
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
@@ -758,7 +758,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -806,7 +806,7 @@ static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!(vmcr & ICH_VMCR_EL2_VEOIM_MASK))
 		return 1;
=20
 	/* No deactivate to be performed on an LPI */
@@ -849,7 +849,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if ((vmcr & ICH_VMCR_EL2_VEOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -865,22 +865,19 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
 {
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VENG0, &vmcr, val & 1);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -889,10 +886,7 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 {
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VENG1, &vmcr, val & 1);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -916,10 +910,7 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	FIELD_MODIFY(ICH_VMCR_EL2_VBPR0, &vmcr, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -929,17 +920,14 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR, val))
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
+	FIELD_MODIFY(ICH_VMCR_EL2_VBPR1, &vmcr, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1029,19 +1017,14 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
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
+	FIELD_MODIFY(ICH_VMCR_EL2_VPMR, &vmcr, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1064,9 +1047,10 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_PREP(ICC_CTLR_EL1_EOImode_MASK,
+			  FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr));
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1075,15 +1059,11 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VCBPR, &vmcr,
+		     FIELD_GET(ICC_CTLR_EL1_CBPR_MASK, val));
=20
-	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VEOIM, &vmcr,
+		     FIELD_GET(ICC_CTLR_EL1_EOImode_MASK, val));
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 61b44f3f2bf14..c9e35ec671173 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -202,16 +202,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
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
index 1d6dd1b545bdd..2afc041672311 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -41,9 +41,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |=3D ICH_HCR_EL2_vSGIEOICount;
=20
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG0_MASK) ?
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
=20
 	/*
@@ -215,7 +215,7 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * We only deal with DIR when EOIMode=3D=3D1, and only for SGI,
 	 * PPI or SPI.
 	 */
-	if (!(cpuif->vgic_vmcr & ICH_VMCR_EOIM_MASK) ||
+	if (!(cpuif->vgic_vmcr & ICH_VMCR_EL2_VEOIM_MASK) ||
 	    val >=3D vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
 		return;
=20
@@ -408,25 +408,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
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
@@ -440,10 +438,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
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
@@ -453,13 +449,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
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

