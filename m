Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2DA1CB97F
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 23:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEHVJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 17:09:51 -0400
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:6097
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727088AbgEHVJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 17:09:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOzViDWIXpz9p50aSrQztQE8MEN5xiRNzFt98I2ZNl9azcUAtZqTkiu8iLloJWbQvHh0G18WymQGl5pNmEDbRi5DeniLtsRlHvJeH0xdA0I6wuC658VZFncEzrWTkoOfdztKE4g5COzM5LkVwWRmseqPD4iYU6cnu/ZTbh4I5end4YPgj6+4kNgS7J2K9M3nyW59a29V83seHsof9hgbPex1cm7lkOYDkeFb68Gh7l137pN9BwfsZJEnomKo2dG/bWhvuN9aBQnAiTweF1rxVcXR3RoznLGaG3ZxcTDsUWilYRylx2CRP17yx7VU++A067ghh00YzNimNlOjCKKc/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55OWPmbFkE16QROd1bFJxGuXEuFYoAgCuzOyoubLayQ=;
 b=VOvFGGJj0J4Jat6HAvNFdszrzAX4QJMtdusksDCG97O0ar026EDG7ju8PLO6xIvTUKv9Oldq3DzNcBp6qCuBDBd+L0t7JU2irthK0i2545uRyAhb1hGYbUdXTkGm4lQOL2ok0RHxf2jzsJDPWtPDjOmxhi8+/Pu8ZmNEv/ELDKGr/09cQHtLurAWMqicdOKxh+FLl2dxcaWDzDW68DDH6uww+GEHQnNMqVBhC7IP985VwmTdXY/frrzK8OaOs2lGjg3oyAdVOHKLKxl3oxIpTHGWV2CaHANTF+rL2dO7pyTmjZV3LL2a76TIQgwH5pvbxgOd0fnbFJVBhkxpTJQQMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55OWPmbFkE16QROd1bFJxGuXEuFYoAgCuzOyoubLayQ=;
 b=2octv/pbT1rJsdruU23SYuXRuLlRyMXXwbi4W0W8bs/Hcot7sCrGgso9BXjYUk3r1OLwSfkEMh1mUKOjCN0nMcsb0bNX+NbSIFNmTDEuPfZK8UpyLhRIXTN73r8XgnBU9yY0V708wDoKUTcxbWfJCDK+COhpvb0GPxQCjWJXaL4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.33; Fri, 8 May
 2020 21:09:43 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 21:09:43 +0000
