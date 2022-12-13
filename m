Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4119764B53B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiLMMf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLMMfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:35:55 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DFE60EF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:35:54 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so7832402wms.4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=syOoJ6QfHbT1mHY1LElg19fus+7+qsrsI/XddduWUC8=;
        b=UXi1cOspPqeiEgmVJxV3WfL9DIpL6mXkrykjdbnvUZlOp2QQedqySUZ0WDcQQhewXn
         BWu9cWpuYp+0X5E/vWNxskY8GN0pE1vl7ELCIjn5tfbVRK4kxzb3r6g+SYrOa9t40zoa
         16CRd6K/DKv5R9NU+GK5A6mPk0yVImGxpVlhMD/ci8sgELdEcI8XBNGIqWuPnC+hnbtK
         iQP8IFW7PjDpIJT8kIBpwcLOuAIu3f3qP2JjGV9F3ngGkShhT2ENlen3G5C3AjKHfmO1
         JveXORRKF4Rgp406B+fv8I5VH0PL4LbUJXfC/JA/j7wNjfCHAOHDvWzK25QoGBqToSSZ
         xecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syOoJ6QfHbT1mHY1LElg19fus+7+qsrsI/XddduWUC8=;
        b=M07cAFuRMqllCOvzm9BlMEjLvIocRy25J6cA+0npfSdKV96B+UpvsIBqcxFRWBZO4S
         WN9OFeeP1Wwahlz4AtcMpRTKe4o2Fwu1qfkFdCdL7oGnK7XZcEEY6K1IH+DxkTb0ZLL0
         3Ofy8zJabr0so2rb2iJ1U/5eyc82VbFulnq8Gkj/Z/DhrUAEWhclsvOvhstycBImK9zz
         gkgwXhJEij9O5aadfH5JPnrX4G7L/yMqtH34oUjmpWUIRULD9ClagPP40UUkstcWDqMQ
         hYEqDkk2M6r6bB6gH34onMcB9I3HScDSvoWjBtap+apuZo+wL8WC+vCnAJ+k2ssr9I8n
         6tQg==
X-Gm-Message-State: ANoB5pkqMyTQQhOio4GbSHhmvBLerCNSg4L1MIBMmGO/EV3FMzIj8gAt
        xmVb1MbGMYo7LXosCX9oRT0jtg==
X-Google-Smtp-Source: AA0mqf6uF7F2Yuvg1b+t3XcONjrA6f9qOWU2/EU379zo/5X0RMjBNgXzCNjsLb2kAv/PAjiX4pX2rA==
X-Received: by 2002:a05:600c:805:b0:3d1:ebdf:d592 with SMTP id k5-20020a05600c080500b003d1ebdfd592mr15090720wmp.22.1670934953371;
        Tue, 13 Dec 2022 04:35:53 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003c71358a42dsm17514329wmq.18.2022.12.13.04.35.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Dec 2022 04:35:52 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 0/4] ppc: Clean up few headers to make them target agnostic
Date:   Tue, 13 Dec 2022 13:35:46 +0100
Message-Id: <20221213123550.39302-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Few changes in hw/ & target/ to reduce the target specificity
of some sPAPR headers.

Philippe Mathieu-Daudé (4):
  target/ppc/kvm: Add missing "cpu.h" and "exec/hwaddr.h"
  hw/ppc/vof: Do not include the full "cpu.h"
  hw/ppc/spapr: Reduce "vof.h" inclusion
  hw/ppc/spapr_ovec: Avoid target_ulong spapr_ovec_parse_vector()

 hw/ppc/spapr.c              | 1 +
 hw/ppc/spapr_ovec.c         | 3 ++-
 include/hw/ppc/spapr.h      | 3 ++-
 include/hw/ppc/spapr_ovec.h | 4 ++--
 include/hw/ppc/vof.h        | 2 +-
 target/ppc/kvm_ppc.h        | 3 +++
 6 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.38.1

