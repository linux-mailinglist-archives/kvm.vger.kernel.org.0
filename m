Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9491127DC38
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgI2WoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728930AbgI2WoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dR9Nk0eM9jSf6djV760qyeufq0GIQie0fmgNB3aO7w=;
        b=PTlzYPKcstPxoAuB3OFhmY47tSSFDviIPSAgnL7JEm0iCBkHG5Uf7frh2bJBwaznaoY/f7
        52HmfU8abVO6PgdGFSSQBZGyNbIdbkDDz5TnMuM0RMi4B0BkcX+3ArUfb2ddAczQ2WNZMU
        3APiHm9r+JvDeShqYgoXJVYMPNPYnqM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-Q_fXLT1aPjWxvUQXVVSurA-1; Tue, 29 Sep 2020 18:44:19 -0400
X-MC-Unique: Q_fXLT1aPjWxvUQXVVSurA-1
Received: by mail-wm1-f70.google.com with SMTP id r83so1991729wma.8
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9dR9Nk0eM9jSf6djV760qyeufq0GIQie0fmgNB3aO7w=;
        b=umao2M7Qbth3mjpr1Gn2jJV6JcFP0R7U57NHqbyzLgIi7B/tYsNwhbudMq0ehFQEYU
         vA4ZJqjGzUFK2Wy8LGTkU76U6VymZRn5F3fPhw0ZTTbFOAI9Ye046XdUj24UXodlWlr3
         8fwMigt2QzoIOm40yeAcodv0bpRKqTqDaEbdobsULBQd282TyGP1nkUdAiZzAM+775mw
         5e0aBR3k7F5Ru+KhdOZZ7qBIVzDB3/whDUzg6LNEkFFQ6sytyCY7/175GH+nWvQCHIMm
         /lokBLu67pJVPA5vsj65uU1Nrn6hiqC8yAgO8TaFeQUi0AIOBnPzNqVzUsk72z1GcvWw
         aSig==
X-Gm-Message-State: AOAM530YdYDuCT389sCUvnmI/PDyDJ3o4necWoEwUoz/77jXAuO0hcuI
        sAuY3I4uUUzSR106IoBeKVul2Xq6ITE3NiLZHIP5cYpUMpreihavRjD2AeDyqTC4LZoCgw+25nq
        WbN3ZBovYPfwj
X-Received: by 2002:adf:fd01:: with SMTP id e1mr6312398wrr.44.1601419458523;
        Tue, 29 Sep 2020 15:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwh51NEq7twr61W/5e9Rg5U9losDLPsHpgTL0nTFBNwMoNiIws2/CzkKqcV0aZDFoO9xffGw==
X-Received: by 2002:adf:fd01:: with SMTP id e1mr6312389wrr.44.1601419458354;
        Tue, 29 Sep 2020 15:44:18 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id y1sm7440740wmi.36.2020.09.29.15.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:17 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 04/12] target/arm: Restrict ARMv4 cpus to TCG accel
Date:   Wed, 30 Sep 2020 00:43:47 +0200
Message-Id: <20200929224355.1224017-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a cpu based on (at least) the ARMv7 architecture.

Only enable the following ARMv4 CPUs when TCG is available:

  - StrongARM (SA1100/1110)
  - OMAP1510 (TI925T)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 7d040827af..b546b20654 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -1,3 +1,7 @@
+config ARM_V4
+    bool
+    select TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -30,6 +34,7 @@ config ARM_VIRT
 
 config CHEETAH
     bool
+    select ARM_V4
     select OMAP
     select TSC210X
 
@@ -244,6 +249,7 @@ config COLLIE
 
 config SX1
     bool
+    select ARM_V4
     select OMAP
 
 config VERSATILE
-- 
2.26.2

