Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631F5258DAF
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 13:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgIALxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgIALw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:52:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567A1C061244;
        Tue,  1 Sep 2020 04:52:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so422147plt.3;
        Tue, 01 Sep 2020 04:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3rTng8S6klnaXBOW81+9mrDYY1I9NVTRnB9JeoS2jtw=;
        b=LcSn7KwXfafkZ0IC+YHw5KEiNnvCSWevlxP8z2DjXGAba25LnTum8hh367JdOezYo2
         su945SOoKCr6SLGAWrrDZNyxzj733IghhO9OBGKnVDWilTSKf9UeA/49n1Oo32wndh0e
         GJ7d21ncUOh+4vpNZA6vcFw3SLdwlH+juMamv4iR09qEbB8BdDnvj1Zs/H9CiVrKweF6
         Tn9Cyl+HNyOSoA9z4FOJ58sH/1vi4WvxjfCc3i7V99HdXaGiNLfJGKoDASktdRqQV5OG
         AAN1aRnOW51QSqDuUjLeCOZyRc6AgmmLeOookncCLvHomGNlAPvMWpPkRW3Cawv+7FN3
         r8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3rTng8S6klnaXBOW81+9mrDYY1I9NVTRnB9JeoS2jtw=;
        b=s21VMyY7isUOwWoK8PoumextrMy2Po5gnOptFcmGr9dc0HbtCeZaxBESznZHVivRX6
         AgsxArgCTO0YUM27R6D4d3VEpixq4ts7ZnsNs0XTljA30z9RfRnUvxpaNmR/bwN6t1KP
         f8XNIUQCny8swXH2rTsRfpq7ltpDBGOVTfm8VU41+lQWouoqRI0JZgDEv27SeAryN/75
         hGBIPYaYRXHfZbulh68ohXaxT6qMFdf0zO2KUoNrKhCm2rKyYcSbnnkoaZIQiPLDqGs0
         KSRYWiQ2/2Pa8oJElpIQPQrvEFYBfC5KN0PfJinTV+hE+o3U5Y781wUQqQDxWZbCTDfb
         lNcQ==
X-Gm-Message-State: AOAM532lrs6eo0biUJ/RuNmvS+LyPdsHnZdZllVc4ox8w3drYy+HX3Ef
        SArqtLcRGT49Tq/BFD3zxck=
X-Google-Smtp-Source: ABdhPJzajFQFmglNSy1ftQejcM7kY3dMr6o6k6FV5TerWypS4jTtWmLGRJbydsOgb7NrR6ESgRP7UQ==
X-Received: by 2002:a17:90a:ba04:: with SMTP id s4mr1280236pjr.3.1598961178901;
        Tue, 01 Sep 2020 04:52:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id h15sm1482498pjf.54.2020.09.01.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:52:58 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yulei.kernel@gmail.com>
Subject: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to boost performance 
Date:   Tue,  1 Sep 2020 19:52:42 +0800
Message-Id: <cover.1598868203.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yulei.kernel@gmail.com>

Currently in KVM memory virtulization we relay on mmu_lock to
synchronize the memory mapping update, which make vCPUs work
in serialize mode and slow down the execution, especially after
migration to do substantial memory mapping will cause visible
performance drop, and it can get worse if guest has more vCPU
numbers and memories.
  
The idea we present in this patch set is to mitigate the issue
with pre-constructed memory mapping table. We will fast pin the
guest memory to build up a global memory mapping table according
to the guest memslots changes and apply it to cr3, so that after
guest starts up all the vCPUs would be able to update the memory
simultaneously without page fault exception, thus the performance
improvement is expected. 

We use memory dirty pattern workload to test the initial patch
set and get positive result even with huge page enabled. For example,
we create guest with 32 vCPUs and 64G memories, and let the vcpus
dirty the entire memory region concurrently, as the initial patch
eliminate the overhead of mmu_lock, in 2M/1G huge page mode we would
get the job done in about 50% faster.

We only validate this feature on Intel x86 platform. And as Ben
pointed out in RFC V1, so far we disable the SMM for resource
consideration, drop the mmu notification as in this case the
memory is pinned.

V1->V2:
* Rebase the code to kernel version 5.9.0-rc1.

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
 arch/x86/kvm/mmu/mmu.c          | 533 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   7 +-
 arch/x86/kvm/x86.c              |  55 ++--
 include/linux/kvm_host.h        |   7 +-
 virt/kvm/kvm_main.c             |  43 ++-
 10 files changed, 639 insertions(+), 60 deletions(-)

-- 
2.17.1

