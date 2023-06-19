Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28060734C7B
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFSHmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 03:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjFSHl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 03:41:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C8FF
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:41:57 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f8d258f203so23156255e9.1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687160516; x=1689752516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mSDEO3S7v0gqsjqb34kIccXlrtVfeECb8OYUdCmpYAc=;
        b=C+DZhtCqAjYyInswfiCXO6os7itVoRlQtPHPNTuHUsXeUrecgnnKFuAigEtuUjfY2Y
         Us69L8zlaDifbvn2R6d4twJfx1qD2DuHdvimmlLM+rwfV13IGTIYSk32upQhOL9YUDlX
         TQTVsi0uWfcVhQpKpe7O8vCiKJTXJwCyOv5UfaGONA1kU35uSm0ZKD7tXpRzco9WqWFp
         3voegU1DphnvgQe5ZBKIqhlWeAQWmZFbX7wMEVnOGWkmwmuYKLM5sIRsrc/WblJrh/Hg
         G1RqlDbOVyE6YVTrL/0K+mRyaiWY+wlWLN2cFMkhH+dTE7tfgMWlq/v2dVPHfoY0WJ1i
         f4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687160516; x=1689752516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSDEO3S7v0gqsjqb34kIccXlrtVfeECb8OYUdCmpYAc=;
        b=iiqRkMI2i+s0NRZcft4dVGgkrdmyGlci5q1x+PNCIgfPke1in1zC0AWLwoyyfUJcxS
         /ON8vGs8lvjPOeDWr4ha65w8iVeHT6mbnLRKSfkMZ2HYsmIk3k7Kd4jZu6LdXAkCf0IG
         uy0BxBKeqEHoKvsJihyKVagJCm2z4ktRjB0FY6F5w3EIWKPZET58yKl8W5M59PO1dh7d
         5TXAVVcjfBtOP3QJyK1n4hYHCZqhLaUcRbt3BglH/Hz5947TD9H+sRA6A5wx4adcO/Pf
         qJBN9GCqIYw9wh9cWQbxgrJzGRpjItT27aZ6bj/ib6RBtXNNB9FWngA9Mp1MRRsOKjPe
         7SJg==
X-Gm-Message-State: AC+VfDzZXzRoG04rJ4dKJjSKbuhQ+qdnFJTfTOAeX5oL15xlPhRXPe69
        BdX1wHPCYr4grU3nX3JatybXuQ==
X-Google-Smtp-Source: ACHHUZ7OFFSztmt/Tn6nEm987OMGHO8qAv1Qs+aHhKfRshCWC598pSvmv3evhLzMOz/cnCav+Afhbw==
X-Received: by 2002:a05:600c:203:b0:3f7:f24b:b2ed with SMTP id 3-20020a05600c020300b003f7f24bb2edmr6235870wmi.19.1687160516336;
        Mon, 19 Jun 2023 00:41:56 -0700 (PDT)
Received: from localhost.localdomain (194.red-95-127-33.staticip.rima-tde.net. [95.127.33.194])
        by smtp.gmail.com with ESMTPSA id c25-20020a05600c0ad900b003f18b942338sm9853169wmr.3.2023.06.19.00.41.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Jun 2023 00:41:55 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/4] exec: Header cleanups around memory.h/address-spaces.h
Date:   Mon, 19 Jun 2023 09:41:49 +0200
Message-Id: <20230619074153.44268-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trivial header cleanups extracted from bigger series.
Sending separately since somehow unrelated to its goal.

Philippe Mathieu-Daudé (4):
  hw/net/i82596: Include missing 'exec/address-spaces.h' header
  hw/dma/etraxfs: Include missing 'exec/memory.h' header
  exec/address-spaces.h: Remove unuseful 'exec/memory.h' include
  sysemu/kvm: Re-include "exec/memattrs.h" header

 include/exec/address-spaces.h | 2 --
 include/sysemu/kvm.h          | 1 +
 hw/dma/etraxfs_dma.c          | 1 +
 hw/net/i82596.c               | 1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.38.1

