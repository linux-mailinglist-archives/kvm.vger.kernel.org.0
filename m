Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CF736F9D7
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhD3MRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:42 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229911AbhD3MRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf1iF3bUvoL9RQvmsLkvgE5JAfREZZ83eK75W9IETqLImnc0pj+v/MzIFO1Oeub125nBm6BI5MLIO/y6oSvZEX0kNfq4s8P2Lcc8YsdUAELgJdKyf7gkjFaR0dE5nhcewxyNg2C7MOc2fZmFShx8ZAU5LxCUYlLLErAMcVqJLxc06OFLovOqo6YwMp6Udz7Lgnk8169SCyRytpAEBwCI8ATGukgRgWc6ZTXPIjjKK3mgD/FhC0lMzex06Vug2I9o9XQP970vtePyF703NcCuNc5OcMazgMVw4CAVYP9Tr1gi0GRyZ6cJr7d+5o+S7wYqdiHAePjQxNDAASf3LLcP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVhGq3NXPwqn3tmVSPQArJ+y5WMyJz65MrvTf4IlK7Q=;
 b=M1L/cVuu22UeOp5OIOadmpKFJPDFiyzT2W7NTe3LukAjLh82TsjgQfpgITyvoTEHLtkGoN0fUonUohF9T2MmvGlZm8NQeY6gjw1cg2sQzjlu5d56lkaqr/3Re9HCddhWb3h9W45H0fv2om3VgpsC9hZELAg2FgR24OIieB9tG0dzNJPD6gyisplwBq6p/F0TGZtf2ZcPtVIu2rVdqB77QWtsBAt0U0Qov1D46jeg6vrSb/zpQbToB1csnRoMCyUu+s+wlYNhOJluH17IYGD8/bpo/pTe5I7gat1N2sVdxNfsA7ylxfK3LpG0MLpLuFKeg1RJy1S+hIQ4jxfvyUojmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVhGq3NXPwqn3tmVSPQArJ+y5WMyJz65MrvTf4IlK7Q=;
 b=nIqoRSAFqnitwf5kWdOkpdRmp5+ZyXXWp7SCv2VneSiFhpSlXb8zsWgtMfD6roOy6905M3WCBmGlCJ1ZL2hhmRUrYLUuirFfWwAsb9fkhcPHQg9P9UmwNZ/AtTeKLrtzWnnpbcxou4rtlNwNfbCvClpFWB0LVWLBfPXoMejKmLQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:47 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 00/20] Add AMD Secure Nested Paging (SEV-SNP) Guest Support
