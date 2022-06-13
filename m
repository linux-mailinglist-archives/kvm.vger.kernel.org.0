Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB454A266
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 01:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245123AbiFMW6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbiFMW5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EC91151
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so6114756ybu.10
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=66YOE3D++YjiCQYAOPbfPb7xNbNJtfXwRmXra4+Vga0=;
        b=OGQQT/kEl+HJEIxg1pFOPK9rS28ovUya8ri7Z+Zs4qy6oaWb7o7khwI7JVXjbdrJXe
         DLQxDiuUabALcAyEtJUjYxq2JOljiWGRFUIj7pSxS7hoG/Zy2Bv/zq2FowrMCezO3plx
         X1ECBFm5XlSTdkMkilClv/2pAGu+Cq4sz1O2+6Cyo9AJdmdxqvjUlHg1v/bxfGMWajBQ
         gPBXlGgq38ijIWB767GbrfGwhU4V3hw0R4AdHzTldbQWT1tIWyhGKf1Fln1qYgTg6daa
         0Bm/KBbPyObSermiYbLLx6MB+OJvj+oL+15400uar6hxXbM5fdgTHTVkDhWKGJynREYW
         r4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=66YOE3D++YjiCQYAOPbfPb7xNbNJtfXwRmXra4+Vga0=;
        b=35PLn2dFcZKO3oJXm7py+WZLcOqebMugWqCJwwHt+tv8nuPItr/4dNuq7/jWuy/IMm
         1WKvA/lb84f6zLOs7RW6w/AGDJqqd1ddRZGNjsgP+KSF793IyXIXfeOfQrY0Qzu5t89V
         sZ4A5BRUHOHZVDlTNV0dsmIGHqbYup1DxpiqGmxhbrLEHn69rcRrXYAU65NVajgkTsOo
         Hl0a45NS4OYgxJUPssvJT99kNfP7+N4r4qEfaxSd9Drysid9Q1Jz5iszYVNUZXmi41Vm
         QPSskON1MgpiHKy6nrfTSCoUW9R2Muwqtg02gYYbZT7VVUZUAp6eqy98BGxbVDyluIsW
         EjOA==
X-Gm-Message-State: AJIora8Vk1XgtuwwGKXariuYOnduVCqkUEM0/N//YboARqfw3MpoTA5m
        anNWTzZQzstCV78a4pp9b72hdm57zQI=
X-Google-Smtp-Source: AGRyM1vFi9XO4bi7ATHD/tcJRWZuWdYliTFf3K/ZUTGXuMM7BsmCw/F9cNYih8H8aUm6iETOgytGKbTPvGk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a5b:101:0:b0:64d:ae10:3d26 with SMTP id
 1-20020a5b0101000000b0064dae103d26mr1933397ybx.103.1655161049615; Mon, 13 Jun
 2022 15:57:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:17 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/8] KVM: VMX: Refactor 32-bit PSE PT creation to avoid using
 MMU macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the number of PTEs to be filled for the 32-bit PSE page tables
using the page size and the size of each entry.  While using the MMU's
PT32_ENT_PER_PAGE macro is arguably better in isolation, removing VMX's
usage will allow a future namespacing cleanup to move the guest page
table macros into paging_tmpl.h, out of the reach of code that isn't
directly related to shadow paging.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..b774f8c1b952 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3704,7 +3704,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	}
 
 	/* Set up identity-mapping pagetable for EPT in real mode */
-	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
+	for (i = 0; i < (PAGE_SIZE / sizeof(tmp)); i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
 		if (__copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
-- 
2.36.1.476.g0c4daa206d-goog

