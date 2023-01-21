Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B6E67620D
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjAUARb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjAUARV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:17:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE8ABAF2A
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g73-20020a25db4c000000b00802b0159bccso2584933ybf.22
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iSSiGqnlhzGiDLCzSAtleJIHOm3o/jPruEIVdPoSPmM=;
        b=i3bQf8fOpOKYn4DsIRRzCUmnsCj+LMJV96+HJVERlyQV50GGhU4m9vph9dFvXLxh33
         a6PijOok3GOHph4F2aF0Uo8zDnzeIuzhlwcNn/lmpe5ODxgUHA6krkenLMHAVsTMVG8A
         DQOBErL8T8utFKaa2hBwsfFZN+8NkBWs2+uZyhMMxhKrvH43FYJ7I3M1J/lUsHYsC3JO
         fw9Xc1e8mfpAWmMp8YsemFubhIbnl6sBYlN9R8OgKxypq4dN68xuIBEA7FNjAMYzR1gV
         Yu5F1WkIRQy/QQlujBYRghEm0b6qOSbdB7fBbpYVu8C0LSyi/b3WnM5jtqRfovPdsPgx
         hPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSSiGqnlhzGiDLCzSAtleJIHOm3o/jPruEIVdPoSPmM=;
        b=gBTms66VFiH389GYOy8rZ0XML0d7DGKU1ttV7Ol6IT9NG/9z0yd6VsXiWG9Yjheulc
         PlTVE9MACFV/KZ/9OggrOdYbplN7Z3rx+yVgVWy0sin3Ck9DwLeDXEOlzY22LaZNaIp2
         /NH3dafAIGbpfWxfUC554OXBnLgmOvDlO+58WZ9rzp+CLNoYVjZsuGtA48QEETtoth3D
         PpE5OnWRHvQ3Jj89ol2LqRSoHGf1nArYTtYqbPSy7PDzn+J76dvDZC/a7A7+J7eaCKPR
         pspYnuzgekvlEcGIHRNvMGKF2UksFW1yxXm/e7U1Ar9kF0SxnsZ8Mg6AAUejol03WKHe
         N9+g==
X-Gm-Message-State: AFqh2kqX/uOTA60Vi4GbFTs0d8qhytutmbglOCJu59HqWyu1r1yW777z
        tM+8EdjHYvL+LfM/RIRy8greEDFj5511DYRvkg==
X-Google-Smtp-Source: AMrXdXtNm9J3NZyrFD1KxSqYxPFs466v/i5MLLy+izXPoRIE2JNGfeNALA/eYTNAOnPBcLdA/BrRIezn5OXkpRyumg==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:bc9:0:b0:471:d0:fcdf with SMTP id
 192-20020a810bc9000000b0047100d0fcdfmr1932256ywl.108.1674260206107; Fri, 20
 Jan 2023 16:16:46 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:15:19 +0000
In-Reply-To: <20230121001542.2472357-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230121001542.2472357-9-ackerleytng@google.com>
Subject: [RFC PATCH v3 08/31] KVM: selftests: Require GCC to realign stacks on
 function entry
From:   Ackerley Tng <ackerleytng@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some SSE instructions assume a 16-byte aligned stack, and GCC compiles
assuming the stack is aligned:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=40838. This combination
results in a #GP in guests.

Adding this compiler flag will generate an alternate prologue and
epilogue to realign the runtime stack, which makes selftest code
slower and bigger, but this is okay since we do not need selftest code
to be extremely performant.

Similar issue discussed at
https://lore.kernel.org/all/CAGtprH9yKvuaF5yruh3BupQe4BxDGiBQk3ExtY2m39yP-tppsg@mail.gmail.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 317927d9c55bd..5f9cc1e6ee67e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -205,7 +205,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
 else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
-CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+CFLAGS += -mstackrealign -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(UNAME_M) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-- 
2.39.0.246.g2a6d74b583-goog

