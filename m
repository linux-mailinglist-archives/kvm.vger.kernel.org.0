Return-Path: <kvm+bounces-37682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B034A2E78A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3B851886C26
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764141C3F34;
	Mon, 10 Feb 2025 09:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YY6y02qd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECC71C3F04
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179374; cv=fail; b=QOGYlpnvUJ+29jjorkHtyGhQZ/uYDbIUWWM2ovuu5PDGYHPMG8o/Y6stmfgBBwMZ+Q7XVA4/EPztpl7XRv3AQ6Hu6aUAOQlO5hlrssM3hh8wCw3lTvZjBMn8zEyZ91YlV0Rf6V35JarkuBMsQCk9Q+mUeUYEp/T6kod3hUe3zLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179374; c=relaxed/simple;
	bh=htiUR381yJWZ4AMkhW6Z7Bp0WBVX70XykDwNdMpyi74=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GAbRc7+8yfK3gNE4cRk5eQ0JeRKODWLSSY0W4eFbByYKkJUuhPEdl5VHQ9zFYvVNQHZPjBKVFT6jnkezvoN9ETOphpnd3dv5hmHLJTTL8pWLjEg80pHR4/SRr831sN1Tebhyjzkw0JgjS9cZsiwZd47FDxP6I2UiX6jGFn5SaYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YY6y02qd; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PvP5twrUzO2MvdViOvthiquj0CPWhBV8F2lYx9HbwpbyiOt7T+NGDrfP8xOyzKf5eymsj3HdYye8d/iyrQ8nwLiQCJfoJDRFClbLdVP20fpwyC6cv17ZrppGKL/wva1YXJOdyIJQLzQKaW/4f5jWtLfd3/2WFHg9s0eToJRBhuZ/Wz84ufUmKxQgAPhZQut0V/mVMBP7ERog2nB7fkZTHKS/4DkjrNlDKyzDv6hz62MMhkOP6/YD2joZFxDdsfQDB+FCHRgVrv2laRtZzJ7dcDxVZEnhwrAdJKebXuN9Nj0DkpVf4+vs9mqBjYdAOZbiDZ5Z3YxnfsWcBK6t8bGD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0glOAD5Hpk/yka5w14UYaOm1WZePDnCsgy1KdcD0MLg=;
 b=rxIYg+9DAhhQ1qzOl0t72ozp/c4pnMxtkZl5RuhhC+5R1oL7BxW4D+qQQMBrmqlvrzk55uRkPw0V1INN1Zb5YB7tfYZkd4utAgtYw4S1KM5n23TFyVPEhMsREY0jgX642c4XjZ05o5kQFE8dC7J+PyBZXABgWPa7R5hcdSTElFTqjtQTDr9hMVXSqltv+t5jAHhOKHyy2+mcShXZ9dNMIyiXFNsqt44xqaU1Rpf96NCFXDavEMFxneb9KWW9JAKo34ErCjW4/m+NT3PbEOaOIXLxMy/u1qxZYDew3X3DJLbF/tZhp8hzu8s0/gWp20+m8/cmitu4EoKrvnlUFBNnFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0glOAD5Hpk/yka5w14UYaOm1WZePDnCsgy1KdcD0MLg=;
 b=YY6y02qdYVmySm9mhtApKygFtjspfHHezngmlYtIQm8TOvsqgUHAcVMlceIt505M2fo1A3TtMAxR3Vxpj/Ya0Rbp5HJVitwUWou4NMDiVDzXwGdL7mXQsVYiLQUN0+wAnvGznsYODSgsORnL3zBaEI1NJaghJc246YXEV4r+Rvs=
Received: from MW2PR2101CA0023.namprd21.prod.outlook.com (2603:10b6:302:1::36)
 by DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 09:22:46 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:302:1:cafe::28) by MW2PR2101CA0023.outlook.office365.com
 (2603:10b6:302:1::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.2 via Frontend Transport; Mon,
 10 Feb 2025 09:22:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 09:22:46 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 03:22:42 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v2 0/4] Enable Secure TSC for SEV-SNP
