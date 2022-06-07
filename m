Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6DA54251E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443892AbiFHBBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574457AbiFGXZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:25:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4330A22DFBB
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g3-20020a170902868300b00163cd75c014so10003936plo.14
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y68XIZUJ1GQ/ObMpbiUUdrzn6qb8lkahi8a44hfFrNA=;
        b=jQ95zgp7qVJDyz/rhBbnbzbFaPXyqDEzj8zrULA0JTAxn1ujGCUU4KkH2I2nb7lyN1
         BgyIKJWUQMaXAbdAtXG12SiP3C1YPVlMBEjCPZZjMLxyqrLf05ilwaPOGFqn5UDHWtN2
         VOGq4vG+livVzLe0sI1eqlvSg/ho1RMSvot8fBuX/peS59R2BwmmovC4CMmGmAkvKeOq
         Nif/YKDQfkwW8ztwDY1E4vNh2+DeObMVSnh3J+n3VpTrqqW/kbUe9OUBIEd2YYAnQRLx
         GVlH6v0JEVKur9tlG4S+AuaTKJXe5K+9BUqQkLjD1C28qEfDCivr45t0uzgm5G2Hw+Sj
         ZS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y68XIZUJ1GQ/ObMpbiUUdrzn6qb8lkahi8a44hfFrNA=;
        b=uFFfDKRzdnKFdf88sbv/AqQH07T8/XDHowIjuUDtvmL13JHj9DKBLWm0YMrco25K9a
         BBe8TNc20y9n35uiKFg5GaTDp2hG1bxTiqj1dohEGqxp0QpjRiDbKggCGMSYzACaL6Wp
         3AznqHRacaU1Qa7YgV8zpKVMuqQseGAfE2kPYhnRlPYVj90LtyRYtjhi/7rIq4nMwOLw
         0bSG8Bt89qPfpCmDZ9+Umkq5Y7pVcWENrw3MDA4k8mAsXHVBV8ILT7b08cTzMa60EXtI
         +q+Sr0bo2ix8XRXUnW2j8fpnF6iNjKJwDxvmaChRkeXuEc2Vl5Styu1xAj+jrc/nUYbQ
         Ozbw==
X-Gm-Message-State: AOAM532LHHhyjGXWzDuHkoyri9iwl84QBZLHpJwEYXKahv6zgbRENq/9
        zou2IzmViD5JhVHzFqBSguWAgOsqzW4=
X-Google-Smtp-Source: ABdhPJxB3VYaQ3PQ1Ta72PzTm03vXyJkriBqEkaiWnpRhP0oEWKbD0KEj038iaragoTuunxOvzLdz2r/Ra8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c981:b0:1e6:75f0:d4ea with SMTP id
 w1-20020a17090ac98100b001e675f0d4eamr35605587pjt.37.1654637781774; Tue, 07
 Jun 2022 14:36:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:51 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 02/15] KVM: nVMX: Account for KVM reserved CR4 bits in
 consistency checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Check that the guest (L2) and host (L1) CR4 values that would be loaded
by nested VM-Enter and VM-Exit respectively are valid with respect to
KVM's (L0 host) allowed CR4 bits.  Failure to check KVM reserved bits
would allow L1 to load an illegal CR4 (or trigger hardware VM-Fail or
failed VM-Entry) by massaging guest CPUID to allow features that are not
supported by KVM.  Amusingly, KVM itself is an accomplice in its doom, as
KVM adjusts L1's MSR_IA32_VMX_CR4_FIXED1 to allow L1 to enable bits for
L2 based on L1's CPUID model.

Note, although nested_{guest,host}_cr4_valid() are _currently_ used if
and only if the vCPU is post-VMXON (nested.vmxon == true), that may not
be true in the future, e.g. emulating VMXON has a bug where it doesn't
check the allowed/required CR0/CR4 bits.

Cc: stable@vger.kernel.org
Fixes: 3899152ccbf4 ("KVM: nVMX: fix checks on CR{0,4} during virtual VMX operation")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..129ae4e01f7c 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -281,7 +281,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr4_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr4_fixed1;
 
-	return fixed_bits_valid(val, fixed0, fixed1);
+	return fixed_bits_valid(val, fixed0, fixed1) &&
+	       __kvm_is_valid_cr4(vcpu, val);
 }
 
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
-- 
2.36.1.255.ge46751e96f-goog

