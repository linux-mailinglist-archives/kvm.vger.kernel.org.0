Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9E601694
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJQSqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiJQSqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:46:16 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66056CD39;
        Mon, 17 Oct 2022 11:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666032375; x=1697568375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tekcCNoQ3YKIU5MGV/KMl+u0lXubCzMUZiA8DXzCHx4=;
  b=lNHPzZNbHaZt7CRwnfOvbeRLwhLKUxFbGDdpEqjuymcxLe95EF8aOAO6
   mzUp3vV8W/xCqNs4PIrLGXfk/EC3thVcmuzMRe6GRT0kkcJXFKUme/2oY
   kWC0c3G6n0hxd13uuMP2VGTY5czRH8W9Zqb+JCAmRHMhaguNCXbVlQ4oC
   c=;
X-IronPort-AV: E=Sophos;i="5.95,192,1661817600"; 
   d="scan'208";a="233756864"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:46:05 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id C717F45CBD;
        Mon, 17 Oct 2022 18:46:03 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 17 Oct 2022 18:45:52 +0000
Received: from f02f4b0103c5.ant.amazon.com (10.43.162.35) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Mon, 17 Oct 2022 18:45:51 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Randrianasulu" <randrianasulu@gmail.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 1/3] kvm: Add support for arch compat vm ioctls
Date:   Mon, 17 Oct 2022 20:45:39 +0200
Message-ID: <20221017184541.2658-2-graf@amazon.com>
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

We will introduce the first architecture specific compat vm ioctl in the
next patch. Add all necessary boilerplate to allow architectures to
override compat vm ioctls when necessary.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..7a40f9bdc173 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1391,6 +1391,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..4c5259828efd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4834,6 +4834,12 @@ struct compat_kvm_clear_dirty_log {
 	};
 };
 
+long __weak kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+				     unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4842,6 +4848,11 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 
 	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {
-- 
2.37.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