Date: Mon, 10 Feb 2025 14:52:26 +0530
Message-ID: <20250210092230.151034-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|DS0PR12MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e7c49f8-12a0-4b4e-de12-08dd49b47b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TtOMXpU7aTvIoSheyWGwg5/4JF+mmVzfA1RWb1NPjDL3Cw8wsjAuHd49bid6?=
 =?us-ascii?Q?xioR5/milA0wljE+KQUSZ+DuBR7MAlJO94OdCSKttYe842HPOElBwo597ZXX?=
 =?us-ascii?Q?v/LydaNxi3yoWdso1pJMq+neM/xRMgiwFpEuF9HsKMJ8aZvzGMWHFgXUdKHe?=
 =?us-ascii?Q?a2ey7akjl8KBHFHoltTVnZoRZLBc6fGK2/XpLjh4ccM+fNor2TAdRjaRdtjJ?=
 =?us-ascii?Q?EsdfWNAwkxZWieseAk4QkdmcJjqN0q/ZThO7Eoo8Yw84n0CbKEvsV5YAJgb5?=
 =?us-ascii?Q?GD5+bzzZl3DTij5AUICv1t49W+XVnkkU12W0pJEHgX1gmRnXbx0/qyZ05Rcu?=
 =?us-ascii?Q?0jh64lhb7eE1Et5JJ0n4qqSZksHm5GK72g3rscCWyNq1zWpnJ5nfvzfudwaG?=
 =?us-ascii?Q?vSdS7Jgae/pH+b9LVkdQ3TfZ6e8m5ubdbFq7r/FAAtb/Zpy83pe0Qr/wGHwd?=
 =?us-ascii?Q?/K9fdp/CvWwySettmOz6kjkzHiJW0BNnvrJ8Gky+Xs6+bwfnxNzfkQWDIsSg?=
 =?us-ascii?Q?orZLxpSowZ+SUiqNthfrPZJNi2ZfMATaBkrsk3msO4N6ugQ4fZzramVX8nwB?=
 =?us-ascii?Q?8bRObND5mjuaeiQbaQAfwi6Sew3YMd+5BebBm5powAQe2v7LaWpR3GpiGz3I?=
 =?us-ascii?Q?AsE50+22iG6YAOSRg+kA2C3FDBZsZcse1QDXNUk6JC7MkUuf6X6Hh9czGTcS?=
 =?us-ascii?Q?zlc0hYg1UbKt6P2+nWgzlmAcviNKlGUFwkYaqirPwKsKO44kwGKzOqPwlEET?=
 =?us-ascii?Q?TWFDFoDb7C6Gj6g3tnOqw7U3xu7FpGhRIK72U03v9dDh9kZg/uAcqWUB3Rqp?=
 =?us-ascii?Q?Md8+S5K1PpZbMrcWWlNTcKDoxDjWfNIRFILiRjxvNMCn8L0Fk0EIz/j9RE2D?=
 =?us-ascii?Q?326EcmfOwe+la+Y5UzIP20bFCPH7rWUaB4N2ChJZt+FBpj7VTRc3/Wg3Ice5?=
 =?us-ascii?Q?u9hv7ZBxuCqFbJdFuNfeSACw/4BuFs1G4PlWLCE6+avkdn4omskY/vDqjGlC?=
 =?us-ascii?Q?r+2c7ZbnJsvUcHdqLgjnBn3c7Ua1ZxWNojr3ROH/S2K4k0drVSFj0Z3euIvz?=
 =?us-ascii?Q?atfc2AHVTXv6zOTKp0xwCFziEHzLZ+wchCYUm0CRR4BUSzLZENsyDLErRwaH?=
 =?us-ascii?Q?l3mhqHybUtGjDUO6Uky1hiaIwZKA6iv9kDbXJObDwBTwwCEssjBwdAhAolF5?=
 =?us-ascii?Q?Fg6sXD449HrCmo5HDO0r4GLVQEnzTN72Xfg36skcFLZblWE+Fb1D8r7dwqqv?=
 =?us-ascii?Q?sP7yT0OTQaBklNhEL5cqt0gSd+HhWUmN+yFiFpa9aDTbFCwRzmzRTyWw9h1v?=
 =?us-ascii?Q?OdD70WqkYoWsYqyMXRMiTSdeBgzsjC3o1zrIuIkboQ2yeViPdSjIuZ2OnBN2?=
 =?us-ascii?Q?y3avo3zJ8HHtb0ZT6Swfn84SW5sfaU8qJ0/Vz5vCr5UG9Jb78a32Ivi2tVq6?=
 =?us-ascii?Q?vKr/5ku+l8U1oIdQ6xYG5+h4eHUKzmez?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 09:22:46.6164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7c49f8-12a0-4b4e-de12-08dd49b47b47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7777

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on kvm/next

Testing SecureTSC
-----------------

SecureTSC guest patches are available as part of v6.14-rc1.

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v2:
* Address cpufeatures comment from Boris
* Squashed Secure TSC enablement and setting frequency patch
* Set the default TSC KHz for proper calulation of guest offset/multiplier

Ketan Chaturvedi (1):
  KVM: SVM: Enable Secure TSC for SNP guests

Nikunj A Dadhania (3):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
  KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 12 ++++++++++++
 arch/x86/kvm/svm/svm.h             | 14 +++++++++++++-
 include/linux/psp-sev.h            |  2 ++
 7 files changed, 53 insertions(+), 2 deletions(-)


base-commit: 43fb96ae78551d7bfa4ecca956b258f085d67c40
-- 
2.43.0


