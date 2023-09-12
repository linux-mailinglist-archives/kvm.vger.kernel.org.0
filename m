Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAF579CFED
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbjILLbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbjILLas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:30:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EF1B3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99bcc0adab4so696977466b.2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694518243; x=1695123043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJDcYGi9xkj6QKbqo3iNcw77O78wB7Hq6Jj/+q8EmC0=;
        b=kjaji4rCE6gdEkZGoCGBCqgiIfXqS1Dw8HL4f2pjTqVT81j8MU7qvR2R30KSIH5u7x
         6PGeEfempwwE1u2xCKL239Wns00SevrhouBT+20gd0YUwNSOdAPVO21xtmbyCpvXCJ5L
         ru2VdFEniuFTBctOvSO1kLIcEl9QZXaCAoi+yNRKvF2/6Vk6Ogh38VPdQMQYXKTQZxLd
         jBUpkC0McZZATlLb8zMDkA29g9zxRu4+evWG19EuQ474JVzQMAyKL1vLhpdYmtYOOXAE
         7TJQHbq64rHROVHOxTjNywFWdOIpSDwqw309zuLIzySTZffk6UM5sLeW7KLbzST3Pcad
         /9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518243; x=1695123043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJDcYGi9xkj6QKbqo3iNcw77O78wB7Hq6Jj/+q8EmC0=;
        b=NBOlQQysplsaHtEdw01mlqJNezdof6f8f99X1BE6HpNXJt0GpNMZV7vladGSNqZ64f
         fVS1KASDqCLsDNC0dvuDfuuYcJBanzuJYKBmjAi1BTqypgykkFDIfbTRa5hCbSwR832w
         SmF0VUF3tUSzOFB7jb3oLICN6LfVwcelDc+FvhxlWS27BT8Yi8kNEWMsuL2hr9YQ98Vr
         mRju/IB3yx7b66ksA7RRL4KPrc9LM5dCMIiQkKOUKT50ze6yF2YO7u4QhYcMBlaqqoZG
         Vm7G2jzN0SLjb/rWiBQveHR/zLXUTF9/Cncsqcdp7Pbfm2G2XDSS+ZCuqxe3Xma07AQn
         49RA==
X-Gm-Message-State: AOJu0Yw61LPToSfnSiMWyG1oXxtnRoMosrbIc5y0uHY1oD5603suQSB+
        uEWyoX203GyQmPLPfwP3t2Y31w==
X-Google-Smtp-Source: AGHT+IFGR/hGUK+MotInaJDLHL5KTJ51jW0Vv1cuFdKWsf08M8zQ6ICYJzMY0WFbfe/ZeqQConVujA==
X-Received: by 2002:a17:906:1da9:b0:9a1:d79a:418e with SMTP id u9-20020a1709061da900b009a1d79a418emr10080318ejh.40.1694518243093;
        Tue, 12 Sep 2023 04:30:43 -0700 (PDT)
Received: from m1x-phil.lan (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id ld10-20020a1709079c0a00b009ad829ed144sm953504ejc.130.2023.09.12.04.30.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Sep 2023 04:30:42 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/4] target/ppc: Restrict KVM objects to system emulation
Date:   Tue, 12 Sep 2023 13:30:24 +0200
Message-ID: <20230912113027.63941-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912113027.63941-1-philmd@linaro.org>
References: <20230912113027.63941-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-stub.c only defines kvm_openpic_connect_vcpu(),
which is clearly not used by user emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/meson.build b/target/ppc/meson.build
index 4c2635039e..bf1c9319fa 100644
--- a/target/ppc/meson.build
+++ b/target/ppc/meson.build
@@ -30,7 +30,6 @@ gen = [
 ]
 ppc_ss.add(when: 'CONFIG_TCG', if_true: gen)
 
-ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
 ppc_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user_only_helper.c'))
 
 ppc_system_ss = ss.source_set()
@@ -46,6 +45,7 @@ ppc_system_ss.add(when: 'CONFIG_TCG', if_true: files(
 ), if_false: files(
   'tcg-stub.c',
 ))
+ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
 
 ppc_system_ss.add(when: 'TARGET_PPC64', if_true: files(
   'compat.c',
-- 
2.41.0

