Return-Path: <kvm+bounces-33341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B809EA2AE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11D58280E99
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC0D1FA172;
	Mon,  9 Dec 2024 23:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ThqQwTu1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0554A1F63EE;
	Mon,  9 Dec 2024 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786681; cv=fail; b=tGtLszKIB0qRpv1vczf5E8pYMMsG64Pod68HzTAR/9Btb7cOsstw4Vb3J1KBYsmc+DPYC5/pqMczyN0nD7R0mcaI7IapYu2WNHL00wyuB2/StNJxG5Z8kTJupznugzSnqGjEr8v8aZW1oCIGJ/b6A1pMcM4g+iUGf9cf1U28bJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786681; c=relaxed/simple;
	bh=n8jSPpjMR2kpiQ26phbSjpBu/S99k3h/hrC5ycSpfvg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OKTcYypviH9Kjqd4cLgKcI8QSYUMl2dJZ6Q6PMJoi6NnCmiIMqUhL0rKvXPqN8CYBpzNJgZwn/OnLR3yOWwQibWLIES3kPJd8yyibZ7/MleRTdztH7Kfa1rM4HWwrQuV4FP7rTZ33ghLhLP4uZsGWwjBCFv2mIvMgOxzmdY0fu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ThqQwTu1; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SUXZqTlJPp3AdOo37zqUBe4oPH8gCIeTXm2/DMsdTk+1Tgi2H9rgFToNuxIuuE7Brw9PbJlW1rnKkhVN55SAVExVAJH3VZt7Yn/QQ5dDJ/6RD+kYdh4eXQG5ug/0XhuADiLacUb1w2eTI273JYzsJSn9MDpJ1AjN1VrlFWMuVFU3SlboFtIKqIpGMxqmrr1ZSDaHR0m4gjqBtJXqu0S3usURYXALEu9rm4fIhMVyIP3k82EO5umwgp/gRerCU3Ac+Z4kD1v+fvS+PdqiVbY+3xIWqETL5o55syibThfXFAN8dv5kzf5IQ9erWqHsF3fOJnE+qNwlu6Z/N40joj3TKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvZMUq2N9V7KxbFfNUHWLrMFkzyR1eDAdj53dKByjTY=;
 b=igWATXeWJypMKFRVZWRJZE41NXfDvMc9WL4AES5GWCWSHQuNdFbUSPKrPLc4oQFJ81KZ+PieX5ietMAkELvVl9I758YTFwnFgqbx8p36mrrd8waDI95St3jDTzazfvcZ+Oh9P6ryqwN0zsaoheu9jwPre87IOzP7xwTBj13a2QE9f8Bv3wrUd51UpGBdurHiNCW7sQK0DcAC+CTGGOPoP6A4lvn5MXf8pxso9rcgJ6DMD4mdQLan0wZ+9otZB5qpwopbMkbdnGmzBKT1UUWZJMuqyFLQPY2gAtGRyrRRjsXk0QIO/jSl8aiNrWdeEcyRb/px8Ufx0YWdkZV6TxQ3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvZMUq2N9V7KxbFfNUHWLrMFkzyR1eDAdj53dKByjTY=;
 b=ThqQwTu1u24PgaqXTAs5qAqIBJjyO/j/ZvY/BNg6+CKQCoG9IJp0ln8UweFIk/ZljF6Pfsjch4Qb1vKMIL0oVCT/iWFydKJJwEFVC6DKWV0KjLMIrHp5eIhvw83n+Q3JGY/FOJrGWXGMD5je4GbghkU+JhGq8dSTUQTrU31lBBo=
Received: from DS7PR03CA0321.namprd03.prod.outlook.com (2603:10b6:8:2b::6) by
 MW4PR12MB6850.namprd12.prod.outlook.com (2603:10b6:303:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 23:24:35 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:8:2b:cafe::2a) by DS7PR03CA0321.outlook.office365.com
 (2603:10b6:8:2b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 23:24:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:24:34 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:24:33 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 0/7] Move initializing SEV/SNP functionality to KVM
