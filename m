Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC37F56C6A2
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiGIEVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiGIEVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6650D4E62C;
        Fri,  8 Jul 2022 21:21:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so3693742pjo.3;
        Fri, 08 Jul 2022 21:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HfxesvineA4lvvWA39Rhk5vO9ldVF5vKgZoZqN8KzAg=;
        b=jkbZ4X55kBzGE43KDHuVaa+mNhz/mniIFifPbU2PnSiHJCLz4j+hGqF/KP9wlPkWzf
         QTtRuKYyw2gAEfq5Qr0gn9mEkfiSXNf7T+3OuOfeJwlZEPDyuSg7Iox3HN4Hs3t7Yg5p
         aobyjtXKKfedI0CTrZaHGF8lGQx3OA0YUE6jh8o6avgEzIVMlyFhivD1wbHBdX/XjUAO
         7kGwlUepcsIT2sR0CscKM/z0hjQfhPZEIVvLQwsyJj+SiLTXesRkCvuqGsEuLGsElCoo
         7rpTWhkhwYBHnkt/CFnz0GDtOYg2D+tXzYL9scs5R9nXAuXp7elOv7BcULLSBNo8QsUQ
         XTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HfxesvineA4lvvWA39Rhk5vO9ldVF5vKgZoZqN8KzAg=;
        b=4oCQ0oRyyNtx7AL63Qm8ZzxUAnZNQOFTDVZlHZMCltHaaDCYbEXt8RonOppo+bHa2T
         WiZwlSJ7kLc3mS+dMqL+SuVMvS/QTmkasRKqWK5B23ita5V7Xj1Izbpu64egvoRzHyQZ
         zGVwIRUJmauefmnuUUJoe5HwCvXQTR+lnUukR669Q96tX4XISuQzxnrx4VoDGp5iStzt
         bgWhn+mP7HoT0S5S2dLI03gHyawzrMFMn58yF/yBzehyFbz8cWhys8Fj9bJF0KcCWYYX
         stkjw3EcLFXZdbTBMp6vJeb2/LYTdeeMW7411jz5yp5Ii4nneIxmdhJr5ymG/eqQCQLX
         6vJg==
X-Gm-Message-State: AJIora8pvctylhYI4RBbwPe1xk4Ns8iES5Hdv6JJ2A1/HjC490bsLjrF
        cRCbyC6tgk29udrkTv3UJjs=
X-Google-Smtp-Source: AGRyM1tKZFbicaQ6X8X63qh/3nFn1Iti2dztUHzcNQoixiHnU66TeRKYrUAa+mAqIFWQJ8cJqw7JWw==
X-Received: by 2002:a17:902:d488:b0:16a:158e:dd19 with SMTP id c8-20020a170902d48800b0016a158edd19mr6977288plg.105.1657340479890;
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id e3-20020a170902784300b001641b2d61d4sm350580pln.30.2022.07.08.21.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8067A103962; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 06/12] Documentation: kvm: tdx-tdp-mmu: Add blank line padding for lists
Date:   Sat,  9 Jul 2022 11:20:32 +0700
Message-Id: <20220709042037.21903-7-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are many "unexpected indentations"-"block quote"-"bullet list"
warnings that are caused by missing blank line padding on
bullet lists at tdx-tdp-mmu.rst.

Add the padding to fix the warnings.

Fixes: 7af4efe3263854 ("KVM: x86: design documentation on TDX support of x86 KVM TDP MMU")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/tdx-tdp-mmu.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/virt/kvm/tdx-tdp-mmu.rst b/Documentation/virt/kvm/tdx-tdp-mmu.rst
index 6d63bb75f785ab..c9d5fc43a6ca7a 100644
--- a/Documentation/virt/kvm/tdx-tdp-mmu.rst
+++ b/Documentation/virt/kvm/tdx-tdp-mmu.rst
@@ -63,32 +63,39 @@ Instead, TDX SEAMCALL API is used.  Several SEAMCALLs correspond to operation on
 the EPT entry.
 
 * TDH.MEM.SEPT.ADD():
+
   Add a secure EPT page from the secure EPT tree.  This corresponds to updating
   the non-leaf EPT entry with present bit set
 
 * TDH.MEM.SEPT.REMOVE():
+
   Remove the secure page from the secure EPT tree.  There is no corresponding
   to the EPT operation.
 
 * TDH.MEM.SEPT.RD():
+
   Read the secure EPT entry.  This corresponds to reading the EPT entry as
   memory.  Please note that this is much slower than direct memory reading.
 
 * TDH.MEM.PAGE.ADD() and TDH.MEM.PAGE.AUG():
+
   Add a private page to the secure EPT tree.  This corresponds to updating the
   leaf EPT entry with present bit set.
 
 * THD.MEM.PAGE.REMOVE():
+
   Remove a private page from the secure EPT tree.  There is no corresponding
   to the EPT operation.
 
 * TDH.MEM.RANGE.BLOCK():
+
   This (mostly) corresponds to clearing the present bit of the leaf EPT entry.
   Note that the private page is still linked in the secure EPT.  To remove it
   from the secure EPT, TDH.MEM.SEPT.REMOVE() and TDH.MEM.PAGE.REMOVE() needs to
   be called.
 
 * TDH.MEM.TRACK():
+
   Increment the TLB epoch counter. This (mostly) corresponds to EPT TLB flush.
   Note that the private page is still linked in the secure EPT.  To remove it
   from the secure EPT, tdh_mem_page_remove() needs to be called.
@@ -110,25 +117,34 @@ Dropping private page and TLB shootdown
 The procedure of dropping the private page looks as follows.
 
 1. TDH.MEM.RANGE.BLOCK(4K level)
+
    This mostly corresponds to clear the present bit in the EPT entry.  This
    prevents (or blocks) TLB entry from creating in the future.  Note that the
    private page is still linked in the secure EPT tree and the existing cache
    entry in the TLB isn't flushed.
+
 2. TDH.MEM.TRACK(range) and TLB shootdown
+
    This mostly corresponds to the EPT TLB shootdown.  Because all vcpus share
    the same Secure EPT, all vcpus need to flush TLB.
+
    * TDH.MEM.TRACK(range) by one vcpu.  It increments the global internal TLB
      epoch counter.
    * send IPI to remote vcpus
    * Other vcpu exits to VMM from guest TD and then re-enter. TDH.VP.ENTER().
    * TDH.VP.ENTER() checks the TLB epoch counter and If its TLB is old, flush
      TLB.
+
    Note that only single vcpu issues tdh_mem_track().
+
    Note that the private page is still linked in the secure EPT tree, unlike the
    conventional EPT.
+
 3. TDH.MEM.PAGE.PROMOTE, TDH.MEM.PAGEDEMOTE(), TDH.MEM.PAGE.RELOCATE(), or
    TDH.MEM.PAGE.REMOVE()
+
    There is no corresponding operation to the conventional EPT.
+
    * When changing page size (e.g. 4K <-> 2M) TDH.MEM.PAGE.PROMOTE() or
      TDH.MEM.PAGE.DEMOTE() is used.  During those operation, the guest page is
      kept referenced in the Secure EPT.
-- 
An old man doll... just what I always wanted! - Clara

