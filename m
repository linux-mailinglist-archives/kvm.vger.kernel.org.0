Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CE4740718
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjF1AOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjF1AOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EB0272E
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b8054180acso23990215ad.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911276; x=1690503276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=YiltKE2ojsIX1IvRFbadB/0W28pDqxr5SG/QQIxwovOvmZ9ydT8id2x0lPVM3uyNhL
         +ZNnoR099reijdo5nZNejbjtA05aUK6BoRdrWc34UIh9gnx3uYugc5CfZP6vXjS9gCSo
         EalYHyIYYHbKSPH/e68MDdibpEtocA/g0bi2v7l+wSsr9krzQJOyqjLZAUruqdRuTW28
         utyqzx++PLQxnUUPXe1ADwHd3SIDVD+iQTLA+65K2IjyGguv19PtDEXPA8LlvDCWf5go
         +UnSlaPneGiafRR8I7UAC/X8Xb1En9rp615e8UMcYaDSjdlHFCj9bVlX/N8v6RrQ/0MP
         VYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911276; x=1690503276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=BBIUImLJpqWP7L1IaVQfS/SbmVtOEAOrLdpVmRJAQAZ7uHzcXceI502TP0pe3u8LZO
         v5rJpGK1fJNfFcDbmscadZIzZY4nJ18PunWNfDlKkObc4pRiFVBBfbs1ZdQ1fpXbiwXu
         4ZZ6qOUkZahoFG3/WYF5nM65RGrd0gDqDeNvKbgaKMkQKQorry2JJ/g0hriMMxk+g76P
         k3+PcNkSFiubVXdxhwKPKbnrXWLadbM+lPxSolxCSpsj6fHjV/MdzwdIfQqrGIcJscZD
         1RjdpyfF5MQxzzFKdyb2KQYfhXY6hdJa5pLtB7Yg20AfWaQwav6jxRswMyvwyM2Drgd1
         vrvQ==
X-Gm-Message-State: AC+VfDwJ+wCFZ8U55VRsNTdnl7HnMbcw8CXjE/PnywiCo1iGu2hDimpM
        OuGdIqyCPF4xdQ3pq3RDTU0=
X-Google-Smtp-Source: ACHHUZ5SRvbDizcqRaoRTMdNa0syYFknidVMQDwP1iEsY47BtD7BGVVdrneA3ak5Wa0+9ZhMSPeWTA==
X-Received: by 2002:a17:903:41c7:b0:1b7:ef04:da55 with SMTP id u7-20020a17090341c700b001b7ef04da55mr11767181ple.11.1687911275849;
        Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 5/6] efi: print address of image
Date:   Wed, 28 Jun 2023 00:13:54 +0000
Message-Id: <20230628001356.2706-7-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Using gdb to debug tests that are run from efi is very hard without
knowing the base address in which the image was loaded. Print the
address so it can be used while debugging.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/efi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 2e127a4..2091771 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -19,6 +19,8 @@ extern int __argc, __envc;
 extern char *__argv[100];
 extern char *__environ[200];
 
+extern char _text;
+
 extern int main(int argc, char **argv, char **envp);
 
 efi_system_table_t *efi_system_table = NULL;
@@ -363,6 +365,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+	printf("Address of image is: 0x%lx\n", (unsigned long)&_text);
+
 	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
-- 
2.34.1

