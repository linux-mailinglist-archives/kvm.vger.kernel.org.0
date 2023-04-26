Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5771D6EF942
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbjDZRX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbjDZRXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6167EC5
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f809d82bcso122041677b3.1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529821; x=1685121821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5E+1UOWpL+AfX1+rGKOtk5ZumAdjQAQKEF7axS8xo4=;
        b=Wj9XFsqKOddsg4HDEScVJUxhOr6cWyMaPJQ6rceo994394ELkxjrjepso+p0yVp3C4
         hiu6ze6O06yivIChmjRSX8e+B8pjKZ4r1xOdnMkSj/611fTzKxEbLsAvhmFCccw7bRIH
         JTcF7Jy1EtKHhbrzVhAE6OpZ6IbPwINbiqWtWzzr1Fx6NoRjRjzKmaN3D4O/nQrGG4AQ
         xl6s/Ebx/xQgfeF8iZ45V1mf77QPxNMzSdDpczM1oRrTImJ59KGj+vR0RsWBVBpJk1xE
         R9297RjkGEomevnGCLBsl4SP972lEW8k+O8hJTmG4zyYMozKxQkPXapMRthwKLTIrIpT
         OuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529821; x=1685121821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5E+1UOWpL+AfX1+rGKOtk5ZumAdjQAQKEF7axS8xo4=;
        b=hRoMwVmgE1pbpm+O2uyuIjaCFLzlQPjRaEzO9PJM/OJ3g+sKHrxliMLAk2mavrVoAg
         +aPCt2UqwLsphfW7UbgAfrxJbN8D7w1v5mdpGQkMkZ9RB4Aom6pVtFTjBqPbNBTdDzPv
         u045YSFiX+LmY0Ts4nsrOEiHbcRPc2oeFGcpapv3a7TdoykSCsz394CXHoNNLA/IDkyB
         8qJolknKKV+W9/kMM8aL0EfEX5CXOFTqxmAh5ZXWjpQAjbmo47RTDHc7HBAhcpF8ljmo
         8kOXV98cW0Q+Xxt1cC6thuGlhfuZkJ9oEqNQ9fKd9QVFObWsnOULkBM4oo4Xi7BlqGDV
         2ihA==
X-Gm-Message-State: AAQBX9cjJ2OJRW1eLjW/s/x9jaeZPt06nocD6ECuW2MkKBDemckbWOO5
        8uaUsDI6Z9SpqPOkXkG4neu+8uEyUtehAA==
X-Google-Smtp-Source: AKy350bezvJQfog2IuPSMkxMJh5aDYfQ2UQnblmT8iIVAx9nNCAtI9OwiRI30wC13EnWSvKLaj4uGzpO4dCuXQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:451d:0:b0:54e:e490:d190 with SMTP id
 s29-20020a81451d000000b0054ee490d190mr10565253ywa.4.1682529820860; Wed, 26
 Apr 2023 10:23:40 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:22 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-5-ricarkol@google.com>
Subject: [PATCH v8 04/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
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

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0ec..c6fa634f236d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -990,6 +990,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331e..58074ecd346c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4596,7 +4596,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
@@ -4609,6 +4609,7 @@ static bool kvm_are_all_memslots_empty(struct kvm *kvm)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(kvm_are_all_memslots_empty);
 
 static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 					   struct kvm_enable_cap *cap)
-- 
2.40.1.495.gc816e09b53d-goog

