Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F70173A5BA
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjFVQKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjFVQKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:10:48 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1A1FC0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f9b258f3a2so49975975e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450231; x=1690042231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrWBSt50GXK7KCFoWhMRFDVlBR7e4c4Lap7a/Dv/MfQ=;
        b=uh16dyOE/YngV+vlrCn9FF7LTn5kqMPDeNAZPJp/OXd6o48t2oNQK6+xyZgF0O/Rwg
         eOGnESuioKTn+49rZFTitvpZbXcCCA2lKI3uKKPWDO6qAJwPVxKRyFjY6tswlOnD5ggQ
         uglMk0I6MEVmcZiNo50/xLJc3XKZtwUiYzcshho3Z8PHZ77Ff5SeMMqNEPPm+6yamswW
         43xD7f+l3wuUlEu0Jk5k14uNzXBhG+/BP5Z2LtMbnA+vN2SOlxaHgl9cD7Y/VNZS7ggW
         sXiU9m8gF/k7MyaKQbMxBUzf2iKP0B73BEmBKpJN7i3GqROl8rychDyAYceCJlDAbGA3
         M6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450231; x=1690042231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrWBSt50GXK7KCFoWhMRFDVlBR7e4c4Lap7a/Dv/MfQ=;
        b=eghbSONUDy93CfbYLA2drOIKhRP/sw94GE0U+kImupT6IC4dcXJpQmfZ/YMs81WpWJ
         WkRM2QkBJ9BA34Wv3tB2f8tTvSmYJhAXm18FOMmqX3/uBRsY3Lu6MFbuosjQvJI0PqiI
         JcHpTkAcY/8HDXViuPTM3tZZhpYW05tDoSyU7LOxe8e8veUkEUg5UVq7ktU4hAPArxrO
         xyYnx6rq00d2OPUmf7uxapqYPH5GwDVhyiPBNlmMHWBijm2ueUqy1VWvQwn4q9tX0ylK
         TNNvplw2FtBRTrKhUt+METHs0XGzXjcZf5tbIM9fgXzJbRBAiaa2sVE4e/+i7PsPqi03
         ezVg==
X-Gm-Message-State: AC+VfDw4Wy2Hg/cnFO+qv6OI4qFFe3tmn1d7Om52J64GaWgdegYVIobD
        qDHD21+ga9D8JPIdF7nR4cDpmWWIWIIWBGY5TNTi3Q==
X-Google-Smtp-Source: ACHHUZ5cB8aDLTQ/tjJec4fXZP1xWmF+PhC752VaaNKObmwfmqLXBqw27M1/B1ILuvDg4fp61kaDNA==
X-Received: by 2002:a1c:7911:0:b0:3f9:b2a9:c546 with SMTP id l17-20020a1c7911000000b003f9b2a9c546mr9068827wme.28.1687450231205;
        Thu, 22 Jun 2023 09:10:31 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c028800b003f9c8c6bf53sm3978876wmk.13.2023.06.22.09.10.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:10:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 12/16] accel: Remove WHPX unreachable error path
Date:   Thu, 22 Jun 2023 18:08:19 +0200
Message-Id: <20230622160823.71851-13-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
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

g_new0() can not fail. Remove the unreachable error path.

https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description

Reported-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/whpx/whpx-all.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 340053e6dd..012ba696a9 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2179,12 +2179,6 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu = g_new0(struct whpx_vcpu, 1);
 
-    if (!vcpu) {
-        error_report("WHPX: Failed to allocte VCPU context.");
-        ret = -ENOMEM;
-        goto error;
-    }
-
     hr = whp_dispatch.WHvEmulatorCreateEmulator(
         &whpx_emu_callbacks,
         &vcpu->emulator);
-- 
2.38.1

