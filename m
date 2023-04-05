Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C27A6D834B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjDEQOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDEQOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:14:31 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CE955AD
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:14:07 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d17so36730895wrb.11
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680711245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31Dm8tqveH6A+pTj5FPrc9/OxO1iY2GmqoL5qWMaQ24=;
        b=pd14cQKQnbGXSS7TUuEfdyDf5sS/zlY7sHExBVdaAoLm+FR9z4m97A4mvOPC2H8vyl
         Gmz3wjbmUwxY/fJqAOLuDOhY616GTL2Q01yU23hOvKYe5S3u7w5HMDoKvtMf+89yPnKW
         TJh1p0Vr+34FXtgnN9X54/7OdJnOV7yf+V4DeDcrkDTaQc6VPniCpr5vSXUXqAHSYMbY
         eeWSSwe4gODZc5fJdhIkgFvMmlCnM3sbzsuI09kT6kRfZgBvgHP7FiCnkJzQo2xF7F4D
         fqJGxbPspWNuXTatpW9EJFD+QObBG2IvHfaCUe0D2Se1nPtRizuXb0zttJf9EXgZ0BS2
         3i9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31Dm8tqveH6A+pTj5FPrc9/OxO1iY2GmqoL5qWMaQ24=;
        b=hGyfuZiVHJgxEu6U7SA5zn0iTX9iP+a2m4TupUHCTCEmZKzDJNZSVwc7h2v+4Vn6o1
         ZW/YIIpmqW/4d5vyFaXEqSTtRGZhGClfG6DVRFbH+oaSKyc8lOhHPTnsZhGY1kBKi8jx
         rquOsN9hTwHAJgyJNhFRAOl1ZuLz87vwHBMGrmp2Tv0SxkNeIOshkzmoN9tMUTk6fkGZ
         CZu4n7YKYQdUWy0GLzemFDKLonGesra3Tj1MPHm5M9lbtnGZofsvCb41+Q6KL12+mLZB
         o1RradDWGX5VBVuqteBfRS0PJkKjr2vAcuOXtAyhVGHE8FK/cGyAIjgsR1Io/xclmJ3g
         inAg==
X-Gm-Message-State: AAQBX9dfqoZn3GjVWM8xmIDtx4qYjgTatkI7pY9jhubodECTxSCWtF2Y
        8IILAy6VyT+RvOvA2Ar3f8QEuQ==
X-Google-Smtp-Source: AKy350bBfE6YE7vKkF6jYUa53ola/eVUuEKMInhDF04I462o2T68qmBLO7/fpuw89LhKQ8T1lLCkdA==
X-Received: by 2002:adf:fcc5:0:b0:2d0:c37a:5ebd with SMTP id f5-20020adffcc5000000b002d0c37a5ebdmr4814064wrs.64.1680711244870;
        Wed, 05 Apr 2023 09:14:04 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id k12-20020adfe8cc000000b002c7b229b1basm15351729wrn.15.2023.04.05.09.14.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:14:04 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/2] accel/stubs: Remove kvm_flush_coalesced_mmio_buffer() stub
Date:   Wed,  5 Apr 2023 18:13:55 +0200
Message-Id: <20230405161356.98004-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405161356.98004-1-philmd@linaro.org>
References: <20230405161356.98004-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_flush_coalesced_mmio_buffer() is only called from
qemu_flush_coalesced_mmio_buffer() where it is protected
by a kvm_enabled() check. When KVM is not available, the
call is elided, there is no need for a stub definition.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/stubs/kvm-stub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 235dc661bc..c0e2df3fbf 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -29,10 +29,6 @@ bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
 bool kvm_direct_msi_allowed;
 
-void kvm_flush_coalesced_mmio_buffer(void)
-{
-}
-
 void kvm_cpu_synchronize_state(CPUState *cpu)
 {
 }
-- 
2.38.1

