Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2120D347DFC
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhCXQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:44:56 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:61165
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236503AbhCXQon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENJbzcuqG8lgb5WwAAbtisWppmJPnIvV9PKxDDaYuDb5LBLlxjCvkNtv1nYZz43d0fgC3+DqJDBf0YnpvdPNxCi2b5+8xZQrjfhwKY5NczYeH6qHdIJUUIFOuZ13k8kqsLS4mduqBQ07ZK/g5105NFIg45wnjy883qBh+J+vR5a7xoAijmKRI653j00NJocxu8a7Q/YzfuexaRY1MaIV5PoLXhSRiL/V0ptlWp/vmFtZorWSCpYNE5Y2Ei25/Y4/WcmBcFsxyYwkhI43MchRZST20uX0v9e7b4ddVALuQ11UM3NzbhCarhosPv+bo2R+o32ZWzHEyYbPLWNRxGPD4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmOPv41Xu//5qztaF/8bpibaj+/vQJdXrN52m574vmg=;
 b=D0JrLCTvOF3UCvABbDaXuR/GlQaZRzM+UwqsjccV0ThDZtermmGutk5V0xqWgFpOf5Cfxos8iwj7wMlGTSmv2cVpKcwN940Yqirs9yJ7CUQXf2hKTNyADDeKDZp8a02S23gdfgRjioHN6Xfxy8GLS4kLC15gsVLGDpKUxTwsgrj0RUVT1FowT6u8/jdxYpC/kBuG36RHTG57p2vTXBFcG1ybNydzd5W7f/AirmCTPP7hGAEbVIS4mKcpzY2TSBKtwchiTfuweVhvUnsP3NX8xl5lYDG6hIMg1Cq/RvlSjIcGEQ4xahGzBYegWXN3XFLxpImxn+k4GH1WQ/yoPGAI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmOPv41Xu//5qztaF/8bpibaj+/vQJdXrN52m574vmg=;
 b=tlsBh9FhOrKvElFW0vgXwblGEID7Ef/bRxAVrIfeO3LdjAk+Gz2mcckXOBXz9JN801h1G13qjBZWPyPh6UDcPNJcGr3EuQhKlwTgcD5We2YEdb+VLrRqIqyzpO4WiVwNZKlixrd+DC4upkCGeeHiR6U0ZzCgY/u8rvEQOaBSI2Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:37 +0000
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
Subject: [RFC Part1 PATCH 00/13] Add AMD Secure Nested Paging (SEV-SNP) Guest Support
Date:   Wed, 24 Mar 2021 11:44:11 -0500
Message-Id: <20210324164424.28124-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf56288d-8684-4ee8-1275-08d8eee41c63
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24478A3F7DD40216913784FCE5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsz+Q82ToENxeb8+FLoSdHZBOFT+TtsQuktuaBwN1xqLp8fgll7tKTUnlH1BaQ1yEZoTiIOg6YDIN5v39zsTcPqRPkW3y40JAm6Pvz9lCKrDWc+8ebPxtkWwF06waNWxhtIK/m+ef2Mc+bDOZFZyBEsALjbdCrNGCO/L4fM5+foxKto4/J3HsHtDiTIgwFRldXNDuiXR1ULWdCLSa2szNyw1StwgunTicB4GPZuYfKx56P1CzUlp5PeFthTOWqMYgKstB6IVHygVBmvpF/YiFskg0tiKUpwGG+1PG4jVaSyikVA6oVIA3qzXu6eirLyckWKEkU42Erh7t/awlGwBabu1jlyRsBOupu3y2wAofGF1SrwNk5r4GQnXczeL91cNhhrks/cb03xgnGUcqlAR4JRCoOx/sM9/eN37QaiZdXsw2NvJJjV9CLMoe6dpFjibmBkxW51lvWIs+f/zE1nGaOYnTm7pDkrbPFOtabW5t7Bnb/aqxCf/jv2tLbL2IoiqcdLv1tQiMVxkd3azeNq/A+kVCCK0bsMOjIA82X2+GoSs5qlAYXvO9fbbvgr4OF1y/TZ4cEQzsy2tmLG2GZjMNJn+qO5HcXTsp0jEm7kvcdnrA4eIBU5bI+UzDbkhljzmP4wmAuj051R2Ct/BouxFXWnGrDV+Th26W4uTfDFU4UCTrDfcpEPVAqq2tZ3l9HAdIvSQ2oWCZm596PEm/9IFPXxaUTeAzFi8KIi8m4dMapY19nbKMpsdmxToQV8/jjSp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(966005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MmJjYWZSVXlKenpNK1JjT0ZqclVwOW9jaUVBUmVjMVZLVnVwNVY0N1lLdWdJ?=
 =?utf-8?B?d1ZpSGJvbVJuelZaODNVanZsUjRrdFVYVXhrZ3JXQmxxT2tybEEraERocVc2?=
 =?utf-8?B?ZHMzMkkya1hwK0hTMHhVSGxDL0MzYmdtRjgvYjRUTVAwdTgxN1BIWWlISzlk?=
 =?utf-8?B?eklOaWtmZGZDZUdXdWpxenpwSVg1Z1JrL2pxNjYveUhEZWJka3AydTFBSzZm?=
 =?utf-8?B?NkdOTlJnUnM3aU1GL3ErMjhmc0UybVhsZzBMMlMxeENnTzJqZDVPUHgrMnkv?=
 =?utf-8?B?YTZXWDdxSGZtRTd0QitVTm8vMUMxVXFvQkpzYkVLTGF2bmRhaXRWMkZtNVo3?=
 =?utf-8?B?dUlwaFRpODFmM0QyNlJ3UXk0ZWViaHUwU1dvUzhXUXZNS2N4bC9vUkp6ekJ1?=
 =?utf-8?B?NG5INWluS2tGaGRraWYvNDJDNGhvdFZrQjFSbkRGTFJGZHo0Q1RQK2lTRjBk?=
 =?utf-8?B?aDJrWGRMSHlNd0kvUWVxOGEzeWY1UFpRcFFVT1RYb2N6WW9MSW5wSFFtVCtJ?=
 =?utf-8?B?TVhldnVGN0xqUWwwbXBoSk1jU2UzTllWazU3N0VyUVNzUGpCWnpNd1hrZ2pW?=
 =?utf-8?B?dk9ONk5Gb3NGdnBvQVlHSmNZdmNJMWJ2dCtkTnBlbWJnTGU2bzNaaXZoQ0kv?=
 =?utf-8?B?SmtyWE5hdCs3M2VxRXdZQWtMLzk0dGN5ZCtpY1NNamllRnpoanBZajluR01W?=
 =?utf-8?B?SnQ5Smh1TFRpVnVSaFJ5ekZ3QzlFa0g4c3dKa2UwaEp1YVRmWDJWV1dPdzM2?=
 =?utf-8?B?aDdOOURQdzhVYkVIWWgxdDNDbXlHbnBQRU9nNHdHUTFhSTZScE84YTVNQnNz?=
 =?utf-8?B?alNBTGh0cDhHazNqVnIzcFZqbW1zWGZLcnN4KzNwSUx0ZmlrVjdXS2d0MXUw?=
 =?utf-8?B?TE11eVdzRW5ESldUTVZvUDNzdGRKVGp3OWVyRlE1eStNR1EvVllpb3NYamVj?=
 =?utf-8?B?cEVRRFBoNEZ2ellJSGJGVm9XdDJ1ZzMwOHUxUEFQTU5GRmRpdTdlV3NNemtt?=
 =?utf-8?B?UHQ4NVJaa3YvUjI0Q3IxUWhKdGVyYzFHWXR2VklUcCtHSHdSTjNCbEtwQ1E4?=
 =?utf-8?B?R0xEQktiYmlpRkZ3SDNvaExrL2V1a3M1MXU1SWp3ZDRWSG5BRlRrVFVSUGZj?=
 =?utf-8?B?N29WK05NaHJuRUJrVXhYUEZxbG8yNE5mckxZMkp5YW5hQnROOHBYaE13emhS?=
 =?utf-8?B?bmp5SU16YW9kUThhZHpWK0FQOWh5azV6VnhzMXFCTWFyQlpuM09PQWZaK3BO?=
 =?utf-8?B?aWpVb2lrU2JEdzNLejZpaTlhT2RtendIaGNMckpSdEVsMFYzQ2pjZ1RRQS9w?=
 =?utf-8?B?eFJGVlpPWnM2VGRkN3VCNkx4WmYxS0ZWNDdnRWF6UUdsaWNtRUVUQXVNVnlY?=
 =?utf-8?B?VDNydG1KQy9Oa1cvTWNyNm5SOGdEUm5YYW5vbWpaOURwVjNSM3BtWXp2d0lo?=
 =?utf-8?B?d2t6RVFsbXAzU1huRFFRdXRMM0JraFB4SjRwMVRUaTQ1M3FlUjRsR0lqeVNY?=
 =?utf-8?B?MUtRNDZtdy9hUDIzaG5GQWFWclBmMFdsNW03OWo1OFBNYWtObU9ydDZvR3Q1?=
 =?utf-8?B?cVFpTHo3N2hjYXpBbDByQ3h4MzdwR0dTYXY1cnFZRUhmbEhHOHlHV1FaSnh4?=
 =?utf-8?B?c0J6cllKYXJ6T095YjdBbWFjK1FqaVU1bGlwVjRPTERMbERFM2xaZ3Q1cmdv?=
 =?utf-8?B?S3Y0OEF5bk5FQXZTbzRrc3VGcWpaSTZOWm9EaG51UTkzeEZYRHdZWnJiM1Q2?=
 =?utf-8?Q?AEbWv2hEvxS/QtqBhEbgUTwRPWs9ILzhqpdPqF9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf56288d-8684-4ee8-1275-08d8eee41c63
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:37.7389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09bEbZtHhtkVMtQIG9hzFD96S7wSJgwTjL/WJ1+eF+hkkcW8h8jyecKby/S3D1MXnPP+geZu0jdLVvqZMvHo1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This part of Secure Encrypted Paging (SEV-SNP) series focuses on the changes
required in a guest OS for SEV-SNP support.

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based memory protections. SEV-SNP adds strong memory integrity
protection to help prevent malicious hypervisor-based attacks like data
replay, memory re-mapping and more in order to create an isolated memory
encryption environment.
 
This series provides the basic building blocks to support booting the SEV-SNP
VMs, it does not cover all the security enhancement introduced by the SEV-SNP
such as interrupt protection.

Many of the integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). Adding a new page to SEV-SNP
VM requires a 2-step process. First, the hypervisor assigns a page to the
guest using the new RMPUPDATE instruction. This transitions the page to
guest-invalid. Second, the guest validates the page using the new PVALIDATE
instruction. The SEV-SNP VMs can use the new "Page State Change Request NAE"
defined in the GHCB specification to ask hypervisor to add or remove page
from the RMP table.
 
