Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93694433444
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 13:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbhJSLED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 07:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhJSLEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 07:04:02 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D4AC06161C;
        Tue, 19 Oct 2021 04:01:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 75so19013853pga.3;
        Tue, 19 Oct 2021 04:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cgY66n6bzkNSfBJEVaCeCJZfl0VGEk0DYQ8DubWzqUE=;
        b=agQ1Bs84IFWTBslOLrsdlItzELZOM4PpTi6mZK1O2icypbLdGiWPqgcL8WuHF0g7F4
         zGJbANtLV915W+ZIAg/8BT6URnVHvQ/elN9NCe6ZQF3g4BmVrKSh3yNRmspFkMF6WEXb
         fa9MICevxlSJj7w1Wv0pCKWHBbLNt4eMxxHPYqdDn1/VQNOEG3xgLfsC+4gSyuIlUR6z
         EZFYx05Mxtj2iHRmeqpDTXCdFKrTXKmc9rPZauozBp6aJ0Qf4OpP9NQ5hDxC4OVzL9tg
         BfIyH4GKAWnBG+DsDnjnyz95IKh4aeQwbC7IczLzjHXEY5pVv4aHNiHbppDRRUE0QFKE
         etDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cgY66n6bzkNSfBJEVaCeCJZfl0VGEk0DYQ8DubWzqUE=;
        b=JiiKYX0cvv2O0I/KFaWi9s5srVOIQSJtsXLPSz4m48ewbqbrRqZwUefwDGANQ4TYYU
         MIEaW6r+MhweuX6eac8JSnhPYXGFLE3VoAeQxmdfTAt+H9qT92UZdOgVh/SbV3juCfu7
         mewQbG1Ls5WHgRto1gkRkhXxDQ/qo9r0znbjffkbw4nEc9p3tvDPuSwlU3083w1R4Qrs
         SA1wzXRWG0irUzZ4VGpwXLTVL1Ps4fmS/2m/kJK7yuSJlHBMBdz0GSfnIIekIoXn6ltJ
         0bVqp7INvKU4ezFi6ubkRW9Hws6RnALdZjtrgYD7ue59e9GKuvIr88m2fnP2D8j5+IZi
         vAuA==
X-Gm-Message-State: AOAM533tTugANsv5KJeFFlsA+PZ3k/isADbSr0fkVf87LMbefOd9UbjT
        B6xVZ5sQMcfwZ9exodt7gOzV4gj1zWQ=
X-Google-Smtp-Source: ABdhPJwCn5MWqjD1OzGEoQOfvHVlYsd/97ztNtBf7TayoNrIy1+joD53m0o19Nicg/2bbDv4xl1oZA==
X-Received: by 2002:a63:7355:: with SMTP id d21mr16444975pgn.179.1634641309819;
        Tue, 19 Oct 2021 04:01:49 -0700 (PDT)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id bb12sm2529306pjb.0.2021.10.19.04.01.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:01:49 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 0/4] KVM: X86: Improve guest TLB flushing
Date:   Tue, 19 Oct 2021 19:01:50 +0800
Message-Id: <20211019110154.4091-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The patchset focuses on the guest TLB flushing related to prev_roots.
It tries to keep CR3s in prev_roots and improves some comments.

Lai Jiangshan (4):
  KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
  KVM: X86: Cache CR3 in prev_roots when PCID is disabled
  KVM: X86: Use smp_rmb() to pair with smp_wmb() in
    mmu_try_to_unsync_pages()
  KVM: X86: Don't unload MMU in kvm_vcpu_flush_tlb_guest()

 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 63 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c     | 53 +++++++++++++++++++++++++++++------
 3 files changed, 95 insertions(+), 22 deletions(-)

-- 
2.19.1.6.gb485710b

