Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612DF3F5CC5
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhHXLEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:04:38 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:15273
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236421AbhHXLEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE8U23HbkmtvGSque4wwquZn2n3LLfi6odDg17YPqFd0x8/f+DDueQVGJE8uZiBUMqv5Pcpj7xdUB6BrwZFHZ1RCde+KT0K5YpqCQlY+2+3mIDPtHI7oRRruQN3eSWAkIvOWaXkuhEwgJzHxYI47SzD+t4yrD0acxwnGl16k4pamOdLl4PRPnxaWJvtn063Zc+5vlu8w2ONOct+peID16brvnN8VvC32pWFUXno2pQZMd1QeZyxktqjNjbJnbKzFS4vU2nHoCtlJbDiIXdoIX7u7c/YCh6YKr31Xsfb4RdXZ7f0jVAf46ekyI7d47em7NyrpBDvmpzC9qcG10VXang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REgg/qvo15B7vy3kDfXU1VugLAQyA6syxIErlJu18yU=;
 b=hIfNjgURAtgq7gRPN8tJZXIYJ2ITLAQDyYy6zt8F2FanjWl73ulodz9OH5B21pm+OVCkDpSZvYZLrVd37OpMFhzSuvQkriIqb35SwQ8ifJA4M6f61co3DCpxKA/+nbPPDjjSLVFT5KekRez42pS7XjRPmyjOXB4xVdy+TmUVuVpCON9soi3rDdXLJM8zS1chSGwRrCZjPt9JaErs66bPd8yCMOUL+iBTEPg6Vpkd2Hg1j29qjCEo/20jXXGH4Q8nPkIysASB0hnKEU3bBhVZPQDaVjHqNR1C5IGsy1qBK9jy58OcYPVuC8PoxDzX3GbWVGG3OLlgupW/28KvsZiPbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REgg/qvo15B7vy3kDfXU1VugLAQyA6syxIErlJu18yU=;
 b=r+h1l4itFvFg+WXIglIB0EowLv8T6k+Euhff0xP/SFB1Z7M9irczABjjs9lLvb7/lCHjlVfXtJ69bcWhZDlhT5ay1MhrfBX2pB0uePsAEfFJduD7pm+IODvu4cMKJS3Cvz+tOQbeTRQe6lowFaV6OIpJIV0KZTDnWARI9HP7pUA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2544.namprd12.prod.outlook.com (2603:10b6:802:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:03:51 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 11:03:51 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: [PATCH v6 0/5] Add Guest API & Guest Kernel support for SEV live migration.
Date:   Tue, 24 Aug 2021 11:03:38 +0000
Message-Id: <cover.1629726117.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0056.namprd02.prod.outlook.com
 (2603:10b6:803:20::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0056.namprd02.prod.outlook.com (2603:10b6:803:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 11:03:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe250b1-e7c5-46c0-a3b3-08d966eedae6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25447637809307C0C95FF9CB8EC59@SN1PR12MB2544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7cdm+HHuhyZpFX87KFiG5nbgtmcUCXystUt6Qzb5t8/5alE6MvpyUi08pH7Ce34tKirrcG9IDWgwU/6A9JsYDntvKxeIWKQgzRPrmWacQiixxKQN3iwxu5CxTwFnEB6BNgPvk8XJVJJExd8+I5S5tNFCGoMtRziAhaT4MNigF0rwveCi6G92wphRcp2COdMKeDg3PhT9vjmliJ/VMSdEjSVhYHctwGbn+mlNyyK48yVMNQseil1JkP8Axn7J4mhaSt9QJmQHCh4MG2kS/KM5eU5SuJLDht3Cj73sV+aFmZgLDwdqXElSXzKSjKBET2VudaMYCI4dTz9akkclMgbrepjjMaDg8syXpTmhG+Gr96lA1lOhTMxi94kJ/LHu4CfoEO3GrCrIQGIfTWABlBfASQZWonH2FpBkPmo40TSAikDfeUjj3Pc73PqzC+xblBZcMYKd9EIh9c7FhNTH8W07wYqIglp3OTlhjcmB4elud1XeFUkNF1pjI/R0uJd0imHHVie9NN3172cDoXaPhvK3/VXsB11XWHm/rlf5+7FoICODCJ5JlbgNxCuRocTLDloNMsOgeVhA+aHGrzOxoZhwIC2iddC0OnibXQGt4XBB3dT7vAbEmuNP2mSCJ6+laJ11OYjs7fQh1Z3MXEJGFx/2FISCPPK/U7d8pkSNhbPvpdRHaA28+PPmL8zNAWPFkgnn5cMoraP4yRMvG9ClZ5MAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(36756003)(83380400001)(2906002)(6666004)(6916009)(956004)(86362001)(66476007)(5660300002)(52116002)(8936002)(26005)(2616005)(7696005)(66946007)(478600001)(38350700002)(38100700002)(6486002)(186003)(4326008)(316002)(8676002)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QQ2eoLXApe/yU7pQa30jTuAPwZW0UCiQeacyiwEidnnYAcycaSnRQZ9K4FAr?=
 =?us-ascii?Q?pYKv5VL5EWGKJYqX8M7jlFfDUqf3EF6GYCERPhKW8xWANbliHvpfC5te8gir?=
 =?us-ascii?Q?n3TP4vz3tMmHaNPE4YXzTfTqqwpZXm12DN7rNfb+qzNFAazCF2a7p5OHmbwo?=
 =?us-ascii?Q?gVMSDXLlls2AvCE8hPoJW1wd19vGqKesejoJOsCv2tLaUWbWaKiC9y9+kC+Z?=
 =?us-ascii?Q?V8k5ceDjaBsg9icjPiuMUakkqSMFicmEOJGWhCihWCw8m0R5hf4OtQ4AdUoS?=
 =?us-ascii?Q?kI+8ulgc39T8Jr57l19r06qLwo6xhih1bry9X6gfTzGsmCBjOVyQ+owdlimQ?=
 =?us-ascii?Q?E77fb1LrH2eZt2QAPZDMsai8UIhoCmn0tAnjq0eY7Kul9u6SlmXe83QU34kk?=
 =?us-ascii?Q?UUmA+iuIvxIMpXBMFxRI1TU8tzzqoRC8yFhT57yRH0QalSoG23DFGcTmsxh4?=
 =?us-ascii?Q?EAWDnA/ATO1zXFfPI8Rhax8391gHdIZE6qcWfKG8QLI6/dC9oPyxjxgzVXhI?=
 =?us-ascii?Q?l/40y9ddcXqsX+9eQf75GUEJ6mtOCOZ0vMtTbZbm8D4NTuJO6rT1hiEuv/Cz?=
 =?us-ascii?Q?4lmchKnY5QMWuJ5nsnnq/sAoj+yaTnAJuvv+hIVPOsIHY6y3ZedPdatkwPH8?=
 =?us-ascii?Q?Z0W0PJPZ2yZM7Ce0XD+9w8pXtBojSZpka3W9Mo3T2soA1xAdOf2VOUVju6By?=
 =?us-ascii?Q?pBe8x+yCRCWWQJ2qg9Qo91Yyz31YNRhN+xZ/w4FtnLu3XCeAa7PZOmtRlK+/?=
 =?us-ascii?Q?xr94o5Ojst5mTNpBBg+fk51cOl0yQPBVY5hDnB0brgsamN2qhqkqskcDi2GP?=
 =?us-ascii?Q?thZdLF2puxSXDV2Yn7qvsBABmTJzUz1zu/ZHeY3wwxkXXntnOYzVOSbETlkZ?=
 =?us-ascii?Q?yU+Ux4gYzbTByx+Fw0WPir/F4f94iznk6x5TjAqtUH/tYo4RC55i9uWKEKuu?=
 =?us-ascii?Q?CQqNyvNyImlWeUwsfRX8vwZRYcd9kbfLYZ6GWWsHow4vMSuAYbM5q4n58yZB?=
 =?us-ascii?Q?pnv+AaYGdPg5yz3riJCTwWX3Ipeub3hTBgZGGqO4KvD8kzKWyu1OU9dV4cxd?=
 =?us-ascii?Q?jYlTw9BEJJR8/Boo2BJPnsKlumPpVl/8sMZGJhPLJ8pIJz3f/WlIQ0b41Fpt?=
 =?us-ascii?Q?vFfNm/j8eIZni3OOChJ0zjLVZ6IA6OMc6JcewDG0WRwKECwwU1LLGjO+970R?=
 =?us-ascii?Q?X4Ecxe7ZPdMi8ZcMofU6iq8no1Ntw5xHTdOnq9GznXDGPOF1ycIPSq6wbMFa?=
 =?us-ascii?Q?ySece5125+WrLQ6E3A1Psl9oBILqvbuaBTlBV4TKFM9muA0C6UJXJ3gP1kDe?=
 =?us-ascii?Q?IZUlgN+WlxV18ibVRUwZyNoG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe250b1-e7c5-46c0-a3b3-08d966eedae6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:03:51.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iz0TyHgqybTKev9eu8J+iLhtsHJ46XaxFewf+YQYgh3i1eQFlCp2NWESbqaWaRPIA2+FqzRq0wZt7JVlpt567g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2544
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The series adds guest api and guest kernel support for SEV live migration.

The patch series introduces a new hypercall. The guest OS can use this
hypercall to notify the page encryption status. If the page is encrypted
with guest specific-key then we use SEV command during the migration.
If page is not encrypted then fallback to default. This new hypercall
is invoked using paravirt_ops.

This section descibes how the SEV live migration feature is negotiated
between the host and guest, the host indicates this feature support via 
KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
sets a UEFI enviroment variable indicating OVMF support for live
migration, the guest kernel also detects the host support for this
feature via cpuid and in case of an EFI boot verifies if OVMF also
supports this feature by getting the UEFI enviroment variable and if it
set then enables live migration feature on host by writing to a custom
MSR, if not booted under EFI, then it simply enables the feature by
again writing to the custom MSR.

Changes since v5:
 - Add detailed comments and explanation why SEV hypercalls need to
   be made before apply_alternative() and how adding kvm_sev_hypercall3()
   function is abstracted using the early_set_memory_XX() interfaces
   invoking the paravirt_ops (pv_ops).
 - Reverting to the earlier kvm_sev_hypercall3() interface after
   feedback from Sean that inversion of KVM_HYPERCALL to VMMCALL
   is causing issues and not going to work.

Changes since v4:
 - Split the guest kernel support for SEV live migration and kexec support
   for live migration into separate patches.

Changes since v3:
 - Add Code style fixes as per review from Boris.

Changes since v2:
 - Add guest api patch to this patchset.
 - Replace KVM_HC_PAGE_ENC_STATUS hypercall with the more generic
   KVM_HC_MAP_GPA_RANGE hypercall.
 - Add WARN_ONCE() messages if address lookup fails during kernel
   page table walk while issuing KVM_HC_MAP_GPA_RANGE hypercall.

Changes since v1:
 - Avoid having an SEV specific variant of kvm_hypercall3() and instead
   invert the default to VMMCALL.

Ashish Kalra (4):
  KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall
  KVM: x86: invert KVM_HYPERCALL to default to VMMCALL
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.

Ashish Kalra (3):
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.
  x86/kvm: Add kexec support for SEV Live Migration.

Brijesh Singh (2):
  x86/kvm: Add AMD SEV specific Hypercall3
  mm: x86: Invoke hypercall when page encryption status is changed

 arch/x86/include/asm/kvm_para.h       |  12 +++
 arch/x86/include/asm/mem_encrypt.h    |   4 +
 arch/x86/include/asm/paravirt.h       |   6 ++
 arch/x86/include/asm/paravirt_types.h |   1 +
 arch/x86/include/asm/set_memory.h     |   1 +
 arch/x86/kernel/kvm.c                 | 107 ++++++++++++++++++++++++++
 arch/x86/kernel/paravirt.c            |   1 +
 arch/x86/mm/mem_encrypt.c             |  72 ++++++++++++++---
 arch/x86/mm/pat/set_memory.c          |   6 ++
 include/linux/efi.h                   |   1 +
 10 files changed, 202 insertions(+), 9 deletions(-)

-- 
2.17.1

