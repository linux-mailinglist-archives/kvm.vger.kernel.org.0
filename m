Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF667B68FD
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjJCMai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjJCMah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:30:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A15783
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:30:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32003aae100so2573840f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336229; x=1696941029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7j+ZKjZU7k+0CzG1aKzjQAk8hMMCzbHPgv7YGTA/m4=;
        b=nZsJ9TkZZxPazdCsBMg0i8ptOKV2kRhgVD+ebHs9mErZy3piYuS4Wry8o7mSrGXX6L
         CWJ9HckOa2EW4gO/JKhONB3e48ytLO3Wlq+QrgWPy3ZUbe1DgDUaWPJ1FRwXWZJr0/Uw
         yc6oN4EiM/LOd1rx4SunOybbNECq88fSeJoZDDw5UZVbTGOrDWVVC0bubP7MhOQL7Ia2
         tf9062Ygp6P9fAbRJGHx9DoUw8sHuv8LsvkmcCyHACnJht5NiT5ug+cm+KtXS/pFgorR
         COBg0uEg1eH3d60HmHE6wi+mLdRFqvDmgG4heOuM1Smb4K9l9IVBW/YBbeIC9ESAQi85
         ZOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336229; x=1696941029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7j+ZKjZU7k+0CzG1aKzjQAk8hMMCzbHPgv7YGTA/m4=;
        b=inW+bUetBxIzOGTC8hipS6oBzkRf6nyy9C4dbX/IYPcMYjyGbBQXuzx1VCSlJQ22gG
         SSpKjuOoxwIkbSoROL4pamNfPv5OCTWwumQEo3/yTxFKb2yZsUNf3bpTpR/1TUHuXa20
         5UQgcdGd3VIK/YC1BzOZxG8bMYmDQdyYqgn2k09wsBjITNCeDjz5vN8xFTbUQw0CBkhf
         VmeLIhwRlelk6OthgEReKlQZ489DhTK95u0Tfgkf5PHowydl0kWk/oR1llv9UfS3PEDp
         tif+CNlWiBMBhDhJuVs6x0FBde+KsrRpuK2FVP4dJdBJ/UFKwKSpMd5le2vMqvBlHvhP
         xlig==
X-Gm-Message-State: AOJu0YyTHFXwpgcaTAgneqs8ux2gdG6a27Uzn+Xyp4ah2e3rKNL9Cwsz
        phDfiyAGiUFnyexPadrUpLKLFA==
X-Google-Smtp-Source: AGHT+IFBxMV4/1nchJeQ/YxQdQE65HU0cTcfcAYgMnGyWOki7FRja2chgmqsuZvdG1rMjy8dNfke8g==
X-Received: by 2002:adf:f3cd:0:b0:31f:fc9a:a03 with SMTP id g13-20020adff3cd000000b0031ffc9a0a03mr2082106wrp.20.1696336229468;
        Tue, 03 Oct 2023 05:30:29 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id n26-20020a1c721a000000b004063c9f68f2sm1186897wmc.26.2023.10.03.05.30.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:30:29 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 0/7] accel: Restrict tcg_exec_[un]realizefn() to TCG
Date:   Tue,  3 Oct 2023 14:30:18 +0200
Message-ID: <20231003123026.99229-1-philmd@linaro.org>
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

Since v1:
- Use 'target'/'common' in function names (Claudio)
- Added Claudio R-b tags

From v1:
- Add missing accel_cpu_common_unrealize()
- Add AccelClass::cpu_common_[un]realize handlers
- Use tcg_exec_[un]realizefn as AccelClass handlers

Philippe Mathieu-Daudé (7):
  accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
  accel: Rename AccelCPUClass::cpu_realizefn() -> cpu_target_realize()
  accel: Rename accel_cpu_realize() -> accel_cpu_common_realize()
  accel: Introduce accel_cpu_common_unrealize() stub
  accel: Declare AccelClass::cpu_common_[un]realize() handlers
  accel/tcg: Have tcg_exec_realizefn() return a boolean
  accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG

 accel/tcg/internal.h        |  3 +++
 include/exec/cpu-all.h      |  2 --
 include/hw/core/accel-cpu.h |  2 +-
 include/qemu/accel.h        | 12 ++++++++++--
 accel/accel-common.c        | 27 ++++++++++++++++++++++++---
 accel/tcg/cpu-exec.c        |  4 +++-
 accel/tcg/tcg-all.c         |  2 ++
 cpu.c                       | 13 +++----------
 target/i386/hvf/hvf-cpu.c   |  2 +-
 target/i386/kvm/kvm-cpu.c   |  4 ++--
 target/i386/tcg/tcg-cpu.c   |  2 +-
 11 files changed, 50 insertions(+), 23 deletions(-)

-- 
2.41.0

