Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6CC3D1E64
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 08:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhGVF7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 01:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhGVF7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 01:59:47 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF533C061575;
        Wed, 21 Jul 2021 23:40:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m16so6835888lfg.13;
        Wed, 21 Jul 2021 23:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=492xaH9XskXIclTeD22F++BxCoQwu3EAB4wNMkhV3+I=;
        b=UBf4kRx2uM7bZiE9TaM+KGMq00abCQsDBJ5ZR7AHeTFfw3d36MA3MhkdHw9DrgwPNh
         vh91KmBF3+AzO06S771Y9JfM6hjstKYeHbTPOdu0+u2GvWgW/3FO0ckqGHBcX2ADqSOS
         P8e7ZUchfJL1/bOt1rMhfsTe7nyWiR7D/xTkqaObVnDaY/idmu57nITJR5XbMN4fmZoT
         PnXPOPqnqCdW10OK8qC7Y3tWKu+qGjiX8jez90t7Y7wqz+bnbzOEQrlb9LKdxKs1AMmN
         QUtnrz7xGypyvJb67cKgJ17HtIEniV32pUOaFXhEWCjRgfOApuxFWeUKIRprJOElQUMU
         JUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=492xaH9XskXIclTeD22F++BxCoQwu3EAB4wNMkhV3+I=;
        b=cKZRVaZPBCsEEn3cwNDUd/AcBzi7aNMIBfBNOA8Y5kfNAWlE+MKnrco7aWd+asB4hY
         Y8CfsUDjAyNVWqML1/ojOBzdkJUiqAYfnTLIA1R8fY/yrp5vZw6InZZihlyPKsMa/mLc
         wPpeWT1kGtepT/dfkUftTl7uZjIBdhNXgc9bPHPzGKlyqU5K/wlmUw0zN1/BCxzx4o4j
         VAaOUdnpfjoZfSj1N9zLYeBIXtWiuWGWhfeuzN79IefesxMNt65/YEsL4M3vrYAQ4PZ8
         3mgocLvIgxp6sU8FyWaWRbD+Jd+J+Fx89FzAJJac4EbkLpJC2uXYkSdO5vDKMFkbYU8K
         nw4A==
X-Gm-Message-State: AOAM531eKUPF54GCUgaGVX+ja+6NDO6r5emwbnUKdBnoNmXOZ30T5zWO
        0j8qXMgxbr/reT07tfQShqXAnkDdrnRnLfSbNw==
X-Google-Smtp-Source: ABdhPJzEsGglyTKJ2RljA2HYhKjC4ug+v2N8YFrUjpEGlyyYnYP1l9K+f7G5w+r8ICP7FaInxusXSg==
X-Received: by 2002:ac2:44cc:: with SMTP id d12mr27963210lfm.264.1626936021062;
        Wed, 21 Jul 2021 23:40:21 -0700 (PDT)
Received: from localhost.localdomain (91-145-109-188.bb.dnainternet.fi. [91.145.109.188])
        by smtp.gmail.com with ESMTPSA id b24sm790695lfp.26.2021.07.21.23.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 23:40:20 -0700 (PDT)
From:   mika.penttila@gmail.com
To:     linux-kernel@vger.kernel.org
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, mingo@redhat.com,
        peterz@infradead.org, kvm@vger.kernel.org,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@gmail.com>
Subject: [PATCH] is_core_idle() is using a wrong variable
Date:   Thu, 22 Jul 2021 09:39:46 +0300
Message-Id: <20210722063946.28951-1-mika.penttila@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mika Penttilä <mika.penttila@gmail.com>

is_core_idle() was using a wrong variable in the loop test. Fix it.

Signed-off-by: Mika Penttilä <mika.penttila@gmail.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c452072a1b..30a6984a58f7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1486,7 +1486,7 @@ static inline bool is_core_idle(int cpu)
 		if (cpu == sibling)
 			continue;
 
-		if (!idle_cpu(cpu))
+		if (!idle_cpu(sibling))
 			return false;
 	}
 #endif
-- 
2.17.1

