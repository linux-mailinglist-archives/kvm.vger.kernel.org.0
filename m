Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5013FF31F
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbhIBSTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346941AbhIBSTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:19:03 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1E6C061764
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:18:05 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x19-20020a05620a099300b003f64d79cbbaso3199274qkx.7
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Aypxzqpu+vAXywZbUjl25jIypyUHDmFPudaxL3Vq6PQ=;
        b=vce/MUghP+vYh+QLW6k3+QnOLQW/MB2oJAGR8yg0OKACE7PEo71nmDMMmTXkNQGacG
         P7FCH4T9jYiBa8jKNXdz47tSxkrJT2ErWnqtY+jQp+lHjDvxZz5K1pHbHWfj3D+q7iNi
         vaYKpjqfuXeUeC9MyVnZovjAVb2iBLS3A03eCj/Q95m+00myydBD1bhjlSyl4lIIZik5
         wf7Aw/gi+vhUT2SiJjyak2p5cIEuPt6NW5ggvGsDww7RUMuFUump1yxECmkRZD7xykPc
         sRwY5BlzzR9ntWOO1spKOloAnTxVo6R/qaYj4qyzUkA3fU9qMkJGfVGhIkTotye2IwW1
         bMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Aypxzqpu+vAXywZbUjl25jIypyUHDmFPudaxL3Vq6PQ=;
        b=TcMbNGdOgSrE7xgZ2URJ03sQdpszkS9cLt9Cp1Vfyh5359XVVnbX+6FRPqzQGGzPQL
         rB9DNPKv3n5y/OBEt3dIUORLliaagmehcYlSm4cK2ufUfJXiN7QCMPa3g6OVLqVkGbSz
         D/s7hixq+6A64bhAwisoAYwaeesRHk8BTt2q++BJPyTtKa0wJ4EDiYH/py2i82RqbFwl
         1M+AJl0PuN8UXF2Tfy+rwJotgxR44Y1muvrn7ggt9yrWEpfVMBXbhHHwhpelUKYVA4uM
         oIzyBdXkgHQ1jVkC001aYvNW9LqzNBn9cZ+1OcfvDo9c8Z49dOWeh/7enX/MpfPFBRh0
         Hi9Q==
X-Gm-Message-State: AOAM531yF+FkFIStsYWAvbE5RnNzb9DO5wrVDbQixX+UB5KU2PAkpA4I
        +kOCKW+0kf4+KwHI1mOFr/19BzRk7ujrxLzlGzq8JkH4jiXWRfBJoDjx7Ly5o5BItLp2P5HDllG
        D9KABeBVScWEM5rSw/mRKa+FxkuC62cDHstkFG/ASsUaFNn5hsyh06NYD+w==
X-Google-Smtp-Source: ABdhPJzR7VRGWNqmYMbLRu0dq4MxHDaTDzW2bon4oUBr6TdUM/HV0/M2zoGiz+SKN8srKQ0n3y+BsoPpfQ4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:faf4:6e40:7b4e:999f])
 (user=pgonda job=sendgmr) by 2002:a0c:c490:: with SMTP id u16mr4540564qvi.26.1630606684120;
 Thu, 02 Sep 2021 11:18:04 -0700 (PDT)
Date:   Thu,  2 Sep 2021 11:17:50 -0700
In-Reply-To: <20210902181751.252227-1-pgonda@google.com>
Message-Id: <20210902181751.252227-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/3 V7] KVM, SEV: Add support for SEV-ES intra host migration
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
 arch/x86/kvm/svm/sev.c | 62 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8db666a362d4..fac21a82e4de 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1545,6 +1545,59 @@ static void migrate_info_from(struct kvm_sev_info *dst,
 	list_replace_init(&src->regions_list, &dst->regions_list);
 }
 
+static int migrate_vmsa_from(struct kvm *dst, struct kvm *src)
+{
+	int i, num_vcpus;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
+
+	num_vcpus = atomic_read(&dst->online_vcpus);
+	if (num_vcpus != atomic_read(&src->online_vcpus)) {
+		pr_warn_ratelimited(
+			"Source and target VMs must have same number of vCPUs.\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_vcpus; ++i) {
+		src_vcpu = src->vcpus[i];
+		if (!src_vcpu->arch.guest_state_protected) {
+			pr_warn_ratelimited(
+				"Source ES VM vCPUs must have protected state.\n");
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < num_vcpus; ++i) {
+		src_vcpu = src->vcpus[i];
+		src_svm = to_svm(src_vcpu);
+		dst_vcpu = dst->vcpus[i];
+		dst_svm = to_svm(dst_vcpu);
+
+		/*
+		 * Copy VMSA and GHCB fields from the source to the destination.
+		 * Clear them on the source to prevent the VM running and
+		 * changing the state of the VMSA/GHCB unexpectedly.
+		 */
+		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
+		dst_svm->vmsa = src_svm->vmsa;
+		src_svm->vmsa = NULL;
+		dst_svm->ghcb = src_svm->ghcb;
+		src_svm->ghcb = NULL;
+		dst_svm->vmcb->control.ghcb_gpa =
+				src_svm->vmcb->control.ghcb_gpa;
+		src_svm->vmcb->control.ghcb_gpa = 0;
+		dst_svm->ghcb_sa = src_svm->ghcb_sa;
+		src_svm->ghcb_sa = NULL;
+		dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
+		src_svm->ghcb_sa_len = 0;
+		dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
+		src_svm->ghcb_sa_sync = false;
+		dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
+		src_svm->ghcb_sa_free = false;
+	}
+	return 0;
+}
+
 int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
@@ -1556,7 +1609,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		return ret;
 
-	if (!sev_guest(kvm) || sev_es_guest(kvm)) {
+	if (!sev_guest(kvm)) {
 		ret = -EINVAL;
 		pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
 		goto out_unlock;
@@ -1582,13 +1635,18 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+	if (!sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		pr_warn_ratelimited(
 			"Source VM must be SEV enabled to migrate from.\n");
 		goto out_source;
 	}
 
+	if (sev_es_guest(kvm)) {
+		ret = migrate_vmsa_from(kvm, source_kvm);
+		if (ret)
+			goto out_source;
+	}
 	migrate_info_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
 	ret = 0;
 
-- 
2.33.0.153.gba50c8fa24-goog

