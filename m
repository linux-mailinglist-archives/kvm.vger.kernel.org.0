Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6B7D51DC
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbjJXNew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbjJXNer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:34:47 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061046A6B
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-408363c2918so5186745e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698154071; x=1698758871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p7NxDbO7GUxLbtod+vtUf5vVuxdvzarRCEG44wnrlEM=;
        b=xwUmhfBygJgbn9ZhfJx6kMQE/3xoShhv+BwNb498DMPgntOJZO0skb+jMsPBXAkaoJ
         kLo/QGylY36f7bjKLy8RWH4YW1WIxyb+HWY0GEu6xgkPc68H/7nvjMwLFiciW09t/mYT
         MfW8keRcVgh9QvzzRsrNBPJ5GensudLK4y1Kf1/DIBRJlVxqTMtPIcwbyXTb0k7ryaSZ
         AYaGSXKL5pw2YN0JgzROVQdMEdj4nB2giRlkzD+vL1bvYQ70WkaYlV6PwPiMxyI+Kcqs
         WXRygQGjPzMgGSEEknSJzgE1Tp0K4+EwItWL7Lgnl1QNReCHMsTg0cDk+TTG8zQ62qxw
         fbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698154071; x=1698758871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p7NxDbO7GUxLbtod+vtUf5vVuxdvzarRCEG44wnrlEM=;
        b=HF63T1NbHOB1N5SGHww2goLiefIYGtDuZq4Y4xkn4PFJc+mrVw54U1jnG3BwM3b38m
         9+6v5c3r+NdVUS/nOtlRYLOR491hotlXaln14+ImjTxgB0TaO0Qp4dPDzSe7u+WptfLI
         FNfCF4JaCOW0X0VBthgu7UlD468ScJY4DAvxcJsg2zvMnhRyVk24uMZ33si1ghAMh4QV
         hUiR+9vjyFlJg7gj7dqfqn5+Zp3NIQCamyJcqlOPKrgtnLD48MvRQHBcx0auYVmnTQkS
         gYn2TbUsx5vNP0YaEy6W62p7VxXBz1VVWqMtUlqidk9amwDDqsX+HYstgVfRMXwZ69lH
         jwPA==
X-Gm-Message-State: AOJu0YxGmzxQzMrGiWzkBDem1BRSZSwyH4euK/1+qDugEZV/5+BLQ+2g
        CLTIrbtZ/dKavH9B2TyvY3XIWA==
X-Google-Smtp-Source: AGHT+IH77/PUgfFp7lhNctpa+rJkehqrdIV97sCBXLPajMuJnwUEvoVFCh76kpQkxXAlg1/QWfUznw==
X-Received: by 2002:a05:600c:2293:b0:403:334:fb0d with SMTP id 19-20020a05600c229300b004030334fb0dmr9098071wmf.4.1698154071124;
        Tue, 24 Oct 2023 06:27:51 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:597d:e2c5:6741:bac9])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4151000000b0032d87b13240sm10034964wrq.73.2023.10.24.06.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 06:27:50 -0700 (PDT)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 0/5] riscv: cleanup assembly usage of ENTRY()/END() and use local labels
Date:   Tue, 24 Oct 2023 15:26:50 +0200
Message-ID: <20231024132655.730417-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does a cleanup of all ENTRY()/END() macros that are used in
arch/riscv/ as well as use of local labels. This allows to remove the
use of the now deprecated ENTRY()/END()/WEAK() macros as well as using
the new SYM_*() ones which provide a better understanding of what is
meant to be annotated. Some wrong usage of SYM_FUNC_START() are also
fixed in this series by using the correct annotations. Finally a few
labels that were meant to be local have been renamed to use the .L
suffix and thus not to be emitted as visible symbols.

Note: the patches have been split between arch/riscv/ and
arch/riscv/kvm/ due to having different maintainers.

---

Changes in V2:
 - Remove duplicated SYM_FUNC_END(memmove)
 - Use SYM_DATA for simple .quad usage
 - Added Andrew Rb:

Clément Léger (5):
  riscv: use ".L" local labels in assembly when applicable
  riscv: Use SYM_*() assembly macros instead of deprecated ones
  riscv: kernel: Use correct SYM_DATA_*() macro for data
  riscv: kvm: Use SYM_*() assembly macros instead of deprecated ones
  riscv: kvm: use ".L" local labels in assembly when applicable

 arch/riscv/kernel/copy-unaligned.S            |  8 +--
 arch/riscv/kernel/entry.S                     | 19 +++----
 arch/riscv/kernel/fpu.S                       |  8 +--
 arch/riscv/kernel/head.S                      | 30 +++++-----
 arch/riscv/kernel/hibernate-asm.S             | 12 ++--
 arch/riscv/kernel/mcount-dyn.S                | 20 +++----
 arch/riscv/kernel/mcount.S                    | 18 +++---
 arch/riscv/kernel/probes/rethook_trampoline.S |  4 +-
 arch/riscv/kernel/suspend_entry.S             |  4 +-
 arch/riscv/kernel/vdso/flush_icache.S         |  4 +-
 arch/riscv/kernel/vdso/getcpu.S               |  4 +-
 arch/riscv/kernel/vdso/rt_sigreturn.S         |  4 +-
 arch/riscv/kernel/vdso/sys_hwprobe.S          |  4 +-
 arch/riscv/kvm/vcpu_switch.S                  | 32 +++++------
 arch/riscv/lib/memcpy.S                       |  6 +-
 arch/riscv/lib/memmove.S                      | 57 +++++++++----------
 arch/riscv/lib/memset.S                       |  6 +-
 arch/riscv/lib/uaccess.S                      | 11 ++--
 arch/riscv/purgatory/entry.S                  | 16 ++----
 19 files changed, 124 insertions(+), 143 deletions(-)

-- 
2.42.0

