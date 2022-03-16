Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8814DAA3A
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 07:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbiCPGDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 02:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353784AbiCPGDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 02:03:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A184C60CC4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 23:02:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y19-20020a25ad13000000b006336877f6d0so1251692ybi.9
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 23:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=S9LUTFOE4suU05eZ/DsUlIvGCAK70B8setAkqGu10xk=;
        b=G3j8CkkhZuGNdY0HD6rwryogN8MIcMFqHxvwfOXygLmUpU+eJA7o4etRVXSO1BLOBt
         xTrXIZrb8NQYCHkyCE8cVylnyd9xUP6kdXWwsYnMuF01xgc+rwevKiVubyG1N/aL1Pos
         NKWlt2+CN/E5Zctfqc/8Sr++NnlWX9FB+fJkf1y+9gqktnt0zLTgxXlEkobUH5CifSbO
         lP5huuRMA8cFFOq7KLVYHECmwPbzpFtz+dicGxhgWOFksv05rrcPTrjnALI3+4iwqzK8
         4vnr+5DrpuR0QokhYY1snuTXDwDaQPoTH+pBX3v1CfzHSFb5l4zHLVbKbvzLW9M8rBMY
         6x+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=S9LUTFOE4suU05eZ/DsUlIvGCAK70B8setAkqGu10xk=;
        b=HMcVICc1BFdc+pjnlaqj9hXHhePAhuCAxAdlKnrU1bwlX+vIO3PG9RJAPqCuImOvy6
         0mEhuwCudiVF7Vk2qVd1vzNLoNjGXBIFXZaZAE0YXKx1eoCg0Y7XwblIX7LHlrZzJUNb
         ezgQz0CSMYkUf9iBIsgsEStyLCtu3/nW06pqvXkTqSkXKegg3ZQFyeGhk3p6vixjD/FA
         9X/H1V4vHV0L63xLX/KJKddTkZlu4j7AsVdEdpvbXugkKvfwMJJsdKrIjkepBpEbSAWY
         83AdZAfgh2ymNPWYbWHQkWIJXMaLhsehUqFasLg1JoLm5O5CCcBcxOPQfWcmqTvIbWfN
         fNvQ==
X-Gm-Message-State: AOAM5321v0zEwW0UNrUAh024xpjffXJQLPn9/J+ZTpx8Jvc3KlbR6DjT
        sNtYtGEcSzN431WgTJdpTp99RhbFusAApEQDh2zOXCoSBpB7nlapxAOE05lSMfGJG+1D9+gE6X9
        aTMdsQowHEWpz+RSWGSpHmcw+rEB/uRCg5VDPxMGH9eOcfJReJlqGlQ==
X-Google-Smtp-Source: ABdhPJx/VuftGVYvhDeQv7tV/DioGeuRkrCuileFyq8WfZo4RSDNn0hVwxIHT2HgiQZDMP7aDG69eY8PyQ==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:1aef:e3a6:d3d3:5b0e])
 (user=morbo job=sendgmr) by 2002:a0d:f883:0:b0:2d0:ee66:5f97 with SMTP id
 i125-20020a0df883000000b002d0ee665f97mr27900875ywf.313.1647410543987; Tue, 15
 Mar 2022 23:02:23 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:02:14 -0700
Message-Id: <20220316060214.2200695-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of bitwise
 "or" with boolean operands
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang warns about using a bitwise '|' with boolean operands. This seems
to be due to a small typo.

  lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
          if (can_assume(LIBFDT_ORDER) |

Using '||' removes this warnings.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/libfdt/fdt_rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
index 13854253ff86..3320e5559cac 100644
--- a/lib/libfdt/fdt_rw.c
+++ b/lib/libfdt/fdt_rw.c
@@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
 			return struct_size;
 	}
 
-	if (can_assume(LIBFDT_ORDER) |
+	if (can_assume(LIBFDT_ORDER) ||
 	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
 		/* no further work necessary */
 		err = fdt_move(fdt, buf, bufsize);
-- 
2.35.1.723.g4982287a31-goog

