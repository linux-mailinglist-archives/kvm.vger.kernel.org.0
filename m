Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BA7305790
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 10:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhA0J5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 04:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbhA0JxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 04:53:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DADC06178A
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 01:52:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j13so1678235edp.2
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 01:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BKiGeCY30LxdXtXYtI8PHHaDHc9dLjGHHBqPPsCS+f0=;
        b=KPEtaCgfMgXZz0v/ms9wLhVOVP8cpev0WGYEBZIG2PZy+wyV57jCz4pDu0AyXhYIKS
         AznVBThkXIOnhfZtXsL8+gaWaPIGQ4kHOQrUzTa3EZGkkApXnt5irnJWGLhVjp8WpGix
         lHg+oPT9zG4KRyuI3WZ2+uN9nM5FVfgcJtwqlzhlduMIyqLqPLZm2sa1jQmecDc7WSma
         G3MXLQHf2cKMVC4SY0CQmEP+vEsfKGm0zt8SKxEn7JLci0kAC20d14a95TXN5RwBhgWF
         dUw1dC7vhSG7NRP+KCxSROifWFGGKYOV3ClXRG8joQ/NshfYCLwZ9kI/ZbUgo5Tr3dlD
         EBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=BKiGeCY30LxdXtXYtI8PHHaDHc9dLjGHHBqPPsCS+f0=;
        b=OI3ay2Qiz05komjIptgl5qOvB6Nrn2sUwARZALh5LJnrnmrnzxAOBoL1u5gCs+fvOV
         YcHbj5F4bOscQzZH3+oR8nln1Vai2H4OyyqKsTl8V+s6hpzefCmBIWuOiXX0029Znl+3
         X4M5DcuTveAQQtfH774QfxxFcP+qHiGZ8fg93/jf42J5hJ6eQlUnA2rpdjqRZ9dWa81h
         iXjR4KxouiEAcig4SjvQRfc0OXtqlEvwyBwnWJYdqPUiIdI3kQu+SXkDNaufwCZVNESd
         jj7uspkuGwLerKliHJjiKmK4pEVv0fD0Ah2bY57IBmFchCP5zUhHi0MoDkg3l+e5A4e0
         eSVQ==
X-Gm-Message-State: AOAM530qW6a+WQf1OR9rv5bmxbjyZLqYEBVMp1y3ijJmkLMmY+NXr5g4
        pqjTzO67HmGEondA5mLEusR/Xn0RYYw7oA==
X-Google-Smtp-Source: ABdhPJxYEgpBZHhMNggQoP1dw8Flw/KobqdraSONmXuE91pWqJV45/ZYJX1JTJbiv9XCrvWfdV5toQ==
X-Received: by 2002:a05:6402:1682:: with SMTP id a2mr8458434edv.30.1611741156269;
        Wed, 27 Jan 2021 01:52:36 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm926265edv.65.2021.01.27.01.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 01:52:35 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com
Subject: [PATCH kvm-unit-tests] x86: use -cpu max instead of -cpu host
Date:   Wed, 27 Jan 2021 10:52:34 +0100
Message-Id: <20210127095234.476291-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows the tests to run under TCG as well.  "-cpu max" is not available on
CentOS 7, however that doesn't change much for our CI since we weren't testing
the CentOS 7 + KVM combination anyway.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .gitlab-ci.yml    |  4 +++-
 x86/unittests.cfg | 40 ++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 8834e59..d97e27e 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -75,6 +75,7 @@ build-x86_64:
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
      eventinj msr port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
+     rdpru pku pks smap tsc_adjust xsave
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -89,7 +90,7 @@ build-i386:
      cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
      vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt vmexit_ple_round_robin
      vmexit_tscdeadline vmexit_tscdeadline_immed eventinj port80 setjmp sieve
-     tsc taskswitch umip
+     tsc taskswitch umip rdpru smap tsc_adjust xsave
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -103,6 +104,7 @@ build-clang:
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
      eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
