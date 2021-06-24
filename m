Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358553B3533
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhFXSIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhFXSIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 14:08:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B829C061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:06:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o12-20020a5b050c0000b02904f4a117bd74so483909ybp.17
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=iLHcgth/bnJSq1B42NH4cj6yM3BU3UaaURi2JWPns6Q=;
        b=Ey0VVNmPKh97XRQFDskZufyBVs/tXzxGnK1A+pNedtSB017exh/he2tANNt0Dx3Twn
         /QmjSTAHosUnC9VEvp3P2xbbrvhSgWVESwreosZRFeL572d77pikAH39AKMT0Uk9/QiE
         8G0KoZciYKLy1FVgkNSqLvIYD01cowAISKCxJnAt8mAlwIHkpAtfBGQ7Glnl1upGLlC6
         HoArkq61nzZmlKQ/QO+bM9G64zDBRQA4DnXOwFIY5y1zEVtsx+L6AEMEpf7BVPI7xQop
         +M25ZM2oufrucs+m7nEicGBByJnymW1Rj7xc9WhiC98FA/Mr1bIM1PjJAq0rDO111cCJ
         UQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=iLHcgth/bnJSq1B42NH4cj6yM3BU3UaaURi2JWPns6Q=;
        b=M7j6KPatX0fw8kJoUR6fs19S2YG5lLNINbIfCjiSbKeB9yz6HtqmvWvEASVK9sBMjk
         sFYI5yrEN5KJ3NyCZBk6kASC58V3H+mEvg7+fbko2RgKRclHv1HLqiX3YfpffCplISvj
         GgzQ9AEXqmoT7J9B6GpdvRil+2kM05yzP38OzX5Orruhvx2RSTmGwIxd47ZVtqNOGFLe
         zoTAkBTqlZpMyWj/m1sQfqnBxIwpkRNMjLsA1PKJX2XA70RunKkPP2i57U1IoUkhda2X
         ZgYGcsduqIQAzIKy8E8WxxMyha5ocU853iXY8Ngv7VjjT1qQJwxnORhNtA+M04QRk1S+
         Zzsg==
X-Gm-Message-State: AOAM531k1yqd8AGWkJV6nIynRAKD8W9q70mAggYkIamHkB5Me46+2jg3
        6HZ1FIx/2Q+kAV/Tjvg8PAED3Y838lQ=
X-Google-Smtp-Source: ABdhPJzz6b/iZa3i3kyj8ZLxGtZ0aMYpILDa362XD7oD241y/VZj6xY1synVhSxws/+y+2xNyGciTWc/CPk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a25:d0c3:: with SMTP id h186mr7080679ybg.150.1624557990486;
 Thu, 24 Jun 2021 11:06:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Jun 2021 11:06:25 -0700
Message-Id: <20210624180625.159495-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] KVM: x86: Fix uninitialized return value bug in
 EXIT_HYPERCALL enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero out 'r' on success in the KVM_CAP_EXIT_HYPERCALL case.  As noted by
clang, the happy path will return an uninitialized value:

  arch/x86/kvm/x86.c:5649:7: error: variable 'r' is used uninitialized
   whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
                  if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  arch/x86/kvm/x86.c:5663:9: note: uninitialized use occurs here
          return r;
               ^
  arch/x86/kvm/x86.c:5649:3: note: remove the 'if' if its condition is always true
                  if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  arch/x86/kvm/x86.c:5540:7: note: initialize the variable 'r' to silence this warning
          int r;
               ^
                = 0

Opportunistically move the "r = -EINVAL;" above the check to match the
pattern used in almost all other cases.

Fixes: 0dbb11230437 ("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4cea00c49a3..647922ba97df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5646,11 +5646,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
 		return r;
 	case KVM_CAP_EXIT_HYPERCALL:
-		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
-			r = -EINVAL;
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK)
 			break;
-		}
+
 		kvm->arch.hypercall_exit_enabled = cap->args[0];
+		r = 0;
 		break;
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 		kvm->arch.exit_on_emulation_error = cap->args[0];
-- 
2.32.0.93.g670b81a890-goog

