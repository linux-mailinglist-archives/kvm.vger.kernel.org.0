Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B10347E0A
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhCXQpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:07 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236560AbhCXQot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRJzWC+w9xuXWdv+o8spWmM+GBwtmOlh3XLBc24FjfTpZ9XH//jsxNmnvnyAbsdv+hYIwmAd5hB70uTorbx2jT5TxmUy0q/2UaJhuTclC1uSI0JL03uGEXtfHxKhbGndvnlrpyAdQNUMy2HePJqoDgVQyudqMvdfeEAqc6JeiE6IDvL4uLf/eWTDtVsT7dl92htabrCCrcqcs2M1HtHVo8S5TdVELDfWRaMzqyjZIBsukJTJi/7YopoEQ5nmEyNWb3j1xmqTRM09DuNYwm/Ig0nZ/t9SnS7Q10CvqmUab1qBb5u4ECoZudkhgvDg5sZNiDRCxbY2Oa7qZKesKN+gKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk7YGh1gNz++rpOVyhPm3IGG/wga63VPTqGGNnLuMXQ=;
 b=iRd6OAy5F2eldw8jd7UDqwVJCqNZ0K+bWDx2pssAjYk2YiFdyf2qhECH9ITl2zqHJ6ZjFoztFHav34nIMP1l8+AQ9edJ37MGEg/mNVyRz92BuMiJr3zcW1/qtTDc14FMyJHZpfIcoQXt7RXVvgCQpfIP0zQxktAMHrHRWeI4fkZTBS3xSlK/1oP7btvDtB7FeSHwyxWOPITfNSQy1sxpLrtyi6aTx9kMbXrctPhiv/pqcszrH9mt4nepCXSc3dgnWr3V55qy3pxK+2/DzG0MP9ulQIK85RdrB2QgLAJMIkXAf2WDwKvxbVWwjf88t345utOQXm+N+hmI98sC566WwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk7YGh1gNz++rpOVyhPm3IGG/wga63VPTqGGNnLuMXQ=;
 b=sqNodnwtFJQ9ueUlv8TYQZwn/9B8dcuQLbZpNUbadawG9GldtPEyPUKosRkh1PyvD34GqZDVC/fWmSB1AJeLfFGuawqGiK26vrUSRGBG7kpIi4s2vCvO2Q1ZINUOWysNJtKtd1FLqIDxSWs/7Vd7Bj23ejtSm7Wr550hEO/XA5A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:45 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 10/13] X86: kernel: make the bss.decrypted section shared in RMP table
