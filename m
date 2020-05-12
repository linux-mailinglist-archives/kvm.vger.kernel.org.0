Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDCF1D0350
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 01:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbgELX64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 19:58:56 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:6034
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731656AbgELX6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 19:58:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiHa+ldcB+nbTmoj4UvWHXgbTEIR3XtMkhr+F6aj9/y79gfqcE19bE0HR+F1AaOQpY05t0HgvLuRVg4O799F9xC1zEmEmH5Mjzt+/wp8L/cYpwHthYn/jvFomMfqCHjzwat5MYK0vAdRPft1FUf/ZM0ZMop6jrLM/7QPc+QcH5J783olbr3AzZpsPG06C/TS0bVvJj52g8sVJQ7dHVndOxptN2zeQklfIThH1F8rBJBnWeKQ1Y98Gum3oAl8kUwUsLop8cSgzCYIxvhwm3hZhuys8JZRwzSYlDLtaB/CciralVRd59cZzbESYgJklwLJbSrKrMmzAU/DWxOV7HSpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nwl55NNBF8qYLEcR5lKJQWd+47tHHxtme8LrHqnd374=;
 b=mQ9wqPAC1hjDOW+EhL1rHQ9gSzBxvTrLaHvAII9orw4RyjJWzrZjhDhexOXDH3iryPHNC2PWAGjhFCA1h0QgJR8iIm1HXuISVW/dzuoheALacmCEqPbBcv8OhrTfD87NcDsMx7lToygvKCWjMxqnoCoOxLqXRg8Z9x8iIpQUUs8vTA/8IcYaAf9beLtF+UtDCocvo8/8azGBnUSyJKxgJNept2/dOmy9TlUlT+zq21RjkXVmk4IyIZIoBwqkk67Xi3RlVwThw0AhDq8BvgOTUZbhyICaUxwIaVZC2x9QAF5l+inj4/6StGmz1UrQ1KN8y7yJ4xyrmig80tJx3bYUqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nwl55NNBF8qYLEcR5lKJQWd+47tHHxtme8LrHqnd374=;
 b=CP/0BK44sZ38ryZKS4hfN0dK1jH+SmCJaSYqKk4Py/bdxibvqeZgBDj/v6W4WXJB1EcakJZrlnpAqdaX/WgOHrI9BCvczndCx3YINgP1lYTff4buoEjkr5k3xcWRKmE9kJDwFlPuNABz+IyoMuxxB9+RL4ge6AHYJWorefQVmN0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2575.namprd12.prod.outlook.com (2603:10b6:802:25::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 23:58:51 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 23:58:51 +0000
Subject: [PATCH v4 0/3] arch/x86: Enable MPK feature on AMD
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
Date:   Tue, 12 May 2020 18:58:46 -0500
Message-ID: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR2201CA0015.namprd22.prod.outlook.com
 (2603:10b6:4:14::25) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM5PR2201CA0015.namprd22.prod.outlook.com (2603:10b6:4:14::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 23:58:47 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 497c9631-566d-4266-5c46-08d7f6d06b38
X-MS-TrafficTypeDiagnostic: SN1PR12MB2575:|SN1PR12MB2575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB257549A1FC54DFC8C454B60B95BE0@SN1PR12MB2575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3XWYv885s1Irm62EPoArkT6DCshXw1WCYQRluPmFuKXFwAwEzQWP8LevAfiaiTk+PjHB3+2CaVz/fSjZUFGfKmd4C5wiwcnU/mwRWppEsC6lH6fMW31L+KuIXBbQtkSUeUPHdLZDkCy0AINrlP0rTWloq3hIDKT3WsocX/ohXhGuaeoAc6xXVtvLyqGHdEleJkWepwB3GijHUjuttA7MM7L4RdaqDC0dYytwif+YBalFjplIUhiiNGVbdTsa12ECJnl7QtvVQIgQTUX1DQkVDqRj0Trd1fEde4Kz0n267B5SwZnZsF5UHqHjPxmWiD1JGD6TVPnakZGCfHqQLelKf2jnfNXDo9L7oQOG2aseWMx5GH4nIYdjF19wYGz9T9zD5/xmr0eOARMzbPrTLeASxQmjos50O5e7NWQyfU2o8B19BCbWDl/7WN5FEbuvvBzm2iwmdwwjYswZD+Bm68dj2wPWjgwvwz38q8CX3j/pFflV77TENlbOqInekpDL0ZEA+a/4eYDoyOFL4sgWb3wV38I0pp0Uvb2PT4CtTIelJQ43/aFZSE52Msgf3XrgrPBovY9Z0Gq0Q+MsZ+AiCdRXzU1Pup5SRkzWV3yTerPlJU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(33430700001)(33440700001)(966005)(66946007)(66556008)(66476007)(4326008)(86362001)(103116003)(55016002)(44832011)(2906002)(956004)(5660300002)(7406005)(7416002)(186003)(8936002)(8676002)(316002)(26005)(478600001)(7696005)(52116002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yGDRF5eAr4QO7JI1jgInWF7rZDqa48UD+EpEu6caULcLKxVsu4MYCuiz+a5mMZTOLPacZUTZsF2nvnfQKRZYOxtFKRMu08LojPIIEjjxyuxLJrID1JNMiG4JbSrqLmFTh2yM6F2KcBA6+nh6/7Q82BA1Y0ODNj07zddZ5hSLc0Q90j5x7hk0gtbnOo048/zzwaIdykR6o1vJVnS9CuFdEz8sxz/llfAfz7WZrcIcXNUDQCL6M0H+oP23YXf08oypApSn+cR2Y3KMgfswZLnvkz4zN/h54EBXSarwMdX1Wa+hVj3wSKh/vQ6v1oZ9R9K+jbilNTCiEK0820xsF3n5zBwBRSkPti1vzR10V5oc6kS67/d5e53Wi6SsLEBAw9Xz8bPZssmjxl/CabR2GjKjgnHvdylabeYja10Lv5RJ7fOgXjNYyRcfjMFzZ183qdIDT0Ke6uPTZUebT5ycuE7j50ih6hhKmJUWeFO0x7dLWZI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497c9631-566d-4266-5c46-08d7f6d06b38
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 23:58:51.2118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+pTZPkVpKdJNH0OIyKfUh379r9oYlbsXFFbGZnnOlh1iIuezrwbXOE9LgskfPuR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2575
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's next generation of EPYC processors support the MPK (Memory
Protection Keys) feature.

This series enables the feature on AMD and updates config parameters
and documentation to reflect the MPK support on x86 platforms.

AMD documentation for MPK feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
Section 5.6.6 Memory Protection Keys (MPK) Bit".

The documentation can be obtained at the link below:
https://bugzilla.kernel.org/show_bug.cgi?id=206537

---
v4:
  - Removed all the source changes related to config parameter.
    Just kept the doc changes and add new config parameter
    X86_MEMORY_PROTECTION_KEYS which shadows X86_INTEL_MEMORY_PROTECTION_KEYS.
 - Minor change in feature detection in kvm/cpuid.c 

v3:
  https://lore.kernel.org/lkml/158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com/#r
  - Fixed the problem Jim Mattson pointed out which can cause pkru
    resources to get corrupted during host and guest switches. 
  - Moved the PKU feature detection code from VMX.c to common code.
  
v2:
  https://lore.kernel.org/lkml/158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com/
  - Introduced intermediate config option X86_MEMORY_PROTECTION_KEYS to
    avoid user propmpts. Kept X86_INTEL_MEMORY_PROTECTION_KEYS as is.
    Eventually, we will be moving to X86_MEMORY_PROTECTION_KEYS after
    couple of kernel revisions. 
  - Moved pkru data structures to kvm_vcpu_arch. Moved save/restore pkru
    to kvm_load_host_xsave_state/kvm_load_guest_xsave_state.

v1:
  https://lore.kernel.org/lkml/158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com/

Babu Moger (3):
      arch/x86: Update config and kernel doc for MPK feature on AMD
      KVM: x86: Move pkru save/restore to x86.c
      KVM: x86: Move MPK feature detection to common code


 Documentation/core-api/protection-keys.rst |    3 ++-
 arch/x86/Kconfig                           |   14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h            |    1 +
 arch/x86/kvm/cpuid.c                       |    9 ++++++++-
 arch/x86/kvm/vmx/vmx.c                     |   22 ----------------------
 arch/x86/kvm/x86.c                         |   17 +++++++++++++++++
 6 files changed, 40 insertions(+), 26 deletions(-)

--
Signature
