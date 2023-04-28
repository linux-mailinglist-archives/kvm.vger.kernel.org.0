Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EB56F1B8A
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbjD1P2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbjD1P2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:28:48 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C585FD3
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:28:12 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPOH-005zz5-IM; Fri, 28 Apr 2023 15:48:05 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH v3 00/19] Add RISC-V vector cryptographic instruction set support
Date:   Fri, 28 Apr 2023 15:47:38 +0100
Message-Id: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides an implementation for Zvbb, Zvbc, Zvkned, Zvknh, Zvksh, Zvkg, and Zvksed of the draft RISC-V vector cryptography extensions as per the v20230425 version of the specification(1) (6a7ae7f2). This is an update to the patchset submitted to qemu-devel on Monday, 17 Apr 2023 14:58:36 +0100.

v2:

    squashed commits into one commit per extension with separate commits for
    each refactoring
    unified trans_rvzvk*.c.inc files into one trans_rvvk.c.inc
    style fixes in insn32.decode and other files
    added macros for EGS values in translation functions.
    updated from v20230303 to v20230407 of the spec:
        Zvkb has been split into Zvbb and Zvbc
        vbrev, vclz, vctz, vcpop and vwsll have been added to Zvbb.

v3:

    New patch 03/19 removes redundant “cpu_vl == 0” checks from trans_rvv.c.inc
    Introduction of new tcg ops has been factored out of patch 11/19 and into 09/19
        These ops are now added to non riscv-specific files

As v20230425 is a freeze candidate, we are not expecting any significant changes to the specification or this patch series.

Please note that the Zvkt data-independent execution latency extension (and all extensions including it) has not been implemented, and we would recommend not using these patches in an environment where timing attacks are an issue.

Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.

For convenience we have created a git repo with our patches on top of a recent master. https://github.com/CodethinkLabs/qemu-ct

    https://github.com/riscv/riscv-crypto/releases

Thanks to those who have already reviewed:

    Richard Henderson richard.henderson@linaro.org
        [PATCH v2 02/17] target/riscv: Refactor vector-vector translation macro
        [PATCH v2 04/17] target/riscv: Move vector translation checks
        [PATCH v2 05/17] target/riscv: Refactor translation of vector-widening instruction
        [PATCH v2 07/17] qemu/bitops.h: Limit rotate amounts
        [PATCH v2 08/17] qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
        [PATCH v2 14/17] crypto: Create sm4_subword
    Alistair Francis alistair.francis@wdc.com
        [PATCH v2 02/17] target/riscv: Refactor vector-vector translation macro
    Philipp Tomsich philipp.tomsich@vrull.eu
        Various v1 reviews
    Christoph Müllner christoph.muellner@vrull.eu
        Various v1 reviews


Dickon Hood (3):
  target/riscv: Refactor translation of vector-widening instruction
  qemu/bitops.h: Limit rotate amounts
  target/riscv: Add Zvbb ISA extension support

Kiran Ostrolenk (5):
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Refactor vector-vector translation macro
  target/riscv: Refactor some of the generic vector functionality
  qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
  target/riscv: Add Zvknh ISA extension support

Lawrence Hunter (2):
  target/riscv: Add Zvbc ISA extension support
  target/riscv: Add Zvksh ISA extension support

Max Chou (3):
  crypto: Create sm4_subword
  crypto: Add SM4 constant parameter CK
  target/riscv: Add Zvksed ISA extension support

Nazar Kazakov (6):
  target/riscv: Remove redundant "cpu_vl == 0" checks
  target/riscv: Move vector translation checks
  tcg: Add andcs and rotrs tcg gvec ops
  target/riscv: Add Zvkned ISA extension support
  target/riscv: Add Zvkg ISA extension support
  target/riscv: Expose Zvk* and Zvb[b,c] cpu properties

 accel/tcg/tcg-runtime-gvec.c             |   11 +
 accel/tcg/tcg-runtime.h                  |    1 +
 crypto/sm4.c                             |   10 +
 include/crypto/sm4.h                     |    9 +
 include/qemu/bitops.h                    |   24 +-
 include/qemu/host-utils.h                |   54 ++
 include/tcg/tcg-op-gvec.h                |    4 +
 target/arm/tcg/crypto_helper.c           |   10 +-
 target/riscv/cpu.c                       |   39 +
 target/riscv/cpu.h                       |    8 +
 target/riscv/helper.h                    |   95 ++
 target/riscv/insn32.decode               |   58 ++
 target/riscv/insn_trans/trans_rvv.c.inc  |  174 ++--
 target/riscv/insn_trans/trans_rvvk.c.inc |  593 ++++++++++++
 target/riscv/meson.build                 |    4 +-
 target/riscv/op_helper.c                 |    6 +
 target/riscv/translate.c                 |    1 +
 target/riscv/vcrypto_helper.c            | 1052 ++++++++++++++++++++++
 target/riscv/vector_helper.c             |  243 +----
 target/riscv/vector_internals.c          |   81 ++
 target/riscv/vector_internals.h          |  228 +++++
 tcg/tcg-op-gvec.c                        |   23 +
 22 files changed, 2365 insertions(+), 363 deletions(-)
 create mode 100644 target/riscv/insn_trans/trans_rvvk.c.inc
 create mode 100644 target/riscv/vcrypto_helper.c
 create mode 100644 target/riscv/vector_internals.c
 create mode 100644 target/riscv/vector_internals.h

-- 
2.40.1

