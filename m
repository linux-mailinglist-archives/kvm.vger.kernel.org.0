Return-Path: <kvm+bounces-56941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D492B465FA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 261395A39A7
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4748E2FF16A;
	Fri,  5 Sep 2025 21:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mHNcph/b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339552F60C1;
	Fri,  5 Sep 2025 21:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108389; cv=fail; b=t2dWzSMZQV/wqG5gHuq4h9u/dggiZQdGBqdqHvvQsGI9NCr0rwNDzDjAhfbBGNTxJOVCIQ0fz3BcUQaHBSY/gJC5tDP44fGHObucGO1c5QRwAQymrVcrk3raWcyi9zEz38eV2WheMaMkbaQvI59W9k9p6gKWXlzTGyMWBC2sJxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108389; c=relaxed/simple;
	bh=Y+etBg4oMZa88Qw9p/e1Fmkc2S+gbg42e5yHamnv58Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPf47WIE2I3tQ6RENGQNfQKarvMbYNwQ4+8bShoHdH3y6fM7pAzNeCW9GYNqUabweJSiJ9vL4M6lYHTiJBrjDUD3HsB+3O/HwrUvwX15HeGRJyLQ3lVhWQJF2p5O72WSXCGgRo66v+YZR+fOPVU0VBkg98UzJ6ehbfit6BqR4eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mHNcph/b; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NhQly5pUD9z2ZNtxmGvlsYtPa1j9pbPh+PBlNLvLdG0HciBHEAW6pG9FrFUfl5cm1BxNwmogTTJnweKpWMAzK9/BYIcM7lmK4OLqsxYRCqovLOC8G4W6M2T/Za4yp0s5IU57Yj7UjY1Q+vZ/u/zvCmyShyiOI1Fr2dpRXyBzbHyf+M+pLD+XvLISe4HLC58XuQ2DkrMOTDZfe3JPPURUAtfNnoWnPaEj7ocATJlmI0oQgqn1ym0Vgq4yhj0IsoCq7RORm5ApM6ru0oYbtYK+r5ugkq7xQGtFykA4PDhRd2rRBXD5pXSbu2een47VBjdG5eLEAQiiXuXAcrMWyBn0Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z65c0Vz2P9z1NTB6EjmVY35eCMfciNmWpZQJfrpwBcQ=;
 b=fMMc5Tpw6NpHTU8tPii9MJAmAEk7Orz2fM1DgJqiWKvfXZjZAwODzzrL2W3+sI4IgnmSTbg3TM+7z0mCeHucJJow9NcM21hkHoni9tQmjUNh3HjgQ/eTzwmS/KtjPMGXa+S/rS1hkC+eIWsORPkViKgrJWR5q2VghQkgmHOgB5BMxkBAiJnJtSKPg80D0EvsdpzcE3e+QGJSI7ZW7eKqWuw43lLQXOW392yw3sdpIEHeAb60xW9uez3hxHUGyxJWZy79DFIYiHxEXfrRcBrxntKjrMgtszwRlKFMZOj8+SXx2Tdup1UNQzdsg7ggt3IOw7me1CyLRagpEQ+9w4UcOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z65c0Vz2P9z1NTB6EjmVY35eCMfciNmWpZQJfrpwBcQ=;
 b=mHNcph/bLIwsx/dfrXet7nTpxVpdWadMOZicgf23mEHEOa5yoJO4TyvtTGzX+/2lZpG68f5/DbEcOPVLwUbJz83yjTiOF478mEarfb6rz6RPM7MbsSL0D1j8x6Xm0+NsFCC4NQy1G/asQM1Cbi2Cb7YPcBw1xg4lN6hkbVC3m4A=
