Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919256AFEF9
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 07:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCHGgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 01:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCHGga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 01:36:30 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3969FBCD;
        Tue,  7 Mar 2023 22:36:29 -0800 (PST)
Received: by gandalf.ozlabs.org (Postfix, from userid 1003)
        id 4PWjJS1PRgz4xDk; Wed,  8 Mar 2023 17:36:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.org;
        s=201707; t=1678257384;
        bh=xlh8AKwmpAujiBC2TZ8TY34N1ZFaVIBckKl457W8J10=;
        h=Date:From:To:Cc:Subject:From;
        b=vDkN/hgStBQKJlPuU1xJd5EiafxrU6GgJW87tN1Bsh1jcJ6eqKgHUSR/7DQPbFRRC
         pQUCfITFhoyjG721Ii92hmEeKoRTeBMffaasIyw6wVV7cQByRyKyv5Nr/I4EQOOA2V
         vjR4syd9hFNejQOPiW3oYtYqceouA4GdcsP792dvibsGZUW/HnPMDgT46A+bOpzPeR
         //Kh7dznGphnJN+RsuhwGpLPqtF8eC+SVSoAdnFHqIfsjfguIrscaKZZnx+7E+nRR+
         dvCEjFBXqfGbhC0pJ5Z8Vj4U1+zUKkv8MGqkBAI9P22gr96bZftMh/23DpM10PBbPW
         uvZ69+Z8OSauA==
Date:   Wed, 8 Mar 2023 17:33:43 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     Michael Neuling <mikey@neuling.org>,
        Nick Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH 0/3] powerpc/kvm: Enable HV KVM guests to use prefixed
 instructions to access emulated MMIO
Message-ID: <ZAgsR04beDcARCiw@cleo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series changes the powerpc KVM code so that HV KVM can fetch
prefixed instructions from the guest in those situations where there
is a need to emulate an instruction, which for HV KVM means emulating
loads and stores to emulated MMIO devices.  (Prefixed instructions
were introduced with POWER10 and Power ISA v3.1, and consist of two
32-bit words, called the prefix and the suffix.)

The instruction analysis code in arch/powerpc/lib/sstep.c has already
been extended to handle prefixed loads and stores, so all we have to
do in HV KVM is to fetch the suffix when necessary and pass it to
analyse_instr().

Since PR KVM doesn't yet handle prefixed instructions, we disable PR
KVM guests from using prefixed instructions (this is done using the
FSCR).

Paul.

 arch/powerpc/include/asm/kvm_host.h      |  4 ++--
 arch/powerpc/include/asm/kvm_ppc.h       | 37 +++++++++++++++++++++++---------
 arch/powerpc/include/asm/reg.h           |  1 +
 arch/powerpc/kvm/book3s.c                | 32 ++++++++++++++++++++++-----
 arch/powerpc/kvm/book3s_64_mmu_hv.c      | 26 ++++++++++++++++------
 arch/powerpc/kvm/book3s_hv.c             | 24 ++++++++++++++-------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  6 +++---
 arch/powerpc/kvm/book3s_paired_singles.c |  4 +++-
 arch/powerpc/kvm/book3s_pr.c             | 22 ++++++++++---------
 arch/powerpc/kvm/book3s_rmhandlers.S     |  1 +
 arch/powerpc/kvm/booke.c                 | 12 +++++++----
 arch/powerpc/kvm/bookehv_interrupts.S    |  2 +-
 arch/powerpc/kvm/e500_mmu_host.c         |  4 ++--
 arch/powerpc/kvm/emulate.c               |  8 ++++++-
 arch/powerpc/kvm/emulate_loadstore.c     |  8 +++----
 arch/powerpc/kvm/powerpc.c               |  4 ++--
 16 files changed, 136 insertions(+), 59 deletions(-)
