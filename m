Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE03B4EDB
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFZOFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Jun 2021 10:05:46 -0400
Received: from forward100p.mail.yandex.net ([77.88.28.100]:60816 "EHLO
        forward100p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhFZOFp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Jun 2021 10:05:45 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id C89DE5981D74;
        Sat, 26 Jun 2021 17:03:21 +0300 (MSK)
Received: from vla1-d30fdea44965.qloud-c.yandex.net (vla1-d30fdea44965.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:131b:0:640:d30f:dea4])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id C5E4F61E0002;
        Sat, 26 Jun 2021 17:03:21 +0300 (MSK)
Received: from vla1-719694b86d9e.qloud-c.yandex.net (vla1-719694b86d9e.qloud-c.yandex.net [2a02:6b8:c0d:3495:0:640:7196:94b8])
        by vla1-d30fdea44965.qloud-c.yandex.net (mxback/Yandex) with ESMTP id Tl4wGTrC9d-3LHiirfh;
        Sat, 26 Jun 2021 17:03:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624716201;
        bh=TCLJUbm5foo9nartojCnuS9tI3bhlkTdI8cS9RROzyc=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=PoUFVaSj7WDHI6H7sQJIrG3o8rayCImhORJO+9IgAtlkQRXuiImOK1l6q+L0rghIK
         7LhxgTPTqaXSpuoilmHofyA0Ssx3DNh2jWKKZBt1nZhnYgU5jwAyGL4iUeCJ0c8Suw
         qt/S9On2Fa7xFl/zY8z0Daa3hMGDAbXcYgGzoRa8=
Authentication-Results: vla1-d30fdea44965.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-719694b86d9e.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id UHoh6rPqG1-3L202goS;
        Sat, 26 Jun 2021 17:03:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (another patch)
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <ba685c8f-1916-ed45-8455-90a272c98940@yandex.ru>
Date:   Sat, 26 Jun 2021 17:03:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

22.06.2021 01:33, Jim Mattson пишет:
> Maybe what you want is run->ready_for_interrupt_injection? And, if

I implemented this suggestion with
the patch below:

---

--- x86.c.old   2021-03-20 12:51:14.000000000 +0300
+++ x86.c       2021-06-26 16:51:17.366592310 +0300
@@ -4109,7 +4109,9 @@
  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
  {
         return kvm_arch_interrupt_allowed(vcpu) &&
-               kvm_cpu_accept_dm_intr(vcpu);
+               kvm_cpu_accept_dm_intr(vcpu) &&
+               !vcpu->arch.exception.pending &&
+               !vcpu->arch.exception.injected;
  }

  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,

---


With that change I indeed can
look into run->ready_for_interrupt_injection
and avoid the race.
That means a cpu-specific work-around
in my code, but at least that works.
But without this change,
run->ready_for_interrupt_injection
just lies.

Does this bring us any closer to the
understanding of what's going on?
If not, what should I find out next?

