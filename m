Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5325F6D798C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbjDEKTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbjDEKTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:19:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BE459ED
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:19:19 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l12so35624165wrm.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBsjiWXEyjNdcnK7CdgNfH2aIDA7wl6BmVcuMNTGlRg=;
        b=ZCeEmGx5C1tuByO7Gk8190umAFm3Jq4q/3LEy8V4HB/sgDGk01PdV0MXcQqltklyu3
         DW09L0fwCMzuVJZy82A0vSyQNKZSvZwE3Rakfj2hr1zvFY1eZeaEbcBCDOHIx7fy11jt
         /S2FM9gq9oJe4BBqhtdS5l+3uhXXNdnl7KuLkaG9eftfsUPFv3TGzexWOVF1sWTguVrY
         838K9xTGvVrgnK3wGNr49BTbICPTkdgaMh9RIPXj5OJjY/e393NR9LtEmB+cM2VmI3zz
         RQrk9WLPd1wzBdC0E7STdPo8yjxVpnfYhSiLQXfXjBKsSb4Cc8fPtp7Mrl4DfK8dO1FF
         g35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBsjiWXEyjNdcnK7CdgNfH2aIDA7wl6BmVcuMNTGlRg=;
        b=HskQlOPm8b9koIfYOPpkItC9IqEsdL/ETVzX0tvkUm1WQ36m2/I3CEJCZgGCYqVELM
         CWcmM+6GoyD92rJgH7eQSgEcpnIu5/JTxi8xuwao8ugcJbMQ/57qAE1xQt/5quQAVfYK
         npz2BYUbUb5yqsoc+NIgG1s3fWn6Yey4h3kVvxxk5AJytuacNjzclzwv4SG0eale2FpI
         BN0uPnpqm6xMGx6SYkPcKYaY4Ik6NNECuiSWhHJj3GA17uFe9KPJwKtDNKg5st/Hlz8C
         f980jLBH6ZPslHySeuiM3AFowyPuLCfxws94nZoEDd9+cBsKYHDJLqeByuGxKtvJXwLv
         cm8Q==
X-Gm-Message-State: AAQBX9cs3pmpWkOvpOVYfSsiqv6++Q8XOCwND7G6ZoW31xQQPfvMkwNs
        Ro7ai4o8EuD/YhSb73wERt01fw==
X-Google-Smtp-Source: AKy350bqyCS4jO7cj3IxU6M9gEfWmwwxn91ShCFu07OvQwRL7AbHTBtXunKmonFyvH6AyOInd3xSpQ==
X-Received: by 2002:adf:f004:0:b0:2cf:f01f:ed89 with SMTP id j4-20020adff004000000b002cff01fed89mr4200753wro.24.1680689958696;
        Wed, 05 Apr 2023 03:19:18 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d424b000000b002e5f6f8fc4fsm14040108wrr.100.2023.04.05.03.19.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:19:18 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH 09/14] accel: Allocate NVMM vCPU using g_try_FOO()
Date:   Wed,  5 Apr 2023 12:18:06 +0200
Message-Id: <20230405101811.76663-10-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

g_malloc0() can not fail. Use g_try_malloc0() instead.

https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index 3c7bdd560f..45fd318d23 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -942,7 +942,7 @@ nvmm_init_vcpu(CPUState *cpu)
         }
     }
 
-    qcpu = g_malloc0(sizeof(*qcpu));
+    qcpu = g_try_malloc0(sizeof(*qcpu));
     if (qcpu == NULL) {
         error_report("NVMM: Failed to allocate VCPU context.");
         return -ENOMEM;
-- 
2.38.1

