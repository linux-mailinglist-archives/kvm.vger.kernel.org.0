Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6445D2D1
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353675AbhKYCFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbhKYCDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E2DC0619EE
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:03 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id mn13-20020a17090b188d00b001a64f277c1eso3884646pjb.2
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc:content-transfer-encoding;
        bh=TADl6tghUWuNbjIh4umz0iINS3LOHqcuh7MettGYbFU=;
        b=hdvEwI2Guwkd0+T/UxhXrpqxnKMJGXwP9W5AgSPqyA1dDR8p3DCcN8qTv2vJWLRwQP
         rvRxE9QQjr01ObnXvoViD7emMkcxSS6lfuy+Ylx+jCBvc5dRKqPKEC4UDieZY9Z1Rm7c
         r6NT0WpR71qjX+rmitACJ1htKI/HOv3CykRSFZsTr0UFrkWnwUU1Onvq5j1R5WQCIiRQ
         I1uPWZYR19Qoi9YwvPQjRxz6uPbl3svf9bVNaxrIgyw6JsdnUemFrPD+N3HKl4YVoylT
         mWndQpT7kvseYEC0jCMcr3XMMaLX/K0MUkrEwwhYYCmrm2mF7dFGztijYzgHu5dyUmNa
         Rkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc
         :content-transfer-encoding;
        bh=TADl6tghUWuNbjIh4umz0iINS3LOHqcuh7MettGYbFU=;
        b=rlHYuu8fqU6S0rpjdGr4k94Egih5bDR2oe14joVecEslPIc2FM/6zFIy2d6EnvhEed
         ad5O5Wwrk6VQZ7CKlwwO+1KHvHfoAJg/UhwuCIzRLIPmEbjtySGYjDs3nlvTKoN1LZzz
         847nOMXW+Kbj318OnR4G4MZd9LH0IGSMUcKqN3UdS5k4MdKyc2nzaYxI2I4lX5gd/PX8
         gdkmqEveDRQtHbldOQ5NYw5Q+9kghrY1hzQX/e2K6xzymFJmPVyhnmUY+1ziqClN72wp
         H5sUmgsgtREpOvCokAXK3r61uRijTbIt1JSPKsJCbMc19MoVXhxPEVmQm7Y/4XLgDSlt
         crkw==
X-Gm-Message-State: AOAM531CEsRc3dra/C6A/xi+0M3Av72lKxBVmlm6W7Ixdxi1o7Y1LMGF
        UYbIhrPsveCm7De9nA4aDOgSAydJCAM=
X-Google-Smtp-Source: ABdhPJyY08jPuSoDJi0GLY7jyHh7HI7F33InotFGqQE6yqTFQI6/okpFJh0Al6s7UovFI/obvzc6pcUdax0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24cd:b0:49f:a4d8:3d43 with SMTP id
 d13-20020a056a0024cd00b0049fa4d83d43mr10796013pfv.49.1637803803266; Wed, 24
 Nov 2021 17:30:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:57 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-40-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 39/39] x86/access: nVMX: Add "access" test
 variants to invalidate via (INV)VPID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add three variants of the #PF interception access test to handle TLB
invalidations by relying on VPID rules.  Intercept the access test's
INVLPG and perform invalidation by:

  1. Implicity flush on VM-Enter by disabling VPID
  2. Explicitly perform INVVPID on the target address
  3. Implicitly "flush" by moving to a new VPID

Case #3 exposes a bug where KVM fails to update unsync SPTEs when using
shadow paging and L1 changes the VPID it uses for L2, i.e. vmcs12->vpid.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg |  6 ++--
 x86/vmx_tests.c   | 89 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f3f9f17..80875d2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -284,7 +284,7 @@ arch =3D i386
=20
 [vmx]
 file =3D vmx.flat
-extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test"
+extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vm=
x_pf_vpid_test"
 arch =3D x86_64
 groups =3D vmx
=20
@@ -353,13 +353,13 @@ groups =3D vmx
=20
 [vmx_pf_exception_test]
 file =3D vmx.flat
-extra_params =3D -cpu max,+vmx -append vmx_pf_exception_test
+extra_params =3D -cpu max,+vmx -append "vmx_pf_exception_test vmx_pf_no_vp=
id_test vmx_pf_vpid_test vmx_pf_invvpid_test"
 arch =3D x86_64
 groups =3D vmx nested_exception
