Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0D6987F4
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBOWeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 17:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBOWeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 17:34:02 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D7A392AA
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:34:01 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z5so19725iow.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnWb0/c3SYq7VOjFth5MeHXAYmHB31VnBFWZUTQPvpw=;
        b=kC+gHfVdbRJlKuA2eO3yNTVt7DH6c/TA0/kfK1ldKXFTz8jF7IfNK0GsqoCDlFaey+
         Ot5LcebAIg2SwBu3bz6JxTwqg50CJu1GANhWz5aFxR+pABZYHwDTNFIl1ylVCSJBriro
         ftvYlS/DyAxzJSjMvhjrfJadtr3Xe/GVoDQlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnWb0/c3SYq7VOjFth5MeHXAYmHB31VnBFWZUTQPvpw=;
        b=drHIJeMMclzwH5VYKR+gRSjJ4zG/6OKhJKEfkoliROs5MD+uQsqAjMwbIFQsgCFegh
         OOfxTmciNcLw8RKRa60NP3IKFXivrzDo5v1J9u6tcSImPjZFn9621viWK2WJ6PlitKsk
         cdvU+TphRr4BMaHwLNC1GprocOLPRUQ2PCp0fzYTylmmupIwTOkykqcd7CRhmHdEfQbU
         gpPvGgcI3eWBraSsijdR/HDGOoNusBEx5Yv0iGMwETjBQpYJJQsLtumCZ26ILTE2aKk7
         Z2W5bOPD+SLxS0vUyVKOTZwe/STfuKaen1kbLAZJMnjtT+NhPT9mbN3VX0tIF2mRx16A
         fgqA==
X-Gm-Message-State: AO0yUKVU1SCmGMIWCAgF5eFAdj0NgsPl/PHzCJBPJPS1tyohFXNFnYjz
        5Zh8O0b1J8eNxB8Tge6tcdUD1w==
X-Google-Smtp-Source: AK7set+LWFNoW1FRruwyMQqPtFjjrfVj8AiheRpZcLSgqEnBWe2webNydnur3ykK3IxtsLkMcuwgOQ==
X-Received: by 2002:a6b:7118:0:b0:734:2621:58e2 with SMTP id q24-20020a6b7118000000b00734262158e2mr3155532iog.20.1676500440593;
        Wed, 15 Feb 2023 14:34:00 -0800 (PST)
Received: from ravnica.bld.corp.google.com ([2620:15c:183:200:6299:179b:a6e4:be59])
        by smtp.gmail.com with ESMTPSA id b15-20020a92c14f000000b003141eddd283sm1131489ilh.22.2023.02.15.14.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:34:00 -0800 (PST)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 4/6] tools/kvm_stat: use canonical ftrace path
Date:   Wed, 15 Feb 2023 15:33:48 -0700
Message-Id: <20230215223350.2658616-5-zwisler@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
In-Reply-To: <20230215223350.2658616-1-zwisler@google.com>
References: <20230215223350.2658616-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The canonical location for the tracefs filesystem is at /sys/kernel/tracing.

But, from Documentation/trace/ftrace.rst:

  Before 4.1, all ftrace tracing control files were within the debugfs
  file system, which is typically located at /sys/kernel/debug/tracing.
  For backward compatibility, when mounting the debugfs file system,
  the tracefs file system will be automatically mounted at:

  /sys/kernel/debug/tracing

A comment in kvm_stat still refers to this older debugfs path, so let's
update it to avoid confusion.

Signed-off-by: Ross Zwisler <zwisler@google.com>
---
 tools/kvm/kvm_stat/kvm_stat | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 6f28180ffeea..15bf00e79e3f 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -627,7 +627,7 @@ class TracepointProvider(Provider):
         name)'.
 
         All available events have directories under
-        /sys/kernel/debug/tracing/events/ which export information
+        /sys/kernel/tracing/events/ which export information
         about the specific event. Therefore, listing the dirs gives us
         a list of all available events.
 
-- 
2.39.1.637.g21b0678d19-goog

