Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC36F55EDDB
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiF1TjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 15:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF1Tia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 15:38:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB9393C8;
        Tue, 28 Jun 2022 12:30:45 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 184so13110203pga.12;
        Tue, 28 Jun 2022 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2EbXlaxImLkjcvI7OS6COUyCRhMXb+wP7E5Ra/H3eM=;
        b=UHgHNFmfLVZpYmgcsOCzsyfY9SFniLePXPzkvatFw8N/9sGNKiOndMJ5R7ViswgMe2
         +eQYgKXpdViZtQzNAER0kQ5QzIZAuJ6F5w3yOeAV7v+S4msjYhC3Na+XCOUmbL6LslGA
         tCfBuZ3yyc66gBkUNNANQkHn/oVRaSd/yrgGesYGB1Ndbh0gcogs8PlAdt6gcoyZVD66
         dkIecSWY7OqniYUWZ/Ylm+fynNcPWfzeYHzh5rkYbKten3UQxztxXEEWH6WpPMfctzDd
         vYCsTl2rPgJkiXU2xD+sDePXAIhdoThCfMuvl7zEBzg+7k6OJ84Fyv0UCSJqr84D5+5O
         K4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2EbXlaxImLkjcvI7OS6COUyCRhMXb+wP7E5Ra/H3eM=;
        b=gKQou4+TZksBYj5+7QAJU9Fl6QYmR8QrTZ0b36th62yPE/qI2hxzuwoTRIEkKC1fwR
         ZrikUZHJa9EafAkbvh5bx3vRBPuvAq+1S0ee26YcCl43z9XraKVpZBX72IzAf7le19Ve
         BYYRbMjfxkL4I8cVRC3nu6slNfrSaaRu+2SA1mdHSIAzGetQrEtrbBONI4r8bAq0Y+iE
         oZtDh/VSGhsZOPjBsVfoDb9tp+0Qa4TgX5uONOyqO8QS9I236xeTLiWcv2luVcgbW8Tz
         OetJelF+/Ei0BNBdbp+WiPaSDAF0EFVUn1iShwwRG375tijKz7xCHE2iZfYt9kb+wFLU
         BEgA==
X-Gm-Message-State: AJIora9/Lkyeox+OX9DuYENf0ZHZV3stSAPMeLvjM2lw0qD/PwpUwlYv
        uzx87u9EhBPZmCl50bphrSecp2qTnIPRaA==
X-Google-Smtp-Source: AGRyM1tCuEn3qozSA3GOvIaeVgjHYn7MPRp2lAqTPv3emHRUY136y48eQ9er2QZmzDHs14EskRgGcQ==
X-Received: by 2002:a63:78ce:0:b0:40c:3c04:e3d8 with SMTP id t197-20020a6378ce000000b0040c3c04e3d8mr18918572pgc.202.1656444613695;
        Tue, 28 Jun 2022 12:30:13 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id d59-20020a17090a6f4100b001ec7ba41fe7sm209484pjk.48.2022.06.28.12.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:30:13 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH] selftests/kvm/x86_64: set rax before vmcall
Date:   Tue, 28 Jun 2022 12:30:11 -0700
Message-Id: <20220628193011.55403-1-avagin@gmail.com>
X-Mailer: git-send-email 2.35.3
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

kvm_hypercall has to place the hypercall number in rax.

Trace events show that kvm_pv_test doesn't work properly:
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0

With this change, it starts working as expected:
     kvm_pv_test-54285: kvm_hypercall: nr 0x5 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xa a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xb a0 0x0 a1 0x0 a2 0x0 a3 0x0

Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ead7011ee8f6..5d85e1c021da 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1422,7 +1422,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 
 	asm volatile("vmcall"
 		     : "=a"(r)
-		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	return r;
 }
 
-- 
2.35.3

