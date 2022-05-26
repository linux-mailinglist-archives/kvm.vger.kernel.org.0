Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA5D53556C
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349090AbiEZVYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiEZVYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:21 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028974C7AA
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so1484521pff.13
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Nj11sMCgQgDAP7C4SyDQj5semkrlbFX/aMEmua6TrWo=;
        b=K72D1I+pKpn91nJKzkfGAnssAW78lSoqkoj7q0Fsy0PcP782i5+XHpwQ+31nJDR/F5
         T2ZQrkYnsoBofCYqYLMmMnYXnzYYVAEb5GSsjU+RSn6T+yYyL5K5PGhP15hyJvwlxtuK
         w3llFQUFkG5IomCwYNqArB0n3jnBFjQAsSzXClsbEumISzv2WFFx4zMofHOp8XqebpbP
         sbTmErvnivyyYdMEsHKht9i8830EY5MELCPHvwaaEp2G952pkNy796Ct4leLH56qcQhJ
         rBdNlJp6c/UI0ykSoDOUe4IdQBZkUQQhh8pRrSc2iBCwh40cRzGcB5O5BCQ0Jc0XMu52
         tlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Nj11sMCgQgDAP7C4SyDQj5semkrlbFX/aMEmua6TrWo=;
        b=gf53jdzKZf598vwC343H/0z19s6P4k9oaoBCqPKb5uww8nAOfLjtQNfAB6pPSluw03
         BiC/NLS3mpsthgmt35CZBDfidDGODyG+iNe2xl41sNl4I9i+paqnE3WJWA6wF01G2Xeo
         vY834d/8VwdfXYPJi3K762T/kn2eZcMJjXOpQVpNEDuAMe5TGDkgZTLNWSHdKG+DbdGM
         v2m6ewDNFPkcz1rGNg6a2RIW8kilLnK+ztL16OZsDMzdx1H6uRyVFTwpCHevPRRHSNL4
         vaYI+V4Jj2z8Zk0MVFw6XQhihvp1c8m4i8V/DJy9JmYiiqVL+6Nr1OSA0fE8sRwSAPYe
         ZxIA==
X-Gm-Message-State: AOAM5337FWOdtvFrzwnB51+COvA8qGBEOej1Y5W+a3rIKluxg2/6oBNR
        UYFutqz/JC3YouYATDOGhQfwQBP1L+M=
X-Google-Smtp-Source: ABdhPJxE9wmASbPgNq1RmxvCK1+awZBzuRGIk5dOXG8m86UEZH9YhpSnNSvR3YNCfYA8r7EWuS14TcECFl4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c612:b0:161:e095:8ff6 with SMTP id
 r18-20020a170902c61200b00161e0958ff6mr37012728plr.145.1653600260466; Thu, 26
 May 2022 14:24:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:11 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 2/8] KVM: x86: Harden _regs accesses to guard against buggy input
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN and truncate the incoming GPR number/index when reading/writing GPRs
in the emulator to guard against KVM bugs, e.g. to avoid out-of-bounds
accesses to ctxt->_regs[] if KVM generates a bogus index.  Truncate the
index instead of returning e.g. zero, as reg_write() returns a pointer
to the register, i.e. returning zero would result in a NULL pointer
dereference.  KVM could also force the index to any arbitrary GPR, but
that's no better or worse, just different.

Open code the restriction to 16 registers; RIP is handled via _eip and
should never be accessed through reg_read() or reg_write().  See the
comments above the declarations of reg_read() and reg_write(), and the
behavior of writeback_registers().  The horrific open coded mess will be
cleaned up in a future commit.

There are no such bugs known to exist in the emulator, but determining
that KVM is bug-free is not at all simple and requires a deep dive into
the emulator.  The code is so convoluted that GCC-12 with the recently
enable -Warray-bounds spits out a false-positive due to a GCC bug:

  arch/x86/kvm/emulate.c:254:27: warning: array subscript 32 is above array
                                 bounds of 'long unsigned int[17]' [-Warray-bounds]
    254 |         return ctxt->_regs[nr];
        |                ~~~~~~~~~~~^~~~
  In file included from arch/x86/kvm/emulate.c:23:
  arch/x86/kvm/kvm_emulate.h: In function 'reg_rmw':
  arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing '_regs'
    366 |         unsigned long _regs[NR_VCPU_REGS];
        |                       ^~~~~

Link: https://lore.kernel.org/all/YofQlBrlx18J7h9Y@google.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216026
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679
Reported-and-tested-by: Robert Dinse <nanook@eskimo.com>
Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7226a127ccb4..c58366ae4da2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -247,6 +247,9 @@ enum x86_transfer_type {
 
 static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON_ONCE(nr >= 16))
+		nr &= 16 - 1;
+
 	if (!(ctxt->regs_valid & (1 << nr))) {
 		ctxt->regs_valid |= 1 << nr;
 		ctxt->_regs[nr] = ctxt->ops->read_gpr(ctxt, nr);
@@ -256,6 +259,9 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON_ONCE(nr >= 16))
+		nr &= 16 - 1;
+
 	ctxt->regs_valid |= 1 << nr;
 	ctxt->regs_dirty |= 1 << nr;
 	return &ctxt->_regs[nr];
-- 
2.36.1.255.ge46751e96f-goog

