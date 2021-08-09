Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D93E517D
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 05:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhHJD2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 23:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbhHJD23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 23:28:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A6AC0613D3;
        Mon,  9 Aug 2021 20:28:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d1so19114680pll.1;
        Mon, 09 Aug 2021 20:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/ed0gDaKV+4auNbc7EJdhjHTQcL9A5qPBDfLfsEH1s=;
        b=BjdVyzF3VGwrkJN4df7DhbgvySjlcyUylGVAZWO7PqsKNCneDbmpU0vhMhWyMbPOBZ
         MdgWVtV+PQPQEx07Yw4flE3hKSro1Ap7wzsKKjHeliXKH9n32VTvJeyZBTt3tvi7k9hs
         sdKHMJGQ255ldC+fUSSoigXuVY1FNGM0EWgv4MGMHMzfX/kXf2nZtjX+Kjpp191wwshp
         5m8+tA4u35SuXwBqlWaG5c9d38N+OXUr+6bj5DTLqO24f6mwaajSAV+gzF/cC8WxUKHi
         evsyNVpZFxKB1/Xx6P7ALfDVHbNQC+AY4PvHS8uy2H9+xNEBZc/UQjUbD6seHvcwhzg4
         XsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/ed0gDaKV+4auNbc7EJdhjHTQcL9A5qPBDfLfsEH1s=;
        b=nCop1JxwB0gp/WV6JRNSdXH2s3MNFHeY0u0+dUTmxV6MfpL6KD+DO/6l63LLMZWgE3
         lor4SnYcGHIeu4h4F9+b/dJDjBt29/W+UZ3+vrl7eZOy3xAabIxBghh/vgxV9GoSlyX8
         QnFZPxvHdiJhCf/wKGwAKRrDcpbYIGIzFhV5F1P3tr6/Mw+9Xb2XklohiC+YaKLg4P3r
         rJMGtIq5MUEK/arjj0MKtBR/d/oGT32Cx/CS4LaeGBn+zkHwYplV71rPI1aFGQtOEBo2
         0V6GhW5lyVWRROdOD6YdVsF96J2HabheJeVBLNhuswUtHM89jWGRCzAF04YgCKZbx7NH
         2Nnw==
X-Gm-Message-State: AOAM531dt27JRWe5eApycLWofeITPgLaHjXlzb7h6cGscFgTGqGJzisA
        pIavyhHd4imeICKkyPruKeiPHKDlpjU=
X-Google-Smtp-Source: ABdhPJzv6VJrv87qOl6QBbPi+/OtpoeMh8LN/1Mh6Vu107huljtA0JToLg2ZJWOzax2i5DM9J4DfXQ==
X-Received: by 2002:a62:cdc8:0:b029:3c4:e67e:2c0b with SMTP id o191-20020a62cdc80000b02903c4e67e2c0bmr21214340pfg.65.1628566087521;
        Mon, 09 Aug 2021 20:28:07 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id j6sm24587192pgq.0.2021.08.09.20.28.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 20:28:07 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 1/3] KVM: X86: Remove unneeded KVM_DEBUGREG_RELOAD
Date:   Tue, 10 Aug 2021 01:43:05 +0800
Message-Id: <20210809174307.145263-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <YRFdq8sNuXYpgemU@google.com>
References: <YRFdq8sNuXYpgemU@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Commit ae561edeb421 ("KVM: x86: DR0-DR3 are not clear on reset") added code to
ensure eff_db are updated when they're modified through non-standard paths.

But there is no reason to also update hardware DRs unless hardware breakpoints
are active or DR exiting is disabled, and in those cases updating hardware is
handled by KVM_DEBUGREG_WONT_EXIT and KVM_DEBUGREG_BP_ENABLED.

KVM_DEBUGREG_RELOAD just causes unnecesarry load of hardware DRs and is better
to be removed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..9623855a5838 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -522,7 +522,6 @@ struct kvm_pmu_ops;
 enum {
 	KVM_DEBUGREG_BP_ENABLED = 1,
 	KVM_DEBUGREG_WONT_EXIT = 2,
-	KVM_DEBUGREG_RELOAD = 4,
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4116567f3d44..ad47a09ce307 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1180,7 +1180,6 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
 		for (i = 0; i < KVM_NR_DB_REGS; i++)
 			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
-		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_RELOAD;
 	}
 }
 
@@ -9600,7 +9599,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[2], 2);
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		set_debugreg(vcpu->arch.dr6, 6);
-		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
@@ -9630,7 +9628,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
-		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
 	/*
-- 
2.19.1.6.gb485710b

