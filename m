Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC45A71A6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiH3XTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiH3XSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0771A2A85
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q7-20020a63e947000000b004297f1e1f86so6162651pgj.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=er0rn6CeFv2sFug+64NWnb5+gXtVZZy3ObF582jX2a4=;
        b=AbJsqnH0z4stM3Vcz6sOQuRN8elndSRUZ0ln3mBw6V20SASPLfRMYDoxB/WelEtthW
         E2GG2rUuCOd16ZdFy5RSYEmBbQEoPNycZhydTaQQM6DOg90hbXveQ56NE+MnvwJw1ams
         pnIhTLkS8aaPtR9K/QIcbYei24WN9gMIXPx9HJFkYc445DOAIedZ/dPdFO9yBg3nPl6O
         vgfU+qRKYBrZf8sS8Lbsx3UO2IOS/RL77TdQQMf3aizMBe4Pp3t2Nm6aQ2vom5LTGU2m
         PuLRQHVCx8i5RPlfS4FGuB1BehXf+ewox10iKsJjbuz2XWaf9w+it9i+X10Z0FtzVw++
         UuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=er0rn6CeFv2sFug+64NWnb5+gXtVZZy3ObF582jX2a4=;
        b=M1NXuZTcKzmZsu4TjAialxS92OZNwOPNIolmtKFhXO1az9BoXOsFWmOGzs/i05d1Pc
         vuPHxkMIi+meDW+CyuG42IlERps/j7/3syJS9g1YGPRAax+noBAvibNfTWOiflt/TCQs
         ZU2brp5Rw/vTvp/QPw49w9Pbx5wsXk+st7au4w8nLucetPHGO90N24gm31O9cGS4RGKu
         wU00Q0HL073d7K9R12fzzElV6f59vQB4gsH8DXWz1RRuuMxd+5SaQl/jN6FkOVVXED+3
         e3WcNxjASFwcXeYcrcAWQzD/v8fVb7EaBIpnNu4VPqBz7oQ1Fpaf2PXG+CudYATxJN5b
         vwYQ==
X-Gm-Message-State: ACgBeo3b+GynRPp36pqQKkf4CoJ/M5zthSv2a+ZMaKzTKxMdJ8q65cne
        jeovHZwfyhCy9atAuMojvv2OaNAkOJA=
X-Google-Smtp-Source: AA6agR7t5PHHGecbEoijbNb/kN8TA45y5UzQ9XctwWfmoTT3LW+rvJ+HP0dXBYP+FTPo4Cm8X7zNucFS+EY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr11251pje.0.1661901397020; Tue, 30 Aug
 2022 16:16:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:59 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-13-seanjc@google.com>
Subject: [PATCH v5 12/27] KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat #PFs that occur during emulation of ENCLS as, wait for it, emulated
page faults.  Practically speaking, this is a glorified nop as the
exception is never of the nested flavor, and it's extremely unlikely the
guest is relying on the side effect of an implicit INVLPG on the faulting
address.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/sgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index aba8cebdc587..8f95c7c01433 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -129,7 +129,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 		ex.address = gva;
 		ex.error_code_valid = true;
 		ex.nested_page_fault = false;
-		kvm_inject_page_fault(vcpu, &ex);
+		kvm_inject_emulated_page_fault(vcpu, &ex);
 	} else {
 		kvm_inject_gp(vcpu, 0);
 	}
-- 
2.37.2.672.g94769d06f0-goog