Received: from SJ0PR13CA0196.namprd13.prod.outlook.com (2603:10b6:a03:2c3::21)
 by BY5PR12MB4258.namprd12.prod.outlook.com (2603:10b6:a03:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:39:40 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::e7) by SJ0PR13CA0196.outlook.office365.com
 (2603:10b6:a03:2c3::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.10 via Frontend Transport; Fri,
 5 Sep 2025 21:39:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:40 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:37 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:35 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <babu.moger@amd.com>, <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: [PATCH v18 29/33] fs/resctrl: Introduce the interface to modify assignments in a group
Date: Fri, 5 Sep 2025 16:34:28 -0500
Message-ID: <b894ad853e6757d40da1469bf9fca4c64684df65.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|BY5PR12MB4258:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c774e4d-e6b4-4d29-0b2f-08ddecc4b801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1h3OVlrNitUWEhGbWp2eisrMG03YjM4VEVldnZTLzRlRkw3OXRPWDVuc05q?=
 =?utf-8?B?YmwwaEZlUW9UL3pvbTJLNDdXeUQzUFBBK2FIbnpwelI3UHV0WnlUdWJPQ1Za?=
 =?utf-8?B?SjU5bU1wOE1WRzRwNVBZTWRTaVRQUXZ6U1J4MWUxYU9GbEJ5b3RTK3B0M1Bj?=
 =?utf-8?B?bDBITHZVTkJTeXFRRksvNzBRblBGVmp6MzhsaEt6VThVSmUxRkNpTEd6eHRL?=
 =?utf-8?B?R0QrUnNLWmpMbFJmWnRUMy9MS0dLQkRZM0x6Tjg2VGRUWTFySGkrQTlKLy8z?=
 =?utf-8?B?VUlXSDRrWEtRa0NnZmU2a0ZQditleXVpbENXWnVqRUZTcnQvUUQwU1hoZi90?=
 =?utf-8?B?TTlMd25zUDRjQS9HRkNzR1FXSGJ3bVp5SFBEYzI3WEVwNk9vRGdhTEhkd1Ur?=
 =?utf-8?B?aUswM1hpZ0hyeU93UjFZcTgvZ28zaUZ5MG5MU0xKVUZZaFhiK2ZUa2lpUklF?=
 =?utf-8?B?eTZoTEM4M21Oa2EvTU5wWi95Y05kNlRFblFObVhrRGdjZjc3QTJJQ0haOHE1?=
 =?utf-8?B?K2pMakR5UVRMK3FoTXRYZ3R3NDJDWVNNSjdxVysxYU55SCsxemttM1Y1ZE14?=
 =?utf-8?B?R1g5VW9QNUcyZEZmbFEySE1aVEhIOHE3Tk4wbkpKN0k2alU1WkFCSGhBMTJ5?=
 =?utf-8?B?d3dmdmo5VjZUMzBkR29aUzdsQUNQZWRmNDBUcmJVT092VDRCMjM3MFA4RWJB?=
 =?utf-8?B?V3gxdFVjc3RxckVhbXZWSjQ0dTlmenlqa05henhlR2s5MkJwTjBsR0FKTXFH?=
 =?utf-8?B?WnZxTGtnY2puSVQ2YzJxUUpkUlplTzRtQUNkR3NlSG1BMWs3enJuamMzdTk4?=
 =?utf-8?B?RnV6SmwreGdPZElPdjF4aVhwM1AwcnVSQVVOd21OZTBpSnp6bDV5SEo3N1Y3?=
 =?utf-8?B?bXBQQ05pR2RvaTlSTnFXeTdNR2dsMCtnZmx4MTJScDVVb21tUXRBQVdSRGRQ?=
 =?utf-8?B?OFJtQTlsZ1dmeFA1T2tpNmUwQnNYaENlOUZhYStEbEJtVUd3cVR0Y3N2NFVV?=
 =?utf-8?B?QlVKcGlNZG9udlRxQnRSSUxBakZPaWd1cEpQaE03SCtxS2JObHI2dk5rNzFs?=
 =?utf-8?B?SHR3MWlXWitMbVNreXBrdHRmZW5mWndqamkrdkZvdWdFSndGRjBSRkpnNVZO?=
 =?utf-8?B?WTdLMFNtOHMyUSt1RVhGMXc0TzdlRUl4TVlqQlVINllsc280MGl2cFFSVG9U?=
 =?utf-8?B?ZmxUUnhlYzJMeGpHWkgyYldOM3ZJVXY4TUM3MVhXVFBGUlllSVF4SURNejRa?=
 =?utf-8?B?bjMwaWRRSnU3U3k3Q080dmh1d3l0dUk4QU4zZjB3RHB3V0FJWE5PUzk5WG9L?=
 =?utf-8?B?TURzbEN3eXBWWkZiNHBQcXlEYzBTekJ6OGR0SFo2QjlmYTZUTDAvNms2NjVt?=
 =?utf-8?B?dnh0L0xrL2ZreHBlWHdTTjFYeVk4MGZhcHhIL010TVRoOWNCazUxaTJncjBk?=
 =?utf-8?B?NlhCRkdPb0ZTeTRlV3JuRS9ENW1PT1czMS9aZ2NiWEdoUklrbVVwMnh4d0lM?=
 =?utf-8?B?YzU3VGFYZlpvTHZTakVZM1pDQ3k5N1ZjQmVmMUk2cHNKYVF2V2RrbTY5Nkox?=
 =?utf-8?B?cmxyRWNaa0NFL3pCQXQzb0dOL1kyVlMyNDJwZmxSUGY5ckVRL21pdllweUpY?=
 =?utf-8?B?NFp3NWpJcWJ2aEZwdWw3VHJZNUp0b0pwcTJEODJWWjZMYlUvRXhGbE1XdHNa?=
 =?utf-8?B?TmRNYk1xV2g2SllOVCs3eFp4SFhnTTFIdnc0MFd3VmxObTE1RHBYanBtQS90?=
 =?utf-8?B?S1lldTNlVjhkLzNjVE0vWFYxSTl0Y1lPeTJjYkRXYjFGbm53SDlIZTJWYisw?=
 =?utf-8?B?ZGxsd3AwQVB3ak1QeDR1YnZGRytwYVErcjUyMEpqRGQybkxoQlE5b3BUc3VO?=
 =?utf-8?B?eWpMQVNPRW82RGdhUHhnTXVBZ0prNUI3S1FoYk5TQW9YZCtMeFBVSHlTdlJy?=
 =?utf-8?B?U3FlKzVPeVhZVnFnMEwrNGR6Z0k4YzZUNG5qd1J6YldKaHFFVW55SUpqeEdG?=
 =?utf-8?B?TTBxd2NwVmxBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:40.0419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c774e4d-e6b4-4d29-0b2f-08ddecc4b801
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4258

Enable the mbm_l3_assignments resctrl file to be used to modify counter
assignments of CTRL_MON and MON groups when the "mbm_event" counter
assignment mode is enabled.

Process the assignment modifications in the following format:
<Event>:<Domain id>=<Assignment state>;<Domain id>=<Assignment state>

Event: A valid MBM event in the
       /sys/fs/resctrl/info/L3_MON/event_configs directory.

Domain ID: A valid domain ID. When writing, '*' applies the changes
	   to all domains.

Assignment states:

    _ : Unassign a counter.

    e : Assign a counter exclusively.

Examples:

$ cd /sys/fs/resctrl
$ cat /sys/fs/resctrl/mbm_L3_assignments
  mbm_total_bytes:0=e;1=e
  mbm_local_bytes:0=e;1=e

To unassign the counter associated with the mbm_total_bytes event on
domain 0:

$ echo "mbm_total_bytes:0=_" > mbm_L3_assignments
$ cat /sys/fs/resctrl/mbm_L3_assignments
  mbm_total_bytes:0=_;1=e
  mbm_local_bytes:0=e;1=e

To unassign the counter associated with the mbm_total_bytes event on
all the domains:

$ echo "mbm_total_bytes:*=_" > mbm_L3_assignments
$ cat /sys/fs/resctrl/mbm_L3_assignments
  mbm_total_bytes:0=_;1=_
  mbm_local_bytes:0=e;1=e

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Moved mbm_L3_assignments_write() and all dependencies to fs/resctrl/monitor.c.
     Fixed extra space.
     Re-organized the user doc.

v16: Updated the changelog for minor corrections.
     Updated resctrl.rst few corrections and consistancy.
     Fixed few references of counter_configs to > event_configs.
     Renamed resctrl_process_assign() to resctrl_parse_mbm_assignment().
     Moved resctrl_parse_mbm_assignment() and rdtgroup_modify_assign_state() to monitor.c.

v15: Updated the changelog little bit.
     Fixed the spacing in event_filter display.
     Removed the enum ASSIGN_NONE etc. Not required anymore.
     Moved mbm_get_mon_event_by_name() to fs/resctrl/monitor.c
     Used the new macro for_each_mon_event().
     Renamed resctrl_get_assign_state() -> rdtgroup_modify_assign_state().
     Quite a few changes in resctrl_process_assign().
     Removed the found and domain variables.
     Called rdtgroup_modify_assign_state() directly where applicable.
     Removed couple of goto statements.

v14: Fixed the problem reported by Peter.
     Updated the changelog.
     Updated the user doc resctrl.rst.
     Added example section on how to use resctrl with mbm_assign_mode.

v13: Few changes in mbm_L3_assignments_write() after moving the event config to evt_list.
     Resolved conflicts caused by the recent FS/ARCH code restructure.

v12: New patch:
     Assignment interface moved inside the group based the discussion
     https://lore.kernel.org/lkml/CALPaoCiii0vXOF06mfV=kVLBzhfNo0SFqt4kQGwGSGVUqvr2Dg@mail.gmail.com/#t
---
 Documentation/filesystems/resctrl.rst | 151 +++++++++++++++++++++++++-
 fs/resctrl/internal.h                 |   3 +
 fs/resctrl/monitor.c                  | 139 ++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |   3 +-
 4 files changed, 294 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index a2b7240b0818..f60f6a96cb6b 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -522,7 +522,8 @@ When monitoring is enabled all MON groups may also contain:
 	Event: A valid MBM event in the
 	       /sys/fs/resctrl/info/L3_MON/event_configs directory.
 
-	Domain ID: A valid domain ID.
+	Domain ID: A valid domain ID. When writing, '*' applies the changes
+		   to all the domains.
 
 	Assignment states:
 
@@ -540,6 +541,35 @@ When monitoring is enabled all MON groups may also contain:
 	   mbm_total_bytes:0=e;1=e
 	   mbm_local_bytes:0=e;1=e
 
+	Assignments can be modified by writing to the interface.
+
+	Examples:
+
+	To unassign the counter associated with the mbm_total_bytes event on domain 0:
+	::
+
+	 # echo "mbm_total_bytes:0=_" > /sys/fs/resctrl/mbm_L3_assignments
+	 # cat /sys/fs/resctrl/mbm_L3_assignments
+	   mbm_total_bytes:0=_;1=e
+	   mbm_local_bytes:0=e;1=e
+
+	To unassign the counter associated with the mbm_total_bytes event on all the domains:
+	::
+
+	 # echo "mbm_total_bytes:*=_" > /sys/fs/resctrl/mbm_L3_assignments
+	 # cat /sys/fs/resctrl/mbm_L3_assignments
+	   mbm_total_bytes:0=_;1=_
+	   mbm_local_bytes:0=e;1=e
+
+	To assign a counter associated with the mbm_total_bytes event on all domains in
+	exclusive mode:
+	::
+
+	 # echo "mbm_total_bytes:*=e" > /sys/fs/resctrl/mbm_L3_assignments
+	 # cat /sys/fs/resctrl/mbm_L3_assignments
+	   mbm_total_bytes:0=e;1=e
+	   mbm_local_bytes:0=e;1=e
+
 When the "mba_MBps" mount option is used all CTRL_MON groups will also contain:
 
 "mba_MBps_event":
@@ -1585,6 +1615,125 @@ View the llc occupancy snapshot::
   # cat /sys/fs/resctrl/p1/mon_data/mon_L3_00/llc_occupancy
   11234000
 
+
+Examples on working with mbm_assign_mode
+========================================
+
+a. Check if MBM counter assignment mode is supported.
+::
+
+  # mount -t resctrl resctrl /sys/fs/resctrl/
+
+  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+  [mbm_event]
+  default
+
+The "mbm_event" mode is detected and enabled.
+
+b. Check how many assignable counters are supported.
+::
+
+  # cat /sys/fs/resctrl/info/L3_MON/num_mbm_cntrs
+  0=32;1=32
+
+c. Check how many assignable counters are available for assignment in each domain.
+::
+
+  # cat /sys/fs/resctrl/info/L3_MON/available_mbm_cntrs
+  0=30;1=30
+
+d. To list the default group's assign states.
+::
+
+  # cat /sys/fs/resctrl/mbm_L3_assignments
+  mbm_total_bytes:0=e;1=e
+  mbm_local_bytes:0=e;1=e
+
+e.  To unassign the counter associated with the mbm_total_bytes event on domain 0.
+::
+
+  # echo "mbm_total_bytes:0=_" > /sys/fs/resctrl/mbm_L3_assignments
+  # cat /sys/fs/resctrl/mbm_L3_assignments
+  mbm_total_bytes:0=_;1=e
+  mbm_local_bytes:0=e;1=e
+
+f. To unassign the counter associated with the mbm_total_bytes event on all domains.
+::
+
+  # echo "mbm_total_bytes:*=_" > /sys/fs/resctrl/mbm_L3_assignments
+  # cat /sys/fs/resctrl/mbm_L3_assignment
+  mbm_total_bytes:0=_;1=_
+  mbm_local_bytes:0=e;1=e
+
+g. To assign a counter associated with the mbm_total_bytes event on all domains in
+exclusive mode.
+::
+
+  # echo "mbm_total_bytes:*=e" > /sys/fs/resctrl/mbm_L3_assignments
+  # cat /sys/fs/resctrl/mbm_L3_assignments
+  mbm_total_bytes:0=e;1=e
+  mbm_local_bytes:0=e;1=e
+
+h. Read the events mbm_total_bytes and mbm_local_bytes of the default group. There is
+no change in reading the events with the assignment.
+::
+
+  # cat /sys/fs/resctrl/mon_data/mon_L3_00/mbm_total_bytes
+  779247936
+  # cat /sys/fs/resctrl/mon_data/mon_L3_01/mbm_total_bytes
+  562324232
+  # cat /sys/fs/resctrl/mon_data/mon_L3_00/mbm_local_bytes
+  212122123
+  # cat /sys/fs/resctrl/mon_data/mon_L3_01/mbm_local_bytes
+  121212144
+
+i. Check the event configurations.
+::
+
+  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_total_bytes/event_filter
+  local_reads,remote_reads,local_non_temporal_writes,remote_non_temporal_writes,
+  local_reads_slow_memory,remote_reads_slow_memory,dirty_victim_writes_all
+
+  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_local_bytes/event_filter
+  local_reads,local_non_temporal_writes,local_reads_slow_memory
+
+j. Change the event configuration for mbm_local_bytes.
+::
+
+  # echo "local_reads, local_non_temporal_writes, local_reads_slow_memory, remote_reads" >
+  /sys/fs/resctrl/info/L3_MON/event_configs/mbm_local_bytes/event_filter
+
+  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_local_bytes/event_filter
+  local_reads,local_non_temporal_writes,local_reads_slow_memory,remote_reads
+
+k. Now read the local events again. The first read may come back with "Unavailable"
+status. The subsequent read of mbm_local_bytes will display the current value.
+::
+
+  # cat /sys/fs/resctrl/mon_data/mon_L3_00/mbm_local_bytes
+  Unavailable
+  # cat /sys/fs/resctrl/mon_data/mon_L3_00/mbm_local_bytes
+  2252323
+  # cat /sys/fs/resctrl/mon_data/mon_L3_01/mbm_local_bytes
+  Unavailable
+  # cat /sys/fs/resctrl/mon_data/mon_L3_01/mbm_local_bytes
+  1566565
+
+l. Users have the option to go back to 'default' mbm_assign_mode if required. This can be
+done using the following command. Note that switching the mbm_assign_mode may reset all
+the MBM counters (and thus all MBM events) of all the resctrl groups.
+::
+
+  # echo "default" > /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+  mbm_event
+  [default]
+
+m. Unmount the resctrl filesystem.
+::
+
+  # umount /sys/fs/resctrl/
+
 Intel RDT Errata
 ================
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 88079ca0d57a..264f04c7dfba 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -418,6 +418,9 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 
 int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
 
+ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
+				 loff_t off);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index e8c3b3a7987b..d49170247b75 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1504,6 +1504,145 @@ int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, voi
 	return ret;
 }
 
