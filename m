Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A024412AE2
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbhIUCCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbhIUB5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:04 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB9C06B66D
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:11 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id az30-20020a05620a171e00b00432eb71d467so102101227qkb.18
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qy6jnuw2GHlynPgzbk2CZqujQi44xwunFVHUnFWapBw=;
        b=atMRoGvtJcJ4uvVqbduvJvc99n3a9PyUuCDbBDOizbGTnbkFKk6asmcxJsiMzmVIkr
         /va1+9qWt0uDCdW3jVw64vHTYpuB5p6JIPj1XY0+AG296sVHW1Ztyv4c24XYh5ixF5yH
         FL6svOJFw1OFkiX09Mmf1FNyb+jY4ZFB+yzhPWNKRSzeoAMBXxnJ5UzpAHtoERnBfm16
         C4Wi1MeCivz7mrM6Mkuda8SacLpZQsENqYigvBfEzK5WhxjcZh1kUzlQWvhf7kzoUGGn
         HasvrTgPLXLMR8Ou2lGPnjZqNWvNyS8bmNy4EUgkkBOE5lPLl8TBxAHiHWXyP5/JIdjI
         p0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qy6jnuw2GHlynPgzbk2CZqujQi44xwunFVHUnFWapBw=;
        b=2OwLWPCQrqOtgL1RyMAguKDJFG7gO1ZQSkUNYe98RbojD42wCjxe0ti7Ml3Gz4KPpO
         RkUsrZj2T7NDD7rm6tVDw0GeHQKQa8gjeTo57fXAqmzPrDwhFX6yPGOG+Y3mHz/b4pDQ
         2GCM9u2CKsCTgaKpVO6zuIEXlX/zMDxSK+2x9ocu7o7oXqb/4ko9uPcy1Njxt/AKMSGJ
         Qwb89Ly/5Lk4qJWxjIe/4NGhSCemmPvHSXHfWTuwHIRyl/gzqYA/NfGDDv0cCFRKX4Rq
         Hdfoev7YD1uxcs9y5OE2iHSRIfYIQiaXDU6zCMBJPabJ0PlaHckAT6xlLT8wtmn78ypq
         1NyQ==
X-Gm-Message-State: AOAM5305QLIjRij4T5x2k83vZNKyuR/jvChjF5ftt/MSw6vh1sVCKfVm
        gwhu375j5Sswrvc15MbrH1gfVXiUBN0=
X-Google-Smtp-Source: ABdhPJyYy20E1PWeG4X2h35A3S9jwhu/QptShKwhi30DqtfKV4bWTw4znqUXz6Hlngh+2RzvST3vobdsvdU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a05:6214:12ee:: with SMTP id
 w14mr28258154qvv.52.1632182590355; Mon, 20 Sep 2021 17:03:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:55 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 02/10] KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT
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

Explicitly zero the guest's CR3 and mark it available+dirty at RESET/INIT.
Per Intel's SDM and AMD's APM, CR3 is zeroed at both RESET and INIT.  For
RESET, this is a nop as vcpu is zero-allocated.  For INIT, the bug has
likely escaped notice because no firmware/kernel puts its page tables root
at PA=0, let alone relies on INIT to get the desired CR3 for such page
tables.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e77a5bf2d940..2cb38c67ed43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10899,6 +10899,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0xfff0);
 
+	vcpu->arch.cr3 = 0;
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+
 	/*
 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
 	 * of Intel's SDM list CD/NW as being set on INIT, but they contradict
-- 
2.33.0.464.g1972c5931b-goog

