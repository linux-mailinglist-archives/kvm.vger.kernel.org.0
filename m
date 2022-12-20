Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121B86522BC
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiLTOgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiLTOfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:35:42 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223E0B67
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:41 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so8954714wms.2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FtKJes66/4jOGZqiJaNKdd7x6uDxsmpWf7n+U2lM5lE=;
        b=NzqVb3JTffWzhT7FSm+CBjrpFGKmGH60tPLlcLI0E7y0g5l9zRMn+cSPiKjwVZksNC
         B7oyrxP44J13H0v/qFYExs4JWtee0zDpHpkmv+BM3SxtGr/KL0NWO1qjXxJxy4OqsjBT
         BfmoXWH5MSQgj/gO83QZo66/A7nqWTNG40Qf9GWv+PYBK/zqT/XasBlLb0rhakwdPFyD
         1N1FC9ZBFvhwnmbALrWALRi1MncrHZqOjjZ4nPbWyuRwS+JChsPswgTH6iOsKPNinWll
         fzh5sDRhC94BI9/zzzLCHi1Yjl2r7mLvZH0fHIZ1CmlsROM93OOPNVpz5h0/u6LH3+bU
         LHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FtKJes66/4jOGZqiJaNKdd7x6uDxsmpWf7n+U2lM5lE=;
        b=gRTl2zNLYwNTclG2Y1FXbLmvt1JrQRo9JsGA1Ibvdr2V0H/6hAxVWdosbt4JxaKSVK
         tvA8JRCNVjk86ZV/ZgpHnhLYhS0OqUGb6cPNusM0KOImpwH6YmFBWjThKzOrdNwfDf9j
         X77QTSSyf8LpB8omBZcpzTGTjzQ2riDlr/8R7eETi51MbSnirlY5tlI+HIgbBXbD3GEl
         VOg755aTsITSE4S+9z8TqSOv/vIGjnz2x7gfvmP7s8rCQ+s2GTQ3oN3tMBjP2wf62XaC
         dofJwdozlct0dXOUTgmf1EvJLwg8zeTt+Kbb7858TCGW7bex3VAs9VsZg3NbNmchy2ge
         ZbRg==
X-Gm-Message-State: AFqh2kpNxsy5HUNLJqxuJKnEVTm8wxj72yhXNDxD8iGm/zIJp0jAdF1D
        bowPeyt2NZiOFlPyAMMjyXPut7Ud1z4Rvaw7XZU=
X-Google-Smtp-Source: AMrXdXu6W4jBstWrKM+QE6scUoWOSzbL52dvRkQ55mXgZDBhqJSkHFLdm6Bfp2G+3ZTef2EZDHFKdw==
X-Received: by 2002:a05:600c:3d96:b0:3d2:2105:1761 with SMTP id bi22-20020a05600c3d9600b003d221051761mr1806999wmb.25.1671546939688;
        Tue, 20 Dec 2022 06:35:39 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id z19-20020a05600c221300b003a3170a7af9sm15867920wml.4.2022.12.20.06.35.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Dec 2022 06:35:39 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/3] tcg: Silent -Wmissing-field-initializers warning
Date:   Tue, 20 Dec 2022 15:35:30 +0100
Message-Id: <20221220143532.24958-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220143532.24958-1-philmd@linaro.org>
References: <20221220143532.24958-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Silent when compiling with -Wextra:

  tcg/i386/tcg-target.opc.h:34:1: warning: missing field 'args_ct' initializer [-Wmissing-field-initializers]
  DEF(x86_punpckl_vec, 1, 2, 0, IMPLVEC)
  ^
  ../tcg/tcg-common.c:30:66: note: expanded from macro 'DEF'
         { #s, oargs, iargs, cargs, iargs + oargs + cargs, flags },
                                                                 ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tcg/tcg-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tcg/tcg-common.c b/tcg/tcg-common.c
index aa0c4f60c9..35e7616ae9 100644
--- a/tcg/tcg-common.c
+++ b/tcg/tcg-common.c
@@ -27,7 +27,7 @@
 
 TCGOpDef tcg_op_defs[] = {
 #define DEF(s, oargs, iargs, cargs, flags) \
-         { #s, oargs, iargs, cargs, iargs + oargs + cargs, flags },
+         { #s, oargs, iargs, cargs, iargs + oargs + cargs, flags, NULL },
 #include "tcg/tcg-opc.h"
 #undef DEF
 };
-- 
2.38.1

