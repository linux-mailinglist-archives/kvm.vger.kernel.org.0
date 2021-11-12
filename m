Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D244E5B1
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhKLLu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 06:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhKLLu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 06:50:28 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B24C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:37 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so6544180wme.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wIGpUqKKsdBHIVu7qLREHVQ4Ti/omu4NC8RNTDPGi9k=;
        b=vj2y4YrzQqksYHFE33XVZ3whLo3Chi4yrXCxl7Zy/f2tOEeUlTog/fLlj88qlAPiY8
         uMM539hoRcocmCg108gpHECMDvof/LYSZNr/jPZ2vukiExcLgxs2z1RvXdozoRfbxORA
         44VpQ2vS+n3E9P9a1JwLQHXdTjQm1/wNh+83ccPR1sVoT+GlM5snCCbJknbIgnXpzSit
         hmlm3R70Q+mA/3w6YI37GLKjB5LAGu2+wHggWgMJI+FWtNZO5xb3tv/u8+sDTEtF2XP4
         Ak6acw2EJOQZeRiYPU06WMNZGHISBo6kbECUA045yPrf7jkVw3fXpxFWmIdwp9X9a1p3
         6taA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wIGpUqKKsdBHIVu7qLREHVQ4Ti/omu4NC8RNTDPGi9k=;
        b=j/hxqRooeqsZ3eAWhrqdPSLHemEVAnDqKbJ/d8UrhG0bqhlPsD1z3A3XgbcS0aaL4a
         1hTBca5DPuioSBAYZ3U12PmIvLfW6uv6VE2EswxWDHopOv7FpvR/H9rpZU1dNnli4Dtv
         NH+H0cjb4/l1lIVx9Nx9N1o8bz2kPOyQte6gNE8q0F3l7Ii9XrJrd5PsGXvfvVX+y02E
         UOuTY32K0nmoBlg4n2mQE4oU0d+EqbX5fhkQ+n7HUzDbtzTLh6/URWFAqBSvvKTZwu8K
         dGtAwevv4dJ8EaoEH9Pm0bRmHBODihCBBGCZF46uEvPDIiF4vczwo3puI3oghEqXEBek
         S3fA==
X-Gm-Message-State: AOAM532WJimhhX5vkajLm48fH2Z65YlNJ4bOzR0QfrHQ+gem0w0a/mGj
        UYIfWfOmHU+pYS6rjEh1bgz0RQ==
X-Google-Smtp-Source: ABdhPJyENsuVXPYwrdzvRDQJQgMZaKOk+plTsoN67GYhMD9w1WdUkbkFRgRwdFvp07nDvh+ZSFMfsw==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr35189034wmr.48.1636717655778;
        Fri, 12 Nov 2021 03:47:35 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j40sm6114775wms.16.2021.11.12.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 5F2261FF98;
        Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v3 1/3] arm64: remove invalid check from its-trigger test
Date:   Fri, 12 Nov 2021 11:47:32 +0000
Message-Id: <20211112114734.3058678-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While an IRQ is not "guaranteed to be visible until an appropriate
invalidation" it doesn't stop the actual implementation delivering it
earlier if it wants to. This is the case for QEMU's TCG and as tests
should only be checking architectural compliance this check is
invalid.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
Message-Id: <20210525172628.2088-2-alex.bennee@linaro.org>

---
v3
  - reflow the comment, drop "willingly do not call" as per Eric's suggestion
---
 arm/gic.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 98135ef..1e3ea80 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -732,21 +732,17 @@ static void test_its_trigger(void)
 			"dev2/eventid=20 does not trigger any LPI");
 
 	/*
-	 * re-enable the LPI but willingly do not call invall
-	 * so the change in config is not taken into account.
-	 * The LPI should not hit
+	 * re-enable the LPI. While "A change to the LPI configuration
+	 * is not guaranteed to be visible until an appropriate
+	 * invalidation operation has completed" hardware that doesn't
+	 * implement caches may have delivered the event at any point
+	 * after the enabling. Check the LPI has hit by the time the
+	 * invall is done.
 	 */
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
 	stats_reset();
 	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
-	wait_for_interrupts(&mask);
-	report(check_acked(&mask, -1, -1),
-			"dev2/eventid=20 still does not trigger any LPI");
-
-	/* Now call the invall and check the LPI hits */
-	stats_reset();
-	cpumask_clear(&mask);
 	cpumask_set_cpu(3, &mask);
 	its_send_invall(col3);
 	wait_for_interrupts(&mask);
-- 
2.30.2

