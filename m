Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00105546F5B
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 23:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350671AbiFJVlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 17:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347712AbiFJVlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 17:41:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAFD28E05
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:41:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z67-20020a254c46000000b0065cd3d2e67eso386921yba.7
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=QRwkxD449IEvVBU53Os0OsTpTWGeUKY9nEsyApnDNxM=;
        b=nG+8NxDyG19Tn+MrYth0pBt/LayA+JxKX+6WS3zpT+O+3YAMOvWuawWbEYrhk13k5C
         58Pi/we6J/OQ/TxF5WaXH1dL99nO/kdd90JJMPgqyvNy9Dv9geElEaa6r+QNrk9hwY19
         HqkZz5y+0i8GB+m3uYAUaBj0DjvBGe9/Xu8uUu7nRkhkVqM8R/dNI3L7tOatAs7OHr8G
         j4EC6PI6OtfU7mg5fqw1NQZD3jZ+Zi/Hw+qv6pTP7J+2VYBupMtKkzxCthX1HtFKvyI2
         D+rj/Z7le29/zpPhdPcn/MFBNHvpWMd7tl/EME0oszHoRmb1qq3G3/+nHgzOSMORco+m
         6s3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=QRwkxD449IEvVBU53Os0OsTpTWGeUKY9nEsyApnDNxM=;
        b=evFnFJeeuObH0hkRvVDNcA0Z+SNNclTHcflheT4B8mtHtRVDQdJkhv/qMbvt8JMUzO
         MCn8t55WOrSPDs+Z3Cn5i29d8dCO6FWwlxAodmWVvAwKf3Db8w7p/JNx5nQIId8xVkSe
         BuhlVoVoZtnG211OsjtVLZPA0Zbm5wY/4+W5WUAdYkNwP+00Aw/CxTQ8ZV71bBn8hiXe
         oQSOlyDiOAAkjafDDTw8iHfD2k5EOTpCFyG7J/iEfdx8rNkV5woVzuHOcmguP0T3hcaf
         w0ZQqCa8AXV74jreYvwf4u3eYKE2jl2FTAI+cyJW5KteKSddgAiQhUSGR/Pf4NOuGIQf
         ZzTg==
X-Gm-Message-State: AOAM531LXeSoEVVfs2RdEoZ7VhbBj7YpXTznFec+/4eS6GS3oixxlBmj
        yJWUp93lMk1GRnMEr1EZujk64I7RzBo=
X-Google-Smtp-Source: ABdhPJzLIGA/VY1p3SL4QfQ3gCm4vTKkKl9Vj/IqUInmjiEG02PjbI7nYTb8eVmDLxi5oZoZApEfHcaYC5U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:21d7:0:b0:313:76ac:4aa6 with SMTP id
 h206-20020a8121d7000000b0031376ac4aa6mr16296719ywh.423.1654897302541; Fri, 10
 Jun 2022 14:41:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Jun 2022 21:41:40 +0000
Message-Id: <20220610214140.612025-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] KVM: VMX: Skip filter updates for MSRs that KVM is already intercepting
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
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

When handling userspace MSR filter updates, recompute interception for
possible passthrough MSRs if and only if KVM wants to disabled
interception.  If KVM wants to intercept accesses, i.e. the associated
bit is set in vmx->shadow_msr_intercept, then there's no need to set the
intercept again as KVM will intercept the MSR regardless of userspace's
wants.

No functional change intended, the call to vmx_enable_intercept_for_msr()
really is just a gigantic nop.

Suggested-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..61962f3c4b28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3981,17 +3981,21 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	u32 i;
 
 	/*
-	 * Set intercept permissions for all potentially passed through MSRs
-	 * again. They will automatically get filtered through the MSR filter,
-	 * so we are back in sync after this.
+	 * Redo intercept permissions for MSRs that KVM is passing through to
+	 * the guest.  Disabling interception will check the new MSR filter and
+	 * ensure that KVM enables interception if usersepace wants to filter
+	 * the MSR.  MSRs that KVM is already intercepting don't need to be
+	 * refreshed since KVM is going to intercept them regardless of what
+	 * userspace wants.
 	 */
 	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
 		u32 msr = vmx_possible_passthrough_msrs[i];
-		bool read = test_bit(i, vmx->shadow_msr_intercept.read);
-		bool write = test_bit(i, vmx->shadow_msr_intercept.write);
 
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, read);
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, write);
+		if (!test_bit(i, vmx->shadow_msr_intercept.read))
+			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
+
+		if (!test_bit(i, vmx->shadow_msr_intercept.write))
+			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
 	}
 
 	pt_update_intercept_for_msr(vcpu);

base-commit: f38fdc2d315b8876ea2faa50cfb3481262e15abf
-- 
2.36.1.476.g0c4daa206d-goog

