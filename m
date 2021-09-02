Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3443FF2F2
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346877AbhIBSA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346712AbhIBSA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:00:56 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B1EC061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 10:59:58 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 13-20020ac8560d000000b0029f69548889so2561615qtr.3
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 10:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=bqDRLFptc44UKBzn+MUQ2EpaypVcZR2bwNWDPt0I16Q=;
        b=kaEccFS9pjl5QRSHoXDXY1chRXLliJunMfC8ysTZtjZQYrWwStlsNOwUkheC3Jp2hm
         CH3UfafyXH/qDnlYL8IVC+JpuEPO2i5AB5jNCQXcJeB8urA9jHxln9EqObsE4rXz93ax
         IWV1OnG4NREJl1tquHShvCB8n8NrBPZSUG0Q6yGPZV5/Q9TAKLyLmyeHowK88cHf7OWs
         M78P15F5prqVDgsit3mnGhiMhnAikVIgVaiMTJ6/rEGDNLt30vQwONVsgRvvteVrE6KE
         pi8TeZhhu510npjkeAa+JvKTH+D4hcutyaarAM1HLg87mkinZwPg5T2Nyqzy0PDtEDkt
         yAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=bqDRLFptc44UKBzn+MUQ2EpaypVcZR2bwNWDPt0I16Q=;
        b=SW1JwMLkunQxL+2rDUf1HSSfRYxFvD7BEOMqi+U8x/RjqudRYgZGm+8irWwB3NTFi0
         XtlS+WRX7u3d61f6J0SUz0NQTJPtpQmw9C566HrR+7Fr0q3tOeVnE2PZ7niqP7N2FnPL
         2tXhmI29IfpY93eb7Z6PCGccfEFyMIGtKPQsoecEm1SEtoRQCeehzOEeqoJ4W0aor7rP
         QTdJbY5F6hhXSua2yBARtr3KMcV1Qec3LR9etGErCDSGULAzH4PT3nytrQ4HCKr6BxDA
         q6dMGAMRRV65uqskuD6TYLnkloltDBb9DK5BUxGsBTGkQBh4sRzO7VRPUB5mmUXBI900
         UsjA==
X-Gm-Message-State: AOAM5333UVsv/22J7jqHErFjwS0SUbzPJA6BQ6aiJ/KTsDTISTMZqF89
        59EaNu/XloQttvTwg4UEbGhMOKh5bJE=
X-Google-Smtp-Source: ABdhPJy6UYCXSDa2mdpOqNlJ+avFm6Ebh49VwTf2qXLaAbHbfRK3+ddkKi3GmcUaXF9ydYJ9K88Lkbp+5+8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:1c7d:d8a5:f41a:8b31])
 (user=seanjc job=sendgmr) by 2002:a05:6214:592:: with SMTP id
 bx18mr4250805qvb.26.1630605597084; Thu, 02 Sep 2021 10:59:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  2 Sep 2021 10:59:51 -0700
Message-Id: <20210902175951.1387989-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH] KVM: Remove unnecessary export of kvm_{inc,dec}_notifier_count()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't export KVM's MMU notifier count helpers, under no circumstance
should any downstream module, including x86's vendor code, have a
legitimate reason to piggyback KVM's MMU notifier logic.  E.g in the x86
case, only KVM's MMU should be elevating the notifier count, and that
code is always built into the core kvm.ko module.

Fixes: edb298c663fc ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..140c7d311021 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -638,7 +638,6 @@ void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 			max(kvm->mmu_notifier_range_end, end);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
@@ -690,8 +689,6 @@ void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 	 */
 	kvm->mmu_notifier_count--;
 }
-EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
-
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
-- 
2.33.0.153.gba50c8fa24-goog

