Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693233FBDB0
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbhH3U6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbhH3U6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 16:58:19 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137B2C06175F
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:25 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e8-20020a05622a110800b0029ecbdc1b2aso1344978qty.12
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ijncrk8rUqsxi+KMQZrb7TMOV/czYWoHZiWYp38B42A=;
        b=diWrc1cigzn6KVGYpj15+fe4oHAsHOaDOHR/zD7GPnsOB2PLhom2HDOytth2iYFuSr
         6VEK6hihUN4yvm33+0HZLSL0blWmak52MNeuyx5ECn8mwGrczChNnaz3lKmks2UBHwjR
         4nvwgbXpFiSZjGGvRbo0/BwyJ7eOVSTHO/NXXS7aAJcEaeIJckfuz2Pjeb0atSDQHcAd
         sTG/HUlH+PYCPzK7bgFTfWbkCP7EQmgpuni+C5OeN0/zeIl1FpHfbJfi5WMzp3orqAbO
         /KUHfE93fPMbYDSUJMWkgj/5pxptUh7a3ZCNpztbMYwzwNVjXza3Ck6IfY+xSy+JEluT
         ITbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ijncrk8rUqsxi+KMQZrb7TMOV/czYWoHZiWYp38B42A=;
        b=qI9jnYzF6rCJRFURhLScQPsHtGucVUvyAE5rrs2314/4be2lL1ZYegbZhpGEIyjR54
         So1pBP0rNHiMgpIBK12o0vjAjpKxN+KEOJlTN9/Az7fa8/ICooogg3GLOIyALg0cgqrv
         NmZmLmH2zULhAaBAeoLc/dYSxqwLSV7KyHI0+ratu5KznNPeSPWzBlfuLmXiLumcgsQx
         dX3g5e4SNTNh+aX7zM7NJCppSVTqDipsWZi9ngJuIahwQejMME3/DFo+zh8Jau9OjfTD
         fTirDVXj3Yjpd7zZ/Be2Rv9gn843tvyc929GjwWGb6fZcNr2TYv1oyqEYCKJHZkbqGKd
         QbPg==
X-Gm-Message-State: AOAM532cyGEnfZtN5w+KzZ3TDZIKPIvX4InwpMDwhRA+s9fpWIkfEvvN
        ef75FlANzHZRCvUAIWO9wTQYvdNmvHC59W7LbwG89FppBQZ+5rB5Z2C2+2FWrW8cXCGsfOqLeaP
        +zteY5QEnqmgjCqp5mZG9ogxaFX47VDaf91TOBJnPqjjoWNjTTvL89sq9MA==
X-Google-Smtp-Source: ABdhPJwr/qupM/KV1lTNths63RBEx3WCz/61pTHw80lU811E3Ft+4wl8Tv63z8MNbNpXBp8llDs0t6oM1is=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:e552:6d5e:b69d:968c])
 (user=pgonda job=sendgmr) by 2002:a0c:bece:: with SMTP id f14mr25050382qvj.25.1630357044119;
 Mon, 30 Aug 2021 13:57:24 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:57:16 -0700
In-Reply-To: <20210830205717.3530483-1-pgonda@google.com>
Message-Id: <20210830205717.3530483-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210830205717.3530483-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 2/3 V6] KVM, SEV: Add support for SEV-ES intra host migration
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
 arch/x86/kvm/svm/sev.c | 62 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 063cf26528bc..3324eed1a39e 100644
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
@@ -1580,13 +1633,18 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
2.33.0.259.gc128427fd7-goog

