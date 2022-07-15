Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF99576851
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiGOUmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiGOUmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9B88779
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31c858e18c8so47581827b3.4
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2CpovJeuRnY71/3WEgYmV3X/+gVqaILzwsGk5qWsmbA=;
        b=CI5eECRw/t2ePq8ve65FTKwSt2kIadrOWUlem3pEqQJDu81Pg2YyoetNf/oE+wfKBI
         UopyVVysF5uDMiduXGfWDIsKiN681CnG7/byuCseClaFFcQPW3p95aVCFGIVS1ULgrCs
         7aXGdyzg370hIHpG0szNsdCGYhpSpQTYSjpfj71Op7j34ZFd1rrrRj8cAt3PMY2cbPvQ
         7/nz/FyNlR6H0s28BBsGTnTeDI4R1cr+Lah0stzc4xzATBps+Pi0XHt/f9v19j4VuHyJ
         KApSjR7vZvCa9W5704VMuvdfGieZTRsWJslq5P3cRavi8JekmKcnqbVbBGyw2urJcNan
         VqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2CpovJeuRnY71/3WEgYmV3X/+gVqaILzwsGk5qWsmbA=;
        b=B0RMH6SxG2K2H32HmG4ax3bO4Do6maGCPVxYc6V53p/L5y+ZyWIdzBqZyg7TzEZ2Fd
         7MFHw1pWuQlZ/oYP+9sirNBYFv9r8KjH7qTmBy04RzbDwM3HeLBuDh5Vyoe5XcfMdYwA
         61+43THYmtScQFPl/DMmkvs0vryBzuNzQKfSG6AZA1Syt8FRuk0Y4smXfnXxdnhnZUnM
         JwJVT+SyzddDeLNkKfh3D9+sBk3WPqh3ONJj7uJDkSShFWAPieStrfbebFnIokSBQ3c6
         DX0bO1xIXNcUlFuenKifcXQVpzp4YxDxxZ+zWxfwLaAIIhjWApHb1/gC6t0u9VYlPUYp
         5O4g==
X-Gm-Message-State: AJIora8u2sAKHRx5z5kVjjep7xGu4gUkcSZxkwyTYJcjesfS2W1iO782
        GGDXUCtruwdX3+f1LoiEeUde/5Qaxbw=
X-Google-Smtp-Source: AGRyM1s2ivCNo7cPKGrdosGL9wj+UwFqiTQrrkTdpFKnHi8+Ltkg+XTbhNDuxIbZcmpxoP5i6PdO0lvFIHQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:66f:193f:edf with SMTP id
 v3-20020a056902108300b0066f193f0edfmr15543284ybu.281.1657917762733; Fri, 15
 Jul 2022 13:42:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:07 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 05/24] KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor
 Trap Flag
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Service TSS T-flag #DBs prior to pending MTFs, as such #DBs are higher
priority than MTF.  KVM itself doesn't emulate TSS #DBs, and any such
exceptions injected from L1 will be handled by hardware (or morphed to
a fault-like exception if injection fails), but theoretically userspace
could pend a TSS T-flag #DB in conjunction with a pending MTF.

Note, there's no known use case this fixes, it's purely to be technically
correct with respect to Intel's SDM.

Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2409ed8dbc71..bc5759f82a3f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3932,15 +3932,17 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * Process any exceptions that are not debug traps before MTF.
+	 * Process exceptions that are higher priority than Monitor Trap Flag:
+	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
+	 * could theoretically come in from userspace), and ICEBP (INT1).
 	 *
 	 * Note that only a pending nested run can block a pending exception.
 	 * Otherwise an injected NMI/interrupt should either be
 	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
 	 * while delivering the pending exception.
 	 */
-
-	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.exception.pending &&
+	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.37.0.170.g444d1eabd0-goog

