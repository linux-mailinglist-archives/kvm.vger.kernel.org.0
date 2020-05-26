Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEF81C7CF3
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 00:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgEFWCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 18:02:17 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:62529
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728621AbgEFWCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 18:02:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg2M+zlp9ix77kwB/sp1kgkxtPp5vNUtwen/FWRs3nk+Fqbxh4waIRkVC2+nSH1Fu7t4/75pUnpTfmzIi+GvH/Xzvw6/OW8gYBV5FMYUAMv9/k1FG06g2vptBZcjtUKaZnXPCWSBM2E+iqsYWX46LPwOHNqljEmPB9lk6xM5v2GR9RrXZwVO6AHLe6PzIvlYjqqfvWRT9F5oi48obJ4H0xLq216/s7Tq2pTkZ5wrCwUpi0LRWbnj8t3SwpSkG9pejgfr0pXT8aE+oQ3tQcOZWU6axR50C023ViBGayVYzF12KaiUZYfNH4qOvH3pjOYE7mS6SrgEBVDj3p1QNP3y5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0B0d4zYiuLCdvai489BpPWKD9qYym4cwE9fIj18bmo=;
 b=KMPnDei8nPe9PXVAQrFjyQY+Wqhxknkp3fuBemtLDV3TWuNroXaHj5cGo6VcslwlfChYzxHpthe1Q6aJgTHz2OYZApnryYgRRLFwsGzEi3hZZ8iiskj2unvHB5TQv6L2MRH6bDvtGETKxscq5nM3uz6uCfEspHiGTeKpA4+Tsn2Nd4OGh5T4PEbBSAcmlTNxPayaEP94NAevQFlOUMRipl8FXi1SvGqJrkj6lVLU9kUjoRXZV5W06fUh+Zxeq7ZDZTqVbx8/P4ednEijIS0mAnycgUwxiP6Qq5q06Jfj0rC/HxDxxeOrAuCaoem4eQzpL+iKzaUPTMIipPJW6xEhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0B0d4zYiuLCdvai489BpPWKD9qYym4cwE9fIj18bmo=;
 b=kXoLUz3ItNmKa627DKuZkdRO8zBjUJI9+FqLCTQq2nItbQGxpzGvOBsKo+28xdndcreZNOALlolpc4sfzgfkl+RkS8X8ykJ1sc8du9dcRla/gCNdkPpE3tUbqyykPYqBVKx2WvB4+OOPxkqTWHfcVhwLbwtqofIV4qDoLPyEFLM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 22:02:08 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Wed, 6 May 2020
 22:02:08 +0000
