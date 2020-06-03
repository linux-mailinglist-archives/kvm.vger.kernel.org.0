Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649511ED9AF
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgFCX4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgFCX4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:42 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07FEC08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:40 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h6so2971388qvb.23
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RZe2iTzkFTucjCz18OJF8aeEcSZVzJ9FXQMhSY4aNNY=;
        b=XHy9n1Xip2plnj0s62bfJ6G1IMfNWQaYW1MO8vtjm2g8nESGoJl47ap/pxjX57gsq5
         hwRRo/Kdfg1buEOQY97J7UQ6Pto6lzsSn/Rn7OJ1eP1/OmSbwwPhfWWRmjrAoRXyGENd
         gWxhBJoAYMzY4mOuHndFcRr+EbzBAvjExCYHjKOgqa7a8zOWncJ8h0dxvOac2he77Cni
         vfX6pEFsDy0K9O3f8q4UyRonyL0lUFqNj0bWeWXkQwQ9C2ebkh9PgGI+NVYJUqhcYQIx
         25Le/rBRd7JvNeLdDfmYs35iwG5Q023gZ5rrYkD38W+Wy5TN1WTl2WdO/dYVHGSlwqZq
         FtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RZe2iTzkFTucjCz18OJF8aeEcSZVzJ9FXQMhSY4aNNY=;
        b=IYdycCCI2WD582tw2PVmWC+DDNL7KALC262w5DyHyVbuc2R6RMLH4PliNbnSmPpJql
         bGm6Qa+GrXVW6itu8ECBszx4Fk45Y6FYNiM2IyZYbCzTUMp5T7d9ZAahXQil2y8JIsyE
         6FAGWZ1Vv5jwkdcwQb1Rjw3dKnPKDSweLSDhvA0nDzYoqBIvPXFVUkWN5KSGdyne0NSl
         Bfrfl5o5rF9h8tk6jZc5L6lS+Xxwl8Y8JYm+/WNgiYgZMVJcVhO04mjI0rBujWYqX4R7
         mmoSqFt0A++JoxmYRgw+ShL+ThKGcMNP4oKEkcbVhl8vndsU3ag8iRUHNLbZy6Uglh5C
         Bpaw==
X-Gm-Message-State: AOAM5307dJtX/2pNWDABTfu8DqCJ4HyQpOd1CBa0U06AlC5Il3Brx7aB
        /+YQhYy/JkZb1ja6iru3XkkujuCsaEIBD9eRr0skdJKA9GedmWdnYnmajXPGOTsQtVoC1qLWn+u
        fXA4YufTdDFnuX9sKkzBhqMC2zxoWKLUSAOt8huNCF718xHWoFEUA7ZObJU/4tQ8=
X-Google-Smtp-Source: ABdhPJzoTm4KnkTcJDEXpkSIUuyD/b/VGbiQghIe2m7TwSvEfjp6ALoCNK+uPF1JunTAGT8IG3vJwM0vUm3zVA==
X-Received: by 2002:a05:6214:1804:: with SMTP id o4mr2331023qvw.27.1591228599905;
 Wed, 03 Jun 2020 16:56:39 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:21 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-5-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 4/6] kvm: x86: Add "last CPU" to some KVM_EXIT information
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More often than not, a failed VM-entry in an x86 production
environment is induced by a defective CPU. To help identify the bad
hardware, include the id of the last logical CPU to run a vCPU in the
information provided to userspace on a KVM exit for failed VM-entry or
for KVM internal errors not associated with emulation. The presence of
this additional information is indicated by a new capability,
KVM_CAP_LAST_CPU.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 Documentation/virt/kvm/api.rst |  1 +
 arch/x86/kvm/svm/svm.c         |  4 +++-
 arch/x86/kvm/vmx/vmx.c         | 10 ++++++++--
 arch/x86/kvm/x86.c             |  1 +
 include/uapi/linux/kvm.h       |  2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d280af5345df..17db8b68c165 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4792,6 +4792,7 @@ hardware_exit_reason.
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu; /* if KVM_LAST_CPU */
 		} fail_entry;
 
 If exit_reason is KVM_EXIT_FAIL_ENTRY, the vcpu could not be run due
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 442dbb763639..938be4172bab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2945,6 +2945,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
+		kvm_run->fail_entry.cpu = svm->last_cpu;
 		dump_vmcb(vcpu);
 		return 0;
 	}
@@ -2968,8 +2969,9 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 1;
+		vcpu->run->internal.ndata = 2;
 		vcpu->run->internal.data[0] = exit_code;
+		vcpu->run->internal.data[1] = svm->last_cpu;
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42856970d3b8..da5490b94704 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4758,10 +4758,11 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	    !(is_page_fault(intr_info) && !(error_code & PFERR_RSVD_MASK))) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
-		vcpu->run->internal.ndata = 3;
+		vcpu->run->internal.ndata = 4;
 		vcpu->run->internal.data[0] = vect_info;
 		vcpu->run->internal.data[1] = intr_info;
 		vcpu->run->internal.data[2] = error_code;
+		vcpu->run->internal.data[3] = vmx->last_cpu;
 		return 0;
 	}
 
@@ -5983,6 +5984,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
+		vcpu->run->fail_entry.cpu = vmx->last_cpu;
 		return 0;
 	}
 
@@ -5991,6 +5993,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
+		vcpu->run->fail_entry.cpu = vmx->last_cpu;
 		return 0;
 	}
 
@@ -6017,6 +6020,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			vcpu->run->internal.data[3] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
+		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
+			vmx->last_cpu;
 		return 0;
 	}
 
@@ -6072,8 +6077,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.ndata = 2;
 	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[1] = vmx->last_cpu;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e41b5135340..20c420a45847 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3472,6 +3472,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_LAST_CPU:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6721eb563eda..3edbd44d85bf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -289,6 +289,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -1031,6 +1032,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_LAST_CPU 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.27.0.rc2.251.g90737beb825-goog

