Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8006D834A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDEQOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjDEQOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:14:20 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E351997
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:14:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r29so36724058wra.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680711240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hySJmhGNiy7HBpCOkc2QYsFMx5sR+aPEFCWb6zlOjxI=;
        b=I3tpQBRdYO7NclUI5y7b4CxkmUbLjgYdQkfRdqIxXZ3gqz6sLzsjyPpD8aPwvw+nj+
         12OvETgsrS8t6LyMSITwaqXXfriHzioMJ7gDzwiuaS9X+ypnIepBCb/kVhriVf2XPjsa
         4a1YCDw+UbPjuwehcbnJW4ksjNfkOnuqn5xYmflM80wLtNbWVhYnanzNvrBfd5nyRU2r
         mWcODmrb34X1wIcsyEhbbK0XEMtZ2l+2vGa5W29Ii7Ma9UBKFP49adRd2SxMELr/SCXk
         n/lsKDTV5cJyOqZUzlZH9L4djWXvVNGWyX1OeQi+bCY/7A3GLO/WQOzp9UCKsVIepDeT
         rcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hySJmhGNiy7HBpCOkc2QYsFMx5sR+aPEFCWb6zlOjxI=;
        b=38VOHzh1JwfpSqnseqHVTVB9BO0XvNZEBgofy3odQXUqXh8evVhf5Y4gljZOF0k/hU
         ECVO4U+vuYcz3tPnBFIdx318q3EUQeV38ceiQQSM02XCxYxfUqfq57s+W1bU5j542/yX
         0a6jKN3UsWMqg5/1k02dl5SfC/kl4GPdpS1qGjG38aC/JseeIt4UK/jEowFzCssKjqe+
         9bnJ/3b7KfnntizW73KCzLrJL4YLxAPz9kMCvByUJSSU80LDI9CoD8aPYmrv5etwisrW
         BWSYvPkgZ6swep9vP1oWV4pF7G3m6ZmZrNT3lhuxs2rbpAWHXwqK35CTOo8gCHPJJC4L
         eA7w==
X-Gm-Message-State: AAQBX9fwtUPfXyYdFuNODrPFS3hrEHC+JTl1HQn6Jcqe244RIrysh2Lo
        /vS1CO3qNVpnGR/2SPpyc1RoxUm4/v4aLfS0wNQ=
X-Google-Smtp-Source: AKy350YrotmbTzVq0tkKx8/EiMyJP/mHPmHYE241R8z+3aMmLyKQODCBRfZIXnZOowy8IChjZeF72A==
X-Received: by 2002:a5d:668a:0:b0:2cf:3399:998d with SMTP id l10-20020a5d668a000000b002cf3399998dmr4753128wru.57.1680711239512;
        Wed, 05 Apr 2023 09:13:59 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d424b000000b002e5f6f8fc4fsm14753554wrr.100.2023.04.05.09.13.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:13:59 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/2] accel/stubs: Build HAX/KVM/XEN stubs once
Date:   Wed,  5 Apr 2023 18:13:54 +0200
Message-Id: <20230405161356.98004-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TCG stubs could become target agnostic but
I'm leaving that for later.

Based-on: <20230405160454.97436-1-philmd@linaro.org>

Philippe Mathieu-Daudé (2):
  accel/stubs: Remove kvm_flush_coalesced_mmio_buffer() stub
  accel/stubs: Build HAX/KVM/XEN stubs once

 accel/stubs/kvm-stub.c  |  4 ----
 accel/stubs/meson.build | 10 ++++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.38.1

