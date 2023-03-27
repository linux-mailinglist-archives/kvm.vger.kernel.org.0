Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5DA6CA3F5
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjC0MXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjC0MXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:23:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646394213
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:22:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l7so7488435pjg.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679919778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o6EVaPW5fhxlxKVN1voS5AJyvimXWvRy4v1O3dUl+Og=;
        b=IYTuVXqnFAZQxkwr3znv/P2clUakHyii6zMizpUFIpvfGPHhXLWPbdZRFaL9i8gbdN
         J2Kdxf5EFVdtmrnQhzySPyw3WhHyBHQl1YHEfO+q6kmyQx9GTK5rfVahtM4JmLz2lR2g
         R3FxnCfr6gb4HsSrJBL6nWRuANYWg3aTgTfywwOpVV2gEyMevIIzP4J0UiKjXyaXwr3o
         /n2Qy15cb5GHhflOx/TN3iDPKKIa09ENY9MEj8gOcJZvbafHqZIUNyxfKf0+qp9Sqz2T
         6MlI08ZERJ+exFfc+j6oez6BUGLbnewNWaE8nowzEqRqEN6bC8HyOCWKvso5CoBzPG9Z
         D+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679919778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6EVaPW5fhxlxKVN1voS5AJyvimXWvRy4v1O3dUl+Og=;
        b=T8PQR4VORKMGov5p6wWYAIe7VnN54JZkgVNGKEg6ulrvHARki+j1C0OxyGzAqZmKzX
         gBYyjosyfa6hrKPpm8ew46wpa6/k4gff+Em6FfvhLZf7AzKOXOI14+tLkw5dmWhAdR4N
         0n8fqEsh2ezOz8An68X0Sozqs24xLDzkrUfPuktdetktbgxkgx3ir6SA8W4EvXZV3BtW
         gv+ychBWdEzJJt3uUM9ydQxtuEY0yOp1KIPtfvdgOgyL6Q076xRn/xUdwr1y/e3eKM7F
         Hl550VZzuaUFeBk6dK4U9uaH/ecKJY6cPyppNAno0HngmDFAws3TvqQUCgpYeoY4mlvE
         V6Qw==
X-Gm-Message-State: AO0yUKVUgDsb7qpC6Zxj/hoRmhTOVf7sv01UZbZ4yxsMyaIHA3j0Qu4c
        mfL89rrGGJdIIqHnePAJIKO/t0lxRw0=
X-Google-Smtp-Source: AK7set+1zQjRK9oweVVGi2qcuCl+5D7nAwXvdx0YPIU6FRHnVlh7r52xnWojxzSGG7FqYcqDzNKaqQ==
X-Received: by 2002:a05:6a20:4890:b0:d7:34a1:859a with SMTP id fo16-20020a056a20489000b000d734a1859amr9969185pzb.27.1679919778369;
        Mon, 27 Mar 2023 05:22:58 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id f9-20020a655509000000b00502f20aa4desm17537281pgr.70.2023.03.27.05.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:22:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH] compiler.h: Make __always_inline match glibc definition, preventing redefine error
Date:   Mon, 27 Mar 2023 22:22:48 +1000
Message-Id: <20230327122248.2693856-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
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

This makes __always_inline match glibc's cdefs.h file, which prevents
redefinition errors which can happen e.g., if glibc limits.h is included
before kvm-unit-tests compiler.h.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
I ran into this with some powerpc patches. I since changed include
ordering in that series so it no longer depends on this change, but it
might be good to have this to be less fragile.

Thanks,
Nick

 lib/linux/compiler.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 6f565e4..bf3313b 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -45,7 +45,14 @@
 
 #define barrier()	asm volatile("" : : : "memory")
 
-#define __always_inline	inline __attribute__((always_inline))
+/*
+ * As glibc's sys/cdefs.h does, this undefines __always_inline because
+ * Linux's stddef.h kernel header also defines it in an incompatible
+ * way.
+ */
+#undef __always_inline
+#define __always_inline __inline __attribute__ ((__always_inline__))
+
 #define noinline __attribute__((noinline))
 #define __unused __attribute__((__unused__))
 
-- 
2.37.2

