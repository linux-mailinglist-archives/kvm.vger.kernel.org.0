Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E1816F8B2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBZHpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:45:04 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:47597 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbgBZHpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:45:03 -0500
Received: by mail-pl1-f201.google.com with SMTP id h3so1396412plt.14
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yng0GPy0e4PuBKIocCGSBVAxQisSu+IFnd/3PrDUp3w=;
        b=wPT135dKnaFgTXeaqYhuIk8yZBRCIyobhOLCm8t1kPJ+3N6Mg7Pbl/ygvDL1ZEemoE
         hpeO/T8WFTnM9X7TSyMd2oes5fk3ExNY2FfP1f4SuE0B0O0bib5kARk88Zt8SyDY9F6A
         EMkkbrXM8V85v5mbMl/L4tQWgVJ7oa25qBZ7fNWgQtxwNgFn6+zooZt+KThVI2DorE1k
         H5clgDCFTd71rbXed+VdMoY/PIU3CA5b1oQA6ecSMSnDNteMFItESJff9kBhXSiYrtMG
         IGUay8QwnVwsNdnh6W1WKm/sn+hXUnzEffWU+oeMmfF17RN+q3a75+HJvJsMpGJOvy/q
         QwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yng0GPy0e4PuBKIocCGSBVAxQisSu+IFnd/3PrDUp3w=;
        b=Hvk8odPs9kGGLMJWYrqJiM8kNacLMHfkfPsLnTvtd32EbWfE2IaoeQDyU3KznhMbDw
         fGJn68KdasD0Srb1Y7iq2uhwPi0nkhIK99q3InHsVA/gYztYfRXiuqXTjG7idvIgY8xs
         93De/HygEdae1MaVYtnRqJiBiRNr/6Jz/V97z0NDzNzGdRQBirUY00UuohwnUDyh+smB
         nmSjncMxfHWQyDxf+qFinLQhpY5SxCvK8qRGOLnQ/TAzPcht/94JvKFvJEoK9bC7eXMg
         rOtNK42rh62ScGxKJ6YgxYlYQGx64P3ikLfI7wKJYaRWCV8YuDCXp/qYQ++ySkVyw81t
         Z9dQ==
X-Gm-Message-State: APjAAAVN6rFiDf7uWE/VdlG1O2oUTfhmlnKHJBz/hRk4/SM1et2+SSZi
        DQKOKZy39dOTJUis3Z4566+yBhlm+StyvEQDO9LeoScCCD7aYMPC24SI088Gu18Yhp3Gx3g2Wzy
        KBoJs9b0+Wm4Nbi1jR3qqo2XKIwoDEL13f9gUJ+QyFQzvjj0ojzhIYQ==
X-Google-Smtp-Source: APXvYqwO4Nifwise5A6AMPigFvw8PHLykHiLaZZV3Ll47ZZeOC2ZNA3DL1hkuIBhhtFSgn1rH1UPcR8LHw==
X-Received: by 2002:a63:f10c:: with SMTP id f12mr2665678pgi.386.1582703102494;
 Tue, 25 Feb 2020 23:45:02 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:25 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-6-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 5/7] svm: convert neg shift to unsigned shift
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

Shifting a negative signed value is undefined. Use a shift of an
unsigned value instead.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index ae85194..17be4b0 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1148,7 +1148,7 @@ static bool npt_rw_l1mmio_check(struct test *test)
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
-#define TSC_OFFSET_VALUE    (-1ll << 48)
+#define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
 static void tsc_adjust_prepare(struct test *test)
-- 
2.25.0.265.gbab2e86ba0-goog

