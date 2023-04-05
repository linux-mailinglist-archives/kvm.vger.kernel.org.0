Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6C6D796C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbjDEKS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbjDEKSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:18:24 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61896271C
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r29so35612911wra.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5W5kRucCzOBlp3KNoaJLlOhdcHcmgdcoSudurkJOAU=;
        b=YvdDHGNJmJITr/TCaBwa+nNTBQzwFo4m9pQoqmbmi3vaFmhxmN+kDfHXTlih7hjOuG
         i5foQd722oTmMrBj+Hnn/y+vSEYHeAfBNU8qFxNsz637G6z7vjp3C2UAjRMomPmXSt6B
         8zPBf0Ips8vfVnHZNtgCTbmeRiHGsNV5SUfNvKV2SqM3fJYcuc7ImyIhwyWRK6Hj9a9X
         +Js3FJbT2ARj2FgCtaCnNeF4Yijhd95peS0BiCwqBd/BuWcL+6seYLzsD3aU2CENQUwI
         ovnk8urTgfiCLVoqgt1J2QmQfKLKfpa8JYktu83jlKdtgVQauBcK79zdBkzhpVPSX3Ka
         StWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5W5kRucCzOBlp3KNoaJLlOhdcHcmgdcoSudurkJOAU=;
        b=Q4p9dPKOFLYNmer1id+nAQ9ZCiiPEjUs/i905Eou6Su5vPs1EziGqDLUDaAbzDICTa
         bFUgEGunYydkOD//0ZcHrTIMhcc/GoJ37MeXQLCVvxi738vUIvUU8dO7dIS+L9A4VLyu
         SsQbm83dwvSqcnOt4rnUaJLj7FgY1tJiY3TDc7WFiSW/ph7W2G1rzHiLSOtzIUGCkdEh
         4v2kkCq5r0U4XgJaeZRmIJxdnsZEwl4g76Rh+FeXYJOF4elCrWjNZ3iCRW36ACqXCAUa
         xUqK9mgKNFSCPZKAZF+j+oDny6Ds4Kqc+ZKRLPk78Cwrj1KMX/VB2inupnSgzGCGbPKe
         uXjg==
X-Gm-Message-State: AAQBX9ewhBiOqiXwdpdWRMJylebqwMi0bV8uj783PXk73Oo6UoodEMik
        2zGfWa4D6zRaYXnYaJ6HaGJtX5n/VqY5otseQGY=
X-Google-Smtp-Source: AKy350bpxg4IrwdUQGHpIVdGoidA/+sCsrkONX9FyvsEM868pIe4QiJWHCOtkMTvKUMsoYziJ+Rgdw==
X-Received: by 2002:a5d:44c2:0:b0:2cf:efd7:2f1d with SMTP id z2-20020a5d44c2000000b002cfefd72f1dmr3851096wrr.13.1680689901758;
        Wed, 05 Apr 2023 03:18:21 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000100c00b002cea8664304sm14500312wrx.91.2023.04.05.03.18.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:21 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 01/14] accel: Document generic accelerator headers
Date:   Wed,  5 Apr 2023 12:17:58 +0200
Message-Id: <20230405101811.76663-2-philmd@linaro.org>
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

These headers are meant to be include by any file to check
the availability of accelerators, thus are not accelerator
specific.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/hax.h  | 2 ++
 include/sysemu/kvm.h  | 2 ++
 include/sysemu/nvmm.h | 2 ++
 include/sysemu/tcg.h  | 2 ++
 include/sysemu/whpx.h | 2 ++
 include/sysemu/xen.h  | 2 ++
 6 files changed, 12 insertions(+)

diff --git a/include/sysemu/hax.h b/include/sysemu/hax.h
index bf8f99a824..80fc716f80 100644
--- a/include/sysemu/hax.h
+++ b/include/sysemu/hax.h
@@ -19,6 +19,8 @@
  *
  */
 
+/* header to be included in non-HAX-specific code */
+
 #ifndef QEMU_HAX_H
 #define QEMU_HAX_H
 
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c8281c07a7..cc6c678ed8 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -11,6 +11,8 @@
  *
  */
 
+/* header to be included in non-KVM-specific code */
+
 #ifndef QEMU_KVM_H
 #define QEMU_KVM_H
 
diff --git a/include/sysemu/nvmm.h b/include/sysemu/nvmm.h
index 833670fccb..be7bc9a62d 100644
--- a/include/sysemu/nvmm.h
+++ b/include/sysemu/nvmm.h
@@ -7,6 +7,8 @@
  * See the COPYING file in the top-level directory.
  */
 
+/* header to be included in non-NVMM-specific code */
+
 #ifndef QEMU_NVMM_H
 #define QEMU_NVMM_H
 
diff --git a/include/sysemu/tcg.h b/include/sysemu/tcg.h
index 53352450ff..5e2ca9aab3 100644
--- a/include/sysemu/tcg.h
+++ b/include/sysemu/tcg.h
@@ -5,6 +5,8 @@
  * See the COPYING file in the top-level directory.
  */
 
+/* header to be included in non-TCG-specific code */
+
 #ifndef SYSEMU_TCG_H
 #define SYSEMU_TCG_H
 
diff --git a/include/sysemu/whpx.h b/include/sysemu/whpx.h
index 2889fa2278..781ca5b2b6 100644
--- a/include/sysemu/whpx.h
+++ b/include/sysemu/whpx.h
@@ -10,6 +10,8 @@
  *
  */
 
+/* header to be included in non-WHPX-specific code */
+
 #ifndef QEMU_WHPX_H
 #define QEMU_WHPX_H
 
diff --git a/include/sysemu/xen.h b/include/sysemu/xen.h
index 0ca25697e4..bc13ad5692 100644
--- a/include/sysemu/xen.h
+++ b/include/sysemu/xen.h
@@ -5,6 +5,8 @@
  * See the COPYING file in the top-level directory.
  */
 
+/* header to be included in non-Xen-specific code */
+
 #ifndef SYSEMU_XEN_H
 #define SYSEMU_XEN_H
 
-- 
2.38.1

