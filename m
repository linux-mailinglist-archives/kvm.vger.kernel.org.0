Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA42F54BC30
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358315AbiFNUsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356667AbiFNUsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6452722B02
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h7-20020a63e147000000b00408948ba461so2709651pgk.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NuhBWXqmLuVOf2m1Sf51S9jTSqkqKCsQtTnFDyuk7Aw=;
        b=AAxqgJ02kZTKFqX0fncJZKFgSJ2T0aA1M4w3CKtg5ghAgxQBqiDR/VJB2qtuKBXK0Y
         2aF2sDvCot1MSZR+2cf+/hdm82ueKwEx2lrUYeouQ+ECCyoxiAcyWRiYUyAf2K/5uWW0
         MkKQbbnd30ju+o9ghshN4pPD8kBxXkIiOHxRXbSKHg7D/A0JJLRcUaXNmfMEqxiWJD5X
         RSlhwPogjoo2Twvp62FoU3WmNujiDrXwCoEJBJJGG4DaSkdlc75jDYUW+BNkvLQO3BvB
         9i2n3fjxiSCCaty3hj2XDmS2Nwgf/M31VCHXBwM1tcp0Gklu8/KRTJiF+gidwqhVSPYw
         vrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NuhBWXqmLuVOf2m1Sf51S9jTSqkqKCsQtTnFDyuk7Aw=;
        b=B5Mb9i/rwVobP9LowiIVvWFKpoDf/Vr6NjdeKlSE+IpjYiYS5orEYS/5h22/2lX5AP
         qkCNU/B57f1hIzeiMCrL3cZplw1ktbDq1jCXyXXRVuDptyd0wb3jU0CavTSi+jN3llXX
         V795fjfJAV/3ZHzjCZQZ1pQD+e6uyf98bklFtuhyATvdk5FQ/Txikw/UEsIqzLUfi+tx
         Hj6ZhXP01Jq4Uz7jzdW4poKkC/hRo+sOG7Xl4s3xsZBR1SGu2p4bAbKYNM1eK0cF4q3Y
         IdCE9LOUH9IVLaW5hK3q9L7DMNilWpUVZpYL6qLZYfEXi0HdCLcp2FZlS0vkmUYZrBzP
         yqeQ==
X-Gm-Message-State: AOAM533njAdptXjdcXHxUDs/JpBspnrw4UhpVNT2kQVAqoBBwbMpVtmz
        GIVhTAd5yPAE4TeoERzO5w/2gVzaX6M=
X-Google-Smtp-Source: ABdhPJxhuOZirzBb6ajrKE0F+5qY70HzLyfqMtZYi5fqIRkVW4Lk3gV+5JSEMCrA+DGmDVzjoE8ZrfiPeDQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1306:b0:512:ca3d:392f with SMTP id
 j6-20020a056a00130600b00512ca3d392fmr6513669pfu.79.1655239674490; Tue, 14 Jun
 2022 13:47:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:19 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 10/21] KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/vmx/sgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 35e7ec91ae86..966cfa228f2a 100644
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
2.36.1.476.g0c4daa206d-goog

