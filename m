Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321F649243E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiARLGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:06:53 -0500
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:17036
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238467AbiARLGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:06:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8ucB/q0xIRdNcq61b0okoSIDz4cC6qaYr3/GPun3hiJMDoAW5M+z1LsvBppObpr+I7N25/nj8LWptbKf9UevezosgFPZj9SBzazGdPwO8rCopanURArGFpTrdlSLeSMMCVW26MmQzzW1CpY0B/6E3nlWyHt7ILzNCjnpcRWvcmjURMXQbwJnkjNGXIWpu27YMrkuYRaqBON8RkPZYPtz5pbttHrDuWizdSDIABE4Z7uakVquWLjWn8pnsj67+4AL7zIGggsEoU14K63BqA7y+8zNg7eqClbwZKcQxeP9lyCl6YNeCl4YTbFB9UkR400biWQrcRGgWb4PMnkhC/B3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cnsaWB5zBna2H46/nY9T+x59sv4GSJ27EDkRkj4UYg=;
 b=SfAgFT+Orpnp0qZZ7f2GIhDawjQ01yn9ES8vkyWvBIzFSMz/yojhQ8RTCMlH2Pz83hQcn4L6REFCS1vJEPcv2BUTvAqAC4PDHHnTzMUQ1CaZTSYKE8qKh3mdVApti0NxOtCDilBJ6INkKgU2ERorkW5mzgFg1LW0O6Cme2ObiI7cVyJmCm09TmbO509Jiihfb6GArWlBgLmK1LdMKz8bi1qezcIZEnN05BvgxDjiYm8DWwrJ79r/Ei4nVnopvYfrvtI703ZcAjncYOKy1Rse4hk5gkxanJdtCXZBokKfgVFQSw8GBYGMVFkVNh8MmcJ/NTf3a00XmAD6mzIUoiJxbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cnsaWB5zBna2H46/nY9T+x59sv4GSJ27EDkRkj4UYg=;
 b=VDgrHdwIN2yshnszy7paaPQGEjq1YYgY0FNTiOy5RllA8MMKwVoIdW28uZRo0xX5S+F5ayRqNrUDuIYKx3yGlrrilw1YCOY6b2q3gC8mqcYHt27n/pfLsoCFDQtgADOwZhYx6XSifHvvxBFdlRPRS4wNK3yuHOZSg/mp6XYKPeI=
