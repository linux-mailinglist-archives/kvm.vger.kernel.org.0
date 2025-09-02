Return-Path: <kvm+bounces-56639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6008FB41024
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 081E47AF60F
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D84279DAD;
	Tue,  2 Sep 2025 22:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CEJym8Nt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F5F2797AE;
	Tue,  2 Sep 2025 22:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852922; cv=fail; b=D2MQacsVppZz2ZGO73O/1I/85o5cQBFZ779rQnkih9WXs899o8XJiDODVJgn5WLYBNS6oCdkmW+TAD9984UybPvc3VgYlOATOPhbm55BEM1JOmZQlWTPlf2UIdyh039BaEb5fRWZ6fbhRHDZ1YLnRyJQ9JVELETsXYna7EIqVvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852922; c=relaxed/simple;
	bh=5qyudYZ8ZbP5XOJM4+sxN2BYp328Xsic1kLsQWhcJEM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pA25IPUqmO5q7+9HVV41bcn45N2Ni7KEkmOXFA4VkPGrBvXiGEz96YdqymiMUF6kG2sK8FNiQjbVzLhxDsF5u5glGv9dInWJTOURmaSIGTbkooT4POl/JTHNU/WXSbnl3IXtt3YjoNhQZChShrWCI0e6ua3tPYFFjxL/eb1GayY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CEJym8Nt; arc=fail smtp.client-ip=40.107.95.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opCsnKgh31gQFgFop4oydlZ02e4wKoSYHBh3ONO8KxVnF9KXfg4hKfWhD/Yx5DLaep8ypahhlzuPBbUG31FmLS9zJ83rqmdW2vW9Ow3sJ+wO6BnIL698clzl/lulsd57YgZYWQqnUOarKbn/6GpZyzBIPAD9B+MABk62mwiiThDcCr/qPk/vguKu2n0FSqWJ82TlZup2q172llYAjK/42vhegzilcOOuOTAe1qeg0vN7wFxvW7u1C9VVWsvbg9KwRdiMicZbuzjbs3EL+49nht2FNzPm6gn2xIl5+/1u5egzx1wZ0+oCEWM1yMn6WicBYu+t0IPAhRU+yEVLd7FF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsGC2H369zlQCIjgUykob6gDkhLZUgReI48Oo4Q/7iY=;
 b=BTBPMqwb1YEsvG24Ydrg5IRKRidhz+DKfoGwlxbW4E7MWjLcjDCOHVmgmf/iZUyup8KZsGF/8BWzLT5n3TSEWHqWWRCtlQvXEGdoqWDASSOZyZQAv/7M6XIU9+0W+0XVJcI8A72drjrT4WG/WySolb0Iwvoy8hP85k0l3siS/IZ7TPwLC6QOKX0yj+U23vMGp8mc1wMXpC0w8ECuN+p7/evVsrGEihDGpV1Eui+0cu+pcVFuiR6bAbYxMP1WMoqZQk4BLDY2hD67lUCHft9Ivc0FGBJ39Z4YpsQgQCm80l/ZgTZyn4TWMDr5VjLkjo1LebAXxCSeFAkX4g+CPvSgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsGC2H369zlQCIjgUykob6gDkhLZUgReI48Oo4Q/7iY=;
 b=CEJym8NtIuMOFyaaW76YFlCUDChVaM1qO5woGcec6YlGzUrwXidmcRuOUwVLutAZsMNgRF3eB3MeSC+SNZoBscc+XT0/dqpKIRnwrjcdnzIaOF3LScD9bOrhVNFmHlNzH1H7bukcGhpAo408S4d7Fhgc7weepLRm8nZmGbjD20I=
Received: from SJ0PR05CA0025.namprd05.prod.outlook.com (2603:10b6:a03:33b::30)
 by MN2PR12MB4376.namprd12.prod.outlook.com (2603:10b6:208:26c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 2 Sep
 2025 22:41:48 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33b:cafe::8e) by SJ0PR05CA0025.outlook.office365.com
 (2603:10b6:a03:33b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 22:41:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:41:46 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:41:40 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:41:38 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<babu.moger@amd.com>, <dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH v9 00/10] x86,fs/resctrl: Support L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE)
