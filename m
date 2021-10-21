Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089404369A1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhJURsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhJURrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:47:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DC5C061220
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:13 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f6-20020a17090a654600b0019e585e8f6fso253456pjs.9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t2TzXOzaxxpB1r0axVc03dmlkYGdQb1MoD9TI8b+FpM=;
        b=Lo4R0SIABnEKWtPLq3zmyvItjcnNmf/4BPykBWra/2dkYB3e+NId5kGorRp0rczI6M
         mgIzD2od3iMK2q88PR3bqZTZcKEVkUtK2tNIYbnwzDN7GY7/QKh6j+DgGOiVCpIiOmzn
         bK7seoyUeH75t0Absc4uTTWajK6C4RBcVshkC2REIJI1Xuf5U9Gx1FZoXJkzSgUdmM5n
         fdpS5RYFrJvhsHJ8gYxhgi+wA7WG5OKmvwHzbTi+ZnZez0tURyNF/XtS4+tIMAw5Dfat
         Al/LIxYCuenBwX+366tziLIzUp2oC96pUCrX/2G4jPQPYA+SnR0Sni28dPpXRY+wi9mp
         Y1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t2TzXOzaxxpB1r0axVc03dmlkYGdQb1MoD9TI8b+FpM=;
        b=WQywPZYhORKH4pXCocx/kfE4sFy81WpY7APAsATUVfSw6u9NFVLT8mS011oRdzxhlk
         8bWFiafFF/GRkZ8qCTiUfMgkRZWjod9SnKhVdw2QiUEoLbW5rFqffccSCCiWXEDA0P+9
         jzlbjxRm+9kiSpEJZklkahdBbNPr/g3/Om1bwyeZ+jVxUInj5G7SJe1jv0AyJ6OZQAui
         Jve6i3dgubD3CSGEt6QJo5fbFOuoY7MO6KD/xubvV9jgK/7O7LFFDXxBkDW7LlAOU+Y9
         17NNJYU/qBpq00sgTxSibyE6/K1U/LqWHDTUc308GQDpKMjbE64I34ViRSzYTlMWqwR9
         3BAg==
X-Gm-Message-State: AOAM530z0DXQBqeVvkZ1hxxbRxquEtc4gX3blDR9vVeI1eO1z0hHhhKX
        t0lras8DzTwr0BzJomf8MRtwODavRH1DjFnKwJSOvqdlFKCvFitCYNu+wjOlHRhdr4SKje0MRDh
        Stf3Q5axImtmiW46nWFZJn8Du2Qv2waM7cz3QXVp1Wm3z1WOwm9OiIwYJjQ==
X-Google-Smtp-Source: ABdhPJyKu1IrLXYtMhCOvmWuA/oOS6a+AMa/auEXa/DRWAj0G/mrPitEW+F7jwqvW9Yg5J61KK7WJWKj1aw=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:da2d:dcb2:6:add9])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:9a2:b0:44c:b979:afe3 with SMTP id
 u34-20020a056a0009a200b0044cb979afe3mr6941216pfg.61.1634838192336; Thu, 21
 Oct 2021 10:43:12 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:43:01 -0700
In-Reply-To: <20211021174303.385706-1-pgonda@google.com>
Message-Id: <20211021174303.385706-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211021174303.385706-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH V11 3/5] KVM: SEV: Add support for SEV-ES intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Cc: Tom Lendacky <thomas.lendacky@amd.com>
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
 arch/x86/kvm/svm/sev.c | 50 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2c2f724c9096..d8ce93fd1129 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1605,6 +1605,48 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
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
+		dst_vcpu = kvm_get_vcpu(dst, i);
+		dst_svm = to_svm(dst_vcpu);
+
+		/*
+		 * Transfer VMSA and GHCB state to the destination.  Nullify and
+		 * clear source fields as appropriate, the state now belongs to
+		 * the destination.
+		 */
+		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
+		dst_svm->sev_es = src_svm->sev_es;
+		dst_svm->vmcb->control.ghcb_gpa =
+			src_svm->vmcb->control.ghcb_gpa;
+		dst_svm->vmcb->control.vmsa_pa = __pa(dst_svm->sev_es.vmsa);
+		dst_vcpu->arch.guest_state_protected = true;
+
+		memset(&src_svm->sev_es, 0, sizeof(src_svm->sev_es));
+		src_svm->vmcb->control.ghcb_gpa = 0;
+		src_svm->vmcb->control.vmsa_pa = 0;
+		src_vcpu->arch.guest_state_protected = false;
+	}
+	to_kvm_svm(src)->sev_info.es_active = false;
+	to_kvm_svm(dst)->sev_info.es_active = true;
+
+	return 0;
+}
+
 int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
@@ -1633,7 +1675,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+	if (!sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_source;
 	}
@@ -1644,6 +1686,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
2.33.0.1079.g6e70778dc9-goog

