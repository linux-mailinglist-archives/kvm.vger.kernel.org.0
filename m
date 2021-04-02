Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C63A352D62
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhDBP1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbhDBP1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE46C0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:00 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id o126so8115888lfa.0
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZjsS1bI2uKq/2mrnLoFtUTJW7+/w5vjC+pfAdCGzd/4=;
        b=sLsxFjLldrKmyHyURfqQVaKuUqWfHVD0j45vA/YcBUS7CK7j45ipCGAFB8I3JUaul7
         EeEMeHuOsEsTv/LrV3rlZXAaQxWH6eHqX/HhMPc2amFnqgahdYRDYS01rQ3A3gNG09Q6
         /wpQeMSCIKilbzP9PBU+7XDjS3/CKdHWx5T4wwUIHeCsLzuHQfv2lJ0sHOn2ypoBLhsr
         ffP0o/FDsjV36uhUX+CKEbJ28/nBdgfXMNS+cPDy0ExO4c6D5sPQoPmVHZnpD4tMFq0A
         jDdGh3Vgx9XQFa3JfbWE5j+nPUsokwi2vRJ+mCVB5TiW94Z81EUfv0ybUkXSh2ftQIiD
         tN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZjsS1bI2uKq/2mrnLoFtUTJW7+/w5vjC+pfAdCGzd/4=;
        b=ueOA2CBom28vTXeRF4Jo7KN9SxObl36rPVjngY0WdFS4irE+8X+3T/2l5L2FztozAn
         TAo7z6vgwsJjM3QpiVKQrnoyU0FJ0kK39FuaIep83SDd1jJWsMGb2pSZFbq4RSjZtlpy
         go6RmHC/Dh/ZH8Orw4dM4+btGv9L66EDRIxORzYllzYazby23D2+CQyOGI9kq7ndebxb
         wg3DBdTN+GXCQLD5212YKF21fzT0QS6wt8y9IS4mslvESYnHerqy2LPNJeQ+c/5ZidBZ
         PWMKyoJ8Yvp05tmvNOZfsLEwdrxaifh0YUts+H7SWQpzIFnHdfnRumYkn1V84IZT3kOS
         i7Qg==
X-Gm-Message-State: AOAM5322IBJod/4gCZK8GA2XQT5Rm9pnfeTWfmUWcjZ57gAqOFrdnk61
        z4k7anX/pCrtYCICjVrufcfnqw==
X-Google-Smtp-Source: ABdhPJz8iSga8n37GQkADy+ssjbmrF28xrjeJGW7r3kmWl1I/wA1rNnTc3V3f/miI9fjdcL6UCQoyw==
X-Received: by 2002:a05:6512:21a:: with SMTP id a26mr9409958lfo.507.1617377218429;
        Fri, 02 Apr 2021 08:26:58 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o11sm950978ljg.42.2021.04.02.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 1E1E310257C; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 0/7] TDX and guest memory unmapping
Date:   Fri,  2 Apr 2021 18:26:38 +0300
Message-Id: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX integrity check failures may lead to system shutdown host kernel must
not allow any writes to TD-private memory. This requirment clashes with
KVM design: KVM expects the guest memory to be mapped into host userspace
(e.g. QEMU).

This patchset aims to start discussion on how we can approach the issue.

The core of the change is in the last patch. Please see more detailed
description of the issue and proposoal of the solution there.

The patchset can also be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-poison

Kirill A. Shutemov (7):
  x86/mm: Move force_dma_unencrypted() to common code
  x86/kvm: Introduce KVM memory protection feature
  x86/kvm: Make DMA pages shared
  x86/kvm: Use bounce buffers for KVM memory protection
  x86/kvmclock: Share hvclock memory with the host
  x86/realmode: Share trampoline area if KVM memory protection enabled
  KVM: unmap guest memory using poisoned pages

 arch/x86/Kconfig                     |   9 +-
 arch/x86/include/asm/cpufeatures.h   |   1 +
 arch/x86/include/asm/io.h            |   4 +-
 arch/x86/include/asm/kvm_para.h      |   5 +
 arch/x86/include/asm/mem_encrypt.h   |   7 +-
 arch/x86/include/uapi/asm/kvm_para.h |   3 +-
 arch/x86/kernel/kvm.c                |  20 ++++
 arch/x86/kernel/kvmclock.c           |   2 +-
 arch/x86/kernel/pci-swiotlb.c        |   3 +-
 arch/x86/kvm/Kconfig                 |   1 +
 arch/x86/kvm/cpuid.c                 |   3 +-
 arch/x86/kvm/mmu/mmu.c               |  15 ++-
 arch/x86/kvm/mmu/paging_tmpl.h       |  10 +-
 arch/x86/kvm/x86.c                   |   6 +
 arch/x86/mm/Makefile                 |   2 +
 arch/x86/mm/mem_encrypt.c            |  74 ------------
 arch/x86/mm/mem_encrypt_common.c     |  87 ++++++++++++++
 arch/x86/mm/pat/set_memory.c         |  10 ++
 arch/x86/realmode/init.c             |   7 +-
 include/linux/kvm_host.h             |  12 ++
 include/linux/swapops.h              |  20 ++++
 include/uapi/linux/kvm_para.h        |   5 +-
 mm/gup.c                             |  31 +++--
 mm/memory.c                          |  45 +++++++-
 mm/page_vma_mapped.c                 |   8 +-
 mm/rmap.c                            |   2 +-
 mm/shmem.c                           |   7 ++
 virt/kvm/Kconfig                     |   3 +
 virt/kvm/kvm_main.c                  | 164 ++++++++++++++++++++++++---
 29 files changed, 442 insertions(+), 124 deletions(-)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c

-- 
2.26.3

