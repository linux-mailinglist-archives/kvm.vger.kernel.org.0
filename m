Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162294FE72C
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358333AbiDLRg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358224AbiDLRgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F31D110F
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0093B212C2;
        Tue, 12 Apr 2022 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8IHuYKDjFmFsgVvZcSaFlGZmvYzo1JkAy+2BEq2zpQU=;
        b=pbbThmCznmi4swc8SSaKAXR1jaQrNV3iszHNM2lVUCydO1XWZp1yDSkqgXVGuazhGydSNt
        ul07nSyoZAGoLM97V3mhs99wEHDQU2R1sLdixEP8TENi/WlXkHBXz29JtJcrd4k+EtQQUV
        tE+39Rznuevs8T7pczug1zlXO7V+Yaw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7349913780;
        Tue, 12 Apr 2022 17:34:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RFFBGgy4VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:04 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 00/10] SMP Support for x86 UEFI Tests
Date:   Tue, 12 Apr 2022 19:33:57 +0200
Message-Id: <20220412173407.13637-1-varad.gautam@suse.com>
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

This series brings multi-vcpu support to UEFI tests on x86.

Most of the necessary AP bringup code already exists within kvm-unit-tests'
cstart64.S, and has now been either rewritten in C or moved to a common location
to be shared between EFI and non-EFI test builds.

A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.

Changes in v2:
- rebase onto kvm-unit-tests@1a4529ce83 + seanjc's percpu apic_ops series [1].
- split some commits for readability.

The series has been tested with this patch [2] which fixes EFI pagetable setup.

Git branch: https://github.com/varadgautam/kvm-unit-tests/commits/ap-boot-v2/
[1] https://lore.kernel.org/all/20220121231852.1439917-1-seanjc@google.com/
[2] https://lore.kernel.org/kvm/20220406123312.12986-1-varad.gautam@suse.com/
v1: https://lore.kernel.org/all/20220408103127.19219-1-varad.gautam@suse.com/

Varad Gautam (10):
  x86: Move ap_init() to smp.c
  x86: Move load_idt() to desc.c
  x86: desc: Split IDT entry setup into a generic helper
  x86: Move load_gdt_tss() to desc.c
  x86: efi: Stop using UEFI-provided stack
  x86: efi: Stop using UEFI-provided %gs for percpu storage
  x86: efi, smp: Transition APs from 16-bit to 32-bit mode
  x86: Move 32-bit bringup routines to start32.S
  x86: efi, smp: Transition APs from 32-bit to 64-bit mode
  x86: Move ap_start64 and save_id to setup.c

 lib/x86/asm/setup.h       |   3 ++
 lib/x86/desc.c            |  39 +++++++++++---
 lib/x86/desc.h            |   3 ++
 lib/x86/setup.c           |  59 ++++++++++++++++-----
 lib/x86/smp.c             |  88 +++++++++++++++++++++++++++++++-
 lib/x86/smp.h             |   1 +
 x86/cstart64.S            | 105 ++------------------------------------
 x86/efi/crt0-efi-x86_64.S |   3 ++
 x86/efi/efistart64.S      |  69 ++++++++++++++++++++-----
 x86/start32.S             | 102 ++++++++++++++++++++++++++++++++++++
 10 files changed, 336 insertions(+), 136 deletions(-)
 create mode 100644 x86/start32.S

-- 
2.32.0

