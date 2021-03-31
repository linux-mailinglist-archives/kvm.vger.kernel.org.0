Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34E0347E7F
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhCXRFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:20 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhCXREx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZvBDWexa5v1FU31308h2/zr4IFm86O3LJEqP8RBSlXFFMLUnrGh+afGguTsD7xsDYtykybN0R1HqLKkxhgwr4U1fTx/ByND+zxDeG3PDWW8dUetynpmpiICV9bDjlSJFRZbKGpVYlF3LuOaBwOvUH73Yubupm/Pnoat3UyzCfk6W/2dC3MvpfRE9koXqciBhoXyxeMd7y93h5xA/JBb0w78jgcwOAZ5r7aAcNU1gBAoZt7UffhDpETXRjHmKhI2BT+MXdLoYCVuqKef0RCe/xv2NfRG0/mzB9Pk6l5WcB/rUoYtq1dN7GCv7rri0j3wXZoIDYvsRMvf9jRoxQPgGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY4mybB65Bwr0RRpP4krujH7j0IBZK10R+a5m3zU3GI=;
 b=ROg2W7ebSLh18QpHv6RHGPCd7I39e363e75Iqbis58felpfkK3OxT+iXP8cOoYmzvKS6GhHhBgpeFM12y1ElIy/wESHd4aTNw8FcV5BAeik46+KdNgxWDL2nhSDkCg5VYHs3n8nG/O+hJEYloVoOwLZyG8JAgGG5nY4eVtKvyKwqIoYiCV+FeLVz2FuskhnZvRNzhza1PNJdeRKej1flGy5mNifaFUNDQFTR0Oy7SdIu9qiWzYMHpXSnKyZiTt8usxcZzCliD7oTBTw/+jy6eOOVVWnemrCmfSqzAOppa39/ncRNdwM5wS6SgHX5iW/VzF2w01MB6tnztPQJKMmiTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY4mybB65Bwr0RRpP4krujH7j0IBZK10R+a5m3zU3GI=;
 b=NlVgVRfPfxbKUyu9e1CCRtSwhtqVhR6bHUQdZNKoModmH1YYHdovZ12/FRz8F0uZSBlmO8c1DCUbWc//hfDqKREYfTEVjSFcIokDYTXHUvHzlKYkHTIBEtPIppKTfPJSyzkWcGUHpWrEPx12WIqXJgQq7mLbXeUzjsiFj0x50xw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:51 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
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
Subject: [RFC Part2 PATCH 00/30] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Wed, 24 Mar 2021 12:04:06 -0500
Message-Id: <20210324170436.31843-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f2a4352-e107-44e8-86e6-08d8eee6eff0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB455728ADB70F9C869342AAA9E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /D2zOBnvASUuAL8Fyu4j1MapxBrSAUmDsQDX/az7qPtt9EhWOAJQdHWopriOWQZ4caltD5k8OJR44MrP90Sqwr0BMppqFY306qKyNdhIv1lCOTKZqwKJFmCrwVp+fqLHotf00CHR7gzUOY+/aJgwZYcoMx8+u+TZ3kSsMk43GJIqWDzuLkom3AcbP3N2+LcvcglgeNIhNfDlu1WcSM93tJyUAnn3HPsuVKxMWOh4Rdngf0QjiprXmIx/E4/V0bhHvd/p9BEO33vKkUVPy0UZCySgILnr6cZMcs4+IML7Tqt+nFtKGIW2mzvllu+pffA2m2u/+fairrRnmEKvjGWEFiKuwoTwj3VrzsTecpmv0kXywdzRnh7okyFVUDt6+8leX80GxftHJto59WmSuNU62vUetR/6rbt8c9GrtA4uqPbPdUBiSNb/5NqkEMrZDpe7T1vY+KNwmLdxLJAL9XiBaFcDa1k6uXaUYlEljG+9RYaJWGxK26jzQyqsFE31GDrLUpcGFz9ZBRwBXNuHFnXfBhp+MQHljM20JELd8qnO+tq/i05qAB7XcPvWkHATqhuwU1J8/xwIAsVdboKXVc7o+UVHfQBetZ4llMjPh59JxiHHbVYtwnLpvfOw9zcQojjJl42hv0ucxCLA5uf3K2O6uHlNp3FnhfRk2eb+hG3C2Zp8KKt/zN5H+nMe+Boze7eaiFkNBz/pzKLk+aAP7V/W04Nw0r2MbdRMml5GwLblmzjDKQBNhLz+Keays7AmuBmTKByjwMENIt6FVxPOlEjzig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(966005)(66946007)(2906002)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8e71MTPzgYzIV2x7gBxkCPPPf8XHH9Zz5bPNL80hCJ5Ei9kA1nI0vg2zk+s3?=
 =?us-ascii?Q?WUqCtBCUWTQpg7mQnoKee5JUs3uxCaa7mX1c0z9fC2DdUDb4uMVoGM4KQwdv?=
 =?us-ascii?Q?bsKkux67Apu6o3oex5e+Muov6l/YDy2Nr2DXNTxH9ijTcKIavvTn803pTb4O?=
 =?us-ascii?Q?nqZowLdX3fV/hyKhDm7mXRPi4aq2YKqVDUj7lJmWW02wJhFJqJC04qKhBNbR?=
 =?us-ascii?Q?3ZlZ4RZgcPdMpEhCSOepFWt+CzVWOi9uRe01QNgpuVFws3frV1bRXnusV4u7?=
 =?us-ascii?Q?1HPbHGZnCZKp68sQcIAAhR10FQymSHAOTkS/C9YNUN+lGMcOMPbV5nNzDQDh?=
 =?us-ascii?Q?UZ1eG60zUoE0a4e2hU2RNveKm7HYrHZB+Ka403o2nDddbLiGL7NXGemDt+Or?=
 =?us-ascii?Q?ce1T2rJ3vS7O43PQzdN9siGFRBIzE4PILVMrc6oz4hnaXFDy3j54yqMG2aZy?=
 =?us-ascii?Q?FipMxSfpO+RqPsBTX5l2W9fNUXLnsnuNIv2H00/PXuMrBjkUBu63uki8aaNY?=
 =?us-ascii?Q?lAYjcpEHYgeu/O/ybIO7Na2ySRxH+jw8Wy45o/T8OMG6/3ej331R4HvZXzMT?=
 =?us-ascii?Q?kttVyKY1BVNbf2sCI+YMJqJ1ou1sfDlHWntNu5ZHhI7TOCDI/9omvyFlsbhU?=
 =?us-ascii?Q?/UqrpuKsvUoJgmGsNeNpx+m+RM+IuH3f2WbYne5gNLzbi1iXKXaQML3nvHK2?=
 =?us-ascii?Q?gpYfYY4CeNvFDvVB91rDNQZY+C8WwLyfh8S+KELSWbTxtb5CwH4hf5e7U7uw?=
 =?us-ascii?Q?FrY8h898EqzHJXQvrS0cRpL8Hn6cltOudoLtkjynN5AAyJk1KOus10EaWHGI?=
 =?us-ascii?Q?TFDjVcGdS43xoFjfxtVC9NlRNy684Ek6wt+iAlJbBw0KPRooIJ29/29+RXgJ?=
 =?us-ascii?Q?FUn4ljmO8/GrbjHDTF3ki93uk1o2Ln5D12DOyocguy7imPcora0Rj/JamH7b?=
 =?us-ascii?Q?Jn3Gd1Jt1EMz0abbniabM1+zv3PTkw/1AUjwRvMwikVkrcv42OYvreWxIGsm?=
 =?us-ascii?Q?z7UOCfqJrZSJ1U4w+GZfbl41jUqptnBZIncr9o+tcaJeHNaJWu4gfpUPK512?=
 =?us-ascii?Q?M96g9rcxL2G1O8Y3v/5jxBNwevkdO/sn2quL037pK7JslkbGGzmGg+e2CjIm?=
 =?us-ascii?Q?gY5CKE30Ahc3Z/wQx+UNaKfBXO690VOU0nPytB92HJfPXXQ9ASUxvwvIeF84?=
 =?us-ascii?Q?Hr60OJRSVuLZYyX7Z9WqJErSIQvkXJamZ62QX/jrp9Zl6pmDVHlC5rlOMJeW?=
 =?us-ascii?Q?mynGvwKnwCWQ8ZrTHbt+69PS4C6WjvaDk0u1qpnnY0vOxfC3lXY+JcjCIF1B?=
 =?us-ascii?Q?Wl8XkIgJJdtdV5S09PJi2A3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2a4352-e107-44e8-86e6-08d8eee6eff0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:50.9561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJxiLDRGmqu+c+vG2H0NT6sBWU90ruqFajMn7XPm72JWhpP7c742NZcSW+yuj+hep5jKd+Mfo5JkCOEhNw2jOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required in a host OS for SEV-SNP support. The series builds upon
