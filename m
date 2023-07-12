Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6A750EA6
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjGLQfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjGLQfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6AAE69
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:13 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b9ecf0cb4cso15108625ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179713; x=1691771713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzGjaoeBd0ts6vFLylivuvgD2i2XVtzgKrFzR+HLz4A=;
        b=KWXvLlbh/lNcJ7Ki6QTYZyRNkAroc90bwY0YluGEEgiQAtOeAY2C0j1objj5/efuYN
         O4IHXykOn1m5WDDXbViJpkz6NeSLCGLKoIZ6lePYRY2hI3WtOB6+HybMnlmN2ERVR/Iy
         yfbDIsXUAmV0CM8J9uiu7zFrTf10jhoc9Sqe6Lw788OlOxO8i+WFC682u01W3BnA0oEi
         FyO9UC9HHrfOcuj15unF+WU/Q4kqWsHRRwL7jXtk7ckUYyAIbL395V1H0idz3CjTGfZG
         8K1pojnV+2jnpvwHRDbtJPKYGlZcSWenh98VAChlxMzhmK5pGZ8oW1GqmlitwY07vo+f
         dGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179713; x=1691771713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzGjaoeBd0ts6vFLylivuvgD2i2XVtzgKrFzR+HLz4A=;
        b=GziEPJn7rfyfeZ5b+yvvl9TrtJUgqOxn/Q+UNf54QzOyNjEU1Cvk+Ce5PB2qY7B3g9
         MMPcSbCiqk5UlhFpyz+Bifpn4AR3Z59pBw2P5OQ1ajL0tVe7lrteXvEfZ2PvjVp3MK5p
         DaJqfgb2AWqf6hxiuJMNo0xUit0YGmoL3pdEFB/Zyb0BxWdlf9vQNPRr+Uka9LLCKYv7
         qOLb9HTrFWFVlsiXOd/WKoWiHtqNXOzTcBRWAYRMVcozUuQ6Bq+pFkmsxkDcYfFJirmQ
         dxsjHXCRMOUA+KeBZQV1pzdDfLN3bLsIQWGkHa8wvYD3F+Q7z2fBKahK/WmNxLCjuG7k
         JHLA==
X-Gm-Message-State: ABy/qLahrkKj9lDVXu8Fl95UrfffSRNn7oUc2PduX6B2L92JMWdDOMGH
        1v9Bbz4+tb7FrkNGO/yJrAyb4Q==
X-Google-Smtp-Source: APBJJlGQSUMfivEnSLMxD2fIklX07FMaCpu88LY8apHaEoetX7NqU0m4okbql8k3yfBPlboYaSEfpA==
X-Received: by 2002:a17:902:e74b:b0:1b8:9b5e:a218 with SMTP id p11-20020a170902e74b00b001b89b5ea218mr19069369plf.42.1689179712954;
        Wed, 12 Jul 2023 09:35:12 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:12 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 1/9] kvm tools: Add __DECLARE_FLEX_ARRAY() in include/linux/stddef.h
Date:   Wed, 12 Jul 2023 22:04:53 +0530
Message-Id: <20230712163501.1769737-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Latest x86 UAPI headers uses __DECLARE_FLEX_ARRAY() macro so let us take
this macro from Linux UAPI header and add it to include/linux/stddef.h.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/stddef.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 39da808..d94e900 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -7,4 +7,20 @@
 #undef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
+
 #endif
-- 
2.34.1

