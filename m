Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E274A0E5C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfH1Xl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:57 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:50932 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfH1Xl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:56 -0400
Received: by mail-vk1-f202.google.com with SMTP id s80so551206vkb.17
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SKvcvADaX/cRYDBINNrqC24ZL5d9ozIWk+Ka38isKR0=;
        b=n4880A4K04SmQgLaL+qGzvkTUWVLM0PZIIApcPrbZvF2Ftz1XeyRq2sg8GoM51QKze
         mkVtqewAzGpht6EhCrOVKiHIJj5lvGdr4x9y1IY3zAMbiUOWE59XEC5E1SOOYQpF8tug
         zaflx6zQmI2B+3z4fVLk0dgxzuG6xLOGcNR0tzQooe3em42DoJKj1depRCUCeAJOftdd
         CzbHv9wSiDMsRwyjs8F8rkKZ4U7369tWPlzEqP0O0ptWlx+/cAaIcB7vL4g3Hr0yJvLz
         G668jXj0aOHGF5fvytG2lD0hxSAjalVkYQ5vQzX3cgH7FrxjB4VunbV6lJg3bCHsNeqg
         tQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SKvcvADaX/cRYDBINNrqC24ZL5d9ozIWk+Ka38isKR0=;
        b=PB08z62PvSGhNXeO02TdCcvM8Bc+iPN7PuqHcqucjPxqebOvtDmJs5IXXLL+KoYZyM
         /sXwAz77OUYePKDviaMP8LApt2GaAqAnyTkeetOhuP38unhFbqSHOG6ytTwx9DmESM9A
         9FpJzdR+/wme4QKM0OlWpEUxnVjyvyjqdu4PelStishdMC/dM8gTV7V7/6pW997z50ez
         Fq/jfr0EIFgifSgPrSmmU/T30Up0eaUC4YxJelznRadBiCuSDwo6nFKtpKS/cFh3Nw6i
         iMQv6oByLEmAK+nZOiKTi4UW3pTevvaW3VX+3nk1oG23wg5zKslrhPH5jfPdrC+FxGmP
         gxwA==
X-Gm-Message-State: APjAAAVfNU7TNnnsjhL2Y/TZN3EIYNg8ZB/HJIZVsb+cgOEX7kfh0xWX
        Kq3odfo+iKaqqiLGdiOvkyk/3Mr4UL5ZFBitQy6h1q+POKivymCdDSooo1rZ6taNsYJvszUtmsy
        aoh+/kW085dpio/bXnyaejc+A+hRR3B8tbKHwx2kAOc8z2Xd+V287NE4jHA==
X-Google-Smtp-Source: APXvYqyCsxAd5Zc3CahVwSBn2mjHn/miyuqyqXoLPvlcSbUMKUlLgt/4H2d/UkWuK/8SdwmqHwsZy1xT8T0=
X-Received: by 2002:a67:c112:: with SMTP id d18mr4044413vsj.42.1567035715389;
 Wed, 28 Aug 2019 16:41:55 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:34 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-8-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH 7/7] x86: VMX: Add tests for nested "load IA32_PERF_GLOBAL_CTRL"
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests to verify that KVM performs the correct checks on Host/Guest state
at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
Control Registers and MSRs".

