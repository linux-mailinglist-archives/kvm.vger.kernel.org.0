Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A46CAAFC
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjC0QuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjC0QuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:50:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E96530D1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d13so8248722pjh.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935819;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=JfWWi0r3Aah4Ssp2OVePCRbSorndLBHm4Dfhdf+0iBVyhGo0793cDzOsrS/TOMoWRT
         p/+84IINhIIfrVo+i4eD91p/+khoi0bv8dpYW6Ftsjb5K3jEZKC3cSkaRZdQ+QDRgCGO
         NeFvS/FyX2no1E8JwM8SRXFyeRSANCwQqdg+QmTp/nhovXgRM9KkmopMx2dP1oVX6tD3
         cH6XRsAch40tbVIgsOKll4xAA7Zi+Xmpor//2HWaSyGfS24zq/a56eOk8HN3wZ+hAATl
         DXRqiOMOp76q4e8FLqFEUcX9B3kRor2z0c7AADxDr2quOhYazYu/P4cGQRg1S5awqYKm
         FyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935819;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=6fQhj/oL5/FiS65A44p02ygiLNDzGZsU6WJjOlwD/MQ+MYYje3UTAUCJXQUHr2Pa6K
         t8fhbnZAeckxpexbLomI2uiWKEtpy9JrNNLfghKSTF3eJqAuqYZizWYocm7luiP/x9z8
         7EkPyoh2KaWT7gG475ayIu6pabQRbbLkkLJ5OLsSo9sXC55bNq/wrVAUN7BTWX+09tE8
         EjPmkBZTDVGDZc/l9w7zn6T7VtaCvd+9pP+mdCpyb92TeYSz/Fl4LXx7CD71O4h5Pu6w
         we5ilr2jp8HUhCAR7+PMksd2GDROaY4g1QZiZNeiBJdStXbxk6fVDPqEEMFhu+Rsl6bZ
         ONsw==
X-Gm-Message-State: AO0yUKXC4SIq7vewlWaDd9xWUEdDNR/1nPVCL5APRob7cxZW/G1RmoIb
        TLd1JZXOe1gMFNbF5MgW9F+YFQ==
X-Google-Smtp-Source: AK7set+Ze6NSJcYMb4Tv1Jgrtl8qn4HKSeVB7KJMmBL8DgmRijsSQsb628r6PiI7XdDQFapZ2Gw6nw==
X-Received: by 2002:a05:6a20:c2a0:b0:d3:d236:f5b7 with SMTP id bs32-20020a056a20c2a000b000d3d236f5b7mr9386121pzb.26.1679935819338;
        Mon, 27 Mar 2023 09:50:19 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:18 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH -next v17 06/20] riscv: Introduce Vector enable/disable helpers
Date:   Mon, 27 Mar 2023 16:49:26 +0000
Message-Id: <20230327164941.20491-7-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

