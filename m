Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BE14A4C5A
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 17:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243200AbiAaQnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 11:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiAaQnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 11:43:31 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61922C06173B
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 08:43:31 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w14so27971067edd.10
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 08:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dGzXd4bmmboGJFGFy1MxKhj8GszZ6zAjTI5/EJrHl7M=;
        b=V7VkJnSdtCA2MSqwQCV/OgUVKpPJJFVLpHLlpmCGdeCMGYOIfxLW+xSh99gc1AW31g
         L97vfeoAznwYGzM9xYm8DKUVpJnZjJNSwnKM810XANbRvsNvQ3MbLadhVjeDbhx+LbaF
         vSR0A5p1b5BKr6So34AxFuEsnyFY1azY0f3ai54quZgCEhuOvFRdYd/NT5PEsV+ctn41
         FZPMLTQiHzrHKtBKu2WrAegFHg6I6AxYJSx3Kz0bV5IKu+ZI5SbziI96d4ny+IbR19jK
         L4Fkrj7GnuQUoPukYryJcBYZ7LvjyhLGLqdG84frOYb8AJxIDBTq74h+tIHjxSsUr6s/
         GiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dGzXd4bmmboGJFGFy1MxKhj8GszZ6zAjTI5/EJrHl7M=;
        b=vshy9ElTWGJv7mjIXQinH7JfLTIVGZ5FxjCGgPgSc6tF7/HAL3rSvP5WVBTR/tX3Cl
         R2+7mFXMEKFwqUoqIMm7fwsmsVQvTIaeanEaCG3ORQOxNLt/eyTJa0UV+9QFQxv7lwXc
         kq34yBmi4q3tMZZSzrZrJ+bQ2/g9C9hWRa4pAfwhTdwuHvsHbitaQztqWmQHDaoNq3Fe
         +W1WdlWvUPJQBEeN/89menn1kKT37pjoeCuJLiVvcwpnbZvnqr4WZ+OpiJxrHIMf22mH
         /121ILwEYI155BEgbLw+/okPkBemUOfyno1u6kg5XVTHa6gRpzOLObtnpkycygzMnphS
         MU3g==
X-Gm-Message-State: AOAM5313cxFpHCUayqPNkQbcnikdhMbvE89NCITmNVSMKmzt0mcwDgMW
        ez23zX6J56kfqpJk2KQBbZz5pQ==
X-Google-Smtp-Source: ABdhPJzYdWkwkSl+sy7pLa9G+31Uj79QOFKPDTW0KlbZ9luY+B9Wio5QZgqA+2A07MgpR+4hfI/TwQ==
X-Received: by 2002:aa7:d0d1:: with SMTP id u17mr20901972edo.179.1643647409952;
        Mon, 31 Jan 2022 08:43:29 -0800 (PST)
Received: from localhost.localdomain ([122.167.49.110])
        by smtp.gmail.com with ESMTPSA id m12sm17833138edq.40.2022.01.31.08.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 08:43:29 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Fix SBI implementation version
Date:   Mon, 31 Jan 2022 22:12:32 +0530
Message-Id: <20220131164232.295585-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI implementation version returned by KVM RISC-V should be the
Host Linux version code.

Fixes: c62a76859723 ("RISC-V: KVM: Add SBI v0.2 base extension")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 4ecf377f483b..48f431091cdb 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/version.h>
 #include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
@@ -32,7 +33,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		*out_val = KVM_SBI_IMPID;
 		break;
 	case SBI_EXT_BASE_GET_IMP_VERSION:
-		*out_val = 0;
+		*out_val = LINUX_VERSION_CODE;
 		break;
 	case SBI_EXT_BASE_PROBE_EXT:
 		if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
-- 
2.25.1

