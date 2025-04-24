Return-Path: <kvm+bounces-44165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3690A9B098
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D16B7A5991
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B36B290082;
	Thu, 24 Apr 2025 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uiibvrls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4F28E5F0
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504057; cv=none; b=iY8ojFlflmXI3BI/tvn00gTLor/jTlNMW7CykeuyHXNNEI3Qkf4TTKigxZgpIrY0RlUVOfdaaH8x3YNeDk235G6fWvSZmL45HfCeIAephVc65jKL9pqx1Gkymifyd5FzBm90POfJRQQb85+rmonB+Lt8zQLRta+seY5l6pybAwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504057; c=relaxed/simple;
	bh=v1GZAOzGYATKFr8YmGOLT0nlJPt5FIGEotq+V+hCZbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpHHew/hLA+vP+2uWIoCCeQltsbS/Lbco9RWA6i97b0F1cRQQV2KZzJvWZAnd1kbYlpQcQ16/6kDr6Eof1ZwID5GaaJR1azGtsovoDDN8fJKyuwXFo1gen98De9iF8nr7VEmTPF44qCDsYlQ5WshCadwAP3pDSC0/JWHUvLgs8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uiibvrls; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso7780745e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504052; x=1746108852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Npq0NQtrgJlAV8FqtQiHtQ8TrFptNSWm5BxQWT8PEM0=;
        b=uiibvrlsxKeiO53O7KMvUTq6V5pxeqYhQonnUHBTJ3lNoajeqVhT/CrQeOmBs76CJJ
         3dW1Mfe9W3IL29grfp4eFoqb9IEinywSh88118AlS2XUfe5/2f4q9lwj7wicMEgBTZGA
         A7BvFOCBgQd5oFs1xsVSt5/KgqIuphAHU1cd4to0vS8BwqGMKrZccWuxQ3VkfvT+E04s
         TX5puDb0Pm/QJ57M4LcXEQBgTcYN0jIE66UJi8Buxh3YB/D9zNymkWtF1k0T+EdWBRCL
         Hq+xoMrBRScN45umw1ADddkPHOL3SlIAma7TU2fkoE54wXBK8tgWzQrnCwWMXxNgvbK4
         Ln9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504052; x=1746108852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Npq0NQtrgJlAV8FqtQiHtQ8TrFptNSWm5BxQWT8PEM0=;
        b=ahGeN+JgMDq5QhknycGW4p6XP7LqUlEjwdHplwcneLojcwDkFcWC63l9QahQb4dEzK
         PxbzCCWxAQm6KYflEhAJHwJeu45GJpcWCncuYEN540FHQIvNz6MVpNHwsQbTNo9kaJ1M
         Z5RHaaawoD/a74rtn+EFc7EsKCEMllUwD4YlQrL8sTuc+U3L7G8lqFznS/Y1dTLot+mX
         OYEzPm3rTKr10cN5B6lp/D2xqAWGldtH8syxYAnRiy1b+HbqhJ0BlGGj3npt9XXiLSF4
         AV23tgCbjlfi5MipLht5xTY9NaA1kZnMxpmFTtuTJtyoh+6id7iIdhMG+WnFr8dEZoYq
         BXuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyl7dXtzH2AraFDpNHz1fHdZAdf3Z1skWHm1SdoqgbfLIaf4cOIm1U5MPDCWm63EBO6lM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEfCbpb6MBk17aCmwWO8qU1hqYOZIFU4bDI9SX9KNqK8J+8SAF
	SU2aduehQDCRhRopbLQF0DbBp5349jD+DbGkCPscZE/Et3pRqWxdnarVAqATbfc=