Date: Tue, 2 Sep 2025 17:41:22 -0500
Message-ID: <cover.1756851697.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|MN2PR12MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d99d9b-47ad-4b48-947b-08ddea71e60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y4Hafy/27OIfvdtd1+OdjZeo1DWZKb9NI0N2Gmn3pQjqYIRU9AEvrPxWVKFa?=
 =?us-ascii?Q?vNNUD91QavGlUdNIklQBt7iu782DpoH0LzbM1Vt8Xm1KMPySIfJXShNP1LPK?=
 =?us-ascii?Q?gPzZ0uEEMyHjt9TmZPVxVeWm63WxQH03X08s3EMecQCAGEL/Y5+6TkqO3IJR?=
 =?us-ascii?Q?hcLt+kd373b5pXG0FRW7xqtxiA4E/2na75i3kuAKwFZvvNZGUX6f/kPvs+nX?=
 =?us-ascii?Q?2M7Ig1w6BgkidGvl/bPycPbx+XqwpgjepTtxQWivJcLI6vrS1gEZ9Gwksijn?=
 =?us-ascii?Q?XBzeoga7skRUSl0TljIqi0Fl2VV6eXCOtCmR71uwtw1+BCXb0ESd7g5nHh0i?=
 =?us-ascii?Q?LNplB0lelbNvcR5xrCzeuVMVPKZw2EZkv96jTxfW+lwstW5c1JYegJPeKhv9?=
 =?us-ascii?Q?QGKSp7rgpqOnPmy+amH8lO+L+q7ZX1p9JiQoLZROKL4ejW86G/C+9Y76oMzf?=
 =?us-ascii?Q?Jb4LoPwFWfaGD6012J+6HOmRklNOtWAdlP2oSUCGtY70vCcelPzI2Gf+zOrw?=
 =?us-ascii?Q?SjyAzRXSQ6RBGkwtv9BKIzLnKa1xYLhjpJMw5oxex41jEWhlT2sHrA6wHzA3?=
 =?us-ascii?Q?HHt0pUEojexYAonB/FDXi37iF4sMJeq+BNvZqXsxPIqmUdgM40jOR17mPZVq?=
 =?us-ascii?Q?FUvotRU/KmVh6f/aLcxw+gth9mJtl+JKZahIS3pxd3ZMW8pIRa7trTaiSzK/?=
 =?us-ascii?Q?t9tB+SM/dvXXDaWo+nU3bUXk8kfyKSYAaWWLIjr8eGj1vWWFxft22j0B0mmN?=
 =?us-ascii?Q?hjha6Pt53dMWeK52nkGyWr9GM3//EDIOaSrSM8RpOQ+WOEsaAZLADxgAauwf?=
 =?us-ascii?Q?4/VsaJLUXzm+hAxvN2FIPVgmvw/SkK6MuEnp1cTqb5vqHpueeibXFfdd5TKO?=
 =?us-ascii?Q?+l09IvoHs4dS98KMxEFEipJTxySgUea7XXu99J2EoMBX7zS+UMXsTPLv6rER?=
 =?us-ascii?Q?VUNl6Q8wWt6eX9Loh+EDvltEpzJ6f1qIwo/RECjrv0ej2V6yuwK7R5jr77J9?=
 =?us-ascii?Q?anfPScxdPjO1lVrlgxz+EMj6OivjFMuRU76VrvMMtTRq0Ak1UQb4MEOyO02O?=
 =?us-ascii?Q?s0dJsZ/Ymc42E5qR1OIZRpLBttHu0INXt/Z5wqO01A0k76l/HKjvuOSKUzI2?=
 =?us-ascii?Q?D3KrX3C6an3Cm4H0sQEHsrmlj1/tBNe65pG/vZKDFDp20jPnEmlB3KNGuWlc?=
 =?us-ascii?Q?JxYWMxVYC00e8BhapqCgYPiGSTELwXe2V2boCJGoKWOL/x4rvngjFgpI/Tb0?=
 =?us-ascii?Q?5ZSy3cJoWhr5jYEUv8aPSbqklI1DbjhOCC/7eIoFqXQzv/e33d2irKkkEQC8?=
 =?us-ascii?Q?OwTDXhKgs50P/C5f0PxkJHW+fXuGC77MO+MLGDHYOVQn71k5kZGazcp4peVt?=
 =?us-ascii?Q?yCmSo56k+8CGS+kaLRoR+VKK1sbXmWlG+lqrWW+a8v1CJQt9I3XvzO59cTw8?=
 =?us-ascii?Q?P8TIVvL8FiXQGojqAxvIlGn5yHgevnf0JCjznDQK9fk7n9H+lXTIgg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:41:46.6795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d99d9b-47ad-4b48-947b-08ddea71e60a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4376