Date: Mon, 9 Dec 2024 23:24:22 +0000
Message-ID: <cover.1733785468.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|MW4PR12MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 800ab76b-6a6d-47b6-6fd5-08dd18a8a449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z3B7BEv/FYfDURJWNOK0StoMYYFSENs7kA0ZSVNJKGEXTT7+Kr9TkMUR26mg?=
 =?us-ascii?Q?7W5vI6la2kKaj+Zs+ziaj5C+hfcEXZZoRDYwSVKBv9pB5qC9ico2jMKP5ocL?=
 =?us-ascii?Q?ZpE9J81AG1hRErCjG0o0HbeQSmKGH8zaExJzmunteOCdheHKxPPYQhheQJH9?=
 =?us-ascii?Q?JZFfq82Jdnxm0rkf3tIZeMXxl3jsUgQe1dQYK/WA0dR7fC7jmDnCpkF4Ku60?=
 =?us-ascii?Q?vT0hJEYHlORncFzjWM6sy4dblYxSJb9LNUj2hUWT1rfQjj8s/0eLVkDNhJPz?=
 =?us-ascii?Q?Pk5s2qGvhIkielckb2S4/I/c3xN88h2o9mP8IAdQZBcb/rIX0Tf9s6jvz7xU?=
 =?us-ascii?Q?6/CnPvUtl0pJZmJN1o7lUMdYRnta42ZVqsmKYUSmaokoC5fAJwMokpdUruz2?=
 =?us-ascii?Q?BZZrqlTwtWwWfkPaSQ3R866kyiLi7PuhzLQSg2TudqVSCDhGmrFiYhUniYwn?=
 =?us-ascii?Q?zCIChIDL2x5jufDKaWUL2mJS0Kf5mFL0PqkpCqxguSW1egDeFwp6AhQ0cMxf?=
 =?us-ascii?Q?OroolgVvaR5U/+LuJUpqnfwpDoK3tzPkbt60jsyH0Ydh4b7DbiaG2n1spPU/?=
 =?us-ascii?Q?kupjEfbzzGulu1NdzQufGM40vcohRYBXPNkOvUPmJFe7AO60SVxIDCb8izK3?=
 =?us-ascii?Q?mFYuqnOC0J20VAugN/NRXmxWUwVj8lEtWdoDmL0pve6APu+K4jzUykiqo7ae?=
 =?us-ascii?Q?/OiaNeLGnKOZwtTeb+GZGz6l1a/fld2YW+EhpRlcIkoJr6Lk5nOYljGNrnXY?=
 =?us-ascii?Q?x16UVqRKXgPu3mvAEfoSTXhajF2tFZy7trxXY975orlFTLT439LJDUL1/jam?=
 =?us-ascii?Q?uxLfDNT12W91lzKj7njFe5pJ2gqOlEYWHb2AnoCgOSs8H0ysya1MenIur6Vi?=
 =?us-ascii?Q?Q33LisuNtryP6rmrKAHx33NFdYLP3/jxbclV/OcWcwruW3ijQME7kbn8F3bQ?=
 =?us-ascii?Q?AEyVFAuI4A5hupS1oO2SEyPctNRxt3KlM8fOSIj51nUJmCnvmCg0IdKlt30Z?=
 =?us-ascii?Q?+8urjU5TrzBd4qnlBKLEjrTU5//jitlAh+vyl7Xaddilw67dYt0ymYvfCGj9?=
 =?us-ascii?Q?yhuG/iBkvdz/D07thKqpDnCpLZe812rdIg5ExN9PKwBj2nKqgxuxMQGVdKer?=
 =?us-ascii?Q?pnb8WsQH3IBO6ZCusmSmWiDYCveTHV32JuWjNhPmnDGDRit4IELAB6QeUeuL?=
 =?us-ascii?Q?LcFSKG/ZZFK5Y5gUMZyzMN2RR4KqvlKKMN0T0LPpWIAzZXwMyz7p6eliPYSl?=
 =?us-ascii?Q?Nf1bICBBdYB+Fpo+VIk9ka3Hlj8mbdf3YuChlIc1oVNYDp44VyoJ5n1znjQq?=
 =?us-ascii?Q?i5aZEHaYIhkJLOSLVgTrLAMsu2hcIVRiqgPObxy0/qGszAMW92dYjnxbqOtD?=
 =?us-ascii?Q?hF92ZZ9ZnW8vArn0M8I3DYsnEa1L410a4gu14BzLLRc5YJOov8ERSYWJeHqH?=
 =?us-ascii?Q?sp+SHevQ4uGv021dYuLq41OUddSVesvwsAjpHRHMqfDuoHwPNnxdfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:24:34.4139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 800ab76b-6a6d-47b6-6fd5-08dd18a8a449
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6850

From: Ashish Kalra <ashish.kalra@amd.com>

Remove initializing SEV/SNP functionality from PSP driver and instead add
support to KVM to explicitly initialize the PSP if KVM wants to use
SEV/SNP functionality.

This removes SEV/SNP initialization at PSP module probe time and does
on-demand SEV/SNP initialization when KVM really wants to use 
SEV/SNP functionality. This will allow running legacy non-confidential
VMs without initializating SEV functionality. 

This will assist in adding SNP CipherTextHiding support and SEV firmware
hotloading support in KVM without sharing SEV ASID management and SNP
guest context support between PSP driver and KVM and keeping all that
support only in KVM.

Ashish Kalra (7):
  crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
  crypto: ccp: Fix implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV/SNP platform shutdown API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  11 ++
 drivers/crypto/ccp/sev-dev.c | 227 ++++++++++++++++++++++++++---------
 include/linux/psp-sev.h      |   3 +
 3 files changed, 187 insertions(+), 54 deletions(-)

-- 
2.34.1


