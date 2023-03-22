Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0BE6C4D2D
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 15:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCVOMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 10:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCVOMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 10:12:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B261331
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 07:12:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5411f21f849so189311177b3.16
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 07:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679494343;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3g8Rn77aV2QcyJGm9ePKuJvFxr4MQGLJYaNKJMKDWU=;
        b=r3mX0acHgQFJ/12GN3ObmLvXudUkJrxw9cCmhw7vFuhOdavMwvBHJvlPQzoM9ZnLwg
         MvwtnJVXs2hfUcZXcO4ksYztfpbTOdQtPxGfDGOu7ZKeA3KBKO5HgxS5D+oIvjUJZut5
         YdZe0Fkq8vI1FqZp//uQpLX/+hvNC9g8yAp8rYj6poswJxK9Qe7fIYyAmWN/Ts7SCtrW
         l/9hx6gJ+y3K29/RprDY2OpfnUqLLdinU1/+HANADLUpUJRRcMHNhrEoUT3E9DPucq4x
         OZgeodp/IwCYc6WqkL4h46eiziMvO7xKLFNh2Ruh4CQiLEIeue98vW88tqjs4djKGlhQ
         f3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679494343;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h3g8Rn77aV2QcyJGm9ePKuJvFxr4MQGLJYaNKJMKDWU=;
        b=R5wRO+7Vi2Dwpgec0PzPS+1ZwVhjAszDEc+v0kmNafHlIuCwGFHY+OkvVD2EpvTapP
         DMj3lRc/07yUIVaQCdmQ3VgAJW/Q/ysqWLLdPQHdkDJRKU0U0a662lv6+X+6lkLe4OM7
         k3+ncD5cI4528sZes3CkzXhSsv7NFZ/YyTv3oIl5sUOzL01U8T4BNu0e3mz/s7CNJEBt
         E6oJmrmlyFmXEi6hZQPF6H6ATx5ua/hzJnUacS+IPAqUPlunoULz1b2QqEfPZ+HPhPoF
         272VkATjgjBlVzkoOAiE4iBshU8GcD/9YJybrcbVkJXxiZGOzmoYrojgadrcka7xi2t7
         Avcw==
X-Gm-Message-State: AAQBX9fn5m7M3aMXz1wbz4QxQ7kJlU89vYLIkXD1pKkH3pUoSrNejCrP
        0v1NQBFReUKS/iZTzqI8fy7N/LU6awk=
X-Google-Smtp-Source: AKy350YjDBGga+E95xC44mu6eIl/sGGbUle3DeXTznmceO6Y5LmPpD76/SMxGXNVMpR7fsEKiLQl8FcjBo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1247:b0:a5f:0:bf12 with SMTP id
 t7-20020a056902124700b00a5f0000bf12mr3324492ybu.13.1679494343468; Wed, 22 Mar
 2023 07:12:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 22 Mar 2023 07:12:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322141220.2206241-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Suppress pending MMIO write exits if emulator
 detects exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangjianguo <zhangjianguo18@huawei.com>,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear vcpu->mmio_needed when injecting an exception from the emulator to
squash a (legitimate) warning about vcpu->mmio_needed being true at the
start of KVM_RUN without a callback being registered to complete the
userspace MMIO exit.  Suppressing the MMIO write exit is inarguably wrong
from an architectural perspective, but it is the least awful hack-a-fix
due to shortcomings in KVM's uAPI, not to mention that KVM already
suppresses MMIO writes in this scenario.

Outside of REP string instructions, KVM doesn't provide a way to resume
an instruction at the exact point where it was "interrupted" if said
instruction partially completed before encountering an MMIO access.  For
MMIO reads, KVM immediately exits to userspace upon detecting MMIO as
userspace provides the to-be-read value in a buffer, and so KVM can safely
(more or less) restart the instruction from the beginning.  When the
emulator re-encounters the MMIO read, KVM will service the MMIO by getting
the value from the buffer instead of exiting to userspace, i.e. KVM won't
put the vCPU into an infinite loop.

On an emulated MMIO write, KVM finishes the instruction before exiting to
userspace, as exiting immediately would ultimately hang the vCPU due to
the aforementioned shortcoming of KVM not being able to resume emulation
in the middle of an instruction.

For the vast majority of _emulated_ instructions, deferring the userspace
exit doesn't cause problems as very few x86 instructions (again ignoring
string operations) generate multiple writes.  But for instructions that
generate multiple writes, e.g. PUSHA (multiple pushes onto the stack),
deferring the exit effectively results in only the final write triggering
an exit to userspace.  KVM does support multiple MMIO "fragments", but
only for page splits; if an instruction performs multiple distinct MMIO
writes, the number of fragments gets reset when the next MMIO write comes
along and any previous MMIO writes are dropped.

Circling back to the warning, if a deferred MMIO write coincides with an
exception, e.g. in this case a #SS due to PUSHA underflowing the stack
after queueing a write to an MMIO page on a previous push, KVM injects
the exceptions and leaves the deferred MMIO pending without registering a
callback, thus triggering the splat.

Sweep the problem under the proverbial rug as dropping MMIO writes is not
unique to the exception scenario (see above), i.e. instructions like PUSHA
are fundamentally broken with respect to MMIO, and have been since KVM's
inception.

Reported-by: zhangjianguo <zhangjianguo18@huawei.com>
Reported-by: syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com
Reported-by: syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..6a3e358a32a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8881,6 +8881,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	}
 
 	if (ctxt->have_exception) {
+		WARN_ON_ONCE(vcpu->mmio_needed && !vcpu->mmio_is_write);
+		vcpu->mmio_needed = false;
 		r = 1;
 		inject_emulated_exception(vcpu);
 	} else if (vcpu->arch.pio.count) {

base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.40.0.rc2.332.ga46443480c-goog

