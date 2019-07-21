Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572406F587
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfGUUYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 16:24:34 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:46859 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfGUUYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 16:24:33 -0400
Received: by mail-wr1-f43.google.com with SMTP id z1so37175251wru.13
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 13:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9gDJRsDgJpmhH/Itv2isyUIxGd0o0b49b6kF17V1AGo=;
        b=SRR8djtKNph1chzbN4ddCx6WRoR3TtGF52ALwC/pvLpIcXteCG/JZbni9V6oUSq7Gh
         O+ycjQc1izoksNI34xqbnJd1T7GG5QIE69yUvDIoi2lKPekmgKeLiDA/HOzKJ24w+5TY
         gVq/ZgTtIMNB3WI5pGFbku4C5O9ULaU5EcC9FRwIjLjqL39H9BCL6bnbiB+EFCqV+lFn
         iZPjK7zaOIwanRmH9j6FUZLdG7HkZ7hHe270yZOxhZoPTSyUbc3b+ulXmZrThJPvibCS
         jKO4yarhVzQ0nr53sQfxrtAxzQgrPzPxO0AbdeanRgbMX8Kpzt2p7IBvo+G5WDVzbR/B
         ctlA==
X-Gm-Message-State: APjAAAX2CHP2mj/OL+GoVc8ltUUnOTY5z/Nroed8lOhL8m8rlWLwzc4S
        cAP4aZc+n0HdbNyl3UVxetorKnkyhNI=
X-Google-Smtp-Source: APXvYqxZnHJwCItPh1CtgoXQSDuldRKA+2xd3XCVGg+r5V6lqTnXxa1uNcyMNSq2rOq/SCl3s/hlnQ==
X-Received: by 2002:a05:6000:9:: with SMTP id h9mr1437289wrx.271.1563740671935;
        Sun, 21 Jul 2019 13:24:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f5ce:1d64:8195:e39d? ([2001:b07:6468:f312:f5ce:1d64:8195:e39d])
        by smtp.gmail.com with ESMTPSA id q18sm42494775wrw.36.2019.07.21.13.24.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 13:24:31 -0700 (PDT)
Subject: Re: nvmx: get/set_nested_state ignores VM_EXIT_INSTRUCTION_LEN
To:     Jan Kiszka <jan.kiszka@web.de>, Liran Alon <liran.alon@oracle.com>,
        kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <3299adf3-3979-7718-702f-bab2d9324c69@web.de>
 <5bfb611e-f136-d9e4-7888-123d21e738c2@redhat.com>
 <c6da9913-1ede-2a54-53c1-fcce0217e987@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <28de799d-63c6-f3ff-2c40-867ddd87c90a@redhat.com>
Date:   Sun, 21 Jul 2019 22:24:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c6da9913-1ede-2a54-53c1-fcce0217e987@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 21:31, Jan Kiszka wrote:
> On 21.07.19 21:14, Paolo Bonzini wrote:
>> On 21/07/19 19:40, Jan Kiszka wrote:
>>> Hi all,
>>>
>>> made some progress understanding why vmport from L2 breaks since QEMU gets/sets
>>> the nested state around it: We do not preserve VM_EXIT_INSTRUCTION_LEN, and that
>>> breaks skip_emulated_instruction when completing the PIO access on next run. The
>>> field is suddenly 0, and so we loop infinitely over the IO instruction. Unless
>>> some other magic prevents migration while an IO instruction is in flight, vmport
>>> may not be the only victim here.
>>>
>>> Now the question is how to preserve that information: Can we restore the value
>>> into vmcs02 on set_nested_state, despite this field being read-only? Or do we
>>> need to cache its content and use that instead in skip_emulated_instruction?
>>
>> Hmm I think technically this is invalid, since you're not supposed to
>> modify state at all while MMIO is pending.  Of course that's kinda moot
>> if it's the only way to emulate vmport, but perhaps we can (or even
>> should!) fix it in QEMU.  Is KVM_SET_NESTED_STATE needed for level <
>> KVM_PUT_RESET_STATE?  Even if it is, we should first complete I/O and
>> then do kvm_arch_put_registers.
> 
> Are we sure that vmport is the only case? What prevents a migration from
> starting in the middle of an IO exit?

Migration syncs with the CPU thread via pause_all_vcpus(), after which
the CPU thread must be in qemu_wait_io_event.  KVM_SET_NESTED_STATE
should definitely not be part of KVM_PUT_RUNTIME_STATE.

Paolo
