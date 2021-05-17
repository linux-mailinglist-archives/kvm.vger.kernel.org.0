Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA62382E21
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhEQOC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbhEQOCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:02:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3CBC061761;
        Mon, 17 May 2021 07:01:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d78so4141718pfd.10;
        Mon, 17 May 2021 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p6jAyFEHVFCxlZGpGxYbrWuXzrXvA1+9+mG4jRlrIQk=;
        b=hDuAmQ4A43GWP0rKjcktZ9hykeiArJVyGcpT4ujdQRFXSuywufDCZFAYgkM2exL46R
         CwYqu8QPpPsZQvgWPTT1EfxUKKA5uEpuCb0xc199tMlwKt67dquZw7yFdxF7BC9Hf06i
         gROqkq6d/HN1ithnaqgpCkOgwFuUpflhf3GjiQb++cKtJnwnAWVSXDHZGbp+/2abu9m8
         pqNeC5PPQNUw6jyeFCDYhqB6ne1SEMGXPztMw/HAbAu6oIxMET7PePOTNzTFrw3yX/Aj
         0k7husLzMEEQJ3QCU4/vNMKH3yqX0wgac8QI3+pnAvBC6FNv0GlnPVBbO633fl4WJIcQ
         t+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p6jAyFEHVFCxlZGpGxYbrWuXzrXvA1+9+mG4jRlrIQk=;
        b=X0h/x0Z+1RxriOTzM8ToK84BYQx67sCePFAj6GYt+VrQmYChpUNr0jFtDHyRIh7fkz
         8l/BHWRFVC7M2MU/8Em85RnZmkAQHiHFllBd5yVgTnagCVPeJN50Z4QOiGtWkiDE9UR+
         OZn0uy0NgwR70s8LPjP3WuGlPCfiTLFol7pkiCcC62b5SMkTUK+fi23uneOdpP+nCeER
         D1FKBYSaT/GeWHfpir65PvBiwyEd00jtnVPvMj24dgijcO7TLyuG6BSayWZ1hEkTpoAM
         AoHgLCfJDq3ezY3kMeBLgz4CFHwAFBVy6hvq8VY0+xTUljWq2TdPdV6hOfwm9zH3PGlr
         kr9w==
X-Gm-Message-State: AOAM532/7L9bUCznphbQnxEFKnIDtXGKirkbJT86ox69ozUITLkDyNFv
        Upkwq20cfRwOYW153sa0S19Rt8El4yc=
X-Google-Smtp-Source: ABdhPJwj9HbY7SlYmRb/kfzs3XrJiDdyRtN9RdDvWJz/I86GDCxyl34GyEAXm4sgQnz/hmSL5B9ePw==
X-Received: by 2002:a63:571d:: with SMTP id l29mr9510292pgb.179.1621260090676;
        Mon, 17 May 2021 07:01:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id k10sm3074229pfu.175.2021.05.17.07.01.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 07:01:30 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 4/5] KVM: x86: hyper-v: Task srcu lock when accessing kvm_memslots()
Date:   Mon, 17 May 2021 07:00:27 -0700
Message-Id: <1621260028-6467-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

   WARNING: suspicious RCU usage
   5.13.0-rc1 #4 Not tainted
   -----------------------------
   ./include/linux/kvm_host.h:710 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
   1 lock held by hyperv_clock/8318:
    #0: ffffb6b8cb05a7d8 (&hv->hv_lock){+.+.}-{3:3}, at: kvm_hv_invalidate_tsc_page+0x3e/0xa0 [kvm]

  stack backtrace:
  CPU: 3 PID: 8318 Comm: hyperv_clock Not tainted 5.13.0-rc1 #4
  Call Trace:
   dump_stack+0x87/0xb7
   lockdep_rcu_suspicious+0xce/0xf0
   kvm_write_guest_page+0x1c1/0x1d0 [kvm]
   kvm_write_guest+0x50/0x90 [kvm]
   kvm_hv_invalidate_tsc_page+0x79/0xa0 [kvm]
   kvm_gen_update_masterclock+0x1d/0x110 [kvm]
   kvm_arch_vm_ioctl+0x2a7/0xc50 [kvm]
   kvm_vm_ioctl+0x123/0x11d0 [kvm]
   __x64_sys_ioctl+0x3ed/0x9d0
   do_syscall_64+0x3d/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

kvm_memslots() will be called by kvm_write_guest(), so we should take the srcu lock.

Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs)
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..f00830e5202f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1172,6 +1172,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 	u64 gfn;
+	int idx;
 
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
@@ -1190,9 +1191,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
 
 	hv->tsc_ref.tsc_sequence = 0;
+
+	/*
+	 * Take the srcu lock as memslots will be accessed to check the gfn
+	 * cache generation against the memslots generation.
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
 	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
 			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
 		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
+	srcu_read_unlock(&kvm->srcu, idx);
 
 out_unlock:
 	mutex_unlock(&hv->hv_lock);
-- 
2.25.1

