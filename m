Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D521040B536
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhINQsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhINQsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:48:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FF2C061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id v33-20020a634821000000b002530e4cca7bso9747391pga.10
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+f6h/X5NIPeStfEfpLAEhC/0Xz4xmxvZvD1XBnS1esg=;
        b=s25ZrxmcmGz46Jr/zJj31XUIp6vh8x7CNYXs1W93DsaANB2p8yRydA+24LZeQNFtkP
         xwi+cF9htLs/1Mi9F/lNEjN/NbjKL3Kg48DEehxiqSXRdRtVSQt9IMRV4GlaRjgUJiLd
         aoaFfwGW4Uow2Aeq0vLzTw2ariB9L/A0jcuMCvCiHTwf/b0Ii/FXnBtJMvZt1rP9ypUr
         9B3ra/OvJvoV1MvCeVLMxComyVq4xizkGgboFdUsMidwkkf/+LAr2690ulJUthiAnSi3
         EZMSWLVrV8WXdnk8EB8OtqNmblBn2dl8b0cMBhJQbYiLPixKfZEUVQoh4y11FBh45Vv4
         Qf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+f6h/X5NIPeStfEfpLAEhC/0Xz4xmxvZvD1XBnS1esg=;
        b=Ph+5ifGhC456BVI2gXbckazHB9E5KAWuQHqb9Q3JeN5eDmCkjFpPuWlSUaw6HeKE08
         zOJGW9sdaCVeIEiwjaa4/PN55VzlHFDcDkLASjQm27B1GT7FlCJWqAkCT5+FcZ5otvWK
         vp4+NIn5pCQi7zScm9II/4ViJvF9APyIiybGr6EldvUjB7t12LTKchfnMB3oF2iPZjHb
         R+3ja6mENXSB6k0L+h45+9gJwiyYn0pzOhg6CWMq5QUfP51Qf2GS7T4Pd6msBPufAcOv
         UseupuxYmOH23jeqlhzMpOBqRdOoIgs+zKXRRBhy4M9QqhRc1ETTeFtkkpJOAOOVLlTQ
         6prQ==
X-Gm-Message-State: AOAM532hfpyKKUKunpLPB/Bv3aZj4TSQ7Me4V5sV+BmFIvxQNo4TKr6O
        LieO3bg7DWjiokvJdD7W58k2F/3V9LkZdeooCjIWT8lUQ9xvI0Ra6rY/Xcb4dIXjkkV2HYvfTgE
        0CzbLNRoyvkEDzFHKIi6myDbVpALgL/bW6ZpEKDDR8dqIoAvicDk7tQkOSw==
X-Google-Smtp-Source: ABdhPJzZdUmAjq2qpiKWaPaTfraahyGuLzQkf5BwelS0V9pdtJrpNa3evbK01Roh94MqN1qrMQcTGXhElIs=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a17:90b:4a84:: with SMTP id
 lp4mr3205571pjb.34.1631638054604; Tue, 14 Sep 2021 09:47:34 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:47:25 -0700
In-Reply-To: <20210914164727.3007031-1-pgonda@google.com>
Message-Id: <20210914164727.3007031-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 2/4 V8] KVM: SEV: Add support for SEV-ES intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
and other SEV-ES info needs to be preserved along with the guest's
memory.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 53 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6fc1935b52ea..321b55654f36 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1576,6 +1576,51 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	list_replace_init(&src->regions_list, &dst->regions_list);
 }
 
+static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
+{
+	int i;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
+
+	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		if (!src_vcpu->arch.guest_state_protected)
+			return -EINVAL;
+	}
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		src_svm = to_svm(src_vcpu);
+		dst_vcpu = dst->vcpus[i];
+		dst_vcpu = kvm_get_vcpu(dst, i);
+		dst_svm = to_svm(dst_vcpu);
+
+		/*
+		 * Transfer VMSA and GHCB state to the destination.  Nullify and
+		 * clear source fields as appropriate, the state now belongs to
+		 * the destination.
+		 */
+		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
+		dst_svm->vmsa = src_svm->vmsa;
+		src_svm->vmsa = NULL;
+		dst_svm->ghcb = src_svm->ghcb;
+		src_svm->ghcb = NULL;
+		dst_svm->vmcb->control.ghcb_gpa = src_svm->vmcb->control.ghcb_gpa;
+		dst_svm->ghcb_sa = src_svm->ghcb_sa;
+		src_svm->ghcb_sa = NULL;
+		dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
+		src_svm->ghcb_sa_len = 0;
+		dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
+		src_svm->ghcb_sa_sync = false;
+		dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
+		src_svm->ghcb_sa_free = false;
+	}
+	to_kvm_svm(src)->sev_info.es_active = false;
+
+	return 0;
+}
+
 int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
@@ -1604,7 +1649,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+	if (!sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_source;
 	}
@@ -1615,6 +1660,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_source_vcpu;
 
+	if (sev_es_guest(source_kvm)) {
+		ret = sev_es_migrate_from(kvm, source_kvm);
+		if (ret)
+			goto out_source_vcpu;
+	}
+
 	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
 	kvm_for_each_vcpu (i, vcpu, source_kvm) {
 		kvm_vcpu_reset(vcpu, /* init_event= */ false);
-- 
2.33.0.309.g3052b89438-goog

