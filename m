Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F125552C1E3
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbiERR7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241173AbiERR7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D6C8CB0D
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d12-20020a17090a628c00b001dcd2efca39so1571074pjj.2
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ngCuMiQQu2crWaF3N2+jr0MQPsojQwzxANrtvFLoUs0=;
        b=gEFnGQRvL1SNUeweZldlNB86h9cbsmE4kfueDxykeLC/dgnbC0SW+2zdJwA8PwDw3d
         nJcI92lhr0cTAkYC081GdamU0nFn4qz63tbJnUHAWZZM7p0i5OC3efWKdPGxiDYYSOvn
         US1kgaHZgh0AJrTlTCqeqJ0KWTTu5Vg5Zm/3+VdiiecTxvK+6Mc8P74ANC43GhnciX3l
         klYm8L1zxexX5JH4E0wKhLTh05FhuSJb/RCh8FZMMnl2aduowRZrqhMoO3eQFiOXDC+E
         5xQtRe/6bAGUTFBmBJ/8cVelvh0swyS46siJSC75IlQtQyz52F8D0yN3qSHhIOJuvU7o
         r2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ngCuMiQQu2crWaF3N2+jr0MQPsojQwzxANrtvFLoUs0=;
        b=7/Q4uSWkL4Nqu8r2MABFucHxUJ8cPYeB6bCKs2coLL9poO4PDOgrpSO55TfWAE4ww5
         rCmAccwQYCoUkKt7/aPhy0V56PgX2be5Z+diEioejR/8GSzrrtlLRl0cASl85KZWdJVz
         OjKo83POEeiCyj00Cn1BCvRe/JOI5+qonbOQxvShaFxV8+GkWBjHu0kFUte7VzqUjZLp
         myeCn+NDsDiDQpCaDoJNz+OGvzkW5KkaBrzl6PxW4vX8yhPmlrGaLFnv/uohwUZR/YLB
         mp/b0eteCILWSQF7bCoYylLWe9WSQtk8l8LVmt/bqZ9iZ6CC3meW+OBgR7bLWlX4tv2E
         NGYw==
X-Gm-Message-State: AOAM533gF1YfjollzZYX5aQz+PMHRdWtjuIWYKJvTyHLT8Dvr3cwwn0q
        XW9bg3TOQf7QGiTmkjeBQFUOUtWoXyAVPCiW9hcIkbBaO7Y61St2639V+vwY8leW4jAJGeo8P85
        tSkJADhvbIdZZmKSYs5G63T/JCtDt9SU9q545GUWg2T06kMExgNqktUgnEQ==
X-Google-Smtp-Source: ABdhPJyBeXg2Aa9RwjM1V9d2ErVROM4+cPUe/IbabCLnLVoPOu/rW/D34Dh5ELw+xdfdzqlCet6MBrjc+sk=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP id
 j10-20020a17090a2a8a00b001df26ba6333mr350472pjd.0.1652896751753; Wed, 18 May
 2022 10:59:11 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:08 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-3-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize the field alongside other kvm_vcpu fields. No functional
change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 36dc9271d039..778151333ac0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -440,6 +440,10 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = NULL;
+
+	/* Fill the stats id string for the vcpu */
+	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
+		 task_pid_nr(current), id);
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -3807,10 +3811,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto unlock_vcpu_destroy;
 
-	/* Fill the stats id string for the vcpu */
-	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
-		 task_pid_nr(current), id);
-
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
-- 
2.36.1.124.g0e6072fb45-goog

