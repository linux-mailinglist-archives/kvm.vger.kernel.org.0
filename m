Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E3C6A675D
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCAFeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCAFen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF3C1555B
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:41 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so6133768pfo.20
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bB74MZqXSTBaNxtCuP+Ee510AKnzU0mpDJN+BqnT3DM=;
        b=QMDyIWUGPsPvo3xdSYngMeWNs6Cg8PNr5kGQWXYHYWBVu0QtJg+ey0G9kCZUJFYhhB
         AMHNyhGYuG39hrnuDQDp/yNBTZPefaKN0sm591iif1IeWjTNOHBRkJP/B0Mzp7HuulGw
         juPeEantOSCkO0v6uAz98zELYqKMDmf0GGRSp/ID2DyC7mkN+N2deJlONhpXaqR9om2Q
         HzT/JDbRAEoxbqOOdFwlf2QS+hV0X2YVFwTmVuYh3hreY5nZDB+Wf4VVzIB76/JWVg54
         BKVhbpqcr8vitgyfO0lPnr5RTinONGra2fekqT+tphk76czWCTXAkEh0xVQyYP6l2FAO
         jcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bB74MZqXSTBaNxtCuP+Ee510AKnzU0mpDJN+BqnT3DM=;
        b=ObM2FHNpyKlGEdIGymYp+HHCFW31eXXtGay/fkkIQWRCP9GVovapwCgZruWkIlpw9i
         Ecy90eXHHCv7nNW98RDi1fsW9v94vRLaIZN7JGQKdeIkVgBai88VnzDt18vnmKMVnQcg
         WcRH6CEvrfJxRpWekrzE+5Jo7aRLD5bhQOCFv1YzXzNYkKxFCmjQOPOPQyi9jWuBPe7k
         70sFHt5qt+u+jgCQnJzCzT2+GX+ptQx5JsiCoJztNbWNbp39HaU+zR1qnPNorGBMRXWM
         tVhAmeZt6ViImvSw0sscUvKVAs8aNfsM6ukPOK3vjEA7ixw7ZFGccabVUYeciSl8La5y
         WGlg==
X-Gm-Message-State: AO0yUKVTlg2RbVz863oRLNPT7+KpilooUo78kWXqrL6MeEf0Vg4H+O1a
        SgN0vP+M/89Sw5wnp1WeE9pgMvjKAZHBw54Uh2GLVdudZeECArIRi7lvhZvNViheSZJRGikg5ur
        CXJXgM69OpJdHVUGadYZwcNXGgdOEo+6E1WuOg6OQ5Y2Rk1c0jT6xVl1jZ41GEwdPLvxH
X-Google-Smtp-Source: AK7set8I+7ELSK+q2cxylbja8RJZjGuyJnJzoYABWDX3NaaL1pTaQvJ8g6qYbjcHljZzk8vsoWKQfeaA1iOqgRj8
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a02:288:b0:501:f894:ae62 with SMTP
 id bk8-20020a056a02028800b00501f894ae62mr5157268pgb.4.1677648881093; Tue, 28
 Feb 2023 21:34:41 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:18 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-2-aaronlewis@google.com>
Subject: [PATCH 1/8] KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The instructions XGETBV and XSETBV are useful to other tests.  Move
them to processor.h to make them available to be used more broadly.

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 19 +++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..62a5c3953deb 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -496,6 +496,25 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	__asm__ __volatile__("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax | ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	__asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
+
 static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b67..4b733ad21831 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -68,24 +68,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
@@ -121,7 +103,7 @@ static inline void check_cpuid_xsave(void)
 
 static bool check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	return xgetbv(0) & XFEATURE_MASK_XTILE;
 }
 
 static void check_xtile_info(void)
@@ -177,9 +159,9 @@ static void init_regs(void)
 	cr4 |= X86_CR4_OSXSAVE;
 	set_cr4(cr4);
 
-	xcr0 = __xgetbv(0);
+	xcr0 = xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
-	__xsetbv(0x0, xcr0);
+	xsetbv(0x0, xcr0);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

