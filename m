Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F5E6D8B32
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjDEXqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjDEXqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:46:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792C072A6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:46:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u11-20020a170902e80b00b001a043e84bdfso22091897plg.23
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680738361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xNGeRDIkTtMwdpUunk/LJQ+eOn2n7u25QTc+Qc8ujPk=;
        b=rJK561EpCQv795FsTyfhoO8EAqpBp3c/KWtvnLOSvr6gn69lCDd/7vu+sQnI8tTMN6
         j5DX+bzYSCpbMfudYzJiUim8gStbYAm1J0n9Levs3BOB0cLiHOjcEq1hlTouBhYKlV1o
         XaiW1yUXvQyn+2u0NrQTAFP7clkPz3y9CdkDIp7VWDLUVRmrMEO2JHFJKgg5rBh67YTo
         yTy0JD0cttYZQBg9Y3jqd5ReibwvcjX2QuOiSn3bgS2l3mSHWCFz0EhNXWBCN3exGXk8
         o6/bvbyjNfYr4kOGrfaDYRm75zwXUZihsXBbFUQnO90b90sGQLPxjtEafdQLpB3g0XFj
         FfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680738361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xNGeRDIkTtMwdpUunk/LJQ+eOn2n7u25QTc+Qc8ujPk=;
        b=J7aJejSuMbw7aNrhegyU0w6zJ5LzCB2QpX3SjzrArE63sWk/67Y5w/eXoX5pEffwFn
         dxt2kD73Aw8gYnDvSA89uYoigw/jgbmoBERGJ3HRPTeeaj9+qJQqA3NRIAc0LSIhGg7p
         PgYzdhPa68symQuv6k7z+1RCHaeuKn3huRLZDta3okmaJ03dmyrNlRLjb55HSoBMt5IR
         nCzZTqz3tgacGK0mXFc2CwE+U1zhAOPOFvnx6O/btczuamPl68SccIGulwlCV3wDSJKO
         Da7s3Ez3kWUJ4Hh4+Tv0lSJa9T59l01RQY4yvHskPDld2yryHE3zMb3qaHsECT/9bWr8
         1+LA==
X-Gm-Message-State: AAQBX9cvJBsthdsu4m59090Q5WLksBSvQPbzkMCZEKnlbU7wfku/LBbB
        tM0pX6SkI+bVPlPOaQc7W/fA4coMbgE=
X-Google-Smtp-Source: AKy350YAGD7mt7Yp0bWIMzK7Fajyk2Sa1d+Ymi5ciNZWaoO6buaEBr5AjolyMtLiOjNp5pr6v2uqpjhGn3M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7108:0:b0:513:5162:a692 with SMTP id
 m8-20020a637108000000b005135162a692mr1674064pgc.5.1680738360888; Wed, 05 Apr
 2023 16:46:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 16:45:55 -0700
In-Reply-To: <20230405234556.696927-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405234556.696927-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405234556.696927-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Inject #GP on ENCLS if vCPU has paging disabled (CR0.PG==0)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject a #GP when emulating/forwarding a valid ENCLS leaf if the vCPU has
paging disabled, e.g. if KVM is intercepting ECREATE to enforce additional
restrictions.  The pseudocode in the SDM lists all #GP triggers, including
CR0.PG=0, as being checked after the ENLCS-exiting checks, i.e. the
VM-Exit will occur before the CPU performs the CR0.PG check.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/sgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index aa53c98034bf..f881f6ff6408 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -375,7 +375,7 @@ int handle_encls(struct kvm_vcpu *vcpu)
 
 	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
-	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
+	} else if (!sgx_enabled_in_guest_bios(vcpu) || !is_paging(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 	} else {
 		if (leaf == ECREATE)
-- 
2.40.0.348.gf938b09366-goog

