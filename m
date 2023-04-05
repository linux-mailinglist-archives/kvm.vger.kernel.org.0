Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AEE6D794C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbjDEKJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbjDEKJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:09:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9230E4ECD
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:09:08 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so18073538wmq.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOIUAejMDgPGNri6CTMX+NYmgz2rO96F3gJmXNOLJxs=;
        b=S/sJ8y4f2rUl+i71e+mCuGZuZfY5fREdNc1TFr/aEXiGuikTme64GMgqYOa7eqvixO
         sNf4U91Oj8cWhbCz7saOEF1jx3ZzoabpA11OvpGepX7sFWjMI2K2iaCYA5Fb4cTqW4qv
         HoQvYT2zAkq2AlgE8ycDb+ODBHfZ/BCzFs9ybHjyfKeXsodw2D/l0JLrY1+diUnYMK0E
         tXVNnQT0t9UN3DtYNnVA9xztmGer2h8JkgXwvU5dkPdsfscXL8aUv9mc9gBJdYD4Nbx/
         4iwShUAj28BK3KLQ6kcThPbwc066mniDVXLh3YMBP3tos1Egxks3TfoEQ8SlpiFstZX7
         RYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOIUAejMDgPGNri6CTMX+NYmgz2rO96F3gJmXNOLJxs=;
        b=ip1+J/f87jQdOnMZcr2E24irfcnxkvplc39f0woS7vLijgfZn4qAdP6KCDG6Ky4/AU
         IfjiTb5Ejy2156Z6Oyd+l2XLJIC2Ih5bJ1gi/irGdNpfFaGkq01Acr5vU95rYD3vxOYI
         Xmxu0dDxNvqK6fUvz0lJvwMepSrN0IMpvhIsOemyyj/KdHZqkpQ/jworTUteR53ovKZ6
         CKz98e60uXAYTQn4quK7ZjUb4wRXJHl04IwLq7gAa9Ui9t/G3oBmVVmYiNrgnU6KeYAC
         ZG32GQWIU0N0eIaTyWHw4p+o4qJDMK+0IPcAbmEDMdv14/nAW5ihLmN/JNgufJRP2/R/
         fFRA==
X-Gm-Message-State: AAQBX9cq6W0x10vRRxer6PWQnSG8xUUlUcqKMl7dPOV+gLwN0wb+kn1x
        wyoUuW+K88hUvzTiLDJ9AQ1dSg==
X-Google-Smtp-Source: AKy350ZwPv7srv1WoSO/MmSOa2UJdjZu3e7HsfWH/ffyjG4++YTRkUBAfgBBRDMhjS3YahEj4GkMfQ==
X-Received: by 2002:a05:600c:25a:b0:3ed:237f:3da with SMTP id 26-20020a05600c025a00b003ed237f03damr4592489wmj.22.1680689347060;
        Wed, 05 Apr 2023 03:09:07 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id m19-20020a7bce13000000b003ee1acdb036sm1700160wmc.17.2023.04.05.03.09.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:09:06 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/2] hw/arm/virt: Restrict Cortex-A7 check to TCG
Date:   Wed,  5 Apr 2023 12:08:48 +0200
Message-Id: <20230405100848.76145-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405100848.76145-1-philmd@linaro.org>
References: <20230405100848.76145-1-philmd@linaro.org>
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

The Cortex-A7 core is only available when TCG is enabled (see
commit 80485d88f9 "target/arm: Restrict v7A TCG cpus to TCG accel").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/virt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ac626b3bef..1fe39c6683 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -204,7 +204,9 @@ static const int a15irqmap[] = {
 };
 
 static const char *valid_cpus[] = {
+#ifdef CONFIG_TCG
     ARM_CPU_TYPE_NAME("cortex-a7"),
+#endif
     ARM_CPU_TYPE_NAME("cortex-a15"),
     ARM_CPU_TYPE_NAME("cortex-a35"),
     ARM_CPU_TYPE_NAME("cortex-a53"),
-- 
2.38.1

