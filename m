Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1771923CC91
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgHEQwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 12:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgHEQtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:49:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76992C0A8938;
        Wed,  5 Aug 2020 07:11:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so24510493pgq.1;
        Wed, 05 Aug 2020 07:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gnq2bYcLCYbS7fB6hPJYIGySV/efaN7joodM7bHp3HM=;
        b=mGGnDTpNY8ZF+dLJA+3RJn/hk+73NVX1GPiWuFeKj+prG1T5Q8RHEnAe34YY7ukHRh
         C9nNFsKDK339IwgGBO4ithBKkz6AQSgtkyiJzTUXPPI+SF9/zjSlJ3GmJQbHhepK72cs
         i0nwwk1P6k9gGvDitoQ5lD+4hQDzmYv49X2pGW/d3uNqLhLzH0wO4oPzqwI1Fs1Vpi01
         OWCldIcCxihrBnDzIWcJaNL9kjCR6ErUPUQ6nDigCLnEbr0ObGtSWZ76VyZxhFTo4Obl
         vqQr+3waWg9fZ/qrUl/4lfkLv1DAwOJAZCzyMehir3PlK6cc9umER0w/WUJNmlSUS9qZ
         7CYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gnq2bYcLCYbS7fB6hPJYIGySV/efaN7joodM7bHp3HM=;
        b=ll40ktqYFkDll/eFP8oNlInzcdHl8eaC5GWXDhOk97yeEinYji2P7l33r3BiDv7kWG
         9lIDsDXcJGPgTpNd+C2rm6cXgQrSSG5mou+c2dR8ckFzS8CvZxgasiapIA8fspNJMo7/
         b/pMHlvLJCND0FHsJvaeb3MIj+pWZphqZWSFTnOhPgjX6FqWXh5oF2odcA+Hgotur6w1
         HbyZMHTTQ92CQwSSApG+yfVMK0ZRYWuscLeqfX7FzpqIwH0Y29Ri7fiRi+7/23F8LvTA
         kHAKg2mzrB3rBNveqNBkt/ItRFHlbYNGzcS88Uf1tjw1yzhaGOcYlQ3gPrWVcXbXLD/6
         2icA==
X-Gm-Message-State: AOAM531cJHyPvxK3dL2+Oidd+9anwJeLPQJTOKwWBE2h0sg/NzQXMKyF
        7eNdYiGwbL5qwQJ1u6OVP0s=
X-Google-Smtp-Source: ABdhPJy77TbI6/Hga9l/DBSuyThrNPQZmn3Gth7qz6s8qSxdXr8BWBae5Rt5ikEaEgOlo8d1yiB2zg==
X-Received: by 2002:a63:4c22:: with SMTP id z34mr3191367pga.370.1596636680035;
        Wed, 05 Aug 2020 07:11:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.gmail.com with ESMTPSA id z29sm3898453pfj.182.2020.08.05.07.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:11:19 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 0/9] KVM:x86/mmu:Introduce parallel memory virtualization to boost performance
Date:   Wed,  5 Aug 2020 22:12:02 +0800
Message-Id: <20200805141202.8641-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Currently in KVM memory virtulization we relay on mmu_lock to synchronize
the memory mapping update, which make vCPUs work in serialize mode and
slow down the execution, especially after migration to do substantial
memory mapping setup, and performance get worse if increase vCPU numbers
and guest memories.
  
The idea we present in this patch set is to mitigate the issue with
pre-constructed memory mapping table. We will fast pin the guest memory
to build up a global memory mapping table according to the guest memslots
changes and apply it to cr3, so that after guest starts up all the vCPUs
would be able to update the memory concurrently, thus the performance 
improvement is expected.

And after test the initial patch with memory dirty pattern workload, we
have seen positive results even with huge page enabled. For example,
guest with 32 vCPUs and 64G memories, in 2M/1G huge page mode we would get
more than 50% improvement. 


Yulei Zhang (9):
  Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
    support
  Introduce page table population function for direct build EPT feature
  Introduce page table remove function for direct build EPT feature
  Add release function for direct build ept when guest VM exit
  Modify the page fault path to meet the direct build EPT requirement
  Apply the direct build EPT according to the memory slots change
  Add migration support when using direct build EPT
  Introduce kvm module parameter global_tdp to turn on the direct build
    EPT mode
  Handle certain mmu exposed functions properly while turn on direct
    build EPT mode

 arch/mips/kvm/mips.c            |  13 +
 arch/powerpc/kvm/powerpc.c      |  13 +
 arch/s390/kvm/kvm-s390.c        |  13 +
 arch/x86/include/asm/kvm_host.h |  13 +-
 arch/x86/kvm/mmu/mmu.c          | 537 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |  17 +-
 arch/x86/kvm/x86.c              |  55 ++--
 include/linux/kvm_host.h        |   7 +-
 virt/kvm/kvm_main.c             |  43 ++-
 10 files changed, 648 insertions(+), 65 deletions(-)

-- 
2.17.1

