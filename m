Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB1A5174A8
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbiEBQpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 12:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiEBQpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 12:45:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDEB631E
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:41:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so8297931pff.13
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=b1+yhpYVGzHw/LBxyBaQyQvUgwk5eQOwyuJq8Nq+m3Y=;
        b=ipx3khv2mxpXyVz88bWTrcyFIDZ8nbH9kl5/zsD8jURUudI/yZVbnjbtQeLhMvrJqH
         M2a2mLuGdNR+zbLc5FucMqVkmdruTQmByp8gV0oR2xw43kn7iPFi/gP0gySTDHVGWF2L
         NEmxTFWwFYpTYnDKkk0Jr6b88gUwX8ghfvNo9e7UulRI4iVI+O2d6Ko7zZaIK9yuHrLk
         r6kBgyG/IwfB6rW3fDT/Hpm+HhV9DSViKuVRog+YTc2Isn7c0FMDYLA+Z9mAylj2tOCw
         5JUt779vrK0YMHz6AWT8RQWKikceWj8uYK3IslR10b+uyV+sbhCLKkexdolVboFGT5bB
         9H1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=b1+yhpYVGzHw/LBxyBaQyQvUgwk5eQOwyuJq8Nq+m3Y=;
        b=ZD3cwYdThNho+coeTRodg8OPP3wZP/vIRwswiNvM9UqEf0QQ/0dLVsJFR5sytUORTx
         dj4MkATxIFJVimfAi0zdMDeph/URnaeGqfCqcAOtLLsJxGP2yhi4fDLjvk5q/hlbNUCi
         pa2/XY1ffq/Xj053+geatixXuOS6KAecFHyTIUDvT0xE11HvskjAGto30ptw4i1OKU/0
         Iim3otlRpgZhNpQBVeWfmPKCE5Buoxa8MSlySQnJmqMpXTl87XzTUC7jn+xu6r3j8BMa
         9vvV8Xfx4aHiVINER29XxNLYzmFIuRL9RJ2qU99QEyQPMqIjXHK26JTJZZOcUx9bdY9Q
         I8qQ==
X-Gm-Message-State: AOAM532nnyBEvOdKQkeNetNolukj4DKiuEVqilVA9vF8q8g6lST90SWj
        3pRJZDQVDXy4gU1uGW0WH6rJdvL2+S1zw/yKDEzHKWBQYAX3r0Xv1LS+B4aLegXtyKmiKtFnkBZ
        410sO69XwPBSMYOYrvgvNvFMl2GPAve2l9MuFuAo1g8DYSjCdHsGW9KtnRldO7z9iNnpf
X-Google-Smtp-Source: ABdhPJznOA0ZuTKJZgA6wsecD2CIp6FEVOhHy6vYOJY6652tIaN2Xwu1xKcRfd2aJ9rlQUuK+w/4ie2IvqW8oB1E
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:11d1:b0:1db:d99f:62cc with SMTP
 id gv17-20020a17090b11d100b001dbd99f62ccmr17634pjb.200.1651509697061; Mon, 02
 May 2022 09:41:37 -0700 (PDT)
Date:   Mon,  2 May 2022 16:40:05 +0000
Message-Id: <20220502164004.1298575-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [kvm-unit-tests PATCH] x86: vmx: Break the 'vmx' monolith into
 multiple tests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jmattson@google.com,
        seanjc@google.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Break 'vmx' into multiple tests to reduce the number of tests run at
once.  This will help get a better signal up front on failure with them
broken up into categories.  This will also do a better job of not
disguising new failures if one of the tests is already failing.

One side effect of breaking this test up is any new test added will
have to be manually added to a categorized test.  It will not
automatically be picked up by 'vmx'.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/unittests.cfg | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b48c98b..0d90413 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -254,13 +254,49 @@ extra_params =3D -cpu qemu64,+umip
 file =3D la57.flat
 arch =3D i386
=20
-[vmx]
+[vmx_legacy]
 file =3D vmx.flat
-extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_a=
ccess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -v=
mx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
+extra_params =3D -cpu max,+vmx -append "null vmenter preemption_timer cont=
rol_field_PAT control_field_EFER CR_shadowing I/O_bitmap instruction_interc=
ept EPT_A/D_disabled EPT_A/D_enabled PML interrupt nmi_hlt debug_controls M=
SR_switch vmmcall disable_RDTSCP int3 into invalid_msr"
 arch =3D x86_64
 groups =3D vmx
=20
-[ept]
+[vmx_basic]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "v2_null_test v2_multiple_entries_t=
est fixture_test_case1 fixture_test_case2"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_vm_entry]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "vmx_controls_test vmx_host_state_a=
rea_test vmx_guest_state_area_test vmentry_movss_shadow_test vmentry_unrest=
ricted_guest_test"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_apic]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "vmx_eoi_bitmap_ioapic_scan_test vm=
x_hlt_with_rvi_test vmx_apic_passthrough_test vmx_apic_passthrough_thread_t=
est vmx_sipi_signal_test"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_regression]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "vmx_ldtr_test vmx_cr_load_test vmx=
_cr4_osxsave_test vmx_nm_test vmx_db_test vmx_nmi_window_test vmx_intr_wind=
ow_test vmx_pending_event_test vmx_pending_event_hlt_test vmx_store_tsc_tes=
t"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_preemption_timer]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "vmx_preemption_timer_zero_test vmx=
_preemption_timer_tf_test vmx_preemption_timer_expiry_test"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_misc]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append "invvpid_test atomic_switch_max_msr=
s_test rdtsc_vmexit_diff_test vmx_mtf_test vmx_mtf_pdpte_test vmx_exception=
_test"
+arch =3D x86_64
+groups =3D vmx
+
+[vmx_ept]
 file =3D vmx.flat
 extra_params =3D -cpu host,host-phys-bits,+vmx -m 2560 -append "ept_access=
*"
 arch =3D x86_64
--=20
2.36.0.464.gb9c8b46e94-goog

