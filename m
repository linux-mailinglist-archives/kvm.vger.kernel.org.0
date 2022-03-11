Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B914D58E0
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346047AbiCKD3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbiCKD3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:16 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08925EB165
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:14 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id v4-20020a63f844000000b003745fd0919aso4037629pgj.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TaKt6ifyDzw/4EryDJ6FgrsRqPfcQSEjNzKUlhOKYgc=;
        b=VM3IB77PwQXDPJ+CJqIHXpNdbm9e9A+2RGayeURR9qEVsFtUrJu8x6Q1sHq0zKOg+H
         8qaQxoqBCu5B1x4cKhKKh8uUHYwgnUZ0UKw2udJyW8wF/X7MAYGmJRfKOPBDGLt3RUsQ
         astlSKoCaHhl22x7MHgPVfpS5rG++nqHbu123QMA+U7F9T2gLysLWQaDSBnTKxfPN1RG
         PV/HZnNod0kDqiv41DDpbDAY1bTBpz2awvS9iBkbRBK8a+vZrWazkYSkHaDcI7ytfm08
         3KFUJL9w/0tQOQO3Si1Suy7vjmyaJg/0YCSUnHra0krGe86JwME1vmpBfNfSHztH8WRw
         0obw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TaKt6ifyDzw/4EryDJ6FgrsRqPfcQSEjNzKUlhOKYgc=;
        b=TquUhcnA0CQXceqfbNWlt7xiqLdHigTwILmQyBiUyag/2ZFSL79EKuyQinYqUmWs94
         sMRSJjOZDPEeLGA0q7CP0ngNJYHlavjd9bhC9+FK1THPz2OkVgJfFdtGreZob5vVh10Q
         ZbHwn4pGpjBVkUnijuANwLVYLK82YVKHH9GFfz945c+n8kQOCzWG+1Y4wtaQaJcVOjeS
         MsCTV14J3OKvD6ULGZOMWIrwiNVx2Pzb4MdCe+BLuj2w+j4FslhEFJFiqh0LtKMfP1HR
         dhCByKWl0xxWGMy+MZeyBuA4UMWsqiY1MHXrlFTXVlRMH6XoPsqN3w2ajId+yXAUWC09
         XBhw==
X-Gm-Message-State: AOAM530Xh/5tpN5krZsN36vggk2/Dt3knpIGPwh9uJVP9/ojfFN/vsMi
        JBpRkNj36JyiQI5L3HuzW6FJbtzugDg=
X-Google-Smtp-Source: ABdhPJw9uw91OP2dgONl+pA11JFBwf4ErEh3CpHGCkwniEzo2MTQ+Ypg+e93ikqW+nHeZ0HzLL4bfkXdUbQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b4a:b0:1bf:83d:6805 with SMTP id
 mi10-20020a17090b4b4a00b001bf083d6805mr20091923pjb.174.1646969293511; Thu, 10
 Mar 2022 19:28:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:46 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 06/21] KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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
---
 arch/x86/kvm/vmx/nested.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 298a58eaac32..53ac6ebb3b3b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3918,15 +3918,17 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
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
2.35.1.723.g4982287a31-goog

