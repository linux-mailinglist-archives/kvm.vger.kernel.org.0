Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167365F17B9
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiJAA7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiJAA7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:25 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCB81AF910
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z6-20020aa78886000000b005470014dc57so3585843pfe.1
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=gWKbedEYDM+WgMEZuaaXsHPdTjjpS3BqpA6Whi9EiUA=;
        b=LMWP/ZwmM6mNI84QoaByA7gGMv3UqTyhq7gvWgXvV+gu83W3Xsz5MlcgWVWntOG568
         HVYiHsHO9gEuCsJKIR5ZyPrrQFSvnTXvQVWXdsv7W4WHcyq/5DC24dd9IwPWGA6cUdOs
         shCRfpNnUoRmuPXs91O85K1ECe76YYMC12wNJQT9f91GNEs8BXLas4v2U3oXZmvGKGyJ
         +sceDgf8U3o8mx28L80DvSeekIQvSi0Egtsjp046zQi9qjLw/QZrMi9yEX1Sy6yR4bXf
         5k59U6996zsNYfcRXjFjA7HKVe9O/gOGGxTKQHlogX1uxTUm/Xsp+prVIQ1o063ZqQmv
         vgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=gWKbedEYDM+WgMEZuaaXsHPdTjjpS3BqpA6Whi9EiUA=;
        b=IptIdKbIvFwKmnXgpZ5MpRJaFcBpTNn3wbpubxCiaIQR76HzpOL6i8VZmukfZN/Qf8
         OdSrShkg+7D4HRGvQ0NoakLePSNXqPNVUQoRHb+hRysLlSzpMhVcl0+cLfZAcPIjPhYj
         NxWmLubQQBZbIUTeVXt1gDm/vWGGctji3qUIz3HYqORD3ygu85v7TyooXEiXeqjjtvsf
         uDv5/jDBldslpuOquib4Ondvyh67RwHiTQdbssSe3h32twVP8fuDVfIUsDRp7EUpHFbw
         /Fdcq3RWMw0b/In2OAOLOEf60ii4SRwx31RfXTHNOVAlPt8AXLUVEMUpcieUXY4mSBFc
         w8xQ==
X-Gm-Message-State: ACrzQf1YokhIyuNroAe70U8NurS/caoR+aeVhfgi/3pvLULdt4f0q7tB
        Gk0wJz8vrQa9uvkZJMEiEVUAtHMQqCg=
X-Google-Smtp-Source: AMsMyM6ZqIp3urmDWoeW4zxYAhyWoaXq1tuhVl0zHsGHO96aoD0eMfzus09JSG0zAhOilveTapAWx7nL7jU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr517109pjt.1.1664585963402; Fri, 30 Sep
 2022 17:59:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:46 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-4-seanjc@google.com>
Subject: [PATCH v4 03/32] KVM: SVM: Flush the "current" TLB when activating AVIC
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Flush the TLB when activating AVIC as the CPU can insert into the TLB
while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
KVM may create a valid NPT mapping for the APIC base, which the CPU can
cache as a non-AVIC translation.

Note, Intel handles this in vmx_set_virtual_apic_mode().

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..712330b80891 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
+		/*
+		 * Flush the TLB, the guest may have inserted a non-APIC
+		 * mapping into the TLB while AVIC was disabled.
+		 */
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
+
 		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
-- 
2.38.0.rc1.362.ged0d419d3c-goog

