Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15883BA48E
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 22:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGBUNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 16:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhGBUNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 16:13:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F4DC061762
        for <kvm@vger.kernel.org>; Fri,  2 Jul 2021 13:10:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id w191-20020a62ddc80000b0290318fa423788so1241pff.11
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 13:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fpTMG9fTauuJitLgUq7zAvCgQyWDpOArBs49FPLP0Y8=;
        b=cWJYhK77Lz48nM1zUfdkD63tuVW35Zj5TXtFYFq1P1W1qtHaQbo8Q4WJrRC6q6uhMh
         nYZkiJaDnODzk3LqLzFd8rBN/LALvb5DN7FOiYvEiXblBhWLwR85YfH6LbnQdAU6Nq8U
         SALRKARCEvW5YH7ztZq5c7EXdzD27ik79eRm4bY/LsydzA5vr3HpnbK+ck59+PJi4Rn2
         nJJrU3MeSy027Xdk2w7pI5CqqYjTYvhtjyi98TKLF/Z2q2xWRimt3P6xSuqO+2AMoeFl
         p1EY3lSvlgrNMTbeuqsaUhOwHDSBTkP5FaIejRDb3qnyEfcSrchzR9+uBo6psxj/R2Fw
         GC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fpTMG9fTauuJitLgUq7zAvCgQyWDpOArBs49FPLP0Y8=;
        b=YRxPtBjtRfyqMwOjvtHF91zrI3RkUNZC9zM7YqoKdpf3m0drCJG2SduNpmqXdcD1px
         R/ZxyCwSb0KQ+++zl5IXdi5W57DofCNTjYAdZa2Q+1tqQGzFG4nN6v5O0Mwvg/KqOUy2
         yh0Eca3l3PSvNjCmxKI/TvdnPtnqll47uru1XscV+ZRbU0gYQ1xvQVaEktDaEQbxfLuQ
         PfAd1AwPZChS0Mtzbqw4XIX+uvP1A4O3jPMOqE2OXDIvdc9Yrj2gG1gFy3mYqkRCLBMz
         n+DfUVyvl1sCtAK5HdojHeHync2ogAXs230DqlXRgxIloZV3xwmZhiW+9LStXvHAAN7Q
         9c/Q==
X-Gm-Message-State: AOAM5331MaGLr1bwhDA+wp08jDRz9VreX5WfESU8y9wt9WJSY2su2UQa
        nDIuopssefUPfwnHnysGwlN0l9M0pUvx2igGUikz74BGNquiwyrORS5OOZvWLZMkRr9HRbqsvHt
        6eF19lXvJRSphOndkFFNb3DUDBd831Qh2wsGHWRcOLYBc3miZd1I/98aZQ5AYH8s=
X-Google-Smtp-Source: ABdhPJxGiYdV5yfa5L2g288Y7UPX8c8X/2XRZTO42+QGgpt9/aMwR4B2q9GbJz60UPQnwc7tat7p1qqFeRBQKw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1411:b029:302:d9d6:651d with
 SMTP id l17-20020a056a001411b0290302d9d6651dmr1254121pfu.56.1625256645780;
 Fri, 02 Jul 2021 13:10:45 -0700 (PDT)
Date:   Fri,  2 Jul 2021 13:10:42 -0700
Message-Id: <20210702201042.4036162-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] KVM: selftests: Address extra memslot parameters in vm_vaddr_alloc
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        seanjc@google.com, maz@kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit a75a895e6457 ("KVM: selftests: Unconditionally use memslot 0 for
vaddr allocations") removed the memslot parameters from vm_vaddr_alloc.
It addressed all callers except one under lib/aarch64/, due to a race
with commit e3db7579ef35 ("KVM: selftests: Add exception handling
support for aarch64")

Fix the vm_vaddr_alloc call in lib/aarch64/processor.c.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9f49f6caafe5..632b74d6b3ca 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-			vm->page_size, 0, 0);
+			vm->page_size);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
-- 
2.32.0.93.g670b81a890-goog