Subject: [PATCH v2 0/3] arch/x86: Enable MPK feature on AMD
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
Date:   Fri, 08 May 2020 16:09:40 -0500
Message-ID: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 21:09:41 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 325917d1-56a8-4602-d6dd-08d7f39420c8
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:|SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2591752BD22868BC6C57BC4195A20@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDrFiE3TTxkh+t5k77ckEKFWJkoUsdjTH2LxxOI78+Nh8pMGl0gmv5hOmg7QZqXgn0iUHqJ0OJeAgZzuc9RF20h7mS0/k1ubS7VaKkSP5lY5M/LVvgZENN2ehKxYX+4az+pJ8By3IiQdTeLARS+6GFGWCFHsvAKPzpkM2kPV/mj/kyAWv2l/PxrUTeQRtFYFibnFNLTi1Hxqih4Bs0nXj4W7ZDV9FFaTRew2zhJQqWYtpQQTtpUmXxuPUpc4EIl1AivHIL1RWyVVbfnKDUY6hOS5t2R1bJFARw/bjF0pLQp1UGf0r2aGHcqkPpPDEWLuflur2TQLo+SCXFpMkuWIu5uikP7UJtSwtuPJIitf4ddt/6ZbpkJje3ebenNJivOJlr9nP7Dpj+3jfwUDptDzVYOZN155tdy+eK57MVRFT25C/yJYXlc/2ZDXHETpjYaLuuOEkh9AcLOkGr5VpF9DPpmtzxWwGObAXhPDkPt0ff1krbFBFYB2jnMm+4/ZUjf2EWH17WFslzX00gddTmScxFGvNSph2P6TklS05XaPk88FOrZBmACYG5rnXk2ZjFyhIEOz1k/+XR2Gq3RaaVxcGlsKmqLJYUQvGmNphI2etec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(33430700001)(7406005)(16526019)(4326008)(7696005)(7416002)(186003)(26005)(66556008)(8936002)(52116002)(316002)(66946007)(66476007)(33440700001)(2906002)(44832011)(956004)(478600001)(55016002)(966005)(5660300002)(8676002)(103116003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zmDu0/jvHkbocr7X85VYqRqBk4DsYJsMlJusIgtmQEDDSOpcuyAVtSzAlPKqxIXrdthP0+0ueRpJwYRH3YcMrt4Y2eIPfkXE/L98qZW5k/cl7vW5Hv0HkhesxvnIzUvzIYTuzaXGHdbETvDXu9xsnWCJohzKAPOzcXxZroXzK8q58nZeK7WNlxUwTXMKZCAylECJflsTHQTXa1H//SbSRZGJOlWyi68yfh1hxhbjU7wLXDuxDA6yi85sdBCHRJpJufvsLx6EL6mY4FpA7rWACm44SaVzd/slKvnHZRjYXNcTEJKDIDfXvUWS1e4+ipf6cLzaWl6WgWNUYgy9HigDwaiArIZZ71XmgqHSBH+aCdGOb7GOdnTwAK2/HiZ0vuxiUOMX7c6qZVYUpHCuOIDwzBRuiHJPbgMka2PY9Q/xpZq6RmMgGxiHuMzLmlOQQc/9Ca85mWhpHPCf28Ny+uKprAcCpemHx7P4ZjngF34vfLY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325917d1-56a8-4602-d6dd-08d7f39420c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 21:09:43.0065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bPueknMWfiVGiOpb7dReMa9fCFs8rR/SoTrigVaPaAK3UDfUck2tIZ39sAye6tN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
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
v2:
  - Introduced intermediate config option X86_MEMORY_PROTECTION_KEYS to
    avoid user propmpts. Kept X86_INTEL_MEMORY_PROTECTION_KEYS as is.
    Eventually, we will be moving to X86_MEMORY_PROTECTION_KEYS after
    couple of kernel revisions. 
  - Moved pkru data structures to kvm_vcpu_arch. Moved save/restore pkru
    to kvm_load_host_xsave_state/kvm_load_guest_xsave_state.

v1:
  https://lore.kernel.org/lkml/158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com/

Babu Moger (3):
      arch/x86: Rename config X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
      KVM: x86: Move pkru save/restore to x86.c
      KVM: SVM: Add support for MPK feature on AMD


 Documentation/core-api/protection-keys.rst     |    3 ++-
 arch/x86/Kconfig                               |   11 +++++++++--
 arch/x86/include/asm/disabled-features.h       |    4 ++--
 arch/x86/include/asm/kvm_host.h                |    1 +
 arch/x86/include/asm/mmu.h                     |    2 +-
 arch/x86/include/asm/mmu_context.h             |    4 ++--
 arch/x86/include/asm/pgtable.h                 |    4 ++--
 arch/x86/include/asm/pgtable_types.h           |    2 +-
 arch/x86/include/asm/special_insns.h           |    2 +-
 arch/x86/include/uapi/asm/mman.h               |    2 +-
 arch/x86/kernel/cpu/common.c                   |    2 +-
 arch/x86/kvm/svm/svm.c                         |    4 ++++
 arch/x86/kvm/vmx/vmx.c                         |   18 ------------------
 arch/x86/kvm/x86.c                             |   20 ++++++++++++++++++++
 arch/x86/mm/Makefile                           |    2 +-
 arch/x86/mm/pkeys.c                            |    2 +-
 scripts/headers_install.sh                     |    2 +-
 tools/arch/x86/include/asm/disabled-features.h |    4 ++--
 18 files changed, 52 insertions(+), 37 deletions(-)

--
