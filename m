Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CCF4B9B35
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 09:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiBQIge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 03:36:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbiBQIga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 03:36:30 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF2129A568;
        Thu, 17 Feb 2022 00:36:16 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y18so4054427plb.11;
        Thu, 17 Feb 2022 00:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zFQNTKgYptCbdXsZlL/77IF7MTD6u26PIaEBtpH1VaM=;
        b=aDXX3JawX1MwT2vrGeK9N8VChXByzIuDCaxBM2jl3JLJmjXK9FkHS3K23DgfpV/GMS
         v51fLkB1/Sgltd+DYeAZ0rSdvc3CixpI4Oatc2UqenO9TBbwmghk7oJucbaFI1hSp/ms
         EzKUrN4t85TES1mttPn2RIbOncIhbNorBVID+AXpyBkOHPRPJ7I1+9pfA9h53OZnZGAl
         nWW6echqo1yugx8ikTic2wqnyP6Vh9oPj7XqjEjl986oaSzdYEARprtTxWbHJbMqlQE5
         4wcb+ne3rSpuE8ljKe0N+RyS4KDJFgkuoopyZtgr1fo/jEz+YOISlfkNFHzKV8TAdlG+
         2h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zFQNTKgYptCbdXsZlL/77IF7MTD6u26PIaEBtpH1VaM=;
        b=KJUPAdsKLzZp4OjVFrsWOwo356FCvyOW+5kL7oKph6ply5tkg3kpNwL53yWy7fMXTP
         aug1nKbdr4aaQiaqRM+mGzptdyMImYHx0TTtdM+m67+HfoafS7dUrEKiZ4OoP13muIqF
         Z1pAKB1lyjkUFnsPN331woJawJm1t6g4qfvZXhdXuKE0FJqVUuGpICu+kT5Qy5CXa11W
         7D7KXGGkNW/WlmhTAkZhSc8Uj758BAnUWWnVfAR/KvLP0JV/hXdp1/BMAJXZH0tEdmMU
         AbIIiepthkR/kJZ/8DmyOGvgzuG6vSAASS2t+hsMAaOmkZguXrckOQLJXtG2o2ARC9BQ
         7yfQ==
X-Gm-Message-State: AOAM530vPdlCOdIltxOhL8xhn6aHQRyAwA10yzRnbDoIbhb+KyHNC/CF
        IH01uG57nfoYh4ZQirFzNNE=
X-Google-Smtp-Source: ABdhPJwfoqlZhQYdFIyoiSza2d+G2zxKPTEJX5nCkLIuP8lHJj0/F+rD8p3wdPPo0yZDdp49YdwLMA==
X-Received: by 2002:a17:90b:291:b0:1b9:3cb7:41ad with SMTP id az17-20020a17090b029100b001b93cb741admr6315770pjb.16.1645086975819;
        Thu, 17 Feb 2022 00:36:15 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a17sm5475843pfv.23.2022.02.17.00.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 00:36:15 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
Date:   Thu, 17 Feb 2022 16:36:01 +0800
Message-Id: <20220217083601.24829-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220217083601.24829-1-likexu@tencent.com>
References: <20220217083601.24829-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Fix the following positive warning:

 =============================
 WARNING: suspicious RCU usage
 arch/x86/kvm/pmu.c:190 suspicious rcu_dereference_check() usage!
 other info that might help us debug this:
 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by CPU 28/KVM/370841:
 #0: ff11004089f280b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x87/0x730 [kvm]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x59/0x73
  reprogram_fixed_counter+0x15d/0x1a0 [kvm]
  kvm_pmu_trigger_event+0x1a3/0x260 [kvm]
  ? free_moved_vector+0x1b4/0x1e0
  complete_fast_pio_in+0x8a/0xd0 [kvm]
  [...]

It's possible to call KVM_SET_PMU_EVENT_FILTER ioctl with the vCPU running.
Similar to "kvm->arch.msr_filter", KVM should guarantee that vCPUs will
see either the previous filter or the new filter so that guest pmu events
with identical settings in both the old and new filter have deterministic
behavior.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index af2a3dd22dd9..94319f627f64 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -185,8 +185,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	bool allow_event = true;
 	__u64 key;
-	int idx;
+	int idx, srcu_idx;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
@@ -209,6 +210,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	}
 
 out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return allow_event;
 }
 
-- 
2.35.0

