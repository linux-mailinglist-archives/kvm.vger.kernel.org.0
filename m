Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970C742AE2B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhJLUvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbhJLUvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 16:51:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AA0C061745
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r17-20020a17090a941100b001a06fd0be74so2250997pjo.3
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dfsL+iXBjUioFCqGNYlyj7PB9YeXysOPmz3Bz3RLVkk=;
        b=WZg1IIHC1aPm3BjNXTCiSg4SBOMMwKVRSe5LeWcOZ2FaZkRS9CbuoYJio/fFrXhQRv
         5MaPO4jsjCsYSVcJs9Ge7sq4vZjNx5aZatQWQVRgbXpGHLt+5A6o20iX7jDgrhhBboUp
         8xMcVzHN0UZ9KaFh5RHFRhCClh+2iuR64E0DkDdNZcJnfMmr7EWXCMXX3x6Hrhns7JDq
         JQ/pjsFqTm7G3ZSdMzYfnMEo1PqaSeeRfN2tgBvnTaKwDCiuKvgPqH/0xDtYFtaSpSqv
         dkcBNntJxE5GbXdxBhsG3IE79ufY7LegqaxMorJjHA7fLPQWbRPgz2ttaHNQCIOkj2DU
         jiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dfsL+iXBjUioFCqGNYlyj7PB9YeXysOPmz3Bz3RLVkk=;
        b=cHRvisTYFZXDt6IC2y1C8MJeSwPNNOpbGyM0c0SnVx7x7QtOMUlzDi5uFpueTkiJlG
         jNcRHqqDnSfiyLwfucyOZeGbMhME9t0x1xeH+WcScbRilZWXI/8Y12QvvAhKMKvU9Gxf
         7a3P6g/zRW5+sOBQ/Ao8ISz4sjqmNumwKXbCr4hc8SQEABqDn9/J0J0OesPfGKDVQcuX
         Z/kO4AA/RuZSPSRMaMjFP90O9ZVSB3wGKihLPfq9Y9ksptFVtD/0HkME+6Kqhttl9v8p
         qGw80nAvxNGeE9Nfoo2id5A0JYszu2NRRTvIyJrjR9qZT1DSZcJij/BYh9Os9Y9V0B6N
         9uqw==
X-Gm-Message-State: AOAM533vUaGU3Hxlq4SUjpfBTJxzI7aIplm8Dpuo/2sDOQxKNBANMaDg
        CAKPnrCDUUkXUa4r3+t2J1ZA+59Sev/9Ba1lKM8hikveMNBA9PvHuQ2YuBBOP6SPG57Mk/N4Ntd
        L/33R9RyjIL1O7hI3RF2r2aFuJmfme237OhG3wUnA4IvEJvikbKNvC4m3CQ==
X-Google-Smtp-Source: ABdhPJz0E0bRfj1GVgTeGXUQRLuRoq4yuzjInSQnGH+da8icoWg4zUtjwqYxPVcL9Y0xPGMqjbuV+qmL3zk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:bab5:e2c:2623:d2f8])
 (user=pgonda job=sendgmr) by 2002:a63:5956:: with SMTP id j22mr24424660pgm.58.1634071749373;
 Tue, 12 Oct 2021 13:49:09 -0700 (PDT)
Date:   Tue, 12 Oct 2021 13:48:56 -0700
In-Reply-To: <20211012204858.3614961-1-pgonda@google.com>
Message-Id: <20211012204858.3614961-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211012204858.3614961-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 3/5 V10] KVM: SEV: Add support for SEV-ES intra host migration
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
 arch/x86/kvm/svm/sev.c | 48 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 42ff1ccfe1dc..a486ab08a766 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1600,6 +1600,46 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
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
+		memcpy(&dst_svm->sev_es, &src_svm->sev_es,
+		       sizeof(dst_svm->sev_es));
+		dst_svm->vmcb->control.ghcb_gpa =
+				src_svm->vmcb->control.ghcb_gpa;
+		dst_svm->vmcb->control.vmsa_pa = __pa(dst_svm->sev_es.vmsa);
+		dst_vcpu->arch.guest_state_protected = true;
+		src_svm->vmcb->control.ghcb_gpa = 0;
+		src_svm->vmcb->control.vmsa_pa = 0;
+		src_vcpu->arch.guest_state_protected = false;
+	}
+	to_kvm_svm(src)->sev_info.es_active = false;
+
+	return 0;
+}
+
 int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
@@ -1628,7 +1668,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+	if (!sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_source;
 	}
@@ -1639,6 +1679,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
2.33.0.882.g93a45727a2-goog

