Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDB076957B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjGaMEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGaME3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:29 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E68BD7
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:28 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-3a5ad44dc5aso3320447b6e.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805068; x=1691409868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hDob3MHXXNcaLiqNKvSqoQT9DoNULCJTTniscL7mVbU=;
        b=DHJC6BqFq3PMjUazpN0Ywc4O1nr3GirvZZfsldgIrST31HRI3mIKcXzmiAuejNlzc/
         +nIbGTW9ARdC7geBq7cs4o7If87luUrpIVQaboK6Tjwc2wJbLcmcQAybRmLwqESRDfM4
         WyfGFaOsQmMqwZYU2imyZqkLDVY3dcvroZEI3Z2SPJrZ9SiHRqCwbQtd17FxpFK8Y6hn
         96oYlp0JgwPofsFFdca3/dz26W8+0YRlBU71r8PFz9gWL6BO5O/hxlk5EdznxKglTTh5
         vhX9SQ3NE4CtpwQ/mqYhz5KFiLUYcT6eAmeFo6wicvL/WZyaW4rPFwPYMUIw1qnJfzDQ
         anPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805068; x=1691409868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDob3MHXXNcaLiqNKvSqoQT9DoNULCJTTniscL7mVbU=;
        b=OXh37MbFjVskVtHYO0sHbORN9LXDM3RErHbBw7mNmZ19zEoaOWmxB6n8PS7Z84fJJq
         LO/c6CBASdm20iJSJ3qQAie6D/IZTPJ/128B6o0Ni7pc28sPuMknvE+CX/F0oLrL5gT3
         F00S0kM708rd4IQz0W/fZGxRD2R1a/UBGuIVFSVYLD9/jRK5bcWdnrLoaGQAcdKGxhDr
         5Sem7Og3I54cCMONrwEL5hfhAUNTodZO8yhxGvXIvtjkr8eIgzZk6zTy6kcK9ZVh0JHL
         i1RP9JqI74AYAhg5GSpU8y37P54+cp6zmGzjECMnaS97FME/x3CED1BF5vJ1XBvjn85V
         SFbg==
X-Gm-Message-State: ABy/qLZfJ0KdNn6rfmVv7TENnFklzrDdIEQdFlua928LVo07dGcy3n9q
        BbSISN6jr3oK+KZue4qnMSKTfA==
X-Google-Smtp-Source: APBJJlFMe5jG80omf6JvGauFmZqkxjhs7/FamgLTrJ9bv7s36827emxke9CVSdmEXkYPLRXM77u2AA==
X-Received: by 2002:a05:6808:2029:b0:3a4:38fa:2e08 with SMTP id q41-20020a056808202900b003a438fa2e08mr9660300oiw.7.1690805067774;
        Mon, 31 Jul 2023 05:04:27 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:27 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 0/6] RISC-V: KVM: change get_reg/set_reg error codes
Date:   Mon, 31 Jul 2023 09:04:14 -0300
Message-ID: <20230731120420.91007-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
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

Hi,

This work was motivated by the changes made in QEMU in commit df817297d7
("target/riscv: update multi-letter extension KVM properties") where it
was required to use EINVAL to try to assess whether a given extension is
available in the host.

It turns out that the RISC-V KVM module makes regular use of the EIVAL
error code in all kvm_get_one_reg() and kvm_set_one_reg() callbacks,
which is not ideal. For example, ENOENT is a better error code for the
case where a given register does not exist. While at it I decided to
take a look at other error codes from these callbacks, comparing them
with how other archs (ARM) handles the same error types, and changed
some of the EOPNOTSUPP instances to either ENOENT or EBUSY.

I am aware that changing error codes can be problematic to existing
userspaces. I took a look and no other major userspace (checked crosvm,
rust-vmm, QEMU, kvmtool), aside from QEMU now checking for EIVAL (and we
can't change that because of backwards compat for that particular case
we're covering), will be impacted by this kind of change since they're
all checking for "return < 0 then ..." instead of doing specific error
handling based on the error value. This means that we're still in good
time to make this kind of change while we're still in the initial steps
of the RISC-V KVM ecossystem support.

Patch 3 happens to also change the behavior of the set_reg() for
zicbom/zicboz block sizes. Instead of always erroring out we'll check if
userspace is writing the same value that the host uses. In this case,
allow the write to succeed (i.e. do nothing). This avoids the situation
in which userspace reads cbom_block_size, find out that it's set to X,
and then can't write the same value back to the register. It's a QOL
improvement to allow userspace to be lazier when reading/writing regs. A
similar change was also made in patch 4.

Patches are based on top of riscv_kvm_queue.

Daniel Henrique Barboza (6):
  RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
  RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
  RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
  RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
  RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
  docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG

 Documentation/virt/kvm/api.rst |  2 ++
 arch/riscv/kvm/aia.c           |  4 +--
 arch/riscv/kvm/vcpu_fp.c       | 12 ++++----
 arch/riscv/kvm/vcpu_onereg.c   | 52 ++++++++++++++++++++--------------
 arch/riscv/kvm/vcpu_sbi.c      | 16 ++++++-----
 arch/riscv/kvm/vcpu_timer.c    | 11 +++----
 6 files changed, 55 insertions(+), 42 deletions(-)

-- 
2.41.0

