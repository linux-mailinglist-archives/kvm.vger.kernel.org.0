Return-Path: <kvm+bounces-13467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F089D8971E1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB401C27702
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D7714A098;
	Wed,  3 Apr 2024 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="WMp4O7B5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8DF1487F1
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152902; cv=none; b=IxZaCjA6EqZy34w666fAv7YkDyLCv4RESKopXgYdXFqy0oX6a/KmDnlwiUDgyGxssKHtQbZY79akwcLptlpPlWjOJWpHUnZKF5Cj+3o7NuIXTGzqoa4JeFXpevaAD55tKk+aOvKfcCHO7oPn/k7OreLbSEdQLhgGrHr5s1yvUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152902; c=relaxed/simple;
	bh=OKezwxiOEiM9+urpB8402BC4SYCwdxDMf8Df/ISZUg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dv1z8AuLnwwjrFW/+Xf454fALGYNvRKpqqBglMj+5RE1CBATboPuL2UsivmnpshSNbzq1ilQXG7Ief67BXH6tTukZvIt1XU/bjjti8xUaEQ2moHTlndW4tfJxg2jUIckdSuHXPqs1l1gG7On2mp3M69ZNuvtfSR7xjE/GaY3Wsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=WMp4O7B5; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e675181ceaso4143302a34.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152898; x=1712757698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VOPM+Isn3puOfkfBMYmv3GVLrqplGzQJegeaxwHn/Q=;
        b=WMp4O7B5HDNF80hOnwY5oOBZPer+2V1WRXTDTQT+cwY/5Cp1SOsxpk21d9uLih02gC
         i3HfmYuFYntSuHtC6fOXuoghrDCsR/ezPt2osU/0qs0+CrLfVRKFBQaFcC2ubd3Cv0j0
         OTAk+xd8LkK+LnurhzJ9SHITRLBcizvh+kpaaEEDYFSP5+KmFWikp7rBE+xXCFFJHzq5
         YNL1dfIr5zpiO3vMAjMka2haB7oOhSztdMHPW51sLHhEcXe2yPb1gOEV494VBQ7k5oTM
         BeR+WgPLfBFEdcsw0oKznFwshw8vIPxXpG3etMx1YOvEU4wB84e9Q+VpV9aFtgiuwXSS
         /iSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152898; x=1712757698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VOPM+Isn3puOfkfBMYmv3GVLrqplGzQJegeaxwHn/Q=;
        b=aw5KiYqpe1TYpUirGlJNOxcS/u154qmBijnwNOdjkBA4SqfTL1GDuJNsFL0PiCfo4d
         XQfvSE0SJuWMZwYEtN7puUM0A7AyueJFN0i6tuIfALG5eWWvqICO2HkgtPlPgXEB7niU
         j8vuPyV6U1K7B8PGht2HhY0CIM4d+x+OBOqJd/NWK/NycXL2a3Y0+PUqy8yuO0tcSq4k
         7e9fM7G6D/da2FwVG+0Nqag7ytDwMO2Gy5+DMxvMsdOwR8UTOGWzDjq8a3Dv+oBMNHx7
         8gme9SbIJKPEmmqXzlDrfvI5BdDgT44BoNzz/p36+RP3CmNBE4GE8oF1mNQEX5Md77Od
         x1cg==
X-Forwarded-Encrypted: i=1; AJvYcCXHMsC402GrisXfsRjEr4DMRN2BDDYQ/cjFBOJ8/01T6Y39rCiF4PosCNAuBB+YVu5EvdngbU1RGZBBMuK9XUmYC+vr
X-Gm-Message-State: AOJu0Yy+z+ktbXiR8uffzD8d2+bzXZvRpg3vnQhaXtiD3YPXvCWa80Gq
	JTr+z0tNiPeMIU4GfI7vGp0TaU/qoXwgt7MDALexLrZtEJJ2kF9n1M76kHGOPSY=
X-Google-Smtp-Source: AGHT+IFVHhEadwy+vYVbpR80h1N15BwjLDnooutKSgc1bq6Ce0yAUhvCgcTFJsTJXfmfWJbdINes4g==
X-Received: by 2002:a05:6830:a44:b0:6e6:d1ac:c989 with SMTP id g4-20020a0568300a4400b006e6d1acc989mr15963532otu.6.1712152898445;
        Wed, 03 Apr 2024 07:01:38 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:38 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	himadrics@inria.fr,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH v2 4/5] pvsched: bpf support for pvsched
Date: Wed,  3 Apr 2024 10:01:15 -0400
Message-Id: <20240403140116.3002809-5-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240403140116.3002809-1-vineeth@bitbyteword.org>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for implementing bpf pvsched drivers. bpf programs can use
the struct_ops to define the callbacks of pvsched drivers.

This is only a skeleton of the bpf framework for pvsched. Some
verification details are not implemented yet.

Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/bpf/bpf_struct_ops_types.h |   4 +
 virt/pvsched/Makefile             |   2 +-
 virt/pvsched/pvsched_bpf.c        | 141 ++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 virt/pvsched/pvsched_bpf.c

diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 5678a9ddf817..9d5e4d1a331a 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -9,4 +9,8 @@ BPF_STRUCT_OPS_TYPE(bpf_dummy_ops)
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
 #endif
