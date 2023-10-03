Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3217B620A
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjJCHE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjJCHE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:04:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38C590
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:04:53 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-31f71b25a99so614742f8f.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696316692; x=1696921492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQzhyHwmNDSDi5pTVRLTrtcYFBIcSrpF9DmpQnEWx1k=;
        b=ZHmCl1vJfVDmxCrjCfeOs5OyW4vG1ypmWZzYeeaKM+vpAlMdYyalqmFbuqGve4OZPj
         zo14KBvVxM1LHEZaD7rIFBcsUDX0Urvf5b9pTEny0u3WZdOs4YwIw8VtSVoWyrJNG2x+
         W04zHEsXtUNcq1413ssU26DulVzFJTH39dk1YJHURk7BgzuOB3KJHeDDsjes5ARTlbJx
         rvLRVVwJCm2JN4M4sRi5nVH4oTuCRJjTGiQmpHrLuBbt8GxyPoI/p7fdCS67bfXSRdnA
         w7lraoWml50ZQ4+6VsJsyQXEs8wg43lP2SO/AP2o/+xAo0Tjcz5QveqPgkuWuHV1CSB3
         Xq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696316692; x=1696921492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQzhyHwmNDSDi5pTVRLTrtcYFBIcSrpF9DmpQnEWx1k=;
        b=vzvVARelmRKosCHOBVrrVXCSMGr6uvOwYnsT4orsvxhtzfdcJOLJv7ygwQ5EbgvvtR
         u94tyGBQTPULBGsikX+auI1QEPzKSy7SrkfLkE0Xhxptet6iQLa3YOqeF6W4tz/GkuNc
         GIPT0w22Yrvugus2JfldiG/VSHuptummtUMBWbrhiwLUJRKAl1Up91kAxtl4zC5nw71M
         6roPS8NNzBGbmUHh1bE5B9JoiMMsiONbYkSPQpLGGN9seyCvVfJNKE0LJtzOR/DUpjMU
         Tq0YE/8iqFCrDH+ZH1yfSFQJv9+SFnWacncC1aFuIJfuweL+4yrrlxa/NchkNMhqxAF3
         OErw==
X-Gm-Message-State: AOJu0YxxfmNlfAOEA3cj/0nx5iPAfdkU9C//DsWx4N7CV3PunR1m6fAX
        uG2A4YXeQvYsD2qydm//4CLlTA==
X-Google-Smtp-Source: AGHT+IH5gi/VEas+l3NNvHvsWgSkQlY/4YqInldrRsPk6XIBCqPemE3++yzm1NzvbAR+ZF3pEplFwg==
X-Received: by 2002:a5d:618c:0:b0:31f:eb6a:c824 with SMTP id j12-20020a5d618c000000b0031feb6ac824mr10944176wru.10.1696316692435;
        Tue, 03 Oct 2023 00:04:52 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d50c5000000b003200c918c81sm813270wrt.112.2023.10.03.00.04.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 00:04:52 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 3/4] target/ppc: Restrict KVM objects to system emulation
Date:   Tue,  3 Oct 2023 09:04:25 +0200
Message-ID: <20231003070427.69621-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003070427.69621-1-philmd@linaro.org>
References: <20231003070427.69621-1-philmd@linaro.org>
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

CONFIG_KVM is always FALSE on user emulation, so 'kvm.c'
won't be added to ppc_ss[] source set; direcly use the system
specific ppc_system_ss[] source set.

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/meson.build b/target/ppc/meson.build
index 0bff3e39e5..44462f95cd 100644
--- a/target/ppc/meson.build
+++ b/target/ppc/meson.build
@@ -30,7 +30,6 @@ gen = [
 ]
 ppc_ss.add(when: 'CONFIG_TCG', if_true: gen)
 
-ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 ppc_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user_only_helper.c'))
 
 ppc_system_ss = ss.source_set()
@@ -46,6 +45,7 @@ ppc_system_ss.add(when: 'CONFIG_TCG', if_true: files(
 ), if_false: files(
   'tcg-stub.c',
 ))
+ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 ppc_system_ss.add(when: 'TARGET_PPC64', if_true: files(
   'compat.c',
-- 
2.41.0

