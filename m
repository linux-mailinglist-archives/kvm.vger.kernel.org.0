Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01F37F113
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 04:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhEMCBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 22:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhEMCBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 22:01:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD7C061574;
        Wed, 12 May 2021 19:00:02 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l70so5146412pga.1;
        Wed, 12 May 2021 19:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v/Eg2aLgMEl3C9DBh5TiPixhOAqZrBo8ju/YFJi/mRs=;
        b=H0Vf/PzvX1Az7P3qelVGuIU3tInxn8PVF40BcYsq29zt+CjKyrEcg8OJGUm7V7Vw6z
         8xLwCXBwBcfozuhpSdADU4XabIQxvQ0WL5ULDTgQrtmv24EfQk8CIFRyMQ8XFrec++ng
         NU1EefB1Vg3LaDJ6AMhhqaYSWYB+ujA+1KiDdFgZWvD9FQirxc5J3cScWqA9eJDr6cfY
         tKPuxK0fgiQzze8lQRkj01lDBuv1Fd/lmfJiLwLTX3CHqphuhql0kR4mB/wH4CJJ8dDG
         bnuUjk40oFgvnzqtUYlTwdvEnks0ZWKMn2knaehUGKeXzeJ1pJBzkmxy8ol8js6uRwW2
         v3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v/Eg2aLgMEl3C9DBh5TiPixhOAqZrBo8ju/YFJi/mRs=;
        b=AeC3/M+HSJda7iksqqEOyndFTTlxNmGF3vv3fjy+AFyoCcMXTbOpV5lju3Eb/0HcI6
         Bk1yinnss1AzA0Z7d6bIb3zOX5yuv1pAGCkiP7kupp/KyZ7b9qDbPqdt58CmN97JMyUI
         hycKyFfc+8pOFkt1a+uaLpUQm8ItHQqIbSTLDWEeaaT/r+aecsNOzFLS8PDxcl3q2SLP
         IHFbUgxG/FtqiQ28P8BIStRWUuJ+F19FfI6heFpdd/zbh9WzvSNMLFjRYIPELbXfPSzS
         UFdrqYrTtjWdc5oSdy8aoHPQSiHR0zWrlYMdu1gEAhb6W3vApt+Ge/Ic7oP19Ql6o0Jb
         7Q4w==
X-Gm-Message-State: AOAM530m1W8HfTMmPqrEJPCLRfpzp1plagUwOkYa54ZnKx2hn1IPIWsW
        EtPQNm5rgdd4QSBwQXuMYSdn/jdsULA=
X-Google-Smtp-Source: ABdhPJzibtVAUmXcXbhH3CJXurXNW/vy8qrWyWeimKensF9A9n0fD8mjbfb7Kpy+62MsfQ4hHemqVg==
X-Received: by 2002:a17:90a:510d:: with SMTP id t13mr1782767pjh.1.1620871202379;
        Wed, 12 May 2021 19:00:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w123sm812742pfw.151.2021.05.12.19.00.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 May 2021 19:00:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 4/4] KVM: x86: hyper-v: Task srcu lock when accessing kvm_memslots()
Date:   Thu, 13 May 2021 09:59:49 +0800
Message-Id: <1620871189-4763-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
References: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
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
index f98370a3..f00830e 100644
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
2.7.4

