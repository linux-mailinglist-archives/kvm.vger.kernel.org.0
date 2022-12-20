Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731206522BF
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiLTOgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiLTOfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:35:48 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE9A1011
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:47 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 131-20020a1c0289000000b003d35acb0f9fso1193865wmc.2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhQROkoTF/kPUU9r78mLwXXxUZ3Qm+COeH3BT1STH1I=;
        b=U4bdbUmaKC05ztUaihxcBo5oVklE8EtQIIjgLEAW6aUtd2R4tZP13fs1igeMLdZ0Hy
         tceVk0pTuZr20byqEM0GGFlRSzOXizqZBTlig538uuZDAptvbU5ka0pVylklZCOY5QXE
         OucNrefj0aiplupBUujPXxDn1WQE7nqHEnEqN3EWHQV5MI9mjwYo1iYstCELMzpReEMQ
         bFt2im80GhDxHiE8NGJ6SOI+Djzl2912/B2c4eykby18ExJ/Ys5/ppLx5QpxkYYYWZtH
         EYpqIxdDbqn94d0X5CeTZRsSB8ZzYtv77MO+Bh4gFMh2EbmEJsFQi3n8v4wAwIyHKQdl
         7J8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhQROkoTF/kPUU9r78mLwXXxUZ3Qm+COeH3BT1STH1I=;
        b=q1VqC+NqEDSoI4Qsy7nk5qLUaT48WpBJalc045NI/L9KzeuoEVh+AgD1/YK43SAJCH
         FfCopU5OhzrhnTS/7s6lxtZMemzAaXvSqYfbtplDIw+GC29vrFVdUSh204+ZezQAnnfw
         HNWMNCvF782gIDU7fvfpd0Pzv63cf9Rj7or1MojUlSymoVgPVwiBRuRQX5L6dGFxODf0
         o+D5JGKCWtK+waO9QDyvNqNOB5ylBVGVSMrtGs4fAqMTSFoFEf+gGbnKW+31ZpX1fGnq
         cSmY+wROP+709UGuaGCREzBHitmkwUd5z8lBfUmgUmx4OpOJcajxuEa5vxmSdguo0XFs
         pl7A==
X-Gm-Message-State: ANoB5pkIR8a+NEOPL97IFZ16g+unf9TzO8SStLbqOoEF/uaxCY8tjf4P
        wa2CrfDj85wM0BXJsnHuoWCFSg==
X-Google-Smtp-Source: AA0mqf792O3BK2uXTYfgvov08uy+kZdnUa+nGrxbZsstHA2YWoojeqCbLBegPYPDG9UvgMVcaO5XEw==
X-Received: by 2002:a05:600c:310e:b0:3cf:b07a:cd2f with SMTP id g14-20020a05600c310e00b003cfb07acd2fmr34553438wmo.37.1671546945726;
        Tue, 20 Dec 2022 06:35:45 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id m34-20020a05600c3b2200b003d208eb17ecsm17185197wms.26.2022.12.20.06.35.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Dec 2022 06:35:44 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/3] accel/kvm: Silent -Wmissing-field-initializers warning
Date:   Tue, 20 Dec 2022 15:35:31 +0100
Message-Id: <20221220143532.24958-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220143532.24958-1-philmd@linaro.org>
References: <20221220143532.24958-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Silent when compiling with -Wextra:

  ../accel/kvm/kvm-all.c:2291:17: warning: missing field 'num' initializer [-Wmissing-field-initializers]
        { NULL, }
                ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e86c33e0e6..acf1ef84f7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2282,13 +2282,13 @@ static int kvm_init(MachineState *ms)
     static const char upgrade_note[] =
         "Please upgrade to at least kernel 2.6.29 or recent kvm-kmod\n"
         "(see http://sourceforge.net/projects/kvm).\n";
-    struct {
+    const struct {
         const char *name;
         int num;
     } num_cpus[] = {
         { "SMP",          ms->smp.cpus },
         { "hotpluggable", ms->smp.max_cpus },
-        { NULL, }
+        { /* end of list */ }
     }, *nc = num_cpus;
     int soft_vcpus_limit, hard_vcpus_limit;
     KVMState *s;
-- 
2.38.1

