Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02EE52BC7A
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiERNq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbiERNqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:46:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CEB1660A0;
        Wed, 18 May 2022 06:46:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id p26so3092091eds.5;
        Wed, 18 May 2022 06:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emRjXefipDOzrwdl8ti4tobydfrsmYJDX4jGfv6NVQ0=;
        b=pIHdu6fIeKCNQmUl5G4GpNW9g6jdq0neC47gphBI7RbN6tDJkRsGWSJN4ghLXVdfDm
         5TMUze5gPB2RFYUZaFjmDzWkR6qoZxfSSUs2vtGQGujllsd2i70kdsDNdI9uK1zKffR+
         0Wgxh20ZP1WoX0V6tvTXvS70XhbCqhJEXuKp6I6kMTwXnaqfP2a19GVEnxk487rIBKrp
         ciz1ml30BB9zUq9Us3VLPWe5tZNRI19qmgVaDCUCCUBaafQ9oR0DCFxyu0d+rptskH2r
         TD3k21IgN0HEYs9tpIx/vOXUsSfqnRqJvHobRs3t90NwnoPa4aq36Fy1rLlJQNzdo1VP
         x+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emRjXefipDOzrwdl8ti4tobydfrsmYJDX4jGfv6NVQ0=;
        b=Nf1YCn/v1P5ryMYFEirgnfs8NvtjM8ugRGcZ2qeDXo9nAMFH/OLvH3iCB4MNdDQhOY
         CuP/UJmeq/I7wIeBVYNxVoA2xB5gbJDFouR5UGjPLlNTu3VgLcwH6lUhwGHpVKzVIMxM
         Njg2483p7n3porTr4xrmWfv5jqGU0rT9eC6n9bVGXGiamFjLqV/PPhNxI3RZ+tDw4uzf
         6lXq2BD1yvBPeGIFuzIgNhGmiZOOAu4EQhUiIE2OqrnGwkrfuvE1cZGHcWT+CXRuo8ZP
         6U41reCl/rXMIG7miUuPU1dX15jHouqHR3kCA/vWAzDGfuZVyiVdyKm4Pu1o9/as93FJ
         YNcQ==
X-Gm-Message-State: AOAM533148pjJPwLeaOgKds2voUGhUU1/JixTDL4jMKV78HlbMJP220V
        LLWum9CLeaXhCSNwHeuKMDqoFCRrvSY=
X-Google-Smtp-Source: ABdhPJyyhd52GApSXiohLZHMyt262d3u6jppghaYnQsCjdUgo1MQlHiw7S6Qqjm/uv8D1EfEf5H//A==
X-Received: by 2002:a05:6402:26ca:b0:427:c181:b0ed with SMTP id x10-20020a05640226ca00b00427c181b0edmr24670287edd.400.1652881571541;
        Wed, 18 May 2022 06:46:11 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id s27-20020a170906221b00b006f3ef214e73sm954490ejs.217.2022.05.18.06.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:46:10 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
Date:   Wed, 18 May 2022 15:45:50 +0200
Message-Id: <20220518134550.2358-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Use try_cmpxchg64 instead of cmpxchg64 (*ptr, old, new) != old
in pi_try_set_control.  cmpxchg returns success in ZF flag, so this
change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg):

  b9:   88 44 24 60             mov    %al,0x60(%rsp)
  bd:   48 89 c8                mov    %rcx,%rax
  c0:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
  c5:   48 8b 74 24 60          mov    0x60(%rsp),%rsi
  ca:   f0 49 0f b1 34 24       lock cmpxchg %rsi,(%r12)
  d0:   48 39 c1                cmp    %rax,%rcx
  d3:   75 cf                   jne    a4 <vmx_vcpu_pi_load+0xa4>

patched:

  c1:   88 54 24 60             mov    %dl,0x60(%rsp)
  c5:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
  ca:   48 8b 54 24 60          mov    0x60(%rsp),%rdx
  cf:   f0 48 0f b1 13          lock cmpxchg %rdx,(%rbx)
  d4:   75 d5                   jne    ab <vmx_vcpu_pi_load+0xab>

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
Patch requires commits 0aa7be05d83cc584da0782405e8007e351dfb6cc
and c2df0a6af177b6c06a859806a876f92b072dc624 from tip.git
---
 arch/x86/kvm/vmx/posted_intr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3834bb30ce54..4d41d5994a26 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -34,7 +34,7 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
+static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 {
 	/*
 	 * PID.ON can be set at any time by a different vCPU or by hardware,
@@ -42,7 +42,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
 	 * update must be retried with a fresh snapshot an ON change causes
 	 * the cmpxchg to fail.
 	 */
-	if (cmpxchg64(&pi_desc->control, old, new) != old)
+	if (!try_cmpxchg64(&pi_desc->control, pold, new))
 		return -EBUSY;
 
 	return 0;
@@ -111,7 +111,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		 * descriptor was modified on "put" to use the wakeup vector.
 		 */
 		new.nv = POSTED_INTR_VECTOR;
-	} while (pi_try_set_control(pi_desc, old.control, new.control));
+	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	local_irq_restore(flags);
 
@@ -161,7 +161,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
-	} while (pi_try_set_control(pi_desc, old.control, new.control));
+	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	/*
 	 * Send a wakeup IPI to this CPU if an interrupt may have been posted
-- 
2.35.1