SEV-SNP Part-1 https://marc.info/?l=kvm&m=161660430125343&w=2 .

This series provides the basic building blocks to support booting the SEV-SNP
VMs, it does not cover all the security enhancement introduced by the SEV-SNP
such as interrupt protection.

The CCP driver is enhanced to provide new APIs that use the SEV-SNP
specific commands defined in the SEV-SNP firmware specification. The KVM
driver uses those APIs to create and managed the SEV-SNP guests.

The GHCB specification version 2 introduces new set of NAE's that is
used by the SEV-SNP guest to communicate with the hypervisor. The series
provides support to handle the following new NAE events:
- Register GHCB GPA
- Page State Change Request

The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
access requires an RMP check. In particular, the read accesses from the
hypervisor do not require RMP checks because the data confidentiality is
already protected via memory encryption. When hardware encounters an RMP
checks failure, it raises a page-fault exception. If RMP check failure
is due to the page-size mismatch, then split the large page to resolve
the fault. See patch 4 and 7 for further details.

The series does not provide support for the following SEV-SNP specific
NAE's yet:

* Query Attestation 
* AP bring up
* Interrupt security

The series is based on kvm/master commit:
  87aa9ec939ec KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs

The complete source is available at
https://github.com/AMDESE/linux/tree/sev-snp-part-2-rfc1

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

