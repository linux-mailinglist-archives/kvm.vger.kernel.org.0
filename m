Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07C3C8847
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbhGNQEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbhGNQEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 12:04:52 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD9EC06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:00 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id y35-20020a0cb8a30000b0290270c2da88e8so1948715qvf.13
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ukpFEBQ3ZSOPfYZVcnUGmbU85zNXyRaZS2xqA85qNuA=;
        b=tRgSEEmo0V/Rf3S07YeK87hz/a7Vmc7RcBcly8NcC+QOXRreSc+UoWK/Lb6dVlLa/o
         QC9Tghk26QugyI6CBcHFoIaLvfmtJJV/YFO0EcG8ukxjDWSGtSf3LQTuPvHEsdQXAbgX
         qp4UFTGfO0usrnBkB2ikNwjiotoEc7XlpOd91bFRRr3zYJ/B0NOY6YSAXy6ZBm+DjWi4
         ktcNs/UEAWnPgYb0Dh7WIyjxUH00mKJwPV7J2sAHUSImQm6dAlnR6A1TZepBgHleefdd
         /741/8aAZIf1gI80zQ5+VOQRAZW9KmQLN6jr+ye7f4vq3sOYzuDZb/+o9bbKTUK4PtBV
         Iouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ukpFEBQ3ZSOPfYZVcnUGmbU85zNXyRaZS2xqA85qNuA=;
        b=FUFKb4Dx91hlDKz1LF5Ly+kJpxo/TpANixTVx4/bxdvK6Yz/ZxkVzy/Vyw6gzJjiVx
         0AnkcYQinWwSguPN6hUwDEyZrOq1xsIpyY6wpRmJG8yMDc27zAoGe9+MbSUf2XXCc1Gq
         IZwjsubph7GaSpnPYkXv/aV5BBUnQ7nrixFFA9m7tQA6DxRAcXkYjXnGwYhBElprv6y/
         rnVcG9wkX28H3eRr1W5Et16vHqp+HH4ikKj8JqmDXUtcmg1bthOmBF0siiO29whk5P09
         GuxU9qgNRx5fi/7LaBRGNiwxhYoFN+rQr+4pY9UavESccCQ8s9ouNUjKOegvJX6sP1IG
         zeFQ==
X-Gm-Message-State: AOAM533dmrksfrb6dEm/222TvnlhXKxof3kKNGlcJQgA6bL46Ax80Ld3
        +VZB2uNUEWWmUd53RdIhMtqQT/q5Ya0=
X-Google-Smtp-Source: ABdhPJy6lP52o8qVNiah756L56JiDKxfILhWmiDeBLW+a5hJESre4NIuFeuouILhaYGP5OsWibWZ0fS/f+Y=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:32d8:66d1:672:9aeb])
 (user=pgonda job=sendgmr) by 2002:a05:6214:1141:: with SMTP id
 b1mr11599789qvt.2.1626278519429; Wed, 14 Jul 2021 09:01:59 -0700 (PDT)
Date:   Wed, 14 Jul 2021 09:01:41 -0700
In-Reply-To: <20210714160143.2116583-1-pgonda@google.com>
Message-Id: <20210714160143.2116583-2-pgonda@google.com>
Mime-Version: 1.0
References: <20210714160143.2116583-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 1/3 V2] KVM, SEV: Refactor out function for unregistering
 encrypted regions
From:   Peter Gonda <pgonda@google.com>
To:     pgonda@google.com
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
index 8d36f0c73071..78fea9c4048d 100644
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
2.32.0.93.g670b81a890-goog

