Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AB452282B
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 02:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiEKAI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 20:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiEKAIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 20:08:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F552F02D
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:08:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so236638pfn.15
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nd70IAruy6YLk7HF+wmxASsgGrGBVsuWU+XIZwvh4Kw=;
        b=nhFPNERpqCW2rbwKZXsNo79ee146E7oAuRVFLoP1ULP1eLhKBZkBSWGlvsR3Buku1a
         LrFupfFPfU4SygJO3xlFTVJkZon9R0M3LCnghz0wiLa1uWHVtSlqckrCxf98GzQd1cWH
         rb0EsdVmyTnTNjTjeCEK4r/KM1nYOFzWN80jJtWwzzs50Q6PHlpuu3moK5L6jyZ5/iCu
         8wFdv3qhr1iVLv4gmcu+EQscizQT9MMTJBy9j1GHVn14TS8Lpbnc6VK8SpprHPTbpVxN
         5NHZrJ70cnR7POPlCM7If2iz52B88ke1Eq5dKx+4ngNc47S7T9J1H3M2CF3UmI3TanrW
         1okg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nd70IAruy6YLk7HF+wmxASsgGrGBVsuWU+XIZwvh4Kw=;
        b=YCR2dbBs1JvM2A94WV84pOIXB1m1nWwayxptbuVmOjQcw6fE0Py9ULhSunZg5SGD2d
         l2wgXPe3IyEpmruc0Fws6ddjS5b/Y/Z6C1nuwNDN2/OZ5tLy0B5waEfZrwh8hRcDN4Uj
         Eimy9cepZq41FPZWEIZyaieM1jylGVBfFPwIJkQs5qUmPOhNDuwMI7VVCEkNCORdzRha
         UcgT8lFqmNVXgXoq3jh5rwopwtV+ZOoSnuZQCDB+pPmrlPXXVkhURNzP9nTrTHgirI9B
         vX6vCvUNS/TUM4P9XCFW5+vtVRsUOXp7JwKli34c6PaPXnJXuxrLTKzShB1V7ZAuNPcm
         varA==
X-Gm-Message-State: AOAM533291fM8/kpb86HOdNtoD1lKqIYXFnbFrCSTUXr7IUjlzDguEm0
        I7ASlBUn/cs5Cxo1L0ykd5v389hAiAKzhIRw
X-Google-Smtp-Source: ABdhPJz43OpKlmYlcMGSh78/cL9Iy9s6NHLb4cSgmpzz40FSTyAhNdUD62Iydw0OAWV3QlFAIOgqxxRMVhzAdxYm
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90b:3e8b:b0:1dc:e920:e072 with SMTP
 id rj11-20020a17090b3e8b00b001dce920e072mr2380190pjb.151.1652227703435; Tue,
 10 May 2022 17:08:23 -0700 (PDT)
Date:   Wed, 11 May 2022 00:08:03 +0000
In-Reply-To: <20220511000811.384766-1-vannapurve@google.com>
Message-Id: <20220511000811.384766-2-vannapurve@google.com>
Mime-Version: 1.0
References: <20220511000811.384766-1-vannapurve@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC V2 PATCH 1/8] selftests: kvm: Fix inline assembly for hypercall
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, shauh@kernel.org, yang.zhong@intel.com,
        drjones@redhat.com, ricarkol@google.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kirill.shutemov@linux.intel.com,
        corbet@lwn.net, hughd@google.com, jlayton@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org,
        chao.p.peng@linux.intel.com, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, marcorr@google.com, erdemaktas@google.com,
        pgonda@google.com, nikunj@amd.com, seanjc@google.com,
        diviness@google.com, Vishal Annapurve <vannapurve@google.com>
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

Fix inline assembly for hypercall to explicitly set
eax with hypercall number to allow the implementation
to work even in cases where compiler would inline the
function.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..4d88e1a553bf 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1461,7 +1461,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 
 	asm volatile("vmcall"
 		     : "=a"(r)
-		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	return r;
 }
 
-- 
2.36.0.550.gb090851708-goog