+#ifdef CONFIG_PARAVIRT_SCHED_HOST
+#include <linux/pvsched.h>
+BPF_STRUCT_OPS_TYPE(pvsched_vcpu_ops)
+#endif
 #endif
diff --git a/virt/pvsched/Makefile b/virt/pvsched/Makefile
index 4ca38e30479b..02bc072cd806 100644
--- a/virt/pvsched/Makefile
+++ b/virt/pvsched/Makefile
@@ -1,2 +1,2 @@
 
-obj-$(CONFIG_PARAVIRT_SCHED_HOST) += pvsched.o
+obj-$(CONFIG_PARAVIRT_SCHED_HOST) += pvsched.o pvsched_bpf.o
diff --git a/virt/pvsched/pvsched_bpf.c b/virt/pvsched/pvsched_bpf.c
new file mode 100644
index 000000000000..b125089abc3b
--- /dev/null
+++ b/virt/pvsched/pvsched_bpf.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2024 Google  */
+
+#include <linux/types.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/filter.h>
+#include <linux/pvsched.h>
+
+
+/* "extern" is to avoid sparse warning.  It is only used in bpf_struct_ops.c. */
+extern struct bpf_struct_ops bpf_pvsched_vcpu_ops;
+
+static int bpf_pvsched_vcpu_init(struct btf *btf)
+{
+	return 0;
+}
+
+static bool bpf_pvsched_vcpu_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
+		return false;
+
+	if (!btf_ctx_access(off, size, type, prog, info))
+		return false;
+
+	return true;
+}
+
+static int bpf_pvsched_vcpu_btf_struct_access(struct bpf_verifier_log *log,
+					const struct bpf_reg_state *reg,
+					int off, int size)
+{
+	/*
+	 * TODO: Enable write access to Guest shared mem.
+	 */
+	return -EACCES;
+}
+
+static const struct bpf_func_proto *
+bpf_pvsched_vcpu_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static const struct bpf_verifier_ops bpf_pvsched_vcpu_verifier_ops = {
+	.get_func_proto		= bpf_pvsched_vcpu_get_func_proto,
+	.is_valid_access	= bpf_pvsched_vcpu_is_valid_access,
+	.btf_struct_access	= bpf_pvsched_vcpu_btf_struct_access,
+};
+
+static int bpf_pvsched_vcpu_init_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  void *kdata, const void *udata)
+{
+	const struct pvsched_vcpu_ops *uvm_ops;
+	struct pvsched_vcpu_ops *vm_ops;
+	u32 moff;
+
+	uvm_ops = (const struct pvsched_vcpu_ops *)udata;
+	vm_ops = (struct pvsched_vcpu_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+	switch (moff) {
+	case offsetof(struct pvsched_vcpu_ops, events):
+		vm_ops->events = *(u32 *)(udata + moff);
+		return 1;
+	case offsetof(struct pvsched_vcpu_ops, name):
+		if (bpf_obj_name_cpy(vm_ops->name, uvm_ops->name,
+					sizeof(vm_ops->name)) <= 0)
+			return -EINVAL;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int bpf_pvsched_vcpu_check_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_pvsched_vcpu_reg(void *kdata)
+{
+	return pvsched_register_vcpu_ops((struct pvsched_vcpu_ops *)kdata);
+}
+
+static void bpf_pvsched_vcpu_unreg(void *kdata)
+{
+	pvsched_unregister_vcpu_ops((struct pvsched_vcpu_ops *)kdata);
+}
+
+static int bpf_pvsched_vcpu_validate(void *kdata)
+{
+	return pvsched_validate_vcpu_ops((struct pvsched_vcpu_ops *)kdata);
+}
+
+static int bpf_pvsched_vcpu_update(void *kdata, void *old_kdata)
+{
+	return -EOPNOTSUPP;
+}
+
+static int __pvsched_vcpu_register(struct pid *pid)
+{
+	return 0;
+}
+static void __pvsched_vcpu_unregister(struct pid *pid)
+{
+}
+static void __pvsched_notify_event(void *addr, struct pid *pid, u32 event)
+{
+}
+
+static struct pvsched_vcpu_ops __bpf_ops_pvsched_vcpu_ops = {
+	.pvsched_vcpu_register = __pvsched_vcpu_register,
+	.pvsched_vcpu_unregister = __pvsched_vcpu_unregister,
+	.pvsched_vcpu_notify_event = __pvsched_notify_event,
+};
+
+struct bpf_struct_ops bpf_pvsched_vcpu_ops = {
+	.init = &bpf_pvsched_vcpu_init,
+	.validate = bpf_pvsched_vcpu_validate,
+	.update = bpf_pvsched_vcpu_update,
+	.verifier_ops = &bpf_pvsched_vcpu_verifier_ops,
+	.reg = bpf_pvsched_vcpu_reg,
+	.unreg = bpf_pvsched_vcpu_unreg,
+	.check_member = bpf_pvsched_vcpu_check_member,
+	.init_member = bpf_pvsched_vcpu_init_member,
+	.name = "pvsched_vcpu_ops",
+	.cfi_stubs = &__bpf_ops_pvsched_vcpu_ops,
+};
-- 
2.40.1


