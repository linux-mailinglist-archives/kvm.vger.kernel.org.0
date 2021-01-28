Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2AD307E73
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhA1Srm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhA1Spe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:45:34 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A58C061756
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:44:52 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b2so9007790lfq.0
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XdnpkSHfGb6mFvfnchwjTHIUgI5G73VkKBRO+kD1NYU=;
        b=t83zFc/cQ4US3B7sl6V77Ae0jilyBuqaUBPtk5sx/71e503HU6U+y0kNq9KpvKKK5P
         vOIXVsuLxSZjoICWXCNCALPRSW1lYw3L02+r2Xd4MC7nl2u+mrmRdX1eyJp/qt0pFKwf
         fRE++57itKMhDKMvJDZm9gKZ4w4ZbjGHR4OyRfj34j5japOlq77oibRx0pHzllVq6eV0
         5uz7HuCiXe2mL9nVqIefWlGuispf7Zv0+wzp7+m9xxXZ7RrJl8jR9zO9KRruVc1xh5a4
         G67GWxeL6aOzJsMY8P8yFt9jWEugOoDCeZcWr6BTasRAMlvfcwpCKkmDXLzKLvEoKZjE
         b3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdnpkSHfGb6mFvfnchwjTHIUgI5G73VkKBRO+kD1NYU=;
        b=AI9BVQmcaszhpvyQxjse43qggZCJ5LSDVaUs82F4i2SvM6mGB+bxT3RB5NzqlfDUx3
         +V690KjPQQ8Q3NYaoQasa+XSasq0v2cExjf8QKmFvCA5SXc05XjKlFM9jSCuxBXhZncp
         15icDX1KWo7o5PG3AyI5NJ4XXJnyRCGsYj12Oby7qEhOAhhp43A5lWhBoJnzDRumRmSb
         dNnlOCFkW56eDLwKYbpZ7T3HfWoAyED6ZjlY1AtBmCf+oS0YbNkDhxCJvfr07YIDLdVO
         BAKl/Up+mbM4iMHV2UJJ8Jb5yDpkymumBgvFYtDNW69xc0VrWqbcsBkVdz+upqJnROpk
         oKKA==
X-Gm-Message-State: AOAM533Ul4fYyjC2muZsiymClHs3p1adiRTIp76zKGs+cjJ7g+/aQ8lx
        TC/0kU0wCS9yLQuNtfHIvnxL0rpwbTw/4bd5
X-Google-Smtp-Source: ABdhPJyl5F6f4G4d7n9knjiX/VYmdAwLQjvW24Oy9/oJ8aR1ZgQwzd+3bEGX5bOXrn51nEjTQgtxPw==
X-Received: by 2002:ac2:5462:: with SMTP id e2mr194719lfn.655.1611859490045;
        Thu, 28 Jan 2021 10:44:50 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id k8sm1750508lfg.41.2021.01.28.10.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:44:49 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v2 2/4] KVM: x86: add support for ioregionfd signal handling
Date:   Thu, 28 Jan 2021 21:32:21 +0300
Message-Id: <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vCPU thread may receive a signal during ioregionfd communication,
ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
must resume ioregionfd.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
Changes in v2:
  - add support for x86 signal handling
  - changes after code review

 arch/x86/kvm/x86.c            | 196 +++++++++++++++++++++++++++++++---
 include/linux/kvm_host.h      |  13 +++
 include/uapi/linux/ioregion.h |  32 ++++++
 virt/kvm/ioregion.c           | 177 +++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c           |  16 ++-
 5 files changed, 415 insertions(+), 19 deletions(-)
 create mode 100644 include/uapi/linux/ioregion.h

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddb28f5ca252..a04516b531da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5799,19 +5799,33 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
 {
 	int handled = 0;
 	int n;
+	int ret = 0;
+	bool is_apic;
 
 	do {
 		n = min(len, 8);
-		if (!(lapic_in_kernel(vcpu) &&
-		      !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, addr, n, v))
-		    && kvm_io_bus_write(vcpu, KVM_MMIO_BUS, addr, n, v))
-			break;
+		is_apic = lapic_in_kernel(vcpu) &&
+			  !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev,
+					      addr, n, v);
+		if (!is_apic) {
+			ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
+					       addr, n, v);
+			if (ret)
+				break;
+		}
 		handled += n;
 		addr += n;
 		len -= n;
 		v += n;
 	} while (len);
 
