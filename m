Return-Path: <kvm+bounces-654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 648C77E1EA1
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07700B20ECF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F66C1C693;
	Mon,  6 Nov 2023 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FSFn3mS5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484491A708
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:36 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F2A4
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8y74Lolq5T0LDv+PFoxvm3kC9HGA3LQOfihqJijE5SE=; b=FSFn3mS59GJdfRIIZe12qeoM/o
	IUERkSlLtCLvpnlYwLH6az4jVaFuBqFZkAJYtUxAo0HgeY2vOdA36i6m6Xj4q+yrSvHLLL2j8Pw/W
	NKOSTnOExI8mA2isNjoZuF5apu2cXNSLP8kzai1deGgZD2IZD/Hrz3+3NwSZR3IeJob91PC3k4AWQ
	B0BKwsh538eW76PLt8gjOJLhI1itgLev1mjgpKRRzza9kuDHtICG5LUlsQ3jRZCw1cSrtTAMPmoiY
	Hv6JfsUoHvVQIlRmEQ3q/UaaKJ/SA99AcAd9/0uipDjNbLGPP+viqyvqV/EeKhZ8uTATdsoiArTSz
	7O0eEqyw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qzx1R-00ARzv-0U;
	Mon, 06 Nov 2023 10:39:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1P-000qG5-39;
	Mon, 06 Nov 2023 10:39:55 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	qemu-stable@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 3/7] hw/xen: select kernel mode for per-vCPU event channel upcall vector
Date: Mon,  6 Nov 2023 10:39:51 +0000
Message-ID: <20231106103955.200867-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106103955.200867-1-dwmw2@infradead.org>
References: <20231106103955.200867-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

A guest which has configured the per-vCPU upcall vector may set the
HVM_PARAM_CALLBACK_IRQ param to fairly much anything other than zero.

For example, Linux v6.0+ after commit b1c3497e604 ("x86/xen: Add support
for HVMOP_set_evtchn_upcall_vector") will just do this after setting the
vector:

       /* Trick toolstack to think we are enlightened. */
       if (!cpu)
               rc = xen_set_callback_via(1);

That's explicitly setting the delivery to GSI#1, but it's supposed to be
overridden by the per-vCPU vector setting. This mostly works in Qemu
*except* for the logic to enable the in-kernel handling of event channels,
which falsely determines that the kernel cannot accelerate GSI delivery
in this case.

Add a kvm_xen_has_vcpu_callback_vector() to report whether vCPU#0 has
the vector set, and use that in xen_evtchn_set_callback_param() to
enable the kernel acceleration features even when the param *appears*
to be set to target a GSI.

Preserve the Xen behaviour that when HVM_PARAM_CALLBACK_IRQ is set to
*zero* the event channel delivery is disabled completely. (Which is
what that bizarre guest behaviour is working round in the first place.)

Cc: qemu-stable@nongnu.org
Fixes: 91cce756179 ("hw/xen: Add xen_evtchn device for event channel emulation")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/kvm/xen_evtchn.c  | 6 ++++++
 include/sysemu/kvm_xen.h  | 1 +
 target/i386/kvm/xen-emu.c | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index a731738411..3d6f4b4a0a 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -490,6 +490,12 @@ int xen_evtchn_set_callback_param(uint64_t param)
         break;
     }
 
+    /* If the guest has set a per-vCPU callback vector, prefer that. */
+    if (gsi && kvm_xen_has_vcpu_callback_vector()) {
+        in_kernel = kvm_xen_has_cap(EVTCHN_SEND);
+        gsi = 0;
+    }
+
     if (!ret) {
         /* If vector delivery was turned *off* then tell the kernel */
         if ((s->callback_param >> CALLBACK_VIA_TYPE_SHIFT) ==
diff --git a/include/sysemu/kvm_xen.h b/include/sysemu/kvm_xen.h
index 595abfbe40..961c702c4e 100644
--- a/include/sysemu/kvm_xen.h
+++ b/include/sysemu/kvm_xen.h
@@ -22,6 +22,7 @@
 int kvm_xen_soft_reset(void);
 uint32_t kvm_xen_get_caps(void);
 void *kvm_xen_get_vcpu_info_hva(uint32_t vcpu_id);
+bool kvm_xen_has_vcpu_callback_vector(void);
 void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type);
 void kvm_xen_set_callback_asserted(void);
 int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port);
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 7c504d9fa4..75b2c557b9 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -424,6 +424,13 @@ void kvm_xen_set_callback_asserted(void)
     }
 }
 
+bool kvm_xen_has_vcpu_callback_vector(void)
+{
+    CPUState *cs = qemu_get_cpu(0);
+
+    return cs && !!X86_CPU(cs)->env.xen_vcpu_callback_vector;
+}
+
 void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
 {
     CPUState *cs = qemu_get_cpu(vcpu_id);
-- 
2.41.0


