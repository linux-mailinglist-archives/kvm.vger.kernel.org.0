Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7EC6E84E0
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjDSW1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjDSW1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:27:00 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED256B478
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:34 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-524b02cc166so67506a12.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943044; x=1684535044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXsqDGUR1sIAzl083YrDdeF8Dcz5MG5TcoJ+FCFYQPE=;
        b=ohOEHO7BV/FHEqjDiY6pG/sbPPkvlHxUUXDxUV7dZqgZIIWVcpKe0qvs+coh7D9ZRh
         B9hkxCLFKh8o9nAC2rlRn7bMm1mBtWYtjnNK9pkEtJDD583cXnspj2Ze6kFtPx4sD05T
         M0i9ezLAErgLCl4r/YZAwl7ub1kBW72A2bCM2VN+GllxhNlhbw4174U5Fs0Rqs8lwuLx
         6dFmv6DPhfk7Q0h+47Fu4cY06lgOcb8Yfc8WZoxCPJavUfQg727zdhXtl53U+ZG5ga3H
         Ua4k+o9Cp2yjV6jziSpH7zmCITKPG2JXN/AwelqUy5IqPzKZ18t594Y0qlAjZCJGwgwu
         OUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943044; x=1684535044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXsqDGUR1sIAzl083YrDdeF8Dcz5MG5TcoJ+FCFYQPE=;
        b=YfF8uBaKMVwLgaI4EhqamUFtPbXFFhnNr/j7NpPuF26Mf51Yi4NBOES9tSvSgvP5yd
         cjMhyZYlQKq73WmDeaA8dXKHJ8lHm3H8oHXN6eEiWuiGcx/vqqCtii8nETSXdE3VaFQ8
         kwNpc6bAAiz2pQHLLoeWFS5W0tmT/VqV21m65fHJnIu39AkSxUue67J/MPdDlzezbr9b
         I4YL4Yg8aakyOv5fw+KiiwjU8CZWGRYf2qWVe72cFZQ1V1CSHdnnvFb+EnSOvjbgYAIu
         Jzha7D7BIV3yFLDrhn0+qn0XXRO1k0GH4yRnAUSci2mlPdjA6N8fUuIsMBcWzid6sZeP
         Iq/A==
X-Gm-Message-State: AAQBX9fT9p/gYkNFVxVZFYepvyQRBbOamKpWfN3ZcEqN3o54QBZs0rTB
        d/Gy4G0umWT9bTcE1b4AZxFthA==
X-Google-Smtp-Source: AKy350ZHJJEltFWMtiEqeoirE/coBcaQIIAAD+T2dcklEUVhjT2GbyU5FBvkRUpdkDap1R/DwivJLA==
X-Received: by 2002:a17:90a:be01:b0:247:1e30:5880 with SMTP id a1-20020a17090abe0100b002471e305880mr3727645pjs.38.1681943044256;
        Wed, 19 Apr 2023 15:24:04 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001a681fb3e77sm11867810plt.44.2023.04.19.15.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:24:04 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC kvmtool 01/10] riscv: Add a CoVE VM type.
Date:   Wed, 19 Apr 2023 15:23:41 -0700
Message-Id: <20230419222350.3604274-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419222350.3604274-1-atishp@rivosinc.com>
References: <20230419222350.3604274-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM needs to distinguish if an user wants to create a CoVE VM instead
of a traditional VM. Define a RISC-V specific CoVE VM type that can be
passed as a VM type.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 include/linux/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ba4c4b0..000d2b9 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -911,6 +911,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_RISCV_COVE  (1UL << 9)
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.25.1

