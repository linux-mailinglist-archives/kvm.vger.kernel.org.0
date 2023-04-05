Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5356D82F0
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbjDEQFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbjDEQFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:45 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D236582
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i9so36737303wrp.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSZpkYKC0E9O8rqY27roK0ybv9W9NQfMeuFKqLZI7LU=;
        b=wqNCwi876yROugf5tN+kiLbImBLgk+uYIjohRocygCiSXtq0GiLxJMZsXSek6pHpVR
         +vfvjXSlWK4qWKr94gcOADBrEVPqgm5CfvJ9deGOWUrdCVM9PHovYkwZHujef3O8MtOZ
         eXzc0P4Y5NXAVWdLu6uqolhV733Ybgg5UBVQpSLnRk/q1N+A6GEHjHvVwc3QqBqwAdiy
         BNPfLSrZgGarjn1j7MUV3SoT0FiNvFRNxXYmemHmO/109VPWZrGM4pBbcOVF8ud8YiU5
         ASlPsQUvC0UDNDeGKeDi0tm00GS1Eunn4AndcQhBbXGrCKw7wvhL9RVtanHs8lJbVSrB
         h7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSZpkYKC0E9O8rqY27roK0ybv9W9NQfMeuFKqLZI7LU=;
        b=Pq6mAkWBHeVO5bbP8i6graVpoz233dQrowkK8Mniini38q7Ehe5xcC8FwwO6FJ8Fy1
         wDnkUsAe3huEk1FgmWkcuq241dpDXTcXPJr8J8lRq1HmXBlUihh0/Xe0FpOsmhY+5Zi7
         DdZ6TW6ZdaLZJA3f9AzZGKII+wmBvEGsFvwqjlGC256snA7N0KKUqeQOsWdNnmwdBb4g
         OM01wYWZB2pB9Gmu8OUHiNeFyEq75iiiJAg+eKOR+worwqnE6Vvp/a9XTUoewAi/IyG4
         CBMRunMuwpdr7fp2Fo1NjwXAadVSdXdGr7HDPr/ayteqwEkuYJGOBa5Z0VdZb9YIXP+S
         yWOg==
X-Gm-Message-State: AAQBX9cRMRVretekQ0LJl+5vL1HJk/5KWbpQ9bNcTOl1aZXgJiNKbqaK
        oT8XiNqyR0pKAC8IA5JpTA2yzw==
X-Google-Smtp-Source: AKy350aZffoChxbCPg7M2fAcOye2AlE3AkD3kI7o7RFqx/SUBuZegFtLbCZIhwjdYIeXSthO8Irkcg==
X-Received: by 2002:adf:eace:0:b0:2ce:a098:c6b8 with SMTP id o14-20020adfeace000000b002cea098c6b8mr5030406wrn.55.1680710738191;
        Wed, 05 Apr 2023 09:05:38 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id q18-20020adffed2000000b002c70851fdd8sm15263762wrs.75.2023.04.05.09.05.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:37 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 07/10] target/arm: Restrict KVM-specific fields from ArchCPU
Date:   Wed,  5 Apr 2023 18:04:51 +0200
Message-Id: <20230405160454.97436-8-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
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

These fields shouldn't be accessed when KVM is not available.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index c097cae988..efd1b010d5 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -945,6 +945,7 @@ struct ArchCPU {
      */
     uint32_t kvm_target;
 
+#ifdef CONFIG_KVM
     /* KVM init features for this CPU */
     uint32_t kvm_init_features[7];
 
@@ -957,6 +958,7 @@ struct ArchCPU {
 
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
+#endif /* CONFIG_KVM */
 
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
-- 
2.38.1

