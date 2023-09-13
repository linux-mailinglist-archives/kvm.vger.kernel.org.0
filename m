Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F4579E3B7
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbjIMJaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjIMJaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:18 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97F410DD
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40037db2fe7so70553295e9.0
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597413; x=1695202213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4qxkgGgN7faOXKmv92A0D3/Cys8KYdliP7Nf1fMSPZI=;
        b=PkYc/c8kuJleLkPK4a8owyZP+yk12dn5l8FaMpkJMdSNXcjLPDj4K52zArXJ8gIP0n
         U3pnk0vck0uOEsm6h/IhKou+txigx494Q3Z5fsK2Qn4ZrmkqZ7yq09FcJJyj5J4AhBgg
         dWxMZZIJzrLV4ehSNRhmkMDxjux6RGwG6JnGc12EQ0kGpJkOdQpIi34Ix1i05tNXkAoR
         T/F5qCL4ekXSz4q9I5QPXiWMSejMmKvOXXZc6ekrVVj3/8wEs543VjBqjhBt069hmPgO
         H+layTS5LjFeYOaOOOqqnb8+ogiIuR6amJk92+6mdSJL7Ah5F7CoIYD/mwMItutyiEtM
         8oGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597413; x=1695202213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qxkgGgN7faOXKmv92A0D3/Cys8KYdliP7Nf1fMSPZI=;
        b=HmW2u6coljuMwXnHfWP1IPsR6H74Zz6zgpEIlH76kLnnl52QNl5pv1LQ/Iqyf726yd
         RnCxpYTLwdk29E7R9HtgdvZVZjFBlRIHNEgf0F0OXWV8WzCYZOCsohtH1ZIvRn52VOBd
         N9RIW7jG1Ar87cym5v1DaFb+Nw1TQJRICbHMNdTDM37iyeUcivI76Uqojcfmbhc7gTYR
         zh6/hHKMzqGWzCiiEeouggGP0Q7sbnpL3axY2I9TbPqaVefm5lxtL8ikShdGqCSA0zMA
         t3wHrBv8pjvlewDltPat4BkIf0swIZeHpjtB/OwUMz4rr56esx2bL2D+LOYbYIwyZaeV
         j/4w==
X-Gm-Message-State: AOJu0YxL928HlcwF6eiBR2EgMmi8u6fnD4v8b5G057+U5Lt/NlxjIUbj
        9xfOdZxV4CsteatIfB8DnGRh/Q==
X-Google-Smtp-Source: AGHT+IFdvAnXbnEFzecAcazXAeZzxQQvSu94Se4MZ8q+TyFfDDe+tqUEFZwkuPCkYwiCViDvQH4sIw==
X-Received: by 2002:a05:600c:2804:b0:401:c1e2:f754 with SMTP id m4-20020a05600c280400b00401c1e2f754mr1572952wmb.21.1694597412975;
        Wed, 13 Sep 2023 02:30:12 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c294c00b003ff3b964a9asm1480345wmd.39.2023.09.13.02.30.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:12 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 0/6] target/i386: Restrict system-specific features from user emulation
Date:   Wed, 13 Sep 2023 11:30:02 +0200
Message-ID: <20230913093009.83520-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since v4:
- Addressed Paolo's suggestions (clearly better)

Too many system-specific code (and in particular KVM related)
is pulled in user-only build. This led to adding unjustified
stubs as kludge to unagressive linker non-optimizations.

This series restrict x86 system-specific features to sysemu,
so we don't require any stub, and remove all x86 KVM declarations
from user emulation code (to trigger compile failure instead of
link one).

Philippe Mathieu-Daudé (6):
  target/i386: Check kvm_hyperv_expand_features() return value
  target/i386: Drop accel_uses_host_cpuid before
    x86_cpu_get_supported_cpuid
  target/i386: Call accel-agnostic x86_cpu_get_supported_cpuid()
  target/i386: Move x86_cpu_get_migratable_flags() around
  RFC target/i386: Restrict system-specific code from user emulation
  target/i386: Prohibit target specific KVM prototypes on user emulation

 target/i386/kvm/kvm_i386.h |   4 ++
 target/i386/cpu.c          | 134 +++++++++++++++++++++++--------------
 2 files changed, 88 insertions(+), 50 deletions(-)

-- 
2.41.0

