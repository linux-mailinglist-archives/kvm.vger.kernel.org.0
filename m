Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C7C570E48
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiGKX2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 19:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiGKX2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 19:28:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33518AB0E
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:14 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l16-20020a170903121000b0016a64bbe81cso4622893plh.11
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gAFaZ4/4ERuw4bK9sHa39BcoOgob+bDhWwNvsNxoB+8=;
        b=auqC5Y/AOEJHYvT5qPXMTMJnka6P9ktH4abdMSWOrllMxo07I/fHOR1Euj69qajyqk
         sP4Rohst6VN5iI+6MzhVNTy9z93BaPKq0CCbbBID26OQ3N5W7at8LwMLp9r98UUMMU08
         HSc1qtPQzk3lU6FnTI8MIkVef4+Ejj99QnhfJwaXxkYGdYxhoj3ap6hIox+Gs2WFa3zG
         hX2J1+srtP360eA/tgM09C1kWgrN5bhiB09PEpTOEelJbkm/5OFtZmNh4JAaP0XSDHb2
         HpRlt2km/ZI/PR4pCjqN+iu+R36j5/ycovomW3LabExMuoXATs4jAZVTwVwq0gXACRDW
         tP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gAFaZ4/4ERuw4bK9sHa39BcoOgob+bDhWwNvsNxoB+8=;
        b=5RddTN3ZIGNHCAp8RhZAH53Ecby6omvPZrbhMiGxGOGna4bgd50ou5HfsJyGqp0v80
         0DE3YXHWPVVfw3XoTZfz1yQVw5jWS9U/gqcRKF3V6iOf3ksdo0Ex+ij/SrfWqIMRouNE
         jp/uV5VSwvxy6SrodYJcZb3qztRnjumVdy80VAjeZj0ZE2FmVkKHadw7qzVvJz5Jsv5k
         dadMPb48+HyWPXDdrFi2vgem9RnP1AW61mRn27Vcyp0PGuY9HfHqPfBQccDwozF7Vd4x
         sMTTIK+kReOPPPll29B42jeZe6ZP+AxLn2iqi+fGxo62dLgFjGo8GS6RX4mu9H/6qR8J
         OH+Q==
X-Gm-Message-State: AJIora/Y+ZbQva5oCuxdiD5gZfgRvI5A/tEQZP5h1CEnR65s80IdPbhV
        UA5EhK1kIzoENsOJVjoK5S8xCEoPMAY=
X-Google-Smtp-Source: AGRyM1toxOQ6GZOX5C9iAC0TrcQrd+ZMPqz1VJ8qL2n+DNOsQyRGlX/ZARQ1rznHLWeOI9jnqRNUyzbhHDg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa4b:b0:15f:b2c:73c7 with SMTP id
 c11-20020a170902aa4b00b0015f0b2c73c7mr21113989plr.164.1657582094045; Mon, 11
 Jul 2022 16:28:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 23:27:49 +0000
In-Reply-To: <20220711232750.1092012-1-seanjc@google.com>
Message-Id: <20220711232750.1092012-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220711232750.1092012-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 2/3] KVM: x86: Set error code to segment selector on LLDT/LTR
 non-canonical #GP
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
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

When injecting a #GP on LLDT/LTR due to a non-canonical LDT/TSS base, set
the error code to the selector.  Intel SDM's says nothing about the #GP,
but AMD's APM explicitly states that both LLDT and LTR set the error code
to the selector, not zero.

Note, a non-canonical memory operand on LLDT/LTR does generate a #GP(0),
but the KVM code in question is specific to the base from the descriptor.

Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 09e4b67b881f..bd9e9c5627d0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1736,8 +1736,8 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-				((u64)base3 << 32), ctxt))
-			return emulate_gp(ctxt, 0);
+						 ((u64)base3 << 32), ctxt))
+			return emulate_gp(ctxt, err_code);
 	}
 
 	if (seg == VCPU_SREG_TR) {
-- 
2.37.0.144.g8ac04bfd2-goog

