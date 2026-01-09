Return-Path: <kvm+bounces-67607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE93D0B8C6
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 76829304F9A6
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E5F364038;
	Fri,  9 Jan 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JYJMUwN8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JYJMUwN8"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013036.outbound.protection.outlook.com [40.107.162.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB5366DB6
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978359; cv=fail; b=WmMA7WGJjTBdXq4U3o+FY9fCNZutCIpQ1GHCK873Zpi7xzB0sDgYSJDjjWxRrb45VzSqsUQorykku5XQouyFNNx2NV7ldsJhBwiw7gT1chT9NwCO/dugjeI/iysSozyTCkp+FKA/VaNyCk4Msa97LcEpZZ5jlwaxBdy9KPiF8RA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978359; c=relaxed/simple;
	bh=ng09FrXpDWaICSnBSLzlRWeggcBY9yz4qq1LlJtSHzE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S03Z0UXQmsnQOWNhNBNZvRLijpBDzweGWpWuVXDkyPZR9k1qkPwAjtkSFXp1hYl0r6+0xCohVGonL76cBlaeEpzMEmUcFbWOgbqCpSYdIaK21QTqxbs3TaU3z9/okR8uTRnOmSo6Fez6Zl8Q+7cQUdZdCCcg1M5zKmR1Z4qP5qM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JYJMUwN8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JYJMUwN8; arc=fail smtp.client-ip=40.107.162.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YalmOp7NdIci6dqua2IxOr+sOdweOUOpkDgEU4iKasdmt2xeczk5roYp4DvDFFlVjBkvUQJ9sm8Mbh7Bmy9uFoMgl04l2JrGGmKjG9jBdlt32lXvzfnyG7TznIYNTYGGbgb+EkgZB2K7wxjSotiEQaaue67N8DDNaPwxfttu2MQKLIOSG3ukDjdpltKFwg7kihM0SGRRNxKc4upt4pvTBLv1TromkzvdRgNwl+SG8gIr5c7eJSMb9Y4OwOMwSO+aZVqG6EdSt8MvnV9Mo8udwFtW7351AUdllgilVzOU73SZswpCPGX6YUdAE3wyOSLd9xM4n4/hPFg8mp5oKNW35A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SR2UlwHkzepZs5Ll5YZSFS5ELgJMKDJu8KqiPjOvDcI=;
 b=HejbNuEpYaI8SKAWcS9XCGn1rAyRsGp/8a5G2hyaz0hmbgdwsvH1Mnovhs4JJx/7VbdPu9vYqXmMwo5g9qo0AXiddN0SYjdprERQN+ZOFvrORTSd1KEH9QWyB+KVC19rWop4KLP0W2XIzTcHiGgJqsFSkexSlP2IBizQAlQCBDvGbDWI4asu1dW9JE03vAZ4tArbxesG1cAyl+kK7UiWwg3cfsK67kuB1UWmBCmUAXqD0anKMar0UTGwd0GTUbiCeJfvsNr6RSLpa/kWJdjL9NLarj3XNv4hBtWgrlxrqU9n2d1R0UkOZhs5vSwRATrRK/lH+pVDMN7yNDISY1urgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SR2UlwHkzepZs5Ll5YZSFS5ELgJMKDJu8KqiPjOvDcI=;
 b=JYJMUwN8M4fJR9ojUmKe2IN46M4P7pJBAP5ItWUFJMPFoJtE1oogxPoQh7NsRU9LehovVeak4oADuzWKI8Fan8jWiGb4H+xSlp6HoFJkPdJ4MSz6e6LHrkEyUAS+Fzz5d4wAhnq+Qs5h/aFqEbOmKyYlquNxiDKoM3NrrFqHwVk=
