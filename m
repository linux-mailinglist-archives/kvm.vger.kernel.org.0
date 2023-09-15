Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C627A26C8
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbjIOTAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjIOTAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:00:19 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E95AF
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:13 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-52c88a03f99so2822614a12.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804412; x=1695409212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Debqhd1KkXYkBU83fGVykCcugVwbCT/5D+O9otxBzPI=;
        b=DwCdT3BP4t2rlTLZE4Guf8262aLrG26NKHkfRaB//BicvBhO+7HR0/ocZvuvtno9r/
         A1lepNcvZ796iGKLV2l+b63wXMipQJZ9sh87zgZiPrTv9H8m0dVMMZG246Hfll9dwA/z
         2S2BN3MWWyqk9lRuAC8LRjmTmyfwtiRiSItKw3GUGH5vapdSXxCeicxwnHIZYM3KdTSR
         J3Gb5EAfnGpTf1A+JBkXYg2R1TM7up6wuK8W+P5VZUh20BK8kpZqHVUwb4rgIkJotLXi
         J70Qm0HoOUS/fSn2oLBA4kFFXcCidBCL3zLPQxy6FwKXiY3BtcQHB4lHBarZu6g5T7cZ
         HSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804412; x=1695409212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Debqhd1KkXYkBU83fGVykCcugVwbCT/5D+O9otxBzPI=;
        b=KiqmgIDhEMBApwKcEght3/ORdkG6BMknMWGBi53g5f8+ulbSPH9kKMLwgtdpsz88zR
         XcH3Poz7nrLoFYG1b61KSY9PsQ9de+l85VeoKA4/AQNpul93vPfTi9766CIJvQua3j/U
         7nTqBs84USbq2bnfW9mdHlmhQa0NOIWbQJkW2zq+tUAZmwQx4wiDT87VIsaQDNHJx+/u
         D6UAhI+Zq2l+ZIwoGw6VpIEgcHIq5oU8wYDuN3WO+RWZ6Jq6vT9xVrole+Y+wezS7t4a
         F1QQU8vQmArPoGqTMBZi0UucdJbt9GAN3lFZ39bawQQnIbxvmnxtQ8q4wa155aTdbZOR
         9FUQ==
X-Gm-Message-State: AOJu0YzVLq6pIZX+us7XWuOmNneRiLCNNcbQTxjd2a1vg3GTENmEG08Z
        Llnux+Sv3uR53cGOzbAoHkP7FQ==
X-Google-Smtp-Source: AGHT+IGt5AzYFdBLKwH4Y9IdNxzFm3HVuqcd7U4qlrCx0cG68aiVuPLcb9/hAMghxoQnz/mu3JWZNw==
X-Received: by 2002:a17:906:51cc:b0:99e:1358:ffdf with SMTP id v12-20020a17090651cc00b0099e1358ffdfmr1851110ejk.72.1694804412476;
        Fri, 15 Sep 2023 12:00:12 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id rp9-20020a170906d96900b0099e05fb8f95sm2760571ejb.137.2023.09.15.12.00.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:12 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH 0/5] accel: Restrict tcg_exec_[un]realizefn() to TCG
Date:   Fri, 15 Sep 2023 21:00:03 +0200
Message-ID: <20230915190009.68404-1-philmd@linaro.org>
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

- Add missing accel_cpu_unrealize()
- Add AccelClass::[un]realize_cpu handlers
- Use tcg_exec_[un]realizefn as AccelClass handlers

Philippe Mathieu-Daudé (5):
  accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
  accel: Introduce accel_cpu_unrealize() stub
  accel: Declare AccelClass::[un]realize_cpu() handlers
  accel/tcg: Have tcg_exec_realizefn() return a boolean
  accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG

 accel/tcg/internal.h      |  3 +++
 include/exec/cpu-all.h    |  2 --
 include/qemu/accel.h      | 12 ++++++++++--
 accel/accel-common.c      | 27 ++++++++++++++++++++++++---
 accel/tcg/cpu-exec.c      |  4 +++-
 accel/tcg/tcg-all.c       |  2 ++
 cpu.c                     | 13 +++----------
 target/i386/kvm/kvm-cpu.c |  2 +-
 8 files changed, 46 insertions(+), 19 deletions(-)

-- 
2.41.0

