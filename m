Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8A27DC3E
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgI2Woy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729065AbgI2Woy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:54 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HavTR5jlyYY+4DgutSw3BluUcAU3B5yxPF0wWIdw1vM=;
        b=QyvM5hYZo5PdYeljjB38as95s9QeLZPEtEAwVsVN/+kcCFuog/ylXU/V9PWj6gUWYamM+D
        lwO1XmBmVCVCot88w8WqmMwtrBOd35tyssLmK0bqBN/6y3e7JXa52AqtcDQ4JZQiJ9q5P/
        HraFse+nQeq020BOi6CpS3tpdVeTkGc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-3oGbZPqfPiesOX3IMerM3A-1; Tue, 29 Sep 2020 18:44:50 -0400
X-MC-Unique: 3oGbZPqfPiesOX3IMerM3A-1
Received: by mail-wr1-f70.google.com with SMTP id l17so2327073wrw.11
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HavTR5jlyYY+4DgutSw3BluUcAU3B5yxPF0wWIdw1vM=;
        b=THfgDFrZazmMMH7V+U7mUyamX++cX1/vId/CgtDcBHd7VjjGXG9x2lVMLuE7ktrfUf
         uflS6Y+hLqe7P1QA8puspAB3PqrgePz7lvl/EjkMTBfuPLVjpXFjbVZDeWMRCS+6XnKp
         oIszCbVx7wkF5uwMSNsKmVRKqrfThq0VfDtHaigWiKRUd61tZOJLzDhjtOIZVdvpu7Gx
         lfALExX1RAs6dE5oncJrwH65teU6+CJDp8V5m0YqfA0OmQwHpL7mSK5IiJWr0qUnHZwc
         cAseynxiKbTK3mR7XAtTgivc27SKZLlLRaKsl4UG1oQsIM+poSjG/UXW1y3mah5jzisk
         krYg==
X-Gm-Message-State: AOAM532oukLOKyYGTpVd1pJOWdc26NFkwW999CheFF+VWkqC5+ooZjjr
        sNggYN8xxK9jSKpmU/b7QOVR5salwRR2G6pZiIPpzSN9ewoyyGhD5MqcCwG1Q3QdOI3oTaLsoAD
        vqiW8MaWWozHu
X-Received: by 2002:adf:f552:: with SMTP id j18mr7126136wrp.128.1601419489039;
        Tue, 29 Sep 2020 15:44:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8PSYX9/XyNa0d4ovucJYi4QupKVwuKDBSqVqoLbQhr626hwpDLMGmdduFj20kYY9OEgIMog==
X-Received: by 2002:adf:f552:: with SMTP id j18mr7126125wrp.128.1601419488887;
        Tue, 29 Sep 2020 15:44:48 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id t4sm8074682wrr.26.2020.09.29.15.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:48 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v4 10/12] target/arm: Do not build TCG objects when TCG is off
Date:   Wed, 30 Sep 2020 00:43:53 +0200
Message-Id: <20200929224355.1224017-11-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We can now safely turn all TCG dependent build off when CONFIG_TCG is
off. This allows building ARM binaries with --disable-tcg.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
[PMD: Heavily rebased during almost 2 years then finally rewritten =) ]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/meson.build | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index f6a88297a8..9b7727d4bb 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,24 +16,29 @@ arm_ss = ss.source_set()
 arm_ss.add(gen)
 arm_ss.add(files(
   'cpu.c',
-  'crypto_helper.c',
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
+  'vfp_helper.c',
+))
+
+arm_tcg_ss = ss.source_set()
+arm_tcg_ss.add(files(
+  'arm-semi.c',
+  'cpu_tcg.c',
+  'crypto_helper.c',
+  'debug_helper.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'translate.c',
   'vec_helper.c',
-  'vfp_helper.c',
-  'cpu_tcg.c',
 ))
-arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
+
+arm_tcg_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
 
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_TCG', if_true: files('arm-semi.c'))
 arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
 
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
@@ -41,6 +46,9 @@ arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: fil
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c',
+))
+
+arm_tcg_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'helper-a64.c',
   'mte_helper.c',
   'pauth_helper.c',
@@ -49,14 +57,16 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'translate-sve.c',
 ))
 
+arm_ss.add_all(when: 'CONFIG_TCG', if_true: arm_tcg_ss)
+
 arm_softmmu_ss = ss.source_set()
 arm_softmmu_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
   'machine.c',
   'monitor.c',
-  'psci.c',
 ))
+arm_softmmu_ss.add(when: 'CONFIG_TCG', if_true: files('psci.c'))
 
 target_arch += {'arm': arm_ss}
 target_softmmu_arch += {'arm': arm_softmmu_ss}
-- 
2.26.2

