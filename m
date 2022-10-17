Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D4160168D
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJQSqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJQSqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:46:05 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B276CD39;
        Mon, 17 Oct 2022 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666032365; x=1697568365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7P4CUTJ+HKkeBiHLXxdrw9k3ZvgWZpB7DAeZdKoH/Y=;
  b=TVeLWI6qqgRJOy0q6/BCOp0Zb0/NrXDyVubCMig/pnn9AtF5SbeU4Kxl
   rwSIn5sYynj1mowrMehOFy6F93Rno+INExvu/R/iv7Nbt01FsGxBsouTE
   jzGxu290YQNtFs12++f3kjscvcLUiohTFJmPP6HjV7+vZErLukCUcdhGl
   E=;
X-IronPort-AV: E=Sophos;i="5.95,192,1661817600"; 
   d="scan'208";a="141055391"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:46:05 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id D9A7045CC1;
        Mon, 17 Oct 2022 18:46:03 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 17 Oct 2022 18:45:56 +0000
Received: from f02f4b0103c5.ant.amazon.com (10.43.162.35) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Mon, 17 Oct 2022 18:45:55 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Randrianasulu" <randrianasulu@gmail.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 3/3] KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER
Date:   Mon, 17 Oct 2022 20:45:41 +0200
Message-ID: <20221017184541.2658-4-graf@amazon.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221017184541.2658-1-graf@amazon.com>
References: <20221017184541.2658-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_X86_SET_MSR_FILTER ioctls contains a pointer in the passed in
struct which means it has a different struct size depending on whether
it gets called from 32bit or 64bit code.

This patch introduces compat code that converts from the 32bit struct to
its 64bit counterpart which then gets used going forward internally.
With this applied, 32bit QEMU can successfully set MSR bitmaps when
running on 64bit kernels.

Reported-by: Andrew Randrianasulu <randrianasulu@gmail.com>
Fixes: 1a155254ff937 ("KVM: x86: Introduce MSR filtering")
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/x86.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19f060ce577f..20b5d25ba265 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6446,6 +6446,62 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	return 0;
 }
 
+#ifdef CONFIG_KVM_COMPAT
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range_compat {
+	__u32 flags;
+	__u32 nmsrs;
+	__u32 base;
+	__u32 bitmap;
+};
+
+struct kvm_msr_filter_compat {
+	__u32 flags;
+	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
+
+#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_filter_compat)
+
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm *kvm = filp->private_data;
+	long r = -ENOTTY;
+
+	switch (ioctl) {
+	case KVM_X86_SET_MSR_FILTER_COMPAT: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter_compat filter_compat;
+		struct kvm_msr_filter filter;
+		int i;
+
+		if (copy_from_user(&filter_compat, user_msr_filter,
+				   sizeof(filter_compat)))
+			return -EFAULT;
+
+		filter.flags = filter_compat.flags;
+		for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
+			struct kvm_msr_filter_range_compat *cr;
+
+			cr = &filter_compat.ranges[i];
+			filter.ranges[i] = (struct kvm_msr_filter_range) {
+				.flags = cr->flags,
+				.nmsrs = cr->nmsrs,
+				.base = cr->base,
+				.bitmap = (__u8 *)(ulong)cr->bitmap,
+			};
+		}
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
+		break;
+	}
+	}
+
+	return r;
+}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
-- 
2.37.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



