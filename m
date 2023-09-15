Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DDD7A26CC
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbjIOTA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjIOTAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:00:39 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABABD106
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:26 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bb9a063f26so39803131fa.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804425; x=1695409225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yj/VmI3CWTgvZ6wzrxeZ+28cs5rrw6eKGcMTnrAf39k=;
        b=N0L14Zk31IwymYZpFO3ROhfqNleikhrT9ZwQmeG+loVHwEUfwB8SL6hnjspX6M+0HB
         aHl5hT1f3lNtWzR3ejlJR9zcM+vAKi6gP1tbrynVtXS08pIyLczz94jjOVDcEGse8OOi
         29k67BRRJ6C2A3xC45RJgjjUmcvJAXsBg/KwmE1uwVpvKnfB6xgk53leSROuvUHp03CO
         wEmKAKsEryhWzg1AllCOI+Ek+lT8+VUe9rsVzhEqLoTYWgEYyTvOcWanNd3DuegQDJei
         h1/E1uETG2QEK7JPomx4YvgaeA5f0xmkU7xx+5/9eDhSu4jbVTDFQfot2tLtlfoFdMTm
         KfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804425; x=1695409225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yj/VmI3CWTgvZ6wzrxeZ+28cs5rrw6eKGcMTnrAf39k=;
        b=j+etZvctCzFDzfvsvrPGMCi5KgTzaGu5+O1KqL7H1c6PslF0BrBUCjdaAGWALYW46B
         ZIufZ8cNPpjoutFAcPzv//yhsr3YfpjNlZ/F/+RnZuc/9V03udM/FatJh2wJ8Kj67P3b
         5z4MztHq9zS13DxZkRerao0Mwn6C+6vn3pOr8hhXAWtVvadhOc2Vev4C1NAx122S7EIx
         35js4TYJEuhtRligOcpWOgvJB0abOkoJ+UjuDSQUMjW8Kf05HisYQQ+JcR5DHht9XE4V
         rP3qv8+FObRiICkmuiHRjT9bS5UWBd/OVlJGPEUcYT4xMaom+xeTZ2Cw9ho6jcdaTU7d
         NKgQ==
X-Gm-Message-State: AOJu0YwlOEivOyCNwp+xKf1RwFbW6foSyI8RreMh2jMNXPg9ZcA5d2nY
        Q8Xs0gWNQpUXgVkH1kqSLL7lBA==
X-Google-Smtp-Source: AGHT+IFqQLY3Tj7eqeOV4Qk/KF83QEwxNZjoYa3bqymzIJPp2j/TFg6tNe+VoWlEZLh1FUBo2pLong==
X-Received: by 2002:a2e:3e0e:0:b0:2b6:bc30:7254 with SMTP id l14-20020a2e3e0e000000b002b6bc307254mr2206820lja.13.1694804424824;
        Fri, 15 Sep 2023 12:00:24 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id lc25-20020a170906dff900b0099bd86f9248sm2776714ejc.63.2023.09.15.12.00.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:24 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH 2/5] accel: Introduce accel_cpu_unrealize() stub
Date:   Fri, 15 Sep 2023 21:00:05 +0200
Message-ID: <20230915190009.68404-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915190009.68404-1-philmd@linaro.org>
References: <20230915190009.68404-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare the stub for parity with accel_cpu_realize().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h | 6 ++++++
 accel/accel-common.c | 4 ++++
 cpu.c                | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index cb64a07b84..23254c6c9c 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -96,6 +96,12 @@ void accel_cpu_instance_init(CPUState *cpu);
  */
 bool accel_cpu_realize(CPUState *cpu, Error **errp);
 
+/**
+ * accel_cpu_unrealizefn:
+ * @cpu: The CPU that needs to call accel-specific cpu unrealization.
+ */
+void accel_cpu_unrealize(CPUState *cpu);
+
 /**
  * accel_supported_gdbstub_sstep_flags:
  *
diff --git a/accel/accel-common.c b/accel/accel-common.c
index b953855e8b..cc3a45e663 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -129,6 +129,10 @@ bool accel_cpu_realize(CPUState *cpu, Error **errp)
     return true;
 }
 
+void accel_cpu_unrealize(CPUState *cpu)
+{
+}
+
 int accel_supported_gdbstub_sstep_flags(void)
 {
     AccelState *accel = current_accel();
diff --git a/cpu.c b/cpu.c
index 61c9760e62..b928bbed50 100644
--- a/cpu.c
+++ b/cpu.c
@@ -187,8 +187,9 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     cpu_list_remove(cpu);
     /*
      * Now that the vCPU has been removed from the RCU list, we can call
-     * tcg_exec_unrealizefn, which may free fields using call_rcu.
+     * accel_cpu_unrealize, which may free fields using call_rcu.
      */
+    accel_cpu_unrealize(cpu);
     if (tcg_enabled()) {
         tcg_exec_unrealizefn(cpu);
     }
-- 
2.41.0