Date:   Fri, 30 Apr 2021 07:15:56 -0500
Message-Id: <20210430121616.2295-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fc7e962-4636-4cbd-c7fb-08d90bd1d3a0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431F0E741B16D86721E4FBEE55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5FSEmP5msp8LRxby4fb6AAeiGEDYQd3d6wupTpiC6QA+uR1rCu4Gxwt/qu8M8Z9y8rws6rhHcQtm4vmaXDIW9IPGiAulZen/+3AO6Pal+swXTcMdp8h/UH3NdDRCvZYXaNKYyQlFFWZ6KRyWHXoKUOvF2TZylg9Z02Z3a1eoChpREbXK5lmcN/gi1vEtPOYo7vdkfgVr/91lW9c1+/cRZPqNcrtRH7JFqrlV9zHVT+Nc0qOcCcJByOsCjab4jRO32vs+R+BnzjaDgf6hbzs8S2dnokF9AC+kK71T6jorDjHb63TYzZHybgzWw+9b2V+npGVcZsUAtlfe0k4LFVO+WoVHVPICp7LmqBn+dS2ujIVtHotkiIw0hEnJFRcviCjAVsuunKWhuwvx2F/5x9zQPocQQyr6A/tCiHFKYK3i4jPO1+xfSxXzsiIOO/3qWxwkEE3cFFllH8kHZb6q17DsDXzKIyTUeP4cKj5yiM0eecWvnT6DCMvTIj2ssyeHu3BsUeXQBp4MIvE8RG1Vw0AbEnzD23i9wnsCsxDcofSG3ru9G90/R7SbZvOu0ad3BZ1c7eHlufqV4uCzUlnWpF0ByM7hzwCmlOiqWSA9jO7ZhScYTylVTKDBdnDGJUsFlK3Umu0VzzAgBb+hPs9/N/rF8upx+lqZEHsSJLE4+Rd7bJrVzLyyhXRbVv9F0YLH0QzJstMWFNyLz0wb/bq+LhbZtaBpbXH+70IwHEiZXmW1Ux9dSg93ldzAIFx5Hye9xNKwXp5jQQGP0e5wQ5Rox9awmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(966005)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVJoVHJlbjgwUVJxMnlEM1dMNjNFZjBKR29pc3RYeURQRE1lN1VGMVIydmox?=
 =?utf-8?B?RTFlS0N4dHBNZkZ3T1Z4YllhcCsxVDNnS0dmdFlHa002MzhmcFZub1VUdHpB?=
 =?utf-8?B?UWl0ejlGUFlrUllRV2xmeHVCNEE2K2cxcXFlTFZ6d1VRTENRV2VhUjk1NWZK?=
 =?utf-8?B?QitQTWJ5WUxtUWp5c2J3aXYra0M3ZzF2eXkwaUFjVzlrUkIySXlVT2t1ams4?=
 =?utf-8?B?VWp1TkJTNEZMek02dTkySDV0RDdXcCt3NGowOEoxQlJEZjZFSGpWc0VRc3E3?=
 =?utf-8?B?K3U3TlpEQzVISGk5MjIrUVU5dk5BVEtJSGcxQ0lWVVBXdm4wUCsyclV4ODZF?=
 =?utf-8?B?RXVLakt0WHlPeTdDMW1jVjd5Snp3dXR5M3ljWVlhbG1SWmFZN2thZTRIdlVn?=
 =?utf-8?B?VVVPK0E3K3VqMStodjVTL0xWUnhsdWdBN0F3VU9lZHFOcHpKWW83azBXYldI?=
 =?utf-8?B?elpGK1V5aGRxUUhuWVpReXRVY2ZSRjNnWkZOdmVlWVNRTTBuZlJJU1FOM1NK?=
 =?utf-8?B?ZXV4Y2UvSURqWE5RUDZSc01LMUlsVjJRSW9TS3BWelpQazJFalphSTVoZ3kv?=
 =?utf-8?B?cm8xcjBYbW1IQTRGb0xCbzBiTjBNZndkaFNvUnhuNENvUEFPOHBTMHBER01t?=
 =?utf-8?B?c255WFFFV1VGNXg4SGFvRDBNSG9LUkpiLzdyNmlBbmRxalZ5eGErc0JTT1F5?=
 =?utf-8?B?RWw5Qktkb3VoRWdOWUxtM0VHdXFmSUJ5WXFtdVlyK0hiQVJQVHNaSVZwUnha?=
 =?utf-8?B?SS9WalZPOGdjdDZHcVNRMzRrOHVxSFYvR08vZlRtMjBGT0tqZEkydVFrV08v?=
 =?utf-8?B?dmdFc0RLSzB4T2pqbmxhRjByN2szN1BGMU44ZU5leGJXQ3pKZk44TUcyWFBX?=
 =?utf-8?B?YTc5RG1QeVlxczk2L3J3Rkl3aVJsUTJGRTJTZnorTW8yeXhzaVIxUWtoaUhh?=
 =?utf-8?B?VEZ5ZnFHYWp2UnpqVzVxR0g5SEFnRXR4SDVIdlpYOENyUElUUkk4Sis4REZQ?=
 =?utf-8?B?NVlUeUdhRDBtWW1OdDdFMHYxZGgrdWFRc2xpbERQRExOUkJkYkF2VnlmZWtV?=
 =?utf-8?B?L3RCTEQxT2hVRUxnbkFodWdNWkxtSGRRNG1PTEgwTU9nbHdNcG40MU1CMDkr?=
 =?utf-8?B?MDRMVkcvZ1czNkk5YnpnN0EyTkZFZ21mZEdkKzNMeFk0MXJjRm1zRGRaenRn?=
 =?utf-8?B?aUVJREx0Rzl2cHd1VkhYRlhRQWtPZFM3SDlCMG5GMnZab0swMmRMTDZ2d3k0?=
 =?utf-8?B?UmJuSFpKMjJyTFpJSVlRb3BzMzVyK3JRa0ltSzRFaURodFMwZnZLVFdvOEd0?=
 =?utf-8?B?dmR4VWQ2THFFbVhKa0gyaXdoYnFEZlJKaU41SU04aDVlWERZYUVhL216RHV6?=
 =?utf-8?B?YW85ZTFtNFo0MEV2alZHWnh5ZDFTMThSaDJqK0pwUnRzUUdUMndzVExtRkx0?=
 =?utf-8?B?L0g1dVpxQ3dUWXpqeFZJVjZxcnZTMktkSnhvSW1CQUd5SGc1QjRMZEttUS9w?=
 =?utf-8?B?dUpyZHFLS0F3ZTBZdzNxNStWSTFnanFiVGNDMkJJanVlSmVXS0hxWlNtM1FY?=
 =?utf-8?B?bUh1Vzk0NXVISWFTanc3aFF4eHpZaWg3RDQyNnFLbitOai90Um5Sb0lvNzlr?=
 =?utf-8?B?cGZ2RkhQL29UbFAxVjVPdXNzZjI1S0VBTURMOUk1aXZzZEFlOHJvWTNRNWts?=
 =?utf-8?B?UjdNR0ZlNXloNzllajlJWU5CSi9LczgzZ3BVQWkxNVllQXB0RFZ6SDdNc1pF?=
 =?utf-8?Q?FQCYDmR7jQGJ5yyi7FWpO3feFhp3AHK3WK4up7B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc7e962-4636-4cbd-c7fb-08d90bd1d3a0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:47.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/dxgieVgxMPm6rxbd2xQK3u1EHuP+EfsCQSFb5jAcIjO/MVXS5F1ZNAgV2UoK+u0Ss/VoicgdD9n2VY/yNStw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
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