+     rdpru pku pks smap tsc_adjust xsave
      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 8c39630..90e370f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -128,12 +128,12 @@ check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
 [smap]
 file = smap.flat
-extra_params = -cpu host
+extra_params = -cpu max
 
 [pku]
 file = pku.flat
 arch = x86_64
-extra_params = -cpu host
+extra_params = -cpu max
 
 [pks]
 file = pks.flat
@@ -163,7 +163,7 @@ arch = x86_64
 
 [memory]
 file = memory.flat
-extra_params = -cpu host
+extra_params = -cpu max
 arch = x86_64
 
 [msr]
@@ -171,12 +171,12 @@ file = msr.flat
 
 [pmu]
 file = pmu.flat
-extra_params = -cpu host
+extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-extra_params = -machine vmport=on -cpu host
+extra_params = -machine vmport=on -cpu max
 check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
 arch = x86_64
 
@@ -204,12 +204,12 @@ extra_params = -cpu kvm64,+rdtscp
 
 [tsc_adjust]
 file = tsc_adjust.flat
-extra_params = -cpu host
+extra_params = -cpu max
 
 [xsave]
 file = xsave.flat
 arch = x86_64
-extra_params = -cpu host
+extra_params = -cpu max
 
 [rmap_chain]
 file = rmap_chain.flat
@@ -218,7 +218,7 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-extra_params = -cpu host,+svm -m 4g
+extra_params = -cpu max,+svm -m 4g
 arch = x86_64
 
 [taskswitch]
@@ -248,7 +248,7 @@ arch = x86_64
 
 [rdpru]
 file = rdpru.flat
-extra_params = -cpu host
+extra_params = -cpu max
 arch = x86_64
 
 [umip]
@@ -261,33 +261,33 @@ arch = i386
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
+extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
 arch = x86_64
 groups = vmx
 
 [ept]
 file = vmx.flat
-extra_params = -cpu host,host-phys-bits,+vmx -m 2560 -append "ept_access*"
+extra_params = -cpu max,host-phys-bits,+vmx -m 2560 -append "ept_access*"
 arch = x86_64
 groups = vmx
 
 [vmx_eoi_bitmap_ioapic_scan]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_eoi_bitmap_ioapic_scan_test
+extra_params = -cpu max,+vmx -m 2048 -append vmx_eoi_bitmap_ioapic_scan_test
 arch = x86_64
 groups = vmx
 
 [vmx_hlt_with_rvi_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append vmx_hlt_with_rvi_test
+extra_params = -cpu max,+vmx -append vmx_hlt_with_rvi_test
 arch = x86_64
 groups = vmx
 timeout = 10
 
 [vmx_apicv_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test"
+extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test"
 arch = x86_64
 groups = vmx
 timeout = 10
@@ -295,14 +295,14 @@ timeout = 10
 [vmx_apic_passthrough_thread]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
+extra_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
 arch = x86_64
 groups = vmx
 
 [vmx_init_signal_test]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_init_signal_test
+extra_params = -cpu max,+vmx -m 2048 -append vmx_init_signal_test
 arch = x86_64
 groups = vmx
 timeout = 10
@@ -310,21 +310,21 @@ timeout = 10
 [vmx_sipi_signal_test]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_sipi_signal_test
+extra_params = -cpu max,+vmx -m 2048 -append vmx_sipi_signal_test
 arch = x86_64
 groups = vmx
 timeout = 10
 
 [vmx_apic_passthrough_tpr_threshold_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
+extra_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
 arch = x86_64
 groups = vmx
 timeout = 10
 
 [vmx_vmcs_shadow_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
+extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
 
@@ -367,5 +367,5 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
 
 [tsx-ctrl]
 file = tsx-ctrl.flat
-extra_params = -cpu host
+extra_params = -cpu max
 groups = tsx-ctrl
-- 
2.29.2

