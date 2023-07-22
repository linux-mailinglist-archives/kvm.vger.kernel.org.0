Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE5675DA4D
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 08:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjGVGXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 02:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjGVGXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 02:23:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02FE134
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 23:23:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb1baf55f5so20222075ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 23:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690006986; x=1690611786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uuareea16HQjMJsl+LvKjlyyFX1fn+ZlqEjqWc7cml4=;
        b=EC1oU8Yu2wRJhZcFevDVdPLBXG4inVW40ssVbOpdONYFCvMlvVdHzj5qbZCVgVq14T
         9X52X9j4beDJD8lPkfk++4pR6h8bWyLgHrIYXAkmWEL91U3YtkMyFOq1sKf45UDK0W4+
         lSeWBn0HbWxKEPGyje0yh0EXUWGlbzMYH+p7wg3AdkbX6vzNpAQOv189IEZg1TZhYitW
         Yyn3f9A6onfkDJsplxRFmoLbtGQ12zCyN2jzgVRnY3+JRzJdSANKWN7KZjQT27nvnf6W
         48z7KA73hrbj3eXVx341gvEtkriuREWm+Sbe1fwryxLaVJ/tJiW42FnDFb5QHE+hSmnf
         H14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690006986; x=1690611786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uuareea16HQjMJsl+LvKjlyyFX1fn+ZlqEjqWc7cml4=;
        b=TFMDpztMcy3HFA9cIzMyVgyeW8R71uOjIBKKVyijvhbQWaSHp8sBU1B4y4DA/ner5O
         FrNgy4eT6aKkUzffyP47iIOldA7r9ewjtSAYoyycABi77YiVh7lLueMIPkiEin3n/pqJ
         gLidwcSQqI3K8OLtC6h/x2t+c39hz5SzrQqwbh6R3gD3a7zZ4Ih1dQJI4uLNyIKgV1pi
         GXGvc9V5yI64g/McmHyko9QFiVCNKoV4gygQ7znU4C9OsQ/70+LSPu49kwHY5rEmQjcL
         9cZllEv1J0q5VBg+JTQ/Jpokpl2YQ01YGscRX3siZ3WBU3VJemMVlXyQ5uOYFOX//FxM
         m8+A==
X-Gm-Message-State: ABy/qLb6Mwlxy6t5DkWq5UAG8HPS++/zmDWdHBwkSv2Lw0ETTIgMe8t/
        RxgaVz8q/qB+KUupK7LcX0o5Xg==
X-Google-Smtp-Source: APBJJlHaygqCOX/TEsYaiU+Jb25W0sMz8LjEUud+ltKrnHN0R4tiaRK9AUXngdBD6OM5N/rnZ/bBiQ==
X-Received: by 2002:a17:903:2341:b0:1b9:d335:2216 with SMTP id c1-20020a170903234100b001b9d3352216mr5594186plh.20.1690006986169;
        Fri, 21 Jul 2023 23:23:06 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902989000b001b9be3b94e5sm4509198plp.303.2023.07.21.23.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 23:23:05 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 0/2] accel/kvm: Specify default IPA size for arm64
Date:   Sat, 22 Jul 2023 15:22:46 +0900
Message-ID: <20230722062250.18111-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
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

V2 -> V3: Changed to use the maximum IPA size as the default.
V1 -> V2: Introduced an arch hook

Akihiko Odaki (2):
  kvm: Introduce kvm_arch_get_default_type hook
  accel/kvm: Specify default IPA size for arm64

 include/sysemu/kvm.h     | 2 ++
 target/mips/kvm_mips.h   | 9 ---------
 accel/kvm/kvm-all.c      | 4 +++-
 hw/mips/loongson3_virt.c | 1 -
 target/arm/kvm.c         | 7 +++++++
 target/i386/kvm/kvm.c    | 5 +++++
 target/mips/kvm.c        | 2 +-
 target/ppc/kvm.c         | 5 +++++
 target/riscv/kvm.c       | 5 +++++
 target/s390x/kvm/kvm.c   | 5 +++++
 10 files changed, 33 insertions(+), 12 deletions(-)

-- 
2.41.0

