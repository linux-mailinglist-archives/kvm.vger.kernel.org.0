Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A7948D008
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiAMBPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiAMBPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:15:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309F7C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:03 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l9-20020a170903120900b0014a4205ebe3so4343476plh.11
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Etwj06rxZKUm/V9RUchPhlkff6JIDDzSi2aLypfcT+w=;
        b=cb4gzM3kZYL5/BlSSeHJRDC1KzW/vkYqjFzm0MdNsVhLmVIvuXEo7wIG91Aqa1s7vr
         OHYoTrKsrElvia1EPoFwfBPvOeL0wirh29yoHovuo6US176LGgg0646NFa9TW5p2vSvR
         GdB4lc+gOgP4p/q1QVWsabwtxjCPH9JAehFFR/JdpmlkHTZuxq/M5J49Avi7vp4OxQo6
         5J06C8oGflZ17S4N+KHBEVA+C+MzFOdUSpLFFJ+ALiuTp2RAWgsnQwxGbpFU2Wu2Gnxb
         c1vEYvfxNfPiiKhM9G07RrL9hUpVvs2QsFBIpoDUv7lz1dtTwlpLTUKYrYDr0DX5Qov5
         ukWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Etwj06rxZKUm/V9RUchPhlkff6JIDDzSi2aLypfcT+w=;
        b=v5sBnzqMJQsAatEoajlHr3ow2C7xJMrtkwIOGkTaJNz0Asf7REYrAZt2mFY9sieO7W
         tFWHlA88w/kgOc2ztfVtPt8acp+vRj8HMS6Yzhp/BcTp2REOXMn3k01lEyX+ljhEAU/b
         xO1LXr1w16id3b40UIf0OJpuk48sltXQ7ySPn2EJ506BLZDoFpJk/QuZw1T6Evh8HBEO
         yV+oZfySF84hEYu+0pnUa4hdJsuYSBHuRHubM/etC4Px7aqu3kOAoR+4OcoCsCiuoui5
         D7+pZ05u7iEQeNvdHWkBW9+3W4a+Gwb77QLw3MrNSPwLTtn07m9WWkAYt7sC9+mmLTXv
         J4zg==
X-Gm-Message-State: AOAM5307NjvKY1g7eMM51QtqWh0NbQ5xz+39D5sxpNaqMZ4eu69+wBbn
        lrkLeGaN+ITCWBLfvacfUpEzz72arlGRNhjdvobt6vKJaUVfyK35043+nOKR3Ebv0hrzk8X2C0J
        DQRh4kksY5A5jMVz9S5CheiOsdHuFFgpKFHCVOIk3U56AmhtnpMo9zVdi8lb2vzk=
X-Google-Smtp-Source: ABdhPJyFeq40lgozOCuETdn2kczA14x4lih7J0usKC5UK9uzvY8OtHSuFzAPDT/r0z7FELPKH+AE0qtJ5l/0KQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:b58d:b0:149:9c02:6345 with SMTP
 id a13-20020a170902b58d00b001499c026345mr2443985pls.21.1642036502539; Wed, 12
 Jan 2022 17:15:02 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:50 -0800
In-Reply-To: <20220113011453.3892612-1-jmattson@google.com>
Message-Id: <20220113011453.3892612-4-jmattson@google.com>
Mime-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 3/6] selftests: kvm/x86: Introduce is_amd_cpu()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the one ad hoc "AuthenticAMD" CPUID vendor string comparison
with a new function, is_amd_cpu().

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h       |  1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 05e65ca1c30c..69eaf9a69bb7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -347,6 +347,7 @@ static inline unsigned long get_xmm(int n)
 }
 
 bool is_intel_cpu(void);
+bool is_amd_cpu(void);
 
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 355a3f6f1970..fdd259c1ab49 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1218,6 +1218,12 @@ bool is_intel_cpu(void)
 	return cpu_vendor_string_is("GenuineIntel");
 }
 
+bool is_amd_cpu(void)
+{
+	return cpu_vendor_string_is("AuthenticAMD") ||
+		cpu_vendor_string_is("AMDisbetter!");
+}
+
 uint32_t kvm_get_cpuid_max_basic(void)
 {
 	return kvm_get_supported_cpuid_entry(0)->eax;
@@ -1436,10 +1442,6 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 	return cpuid;
 }
 
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
-
 static inline unsigned x86_family(unsigned int eax)
 {
         unsigned int x86;
@@ -1463,9 +1465,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 	/* Avoid reserved HyperTransport region on AMD processors.  */
 	eax = ecx = 0;
 	cpuid(&eax, &ebx, &ecx, &edx);
-	if (ebx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx ||
-	    ecx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx ||
-	    edx != X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
+	if (!is_amd_cpu())
 		return max_gfn;
 
 	/* On parts with <40 physical address bits, the area is fully hidden */
-- 
2.34.1.575.g55b058a8bb-goog