X-Gm-Gg: ASbGnct7hUA2r0OLLjnXuENOcbIwE2/nqLcq8cFyur9I5o5O+1cpXWKDl2nnQJir5hR
	D5wngj/XyJWgGrFUaWZy+gBcYBK6VBBqWV3dvErFpy7ocYaiVW9HkJato3XqrnI44OWN0UQfg72
	WJUgBdIsBWdPKrWVAjWuvcwuFwbyfwquejFFnthiyF5KnaVoeNUWl7XiiyJgZnsGqxBkXENUkxO
	enfAqkQJe9WWmbd8xHdgkCkAQ9fcckglkDTiHUweb4U49/icNRbXjeFCEa+O9qfg/C4E8yr+Ci/
	NBsIf2e+QCkk1yU5Pc/oTi1bGbB0miiwEdUhre97nNHJHvLLvkqVcBEN1cMSSq9E6d6Dgoof92c
	Y2aor2mOHJgTYno9b
X-Google-Smtp-Source: AGHT+IGDNQni2+JFXMwQWuIVE9mUFnHRCikRQcusA6Pgtq8l9mbgJyFlCKPQ4I6jOpeZedp+Ki0cWw==
X-Received: by 2002:a5d:5f4f:0:b0:39c:1f10:c736 with SMTP id ffacd0b85a97d-3a06cfab8cbmr2032162f8f.43.1745504052080;
        Thu, 24 Apr 2025 07:14:12 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:11 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 20/34] gunyah: add proxy-scheduled vCPUs
Date: Thu, 24 Apr 2025 15:13:27 +0100
Message-Id: <20250424141341.841734-21-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is based heavily on the original Gunyah vCPU support from
Elliot Berman and Prakruthi Deepak Heragu:
https://lore.kernel.org/lkml/20240222-gunyah-v17-14-1e9da6763d38@quicinc.com/

The original implementation had its own character device interface. This patch
ports Gunyah vCPU management to KVM (e.g., `kvm_arch_vcpu_run()` calls Gunyah
hypervisor, running as firmware, via hypercalls, which then runs the
vCPU).

This enables Gunyah vCPUs to be driven through the standard KVM userspace
interface (e.g., via QEMU), while transparently using Gunyah’s
proxy-scheduled vCPU mechanisms under the hood.

Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
Co-developed-by: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 348 +++++++++++++++++++++++++++++++++++++++-
 include/linux/gunyah.h  |  51 ++++++
 2 files changed, 395 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 084ee1091770..e066482c2e71 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -19,6 +19,8 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "gunyah: " fmt
 
+static int gunyah_vm_start(struct gunyah_vm *ghvm);
+
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 
 enum kvm_mode kvm_get_mode(void)
