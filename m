Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73276C06F
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjHAW1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbjHAW1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:27:10 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0552D71
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:58 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1bf0a1134d6so1139881fac.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928817; x=1691533617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbDT0MfbRX4j7ZGvFYTA0I3dalF0+0N+r3+DHPQCNeI=;
        b=AQcHVF1WjA4okSWGpOMbqspUIJ3iEg1VDpgwCCzt4IfG46kooADzgPENm+bxk9fLBG
         6yxYIir/rHNgxKXt7Dhyl0H2g45WSO9c8jEsiOzJd6yuIn7McV2Pu3BWKaNi8tUnJIu9
         RfUqIwMWue5F8xJFo5m/JHaAS0d0qQ18ehu4zSvZ9ehRICxv4RIM25UkQosBDdZAntHO
         ijDI4c5ff+LgcNeTLD1lLg3/y/iwzn1xDj5jfvQm/zo9nhIBsqAnVkobsitFH716xS2x
         h8Wj9xLLbIQG2tY7VrUG8Fh9ZR2ZSRTBHEbPr9ewRXVJRbzn8bWBLqsx7YHld53750K/
         ltJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928817; x=1691533617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gbDT0MfbRX4j7ZGvFYTA0I3dalF0+0N+r3+DHPQCNeI=;
        b=dKMZlyYudRJbf8EDYw3Izd/pwmR12bq5bSsmdAaqxX8vhP+jtAo3JkZ+dCc5x/bJij
         Y11YL2YKH2r2RPvHgNzcRNszrnWMFnKxrSgoYa+2E0Ka9GADUZHWddTAJYYEKZ62ALbP
         hFYaSYi43DD2omNNGC26rhES6j5SD9FY8Q8wUN4mvG2Rm6njPa2VB/ix3fCBXT3tyaUK
         bMIudlX4z5EXEYo8FH2rg3qshd5sdCxHwI1dV0V/Pb1OrwR/+2sqh6M6Kj9xmdXujWwF
         2v5S9svUgz0Aoo/U4n53q22hR8b0Io0R9+I40pD1olJvz59pHz42T727O89a8Qf07GHY
         krzg==
X-Gm-Message-State: ABy/qLYfRfPPkA7MIV3r7pTACl7WM6lXIc/dlnlC50Mph0Tf+e+j3j/D
        IsFvN2KA4jkBYwlx2/lCiLp11g==
X-Google-Smtp-Source: APBJJlGpQT+OrLDl8OyEuxWQhziQS0XGOWgH6q3o9SRCpTCS5ubBiyUy9ofy1qow8+tdKf+wUM+1EQ==
X-Received: by 2002:a05:6870:784:b0:1b0:73e0:97eb with SMTP id en4-20020a056870078400b001b073e097ebmr15376248oab.30.1690928817004;
        Tue, 01 Aug 2023 15:26:57 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:56 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 8/9] RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
Date:   Tue,  1 Aug 2023 19:26:28 -0300
Message-ID: <20230801222629.210929-9-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801222629.210929-1-dbarboza@ventanamicro.com>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

riscv_vcpu_set_isa_ext_single() will prevent any write of isa_ext regs
if the vcpu already started spinning.

But if there's no extension state (enabled/disabled) made by the
userspace, there's no need to -EBUSY out - we can treat the operation as
a no-op.

zicbom/zicboz_block_size, ISA config reg and mvendorid/march/mimpid
already works in a more permissive manner w.r.t userspace writes being a
no-op, so let's do the same with isa_ext writes.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 1ceccc93ccdb..c88b0c7f7f01 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -475,6 +475,9 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
 		return -ENOENT;
 
+	if (reg_val == test_bit(host_isa_ext, vcpu->arch.isa))
+		return 0;
+
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
 		 * All multi-letter extension and a few single letter
-- 
2.41.0

