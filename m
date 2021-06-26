Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B863B5050
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 23:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFZVxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Jun 2021 17:53:01 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:45924 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229794AbhFZVxB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Jun 2021 17:53:01 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id B64B94B01915;
        Sun, 27 Jun 2021 00:50:36 +0300 (MSK)
Received: from vla5-4a733ba05de7.qloud-c.yandex.net (vla5-4a733ba05de7.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3514:0:640:4a73:3ba0])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id B359061E0004;
        Sun, 27 Jun 2021 00:50:36 +0300 (MSK)
Received: from vla5-445dc1c4c112.qloud-c.yandex.net (vla5-445dc1c4c112.qloud-c.yandex.net [2a02:6b8:c18:3609:0:640:445d:c1c4])
        by vla5-4a733ba05de7.qloud-c.yandex.net (mxback/Yandex) with ESMTP id QufcQ2W4bJ-oaHaBJAj;
        Sun, 27 Jun 2021 00:50:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624744236;
        bh=PhqJl6gIweaTPn2VygJ3bi52oNz9OKGzeUaSpk/WS+0=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=hGkUK+mvOFo1Rgc8qKJ197gqWWjkglPlO09RQztGbyXJ3pBNNa9dzFJG7oFF4FmUk
         ebbXwGwiJYaYcVwTCmsOwcFfw3uq5NGYuPLJ1P6f2xhQP80kqvkSA/xH6RCTPHvJx9
         hI1jZscc9P2BteQeiBKDg+iKiggcaiyEVmmJiPkI=
Authentication-Results: vla5-4a733ba05de7.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-445dc1c4c112.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id JHG95TzntA-oa3SrupZ;
        Sun, 27 Jun 2021 00:50:36 +0300
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
Message-ID: <a18ea3f1-2d7a-fee4-aa20-bb26c44baf19@yandex.ru>
Date:   Sun, 27 Jun 2021 00:50:35 +0300
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

OK, below are 2 more patches, each of
them alone is fixing the problem.

---

--- x86.c.old   2021-03-20 12:51:14.000000000 +0300
+++ x86.c       2021-06-27 00:38:45.547355116 +0300
@@ -9094,6 +9094,7 @@
         if (req_immediate_exit)
                 kvm_make_request(KVM_REQ_EVENT, vcpu);
         kvm_x86_ops.cancel_injection(vcpu);
+       kvm_clear_exception_queue(vcpu);
         if (unlikely(vcpu->arch.apic_attention))
                 kvm_lapic_sync_from_vapic(vcpu);
  out:
---


Or:

---

--- x86.c.old   2021-03-20 12:51:14.000000000 +0300
+++ x86.c       2021-06-27 00:47:06.958618185 +0300
@@ -1783,8 +1783,7 @@
  bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
  {
         xfer_to_guest_mode_prepare();
-       return vcpu->mode == EXITING_GUEST_MODE || 
kvm_request_pending(vcpu) ||
-               xfer_to_guest_mode_work_pending();
+       return vcpu->mode == EXITING_GUEST_MODE || 
kvm_request_pending(vcpu);
  }
  EXPORT_SYMBOL_GPL(kvm_vcpu_exit_request);

---


Still not a clue?

