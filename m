Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547C66E1834
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjDMXT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 19:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjDMXTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 19:19:42 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2453B448F
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 16:19:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54be7584b28so286372577b3.16
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681427960; x=1684019960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=76AH6jeC0zUFc6RLhtB1VloLSMnKdwxfmQWgPXRFScc=;
        b=3JkngVwkuZE/YTh1waUy7PTk9n/XgQp4TSQpXmwlB49LWxI9cPN/uXZJfO1L1Yqjd6
         G/rjeCDaxoAW+0UbA87uVs+Op/nA46kVZQXvMq/nMpKkafrk7o7DleSB/h9FZJAZ05fT
         5Swu9qAWOMPKj1IY04zyyF0AppbMGDiOa2NXw9oLgauoBYlGxij0wA1TXOu3UwStSRxK
         0EKIPdPvZyu0HKZvErkzoWOIgS3GS+dFVjYI1w23aCzxd0OiN0QkQVaWYMcO9+c8vC3w
         EsOtPYUbAjxFFbypNbMaYZ4Cni5hVFCgpkp57PAAS/rM6GqIbmhFViXB/7ZPIxF9Nzrx
         c+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681427960; x=1684019960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76AH6jeC0zUFc6RLhtB1VloLSMnKdwxfmQWgPXRFScc=;
        b=Br3T1HfyV41Zk85cR8HSjp5IAHGRJC+L6gz1Wh2iIMGYBrw3dGJF9jj1gcf7oN7Ni9
         txi4t3DjWRIgPI75Sjd8Y9mWQ0Z6hnEZhHjlVkK6FrnHf4Hj/2KhX5v4mHh0MJ4abx6u
         3t5lU/IlBaaRu3aa4pBtglUPiXRjAozSemzd0Wd/q3J/kzTGlevf1B/wZ56kJXnYWh8M
         fSuz4m5k3Z1uKwcvPjF6n/cZ2dNbS4GwdJc7fj+MXIMPun6NGWY/EMggWZk4nEQHI+WU
         zF1vPwjbiqj9eINJlJa3OZ00CtDP3A2jozLmXKUdS2kVsE03bkDVD7IRJSrv9GRFA/ed
         aB5w==
X-Gm-Message-State: AAQBX9dGVziZnewJ1LV6Biwi9P9Jv3EQHrBHsN6NsDezQe88cC7ryMlq
        plNwlt5tn0eGY8o65YulWLKbd2g21dE=
X-Google-Smtp-Source: AKy350bNSFXacXMTWAobp0sufEqFSEvdZGZwi+emRTP2ohIDz7BXP4Xm8c+/fBJsyMhO81f0YOf6nrf0GJo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cc05:0:b0:b8b:eea7:525a with SMTP id
 l5-20020a25cc05000000b00b8beea7525amr2052763ybf.7.1681427960466; Thu, 13 Apr
 2023 16:19:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Apr 2023 16:19:14 -0700
In-Reply-To: <20230413231914.1482782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230413231914.1482782-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230413231914.1482782-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@intel.com>
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

Use kvm_is_cr4_bit_set() to read guest CR4.UMIP when sanity checking that
a descriptor table VM-Exit occurs if and only if guest.CR4.UMIP=1.  UMIP
can't be guest-owned, i.e. using kvm_read_cr4_bits() to decache guest-
owned bits isn't strictly necessary, but eliminating raw reads of
vcpu->arch.cr4 is desirable as it makes it easy to visually audit KVM for
correctness.

Opportunistically add a compile-time assertion that UMIP isn't guest-owned
as letting the guest own UMIP isn't compatible with emulation (or any CR4
bit that is emulated by KVM).

Opportunistically change the WARN_ON() to a ONCE variant.  When the WARN
fires, it fires _a lot_, and spamming the kernel logs ends up doing more
harm than whatever led to KVM's unnecessary emulation.

Reported-by: Robert Hoo <robert.hu@intel.com>
Link: https://lore.kernel.org/all/20230310125718.1442088-4-robert.hu@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57464c762c79..f0975e790f7f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5402,7 +5402,13 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
+	/*
+	 * UMIP emulation relies on intercepting writes to CR4.UMIP, i.e. this
+	 * and other code needs to be updated if UMIP can be guest owned.
+	 */
+	BUILD_BUG_ON(KVM_POSSIBLE_CR4_GUEST_BITS & X86_CR4_UMIP);
+
+	WARN_ON_ONCE(!kvm_is_cr4_bit_set(vcpu, X86_CR4_UMIP));
 	return kvm_emulate_instruction(vcpu, 0);
 }
 
-- 
2.40.0.634.g4ca3ef3211-goog

