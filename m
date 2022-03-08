Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563204D0EBB
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbiCHElG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237826AbiCHElD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796982C647;
        Mon,  7 Mar 2022 20:40:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8Rd+KqvZK/E1JCyGUW5GTk/nyoyEx3qzaoWB+abGKIRJdk7ITXidEvpjEnTFlJcFUuUIxdBOIrJeCwRmxQ0lKHVx1CU1jiT0muhrcgGLu4M/tx9Tgvws+T0mt8JkKsOUdEIA6H4aRQcMAs5gssA5Q5XTLfpaZZJlTrHamGEsHMWQ+d2t4FteIrgwqq/+wq6jZMeytsYJ/4w5F4F15zccO8YLuyY5wDEKFweyFwq3G3qirdbfvJZBjLdUNuiYR+lCcf0IdfuQ+T2LLwaiQQbN9iSVM384BVy7wm2bilKPjf5qrMmL0fYsUZ2EBMlYQsOBExrGuwZYTIT1tAhvA+mwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRSWIaFdDxHjtWTmisJOX4D/9oQ5CZLyTd69G0sOm+A=;
 b=gaCfo3CDkiVpMkGRB0BU2PPyjaemu4yHmyjUmoxJBRIgKBlF/EDn4fSKc4EPzN+0V82VePQKk8lu3XAJlX/I5bT2d1hARqzxCZNcXiDXXOoE0FfrWjdMQwHmz0+jI41Xk1AVfZsZsLlb77jeoeieVL72qEA4T2Hn/Alb8opnQd7eu/v25NGJgau0w3DErdwhgjiaL9bAYo31/5aPtmoo20B43JR8rfx+mKOmsTq+FWePxPL4E4J0gb8FmhTcXgDKZTV2Stsb9Ilftr8vY1gVVClf3YM6qJkYEOPE1BOIIn57AOXapMcbxto1pg+7xRripfo02bwpAPQzcIg33E6LHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRSWIaFdDxHjtWTmisJOX4D/9oQ5CZLyTd69G0sOm+A=;
 b=ox4hJhVMoo3+CiDwOV7UpLbgcbyRnYJmtsP3cesQohzIL+1YZN1lJzGX2YRXvtnlyhuWjx24+VxONy4yylD4hVRUd/44JttVkev0YVK6TIuvdqip5sW/Pd7YyXwnRFi/3GbnkF24PksaBbkeoPFY+m/r9lqlAN6QYEtsn1PmPj8=
