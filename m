Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A15948E218
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiANBV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiANBVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB7DC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j37-20020a634a65000000b00349a11dc809so922180pgl.3
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t5+Hk25faeWd6hJuKjoKVUQoChCD/0tSxqnL+SgNhi8=;
        b=Do2zbEfqTof61cSUME/a3BcZtxo4tjOlh+QzT+eiqPdPiP1ITAAIA9jqj/6Xu/I5hO
         iF1VvNi6QC5+HbhBPNemluJX6Ms8u4z05kzsnwZCfaIjY+5H9QZ5igZcWdoMVAhwO1k5
         4sG9706B52QRFedMaIHtItVH6UFjy7ZiSPxZthdl7qgYeFy6oqUBpamuKkwABrhm5w4c
         x2CNp9XMBSkbNeskQV37NJnHiHYamYthrkY7c/b6q/JstCDQJPqqwSmFE4oFU2iM9XU9
         smm58q4XZV9CwlbyVDiVpLO6SZQwCPsNjF24hCkxMQrtytuS92b2RPtkIgLBr6ldIjGj
         WsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t5+Hk25faeWd6hJuKjoKVUQoChCD/0tSxqnL+SgNhi8=;
        b=pDb7yEOpKFZgHP/BOS6s/spKWYTLQ07SfTiRw//cNsgX7RPyLinESAxYZoiUmMEVKl
         ySpXNI4XHiiKFJMRadKqBpkVp4InpupRmqN1nwD4felFhkujUyYt1LnXmk8x0vrbFV/m
         CqiBC4pD7XuiGVtENQb0WCnK9BbLxeIQgH6Em3rIZCjvW5PC6kUWeA2U/LMHKiEvrNfN
         xHReJ1/j2ryMT9FRXKdeG0cX97Y+uT/+rUldn6p0muYbd+hLvmAh7tB7DyWlwomvw6oW
         87igcnM0kw/HEnrWerPGbiXA9YWfI2CrzC0N2a+zqtAm4nThJfwHujSfd3DXVnruShae
         e7jw==
X-Gm-Message-State: AOAM531AMa/EjE03t2C1w/dHuX1B4RJaDb2L2aCxwZcpY3I5vLE4vJA3
        vFpRGQS8FV5TzAWbdbf+p2vv0pdCl+dNAM64d4/B2BIjZ9KLe9KN/7xNotpr5TZNpUzUlUm9G+W
        oyYJBcWRms9G6yUCvFCOvQq7A5T3uxCoyzqHg77lqF/4uIm+jM9RNoxO+mPTEsps=
X-Google-Smtp-Source: ABdhPJzfVCQyuohcBMtoTEzzCjFPxM5SqmywzM/f3BeNb3q8AyVwc2qxUl/QvHvBoAEa5aPC+y69dx40ituJww==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:c40b:b0:14a:5ccb:c145 with SMTP
 id k11-20020a170902c40b00b0014a5ccbc145mr7252092plk.170.1642123284429; Thu,
 13 Jan 2022 17:21:24 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:07 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-5-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 4/6] selftests: kvm/x86: Export x86_family() for use
 outside of processor.c
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move this static inline function to processor.h, so that it can be
used in individual tests, as needed.

Opportunistically replace the bare 'unsigned' with 'unsigned int.'

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h | 12 ++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 69eaf9a69bb7..c5306e29edd4 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -349,6 +349,18 @@ static inline unsigned long get_xmm(int n)
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
+static inline unsigned int x86_family(unsigned int eax)
+{
+        unsigned int x86;
+
+        x86 = (eax >> 8) & 0xf;
+
+        if (x86 == 0xf)
+                x86 += (eax >> 20) & 0xff;
+
+        return x86;
+}
+
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index b969e38bc02e..286ae9605501 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1444,18 +1444,6 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 	return cpuid;
 }
 
-static inline unsigned x86_family(unsigned int eax)
-{
-        unsigned int x86;
-
-        x86 = (eax >> 8) & 0xf;
-
-        if (x86 == 0xf)
-                x86 += (eax >> 20) & 0xff;
-
-        return x86;
-}
-
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
-- 
2.34.1.703.g22d0c6ccf7-goog

