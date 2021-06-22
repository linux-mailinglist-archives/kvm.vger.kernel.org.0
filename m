Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22603AFA28
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFVA3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 20:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFVA3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 20:29:22 -0400
X-Greylist: delayed 78743 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Jun 2021 17:27:07 PDT
Received: from forward101p.mail.yandex.net (forward101p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E3C061574
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 17:27:07 -0700 (PDT)
Received: from iva4-12d38d5d3a8a.qloud-c.yandex.net (iva4-12d38d5d3a8a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:1293:0:640:12d3:8d5d])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 8168A3280D28;
        Tue, 22 Jun 2021 03:27:05 +0300 (MSK)
Received: from iva5-057a0d1fbbd8.qloud-c.yandex.net (iva5-057a0d1fbbd8.qloud-c.yandex.net [2a02:6b8:c0c:7f1c:0:640:57a:d1f])
        by iva4-12d38d5d3a8a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id XyzimpVPUY-R5eanoah;
        Tue, 22 Jun 2021 03:27:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624321625;
        bh=lMGPlMKXRpukZaTSLb9HwU/TZkJ3tpInSviCPurUacM=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=b6BZxiStbLurjKUkYJ0TKCgblTyHe75ldKgx6m2Elu0XuKx7Duh5bdqxSQkBOwCIe
         KO3f0P9inzOvLvHDRi4f76jkbcNjxqp34WbuVXWCGDgu+xIr64CseaB0rWtQ/41gli
         1li3p+17FYJWVfp1EtAsmkFJNX7LurtRdy33B/D8=
Authentication-Results: iva4-12d38d5d3a8a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva5-057a0d1fbbd8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id jHXgkfaR1e-R5O8RSPf;
        Tue, 22 Jun 2021 03:27:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
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
Message-ID: <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
Date:   Tue, 22 Jun 2021 03:27:04 +0300
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
> that's not set, try KVM_RUN with run->request_interrupt_window set?
static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
{
         return kvm_arch_interrupt_allowed(vcpu) &&
                 !kvm_cpu_has_interrupt(vcpu) &&
                 !kvm_event_needs_reinjection(vcpu) &&
                 kvm_cpu_accept_dm_intr(vcpu);

}


So judging from this snippet,
I wouldn't bet on the right indication
from run->ready_for_interrupt_injection

in our situation.
It doesn't check for vcpu->arch.exception.pending
or anything like that.
I believe, the exit to user-space
with pending synchronous exception
was not supposed to happen (but it does).

Also x86_emulate_instruction() seems
to be doing kvm_clear_exception_queue(vcpu)
before anything else, so obviously
such scenario is not trivial...
Possibly the non-emulate path
forgets to clear the queue on entry?

