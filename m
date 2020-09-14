Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093226852B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 08:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgING4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 02:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgING4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 02:56:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8495C06174A;
        Sun, 13 Sep 2020 23:56:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v196so11928673pfc.1;
        Sun, 13 Sep 2020 23:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SNAtT/7LYD5SCZCVb8HK7FrqwZpKd7aSBFmTnXlZfF8=;
        b=iTmA1RwGEKhqrwJIhpyQHf2zlosnkt2ZbfSnljTQECHiuIqQ7d6/lvqMHbReo3CkbW
         TNkM1CfV2IW1w1FvbZyWY6JZRDMZCLLPDB6k5c9bFHX+b72qcDMYua1fyqUrSRCspe91
         S94VF8dRaozBaJjBkuQesHS4TWOsoWmAwy4gcAGGRDqf2rFXy8MLSbQ5D9CuDt76IG9C
         7/yIBAUdRry/F6nLZeQZUkz0Z/I4fauXOmomXLQY4N1Ep2xjiglEDIpBSVxIFetJryb6
         Plt1dJ7WrXIjbPk3nqLEmA2ShZ9zwGuSZwNmOleHBC63/6EHi9j/UFCRR2Wv+OKosLcl
         lpLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SNAtT/7LYD5SCZCVb8HK7FrqwZpKd7aSBFmTnXlZfF8=;
        b=qdnIdL6hm7OUAZnYI7iA2NKLzfEfVqFIXjoUVGt6vfE3Uy65iBcUcLijkvS+sgiTAn
         dL+J2X9ResSJ6EvvPdA9JrbFx2YHnMY5ojI8VdHtjm/HIkvzJUFYYtBTwvV0cEOQW9rU
         +hhLEOz+KCfkskC4W5E1zlsd4OyfYvwiIsoKopqNGnPrZgUlLsjTfK+XjyO5+RwZzvxR
         Qe/miEaRFM4ROAtv2ybN6+DK+q7mpl80BUCgsvaw04yglerylTXJ/LC7gH0CdyWGYAp4
         2tl3rtDivgjOzZmzydEiStDiwonNmQvVa8wKvgBWWyDoxKXqh9dZFvZED23T7r8yR3FL
         c5LQ==
X-Gm-Message-State: AOAM532yDL6kbHEMXCjO3LmOeHUAScmpK94i/XkljtqlXnRSR3fmSbcN
        fn3W1MC9fdmKjrA8el6jUT998bIn4qM=
X-Google-Smtp-Source: ABdhPJxgIfKdBiY8KoK5z/OxRVNQcszhxv0ghYoIp/yRS4i8N7G3nOOysCt95Pf1by6Sfe6OweJhTw==
X-Received: by 2002:aa7:9f99:0:b029:13e:d13d:a134 with SMTP id z25-20020aa79f990000b029013ed13da134mr12287868pfr.28.1600066562216;
        Sun, 13 Sep 2020 23:56:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id p29sm7245400pgl.34.2020.09.13.23.55.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 23:56:01 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
Date:   Mon, 14 Sep 2020 14:55:48 +0800
Message-Id: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Analyze is_guest_mode() in svm_vcpu_run() instead of svm_exit_handlers_fastpath()
in conformity with VMX version.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3da5b2f..009035a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3393,8 +3393,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu) &&
-	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
 	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
@@ -3580,6 +3579,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_handle_mce(svm);
 
 	svm_complete_interrupts(svm);
+
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 	return exit_fastpath;
 }
-- 
2.7.4

