Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D50504D3B
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 09:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiDRHqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 03:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiDRHqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 03:46:02 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE7012A8E;
        Mon, 18 Apr 2022 00:43:24 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q12so17441509pgj.13;
        Mon, 18 Apr 2022 00:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Bz3WXy9wp2iTizc3RUbJP1TFtfPRjIT22rWiujaCDg4=;
        b=ewftY+yE8/uWZN1l3zx9HBD0GfZdbWrHPtcpH/DYz0i8BoRvxIk6lmvn5jbrtvd7NJ
         2hHLmuGLuIh65EQy57k6QuJFZZcJW5WkJRLfxo6GTYy2bMAeVgIgv5iKykmlQ8RTH/U8
         ynMsbHDuPygm/vPn/gP0pVcvPRU+D2R9+VK7NqPlbGYtYUu8VQPtyIBXkcMNsJHMoSe+
         74auquXJEripwV8sj1crTTYgkFcUYve7eAe1Md7X2jDFTWMCXYUhvn316mFQVvE+OgZB
         x2C+JjVRuPszvq30lCud6XRqpBcWrTQxDbhxRnceBc4QLkYjDStUT+fSfOaGbZvaJf9E
         hBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bz3WXy9wp2iTizc3RUbJP1TFtfPRjIT22rWiujaCDg4=;
        b=HNEtJY4RjIUh27DsdvdcpT9aWvG1wyDydVUDVOSLbHBnxJs6GIlYx5OiE0wIOH1+kn
         1nJz19mtZG4xmnj5oVWvHsZ3kZKKB5dGrKnDBNWiTKDGyJIz9cXHUpMkPt1wjUTWJjI2
         E/Sl6qsMneerFHo9q9q+wDLZi7hjEWLMJdWWmUsSRGFNJkwD78NygLuL6q2gJAixliAI
         KgDcAw8SMPPVHvSG2/r7pxZgYHK4Dn4j8OfIF6+ZDLG2blXL2klm8MFCdSZ+C+ObMpNq
         at4uk2vp94QrQdQDoifwgn9k+oi5UNjal7C1S6gx/pZoqmH4oVBYwchpFwZ5vOCoJRyi
         24Fw==
X-Gm-Message-State: AOAM533b5qMD9d5EWTbx+gWLMoSYDzxPbMuLgvoqc9AYVCu79xA0T3LL
        ygmsMlzszxBNIsHc66keTQ6+0Ug6idA=
X-Google-Smtp-Source: ABdhPJztF+bhZ3iSTCuU4Fspb2ZW6Ym/5MreY4jNwz9C6BC/h7ZZQI+/+Zxffw0vI8JIodPUVZ0sFg==
X-Received: by 2002:a65:4b85:0:b0:399:8cd:5270 with SMTP id t5-20020a654b85000000b0039908cd5270mr8910175pgq.418.1650267804116;
        Mon, 18 Apr 2022 00:43:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.googlemail.com with ESMTPSA id br10-20020a17090b0f0a00b001cd4fb89d38sm15595833pjb.9.2022.04.18.00.43.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Apr 2022 00:43:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] x86/kvm: Fix guest haltpoll after the guest suspend/resume
Date:   Mon, 18 Apr 2022 00:42:32 -0700
Message-Id: <1650267752-46796-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

All AP cpus hot-unplugged during guest suspend and hot-plugged during
guest resume, qemu makes host haltpoll as default during vCPU reset,
it resets all the haltpoll to host haltpoll by KVM_SET_MSRS ioctl. All
AP cpus switch to guest haltpoll again by haltpoll driver hotplug
callbacks in the guest. However, BSP is not hotpluggable and keeps host 
haltpoll which means that the BSP switches from guest haltpoll to host 
haltpoll during the guest suspend and resume, this will have vmexit cost
each time the guest enters idle. This patch fixes it by recording BSP's 
haltpoll state and resuming it during guest resume.

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d0bb2b3fb305..5c65643cb005 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -69,6 +69,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
 
+static int has_guest_poll = 0;
 /*
  * No need for any "IO delay" on KVM
  */
@@ -706,14 +707,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 
 static int kvm_suspend(void)
 {
+	u64 val = 0;
+
 	kvm_guest_cpu_offline(false);
 
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
+		rdmsrl(MSR_KVM_POLL_CONTROL, val);
+	has_guest_poll = !(val & 1);
+#endif
 	return 0;
 }
 
 static void kvm_resume(void)
 {
 	kvm_cpu_online(raw_smp_processor_id());
+
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL) && has_guest_poll)
+		wrmsrl(MSR_KVM_POLL_CONTROL, 0);
+#endif
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.25.1

