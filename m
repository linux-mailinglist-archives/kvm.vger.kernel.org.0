Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8039BEA5
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhFDR2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhFDR2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:28:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2CDC061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:26:32 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n22-20020a6372160000b0290220c022078cso2695624pgc.17
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FX10PQdLzDz16GdUbiM5sgnv+3jGZM7Tq2+dVV1y+FU=;
        b=oITuushgDMrGVmDQZkWx+majdGJ85wT6icbDWQMZtklgfjfrXrlUjCZBbRlFL2BTPa
         pcDmjrI6mgQIiLcl9OYKh5Jd6LRs4rIqI1xXAyBumiCLhP4AUGNU9qOGvnfqgTMVFW54
         QdLWKynUHl11q2IZTrKp3OEkBe2v+LNn1LvoZ1ht0whNUzYxzAwknRWv1gGiBt0ad1ct
         tkf3E9Xz1Oa4VMWkO+fNu3xCMAFnaHXdMdm2aT9h1YcgMxgSo2XgFj8a7UzImaAF2NTj
         cyuVPUZVZHtO4zeKD98AyS97iQiCQJcbD5bg4WKe98Zjnz64mEq2RWd+1bGVj3Mg0Tby
         IV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FX10PQdLzDz16GdUbiM5sgnv+3jGZM7Tq2+dVV1y+FU=;
        b=hdpA4gZsrxwoYZiNcgh9wc01gowICmE4VMjHpJr0y0oHOm5C74Hzv9eGnUqPfZCYNd
         bHhV8xXunmemTzffiGKCUc7WGxb8VnLAVkq1DpkKWo2qJXqmiWmU4XuQr5XNgmEUIB4U
         Ji6wi4OUlR+lJpBmvAX7zuh+AvXXtUu05ZSFw30O01is7mvzC+OLWunebVexMBm3ZIsm
         y7xkd0HDZwUeZHIFHVplNQ0Tw1dDGPNAfXnKLKXFkXgAmknJEJDGZAl1EpCgT5741F+o
         YqvhJ6JHk9+ayN69pxrHEbuouMmCPmK2EVQRk9dRFn+vhmBEdzd+sf72hcxwmqK7m3DH
         kbNw==
X-Gm-Message-State: AOAM5339jThSolqLD4ldpCAxx3P6GbxfoO3rbX8bUQJv6tAmVedf+vDe
        sUaib7CggmVvL7FkGk9+u16jct4AE2YhW9SDkj7iy7qBvMzmGq2ygNH1aBlJhzjwtQMsjADfZx+
        QxnZ/cAY2mw+pw58sJhj5h+92tjfS5xe1JlTC/bXNwuo7CKSpXtxrpObi66NPJqQ=
X-Google-Smtp-Source: ABdhPJwbGFq+vz1fxQkZjZ+qO5HhG/X/iQzGnGVVoEcSDTC2l+UiSXMm2sQH/frmb72TndXlY/wsY6Q13gOR0w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a62:1a49:0:b029:2eb:6de0:9890 with SMTP
 id a70-20020a621a490000b02902eb6de09890mr5394966pfa.39.1622827592354; Fri, 04
 Jun 2021 10:26:32 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:02 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-4-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 03/12] KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..7646e6e561ad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3682,7 +3682,7 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
+static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -3690,17 +3690,17 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	u16 status;
 
 	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
-		return;
+		return 0;
 
 	vmx->nested.pi_pending = false;
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
-		return;
+		return 0;
 
 	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
 	if (max_irr != 256) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
-			return;
+			return 0;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3713,6 +3713,7 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	}
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
+	return 0;
 }
 
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
@@ -3887,8 +3888,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 no_vmexit:
-	vmx_complete_nested_posted_interrupt(vcpu);
-	return 0;
+	return vmx_complete_nested_posted_interrupt(vcpu);
 }
 
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
-- 
2.32.0.rc1.229.g3e70b5a671-goog