This series adds the support for L3 Smart Data Cache Injection Allocation
Enforcement (SDCIAE) to resctrl infrastructure. It is referred to as
"io_alloc" in resctrl subsystem.

Upcoming AMD hardware implements Smart Data Cache Injection (SDCI).
Smart Data Cache Injection (SDCI) is a mechanism that enables direct
insertion of data from I/O devices into the L3 cache. By directly caching
data from I/O devices rather than first storing the I/O data in DRAM, SDCI
reduces demands on DRAM bandwidth and reduces latency to the processor
consuming the I/O data.

The SDCIAE (SDCI Allocation Enforcement) PQE feature allows system software
to control the portion of the L3 cache used for SDCI devices.

When enabled, SDCIAE forces all SDCI lines to be placed into the L3 cache
partitions identified by the highest-supported L3_MASK_n register, where n
is the maximum supported CLOSID.

Since CLOSIDs are managed by resctrl fs it is least invasive to make
the "io_alloc is supported by maximum supported CLOSID" part of the
initial resctrl fs support for io_alloc. Take care not to expose this
use of CLOSID for io_alloc to user space so that this is not required from
other architectures that may support io_alloc differently in the future.

The SDCIAE feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
Injection Allocation Enforcement (SDCIAE)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]

The feature requires linux support of TPH (TLP Processing Hints).
The support is available in linux kernel after the commit
48d0fd2b903e3 ("PCI/TPH: Add TPH documentation")

The patches are based on top of commit (v6.17.0-rc4)
commit a1d91c792486 ("tip/master) Merge branch into tip/master: 'x86/tdx'").

Comments and suggestions are always welcome as usual.

# Linux Implementation

Feature adds following interface files when the resctrl "io_alloc" feature
is supported on the resource:

/sys/fs/resctrl/info/L3/io_alloc: Report the feature status. Enable/disable the
				  feature by writing to the interface.

/sys/fs/resctrl/info/L3/io_alloc_cbm:  List the Capacity Bit Masks (CBMs) available
				       for I/O devices when io_alloc feature is enabled.
				       Configure the CBM by writing to the interface.

When CDP is enabled, these files are created both in L3CODE and L3DATA.

# Examples:

a. Check if io_alloc feature is available.

	# mount -t resctrl resctrl /sys/fs/resctrl/

	# cat /sys/fs/resctrl/info/L3/io_alloc
	disabled

b. Enable the io_alloc feature. 

	# echo 1 > /sys/fs/resctrl/info/L3/io_alloc 
	# cat /sys/fs/resctrl/info/L3/io_alloc
	enabled

c. Check the CBM values for the io_alloc feature.

	# cat /sys/fs/resctrl/info/L3/io_alloc_cbm 
	0=ffff;1=ffff

d. Change the CBM value of domain 1.
	# echo 1=ff > /sys/fs/resctrl/info/L3/io_alloc_cbm

	# cat /sys/fs/resctrl/info/L3/io_alloc_cbm 
	0=ffff;1=00ff

e. Change the CBM value of domain 0 and 1.
	# echo 0=ff;1=f > /sys/fs/resctrl/info/L3/io_alloc_cbm

	# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
	0=00ff;1=000f


f. Disable io_alloc feature and exit.

	# echo 0 > /sys/fs/resctrl/info/L3/io_alloc 
	# cat /sys/fs/resctrl/info/L3/io_alloc
	disabled

	# umount /sys/fs/resctrl/
---
v9:
  Major change is related to CDP.
  The processing and updating CBMs for CDP_CODE and CDP_DATA are done only once.
  The updated CBMs are copied to the peers using staged_config.
  
  Removed resctrl_get_schema(). Not required anymore.

  Updated the "bit_usage" section of resctrl.rst for io_alloc.

  Fixed the tabs in SMBA and BMEC lines in resctrl.rst.

  Improved the changelog for all the patches.
  
  Added the code comments about CDP_CODE and CDP_DATA where applicable.

  Added Reviewed-by: tag for couple of patches.
  
  Added comments in each patch about the changes.


