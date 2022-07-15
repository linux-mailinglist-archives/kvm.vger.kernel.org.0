Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2882576771
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiGOTbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiGOTaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2296171B
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a8-20020a25a188000000b0066839c45fe8so4513938ybi.17
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TAzWPzxWt/xQfClUKSK8iVRAelG3qw/M2QmSChpgMSI=;
        b=YNM9JNlWqYCDiOo3N8HlI4kB6O7IiOnhbpDLU5h7U/5DOLcS/NETWbGtl2M5UsAjeU
         5FQs1H/BQZETak+scuHq+3xxRENuOnxo3ZmnHKeUYLxlRlA94cNAd8IT2pFoqRcmPIKK
         0o+27bCLWXWn2JJ0w10g5lPDoerBxd2qYVjX8W0aAkiNCeA7OC53VkZo84reYKvo98vM
         +KGohTOxpTC1z0XG4DcXsZCENDMLVxCcONr7EYF+BTbtMzbe1cGhG0onOvPAgH4QM+Yv
         3hRGC/jitECNYZz7Ls9gWgR4kWwNkm+YYB2DCJSIhRyYrHMrRKHDe0Hw3hqv6da++U02
         Ytaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TAzWPzxWt/xQfClUKSK8iVRAelG3qw/M2QmSChpgMSI=;
        b=gy690+KSaOAZR14/OS+3w7H4/n3ntx4rcNP/sZWRJelYTqmUeQuLv/Z2xByzC/txtZ
         Bv1hkPXaOehWv7OTIhWn+rpTJlX8YgmkMFj5OUW0tqRxX38AI9LPzlERGqGQxmzAmtkp
         ra++ae3MHeEEOHZaPMvztzScOCLVrt3UhivBuyUKB5tF8oFvP3EhN3I4Q8d63fc2/Vwy
         NF/8Hq/k9ppCLJZpND5Ot2scvxQ3AP0ly/fu87SSNjrt7slH1G0W/276lztKmLlafIq4
         1jnrkVS5Oo5JDjb57snS88EzVcwyHjANXqP3LpIK+Jum4ko3xCRjhvthvSJZbWEKO9Yg
         IOKA==
X-Gm-Message-State: AJIora8Ocq1eG9Bf0e2Rg1hTxF5ZDUSH8oefFtRPPYILxi2ZdiEVX0Jp
        S/DhDBQ+qG8E9cg72g8uM5mMpJJ9XveBbxOfaFQ9JlaQVWVUUpNcg4dY3HTX83MCe6KeYXSvcZV
        kZg6XKYAJDM4OvC0IZONWbFS2CVzqo5q9XqthltWbYxF6ltXouYEzluRpmA==
X-Google-Smtp-Source: AGRyM1tRj6psVB1GLADfUquHWkwvBdbCnSPQ69Mq1ZfxyCnynBeVXK2A+5crNaMaFlFr3oKyKuVU8aftytc=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a81:6cf:0:b0:31c:913c:144c with SMTP id
 198-20020a8106cf000000b0031c913c144cmr17753756ywg.437.1657913420660; Fri, 15
 Jul 2022 12:30:20 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:53 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-9-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 07/10] tools: Add atomic_test_and_set_bit()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

atomic_test_and_set_bit() allows for atomic bitmap usage from KVM
selftests.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>

---
 tools/arch/x86/include/asm/atomic.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index 1f5e26aae9fc..45ea15c98957 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -8,6 +8,7 @@
 
 #define LOCK_PREFIX "\n\tlock; "
 
+#include <asm/asm.h>
 #include <asm/cmpxchg.h>
 
 /*
@@ -70,4 +71,10 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
+static inline int atomic_test_and_set_bit(long nr, volatile unsigned long *addr)
+{
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
+
+}
+
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
-- 
2.37.0.170.g444d1eabd0-goog

