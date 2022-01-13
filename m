Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3ED48D009
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiAMBPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiAMBPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:15:05 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D947C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:05 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n23-20020a17090a161700b001b3ea76b406so6098151pja.5
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VzIvKx1GxYRKZyj3qaHjuGKQQw/z1gYrwBUmJVRKcfA=;
        b=tTTFHw7bD2QUxe96fLsou27D3AizYGa/yrJRXb/ilnmxd9/3nSTiDaVtCmvMIkVc3Z
         jiEJo3S9D4/i/iq0mpvCsDCGMIw/Kv1AjXH7ID5sY5BKAbFHp6U3erxz0W9fKxlt9nc4
         8YFb9HD0Uf5SO2y+Nw4Wta0iLbG8GY6jliU34fJ1IeHlu5oooclfl9ENSCJiGIgy+Bbq
         LRLtd2IhjNuLLMb5txNAwDO+1Ncccq222fqUs05Zse+s/EMfjXLSvifMbbREd9k1R4+v
         euxeyAa1XC+SanhGzsHlZmiMGpEA81LBdimZ8shV7UFYFMt5CaaciVQrjIMyyoyeRAV5
         e6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VzIvKx1GxYRKZyj3qaHjuGKQQw/z1gYrwBUmJVRKcfA=;
        b=I7ACZPA5PzTyi3FjCaMC6Nbo2CCtfTBoPn9n2TfrxPge5VgJTQD0B9HcK0DehH4UGv
         f4IDUJk/3O0w1ysl2DCrc6+Acdr3tM57+65RHL6NLtexZekEodeMBElzeLkIbfKsFbpY
         wnMVtAU3BAdwqqiSGVvAGSqrkZvLyjCrd4behRJ33nbCjhZx3cgCSgPkoOo6uXcjs/Kc
         sSAOdHjnu5vcSb1ODVxHrQFpug3z6/tl1YT3xljclPmEtyqOPD2HNzMpmMqWP+kwVbCD
         j/qbwBwuvJsUaLDYcihc1IPCEmkEIsN9rEs3bKktCvXI1KMFYm4MQ3owxej6iqv0AWI5
         +dVg==
X-Gm-Message-State: AOAM533CdiA3o2Qw5vLeHGPbOkBrGQNxhUNgfBodhV9OP/OJbeY/qCFh
        c890D9dt9jSfyEFxJqV+ClX9qCFYjck263FH/APDJ6XjbcSQJOY8Z9AHaWEYr2jFTLzgrFXY/YD
        gy39QNdlrvSRjg06nX22Cj6K1v4LHg0YTO6XpX2bR96BBZqeKQ0b65FyNZMR9dWA=
X-Google-Smtp-Source: ABdhPJzgVOYSve6Hg7mzrK1PfwivJzR1tjr9L0MEMrvX9lEfxaLWom+6rrGELNlCU6WAUrfMSN/NTZfm2/4mgg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:2a4e:: with SMTP id
 d14mr229274pjg.0.1642036504267; Wed, 12 Jan 2022 17:15:04 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:51 -0800
In-Reply-To: <20220113011453.3892612-1-jmattson@google.com>
Message-Id: <20220113011453.3892612-5-jmattson@google.com>
Mime-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 4/6] selftests: kvm/x86: Export x86_family() for use outside
 of processor.c
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
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
index fdd259c1ab49..6776d692b238 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1442,18 +1442,6 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
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
2.34.1.575.g55b058a8bb-goog

