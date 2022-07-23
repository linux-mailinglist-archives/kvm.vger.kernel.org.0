Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FE457EAC8
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiGWAwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236739AbiGWAwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:52:12 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1703389672
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o7-20020a170902d4c700b0016d2f7f9a6bso3431791plg.13
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Dh5XhG/onjnmd2PjNqHEDq5Y/Izy1DZsJYFMaDP2/WM=;
        b=o7+HUcUvi+SlVGBX7T1V29ZcIIQcy3ldwgFEeUnF7/UnKremL5OXo1ztYxooVx26tv
         dug/4l8lJSV5pyHs+iAUZU4G0jtnel1nt+vAhmjbFTVVil4+ZOFHKr4ycIJe8W8/kbZt
         K5ss0ld/kKmvi7d2BdxW2aQZGvXfqpfaDQ5WAeiMw6xy8Mw91B7zoTeKfkrG4gWdy8G4
         d6d29agos2Z44C+9qkstFdMtc6Po/uZolJgE05Qx0ovwaEMU01BZ3teDC0ZavAoqYQYo
         68vH7w+8BBEQFAYBf/c/WXZ5l0J+baNoN/F+BWyxIVG3Eb49XFRjUhwcZmrp27Kl830T
         GkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Dh5XhG/onjnmd2PjNqHEDq5Y/Izy1DZsJYFMaDP2/WM=;
        b=2Ijmn2pKM5Bkr6kzjaivDYqY1oBiqeEbqRzN+GqbZYGyq538fS1zXPRgo0AocHhb2f
         g08pHNgOdycWJnYPf6b8FHQReSOppgkqMR6CLNcV3gXCcUy52pwMqZyo2kbHyu43Zqt7
         wHgP4vQX+fQiaJaFUex4IRO+J70GXU0z1PkadYI+RRrB0xzloQktKqHAlctwvsU9+gZU
         gfIbCWc2iVXlvAMMoI+JIg0rcHl3sX6VmqGDCM5CMs5aBRs30ueQm62CzWqf5P2rxHFb
         G/DJr46CnjlhdDqOz2ojs7CaroxtNpBHZrkEs2Z/XrptOf+CfIVkprix6CnZLnhuadKY
         FYeg==
X-Gm-Message-State: AJIora9zzRQlLIy7mBKMsx5FR22O/YXurhUoN6UPbEaCfEJfVsKqAkr2
        Co63P8iI/tat+9yVoTMD0kiT7X1jRbc=
X-Google-Smtp-Source: AGRyM1sZ46Ujgo1qO3MVUIDhgt+56oBD91Ennuxg6aLoZOAqeWPJDDVcviYC4X9L6A2CkLxH5cAn/Fk4UeY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1211:0:b0:419:a2dd:63ea with SMTP id
 h17-20020a631211000000b00419a2dd63eamr2058770pgl.416.1658537518202; Fri, 22
 Jul 2022 17:51:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:23 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 10/24] KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
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
2.37.1.359.gd136c6c3e2-goog

