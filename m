Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4099F186FC7
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbgCPQO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27946 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732082AbgCPQO3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDZzTTq3ryTffSf3hGL4Htu3pk7V1G5isiblOtOvRc0=;
        b=MyHz0TZPs9VPdZL+lern1rsRYNodKuGyVwxF3cRO/Al/0BBD+tAvRrt1DaMVah5+o3K9jC
        g7Ck8SJkJmwVGCi+GtRFn8ue8gqbi2fSz/im9lv4Kyb/2r2PxFYir8YN/DauYqGQ+LjtJw
        ++dM0kIBRgD3QiSwnSoSDjaFLL6cWvs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-hbuQPBBJPKeE1SbaULvLEA-1; Mon, 16 Mar 2020 12:08:07 -0400
X-MC-Unique: hbuQPBBJPKeE1SbaULvLEA-1
Received: by mail-wm1-f72.google.com with SMTP id a11so2883759wmm.9
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QDZzTTq3ryTffSf3hGL4Htu3pk7V1G5isiblOtOvRc0=;
        b=o0EPWr0fiW34qS5E8W/19ZpgDI91+1oTib7v4zw9pjdxRRdax/3XkiVXKDuOZXVsfg
         yOgVQjx8rx/f9IP1a3yRJoVL5IJZN8SHa0jxKyhzbqmT6vQcDjxJfWTFRrDLHiRzfQQ9
         eXTQy+LXWniZhQ6+tePWjPR2/4dcd1ke1jEh3CuXIxAOmVeNK3th1q879t3QFIpDw1OY
         4yyOH6cM/wqEgvJR+rJQXQYrNamGLA9/v/yxElv1ZZqdXSriKC+96JZQHI+EO4t+L/h0
         2BTp04hOnO2S2Njj7fN18SxdlEYgW3UUd3SpLoVA1AdISkgs4BdNZxhJqmwWOGgz086v
         vvHw==
X-Gm-Message-State: ANhLgQ3Omv4M0OmYL81xVBMuuv82RYCqGvuZ/YoqSOI2oFNkeLhuUZQh
        AsCeV7hWtHT3ql/y7E1PsfxkQnTrbaoiVOnXGo2u190bfTZ+d9/+z4arySb+qpmKKoqcom7A+PK
        rz4ffsGiPGhY3
X-Received: by 2002:adf:ed85:: with SMTP id c5mr82536wro.41.1584374885378;
        Mon, 16 Mar 2020 09:08:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtsr6U360K/odsCSzAC+mklkWuyn4n54yHB+Y2LZqv/r6/8LWfd199gkdpJvQ01dxn7hcEgzQ==
X-Received: by 2002:adf:ed85:: with SMTP id c5mr82517wro.41.1584374885204;
        Mon, 16 Mar 2020 09:08:05 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id o23sm553874wro.23.2020.03.16.09.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:08:04 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v3 16/19] target/arm: Do not build TCG objects when TCG is off
Date:   Mon, 16 Mar 2020 17:06:31 +0100
Message-Id: <20200316160634.3386-17-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We can now safely turn all TCG dependent build off when CONFIG_TCG is
off. This allows building ARM binaries with --disable-tcg.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
[PMD: Heavily rebased during 18 months]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/Makefile.objs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index 993899d731..0178431549 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -60,8 +60,6 @@ ifeq ($(CONFIG_TCG),y)
 obj-$(CONFIG_SEMIHOSTING) += arm-semi.o
 obj-$(call lnot,$(CONFIG_SEMIHOSTING)) += arm-semi-stub.o
 
-endif # CONFIG_TCG
-
 obj-y += tlb_helper.o debug_helper.o
 obj-y += translate.o op_helper.o
 obj-y += crypto_helper.o
@@ -80,3 +78,5 @@ obj-$(CONFIG_SOFTMMU) += psci.o
 obj-$(TARGET_AARCH64) += translate-a64.o helper-a64.o
 obj-$(TARGET_AARCH64) += translate-sve.o sve_helper.o
 obj-$(TARGET_AARCH64) += pauth_helper.o
+
+endif # CONFIG_TCG
-- 
2.21.1

