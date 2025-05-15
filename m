Return-Path: <kvm+bounces-46684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B086AB85F9
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 14:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBBB79E73E1
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 12:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D2529DB90;
	Thu, 15 May 2025 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XpfYxYud"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332A229ACD3;
	Thu, 15 May 2025 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747310923; cv=fail; b=YwrJfn0vnA5/kMCbSa8ScenwSDsP48T2M5Qix14iN8Z5C5Hi5zSVdIFVFRVn1wudBnInqVXlaHOa/4dVlR41qrMq1L6JuFgtAnxH8pIMFk+ybEiec/cWWfZ+Zck1GtSUqa3xGByPeBbay71/CvFJFZU3n/1fViKJncqkBvBvRvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747310923; c=relaxed/simple;
	bh=k+sYv1vErRd76FerCR3lBQjCmVJ0kCueNOWf4eIAXcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axn47kOaCoolfjytnnB7iUZ7XkscOlxqI1ETuHiaWWjklnGaeeRUnPevPnyM8LlDfIfYcznLlQ5waqDTluO9gvg5PUq8ontBXzAXINbdWgg6sqAgv4zBu4o2Mm3i7c2KRuRrEucRDFA4m/5evz0jI1B5DqJ5LWk+FOoD5teeVQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XpfYxYud; arc=fail smtp.client-ip=40.107.100.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZJhxheFBqV/ojo+/XZQF4Tq3VivGfKTsqdNSQn4NCX7WwemI1wueifcPk6hXeVNwe3FMcORXY2jKMK2EvwRAxQZUJ3Ilweo1DFUd/uGXHisqhNO3PqoA0XKxprC5wyAbCNRC0Q536D4okBOiTniHl3fwX8k67zdKIq923aIgOTCvtvd+uM/1X02tf+9lT/Vw4OLdRVPhc2V5de+EhgyAhukxCxebJgL1i/KUbmaz9vkObTbvh+jYluUvv6QDyeJDQXrK+QATWI3aUCM3Xif/BRMkUdIUb2rrox8IVUlcMAUJAgD20sNW71UBNxYc2EuaxpK7OB/suugcukbMeRkJpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ftg/CyEP9NfkuvWf0cYWfexGAPN6rVWwfg7ZWld6tUM=;
 b=sj2NT6vqW3AYOZWvq9rXbTSMolTOzgNIjpATD6oGrZt7y43SzxYZQYp1Y0GALEeQQBI/RhU3SjXSxur02O99+tVScV3PGBk0CHdyrtOJjeRAK4h766kQo4ocrGpZjq3hH4PGI+kauPThrAu8p9pbWSee0tKxZ84wcZwvgFwT+nSYNPqJeSLvG0onEc7h7Di056B116Z+boJbnJkXps+a8EI+5bevjlDxmTF/71OdPP5D4l+Nn01ZM+vEH9/klyTRhmPgWK6uZoNV+Ua3mpaSu00Au1u5Xp0evjmfbCgGd+D4wIMUvgA0u1xOKnAiEFZuGMHuZrMs4M6XfCE342Gaew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ftg/CyEP9NfkuvWf0cYWfexGAPN6rVWwfg7ZWld6tUM=;
 b=XpfYxYudcWfi6QiUfTlEKUXPwOcu+ioQaYi7EJLFLLU4j+uIDQ+/ezvELuDaSWBih6SIe9+/HBqIiu9oRUn+u+DEIIT0hiHxvHrICKmt9+a2EN/t30xSJ3SYyyiBbXzFcXy68MwuqRcszHi9Nq7GF4dEMSSjNP3YDScQFhh7QY0=
