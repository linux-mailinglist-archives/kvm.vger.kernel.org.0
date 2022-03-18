Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A708C4DD867
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 11:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiCRKtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 06:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiCRKsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 06:48:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877DE2C578B;
        Fri, 18 Mar 2022 03:46:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 38854210EA;
        Fri, 18 Mar 2022 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647600409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MM0r6zvbwpydkDT1R+F5hWqdXa0Z4qMXYmUqvX1aq+0=;
        b=DAqHahI8SUMzWGkPbqH5Mq42I+OEoNkvTWiw5arB+cdPMBbGR9lroaBnc8ZrbQkkgucBUV
        UbgWFfgRm5siAM3mZbr4a/xyAAiPVRdVWBKDZHvmt/INrYk+c/7Aqpalss0w20PEYODiR6
        WK+iSOZZMJPwJYHnxYTTcB4VjnvcF8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647600409;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MM0r6zvbwpydkDT1R+F5hWqdXa0Z4qMXYmUqvX1aq+0=;
        b=2ALG9+Ur1c+C7IND5+u9jvYZx36lL1rhRQQoms1FcFNfJRtuXz3iZHyH+Y0uKOdY9dHIeg
        dO2HDmsMt2rdUICg==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id D713BA3B81;
        Fri, 18 Mar 2022 10:46:48 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org
Cc:     bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 0/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Date:   Fri, 18 Mar 2022 11:46:42 +0100
Message-Id: <20220318104646.8313-1-vkarasulli@suse.de>
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

PS: I am resending this version because I made a mistake in the subject.
Apologies for the spam.

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

