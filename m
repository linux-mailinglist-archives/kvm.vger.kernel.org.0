Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06B186FC9
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbgCPQOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21735 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731924AbgCPQOt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ro+HCuhG/U1g3lYErsu/yY3mato6cTL6YgdKcF/Jx28=;
        b=D0x/yojqrtg6g16+G9QawXjFSb3l33L6ZdczDI91MuVo51m9kyVeCBR3WTMzmbA4tu9QYp
        sRuHIJ6wokfLBTY+ou4XCMwFcNtxpVvY7YgTLgNiuT/GDeJ7cy8Cfaxd4rVhSV+r2Uuc8y
        3nJXTdlNAXq7ZUAEEyo0DuOTkPWFxjc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-b9sKGQNZP-GHiF-AmTfXHg-1; Mon, 16 Mar 2020 12:07:11 -0400
X-MC-Unique: b9sKGQNZP-GHiF-AmTfXHg-1
Received: by mail-ed1-f70.google.com with SMTP id u4so644295edo.21
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ro+HCuhG/U1g3lYErsu/yY3mato6cTL6YgdKcF/Jx28=;
        b=i/xmt0gBCWwuN4T8fHCNbMJAAYxxLMQnrMA9q3gQfLE7vifcKjQDe1sRcDoNDIqEBF
         jStXB9wsdVFJE7s4wjwShl5+6ko+ORVsMdax3aoYt9uouiOpX4LkHaaEHOndOv0d5hck
         qShcsFNqW6JMVqcJ8i+MMHbfMNoPsGXB7S8tzGw7leHGwvH34s6Hmu5iewR65yNKxOx4
         ot6sAT/SjcVvGxX67wMrrJYHp/poRcp/CZC59JUVcNNmErCySYV5IEgy8Z5ykp7XzmJg
         SrXn2tSbpDLYGTKDZF9ptHLNaNT/GXhT9YOfCx8krUqBOb2VhB05wEPdjVE/By1jXK0h
         nlCg==
X-Gm-Message-State: ANhLgQ1cmLL2bTz6kCMD5WX8mm/CNQfxdhO7xzI5fIkeiXNioVDuafN0
        RrxjVD50TbNGRpZWcYRDqD0xl4bii5qY8RIlW6zkOiT5ir4VyYX9BHGMAKPaXfriJJzP5oqJIVi
        py0LTHu0V4SCA
X-Received: by 2002:a17:906:33d0:: with SMTP id w16mr19391053eja.257.1584374825492;
        Mon, 16 Mar 2020 09:07:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtV7veg30cCQ3j3SAt9xjtSLJOa94Pxt9UeVCoRu/dTyjd6KIDS5xdnx353O9uNorBrl6JTdw==
X-Received: by 2002:a17:906:33d0:: with SMTP id w16mr19391034eja.257.1584374825290;
        Mon, 16 Mar 2020 09:07:05 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id 31sm14913edc.26.2020.03.16.09.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:04 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 05/19] target/arm: Restrict Virtualization Host Extensions instructions to TCG
Date:   Mon, 16 Mar 2020 17:06:20 +0100
Message-Id: <20200316160634.3386-6-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under KVM the ARMv8.1-VHE instruction will trap.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/helper.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index a5280c091b..ce6778283d 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -2897,16 +2897,6 @@ static void gt_virt_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
     gt_ctl_write(env, ri, GTIMER_VIRT, value);
 }
 
-static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
-                              uint64_t value)
-{
-    ARMCPU *cpu = env_archcpu(env);
-
-    trace_arm_gt_cntvoff_write(value);
-    raw_write(env, ri, value);
-    gt_recalc_timer(cpu, GTIMER_VIRT);
-}
-
 static uint64_t gt_virt_redir_cval_read(CPUARMState *env,
                                         const ARMCPRegInfo *ri)
 {
@@ -2949,6 +2939,17 @@ static void gt_virt_redir_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
     gt_ctl_write(env, ri, timeridx, value);
 }
 
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
+static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
+                              uint64_t value)
+{
+    ARMCPU *cpu = env_archcpu(env);
+
+    trace_arm_gt_cntvoff_write(value);
+    raw_write(env, ri, value);
+    gt_recalc_timer(cpu, GTIMER_VIRT);
+}
+
 static void gt_hyp_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
 {
     gt_timer_reset(env, ri, GTIMER_HYP);
@@ -2976,6 +2977,7 @@ static void gt_hyp_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
 {
     gt_ctl_write(env, ri, GTIMER_HYP, value);
 }
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
 
 static void gt_sec_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
 {
-- 
2.21.1

