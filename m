Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011647C6477
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377559AbjJLFQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbjJLFPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:15:55 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09342181
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:41 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so445149a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087741; x=1697692541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRORRt3s6hvFf4qGGIikwZfB3q5mq8SDYLLtJc1fkNQ=;
        b=V94Wj3U/8ri8qOnuiAfwzl/+3mX/XBsscxf8tNI0Hms+fw5wJy9OjICgNeHgx7CUzm
         lT4CMLvtxci7RU1cvI86pEOZRBOWqybo1tNkXEWqe/OLTjE1cKaR1rM8ir6LnUCYSEWi
         pQcgVlqgGyTmixozzZ3j0cPfYtKoryovslksLot74oNUsZDHs1L1SQkpf4yN+v+FU82r
         MGFc9ljUpBrrdBHGvoMPdVGtve8hTYR+wg9/nUgmaWNXk5J9KRsbJJMSEnQxq1BY2pf8
         1G5ff1mCo6EiHQafHJPojpXLHVz2EYASo8KKP034drr+mn0au9iyxQoQU+IxXkXWiSSt
         Ui7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087741; x=1697692541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRORRt3s6hvFf4qGGIikwZfB3q5mq8SDYLLtJc1fkNQ=;
        b=n/AXV+MmRITgSjBQKqLKn7BNQEaVL8DTU64RW1nL9Utz/oEOqRo1yjdqb6YjA1mJ34
         HtkotRO3LIPH6iUyU2OLQK/GUwndp2HKdBEg8o2SLb0Bxf1phFfKVhaTqRLbY1ruc/kI
         Y9prg/UR+AvAYlqDBFp0D0vOPieCDFcLjoOPLr2ENZXXKEDsz//u02HFAs988B2d6vi+
         9N8K/vH+hIdfgNC80THScvMDOF1CeFQ8DaCBLVX/paWlZ+IvByRQwAsmK9Gq+4vMRL7B
         Oz/TYqvC1p+SVWlivQUZwREHO9KEaSuMtTUjVgubgU1OrdQkUA6BfykoC1cgKyb0i4KX
         xC9Q==
X-Gm-Message-State: AOJu0YwwAh9d3W/QywaS+KRuj+GL5gH073nS88qsLc65UWZFHyD9Qgu0
        pSeaEGOJDC8IEVEtAd8IzWWPDQ==
X-Google-Smtp-Source: AGHT+IEHQA7g0wr5kBdA1+VUq03jI8s5X+zTK5oLbVixutxk664ESGEsqt+140ZFSE0KLFXmweQiJg==
X-Received: by 2002:a05:6a20:1586:b0:173:e36c:6d03 with SMTP id h6-20020a056a20158600b00173e36c6d03mr3716883pzj.22.1697087741089;
        Wed, 11 Oct 2023 22:15:41 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:40 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 5/8] RISC-V: Add inline version of sbi_console_putchar/getchar() functions
Date:   Thu, 12 Oct 2023 10:45:06 +0530
Message-Id: <20231012051509.738750-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231012051509.738750-1-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions sbi_console_putchar() and sbi_console_getchar() are
not defined when CONFIG_RISCV_SBI_V01 is disabled so let us add
inline version of these functions to avoid "#ifdef" on user side.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 12dfda6bb924..cbcefa344417 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -271,8 +271,13 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg3, unsigned long arg4,
 			unsigned long arg5);
 
+#ifdef CONFIG_RISCV_SBI_V01
 void sbi_console_putchar(int ch);
 int sbi_console_getchar(void);
+#else
+static inline void sbi_console_putchar(int ch) { }
+static inline int sbi_console_getchar(void) { return -1; }
+#endif
 long sbi_get_mvendorid(void);
 long sbi_get_marchid(void);
 long sbi_get_mimpid(void);
-- 
2.34.1

