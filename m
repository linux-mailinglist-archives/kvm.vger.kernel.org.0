Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFEE79CFF4
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjILLb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbjILLbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:31:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB6E170F
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-52e297c7c39so6917478a12.2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694518256; x=1695123056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qjw2XAQ6HKVx9Z3EPaWrG+b3gjC37zBrk2Sv1nlYmYs=;
        b=LACDLyDuZD9accFoJk2Wd9oDKlSKUqCQiXqOTR9hLCUg3HronSHnf9kRt5WlaW9iFW
         YHCy6XniucIlok/0Yg0zvrI8sE464J6JROB7Z8wbDBAGbNoQ6v4Ucq+NOqZCq3+aC5rA
         0lwOredqQggd7g2DS6Av9HA0v5WwqcPEQ/hDrCGcGIXhhuzZ6B5D29O3cGDZMUnwyzx7
         aoEQJdcy7H1VI7fzQnvIiCs4tRti3zmTWwxm7L+RjBbSn67ytYvFdrHNJVZcIh3pFm4f
         O0MFZoPjST9UEMws/FkaxaI/+nsxHrgUKjQ/q5RytATt27QQXugtvX4saBDSogUPBsTT
         YoJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518256; x=1695123056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qjw2XAQ6HKVx9Z3EPaWrG+b3gjC37zBrk2Sv1nlYmYs=;
        b=gk7XZ/HKec3AWNIvnjAVrPJcxiYMDhzMx1pfqd46bkv32xnI4iJLRkdr/69MVeVK3b
         oC9r5TK8nlhB0p3eZgoJz0L+MEoFst4uzk9RNTxf/CE5sPkyjAQpmn7AaqlKMjSpGRTf
         WstRvqymMvEa8H4PK/ruj8kDeKkLKOKpFktaLP3e48UGN/6YRAGQ6Y7/W55pRVYAuNzT
         lXJbjmdBhrosl6u1uP9JtULZVw2gB9HHBUEzru/nnwkqPtcOyNL/HA+S7gLlYlxoXsE6
         iqganLNaL+99C+BsOP0SL1AGz2RxaySrNlcAV1no2GbyGBriIxlqlAzTd79Di7uIc6wI
         PvBQ==
X-Gm-Message-State: AOJu0YwH7HOSD5As/tXR4AddDq/Pe6FOWErerVWAYyP8VNyL8W2NUM17
        UPX/aW89C/9OYPMPjw5gM0ZKQw==
X-Google-Smtp-Source: AGHT+IGiO5Y1ImU0e5NPiApxvVuGIaqglPuHqf13s/S2DHwx1SaXcvGhb+gpSsNwSY48HsTaLRHqKw==
X-Received: by 2002:a17:906:10c:b0:9ad:805d:70da with SMTP id 12-20020a170906010c00b009ad805d70damr1647683eje.12.1694518256600;
        Tue, 12 Sep 2023 04:30:56 -0700 (PDT)
Received: from m1x-phil.lan (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090637c600b00991e2b5a27dsm6698164ejc.37.2023.09.12.04.30.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Sep 2023 04:30:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 4/4] target/ppc: Prohibit target specific KVM prototypes on user emulation
Date:   Tue, 12 Sep 2023 13:30:26 +0200
Message-ID: <20230912113027.63941-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912113027.63941-1-philmd@linaro.org>
References: <20230912113027.63941-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of these target-specific prototypes should be used
by user emulation. Remove their declaration there, so we
get a compile failure if ever used (instead of having to
deal with linker and its possible optimizations, such
dead code removal).

Suggested-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 440e93f923..ffda8054b2 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -13,6 +13,10 @@
 #include "exec/hwaddr.h"
 #include "cpu.h"
 
+#ifdef CONFIG_USER_ONLY
+#error Cannot include kvm_ppc.h from user emulation
+#endif
+
 #ifdef CONFIG_KVM
 
 uint32_t kvmppc_get_tbfreq(void);
-- 
2.41.0