+#ifdef CONFIG_KVM_IOREGION
+	if (ret == -EINTR) {
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+	}
+#endif
+
 	return handled;
 }
 
@@ -5819,14 +5833,20 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 {
 	int handled = 0;
 	int n;
+	int ret = 0;
+	bool is_apic;
 
 	do {
 		n = min(len, 8);
-		if (!(lapic_in_kernel(vcpu) &&
-		      !kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev,
-					 addr, n, v))
-		    && kvm_io_bus_read(vcpu, KVM_MMIO_BUS, addr, n, v))
-			break;
+		is_apic = lapic_in_kernel(vcpu) &&
+			  !kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev,
+					     addr, n, v);
+		if (!is_apic) {
+			ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS,
+					      addr, n, v);
+			if (ret)
+				break;
+		}
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, n, addr, v);
 		handled += n;
 		addr += n;
@@ -5834,6 +5854,13 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 		v += n;
 	} while (len);
 
+#ifdef CONFIG_KVM_IOREGION
+	if (ret == -EINTR) {
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+	}
+#endif
+
 	return handled;
 }
 
@@ -6294,6 +6321,12 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;
 
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR)
+		return (vcpu->ioregion_ctx.in) ? X86EMUL_IO_NEEDED : X86EMUL_CONTINUE;
+#endif
+
 	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
@@ -6411,16 +6444,23 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 
 	for (i = 0; i < vcpu->arch.pio.count; i++) {
 		if (vcpu->arch.pio.in)
-			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
+			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS,
+					    vcpu->arch.pio.port,
 					    vcpu->arch.pio.size, pd);
 		else
 			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
-					     vcpu->arch.pio.port, vcpu->arch.pio.size,
-					     pd);
+					     vcpu->arch.pio.port,
+					     vcpu->arch.pio.size, pd);
 		if (r)
 			break;
 		pd += vcpu->arch.pio.size;
 	}
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_interrupted && r == -EINTR) {
+		vcpu->ioregion_ctx.pio = i;
+	}
+#endif
+
 	return r;
 }
 
