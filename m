Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2FF6E145C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjDMSnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjDMSnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:01 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908C983D2
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k36-20020a05600c1ca400b003f0a7c483feso1711424wms.4
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411357; x=1684003357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYXXnoJo+Fwln2HbBX+xMIeux/r/zLuBKEudRVnzx2E=;
        b=nkkA8q2rgTsyLijgsc53fPGfUHqn1lg3v7jT8eSoPG7D7aO/Jx48zvh3GwoRFWwZVF
         D79CjpffokQYS+buYX+8s1RksveTyO5eLnfxwDzJMDO+3n3eQDaOE0BNlz09I5Kn78VO
         Y0RKRYj6HrYb6GF6ueMwMTnR4q90IusmiA2gCbh4PDX9HnGMGk9QQgngNwaBX6O1IWHn
         r9/yrYlUc0CbuS2LZ8c8vRHlec+vNnMajXxtF+vux9pnnaBTISioTP5FA+5zVBbpEgYR
         P3uJ5TXrYaEPF8PgE2wjfFdXuVZkl/pxwwI8ICPVtiHB9kXhlZHk99jtJ+QxRMztKw+G
         cYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411357; x=1684003357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JYXXnoJo+Fwln2HbBX+xMIeux/r/zLuBKEudRVnzx2E=;
        b=QN0Y+J/GFrIbEVeyoF+9C7UPe5a5ZrIc7KecTLhoXQnnImo0SqWn8M7LXxmQx0+G7r
         67nqoWZglW6cj/vFuld84sikdHWAoKI/IEztsh3aNyEaTspDV0xOoTMChtEXwHOXF2oD
         QxnrymWshlArjogEm4a4CzgWpNGj1QnwMFzKlrpN4Bs/WxXD+cH3ByhiBn/KWaDTXI/9
         mnCzzLF2aca4lb915xD3IODamuRcBkQDM3dU5IfEa7AdITwXKveTCSakediYosEuFt36
         eLmzGEdLwkkYQTy68K5UgT2FmiEAhpY9DeV/uKeRGZ500JUIk8Cx3py0SqEuthJcJPqs
         MsyA==
X-Gm-Message-State: AAQBX9e3Y0q2Mza3LLHPhyRWPm/xEZkBQxvIMonkqtWrPtqZRB6xJ0f8
        cxpoC/bKfTO4HnelxKuKLo9qeg==
X-Google-Smtp-Source: AKy350b+yioJVqwTnhXmfEtT2Zt5y8j8F338o1kKSbmRYa7hxA2pw0ClhQE90DxL7xrTbkHC9K1RZA==
X-Received: by 2002:a05:600c:3783:b0:3ee:1a70:7ea2 with SMTP id o3-20020a05600c378300b003ee1a707ea2mr2157294wmr.3.1681411357154;
        Thu, 13 Apr 2023 11:42:37 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:36 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 02/16] x86: Use symbolic names in exception_mnemonic()
Date:   Thu, 13 Apr 2023 20:42:05 +0200
Message-Id: <20230413184219.36404-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use existing symbolic definitions for vector numbers instead of plain
numbers and streamline the stringification further by using a macro.

While at it, add the missing case for #CP.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/processor.h |  1 +
 lib/x86/desc.c      | 39 +++++++++++++++++++++------------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 91a9022ef43c..5dd7bce024fd 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -36,6 +36,7 @@
 #define MF_VECTOR 16
 #define AC_VECTOR 17
 #define MC_VECTOR 18
+#define XM_VECTOR 19
 #define CP_VECTOR 21
 
 #define X86_CR0_PE_BIT		(0)
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index b293ae420f86..9402c0ef59d0 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -110,25 +110,28 @@ extern struct ex_record exception_table_start, exception_table_end;
 const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
-	case 0: return "#DE";
-	case 1: return "#DB";
-	case 2: return "#NMI";
-	case 3: return "#BP";
-	case 4: return "#OF";
-	case 5: return "#BR";
-	case 6: return "#UD";
-	case 7: return "#NM";
-	case 8: return "#DF";
-	case 10: return "#TS";
-	case 11: return "#NP";
-	case 12: return "#SS";
-	case 13: return "#GP";
-	case 14: return "#PF";
-	case 16: return "#MF";
-	case 17: return "#AC";
-	case 18: return "#MC";
-	case 19: return "#XM";
+#define VEC(v) case v##_VECTOR: return "#" #v
+	VEC(DE);
+	VEC(DB);
+	VEC(NMI);
+	VEC(BP);
+	VEC(OF);
+	VEC(BR);
+	VEC(UD);
+	VEC(NM);
+	VEC(DF);
+	VEC(TS);
+	VEC(NP);
+	VEC(SS);
+	VEC(GP);
+	VEC(PF);
+	VEC(MF);
+	VEC(AC);
+	VEC(MC);
+	VEC(XM);
+	VEC(CP);
 	default: return "#??";
+#undef VEC
 	}
 }
 
-- 
2.39.2