Received: from MN2PR16CA0048.namprd16.prod.outlook.com (2603:10b6:208:234::17)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 12:08:37 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:234:cafe::2c) by MN2PR16CA0048.outlook.office365.com
 (2603:10b6:208:234::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Thu,
 15 May 2025 12:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 15 May 2025 12:08:37 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 15 May
 2025 07:08:33 -0500
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <seanjc@google.com>
CC: <baolu.lu@linux.intel.com>, <dmatlack@google.com>, <dwmw2@infradead.org>,
	<iommu@lists.linux.dev>, <joao.m.martins@oracle.com>, <joro@8bytes.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>, <naveen.rao@amd.com>, Sairaj Kodilkar
	<sarunkod@amd.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
Date: Thu, 15 May 2025 17:38:04 +0530
Message-ID: <20250515120804.32131-1-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 25c5f502-fd80-4641-c9ef-08dd93a9395f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N0H/lJ0jc4uSbnf9rkZKw3H6Wav4muBTXZkeXAUt+hLg/UTn00CxId8Ecz1g?=
 =?us-ascii?Q?uVizsASLCiEcB3WeAzE1E1F9YQQWnynaxeUhNVti86x8Q+/Gsf2vXMK8YiPk?=
 =?us-ascii?Q?NrLN1fWlZZa7HGFysbs1aAxGNYs2sI+uD9wkU32xFbXgfUamaUkDXW3g6HhW?=
 =?us-ascii?Q?TWeSmylVM0H4l69FIVRN0G/4L2NDHIwaUH5d9c+9zI1Q+kCpx3PWWJo/avJi?=
 =?us-ascii?Q?qfgJPCQvvCGrzvfjgiHM/IdGB1NcciJlWE5JGKzMc9oZeAYkwyF3Q631x1Ph?=
 =?us-ascii?Q?/2KzFZRCJWKUTEEeG+TqZMz1JhP9AXXSH9Vh8b1TanSHPNJoCgqdl9JBen4Z?=
 =?us-ascii?Q?BZdimkv6yEQHZgbbLdwHZbmOrVuozsqbf44kifVyxOF/tzc51Ibe+Xlz943f?=
 =?us-ascii?Q?7HYvWHXT4LT2DY0OEIpVWyKw2CQxtrvJWXfpuDqCmj+buzVgy2YzCDDroE9Y?=
 =?us-ascii?Q?sBW0IwPKQEjXs79EiXlwfCsOINAV29RMpXTleJZTeHg6UjIp/UD9UumsNuP7?=
 =?us-ascii?Q?qh/9ot2XPLVkrAaJrqRWjZuq4BTHIYrJyCv9iOFXX94OseRitYG2iVj56FPt?=
 =?us-ascii?Q?lmfY32sPW7bLKn8RLIF+IVctzyLLU0+bp32zB4Y443oi7GUDip877C6AyLo7?=
 =?us-ascii?Q?DXBvHq9b9yYr8lUCKcS0Wmfp6RnP47BqtBkWtY4DFf4ViT2CMzajPiavL1FG?=
 =?us-ascii?Q?Z9tMhD9EO2m5A+daLg5E9oU7Ck2oSUqgtNsNbJL3DLkpPCg0IQbUVmMlfvMu?=
 =?us-ascii?Q?wH7l4oRZ9DfMLiYAHoWajvlXb9mc71N69xqdEx8gtrovQ5Ty89bEr3YNrJIq?=
 =?us-ascii?Q?fGx2gEcATtNEK7pgJZ93A1HLCzP0TobVkuoqDWHoOE3LOBe5xoz6CJ1h7CK2?=
 =?us-ascii?Q?/JJOM8rzaTZLd2G0QmpzEugKzpdm7Z6qGj4Mk4F1FGw6DPt7hW1nGLXYqWjw?=
 =?us-ascii?Q?MKTuNP6WOoghvAKJoOgPs1DvkchxoWM78fNus54flssym4+df/v+8s6EU3Iq?=
 =?us-ascii?Q?w9trrYPObKfcQlp2l0akRBYKHbT2d9JhaLsR18qI2ZKhjnYEH7eVkSvG0sXB?=
 =?us-ascii?Q?Tq5MqrqsgYVVFH3jmCXVvgM+2gGxu19FwbzT2woNqEiCIs++PW5DYSrcN5v8?=
 =?us-ascii?Q?9SVL6bKydHCGp0jQ1NGIzv30FsedoXDBxa/6aETOLkBmF6fyPi8pP7obfwpr?=
 =?us-ascii?Q?3xzAQdlzjWG0e5E3TeHReG310/43lu4pAtB0vKl9Pdx/fvnbM0vNywcycOt5?=
 =?us-ascii?Q?OzeNibiQxPMDwtLSIa7XVZuThacaL1ztGvd4J7pMdoTaP+euRNTa1rjIwut+?=
 =?us-ascii?Q?eUN8aZJpNyj1gUdVUzDlD3wLkcx8srkog2FbhsPvuKKLm6fJ6JI/CQsizlGP?=
 =?us-ascii?Q?lO5JVjN9gU6AS/0qZk/HYls+wN/7wdk28h6En7291GJfIybSV+sFZRmBEKmX?=
 =?us-ascii?Q?5Z/A1h85kEtie66gugrkSCk3gdXB+3ZU3cQLesQWE4+R1LwlpvxlLM0HE3FE?=
 =?us-ascii?Q?cgEil1LgskNmRYrZv2AOSq2kotxX4qJAkC1y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 12:08:37.7375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c5f502-fd80-4641-c9ef-08dd93a9395f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492

Hi Sean,

We ran few tests with following setup

* Turin system with 2P, 192 cores each (SMT enabled, Total 768)
* 4 NVMEs of size 1.7 attached to a single IOMMU
* Total RAM 247 GiB
* Qemu version : 9.1.93
* Guest kernel : 6.14-rc7
* FIO random reads with 4K blocksize and libai

With above setup we measured the Guest nvme interrupts, IOPS, GALOG interrupts
and GALOG entries for 60 seconds with and without your changes.

Here are the results,

                          VCPUS = 32, Jobs per NVME = 8
==============================================================================================
                             w/o Sean's patches           w/ Sean's patches     Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts               123,922,860                 124,559,110              0.51%
IOPS (in kilo)                            4,795                       4,796              0.04%
GALOG Interrupts                         40,245                         164            -99.59%
GALOG entries                            42,040                         169            -99.60%
----------------------------------------------------------------------------------------------


                VCPUS = 64, Jobs per NVME = 16
==============================================================================================
                             w/o Sean's patches           w/ Sean's patches     Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts               99,483,339                   99,800,056             0.32% 
IOPS (in kilo)                           4,791                        4,798             0.15% 
GALOG Interrupts                        47,599                       11,634           -75.56% 
GALOG entries                           48,899                       11,923           -75.62%
----------------------------------------------------------------------------------------------


                VCPUS = 192, Jobs per NVME = 48
==============================================================================================
                             w/o Sean's patches          w/ Sean's patches      Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts               76,750,310                  78,066,512               1.71%
IOPS (in kilo)                           4,751                       4,749              -0.04%
GALOG Interrupts                        56,621                      54,732              -3.34%
GALOG entries                           59,579                      56,215              -5.65%
----------------------------------------------------------------------------------------------
 

The results show that patches have significant impact on the number of posted
interrupts at lower vCPU count (32 and 64) while providing similar IOPS and
Guest NVME interrupt rate (i.e. patches do not regress).

Along with the performance evaluation, we did sanity tests such with AVIC,
x2AVIC and kernel selftest.  All tests look good.

For AVIC related patches:
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>

Regards
Sairaj Kodilkar


