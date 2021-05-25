Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0936C390807
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhEYRow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhEYRoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:44:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE43BC061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:42:35 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f6-20020a1c1f060000b0290175ca89f698so13966398wmf.5
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRd9XsO+PDr6n4FeCOKrjoZ73C+wdSaKiGHr6cRSi/o=;
        b=lcuvChzJ8BN2TYlPcmvvAZ5Q1xMlrBmS6r7ceo1rAACSz8yGjYpW+/iucHYFCQ0Wtd
         6w0DRSeHgsM28X67c9WCerAUnRIiXLyA0Wi7Ni8yoZc7SJ+HtTx2oio0cOFQA6fzRa0B
         ApTF3w5tVirxlb7+AohSilHxlzQwyDv+MexiO+tDQGOcseSL09qetYIZS4pPRsmYGJMm
         N5WHGRY+kRtvDtApIvxHS0tn8Y8N1Rvc7YA4CWBuWvPEH4ctTCXt22B3tF8ft69JgPiI
         IgfwpdhDSf+t6Ai7635kgD4PE1ZBCb9vdU/puofaNvmoQaBY2eDAKLfR7qPbp9lMt0pH
         BmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRd9XsO+PDr6n4FeCOKrjoZ73C+wdSaKiGHr6cRSi/o=;
        b=RF3/+H76PIVwm17TShVxFfqLkoutJ4SMchd5QKooCiV5d35lODA4h8PWc9INuvB/rc
         8HKFAKvhkuPdoP3MGfUoBYfKvalRlL5c+H7zxbIzozXKpVj6iEhj/JZwhysgro6f/6Q6
         5LwX+qgdKLMV7y7AG5oQROEd3053ii+8XffYK3LJrYcAC9TDnx+uSSOXNylOzKfaIr3L
         sH0El3MI825sQNvjGzvX/fPDgAzmksnKYflLVBwypuPb9TkX3iU1UDkyAP7fAnSpWvEM
         7tmUzZ9wuzDd2+YJJmxInHFK0s6oFtnDJop8VYManQv47ZWXADrUHbAR2J9H3+Y5hn/k
         0Rkg==
X-Gm-Message-State: AOAM533XqcZP7vsUjXzvdElSteFQslAaSxgJ2BYhEujeQlfqu/nxfSEg
        56Nh9x1YT5pkgU6UimPjvoeTlw==
X-Google-Smtp-Source: ABdhPJxaqQHNaLKGr4fuwt/Q7tHiqBlX9WrKJ8ZFkr85g6fKVEx9BNsMXajWfHgn+YRz4uEKvCtTeg==
X-Received: by 2002:a1c:b646:: with SMTP id g67mr24639077wmf.117.1621964554306;
        Tue, 25 May 2021 10:42:34 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id d3sm16788921wrs.41.2021.05.25.10.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:42:32 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C4ADF1FF7E;
        Tue, 25 May 2021 18:42:31 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org, qemu-arm@nongnu.org, qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests RFC PATCH] arm64: split pmu tests into tcg/kvm variants
Date:   Tue, 25 May 2021 18:42:21 +0100
Message-Id: <20210525174221.16987-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU is able to give a counter for instructions retired under TCG but
you need to enable -icount for it to work. Split the tests into
kvm/tcg variants to support this.

[AJB: I wonder if the solution is to have a totally separate
unittests.cfg for TCG mode here?]

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/unittests.cfg | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index adc1bbf..2c4cf41 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,24 +66,40 @@ file = pmu.flat
 groups = pmu
 extra_params = -append 'cycle-counter 0'
 
-[pmu-event-introspection]
+[pmu-event-introspection-kvm]
 file = pmu.flat
 groups = pmu
 arch = arm64
+accel = kvm
 extra_params = -append 'pmu-event-introspection'
 
+[pmu-event-introspection-tcg]
+file = pmu.flat
+groups = pmu
+arch = arm64
+accel = tcg
+extra_params = -append 'pmu-event-introspection' -icount shift=1
+
 [pmu-event-counter-config]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-event-counter-config'
 
-[pmu-basic-event-count]
+[pmu-basic-event-count-kvm]
 file = pmu.flat
 groups = pmu
 arch = arm64
+accel = kvm
 extra_params = -append 'pmu-basic-event-count'
 
+[pmu-basic-event-count-tcg]
+file = pmu.flat
+groups = pmu
+arch = arm64
+accel = tcg
+extra_params = -append 'pmu-basic-event-count' -icount shift=1
+
 [pmu-mem-access]
 file = pmu.flat
 groups = pmu
-- 
2.20.1