v8:
  Added Acked-by, Reviewed-by tags to couple of patches.

  Updated Documentation/filesystems/resctrl.rst for each interface.
   
  Updated the changelog in most patches. 
  
  Moved the patch to update the rdt_bit_usage_show() for io_alloc changes to the end.
 
  Moved resctrl_arch_io_alloc_enable() and its dependancies to
  arch/x86/kernel/cpu/resctrl/ctrlmondata.c file.
  
  Moved resctrl_io_alloc_show() to fs/resctrl/ctrlmondata.c.
  Added prototype for rdt_kn_parent_priv() in fs/resctrl/internal.h
  so, it can be uses in other fs/resctrl/ files.
  
  Renamed resctrl_io_alloc_init_cat() to resctrl_io_alloc_init_cbm().
  Moved resctrl_io_alloc_write() and all its dependancies to fs/resctrl/ctrlmondata.c.
  Added prototypes for all the functions in fs/resctrl/internal.h.

  Moved resctrl_io_alloc_cbm_show() to fs/resctrl/ctrlmondata.c. show_doms remains
  static with this change.

  Moved resctrl_io_alloc_parse_line() and resctrl_io_alloc_cbm_write()
  to fs/resctrl/ctrlmondata.c.

  Added resctrl_arch_get_cdp_enabled() check inside resctrl_io_alloc_parse_line().
  parse_cbm() remains static as everything moved to ctrlmondata.c.

  Simplified the CDT check  in rdt_bit_usage_show() as CDP_DATA and CDP_CODE
  are in sync with io_alloc enabled.

v7:
  Fixed few conflicts in
  arch/x86/include/asm/cpufeatures.h
  arch/x86/kernel/cpu/scattered.c

  Updated the changelog in most patches. Removed the references of L3 in
  filesystem related changes.

  Removed the inline for resctrl_arch_get_io_alloc_enabled().
  Updated the code comment in resctrl.h.
  Changed the subject to x86,fs/resctrl where applicable.
 
  Split the patches based on the comment.
  https://lore.kernel.org/lkml/3bec3844-7fda-452b-988f-42b0de9d63ba@intel.com/
  Separated resctrl_io_alloc_show and bit_usage changes in two separate patches.

  Added new function resctrl_io_alloc_closid_supported() to verify io_alloc CLOSID.
 
  Added the code to initialize/update the schemata for both CDP_DATA and CDP_CODE when CDP is enabled.

  Rephrased the changelog and code comments in all the patches.

v6: 
   Sorry if you see this series duplicate. Messed up the
   emails linux-doc@vger.kernel.org and linux-kernel@vger.kernel.org.

   Sent v5 by mistake before completing all testing.
   Most of the changes are in resctrl.rst user doc.
   The resource name is no longer printed in io_alloc_cbms.
   Updated the related documentation accordingly.
   Resolved conflicts in cpufeatures.h
   Added lockdep_assert_cpus_held() in _resctrl_sdciae_enable() to protect
   r->ctrl_domains.

   Added more comments in include/linux/resctrl.h.

   Updated "io_alloc_cbm" details in user doc resctrl.rst. Resource name is
   not printed in CBM now.

   Updated subjects to fs/resctrl: where applicable.

v5: 
    Patches are created on top of recent resctrl FS/ARCH code restructure.
    The files monitor.c/rdtgroup.c have been split between FS and ARCH directories.
    Resolved the conflict due to the merge.

    Updated bit_usage to reflect the io_alloc CBM as discussed in the thread:
    https://lore.kernel.org/lkml/3ca0a5dc-ad9c-4767-9011-b79d986e1e8d@intel.com/
    Modified rdt_bit_usage_show() to read io_alloc_cbm in hw_shareable, ensuring
    that bit_usage accurately represents the CBMs.

    Moved prototypes of resctrl_arch_io_alloc_enable() and
    resctrl_arch_get_io_alloc_enabled() to include/linux/resctrl.h.

    Used rdt_kn_name to get the rdtgroup name instead of accesssing it directly
    while printing group name used by the io_alloc_closid.

    Updated show_doms() to print the resource if only it is valid. Pass NULL while
    printing io_alloc CBM.

    Changed the code to access io_alloc CBMs via either L3CODE or L3DATA resources.

v4: The "io_alloc" interface will report "enabled/disabled/not supported"
    instead of 0 or 1..

    Updated resctrl_io_alloc_closid_get() to verify the max closid availability
    using closids_supported().

    Updated the documentation for "shareable_bits" and "bit_usage".

    NOTE: io_alloc is about specific CLOS. rdt_bit_usage_show() is not designed
    handle bit_usage for specific CLOS. Its about overall system. So, we cannot
    really tell the user which CLOS is shared across both hardware and software.
    This is something we need to discuss.

    Introduced io_alloc_init() to initialize fflags.

    Printed the group name when io_alloc enablement fails to help user.
    
    Added rdtgroup_mutex before rdt_last_cmd_puts() in resctrl_io_alloc_cbm_show().
    Returned -ENODEV when resource type is CDP_DATA.

    Kept the resource name while printing the CBM (L3:0=ffff) that way we dont have
    to change show_doms() just for this feature and it is consistant across all the
    schemata display.

    Added new patch to call parse_cbm() directly to avoid code duplication.

    Checked all the series(v1-v3) again to verify if I missed any comment.

