Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FB2520614
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiEIUo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiEIUoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:34 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD0B285ECA
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:34 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p26so12599500lfh.10
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WA4bqSkwRvXPCr2i6PkIlB+a6KUj9JwkAAaoN6M6AmU=;
        b=ZqUJ32ZJYrYy2H1W/PASpppByDAZ9hy7pWq7wn/V952r+qLtA7Y6pGR6sEjZgjloMD
         9O9utOE3G7o+Rx3Ar0/jhCowjTYpNLml7uelNAsS6Ehpy3CeDwOwSEoMyv6x2dGkOxoJ
         CHC85pRqiscRmgOVnk7YYQqvIfURqQbpCWSNSnprjgqCD2YBiNTCp+LiVwL8xEUxAgRX
         FOG1zJ/nn9Ef1Z+4FNAYPqJS0LmaAExrHWvt/cBVZ8X9ry6v+g8XcRtgv4h9c9jhvoRs
         jcpj1DBAE6YWxKWAv/owXPcbmxdIzLfvKmwk27xfBLzBkCLPBioM/FPF4+F2rwVIsUPI
         O2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WA4bqSkwRvXPCr2i6PkIlB+a6KUj9JwkAAaoN6M6AmU=;
        b=Io46LeFQb9/t8rhQjKgDxXGfkHdkYrggVOjp8/BCsgihz9CXwRXTXhYF+XsczyKuCF
         KT0t+RTBOCxlJz+xMpPvE8qL1zUjS4sf4la96FxeIyuwHNa6Khs0XfICSq/wOZ5sUmrq
         T4bqpJ5ezMcfYbmdtvtSJxlJh9CTZgXyLr+5LuhJU5E+T/XfyhjbhRww18KGFmFtpIWo
         u42XCkQUvyc4ZBRh0jSJi0GJ+ZShk0KFyAPivust+rEO8vInZk1Nx50+NixFyeEIyWfa
         bn+8UUxFVIWk5ILMV8iiSeIN3fr3t286ocQfBiB4tLx40bbGArxm+sZWTXRAvkxGxlun
         WQqA==
X-Gm-Message-State: AOAM5310fNIec7T4K5P9iDytEfBmNiNSD6+2o1iLvyyodcnstSBrxoj9
        BDZ52iP77rqyZ/69DUS9oNmZG45FB0o=
X-Google-Smtp-Source: ABdhPJxVDZnmCwVvFQ/M6kEaViojyuk1tt1HNq/YE1YPCLVDH/pFjZoSuf5nzZg7ydhqOS8r2dpl7A==
X-Received: by 2002:a05:6512:1048:b0:473:c648:c5c3 with SMTP id c8-20020a056512104800b00473c648c5c3mr13838447lfb.487.1652128833084;
        Mon, 09 May 2022 13:40:33 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:32 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 6/6] kvmtool: Have stack be not executable on x86
Date:   Mon,  9 May 2022 23:39:40 +0300
Message-Id: <20220509203940.754644-7-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes an issue of having the stack be executable
for x86 builds by ensuring that the two objects bios-rom.o
and entry.o have the section .note.GNU-stack.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 x86/bios/bios-rom.S | 5 +++++
 x86/bios/entry.S    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
index 3269ce9..d1c8b25 100644
--- a/x86/bios/bios-rom.S
+++ b/x86/bios/bios-rom.S
@@ -10,3 +10,8 @@
 GLOBAL(bios_rom)
 	.incbin "x86/bios/bios.bin"
 END(bios_rom)
+
+/*
+ * Add this section to ensure final binary has a non-executable stack.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/x86/bios/entry.S b/x86/bios/entry.S
index 85056e9..1b71f89 100644
--- a/x86/bios/entry.S
+++ b/x86/bios/entry.S
@@ -90,3 +90,8 @@ GLOBAL(__locals)
 #include "local.S"
 
 END(__locals)
+
+/*
+ * Add this section to ensure final binary has a non-executable stack.
+ */
+.section .note.GNU-stack,"",@progbits
-- 
2.25.1

