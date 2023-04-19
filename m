Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291FB6E84CF
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjDSWWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjDSWWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:22:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B99EE3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a9253d4551so4770515ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942756; x=1684534756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8D5qQaAsWRyihppL8lxgNE7a17gNAwjOwZEXYQRMgE=;
        b=KY3qeDkuqx7ojUE9edJo91m4yJkLaFWv5WBr0z1XBW37m3Ugju5gvpwIFDQff0jKms
         +hgKcILxSjrfAbaSn/gsJas5jFwQYwJwvq++pUZKG2L4GsKhyqTPcUu6xp5ypSE2166a
         M9MbN1bFoVVAdPgWpFhugIMpkrykve+HvKmx+0rzvYuv5b7fjLguHE92nxuCMfaazyT0
         EjqjUkf7F7QIDOnYykXPXccd7CL3t2WBS+Rd2ML5ADa2yHIE2iBIctAwVUyHJ5XwQDtq
         3t1dyXic09IH7MeVfo82H9l2jXFUHVEBVSeBHFYy8QxMmo1hXkdwnKJUN8t2qaLHF1ux
         +z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942756; x=1684534756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P8D5qQaAsWRyihppL8lxgNE7a17gNAwjOwZEXYQRMgE=;
        b=PvO5hTlEePzx+TkcKohogfUskVDRK6gAf2szVvMWcrRgrNW42MWB9mZxnnYhsNEWJB
         Gn4kKMxca5IBfuGs2QOWaG+4IvIwkz3Ea73Oz4jaqC2sFcb995u8elVMzoFTyNqNjPv3
         pflGS8qilWXPviiS1GTXM5BaJ5zdrNbvi3ZbKWea0Naj8fOP7taBST6hvk9pttW16qWi
         EDZ1fXD6Vbunuj1QNMlbChyhUHbyRAk4f4UYoUBg667a26WsKINzfAa76hSWSUDFYLjb
         HNwkfZ/5HdFoX8WA+obB8xDu498Y9KyZeTzIQa2kL31Y7N7JEE2irnzOSsZeidS3X6Ld
         ZLRQ==
X-Gm-Message-State: AAQBX9etY7TxUBLoWRMoeP1NPNTvjmYZKFcqPJpxwSsU2tFvN2bj+KJZ
        fizW4PT6nzVT6+YL830TKFO+Rw==
X-Google-Smtp-Source: AKy350ZigrT04ztZNfYo7vxPOIAk65YMZhdMrGeFS26zGyCIXgxICUZh5tguDmZpxCxB9++y2y9iww==
X-Received: by 2002:a17:903:2288:b0:1a5:2db2:2bb with SMTP id b8-20020a170903228800b001a52db202bbmr8899588plh.15.1681942756356;
        Wed, 19 Apr 2023 15:19:16 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:16 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 48/48] drivers/hvc: sbi: Disable HVC console for TVMs
Date:   Wed, 19 Apr 2023 15:17:16 -0700
Message-Id: <20230419221716.3603068-49-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If two same type of console is used in command line, kernel
picks up the first registered one instead of the preferred one.
The fix was proposed and NACK'ed due to a possible regression
for other users.

https://lore.kernel.org/all/Y+tziG0Uo5ey+Ocy@alley/

HVC sbi console makes it impossible to use virtio console
which is preferred anyways. We could have disabled HVC console
for TVMs but same kernel image must work on both host and the
the guest. There are genuine reasons for requiring the hvc sbi
cosnole for the host.

Do not initialize the hvc console for the TVMs so that virtio
console can be used.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/tty/hvc/hvc_riscv_sbi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_sbi.c
index 83cfe00..dee96c5 100644
--- a/drivers/tty/hvc/hvc_riscv_sbi.c
+++ b/drivers/tty/hvc/hvc_riscv_sbi.c
@@ -11,6 +11,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 
+#include <asm/cove.h>
 #include <asm/sbi.h>
 
 #include "hvc_console.h"
@@ -103,6 +104,10 @@ static int __init hvc_sbi_init(void)
 {
 	int err;
 
+	/* Prefer virtio console as hvc console for guests */
+	if (is_cove_guest())
+		return 0;
+
 	if ((sbi_spec_version >= sbi_mk_version(1, 0)) &&
 	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
 		err = PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_dbcn_ops, 16));
-- 
2.25.1

