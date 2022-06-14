Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E754BB8E
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbiFNULC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358054AbiFNUKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:10:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13FD4D9D9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l5-20020a170902f68500b00167654aeba1so5355358plg.2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/uGXcjYgRdwThYzoVEngvsjuBTkNgyg4uSxffZc50Bk=;
        b=pzfVMA20p2pnNldqq01nGCMA5u/qRXcRcGB7M5KM+fz/WvBFzJMig40OUcz7HZ7WRe
         M5dmPWiMIisozQJp2yWvSJqz0rej3BW1dhb1o8s6sv0ceYHY0/0xHDFtEcjHpM912iJf
         ED7ooCsSdoKKLIro/Xax0qMRIZ3fBCu3Su0BsRbb5l1jrXg/j0cn1lDScQ9UwZaLZy4T
         7Gh7BmDpDDXUobaRtKDaNyxEX2dVwWoCtnlFOwlUGtHnhR04IIg5pwD9Ve9kouqjzJKA
         jmkYJ8+UB7yTEEIwkAbML6UzIZfNQWcuK5MeaqxnSPf8yk0VaJ6DwrhF9iX8lnOZzq9E
         hN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/uGXcjYgRdwThYzoVEngvsjuBTkNgyg4uSxffZc50Bk=;
        b=DucMh1v0wRXc1nMUmeZ7i+dJ4ou8d1JSkFjOm9uiUwLT0RQqesQ+OY38bTKiLVgqXP
         QPhYLjDb8BYNqmUKiVjdy0Zi0AoHKBLOfzfDFSA2/0eqn43h3+149guriYnlTW3jclOo
         8jes8Tpn7P649DIM8CzTJiqFxHvnIJ2sxO3hJg4/zLQ8cdjwB5qivaR2reGtaFwrUOWb
         h72B7Eh4QsXKbpMJBUm0YJ4HqJjgM7cLL/AfPj0abZL0Sk8pdSE+sdC9gvBkQ6wLDs8t
         VjrjzHCaDPZJ2Ncp2xX/40ayMsLsCSRqSUuPvtlMmb5fXskse9biSgVFdhpKQNO04FHH
         jK8w==
X-Gm-Message-State: AOAM531dgqVJAmld7OAXbTGU1KBBxt6sbn90TnlMqyI5Ug3+RIijqq7f
        zB8OVdUebEIcKyYlgXtL9QMHomDIcp8=
X-Google-Smtp-Source: ABdhPJyx++YntFm0WsQdNfldGACaB/WlL3fz/aantDLV1wzIbzfVFkyeMg44LApwWEef3B57OG4/I6G9LgI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4406:b0:51c:244f:85d8 with SMTP id
 br6-20020a056a00440600b0051c244f85d8mr6275367pfb.36.1655237305726; Tue, 14
 Jun 2022 13:08:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:06 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-42-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 41/42] KVM: selftests: Use the common cpuid() helper in cpu_vendor_string_is()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use cpuid() to get CPUID.0x0 in cpu_vendor_string_is(), thus eliminating
the last open coded usage of CPUID (ignoring debug_regs.c, which emits
CPUID from the guest to trigger a VM-Exit and doesn't actually care about
the results of CPUID).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d606ee2d970a..936ad738ad4a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1011,15 +1011,9 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state)
 static bool cpu_vendor_string_is(const char *vendor)
 {
 	const uint32_t *chunk = (const uint32_t *)vendor;
-	int eax, ebx, ecx, edx;
-	const int leaf = 0;
-
-	__asm__ __volatile__(
-		"cpuid"
-		: /* output */ "=a"(eax), "=b"(ebx),
-		  "=c"(ecx), "=d"(edx)
-		: /* input */ "0"(leaf), "2"(0));
+	uint32_t eax, ebx, ecx, edx;
 
+	cpuid(0, &eax, &ebx, &ecx, &edx);
 	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
 }
 
-- 
2.36.1.476.g0c4daa206d-goog

