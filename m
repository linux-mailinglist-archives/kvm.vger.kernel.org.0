Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD55A602DF7
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJROJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiJROJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:09:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641EE17421
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:37 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id b5so13409989pgb.6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQSIDFFVuF+EIt2cEUFNJqH3Rmj/qJAjRYREvcssnEc=;
        b=UoN1IAs8s/3Fu4+iotE3z0nvVddkbZfV9io2+cQEJ2uRjvmOc42FChGgaW7/2ZArc4
         JykfKy8B2cQUacgccfC95J4iDc23qv7j+3R3fqAeat29lA+5vOfGACIAbI115WSFyEH0
         Q9m/+w6FZpsdtvfrTdlLpteF9SAMBXzuI49N1uLhuD3QCuMFMoSYWaCQSW/BkSsniE+B
         zsjUaTtRhVvF1WC7ll/gWzlrAAh5pCdQJeMAefLl3GELEy3oPzu2mO1J9d5ZLfTpITPe
         DG6yQELJ2F/Z3h2OJJLxVJ6QV95wW7wvlMvX6c4y2JD1Twyb0B+bwmAfWcxaRnYPmMOC
         payQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQSIDFFVuF+EIt2cEUFNJqH3Rmj/qJAjRYREvcssnEc=;
        b=XB6+1BtNoNmCsXjQo1X9KUVGBA7TpHQCjaELtvlVL2+ifkQw7cpGCWKBQKWk7qt7Ny
         wI9I84W08vLoshiwc0I+J8uiYDKN5sx6AQUMdBmjA7GkA4WUUDk1ytlJEJH1GNDNO7pN
         0Uno+Es9nCJb8qQJkUTYXOQetPEbblNGvGd3PUPc9w2KS+FuHt4C4lPBNlMu/pE1uN8d
         qhb4kz7f/I5LlBxXn2iS2litZUVVJGRIky/18Bq5pCYxmsf6KlmpnCNue24AyXyaneG8
         f6M7hCLc4zDpd6wzdioC0ZKNgnKg8pWX9iKVD2YhyQod5gGGYy1GXeiQYN51P1ayHyEf
         Adkw==
X-Gm-Message-State: ACrzQf2bCzOJ1TUBTT5ZyXxhfUj+5/4Kl4CFcEdgbhmPyGD+PjXmZ8I1
        LVDaDLbrmmjxT5Xw6zW7u5CMng==
X-Google-Smtp-Source: AMsMyM4QqTc9RDg38FTb9jRNWuxsRXJuswFnY9rJKOUgJhDITlN1G5Ec8NTaf6OwumSzrdOyJpl96Q==
X-Received: by 2002:a63:145d:0:b0:44b:f115:f90f with SMTP id 29-20020a63145d000000b0044bf115f90fmr2822412pgu.157.1666102176161;
        Tue, 18 Oct 2022 07:09:36 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:35 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 2/6] riscv: Add Svinval extension support
Date:   Tue, 18 Oct 2022 19:38:50 +0530
Message-Id: <20221018140854.69846-3-apatel@ventanamicro.com>
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

Svinval extension allows the guest OS to perform range based TLB
maintenance efficiently. Add the Svinval extensiont to the device
tree if it is supported by the host.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index e3d7717..42bc062 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info {
 struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
+	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

