Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEA744D98F
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhKKPxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:53:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234141AbhKKPxD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:53:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/aCpkr9XrbtSc9FkTH46CZ56peC6IEqHY/JjZCn98g=;
        b=R8hHmxH0Npg1tHGIEIjhNxzBIgbEX/FZSNmoWzOohhj8643WlT4CTaN9r6YbDKN7ynNCQt
        tz/QXsNBPKW5pqccjmxHgd6Edbv/Z5Hggsp9o8JnJgUu8fO1nGTI1sjC/m/pe+zXR/rRXm
        3018qy3N5fHhCxmwGbWgUHsR2SEzT9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-EkQ546-aPUGKuzfSwTecpQ-1; Thu, 11 Nov 2021 10:50:11 -0500
X-MC-Unique: EkQ546-aPUGKuzfSwTecpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E24CA40C3;
        Thu, 11 Nov 2021 15:50:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C42A35DEFB;
        Thu, 11 Nov 2021 15:49:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com,
        Marc Orr <marcorr@google.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/7] KVM: SEV: Add support for SEV-ES intra host migration
Date:   Thu, 11 Nov 2021 10:49:28 -0500
Message-Id: <20211111154930.3603189-6-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

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
Message-Id: <20211021174303.385706-4-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 48 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8b529022f0cf..f63f9156964f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1612,6 +1612,46 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
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
+		memcpy(&dst_svm->sev_es, &src_svm->sev_es, sizeof(src_svm->sev_es));
+		dst_svm->vmcb->control.ghcb_gpa = src_svm->vmcb->control.ghcb_gpa;
+		dst_svm->vmcb->control.vmsa_pa = src_svm->vmcb->control.vmsa_pa;
+		dst_vcpu->arch.guest_state_protected = true;
+
+		memset(&src_svm->sev_es, 0, sizeof(src_svm->sev_es));
+		src_svm->vmcb->control.ghcb_gpa = INVALID_PAGE;
+		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
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
@@ -1640,7 +1680,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+	if (!sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_source;
 	}
@@ -1660,10 +1700,16 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_dst_vcpu;
 
+	if (sev_es_guest(source_kvm)) {
+		ret = sev_es_migrate_from(kvm, source_kvm);
+		if (ret)
+			goto out_source_vcpu;
+	}
 	sev_migrate_from(dst_sev, src_sev);
 	kvm_vm_dead(source_kvm);
 	ret = 0;
 
+out_source_vcpu:
 	sev_unlock_vcpus_for_migration(source_kvm);
 out_dst_vcpu:
 	sev_unlock_vcpus_for_migration(kvm);
-- 
2.27.0


