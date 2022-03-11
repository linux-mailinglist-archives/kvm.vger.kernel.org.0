Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3A4D58FD
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346164AbiCKD3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346097AbiCKD3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:42 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1453ECC72
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:20 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a23-20020aa794b7000000b004f6a3ac7a87so4410793pfl.23
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AcJat6mfsYesUxiLsf097aJKwH7FBxsnrZltNc4YjNY=;
        b=UXgtWo/oc9ev1snc+o3QfD26We+3IV17jR3vHN8gwuLYsncQj9wSpNhPG4zDoDm6FR
         0M6Ggegix0R7PfGseTLt4fXluy6idQUfX/jT0o4n4tsmfmYuQlZvTAgm0403CBs2Cw10
         JRge3iUCXhNB8WaXwGbUjsal9IXUpKK3OGwysKxKjjxSZlOX4u+NUdswylh44YA884eN
         UabTfHqHkJR00Qle96v6J0+oSg5XIRMLQJYe7lDb/p6WhEZuhRye5XAd4XnD/qbrgm6J
         iK+rAKNBGq/vsUUx5YcqadXCx2nT48ExD00+fCAtpEf9YmwIeyqmSJzBBzozMeEMjxIx
         YxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AcJat6mfsYesUxiLsf097aJKwH7FBxsnrZltNc4YjNY=;
        b=Y9x9MPOL/GTRvDnN+D0m9EKjqhzIEqwscOiiYTbwaH+kknuh24t5/JlR6v/MAMR4gc
         aqCnczy/nwzs2FnptJqvoI+3bnUhmTfPH35dBw9ef/RcbOXFnxiJgW06HCP9/85USO2B
         YwsifxKk6tEqbVBsKaPFMtIbWL8ijNee+v0YxnXuJOd6bIZVFXwG8AO1e8rqsH1s3Z22
         Yo30ZPdeTQptUvNmGd/IneYzFoUrvMT+RuPBrhknupbf/jgS9Hin3G6LMLW4SwIkNngH
         JpKv5B/cRnwZ2VMYuYD1Pe4KgdMUgfjXERtHAI4trgbY4Mwrws11IIDhCTZsUVU5jF72
         C/Hw==
X-Gm-Message-State: AOAM532VmUAq1RdIA2vdDS4dEvOYb2f4NcKn8th0Q22Qajl5drkFtGmt
        gzd3xlkzO7RrprvuyQLYsXG1oKfBucY=
X-Google-Smtp-Source: ABdhPJyliGAu6H5Nz54834Q3GV0caw3GdOFbWEVZpIm/9XuBICxNCnAsmjPKoCEANi2gYwoHf39zGnEdCGs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c42:b0:1bf:c572:cc45 with SMTP id
 np2-20020a17090b4c4200b001bfc572cc45mr8597614pjb.238.1646969300408; Thu, 10
 Mar 2022 19:28:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:50 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 10/21] KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
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

Clear mtf_pending on nested VM-Exit instead of handling the clear on a
case-by-case basis in vmx_check_nested_events().  The pending MTF should
never survive nested VM-Exit, as it is a property of KVM's run of the
current L2, i.e. should never affect the next L2 run by L1.  In practice,
this is likely a nop as getting to L1 with nested_run_pending is
impossible, and KVM doesn't correctly handle morphing a pending exception
that occurs on a prior injected exception (need for re-injected exception
being the other case where MTF isn't cleared).  However, KVM will
hopefully soon correctly deal with a pending exception on top of an
injected exception.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b22089ebfe76..82b2d9dde611 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3884,16 +3884,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
-	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/*
-	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
-	 * this state is discarded.
-	 */
-	if (!block_nested_events)
-		vmx->nested.mtf_pending = false;
-
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3902,6 +3894,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
 			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+
+		/* MTF is discarded if the vCPU is in WFS. */
+		vmx->nested.mtf_pending = false;
 		return 0;
 	}
 
@@ -3939,7 +3934,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (mtf_pending) {
+	if (vmx->nested.mtf_pending) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
@@ -4532,6 +4527,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
+	/* Pending MTF traps are discarded on VM-Exit. */
+	vmx->nested.mtf_pending = false;
+
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-- 
2.35.1.723.g4982287a31-goog

