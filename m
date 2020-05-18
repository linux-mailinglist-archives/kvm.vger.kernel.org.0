Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11C41D7D6B
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgERPxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgERPxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27674C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:11 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z72so32623wmc.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W0NZH996mfqrH/xeDmImG2NwLarasbVlVoAElHsd8sQ=;
        b=tLXmLd86dVALrDyfRBSDM7xGyBzx8PJJWlY3i38vW6q9/Pq2n5mt3ItbF9uZKtViWL
         5wjAhT45r111vXSVIQUuwkb/+pC4BmSqWADibN6q3Locg2JVINUoZqSROZBnySBdcKu2
         o7icrgMjNdj41GvG+1h7CXICRijZyk9PCqmL73xjibtIUlwr5m8fU954ESI+FigCiT6C
         bs8ilZH4spkBeWmS9qFncwqfwwrAdAuMAk77e2TsE5z07YnW6/jjk8LqIzgX5aLh8Lf3
         32nm7cFpyxPY9VYf1Y8EuTeXM0FeWyXQRN+cYia6fpPx0obBb5QsL6e2VcrOwfrxbO5A
         rQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=W0NZH996mfqrH/xeDmImG2NwLarasbVlVoAElHsd8sQ=;
        b=cGNwaBONmF5FoTP5BpAY+ejnKL2dS3XoL/4EtY6D6qS1Zv7V3+mjW9cqceupD1TH0V
         sx13L+WxrO22b1KFkfyxb4zk/nc4Qtz6PvfTMqkM+rmT2fbpu5WBSrD75rUFzbXZxTrB
         Bo+vh1fyKkgqd44BBNELyZp282ZKuSs4Fjruf9/7IQGmo5cfx2nhKVpOcH59p9ZROYFC
         I/IbMeUOZiCR/naENPIy7GqDlckAxVyufPPkn+by06xZcV6skmIcM9NE5YZM9IkdNH2U
         KCqdKVZyz2s/Znf6YUMWdp5kurQqfNMRc83zDY/QIVW5Z1p8zOxlKUZytNYgaBVsVGw2
         +Dkw==
X-Gm-Message-State: AOAM530y64jPTVePt80POMU6WLkews+pAaa2mB033blNX8GApjvWbKhS
        O3H/W6dmLwyGI10bocDEbEI=
X-Google-Smtp-Source: ABdhPJwFfUufdYrC8E/cFB2xycdYjZB2Yu69MdjITV5JZ/mrnUeCukTsqIzH1kqKOnPbmTGUwxINOQ==
X-Received: by 2002:a7b:c948:: with SMTP id i8mr41508wml.138.1589817189954;
        Mon, 18 May 2020 08:53:09 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:09 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 0/7] exec/memory: Enforce checking MemTxResult values
Date:   Mon, 18 May 2020 17:53:01 +0200
Message-Id: <20200518155308.15851-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Various places ignore the MemTxResult indicator of
transaction failed. Fix the easy places.
The rest are the DMA devices, which require deeper
analysis.

Since v1:
- Dropped "exec/memory: Emit warning when MemTxResult is ignored"
  https://www.mail-archive.com/qemu-devel@nongnu.org/msg704180.html

Philippe Mathieu-Daudé (7):
  exec: Let address_space_read/write_cached() propagate MemTxResult
  exec: Propagate cpu_memory_rw_debug() error
  disas: Let disas::read_memory() handler return EIO on error
  hw/elf_ops: Do not ignore write failures when loading ELF
  hw/arm/boot: Abort if set_kernel_args() fails
  accel/kvm: Let KVM_EXIT_MMIO return error
  hw/core/loader: Assert loading ROM regions succeeds at reset

 include/exec/cpu-all.h |  1 +
 include/exec/memory.h  | 19 +++++++++++--------
 include/hw/elf_ops.h   | 11 ++++++++---
 accel/kvm/kvm-all.c    | 13 +++++++------
 disas.c                | 13 ++++++++-----
 exec.c                 | 28 ++++++++++++++++------------
 hw/arm/boot.c          | 19 +++++++++++++------
 hw/core/loader.c       |  8 ++++++--
 8 files changed, 70 insertions(+), 42 deletions(-)

-- 
2.21.3

