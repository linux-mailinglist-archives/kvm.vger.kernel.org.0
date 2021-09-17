Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEDF40F84F
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbhIQMwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:52:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238307AbhIQMwH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631883045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tf1rvKL/yX0MU6z7TAk43jAFZ2N+O3DLW/Sv60cPFxE=;
        b=R2GDDeY5CaPsy1aEl+bp0FBfZYcRJ4euxaoHx6h/3OqoO8r7XqwIqluENDFggiEIYiI5h5
        9f4XJ1t7RqdB+uQZxQ+FeItfZW8XZjzLkn4Gy/mrOq8aLxcxYGJ3TnFmXU8O8rdVKGPv40
        zjchQLSDUqiE+fKTaIKoWs5EBOBaw8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-JJH8aRflOSSci7LzHIsXHQ-1; Fri, 17 Sep 2021 08:50:44 -0400
X-MC-Unique: JJH8aRflOSSci7LzHIsXHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3B21800D41;
        Fri, 17 Sep 2021 12:50:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BB1077F29;
        Fri, 17 Sep 2021 12:50:41 +0000 (UTC)
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
Subject: [RFC PATCH 1/2] nSVM: introduce struct vmcb_ctrl_area_cached
Date:   Fri, 17 Sep 2021 08:49:55 -0400
Message-Id: <20210917124956.2042052-2-eesposit@redhat.com>
In-Reply-To: <20210917124956.2042052-1-eesposit@redhat.com>
References: <20210917124956.2042052-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will replace vmcb_control_area in
svm_nested_state, providing only the fields that are actually
used by the nested state. This avoids having and copying around
uninitialized fields. The cost of this, however, is that all
functions (in this case vmcb_is_intercept) expect the old
structure, so they need to be duplicated.

Introduce also copy_vmcb_ctrl_area_cached(), useful to copy
vmcb_ctrl_area_cached fields in vmcb_control_area. This will
be used in the next patch.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9b2c4895d5d9..d06a95156535 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1224,6 +1224,38 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
+/* Inverse operation of copy_vmcb_control_area(). asid is copied too.  */
+static void copy_vmcb_ctrl_area_cached(struct vmcb_control_area *from,
+				       struct vmcb_ctrl_area_cached *dst)
+{
+	unsigned int i;
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
index 9982e6136724..a00be2516cc6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -112,6 +112,31 @@ struct vmcb_save_area_cached {
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
@@ -304,6 +329,12 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
+static inline bool vmcb_is_intercept_cached(struct vmcb_ctrl_area_cached *control, u32 bit)
+{
+	return vmcb_is_intercept((struct vmcb_control_area *) control,
+				 bit);
+}
+
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-- 
2.27.0

