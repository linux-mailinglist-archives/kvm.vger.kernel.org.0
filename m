Return-Path: <kvm+bounces-13466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1948971DF
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B958B28CD60
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25EB14900F;
	Wed,  3 Apr 2024 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="bZzaMlBF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8CF14882F
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152900; cv=none; b=GTmM/qtlAbfnkCQcR7ZfSRkAhu52zttC4By1APcQn+csboqwgd653QE9Qj7rhlTQOzA7pQtXqc+rQIDnSTMUOLUwMRHbG+9kY9gMhAPOwrO9RCYaYmjFeJdxp6Yq7R/WCBpWV0q3GnjBTCd9E8hVOidgKqKSDTSgkcuCL95I89E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152900; c=relaxed/simple;
	bh=FDYnvGX3jppgjt0ms5JcBF+Jc7zw8R2BAEn2b+ABJPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rNDyYqp0ZaR7EnSr6BBqS8lGzTeoiPiH+u9OLCAZRpbFM+A4e5L/FUIrbdwzxVykNikKl8Y+pawAzh90e+psAmNW7qilOPnyi29DJloP5dZLEa8awGcRlqhj53CTzgIGTAc0S2uanl23WS+/meKmPZalqE6RfB2TprESa1A+djg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=bZzaMlBF; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6991fb8f31dso8922216d6.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152897; x=1712757697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAl5yGyZgzeKDHOgPfwgCPdv3gtVirZpx2WY36IzrFA=;
        b=bZzaMlBFrw/elIW7JgN4qv6+Iv1CiHxkvUozSuzRHwiCmJpMQl9mIeP/VTN8Okgfp3
         o84RvGxZ6SuHf+Ll+7aOCl3Zq18WftiqazJqNT3d4K7EzRIHV7YDL2QyRXypudqCzCDY
         NTKpxJpuYPvbEJzC3InYC69ja2aacA/TssJy09anMpRkKtq9KuF4JJALfUcnjmU4nX3M
         F8VgTTbyqArV5hI8XrSfZ72sIN1QrdVsKydhOvck3DOBIeIwRgfH497GP0RMOm9m8vx6
         o6UDB4erVNpB30TZRWfJtpn7nfzRxSyGUK6AN7u12sKXa4wrvReucbWdm7UhSKOk7ahy
         xwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152897; x=1712757697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RAl5yGyZgzeKDHOgPfwgCPdv3gtVirZpx2WY36IzrFA=;
        b=mP5LxkqyFIf+i28xEVAPR3titA3o8ecnEYxga5CTo54JAOUAZ5it4//UxDgSNhJEwO
         WdhBZc03UUtkgUaJJdIetrbBuMGngKb+dIDWgF1i1qna2aTR0W3I6CJRBVsczsyuYD6C
         QtjuELpu+zIuSEmukI12QFvs7L1rjrK1Im50EP6nDeRHTc75fSYUvGeNq7j0GSjxh4d/
         ulTHoNtAXbC5aIddSbpgofmi51CfEKJlcXTpxe9SUkQCqDs3xta8inSEox/C+MaY/mZR
         gLQuzU2pB6BBjBnwdLKBFKiaxVlkOHemwCW2q2NGu5NgeTIoDwvI+ulYNgkeBY5jFq2x
         q3Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUR8baky1VPiO9azCCW5/CCoUdiMejsI+tq5gHhZOHnQYn2uPwgoerqC27B/mxpxzUkzf05DPGkHV0a5HiroKgFKilu
X-Gm-Message-State: AOJu0YzNf/478HB/Ye5OG2pSGrh4WqJJnIJHyvKi/eezfwgU5EVcUDMo
	ExuWVK9ZATdqGzdFqOu2q3TXHj9Kf3eTokvuy2k/uGNEZJUr31LCbL/Fa5ww3lM=
X-Google-Smtp-Source: AGHT+IHvc+Z8rAGYdV18GoHSVhAuEJhixIxtB7Sprh49Rl10nkC3+gtuPFpYpMsM5sh5ZkIdR/76QA==
X-Received: by 2002:a0c:ed4e:0:b0:699:1b6b:82ae with SMTP id v14-20020a0ced4e000000b006991b6b82aemr4264059qvq.17.1712152896489;
        Wed, 03 Apr 2024 07:01:36 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:26 -0700 (PDT)
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
Subject: [RFC PATCH v2 3/5] kvm: interface for managing pvsched driver for guest VMs
Date: Wed,  3 Apr 2024 10:01:14 -0400
Message-Id: <20240403140116.3002809-4-vineeth@bitbyteword.org>
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

