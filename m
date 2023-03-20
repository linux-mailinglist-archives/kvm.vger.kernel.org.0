Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D176C2440
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCTWKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCTWKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:36 -0400
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087E2EC5D
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5r/nxvUmD7imNRO81Xhjg+6YJH/avavC5N84p/0LnA=;
        b=vnRCAF1E7D6wgpadRvLKxtvlNRal0WgxFBkTvCNerPN9qkxZlmPGp0epqBoxZ5ksEct4X0
        9v8ERRBMxaKQmSzQ68dFuLTyNDI3bqMLuraTMfIOleW2pkzYcJ1GAQRAttPC/07aKqnOlo
        Owdt+yWi9iumoCsm86eMmchmlIWwl1A=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 03/11] KVM: arm64: Add vm fd device attribute accessors
Date:   Mon, 20 Mar 2023 22:09:54 +0000
Message-Id: <20230320221002.4191007-4-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change will allow userspace to convey a filter for
hypercalls through a vm device attribute. Add the requisite boilerplate
for vm attribute accessors.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..b6e26c0e65e5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1439,11 +1439,28 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	default:
+		return -ENXIO;
+	}
+}
+
+static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	default:
+		return -ENXIO;
+	}
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
@@ -1479,6 +1496,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
 	}
+	case KVM_HAS_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_has_attr(kvm, &attr);
+	}
+	case KVM_SET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_set_attr(kvm, &attr);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.40.0.rc1.284.g88254d51c5-goog

