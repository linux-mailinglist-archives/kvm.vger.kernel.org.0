Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B76BE859
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCQLhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCQLhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:20 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FCBE1FE9
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so4852042pjp.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053010;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=S6uqy4a2UaKCJDQlWCmNiV806NKcOgDvAFNjC0J6sGpJvb5eMR0lQWFc5Sxk61vlfF
         Q8K9RbAQxn1VCIJZx/2D5k1YxGs50wH37bG9Q5n3StxAFUMXByfJEy8t43QnrYx5uHZm
         qZeeAPqAoBlve7pYNRFHbuDeEzuXdow2og1FsODANncOGGxDuRZJU65nMLfKDVO8kdRN
         KgJPrbms9IgosCP7KAWsCkNPyb3AKjGw3xLYHJwvdr8uGqqHt/hHkY2+GmewEqhgLIws
         nmrUGwdLdgpFpPQt2gYg1P1rN246gOb9TdSSBvoSTN7DlL71mUpEWiHfCt824cO+yspZ
         Nl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053010;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=u+obDTIlVxaH/Tk18Wdm01jL8DZobVnuxTZXjipcSAqt4JUPpwczXqe1v0furnLH4I
         FXdgzVl6khkBYt14986YPa68zlMaDRFYem//g/VNvyIwAD1xQQ7kgMEEB3GG/k9lgdLV
         LO6jJu1CuP1LkUuSwuQNksWgfmZtEsrVGsBpnTEn+exw9A35Q0TaP0HV8UD5hKWm0dOn
         U/7vuUm2doft/sTyHbd+Mph+i1k0+mws6cmirBqRmdEJpibwgQyMKAXDajZ42Bs+dHA+
         pKb2gOtHUB6NwYxqNNvrYIBKELyJUYlXU84DUeyAtSOLoEwrmheBppnac9I7FkgB6zd3
         WuOA==
X-Gm-Message-State: AO0yUKWE6bvUDiNDu5TFtZ/1csJ5Xx+Or1uvuZMoABG+vYd3P+GFbygS
        MtEHh/9ZnO5CJScRT3Ukdde+Qw==
X-Google-Smtp-Source: AK7set/TlyooaQ9QmuPWasTPsj+TdRra8vnKawS/cA+NsLt85idE6Cz7j+TByTfh+4Zdo20H9baV8Q==
X-Received: by 2002:a17:90b:1e4e:b0:23d:1fc0:dd20 with SMTP id pi14-20020a17090b1e4e00b0023d1fc0dd20mr7679811pjb.17.1679053010062;
        Fri, 17 Mar 2023 04:36:50 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:49 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v15 06/19] riscv: Introduce Vector enable/disable helpers
Date:   Fri, 17 Mar 2023 11:35:25 +0000
Message-Id: <20230317113538.10878-7-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

These are small and likely to be frequently called so implement as
inline routines (vs. function call).

Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/vector.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 427a3b51df72..dfe5a321b2b4 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,12 +11,23 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <asm/hwcap.h>
+#include <asm/csr.h>
 
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
 }
 
+static __always_inline void riscv_v_enable(void)
+{
+	csr_set(CSR_SSTATUS, SR_VS);
+}
+
+static __always_inline void riscv_v_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SR_VS);
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
-- 
2.17.1

