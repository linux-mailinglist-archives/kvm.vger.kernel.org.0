Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4927557EAC4
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiGWAwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbiGWAv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F77D8CC96
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b10-20020a17090a6e0a00b001f221432098so2695897pjk.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RtVR2Tkco0tuXD7bLAFV7Fg1ldNSfzq0D9HUqql94JM=;
        b=JlCKvFLufslNPFBb2FTFua18M+4EkJnw4RZBxfm4Kn7ZqfIDkj+uEaVJRC1D4a9UuG
         Bqkv1vEvi8eJ1dmoYbX8sOEyx0atakWIVMTcSn6S0oS0ONdVBGxmtB35y8BtmLNFwjFM
         Dr33xD2jTN9GLFmWh6aYzXEADCXXw19/QpupXTlCSSLSBQTXRMF/TviTi01uQ9oaCOBy
         XctvQJWiXIIW50Mg0Ld6F6SIMU0KRH3EVKNWFsp0I2Pg/az3oMZnCT1w4NkdzcP1dy6h
         3tOeZjPdmMnhi8hAGvyd2n1Sx4aHvDGOBBd8JInbNURIUXHQFa7BJEt1jV9lxFbaHCbs
         1Stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RtVR2Tkco0tuXD7bLAFV7Fg1ldNSfzq0D9HUqql94JM=;
        b=XOebge3zK0L4fCK1NLkpjbdYGCKYXgJDipbJ9zcGPNMneNokTirD28txGa3t7RJDv+
         JRz/GUvqt5eZwwpolB2ucThiAC6I/XOWgt3raINvhylJvRhR5vmepEjosSqRGXBUaaHa
         oyCe6rnzt26QUqXHBkiP9kkdI8mKot/rO7Cmi59SYJN8yH0cYTkgzKXMHyBHjTCDxVx5
         L88tOoMtL9TmsSmzPKMSdaz6kXxhpTLxZBTryp2+t340mxsXUX/l+QwHIcnxaP/6qcwW
         wiV+zToTd+enwtjHniKYFSZyuQ3YEmZ+1EtXuqNXpNIooQ04XF+mILmqoKHS4W4xDmV/
         5QVw==
X-Gm-Message-State: AJIora+1bKxYZv7jBiL+H6OCK9rgmerOS7tIOqMSDrkl0SSE3xv68Qx5
        Wnh7+Ij52M9Ksp54+YWWh0c4sc/cyHU=
X-Google-Smtp-Source: AGRyM1tDknBN2M+wi6EP6p98NDwZtB00KTdlSsvJ1NXCoLJgAlNlfqBfaq7Td2vZ3FATLnMSGw7V9BakbVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c08:b0:1f2:977:c147 with SMTP id
 na8-20020a17090b4c0800b001f20977c147mr20329213pjb.6.1658537513521; Fri, 22
 Jul 2022 17:51:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:20 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 07/24] KVM: x86: Use DR7_GD macro instead of open coding
 check in emulator
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use DR7_GD in the emulator instead of open coding the check, and drop a
comically wrong comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bd9e9c5627d0..fdeccf446b28 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4181,8 +4181,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->get_dr(ctxt, 7, &dr7);
 
-	/* Check if DR7.Global_Enable is set */
-	return dr7 & (1 << 13);
+	return dr7 & DR7_GD;
 }
 
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
-- 
2.37.1.359.gd136c6c3e2-goog

