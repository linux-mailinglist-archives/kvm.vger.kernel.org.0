Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B141E7D0961
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376472AbjJTHWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376495AbjJTHWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:22:25 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34ED7A
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:18 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7a6889f33b9so19337239f.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786537; x=1698391337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MwlyMPcz0zqeFoKpmeSvnyAhcAgahoPS/k2EPhyd9Ww=;
        b=JvsWy9tI8Qc+kx0cpzg5opF0cLQB/gDC9oFvHcduXBta5uGVSLbsXwSCq2fP5vNJeb
         3D3brFJrmwZc6Oo+IOYgkg1H3NSRtPfTmsgOZJh3yOvCjrxQPOq7DVzDPpbEj8r8I3nt
         ecHy1tlYv+2XEQgQ53XJD3NjC1fB0pFI1bTF2bqYaw3xKcGF6YgByZo1sClyAQhMBs5F
         Aopmuv8MfnQSuMWkhrMkmfuB3zChegJdZaL+fspKt6i+gTkyCOEnZpMRUAGPZym7EQ3C
         dztSkCOAu0/O71NnNFrjoAKpCtTDRXdBWmM+6YtqYYtcJRrhAwflLfKCOOYKqOvFwLPw
         G3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786537; x=1698391337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MwlyMPcz0zqeFoKpmeSvnyAhcAgahoPS/k2EPhyd9Ww=;
        b=LvMdumWV4eJ00bgtbLA2i36M+g1XeWlQkuH8chA5RPj89u4OaB+EAa2B0ICNQpGTgw
         Nq6RwkGoeZUh9KdLg/NOq/kOjIYDrA7004jows8YuH9uqabNM+8DKg51IFjGtAXPL1iq
         1IO3kjzz/PF95lnedBWn+81nb7KBdCbXB6vpK/wrPWxZIZ/oggrF/5mmv52jLCM715nq
         FF7h0Dopj+k9HwwSr1ZR4ow/qVDA91iqOmkFat5kBx/yq+zT7nKepi3fBzddQCFAluKV
         /7BZI1F5hrESu5Gk/lRBm7sJjv5kgzgRXt/aeFeUecNitFeuatUrYc9x2ikbr3/OG93B
         n9oQ==
X-Gm-Message-State: AOJu0YxxXmJffzex18gmee5ml7brrQ93ZZvv8lvZYdYkR5WNuRVA9TA3
        4vDWYIILifkqj+VAVrKtdzheLQ==
X-Google-Smtp-Source: AGHT+IGxC63+68DtxcLP2NLHVLlq5o7kgQhRaiJb+wOy0CTSQu3yay0cbuJzx5Z+DRUCCNZLZovnkw==
X-Received: by 2002:a05:6e02:1748:b0:34c:e16d:6793 with SMTP id y8-20020a056e02174800b0034ce16d6793mr1508711ill.14.1697786537209;
        Fri, 20 Oct 2023 00:22:17 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:22:16 -0700 (PDT)
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
Subject: [PATCH v3 6/9] RISC-V: Add stubs for sbi_console_putchar/getchar()
Date:   Fri, 20 Oct 2023 12:51:37 +0530
Message-Id: <20231020072140.900967-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
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
stub of these functions to avoid "#ifdef" on user side.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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