Additional resources
---------------------
SEV-SNP whitepaper
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
 
APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf
(section 15.36)

GHCB spec v2:
  The draft specification is posted on AMD-SEV-SNP mailing list:
   https://lists.suse.com/mailman/private/amd-sev-snp/

  Copy of draft spec is also available at 
  https://github.com/AMDESE/AMDSEV/blob/sev-snp-devel/docs/56421-Guest_Hypervisor_Communication_Block_Standardization.pdf

GHCB spec v1:
SEV-SNP firmware specification:
 https://developer.amd.com/sev/

Brijesh Singh (30):
  x86: Add the host SEV-SNP initialization support
  x86/sev-snp: add RMP entry lookup helpers
  x86: add helper functions for RMPUPDATE and PSMASH instruction
  x86/mm: split the physmap when adding the page in RMP table
  x86: define RMP violation #PF error code
  x86/fault: dump the RMP entry on #PF
  mm: add support to split the large THP based on RMP violation
  crypto:ccp: define the SEV-SNP commands
  crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
  crypto: ccp: shutdown SNP firmware on kexec
  crypto:ccp: provide APIs to issue SEV-SNP commands
  crypto ccp: handle the legacy SEV command when SNP is enabled
  KVM: SVM: add initial SEV-SNP support
  KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
  KVM: SVM: define new SEV_FEATURES field in the VMCB Save State Area
  KVM: SVM: add KVM_SNP_INIT command
  KVM: SVM: add KVM_SEV_SNP_LAUNCH_START command
  KVM: SVM: add KVM_SEV_SNP_LAUNCH_UPDATE command
  KVM: SVM: Reclaim the guest pages when SEV-SNP VM terminates
  KVM: SVM: add KVM_SEV_SNP_LAUNCH_FINISH command
  KVM: X86: Add kvm_x86_ops to get the max page level for the TDP
  x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
  KVM: X86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
  KVM: X86: define new RMP check related #NPF error bits
  KVM: X86: update page-fault trace to log the 64-bit error code
  KVM: SVM: add support to handle GHCB GPA register VMGEXIT
  KVM: SVM: add support to handle MSR based Page State Change VMGEXIT
  KVM: SVM: add support to handle Page State Change VMGEXIT
  KVM: X86: export the kvm_zap_gfn_range() for the SNP use
  KVM: X86: Add support to handle the RMP nested page fault

 arch/x86/include/asm/kvm_host.h  |  14 +
 arch/x86/include/asm/msr-index.h |   6 +
 arch/x86/include/asm/sev-snp.h   |  68 +++
 arch/x86/include/asm/svm.h       |  12 +-
 arch/x86/include/asm/trap_pf.h   |   2 +
 arch/x86/kvm/lapic.c             |   5 +-
 arch/x86/kvm/mmu.h               |   5 +-
 arch/x86/kvm/mmu/mmu.c           |  76 ++-
 arch/x86/kvm/svm/sev.c           | 925 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c           |  28 +-
 arch/x86/kvm/svm/svm.h           |  49 ++
 arch/x86/kvm/trace.h             |   6 +-
 arch/x86/kvm/vmx/vmx.c           |   8 +
 arch/x86/mm/fault.c              | 157 ++++++
 arch/x86/mm/mem_encrypt.c        | 163 ++++++
 drivers/crypto/ccp/sev-dev.c     | 312 ++++++++++-
 drivers/crypto/ccp/sev-dev.h     |   3 +
 drivers/crypto/ccp/sp-pci.c      |  12 +
 include/linux/mm.h               |   6 +-
 include/linux/psp-sev.h          | 311 +++++++++++
 include/uapi/linux/kvm.h         |  42 ++
 include/uapi/linux/psp-sev.h     |  27 +
 mm/memory.c                      |  11 +
 23 files changed, 2224 insertions(+), 24 deletions(-)

-- 
2.17.1

