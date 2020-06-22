Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB21204345
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgFVWEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:04:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730794AbgFVWEz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 18:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592863493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92xlo56NnQbKrNJm5mldzyMce3skYCA3gpK4Ws+GIX4=;
        b=HaaSEpFVYPjsqICjv2RQhacI1wO6GXV7A4y5TBzvlO8359EE52v+keaVMsYd+Ux6sIxhtR
        HLpwcK8QATcCF1XTftfR79weBBqqEGk8OlNoqpwkPF3/9TooVA9WSQg6RiR/7pBPnNSsE0
        FFo+C0sf2+EjjE7+UBEvG1+/OTNRcnM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-s0HoMUk5Om-LOQzYoBfBvA-1; Mon, 22 Jun 2020 18:04:51 -0400
X-MC-Unique: s0HoMUk5Om-LOQzYoBfBvA-1
Received: by mail-qk1-f198.google.com with SMTP id i6so2684106qkn.22
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92xlo56NnQbKrNJm5mldzyMce3skYCA3gpK4Ws+GIX4=;
        b=lhF6ujVstpi9KrInMoySDK+5PK3bkKO7uH+9CcVbDDXgzYdmn+w13MOZWb/V6BbT0l
         HiWLB+MNBy1bf2vGoJYn41BfmQ4Csclq6YUnahNFzdtWmeacXg3vVLEUV97jwSFhM92x
         okaZKMjPtqcziBnuuTAtOYaT3gE5yKPKJvHUVGI27LRzrcx+zYpdv6f9m/hrAPUuGWIg
         6xVR3uiO8oXqTVc0sO+tvDiGVRe7ZynOSFqahskkf3nXLkzr6dvV20LvN2f0ilohB4YM
         Yx26dR1G/9tRButLKdK7eHwKMWp0GxTYAJfyQJ4tVqnS9EudZOy9+UWReiQgXuT6RY8c
         H0tA==
X-Gm-Message-State: AOAM530m3XhmzPodlVIst+35RS3G0hF8Q4Dm4aQ16JUAakdo2xx44KkD
        9PceZopvQrFyk+dRM6MbceNkM2KmzFvlVhOTJtVxlLvTvQdYsMRPDiJrKRrM7ERG5lbW7FcfjRp
        IRH4FI6NgKXQ7
X-Received: by 2002:a37:44d5:: with SMTP id r204mr7294737qka.113.1592863490935;
        Mon, 22 Jun 2020 15:04:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwpw9hXXzrRoZ7uBlSGesnncpPEpLsS//WL8KZ5yVPHkbD2TpWTGus3gca62CrS2n80xyqrg==
X-Received: by 2002:a37:44d5:: with SMTP id r204mr7294705qka.113.1592863490646;
        Mon, 22 Jun 2020 15:04:50 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h6sm3506810qtu.2.2020.06.22.15.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:04:50 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Date:   Mon, 22 Jun 2020 18:04:41 -0400
Message-Id: <20200622220442.21998-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622220442.21998-1-peterx@redhat.com>
References: <20200622220442.21998-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR accesses can be one of:

  (1) KVM internal access,
  (2) userspace access (e.g., via KVM_SET_MSRS ioctl),
  (3) guest access.

The ignore_msrs was previously handled by kvm_get_msr_common() and
kvm_set_msr_common(), which is the bottom of the msr access stack.  It's
working in most cases, however it could dump unwanted warning messages to dmesg
even if kvm get/set the msrs internally when calling __kvm_set_msr() or
__kvm_get_msr() (e.g. kvm_cpuid()).  Ideally we only want to trap cases (2)
or (3), but not (1) above.

To achieve this, move the ignore_msrs handling upper until the callers of
__kvm_get_msr() and __kvm_set_msr().  To identify the "msr missing" event, a
new return value (KVM_MSR_RET_INVALID==2) is used for that.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 80 +++++++++++++++++++++++++++++++---------------
 arch/x86/kvm/x86.h |  2 ++
 2 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..b49eaf8a2ce5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -245,6 +245,29 @@ EXPORT_SYMBOL_GPL(x86_fpu_cache);
 
 static struct kmem_cache *x86_emulator_cache;
 
+/*
+ * When called, it means the previous get/set msr reached an invalid msr.
+ * Return 0 if we want to ignore/silent this failed msr access, or 1 if we want
+ * to fail the caller.
+ */
+static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
+				 u64 data, bool write)
+{
+	const char *op = write ? "wrmsr" : "rdmsr";
+
+	if (ignore_msrs) {
+		if (report_ignored_msrs)
+			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
+				    op, msr, data);
+		/* Mask the error */
+		return 0;
+	} else {
+		vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
+				       op, msr, data);
+		return 1;
+	}
+}
+
 static struct kmem_cache *kvm_alloc_emulator_cache(void)
 {
 	unsigned int useroffset = offsetof(struct x86_emulate_ctxt, src);
@@ -1496,6 +1519,17 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	return kvm_x86_ops.set_msr(vcpu, &msr);
 }
 
+static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
+				     u32 index, u64 data, bool host_initiated)
+{
+	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
+
+	if (ret == KVM_MSR_RET_INVALID)
+		ret = kvm_msr_ignored_check(vcpu, index, data, true);
+
+	return ret;
+}
+
 /*
  * Read the MSR specified by @index into @data.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -1517,15 +1551,29 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	return ret;
 }
 
+static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
+				     u32 index, u64 *data, bool host_initiated)
+{
+	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
+
+	if (ret == KVM_MSR_RET_INVALID) {
+		/* Unconditionally clear *data for simplicity */
+		*data = 0;
+		ret = kvm_msr_ignored_check(vcpu, index, 0, false);
+	}
+
+	return ret;
+}
+
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
-	return __kvm_get_msr(vcpu, index, data, false);
+	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr);
 
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
-	return __kvm_set_msr(vcpu, index, data, false);
+	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
@@ -1621,12 +1669,12 @@ EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
  */
 static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	return __kvm_get_msr(vcpu, index, data, true);
+	return kvm_get_msr_ignored_check(vcpu, index, data, true);
 }
 
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	return __kvm_set_msr(vcpu, index, *data, true);
+	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
 #ifdef CONFIG_X86_64
@@ -2977,17 +3025,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return xen_hvm_config(vcpu, data);
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
-		if (!ignore_msrs) {
-			vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
-				    msr, data);
-			return 1;
-		} else {
-			if (report_ignored_msrs)
-				vcpu_unimpl(vcpu,
-					"ignored wrmsr: 0x%x data 0x%llx\n",
-					msr, data);
-			break;
-		}
+		return KVM_MSR_RET_INVALID;
 	}
 	return 0;
 }
@@ -3234,17 +3272,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
-		if (!ignore_msrs) {
-			vcpu_debug_ratelimited(vcpu, "unhandled rdmsr: 0x%x\n",
-					       msr_info->index);
-			return 1;
-		} else {
-			if (report_ignored_msrs)
-				vcpu_unimpl(vcpu, "ignored rdmsr: 0x%x\n",
-					msr_info->index);
-			msr_info->data = 0;
-		}
-		break;
+		return KVM_MSR_RET_INVALID;
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc0516f..62e3e896d059 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -359,4 +359,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 
+#define  KVM_MSR_RET_INVALID  2
+
 #endif
-- 
2.26.2

