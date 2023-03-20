Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846856C0B04
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCTHDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCTHDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:03:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12003AD3B
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so15410521pjt.2
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5PF3sqkFmxXngJQJQHQ0RIO725f9lA9+mqcaHUiq3c=;
        b=Kh1EYrYamt/CU/BWMDEotcNXoaE3D8KsDeFv2RPQxsT1dCLE0RIQVuu7qHd1yRQhKY
         yR0htgul6y3HUSxgbEa1lZ1o6S2p9g6nEAa5WP0xxtquOwqW9O9IkpLVmQqNSiQzW+l+
         eYwhPLa6ZKWTRMjU6ZYQDdZNBzI/dKuJjpcdvUmlLdY4ZLYFUzxGjXIhyA82YyqEf/B2
         B2Wb9i5Q/kgaio8yioK3tEoXfclrT+71zMffp2jVwM2ICj5KA5YdCZIHLJb9ECe53I6Z
         4P4niikC9zG3fOCDTagQ5q0wVCZweU7Ged1W8cCNd/CpkpVE7YbAA95nU26Jyghb1Te4
         aJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5PF3sqkFmxXngJQJQHQ0RIO725f9lA9+mqcaHUiq3c=;
        b=U4AOhPrzrzCpQiYi8idupPom0VHAd7XQIFt0gKqUfs6jvJL2eE63agQOgkXNBbmw7b
         HO+Hbx8m/81pWXqXcD7Qk4dryBV59HpyAizX2zC3zVNH6by4B/OIVe7NnMZeKUkgD+Sj
         IZSJd/v21vqtjRWzZNii8drMN+iAxN9npQNfC90JqxXzw204nV1LFaPgKxfKHzkUYTuG
         pZuh+zOIQUxPk8C8ShUtutO7xHNLNyAS3KQYSAWa7A9f168dJkW0yP8CWVtu3qzGh+xJ
         1b/MbrQOZ7Qb2+l6iPjYSwULdrJTDdixh8AUc0/up8oZ+du7vWUNylNRBWU20kOAa7sE
         t1Xg==
X-Gm-Message-State: AO0yUKWeWKqItM2uywNaYlgNz+3lAw/l3zXzQoFo+OVlS6i3vH8PZuvq
        aF/7Os1AfrGqN28vo69MsNUfX/XMkt0=
X-Google-Smtp-Source: AK7set8ITskZVGXO4N98vL/NAW3CoS9AAbk6UAN1ecdRjB3Myxm+U2Cn0p5sO+iUsxrX8gtzowstFw==
X-Received: by 2002:a05:6a20:609:b0:d3:c972:9a83 with SMTP id 9-20020a056a20060900b000d3c9729a83mr13550453pzl.56.1679295832063;
        Mon, 20 Mar 2023 00:03:52 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:03:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 01/10] MAINTAINERS: Update powerpc list
Date:   Mon, 20 Mar 2023 17:03:30 +1000
Message-Id: <20230320070339.915172-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM development on powerpc has moved to the Linux on Power mailing list,
as per linux.git commit 19b27f37ca97d ("MAINTAINERS: Update powerpc KVM
entry").

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de50..b545a45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -79,7 +79,7 @@ M: Laurent Vivier <lvivier@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 S: Maintained
 L: kvm@vger.kernel.org
-L: kvm-ppc@vger.kernel.org
+L: linuxppc-dev@lists.ozlabs.org
 F: powerpc/
 F: lib/powerpc/
 F: lib/ppc64/
-- 
2.37.2

