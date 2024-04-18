Return-Path: <kvm+bounces-15162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3806D8AA37C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B44241F225AD
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652F81A38F7;
	Thu, 18 Apr 2024 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x7LG7sKg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA36D194C8B;
	Thu, 18 Apr 2024 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469831; cv=fail; b=Av4HqbAwZJYFm/xNNX7C5NppBifSuTkFJAkfPfMchflHimkiv36HMhzNfJ/oZtW1BXkE+8mSonilBS6AFFnscFBMKNZ3vgKPjCSqF9LWD84CRRlyVUwI++6Z+LrsIg7UBOTfO8FxhNd1HhvsRxIh8UhWS2lYYo6XThC4vJNgkXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469831; c=relaxed/simple;
	bh=FJCMQvRyfp5Z1IhuXUvGBSE2rK2rAfv2nhEopFQTfmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRBAsAMxnHQz28kN3MWDXWRDYLylKT5iiluJbSsxxm+oVeBU2+EWhPVO9D0l45ogZn+NRzOqUXjKQKilIubYIghfEzM/auUp5yapzdTxz0yNAMSA7lGW2cWYbKAiuPc28N86gdoIUybTmU6/DFpDZ32JLED4xuzj8HHh9hd1l4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x7LG7sKg; arc=fail smtp.client-ip=40.107.96.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz+mOHeV7cEoxzA4wzXBS3Hyb9TgAmDRnCECWZ1dgwW230j1l/006oyNV84t4pkTD+HJI05EYY8UNwhkAhY4v+N5rOaUVGHJdWJjhWJQRoBBxT+CW/uBqZt1008hC0HZlhCEHss3VOoGquY/HahpsfwCFp+P5GBQCZZnh+VacUnzveYXTiZ5sZXH/AzMaR8kIfYTEZvk8L3BudPqMg66JKcGFLHL4RaJYhWHNQAR57eMi4XCSKslpWEyTZ3HENY67aN96k+X4Ln+ifTywdGJV0V9WSZDPnoEuJ9K/FH35VSV4F1G5ZUu2J+AXJK2JYM1DdGVFVbQmGmojVaD0/FIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=HrDrQNTFv1FdsbtyvA8O/VSWZb+S6/Z3FfMSwseKjSXy7+k+KGz42PdOnmYLbtYWgSSDGfh+bGgi30L6bPbNuwgcayOARXFVP6nW+96Gr0o6tBHBVYqcf82MKBq3swmffPBsbBkLwMHf3yMjzo/Kr80XCAtPWcRd8kgvqr++zDRFGasChDD+PZbb3FmN9TV+09VZT+lli4QBqfQj5LL4NZqteWCc0q28o8VbOkvODLChX/HjE7J/6QnFeTPKl7uN8PkLVwSfttS7hK/agK0FJXpr7n8XZxruPsfIl1Yozl1kVrtR9LL25EouxnnMkdfLWvHORtW5Aq+sYw8fWWyR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=x7LG7sKgjsGS2WqMbVchgLVqkh4Pgg75y/z8GDPXihufXyJltSTh7t6s68zFjt2E68Vb2BwCacgSoLzQc3ujFa62nZhuq9ThXWuok3C7DBrHQtogWCPYdueQgnnxQqCJq+9QH/eWlmUIsFHPpMKZe5ikFXLe96s9SGTYfqI/89g=
Received: from SN7PR18CA0020.namprd18.prod.outlook.com (2603:10b6:806:f3::14)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:50:26 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:806:f3:cafe::c7) by SN7PR18CA0020.outlook.office365.com
 (2603:10b6:806:f3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.29 via Frontend
 Transport; Thu, 18 Apr 2024 19:50:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:50:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:50:25 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 05/26] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Thu, 18 Apr 2024 14:41:12 -0500
Message-ID: <20240418194133.1452059-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: 897adf2a-ee80-4d0a-1011-08dc5fe0cadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OW7aQOfvhoXJmRIv0De1SA9xPgnn5IYqo/Szg8kFVim5ScplZpG/Xjs7SpVYEJYQP6SJpIAm0dbSs+MlpFSn5rOkdI/NtJDAe427Leq29mvjuMrSO8lYTU96+TVYOKkKc779W4Rk3xEzotj+H8udh42o5e4pK/l+cNIeYiW1Sa2IzL16RWbMBH0xGdNU/P6hXYuTck6V+VXMXZdD29lbNygAFu2yG/Xqi6amyFco/xETr4GBTsP3KWrS0uHhNDcTV7vgz34HTYj3mytQT/GveionJxJ+5Vkaplj6WaQPfs0UaLTfVtn9C8bwyZjzBAWFMNL+/XgWozOyC3//NPdOjLFJvraOvZrXZiI/1EBla/cueapYraSbfRDhE1oKe545GO0C6zTGV3wp1anQx6/x+5SO2vhjDBjRzwYaK+yiXgUMWiNB/HCDNvwueKH2YVP6NZ8oZS/MWUY0AQzH8LgfHt8EIborR8HgQXV5DDJbnK6U5yKFvH96ZSHG4XebPWzsjb9zPVdP4KRXjgYbHiNXasnj0eTv4Sg6tE8XcqwzdjvP+YruaD9SHli7OCTry2Zi8ySVs6on47FryYb4mtcBUbtQcm1PBxuPAipdOx4DGZyCzYJm66YDvPV1HshDtm2WcIY1AcHvT/YqoIXJQwNoYekQhTEiBHu9vQp6itwJIKF7bklZzslQ4SscEqJNdF2KcjRqO3WK7AdKx+vPvOMsb35CwvZ6mvuGX0aLoPCtLf1r305n6FE5/m6hFHWWLkj8
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:50:25.9809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 897adf2a-ee80-4d0a-1011-08dc5fe0cadb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120

SEV-SNP relies on private memory support to run guests, so make sure to
enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM config
option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d64fb2b3eb69..5e72faca4e8f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -136,6 +136,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


