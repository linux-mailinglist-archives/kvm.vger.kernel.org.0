Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9681D320A30
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 13:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBUMLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 07:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhBUMLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 07:11:41 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CE1C06178A
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:01 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a17so47259704ljq.2
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v2wYisLi/6JiY10iEt1CqvqaKJZOrEN0T8rwl6ZqCm8=;
        b=pMwpmLuM0KUN/RIwTgT4qoAsaUIuuW63wP/2gFsoR2cWxt/8+D5tEzeSdQuIn/neyH
         IQVBX9U5wZaggaHsBGBxDpiSx9dK6psO1i+G41L/4Iv/mgCa4nT7ve/6dpIcqsGZB3UX
         /KvDfy5RfXe+FQwq4aL/76NwnXvGZVeNwqwNxWG6fak/kOzWKAn761mzyZdFQQ7JDH1+
         7KlOgAypH+Rz1jDyUNIE887JQz2BYEivpG6D9YqCPYFnD7McFWFEMfKsu2K7egmHlJ/R
         MQmzEntHLpxC9ww8m3vlIjTPeNgFN7b7uw4A9fF60KJON/zGnKR1Wnkcmz1RIr+v7j85
         kszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v2wYisLi/6JiY10iEt1CqvqaKJZOrEN0T8rwl6ZqCm8=;
        b=FiuVrhEv7/fwDwuItkldqXhJkXHi1HAkpuFv7bOEXiKQH9ignczH6t7ymazb80Iorg
         QP6W5iC/stszTJdnVn0bczRKMg5PRw0uFyE/DxUdukD8xZ9+PTZOYuRyn5Hin7zNBq4f
         fnAJQBhnwQa1eNaaOe1aQvEBbNCxz5wsyGA7qlghzT7hD/YnbkFr+KbdZ49FDSNzR34h
         O3i9uGJXv7w7AFIWsUg6jMFUobqPR8Q5wrflQp8w7bDZF6u8ajRoQppKGEzcUpg8hg7Z
         upMyEcrauDDB3rw/nlOI9Ex1v3u4uaWXoRLdcLT7hvUgoYP9hGE0gsQZzDuMXISq3wau
         OldQ==
X-Gm-Message-State: AOAM530yIb6/T3rnLqK5R04JD/3n4IWYxSHTQA3DXeNZRFl5pJHN+wph
        bq6xt8r7CcxSCkkvob/9gmbCHsKEcfQLP8c1
X-Google-Smtp-Source: ABdhPJzFfuD6YixhyJlMSdYC7bY0o6YW/drrkx7lxHsYGzyV2dLS9ZjJu+e20cl+zTVXZ/y2LKvMoQ==
X-Received: by 2002:ac2:4c0b:: with SMTP id t11mr9318368lfq.605.1613909458830;
        Sun, 21 Feb 2021 04:10:58 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id q6sm1547715lfn.23.2021.02.21.04.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:10:58 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v3 2/5] KVM: x86: add support for ioregionfd signal handling
Date:   Sun, 21 Feb 2021 15:04:38 +0300
Message-Id: <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
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
v3:
 - add FAST_MMIO bus support
 - move ioregion_interrupted flag to ioregion_ctx
 - reorder ioregion_ctx fields
 - rework complete_ioregion operations 
 - add signal handling support for crossing a page boundary case
 - fix kvm_arch_vcpu_ioctl_run() should return -EINTR in case ioregionfd 
   is interrupted

 arch/x86/kvm/vmx/vmx.c   |  40 +++++-
 arch/x86/kvm/x86.c       | 272 +++++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h |  10 ++
 virt/kvm/kvm_main.c      |  16 ++-
 4 files changed, 317 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..39db31afd27e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5357,19 +5357,51 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+#ifdef CONFIG_KVM_IOREGION
+static int complete_ioregion_fast_mmio(struct kvm_vcpu *vcpu)
+{
+	int ret, idx;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS,
+			       vcpu->ioregion_ctx.addr, 0, NULL);
+	if (ret) {
+		ret = kvm_mmu_page_fault(vcpu, vcpu->ioregion_ctx.addr,
+					 PFERR_RSVD_MASK, NULL, 0);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		return ret;
+	}
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+#endif
+
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
+	int ret;
 
 	/*
 	 * A nested guest cannot optimize MMIO vmexits, because we have an
 	 * nGPA here instead of the required GPA.
 	 */
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-	if (!is_guest_mode(vcpu) &&
-	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
-		trace_kvm_fast_mmio(gpa);
-		return kvm_skip_emulated_instruction(vcpu);
+	if (!is_guest_mode(vcpu)) {
+		ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL);
+		if (!ret) {
+			trace_kvm_fast_mmio(gpa);
+			return kvm_skip_emulated_instruction(vcpu);
+		}
+
+#ifdef CONFIG_KVM_IOREGION
+		if (unlikely(vcpu->ioregion_ctx.is_interrupted && ret == -EINTR)) {
+			vcpu->run->exit_reason = KVM_EXIT_INTR;
+			vcpu->arch.complete_userspace_io = complete_ioregion_fast_mmio;
+			++vcpu->stat.signal_exits;
+			return ret;
+		}
+#endif
 	}
 
 	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddb28f5ca252..07a538f02e3b 100644
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
 
