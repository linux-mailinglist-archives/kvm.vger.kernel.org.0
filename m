Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86974662CE
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346631AbhLBL5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241672AbhLBL5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD69EC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:53:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a18so59169926wrn.6
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=assPRJZISp/N09x/XwLMYXECdxd+01DO7D0xsbG5ltw=;
        b=KOJZVynTFuG/6NOJXr2C4Vazs7n8HHWiJb78KKi6YLrt5Wi9b+schevcHXrG1rf73V
         RuHhI8pWw6nXqzZhTefRIjJSu5dcW/GT8BvyQhviuQHchvtniR+E9QqSQuYmy6RTYgPI
         lnNAb9VcYKBMBun9WuGm0pA8+rovBl0E5QL7CF3y68JGjie/63fYnCv/QcNJn1dma8aK
         BWvxRtwONYGuByLqp9txeW7NEJk4y32/6yFSPlQd6GefkczXizFNh0R4DaHPJQBx1XlH
         x5jBVrONLOn6RzTTlPvajcFVK/nw+ORyhx5S+QLv91Y6xfmYcoEc5kiWGXlPt3eq7S35
         k4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=assPRJZISp/N09x/XwLMYXECdxd+01DO7D0xsbG5ltw=;
        b=rlELVSwdH5ZK9o/u/QWNoBw5bbq2avcpWF3a/mTPZE5NG6ZBa26D6F3Z21M2kEOduH
         vY1OcGoEJBEntE5rpUFiNGvzwQPV44TsI8Isy+GbggMfX3/ewtYeVxOqssvduEB3+cUf
         biaS/O+/t+yPv+RXLryK3UuA8s87K6y2OhplOjicya/wt8yDMfPWIHG7Nfy4+SiOdQUa
         L4sd/52rIqSMiSvubMLdQdqE1fGGjjwISbpR4wwOm0mAkF2l9FIBHAzJ/9ydlUecRZQv
         D9YrBDD5nQcM9fV64OO/C3iFqd044Wammtd2PSOZrCC3CoB6+JFqENhyHsdeFe6pBqe0
         d99Q==
X-Gm-Message-State: AOAM531aVCsl2lUFil5NH8dHqV2QFb79cXz7HfbXANErZ1EbaTrKa3Qd
        TQf/BaB5zLkUsp2T+Z61b1qTNA==
X-Google-Smtp-Source: ABdhPJwwW+FHTijTO4l+Zd2NHkZo+99Xp3nRtXN0H2oqzfplC6cix6takcu1+C2dOWtuBhiGvbvR4g==
X-Received: by 2002:adf:97c2:: with SMTP id t2mr14007936wrb.577.1638446034298;
        Thu, 02 Dec 2021 03:53:54 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id f15sm2448073wmg.30.2021.12.02.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 72A0C1FF96;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Date:   Thu,  2 Dec 2021 11:53:43 +0000
Message-Id: <20211202115352.951548-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Not a great deal has changed from the last posting although I have
dropped the additional unittests.cfg in favour of setting "nodefault"
for the tests. Otherwise the clean-ups are mainly textual (removing
printfs, random newlines and cleaning up comments). As usual the
details are in the commits bellow the ---.

I've also tweaked .git/config so get_maintainer.pl should ensure
direct delivery of the patches ;-)

Alex Bennée (9):
  docs: mention checkpatch in the README
  arm/flat.lds: don't drop debug during link
  Makefile: add GNU global tags support
  lib: add isaac prng library from CCAN
  arm/tlbflush-code: TLB flush during code execution
  arm/locking-tests: add comprehensive locking test
  arm/barrier-litmus-tests: add simple mp and sal litmus tests
  arm/run: use separate --accel form
  arm/tcg-test: some basic TCG exercising tests

 arm/run                   |   4 +-
 Makefile                  |   5 +-
 arm/Makefile.arm          |   2 +
 arm/Makefile.arm64        |   2 +
 arm/Makefile.common       |   6 +-
 lib/arm/asm/barrier.h     |  19 ++
 lib/arm64/asm/barrier.h   |  50 +++++
 lib/prng.h                |  82 +++++++
 lib/prng.c                | 162 ++++++++++++++
 arm/flat.lds              |   1 -
 arm/tcg-test-asm.S        | 171 +++++++++++++++
 arm/tcg-test-asm64.S      | 170 ++++++++++++++
 arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
 arm/locking-test.c        | 322 +++++++++++++++++++++++++++
 arm/spinlock-test.c       |  87 --------
 arm/tcg-test.c            | 338 ++++++++++++++++++++++++++++
 arm/tlbflush-code.c       | 209 ++++++++++++++++++
 arm/unittests.cfg         | 170 ++++++++++++++
 README.md                 |   3 +
 19 files changed, 2161 insertions(+), 92 deletions(-)
 create mode 100644 lib/prng.h
 create mode 100644 lib/prng.c
 create mode 100644 arm/tcg-test-asm.S
 create mode 100644 arm/tcg-test-asm64.S
 create mode 100644 arm/barrier-litmus-test.c
 create mode 100644 arm/locking-test.c
 delete mode 100644 arm/spinlock-test.c
 create mode 100644 arm/tcg-test.c
 create mode 100644 arm/tlbflush-code.c

-- 
2.30.2