=20
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file =3D vmx.flat
-extra_params =3D -cpu IvyBridge,phys-bits=3D36,host-phys-bits=3Doff,+vmx -=
append vmx_pf_exception_test
+extra_params =3D -cpu IvyBridge,phys-bits=3D36,host-phys-bits=3Doff,+vmx -=
append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_i=
nvvpid_test"
 arch =3D x86_64
 groups =3D vmx nested_exception
 check =3D /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=3DY
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 172d385..3d57ed6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10575,13 +10575,21 @@ static void vmx_pf_exception_test_guest(void)
 	ac_test_run(PT_LEVEL_PML4);
 }
=20
-static void vmx_pf_exception_test(void)
+typedef void (*invalidate_tlb_t)(void *data);
+
+static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
 {
 	u64 efer;
 	struct cpuid cpuid;
=20
 	test_set_guest(vmx_pf_exception_test_guest);
=20
+	/* Intercept INVLPG when to perform TLB invalidation from L1 (this). */
+	if (inv_fn)
+		vmcs_set_bits(CPU_EXEC_CTRL0, CPU_INVLPG);
+	else
+		vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_INVLPG);
+
 	enter_guest();
=20
 	while (vmcs_read(EXI_REASON) !=3D VMX_VMCALL) {
@@ -10605,6 +10613,9 @@ static void vmx_pf_exception_test(void)
 			regs.rcx =3D cpuid.c;
 			regs.rdx =3D cpuid.d;
 			break;
+		case VMX_INVLPG:
+			inv_fn(data);
+			break;
 		default:
 			assert_msg(false,
 				"Unexpected exit to L1, exit_reason: %s (0x%lx)",
@@ -10617,6 +10628,79 @@ static void vmx_pf_exception_test(void)
=20
 	assert_exit_reason(VMX_VMCALL);
 }
+
+static void vmx_pf_exception_test(void)
+{
+	__vmx_pf_exception_test(NULL, NULL);
+}
+
+static void invalidate_tlb_no_vpid(void *data)
+{
+	/* If VPID is disabled, the TLB is flushed on VM-Enter and VM-Exit. */
+}
+
+static void vmx_pf_no_vpid_test(void)
+{
+	if (is_vpid_supported())
+		vmcs_clear_bits(CPU_EXEC_CTRL1, CPU_VPID);
+
+	__vmx_pf_exception_test(invalidate_tlb_no_vpid, NULL);
+}
+
+static void invalidate_tlb_invvpid_addr(void *data)
+{
+	invvpid(INVVPID_ALL, *(u16 *)data, vmcs_read(EXI_QUALIFICATION));
+}
+
+static void invalidate_tlb_new_vpid(void *data)
+{
+	u16 *vpid =3D data;
+
+	/*
+	 * Bump VPID to effectively flush L2's TLB from L0's perspective.
+	 * Invalidate all VPIDs when the VPID wraps to zero as hardware/KVM is
+	 * architecturally allowed to keep TLB entries indefinitely.
+	 */
+	++(*vpid);
+	if (*vpid =3D=3D 0) {
+		++(*vpid);
+		invvpid(INVVPID_ALL, 0, 0);
+	}
+	vmcs_write(VPID, *vpid);
+}
+
+static void __vmx_pf_vpid_test(invalidate_tlb_t inv_fn, u16 vpid)
+{
+	if (!is_vpid_supported())
+		test_skip("VPID unsupported");
+
+	if (!is_invvpid_supported())
+		test_skip("INVVPID unsupported");
+
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY);
+	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VPID);
+	vmcs_write(VPID, vpid);
+
+	__vmx_pf_exception_test(inv_fn, &vpid);
+}
+
+static void vmx_pf_invvpid_test(void)
+{
+	if (!is_invvpid_type_supported(INVVPID_ADDR))
+		test_skip("INVVPID ADDR unsupported");
+
+	__vmx_pf_vpid_test(invalidate_tlb_invvpid_addr, 0xaaaa);
+}
+
+static void vmx_pf_vpid_test(void)
+{
+	/* Need INVVPID(ALL) to flush VPIDs upon wrap/reuse. */
+	if (!is_invvpid_type_supported(INVVPID_ALL))
+		test_skip("INVVPID ALL unsupported");
+
+	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
+}
+
 #define TEST(name) { #name, .v2 =3D name }
=20
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10723,5 +10807,8 @@ struct vmx_test vmx_tests[] =3D {
 	TEST(vmx_mtf_test),
 	TEST(vmx_mtf_pdpte_test),
 	TEST(vmx_pf_exception_test),
+	TEST(vmx_pf_no_vpid_test),
+	TEST(vmx_pf_invvpid_test),
+	TEST(vmx_pf_vpid_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
--=20
2.34.0.rc2.393.gf8c9666880-goog