* Extended Guest request
* CPUID filtering
* AP bring up using the new SEV-SNP NAE
* Lazy validation
* Interrupt security

The series is based on tip/master commit
 - 24b57391e410 (origin/master, origin/HEAD) Merge branch 'core/rcu'
 - plus, cleanup series https://marc.info/?l=kvm&m=161952223830444&w=2

Additional resources
---------------------
SEV-SNP whitepaper
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
 
APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf
(section 15.36)

GHCB spec:
https://developer.amd.com/wp-content/resources/56421.pdf

SEV-SNP firmware specification:
https://developer.amd.com/sev/

Change since v1:
 * Integerate the SNP support in sev.{ch}.
 * Add support to query the hypervisor feature and detect whether SNP is supported.
 * Define Linux specific reason code for the SNP guest termination.
 * Extend the setup_header provide a way for hypervisor to pass secret and cpuid page.
 * Add support to create a platform device and driver to query the attestation report
   and the derive a key.
 * Multiple cleanup and fixes to address Boris's review fedback.

Brijesh Singh (20):
  x86/sev: Define the GHCB MSR protocol for AP reset hold
  x86/sev: Save the negotiated GHCB version
  x86/sev: Add support for hypervisor feature VMGEXIT
  x86/sev: Increase the GHCB protocol version
  x86/sev: Define SNP Page State Change VMGEXIT structure
  x86/sev: Define SNP guest request NAE events
  x86/sev: Define error codes for reason set 1.
  x86/mm: Add sev_snp_active() helper
  x86/sev: check SEV-SNP features support
  x86/sev: Add a helper for the PVALIDATE instruction
  x86/compressed: Add helper for validating pages in the decompression
    stage
  x86/compressed: Register GHCB memory when SEV-SNP is active
  x86/sev: Register GHCB memory when SEV-SNP is active
  x86/sev: Add helper for validating pages in early enc attribute
    changes
  x86/kernel: Make the bss.decrypted section shared in RMP table
  x86/kernel: Validate rom memory before accessing when SEV-SNP is
    active
  x86/mm: Add support to validate memory when changing C-bit
  x86/boot: Add Confidential Computing address to setup_header
  x86/sev: Register SNP guest request platform device
  virt: Add SEV-SNP guest driver

 Documentation/x86/boot.rst              |  26 ++
 arch/x86/boot/compressed/ident_map_64.c |  17 +
 arch/x86/boot/compressed/sev.c          |  81 ++++-
 arch/x86/boot/compressed/sev.h          |  25 ++
 arch/x86/boot/header.S                  |   7 +-
 arch/x86/include/asm/mem_encrypt.h      |   2 +
 arch/x86/include/asm/msr-index.h        |   2 +
 arch/x86/include/asm/sev-common.h       |  86 +++++
 arch/x86/include/asm/sev.h              |  47 ++-
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 arch/x86/include/uapi/asm/svm.h         |   8 +
 arch/x86/kernel/head64.c                |   7 +
 arch/x86/kernel/probe_roms.c            |  13 +-
 arch/x86/kernel/sev-shared.c            |  72 +++-
 arch/x86/kernel/sev.c                   | 354 +++++++++++++++++-
 arch/x86/mm/mem_encrypt.c               |  52 ++-
 arch/x86/mm/pat/set_memory.c            |  15 +
 arch/x86/platform/efi/efi.c             |   2 +
 drivers/virt/Kconfig                    |   3 +
 drivers/virt/Makefile                   |   1 +
 drivers/virt/snp-guest/Kconfig          |  10 +
 drivers/virt/snp-guest/Makefile         |   2 +
 drivers/virt/snp-guest/snp-guest.c      | 455 ++++++++++++++++++++++++
 include/linux/efi.h                     |   1 +
 include/linux/snp-guest.h               | 124 +++++++
 include/uapi/linux/snp-guest.h          |  50 +++
 26 files changed, 1446 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/boot/compressed/sev.h
 create mode 100644 drivers/virt/snp-guest/Kconfig
 create mode 100644 drivers/virt/snp-guest/Makefile
 create mode 100644 drivers/virt/snp-guest/snp-guest.c
 create mode 100644 include/linux/snp-guest.h
 create mode 100644 include/uapi/linux/snp-guest.h

-- 
2.17.1

