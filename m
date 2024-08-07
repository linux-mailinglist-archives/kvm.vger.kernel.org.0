Return-Path: <kvm+bounces-23580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D97F894B2E3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AD6CB2165C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB4C1527BB;
	Wed,  7 Aug 2024 22:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RPyLckkj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062C12FF7B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068958; cv=fail; b=c8/Dwt500E4FiMp51P1wD9AdU5e/xbSbUlx1y276wU9oLU68Dr8erp3fbGAYyRAgRD3dupbzQmEUc6imobBoL54VgmnxZtC/GcHKVtZByG3wvnDSG7vu+tzkI4lPjRpgiUKEg2Z82BiXfGZbm+YNDzt0YLyGTkHwhJnjANgfNns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068958; c=relaxed/simple;
	bh=LbHF0zY+EOQMVgPrJGaDUf/nBLjQpNLy+i6jwMpS0SU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KsLeelmusxgumjTTrHp9ddf1YtkJxwarnfJAnI9tDw5ayoXbVr0vpISJo84GI8tLczxI9PlzCKxtSuIdr7GBG+dqpHs0p3l86vseLeOMZ45kPJdzTMtpRo4QVqADgMl/1VYaZqBwfBmu5EJ73hQQu1u9iMV5iFqdquBSYaQiUGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RPyLckkj; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GanBE+C31iXj5Z0s/AmHh6jT4OtlIfEecAT2ii8CwDUzxGdPemh9MHgEOcV7DZDsc1FzWv/hMArFRK6t+MGUvQuWI5XXKz3fKq9RdvXSws82416tu4tb6N+XF2NP4XuuzvWiTPJv5g+21EgdhGmwmds5ko47S/MWY5XrOrhfz9tpV5vG03wGedfERJw1RlhkLghutE4n3XgI9xxHbIgtIWnRvNHIPmy7HDF3gpOYL8wP0pVjSPyb4F7YpAtvt9NcP8VTg5ZEdkJh3c/dzYFMxm6dMDWS40X+BxZm7Bt5veBJEP0ciC3UlaK/AQnulUXuMd0QNJUeO69EssF8iiqO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeZn/OxC98c6/Yo5piz6c6jBUdhs3HGA7hM+ers+boo=;
 b=vSr5EoTV5qswPJfZt64/MXGW4U++EyxxLxvMb0ch8aJ63P1ZSQT897/rOhEC0NQtf7rvm/50mq3HqBq4fGPpK3+D9VO3fyfjyXRwJMQghPT/VoALqE5iOLG0qBR1FUwqEpdOcTt2HZ61/Ja5oqC+AWr0jH1TJzD4WLJmqiYrt2VIC2zKtdRVTnZ3GzJVLwYBd0adTK1uMYuWyRseTit4jJJ7KIa0KqqHkYf5pr44G+XeemAHMb+yfsklGVmcYCAnoOtDEYOe8eOyQ5V3F2GmQsDJcbWjnr2weBjI2r37ry9b6euhzxJ8KQkdqCM5BRpiS5Qsq8uQ75c4wSfVzqRSvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeZn/OxC98c6/Yo5piz6c6jBUdhs3HGA7hM+ers+boo=;
 b=RPyLckkj9GyEfig/FkY4No3JVQ6dvUucRUuig6JAhBwCpZS5WfmVKpIr8EpEmdvOMMrdiKNW3QZh9wDgeroGNEietkPYTHRp93UeLF/6+rkOZ9vO1KFjfCGUUnzDbolotL+quEtogWO89Un1m9aKXlBIhNMtYa/g1RKvzWYWg4Y=
Received: from CH0PR03CA0381.namprd03.prod.outlook.com (2603:10b6:610:119::16)
 by MN6PR12MB8589.namprd12.prod.outlook.com (2603:10b6:208:47d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 22:15:52 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::9e) by CH0PR03CA0381.outlook.office365.com
 (2603:10b6:610:119::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30 via Frontend
 Transport; Wed, 7 Aug 2024 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 22:15:52 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 7 Aug
 2024 17:15:51 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <babu.moger@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 0/4] i386/cpu: Add support for perfmon-v2, RAS bits and EPYC-Turin CPU model