v3: Rewrote commit log for the last 3 patches. Changed the text to bit
    more generic than the AMD specific feature. Added AMD feature
    specifics in the end.

    Renamed the rdt_get_sdciae_alloc_cfg() to rdt_set_io_alloc_capable().
    Renamed the _resctrl_io_alloc_enable() to _resctrl_sdciae_enable()
    as it is arch specific.

    Changed the return to void in _resctrl_sdciae_enable() instead of int.
 
    The number of CLOSIDs is determined based on the minimum supported
    across all resources (in closid_init). It needs to match the max
    supported on the resource. Added the check to verify if MAX CLOSID
    availability on the system.

    Added CDP check to make sure io_alloc is configured in CDP_CODE.
    Highest CLOSID corresponds to CDP_CODE. 

    Added resctrl_io_alloc_closid_free() to free the io_alloc CLOSID.

    Added errors in few cases when CLOSID allocation fails.
    Fixes splat reported when info/L3/bit_usage is accesed when io_alloc is enabled.
    https://lore.kernel.org/lkml/SJ1PR11MB60837B532254E7B23BC27E84FC052@SJ1PR11MB6083.namprd11.prod.outlook.com/

v2: Added dependancy on X86_FEATURE_CAT_L3
    Removed the "" in CPU feature definition.

    Changed sdciae_capable to io_alloc_capable to make it as generic feature.
    Moved io_alloc_capable field in struct resctrl_cache.

    Changed the name of few arch functions similar to ABMC series.
    resctrl_arch_get_io_alloc_enabled()
    resctrl_arch_io_alloc_enable()

    Renamed the feature to "io_alloc".
    Added generic texts for the feature in commit log and resctrl.rst doc.
    Added resctrl_io_alloc_init_cat() to initialize io_alloc to default values
    when enabled.
    Fixed io_alloc interface to show only on L3 resource.
    Added the locks while processing io_alloc CBMs.

Previous versions:
v8: https://lore.kernel.org/lkml/cover.1754436586.git.babu.moger@amd.com/
v7: https://lore.kernel.org/lkml/cover.1752167718.git.babu.moger@amd.com/
v6: https://lore.kernel.org/lkml/cover.1749677012.git.babu.moger@amd.com/
v5: https://lore.kernel.org/lkml/cover.1747943499.git.babu.moger@amd.com/
v4: https://lore.kernel.org/lkml/cover.1745275431.git.babu.moger@amd.com/
v3: https://lore.kernel.org/lkml/cover.1738272037.git.babu.moger@amd.com/
v2: https://lore.kernel.org/lkml/cover.1734556832.git.babu.moger@amd.com/
v1: https://lore.kernel.org/lkml/cover.1723824984.git.babu.moger@amd.com/


Babu Moger (10):
  x86/cpufeatures: Add support for L3 Smart Data Cache Injection
    Allocation Enforcement
  x86/resctrl: Add SDCIAE feature in the command line options
  x86,fs/resctrl: Detect io_alloc feature
  x86,fs/resctrl: Implement "io_alloc" enable/disable handlers
  fs/resctrl: Introduce interface to display "io_alloc" support
  fs/resctrl: Add user interface to enable/disable io_alloc feature
  fs/resctrl: Introduce interface to display io_alloc CBMs
  fs/resctrl: Modify rdt_parse_data to pass mode and CLOSID
  fs/resctrl: Introduce interface to modify io_alloc Capacity Bit Masks
  fs/resctrl: Update bit_usage to reflect io_alloc

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 124 +++++--
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/msr-index.h              |   1 +
 arch/x86/kernel/cpu/cpuid-deps.c              |   1 +
 arch/x86/kernel/cpu/resctrl/core.c            |   9 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c     |  40 +++
 arch/x86/kernel/cpu/resctrl/internal.h        |   5 +
 arch/x86/kernel/cpu/scattered.c               |   1 +
 fs/resctrl/ctrlmondata.c                      | 305 +++++++++++++++++-
 fs/resctrl/internal.h                         |  24 ++
 fs/resctrl/rdtgroup.c                         |  77 ++++-
 include/linux/resctrl.h                       |  24 ++
 13 files changed, 570 insertions(+), 44 deletions(-)

-- 
2.34.1


