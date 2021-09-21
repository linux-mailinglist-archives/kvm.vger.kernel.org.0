Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54EA412AE1
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhIUCCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbhIUB5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:04 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D0DC06B66E
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:13 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t18-20020a05620a0b1200b003f8729fdd04so158436088qkg.5
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7ySQ7PzHzecQkNA7fuuC9dVS9Ycf6xIgHtLk0jm/WMk=;
        b=fw+KWXlLNh2fa9IxHz5fE2f4PlO5c8TJsApHW2RJelnJ65DuB6p+yssry8A+9LSKDE
         AJTX5LQ/RkzF89E8NPksvnb03OhPIUZYUZZpne/Y6O2QUpeEqKqILkhjuF52nNvYZ859
         8genJkp33FiqCPnqr125Y3/RED1JWUxvuQCcSnI2QgO/AIWaDPU1mTJ8CJu72fWBs5Jr
         cF/3CCjP1cUAW4NY8h3s4qOp1ziOYSpZCR7R/kxEINlGXcNhfmEPCN3yDGp90hlR9cNE
         qvhWvu9Zk2UCuXpiYCbSRzpE0+AIY1XoG+eS45o7V/n/eEa8kJfCWzojC1N4qHftE15g
         AxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7ySQ7PzHzecQkNA7fuuC9dVS9Ycf6xIgHtLk0jm/WMk=;
        b=Eym/3yESbfcCnCenuI6R9X/EsVpyFMlf4TtgzZ/vCofdHh+Pp7oDlxQ5mA1BKScRNm
         XFiPZLtoxawXSQINJVbqSUw+e0WoVRy7KPKIyJL6bY8sRU40elUgFkD6Cahjn3AB8EU8
         4b6hU1wJ4VQlAjPgttr/rskPCV6GcfsMXWFEIyRdsY5TRMWJVB79JycbKzUxPytk2ttU
         YzlAjGVdSphPwcgKvhzLNjxTqGMlAJeFmE/qJW95xjBMmdiPFshVkVouzyDo8J8x7egi
         buB4Zv2ZOXt0oyMnsNLHoEy6Mh4lUsm+SmOA8jjzqn4ZAuN3pucFHnG3d1yRVNHxj0Cg
         sDrA==
X-Gm-Message-State: AOAM531btQ/uJ8LTaBNQmPFgDua/05YHV1m1JkOeKY88Ei5Xgat0a9oO
        ynDodeENvQPbshlcRWzDkyzfRj/+EDs=
X-Google-Smtp-Source: ABdhPJzKtDAhlL41PSsN3qvFgBT0gaVvW3TWjbUFRNfc75CQpNiThhjhAk0MFSGV5KVrAFzUiUe5XrWVfEc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a05:6214:528:: with SMTP id
 x8mr27797931qvw.30.1632182592456; Mon, 20 Sep 2021 17:03:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:56 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 03/10] KVM: x86: Do not mark all registers as avail/dirty
 during RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not blindly mark all registers as available+dirty at RESET/INIT, and
instead rely on writes to registers to go through the proper mutators or
to explicitly mark registers as dirty.  INIT in particular does not blindly
overwrite all registers, e.g. select bits in CR0 are preserved across INIT,
thus marking registers available+dirty without first reading the register
from hardware is incorrect.

In practice this is a benign bug as KVM doesn't let the guest control CR0
bits that are preserved across INIT, and all other true registers are
explicitly written during the RESET/INIT flows.  The PDPTRs and EX_INFO
"registers" are not explicitly written, but accessing those values during
RESET/INIT is nonsensical and would be a KVM bug regardless of register
caching.

Fixes: 66f7b72e1171 ("KVM: x86: Make register state after reset conform to specification")
[sean: !!! NOT FOR STABLE !!!]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 arch/x86/kvm/x86.c     | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..d44d07d5a02f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4448,6 +4448,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_cr8(vcpu, 0);
 
 	vmx_segment_cache_clear(vmx);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
 
 	seg_setup(VCPU_SREG_CS);
 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cb38c67ed43..ab907a0b9eeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10876,9 +10876,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
 	}
 
+	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
-	vcpu->arch.regs_avail = ~0;
-	vcpu->arch.regs_dirty = ~0;
+	kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);
 
 	/*
 	 * Fall back to KVM's default Family/Model/Stepping of 0x600 (P6/Athlon)
-- 
2.33.0.464.g1972c5931b-goog

