Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA638784D
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349025AbhERMDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348967AbhERMC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:02:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6831C061573;
        Tue, 18 May 2021 05:01:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1409791pjb.5;
        Tue, 18 May 2021 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p6jAyFEHVFCxlZGpGxYbrWuXzrXvA1+9+mG4jRlrIQk=;
        b=tqDT9KxazuovNRmwbS4IDOkVHtDo6mjoMa1uRcY3W2LdtNltNuSGmnD9tTl3RSQRPV
         aQ40q/O/ydu3Y+oKrfdL8Grga0tnbpgOaQ/H7F+2BDsN/WI0LNNlNaQ7OSpCDa76b6Zt
         zNIPVabi3l57HxgDO1vD/JsZWAZ47QxOOfEm9NrNrxsXoLQbYTm8pX1ag0ODn9yviFCx
         iLXc4NAHQqB/9TpyZ12s/FfjZLVLOia3t/kfxgqSrdOMzLmJLR2DThE3+NMd54ITF8us
         0zuq6SW+9Hf0wB9ZaKI4HMvSFxK8Q08syOS6UtQcM7P3MJmdfqM4e/6rkIDWPMNCE13E
         t8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p6jAyFEHVFCxlZGpGxYbrWuXzrXvA1+9+mG4jRlrIQk=;
        b=RCdIfmXn7beW5k4nJPNKJGKCK0+Dxoga/D/EF60MDE5TTn843KzJtV0X/2yoHMnHPx
         cEGhghxDJziwVAPEjUz8JPQwHOYTK7bKO9wos3sP1pJT9XlAhhayhgykxpgTsdpn5IwT
         bLK+3fQVjNQEQbB5pooswYYPLhhxY6wHygR9RPJ17OqOA8zgWtUikQ+MPQG0I3pNkVZ9
         mTe/WVDpurGZ5UVE6/pzUlvAYadZZntaNrmxPvrXral5/Fo5rD2IBTRU7ZeL+luUTjL6
         hEXgHsvPFSu/ub+szPZtjb4lyuw+Y4ogAzmICl/5emSsS033UqRw+2C6C41gQkZ3WZw5
         b3Lg==
X-Gm-Message-State: AOAM530DLRnn56OvMbSfwsNtPKYPXd3pzsBs0nAd5iXV0ncmzgk69LzD
        fh4MJa7DppRU1XUFoAxGq/7teA1O/sk=
X-Google-Smtp-Source: ABdhPJx3RfT9dV9jIXyfohnH4+VlEo/N3L8V1FP0l3Eoi6Fi1Sa88+ub7ujncc8i0vPmhKB89Z8WYQ==
X-Received: by 2002:a17:90b:ed5:: with SMTP id gz21mr5200301pjb.102.1621339301043;
        Tue, 18 May 2021 05:01:41 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id l20sm12757394pjq.38.2021.05.18.05.01.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 05:01:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 4/5] KVM: X86: hyper-v: Task srcu lock when accessing kvm_memslots()
Date:   Tue, 18 May 2021 05:00:34 -0700
Message-Id: <1621339235-11131-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
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