Implement ioctl for assigning and unassigning pvsched driver for a
guest. VMMs would need to adopt this ioctls for supporting the feature.
Also add a temporary debugfs interface for managing this.

Ideally, the hypervisor would be able to determine the pvsched driver
based on the information received from the guest. Guest VMs with the
feature enabled would request hypervisor to select a pvsched driver.
ioctl api is an override mechanism to give more control to the admin.

Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/uapi/linux/kvm.h |   6 ++
 virt/kvm/kvm_main.c      | 117 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..4b29bdad4188 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2227,4 +2227,10 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+struct kvm_pvsched_ops {
+	__u8 ops_name[32]; /* PVSCHED_NAME_MAX */
+};
+
+#define KVM_GET_PVSCHED_OPS		_IOR(KVMIO, 0xe4, struct kvm_pvsched_ops)
+#define KVM_REPLACE_PVSCHED_OPS		_IOWR(KVMIO, 0xe5, struct kvm_pvsched_ops)
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0546814e4db7..b3d9c362d2e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1223,6 +1223,79 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	}
 }
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+static int pvsched_vcpu_ops_show(struct seq_file *m, void *data)
+{
+	char ops_name[PVSCHED_NAME_MAX];
+	struct pvsched_vcpu_ops *ops;
+	struct kvm *kvm = (struct kvm *) m->private;
+
+	rcu_read_lock();
+	ops = rcu_dereference(kvm->pvsched_ops);
+	if (ops)
+		strncpy(ops_name, ops->name, PVSCHED_NAME_MAX);
+	rcu_read_unlock();
+
+	seq_printf(m, "%s\n", ops_name);
+
+	return 0;
+}
+
+static ssize_t
+pvsched_vcpu_ops_write(struct file *filp, const char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	int ret;
+	char *cmp;
+	char buf[PVSCHED_NAME_MAX];
+	struct inode *inode;
+	struct kvm *kvm;
+
+	if (cnt > PVSCHED_NAME_MAX)
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	cmp = strstrip(buf);
+
+	inode = file_inode(filp);
+	inode_lock(inode);
+	kvm = (struct kvm *)inode->i_private;
+	ret = kvm_replace_pvsched_ops(kvm, cmp);
+	inode_unlock(inode);
+
+	if (ret)
+		return ret;
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pvsched_vcpu_ops_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pvsched_vcpu_ops_show, inode->i_private);
+}
+
+static const struct file_operations pvsched_vcpu_ops_fops = {
+	.open		= pvsched_vcpu_ops_open,
+	.write		= pvsched_vcpu_ops_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void kvm_create_vm_pvsched_debugfs(struct kvm *kvm)
+{
+	debugfs_create_file("pvsched_vcpu_ops", 0644, kvm->debugfs_dentry, kvm,
+			    &pvsched_vcpu_ops_fops);
+}
+#else
+static void kvm_create_vm_pvsched_debugfs(struct kvm *kvm)
+{
+}
+#endif
+
 static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
 	static DEFINE_MUTEX(kvm_debugfs_lock);
@@ -1288,6 +1361,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 				    &stat_fops_per_vm);
 	}
 
+	kvm_create_vm_pvsched_debugfs(kvm);
+
 	ret = kvm_arch_create_vm_debugfs(kvm);
 	if (ret)
 		goto out_err;
@@ -5474,6 +5549,48 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_gmem_create(kvm, &guest_memfd);
 		break;
 	}
+#endif
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case KVM_REPLACE_PVSCHED_OPS:
+		struct pvsched_vcpu_ops *ops;
+		struct kvm_pvsched_ops in_ops, out_ops;
+
+		r = -EFAULT;
+		if (copy_from_user(&in_ops, argp, sizeof(in_ops)))
+			goto out;
+
+		out_ops.ops_name[0] = 0;
+
+		rcu_read_lock();
+		ops = rcu_dereference(kvm->pvsched_ops);
+		if (ops)
+			strncpy(out_ops.ops_name, ops->name, PVSCHED_NAME_MAX);
+		rcu_read_unlock();
+
+		r = kvm_replace_pvsched_ops(kvm, (char *)in_ops.ops_name);
+		if (r)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &out_ops, sizeof(out_ops)))
+			goto out;
+
+		r = 0;
+		break;
+	case KVM_GET_PVSCHED_OPS:
+		out_ops.ops_name[0] = 0;
+		rcu_read_lock();
+		ops = rcu_dereference(kvm->pvsched_ops);
+		if (ops)
+			strncpy(out_ops.ops_name, ops->name, PVSCHED_NAME_MAX);
+		rcu_read_unlock();
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &out_ops, sizeof(out_ops)))
+			goto out;
+
+		r = 0;
+		break;
 #endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
-- 
2.40.1