@@ -6229,6 +6256,13 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
+#ifdef CONFIG_KVM_IOREGION
+	/* crossing a page boundary case is interrupted */
+	if (vcpu->ioregion_ctx.is_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR)
+		goto out;
+#endif
+
 	/*
 	 * Is this MMIO handled locally?
 	 */
@@ -6236,6 +6270,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	if (handled == bytes)
 		return X86EMUL_CONTINUE;
 
+out:
 	gpa += handled;
 	bytes -= handled;
 	val += handled;
@@ -6294,6 +6329,12 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;
 
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_ctx.is_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR)
+		return (vcpu->ioregion_ctx.in) ? X86EMUL_IO_NEEDED : X86EMUL_CONTINUE;
+#endif
+
 	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
@@ -6411,16 +6452,22 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 
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
+	if (vcpu->ioregion_ctx.is_interrupted && r == -EINTR)
+		vcpu->ioregion_ctx.pio = i;
+#endif
+
 	return r;
 }
 
@@ -6428,16 +6475,27 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
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
@@ -7141,6 +7199,10 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_KVM_IOREGION
+static int complete_ioregion_io(struct kvm_vcpu *vcpu);
+static int complete_ioregion_fast_pio(struct kvm_vcpu *vcpu);
+#endif
 
 static void kvm_smm_changed(struct kvm_vcpu *vcpu)
 {
@@ -7405,6 +7467,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		r = 1;
 		if (inject_emulated_exception(vcpu))
 			return r;
+#ifdef CONFIG_KVM_IOREGION
+	} else if (vcpu->ioregion_ctx.is_interrupted &&
+		   vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		if (vcpu->ioregion_ctx.in)
+			writeback = false;
+		vcpu->arch.complete_userspace_io = complete_ioregion_io;
+		r = 0;
+#endif
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
@@ -7501,6 +7571,12 @@ static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
 		vcpu->arch.complete_userspace_io =
 			complete_fast_pio_out_port_0x7e;
 		kvm_skip_emulated_instruction(vcpu);
+#ifdef CONFIG_KVM_IOREGION
+	} else if (vcpu->ioregion_ctx.is_interrupted &&
+		   vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
+		vcpu->arch.complete_userspace_io = complete_ioregion_fast_pio;
+#endif
 	} else {
 		vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
 		vcpu->arch.complete_userspace_io = complete_fast_pio_out;
@@ -7549,6 +7625,14 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	}
 
 	vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
+
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_ctx.is_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR) {
+		vcpu->arch.complete_userspace_io = complete_ioregion_fast_pio;
+		return 0;
+	}
+#endif
 	vcpu->arch.complete_userspace_io = complete_fast_pio_in;
 
 	return 0;
