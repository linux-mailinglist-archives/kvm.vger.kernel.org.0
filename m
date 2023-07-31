Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97491769585
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjGaMEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjGaMEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:45 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C5910EA
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:44 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3a7293bb9daso696795b6e.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805084; x=1691409884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5g6ezAcbcDbpiKHj+AEdPKnGvpfWwAjfnv3+ZuFJ5r4=;
        b=gbBcnmgdij70CZuNsemzv6OiZ62y/nqSLVfJuBjt56UG8eTsfqEcQ5H0O9hvulUTuo
         TsBmBA4snnIblsOueHwJ7KEk7XORWZrMUGtCktF0b+7KUcf51BqSn4m8k9vNb6mh7Z3X
         EA1rhX1hmSNpoylzN1u1mEmHfCxw4s1XQ9Us3ezPorKU6ypgsv3NRQm2GABUBULG1U+S
         skX4nx28Jzb2VXpL/Ct1+0cRdC6Y7uTW1Jxcpt3V4Bk2AK8CMUFj28tlg0nThapDHaJm
         TD7kANuoyXYCm2XPQczXHTiGigNBNZI9OX7IXipnIKjJwuixKYEQFV6VjoFdq6GEvKdL
         PAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805084; x=1691409884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5g6ezAcbcDbpiKHj+AEdPKnGvpfWwAjfnv3+ZuFJ5r4=;
        b=gx4KyTD9QCXMyO2k6c/g0LeHuekYlanESxjonCpq3WG8jN5vDoS54rI8Zv61jSiYX4
         ABsnLCuxb/BZjj79tImzVjnjXYCStUFI0CjlnVyRGMdguQb0owVdQnl4By9c4UP5PAyU
         otsJ0RP9YOVaO5ukS6q70dZbhmSFeheWdM9opaunu8ySZOkmM4xYf5KdanRmTJWUpiBo
         Bu3TNlmlhFl3OYbOcWvvjh3JNnwXX3MhJKmA38M+Boz5sYKPwTP5CleGd93l9eqEoKsu
         grM/3Q5HLPZR3cvgePuk7qleM8/PnN6GPj7OufHp0b1XlHnpBVrP8oTGFANIuSDhQGJx
         p9gA==
X-Gm-Message-State: ABy/qLZmKVzI4SG/b7waTiKPRSPdnNKcTLdPmLWb/JHHlFNRoJZII6Dx
        OeCbm6jKgArGpPIoTb5P2fNlrg==
X-Google-Smtp-Source: APBJJlEK140Sqf3PZqEO+ojsGo00HTDQQSk+USiO73L/HrwOAD+v54PVGva7arYeyJ8WWOtMWFVgxQ==
X-Received: by 2002:a54:4714:0:b0:3a7:4f8:eb76 with SMTP id k20-20020a544714000000b003a704f8eb76mr7414240oik.24.1690805084090;
        Mon, 31 Jul 2023 05:04:44 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:43 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 6/6] docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
Date:   Mon, 31 Jul 2023 09:04:20 -0300
Message-ID: <20230731120420.91007-7-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731120420.91007-1-dbarboza@ventanamicro.com>
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The EBUSY errno is being used for KVM_SET_ONE_REG as a way to tell
userspace that a given reg can't be written after the vcpu started.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..229e7cc091c8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2259,6 +2259,8 @@ Errors:
   EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
   EPERM    (arm64) register access not allowed before vcpu finalization
+  EBUSY    (riscv) register access not allowed after the vcpu has run
+           at least once
   ======   ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
-- 
2.41.0

