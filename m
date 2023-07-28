Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27516767752
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjG1VBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 17:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjG1VB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 17:01:29 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C444483
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:01:28 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b9cf7e6ab2so2103877a34.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690578087; x=1691182887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NfiXyqjOsuhBJ7gNzyGFQOYN9/v2M7YPA+xZ8F8OLCE=;
        b=DE5ugsNM9Doc3yveWcisFKCkH0mNaPI+BE0Mcedw99qW2USuJBMStQNGhvUERkv4Iq
         wjL76GT03yGk3EP9CP37Yk+9OTP5t0ry5Paum3Z3Dxl3gU7LMO+CtIy4EBMUC16P62q0
         h1O4wVHgNBpNsZhuSdpCRiwbm9mnepJeQQb+zcOINfSJcub60B95ZO6YDGaQmDoavdY+
         m4bpWWJv4k94RwVrsTY/6BhIMUEIX7ud0F2JtBL579o7E+aTUjqyBNw8j3+JsVgCF7ep
         OwDMH2Y7p6Ga46hQH1ZbJMxFEWWKvP3Vopro/wbacvgUDVtPoPXfatNVwPIcrvAwDlXx
         HaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690578087; x=1691182887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NfiXyqjOsuhBJ7gNzyGFQOYN9/v2M7YPA+xZ8F8OLCE=;
        b=MwYe0q96Qka7glRzazFg0x/zChiktIdGBmIeXSsDiy6hkYIbbxAzOojNlSoWsHko2A
         6WulljcpI9tTfObHalBp6aw4uy96bZwlB86gnD+EI0iojgXPLUoDh/3Jl1GHLZ/O37IA
         7mQqh+8IY1VvANImluC0j9O35/m4PkFbmW1JNPBtZiM7XH75n2s7DtoEKRbs1m4JpEL8
         SBMoys+bK+LXYhQA0o3MNnkmCfSMgQ0XYhIU5KlQhcXg3SLK9YmAwNDapikFZhoy8kF6
         ttuhcZh1VGSFHq9vhybl58dc5tAY4NLMl3AQX+Fia0nk498TatgYNBLJg81DsDxxG9Ga
         iehQ==
X-Gm-Message-State: ABy/qLbPeXog0s4XczBDlXd2lv21vnd+CWsYpCr7x6gDGPd2fm4WIaau
        rE6THMkhWMYNg6f4ryunJC/VEjPfuDyK3sbor2Uv0Q==
X-Google-Smtp-Source: APBJJlEnC6e8HublhqTxll43F9VC6kXXC0q22Q7/XrNujEjKjuYqyCI6oySh7bDLW+XpyVF1SWmQ7w==
X-Received: by 2002:a05:6830:1d8b:b0:6b9:6210:9014 with SMTP id y11-20020a0568301d8b00b006b962109014mr3761688oti.29.1690578087725;
        Fri, 28 Jul 2023 14:01:27 -0700 (PDT)
Received: from grind.. (201-69-66-36.dial-up.telesp.net.br. [201.69.66.36])
        by smtp.gmail.com with ESMTPSA id n11-20020a9d740b000000b006b9c87b7035sm1987769otk.18.2023.07.28.14.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 14:01:27 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 0/1] RISC-V: KVM: provide UAPI for host SATP mode
Date:   Fri, 28 Jul 2023 18:01:21 -0300
Message-ID: <20230728210122.175229-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
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

Hi,

This new version is just a rebase after the recent changes made by Anup
that landed in riscv_kvm_queue (introduction of vcpu_onereg.c). No other
changes were made.

Changes from v1:
- rebased with riscv_kvm_queue
- v1 link: https://lore.kernel.org/kvm/20230705091535.237765-1-dbarboza@ventanamicro.com/

Daniel Henrique Barboza (1):
  RISC-V: KVM: provide UAPI for host SATP mode

 arch/riscv/include/asm/csr.h      | 2 ++
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 7 +++++++
 3 files changed, 10 insertions(+)

-- 
2.41.0

