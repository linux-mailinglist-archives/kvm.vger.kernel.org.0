Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1370B2289B7
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgGUUS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 16:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730642AbgGUUSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 16:18:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F97C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s8so17063888pgs.9
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z39UGLiwUBksk1towyRmeqgzcjsEShuupZsYnYVL+Us=;
        b=rKegZBrTVX4xxVBEOTXScIQU9r+3I3UzVc+V5qfGJiX49ovdnLx+zRPQWSbOQmpBZn
         UO/CMvrtPRQ5fL2YzOiUu4vi25Q7sYzhnVx3VzY43tgtsLpFNKE5YW6w+Soj9jLfErYc
         Fc6ePt6Nf4ZtyIKZ1wB+upGHrqvO/blEpT/8weQp5ZMETdUL39bQVVClKuyfbs8+rGEi
         s+3gBD+rQGLZWAAQgJ/bYT7XLWiOBhCSuYUnSna4LXgAuOxYT3vaCOwg0BxTjHSbfVVE
         Cd9yWP+S8Ue3G+lXUuiNxVEktGkeASVbATxosrMuGEkBECLHGxGgtWQ1eoR2Trn44FZp
         VNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z39UGLiwUBksk1towyRmeqgzcjsEShuupZsYnYVL+Us=;
        b=s7wvz9qBfPOq4FwcHI2/rSq3ThIzht35AYpdIsQhYIEaIMsu9HuD4XSu4rmEvVUcUF
         QfIBN6ZqY+fOmakkSSPhiZr6IBras7cwp9i1gsWsW9rip5VEu0eIXQHISybb4+0Wgeyg
         ffTfq5T1ve+vFlmOW+qEitaeXp6p2glfjONDUDZV0xqp0HKOvJLwCT4JmYatyZC/ecd7
         5KAdjv+HYxi5SY4v5KcVN8fpGC1UVvhRC9kzzWRM95DSpFMPOVREEKKcJFUiX1Tp2rsk
         ySdPQdMmda01pZ9mRe4HZQdbcsyrK4CAUSxk2Wz01lC9vkFz0pDsrNZmxsdQeigl+Utu
         s4Cg==
X-Gm-Message-State: AOAM531lrjH1bUE2uJ7bsBrWR8dQEVe5hFDmvSPK+YYtnoBinAmA3ZZn
        IVfaWRKdvardGwtqzjPGBcvR8q7F48wsAnktuqzJFhXAxHIveatQSrE6F3HCNWm5UrDgfyXEIsq
        AD5DD+ZFS7wf1AoDeyLfM6pmZ0/MToQqCp85etoiK9hACNEMzfwze2Bz2Tg==
X-Google-Smtp-Source: ABdhPJzKvjyCQvoHdGEutI4GSzk1azjUN1XdrsE0h13RVid56En9AtsZcnMM0RfKF+0jlDwJFurMxOXQZK8=
X-Received: by 2002:a65:418b:: with SMTP id a11mr23531485pgq.399.1595362704856;
 Tue, 21 Jul 2020 13:18:24 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:18:12 +0000
In-Reply-To: <20200721201814.2340705-1-oupton@google.com>
Message-Id: <20200721201814.2340705-4-oupton@google.com>
Mime-Version: 1.0
References: <20200721201814.2340705-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v2 3/5] kvm: vmx: check tsc offsetting with nested_cpu_has()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b41d987b101..fa201010dbe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1775,7 +1775,7 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	 * to the newly set TSC to get L2's TSC.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
+	    nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING))
 		g_tsc_offset = vmcs12->tsc_offset;
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-- 
2.28.0.rc0.142.g3c755180ce-goog

