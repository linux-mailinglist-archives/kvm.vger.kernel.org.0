Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91941EB1A9
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgFAWYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgFAWYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 18:24:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B65C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 15:24:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e192so12763610ybf.17
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 15:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=esuDLQ5YIiqnB7jmaMDCOvaz2pEkozZla8OGqrKe1Bg=;
        b=cX/Y7aSSYGVar3zQ/yaxlnlBTSQeonQOF0rrTUMXf6R+3APe0xdO30EAvm40NHceDA
         8GLkLDQN9Fd7luNM1yxJx3IvkMIiHxR9rrmb8Jn6c6R5j/QKxvp9E37nsKLJoBm5X+GW
         ZSfC+ToubfdrLIJqet9X0fYZMh0Wo61gEoaS9bn13VCZOeQzIEjzxz5/wHO1WbEkQSad
         pDSWplTnJ7avtOZKFJl54/TLv4Ud3LrZV+aO8eNv/GglvWp+dujm6Xe1u4CEqPGEMErD
         Yl05N8DVHrBaQCY19D31b83zsodFxcLH/Pv7IXi10jnswFSPTX3iBqc8kJwaamRcsaSS
         l9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=esuDLQ5YIiqnB7jmaMDCOvaz2pEkozZla8OGqrKe1Bg=;
        b=Mkz9V5ZagpjybPg8f0ufeMRpelPem9IC5fHFXvSTcSRDkOK63tiuGzqt5CfwaDP5zZ
         UU1S2y4YMgPG0pKiePyfYnicZ20iKbKpY0SR/eGzXJJwNIZsT5RKavhrSxS4VwqljIBi
         A/AHe2q0C+nKvNfBK9wr5xaLxCs/ZX+nK7uWXNlP9Q7/WunTagUayIT3miSgmHrVoca6
         WTl8F42WI8BJ3hdobHourqhzQZVGPqIkReYt78vhL3uCQa0akD8MfsV5PJ0CNwQ2eWAT
         xon/W+i6yr/FqaX/Aci764cCQrKQ2J32M6WL6rk2bV4r9IbY6CFHHcuYuwkUx5AGq6cO
         S/oQ==
X-Gm-Message-State: AOAM531kgmfFzwRB82Hi+blSBf5ppD/vBm9ubMFrsXbOmpnvgysQc36g
        5HDh74+ahRSTYM0WVnbV6WrhJHfi4q0pU+aeO1xSI2U++cZ6UM/nytsiLsqKubluyikdFCFT3R3
        yLoLWZTZwH0XyTc+wyjg3UnKysxrbt4Or0QyOUPbo1mzfV23Aq335ozGvnQGZo4c=
X-Google-Smtp-Source: ABdhPJyvPtpTdwRYcC2FQBjYbvWLX3qfT2kg9ta3dTGop5pTXN+yBvW9CM7uBa6KT1QGKytyNejPjTvx/3Sgnw==
X-Received: by 2002:a25:354:: with SMTP id 81mr39089015ybd.257.1591050279334;
 Mon, 01 Jun 2020 15:24:39 -0700 (PDT)
Date:   Mon,  1 Jun 2020 15:24:14 -0700
In-Reply-To: <20200601222416.71303-1-jmattson@google.com>
Message-Id: <20200601222416.71303-3-jmattson@google.com>
Mime-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v3 2/4] kvm: svm: Always set svm->last_cpu on VMRUN
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, this field was only set when using SEV. Set it for all
vCPU configurations, so that it can be communicated to userspace for
diagnosing potential hardware errors.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 arch/x86/kvm/svm/svm.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 89f7f3aebd31..aa61d5d1e7f3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1184,7 +1184,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	    svm->last_cpu == cpu)
 		return;
 
-	svm->last_cpu = cpu;
 	sd->sev_vmcbs[asid] = svm->vmcb;
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	mark_dirty(svm->vmcb, VMCB_ASID);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f0dd481be435..442dbb763639 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3394,6 +3394,7 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+	svm->last_cpu = vcpu->cpu;
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
-- 
2.27.0.rc2.251.g90737beb825-goog

