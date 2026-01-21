Return-Path: <kvm+bounces-68781-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBD0AIJJcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68781-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:47:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB345E414
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D91BF846C35
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B5942882C;
	Wed, 21 Jan 2026 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JTeQsbey"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085174219FD;
	Wed, 21 Jan 2026 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030002; cv=fail; b=RcnPgYTKxWNwl1I9m2KzKqepJLQvlLFP9mnUbltxXy8lB7IwFFZUJo5n1RDQZozjBAu9p3LJQresVd+4vl7bNuAeMqzKwlgpcV3nZnddYJQdaua1Cha4YOblMRsYFzHllePcldVFoGczHHKz0wUNVbiGHtaxx4JysKQPsfPAULg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030002; c=relaxed/simple;
	bh=bhJ8lulNnU2xjOjZtpPjxEyuGXmJTYYUx/AYQokVLl4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m98qrovw3Jqpvi75tJ1raY4rxYHh5Jr8OgwRN3EJU1rFW6OIKyG5rdddytXhTxtnWiBERGXlIdNETezsLDmI4fN0BDyEcovHwFOoD4jsfraFA7tgqVa/ogb0YhMhe3NmrvznH1d0YgyBiD08AdCUdKB1RpuDKYy6w4ZKHjc7lTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JTeQsbey; arc=fail smtp.client-ip=40.93.194.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMUgT/j1puYm0/ZTtM39V5VA18pbxlVL/ZcIfFLcu7OAngA6g23P69oZOZgaTm2o4x42ofMPM/qTTA9FrfI5NfbXw1friXom1eKeKcNatXixk7ng0jE7UaE5ANh4PgwP7RKOVmuhuPw8SCdFLa2fzerX6DrvfV0Yj6fCTvfDV2WVr9qzNTu2id/b9FsO+N7Ezjmwj/xlRBj+o46M987K3AagUFD61H6Q9V4IDAYs/4j2skEd3iIoLNRFslFNDzhKVoWsR2LyA6O2BBe23Vcybu7NeSeBzBP772ZVABTGJQweEaX43XO8XbztmAxrbkbD9vaCne/YIac2aSpauWqj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3G9dhIE2/BkTDNBr7RdKVkIKnBaaYIND2iNFpH+9rk=;
 b=llAUERbERR4c/ovrjsLMqtTLcJG3G4ZodbNXMHewWYRSna+1qlLUyCyYcuE4BpV3JfSUKF/yGh45AXu1J9QkRolcnVM7+ZJ/klbG5XyMTY2yRAWoSb16uyYU1/RvA1Jsv18BOfiHDKZoEIpkcQmphV6e49jLac0+8GLcsFPH2e8xEBEJX/gJHuWWlK/XFLHED1hp+HL07+o7vqZY8F+hLvP7qwT8d0XMiJrjkcoSAWR6vFyyJx+Jnc0PfTH3rUTBUFvMkAz2hdVSKTgqvO9VQcY0UaCm6EwDh8Qb/eCxYBJkpcNypanTDKs0TBZYEkwN22L0jtCDWiIUpcXmVJvxAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3G9dhIE2/BkTDNBr7RdKVkIKnBaaYIND2iNFpH+9rk=;
 b=JTeQsbeyb7815OxtbqLT3wiQyXmrX+vqYX4zbXoIksTCBaZ2T2TfVkWCIk9f0hLRhh0/7QdGnsWI6HS36groghx9+vQv4AF02VrQdXQYcIJFO7jOhuMXVbw9lcXnlUk/bB/2sFGE0J6H30uhTldw7M3C3mSMtzHlOS+m9oapEWA=
