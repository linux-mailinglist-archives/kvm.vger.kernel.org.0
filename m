Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB4570E47
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiGKX2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiGKX2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 19:28:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4A8AB08
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cu3-20020a056a00448300b0052ae559108fso225134pfb.9
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y4c9+hRyXDtn+HmMTY8LBUAXVpb8i20If3SwC4b4N10=;
        b=GOCG7wXwJDxav8DI1JKokVLWSeeeAe5t3C9q4/j0GVaKqzLkuo38RYOe27JrYuldnh
         cQqaShlay2vxnFPl8uPzovSvzyQDlwGosD1hsPkBswnfl1Cb42jlFMT93jdKLD3BR5Zd
         ai/QhN2ho/28LYidGARFUjr6DEM6TlNjDv+MRMcY+r6DjBaFbTAoy8wonS/hHVu7DS7I
         UFB6VpfIDXNUFnic5AsuTCR0wwTGtehvYa+BOa+UCbkbhT6/qf4suunrKOGAClZozuqQ
         qEAppRWbpavzENbRUC+WpnMwKO0CzbcPV7tLbO1zuOwAtkJVQSGWwecH+CYEnYRSiHSb
         1CiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y4c9+hRyXDtn+HmMTY8LBUAXVpb8i20If3SwC4b4N10=;
        b=6UrvUb0eRcKKEuAyJJGewMywoPi16ryBuVMSWrHftJMPFPty24GL7jBAe1WjiYBlrd
         5Vrv3t6PICsB+jUX9Y1K/1GI1Fnv63KlrhTa9VZHPMqpvTgK9ihdPwQ9IpOxEjUp5wup
         XpEc/eVqhiut7SEo2qWsWJVYDnmHcaGVcfOnepaFyXafx5kozXUSjm/X9dSnrM4Q7BOv
         RGjjSuOpq136qIVIG9nc08u2NQI4eQbdTlLNFG4Sg+rpoEaDmC+OxDggnYIKm24g7v7Q
         T4dtPLOnzEOwdTEKY2nksBXvf82UrDMeoDvZVTYgDnME52c+8sLLJ5TtRYsKSTb0D0zv
         JbBQ==
X-Gm-Message-State: AJIora8upNbrlrmkrHd34YrgJzSR5eGPu3Ujz/41hCwefaEmPu76ugSP
        PZjrim96Yhv0lQMSS+mqiZYT1A1d8+E=
X-Google-Smtp-Source: AGRyM1sTdQbj7QIQ49xadb6Yn8ZwM1BxYmn+FDHHDGJJ26V47pzTBaXpM6yfN2XMfH4QjPGtQA+AXCFvb0c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a6:b0:52a:e089:e777 with SMTP id
 bd38-20020a056a0027a600b0052ae089e777mr2824888pfb.53.1657582092309; Mon, 11
 Jul 2022 16:28:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 23:27:48 +0000
In-Reply-To: <20220711232750.1092012-1-seanjc@google.com>
Message-Id: <20220711232750.1092012-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220711232750.1092012-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 1/3] KVM: x86: Mark TSS busy during LTR emulation _after_ all
 fault checks
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wait to mark the TSS as busy during LTR emulation until after all fault
checks for the LTR have passed.  Specifically, don't mark the TSS busy if
the new TSS base is non-canonical.

Opportunistically drop the one-off !seg_desc.PRESENT check for TR as the
only reason for the early check was to avoid marking a !PRESENT TSS as
busy, i.e. the common !PRESENT is now done before setting the busy bit.

Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
Reported-by: syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39ea9138224c..09e4b67b881f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1699,16 +1699,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	case VCPU_SREG_TR:
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
-		if (!seg_desc.p) {
-			err_vec = NP_VECTOR;
-			goto exception;
-		}
-		old_desc = seg_desc;
-		seg_desc.type |= 2; /* busy */
-		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
-						  sizeof(seg_desc), &ctxt->exception);
-		if (ret != X86EMUL_CONTINUE)
-			return ret;
 		break;
 	case VCPU_SREG_LDTR:
 		if (seg_desc.s || seg_desc.type != 2)
@@ -1749,6 +1739,15 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 				((u64)base3 << 32), ctxt))
 			return emulate_gp(ctxt, 0);
 	}
+
+	if (seg == VCPU_SREG_TR) {
+		old_desc = seg_desc;
+		seg_desc.type |= 2; /* busy */
+		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
+						  sizeof(seg_desc), &ctxt->exception);
+		if (ret != X86EMUL_CONTINUE)
+			return ret;
+	}
 load:
 	ctxt->ops->set_segment(ctxt, selector, &seg_desc, base3, seg);
 	if (desc)
-- 
2.37.0.144.g8ac04bfd2-goog

