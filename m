Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6340733D7C
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjFQBuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjFQBuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:50:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E903AB6
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-25e8545ea28so1063177a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966603; x=1689558603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8wvopEEtJy+VQFi0jWO9AxOzf3zK7vuqzel5MQDBWI=;
        b=Fs0KtJc+jvQH/d7Pv0q5K80EW8ySTlxM8cegq9+AgS1Ijq7KgNoXaqB+A4eGobQeKr
         pJvQayWppVmdbd0EU9m6YPpPBaZ9x456vndxRPGFkjoA2nJTvu3LM6BPm2rZqOJ1vZ6C
         J6tJSBdgUSBiFXwgFArHHfL0HtnlvQKqff8gHCMtz/mx6A8fj+KXs9dNZCiy/237RyRW
         lWREmvxFnZE+IIRhMlxhkqaLLhvu1dj8FS5893DMTNX6qj9jkAzJpnto2x6n2mM64Q7c
         fvBfwOkrcevXEZUp1ZBRyA6ddDNEbVTTExuGeSFWtRiAU0GbnqIw9eBaTphsrorqAQZr
         ysEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966603; x=1689558603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8wvopEEtJy+VQFi0jWO9AxOzf3zK7vuqzel5MQDBWI=;
        b=LdvVGsaVxdaONxdjM6mk2Oj3l75OyzIdrTAwzVwiIlop2bgvz4TsyW7kPeZEg1qAhL
         94TEGDabHkiPi3BHyE4CpZmiJ0jJdGviskJ4sucj+pKb2GPtsNBa4f+MKbo6pnUS/5Ba
         /AF4mVqJQO5O3THo/QsCtOM6R45Iw3OSzKN8l073hvjK3NYxlDQcDjwTjGUUqxrWk4ax
         ajaoup9PhiqQavk7J+n2+NBNe4SX/3Rm/6H/XNN4LBDnH4fRUPsKm4l0pgOTLgZY1q2p
         iaBfv98scrWbW3reZ4SxYoXgsuDIHP6yoZVH9cKiGEo2XX/NxqEmZF3QFFxARAHgEJYi
         ya9Q==
X-Gm-Message-State: AC+VfDyGSxUUn7+KUGoq5ptf4cgYM8RIv39QJmDRjYiN5W3TNb8OGf4z
        ZZiwzGsav7inoY7BVJoaDuo=
X-Google-Smtp-Source: ACHHUZ5l3EtrTX/js9eRnKEPECFJgzUDyg+TRt4q/rH+tzKCj1LvKdE8J/YrR1AWrw2RkWTcCsLmcw==
X-Received: by 2002:a17:90a:470f:b0:259:dda1:bee1 with SMTP id h15-20020a17090a470f00b00259dda1bee1mr3215312pjg.46.1686966603339;
        Fri, 16 Jun 2023 18:50:03 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:50:02 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 5/6] efi: Print address of image
Date:   Sat, 17 Jun 2023 01:49:29 +0000
Message-Id: <20230617014930.2070-6-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
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
 lib/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 2e127a4..f42edd4 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -18,6 +18,7 @@
 extern int __argc, __envc;
 extern char *__argv[100];
 extern char *__environ[200];
+extern char _text;
 
 extern int main(int argc, char **argv, char **envp);
 
@@ -363,6 +364,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+	printf("Address of image is: 0x%lx\n", (unsigned long)&_text);
+
 	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
-- 
2.34.1

