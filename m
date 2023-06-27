Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98F73FB61
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjF0Lve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjF0Lvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:51:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A46510D
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so5815035a12.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866688; x=1690458688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qPtl76CipHVizf8iARQn4UaHNN6Q85+7HKGDlYZi6lk=;
        b=IHXdv9VH6AeXO0m39eVCHQOX+VJnJPytveSYJdymBKX+NaBmcva/dMtq9RXkcD9J1q
         Vjc29PPtva3lGclZMGpXay+GlQhObuQH9NeWFz4wIh3Mh2swBwuI4R5smZmO7jJ8VxHv
         a/rqCsobN6UKbX8EehPtOrH4u/MwhaxKLyJFHAigdJCAMJ1mZxPhnKk9tKCNpyy/Uz4e
         HnNTksYKRATrsN9Yo3vvOLRG4+aoIBlnI7cqslpx52YlAOrZOZ/DuiryRnhmnU14ewnj
         pbLiYbuV2J9O7Lqxhy3+ZEONYwQU65Drt0OupnBvKPKecGXSTDLxbipim3FIw17YCJ3e
         4tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866688; x=1690458688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qPtl76CipHVizf8iARQn4UaHNN6Q85+7HKGDlYZi6lk=;
        b=VWZCf+1b7xQFMp+dc7jsOaehAr6/xjiy06+ll841VkO0JWpV6W8r3+1qXNoKxTA9dC
         oOSIVlNI3eGj7dqbTxkJVrO/Fd9WuqiqsZKjOtMIX76fJdaVQe3G5sjpE4C6pXf6jCt/
         ShGI4pMD0POaIdcjOFFj/deLrwXlxxLPkYZ9/mHg5gmwwnLWrD2hiZFsjV3L2eOkHINP
         oRShAP0GLZRNKztZfEeI9/ZGdTRDbSX57K8hCaOkhvqCrTL7S8NM0pFcHnb+yYelseQB
         P/E5KGhmZd2R4y+Q92vMtyuLZ33HjTcyLf7CG9LvubCENlcaLG3AViOLBvJ66XFUz0Q6
         r2bA==
X-Gm-Message-State: AC+VfDzy9DVqVuUs4/Vqv2ooKxpK7yv+ZI7SU6XosQRab/OwZeBWjo5i
        DJQspqZ83wXnj/D5oDdIQqi4OQ==
X-Google-Smtp-Source: ACHHUZ4bhSYl2ChCkrhZi7oo7PTKNdL5gy6/V5UrWzFh8sqg1GlhRG4M0JvVQV64c45Y6wiDFouwKw==
X-Received: by 2002:a50:ed06:0:b0:51d:902a:63c3 with SMTP id j6-20020a50ed06000000b0051d902a63c3mr6298243eds.34.1687866687711;
        Tue, 27 Jun 2023 04:51:27 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id z24-20020aa7cf98000000b0051bfcd3c4desm3676022edx.19.2023.06.27.04.51.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:27 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 0/6] target/ppc: Few cleanups in kvm_ppc.h
Date:   Tue, 27 Jun 2023 13:51:18 +0200
Message-Id: <20230627115124.19632-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PPC specific changes of a bigger KVM cleanup, remove "kvm_ppc.h"
from user emulation. Mostly trivial IMO.

Philippe Mathieu-Daudé (6):
  target/ppc: Have 'kvm_ppc.h' include 'sysemu/kvm.h'
  target/ppc: Reorder #ifdef'ry in kvm_ppc.h
  target/ppc: Move CPU QOM definitions to cpu-qom.h
  target/ppc: Define TYPE_HOST_POWERPC_CPU in cpu-qom.h
  target/ppc: Restrict 'kvm_ppc.h' to sysemu in cpu_init.c
  target/ppc: Remove pointless checks of CONFIG_USER_ONLY in 'kvm_ppc.h'

 target/ppc/cpu-qom.h  |  7 +++++
 target/ppc/cpu.h      |  6 ----
 target/ppc/kvm_ppc.h  | 70 ++++++++++++++++++-------------------------
 target/ppc/cpu_init.c |  2 +-
 4 files changed, 37 insertions(+), 48 deletions(-)

-- 
2.38.1

