Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567CE2642EF
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgIJJyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgIJJvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDB9C061756;
        Thu, 10 Sep 2020 02:51:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so3969021pgl.4;
        Thu, 10 Sep 2020 02:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8zHqH3bYwOpt/fl66BhVTKbXCR1yhQYjhkRrfj5pdDI=;
        b=VjRprMti9hsYYvaafHw5p2Qte8v6onDPZtBdKHdHzzAIdAWJyU1+vcqBU2Puvh1cf+
         jdX3EO8F9KxV/y+7+raQO+rn3uOOIWvCGTT7A0kJ+i9+gRg1om9GA8ryjQSbIy+uAjJ9
         0McDaMrYmxLWIPn8nASuSXlwV0BzTly/jtB2K+x8PwpW+f4tJ26XHenPLEQZ/hdyIvLC
         BFD7LRxq0MS7jyt9fmoVyjG0yNw+zvDaaq63LGmFSlozXwoMIhJhjN8nbf9IybycEOIH
         81IxGLMlDxCglfwFvPfmpgApFm8Rn5AJdVVwJQMIM8UiMOyvuthBI/ZwePTxdb+9zTr1
         0Kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8zHqH3bYwOpt/fl66BhVTKbXCR1yhQYjhkRrfj5pdDI=;
        b=RMfJXYLdC8sAHQiQm1wJNV797r4cg+tg/npGNhsVzZcCTrUDPk7IPS0Vij4ZcLIKxB
         zhD0WP8vXGPOf2F0UhzH6sMGhChqr+LPR7Kd5tO9zlz4M1oz/lt+y2b/TSS6pEOr96Ed
         Gm9nMA6IqmoIvs2shxZO14S6Tj/mEQiNWqnTO9G3tziNSIe8QOUY4cUuBID1PlgnT+vZ
         2NhIx9yCniiUisZ9VAbS/iSBd9dQmgIsP74vo55C7HlC3NPd2s5YkqA3UhpOCJYBW8hS
         GV5S4aNxBB6sIja5lzXNFXiS5faXKCmIGj8GHHHM0/M0EegVBDKB9yOZlsz1AAcqJEUY
         KSKg==
X-Gm-Message-State: AOAM533BifNXw/0tOU7elk2iAsHNNMEuIl/zh5p40T2ryW2GWUf6x3tD
        EdU9k1hrPIp5J+v4z90GC1b6riwqkTA=
X-Google-Smtp-Source: ABdhPJy+Kw9FZXlSZos28NS770cn0ADEa/un0w+Jc2NoI8ezE6vme1iy/APwXHxMLocPXxAm0Xba5A==
X-Received: by 2002:aa7:8f0b:0:b029:13e:d13d:a0fb with SMTP id x11-20020aa78f0b0000b029013ed13da0fbmr4566622pfr.23.1599731479685;
        Thu, 10 Sep 2020 02:51:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:19 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: [PATCH v2 8/9] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
Date:   Thu, 10 Sep 2020 17:50:43 +0800
Message-Id: <1599731444-3525-9-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Moving svm_complete_interrupts() into svm_vcpu_run() which can align VMX
and SVM with respect to completing interrupts.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c61bc3b..dafc14d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
 
-	svm_complete_interrupts(svm);
-
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
@@ -3530,6 +3528,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
 
+	svm_complete_interrupts(svm);
 	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
 }
-- 
2.7.4

