Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0B4F92FE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiDHKdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiDHKdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04391AB9D5
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 556BD1FD07;
        Fri,  8 Apr 2022 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=30t+leXsBt6I0ScruLT0TK74pCQ5UrRcFm0FAvno2jA=;
        b=m2sCxe28nZup20kmCuWd1wlEGAOAqZtyhmDr/98Iw9IS4p35Dau7zfYG8taMPZc1HXCi5Q
        dKhQDzPdPlP/fmoFi9S2JtjjlHSaONLtHNLZZFefSD+BoGfbWVp9UZ1K7xuQzMGfgbH90U
        u/JEZMyVy+27isBHpN665l4MeEQ6n44=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B3583132B9;
        Fri,  8 Apr 2022 10:31:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jmi1KfwOUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:24 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 0/9] SMP Support for x86 UEFI Tests
Date:   Fri,  8 Apr 2022 12:31:18 +0200
Message-Id: <20220408103127.19219-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Git branch: https://github.com/varadgautam/kvm-unit-tests/commits/ap-boot-v1

Varad Gautam (9):
  x86: Move ap_init() to smp.c
  x86: Move load_idt() to desc.c
  x86: desc: Split IDT entry setup into a generic helper
  x86: efi, smp: Transition APs from 16-bit to 32-bit mode
  x86: Move 32-bit bringup routines to start32.S
  x86: efi, smp: Transition APs from 32-bit to 64-bit mode
  x86: Move load_gdt_tss() to desc.c
  x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI
  x86: setup: Serialize ap_start64 with a spinlock

 lib/x86/asm/setup.h       |   3 ++
 lib/x86/desc.c            |  39 +++++++++++---
 lib/x86/desc.h            |   3 ++
 lib/x86/setup.c           |  65 +++++++++++++++++-----
 lib/x86/smp.c             |  89 +++++++++++++++++++++++++++++-
 lib/x86/smp.h             |   1 +
 x86/cstart64.S            | 111 ++------------------------------------
 x86/efi/crt0-efi-x86_64.S |   3 ++
 x86/efi/efistart64.S      |  73 ++++++++++++++++++++-----
 x86/start32.S             | 102 +++++++++++++++++++++++++++++++++++
 10 files changed, 348 insertions(+), 141 deletions(-)
 create mode 100644 x86/start32.S

-- 
2.32.0

