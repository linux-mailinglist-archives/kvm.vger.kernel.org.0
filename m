Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8454A164
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352247AbiFMVaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353166AbiFMV3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38293DD1
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v127-20020a256185000000b0065cbe0f6999so5958233ybb.22
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VkR00FIY91tjDpMUCEsQU2PfErV2sywfNrBtcS7WMdA=;
        b=UEPb/R59lq8V0rQq30AmkNgtayiFpIGEWCSalN9r1ucDzSJGzRnBAV01JGW8njwhqC
         lWQO5gk9PF8tD8n20nTTH3SLPkjg/m+VbFCZWv6BgtKjkZJ7B9EXdjAbyfgF3EaD/wU4
         IryCXnecgXVcCT49ytAduSe478drjCJTURMN8X7SgkMQYfWm53xldKgzGVG+OtGCya+g
         mRjWssFxkU7v9KRaL5jNgNwNm1cSf4wyOBeXVU8CBVWcWmWvdAeTs1LkqiWrsoyiLZdE
         aSXEP7njhdjc5obmr6XMESfssR40v+dbNPmwEQy0HuxewMWAiEvKtc/kEJbFV/eShkGN
         9JyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VkR00FIY91tjDpMUCEsQU2PfErV2sywfNrBtcS7WMdA=;
        b=TmZBXmearrvfZVcIXq7Ye9R55lVH/ZbvIcUf0VAGPYILHS83lF4ZVi9654cYJ6vcwu
         N9YDLdOO9IZrQJOgap6prkv3frdT7Qx/P/6/spV3lxTxFS5IphicXaDz4yFdX1Jxya7R
         KAS+XBZvPeiBM0xkroFC0ieLNPQLUW82qEtCMv3ezmK40eq7llTxLsv/TKFqHkLGHiiS
         Mi6ElibBpMlZPaVU03ckmENZj9kIwuc0pHQCa/T1UkwSYV78hw1bWS6dQcd8dDasmfEJ
         HxmUp0oAtGyIqxMQqzjYxd7PGAWk4vXNmV74p6G8AWEVYuPzpmQnYC/joBF1tNQI+kTX
         5AWA==
X-Gm-Message-State: AJIora80cjURPwRrYcVTcj9DDK8WGJ34mjlBfazIv5dCGnXKU8v4egdq
        YLNJffJTbTV80w0o9FTyJMuAgdt3FIyNo9mYBwuoEEBV4YEpM+pZVRBtaM5xOQRlZATVp1q6Kmh
        LjFDJHHuWZnu51UefsuWknm8DDTE+QQ6LFWIhjkbYqRuTnzMWtvaYEa7Fcra7
X-Google-Smtp-Source: AGRyM1sceaZ0bDImwee/oOoIdhrOh/Mf9Twz8hbEsZTH2MRSIYefJttI+4NGXFaKqrCk/yQgMsZj6WphjB0J
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a25:d4c9:0:b0:65c:a345:64a1 with SMTP id
 m192-20020a25d4c9000000b0065ca34564a1mr1627968ybf.535.1655155538306; Mon, 13
 Jun 2022 14:25:38 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:20 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 07/10] KVM: x86: Fix errant brace in KVM capability handling
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

The braces around the KVM_CAP_XSAVE2 block also surround the
KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
move the curly brace back to where it belongs.

Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2318a99139fa..d6639653a113 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4398,10 +4398,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
-- 
2.36.1.476.g0c4daa206d-goog

