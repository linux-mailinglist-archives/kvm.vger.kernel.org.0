Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11AD1CE91A
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 01:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgEKXcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 19:32:55 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:11396
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbgEKXcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 19:32:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwbFDuvhIr71DrUViwJGHMFfobfRjxzkOt8iA94FObayCMpoWQQwMFeRitznJbc8KHhh2A1Bn1NZILZYBOfNJ6dzudIaoc31TKQoFwTBerjdJE9j4XhdKdc4hDSpfnQ3peKbwvw+NvJH5ws5W3n0omvi5s18Jrdj8TXbHr4xg6cnaBnP1ylWP/Y+A4kHLQ1V0SZgMfC7tK5CLFjTkQyqCOgThFypdgtReqpbz+2LDOB26A6mLG9yAeeAlqYm9jDVNUlLAXYolvXtub0v1SKg6jnjBQhqFHTGOPKXwcHsa8UzThKoOv88tojJ0t17DtQhPuosH73PHsjYdQ0xGf5wxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D060MiVhROfRkaF8exhWBz9jtjcrF3IFw87Lvr+3HXw=;
 b=H89v5ytcNAl/1fG6o15zeIV7qfIkR7/TFYNfl7Y8Q6qxSuJ6cCeohGdjqkT9gf6nCJVN6aEjs6Lqm9xOBAgXtuqt52DL1yn0K/HmeQgQQnUBc3b/WbBip7SJ83oVxPKYcxdneLV8KU+WwMkJWlO+3Ra9HhoJsNSE50aOXmei0u1oTy1JnLt0IE5yZ28ZdvRYE1T/87zA3j/805ki0ehucj+SD0J43yHm6myGOJmTInWJ4YbwR3nt7dIRLQgmu/Tnhj686NL8eSmJsk7MtZj+4Nrs1r91wd34oNQ6qmuJ6Fikp9RBx0RgTpBnlylxUCvZdOzcYx249ezQ+CQV721RUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D060MiVhROfRkaF8exhWBz9jtjcrF3IFw87Lvr+3HXw=;
 b=qzPNmOkwN0y0uOjXq7/edMbgsXvz7W5uDwo9nRilihOXfBpLzmTSCFlDH97WhBw03403Sld0eszmjSdPJbtUl7z+8Mr40aFHXy0n7Rpl9gtANy1R+422hZcrXfMBCNXDmhYEx7UATN6Js9sKnLDKj5pj0qrw5AIEZI8v90IGlAk=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2478.namprd12.prod.outlook.com (2603:10b6:802:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 23:32:49 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 23:32:49 +0000
Subject: [PATCH v3 0/3] arch/x86: Enable MPK feature on AMD
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
Date:   Mon, 11 May 2020 18:32:45 -0500
Message-ID: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:5:74::24) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM6PR07CA0047.namprd07.prod.outlook.com (2603:10b6:5:74::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Mon, 11 May 2020 23:32:45 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f31ddab0-c2e5-4abd-5271-08d7f6039dc3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2478:|SN1PR12MB2478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24786E8B59EBCBB2EE11B43D95A10@SN1PR12MB2478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PjwJkVSa7A6aBEReocla0l5tm0Y06FMSxM7CTrRSA9NA8cQf1uFmAqu0OOTUSxNlfKmtE2NqBuYeusqsmHqqIRE7+XNZbXsmd13aBAt6uNV3r8Z92zIRqmxlBEUf68mE7Idfqrc/dvQDO7H7e8dS4Zg8uZd3XpKraawVKJvfHOmpc6Q3fWX4r/73Bur0F7WIMDSIDSKAo5kkP6JDXo9miVmn65XBazC59xUOHJEH71cl/J+xHx+TMa9XoBLxKF/M4WcIDLwwD/krpjmZcfcuqGZLMK5/51lbV3xqvVQ5PNukJ6GX+5klX5z2KPJtks3hC+OyCa6+en97mvvRwYKI0DDlSPGHQYI9b9KFd2D9jZf3nv0JHYasxo6EeLCUS06cZqcpsKLqahBchJD13awlaAz4WW/3SeAvo6dE7fPx6Ufm7+7K0qjLtXMu3WF8mYxGllIQH8A6mBbz+bzWD/oEkZvORBKOy1fYh0Wj9msOiYHZ5ogMEYt2LwLW3VPJGWjPfVrMwp+BKVNl7im61PcP4u7tzvvlp1IsNGy2wkb00cQcgLE6+j97phcm/9LoUfgfd8c14ym92nJG3VJtOe+Czxzq5V6F8ZyD8bQDMhInLF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(33430700001)(8676002)(2906002)(478600001)(4326008)(8936002)(186003)(26005)(7406005)(16526019)(5660300002)(7416002)(44832011)(86362001)(316002)(103116003)(956004)(33440700001)(55016002)(66946007)(52116002)(7696005)(66476007)(66556008)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hkwwX1JcmwZFCXNbQx7xJq/FFvBraB9QYtff4m3uQsohr1+NCMu/auh7og1RFhe5jJ1uoASJ7PTOY801IrCqeSEFQzVib81S9B78vtDBi09ILaBClxQszw886yeiw8dVD1Y/SZTO0+FPdg5Zsx61MQmuLF3XJHhgfcHZta8QOCxhoImh8bHJmwTcpGuLmoqNCU3gIlYOD+g4l3SUF2QOx3I5RsawB0IEiJ1WuSXtsgZhTAE9gZUP+xVpMEmHZ79wp9H0Qm6U8NsOTT6jXnvW14sYGHaGqBvuW95fVGRxyOyp+zsgfDeeLaB9PoLDfVOv0uWwEUkQBOG2H10LmLC01AE3x6+4R2rlLabAZQMc4MrWNkrWgxMydcrVxGe0kzKrO5ARneh7CvHYyTPFfKGoGrJec0IhasOHE2slPCy1dUfy4bmTpU4ATl+SIj4oaAigP4vLAxhw/MeK+gQKXN0pYLroUyiyFh1hdUHXe82BqTE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31ddab0-c2e5-4abd-5271-08d7f6039dc3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 23:32:49.1740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WeeEj17MgnzOKGnIbNsKcQ9zGC4EJvjkbTf30QIHkxEM9MmkvdzNvNWWOi9RFyOD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2478
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
v3:
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
      arch/x86: Rename config X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
      KVM: x86: Move pkru save/restore to x86.c
      KVM: x86: Move MPK feature detection to common code


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
 arch/x86/kvm/cpuid.c                           |    4 +++-
 arch/x86/kvm/vmx/vmx.c                         |   22 ----------------------
 arch/x86/kvm/x86.c                             |   17 +++++++++++++++++
 arch/x86/mm/Makefile                           |    2 +-
 arch/x86/mm/pkeys.c                            |    2 +-
 scripts/headers_install.sh                     |    2 +-
 tools/arch/x86/include/asm/disabled-features.h |    4 ++--
 18 files changed, 48 insertions(+), 42 deletions(-)

--
