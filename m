Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEE97CC5E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 20:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbfGaS4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 14:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbfGaS4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 14:56:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C7C6206A2;
        Wed, 31 Jul 2019 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564599382;
        bh=HxE5nJoezKPmCmbBqI6y5cp+2ktFXV6qqDPXeFBB+Rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1TeErr1RyD1IXhKuXf8fU/1z50JcD3Ui1OOC0qfkmretxiGVdwcv6avY05pv4qyk1
         J8N1ihmOckqBaifjqyiEikFS5MGPGZYJYaHaAQp95MroUwgrACz4RWq5FzwOJh6E15
         YoZ7ccWGUQvfM3iLQE2bgl3+iIQH4snKWuR6je30=
Date:   Wed, 31 Jul 2019 20:56:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: no need to check return value of debugfs_create
 functions
Message-ID: <20190731185620.GB703@kroah.com>
References: <20190731185556.GA703@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190731185556.GA703@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Also, when doing this, change kvm_arch_create_vcpu_debugfs() to return
void instead of an integer, as we should not care at all about if this
function actually does anything or not.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: <kvm@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: change the return value of kvm_arch_create_vcpu_debugfs() to be
    void, based on review comments.

 arch/mips/kvm/mips.c       |  3 +--
 arch/powerpc/kvm/powerpc.c |  3 +--
 arch/s390/kvm/kvm-s390.c   |  3 +--
 arch/x86/kvm/debugfs.c     | 41 ++++++++++++--------------------------
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/arm/arm.c         |  3 +--
 virt/kvm/kvm_main.c        | 21 +++++--------------
 7 files changed, 23 insertions(+), 53 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 948ef36ca87c..65eeda084c58 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -150,9 +150,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-	return 0;
 }
 
 void kvm_mips_free_vcpus(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 78d166672492..5a303fd2396b 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -452,9 +452,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return -EINVAL;
 }
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-	return 0;
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4dd49bda8d25..f62d874b6b2a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2516,9 +2516,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return rc;
 }
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-	return 0;
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 9bd93e0d5f63..018aebce33ff 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -43,37 +43,22 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-	struct dentry *ret;
+	debugfs_create_file("tsc-offset", 0444, vcpu->debugfs_dentry, vcpu,
+			    &vcpu_tsc_offset_fops);
 
-	ret = debugfs_create_file("tsc-offset", 0444,
-							vcpu->debugfs_dentry,
-							vcpu, &vcpu_tsc_offset_fops);
-	if (!ret)
-		return -ENOMEM;
-
-	if (lapic_in_kernel(vcpu)) {
-		ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
-								vcpu->debugfs_dentry,
-								vcpu, &vcpu_timer_advance_ns_fops);
-		if (!ret)
-			return -ENOMEM;
-	}
+	if (lapic_in_kernel(vcpu))
+		debugfs_create_file("lapic_timer_advance_ns", 0444,
+				    vcpu->debugfs_dentry, vcpu,
+				    &vcpu_timer_advance_ns_fops);
 
 	if (kvm_has_tsc_control) {
-		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
-							vcpu->debugfs_dentry,
-							vcpu, &vcpu_tsc_scaling_fops);
-		if (!ret)
-			return -ENOMEM;
-		ret = debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
-							vcpu->debugfs_dentry,
-							vcpu, &vcpu_tsc_scaling_frac_fops);
-		if (!ret)
-			return -ENOMEM;
-
+		debugfs_create_file("tsc-scaling-ratio", 0444,
+				    vcpu->debugfs_dentry, vcpu,
+				    &vcpu_tsc_scaling_fops);
+		debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
+				    vcpu->debugfs_dentry, vcpu,
+				    &vcpu_tsc_scaling_frac_fops);
 	}
-
-	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 52596a27ab27..b7a7cb291c14 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -861,7 +861,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index cc85259a243d..dda5e0bb6871 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -144,9 +144,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-	return 0;
 }
 
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ac0a2f6a50a4..5e54b47e2343 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2591,27 +2591,18 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return anon_inode_getfd(name, &kvm_vcpu_fops, vcpu, O_RDWR | O_CLOEXEC);
 }
 
-static int kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	char dir_name[ITOA_MAX_LEN * 2];
-	int ret;
 
 	if (!debugfs_initialized())
-		return 0;
+		return;
 
 	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
 	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
-								vcpu->kvm->debugfs_dentry);
-	if (!vcpu->debugfs_dentry)
-		return -ENOMEM;
+						  vcpu->kvm->debugfs_dentry);
 
-	ret = kvm_arch_create_vcpu_debugfs(vcpu);
-	if (ret < 0) {
-		debugfs_remove_recursive(vcpu->debugfs_dentry);
-		return ret;
-	}
-
-	return 0;
+	kvm_arch_create_vcpu_debugfs(vcpu);
 }
 
 /*
@@ -2646,9 +2637,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_destroy;
 
-	r = kvm_create_vcpu_debugfs(vcpu);
-	if (r)
-		goto vcpu_destroy;
+	kvm_create_vcpu_debugfs(vcpu);
 
 	mutex_lock(&kvm->lock);
 	if (kvm_get_vcpu_by_id(kvm, id)) {
-- 
2.22.0

