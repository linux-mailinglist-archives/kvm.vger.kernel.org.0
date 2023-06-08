Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CBE72821C
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbjFHODk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbjFHODj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:03:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F6198C;
        Thu,  8 Jun 2023 07:03:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 921EA21A14;
        Thu,  8 Jun 2023 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686233015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xLZHfs84yXjkQpWBr2AnjtulNIQynm+15xDEC6bGzuQ=;
        b=B1BzVMJKO7TeqDYmcc2zaHSMN6eIb/lygNZttFSrSJoMUQLDWuQmBUvxa3GM+u6Ar6tK8D
        fxHuEZv/8kO6nBmS7dq40Wp9OJc49L42sD6N3s2LIzcNQx7M1ECOJ0ObJASujCtaIrUlpM
        8COeN5AFtNL1FH3j3PVvtFzlinSONV0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B625138E6;
        Thu,  8 Jun 2023 14:03:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 21U+BbffgWRCbwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 08 Jun 2023 14:03:35 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: [RFC PATCH 0/3] x86/paravirt: Get rid of paravirt patching
Date:   Thu,  8 Jun 2023 16:03:30 +0200
Message-Id: <20230608140333.4083-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
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

This is a small series getting rid of paravirt patching by switching
completely to alternative patching for the same functionality.

The basic idea is to add the capability to switch from indirect to
direct calls via a special alternative patching option.

This removes _some_ of the paravirt macro maze, but most of it needs
to stay due to the need of hiding the call instructions from the
compiler in order to avoid needless register save/restore.

What is going away is the nasty stacking of alternative and paravirt
patching and (of course) the special .parainstructions linker section.

I have tested the series on bare metal and as Xen PV domain to still
work.

RFC because I'm quite sure there will be some objtool work needed
(at least removing the specific paravirt handling).

Juergen Gross (3):
  x86/paravirt: move some functions and defines to alternative
  x86/alternative: add indirect call patching
  x86/paravirt: switch mixed paravirt/alternative calls to alternative_2

 arch/x86/include/asm/alternative.h        | 26 +++++-
 arch/x86/include/asm/paravirt.h           | 39 ++-------
 arch/x86/include/asm/paravirt_types.h     | 68 +++-------------
 arch/x86/include/asm/qspinlock_paravirt.h |  4 +-
 arch/x86/include/asm/text-patching.h      | 12 ---
 arch/x86/kernel/alternative.c             | 99 +++++++++++------------
 arch/x86/kernel/callthunks.c              | 17 ++--
 arch/x86/kernel/kvm.c                     |  4 +-
 arch/x86/kernel/module.c                  | 20 ++---
 arch/x86/kernel/paravirt.c                | 54 ++-----------
 arch/x86/kernel/vmlinux.lds.S             | 13 ---
 arch/x86/tools/relocs.c                   |  2 +-
 arch/x86/xen/irq.c                        |  2 +-
 13 files changed, 111 insertions(+), 249 deletions(-)

-- 
2.35.3

