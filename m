Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810226D794A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbjDEKI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbjDEKI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:08:57 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AE11701
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:08:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v1so35617140wrv.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HI3xN1Xw0CC8DrBzNb0i+wLUvlK4SEej1IdIipPh7tY=;
        b=M3wXPW8CEHaaU/SeIwgurVpmjXnpmz0FsbXMGeB0ADgrI78Mmg1BzVsGsrbHXEu9FH
         iAnGHA/wzFBnABSYu1PTgyVZ6t9O92c9zVYwz0UE9Gqp1kWBpVHcf60/SzNjx5GOOjDZ
         +NDJPZjbZKCSqwNKf0v7JTQa6pl3jx60P0zUyRzbQ6ufK8IJeHYnM+J3RF3076HF5Eiu
         jhs3ryW7nFl27iDtRxZsoxLcIReYHp9GEKTw6P0r4yJV3E9gnJJJnKtQkK1N5H31LCV7
         QKG2qmknPkZufFp7SbuoWZRoxPAW/CXxNbJaQZ2plPXa65PuysHeZMwoSOMd0j4YmfYm
         164w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HI3xN1Xw0CC8DrBzNb0i+wLUvlK4SEej1IdIipPh7tY=;
        b=mylwQsxyKVPcFhrvlGaIOTh5Ee8lIE/H6u2v1hCnWuowIvjrJqZnnFP9xCcQVwUF39
         HlS9GdcaiHgBr6a+avn+hEoeK2JhkClvehQ/aQD9KtROvl3KTXLfbpkObA0/m4SclmNr
         W1AmSDqD1fBrK/dl6ZC35Z6oT7gSYXTTZ3rJPYSvzxIGxCPTjedXv3dbSM8OfWFUS4Ux
         yLtyGSGdOjiO8rgAp+tUHc4OIhNnlYVdhlFVP1guseRD1ekHl58+AgqwLcR2lr7dTxmV
         aRrvfoLFqn5lb8cO9hgBKLpXn0lPhXuKKjoJEPHIg7Aq32gVMUmKFZDKlZRSSCGqmAQi
         PdFA==
X-Gm-Message-State: AAQBX9f/Yq1hWSwaI6KQ8JvqT3g4dERJrV2b1ZcIfyhOGAJO7yEcNLh5
        AkqmYyFZxcIQ1+UrvAzntLc5IQ==
X-Google-Smtp-Source: AKy350YTMitKz+YkGE/b7aGjKk7ltxCbj29oXbGEQgyyI89jT6BypREEABdgQmipAwrQPTmnEPKJDw==
X-Received: by 2002:a5d:4884:0:b0:2c7:a55:bef5 with SMTP id g4-20020a5d4884000000b002c70a55bef5mr3784813wrq.23.1680689331740;
        Wed, 05 Apr 2023 03:08:51 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id d14-20020a5d4f8e000000b002d1bfe3269esm14604073wru.59.2023.04.05.03.08.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:08:51 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/2] target/arm: KVM Aarch32 spring cleaning
Date:   Wed,  5 Apr 2023 12:08:46 +0200
Message-Id: <20230405100848.76145-1-philmd@linaro.org>
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

Remove unused KVM/Aarch32 definitions.

Philippe Mathieu-Daudé (2):
  target/arm: Remove KVM AArch32 CPU definitions
  hw/arm/virt: Restrict Cortex-A7 check to TCG

 target/arm/kvm-consts.h | 9 +++------
 hw/arm/virt.c           | 2 ++
 target/arm/cpu_tcg.c    | 2 --
 3 files changed, 5 insertions(+), 8 deletions(-)

-- 
2.38.1

