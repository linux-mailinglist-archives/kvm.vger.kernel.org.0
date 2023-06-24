Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A1A73CC1E
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjFXRl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjFXRl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:41:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5170A1BF2
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-30fcda210cfso2011695f8f.3
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628514; x=1690220514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWWds0uHrElgc22pSSxJ50tOp/lAV9kSI84s7Y2g/GM=;
        b=JjwltddD/cnNRwVGBpMlwyJ7wVl1Dd+vLMYIA1ed2CA1z7xOvX3DxVnc8gtCpAefSE
         xo5g1CiCqTPXpIH4UJy5+rsZYpuKE81Z7be0dQTZ7JzdeX9j5u9Mx8Z5FVXetI2JfTyn
         47UG4xbVI3FVQad68NuGZMbwNXEiWjQIy56FIAywQDCoHP3eiLzbyyHqhhjC+Qo5u3Cg
         4ws7FQYnR+gqZpuWyo+1mj6A2Kgebxl4XbhZ5VUeZWE7itV80GK8EINXxv01Dffpjd6L
         xbEKH2Df7yWf84jA7YjCpGFhq4pv94jz889H0Vtin/e3lUxP++i7igvK6CJ6NiiQ/q9Z
         ZPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628514; x=1690220514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWWds0uHrElgc22pSSxJ50tOp/lAV9kSI84s7Y2g/GM=;
        b=XFdahr67VyLc6HlfCVJJhJPvp2lRDD4wYLBUIeB6Vq0WGfUXaC9gZ935t4AQAC819t
         IQkRdYqi1Fnn3m03k9hsG98ai9PBpscqYSO08XmKmI0+Yi566TpZYTFL4dvT+bHI4V7S
         YrXeUWWAoJ4j/YLT1+rId1UyhKJjxJqhc3bb1+U4bcUXKSNJKrinVXixvjwh21ify3xZ
         YqJwuSev9dK6uokFa7FvssmeXsb6/TQBW65uh0UHra41KTc092tARUA0MWbJYHAAjex4
         7ZAhvTtTl1sym5mYS0CfYf8vFzpakBJoiPeo2MdmfDDFIUXdDbYXQY53w7FFiRkpetl2
         2vQQ==
X-Gm-Message-State: AC+VfDzkBr9BJw9O0VZ56gJopPKT2TB/P0BT+EoDrNVVkfEyp/QRWA9q
        q9tO26jyvK2r28ZaySP2PnJ6rQ==
X-Google-Smtp-Source: ACHHUZ4nAed12yC0ATc4y4T6ov4JNqGmFeW1j5VBFhJ02T6YV9zBXbm//g8zhdDQtOShKB4zz31FCw==
X-Received: by 2002:a5d:5541:0:b0:311:abb:e377 with SMTP id g1-20020a5d5541000000b003110abbe377mr6323739wrw.39.1687628513811;
        Sat, 24 Jun 2023 10:41:53 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id i11-20020adfefcb000000b0030ae3a6be5bsm2589165wrp.78.2023.06.24.10.41.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:41:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 04/16] accel: Fix a leak on Windows HAX
Date:   Sat, 24 Jun 2023 19:41:09 +0200
Message-Id: <20230624174121.11508-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hThread is only used on the error path in hax_kick_vcpu_thread().

Fixes: b0cb0a66d6 ("Plumb the HAXM-based hardware acceleration support")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/hax/hax-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 3e5992a63b..a2321a1eff 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -205,6 +205,9 @@ int hax_vcpu_destroy(CPUState *cpu)
      */
     hax_close_fd(vcpu->fd);
     hax_global.vm->vcpus[vcpu->vcpu_id] = NULL;
+#ifdef _WIN32
+    CloseHandle(cpu->hThread);
+#endif
     g_free(vcpu);
     return 0;
 }
-- 
2.38.1