Subject: [PATCH 0/2] arch/x86: Enable MPK feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 06 May 2020 17:02:05 -0500
Message-ID: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0049.namprd05.prod.outlook.com
 (2603:10b6:803:41::26) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN4PR0501CA0049.namprd05.prod.outlook.com (2603:10b6:803:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.16 via Frontend Transport; Wed, 6 May 2020 22:02:06 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0d58689f-ab94-4574-d1d4-08d7f2091e9c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:|SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB251213DBF887E0BCC0D386FF95A40@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgTxiOq1gkmanrhkn5E3a6lNsx5TyOmSlRBgs15HXd++JNtfea/IRHoCAKt7Iy+DQG+Bhj1dXeQk3pktRU29eAiomH13THHsqkSL6rGR2IL862c4mQTAUytHNJUyzxHCIlvuboaCL4LO5iomKhqfTp7iukobiGdSisMZK3f8Fvku+/XgKQ8NRFJQzyqcxh5lruypiTKuvKpcLpM687bU7FhwO7URG45OAm0Sv2v7gwHS8pJUY7PCe/FTJ580c7UagZ5w4WN4M5x2gbLWwTg7/wQAU3jC6l2IO1bm+lBQCSodSdsIk6+mQhJ7Ijn+6ypM89oljFfYJLjq8/USjxOyQJSblE2SxXkVkdJNv/ChOQY+kyTaFseRJqv1Yb34OD0WqnzQ05UeFauZBO1xNB6r+5eMHif3ahOjf/MGB7fxGdpMEWQDhWyw/C1REeaoy+O6/pyha1n64NPEBqb+Q9QYiHuNbp0efZMAbC5UIlgNf7Y3kb3OOplK2xF3usNkIzToA2a5oaLarKH4WhcYYTKdPpzWKxJI4xVuw16AWQRVm/r/fbg2EDSySksWJxfD20cdfInBAeTHKGTfbvYSHtdVcwZjq+e2UJLM3RA8o/s/SNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(33430700001)(26005)(52116002)(7696005)(4326008)(2906002)(8936002)(33440700001)(66476007)(66556008)(8676002)(16526019)(478600001)(55016002)(186003)(103116003)(966005)(316002)(86362001)(956004)(66946007)(7416002)(7406005)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ef5KWZ+BtRCMXIB2ah/x7gGLXVgnvCRYH3/8lzFygbrzy6twyzyjCZeOgVwvRRPQcoFV3rreu2XiUhU0knjWlRg3ejq1xoi/iL3oKMBWJayfUwXhLGXItRYNXBHTbgcZsZwUsm77Q/wsFgAnvUPZX8mRVvKeDzmKuQOz6skqXUB1KuV/RKsF3UuvsVjhN1BheXkEDWQfanUT3SuXpg2Xwyc5yoEe+jM4aTmhxxV5AasDbAeuwVVYpG9MI9WYmKQbe0pyoX9XmJFBiqs2Ze87WCAr3gncV9vmvf9WpOUk7bfzFIJZuEhQTS58rPspwoPgajWGNoqz0GMC/HqKDFXEZ1KaQh73m6pGeMqVnuc2v5DA/ELXjSyow0sQFrTcpN4LCsbJ4GcAZZ1vjZQFvhkfPzXnj9lPnr+vWKbnFyBy5srcu0JnGf0a9aRTPYO1gX578vySo1SHQI72UhBjCntrl31yvl3+WjwipuyaxeI5cAiKAS9UqJR6tjOdD8BCkKZR0UKycqVl9HwPKJEnFPwTtfPFXyhZa8QpRRbPRx3tUuM6WgWHF7iKLyHC+1tyQl69/pDTXJZz2FfM1Cxn4xhS0irEhXqIsBVVHZR9QmkLSQsNsP0UdXO84SHO0OPd3VCsas7604RG2jG5BJWnXB6kxlT0yTg6f8V3IQlzPAsjbXkU/mxfQwJ9aMrioP9o8qKfsqxfHUQCLWwLAJaVKj4vZYlgFe+A93qsbFKQcMl0+1oiQPlDBWDRtqpBIiYtt40rcBLv4JN/wflw2nYImo4WE+GmkCyYgRqcbfeYRxNoZ5E=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d58689f-ab94-4574-d1d4-08d7f2091e9c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 22:02:08.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEBHNVI3o71Ue51uDAAzU3zx3lqyqJqdb04/JrzgU9EmSsSLTcB6tqEUHYNpT6Fy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's next generation of EPYC processors support the MPK (Memory
Protection Keys) feature.

AMD documentation for MPK feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
Section 5.6.6 Memory Protection Keys (MPK) Bit".

The documentation can be obtained at the link below:
https://bugzilla.kernel.org/show_bug.cgi?id=206537

This series enables the feature on AMD and updates config parameters
to reflect the MPK support on generic x86 platforms.

---

Babu Moger (2):
      arch/x86: Rename config X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
      KVM: SVM: Add support for MPK feature on AMD


 Documentation/core-api/protection-keys.rst     |    3 ++-
 arch/x86/Kconfig                               |    6 +++---
 arch/x86/include/asm/disabled-features.h       |    4 ++--
 arch/x86/include/asm/mmu.h                     |    2 +-
 arch/x86/include/asm/mmu_context.h             |    4 ++--
 arch/x86/include/asm/pgtable.h                 |    4 ++--
 arch/x86/include/asm/pgtable_types.h           |    2 +-
 arch/x86/include/asm/special_insns.h           |    2 +-
 arch/x86/include/uapi/asm/mman.h               |    2 +-
 arch/x86/kernel/cpu/common.c                   |    2 +-
 arch/x86/kvm/svm/svm.c                         |   20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.h                         |    2 ++
 arch/x86/mm/Makefile                           |    2 +-
 arch/x86/mm/pkeys.c                            |    2 +-
 scripts/headers_install.sh                     |    2 +-
 tools/arch/x86/include/asm/disabled-features.h |    4 ++--
 16 files changed, 43 insertions(+), 20 deletions(-)

--