@@ -458,9 +460,311 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return true;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_alloc(void)
+/*
+ * When hypervisor allows us to schedule vCPU again, it gives us an interrupt
+ */
+static irqreturn_t gunyah_vcpu_irq_handler(int irq, void *data)
+{
+	struct gunyah_vcpu *vcpu = data;
+
+	complete(&vcpu->ready);
+	return IRQ_HANDLED;
+}
+
+static int gunyah_vcpu_rm_notification(struct notifier_block *nb,
+				       unsigned long action, void *data)
 {
-	return NULL;
+	struct gunyah_vcpu *vcpu = container_of(nb, struct gunyah_vcpu, nb);
+	struct gunyah_rm_vm_exited_payload *exit_payload = data;
+
+	/* Wake up userspace waiting for the vCPU to be runnable again */
+	if (action == GUNYAH_RM_NOTIFICATION_VM_EXITED &&
+	    le16_to_cpu(exit_payload->vmid) == vcpu->ghvm->vmid)
+		complete(&vcpu->ready);
+
+	return NOTIFY_OK;
+}
+
+static int gunyah_handle_page_fault(
+	struct gunyah_vcpu *vcpu,
+	const struct gunyah_hypercall_vcpu_run_resp *vcpu_run_resp)
+{
+	return -EINVAL;
+}
+
+static bool gunyah_kvm_handle_mmio(struct gunyah_vcpu *vcpu,
+		unsigned long resume_data[3],
+		const struct gunyah_hypercall_vcpu_run_resp *vcpu_run_resp)
+{
+	struct kvm_vcpu *kvm_vcpu = &vcpu->kvm_vcpu;
+	struct kvm_run *run = kvm_vcpu->run;
+	u64 addr = vcpu_run_resp->state_data[0];
+	u64 len = vcpu_run_resp->state_data[1];
+	u64 data = vcpu_run_resp->state_data[2];
+	bool write;
+
+	if (WARN_ON(len > sizeof(u64)))
+		len = sizeof(u64);
+
+	if (vcpu_run_resp->state == GUNYAH_VCPU_ADDRSPACE_VMMIO_READ) {
+		write = false;
+		/*
+		 * Record that we need to give vCPU user's supplied
+		 * value next gunyah_vcpu_run()
+		 */
+		vcpu->state = GUNYAH_VCPU_RUN_STATE_MMIO_READ;
+	} else {
+		/* TODO: HANDLE IOEVENTFD !! */
+		write = true;
+		vcpu->state = GUNYAH_VCPU_RUN_STATE_MMIO_WRITE;
+	}
+
+	if (write)
+		memcpy(run->mmio.data, &data, len);
+
+	run->mmio.is_write = write;
+	run->mmio.phys_addr = addr;
+	run->mmio.len = len;
+	kvm_vcpu->mmio_needed = 1;
+
+	kvm_vcpu->stat.mmio_exit_user++;
+	run->exit_reason = KVM_EXIT_MMIO;
+
+	return false;
+}
+
+static int gunyah_handle_mmio_resume(struct gunyah_vcpu *vcpu,
+				     unsigned long resume_data[3])
+{
+	struct kvm_vcpu *kvm_vcpu = &vcpu->kvm_vcpu;
+	struct kvm_run *run = kvm_vcpu->run;
+
+	resume_data[1] = GUNYAH_ADDRSPACE_VMMIO_ACTION_EMULATE;
+	if (vcpu->state == GUNYAH_VCPU_RUN_STATE_MMIO_READ)
+		memcpy(&resume_data[0], run->mmio.data, run->mmio.len);
+	return 0;
+}
+
+/**
+ * gunyah_vcpu_check_system() - Check whether VM as a whole is running
+ * @vcpu: Pointer to gunyah_vcpu
+ *
+ * Returns true if the VM is alive.
+ * Returns false if the vCPU is the VM is not alive (can only be that VM is shutting down).
+ */
+static bool gunyah_vcpu_check_system(struct gunyah_vcpu *vcpu)
+	__must_hold(&vcpu->lock)
+{
+	bool ret = true;
+
+	down_read(&vcpu->ghvm->status_lock);
+	if (likely(vcpu->ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING))
+		goto out;
+
+	vcpu->state = GUNYAH_VCPU_RUN_STATE_SYSTEM_DOWN;
+	ret = false;
+out:
+	up_read(&vcpu->ghvm->status_lock);
+	return ret;
+}
+
+static int gunyah_vcpu_run(struct gunyah_vcpu *vcpu)
+{
+	struct gunyah_hypercall_vcpu_run_resp vcpu_run_resp;
+	struct kvm_vcpu *kvm_vcpu = &vcpu->kvm_vcpu;
+	struct kvm_run *run = kvm_vcpu->run;
+	unsigned long resume_data[3] = { 0 };
+	enum gunyah_error gunyah_error;
+	int ret = 0;
+
+	if (mutex_lock_interruptible(&vcpu->lock))
+		return -ERESTARTSYS;
+
+	if (!vcpu->rsc) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	switch (vcpu->state) {
+	case GUNYAH_VCPU_RUN_STATE_UNKNOWN:
+		if (vcpu->ghvm->vm_status != GUNYAH_RM_VM_STATUS_RUNNING) {
+			/**
+			 * Check if VM is up. If VM is starting, will block
+			 * until VM is fully up since that thread does
+			 * down_write.
+			 */
+			if (!gunyah_vcpu_check_system(vcpu))
+				goto out;
+		}
+		vcpu->state = GUNYAH_VCPU_RUN_STATE_READY;
+		break;
+	case GUNYAH_VCPU_RUN_STATE_MMIO_READ:
+	case GUNYAH_VCPU_RUN_STATE_MMIO_WRITE:
+		ret = gunyah_handle_mmio_resume(vcpu, resume_data);
+		if (ret)
+			goto out;
+		vcpu->state = GUNYAH_VCPU_RUN_STATE_READY;
+		break;
+	case GUNYAH_VCPU_RUN_STATE_SYSTEM_DOWN:
+		goto out;
+	default:
+		break;
+	}
+
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+
+	while (!ret && !signal_pending(current)) {
+		if (vcpu->immediate_exit) {
+			ret = -EINTR;
+			goto out;
+		}
+		gunyah_error = gunyah_hypercall_vcpu_run(
+				vcpu->rsc->capid, resume_data, &vcpu_run_resp);
+
+		if (gunyah_error == GUNYAH_ERROR_OK) {
+			memset(resume_data, 0, sizeof(resume_data));
+
+			switch (vcpu_run_resp.state) {
+			case GUNYAH_VCPU_STATE_READY:
+				if (need_resched())
+					schedule();
+				break;
+			case GUNYAH_VCPU_STATE_POWERED_OFF:
+				/**
+				 * vcpu might be off because the VM is shut down
+				 * If so, it won't ever run again
+				 */
+				if (!gunyah_vcpu_check_system(vcpu))
+					goto out;
+				/**
+				 * Otherwise, another vcpu will turn it on (e.g.
+				 * by PSCI) and hyp sends an interrupt to wake
+				 * Linux up.
+				 */
+				fallthrough;
+			case GUNYAH_VCPU_STATE_EXPECTS_WAKEUP:
+				ret = wait_for_completion_interruptible(
+					&vcpu->ready);
+				/**
+				 * reinitialize completion before next
+				 * hypercall. If we reinitialize after the
+				 * hypercall, interrupt may have already come
+				 * before re-initializing the completion and
+				 * then end up waiting for event that already
+				 * happened.
+				 */
+				reinit_completion(&vcpu->ready);
+				/**
+				 * Check VM status again. Completion
+				 * might've come from VM exiting
+				 */
+				if (!ret && !gunyah_vcpu_check_system(vcpu))
+					goto out;
+				break;
+			case GUNYAH_VCPU_STATE_BLOCKED:
+				schedule();
+				break;
+			case GUNYAH_VCPU_ADDRSPACE_VMMIO_READ:
+			case GUNYAH_VCPU_ADDRSPACE_VMMIO_WRITE:
+				if (!gunyah_kvm_handle_mmio(vcpu, resume_data,
+							&vcpu_run_resp))
+					goto out;
+				break;
+			case GUNYAH_VCPU_ADDRSPACE_PAGE_FAULT:
+				ret = gunyah_handle_page_fault(vcpu, &vcpu_run_resp);
+				if (ret)
+					goto out;
+				break;
+			default:
+				pr_warn(
+					"Unknown vCPU state: %llx\n",
+					vcpu_run_resp.sized_state);
+				schedule();
+				break;
+			}
+		} else if (gunyah_error == GUNYAH_ERROR_RETRY) {
+			schedule();
+		} else {
+			ret = gunyah_error_remap(gunyah_error);
+		}
+	}
+
+out:
+	mutex_unlock(&vcpu->lock);
+
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
+	return ret;
+}
+
+static bool gunyah_vcpu_populate(struct gunyah_vm_resource_ticket *ticket,
+				 struct gunyah_resource *ghrsc)
+{
+	struct gunyah_vcpu *vcpu =
+		container_of(ticket, struct gunyah_vcpu, ticket);
+	int ret;
+
+	mutex_lock(&vcpu->lock);
+	if (vcpu->rsc) {
+		pr_warn("vcpu%d already got a Gunyah resource", vcpu->ticket.label);
+		ret = -EEXIST;
+		goto out;
+	}
+	vcpu->rsc = ghrsc;
+
+	ret = request_irq(vcpu->rsc->irq, gunyah_vcpu_irq_handler,
+			  IRQF_TRIGGER_RISING, "gunyah_vcpu", vcpu);
+	if (ret) {
+		pr_warn("Failed to request vcpu irq %d: %d", vcpu->rsc->irq,
+			ret);
+		goto out;
+	}
+
+	enable_irq_wake(vcpu->rsc->irq);
+out:
+	mutex_unlock(&vcpu->lock);
+	return !ret;
+}
+
+static void gunyah_vcpu_unpopulate(struct gunyah_vm_resource_ticket *ticket,
+				   struct gunyah_resource *ghrsc)
+{
+	struct gunyah_vcpu *vcpu =
+		container_of(ticket, struct gunyah_vcpu, ticket);
+
+	vcpu->immediate_exit = true;
+	complete_all(&vcpu->ready);
+	mutex_lock(&vcpu->lock);
+	free_irq(vcpu->rsc->irq, vcpu);
+	vcpu->rsc = NULL;
+	mutex_unlock(&vcpu->lock);
+}
+
+static int gunyah_vcpu_create(struct gunyah_vm *ghvm, struct gunyah_vcpu *vcpu, int id)
+{
+	int r;
+
+	mutex_init(&vcpu->lock);
+	init_completion(&vcpu->ready);
+
+	vcpu->ghvm = ghvm;
+	vcpu->nb.notifier_call = gunyah_vcpu_rm_notification;
+	/**
+	 * Ensure we run after the vm_mgr handles the notification and does
+	 * any necessary state changes.
+	 */
+	vcpu->nb.priority = -1;
+	r = gunyah_rm_notifier_register(ghvm->rm, &vcpu->nb);
+	if (r)
+		return r;
+
+	vcpu->ticket.resource_type = GUNYAH_RESOURCE_TYPE_VCPU;
+	vcpu->ticket.label = id;
+	vcpu->ticket.populate = gunyah_vcpu_populate;
+	vcpu->ticket.unpopulate = gunyah_vcpu_unpopulate;
+
+	return gunyah_vm_add_resource_ticket(ghvm, &vcpu->ticket);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -470,7 +774,8 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	return -EINVAL;
+	GUNYAH_STATE(vcpu);
+	return gunyah_vcpu_create(ghvm, ghvcpu, vcpu->vcpu_id);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -479,6 +784,28 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	GUNYAH_STATE(vcpu);
+
+	gunyah_rm_notifier_unregister(ghvcpu->ghvm->rm, &ghvcpu->nb);
+	gunyah_vm_remove_resource_ticket(ghvcpu->ghvm, &ghvcpu->ticket);
+	kfree(ghvcpu);
+}
+
+struct kvm_vcpu *kvm_arch_vcpu_alloc(void)
+{
+	struct gunyah_vcpu *vcpu;
+
+	vcpu = kzalloc(sizeof(*vcpu), GFP_KERNEL_ACCOUNT);
+	if (!vcpu)
+		return NULL;
+	return &vcpu->kvm_vcpu;
+}
+
+void kvm_arch_vcpu_free(struct kvm_vcpu *kvm_vcpu)
+{
+	struct gunyah_vcpu *vcpu = gunyah_vcpu(kvm_vcpu);
+
+	kfree(vcpu);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -521,7 +848,20 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
-	return -EINVAL;
+	GUNYAH_STATE(vcpu);
+	int ret;
+
+	if (!xchg(&ghvm->started, 1)) {
+		ret = gunyah_vm_start(ghvm);
+		if (ret) {
+			xchg(&ghvm->started, 0);
+			goto out;
+		}
+	}
+	ret = gunyah_vcpu_run(ghvcpu);
+out:
+	return ret;
+
 }
 
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index f86f14018734..fa6e3fd4bee1 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -16,9 +16,16 @@
 
 #include <linux/gunyah_rsc_mgr.h>
 
