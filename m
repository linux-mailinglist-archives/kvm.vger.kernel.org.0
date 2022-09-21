Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABA15C00E4
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiIUPPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiIUPPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640188B2DE
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:35 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p4-20020a17090a348400b00202c6d79591so3074152pjb.0
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=q5FKg/0mjl2aM9VJREiLwHODyTQ+5pF2aj7ZjIqUAHY=;
        b=Ssvgf4FDEYaHaJdCcu92Ij3z3iz7n+1aVw4iavl9umcDPdXM/QMZV+teK6mm77l2qQ
         v+g6MMQlpHwBJ0KEsT9Uc/87HOdNr5rKVogMTvm08WAlIcj+eBHv84GoDT2MtkdvOkvg
         wVEYTwGnRWCC55acaHZYh4ku0AjqS+Gu7YgGzMiPkOEiUyooddyUL5h+OPXwyBMbygvZ
         CEg/t+yteX7ARNNlgaFICg0UHd/z/+zWB/BbW/rZfXU1weEn37d95OmYKwaIMoMYY8to
         t2YaMVIbSu3MRY1fH2yBTuoAKIGiK30OXc9l8gJF2bwVELn/M2DO3pJYmjNmape8/Ace
         qaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=q5FKg/0mjl2aM9VJREiLwHODyTQ+5pF2aj7ZjIqUAHY=;
        b=c30baLWviUf2QlXjZ4R1w9CBxk8WijtyURTxsdKTz6u+Ak+AnuSKMtXAvConkbx5tQ
         NIx7dTBx+tEhCMHZDPvQ4k4Ux7csFGPCVBH5UpfA7MnshmJNexni2xae0Bh1JI/TxK7/
         0xwt4sENFeUuKlB/xEdWpw/xCDxwClhtcoTufuubjMONmcfi/xxg+/gxdZr/MtxvLgoj
         bw7gPpyg1Qx05xzATtmIvHVd/j0yQOMVscAJNHif1PdY7BmQrR0jcmHsoVGdYOsmsmzq
         QoSc/fs/IjJNvu1/Yu5OTBPc27LELzaR1xC+hEZXdD2OSHx/3XizmquMJ7J3VsJa1pFF
         ZyHQ==
X-Gm-Message-State: ACrzQf2MvNbeLI9+/j7gRyDTqiHtgNZZbOnfQ4V90TIV1me5jhIhVT21
        XJfw9ovYx4C2K3l7ESLsemVc7vmOCoNMOI9fvrRN7yZnV5phV++DzDUcJRUpg6WIBNNaiXyRqe1
        TLjkaiC817K2coJNtNfnK4bii7D4L8iENx05eYiusDNl2hroCCFLE6qdCYDwh41nPOzA4
X-Google-Smtp-Source: AMsMyM7xo/g+PQl0HBmi0CCdOQ3m448tWSTW5q2DyTKTzxb1YGZ3gUl3M3xPNYJS4Wt06iI3OBIPVbKQDVoBLYgg
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP
 id p10-20020a17090b010a00b002002849235fmr771305pjz.1.1663773334225; Wed, 21
 Sep 2022 08:15:34 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:23 +0000
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220921151525.904162-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-4-aaronlewis@google.com>
Subject: [PATCH v4 3/5] KVM: x86: Add a VALID_MASK for the flag in kvm_msr_filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the mask KVM_MSR_FILTER_VALID_MASK for the flag in the struct
kvm_msr_filter.  This makes it easier to introduce new flags in the
future.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 73ad693aa653..ae4324674c49 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -226,6 +226,7 @@ struct kvm_msr_filter {
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
 #endif
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 852614246825..670ae38f8f3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6397,7 +6397,7 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
-	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+	if (filter.flags & ~KVM_MSR_FILTER_VALID_MASK)
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
-- 
2.37.3.968.ga6b4b080e4-goog

