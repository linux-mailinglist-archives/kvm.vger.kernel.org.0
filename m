Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EE67648F8
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjG0HkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjG0Hjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:39:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF413D
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-686b91c2744so526991b3a.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690443115; x=1691047915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8W/2glyFNghlOR8aLoJh4rtbBTz1uiLofQu+GK6+ib0=;
        b=TwyLkq7VkQVku7UEGEJGvOxpiLGKqGNn2Z8k57YpSS6ZkWHfSRznN+VshcyamJEJqB
         zMw97jUDWAXtbrKFdxDdZwZlTw6jMTuKDc69kpYGQ0SwXjls2dSoY2OhR7sH8bIrD4ut
         G0xxv4KpICYR9eGhbLk7VBV+IuNi87eZcDIuQc2fsSeQHyMLWy9i4ZRqjfD2vLbCVkaS
         gH2rgu9ptJReOtFpj98D23kSv1ELspNKBm2SZkYIDSxsUsfqx7DVi5tLI2e5vuNCLyJ3
         6YmLAZvRauKh3Zadas84zdgYM3WKD/wsk1snqp9KY3I0KaeJVZx2HrbjHlfEjSasJF89
         9OSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443115; x=1691047915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8W/2glyFNghlOR8aLoJh4rtbBTz1uiLofQu+GK6+ib0=;
        b=hxE7bCbCkPG4U0M4eFnYf+vuRSZJc4bLGPbfbDk3sgDt6kJcRHoM0KILDNsyWBX39Z
         +BhQ7mxdpWjlogFe7u+SW4HIVlkQ+nKmrjjkzJKm0tpnwW3UgRHxGK6r23pdw3SPwfkL
         8OQajjO2h1htnBM34RD4kfzT0VbGn4G8KVsblfmEZApt/jgfmRFz2lUWWPpyqzniU4a6
         cOjj+sdHY8BLHmHS7x6Uykw3Zsx096VBfn71DEvX90ydjWZG0OoVbnmcQser9JyLoWtr
         IhUesigg4ZONL9IeCJ1sR09WWN2cPVHpkXepc/rRfiDd7hydIT2ryKuqWosdV1d9vuYV
         /MfQ==
X-Gm-Message-State: ABy/qLb+hM5/gYS2tDtC75TIPwTpW7C39ZqzAbFtUtAZp5IZ6esdek3/
        gLRyOvODGbScPAAEC9Y4a5/xyRtdsRy8XGpY/fg=
X-Google-Smtp-Source: APBJJlGH5IK6xCXrgs0jr2kjrwPluYHvsn81u11F09P420p9JlfCazkD9jzO2BEnsFqFVedHPLVqnQ==
X-Received: by 2002:a05:6a00:1515:b0:668:74e9:8eea with SMTP id q21-20020a056a00151500b0066874e98eeamr5088101pfu.33.1690443115301;
        Thu, 27 Jul 2023 00:31:55 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78689000000b0064fa2fdfa9esm802002pfo.81.2023.07.27.00.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:31:55 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 5/6] accel/kvm: Free as when an error occurred
Date:   Thu, 27 Jul 2023 16:31:30 +0900
Message-ID: <20230727073134.134102-6-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230727073134.134102-1-akihiko.odaki@daynix.com>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An error may occur after s->as is allocated, for example while
determining KVM type.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 accel/kvm/kvm-all.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 94a62efa3c..4591669d78 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2765,6 +2765,7 @@ err:
     if (s->fd != -1) {
         close(s->fd);
     }
+    g_free(s->as);
     g_free(s->memory_listener.slots);
 
     return ret;
-- 
2.41.0

