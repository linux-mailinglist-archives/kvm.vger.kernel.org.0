Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432403F1D49
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbhHSPt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbhHSPty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 11:49:54 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE7C06175F
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 08:49:18 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 21-20020a370815000000b003d5a81a4d12so4462696qki.3
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 08:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=myQLUZfPFyoLW9vf+KurBFHMgK8OiRnb6RGJ/OtP1/w=;
        b=MQ9Oy18irGDThhqOabn8oQL7DPlYC2XtPkgGEaD1iqW3OV1ZMN1m27KQ3VTiy7ZPhf
         Ondjw+0YVNNVDyW8HVJe7qyFRdoN+1jO2o831JOotc+0da3/ruh8Z/JF9f7a/87+U5mu
         j4sBVzZwVwwTzODByn+eMlzwTNh1SzIZeISezb+JL4ErSUiW8G8BCJaeH26X/f/n3aMm
         hw1Kg6eFKWbdbDhB4f9mqW1ged68ft8Y9lIkvbJWhLKGqn0GBbVk4TPGnIlNRAPNuuQN
         5X7Rxfwd49BSBz2UyNqDpmCfiw2SqNwR7QoS+ZurDE73UQ1ga0fAzBMxPGI6cQRkADLu
         OxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=myQLUZfPFyoLW9vf+KurBFHMgK8OiRnb6RGJ/OtP1/w=;
        b=e67dr41Vw9EvClD4Wgi+DqNcaO46u4nyGSvj4cTstI0OlQbZmXCahAyrLy756j9MFK
         fUcJ2XR84ZlgHlmDP6zF8+I3cRxrkIbgCPxwpczeqOETJmID7HMRigaS3sOdhVlYBzZQ
         inSsmiJTjqeaqHA/dCsyT+8mgQfLbJLldS6SIVPhQnkZ/tTFWWMUWeAwOPDhlPXL+z/d
         i0p1RX4zB7VAZs7C6N1JKaoypJ2JKfwFy5ptnuc9iaUW1femO9MX1elnVzwZUnORRxvL
         bObkCuz4M5BRpflHp0vHN8J12O4Ly9fhNRbIcFmPqAQe9Rxw7qAaRuSI0gLiimYPdquk
         uVUA==
X-Gm-Message-State: AOAM530KIPtdVISSbNIc5x8Mp+il2dI7VP9e2SUgW0sE4Bp90wxBKgX4
        zChdFJBAB17rMLI833vTLG9gmWng8C+hoa7Vgaz+KmytvNEOA799BrFwGCDzLJFK2FiyyGYEW9M
        ryPvlmWFrqdqOPxSaWoPyHkDyDtdYuZbD4t4UOljFhh2IC/LTzrO+wni4xg==
X-Google-Smtp-Source: ABdhPJwgcTWvBZSJEp8qhdfgtVSd6RA9MwxWgU4vFyNxDrWi4cTASVGtw7ZPuvq5dQ3AOpQERREdUMwhA+Q=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:6cf4:9d41:7258:8536])
 (user=pgonda job=sendgmr) by 2002:ad4:522c:: with SMTP id r12mr15083699qvq.17.1629388157651;
 Thu, 19 Aug 2021 08:49:17 -0700 (PDT)
Date:   Thu, 19 Aug 2021 08:49:10 -0700
In-Reply-To: <20210819154910.1064090-1-pgonda@google.com>
Message-Id: <20210819154910.1064090-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 2/2 V4] KVM, SEV: Add support for SEV-ES intra host migration
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
 arch/x86/kvm/svm/sev.c | 58 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2d98b56b6f8c..970d75c34e9a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1554,6 +1554,53 @@ static void migrate_info_from(struct kvm_sev_info *dst,
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
+		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
+		dst_svm->vmsa = src_svm->vmsa;
+		src_svm->vmsa = NULL;
+		dst_svm->ghcb = src_svm->ghcb;
+		src_svm->ghcb = NULL;
+		dst_svm->vmcb->control.ghcb_gpa =
+				src_svm->vmcb->control.ghcb_gpa;
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
@@ -1565,7 +1612,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		return ret;
 
-	if (!sev_guest(kvm) || sev_es_guest(kvm)) {
+	if (!sev_guest(kvm)) {
 		ret = -EINVAL;
 		pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
 		goto out_unlock;
@@ -1589,15 +1636,20 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
-        ret = 0;
+	ret = 0;
 
 out_source:
 	svm_unlock_after_migration(source_kvm);
-- 
2.33.0.rc1.237.g0d66db33f3-goog