@@ -6428,16 +6468,27 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 			       unsigned short port, void *val,
 			       unsigned int count, bool in)
 {
+	int ret = 0;
+
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count  = count;
 	vcpu->arch.pio.size = size;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
+	ret = kernel_pio(vcpu, vcpu->arch.pio_data);
+	if (!ret) {
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
 
+#ifdef CONFIG_KVM_IOREGION
+	if (ret == -EINTR) {
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+		return 0;
+	}
+#endif
+
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
@@ -7141,6 +7192,10 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_KVM_IOREGION
+static int complete_ioregion_io(struct kvm_vcpu *vcpu);
+static int complete_ioregion_fast_pio(struct kvm_vcpu *vcpu);
+#endif
 
 static void kvm_smm_changed(struct kvm_vcpu *vcpu)
 {
@@ -7405,6 +7460,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		r = 1;
 		if (inject_emulated_exception(vcpu))
 			return r;
+#ifdef CONFIG_KVM_IOREGION
+	} else if (vcpu->ioregion_interrupted &&
+		   vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		if (vcpu->ioregion_ctx.in)
+			writeback = false;
+		vcpu->arch.complete_userspace_io = complete_ioregion_io;
+		r = 0;
+#endif
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
@@ -7501,6 +7564,11 @@ static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
 		vcpu->arch.complete_userspace_io =
 			complete_fast_pio_out_port_0x7e;
 		kvm_skip_emulated_instruction(vcpu);
+#ifdef CONFIG_KVM_IOREGION
+	} else if (vcpu->ioregion_interrupted &&
+		   vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		vcpu->arch.complete_userspace_io = complete_ioregion_fast_pio;
+#endif
 	} else {
 		vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
 		vcpu->arch.complete_userspace_io = complete_fast_pio_out;
@@ -7548,6 +7616,13 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 		return ret;
 	}
 
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		vcpu->arch.complete_userspace_io = complete_ioregion_fast_pio;
+		return 0;
+	}
+#endif
 	vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
 	vcpu->arch.complete_userspace_io = complete_fast_pio_in;
 
@@ -9204,6 +9279,101 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_IOREGION
+static void complete_ioregion_access(struct kvm_vcpu *vcpu, gpa_t addr,
+				     int len, void *val)
+{
+	if (vcpu->ioregion_ctx.in)
+		vcpu->ioregion_ctx.dev->ops->read(vcpu, vcpu->ioregion_ctx.dev,
+						  addr, len, val);
+	else
+		vcpu->ioregion_ctx.dev->ops->write(vcpu, vcpu->ioregion_ctx.dev,
+						   addr, len, val);
+}
+
+static int complete_ioregion_mmio(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmio_fragment *frag;
+	int idx, ret, i, n;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	for (i = vcpu->mmio_cur_fragment; i < vcpu->mmio_nr_fragments; i++) {
+		frag = &vcpu->mmio_fragments[i];
+		do {
+			n = min(8u, frag->len);
+			complete_ioregion_access(vcpu, frag->gpa, n, frag->data);
+			frag->len -= n;
+			frag->data += n;
+			frag->gpa += n;
+		} while (frag->len);
+		vcpu->mmio_cur_fragment++;
+	}
+
+	vcpu->mmio_needed = 0;
+	if (!vcpu->ioregion_ctx.in) {
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		return 1;
+	}
+
+	vcpu->mmio_read_completed = 1;
+	ret = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}
+
+static int complete_ioregion_pio(struct kvm_vcpu *vcpu)
+{
+	int i, idx, r = 1;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	for (i = vcpu->ioregion_ctx.pio; i < vcpu->arch.pio.count; i++) {
+		complete_ioregion_access(vcpu, vcpu->ioregion_ctx.addr,
+					 vcpu->ioregion_ctx.len,
+					 vcpu->ioregion_ctx.val);
+		vcpu->ioregion_ctx.val += vcpu->ioregion_ctx.len;
+	}
+
+	if (vcpu->ioregion_ctx.in)
+		r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	vcpu->arch.pio.count = 0;
+
+	return r;
+}
+
+static int complete_ioregion_fast_pio(struct kvm_vcpu *vcpu)
+{
+	int idx;
+	u64 val;
+
+	BUG_ON(!vcpu->ioregion_interrupted);
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	complete_ioregion_access(vcpu, vcpu->ioregion_ctx.addr,
+				 vcpu->ioregion_ctx.len,
+				 vcpu->ioregion_ctx.val);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (vcpu->ioregion_ctx.in) {
+		memcpy(&val, vcpu->ioregion_ctx.val, vcpu->ioregion_ctx.len);
+		kvm_rax_write(vcpu, val);
+	}
+	vcpu->arch.pio.count = 0;
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int complete_ioregion_io(struct kvm_vcpu *vcpu)
+{
+	BUG_ON(!vcpu->ioregion_interrupted);
+
+	if (vcpu->mmio_needed)
+		return complete_ioregion_mmio(vcpu);
+	if (vcpu->arch.pio.count)
+		return complete_ioregion_pio(vcpu);
+}
+#endif
+
 static void kvm_save_current_fpu(struct fpu *fpu)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7cd667dddba9..5cfdecfca6db 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -318,6 +318,19 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+#ifdef CONFIG_KVM_IOREGION
+	bool ioregion_interrupted;
+	struct {
+		struct kvm_io_device *dev;
+		int pio;
+		void *val;
+		u8 state;
+		u64 addr;
+		int len;
+		u64 data;
+		bool in;
+	} ioregion_ctx;
+#endif
 	struct kvm_vcpu_arch arch;
 };
 
diff --git a/include/uapi/linux/ioregion.h b/include/uapi/linux/ioregion.h
new file mode 100644
index 000000000000..7898c01f84a1
--- /dev/null
+++ b/include/uapi/linux/ioregion.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_IOREGION_H
+#define _UAPI_LINUX_IOREGION_H
+
+/* Wire protocol */
+struct ioregionfd_cmd {
+	__u32 info;
+	__u32 padding;
+	__u64 user_data;
+	__u64 offset;
+	__u64 data;
+};
+
+struct ioregionfd_resp {
+	__u64 data;
+	__u8 pad[24];
+};
+
+#define IOREGIONFD_CMD_READ    0
+#define IOREGIONFD_CMD_WRITE   1
+
+#define IOREGIONFD_SIZE_8BIT   0
+#define IOREGIONFD_SIZE_16BIT  1
+#define IOREGIONFD_SIZE_32BIT  2
+#define IOREGIONFD_SIZE_64BIT  3
+
+#define IOREGIONFD_SIZE_OFFSET 4
+#define IOREGIONFD_RESP_OFFSET 6
+#define IOREGIONFD_SIZE(x) ((x) << IOREGIONFD_SIZE_OFFSET)
+#define IOREGIONFD_RESP(x) ((x) << IOREGIONFD_RESP_OFFSET)
+
+#endif
diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index 48ff92bca966..da38124e1418 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <kvm/iodev.h>
 #include "eventfd.h"
+#include <uapi/linux/ioregion.h>
 
 void
 kvm_ioregionfd_init(struct kvm *kvm)
@@ -38,18 +39,190 @@ ioregion_release(struct ioregion *p)
 	kfree(p);
 }
 
