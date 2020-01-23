Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC73147051
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 19:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgAWSE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 13:04:56 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:48799 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbgAWSEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 13:04:54 -0500
Received: by mail-pl1-f202.google.com with SMTP id d20so1826930pls.15
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 10:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fRJtGzU1nWtZCwyyEdBQOQV0uriURdFY4YOkq57xKFA=;
        b=I/C8CMtDyMwkAyRWTigJSrx8ByPwzQxVcP2Y+qJ4lGvA2rQUQ+UnnLo7HnBLIstBBI
         Se+PwmLQHN+LOVGuJqJzd/H7Bcbp05STGoP3ij0oUhXZqXYtjMxODspqKQ+r0Qf/48bi
         XXhUwajJPI3kaI+9Ok0tfbC6HBRjJ6XiYJGcpudGe+aY+EvqIUsCZEGShQlf86XZaWzo
         Q2P/+Y2eTaAm8vFcIPTkCe/0dFigQC6wmq42DqOwPkIRwZyXrBrWJGdFPD1QSYjfNjYL
         rV8Z0D6oaAwGzyN0FI4d4McSMqWxeax+btspKH6/+JWKqHjpJ9le7DXX1SDGH0LLCwJn
         jHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fRJtGzU1nWtZCwyyEdBQOQV0uriURdFY4YOkq57xKFA=;
        b=B5K+bMLH+i/ESJTdOyTK8gexIppLYI8xVwD3N67gwtIzZfGnu7JsfAj4b65Z9hMUmT
         uSJFoheC2qF9sItMRyvhQRcfowvP8AaWdCEwPcvzJpuGSRGogtJUS3TRcOkIeewZmNuf
         WtA8BJGWjPXBGDEuOC/P5bsJGCfvwnXG/mvKpkR2TXJUx1LVPxs0w98dBhLxLK6L0QYH
         cih+PcuIDJ4T0KOiJ6MCRSasGrkn2dVgSkEnik1uHX4jAXkQAFbCS+ki2BhBlK/H8VK2
         9iHLKXC89jj83ZHP8e5aNbw0OR7EVXoZz17cnhgbk6Gki7bNmni39pkzzuBAvaIJAXLK
         L7rA==
X-Gm-Message-State: APjAAAW9yaKpswdkBtAVrBhruVrh1HIb/bzd0pdDVZD1surqkJE3ce+W
        3hkVfCiCBPtdUUlK5WB1owA5brAXEvn7
X-Google-Smtp-Source: APXvYqx0aHZM1DcqSFTVtQf5JBTmVMs5XjbKOT9oAFEQnjFFCQcfL2/KGMJmFYibuxRpdeVN5YZ1pdPKWiZd
X-Received: by 2002:a63:6c86:: with SMTP id h128mr14829pgc.200.1579802694008;
 Thu, 23 Jan 2020 10:04:54 -0800 (PST)
Date:   Thu, 23 Jan 2020 10:04:32 -0800
In-Reply-To: <20200123180436.99487-1-bgardon@google.com>
Message-Id: <20200123180436.99487-7-bgardon@google.com>
Mime-Version: 1.0
References: <20200123180436.99487-1-bgardon@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v4 06/10] KVM: selftests: Add support for vcpu_args_set to
 aarch64 and s390x
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently vcpu_args_set is only implemented for x86. This makes writing
tests with multiple vCPUs difficult as each guest vCPU must either a.)
do the same thing or b.) derive some kind of unique token from it's
registers or the architecture. To simplify the process of writing tests
with multiple vCPUs for s390 and aarch64, add set args functions for
those architectures.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 33 +++++++++++++++++
 .../selftests/kvm/lib/s390x/processor.c       | 35 +++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 86036a59a668e..a2ff90a75f326 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -333,3 +333,36 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
 }
+
+/* VM VCPU Args Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   num - number of arguments
+ *   ... - arguments, each of type uint64_t
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the first num function input arguments to the values
+ * given as variable args.  Each of the variable args is expected to
+ * be of type uint64_t. The registers set by this function are r0-r7.
+ */
+void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
+{
+	va_list ap;
+
+	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
+		    "  num: %u\n",
+		    num);
+
+	va_start(ap, num);
+
+	for (i = 0; i < num; i++)
+		set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[num]),
+			va_arg(ap, uint64_t));
+
+	va_end(ap);
+}
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 32a02360b1eb0..680f37be9dbc9 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -269,6 +269,41 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	run->psw_addr = (uintptr_t)guest_code;
 }
 
+/* VM VCPU Args Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   num - number of arguments
+ *   ... - arguments, each of type uint64_t
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the first num function input arguments to the values
+ * given as variable args.  Each of the variable args is expected to
+ * be of type uint64_t. The registers set by this function are r2-r6.
+ */
+void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
+{
+	va_list ap;
+	struct kvm_regs regs;
+
+	TEST_ASSERT(num >= 1 && num <= 5, "Unsupported number of args,\n"
+		    "  num: %u\n",
+		    num);
+
+	va_start(ap, num);
+	vcpu_regs_get(vm, vcpuid, &regs);
+
+	for (i = 0; i < num; i++)
+		regs.gprs[i + 2] = va_arg(ap, uint64_t);
+
+	vcpu_regs_set(vm, vcpuid, &regs);
+	va_end(ap);
+}
+
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	struct vcpu *vcpu = vm->vcpu_head;
-- 
2.25.0.341.g760bfbb309-goog

