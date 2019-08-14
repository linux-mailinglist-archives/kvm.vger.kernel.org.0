Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAEC8D7F4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfHNQWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 12:22:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43181 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728265AbfHNQWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 12:22:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so5721356wrn.10;
        Wed, 14 Aug 2019 09:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4b8CPfu268RbprWIAAnR9GOAkcKFH0eYu1KeRaQ2giI=;
        b=dWTk3SUIh/kNncCDReLtOQwHXQpQ0xfR1S76OsgRRNd/jeWkhr3yCFHns4FFw9Rd7j
         /+slB4R/F1jCtyAHpRJctNoXx4P0Y8hQfyTP/H5E/pWCfggJ/PKbk5/zm2ueZQIsiufC
         XqZASQAV6s/tDldopfn57UAzrYPYmvnZqihTfPcPB5PTGd3M21ghg3fd0ziHOwnWCf8e
         kAiTXDCrt0xRGyEM3MRIS7+ipcDAuXw0tMFGyT1UGd+HYBS9jihPhHpnqwKdR+wAOmpV
         ZMa8wDerJcU2eHOilVYnmadtLIFpRlRoJ3S+jfPSzwTGTuQ16epZE8nS9nAPCrVAHXGt
         QdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=4b8CPfu268RbprWIAAnR9GOAkcKFH0eYu1KeRaQ2giI=;
        b=eBEqJZtycq+g+EyrPa342OfAg7UG8RLo0PQ2G1c6Q8doO/zgja9kjbByw/HFPWbV4W
         YOqScFve2d3JozbNf2zzvZjPovXGMXHxoXt7rLmckQevOFaNXCeGy04zdPgJ94cKnwxG
         1kgUB87Vhk/VKYKr0O43szUdrh+NZiGUJR5/vu5rgU5tu6Io8+P8dAXYPMENWd1d1qRz
         m6QAKolS7CS0ngCIZh1qOsgxmtHL+TBXxsatlOM0Z9PqRCzBxfGsWkLHg7OdU1MavQaM
         aKArQwRxLbz1ORCmqIHkWzbeWKTBRQ9U3ECCKT118xY2PH6PcKXp9CDtUx7jeSlc6aq4
         hZng==
X-Gm-Message-State: APjAAAVuJdgjpTyND94CkDP9TMPVrB3Rsbwh/tJ4Kfcilw83rtmtfrW6
        zN7twP07QzND4nfiupcusPo5/OGo
X-Google-Smtp-Source: APXvYqwtFHsgIM0uzf0KOtLFWQuzo9lLmz0HOpJ6Ty6hJRjWM6hfiLWyJyAC/2FESOH4PdVwFh9NUw==
X-Received: by 2002:adf:ef07:: with SMTP id e7mr600507wro.242.1565799759725;
        Wed, 14 Aug 2019 09:22:39 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k124sm191620wmk.47.2019.08.14.09.22.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:22:39 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH 3/3] selftests: kvm: fix vmx_set_nested_state_test
Date:   Wed, 14 Aug 2019 18:22:33 +0200
Message-Id: <1565799753-3006-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
References: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_set_nested_state_test is trying to use the KVM_STATE_NESTED_EVMCS without
enabling enlightened VMCS first.  Correct the outcome of the test, and actually
test that it succeeds after the capability is enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c    | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index a99fc66dafeb..853e370e8a39 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -25,6 +25,8 @@
 #define VMCS12_REVISION 0x11e57ed0
 #define VCPU_ID 5
 
+bool have_evmcs;
+
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
 	vcpu_nested_state_set(vm, VCPU_ID, state, false);
@@ -75,8 +77,9 @@ void set_default_vmx_state(struct kvm_nested_state *state, int size)
 {
 	memset(state, 0, size);
 	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
-			KVM_STATE_NESTED_RUN_PENDING |
-			KVM_STATE_NESTED_EVMCS;
+			KVM_STATE_NESTED_RUN_PENDING;
+	if (have_evmcs)
+		state->flags |= KVM_STATE_NESTED_EVMCS;
 	state->format = 0;
 	state->size = size;
 	state->hdr.vmx.vmxon_pa = 0x1000;
@@ -126,13 +129,19 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
 	 * setting the nested state but flags other than eVMCS must be clear.
+	 * The eVMCS flag can be set if the enlightened VMCS capability has
+	 * been enabled.
 	 */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->hdr.vmx.vmcs12_pa = -1ull;
 	test_nested_state_expect_einval(vm, state);
 
-	state->flags = KVM_STATE_NESTED_EVMCS;
+	state->flags &= KVM_STATE_NESTED_EVMCS;
+	if (have_evmcs) {
+		test_nested_state_expect_einval(vm, state);
+		vcpu_enable_evmcs(vm, VCPU_ID);
+	}
 	test_nested_state(vm, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
@@ -217,6 +226,8 @@ int main(int argc, char *argv[])
 	struct kvm_nested_state state;
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
+	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
+
 	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		printf("KVM_CAP_NESTED_STATE not available, skipping test\n");
 		exit(KSFT_SKIP);
-- 
1.8.3.1

