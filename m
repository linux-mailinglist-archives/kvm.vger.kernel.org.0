Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1ED79C10D
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjILAFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 20:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjILAFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 20:05:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5087165047
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 17:01:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9a9d82d73f9so620771866b.3
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 17:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694476827; x=1695081627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+i6b3bA3Rg0SUcnPH4Ss1gYaJoTqAir2E8b0QJQ/x7A=;
        b=HOIt5HL6nCCwsSRi7ElAmMmSOLxQ/cK8j1AwQNIkX77peesBkOP/4mDX5cqu91dfeN
         Cc0u5iQxBr4MN9jv7FfkX7nCBPOUXLYR2R5fZ3g3s9OW4SaTg58jci882RWSFZUTWEWD
         PH2s48Gd91zGwYd2A3PFsIvJbSkrfj24tDOxRgGn6UwEpKf0JqyM9ErHr1mpMmFlJXiD
         5qrXLAkncm6ftouPRERMRA4jIt8D+UDI853KrOMDPEEIxQ1E36c4er9CoSmPODDIJi4h
         yc+ObqyVqv1of2r/O2UGZbQaVm4/ax7YRQotcM56DWUwBNtnSnYlvI/PETraLAvcbyAO
         K2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694476827; x=1695081627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+i6b3bA3Rg0SUcnPH4Ss1gYaJoTqAir2E8b0QJQ/x7A=;
        b=m0X9iIXEjmL1iIlTZJvxVfNLvbUt/fDmqIPHFRTyHih3YMUJA+YPpkCxeV/VQCFUax
         rktTJj2by/8FiGnMvY1ysC8DV1QXxJGw9vItu00a67Rj6Luf1Py4bRta5WbgvHhZIMYb
         5nXVElDM7ZKd067FZM21nB5LCU6g2HNP+WnL42Upe6QaJQGWSmz8s9aYO/PWU2nUB63x
         5jcZHeiebm7IXhZrTpCv7CY993Fi9wuAcerrhzlg5DT3AjDWbN+npJuwz+8F2n9uSKyK
         lvOyaS18LyGler+UJrfnI0+zatbygsUoZV7MMxPLpO9TDCWILiD3E1UqcPsTP4rklbCK
         pvlw==
X-Gm-Message-State: AOJu0YyK7FlyGJiueEgsVPBc1I50Zw7CbYm8iPjJuc52i1qwqtlItcqt
        6UYiM7HJfgwWzfCfKzY8xwXj1ZrhRxR4O4RDcK8=
X-Google-Smtp-Source: AGHT+IElUDIPmZ/cuW0+paD+bclrhVYiKji+qUy1+WUV9TZqVwtCVc8ugnSPJ1h1PnaIoN52qjgbcg==
X-Received: by 2002:a17:907:7804:b0:9a1:aa7b:482e with SMTP id la4-20020a170907780400b009a1aa7b482emr8911335ejc.26.1694466801049;
        Mon, 11 Sep 2023 14:13:21 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id n16-20020a170906379000b009930308425csm5884542ejc.31.2023.09.11.14.13.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 14:13:20 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 0/3] target/i386: Restrict system-specific features from user emulation
Date:   Mon, 11 Sep 2023 23:13:14 +0200
Message-ID: <20230911211317.28773-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Too many system-specific code (and in particular KVM related)
is pulled in user-only build. This led to adding unjustified
stubs as kludge to unagressive linker non-optimizations.

This series restrict x86 system-specific features to sysemu,
so we don't require any stub, and remove all x86 KVM declarations
from user emulation code (to trigger compile failure instead of
link one).

Philippe Mathieu-Daudé (3):
  target/i386: Check kvm_hyperv_expand_features() return value
  RFC target/i386: Restrict system-specific features from user emulation
  target/i386: Prohibit target specific KVM prototypes on user emulation

 target/i386/kvm/kvm_i386.h |  4 +++
 target/i386/cpu.c          | 58 +++++++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 7 deletions(-)

-- 
2.41.0

