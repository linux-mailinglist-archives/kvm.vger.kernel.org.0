Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01350FC2F
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349613AbiDZLrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349605AbiDZLrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C0E3B3E6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9DAAC1F747;
        Tue, 26 Apr 2022 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0FowHxVZfXs06uskdl+dM3gPCzfAn+oqgnWYGXGvHtI=;
        b=UdqM7z4CfNrlFNFRQAhFt/YFBD1N2a69+zhVkY4LEINHwV+YABq0mn0l0iPY1WYtdEH1H3
        QFXTD+eVNK5XBm3x3aAJrij3uF0oklfqcad2vpiMxbB04MbiWK8myxXibnPLJKyAwdPtGP
        ySqaHpjgYMlm3RTVJYye6299M8ixNZo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AE3113223;
        Tue, 26 Apr 2022 11:44:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ywc6AArbZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:09 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 00/11] SMP Support for x86 UEFI Tests
Date:   Tue, 26 Apr 2022 13:43:41 +0200
Message-Id: <20220426114352.1262-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v3:
- Unbreak i386 build, ingest seanjc's reviews from v2.

Git branch: https://github.com/varadgautam/kvm-unit-tests/commits/ap-boot-v3/
v2: https://lore.kernel.org/kvm/20220412173407.13637-1-varad.gautam@suse.com/

Varad Gautam (11):
  x86: Share realmode trampoline between i386 and x86_64
  x86: Move ap_init() to smp.c
  x86: Move load_idt() to desc.c
  x86: desc: Split IDT entry setup into a generic helper
  x86: Move load_gdt_tss() to desc.c
  x86: efi: Provide a stack within testcase memory
  x86: efi: Provide percpu storage
  x86: efi, smp: Transition APs from 16-bit to 32-bit mode
  x86: Move 32-bit bringup routines to start32.S
  x86: efi, smp: Transition APs from 32-bit to 64-bit mode
  x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI

 lib/alloc_page.h          |   3 +
 lib/x86/apic.c            |   2 -
 lib/x86/asm/setup.h       |   3 +
 lib/x86/desc.c            |  39 +++++++++--
 lib/x86/desc.h            |   3 +
 lib/x86/setup.c           |  84 ++++++++++++++++++++----
 lib/x86/smp.c             | 132 +++++++++++++++++++++++++++++++++++++-
 lib/x86/smp.h             |  10 +++
 x86/cstart.S              |  38 +----------
 x86/cstart64.S            | 120 +---------------------------------
 x86/efi/crt0-efi-x86_64.S |   3 +
 x86/efi/efistart64.S      |  81 ++++++++++++++---------
 x86/start16.S             |  27 ++++++++
 x86/start32.S             | 102 +++++++++++++++++++++++++++++
 x86/svm_tests.c           |  10 ++-
 15 files changed, 443 insertions(+), 214 deletions(-)
 create mode 100644 x86/start16.S
 create mode 100644 x86/start32.S

-- 
2.32.0

