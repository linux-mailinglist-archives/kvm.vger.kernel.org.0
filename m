Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6FB5BA62E
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 06:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIPE7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 00:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiIPE7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 00:59:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44EEA1D0A
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e187-20020a6369c4000000b0041c8dfb8447so10445671pgc.23
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=s+f6iuFPnTWt8Fk8zpSmfYnRtMxwV4Pi8oGvt18dXLQ=;
        b=DeFnP+9pacpvMxfyB7Lr8mY3ehpEKqyz7/yVgaleePB7AVlM5bt0YdDZSTpFzpj3mO
         xuyu/aNFVr7lxTnqIYlNjQKP5lmqTms2Yg/cB3S0VVZCO9qi1QqS02sT5uFvi6NMVUUD
         lb2TTl7ZxCbyxWohXgSmi/jvgFaf1NV2O6AYJ7G3Lu6hlTUaJEvrTp2zhu1Jb8NP16Cx
         Y77GPZ/EmEQWTtXQwzQ1HN+ng5UqA39TuJQcmpEDa36Av2qb8n0SKrhKiUXLBe2DceVA
         ZBJMhasC8eikXk/+svzKZVV4i1x07j/d4uTCUOmFmr8mLZCgoYhZKifxto/c3nyJ33uB
         W7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=s+f6iuFPnTWt8Fk8zpSmfYnRtMxwV4Pi8oGvt18dXLQ=;
        b=yfg0AZgmQrgHNZglhhgGn2fPekjmbSjnM41Hd6Z6y2AdO8OS4z8NiSyJu2o9JucVlH
         hflIThr0nto2a9LY7jK7bxzRiGs+F+YNp1uQAybBCpcp9IcnUKJ0gN/Dybv9UZV7iNmo
         XAl6/XYBKoKwvhlac9dphVohgaBLKYgKLUKNAN+4mHPNSJ1M9xqlfPWzfXGzkX3vx4nu
         g+RWEToGIvyXWQ8H0n9dNJx4VjeQMobOrlWuN1Z8yqwsyL04fzQm8j2CG4bGCYtDEFEZ
         DvgNftfbOdPOsPMthk6t/4cHQngRbCx1uQZ39RZ7VYitk+xGdYoc/5zkYIT3HjX1CFDx
         r1EQ==
X-Gm-Message-State: ACrzQf1HfkTdPHJodfU0dB13OMjuf3+j2Xp9IWQMTp8KLQr6EICs3yds
        YpI17Lm16sQ51B8NLij54eloUvLxXLxDig==
X-Google-Smtp-Source: AMsMyM52qpAlEtbK9ix5lLb2qOF8X1z11EAIwtjk7BaIAbcNFJQFz4AMGZhhH3LrUtVCM0atswfdG2M/IYIC+w==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:848e:b0:178:54ce:c108 with SMTP
 id c14-20020a170902848e00b0017854cec108mr3098215plo.134.1663304339152; Thu,
 15 Sep 2022 21:58:59 -0700 (PDT)
Date:   Thu, 15 Sep 2022 21:58:31 -0700
In-Reply-To: <20220916045832.461395-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220916045832.461395-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220916045832.461395-5-jmattson@google.com>
Subject: [PATCH 4/5] KVM: x86: Enforce X86_FEATURE_NO_LMSLE in guest cpuid
From:   Jim Mattson <jmattson@google.com>
To:     Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>
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

When the guest CPUID reports that EFER.LMSLE is not supported, treat the
bit as reserved.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..26c4ca73e389 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1686,6 +1686,9 @@ static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (efer & EFER_NX && !guest_cpuid_has(vcpu, X86_FEATURE_NX))
 		return false;
 
+	if (efer & EFER_LMSLE && guest_cpuid_has(vcpu, X86_FEATURE_NO_LMSLE))
+		return false;
+
 	return true;
 
 }
-- 
2.37.3.968.ga6b4b080e4-goog