Date: Wed, 7 Aug 2024 17:15:42 -0500
Message-ID: <cover.1723068946.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|MN6PR12MB8589:EE_
X-MS-Office365-Filtering-Correlation-Id: 18ddb99d-8d39-4aa9-56bd-08dcb72e8038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X24eqRKJfu5F+XY14XYfC7YONodvCMu5nvSweF7ExBdSavzu9kYiA6tUFvlT?=
 =?us-ascii?Q?SZ1NAA/xD85SuR6DdOxsT9/BQwgq4OhBHqIpgNwui1IjPdGnBFzZLq4U6ecQ?=
 =?us-ascii?Q?z7OOMYyLZXXI8fwORUudw1X6Zxs3o5wXr3LOpEWWUBMalcUGC20BfM3VxRNF?=
 =?us-ascii?Q?nP4CUyNFSd+vIxCluAwSjgojhr8hruiQq2IAbnIEHd6Pe2MO18HSNCgXBE/d?=
 =?us-ascii?Q?K5xrYL4L2F3CeXrVcQAD8g00NI5wU2127IJFkOXSXi2xVOsZ4iq8Adz7zUm7?=
 =?us-ascii?Q?FjlkqkC/GozRdiQiVWONcnvnfuha4JremiBihWN2wPRls2v+2/0wO0vdjZG8?=
 =?us-ascii?Q?XzqwUrUehhmQWebnVbqZYFapz9KDLMTfKX1Ox26O7KTPShN4Y41qXlpyXWE8?=
 =?us-ascii?Q?57swvIaH+gUlku0z4wfi8GTVdhE1lKDDRIWk+M4M0e5U59TgKkcInEmYhav1?=
 =?us-ascii?Q?EKTBebN+dPPcTmgTrwdX+9H5bTniCkV2EQvWhRet1FQ6zUIzfym4DU1OMICF?=
 =?us-ascii?Q?U/pl428atVuI403rJpqucsspJ8tFoMmkR8Y4F4Sbari21fiJYavkvY+P8MDe?=
 =?us-ascii?Q?t8AQMcUM2Q+z17URq8f+llX0R7jBkZz4i++0Yt1MjkjGSnm+cq0wCinYhxzA?=
 =?us-ascii?Q?3v9L8l4ZI99MGsa4H4cdanaSkrloRw4NgFojLwWiYe2S0OYQ87dznCrpKgQz?=
 =?us-ascii?Q?/eWXHedQRzRcMf5fqz8E7kYhMXGNQUWB6F6y2Jsgg0f88jP95XSKEz0Dcu6C?=
 =?us-ascii?Q?F0nWp83mjNGmF8c2vSXS+HAxlBWxtMd+5ti9yNA49MHX5yrIJ5ceq/1NCHNZ?=
 =?us-ascii?Q?V0bjEek6bv4FHSuqhfaOElW6u2hZD0KCJuZN9+GJ6bi5+W2noveY0ePx4uoS?=
 =?us-ascii?Q?jFOO7Ot/eUoS7z0qTFg1l4jWyMpOYCvp4fJ7ckFri7zf94M8fpSPIaeuJHyU?=
 =?us-ascii?Q?9F49S5UJkpwhv6qP8uB69P9pMUllPqKKiTs83LnBZwzSm9Kt+P2bFigeA/wp?=
 =?us-ascii?Q?uEqp2dbD+iP88GtTlpD6M9Yj7ZIlLBBEAAiwsa+gk+nGifw0htrSiABSPxhX?=
 =?us-ascii?Q?zdnuWH1AMsDybsSCCTKvkayTNg0WMu8O7nrDpmNLCzEhrcMzUtEjbC2IEX9q?=
 =?us-ascii?Q?z/chyZ2N7ctLbU9/pAHN6Rs0O9JGhabaiqAMklgjxnHPCqQG+YsNoSOG/Yi9?=
 =?us-ascii?Q?Lmeo5J1piBX12521Ci/LeQXAJRGoxQ4jYU2pP9a0WgqiMrB4BaCBGVEJiuPr?=
 =?us-ascii?Q?GxqjeS+IDE0Cp1QklCDy0GFlJjWtFr2F+VyZUpfym58OC3cjDTVYDUJ6YmEE?=
 =?us-ascii?Q?gIfIlY3TvMhB3PbsSpm6sT/wlhz2UcyrsgNlF1bKyVokfE7sLkX944gYWgxq?=
 =?us-ascii?Q?BX32/eRJqnn1C1IyjqbMvvtRxWr07IsVrUiJYTGvPDWTUz6Vhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:15:52.6541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ddb99d-8d39-4aa9-56bd-08dcb72e8038
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8589


This series adds the support for following features in qemu.
1. RAS feature bits (SUCCOR, McaOverflowRecov)
2. perfmon-v2
3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
4. Add support for EPYC-Turin

---
v2: Fixed couple of typos.
    Added Reviewed-by tag from Zhao.
    Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")
  
v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/
-- 
2.34.1



Babu Moger (3):
  i386/cpu: Add RAS feature bits on EPYC CPU models
  i386/cpu: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
  i386/cpu: Add support for EPYC-Turin model

Sandipan Das (1):
  i386/cpu: Add PerfMonV2 feature bit

 target/i386/cpu.c | 202 ++++++++++++++++++++++++++++++++++++++++++++++
 target/i386/cpu.h |   4 +
 2 files changed, 206 insertions(+)

-- 
2.34.1


