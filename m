Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE9D310234
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhBEB0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhBEB0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 20:26:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B28C061793
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 17:25:06 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l10so5243629ybt.6
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 17:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NsGpEfTu4cLzsz3Z3nvZ8Zvi7McRK3J13A5YbpGKONI=;
        b=un/5N8cNYxEeZsiNMb1emCSkI2N5/6aN39TfGWtS7yipr3Oa6xpCTVvHKcn/0QEsEP
         xVb8ERoQSJjuh8O9ZiSUcZrJcju+n8HDPrdAT2JkAZ//cbUo4mYGqC90FUcznM86z2H/
         /gXJnQvkXnn+201WR139QRYAAyFLF6TH+7HMZC+WMC0mdA9jAKETugZjklWwnIGQkuh9
         6ICAUgxFQ1G2BDssScdvAyiBbR83bZdcXvMZEcizbLe4MDYXA7pFKRNrpNh6wzo1H0Pd
         xR9U+tMF+E4m4auRphQulcnIbaiZZBJS34UPShsN+6M897R1g8G/3BEby9W5HUauY1Aq
         ShHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NsGpEfTu4cLzsz3Z3nvZ8Zvi7McRK3J13A5YbpGKONI=;
        b=ggJ1wfRc2V5kFYuwfYiRUq/HzqWCBNUhxXBD1eKlNJTDtatRBNwLBNjKRmmGDHMi4X
         Q6WPgGBqm7TwUbaodHFH/djEJ35Iwa1A+GF5LKCFRF4A4akzNd8vWnPhuUKpMJnslO6u
         ovBsGmkGIswwZhxiPtDMehFd7Hf9iaxxC+P9okPPm1A9g0YufhHR7CP+Rd/1OBNVquSA
         e2/WUAFYHa0pygHcmTLDDNg9HKZcLklIGzRsF9QcKtT+VfxIJ1xYJbokBj/jCsc4JT7f
         3Yne1RMXuHXKQqdP3jAHi2PMcgG7uTwC01J9TPWsxf7rOI2ZPMxiMADk1u474z719P8Y
         SwZw==
X-Gm-Message-State: AOAM5332LN1DJanTlRGB9UNln8Uv2+0DIVHrNsTynDjntyz5GmiOR+pd
        WRpQoyrCnUc/G2EATlpSGUlyhyFUFPU=
X-Google-Smtp-Source: ABdhPJwPTyOHnU91Vvajo0M6B147oydY5Bm6+xq0JcJKv/A6snQt0S7F2CPWE4oQmJqlr415aX6UDN8c7N4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:b74d:: with SMTP id e13mr2844459ybm.405.1612488305988;
 Thu, 04 Feb 2021 17:25:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 17:24:58 -0800
In-Reply-To: <20210205012458.3872687-1-seanjc@google.com>
Message-Id: <20210205012458.3872687-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210205012458.3872687-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 2/2] KVM: x86: Restore all 64 bits of DR6 and DR7 during RSM
 on x86-64
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the full 64-bit values of DR6 and DR7 when emulating RSM on
x86-64, as defined by both Intel's SDM and AMD's APM.

Note, bits 63:32 of DR6 and DR7 are reserved, so this is a glorified nop
unless the SMM handler is poking into SMRAM, which it most definitely
shouldn't be doing since both Intel and AMD list the DR6 and DR7 fields
as read-only.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2e6e6c39922f..72a1bd04dfe1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2564,12 +2564,12 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
 	ctxt->eflags = GET_SMSTATE(u32, smstate, 0x7f70) | X86_EFLAGS_FIXED;
 
-	val = GET_SMSTATE(u32, smstate, 0x7f68);
+	val = GET_SMSTATE(u64, smstate, 0x7f68);
 
 	if (ctxt->ops->set_dr(ctxt, 6, val))
 		return X86EMUL_UNHANDLEABLE;
 
-	val = GET_SMSTATE(u32, smstate, 0x7f60);
+	val = GET_SMSTATE(u64, smstate, 0x7f60);
 
 	if (ctxt->ops->set_dr(ctxt, 7, val))
 		return X86EMUL_UNHANDLEABLE;
-- 
2.30.0.365.g02bc693789-goog