Each page assigned to the SEV-SNP VM can either be validated or unvalidated,
as indicated by the Validated flag in the page's RMP entry. There are two
approaches that can be taken for the page validation: Pre-validation and
Lazy Validation.
  
Under pre-validation, the pages are validated prior to first use. And under
lazy validation, pages are validated when first accessed. An access to a
unvalidated page results in a #VC exception, at which time the exception
handler may validate the page. Lazy validation requires careful tracking of
the validated pages to avoid validating the same GPA more than once. The
recently introduced "Unaccepted" memory type can be used to communicate the
unvalidated memory ranges to the Guest OS.

At this time we only sypport the pre-validation, the OVMF guest BIOS
validates the entire RAM before the control is handed over to the guest kernel.
The early_set_memory_{encrypt,decrypt} and set_memory_{encrypt,decrypt} are
enlightened to perform the page validation or invalidation while setting or
clearing the encryption attribute from the page table.

This series does not provide support for the following SEV-SNP features yet:

* CPUID filtering
* Driver to query attestation report
* AP bring up using the new SEV-SNP NAE
* Lazy validation
* Interrupt security

The series is based on kvm/master commit:
  87aa9ec939ec KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs

The complete source is available at
 https://github.com/AMDESE/linux/tree/sev-snp-part-1-rfc1

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