Received: from CO1PR15CA0071.namprd15.prod.outlook.com (2603:10b6:101:20::15)
 by CY4PR12MB1173.namprd12.prod.outlook.com (2603:10b6:903:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 11:06:50 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::36) by CO1PR15CA0071.outlook.office365.com
 (2603:10b6:101:20::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Tue, 18 Jan 2022 11:06:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:06:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:06:40 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [RFC PATCH 0/6] KVM: SVM: Defer page pinning for SEV guests
Date:   Tue, 18 Jan 2022 16:36:15 +0530
Message-ID: <20220118110621.62462-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f36799a7-a3d1-4ed2-95b7-08d9da72a05d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1173:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1173A943A6AE225D5C831064E2589@CY4PR12MB1173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kz1hBfz1nQXTCHX1HX2uat6aqedcRZNokrqmWqaMX8nGjSvEUZ/OJW9AkuEx9YDEyJKMKW2NOG0RLvueM+JDJkxCqZLl5lWzpFL5exvNr2/jofhWg+/tuPaIVwenA+flFhXL06dF9jVDSrqL8j5UxDMLVppYZ2UTACNxylinKRb7EccqyWXR3k9kqMSnKfNWIxrmu37X9CaHACsZE1MsAfRXNzXG9KS5t1ueSxkDaWZGVUfDOOSc6vSQ8uOMKSmtUApvJCH5XTptEAiuYo2I38XnJV3qwY9eO51TNCQOY7k3jRSUofG/X0G0+Q87gDLSsGmyRoUfAKjoJfQSkz6bHhy69Qr89Ep3vle597GQp7yll1Xpmj4QGiAqe3eGRtxsjKrsIcNOtBtYvk/Ox4tNzuBoozbtCg9qe9YsSZlyBQRMWDEOR0qeTHJW/+89g1y52ssisNYl1+Yd2vPH75gW8u9Ta1N+6wbGM4UoGD/oG/6X7BLH/5IwGgkHnGf079MN8F38e1C/snfrmlnyIrdfFm7CuFkuDzWqAU65M7dQGuxnETDlkFBCZzrUN3plgx4BGglqYskHhH15+4nRUUXCehB8QXfiXB4uJmKjoAH1LvbKqIGhBQUOZqBB+8bjDsFW0GiAQAulLwPHhc3ZEek5AmNFBu1geZ0suQzllmlsNgvUrUsz/qaq33IScPP3w5oFgkIikMZ94CvopNHhTvfSBZgqwP1oVu0LDK1NYAWIFe8Mt9LoWi74IVgRB4zrbmOcMRHSA/+O7II70iRtCLWDp3idO9kcU+FBVOe6NKXkObu0Khb3CRu7pLkKTHehudes1pH9agKyafRs6Bzpa5cuGWU4aMDhKTGRKETarkOS064Krje+32Qy/cCVhvAuNMI3
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(186003)(426003)(6916009)(966005)(356005)(47076005)(2906002)(70586007)(54906003)(81166007)(336012)(16526019)(8676002)(4326008)(82310400004)(6666004)(2616005)(83380400001)(36756003)(7696005)(40460700001)(316002)(26005)(8936002)(36860700001)(5660300002)(508600001)(1076003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:06:49.9688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f36799a7-a3d1-4ed2-95b7-08d9da72a05d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV guest requires the guest's pages to be pinned in host physical
memory as migration of encrypted pages is not supported. The memory
encryption scheme uses the physical address of the memory being
encrypted. If guest pages are moved by the host, content decrypted in
the guest would be incorrect thereby corrupting guest's memory.

For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
encrypted and when the guest is done using those pages. Hypervisor
should treat all the guest pages as encrypted until the guest is
destroyed.

Actual pinning management is handled by vendor code via new
kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
demand. Metadata of the pinning is stored in architecture specific
memslot area. During the memslot freeing path guest pages are
unpinned.

Initially started with [1], where the idea was to store the pinning
information using the software bit in the SPTE to track the pinned
page. That is not feasible for the following reason:

The pinned SPTE information gets stored in the shadow pages(SP). The
way current MMU is designed, the full MMU context gets dropped
multiple number of times even when CR0.WP bit gets flipped. Due to
dropping of the MMU context (aka roots), there is a huge amount of SP
alloc/remove churn. Pinned information stored in the SP gets lost
during the dropping of the root and subsequent SP at the child levels.
Without this information making decisions about re-pinnning page or
unpinning during the guest shutdown will not be possible

[1] https://patchwork.kernel.org/project/kvm/cover/20200731212323.21746-1-sean.j.christopherson@intel.com/ 

Nikunj A Dadhania (4):
  KVM: x86/mmu: Add hook to pin PFNs on demand in MMU
  KVM: SVM: Add pinning metadata in the arch memslot
  KVM: SVM: Implement demand page pinning
  KVM: SEV: Carve out routine for allocation of pages

Sean Christopherson (2):
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV/TDX
  KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |   9 +
 arch/x86/kvm/mmu.h                 |   3 +
 arch/x86/kvm/mmu/mmu.c             |  41 +++
 arch/x86/kvm/mmu/tdp_mmu.c         |   7 +
 arch/x86/kvm/svm/sev.c             | 423 +++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c             |   4 +
 arch/x86/kvm/svm/svm.h             |   9 +-
 arch/x86/kvm/x86.c                 |  11 +-
 9 files changed, 359 insertions(+), 151 deletions(-)

-- 
2.32.0

