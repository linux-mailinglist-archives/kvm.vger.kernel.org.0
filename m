Return-Path: <kvm+bounces-651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE60E7E1E99
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00011C20B2C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B04199CE;
	Mon,  6 Nov 2023 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PKghrx40"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E887182AC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:25 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72374CC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bUIwWhSmxxhL6AS/9ZXbE9mq6OB7mrxWvKvI7fmMtUk=; b=PKghrx40QFAYvqzmoIilm9wA2v
	pxZ4oYhwBBymCgCvc2Usep0OkshnQ9Rwj2ML4rAPFff0nwvxNOOgCpLIhKFfZopoZz6V8n3pnLQ5d
	CMv725X/ZTTpYldzx15AzhXXWx2ND9Dt4ek5Uy9Vt1nPHDw6LewWuAuFU+bLiEYuYfK8bfOxlxsN2
	SFAeRgy0QbzGk+nFD7rctc7gjWEhxy/Z7fYhfXO/rBWJ/ZlNLlGf4sCrEboyJupti1CBCOlqROAdf
	M3mlUGHG2Yl8MCbvml+3PT7xKfd/AMvTSKDHLPPs2e8R537YDpdqMY5HwnN8efhApCB97O/WgTONw
	tmskLnaA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qzx1R-00ARzu-0T;
	Mon, 06 Nov 2023 10:39:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1P-000qG1-2r;
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
Subject: [PULL 2/7] i386/xen: fix per-vCPU upcall vector for Xen emulation
Date: Mon,  6 Nov 2023 10:39:50 +0000
Message-ID: <20231106103955.200867-3-dwmw2@infradead.org>
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

The per-vCPU upcall vector support had three problems. Firstly it was
using the wrong hypercall argument and would always return -EFAULT when
the guest tried to set it up. Secondly it was using the wrong ioctl() to
pass the vector to the kernel and thus the *kernel* would always return
-EINVAL. Finally, even when delivering the event directly from userspace
with an MSI, it put the destination CPU ID into the wrong bits of the
MSI address.

Linux doesn't (yet) use this mode so it went without decent testing
for a while.

Cc: qemu-stable@nongnu.org
Fixes: 105b47fdf2d0 ("i386/xen: implement HVMOP_set_evtchn_upcall_vector")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 target/i386/kvm/xen-emu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 0055441b2e..7c504d9fa4 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -306,7 +306,7 @@ static int kvm_xen_set_vcpu_callback_vector(CPUState *cs)
 
     trace_kvm_xen_set_vcpu_callback(cs->cpu_index, vector);
 
-    return kvm_vcpu_ioctl(cs, KVM_XEN_HVM_SET_ATTR, &xva);
+    return kvm_vcpu_ioctl(cs, KVM_XEN_VCPU_SET_ATTR, &xva);
 }
 
 static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
@@ -440,7 +440,8 @@ void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
          * deliver it as an MSI.
          */
         MSIMessage msg = {
-            .address = APIC_DEFAULT_ADDRESS | X86_CPU(cs)->apic_id,
+            .address = APIC_DEFAULT_ADDRESS |
+                       (X86_CPU(cs)->apic_id << MSI_ADDR_DEST_ID_SHIFT),
             .data = vector | (1UL << MSI_DATA_LEVEL_SHIFT),
         };
         kvm_irqchip_send_msi(kvm_state, msg);
@@ -849,8 +850,7 @@ static bool kvm_xen_hcall_hvm_op(struct kvm_xen_exit *exit, X86CPU *cpu,
     int ret = -ENOSYS;
     switch (cmd) {
     case HVMOP_set_evtchn_upcall_vector:
-        ret = kvm_xen_hcall_evtchn_upcall_vector(exit, cpu,
-                                                 exit->u.hcall.params[0]);
+        ret = kvm_xen_hcall_evtchn_upcall_vector(exit, cpu, arg);
         break;
 
     case HVMOP_pagetable_dying:
-- 
2.41.0


