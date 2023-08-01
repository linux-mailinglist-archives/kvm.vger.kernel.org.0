Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C985976C070
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjHAW1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjHAW1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:27:10 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0241630C6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:27:00 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6bca7d82d54so1901540a34.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928819; x=1691533619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5g6ezAcbcDbpiKHj+AEdPKnGvpfWwAjfnv3+ZuFJ5r4=;
        b=eVli2vidJKe5G6yzfio4xe3N1CQY38+fWkC805I+iE0BKgN3cQPDSlj2Q2qTkkRTdT
         oXDB9NpCnawERW+EGwdjj4ycY87U0o279DCOI8ZZe+SOxekYCQK3bUe6pF4zymNyPs6U
         TcJeRYqB1jTkzCVLWcpfGVeZxnqrgjoE02gMT0kzkHAEJJNiOpJU+EDkySr1W3F1NFQG
         jspe+cRjZWUhgv5d5EGnA6O4cPaZKIZGrn1NqeHfgg5F8DYTPEHUcGveymItLkyneDyv
         JRXt491LPCI2QS+V+WWgmirg2jRCMPem+zldlb/UwrSHGw4wvRoQi55utBIaDK3kYk8I
         VCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928819; x=1691533619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5g6ezAcbcDbpiKHj+AEdPKnGvpfWwAjfnv3+ZuFJ5r4=;
        b=ZoePgJaZiPM9qbJfnEuDQPQNihXEYAtukYDMBJjmUs910bJcz20Pj/e+5Q8LyD6BZI
         PoLwD6jURYQLxJLBEXiLoF3oQ+4U5Wx4eTJ2YC2yzb3PYbU1Zx799IJqkx2x3nquPShk
         +F0pJwzvjyqT/h60HbMO3FtbnGPypiZqegBe3uI/AR3+WUPQRev37yfX0kI8lizUg22e
         iLy+nn38pbOMZUrLPI9DZr+t7146mRV6+Njett01Ysgh06cI9khsCUviodjWh+YwOH3a
         uFub1gldu6pC8aNK+xQ8ePXo9rWf2NrHxV5nY3moyzEu8nYnbdgLSCJR2sehtgHPKWGN
         bXEQ==
X-Gm-Message-State: ABy/qLaSQOys5aSLMH68IK/W+2cejCjXC48msMzNZiM6VO4uaTzw6jwn
        3xhHYqP8HK5dR0+n8kfHzLJEbA==
X-Google-Smtp-Source: APBJJlGZLIQX6v2Gff80pri9PSoxKtsIvuNPKAsHRV2rZ64pUXfcAAVzSPiog1oHKzqGX/7wJwKNlw==
X-Received: by 2002:a05:6870:524e:b0:1bf:62d:6ea3 with SMTP id o14-20020a056870524e00b001bf062d6ea3mr4055037oai.20.1690928819651;
        Tue, 01 Aug 2023 15:26:59 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:59 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 9/9] docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
Date:   Tue,  1 Aug 2023 19:26:29 -0300
Message-ID: <20230801222629.210929-10-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801222629.210929-1-dbarboza@ventanamicro.com>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
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