Date:   Wed, 24 Mar 2021 11:44:21 -0500
Message-Id: <20210324164424.28124-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fed62fe7-75a8-436b-37f7-08d8eee4217f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446D3D06F760AC15E3213FEE5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDGUdJP0FfOsps35D1aVeqoanuPUQ+9Xxdurja8LxG0YoaR7bYm9VA58kPGx3rDKoDLeqVnUSwCzE0NP+9b6Wmq6wueUnzNp/sYUZd5ZPwh5+uRxSR6ynKsUk0ENQ/CPQGZYrUwSBjgfPA7NvfCL9FoUfe6OUlTq4zkjTgnSfum2MV9RYrgoU8CQaCcoYd5hDiMmV+aIWdGZyAqWpxCV6WlHwljdNueo+IeXvds1m5cEZjK9EmMINxx7YBxL4x9BG7Xu/2nAcxRuNfV0UJm9b0FKjrFTO/ltX+qHnSeQTYawZjQ86hjRnk2C+y//zDvT73otkxjTJUvIo9xtGh8DKrvLV1VsbUUXbTFYoZuk7fia+2zxPesCVvZPuRWqnQqKsfxusc3/fJW6rAnaY4zedMIUDSMl5hn9+C0fOcxUikczZNMWYOr/K2uMzgrjezHx6rmuKfLv6UfQbexTuMmpZgF0rQvTa7bDcasYH9q44LDpWDL8NebcqMx6yIyyFEouYOyAms88eMlTfPfPzT48V/uGAihaodj27iAUpqnMxJjyNCHwUTFNDD8Zle7CdZYu5JtmPjajWG44unu3xOP8QEZMAdXHUb1KnmH92mATwBGPx9eepnCY2sHvoif2gvRUnD/Jb3mOGjJJdQQZ1Xg48wKStpdN3kcKs+trppnV9xc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MI4cBYFwRdtsOvBjanKVDcCx4D6fZoA2Op7Lvk8IwWMPS3S24R/bJDHW6Jev?=
 =?us-ascii?Q?ef3Qk9/H+hbKRlgXUtU1Gvb8p2jUfde/ZaTux3t8vrsT2J7Q42vHWk0dj0Fh?=
 =?us-ascii?Q?ZJ5sGMvaJB8TTDjgogqg1Yjb/SwCytmbyoC2xWmOw0Dv7QwdPfntpf1d0jef?=
 =?us-ascii?Q?adG2BaSiaqZIYlow5gMaA4KO/xdp3G6RqTYql798f2BRybnIbw/e2tw1T1nZ?=
 =?us-ascii?Q?4fcGLtVtmpwlErapanPE9x4nmbXw0tjRsWebB2akIq6qSk8nMfcHR7Y/gcxY?=
 =?us-ascii?Q?WiE2FbEbrBOp0mKkptCOSGCaxtPIekONPq4kWp2Sg5Qi+oPgH3UwFSJ6AV4n?=
 =?us-ascii?Q?MMAoxxpbmoH8JmnNEm+5lgUitlF5+DyTPCmBPl5TUfYQa0qukTkrECYW2Ow6?=
 =?us-ascii?Q?O6BXfBno5LJvCwWO6vy+rj7qbr41j9ZRHjaIyMi06u4SFJLFLdQYe3ZGcFPe?=
 =?us-ascii?Q?xa+XleRkqmZydKs9SVcywsGwu1LShFFQZyAUXmxf3H+AhbR2Ue8pb8U5SSLF?=
 =?us-ascii?Q?SZUcEmh13g1Q0wmkFEhbY1tJiTfiaQXo1JqlEzTWzPBOi77oE3Kschq2+6yU?=
 =?us-ascii?Q?zCbi/BRMKPkdGdWNtjcocH8p5AXO8oXZOW4C7eeYdJ5PdfV8neNu4ICKg65I?=
 =?us-ascii?Q?N6H2ac+C93kCz5hB2n4XN+HJNwbOufiMAXdJ33YnNHFIjnlBYlgNuQ12o4Zc?=
 =?us-ascii?Q?1PU3TK64MR5cH389+bSSgXom2dHsvRoDZxTA8q4Q5GFIQWJ/6YdzTKc8ShUB?=
 =?us-ascii?Q?Pzeupk+d+vm4gC6WMJM2b1Ewq7CVTpZaXjKY8bQQIMdKJt1K5QCUraAE4bYy?=
 =?us-ascii?Q?wBjXw6AYRb19D7SVut49hYP96UIbOrLRyoieln1B7bwKqdZ11Tqw3vhILsxK?=
 =?us-ascii?Q?2jlmxiUHyjQPGwwHmEbxS52LuP3mAE3vSbcgiu+1HeU2bfuV8Z6OctXduyJy?=
 =?us-ascii?Q?QsEqIaLxrHBNmqYlN2P8ym+hdrERFZFBYZ1TWzTTP30vSF0Jd5knpKhjavMW?=
 =?us-ascii?Q?s7EAywLTcNOA01M5L1i/KfvEubCREqchzlgSjcDBAzXHzraVFRahurYKq74B?=
 =?us-ascii?Q?KdzGazkRD6ftw4t11t+78If1T8M+65daTY+GTC53+nwL5Ruo/u6gtEVdAiuh?=
 =?us-ascii?Q?Gv64+2ijlhXXkOvf9l5Xu2j2WlPhCKt9EcuZ+vTiTjzygm/GafqFPMUoqR/T?=
 =?us-ascii?Q?EzsMP73G5pDIkz1FOr611DMCEjS2p3hQkUDCos4PkcgFe+TFO04L8SF0vLIt?=
 =?us-ascii?Q?GJmAlkrEobVHrFL/YkIRs8fJJtNZWYubwd0drBXJDJrfZ4q9ineQHnXLSD+s?=
 =?us-ascii?Q?2bRUsBSeGh7TW9mMyBIFo4an?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed62fe7-75a8-436b-37f7-08d8eee4217f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:45.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDyuhT8psoVP1am/plLuJy2KaBgefvLNb+vZXdiLaWlK1xDc7ZwiEj8/jIp0TrLJLewgScltI0felDmKYdvBmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The encryption attribute for the bss.decrypted region is cleared in the
initial page table build. This is because the section contains the data
that need to be shared between the guest and the hypervisor.

When SEV-SNP is active, just clearing the encryption attribute in the
page table is not enough. We also need to make the page shared in the
RMP table.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/head64.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5e9beb77cafd..1bf005d38ebc 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -40,6 +40,7 @@
 #include <asm/extable.h>
 #include <asm/trapnr.h>
 #include <asm/sev-es.h>
+#include <asm/sev-snp.h>
 
 /*
  * Manage page tables very early on.
@@ -288,6 +289,19 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	if (mem_encrypt_active()) {
 		vaddr = (unsigned long)__start_bss_decrypted;
 		vaddr_end = (unsigned long)__end_bss_decrypted;
+
+		/*
+		 * The bss.decrypted region is mapped decrypted in the initial page table.
+		 * If SEV-SNP is active then transition the page to shared in the RMP table
+		 * so that it is consistent with the page table attribute change below.
+		 */
+		if (sev_snp_active()) {
+			unsigned long npages;
+
+			npages = PAGE_ALIGN(vaddr_end - vaddr) >> PAGE_SHIFT;
+			early_snp_set_memory_shared(__pa(vaddr), __pa(vaddr), npages);
+		}
+
 		for (; vaddr < vaddr_end; vaddr += PMD_SIZE) {
 			i = pmd_index(vaddr);
 			pmd[i] -= sme_get_me_mask();
-- 
2.17.1

