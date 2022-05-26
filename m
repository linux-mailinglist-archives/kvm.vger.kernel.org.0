Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19B85352CE
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiEZRkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348346AbiEZRkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:40:11 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC149C2E3
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:53 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id y15so2509031qtx.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yr9uFicSLJK96JT2VOmPXiqzHrQ5NijsekboH2rmb8w=;
        b=UsQACwvlL/Xsn+EOjXVoRwgBWvaTrBmhNoyrVNwhL+vUgD5ZeNy3171OLUWHa2dNyJ
         v4gv8G3IhRALPg0Nn3kbL2TVhH+EvcKqgS/iWSdS0k6c41psGV2RTeLp39JjV3+wrT5f
         bmGLvVIg55VRxxOz+y/EAfG9fDFLwVwSsVhDVnQ3FOhUU10ywrG1a5mBruXbaFI8OMDO
         j0DYU8WTzbLjG1DYd6xclNNFKcnZCNBWopNIh0rOPS5Vl9ITmGn3XsomZBpjoAyS3B/m
         nUPTBDKESXd+VxtIES/rxkaHQEhpG4STbXKeu/iKKRx4KcFW+AoHy7zwYL3Ra02KfRVm
         LXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yr9uFicSLJK96JT2VOmPXiqzHrQ5NijsekboH2rmb8w=;
        b=Y8iOTHNVGfFwodere4cmNuZhMTxyp+gNOVCNJFrW4Tus/XFn2gJLyVoY+HlYzhzrP8
         2ROkQ8WAjGkkUevkv6REDeWdd7ebyhbmZZaZ4MY2fWls+4p35mMsaKa1tp7XwOZgGXT4
         vGrGip3QlMRwOMYNN//AXwju0uyJXi/jaW3LNfgPu6nSruekdOgXSfNFqbcLApNtAIaY
         bQ7ueNpFFzdePo3N4yg7fJ4KBBuUyx453uKF36sjrMbRh+DyhWVVTxPmC+PJH5S1SLdj
         /zg/zWy+iarBxa6couTxkaQ1UyoQjUZyDE8dVbQNj9cUvXNuydHIN9UkhITmLz+/Uy5I
         BVjQ==
X-Gm-Message-State: AOAM531d8w8TyvYKD5NR0ZRvUiqug4CO086obDehtJkM4bsNxdLQe6ag
        +0VmwTTrw2Evp+2d7CqmwPLPm06ycNe/bVYG
X-Google-Smtp-Source: ABdhPJwwvlRolQMQUQLr6byQ5mQkR82pK7+qZ2A/+ZhctJATe9uTk4kqEdl9lL1ocuwG+m6i0st8qA==
X-Received: by 2002:a05:622a:38d:b0:2f3:c9f7:bfa0 with SMTP id j13-20020a05622a038d00b002f3c9f7bfa0mr30281804qtx.404.1653586792220;
        Thu, 26 May 2022 10:39:52 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id bq15-20020a05620a468f00b006a5a07bb868sm1592257qkb.119.2022.05.26.10.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:39:51 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
Date:   Thu, 26 May 2022 17:39:48 +0000
Message-Id: <20220526173949.4851-2-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.2
In-Reply-To: <20220526173949.4851-1-cross@oxidecomputer.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change x86/Makefile.common to invoke the linker directly instead
of using the C compiler as a linker driver.

This supports building on illumos, allowing the user to use
gold instead of the Solaris linker.  Tested on Linux and illumos.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 x86/Makefile.common | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b903988..0a0f7b9 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,7 @@ else
 .PRECIOUS: %.elf %.o
 
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
-	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
+	$(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
@@ -98,8 +98,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
-	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(LD) -m elf_i386 -nostdlib -o $@ \
+	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
-- 
2.31.2

