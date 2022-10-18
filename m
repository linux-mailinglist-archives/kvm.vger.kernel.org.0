Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B99602DF8
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiJROJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJROJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:09:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7251F605
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso14119258pjk.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2IpBJzC/KZLEhOakHFoNifjUYgUg4NurhrpOreBu/A=;
        b=i7BNkwhBmRa911t30Yz5CURDDoTYRau2vSyCQvKiKh5hBnfXfXdPATcb5C3HeuPbOO
         ZP848bhXlrfsq3kgizUEIYjnbfqggU5ahRGXNM90LmQdWnYU1snwdCJXHoJX2ThjUOiF
         ZX1UahzlEP4mVTQC+Pk5k4kPGHD3hndG0C00NmK+8rdXEEq4Je5wWKA9nUwoXfF0y+7V
         /du2jQfJzvAJZmXXAMQibYgcG/dNIyrpTLKEpnF78gUfF+G8pJcxYC9PsZUFJlsv4XYV
         HX7WA/MjzJQ/ZBaUUhn8GZLor4BWOmWJ4kZeKN07aWMr9uFq+9RQ6jMM+yOpqtF+GKuZ
         d5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2IpBJzC/KZLEhOakHFoNifjUYgUg4NurhrpOreBu/A=;
        b=YeCxn/HIv7FBD3JNv+d9Ew8du1IHn7Wa5i+6ae280jM6MwuDsC/r0I6tMIkBgNIf23
         3VkOf/qDUJk7kYFTNEfLLxprP+IV7c22G5+CycVP8yp+6V+ZXK9GhF3Ruyfz1pCrP5nB
         +bfGZNqWDrrqe3HQJNPZt0b/h3Ub/vmQ0PgWAgAyDXSNAzqNAEnG4VlkScrRvRZdstx2
         huBmenTTTQ4dmFclS8jf+ytl+PFhJk3UTvYKS5x9I5ZtmH42ot+YU+vYseObLqPZsK7b
         Tu/HOfZ/OD9VzG7dHSt+6Bs9oBKaZ+mdgzFKLhsLK3fuTTpc9QCotivR19AUvciL+lyj
         xKVw==
X-Gm-Message-State: ACrzQf1ROmq167sF+yxiZtmtMITaSiP/4Z791DDXgDIqgiWqu7M3pu++
        N666WbMB5cHmYWHqgltXc52XyQ==
X-Google-Smtp-Source: AMsMyM5/1xD9nchl7YiD8PnipajH6ICLb8WzrqA2KonCjgdXWURk46jUpTdgmv0uhbUdbiWOuwle4Q==
X-Received: by 2002:a17:903:240d:b0:183:9bab:9c3 with SMTP id e13-20020a170903240d00b001839bab09c3mr3318161plo.48.1666102183918;
        Tue, 18 Oct 2022 07:09:43 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:40 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: [PATCH kvmtool 3/6] riscv: Add zihintpause extension support
Date:   Tue, 18 Oct 2022 19:38:51 +0530
Message-Id: <20221018140854.69846-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mayuresh Chitale <mchitale@ventanamicro.com>

The zihintpause extension allows software to use the PAUSE instruction to
reduce energy consumption while executing spin-wait code sequences. Add the
zihintpause extension to the device tree if it is supported by the host.

Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
---
 riscv/fdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 42bc062..ef0bc47 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -20,6 +20,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

