Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7FD3D67B0
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 21:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhGZTJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 15:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhGZTJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 15:09:55 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C5C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:23 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x12-20020a05620a14acb02903b8f9d28c19so9813250qkj.23
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=knMJJ87eko5EeIiU5PeBUCHHjZaqbhQNRmla83IZQH4=;
        b=n4znNVinxqDctXyi2lU7C8it/qXicNjkwibziXmmXL+JvD1gAUed5izs3EC8p9gfBE
         D5tKBIKg5s1GMbZS/ENJxs4fWvlEvwp91u4pBfxIkLoWUdjktAtJHnfp7OuKXWcAVfYv
         ZWTFuBTx/KYBkudumOB6JCgxqVIJaqy7hfbzsjZpoO9Du0s9CwLY9aAAPFquxvfWRCvq
         1yD4rVO9j9nebyggTtqEbPs/cq8S6zEGIQR2v4/3LKfjSCY5mnP7mzbRDkgQneRkrpdw
         kGCcrdC52fnJSARpl7O66o41BOIIhznrjMxITCCNcWpIgSqXSXqI223qITwi+QMVtQsg
         bCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=knMJJ87eko5EeIiU5PeBUCHHjZaqbhQNRmla83IZQH4=;
        b=JlktF6DDrXbMSazCRbasQeekqqlEoXkHXeCoPYWpRc9jFsEBLj3yjR0AcLD/oBq2Au
         +Rq4HvhtLsVyabZKKFJx74mpzlvkzKjagYCwUX8SzSt34FFt6Qkx98JAePWGybNDUfvh
         oiHWhAX85JNdQ/sH28+ja0mta52BQPUmcFVSHT3liynBEB79CNt4F/XcUDhbBVsRJg9w
         BlYj6v26sQkz0GcutD2AgcjoRqJjzi2lHFaYGWWg2DZ0IclyvIZ8iYn33WzPi7HQwvME
         sOIZtN97KFWsfc7g4njvLlMR6X5XS3c0uITNL/ZdqsuiEKAkVQvVpSSjPADTBGRicsxR
         brsw==
X-Gm-Message-State: AOAM530tBFSH4W/it2hqj8694lnOz41qym4zXOetPRVgVeZvw1Hh8WIe
        kfsbd4FYfzgqXZ8oIohMMxlIu3dQBUlpU2Fh3OhLW0Xu11tSfWI0d0ruj7jnp3GBMlovd20Z30c
        q5rtpuFJsv8o/DcrkZb9Af30DeTsugDV7YoFDpFDTJpe8gVpV+vnefU6ppQ==
X-Google-Smtp-Source: ABdhPJzLoA47/pLUshXDPOXJFfi6sZ3KV4LD+sfEu6W/hksSIqTNhS9h5igguBuE1wOQWxmwz3ZWhCrn2cA=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:f4a:330f:115:e2d4])
 (user=pgonda job=sendgmr) by 2002:a05:6214:262f:: with SMTP id
 gv15mr19281552qvb.36.1627329022739; Mon, 26 Jul 2021 12:50:22 -0700 (PDT)
Date:   Mon, 26 Jul 2021 12:50:13 -0700
In-Reply-To: <20210726195015.2106033-1-pgonda@google.com>
Message-Id: <20210726195015.2106033-2-pgonda@google.com>
Mime-Version: 1.0
References: <20210726195015.2106033-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 1/3 V3] KVM, SEV: Refactor out function for unregistering
 encrypted regions
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
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

Factor out helper function for freeing the encrypted region list.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Marc Orr <marcorr@google.com>
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
 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b59c464bcdfa..6cb61d36fd5e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1775,11 +1775,25 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static void unregister_enc_regions(struct kvm *kvm,
+					    struct list_head *mem_regions)
+{
+	struct enc_region *pos, *q;
+
+	lockdep_assert_held(&kvm->lock);
+
+	if (list_empty(mem_regions))
+		return;
+
+	list_for_each_entry_safe(pos, q, mem_regions, list) {
+		__unregister_enc_region_locked(kvm, pos);
+		cond_resched();
+	}
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
-	struct list_head *pos, *q;
 
 	if (!sev_guest(kvm))
 		return;
@@ -1803,13 +1817,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	 * if userspace was terminated before unregistering the memory regions
 	 * then lets unpin all the registered memory.
 	 */
-	if (!list_empty(head)) {
-		list_for_each_safe(pos, q, head) {
-			__unregister_enc_region_locked(kvm,
-				list_entry(pos, struct enc_region, list));
-			cond_resched();
-		}
-	}
+	unregister_enc_regions(kvm, &sev->regions_list);
 
 	mutex_unlock(&kvm->lock);
 
-- 
2.32.0.432.gabb21c7263-goog