+/*
+ * mbm_get_mon_event_by_name() - Return the mon_evt entry for the matching
+ * event name.
+ */
+static struct mon_evt *mbm_get_mon_event_by_name(struct rdt_resource *r, char *name)
+{
+	struct mon_evt *mevt;
+
+	for_each_mon_event(mevt) {
+		if (mevt->rid == r->rid && mevt->enabled &&
+		    resctrl_is_mbm_event(mevt->evtid) &&
+		    !strcmp(mevt->name, name))
+			return mevt;
+	}
+
+	return NULL;
+}
+
+static int rdtgroup_modify_assign_state(char *assign, struct rdt_mon_domain *d,
+					struct rdtgroup *rdtgrp, struct mon_evt *mevt)
+{
+	int ret = 0;
+
+	if (!assign || strlen(assign) != 1)
+		return -EINVAL;
+
+	switch (*assign) {
+	case 'e':
+		ret = rdtgroup_assign_cntr_event(d, rdtgrp, mevt);
+		break;
+	case '_':
+		rdtgroup_unassign_cntr_event(d, rdtgrp, mevt);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int resctrl_parse_mbm_assignment(struct rdt_resource *r, struct rdtgroup *rdtgrp,
+					char *event, char *tok)
+{
+	struct rdt_mon_domain *d;
+	unsigned long dom_id = 0;
+	char *dom_str, *id_str;
+	struct mon_evt *mevt;
+	int ret;
+
+	mevt = mbm_get_mon_event_by_name(r, event);
+	if (!mevt) {
+		rdt_last_cmd_printf("Invalid event %s\n", event);
+		return -ENOENT;
+	}
+
+next:
+	if (!tok || tok[0] == '\0')
+		return 0;
+
+	/* Start processing the strings for each domain */
+	dom_str = strim(strsep(&tok, ";"));
+
+	id_str = strsep(&dom_str, "=");
+
+	/* Check for domain id '*' which means all domains */
+	if (id_str && *id_str == '*') {
+		ret = rdtgroup_modify_assign_state(dom_str, NULL, rdtgrp, mevt);
+		if (ret)
+			rdt_last_cmd_printf("Assign operation '%s:*=%s' failed\n",
+					    event, dom_str);
+		return ret;
+	} else if (!id_str || kstrtoul(id_str, 10, &dom_id)) {
+		rdt_last_cmd_puts("Missing domain id\n");
+		return -EINVAL;
+	}
+
+	/* Verify if the dom_id is valid */
+	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		if (d->hdr.id == dom_id) {
+			ret = rdtgroup_modify_assign_state(dom_str, d, rdtgrp, mevt);
+			if (ret) {
+				rdt_last_cmd_printf("Assign operation '%s:%ld=%s' failed\n",
+						    event, dom_id, dom_str);
+				return ret;
+			}
+			goto next;
+		}
+	}
+
+	rdt_last_cmd_printf("Invalid domain id %ld\n", dom_id);
+	return -EINVAL;
+}
+
+ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
+				 size_t nbytes, loff_t off)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	struct rdtgroup *rdtgrp;
+	char *token, *event;
+	int ret = 0;
+
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n')
+		return -EINVAL;
+
+	buf[nbytes - 1] = '\0';
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		rdtgroup_kn_unlock(of->kn);
+		return -ENOENT;
+	}
+	rdt_last_cmd_clear();
+
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event mode is not enabled\n");
+		rdtgroup_kn_unlock(of->kn);
+		return -EINVAL;
+	}
+
+	while ((token = strsep(&buf, "\n")) != NULL) {
+		/*
+		 * The write command follows the following format:
+		 * “<Event>:<Domain ID>=<Assignment state>”
+		 * Extract the event name first.
+		 */
+		event = strsep(&token, ":");
+
+		ret = resctrl_parse_mbm_assignment(r, rdtgrp, event, token);
+		if (ret)
+			break;
+	}
+
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 519aa6acef5b..bd4a115ffea1 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1939,9 +1939,10 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "mbm_L3_assignments",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= mbm_L3_assignments_show,
+		.write		= mbm_L3_assignments_write,
 	},
 	{
 		.name		= "mbm_assign_mode",
-- 
2.34.1


