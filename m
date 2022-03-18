Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978F94DD744
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiCRJq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiCRJqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:46:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E63F2C3DFE;
        Fri, 18 Mar 2022 02:45:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CD3571F38E;
        Fri, 18 Mar 2022 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647596735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=oGA/yvm/gqNdpwaPx6sBtB0hVGICo80CcKhGUxQPfB8=;
        b=qS/TaOvW+jrEBOjhneobfyyc0+JuCwZ692tU6w6TyswDa7P3Cyc52JAq0jQPjGcw0N/NcI
        LfinwTiWZgmgko+NPkErtKfq02RmpH0MCS40MiCpqMzwuxdHC8EVY6LCaaMou9rH1YwZMY
        tWHwv2WYhH2XVi+necqGlv/nChi6+OE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647596735;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=oGA/yvm/gqNdpwaPx6sBtB0hVGICo80CcKhGUxQPfB8=;
        b=e45uj0E5nYc794ludXFkBpocxN72v8cUw5gNPbWgJevgB6bjbEm+2j8I0wEmehJ0eOnFSD
        3UUOtgSnU4l/+ZCg==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 62131A3B81;
        Fri, 18 Mar 2022 09:45:35 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org
Cc:     bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 0/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Date:   Fri, 18 Mar 2022 10:45:28 +0100
Message-Id: <20220318094532.7023-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

   This is the version 6 of the patch written to add tests for
   AMD SEV-ES #VC handling. This version attempts to
   address review comments to the previous version of the patch in
   https://lore.kernel.org/kvm/20220208162623.18368-1-vkarasulli@suse.de/.

   Changes in this version:
   1. The patch in the previous version is split into 4 parts.
   2. Constants in function sev_es_nae_mmio are replaced by macros.

Thanks,
Vasant

Vasant Karasulli (4):
  x86/tests: Add Kconfig options for testing AMD SEV related features.
  x86/tests: Add KUnit based tests to validate Linux's VC handling for
    instructions cpuid and wbinvd. These tests: 1. install a kretprobe
    on the #VC handler (sev_es_ghcb_hv_call, to    access GHCB
    before/after the resulting VMGEXIT). 2. trigger an NAE by executing
    either cpuid or wbinvd. 3. check that the kretprobe was hit with the
    right exit_code available    in GHCB.
  x86/tests: Add KUnit based tests to validate Linux's VC handling for
      instructions accessing registers such as MSR and DR7. These tests:
        1. install a kretprobe on the #VC handler (sev_es_ghcb_hv_call,
    to        access GHCB before/after the resulting VMGEXIT).     2.
    trigger an NAE by accessing either MSR or DR7.     3. check that the
    kretprobe was hit with the right exit_code available        in GHCB.
  x86/tests: Add KUnit based tests to validate Linux's VC handling for
          IO instructions. These tests:         1. install a kretprobe
    on the #VC handler (sev_es_ghcb_hv_call, to            access GHCB
    before/after the resulting VMGEXIT).         2. trigger an NAE by
    issuing an IO instruction.         3. check that the kretprobe was
    hit with the right exit_code available            in GHCB.

 arch/x86/Kbuild              |   2 +
 arch/x86/Kconfig.debug       |  16 ++++
 arch/x86/kernel/Makefile     |   7 ++
 arch/x86/tests/Makefile      |   3 +
 arch/x86/tests/sev-test-vc.c | 155 +++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+)
 create mode 100644 arch/x86/tests/Makefile
 create mode 100644 arch/x86/tests/sev-test-vc.c


base-commit: 09688c0166e76ce2fb85e86b9d99be8b0084cdf9
prerequisite-patch-id: b74bc39d7ca69ad86b5f9090047c44ab039f4622
prerequisite-patch-id: a53a291b59b4ceaffa25a9a08dfa08b5a78a01b9
--
2.32.0

