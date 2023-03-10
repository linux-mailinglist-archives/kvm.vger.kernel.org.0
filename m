Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87E36B540A
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 23:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjCJWOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 17:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjCJWOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 17:14:24 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C925013F572
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 14:14:21 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541665e581cso2039447b3.14
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678486460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2opxKga+fb5i4H+BY6IhBhjz7Vmgmcavrh6WO0nAabw=;
        b=XANFaeRYOx5Rd/kapDHhNmO90qoMVlvQlylWOJKFiusgRTk50x3TP11Tb99KjhRtRp
         Ilp6Fnx2ETLBE3ONxbTQK/JHBUg90svkVN5Ksjq6gDLd6XGGLH3cF/yhlaBgocMStinz
         BgYUmwsqJH2QawF4/6NH9+aU6CFGqKWcG0poEIYHj6EwiQB9E2zPA277B2ph+E8+ViKI
         skXt6AXZdpliK6f0KboRPpk16NPL23XsUnuJZwzJxP6uQZnZFD4DhdkN8ZAiCA34+SyC
         eiBTO57MgJwbaZpawRvV5J7htbbDb96jJ2ohiFCXMIPVyvl34nTNPoV17hacH1Od+NjM
         RPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678486460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2opxKga+fb5i4H+BY6IhBhjz7Vmgmcavrh6WO0nAabw=;
        b=hZXVDw0f84Ud8X2pD3RPmzJdhKWFqO/119b9+zip58ZpdksbGpZLrg4njBRefgVLpC
         yMqUiyN9cP1w7mcqQktV5RGOZ+/5WYUyRrJhmK/V5Inf2b8TvOr/wnaRHsoOta3n09k/
         qF8Cdw49sDEpvlUUhNuUiiSqAmRgykCw9ldS6nhfETGx/wAb0e1dYXi9gb2RPCFaXPsK
         P+Q8URlJPT+TLXHIX+2KNCNpi5SM/9Jiz9Q2BraHszo6BRZ9NNHuPG6KW1VKokvKKXQ7
         jIb8e2Q3eqdOC9XjAHGsJoSDm54vrtVdQO3U8TrIlxWSTr3ynTWVsmT5jaRafOn3BA8+
         GJzA==
X-Gm-Message-State: AO0yUKXsdYkcQ9rSdAmAExejDaVH4IV+fWkivwEk6tAeju+JCljaJK50
        rfIyYcx6MIeAA8+mM+WdcsniDh6+uD8=
X-Google-Smtp-Source: AK7set9W78UovW/m1wQ6WBrZF9xvfIQRknxFWcTaYsNYshb2LLp3atXf4mwpxmtOXFU5GAMHzAFXebzuJ+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1149:b0:8da:3163:224 with SMTP id
 p9-20020a056902114900b008da31630224mr2418826ybu.0.1678486460678; Fri, 10 Mar
 2023 14:14:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 14:14:14 -0800
In-Reply-To: <20230310221414.811690-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310221414.811690-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310221414.811690-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: Don't enable hardware after a restart/shutdown is initiated
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6cdfbb2c641b..b2bf4c105181 100644
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
2.40.0.rc1.284.g88254d51c5-goog

