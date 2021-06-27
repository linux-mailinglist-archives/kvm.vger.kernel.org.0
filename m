Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3B43B5342
	for <lists+kvm@lfdr.de>; Sun, 27 Jun 2021 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhF0MPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Jun 2021 08:15:30 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:50810 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhF0MP2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Jun 2021 08:15:28 -0400
Received: from myt6-9cfe67cfd141.qloud-c.yandex.net (myt6-9cfe67cfd141.qloud-c.yandex.net [IPv6:2a02:6b8:c12:25a9:0:640:9cfe:67cf])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 3FE284D40856;
        Sun, 27 Jun 2021 15:13:03 +0300 (MSK)
Received: from myt6-016ca1315a73.qloud-c.yandex.net (myt6-016ca1315a73.qloud-c.yandex.net [2a02:6b8:c12:4e0e:0:640:16c:a131])
        by myt6-9cfe67cfd141.qloud-c.yandex.net (mxback/Yandex) with ESMTP id BCvMn3rtlB-D3HK6bK5;
        Sun, 27 Jun 2021 15:13:03 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624795983;
        bh=Z7IY8jVs5UtGEDbOY34LK+fK8gW7jt7RvS+mzcezbro=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=aO61mykCxoJXFu3t1govmImGPAnjNIQRUfKHGHeaohWQSqAdPcVVgGAGiGvKGhZtb
         WkzifUVKT7Vbmscyst9Kx4yognHu2KivmZBMzBF+4AgOqp+SCx+r8XeV7iSHLScBjk
         HmclKCRSCkd2tv6anRGapZ8uwuKrUCW2vMOaP37A=
Authentication-Results: myt6-9cfe67cfd141.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-016ca1315a73.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id etYfqOm4kg-D23Gi8Nq;
        Sun, 27 Jun 2021 15:13:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race on core2 CPUs (with fix!)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
 <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
 <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
 <19022e7d-e1f5-06b5-f059-27172ca50011@yandex.ru>
 <f09d851d-bda1-7a99-41cb-a14ea51e1237@yandex.ru>
 <CALMp9eQWKa1vL+jj5HXO1bm+oMo6gQLNw44P7y6ZaF8_WQfukw@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <6d34acc1-b8cf-b734-c083-dfa446d0a66c@yandex.ru>
Date:   Sun, 27 Jun 2021 15:13:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQWKa1vL+jj5HXO1bm+oMo6gQLNw44P7y6ZaF8_WQfukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

26.06.2021 03:15, Jim Mattson пишет:
> If the squashed exception was a trap, it's now lost.

I am pretty sure this will do it:

---

--- x86.c.old   2021-03-20 12:51:14.000000000 +0300
+++ x86.c       2021-06-27 15:02:45.126161812 +0300
@@ -9093,7 +9093,11 @@
  cancel_injection:
         if (req_immediate_exit)
                 kvm_make_request(KVM_REQ_EVENT, vcpu);
-       kvm_x86_ops.cancel_injection(vcpu);
+       if (vcpu->arch.exception.injected) {
+               kvm_x86_ops.cancel_injection(vcpu);
+               vcpu->arch.exception.injected = false;
+               vcpu->arch.exception.pending = true;
+       }
         if (unlikely(vcpu->arch.apic_attention))
                 kvm_lapic_sync_from_vapic(vcpu);
  out:
@@ -9464,6 +9468,7 @@
         kvm_rip_write(vcpu, regs->rip);
         kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);

+       WARN_ON_ONCE(vcpu->arch.exception.injected);
         vcpu->arch.exception.pending = false;

         kvm_make_request(KVM_REQ_EVENT, vcpu);
---


In cancel_injection, the injected/pending
members were getting out of sync with
vmcs.
We need to move it back to pending,
and if user-space does SET_REGS, then
it is cleared (not sure why SET_SREGS
doesn't clear it also).
But if the .injected member is stuck,
then its not cleared by SET_REGS, and
I added WARN_ON_ONCE() for that case.

Does this make sense?

