Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEDF720755
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbjFBQUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbjFBQT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8339EB4
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba81b37d9d2so2987106276.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722795; x=1688314795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T0ZSDe8DD8qgI+hQ5GGVvv9DPX/fmVUfBiQgPPJDyag=;
        b=vzJ5lp+Vvxh5jgKhw4N3EcLYc1sep3oLnDwHDo3WNGxsANVN3K2Y57xncwkwdrOMCh
         i4n0KN8JOThqQKrkpUO4MjVbeS1RMll4Wj+avp5CHRp0CGn8OW03nv1WghwIhH5UVq1R
         ZIdzdtwGxC8lQWqlnKlZQZVLnSqARx01dNWEozCh8mOBFxG8V4bAASFDGF8VpRWFYirU
         hOylusUj7TlapbQaFTvt8CaoWxdJc6/bdR+rOtl8p2+i8eshKIxhVRO0NxUDFCj4lXfu
         aa2PP0YKK2lzhCaiv40NVdFju/t300IW1AfunNPwbGnLXjpO2AD/s1zqYlQKcfazo/5B
         8LaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722795; x=1688314795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0ZSDe8DD8qgI+hQ5GGVvv9DPX/fmVUfBiQgPPJDyag=;
        b=FDt02P1ATc7zw5drACBlOf2rS/+WDUv2CTvj7PIs3LbEXRIzYdD82hrGVr1NgGpC3K
         oa9kf1leUhlP5RYqRbOM/F3mflTO/hs7kTIdy6xD+w/UN95wesQjZEDYczQEIRJWBpNY
         3SxudjTGwc5mj20osMpQZAlMFWsPswPGh5PfS38bs03M44kobpkmxOPxptO1gVk1Rttn
         m71ookFIHYRJe4NPc9Jp2sHqf0RbcbPtZLnhx4TSQhTVwcFuzfuLkVTPJk8yPBIX3TVk
         BGxwfOsOkChq663tMEqgdh5eK8nj0hC748rrCdMKrV5kqOeeoLcG0SGLtz+zUnBrusGj
         37Dg==
X-Gm-Message-State: AC+VfDxhPDqFTSX434oCTqhyu6EW6J/OCKIjFcyrm1Q/6T8v9O43jMp7
        CDyWpGssbfrhDd6WohaHmmuTFRcSZiLX5g==
X-Google-Smtp-Source: ACHHUZ5Sfp52rrqZwc5OSKpraZQwO+GGnki/y+5vdhdc6/KeATsrubLSu85itYYdA99ZGshYC27a5L0PInmD1w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:4049:0:b0:bac:faf4:78fd with SMTP id
 n70-20020a254049000000b00bacfaf478fdmr1207331yba.7.1685722794830; Fri, 02 Jun
 2023 09:19:54 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:10 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-6-amoorthy@google.com>
Subject: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
kvm_vcpu_write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9c0fa7c907f..ea27a8178f1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3090,8 +3090,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 /*
  * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ * If 'vcpu' is non-null, then may fill its run struct for a
+ * KVM_EXIT_MEMORY_FAULT on uaccess failure.
  */
-static int __kvm_write_guest_page(struct kvm *kvm,
+static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
@@ -3102,8 +3104,13 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
+	if (r) {
+		if (vcpu)
+			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
+						 len,
+						 KVM_MEMORY_FAULT_FLAG_WRITE);
 		return -EFAULT;
+	}
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
@@ -3113,7 +3120,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -3121,8 +3128,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
+				      offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