@@ -9204,6 +9288,162 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_IOREGION
+static int complete_ioregion_access(struct kvm_vcpu *vcpu, u8 bus, gpa_t addr,
+				    int len, void *val)
+{
+	if (vcpu->ioregion_ctx.in)
+		return kvm_io_bus_read(vcpu, bus, addr, len, val);
+	else
+		return kvm_io_bus_write(vcpu, bus, addr, len, val);
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
+			ret = complete_ioregion_access(vcpu, KVM_MMIO_BUS,
+						       frag->gpa, n, frag->data);
+			if (ret < 0)
+				goto do_exit;
+			frag->len -= n;
+			frag->data += n;
+			frag->gpa += n;
+		} while (frag->len);
+		vcpu->mmio_cur_fragment++;
+	}
+
+	vcpu->mmio_needed = 0;
+	if (!vcpu->ioregion_ctx.in) {
+		ret = 1;
+		goto out;
+	}
+
+	vcpu->mmio_read_completed = 1;
+	ret = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	goto out;
+
+do_exit:
+	if (ret != -EOPNOTSUPP) {
+		vcpu->arch.complete_userspace_io = complete_ioregion_mmio;
+		goto out;
+	}
+
+	/* if ioregion is removed KVM needs to return with KVM_EXIT_MMIO */
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+	vcpu->run->mmio.phys_addr = frag->gpa;
+	if (!vcpu->ioregion_ctx.in)
+		memcpy(vcpu->run->mmio.data, frag->data, n);
+	vcpu->run->mmio.len = n;
+	vcpu->run->mmio.is_write = !vcpu->ioregion_ctx.in;
+	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
+	ret = 0;
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}
+
+static int complete_ioregion_pio(struct kvm_vcpu *vcpu)
+{
+	int i, idx, ret;
+	unsigned long off;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	for (i = vcpu->ioregion_ctx.pio; i < vcpu->arch.pio.count; i++) {
+		ret = complete_ioregion_access(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
+					       vcpu->arch.pio.size,
+					       vcpu->ioregion_ctx.val);
+		if (ret < 0)
+			goto do_exit;
+		vcpu->ioregion_ctx.val += vcpu->arch.pio.size;
+	}
+
+	ret = 1;
+	if (vcpu->ioregion_ctx.in)
+		ret = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	vcpu->arch.pio.count = 0;
+	goto out;
+
+do_exit:
+	if (ret != -EOPNOTSUPP) {
+		vcpu->ioregion_ctx.pio = i;
+		vcpu->arch.complete_userspace_io = complete_ioregion_pio;
+		goto out;
+	}
+
+	/* if ioregion is removed KVM needs to return with KVM_EXIT_IO */
+	off = vcpu->ioregion_ctx.val - vcpu->arch.pio_data;
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = vcpu->ioregion_ctx.in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = vcpu->arch.pio.size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE + off;
+	vcpu->run->io.count = vcpu->arch.pio.count - i;
+	vcpu->run->io.port = vcpu->arch.pio.port;
+	if (vcpu->ioregion_ctx.in)
+		vcpu->arch.complete_userspace_io = complete_emulated_pio;
+	else
+		vcpu->arch.pio.count = 0;
+	ret = 0;
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}
+
+static int complete_ioregion_fast_pio(struct kvm_vcpu *vcpu)
+{
+	int idx, ret;
+	u64 val;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	ret = complete_ioregion_access(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
+				       vcpu->arch.pio.size, vcpu->ioregion_ctx.val);
+	if (ret < 0)
+		goto do_exit;
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (vcpu->ioregion_ctx.in) {
+		memcpy(&val, vcpu->ioregion_ctx.val, vcpu->ioregion_ctx.len);
+		kvm_rax_write(vcpu, val);
+	}
+	vcpu->arch.pio.count = 0;
+	return kvm_skip_emulated_instruction(vcpu);
+
+do_exit:
+	if (ret != -EOPNOTSUPP) {
+		vcpu->arch.complete_userspace_io = complete_ioregion_fast_pio;
+		goto out;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = vcpu->ioregion_ctx.in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = vcpu->arch.pio.size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->run->io.count = 1;
+	vcpu->run->io.port = vcpu->arch.pio.port;
+	vcpu->arch.complete_userspace_io = vcpu->ioregion_ctx.in ?
+			complete_fast_pio_in : complete_fast_pio_out;
+	ret = 0;
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}
+
+static int complete_ioregion_io(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->mmio_needed)
+		return complete_ioregion_mmio(vcpu);
+	if (vcpu->arch.pio.count)
+		return complete_ioregion_pio(vcpu);
+}
+#endif /* CONFIG_KVM_IOREGION */
+
 static void kvm_save_current_fpu(struct fpu *fpu)
 {
 	/*
@@ -9309,6 +9549,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	else
 		r = vcpu_run(vcpu);
 
+#ifdef CONFIG_KVM_IOREGION
+	if (vcpu->ioregion_ctx.is_interrupted &&
+	    vcpu->run->exit_reason == KVM_EXIT_INTR)
+		r = -EINTR;
+#endif
+
 out:
 	kvm_put_guest_fpu(vcpu);
 	if (kvm_run->kvm_valid_regs)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f35f0976f5cf..84f07597d131 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -318,6 +318,16 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+#ifdef CONFIG_KVM_IOREGION
+	struct {
+		u64 addr;
+		void *val;
+		int pio;
+		u8 state; /* SEND_CMD/GET_REPLY */
+		bool in;
+		bool is_interrupted;
+	} ioregion_ctx;
+#endif
 	struct kvm_vcpu_arch arch;
 };
 
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

