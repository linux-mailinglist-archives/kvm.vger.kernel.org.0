Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517B14D58ED
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346205AbiCKD3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346099AbiCKD3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5758EBAFF
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 64-20020a621743000000b004f778ce34eeso1886014pfx.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4wHqQmQYMmlrvs3hNFs3qg3hjBR4lK0MtK0mo5CKbtk=;
        b=dm/O2RQ0osNZqyPdQT9mVd47I6mZ1PQUwrpx1+f80sVQ/M/bsGsmpwbfFg+/ofwoic
         na1VFKn6V1/+TNoqFtNHX+vjWsAE8mdaZF//Y2XYPqsnMVvSUDKqQaqJSsPIn4IvS3TT
         0UKzZGDLGsYzmTWmczT5so8JBiWvcoCCQ4yGUPDkVOZ/0er9d7LCzEe30xbkuFpQdnDv
         PNzvfSsn73gXvupazH432VmfG8qOnnoEAk5hEOiSX7fbSz+ufvQ28Q7v3h1n7FFRcUN3
         ghk+vJ5LeKHL7HRR/kL5VgC9ekxzJCcfSfYJgIf3qmmLo1K4mM4SM0HkvuvIlUz4t3lD
         zyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4wHqQmQYMmlrvs3hNFs3qg3hjBR4lK0MtK0mo5CKbtk=;
        b=imDwFExNd43B7iAec9beNCUhqitjNdQRLmjjFxlqxwmv6vEeIJ0d1BuJqmnK7nIpGv
         xcQzq5x1Lhw3cHAdwo3OblnLiFKKHKyLe1tqqyvKbs32AFqR5zYjSWb0verajfr8hGRQ
         R+kIdAHFbsOw76zrwFt9BRjFwUEkaRAGOQ/vqeIh7e3TOHHtDfFn/TGjZwBIC19jPZee
         faXtnWwoh8TZIkPjBDiBYgU9Pvvt3u4eJ/9P5EzAIFOweHbW6HbWxOtLVbT/47zF+IMx
         vN7hk6AKJXIksEu5Rt9SyVn+35vB3FN25mUhziuGZv8gi1hesSUr+fUwi7xONVzLM/vj
         zRgQ==
X-Gm-Message-State: AOAM532kWH+vweIjL2Uh1mgLuKWkag6vzwqVqZV5GpikgzUOi1IHt/KO
        0UQBOqCVyR2ZxST2Lyvxz5p8Yv2qSDw=
X-Google-Smtp-Source: ABdhPJyRDLP072Uw4B0sqGdbay9yE4OLa/6LAjtCL6JnJz5Dpd4znMU+cQxDWQlz2yB2sc/JgGetmzRaUNg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a8b:b0:4e1:52db:9e5c with SMTP id
 b11-20020a056a000a8b00b004e152db9e5cmr7945372pfl.38.1646969298739; Thu, 10
 Mar 2022 19:28:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:49 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 09/21] KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is
 not in WFS
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

Fall through to handling other pending exception/events for L2 if SIPI
is pending while the CPU is not in Wait-for-SIPI.  KVM correctly ignores
the event, but incorrectly returns immediately, e.g. a SIPI coincident
with another event could lead to KVM incorrectly routing the event to L1
instead of L2.

Fixes: bf0cd88ce363 ("KVM: x86: emulate wait-for-SIPI and SIPI-VMExit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 53ac6ebb3b3b..b22089ebfe76 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3911,10 +3911,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
 						apic->sipi_vector & 0xFFUL);
-		return 0;
+			return 0;
+		}
+		/* Fallthrough, the SIPI is completely ignored. */
 	}
 
 	/*
-- 
2.35.1.723.g4982287a31-goog

