Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165E55A72D4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiHaAiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiHaAhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867FFAE228
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y9-20020a17090322c900b00174c881abaeso4608045plg.6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=COtQNDmyFMKiUnG0r6DP8wnDX53zfdZyDRmbDYIlONY=;
        b=lv67W+znzN/46x7oLehYcakVQyriJLYBfxgch3FDtG3+6DalnO4gEwMnCOeXlh3RsV
         QL1VXkz2olPy3veCJ8XWGpnGwzQLCt8bKiqiAZQ6pjj0ImImEt0lD+qsuj/KSitJmtrt
         r+Yq7rr7LFmnXuHZbUAYDmwESgLTHohJHspdlcwms+caDyxgUS2/RgIuiH4VrW0Ry/bM
         6PMkkR3Ose6LKPEoEZfmTGpmfkOAO2HmAmLmGUZL2xHfpb4vCJE9eeoAUpuMOLJknLaH
         Hm6X+HjPjR+JCRhkDKOdrunS5EEPGwg6wzsQN4OIRJYOvPtBDFFkENzCfVWNMs17qam3
         nJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=COtQNDmyFMKiUnG0r6DP8wnDX53zfdZyDRmbDYIlONY=;
        b=HFSE1mBONqE8dFoLiUYy56Kh70aY5YlgLtQtxVPd3H5U/21HJelw1lJOrc1NYMkLUu
         kCzhekTKQGmD1CvD6sFql82VRtxSQnM2SSmR0TPK1GPzqCAcDX/AiBviOxhq9TuClbLe
         O+vpgRa1jeyxYSijklDqkEjY7Ak7XjvMF3s3LrQbk0lvPiaqforGIGYfICSuKwz2lmGv
         yXk9xpYKm3ptwaocljQ/220d12OWy4cwj+yKrtaFn+qgl2k/EFAz7lUOpLJr69UCc009
         yeIB1ddGweMuOrJez1gHtwmF0JlP+1JnDd/2L64tiv0U9ak5ttE8NLPpR4vpQ4c8VIro
         BHkA==
X-Gm-Message-State: ACgBeo20OuUDf3DurJ3nsPn/NoCZuPJnA3t4J6r0kmGF4MpUXIS/6bHo
        tqYO6BA/Tm1jf1mj6W3UlHQ182yFDJ4=
X-Google-Smtp-Source: AA6agR53jSxsmlnw8Vqq0VWR0l6XXD330eDCt8c05joJrhe9CCBHlg9c14qWUc1wmSjGkMR7ljsa45TWru4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a19:b0:535:49ee:da43 with SMTP id
 p25-20020a056a000a1900b0053549eeda43mr23874432pfh.53.1661906139729; Tue, 30
 Aug 2022 17:35:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:35:05 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-19-seanjc@google.com>
Subject: [PATCH 18/19] KVM: SVM: Ignore writes to Remote Read Data on AVIC
 write traps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Drop writes to APIC_RRR, a.k.a. Remote Read Data Register, on AVIC
unaccelerated write traps.  The register is read-only and isn't emulated
by KVM.  Sending the register through kvm_apic_write_nodecode() will
result in screaming when x2APIC is enabled due to the unexpected failure
to retrieve the MSR (KVM expects that only "legal" accesses will trap).

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dad5affe44c1..b2033a56010c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -675,6 +675,9 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 	case APIC_DFR:
 		avic_handle_dfr_update(vcpu);
 		break;
+	case APIC_RRR:
+		/* Ignore writes to Read Remote Data, it's read-only. */
+		return 1;
 	default:
 		break;
 	}
-- 
2.37.2.672.g94769d06f0-goog

