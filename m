Return-Path: <kvm+bounces-50118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F224DAE1FCB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731863AE3D3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E6E2E6124;
	Fri, 20 Jun 2025 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dfMlF0FW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dfMlF0FW"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013017.outbound.protection.outlook.com [40.107.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ABB13774D;
	Fri, 20 Jun 2025 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435710; cv=fail; b=DdUgNCjOtMVgCzCH/BSgh97QLlwSWIviiBc/oKILkB++HVSDDrFW3QDVhk51lDpv6NaUyztTd7cScVqx9MEMrmYXJ004/uCg8XpeWLmUkh3g/VXGzE8kjjwMuPsa3+zisF0tcD7VK2gW0Nu6JmLt965z3V+Wc9Oi6zUMGiYGGf8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435710; c=relaxed/simple;
	bh=I1pU7+v0ne1pwhl0rW1n57cjQCU/2fDB2oxldKZsqGA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WT60XR/I3WTfdTnkCgDlMcOIqIrYRr4K7jVApsO/1De4L7pLkdMHFxJcT8hBY1R3PV0zs+CjExgV9h7CXPefuCy9Hdla5eOfEvlSZ0EfvoZLXZa0joqJRxyMIrJ0zpie9xhFJE63QyjlbGKZcOjsa/gD/6sBxSKZdHavAuYzmR0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dfMlF0FW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dfMlF0FW; arc=fail smtp.client-ip=40.107.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UveKmvJuroVDEm4x1A3IyCBN2aaWaA5LwOx8vGPjCUSt+s76etvG6UOVshgFryB/FJQcFnXFVI9X/rGsQcZpUZ2ZktU8J02bu9POmeYKXcPvEGz92sh8P2v0Ysjdddx6GQiutHjS7pCRgTow8rkoOuot2P0UyRAWSJfZGOf7BkHcv8ttXcChfa22bsLcBhKfYURioVROPhnlKAPSLbXol0dM8isSUQmde70xffRNoTDww1RhHnTEquIs7LW8GZ91ZGHYas6n44EEnHR2HsAYbvLLLZkFxDpMWDOiWIiagJIdM0CzusVHyC7JX1LlP+3FNeBWRc9BhxEjcLgJHKrLHQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br+pptz0dEzDGu3F+DixeFNoziYn9oZSKCIqG2JSTVs=;
 b=M6d0ID5Ep1tRTU+zgj6wMs5kZFKjd7Bvo1YKrdd3TmN6sI9bzLOthdNJY6NEnf+JEb6IALR6V0i1CvvWd/dHK/gWzg7JItvxUnhJwDAYSUYVUfR535DbJ5MzFRCzJBYIHFj3m23edLrIND97UxOz1hshJdx8sfp2Npq/1p+84zRLAqSTjWUDXfvO9tM78jl04VkBpvY5Dds8pJTqhXrYJWJ4ns4lIG6AsXzKeHujuhvQc0RC3SmaDYtqcEPQ5efAQ91etw0fwdWediiMYx3SZ4VRktsHPcVj/xh/7b5WpOJQ9jQhngnDgzaxKZypTOR12rPSBaaDFNDVkT0q6bxpeg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br+pptz0dEzDGu3F+DixeFNoziYn9oZSKCIqG2JSTVs=;
 b=dfMlF0FW2U9co5hEBcardwo6+2lUoXUCYnWIhnHjfeWzASwDA5d9FIJZO87udKtz/mFSlOWN8IusTe8HpKVmmjY+dHMRFgfAfsn6ByQ2A24jsa0dAEazvCBcwbg0oApHgTCBdNj35nrYqbXehK6i97h3yZ1C/ppDvYJZUianVQ8=