+#define gunyah_vcpu(kvm_vcpu_ptr) \
+	container_of(kvm_vcpu_ptr, struct gunyah_vcpu, kvm_vcpu)
+
 #define kvm_to_gunyah(kvm_ptr) \
 	container_of(kvm_ptr, struct gunyah_vm, kvm)
 
+#define GUNYAH_STATE(kvm_vcpu)							\
+	struct gunyah_vm __maybe_unused *ghvm = kvm_to_gunyah(kvm_vcpu->kvm);	\
+	struct gunyah_vcpu __maybe_unused *ghvcpu = gunyah_vcpu(kvm_vcpu)
+
 struct gunyah_vm;
 
 /* Matches resource manager's resource types for VM_GET_HYP_RESOURCES RPC */
@@ -89,6 +96,7 @@ struct gunyah_vm_resource_ticket {
  */
 struct gunyah_vm {
 	u16 vmid;
+	bool started;
 	struct kvm kvm;
 	struct gunyah_rm *rm;
 	struct notifier_block nb;
@@ -101,6 +109,49 @@ struct gunyah_vm {
 	enum gunyah_rm_vm_auth_mechanism auth;
 };
 
+/**
+ * struct gunyah_vcpu - Track an instance of gunyah vCPU
+ * @kvm_vcpu: kvm instance
+ * @rsc: Pointer to the Gunyah vCPU resource, will be NULL until VM starts
+ * @lock: One userspace thread at a time should run the vCPU
+ * @ghvm: Pointer to the main VM struct; quicker look up than going through
+ *        @f->ghvm
+ * @state: Our copy of the state of the vCPU, since userspace could trick
+ *         kernel to behave incorrectly if we relied on @vcpu_run
+ * @ready: if vCPU goes to sleep, hypervisor reports to us that it's sleeping
+ *         and will signal interrupt (from @rsc) when it's time to wake up.
+ *         This completion signals that we can run vCPU again.
+ * @nb: When VM exits, the status of VM is reported via @vcpu_run->status.
+ *      We need to track overall VM status, and the nb gives us the updates from
+ *      Resource Manager.
+ * @ticket: resource ticket to claim vCPU# for the VM
+ */
+struct gunyah_vcpu {
+	struct kvm_vcpu kvm_vcpu;
+	struct gunyah_resource *rsc;
+	struct mutex lock;
+	struct gunyah_vm *ghvm;
+
+	/**
+	 * Track why the vcpu_run hypercall returned. This mirrors the vcpu_run
+	 * structure shared with userspace, except is used internally to avoid
+	 * trusting userspace to not modify the vcpu_run structure.
+	 */
+	enum {
+		GUNYAH_VCPU_RUN_STATE_UNKNOWN = 0,
+		GUNYAH_VCPU_RUN_STATE_READY,
+		GUNYAH_VCPU_RUN_STATE_MMIO_READ,
+		GUNYAH_VCPU_RUN_STATE_MMIO_WRITE,
+		GUNYAH_VCPU_RUN_STATE_SYSTEM_DOWN,
+	} state;
+
+	bool immediate_exit;
+	struct completion ready;
+
+	struct notifier_block nb;
+	struct gunyah_vm_resource_ticket ticket;
+};
+
 /******************************************************************************/
 /* Common arch-independent definitions for Gunyah hypercalls                  */
 #define GUNYAH_CAPID_INVAL U64_MAX
-- 
2.39.5


