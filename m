Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08CB30DD7D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhBCPCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhBCPCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65505C0617AB
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LO/cU+t4ZnXH8t1exeasZ5UcWijE39xUA4Y8DW/qKCw=; b=W8bVMMQHeJI6OZD7jUn0UaPK8k
        oSW2napJ9XWoiGAG59RKAY4RHWR771Cw/BT7IgKN6eJc2vuo8k67ErWOC+b2YrjOcDk5SAOEQBe4r
        z/WYUGwL4y+Hnc8yoxN50gEDTeb0Swm6HJuH82beTt5wWnQEC1ijgKjEQ51nl3CnFNszCHu+DZB2d
        j1h5JzjOULcUxsG7YXmtVY8P67dgUfkz1byQjecA8gu9WjXQDt+t3cmKwM/aLQwoXW5ZeXc1Dl3gL
        ig9CGbTrMQmd3BbEbDZpL7O1utNdqOgCLUrsBzFvCHF/oRpbTyr9rprZQI6p8YLP+uFa+myCTstAK
        hv6SbEEA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zH-Ho; Wed, 03 Feb 2021 15:01:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reN-5T; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 05/19] KVM: x86/xen: Move KVM_XEN_HVM_CONFIG handling to xen.c
Date:   Wed,  3 Feb 2021 15:01:00 +0000
Message-Id: <20210203150114.920335-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is already more complex than the simple memcpy it originally had.
Move it to xen.c with the rest of the Xen support.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 14 +-------------
 arch/x86/kvm/xen.c | 18 ++++++++++++++++++
 arch/x86/kvm/xen.h |  1 +
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b948c4cd48e..a74ae5f70bdc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5607,19 +5607,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&xhc, argp, sizeof(xhc)))
 			goto out;
-		r = -EINVAL;
-		if (xhc.flags & ~KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL)
-			goto out;
-		/*
-		 * With hypercall interception the kernel generates its own
-		 * hypercall page so it must not be provided.
-		 */
-		if ((xhc.flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
-		    (xhc.blob_addr_32 || xhc.blob_addr_64 ||
-		     xhc.blob_size_32 || xhc.blob_size_64))
-			goto out;
-		memcpy(&kvm->arch.xen_hvm_config, &xhc, sizeof(xhc));
-		r = 0;
+		r = kvm_xen_hvm_config(kvm, &xhc);
 		break;
 	}
 	case KVM_SET_CLOCK: {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 19bcb2bfba86..b52549fc6dbc 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -79,6 +79,24 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
+int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
+{
+	if (xhc->flags & ~KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL)
+		return -EINVAL;
+
+	/*
+	 * With hypercall interception the kernel generates its own
+	 * hypercall page so it must not be provided.
+	 */
+	if ((xhc->flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
+	    (xhc->blob_addr_32 || xhc->blob_addr_64 ||
+	     xhc->blob_size_32 || xhc->blob_size_64))
+		return -EINVAL;
+
+	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
+	return 0;
+}
+
 static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 {
 	kvm_rax_write(vcpu, result);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 276ed59e476b..28e9c9892628 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -11,6 +11,7 @@
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
+int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
-- 
2.29.2

