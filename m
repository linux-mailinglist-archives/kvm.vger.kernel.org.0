Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FD53B6AAB
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbhF1WDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbhF1WDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 18:03:06 -0400
Received: from forward104o.mail.yandex.net (forward104o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C89C061767
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:00:38 -0700 (PDT)
Received: from sas1-1650ac5d911d.qloud-c.yandex.net (sas1-1650ac5d911d.qloud-c.yandex.net [IPv6:2a02:6b8:c08:d927:0:640:1650:ac5d])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id 705B1941CE3;
        Tue, 29 Jun 2021 01:00:35 +0300 (MSK)
Received: from sas2-1cbd504aaa99.qloud-c.yandex.net (sas2-1cbd504aaa99.qloud-c.yandex.net [2a02:6b8:c14:7101:0:640:1cbd:504a])
        by sas1-1650ac5d911d.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 3wRXAvDw6m-0ZHSRpkw;
        Tue, 29 Jun 2021 01:00:35 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624917635;
        bh=EbHM+rMa9x/Zlxx2OWXy8ApRx5rw1ksG/73ACtZhnVU=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=SxKlsK+EhNmtN1s2Nn52b92D9g+h9A2tTj+Khgum4fCamyu3Gn33OrpVFmifAHLqo
         Ge/CuJ+zyc4YuSzW9ya/tQieYho6W0nYxnkVmv7nHuHj6sCD8oSToW0nmm/i/wkium
         F2iY/2VZTwb4yA+M+fVcoJ5udcPK6uN2M1+5sr7E=
Authentication-Results: sas1-1650ac5d911d.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas2-1cbd504aaa99.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 2Q9lZqtnea-0Y3aPfFu;
        Tue, 29 Jun 2021 01:00:34 +0300
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
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
 <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <b15c78e6-4ae3-5825-50c2-396c4e600d02@yandex.ru>
Date:   Tue, 29 Jun 2021 01:00:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

29.06.2021 00:47, Jim Mattson пишет:
> On Mon, Jun 21, 2021 at 5:27 PM stsp <stsp2@yandex.ru> wrote:
>> 22.06.2021 01:33, Jim Mattson пишет:
>>> Maybe what you want is run->ready_for_interrupt_injection? And, if
>>> that's not set, try KVM_RUN with run->request_interrupt_window set?
>> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>> {
>>           return kvm_arch_interrupt_allowed(vcpu) &&
>>                   !kvm_cpu_has_interrupt(vcpu) &&
>>                   !kvm_event_needs_reinjection(vcpu) &&
>>                   kvm_cpu_accept_dm_intr(vcpu);
>>
>> }
>>
>>
>> So judging from this snippet,
>> I wouldn't bet on the right indication
>> from run->ready_for_interrupt_injection
> In your case, vcpu->arch.exception.injected is true, so
> kvm_event_needs_reinjection() returns true. Hence,
> kvm_vcpu_ready_for_interrupt_injection() returns false.
>
> Are you seeing that run->ready_for_interrupt_injection is true, or are
> you just speculating?

OK, please see this commit:
https://www.lkml.org/lkml/2020/12/1/324

There is simply no such code
any longer. I don't know where
I got the above snippet, but its
not valid. The code is currently:

---

static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
{
         return kvm_arch_interrupt_allowed(vcpu) &&
                 kvm_cpu_accept_dm_intr(vcpu);
}

