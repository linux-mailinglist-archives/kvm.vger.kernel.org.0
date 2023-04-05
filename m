Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069A06D82F4
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbjDEQGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbjDEQGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:06:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227465FCF
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i9so36738238wrp.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCSdJqBx+24lo5un4mJkeawVRhwXkPODtT/ypBXdn1k=;
        b=nYNsq+8yFO7mMRk2/GCs4D4e2iDu1F5AjhPlSj5MwnASO0hw5U/4oxpVLogb6drfmz
         3xU+KV29anaINmgzTl9ZhOc9H9utB1dE343KJ/Ch3nsDN2awoc2m/uGIUTaVMxmzxSgG
         xqRD/xBZxEreYRjFvoqcqzu5XK6hiX/J8pDK3O5eVEHmU9QCzAK4BaAmplmm9aESOaiO
         ae6Uv7SF5z/IgEENdF+M+eAcH47+wYVpnVgBJUOx9FPSM7Zy1/YL3ZUrvW8BmVJCLBZH
         ZI65eOSaRJWzT4iXngpJ6wyoT9UFNgKF6YSG3WUY8ns0z8i9D9egnrZvA5oKcJER0raT
         J/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCSdJqBx+24lo5un4mJkeawVRhwXkPODtT/ypBXdn1k=;
        b=yNOXmHLpYJ4FOXjwM2GDtebCAb0ISAt5M+ebsWM6DUTvhVgRAJDCLEwOqW+IQwRjpg
         nh3/+LNm2PvAmqseV//VXr09UxVGHNMzhTIINOxrNb3Mkwx0ljwUqgL5VHIaWoj5EzBa
         K6CoINMiEacnMiAOnG3HrbRCL7DJIu1hBEdDrcXuXGvflS+N1sbyYzUdhuhxV8j6lEsu
         zitQ/CB7ee2RbpvTOgDaowHEhhruMNQNwTTibX0o3y9heHeNiQ3X0ZWIMtUgQLlAMWWv
         FW7yY+nFjmRkVyS59FvhKcGajOs1JpQWjbUcBSn6fBLxA/hhZqSPL7nSaC/nw23z7bZA
         4AnQ==
X-Gm-Message-State: AAQBX9fSsPk67cEH+Nck+jdlgbAVBDQH/x/yPY2Lqxca+8qtLQSSrQ0K
        YqJ6tO5kmghppERmIfWnX1i64A==
X-Google-Smtp-Source: AKy350YkYdiHXB0g5ih7Cr+SgsA3BhgsWi6U992BWoRDvOtWKxTNhNkKh0iJQeFeR5+OUd9Zhgsf8g==
X-Received: by 2002:a5d:4745:0:b0:2ce:a835:83d4 with SMTP id o5-20020a5d4745000000b002cea83583d4mr2147619wrs.27.1680710755745;
        Wed, 05 Apr 2023 09:05:55 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000100c00b002cea8664304sm15199709wrx.91.2023.04.05.09.05.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:55 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 10/10] hw/s390x: Rename pv.c -> pv-kvm.c
Date:   Wed,  5 Apr 2023 18:04:54 +0200
Message-Id: <20230405160454.97436-11-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
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

Protected Virtualization is specific to KVM.
Rename the file as 'pv-kvm.c' to make this clearer.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/s390x/{pv.c => pv-kvm.c} | 0
 hw/s390x/meson.build        | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename hw/s390x/{pv.c => pv-kvm.c} (100%)

diff --git a/hw/s390x/pv.c b/hw/s390x/pv-kvm.c
similarity index 100%
rename from hw/s390x/pv.c
rename to hw/s390x/pv-kvm.c
diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index f291016fee..2f43b6c473 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -22,7 +22,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
   'tod-kvm.c',
   's390-skeys-kvm.c',
   's390-stattrib-kvm.c',
-  'pv.c',
+  'pv-kvm.c',
   's390-pci-kvm.c',
 ))
 s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
-- 
2.38.1

