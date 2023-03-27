Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3C6CA45E
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjC0Mpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC0Mpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4DF40E3
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso10682489pjc.1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4ZWQOUypcsgCXXVPbKnNZqOOjIZdRA7smKekWER4aI=;
        b=TVsFZfDGtxV3DA4IKHsUd2IeCSVQNYKpAU1vanVIPTYoQR7OVETUUI6nYiLPxESWCT
         JDP6QugapIdjn8jiXCsrDNhAusZdolSkshwmrXRwO0BLSTnHfUU8742HK3P4Yu2F0IvY
         kdGlcWvT7H3JR+5J2Wuk4+FXEfV9dDgjcrb4kiqYbQ+K16XFKT+/2EcGEWH4GrU7NZdO
         UvQIZS3v95j8ryuHZuNmlVcp0OX+yUxIcr7cs7evQSVaxF5Jp480zduvAD3EwJeI/iMP
         1Nc56kQRHyASPzsxwrM/p5al6XgaeVMMpyi4bw7cIBndZZ5/XIpvn0zd8/Jj21xpxqLt
         Yb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4ZWQOUypcsgCXXVPbKnNZqOOjIZdRA7smKekWER4aI=;
        b=oovDsoxpvL8Ljb1M7LgBHAIUm9ABkOcLgx20tFXjEI5o0VoRgYTBNYfCKHmjZ8cHjf
         TgkxpWQ5t8QYGsFtm1njH+1PFcATCWeId17+wHXZmFSrmmSVWyjvoCI28nFIQZcMzApE
         yATfzKkeQNtsE28av1msJGV/dGfmAwhxx2cImZBIL+l+lWDuE6RPONn6rVjvsse/XQ2B
         1a8G/5o6k9M2eyNk0T94FjMX3lOctb4A5gYKzrnXqeb4OJBWbt7gRk6AMsSILxUzUmUo
         6ldbK03tluRPDNGOK2whhrt0VHJ80tL79aD6OhaDAGW8rSidnn4G+v9vXPBQ80eZd4EY
         KkNQ==
X-Gm-Message-State: AAQBX9e8cvjc07WAihncZTPS8UkmUclmQdY1NGPu0PCBAFiFdq99cAuI
        02gXenuBfJ3wb39m7EV67zdetTp8/Ss=
X-Google-Smtp-Source: AKy350b9+S4Php29L7XVK+EMmzBMHiDm9zO4F8aYkliY9fJDpX3S93CAYQiwwAiyO3co3/+pzY4f9g==
X-Received: by 2002:a17:902:e5c3:b0:1a1:98a9:406f with SMTP id u3-20020a170902e5c300b001a198a9406fmr14242489plf.67.1679921139262;
        Mon, 27 Mar 2023 05:45:39 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 02/13] powerpc: Add local variant of SPR test
Date:   Mon, 27 Mar 2023 22:45:09 +1000
Message-Id: <20230327124520.2707537-3-npiggin@gmail.com>
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

This adds the non-migration variant of the SPR test to the matrix,
which can be simpler to run and debug.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- Don't use a new group for local SPRs [Thomas review]

 powerpc/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 1e74948..e206a22 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -68,5 +68,8 @@ groups = h_cede_tm
 
 [sprs]
 file = sprs.elf
+
+[sprs-migration]
+file = sprs.elf
 extra_params = -append '-w'
 groups = migration
-- 
2.37.2