Received: from CWLP123CA0144.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:87::36)
 by DB9PR08MB6619.eurprd08.prod.outlook.com (2603:10a6:10:257::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Fri, 20 Jun
 2025 16:08:25 +0000
Received: from AM3PEPF0000A797.eurprd04.prod.outlook.com
 (2603:10a6:401:87:cafe::db) by CWLP123CA0144.outlook.office365.com
 (2603:10a6:401:87::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.32 via Frontend Transport; Fri,
 20 Jun 2025 16:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A797.mail.protection.outlook.com (10.167.16.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV2zvrLZsYGSSHJ7WvIoPuc9X+aEHLbRzVUWeEiTXepxHq9zhaVtTl6Nk+Nc7w/nujaBS9o+CtwCxgfw/6EKmDftiivXKs7//D45OOzOy4EV5fYKQrTufuD4ryPVITbnq+fMIBuE96FErn9tR4Zi5REY8sWMmgYRFPeytvhaYDAw9trpCWZOJzVd+OVzRjXimTXk/+CFKe3sCHZR5LkRxIR/FoSBW0aUVCuTsdkDs0Zo51jsygUm/bQavIpgqUtjQpRgIm6HpzykAi43EMlRm6fyMEHG5hf0iv5QauoqZvNxy9YG1iqoTW6UUgBr5kzZqSMQE4/oLl89/cGn9ah00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br+pptz0dEzDGu3F+DixeFNoziYn9oZSKCIqG2JSTVs=;
 b=PxSYv9Q3/UuxR3n+1ScjipMn+i+zvmNcNf8tNte+RG6dzLeZVyslxwqvguN4g+2pAb22SDI4uOo5maJewT7vyu4oeyTqem2e3Eve3IwHqdtiQ1AIfpPkt5J9J7AjESwJeCFT/XoBHuFcUIrWXWRxcpxbCnSPrzYhQi9ToNaCigDn2AO7x1M60hwAsUFmER28ws+/vM0MY/sd9Su5hiykpR/RAzwb32JZQ5v9tJPi3zaUUueY5090/wsCO1RChFfyvBYcfTuIt9qC2pJpsl52iJXnmQxUdUAIBKRKRnQASJtl5VB1NDzOWb5f94ZgUqdEl5LDcZDvFAXNTqPFE7dwbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br+pptz0dEzDGu3F+DixeFNoziYn9oZSKCIqG2JSTVs=;
 b=dfMlF0FW2U9co5hEBcardwo6+2lUoXUCYnWIhnHjfeWzASwDA5d9FIJZO87udKtz/mFSlOWN8IusTe8HpKVmmjY+dHMRFgfAfsn6ByQ2A24jsa0dAEazvCBcwbg0oApHgTCBdNj35nrYqbXehK6i97h3yZ1C/ppDvYJZUianVQ8=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS2PR08MB9474.eurprd08.prod.outlook.com (2603:10a6:20b:5e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 16:07:51 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Topic: [PATCH 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Index: AQHb4f14VUlvORHulEmA538kHw8XQw==
Date: Fri, 20 Jun 2025 16:07:50 +0000
Message-ID: <20250620160741.3513940-2-sascha.bischoff@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
In-Reply-To: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS2PR08MB9474:EE_|AM3PEPF0000A797:EE_|DB9PR08MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: f31f924c-c136-41b4-b643-08ddb014afa2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?HlPPJ92xi0KE5uB9wMNnEMxqWk4kA17aYw4yMy7ZrC2anFVljGfKQYNAul?=
 =?iso-8859-1?Q?p14EiFQ7UPxHbQSs/MA/fcr+eGbay7laiP7HVxJw7WOomzP5ZMxpaNmsY3?=
 =?iso-8859-1?Q?gUFAxDo6dkPvExEeUG366uQsJCR3kUnAcWkl0Tm0EWF9lodnl1Js2GyiqO?=
 =?iso-8859-1?Q?QzkQqSwRKZNDiV3WPWCip+R/88x6VL+RE7LSOuQgxZqgd9mOhfwuB5eBq1?=
 =?iso-8859-1?Q?DDvn0BM7uB7xzFvoozcTN4CyVe6TwPW7QrNTfZf+f99UzuYoDc+wwz1fN0?=
 =?iso-8859-1?Q?f3IUZAmtKDvEDMg9AvuS/yYtnGK7dt8cLoJ+odMIzU6zBd3v4yyYBQpLlq?=
 =?iso-8859-1?Q?RIaZ7Wp6wedc5xQZVSXdRX31PTHuG3rHBFbWIE6lsnOnVUHzqTL1wv9BjW?=
 =?iso-8859-1?Q?7tGVhWEPgBQocCncae4fxwyJx/RTctq1djs4Cwh7mZd9Ps2bzsMVkFgVB2?=
 =?iso-8859-1?Q?RFj+KXqy7oNaBakOlXgD/smUP8qCEPowgatTIThyzq7Myst1POZb5zkSlB?=
 =?iso-8859-1?Q?1BKGjnBFQYbsCD6U1wx2C1R4mSc5mQAyYZTIAWlAm/PRiD13P8RYLphC8x?=
 =?iso-8859-1?Q?UkglG4PxDTdTurTPl3OklLYn5ORZlUoL4o8loeSOQPBYeF16/r54aUghDb?=
 =?iso-8859-1?Q?RkY3e4lhxddulzZfaNXslD+dTf9V1WctM9bXAfvn3lBeSWH4N9lq2T+Uq6?=
 =?iso-8859-1?Q?prCXQ9R7OGyDcyb4wXrrqgo2/WQRUdDs05NLuNVLJzv3OmON+6qa4o3kro?=
 =?iso-8859-1?Q?9XDprd1R4DEK8iVqMVapztDQb9so1Ro4pSCW+CL9GPRJJPyP+rG6ppTZKF?=
 =?iso-8859-1?Q?Pl+rT70oeHFKqw59x09qK420ii/jvDl5zBajGZR0BvWwPxki6YrHz9GuxX?=
 =?iso-8859-1?Q?WAnNClAWmXh0ZLxBuQ3Hy/gXMWgSkCRh43UCubA6NGH/wF63DO/7oEZgPc?=
 =?iso-8859-1?Q?H1vYTq9l4Veg04TaM2tQbo37IAWEIchhXz0FGj45OREg7ewH1Uw06Y//cU?=
 =?iso-8859-1?Q?iacVgWe3Y4tZTNtFSD4oIeotBFp1fqgI1/X2MHChEYB/sXz8ogDbL8iIZj?=
 =?iso-8859-1?Q?5b4YdvhynAZMlgWwtNPCM1ytKUK7XrRP1zGENZkCCX5Nn/IZZaZbDavNjl?=
 =?iso-8859-1?Q?God8YZqA/N2Zh9zisThgXnuy3mC216Tzghb48pPTuBQ3Gq19FFzYhCDgc6?=
 =?iso-8859-1?Q?0Lenm5KkaLJV/S8dH69AIYsS6zjhpMuDZCIgObnNTj1OevI2P/LG5Cp03l?=
 =?iso-8859-1?Q?B+NWnpUYl94+iTkBNo977+r3yPtJnqzALheE//t7Q9f/ITklDEgHOqnzSe?=
 =?iso-8859-1?Q?KyrDvBIIRKyzscSxiKMAtMMcnjdyeV+5vMaHxO/iWglm7onUhKxCf/K4zb?=
 =?iso-8859-1?Q?swIviU8MDQZhQ53l38cGJpgDZysvmjwBIrbRRAsmPh6qqt1KyEEWifa2Mt?=
 =?iso-8859-1?Q?FizkK8vVdMMqe2wTGKCPrh0UEzMCK5stQiMkncZtkjtx+pUrWq6JfQX668?=
 =?iso-8859-1?Q?0WCBg87wgnNv3c996P9RbK0JMtf5XvultUxJReESrezg=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	99ba701e-370f-4c1e-9db1-08ddb0149b6a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|14060799003|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?uTZywpbxLPdxsWLSY/DixmuPagkUqVAIeezSm9s/0TwURpLZjWCI72Pn5B?=
 =?iso-8859-1?Q?MDt+ymf/MNYeuHv6/nIuZZB07X/VVTf+ndRGj7coUHPs9vjTYhSlHewcha?=
 =?iso-8859-1?Q?EP8qV7+HNP0nk8bG+9r/DvPv0bw8yTXDZsTD/zOiDIweupZujd8VL7safV?=
 =?iso-8859-1?Q?MlkYHJJwOnKe6uv5aD4eOg41/PkKpiyPyTIetojhVYv9tCN4wFclO/E8uM?=
 =?iso-8859-1?Q?XdLGz8wNZd6GxoO3hN8MeQlg6x9nVKRGc2qnQegmkJkr+asvwYaWti0doc?=
 =?iso-8859-1?Q?T+MIw7+oKwWAgE4TiJm+avr9dpQp5fZ3Q3RuJOpp+TmKAftinsbYktlsL2?=
 =?iso-8859-1?Q?1pUmaDp7UWmUUtZ9K6ZoPaQ/yz0QDOea/oD1THmydinwvABx0W1WDUklyD?=
 =?iso-8859-1?Q?beyrZwkazq/kwo7i+xNCiTikyUPfhmq2hV5TvPTLfAlm4A1TyMrJwsqMwx?=
 =?iso-8859-1?Q?DqnpllqbXR76PzjUwpuoMAW+eDMoFJETfsrdAJUy4Jp+UGnA/3OA8Obc3l?=
 =?iso-8859-1?Q?Ik/N58pbujCnkZGXZmsFCsMAlUdnL+TI1lR3RMAkwb2mNrP7Hargbk0/Ex?=
 =?iso-8859-1?Q?pcEIpb6X66Sh5JBMrpEB1/oGobTsARzfahTY2fkMRscnIazHQW4bNtR/gZ?=
 =?iso-8859-1?Q?hogttXVoK5pQGKGhXZ/L+WHxwYFOwg2c2YeFTkDK/vz+6PRFGIv7mbyWZG?=
 =?iso-8859-1?Q?vfJK2EN6UGrpuzhGQyqjbSV4k/XnOul1M2QfrSi1OOlWnFeJKO2NikH0Re?=
 =?iso-8859-1?Q?lW5ViInsgZdp23TiuEIvZw9R0pCo1oKoH+dtRCSwE5Lwce1/JpaO5fbuT/?=
 =?iso-8859-1?Q?Ayly5sOL8/z/+FBpQDKewbyevGKjLRMXBaonHRmArTwXThuxouW4naJCKq?=
 =?iso-8859-1?Q?sMGUuNlL+kfFoI6AgDfLKcOq62AGLjSr81gvB/HxdP4eylK4Wt45V3MVTa?=
 =?iso-8859-1?Q?Oce0QxpF1a3fbkl+1OG+qFuIyoT3ss6GKt8uEu1pRseVOCtmBqAbjuEekI?=
 =?iso-8859-1?Q?eKhs1aYJeJkwe4Ata3AJWJyoAPCXZxWJHVe2r3fQkzL2/reZgTN/c2WoK2?=
 =?iso-8859-1?Q?Y+z5EO++fMWuAa3Vhx9zUtbw4AlaCczFT7if1XsiPtz6TeEk/AMO4iuB/X?=
 =?iso-8859-1?Q?rYzy8sOgsRlxoHZIEy5rgrHDWU9B7rmAlH9Dihevq5GotlBkTkDCpvEJgS?=
 =?iso-8859-1?Q?2Q7tE2tR2k08vYI5nwR0iRWdiO/ZOADSFS54Qi66TfNiRRLcf8oXviEJn3?=
 =?iso-8859-1?Q?3XaxEUF0h1ZgpEaPPoNxjoARYVUDxWj/R9Hd3io32ERlNJqYHREO10VfQH?=
 =?iso-8859-1?Q?4U3z6d+/SIPyT3flQhM9eRbDkFTyNBCOma3yeRAnjF83VJZgASbiPt56Uj?=
 =?iso-8859-1?Q?nP+sgCsjilm6yKB8qDKCC6aZmLmzi/+uVbC/EfOeW/ZbJwOf0kiWS3whEy?=
 =?iso-8859-1?Q?hSVHte3IdEO9I1Li/sTjklXAO72cjWBnw06V7wvK/zboBR5K6WMwIa033Z?=
 =?iso-8859-1?Q?pNNcBDzYw5HWwoelXgC0izBfrIb0K22CKsrFCzrCjDCAf0wrVq2xNwJYMK?=
 =?iso-8859-1?Q?BzJuZXBBRI0X4Tmyh6QDDcbn9y2E?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(14060799003)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:24.8032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f31f924c-c136-41b4-b643-08ddb014afa2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6619

If a PPI interrupt is forwarded to a guest, skip the deactivate and
only EOI. Rely on the guest deactivating the both the virtual and
physical interrupts (due to ICH_LRx_EL2.HW being set) later on as part
of handling the injected interrupt. This mimics the behaviour seen on
native GICv3.

This is part of adding support for the GICv3 compatibility mode on a
GICv5 host.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 4a0990f46358..28853d51a2ea 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -213,6 +213,12 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_typ=
e)
=20
 static void gicv5_ppi_irq_eoi(struct irq_data *d)
 {
+	/* Skip deactivate for forwarded PPI interrupts */
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		gic_insn(0, CDEOI);
+		return;
+	}
+
 	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
 }
=20
@@ -494,6 +500,16 @@ static bool gicv5_ppi_irq_is_level(irq_hw_number_t hwi=
rq)
 	return !!(read_ppi_sysreg_s(hwirq, PPI_HM) & bit);
 }
=20
+static int gicv5_ppi_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	if (vcpu)
+		irqd_set_forwarded_to_vcpu(d);
+	else
+		irqd_clr_forwarded_to_vcpu(d);
+
+	return 0;
+}
+
 static const struct irq_chip gicv5_ppi_irq_chip =3D {
 	.name			=3D "GICv5-PPI",
 	.irq_mask		=3D gicv5_ppi_irq_mask,
@@ -501,6 +517,7 @@ static const struct irq_chip gicv5_ppi_irq_chip =3D {
 	.irq_eoi		=3D gicv5_ppi_irq_eoi,
 	.irq_get_irqchip_state	=3D gicv5_ppi_irq_get_irqchip_state,
 	.irq_set_irqchip_state	=3D gicv5_ppi_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	=3D gicv5_ppi_irq_set_vcpu_affinity,
 	.flags			=3D IRQCHIP_SKIP_SET_WAKE	  |
 				  IRQCHIP_MASK_ON_SUSPEND,
 };
--=20
2.34.1

