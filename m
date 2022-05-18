Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B8752B36B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 09:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiERH1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 03:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiERH1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 03:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EF3F5C74B
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652858841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kM/jq3wC06Yxt2m9o66mKz8VgGhEZ6UVb+F8A80Qnbw=;
        b=dPTjhwljMbu2SGjogTsg9+M++/hKfo4UlGA/wsRHPLaik/M9l+YeE1te6gj+bQ5iu4Yl+J
        kNWz70K5xc0lAkK7hkblGm/GSz/qwYRRCgE4jHRAEl/M8dHAH21YmC3DXJD0Cxs+LMUTfu
        u5vyeXiAQ/Y2tYOegSmPyeus8eVAf3Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-NR-mxCDLP-2mUyqogS8SLg-1; Wed, 18 May 2022 03:27:18 -0400
X-MC-Unique: NR-mxCDLP-2mUyqogS8SLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74EED29DD9A0;
        Wed, 18 May 2022 07:27:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC2DA2026D64;
        Wed, 18 May 2022 07:27:10 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: x86: SVM: fix nested PAUSE filtering
Date:   Wed, 18 May 2022 10:27:09 +0300
Message-Id: <20220518072709.730031-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 74fd41ed16fd
("KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE")

introduced passthrough support for nested pause filtering,
(when the host doesn't intercept PAUSE)
(either disabled with kvm module param, or disabled with
'-overcommit cpu-pm=on')

However the feature was exposed as supported by KVM cpuid unconditionally,
thus if the guest is launched with -cpu host, it could use it even when
the KVM can't really support it.

While this use case should be avoided by the management software
(e.g libvirt), a failback was made for this case to intercept
each PAUSE instruction.

Turns out that in some cases, such intercept can slow down the
nested guest so much that it can fail to boot.

Also it turns out that when the pause filtering is not supported,
the KVM doesn't intercept PAUSE at all, so before this patch,
this slowdown didn't exist.

To fix this, change the fallback strategy - ignore the guest threshold
values, but use/update the host threshold values, instead of using zeros.

Also fix a minor bug: on nested VM exit, when PAUSE filter counter
were copied back to vmcb01, a dirty bit was not set.

Finally a note on why it 'worked' before the problematic commit in
regard to nesting:

KVM was setting both thresholds to 0 in vmcb02, but very soon afterwards,
(after a first userspace VM exit), the shrink_ple_window was called
which would reset the pause_filter_count to the default value.

Thanks a lot to Suravee Suthikulpanit for debugging this!

Fixes: 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE")

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 16 ++++++----------
 arch/x86/kvm/svm/svm.c    |  4 ++--
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef0..f209c1ca540c9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -681,17 +681,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 				svm->pause_threshold_enabled ?
 				svm->nested.ctl.pause_filter_thresh : 0;
 
-	} else if (!vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
-		/* use host values when guest doesn't use them */
+	} else {
+		/* use host values otherwise */
 		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
 		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
-	} else {
-		/*
-		 * Intercept every PAUSE otherwise and
-		 * ignore both host and guest values
-		 */
-		vmcb02->control.pause_filter_count = 0;
-		vmcb02->control.pause_filter_thresh = 0;
 	}
 
 	nested_svm_transition_tlb_flush(vcpu);
@@ -951,8 +944,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	if (!kvm_pause_in_guest(vcpu->kvm) && vmcb02->control.pause_filter_count)
+	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
+		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
+
+	}
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b49337998ec9..aa7b387e0b7c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -909,7 +909,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+	if (kvm_pause_in_guest(vcpu->kvm))
 		return;
 
 	control->pause_filter_count = __grow_ple_window(old,
@@ -930,7 +930,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+	if (kvm_pause_in_guest(vcpu->kvm))
 		return;
 
 	control->pause_filter_count =
-- 
2.26.3

