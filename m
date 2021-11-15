Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D733A450A1A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhKOQyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A33C061207
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bZI3ChsRaWVIa6fOUPHIo3mgiaxFid5h+IvBk5+KzcA=; b=gYsvRmtw80QX3YgkSvVemYxkNq
        tzwbwkhZS0jsCXY1EgP0FIddaOM1Cz5fck4sxHH31yY9wOorNY26wzuew59igpdguIR5PnGDMJ2Mx
        BSDgi98aBSGnkOMeYgyddfI9xsh3zVlzjOW55yE5qK53DcORYp/IZjBjQnuRifp4zneOrRUrwIhz5
        RwBidksWBTLW0eklKzbYjrJeLYDBCmtQ6I2xXgXOde7L1RSiYOSWkp27RNgdjlX5Wi9qAHY5bbXO6
        /CEGGK25xEiOBEHDzWUDYPo3U428ZHGa2LmUxSMfqFbY7VACPcifRwmHysRanr+LzFfRbu2ThCkAY
        90JFvcqg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-00GAg5-MP; Mon, 15 Nov 2021 16:50:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wT-C4; Mon, 15 Nov 2021 16:50:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 01/11] KVM: x86: Fix steal time asm constraints in 32-bit mode
Date:   Mon, 15 Nov 2021 16:50:20 +0000
Message-Id: <20211115165030.7422-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In 64-bit mode, x86 instruction encoding allows us to use the low 8 bits
of any GPR as an 8-bit operand. In 32-bit mode, however, we can only use
the [abcd] registers. For which, GCC has the "q" constraint instead of
the less restrictive "r".

Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc7eb5fddfd3..54452269a4ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3307,7 +3307,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 			     "xor %1, %1\n"
 			     "2:\n"
 			     _ASM_EXTABLE_UA(1b, 2b)
-			     : "+r" (st_preempted),
+			     : "+q" (st_preempted),
 			       "+&r" (err)
 			     : "m" (st->preempted));
 		if (err)
-- 
2.31.1

