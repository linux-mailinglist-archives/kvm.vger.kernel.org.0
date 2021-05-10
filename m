Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDC0377E07
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhEJIXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhEJIXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:23:14 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012BC061573;
        Mon, 10 May 2021 01:22:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t193so216643pgb.4;
        Mon, 10 May 2021 01:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dhMvoxMJAO0uO8IA2H0TKE6ifTGSTb7TdUN9wUYY1wY=;
        b=rF+VTgtqNWExfkHPyubomVntp5D64QNIvFRhbWNDq6JUqR6drFXxO2hUq73WoOb4A+
         SXOJgOFxNcvt44dK+celf8J3digKOAsuPwycGLvcaaHB/tHudcZcGzYjb+ce+eNCEm5Y
         w1w7mnQROzs825bb6dI+/Ueisd7QaGmUSyyHHzsOrxhPaFiyt2PlTlOrvpueeDTt24Pz
         waUwUJhvvCcbpGEmlvPq6YugzUH0ga9pv4L/PLrps/YtrJPioHxChF4RezJHTP89GA54
         XVo5oXSsoj8GaAu8br8RIuD/SSQuPkATQhlrx3Ga5B2ACa6PpiZiE5By+lDUoVaUWz1K
         BkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dhMvoxMJAO0uO8IA2H0TKE6ifTGSTb7TdUN9wUYY1wY=;
        b=jqnXwF3gIcCmTusClvtZ4CmQItUK73p7FS9NTQ9S/tR3WqsJma1s5ZU3I+2sfmH1Rf
         DiG99sU+YBUuIpRH0CDh5Fe19N8Jf5Unao4v5CeSkG0kkp8p8SQlDhAKhWIsUKLUVBIi
         6pXnuOCKp/WZeNhPigiDetAh9giY5yUt8oT7h0fyZGDPBx5McXx9g/NSz66YKhhLhQlQ
         MGF+kf7q7mYuXJXH75TTghw2tPQSWYPR72lMMqnx+2GgqxyGF75+KW8pyy+exaR8f+RU
         TNzkT8mTBsDAMzxLuSR/udvKjOvrP6LGh0R/YhOby/nxTfx4ptA7czExYQainqZXl1U/
         2/UQ==
X-Gm-Message-State: AOAM532bU/sMZu1SbSgMAEaoHJrNUqaj3/aG+UI1TsKMHryihT+00noM
        fsEgMcqRTYXHqjU6YIYpzj93fr19DV0=
X-Google-Smtp-Source: ABdhPJzIP+6jHymcpdNkCuuBGSX0Azj04jxYye7z94O7cf+ud4WEkbUhx8ymwUTMtSHpOCMpQk7ZVg==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr24343609pgd.82.1620634929917;
        Mon, 10 May 2021 01:22:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id n8sm10477853pgm.7.2021.05.10.01.22.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 01:22:09 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86: hyper-v: Task srcu lock when accessing kvm_memslots()
Date:   Mon, 10 May 2021 16:21:59 +0800
Message-Id: <1620634919-4563-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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