Test that KVM does the following:

    If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
    reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
    GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
    should fail with an exit reason of "VM-entry failure due to invalid
    guest state" (33).

    If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
    reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
    HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
    should fail with a VM-instruction error of "VM entry with invalid
    host-state field(s)" (8).

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 186 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 94be937da41d..ac734fea7f3d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6837,6 +6837,189 @@ static void test_host_efer(void)
 	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
 }
 
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_edx {
+	struct {
+		unsigned int num_counters_fixed:5;
+		unsigned int bit_width_fixed:8;
+		unsigned int reserved:19;
+	} split;
+	unsigned int full;
+};
+
+static bool valid_pgc(u64 val)
+{
+	struct cpuid id;
+	union cpuid10_eax eax;
+	union cpuid10_edx edx;
+	u64 mask;
+
+	id = cpuid(0xA);
+	eax.full = id.a;
+	edx.full = id.d;
+	mask = ~(((1ull << eax.split.num_counters) - 1) |
+		(((1ull << edx.split.num_counters_fixed) - 1) << 32));
+
+	return !(val & mask);
+}
+
+static void test_pgc_vmlaunch(u32 xerror, bool xfail, bool host)
+{
+	u32 inst_err;
+	u64 guest_rip, inst_len;
+	bool success;
+
+	if (host) {
+		success = vmlaunch_succeeds();
+	} else {
+		if (xfail)
+			enter_guest_with_invalid_guest_state();
+		else
+			enter_guest();
+		success = VMX_VMCALL == (vmcs_read(EXI_REASON) & 0xff);
+		guest_rip = vmcs_read(GUEST_RIP);
+		inst_len = vmcs_read(EXI_INST_LEN);
+		if (success)
+			vmcs_write(GUEST_RIP, guest_rip + inst_len);
+	}
+	if (!success) {
+		inst_err = vmcs_read(VMX_INST_ERROR);
+		report("vmlaunch failed, VMX Inst Error is %d (expected %d)",
+		       xerror == inst_err, inst_err, xerror);
+	} else {
+		report("vmlaunch succeeded", success != xfail);
+	}
+}
+
+/*
+ * test_load_pgc is a generic function for testing the
+ * "load IA32_PERF_GLOBAL_CTRL" VM-{entry,exit} control. This test function
+ * will test the provided ctrl_val disabled and enabled.
+ *
+ * @nr - VMCS field number corresponding to the Host/Guest state field
+ * @name - Name of the above VMCS field for printing in test report
+ * @ctrl_nr - VMCS field number corresponding to the VM-{entry,exit} control
+ * @ctrl_val - Bit to set on the ctrl field.
+ */
+static void test_load_pgc(u32 nr, const char * name, u32 ctrl_nr,
+			  const char * ctrl_name, u64 ctrl_val)
+{
+	u64 ctrl_saved = vmcs_read(ctrl_nr);
+	u64 pgc_saved = vmcs_read(nr);
+	u64 i, val;
+	bool host = nr == HOST_PERF_GLOBAL_CTRL;
+
+	if (!host) {
+		vmx_set_test_stage(1);
+		test_set_guest(guest_state_test_main);
+	}
+	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
+			    ctrl_name);
+	for (i = 0; i < 64; i++) {
+		val = 1ull << i;
+		vmcs_write(nr, val);
+		report_prefix_pushf("%s = 0x%lx", name, val);
+		/*
+		 * If the "load IA32_PERF_GLOBAL_CTRL" bit is 0 then
+		 * the {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL field is ignored,
+		 * thus setting reserved bits in this field does not cause
+		 * vmlaunch to fail.
+		 */
+		test_pgc_vmlaunch(0, false, host);
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	vmcs_write(ctrl_nr, ctrl_saved | ctrl_val);
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=1 on %s",
+			    ctrl_name);
+	for (i = 0; i < 64; i++) {
+		val = 1ull << i;
+		vmcs_write(nr, val);
+		report_prefix_pushf("%s = 0x%lx", name, val);
+		if (valid_pgc(val)) {
+			test_pgc_vmlaunch(0, false, host);
+		} else {
+			/*
+			 * [SDM 30.4]
+			 *
+			 * Invalid host state fields result in an VM
+			 * instruction error with error number 8
+			 * (VMXERR_ENTRY_INVALID_HOST_STATE_FIELD)
+			 */
+			if (nr == HOST_PERF_GLOBAL_CTRL) {
+				test_pgc_vmlaunch(
+					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+					true, host);
+			/*
+			 * [SDM 26.1]
+			 *
+			 * If a VM-Entry fails according to one of
+			 * the guest-state checks, the exit reason on the VMCS
+			 * will be set to reason number 33 (VMX_FAIL_STATE)
+			 */
+			} else {
+				test_pgc_vmlaunch(
+					0,
+					true, host);
+				TEST_ASSERT_EQ(
+					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
+					vmcs_read(EXI_REASON));
+			}
+		}
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+
+	if (nr == GUEST_PERF_GLOBAL_CTRL) {
+		/*
+		 * Let the guest finish execution
+		 */
+		vmx_set_test_stage(2);
+		vmcs_write(ctrl_nr, ctrl_saved);
+		vmcs_write(nr, pgc_saved);
+		enter_guest();
+	}
+
+	vmcs_write(ctrl_nr, ctrl_saved);
+	vmcs_write(nr, pgc_saved);
+}
+
+static void test_host_load_pgc(void)
+{
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "exit control not supported\n");
+		return;
+	}
+
+	test_load_pgc(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
+		      EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
+}
+
+
+static void test_guest_load_pgc(void)
+{
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "entry control not supported\n");
+	}
+
+	test_load_pgc(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
+		      ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
+}
+
 /*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
@@ -7128,6 +7311,7 @@ static void vmx_host_state_area_test(void)
 	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
 
 	test_host_efer();
+	test_host_load_pgc();
 	test_load_host_pat();
 	test_host_segment_regs();
 	test_host_desc_tables();
@@ -8564,7 +8748,6 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
 	return VMX_TEST_VMEXIT;
 }
 
-
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -8614,6 +8797,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_host_state_area_test),
 	TEST(vmx_guest_state_area_test),
 	TEST(vmentry_movss_shadow_test),
+	TEST(test_guest_load_pgc),
 	/* APICv tests */
 	TEST(vmx_eoi_bitmap_ioapic_scan_test),
 	TEST(vmx_hlt_with_rvi_test),
-- 
2.23.0.187.g17f5b7556c-goog

