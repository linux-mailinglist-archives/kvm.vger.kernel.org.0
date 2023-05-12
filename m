Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F9C70127F
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbjELXbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240784AbjELXbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:31:35 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6FA1FF6
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:31:34 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-528ab71c95cso5261422a12.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683934293; x=1686526293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wcH/IZQt2fpKxWmdOflRc9OWLwVhjYgy+bCX1XDE93g=;
        b=4v83TGIas+wfJjaWLCOjPTDFSf5eI0rTg2hOJnaAcwUhGubuB/XMefrzo/70cdPHs7
         2qaVG9FFRFrrWuA1ch2mD8R4vANQ3Jz3nCMrzvZL0iWOP4dnahrvsSnasp3AStseMnli
         rgmbk09ghFEHQUAHCkGmU4u7FWympmB7VW8JOn548sLMsS9hGc7lp6VtWMLlA0tgQ2Kz
         NUo3Hp2V0aQJU/fe5wxt9V43OBF9EodvkmL7m7XGnUC0Z3cqtyVB9kmSoK8AJVw5WF7Z
         gLH0mc1P5/CzJt6NLPLOzREmR25cB3/2DNJss8i8VU9bLcWJ8eQ9iPX/k78+NRi1c9yG
         QLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683934293; x=1686526293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wcH/IZQt2fpKxWmdOflRc9OWLwVhjYgy+bCX1XDE93g=;
        b=cHRw+JruFEaDLsu56v+iK0GctKIbcyvcYkADwogRULL8STUtlLrsp97VPVClnr59Yy
         mz/iby0sKqhAsgq7w+/QFlfCPJEEdWDJcv3LevJhEh/lG9o5XdoDpE6EJMTOapMfLPPl
         WzLBuz32TqtG/1I4eH0F8N6ZzO7R8PBRpzrXIgKWvjF7A2EEBg8icHf8nqrcBKQKzzV/
         5k4xnEsH7zH+DnXbFDAglLGRKpjq64ou5cl8uu2X9bklAlz7lpVzq56+IAcGXcWNviXi
         FffPvnGVCMS0yeQUOJB8hrY8+0AsU2GN42ovm60QvfGnN4KoT9S464uWloYA1pHrl868
         S/QQ==
X-Gm-Message-State: AC+VfDx4UKFAB+RHA+EbqJuAw1tjmmD8Zb5ejfxMRp35/rh25Ak4fSyd
        Qy9Wo/1q9WTthOkX5xaXHR4rZERQgs8=
X-Google-Smtp-Source: ACHHUZ5UNjKC3Mr05CVuFrOytcZXmJ4jNvPP0Z/3ZNzFBXbNdnsGA19Lumkans0gS6XeDtr0V3XVeltLARk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2b04:0:b0:521:62ef:9b38 with SMTP id
 r4-20020a632b04000000b0052162ef9b38mr7261719pgr.3.1683934293773; Fri, 12 May
 2023 16:31:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:31:27 -0700
In-Reply-To: <20230512233127.804012-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512233127.804012-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: Don't enable hardware after a restart/shutdown is initiated
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>
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

Reject hardware enabling, i.e. VM creation, if a restart/shutdown has
been initiated to avoid re-enabling hardware between kvm_reboot() and
machine_{halt,power_off,restart}().  The restart case is especially
problematic (for x86) as enabling VMX (or clearing GIF in KVM_RUN on
SVM) blocks INIT, which results in the restart/reboot hanging as BIOS
is unable to wake and rendezvous with APs.

Note, this bug, and the original issue that motivated the addition of
kvm_reboot(), is effectively limited to a forced reboot, e.g. `reboot -f`.
In a "normal" reboot, userspace will gracefully teardown userspace before
triggering the kernel reboot (modulo bugs, errors, etc), i.e. any process
that might do ioctl(KVM_CREATE_VM) is long gone.

Fixes: 8e1c18157d87 ("KVM: VMX: Disable VMX when system shutdown")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e771b6a013c9..cc36a7fc8a86 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5182,7 +5182,20 @@ static void hardware_disable_all(void)
 static int hardware_enable_all(void)
 {
 	atomic_t failed = ATOMIC_INIT(0);
-	int r = 0;
+	int r;
+
+	/*
+	 * Do not enable hardware virtualization if the system is going down.
+	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
+	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
+	 * after kvm_reboot() is called.  Note, this relies on system_state
+	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
+	 * hook instead of registering a dedicated reboot notifier (the latter
+	 * runs before system_state is updated).
+	 */
+	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
+	    system_state == SYSTEM_RESTART)
+		return -EBUSY;
 
 	/*
 	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
@@ -5195,6 +5208,8 @@ static int hardware_enable_all(void)
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
 
+	r = 0;
+
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		on_each_cpu(hardware_enable_nolock, &failed, 1);
-- 
2.40.1.606.ga4b1b128d6-goog

