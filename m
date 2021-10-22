Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D784B436F0A
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhJVAwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhJVAv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:51:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B23C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d6-20020a63d646000000b00268d368ead8so974295pgj.6
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8siHIAryW00e1Nv7PaQKAACob4qQGJPm4xGVUggbE3c=;
        b=hN5DFB6YfJIJHp17H0JZwemRBmfrZcuCT1FHOgndUbd8f4CDvPIp5Z1bEYUW+73+En
         8TxtKvTnv46dRXzCNfMtSKhkLwSbuY+F8ilrvMjK7u9Yn5Qfn5/4nRzUdlQn9lLnOlN8
         oBCswuwsC8lbSIrXMQZCYh7FOWtfza3RcvlmyL04UOxlQmQHmUkDKSvCiAV4Hkc56GQF
         SKPBoHXBdl28weI1ngARkXlT1/Z8yQFFgHKfin9ShzyYc0S7FQFcB/Y+aVGD6gTwtWQx
         Su2yS0y3eyz4zusNWDNjW1eUEwIZ3kmDEG8w5RqTihm8CjbdpCJaa1SAWNcIcNB3Pgw8
         peFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8siHIAryW00e1Nv7PaQKAACob4qQGJPm4xGVUggbE3c=;
        b=kFbPLFirw63CgGH8HpjxOFVzIm3jSE9042qV178qlYVJhEuUUv2WlXQLkAf4Exu1V7
         KBY/EGedw1NqSExYl9WcrwbWS4XwPuyYt70z4xnoigF+tIA37VnqO+Tb+r9D623KV7iP
         /GvEAX7SHbJoS5yDsozX85NZ3kConowR1o15z1gwLLueu3EhDDjOKjoW46Rdj+ZORrR9
         Cn6n+mku8XAe3A+842YK8xJnf3UaT6AC20vuH1p9Aaeh4TwBFD3K+fiJPv6t+obScgvY
         FJYXJW7UpQEqBg2o0R6V1AWsAtwS7O3Gb2IXiPccyXoxg2IZejx+EUIbCy7v/C9FVKJ/
         krcQ==
X-Gm-Message-State: AOAM533H2vr5zttwsUOwvAY35p90+bZUW+KHDJl/bjV4pZhiDLRkCL2f
        If6SPqCQwI3n9NX9NLz96grwslgVdKk=
X-Google-Smtp-Source: ABdhPJxtLIbxslammZt27IR+Yt0z1dSiEt0eiclINPCR4oHIJaVuWzOoA+n1+0Uq8KT5fTgQrLSDgy3MM8U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c09:: with SMTP id
 oc9mr10629140pjb.33.1634863779155; Thu, 21 Oct 2021 17:49:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:49:27 -0700
In-Reply-To: <20211022004927.1448382-1-seanjc@google.com>
Message-Id: <20211022004927.1448382-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211022004927.1448382-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 4/4] KVM: x86: Use rw_semaphore for APICv lock to allow
 vCPU parallelism
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a rw_semaphore instead of a mutex to coordinate APICv updates so that
vCPUs responding to requests can take the lock for read and run in
parallel.  Using a mutex forces serialization of vCPUs even though
kvm_vcpu_update_apicv() only touches data local to that vCPU or is
protected by a different lock, e.g. SVM's ir_list_lock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  4 ++--
 arch/x86/kvm/x86.c              | 12 +++++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f64eef86391d..b61c03cda2b4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,7 +1070,7 @@ struct kvm_arch {
 	atomic_t apic_map_dirty;
 
 	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
-	struct mutex apicv_update_lock;
+	struct rw_semaphore apicv_update_lock;
 
 	bool apic_access_memslot_enabled;
 	unsigned long apicv_inhibit_reasons;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6f11cda2bfa4..4f15c0165c05 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -112,7 +112,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	if (!!auto_eoi_old == !!auto_eoi_new)
 		return;
 
-	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
+	down_write(&vcpu->kvm->arch.apicv_update_lock);
 
 	if (auto_eoi_new)
 		hv->synic_auto_eoi_used++;
@@ -123,7 +123,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				   !hv->synic_auto_eoi_used,
 				   APICV_INHIBIT_REASON_HYPERV);
 
-	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
+	up_write(&vcpu->kvm->arch.apicv_update_lock);
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03103b69e8a6..77f6dc3aa4ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8742,7 +8742,7 @@ EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
 static void kvm_apicv_init(struct kvm *kvm)
 {
-	mutex_init(&kvm->arch.apicv_update_lock);
+	init_rwsem(&kvm->arch.apicv_update_lock);
 
 	if (enable_apicv)
 		clear_bit(APICV_INHIBIT_REASON_DISABLE,
@@ -9402,7 +9402,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
+	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
 	activate = kvm_apicv_activated(vcpu->kvm);
 	if (apic->apicv_active == activate)
@@ -9422,7 +9422,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
-	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
+	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
@@ -9430,6 +9430,8 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
 	unsigned long old, new;
 
+	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
+
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
 	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
 		return;
@@ -9468,9 +9470,9 @@ EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
 
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	mutex_lock(&kvm->arch.apicv_update_lock);
+	down_write(&kvm->arch.apicv_update_lock);
 	__kvm_request_apicv_update(kvm, activate, bit);
-	mutex_unlock(&kvm->arch.apicv_update_lock);
+	up_write(&kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.33.0.1079.g6e70778dc9-goog

