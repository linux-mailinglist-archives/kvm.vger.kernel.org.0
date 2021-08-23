Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337353F4E58
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhHWQ2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhHWQ2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 12:28:51 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3B2C061757
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:28:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c2-20020a17090a558200b001873dcb7f09so1794095pji.7
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WhC88oeHU3q8AoHfgipLtOjjmR8hfUdN/cT1NWJmJsQ=;
        b=GZAvK1dNq1drjpMCj7HE9gJqJ+V4FJmIlRvoUMhRe1e34vROEQbT4Ks6SsuLIzVdOp
         6BwlUICnhTk85R1B9jJEA2SuX6YxkLJJk5x1UJQ98Xta7xMNEafmyoJ+HPcIWm7VFQZ3
         cLI4MqYGfh80rBmNFCtc0fBq6VyOpb9yiltEv//SnYOpbSJtRy4cYywyDDOhNb9IIStO
         ow5TfMQlpjaPVlbXuDrK8/keV9wSY7+f9ApnhBUuaoxipnChS8C5NsPKs3fo/UlVkjnk
         c81wQ8sPt98qIj8VkjCspQigFMW6XDdQ4Dr8uTE6aPVGeIqcOD4PVOJcELH3WzWFmm9G
         JJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WhC88oeHU3q8AoHfgipLtOjjmR8hfUdN/cT1NWJmJsQ=;
        b=uPZLNPa6RaI58p2pneCQgskETa3EGDD1OXo6RTCacYyLnY7XxPZH7EeDBXmf0FPo5u
         nOZBszLGKXRXw1w5Zywi4NhcANAxod2aeAR+Q1CQaZAxCuS5tAqr2J6grJ+nGAC8dccW
         F0qU1q1/ES5nQpH+jOJvSL6g2bFNu59x6kUWNYnbRhxHINr/hxYEnhvCBWOUDF5Os/pJ
         3+c68GEAhsiKzmD4t6YXHjGVnQW/96l6Pa3oZsRbW3Wwpe04KZU69fhwTPlmAKH/+CpW
         Du9FG30dCDO+msX+JvAo5rXNYRq8p9qtKM22z5QGgmGPihf+4dxiIoBTWe+4IrGaQk94
         jVfw==
X-Gm-Message-State: AOAM531E2OdWuIGk1BID1r4uCy3gNntxP6LH5+KXqkGwmn9G9ialIHuJ
        vZSZrfQ7W8lCSgOwOc2dXRH83NaHJEvPdsxFcm8yuxl/BGr/q4PLSQjRxMaN335sPepLHeNVF7I
        SX/BiQwsDA9ljtmkkFC8lNKL5rpFsZPvv6S8Mj4HcFbU12EJs08eK/3gdRQ==
X-Google-Smtp-Source: ABdhPJyBs+jEUCFKL7VEGjwfU6TLP9g5jRBkYqJZCFbXF3pZZsHRRle3ZhBKr7oQssBUkoSIjSDaz56HcJ4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:672c:389d:3532:4d07])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1703:b0:3e9:568e:d13 with SMTP id
 h3-20020a056a00170300b003e9568e0d13mr19652068pfc.60.1629736087698; Mon, 23
 Aug 2021 09:28:07 -0700 (PDT)
Date:   Mon, 23 Aug 2021 09:27:56 -0700
In-Reply-To: <20210823162756.2686856-1-pgonda@google.com>
Message-Id: <20210823162756.2686856-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210823162756.2686856-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/2 V5] KVM, SEV: Add support for SEV-ES intra host migration
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
index 3467e18d63e0..f17bdf5ce723 100644
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
2.33.0.rc2.250.ged5fa647cd-goog

