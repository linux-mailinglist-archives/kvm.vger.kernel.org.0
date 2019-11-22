Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97CA107AC2
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfKVWlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:41:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:61220 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfKVWkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029632"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] KVM: x86: Refactor I/O emulation helpers to provide vcpu-only variant
Date:   Fri, 22 Nov 2019 14:39:47 -0800
Message-Id: <20191122223959.13545-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add new helpers for I/O helpers to provide a variant that takes a vCPU
instead of the emulation context.  This will eventually allow KVM to
constrain use of the emulation context to the full emulation path.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a256e09f321a..2b4af6be255c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5887,11 +5887,9 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
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
@@ -5911,17 +5909,30 @@ static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
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
@@ -6842,8 +6853,8 @@ static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port)
 {
 	unsigned long val = kvm_rax_read(vcpu);
-	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
-					    size, port, &val, 1);
+	int ret = emulator_pio_out(vcpu, size, port, &val, 1);
+
 	if (ret)
 		return ret;
 
@@ -6879,11 +6890,10 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
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
@@ -6898,8 +6908,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = emulator_pio_in_emulated(&vcpu->arch.emulate_ctxt, size, port,
-				       &val, 1);
+	ret = emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
-- 
2.24.0