Received: from SJ0PR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:33f::12)
 by SA3PR12MB8045.namprd12.prod.outlook.com (2603:10b6:806:31d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Wed, 21 Jan
 2026 21:13:10 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::4f) by SJ0PR05CA0037.outlook.office365.com
 (2603:10b6:a03:33f::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.2 via Frontend Transport; Wed,
 21 Jan 2026 21:13:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:10 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:03 -0600
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: [RFC PATCH 00/19] x86,fs/resctrl: Support for Global Bandwidth Enforcement and Priviledge Level Zero Association
Date: Wed, 21 Jan 2026 15:12:38 -0600
Message-ID: <cover.1769029977.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|SA3PR12MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: f081af62-67e3-4f19-c097-08de5931e16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BbKtCkrv27TdnZBXwLw0y7FzrrErlQ6y7vnmMHlgg7SF/W1HZfY9FCwNtnVk?=
 =?us-ascii?Q?sGf4ye5bdV/NcAnmg5DcwowrrSxaoYnHVpBmdYsYytFK5fgf0LxsTMvFk7Cf?=
 =?us-ascii?Q?gidj6/iiYEFakXXblrX/GORU7qmbLjk/27B9j31J68OYi0kmbdMWDHxhdF8M?=
 =?us-ascii?Q?0SvzNBjcv0dRtkwLxejX5x9URGxoXtimTKvFk/v+RMGAnpgUNnLk0JAW5hst?=
 =?us-ascii?Q?B+y2slqRtSRnCTmkrXs26odD1zIIoJb0xFO5dI4X31FKxRws5UpLy2uZ14IJ?=
 =?us-ascii?Q?gcRNoUffx1IrY39dfNd4X9hZOLgS13Hbnv/DH7lM1Q3/w+a/SW3N1GSKOBFp?=
 =?us-ascii?Q?+hgn72xqd9O5u1uIYSmSURw7QiEC8m3LY6MOFvOxjdMMoIfvXlRA10gvtK67?=
 =?us-ascii?Q?bHvMAwtwKywGQEGxakOetnaz/9ovvkHojwozovT0FEeOzuV8GbkGzgWBYAZj?=
 =?us-ascii?Q?HTUj3ZcdkNMGUO8mosKM9NepxqgJGI274OjJ7g371DBHIEMx/zF+GSU63wC3?=
 =?us-ascii?Q?gJDI9mD+mKVAv88AI+YMarSMaqbn7YgEqKc0IR+XJm4bIZQcX+aIXY8dOPQJ?=
 =?us-ascii?Q?u/4NsmGnYPuHsE87AKLYCiJdYbEpGJ9I05/BA1kEaJNQfuDMyWajcyRQpHdq?=
 =?us-ascii?Q?VznNPugNKiwDOAih0QUptKH5VXCfp4OhuphvYdGujEz6X2NGCXxonrDtDBwV?=
 =?us-ascii?Q?ouI4FkJObFAXdf8yh7QTqAPQ5H+3nLPJfGPqHX79omVV350VBUtIFQOLVX/a?=
 =?us-ascii?Q?M+HQm1mmKKV5RzbKtx++loEel/qIL5li6ypN9Scz6fEEUphSSoKSzL5zJ7u9?=
 =?us-ascii?Q?Sxhbjree3y1kS9/PWum+WYyd9TwhgJtK4LhFBUh5qCN6GECgsaqjWb5apPoC?=
 =?us-ascii?Q?9n/gEz0QkqOHmMqjelP4ltfB3KdyuUKmTwuR7YZ0I37gCt7MEbmmxBKHV2NW?=
 =?us-ascii?Q?c+mnkk3ULVv4jQYYfMPq5+L1oMzNwzqs1geYobZ3wLklMjGA8khprfZZeTub?=
 =?us-ascii?Q?rH4WHiI5qLfz4hG1nzrLGdaF+TfvkDmlxCSRTDJ5zHIBm2LyUWxl1ZOBGLbr?=
 =?us-ascii?Q?w9noF6jUR2bhXY4DJHXXQBhgrn/QjYXD3KQsM6q3ez/Mfa9N6Ry/3t6m/VV+?=
 =?us-ascii?Q?n9XwlUY0HXI++uJ/IStwZ2IWl9kMnLURu+H9Lxd7C2FPN9+yN4b9vQ7PrZL6?=
 =?us-ascii?Q?ELn2BfXyRAvUdvh61J9FS57+OgY+FFLqIzHs0+IDYwbRC3IZ+SGpxQ2FkahN?=
 =?us-ascii?Q?uOA1nMIvI+VLzO874EMWXqfusqeNr9Bmj37tLjhKOaDrIgZd3zl98FszUwt9?=
 =?us-ascii?Q?KXWNEDqbm0lHXOJXFjtnm4lcZBUo+4YptX1piUIx61ehbXRWQKgsA3pUFjDw?=
 =?us-ascii?Q?RzKiURq+6IloAICxyy30Vzk/PJNRQThPv5j+hB2RCeYCSNIB3HGx4I8pcbS5?=
 =?us-ascii?Q?PkDVeDeeZStB8FPv5JKMtQ7bMHOVCkAtFwfwFDBQzYvXgYAItdnGZiPxemmc?=
 =?us-ascii?Q?OLujyG4+0OUzr4pSQeD2NI4ac4jomXLHvA7DDcTSt4dNc96eoGcrM8/ltxjo?=
 =?us-ascii?Q?XnixEjYz0kw9xgNeeZIcbckzoTWDAccH03PSgloN5eHh8xW/4B+A5iHojUf3?=
 =?us-ascii?Q?01WG6Z1OQbauvZAi6Umcn5KR+6EZWAgJ0WOkvJwXyYsEJ9o4rAh0iHLVlfE2?=
 =?us-ascii?Q?iUFTjxGsUcQnYCCXb1ix04WKrIA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:10.1990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f081af62-67e3-4f19-c097-08de5931e16a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8045
X-Spamd-Result: default: False [1.54 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68781-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9DB345E414
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


This patch series adds support for Global Bandwidth Enforcement (GLBE),
Global Slow Bandwidth Enforcement (GLSBE) and Priviledge Level Zero
Association (PLZA) in the x86 architecture's fs/resctrl subsystem. The
changes include modifications to the resctrl filesystem to allow users to
configure GLBE settings and associate CPUs and tasks with a separate CLOS
when executiing in CPL0.

The feature documentation is not yet publicly available, but it is expected
to be released in the next few weeks. In the meantime, a brief description
of the features is provided below. Sharing this series as an RFC to gather
initial feedback. Comments are welcome.

Global Bandwidth Enforcement (GLBE) 

AMD Global Bandwidth Enforcement (GLBE) provides a mechanism for software
to specify bandwidth limits for groups of threads that span multiple QOoS
Domains. This collection of QOS Domains is referred to as the GLBE Control
Domain.  The GLBE ceiling is a bandwidth ceiling for L3 External Bandwidth
competitively shared between all threads in a COS (Class of Service) across
all QOS Domains within the GLBE Control Domain.  This complements L3BE L3
External Bandwidth Enforcement (L3BE) which provides L3 eExternal Bandwidth
control on a per QOS Domain granularity.  

Global Slow Bandwidth Enforcement (GLSBE) 

AMD PQoS Global Slow Bandwidth Enforcement (GLSBE) provides a mechanism for
software to specify bandwidth limits for groups of threads that span
multiple QOS Domains. GLSBE operates within the same GLBE Control Domains
defined by GLBE.  The GLSBE ceiling is a bandwidth ceiling for L3 External
Bandwidth to Slow Memory competitively shared between all threads in a COS
in all QOS Domains within the GLBE Control Domain.  This complements L3SMBE
which provides Slow Memory bandwidth control on a per QOS Domain
granularity.  
 
Privilege Level Zero Association (PLZA) 

Privilege Level Zero Association (PLZA) allows the hardware to
automatically associate execution in Privilege Level Zero (CPL=0) with a
specific COS (Class of Service) and/or RMID (Resource Monitoring
Identifier). The QoS feature set already has a mechanism to associate
execution on each logical processor with an RMID or COS. PLZA allows the
system to override this per-thread association for a thread that is
executing with CPL=0. 

The patches are based on top of commit (v6.19-rc5)
Commit 0f61b1860cc3 (tag: v6.19-rc5, tip/tip/urgent) Linux 6.19-rc5
 
Changes include:        
 - Introduction of a new max_bandwidth file for each resctrl resource to
   expose the maximum supported bandwidth.
 - Addition of new schemata GMB and GSMBA interfaces for configuring GLBE
   and GSLBE parameters.
 - Modifications to associate resctrl groups with PLZA.
 - Documentation updates to describe the new functionality.

Interface Changes:
1. A new max_bandwidth file has been added under each resource type
   directory (for example, /sys/fs/resctrl/info/GMB/max_bandwidth) to
   report the maximum bandwidth supported by the resource.

2. New resource types, GMB and GSMBA, have been introduced and are exposed
   through the schemata interface:
   # cat /sys/fs/resctrl/schemata
     GSMBA:0=4096;1=4096
      SMBA:0=8192;1=8192
       GMB:0=4096;1=4096
        MB:0=8192;1=8192
        L3:0=ffff;1=ffff

3. A new plza_capable file has been added under each resource type directory
  (for example, /sys/fs/resctrl/info/GMB/plza_capable) to indicate whether
   the resource supports the PLZA feature.

4. A new plza control file has been added to each resctrl group (for example,
  /sys/fs/resctrl/plza) to enable or disable PLZA association for the group.
  Writing 1 enables PLZA for the group, while writing 0 disables it.


Babu Moger (19):
  x86,fs/resctrl: Add support for Global Bandwidth Enforcement (GLBE)
  x86,fs/resctrl: Add the resource for Global Memory Bandwidth
    Allocation
  fs/resctrl: Add new interface max_bandwidth
  fs/resctrl: Add the documentation for Global Memory Bandwidth
    Allocation
  x86,fs/resctrl: Add support for Global Slow Memory Bandwidth
    Allocation (GSMBA)
  x86,fs/resctrl: Add the resource for Global Slow Memory Bandwidth
    Enforcement(GLSBE)
  fs/resctrl: Add the documentation for Global Slow Memory Bandwidth
    Allocation
  x86/resctrl: Support Privilege-Level Zero Association (PLZA)
  x86/resctrl: Add plza_capable in rdt_resource data structure
  fs/resctrl: Expose plza_capable via control info file
  resctrl: Introduce PLZA static key enable/disable helpers
  x86/resctrl: Add data structures and definitions for PLZA
    configuration
  x86/resctrl: Add PLZA state tracking and context switch handling
  x86,fs/resctrl: Add the functionality to configure PLZA
  fs/resctrl: Introduce PLZA attribute in rdtgroup interface
  fs/resctrl: Implement rdtgroup_plza_write() to configure PLZA in a
    group
  fs/resctrl: Update PLZA configuration when cpu_mask changes
  x86/resctrl: Refactor show_rdt_tasks() to support PLZA task matching
  fs/resctrl: Add per-task PLZA enable support via rdtgroup

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 110 ++++++-
 arch/x86/include/asm/cpufeatures.h            |   4 +-
 arch/x86/include/asm/msr-index.h              |   9 +
 arch/x86/include/asm/resctrl.h                |  44 +++
 arch/x86/kernel/cpu/resctrl/core.c            |  89 +++++-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c     |  25 ++
 arch/x86/kernel/cpu/resctrl/internal.h        |  26 ++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   7 +
 arch/x86/kernel/cpu/scattered.c               |   3 +
 fs/resctrl/ctrlmondata.c                      |   5 +-
 fs/resctrl/internal.h                         |   2 +
 fs/resctrl/rdtgroup.c                         | 301 +++++++++++++++++-
 include/linux/resctrl.h                       |  16 +
 include/linux/sched.h                         |   1 +
 15 files changed, 623 insertions(+), 21 deletions(-)

-- 
2.34.1


