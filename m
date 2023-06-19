Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71369734C80
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 09:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjFSHmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 03:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjFSHmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 03:42:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD14E7D
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30adc51b65cso3186548f8f.0
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687160533; x=1689752533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BT5WpWOETZMXxgChaA/hO32lYMuyGzMiCBmIgxW1Frk=;
        b=umUk00NvLphY0IlIANc5KbQE5bhlJwwKeZcl4fyhJ+EZSz23anx/rnx/RicmWgOAN8
         vKdUKaJ+cygAKh8Ag5pABbRBT6My4hLE+VguA6+tWbYsttlF8kUYD9Yv6hJiNOBRF8te
         MbDEnFWFo2Ll5DnZXAhoXpAj27yUPDZgr9aBArCoCr5Uv+be4fVQtozKE738Gcz5RkRx
         VAocvAr6xuBWwkmL6iGs/iQSSR4/6yq1FwslQ+NPlwNGNFzkUoJwWsDAUr1eLGci6QwQ
         ytOjpInInl/HGD7j3iPmU/+pQkNwflfEf9Q71ElIFMPoMRbyBKW8PJfkIQewv9zxyywf
         Z28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687160533; x=1689752533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BT5WpWOETZMXxgChaA/hO32lYMuyGzMiCBmIgxW1Frk=;
        b=eVooXasuKUdm6YVYIIXYbjdTlhArt6BalOHpWWYsNs9CHQLCTKbCceetONr246qdLZ
         hwO0nZjZ75S3YDWb6Y9/5QTYs9oIU2DYZt0Co4zDJMlF1MIwYW6T+X/RB+No1VuKVbwv
         cM6SV4WQEddTr0Ewarq5nxyxFqegr10F7hGv0hhLzrj3OiCxPtH0XtRG9sWD+rwOuy/m
         QeMszwIld1t9uiC49RbQkSM7RpUa+ChkJUXeq7sSfFyjzFZpNGo+ikbbjzHbotcQH9Dg
         HKRPDWuTjCtZeMeiJQ6gr0zls+7va0vvlvnZgvkFVDRUjoNqBsCUeUW6s4N9wnBq+AYG
         t0HA==
X-Gm-Message-State: AC+VfDxjswI0WY4pac7raIV/e2MEJrRoWKR22nfBenaoq9LUXX8hIeFQ
        HizCPDnuOAQ9RKosGqYP003uGQ==
X-Google-Smtp-Source: ACHHUZ5h2BLgoGUrZ54XYb21bpMoPxOtd7xTNMLSSiHnhPZ0Imsc810frdGVzsuPUdg/pyCGUtpTrw==
X-Received: by 2002:a5d:668c:0:b0:30f:ca58:cb10 with SMTP id l12-20020a5d668c000000b0030fca58cb10mr9968812wru.22.1687160533141;
        Mon, 19 Jun 2023 00:42:13 -0700 (PDT)
Received: from localhost.localdomain (194.red-95-127-33.staticip.rima-tde.net. [95.127.33.194])
        by smtp.gmail.com with ESMTPSA id t1-20020adfe101000000b0030e5a63e2dbsm31033657wrz.80.2023.06.19.00.42.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Jun 2023 00:42:12 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 3/4] exec/address-spaces.h: Remove unuseful 'exec/memory.h' include
Date:   Mon, 19 Jun 2023 09:41:52 +0200
Message-Id: <20230619074153.44268-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230619074153.44268-1-philmd@linaro.org>
References: <20230619074153.44268-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"exec/address-spaces.h" declares get_system_io() and
get_system_memory(), both returning a MemoryRegion pointer.
MemoryRegion is forward declared in "qemu/typedefs.h", so
we don't need any declaration from "exec/memory.h" here.
Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/address-spaces.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/exec/address-spaces.h b/include/exec/address-spaces.h
index db8bfa9a92..0d0aa61d68 100644
--- a/include/exec/address-spaces.h
+++ b/include/exec/address-spaces.h
@@ -19,8 +19,6 @@
  * you're one of them.
  */
 
-#include "exec/memory.h"
-
 #ifndef CONFIG_USER_ONLY
 
 /* Get the root memory region.  This interface should only be used temporarily
-- 
2.38.1

