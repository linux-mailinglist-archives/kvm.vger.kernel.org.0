Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F036CA46B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjC0MqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjC0MqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:46:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89C4216
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id ix20so8321087plb.3
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ob1Ka1GDo4kUszz8YMerJdsHwWFQwfeKAyOzlxkgMc=;
        b=c+YEwJEVLECEtmPkN75tqIWyoibov+g4LcIPV+9zj5LMyqwtXXuLGuhrvMxetIJEz2
         gsiHpp+BLhj8TMEH+wSgL8xweD/mdqJ6VsNJ//stewOaNLCBnxVPn5IF340ShFycHK+v
         0fFA/E9ZAvLWtyYiWVKpDt99jHMcza7lj5War+XENswOEu21FHEblUhm/7ogbLQkUkyL
         02G7SNlRjP17Y9M2XBTKeXqt8dZbX8kybtKmBpzNiiUyepc+fsSmnHK03OwU6ZEl+CeM
         ZeQLge+7Cn0zEsKmTTQm2wscM2lyEj8szWqacgQrYVbTdNaKtZ1UNM6SYJJDsReyVnqr
         o1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Ob1Ka1GDo4kUszz8YMerJdsHwWFQwfeKAyOzlxkgMc=;
        b=y/TzWt9p6HKCGQtkC+ND8snfter6GemZLtGILiLkA+dYI2KRkPATc7CsdWQa62dUD6
         8w0Y8V8Jkfib3oePpEGOmE7AcyEagWxhB0OSKQySbfsRvttOA7RPOivA6Sw3KhsR3pee
         KYkan15nvgV2Sr55g2+DJXWosP8f/GY1f7IGHU5GS/f0NdoL8YJKe1aJMRSB76FbJACx
         380uKedGc6uPFlIIYoo5p7WMkBX8gA1U3JwlLgOtcOWyuuIOCfpR+0UG4Vaplm8EILPI
         UkQJ+UoChuKkw3WGd32Kf8wWXi59yLswh1kmGFSFd1DBoo5jq9GobvH2w0vYALUDWRYt
         8HZg==
X-Gm-Message-State: AAQBX9f/eKZdceNfNWOfPiA2YdZtzSnkrQiA6rXgaPY9GFBifzWkQq8s
        gkNMER9rhekzMnSTXFeaesTsKsSX9JI=
X-Google-Smtp-Source: AKy350aohabTNCzw6Ebj8r5zR6Y2fQGuegq50HCZBGegiiJ+lkjUzKO7o8TJ5w/jDAfxApx+luidgw==
X-Received: by 2002:a17:902:cec5:b0:19c:bcb1:d8c3 with SMTP id d5-20020a170902cec500b0019cbcb1d8c3mr14637115plg.54.1679921161694;
        Mon, 27 Mar 2023 05:46:01 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:46:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 09/13] powerpc: Expand exception handler vector granularity
Date:   Mon, 27 Mar 2023 22:45:16 +1000
Message-Id: <20230327124520.2707537-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exception handlers are currently indexed in units of 0x100, but
powerpc can have vectors that are aligned to as little as 0x20
bytes. Increase granularity of the handler functions before
adding support for thse vectors.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- New patch

 lib/powerpc/processor.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index f8b7905..411e013 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -16,19 +16,24 @@
 static struct {
 	void (*func)(struct pt_regs *, void *data);
 	void *data;
-} handlers[16];
+} handlers[128];
 
+/*
+ * Exception handlers span from 0x100 to 0x1000 and can have a granularity
+ * of 0x20 bytes in some cases. Indexing spans 0-0x1000 with 0x20 increments
+ * resulting in 128 slots.
+ */
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 		      void * data)
 {
-	if (trap & 0xff) {
+	if (trap & 0x1f) {
 		printf("invalid exception handler %#x\n", trap);
 		abort();
 	}
 
-	trap >>= 8;
+	trap >>= 5;
 
-	if (trap < 16) {
+	if (trap < 128) {
 		if (func && handlers[trap].func) {
 			printf("exception handler installed twice %#x\n", trap);
 			abort();
@@ -45,9 +50,9 @@ void do_handle_exception(struct pt_regs *regs)
 {
 	unsigned char v;
 
-	v = regs->trap >> 8;
+	v = regs->trap >> 5;
 
-	if (v < 16 && handlers[v].func) {
+	if (v < 128 && handlers[v].func) {
 		handlers[v].func(regs, handlers[v].data);
 		return;
 	}
-- 
2.37.2

