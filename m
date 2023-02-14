Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91E6960CC
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 11:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjBNKdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 05:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBNKdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 05:33:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AC2222F7
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 02:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8555BB81D06
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C455EC433D2;
        Tue, 14 Feb 2023 10:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676370790;
        bh=MwFoiJ2S+3dDe4m1UN4luipBIDQtovWAF23GHeW9zo4=;
        h=From:To:Cc:Subject:Date:From;
        b=bVhyv3mt5i1Kqusel3h+qUe2rqePvjqvVDMGFCXwD8KrviBnp4/fYSJitDtF8FOFS
         R+Co3Xj0/SYdF+o/EiMj6xCqFDh5ENo1VMNHG05pLQjflnhCL0KKhjFHLQMKjfVfdm
         ka4KAmHdGxuaIwnXtpx97SS9iOqmQxj0orSj94Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     kvm@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH] kvm: initialize all of the kvm_debugregs structure before sending it to userspace
Date:   Tue, 14 Feb 2023 11:33:04 +0100
Message-Id: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=gregkh@linuxfoundation.org; h=from:subject; bh=MwFoiJ2S+3dDe4m1UN4luipBIDQtovWAF23GHeW9zo4=; b=owGbwMvMwCRo6H6F97bub03G02pJDMmvk+N8t9+8e//+W1mP8rMKE+Sniy16PuvLd+3IRWv+LrTr fbNjTUcsC4MgE4OsmCLLl208R/dXHFL0MrQ9DTOHlQlkCAMXpwBMxFmBYX6sj9l/KzkmxqaXllOE3e zzbZa69jLML5892euST0ftZ8Xqes2K6bsfnVbeCAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calling the KVM_GET_DEBUGREGS ioctl, on some configurations, there
might be some unitialized portions of the kvm_debugregs structure that
could be copied to userspace.  Prevent this as is done in the other kvm
ioctls, by setting the whole structure to 0 before copying anything into
it.

Bonus is that this reduces the lines of code as the explicit flag
setting and reserved space zeroing out can be removed.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable <stable@kernel.org>
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..50a95c8082fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5254,12 +5254,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 {
 	unsigned long val;
 
+	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
-	dbgregs->flags = 0;
-	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
-- 
2.39.1

