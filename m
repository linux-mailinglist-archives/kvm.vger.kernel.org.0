Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52E648F4F0
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiAOFY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiAOFYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:49 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3198EC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:49 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 67-20020a630746000000b003443fe43bbaso3118959pgh.12
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t5+Hk25faeWd6hJuKjoKVUQoChCD/0tSxqnL+SgNhi8=;
        b=etBIy029m1Euo3imJzWZn7Z/3uqHxFgwJTzreQhNlH6fE9JgVl7qnMJiS+m9m4uvbk
         NdQsBFYoUBa/R3wJgldm2zrgkQtGa3hh/kCKfC+3Pj3+n31A3GYrBc4S/WKkts7EM5s4
         B2/DXmr3hQGRUlLi2TrMkVc0GHRltXD1X8ikvi1RQQaFbqN/Qa9q3P4JSf7/ZHzmgG91
         eoClIQyy61Rxj7fksmwwMBLOs/pZfxI8V6wReO8wnkW2I6TUGo5Vilu5F31nm6nyjaHe
         oKzbuyMNcOsFgImRie0vRkYBnp5tWG91SO5+JwUBFemnGj4VNnjXw//Lhv8GGnLhRnF0
         wHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t5+Hk25faeWd6hJuKjoKVUQoChCD/0tSxqnL+SgNhi8=;
        b=ZypzED+QFh41IGuK2/IowhB97iFP5twHkGazuLF/D2Vt45/t+vK8OJo7RbHlmzKwkm
         Z1FiTVZcauBPZPQ3u89vRjJwXNCQ9ZrIZ9EhH8//+uNrTPwRRAsXSDbIyoOJu2rJ5Rh1
         D5pA7FvtRdK7RpU56UrMrvA7mD/BuKBjdh06kgblkc5ftEBbwQryADnq56vAGRVOcfBf
         wQbGedWypdXHm8/O+hKQ22f/pAenBgGcgjdVG+O7GVxzL3/MdPMRa6jvwitzBgnXCHOf
         efRmQOxsZlx/ySmD8Gz4ulWxwW+NL2rYr/21KvBVvZhtwRijRvd7xyqPg43VId8feF7x
         eMkw==
X-Gm-Message-State: AOAM531ChhN9PYLXSl0TyrXBy9PkGaZeQOiBBu74lWEVNR2BZHy3wFob
        KqwZ2hwqbai6JkJdWE1KkwYgbeqLvANnDrFMExikYBhO0gFWLvR7qBG09dDBLC4AZLM0UnEbhD0
        QVypnd0LrXjvx2OfL3ojb+gx8d1qV8XJeYS2ZbSAP3wzD/USYkREv3bq0a/lxyGQ=
X-Google-Smtp-Source: ABdhPJxt24YLcYQjvh1mWLMPnhBKGq1Eq92Kdi+TalP8rZCXnae5coh0T6+oufg4vDbGXTvgWMuSsc8k75gCFQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4c0b:: with SMTP id
 na11mr211059pjb.118.1642224288563; Fri, 14 Jan 2022 21:24:48 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:29 -0800
In-Reply-To: <20220115052431.447232-1-jmattson@google.com>
Message-Id: <20220115052431.447232-5-jmattson@google.com>
Mime-Version: 1.0
References: <20220115052431.447232-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 4/6] selftests: kvm/x86: Export x86_family() for use
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