Received: from DB3PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:8:1::18) by
 VI1PR08MB10220.eurprd08.prod.outlook.com (2603:10a6:800:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:05:51 +0000
Received: from DU2PEPF00028CFE.eurprd03.prod.outlook.com
 (2603:10a6:8:1:cafe::ac) by DB3PR06CA0005.outlook.office365.com
 (2603:10a6:8:1::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFE.mail.protection.outlook.com (10.167.242.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACjJw/5PK/UrOIlDByZUgg+1EtiMUPez7wULnJJYTA++fHHlwg3U3LiLkCOD8HnmtuMJ7q2cJfzXxvCYUy4Zo9RWtCoT/RSFot3tcGHrp9H80MPFR/B0nYbtkmjIlBBqFHIrdujjtYT4kuRPGpES8CEKYUY/04AIzTbp4b8Mpeb+ukxtxbzysyqtsTX7zIE4xvugOIq5RbCNlrRQU77xWoBSUeEst0q9DlVEXTiNI3eGkhOjiigHBjYG4r+txq4EMeIhWfoN8R1/CkkK3x2scH62+oIQw+6+zLmhfluyh4cS5ytmlJcYTp5Bx6NhgP98Kki/r5DT2URwgBYKYPJxmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SR2UlwHkzepZs5Ll5YZSFS5ELgJMKDJu8KqiPjOvDcI=;
 b=fuMjRQN4MbgBP358kE+UuGytkl1uYia+Kwx3SoMGqUF7cjkWsGEAmtCatPj8VyI2Nqt7P5mYsl19tJIPc+/begCkGdGuAy1EDJjHk1ZBxkgBGsslMatFDjF1PEWXitQgIYKIGa5pGGS4RQeOgh/xelWs4HbxGNH2pdItoiyaQ12dyfkYFvHGCJWUj5+/1BW34V6PpPMbhUYnyOUZiE/tXCdUH5+ZC7of6+QnoV7fX+6PbHIYlsp+OfpoYXJymL2PI3gBclyK4I6jh/Q7GHCZBCM2gGEUAwqwlYJvW5CjN+0qOi+Og3IDIAZlEBmqj5YerZwGxvoKkOxLoOLDB/I3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SR2UlwHkzepZs5Ll5YZSFS5ELgJMKDJu8KqiPjOvDcI=;
 b=JYJMUwN8M4fJR9ojUmKe2IN46M4P7pJBAP5ItWUFJMPFoJtE1oogxPoQh7NsRU9LehovVeak4oADuzWKI8Fan8jWiGb4H+xSlp6HoFJkPdJ4MSz6e6LHrkEyUAS+Fzz5d4wAhnq+Qs5h/aFqEbOmKyYlquNxiDKoM3NrrFqHwVk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:47 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:47 +0000
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
Subject: [PATCH v3 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Topic: [PATCH v3 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Index: AQHcgYoOQYFGXjMDekC4L1GZOghU9A==
Date: Fri, 9 Jan 2026 17:04:46 +0000
Message-ID: <20260109170400.1585048-23-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DU2PEPF00028CFE:EE_|VI1PR08MB10220:EE_
X-MS-Office365-Filtering-Correlation-Id: 0408b60c-d483-4438-7132-08de4fa15743
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?G03Er1rJGl+iBxGyc/S4ylzwJEeKck6FbIKyKRt3n5wb2sTvZ1pA4tJj6W?=
 =?iso-8859-1?Q?hipLDXFYSd9xpBLUQodLdkGAqa6vfiqyG/fk8tYt/Z/QK0EcO4yChQPgzY?=
 =?iso-8859-1?Q?mje/WxkvHnRI3LHfrVuQs6BrSs61KHagMrO63Yns3tUj5Fx7Vo+dY2UdWK?=
 =?iso-8859-1?Q?WI4BFgzUAxaLLseJ44gk5gp8xVuHu5Cp90KEi82qMNSfISSmHxLP2pNv/x?=
 =?iso-8859-1?Q?Q+w+/LtPlfU2xlS04Cdi4NAZlWmvFMrVcE1HSr7a6Zkdumk3718vrc5yUK?=
 =?iso-8859-1?Q?yypkXe8DPJb2Lc3qN6IKOejascfOW1u/nerCOga0ygBMxdiSE2NAWIO9Rt?=
 =?iso-8859-1?Q?usy4+SnQ0b9kmT7QgZtf4NpfY08+PhNHWJyTutSxn2IR8lCoclcYbAEY92?=
 =?iso-8859-1?Q?mRfDSibmLvmSM31/fO7h9i3zPoPyP47bpnWQ+vzZcMnmoR6F1zKWiGfDdj?=
 =?iso-8859-1?Q?9tSGqR8Buc3Tl3ucXA9aGQMVb7sFqC9aIPFWBvGR22cWzYLt+dlfRFdT5o?=
 =?iso-8859-1?Q?mDduEfUAltYBbYq/u/pTJQe5dQBK/6aJCpj7dkH0yIbktwUPgxcGlbgZQn?=
 =?iso-8859-1?Q?TjreGsXodw9M879C3Z1W1wEIbPKrJqwcbkFFeHagnh9GRnJKCEWyTvOqUf?=
 =?iso-8859-1?Q?fq5ZuMk0hiqx0yz34JBkbzA4tUvJqL7035T5xqgxIcjyPyvVApOyAxg7RS?=
 =?iso-8859-1?Q?yq52Os6f9F3nzJIieTURVrrZ5FxzqOzbv7ayZ3wfzOjshQP+jBFn5pAL2Z?=
 =?iso-8859-1?Q?5UF5tDam14CrwTogG2GjftjWVA6PJndXkLxVFVLMb3nhgHmH7Vi8zzGtq5?=
 =?iso-8859-1?Q?vV3aBhvEdxIFvoL1ETCKWeY1uAvary5jEyVdyyCimw6J/qm9GZ1RBGxYQ/?=
 =?iso-8859-1?Q?3MB9Q4toXRz8ps/sAI1q7/UcQvP5I9utnUych2NSK+vJSqm5Jc6Zs2sJSz?=
 =?iso-8859-1?Q?WzQ/2oAyQ17IjAbAi+IjEfmVGkcHLrIv3DJbt5I+PWqgfD//jnTtdiW1pe?=
 =?iso-8859-1?Q?oSspB/WxBtvGAXcl/p25mUwXCTX0IJEQgtp3DNf79eApQMgL49tRjp8Uc4?=
 =?iso-8859-1?Q?o4xrM5wywAmUjmq6wIkUBjuU0efOpeylPM9G6zclq0/TSuuQiiSnCYA9KK?=
 =?iso-8859-1?Q?YlV7jC0LnVoAl7m7im6fMD4r7t14BAwubz7WvLVDXJG4F2ONZe2R+ab2r/?=
 =?iso-8859-1?Q?VWTj9xHwg4wiVaqIjLzue7YrJQnrqNLVKZjMf565xW6h2FUFUWz+OVPdG+?=
 =?iso-8859-1?Q?mrD5FUKNvdAcSJBHFPSIX+Dk6i+6Aw6m3p984OHFWsfewhV6VUIoehZ7WV?=
 =?iso-8859-1?Q?8MBB6H0qR9ugmS+gPvQ4GYcFaeqSgLjvbUJ1lV+Y2RUv0xWT03SPhwjFGU?=
 =?iso-8859-1?Q?V+BnnAoQhXt0y3dWMtDPwji9S0S4phqS2GFRaIlzLlwAJAFSE7CyxKSEgm?=
 =?iso-8859-1?Q?MYRM3HocsG86iGHYGAiWoMZHVkB+1AZhhYOyPtG+/gsd/RExiYuemdysdP?=
 =?iso-8859-1?Q?tcQ8uOaXyQw49viP11L2rMdPAJ7eQDgqdixd8NrwfFG7S8wi7Winm26Khq?=
 =?iso-8859-1?Q?v+O05UvVcl/h9fSqZ+7TasZAp1bW?=
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
 DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f64d6a01-58d6-466c-b67c-08de4fa131d8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|376014|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?cBN0lxkqCSn87JL6reGZfOQwz1OUwz2O11zRPSqopZOOcNbridOzJ1dFzb?=
 =?iso-8859-1?Q?kSRyHJOWeFdHeMxAVTBPF0u4AjdlV8azmHdVCLCCRC3Y879/8sVn1Jl3Mq?=
 =?iso-8859-1?Q?0c/W5XE5gjTDH153cv2/mXcx9klXttXOyS12vE+jxXJVgeVhMg/eMQ6Y1r?=
 =?iso-8859-1?Q?rR1vb6uSTsPbNm6Ilq6aSwK0mZ1YwgP6ev+Avy4/QNuSGN5zEqWOOWq2hh?=
 =?iso-8859-1?Q?KN19RuAjT1n8bcw6QwdX9pF1zPeL/vxrAhR3In2t0glPK+fv5i3ssjnC99?=
 =?iso-8859-1?Q?E5mfUTBm0IX3fSgHMGlmQ5LNVQ4bytssXJQbfTXArAWe/55phfcoqzoncj?=
 =?iso-8859-1?Q?6kJ3zzzujv8lFJVVkSZa7vM7CBwiB7B8TQSAFuNtK1MOah3ZC9qHO9zaUD?=
 =?iso-8859-1?Q?CiFd3Lue+9SSaG2ifchS6+6ys9OS6scIevLhPxprb1m7xEooVIpBy7DkC7?=
 =?iso-8859-1?Q?5x1oSZjaxbG1XwDK9DSEx01/I62PP0x5wggNbuBQIF5g59F15O+oZWCBZN?=
 =?iso-8859-1?Q?WoYplsCoVPSmAKQgrddGcHJKl99W+IPVpFYHq8cGrVS8Mmu76RfpE5ee1+?=
 =?iso-8859-1?Q?WvCYWKeTyNcsh99Aq0KTDdEjY8xrJSHzmpqKFj5hB3+ECGzDRyTV1Bmb4L?=
 =?iso-8859-1?Q?/6zD2mgt786r1riewljNUaqshal01SSaYOFufnrk5i1F1kOxHMnAvDJmAy?=
 =?iso-8859-1?Q?kuAd8AZr2mQV7oc6lVYAU37oIfS+zWW8gmrJIpBHmQomDQFFefst4Unb4E?=
 =?iso-8859-1?Q?ELPBve2b2ltuC/RF9u7sQDzxDhsvme7q4tqRXXS671pwz4nNQx03DB9Yd2?=
 =?iso-8859-1?Q?hYFawckvYcJ4PV/A9ZJm/SUYEVHvm8Y/0Y9pGjZeMcW5yztJv40jLSFIr1?=
 =?iso-8859-1?Q?1NIK0rFVkGmiiw+3WZwg//MhJGdGd0a59dP4qFY3yyflwAJr95HielHWI7?=
 =?iso-8859-1?Q?cAYMJIL7cHWUMOI1h5PpsJr7xxi2TNlogDWc/tJmvBeG5ljxmmfuhialr2?=
 =?iso-8859-1?Q?JpsfQGs+H6uQ6xexnZxz2PncbBNMvLBAMHR2bdC25++3sj3Evxyzho4OtO?=
 =?iso-8859-1?Q?QOinil1BIMsKJlaAy7n1pBI3xFNcRV4XRWzVJaIGaFfpVLqWcJ7wqAYjqv?=
 =?iso-8859-1?Q?qWPw54B54dD2ocPm0CIAtJcgv9HAqJaHmKJKhXV6GiOjO0rWvyoEHkJjyu?=
 =?iso-8859-1?Q?ZyngfFz+OpHBICuDxkNQcW2eiBV0BWHbkE2NbQFJXnaKQYU19vWUivyJdr?=
 =?iso-8859-1?Q?b4FjtnN5jpMdklXicl9qBGjpjJWC+CAGz2ZA70KhVNoYllkyjhxO/8WYCI?=
 =?iso-8859-1?Q?6rvHSu8y3+XPbtSFwW07tS+bXLCuaEWQcarwFxfqxoGmwCYgaai3NsBk1t?=
 =?iso-8859-1?Q?Bq7/TOnbkjrcLr+EEwOr8WyUq9xZQt+N8/nG/oYPsTw46j0Ulu01rRz45v?=
 =?iso-8859-1?Q?iAlLkYxsIFr/3bYbaJHRyHqoSCkv9jc3Ieaxt6aK7gTsW7WTLW40yXKm0D?=
 =?iso-8859-1?Q?BaIsmPrmiENnj4suc8X+Ws6X+c5rLDSfrVK4Hk5ezC0LmY9MJ16pf21eNw?=
 =?iso-8859-1?Q?6SYPkQ6WE2HdTF8HBktO80sBE+2oB7yuw5YxS1i1hWa/oVgcd5N1p3Mae1?=
 =?iso-8859-1?Q?qh/fBrk3YsHI4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(376014)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:50.4475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0408b60c-d483-4438-7132-08de4fa15743
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10220

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. Avoid the guest enabling any PPIs
that are not implemented as far as the guest is concerned by trapping
and masking writes to the two ICC_PPI_ENABLERx_EL1 regisers.

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state. As there is now no way for the guest to change
the PPI enable state without it being trapped, saving of the PPI
Enable state is dropped from guest exit.

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
masked version of what the guest last wrote.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/config.c           | 15 +++++++++++--
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  3 ---
 arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b49820d05e6c5..0c7ac0f0a1823 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -788,7 +788,6 @@ struct kvm_host_data {
=20
 		/* The saved state of the regs when leaving the guest */
 		u64 activer_exit[2];
-		u64 enabler_exit[2];
 	} vgic_v5_ppi_state;
 };
=20
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 79e8d6e3b5f8e..a82a72973378f 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1586,10 +1586,21 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *v=
cpu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest. */
 	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
 }
=20
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1);
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1612,7 +1623,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
 		__compute_ich_hfgrtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_ich_hfgwtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 47c71c53fcb10..4d20b90031711 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -31,9 +31,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER1_EL2);
=20
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER0_EL2);
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER1_EL2);
-
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR1_EL2);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eecfb5f2db79e..89bc2f6ea68d1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -696,6 +696,39 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 masked_write;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[=
p->Op2 % 2];
+	cpu_if->vgic_ppi_enabler[p->Op2 % 2] =3D masked_write;
+
+	/* Sync the change in enable states to the vgic_irqs */
+	for (int i =3D 0; i < 64; i++) {
+		struct vgic_irq *irq;
+		u32 intid;
+
+		intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, (p->Op2 % 2) * 64 + i);
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D !!(cpu_if->vgic_ppi_enabler[p->Op2 % 2] & BIT(i));
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3430,6 +3463,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

