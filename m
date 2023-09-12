Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63A979CFEB
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbjILLa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbjILLag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:30:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05D98
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:31 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9a63b2793ecso700274966b.2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694518230; x=1695123030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F/EKm1PmSvEC7rs4ZxmxgrW2WM6+iO3cGl9uzitMTBI=;
        b=fzJPTDNemPpuK51eIPbE10nBGpxgy+zLwCAcN5WUTlWaimQVSDmrVgFg1iThpr+xO5
         yXO/W8sM4+G6XqS5WyHH0dF2CGzHFYtMIZZZNG1CsuX8836g8Za0o5fPusEWu1LgynLp
         WIQFT2M4MHhVV6GR1U4WZQMvyAXTd/IDQ8gEyAL3L9PfBux6sc1pqMSUWJSgENA2zESl
         L3q4QWD+3i8cv9KRLgQHhQsciGPhnx0Efk6kOkgs4g+GlaFTapkHKdPEZvqR+viazpZS
         3CzionjsXg0UvktNTIH4R/2ntnPgUclr3W4wXtGAzawAKpXqML7m1PE7kn8X9iFRkWq/
         CsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518230; x=1695123030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/EKm1PmSvEC7rs4ZxmxgrW2WM6+iO3cGl9uzitMTBI=;
        b=V7LzSUk47BlzwlwgpQ2PMzBk9uVddvn8X2hJKmOIwvd2UFVqcfa5PSrAgyYJSpt0qe
         tWmF71xNyIYLVKgLu/qPAj33bckyu7W3yUpmy1l8oA6eKJViwR0vAlVKe8bjB6dDFSHa
         dmYLRAjOCl/tMT0IadXEg7pGo3Q2efUqOOBmhJIWH334lXJoSXFI2U8Sqmex7Gp1AtpD
         X8A9BPea2uUsVtBBIa7v1AFJlMkl71anerQTCp4all6WrD+nZyRfTYI83m+aRLlqE5BV
         N5zSlPp4fpoRFQFYkagTbLb/8WB7mhcrio8nX8UwRF5vKWH05oyrurc/puZ8986jNEp9
         tOsg==
X-Gm-Message-State: AOJu0YyCBCRnBajXNt+R/Ih8Bh9jqt5bsYMUBlgdk17LYLg9bVMRhCN5
        0ZusVjSHv93M0brycYkEfkiKCA==
X-Google-Smtp-Source: AGHT+IG8ZGVAtPAxgR7LQWZ2H5QWK9SxUmAMBPgezLz6rY0uT5RF0bLMGBo73IIHaakvdDTgoxb9xw==
X-Received: by 2002:a17:906:53c4:b0:9a5:c9a8:1816 with SMTP id p4-20020a17090653c400b009a5c9a81816mr10949917ejo.58.1694518230392;
        Tue, 12 Sep 2023 04:30:30 -0700 (PDT)
Received: from m1x-phil.lan (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id kj27-20020a170907765b00b0099b5a71b0bfsm6787085ejc.94.2023.09.12.04.30.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Sep 2023 04:30:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/4] target/ppc: Prohibit target specific KVM prototypes on user emulation
Date:   Tue, 12 Sep 2023 13:30:22 +0200
Message-ID: <20230912113027.63941-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement Kevin's suggestion to remove KVM declarations
for user emulation builds, so if KVM prototype are used
we directly get a compile failure.

Philippe Mathieu-Daudé (4):
  sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
  target/ppc: Restrict KVM objects to system emulation
  hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
  target/ppc: Prohibit target specific KVM prototypes on user emulation

 include/sysemu/kvm.h   |  1 -
 target/ppc/kvm_ppc.h   |  6 ++++++
 hw/ppc/e500.c          |  4 ++++
 target/ppc/kvm-stub.c  | 19 -------------------
 target/ppc/kvm.c       |  4 ++--
 target/ppc/meson.build |  2 +-
 6 files changed, 13 insertions(+), 23 deletions(-)
 delete mode 100644 target/ppc/kvm-stub.c

-- 
2.41.0

