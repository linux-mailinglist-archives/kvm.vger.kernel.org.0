Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74A276EF89
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbjHCQdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbjHCQdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:15 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521C730D3
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:10 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6bca88c3487so1000114a34.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080389; x=1691685189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ILMTrWynO1XeQZo7Pg/qrvjmupOG1msKuU2sVES4A7U=;
        b=FVmdL9BKhYm0oI0J4dt4CGErWoGauSC4HRBJ5n1Etp1kEGIvThQH1Dh9CwrqzeD4IJ
         zwL8q3eyWF7EBEkfjkbJjM89k6iUWCH2y/BdjTIqnPb8iZFKRYTMHjxg2+8z8ahVZKFJ
         SPHAWwroS0984S4jWk1AxN+pNYputTym03cih2/4osNfduxZUZuXYd+6C8yH+fpbjDg4
         NhuCCWcT/L0CjreDuzfEuzfWWz6oPBgNmwg90LRZiwEVOcsWEuMp7IAm1b4KUtUvUMv7
         jJR+kDHl0BYDTieC8D8zTDz4EAsEulTGWrE3x6QeKTQIH0TD5gDjjjTVvp7XkZFvtEyW
         qHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080389; x=1691685189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILMTrWynO1XeQZo7Pg/qrvjmupOG1msKuU2sVES4A7U=;
        b=JL5fTMzsnNKMRtmw3nK7YArP17C9qpBcTuSlWKAlKXHGvs7QbANHc9lGtWYP0x0YZN
         FQRc1AINgVnkhBDceGUkf0twtO40fyJ5gShuXZ8u2xvI0YjKqiK3X5mcJbr3lYNhon1K
         UU1woK8/GgnkiIr2KBrurfJI0VN4NmP+sUiwE4nBJBQ6zL5HApjjrYPr1kR4wk9SAwvf
         nV/lqc8qMcwJiHdZW57JnZ/Hcj4N6SbWfB11Jj2P7zO09j6MOJDJ5EaBGMmRGrO9CkMn
         0Ea96rCcls0xUdzqRdqPqFkVp8QQQFZc1BNnAXFxCJnKNos90UjEqAjn9Eck1iZ7enBm
         vhjg==
X-Gm-Message-State: ABy/qLZmeQHwrw8+m5u3VI53XvemnUqhQw7vDoh+r4CqKhJ6xX4R80VJ
        hIiLTf5m1Y+2Olg5ME583PgPiQ==
X-Google-Smtp-Source: APBJJlFtQ/kKMZtlpg91FxETCiMj0acqjG/Nc1UJc9kNAWDnlX6fQ7+E3ozHQnRPcxlPa2jRfPNJng==
X-Received: by 2002:a05:6870:f623:b0:1a6:c968:4a15 with SMTP id ek35-20020a056870f62300b001a6c9684a15mr21181995oab.4.1691080388818;
        Thu, 03 Aug 2023 09:33:08 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:08 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 00/10] RISC-V: KVM: change get_reg/set_reg error code
Date:   Thu,  3 Aug 2023 13:32:52 -0300
Message-ID: <20230803163302.445167-1-dbarboza@ventanamicro.com>
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

This version includes a diff that Andrew mentioned in v2 [1] that I
missed. They were squashed into patch 1.

No other changes made. Patches rebased on top of riscv_kvm_queue.

Changes from v3:
- patch 1:
  - added missing EINVAL - ENOENT conversions
- v3 link: https://lore.kernel.org/kvm/20230803140022.399333-1-dbarboza@ventanamicro.com/

[1] https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventanamicro.com/


Andrew Jones (1):
  RISC-V: KVM: Improve vector save/restore errors

Daniel Henrique Barboza (9):
  RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
  RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
  RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
  RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
  RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
  RISC-V: KVM: avoid EBUSY when writing same ISA val
  RISC-V: KVM: avoid EBUSY when writing the same machine ID val
  RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
  docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG

 Documentation/virt/kvm/api.rst |  2 +
 arch/riscv/kvm/aia.c           |  4 +-
 arch/riscv/kvm/vcpu_fp.c       | 12 +++---
 arch/riscv/kvm/vcpu_onereg.c   | 74 ++++++++++++++++++++++------------
 arch/riscv/kvm/vcpu_sbi.c      | 16 ++++----
 arch/riscv/kvm/vcpu_timer.c    | 11 ++---
 arch/riscv/kvm/vcpu_vector.c   | 60 ++++++++++++++-------------
 7 files changed, 107 insertions(+), 72 deletions(-)

-- 
2.41.0

