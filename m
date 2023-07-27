Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D999B7648F2
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjG0Hjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjG0Hjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:39:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347959C
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-686bc261111so524142b3a.3
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690443104; x=1691047904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XNojA4zMzd30qUIFHT5IxiLGg6u2c9ZAs/+vQaBH6fU=;
        b=LhjJaoFIO3msBLNQYeOszTGi+0keE5rszVhxOFnadyd7/NHtSVHXCLuhR4RKxJUJnI
         5TtMvuKGi/nZLKJKkiXtlNS7euW6Ort7K+6sPSwUIg98N9b0Im+psTxghbHI9ND0hIAi
         OaOjQO4p79GnpVwb//4G/AKxayCkpCudZkY1Kx2ZhWTjWFEpIHZtTb1TofH4ln59wiir
         GlQDunLexjW1adklQSpJmWkopkq9XfwGesFVuKbKhKtNENy11UirUdUGylQZ68Bqr+5W
         aaH05c3B63s1qqdzQ1MJlP+vTeaZqhyLan5L2++ke3wwrnAS4rshT49GM8LMtWxtL7Hd
         PKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443104; x=1691047904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNojA4zMzd30qUIFHT5IxiLGg6u2c9ZAs/+vQaBH6fU=;
        b=ieZVSNq/IFskLIzzeBo3qk87Ptj4UtFz02AnEatC3SfyzNLOXwleiIVjynrMDiWfoe
         Dyt9b+xw6LknwvbI200uAJCxCkwDxTjOhLRK+wO7Q8EDqvJvoHto01M1/GkEetv4a2jb
         OmT5HfKazgtyswPmuQf6sc8cbAQKQaAzcshyrBBljsH14aQWy5ayoHtjowbCbFYCu9al
         iNzy0AiMrQGL2cvZjm9lU/aEqqpO2Y+5zml2yDCxjNgXnfsgy8AmJjdXaHfAFxbBaFAu
         0zd8J8i6oqwhSZ1JkUaEnBAgxkMS41Wt8mfn2nSVNs66b5eq8TwCrUiUmX7c6d3Eta47
         f8hw==
X-Gm-Message-State: ABy/qLbxg26YDY2/TTX0q+OuK27rxEeXwF2GvNZis+h9b5cNm332Au2f
        wQzRnsAlBA0saJid4V9fltVi8Q==
X-Google-Smtp-Source: APBJJlGr1mGBX50eU/zNqYdAc7dzLGhkxLnfOcLJuIXfrTZJjIQVNAA7VVv29xDe12znB1fcScLamw==
X-Received: by 2002:a05:6a00:808:b0:686:b94a:3879 with SMTP id m8-20020a056a00080800b00686b94a3879mr4859980pfk.18.1690443104613;
        Thu, 27 Jul 2023 00:31:44 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78689000000b0064fa2fdfa9esm802002pfo.81.2023.07.27.00.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:31:44 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 0/6] accel/kvm: Specify default IPA size for arm64
Date:   Thu, 27 Jul 2023 16:31:25 +0900
Message-ID: <20230727073134.134102-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some Arm systems such as Apple Silicon Macs have IPA size smaller than the
default used by KVM. Introduce our own default IPA size that fits on such a
system.

When reviewing this series, Philippe Mathieu-Daudé found the error handling
around KVM type decision logic is flawed so I added a few patches for fixing
the error handling path.

V4 -> V5: Fixed KVM type error handling
V3 -> V4: Removed an inclusion of kvm_mips.h that is no longer needed.
V2 -> V3: Changed to use the maximum IPA size as the default.
V1 -> V2: Introduced an arch hook

Akihiko Odaki (6):
  kvm: Introduce kvm_arch_get_default_type hook
  accel/kvm: Specify default IPA size for arm64
  mips: Report an error when KVM_VM_MIPS_VZ is unavailable
  accel/kvm: Use negative KVM type for error propagation
  accel/kvm: Free as when an error occurred
  accel/kvm: Make kvm_dirty_ring_reaper_init() void

 include/sysemu/kvm.h     |  2 ++
 target/mips/kvm_mips.h   |  9 ---------
 accel/kvm/kvm-all.c      | 19 +++++++++++--------
 hw/arm/virt.c            |  2 +-
 hw/mips/loongson3_virt.c |  2 --
 hw/ppc/spapr.c           |  2 +-
 target/arm/kvm.c         |  7 +++++++
 target/i386/kvm/kvm.c    |  5 +++++
 target/mips/kvm.c        |  3 ++-
 target/ppc/kvm.c         |  5 +++++
 target/riscv/kvm.c       |  5 +++++
 target/s390x/kvm/kvm.c   |  5 +++++
 12 files changed, 44 insertions(+), 22 deletions(-)

-- 
2.41.0

