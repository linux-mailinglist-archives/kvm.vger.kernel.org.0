Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE92962D687
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbiKQJWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiKQJV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:21:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3008697C2
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:50 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a25bd88000000b006dda2c86272so1037523ybh.5
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8/cKQPsYeoJ6WZzz3pgJJPoeRh1qwoT0hPqple+G7I=;
        b=qtLk7Kyj04/36JGUurPvVlmER2lO20Sap99vJK/lCF8P7Rx2+ibCgWV/IWzCIAt2Bs
         PuctttN7P1WWgieHXWKgLhmiyDn/SZB7QK6t7daZQSMLx4OP+KgLNdagUPzM4ES0FB1X
         AIPwsdYXcyxB2+Tgf4lcGrV0nqqtZn1ZozJXifETfCQ5bgr5bVPZUMsFrRFjbiC3zSSL
         I7PqtSMMhKU8iF2ssEiwHLBHhHcHipY5oGDzPRjIsKVBz1tbTksqw6vRUYn5hT8bkEZR
         3QdOuy+iYUXFRF4fzpfn5KNsdVoZKsd7Y6ApmaBiDeicB1fHhPT+ypymUaeOL2y4cEw5
         6/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8/cKQPsYeoJ6WZzz3pgJJPoeRh1qwoT0hPqple+G7I=;
        b=F5DWWZOLyjipythGu4dcaUBk3nV0k9wembWjNvupPtmDrub5Uz/4/vRzB84oeaBbTP
         hcuOZGRTT8o2eci9VEQgsb3cKz/PEfiuI5yYmJyVvrFef8FG8vAkZnMMAIPngZO7QURu
         hKcMzg91d2UraSLV3tPL2fuvlO4qD+diJd7a8sPGRjrZ0aUQ4J9ND0KPSZYsRkN1jg1j
         8Q6M02lylV4bKMrAv5YOGTuAT/UZRTe+Bvm/wbjY2oQPTIoRbMPfX/FeX4+Jr+scEzHT
         DjqUsQ1oHMHqgNmBQKwlrqPIc2has8ksFzgIFc2bUEXyexIK8sK/iv57GLWJaG1czbnf
         cpIQ==
X-Gm-Message-State: ACrzQf3C3JKgsgMNhSYflV0I0/1JeiKk2Gknsk314q/xblmzLendRgDQ
        wMZqUN1HYxGUx0Xips/upI4CdajBHcybnA==
X-Google-Smtp-Source: AMsMyM5St+3pGP0Ci4+t+wwjSn58P+dUHUog2NS1eeJ8T4E5iaP/eP0MNajlJ1dq2KBRNvyd0Il6tIRWjiKe3g==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:bec1:0:b0:6cc:57e2:6f2c with SMTP id
 k1-20020a25bec1000000b006cc57e26f2cmr63010965ybm.544.1668676909490; Thu, 17
 Nov 2022 01:21:49 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:41 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-24-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 23/34] x86/speculation: Use cached host SPEC_CTRL value
 for guest entry/exit
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bbb69e8bee1bd882784947095ffb2bfe0f7c9470 upstream.

There's no need to recalculate the host value for every entry/exit.
Just use the cached value in spec_ctrl_current().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index e720dee4d30b..8ab96965bf28 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -198,7 +198,7 @@ void __init check_bugs(void)
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = x86_spec_ctrl_base;
+	u64 msrval, guestval, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
 	/* Is MSR_SPEC_CTRL implemented ? */
@@ -211,15 +211,6 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 		guestval = hostval & ~x86_spec_ctrl_mask;
 		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
 
-		/* SSBD controlled in MSR_SPEC_CTRL */
-		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    static_cpu_has(X86_FEATURE_AMD_SSBD))
-			hostval |= ssbd_tif_to_spec_ctrl(ti->flags);
-
-		/* Conditional STIBP enabled? */
-		if (static_branch_unlikely(&switch_to_cond_stibp))
-			hostval |= stibp_tif_to_spec_ctrl(ti->flags);
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -1274,7 +1265,6 @@ static void __init spectre_v2_select_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
-- 
2.38.1.431.g37b22c650d-goog