Brijesh Singh (13):
  x86/cpufeatures: Add SEV-SNP CPU feature
  x86/mm: add sev_snp_active() helper
  x86: add a helper routine for the PVALIDATE instruction
  x86/sev-snp: define page state change VMGEXIT structure
  X86/sev-es: move few helper functions in common file
  x86/compressed: rescinds and validate the memory used for the GHCB
  x86/compressed: register GHCB memory when SNP is active
  x86/sev-es: register GHCB memory when SEV-SNP is active
  x86/kernel: add support to validate memory in early enc attribute
    change
  X86: kernel: make the bss.decrypted section shared in RMP table
  x86/kernel: validate rom memory before accessing when SEV-SNP is
    active
  x86/sev-es: make GHCB get and put helper accessible outside
  x86/kernel: add support to validate memory when changing C-bit

 arch/x86/boot/compressed/Makefile       |   1 +
 arch/x86/boot/compressed/ident_map_64.c |  18 ++
 arch/x86/boot/compressed/sev-common.c   |  32 +++
 arch/x86/boot/compressed/sev-es.c       |  26 +--
 arch/x86/boot/compressed/sev-snp.c      | 141 +++++++++++++
 arch/x86/boot/compressed/sev-snp.h      |  25 +++
 arch/x86/include/asm/cpufeatures.h      |   1 +
 arch/x86/include/asm/mem_encrypt.h      |   2 +
 arch/x86/include/asm/msr-index.h        |   2 +
 arch/x86/include/asm/sev-es.h           |  11 +
 arch/x86/include/asm/sev-snp.h          | 121 +++++++++++
 arch/x86/include/uapi/asm/svm.h         |   1 +
 arch/x86/kernel/Makefile                |   3 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/cpu/scattered.c         |   1 +
 arch/x86/kernel/head64.c                |  14 ++
 arch/x86/kernel/probe_roms.c            |  15 ++
 arch/x86/kernel/sev-common-shared.c     |  31 +++
 arch/x86/kernel/sev-es-shared.c         |  21 +-
 arch/x86/kernel/sev-es.c                |  32 ++-
 arch/x86/kernel/sev-snp.c               | 269 ++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c               |  49 ++++-
 arch/x86/mm/pat/set_memory.c            |  19 ++
 23 files changed, 792 insertions(+), 46 deletions(-)
 create mode 100644 arch/x86/boot/compressed/sev-common.c
 create mode 100644 arch/x86/boot/compressed/sev-snp.c
 create mode 100644 arch/x86/boot/compressed/sev-snp.h
 create mode 100644 arch/x86/include/asm/sev-snp.h
 create mode 100644 arch/x86/kernel/sev-common-shared.c
 create mode 100644 arch/x86/kernel/sev-snp.c

-- 
2.17.1

