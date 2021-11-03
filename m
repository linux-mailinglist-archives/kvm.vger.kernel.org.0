Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73C4440DF
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 12:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhKCL42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 07:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhKCL4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 07:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635940419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMRcAwfrUTUzjur/Cy5j57aorJS9O9vaCqDkzCUe56o=;
        b=QfVxZ1789VMHpoNqLIs5O+hbXpwFhNk7Pqtw9KwICUTjI/k2XZW9RVCPlATup5aYnAd26R
        OIiA0tnjN9DeTiY3fFcj93DnG1rAIe1biDOZJMS3DnqiOCgk/u9wjVQJWwxX69FjIpGy+h
        47c2WT0AIFiu3HpbCPo8Pie7oAxikME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-TbN52wlVOp2OYSZKcLEUVQ-1; Wed, 03 Nov 2021 07:53:36 -0400
X-MC-Unique: TbN52wlVOp2OYSZKcLEUVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED6898066EB;
        Wed,  3 Nov 2021 11:53:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCF58196E2;
        Wed,  3 Nov 2021 11:53:33 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v4 6/7] nSVM: introduce struct vmcb_ctrl_area_cached
Date:   Wed,  3 Nov 2021 07:52:29 -0400
Message-Id: <20211103115230.720154-7-eesposit@redhat.com>
In-Reply-To: <20211103115230.720154-1-eesposit@redhat.com>
References: <20211103115230.720154-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will replace vmcb_control_area in
svm_nested_state, providing only the fields that are actually
used by the nested state. This avoids having and copying around
uninitialized fields. The cost of this, however, is that all
functions (in this case vmcb_is_intercept) expect the old
structure, so they need to be duplicated.

Introduce also nested_copy_vmcb_cache_to_control(), useful to copy
vmcb_ctrl_area_cached fields in vmcb_control_area. This will
be used in the next patch.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1b60e6818836..7895ddf176ed 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1229,6 +1229,40 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
+/* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
+static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
+					      struct vmcb_ctrl_area_cached *from)
+{
+	unsigned int i;
+
+	memset(dst, 0, sizeof(struct vmcb_control_area));
+
+	for (i = 0; i < MAX_INTERCEPT; i++)
+		dst->intercepts[i] = from->intercepts[i];
+
+	dst->iopm_base_pa         = from->iopm_base_pa;
+	dst->msrpm_base_pa        = from->msrpm_base_pa;
+	dst->tsc_offset           = from->tsc_offset;
+	dst->asid                 = from->asid;
+	dst->tlb_ctl              = from->tlb_ctl;
+	dst->int_ctl              = from->int_ctl;
+	dst->int_vector           = from->int_vector;
+	dst->int_state            = from->int_state;
+	dst->exit_code            = from->exit_code;
+	dst->exit_code_hi         = from->exit_code_hi;
+	dst->exit_info_1          = from->exit_info_1;
+	dst->exit_info_2          = from->exit_info_2;
+	dst->exit_int_info        = from->exit_int_info;
+	dst->exit_int_info_err    = from->exit_int_info_err;
+	dst->nested_ctl           = from->nested_ctl;
+	dst->event_inj            = from->event_inj;
+	dst->event_inj_err        = from->event_inj_err;
+	dst->nested_cr3           = from->nested_cr3;
+	dst->virt_ext              = from->virt_ext;
+	dst->pause_filter_count   = from->pause_filter_count;
+	dst->pause_filter_thresh  = from->pause_filter_thresh;
+}
+
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4346f6053432..49cc502986a9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -116,6 +116,31 @@ struct vmcb_save_area_cached {
 	u64 dr6;
 };
 
+struct vmcb_ctrl_area_cached {
+	u32 intercepts[MAX_INTERCEPT];
+	u16 pause_filter_thresh;
+	u16 pause_filter_count;
+	u64 iopm_base_pa;
+	u64 msrpm_base_pa;
+	u64 tsc_offset;
+	u32 asid;
+	u8 tlb_ctl;
+	u32 int_ctl;
+	u32 int_vector;
+	u32 int_state;
+	u32 exit_code;
+	u32 exit_code_hi;
+	u64 exit_info_1;
+	u64 exit_info_2;
+	u32 exit_int_info;
+	u32 exit_int_info_err;
+	u64 nested_ctl;
+	u32 event_inj;
+	u32 event_inj_err;
+	u64 nested_cr3;
+	u64 virt_ext;
+};
+
 struct svm_nested_state {
 	struct kvm_vmcb_info vmcb02;
 	u64 hsave_msr;
@@ -308,6 +333,12 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
+static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	return test_bit(bit, (unsigned long *)&control->intercepts);
+}
+
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-- 
2.27.0

