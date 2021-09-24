Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B31416F22
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 11:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245260AbhIXJlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 05:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbhIXJk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 05:40:57 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16087C061574
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 02:39:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t7so25368900wrw.13
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 02:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D1NIBiKsJLet/LtgtEl9N8uYnLoHyxQP991kqXpIcyw=;
        b=Ww8e5hZDWqw9JfWpbMGhlqI7pDDqNdcsWrhsNdLDPKqjDZuCT/aOjXMXb3ffPDz4JC
         q4k8WWznxOI4F1skYyZqEK49yp2FXUcThpTuvaBp4eAAxMqnxHpRgbgShH5w+bK6l+qN
         5CbHVj/3aQaStowcB7zyX9sRrzHvahYpMf3OEf1LI3dUTj81LxjmhzocnrQtkABZT4bv
         pOjNSpXr+tK4BYdzodu+F7O/vsKfVbunl1/0JxhfUws8bpvBn7zud2onCKzhJiPhXEHd
         X+zYEuybb3KioSVSLtAJeCqSWblWl3MMoMNaTWjoQbL2AQSeoiHPEyH5HYcl/aJsxWDB
         pFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=D1NIBiKsJLet/LtgtEl9N8uYnLoHyxQP991kqXpIcyw=;
        b=o1hpPYFmGkqUYlDzukvk/4Y6xSPjmAfJfTkEEmDYMY7XLfVQtyiy1VmUz8w2R5tw3C
         Pag/37lhoomXhrQgjREarzu5nZjta8nizuwZZoJzuLEo2fGljZws1gxNnCkjt3CuR3Mn
         A8ZRNFQBOxJsLGKoIPz5RowHlwNWG65WfCUughUVwTfsVuaDXij4RJuQ9f2tyRrrkjTl
         IL7tu8FjtzmDXbZZCOkAV8aq/9jDBu4NMrCMYeQXMRSK6GKR0jLMrWaCaDJhTkAwzD37
         zJgJ58VLAO/865cHTgK4Jplx1w7mkPnbaLKShHxCSJ9K41yTZVzuWnjKmtZFfFwFCByn
         HRGw==
X-Gm-Message-State: AOAM531ZY75vEd05zFQV/9c2H2IJwps90MQJEWmFwfJQEZIcKj56mrf9
        9Ti94Gwpt8pF1xYvNw7GJns=
X-Google-Smtp-Source: ABdhPJwoZCGo+hg2kmuMf981/dvpSfGlMLdZmtK66h5QoVdyf/I/omnPIeNLYPXTYxRqHVoRVka+SQ==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr1051357wml.136.1632476362750;
        Fri, 24 Sep 2021 02:39:22 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id m128sm5645595wme.0.2021.09.24.02.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:39:22 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v6 07/40] accel/kvm: Implement AccelOpsClass::has_work()
Date:   Fri, 24 Sep 2021 11:38:14 +0200
Message-Id: <20210924093847.1014331-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924093847.1014331-1-f4bug@amsat.org>
References: <20210924093847.1014331-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM has_work() handler in AccelOpsClass and
remove it from cpu_thread_is_idle() since cpu_has_work()
is already called.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/kvm/kvm-accel-ops.c | 6 ++++++
 softmmu/cpus.c            | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 7516c67a3f5..6f4d5df3a0d 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -74,6 +74,11 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
 }
 
+static bool kvm_cpu_has_work(CPUState *cpu)
+{
+    return kvm_halt_in_kernel();
+}
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -83,6 +88,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->has_work = kvm_cpu_has_work;
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 85b06d3e685..c9f54a09989 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -90,7 +90,7 @@ bool cpu_thread_is_idle(CPUState *cpu)
         return true;
     }
     if (!cpu->halted || cpu_has_work(cpu) ||
-        kvm_halt_in_kernel() || whpx_apic_in_platform()) {
+        whpx_apic_in_platform()) {
         return false;
     }
     return true;
-- 
2.31.1

