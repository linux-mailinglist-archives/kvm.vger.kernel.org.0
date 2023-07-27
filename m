Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1E97648F4
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjG0Hj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjG0Hjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:39:40 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A5F5
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:51 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-686b879f605so447454b3a.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690443111; x=1691047911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26LP4jR8UCRhJyh1M0qdx1yDCFp8JOR+j4jZMhaZd5Y=;
        b=FMXUAO4Yoxbd/c3ZDAJO2Eft2gOvbLIXf4hOBH5Dj9DW3gt3d58iYHeQbhg3l1Hpmg
         I19AscWEwJNXso/G1WZ6tivdoRArUDtLLbJ6rH6XmR1/n+H4xd7fhr11URWhGi2HuOoM
         YRIhUGNyDTY6U/j1ShMhaPgpHYqhrjN5joKZ+zuJf4vgAeLVFubAD1fgso1+zLlpEBIl
         aQP0NIhtn5cgY5kVQCeKUcrAVL5klU7kvwre68iLoq9uUIhKDR+roXkSeTWsG2Nj05w3
         m2v2Gg9ffatEkLhmzvEW8yEulbHU6UGF2Novf97q8cExbXPUMqDh0NstuyISfzWG1n6w
         OJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443111; x=1691047911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26LP4jR8UCRhJyh1M0qdx1yDCFp8JOR+j4jZMhaZd5Y=;
        b=Bc/N2wiUW2glADLdfoX67hIqoX2Isf1tuNiifVvCXcvuA8kkbbA8/wVd/el4w5sxew
         XURrR12mqU7WnQxKeNf+sbdLubKiVtI1MHLBFiLVf01ZDt5y9ygw+31R60MqyhlJGnBo
         ndyOi2eSd/0tb0HYKzIZt4H4aWDN3obDaS3J1G/Ake1zXpO6kzK1MiJsJyYRKy01Ejkc
         +kFN2bqpv/2YA5BxwCtcJWELGkJV2STPxYwVX39bBj4tLU58CUBRBNYogA5AR1kNTSKe
         W1vidJ+boJFC9v/ezQtPHtrxP5Ykqfb6eOZymzG8BdmGpgmlhReDu6DsVVtkKf6/N35J
         hZSw==
X-Gm-Message-State: ABy/qLYhXBEsvtIjuB8YA09qlpraHmt3bDV3ckfNLpLOvoBa06IkzHZJ
        hQxoKqxr3fKlvPhQnjudoDMY5g==
X-Google-Smtp-Source: APBJJlF9vyB/rMKDG8kcKzWzhp8EQUmef9v7mW4IywNdEUOM/7FJYAMVAQcRxxvO32/savSwOQjPaA==
X-Received: by 2002:a05:6a20:1610:b0:137:53d1:3e2 with SMTP id l16-20020a056a20161000b0013753d103e2mr4116444pzj.41.1690443111088;
        Thu, 27 Jul 2023 00:31:51 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78689000000b0064fa2fdfa9esm802002pfo.81.2023.07.27.00.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:31:50 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 3/6] mips: Report an error when KVM_VM_MIPS_VZ is unavailable
Date:   Thu, 27 Jul 2023 16:31:28 +0900
Message-ID: <20230727073134.134102-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230727073134.134102-1-akihiko.odaki@daynix.com>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On MIPS, QEMU requires KVM_VM_MIPS_VZ type for KVM. Report an error in
such a case as other architectures do when an error occurred during KVM
type decision.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/mips/kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index e98aad01bd..e22e24ed97 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1278,6 +1278,7 @@ int kvm_arch_get_default_type(MachineState *machine)
     }
 #endif
 
+    error_report("KVM_VM_MIPS_VZ type is not available");
     return -1;
 }
 
-- 
2.41.0

