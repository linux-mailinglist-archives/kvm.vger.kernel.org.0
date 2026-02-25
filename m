Return-Path: <kvm+bounces-71789-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gO6hA5CLnml8WAQAu9opvQ
	(envelope-from <kvm+bounces-71789-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:41:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C86819215C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D1AF305ED2D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB192DCF55;
	Wed, 25 Feb 2026 05:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jYARXzJq"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010067.outbound.protection.outlook.com [52.101.201.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EDC1ADC97;
	Wed, 25 Feb 2026 05:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998075; cv=fail; b=a1fvNNtSH1Ki21YwXjNX4lhdvguoFT8pfy0jzmGUxlnK9/BKNf3RXzYNNljDUddtaQH8ci7CSQEsJFrcLUELxrjg727qBbcAwOUQPfsj3v86y9QhF02vj9nSPOSRCTCo5N/99iPLKFo9wvmvRwDIZGx9puUVlX2onIVNWU5xByU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998075; c=relaxed/simple;
	bh=RCi11clcbiDdkZhmdn1CyGO8yOZDQLXjRdu7SmSnnKU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EsHFpbMgiwHJaOdHfOQHp9LjAtQp+C5KhkzTgYTNwhftS8WSXbKell5TrkynIwcCjoagVH4CveSp4uagYfpYAZ8Xk3MKG0rJno3+Cvo7MsIBWIXOQutNB/SAxwqM44B7kPAxHhAJjOuHgTY+3VdaUInEshPnIKXSC6N46BMHlSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jYARXzJq; arc=fail smtp.client-ip=52.101.201.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErLqk4KtSyrM06VfRrITY1adnmUx0LMVqmUjmMquHyztms6JqxIf7WlHB3zpGIlQoHtcp7RP94LMaz69ih9sXMrsVG3wzCRGr1+YHIzCmocIsmRop5LGCpwCI30oN/AhJJ3wP9j3DTx8bZ0WcRW0ndAjtPOCQrZq5vo5imZw+HOSQMHmv3EZYBMB8Fm0me9VaRS9/33U68q3Y4+aZedyK9QPDuxokPkr+JV3YqdvytGjdUZ0GnfLcp1TWVKK7OLMjKIO8m5lJdaOq6UzIhMarMFu6f+tm4d4oQiqhhyfs6fo8dBvbYDPEgViEckhECAt4TCIPLoczkCs9cZtHHlIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryPls/lksunlDf/yEL+j5O9OgSMQriJyUtFyYVOzhK8=;
 b=unNJRrFHoJcSquT5NKvt/v6FjtTTS2b6CQdfdGsO8Ono5AmByellR6kLsm0t0hxyT299abIzH1gEZcounEsOBHDxH2Nq/XBZENGEEyn5WUXn2Ai6yBLU1b5++MwlMEPHGuwzW78dc7sA9qyQhKG+DNei/RUOLjC2y1QwH2zgDTnfkW0jdFR5hk5SqZjswa410AcCU2IL16W9sm4LDo56+ZD1OG7A9q95BGn/kLGUbcmxAz56ZjYoGQZyvGPzWLohW97dhXI5tVyaHjHCxqRbugUlCDysCHdsGh1UVrvLNSRq6ZG01vWpycn75CEG8bifwDwc8ThyQYgwXX4OXvOZig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryPls/lksunlDf/yEL+j5O9OgSMQriJyUtFyYVOzhK8=;
 b=jYARXzJqIjwPvjzbzxioR/XkGgmkR/ykuN+y4peu6DNE/U4o9ZrMdoy0ewBa1AHucmjKWBZjW5AV9uHnqi0jAeZAUnInZfB/K8UWxnap8r+cGd9tk9u5KI2Q/+wNIy/i7AUspcVF7T+sUH0G1LgS94PWgP3o/YhmkNDcYCza4Ug=
Received: from MN2PR04CA0031.namprd04.prod.outlook.com (2603:10b6:208:d4::44)
 by SN7PR12MB6671.namprd12.prod.outlook.com (2603:10b6:806:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:41:10 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:208:d4:cafe::b7) by MN2PR04CA0031.outlook.office365.com
 (2603:10b6:208:d4::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:41:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:41:10 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:40:50 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP devices
Date: Wed, 25 Feb 2026 16:37:47 +1100
Message-ID: <20260225053806.3311234-5-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225053806.3311234-1-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|SN7PR12MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d59c68-60c8-431c-6c93-08de74307ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Zq9ZAWXEmPJlg+jB8jHPD3XqaFQoWKNDD5zZr6jDZ/SO/0sSbp5tUT4G20S?=
 =?us-ascii?Q?KwWNrdRIR8DBnxYKeVKiozVXi6rvk7UhtMApU2Eu48SEh5NSdENSMKu74ZNg?=
 =?us-ascii?Q?dsz3JKnuIYqmatDylvD8AVSTxseP4ySvJQ0nuUDpRtJdIQ3Vr3ZfkYP0H/HV?=
 =?us-ascii?Q?eFlFlG3LiP4Ul4opV+d4iCf+vAqJQ9yUdip8X3KZVHqEyc6TpuXE04LvXQ2c?=
 =?us-ascii?Q?K3pmJN7HU5VxBxr2IWs1/5xJEngXXIwDwpbvsr+ZdIqGnlMmY1FrAKsEM9Jh?=
 =?us-ascii?Q?7UC4+epv+4BWVgKXO7juGsFcZm3hHIJWxdt6pXyMaKfwAaXSpMTkQfx7GnC9?=
 =?us-ascii?Q?HZwMuD7EuHCsRzKh2QpOStmZKwGZ/i4urhAsUTg/kE01eKTVsTEgG910/tMp?=
 =?us-ascii?Q?rmrcp4X4Y46XtEgLuGnP2VWycyCVsIdm4vjwQhQG7hwbZ4quQf9vK2NzbXy9?=
 =?us-ascii?Q?7pp9p1fb1l4bJrfTkAR8syEx0Whu6XKWXndEw4RJ9OV5P/n0fVlUB8fKCv0/?=
 =?us-ascii?Q?1JWjxDryxHmd29ZXRUOkLvFEa1urOyhcSiN+YJ+tCXCSyra3yM0V+pwEFHKX?=
 =?us-ascii?Q?6tlBIeI+1n7/9OUCmOKIXMA6rmOBlR+LpyQF7usL1aNJFK8Mq9tkHjvq0lwq?=
 =?us-ascii?Q?ej/ufDZPo+oSY9pU1psbsTeQQcOmwK+ntk5/JSjKLGWi+F/AnU7lkh2mB59y?=
 =?us-ascii?Q?8y4JK+mmR53nU1f8C8Zz85RWpFz702EfN/jdj4/b+0JDtDyfPJYOlltQxsVr?=
 =?us-ascii?Q?mOGHHSYRBJ+PeZO8Az4Yjqt+Ba7+KdH94E2nwJsu4hxg2dRC5c4WzGj5iX+Q?=
 =?us-ascii?Q?Hfk7l2fgplBMYAfheqX11BS7m7T5SX0sr0f8fQKtLxHpGuT0CIavepFAyDz/?=
 =?us-ascii?Q?oryNLqDXM3P/t+BWiRKHm7C32HKMNEQDTkmsLCaPUz1hXGjJMlgiivQqyk+F?=
 =?us-ascii?Q?pQlCKVH3FH0+9zEJGPZC1ur2OQyZcOgDdTtKY4W0OL+QvuFuBuqiU8oBETxG?=
 =?us-ascii?Q?AxoS7BE9E40mIERwih7GJb3Y6PZY7/VhzRi9pG0NlIh0kNEjnYFC7VO3q4Ar?=
 =?us-ascii?Q?1ATNExxylVcEiLFTcWQVajT8H3Z8DsGtLiC9Qnmz1jkE3IKmnKsL97MWdiWu?=
 =?us-ascii?Q?YoVqNBxabD2XiaWb0efWHJ2ja+cTzOCUr3Bl9wYFtsIng6DlWVCJCA4FBu80?=
 =?us-ascii?Q?6Pe/Yn3ZGItG9yyIkUOgkBD1/IqW5DhSKYGYp9nGyZ1I0sP0YsbM2upufBTI?=
 =?us-ascii?Q?bXGSIFWXtt/ppe+bWNvNxN/HSFmY0rUuU01xhlwzSretLjR1pa3HZww4tWLt?=
 =?us-ascii?Q?7UPm4I6dLWIh2eFRjHSa0/X7OSWXXBJXzdD78Eap/frGzRvRFjgAMoaWN2e7?=
 =?us-ascii?Q?q/y0ARQM3KU4bCvBAD9VqneRTnCImc3L/tvlT5FItijNaHG8wMwKQlGfRhNf?=
 =?us-ascii?Q?Hzt7YeOaxs79nL0u764JXft5NY27aZsufeuFNVMdmXwEv3fDA6UPriNkXBjI?=
 =?us-ascii?Q?ErBKYf1Pk3dhiQQDxAFS/x88idIE8xS73EPavWu5h5l6HvWJuCsgKC8EqGLe?=
 =?us-ascii?Q?ySxohcLumuKKH7ZHpjJXKb+mDJTSUHKib5whB2+5oSAGvgiZFM1FUxKJXksa?=
 =?us-ascii?Q?87MRQlK6beQfzq6nh+i/PyfsdlVDVnPyxzlMNPrM1AtjqNcyzUwGDyMxq96O?=
 =?us-ascii?Q?3EbR7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qYrTZcTfx57qppilh+bW/OVjg+RWmrK2h0bDrovEDoPzYshiSgLa9VcNfcjDtWkpGrncH12R4xnyFhwn3TAynjs6TWRXs9XTadgUd6jde+YVanXC1SiOWvzn3dUBk8hRyh/nIIyy5oac6UGd+Q5EcRgqImkOYyA4d+HomqyXXimraRxsQoEOCyeU+hnWg9OEXBDv1kltJX9bJNsGVqMfR9EiX+4HhyhFf67B8GdPRU76dIDZCRW0JCZ0SzKfn+PJdLtegLeAKCGdoUJE1LGxOgDeuqO3hmO9GDQ3Wk8TcwQCSmYllZisxG7zAtdoPopa/eK0N9K7hKvDoUOTAWx9PMKsdQn1GERACi1wHkAt0ATYUe/SepRNvBHbI3jKhqf1N9HqwOUEiiBfE6/PL1dg1FYsiMmuADyWPk/I3GB7n6UkZEx6lOxQeikxrDlRBPoR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:41:10.0812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d59c68-60c8-431c-6c93-08de74307ad5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6671
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71789-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 7C86819215C
X-Rspamd-Action: no action

SWIOTLB is enforced when encrypted guest memory is detected
in pci_swiotlb_detect() which is required for legacy devices.

Skip SWIOTLB for TDISP devices.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/swiotlb.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 3dae0f592063..119c25d639a7 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 
+	/*
+	 * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
+	 * swiotlb_init_remap() to allow legacy devices access arbitrary
+	 * VM encrypted memory.
+	 * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
+	 */
+	if (device_cc_accepted(dev))
+		return false;
+
 	return mem && mem->force_bounce;
 }
 
-- 
2.52.0