Received: from DM5PR20CA0013.namprd20.prod.outlook.com (2603:10b6:3:93::23) by
 MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 04:40:03 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::cc) by DM5PR20CA0013.outlook.office365.com
 (2603:10b6:3:93::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:03 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:39:56 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Date:   Tue, 8 Mar 2022 10:08:48 +0530
Message-ID: <20220308043857.13652-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45450a2f-f7b5-4276-162b-08da00bdb62e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1310:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13109C187F4F12D74BAAF440E2099@MWHPR12MB1310.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6C8L4sYazcdC8TsiIgVUv9C7c9EtL9vGSAC+tlYmirNiQfKoL0gR9xn+rbC2BepWB4o+CYxzocjPef7QD3+PGVclEiz6i2K/3s9yqlc8V65gYxlqutCiFUiv5nRb5omCElNrn9UPLlDFwJkTkeqCYFlElKi4fIJCnr8kM067BtB//NFBDWPSTZ2y8HB/VehMqukxffCCAcGx7KvDAhc6EgO+0QAhoD9WSxpk4/qMjviOSqq/9jz3B5oFkuqKU4W+Osi10NfYde+p64zF7NXlqBdZrqeaouvMEWH1MEd4kiV0N6Eu8IuZQAKC6Hui0FyNMnLjWD+Jda87d5sW8lKa2sZVIWyf3+5iMbGbfzzGoSZ20zT+XGVge83ZTToX9dsR5fCw4W9eyGSxrTv8Mxk6T02GQ1GPbS8lO5XYKlokZaTxmU7js8PPriAa5dt64nrvFARipp0os/nej50qhbio4/il5poWjInla3EJKP+lUWSM2w++lc3+swa2WnG00+g4Qw8fbqJMBFyNBVfGASvlKjJAoL/64UImqMrGGj6ZKlIrlZPzH5TpY8tgs239cWCJzXoev1CgPiaMfqi/PAlMfH/haPXYT/Mjrub4a9LBEkMjTvqyGpBMNYarbLUA7w+tc7Gl9hc+mwvSUp43bC4Fd6WeD9E7Pizbz8UIHIXuiYMUGYtvc4KaJajAH9YOHQ3oTBPmIXwE3PcCzHPdkTeOlesNY20AoB3lFswdB/RfD1nvgrc5rX79+HNnD9rB/X0RkokpF7OM0yNJJZA+LvYpBRxi4fbxmm/txLB7RpTJQ0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(36860700001)(40460700003)(36756003)(186003)(336012)(47076005)(16526019)(426003)(2906002)(1076003)(2616005)(54906003)(83380400001)(316002)(6916009)(5660300002)(7416002)(966005)(356005)(8936002)(508600001)(81166007)(82310400004)(70586007)(70206006)(7696005)(8676002)(4326008)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:03.0545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45450a2f-f7b5-4276-162b-08da00bdb62e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1310
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a follow-up to the RFC implementation [1] that incorporates
review feedback and bug fixes. See the "RFC v1" section below for a 
list of changes.

SEV guest requires the guest's pages to be pinned in host physical
memory as migration of encrypted pages is not supported. The memory
encryption scheme uses the physical address of the memory being
encrypted. If guest pages are moved by the host, content decrypted in
the guest would be incorrect thereby corrupting guest's memory.

For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
encrypted and when the guest is done using those pages. Hypervisor
should treat all the guest pages as encrypted until they are 
deallocated or the guest is destroyed.

While provision a pfn, make KVM aware that guest pages need to be 
pinned for long-term and use appropriate pin_user_pages API for these
special encrypted memory regions. KVM takes the first reference and
holds it until a mapping is done. Take an extra reference before KVM
releases the pfn. 

Actual pinning management is handled by vendor code via new
kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
demand. Metadata of the pinning is stored in architecture specific
memslot area. During the memslot freeing path and deallocation path
guest pages are unpinned.

Guest boot time comparison:
+---------------+----------------+-------------------+
| Guest Memory  |   baseline     |  Demand Pinning + |
| Size (GB)     | v5.17-rc6(secs)| v5.17-rc6(secs)   |
+---------------+----------------+-------------------+
|      4        |     6.16       |      5.71         |
+---------------+----------------+-------------------+
|     16        |     7.38       |      5.91         |
+---------------+----------------+-------------------+
|     64        |    12.17       |      6.16         |
+---------------+----------------+-------------------+
|    128        |    18.20       |      6.50         |
+---------------+----------------+-------------------+
|    192        |    24.56       |      6.80         |
+---------------+----------------+-------------------+


Changelog:
RFC v1:
* Use pin_user_pages API with FOLL_LONGTERM flag for pinning the 
  encrypted guest pages. [David Hildenbrand]
* Use new api kvm_for_each_memslot_in_hva_range to walk the memslot.
  [Maciej S. Szmigiero]
* Maintain the non-mmu pinned memory and free them on destruction.
  [Peter Gonda]
* Handle non-mmu pinned memory for intra host migration. [Peter Gonda]
* Add the missing RLIMIT_MEMLOCK check. [David Hildenbrand]
* Use pin_user_pages API for long term pinning of pages.
  [David Hildenbrand]
* Flush the page before releasing it to the host system.
  [Mingwei Zhang]

[1] https://lore.kernel.org/kvm/20220118110621.62462-1-nikunj@amd.com/

Nikunj A Dadhania (7):
  KVM: Introduce pinning flag to hva_to_pfn*
  KVM: x86/mmu: Move hugepage adjust to direct_page_fault
  KVM: x86/mmu: Add hook to pin PFNs on demand in MMU
  KVM: SVM: Add pinning metadata in the arch memslot
  KVM: SVM: Implement demand page pinning
  KVM: SEV: Carve out routine for allocation of pages
  KVM: Move kvm_for_each_memslot_in_hva_range() to be used in SVM

Sean Christopherson (2):
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV/TDX
  KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |  10 +
 arch/x86/kvm/mmu.h                 |   3 +
 arch/x86/kvm/mmu/mmu.c             |  57 +++-
 arch/x86/kvm/mmu/tdp_mmu.c         |   2 -
 arch/x86/kvm/svm/sev.c             | 531 ++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c             |   4 +
 arch/x86/kvm/svm/svm.h             |  12 +-
 arch/x86/kvm/x86.c                 |  11 +-
 include/linux/kvm_host.h           |  12 +
 virt/kvm/kvm_main.c                |  69 ++--
 virt/kvm/kvm_mm.h                  |   2 +-
 virt/kvm/pfncache.c                |   2 +-
 13 files changed, 556 insertions(+), 162 deletions(-)

-- 
2.32.0

