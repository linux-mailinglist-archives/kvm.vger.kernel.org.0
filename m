Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D04163740
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBRXa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:38638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbgBRX3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936641"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/13] KVM: x86: Refactor I/O emulation helpers to provide vcpu-only variant
Date:   Tue, 18 Feb 2020 15:29:41 -0800
Message-Id: <20200218232953.5724-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add variants of the I/O helpers that take a vCPU instead of an emulation
context.  This will eventually allow KVM to limit use of the emulation
context to the full emulation path.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..6554abef631f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5959,11 +5959,9 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
-static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
-				    int size, unsigned short port, void *val,
-				    unsigned int count)
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			   unsigned short port, void *val, unsigned int count)
 {
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int ret;
 
 	if (vcpu->arch.pio.count)
@@ -5983,17 +5981,30 @@ static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
 	return 0;
 }
 
-static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
-				     int size, unsigned short port,
-				     const void *val, unsigned int count)
+static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
+				    int size, unsigned short port, void *val,
+				    unsigned int count)
 {
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	return emulator_pio_in(emul_to_vcpu(ctxt), size, port, val, count);
 
+}
+
+static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
+			    unsigned short port, const void *val,
+			    unsigned int count)
+{
 	memcpy(vcpu->arch.pio_data, val, size * count);
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
 	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
 }
 
+static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
+				     int size, unsigned short port,
+				     const void *val, unsigned int count)
+{
+	return emulator_pio_out(emul_to_vcpu(ctxt), size, port, val, count);
+}
+
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	return kvm_x86_ops->get_segment_base(vcpu, seg);
@@ -6930,8 +6941,8 @@ static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port)
 {
 	unsigned long val = kvm_rax_read(vcpu);
-	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
-					    size, port, &val, 1);
+	int ret = emulator_pio_out(vcpu, size, port, &val, 1);
+
 	if (ret)
 		return ret;
 
@@ -6967,11 +6978,10 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
 	val = (vcpu->arch.pio.size < 4) ? kvm_rax_read(vcpu) : 0;
 
 	/*
-	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in_emulated perform
+	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in perform
 	 * the copy and tracing
 	 */
-	emulator_pio_in_emulated(&vcpu->arch.emulate_ctxt, vcpu->arch.pio.size,
-				 vcpu->arch.pio.port, &val, 1);
+	emulator_pio_in(vcpu, vcpu->arch.pio.size, vcpu->arch.pio.port, &val, 1);
 	kvm_rax_write(vcpu, val);
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -6986,8 +6996,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = emulator_pio_in_emulated(&vcpu->arch.emulate_ctxt, size, port,
-				       &val, 1);
+	ret = emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
-- 
2.24.1