+static bool
+pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, int opt, int resp,
+	 u64 user_data, const void *val)
+{
+	u64 size = 0;
+
+	switch (len) {
+	case 1:
+		size = IOREGIONFD_SIZE_8BIT;
+		break;
+	case 2:
+		size = IOREGIONFD_SIZE_16BIT;
+		break;
+	case 4:
+		size = IOREGIONFD_SIZE_32BIT;
+		break;
+	case 8:
+		size = IOREGIONFD_SIZE_64BIT;
+		break;
+	default:
+		return false;
+	}
+
+	if (val)
+		memcpy(&cmd->data, val, len);
+	cmd->user_data = user_data;
+	cmd->offset = offset;
+	cmd->info |= opt;
+	cmd->info |= IOREGIONFD_SIZE(size);
+	cmd->info |= IOREGIONFD_RESP(resp);
+
+	return true;
+}
+
+enum {
+	SEND_CMD,
+	GET_REPLY,
+	COMPLETE
+};
+
+static void
+ioregion_save_ctx(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
+		  bool in, gpa_t addr, int len, u64 data, u8 state, void *val)
+{
+	vcpu->ioregion_interrupted = true;
+
+	vcpu->ioregion_ctx.dev = this;
+	vcpu->ioregion_ctx.val = val;
+	vcpu->ioregion_ctx.state = state;
+	vcpu->ioregion_ctx.addr = addr;
+	vcpu->ioregion_ctx.len = len;
+	vcpu->ioregion_ctx.data = data;
+	vcpu->ioregion_ctx.in = in;
+}
+
 static int
 ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	      int len, void *val)
 {
-	return -EOPNOTSUPP;
+	struct ioregion *p = to_ioregion(this);
+	union {
+		struct ioregionfd_cmd cmd;
+		struct ioregionfd_resp resp;
+	} buf;
+	int ret = 0;
+	int state = 0;
+
+	if ((addr + len - 1) > (p->paddr + p->size - 1))
+		return -EINVAL;
+
+	if (unlikely(vcpu->ioregion_interrupted)) {
+		vcpu->ioregion_interrupted = false;
+
+		switch (vcpu->ioregion_ctx.state) {
+		case SEND_CMD:
+			goto send_cmd;
+		case GET_REPLY:
+			goto get_repl;
+		case COMPLETE:
+			memcpy(val, &vcpu->ioregion_ctx.data, len);
+			return 0;
+		}
+	}
+
+send_cmd:
+	memset(&buf, 0, sizeof(buf));
+	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
+		      1, p->user_data, NULL))
+		return -EOPNOTSUPP;
+
+	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
+	state = (ret == sizeof(buf.cmd));
+	if (signal_pending(current)) {
+		ioregion_save_ctx(vcpu, this, 1, addr, len, 0, state, val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.cmd)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+
+get_repl:
+	memset(&buf, 0, sizeof(buf));
+	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+	state += (ret == sizeof(buf.resp));
+	if (signal_pending(current)) {
+		ioregion_save_ctx(vcpu, this, 1, addr, len, buf.resp.data, state, val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.resp)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+
+	memcpy(val, &buf.resp.data, len);
+
+	return 0;
 }
 
 static int
 ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		int len, const void *val)
 {
-	return -EOPNOTSUPP;
+	struct ioregion *p = to_ioregion(this);
+	union {
+		struct ioregionfd_cmd cmd;
+		struct ioregionfd_resp resp;
+	} buf;
+	int ret = 0;
+	int state = 0;
+
+	if ((addr + len - 1) > (p->paddr + p->size - 1))
+		return -EINVAL;
+
+	if (unlikely(vcpu->ioregion_interrupted)) {
+		vcpu->ioregion_interrupted = false;
+
+		switch (vcpu->ioregion_ctx.state) {
+		case SEND_CMD:
+			goto send_cmd;
+		case GET_REPLY:
+			if (!p->posted_writes)
+				goto get_repl;
+			fallthrough;
+		case COMPLETE:
+			return 0;
+		}
+	}
+
+send_cmd:
+	memset(&buf, 0, sizeof(buf));
+	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
+		      p->posted_writes ? 0 : 1, p->user_data, val))
+		return -EOPNOTSUPP;
+
+	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
+	state = (ret == sizeof(buf.cmd));
+	if (signal_pending(current)) {
+		ioregion_save_ctx(vcpu, this, 0, addr, len,
+				  0, state, (void *)val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.cmd)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+
+get_repl:
+	if (!p->posted_writes) {
+		memset(&buf, 0, sizeof(buf));
+		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+		state += (ret == sizeof(buf.resp));
+		if (signal_pending(current)) {
+			ioregion_save_ctx(vcpu, this, 0, addr, len,
+					  0, state, (void *)val);
+			return -EINTR;
+		}
+		if (ret != sizeof(buf.resp)) {
+			ret = (ret < 0) ? ret : -EIO;
+			return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		}
+	}
+
+	return 0;
 }
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88b92fc3da51..df387857f51f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4193,6 +4193,7 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 			      struct kvm_io_range *range, const void *val)
 {
 	int idx;
+	int ret = 0;
 
 	idx = kvm_io_bus_get_first_dev(bus, range->addr, range->len);
 	if (idx < 0)
@@ -4200,9 +4201,12 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 
 	while (idx < bus->dev_count &&
 		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
-		if (!kvm_iodevice_write(vcpu, bus->range[idx].dev, range->addr,
-					range->len, val))
+		ret = kvm_iodevice_write(vcpu, bus->range[idx].dev, range->addr,
+					 range->len, val);
+		if (!ret)
 			return idx;
+		if (ret < 0 && ret != -EOPNOTSUPP)
+			return ret;
 		idx++;
 	}
 
@@ -4264,6 +4268,7 @@ static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 			     struct kvm_io_range *range, void *val)
 {
 	int idx;
+	int ret = 0;
 
 	idx = kvm_io_bus_get_first_dev(bus, range->addr, range->len);
 	if (idx < 0)
@@ -4271,9 +4276,12 @@ static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 
 	while (idx < bus->dev_count &&
 		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
-		if (!kvm_iodevice_read(vcpu, bus->range[idx].dev, range->addr,
-				       range->len, val))
+		ret = kvm_iodevice_read(vcpu, bus->range[idx].dev, range->addr,
+					range->len, val);
+		if (!ret)
 			return idx;
+		if (ret < 0 && ret != -EOPNOTSUPP)
+			return ret;
 		idx++;
 	}
 
-- 
2.25.1

