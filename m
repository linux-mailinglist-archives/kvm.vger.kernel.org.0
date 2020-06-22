Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC2204434
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgFVXC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 19:02:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731406AbgFVXC0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 19:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592866945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLgMiGtPFjIaSIz3RbHMh7JjOAzoUD45vxqY2OF/ySw=;
        b=SSD/skXBvZ4z7zL+NultChBP03kcdZ2x2qonzmPaf3LokZXviXPIuT6Sk95tLVssFtc3U+
        HBuA9J0jBn6bh+duHcaoOi5wUAN/M/97Z+yzH57VCtCEUjSs0QI+CKG4aK1AZbNlkMAjzu
        qFz4/69CDSzWQ1XbKK7+/Ee/vETOgqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-pDxYIQreOd2yCEKWc8Zqvw-1; Mon, 22 Jun 2020 19:02:23 -0400
X-MC-Unique: pDxYIQreOd2yCEKWc8Zqvw-1
Received: by mail-wr1-f71.google.com with SMTP id o25so10303594wro.16
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 16:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLgMiGtPFjIaSIz3RbHMh7JjOAzoUD45vxqY2OF/ySw=;
        b=JFUGEJYAn4jASdZ4hySf4jn2VF6fx/aexKqclAh8LazZLjNENHIvH21TUq2chHdpLk
         jz8H/uDsjsnA48ih7BUP6eLcXTctMyC0zEP2kh7zcBfFWk7ob1ZZTxMhChgscJW/anlc
         fC2eJ9tl32zpA9FiaY1xYCrRAcBXXkgA73Y5Osbq53V8cPCdIKYt8hIZYgf2sYVNDoUW
         qHwO21wmh9PeNX9PdCb9sQmX1OwIjekMk2K2BSv/yIn0WAaBnHyPkUu0whtLX162Yo/J
         Ms5obfx/PWNepYcbV5inUSczDFziHm/kxlr+xD+jRcz/M2Az64l55nCzM6OQN7lphZhN
         s/sg==
X-Gm-Message-State: AOAM53207WTWL8nZqzEseC3RPzi/XwRagLQaCiMzexNb4Tb5HobERYRw
        /PvaA1JNbfbfa1BEYKOTIaD/gA+8WnozqEnAcg1qScpwQTHUZHUoE18Cdm9TM72XvEtm0dvX/jH
        b1xBWyADi8uwE
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr20715496wrs.235.1592866942007;
        Mon, 22 Jun 2020 16:02:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWBFC/i0pH767rQ65hiPwG4g0Y0IABLIaMpXiHXR7sC46xcI7ASgS6BosXoA31yasCAsDrVQ==
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr20715475wrs.235.1592866941776;
        Mon, 22 Jun 2020 16:02:21 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id n16sm1136322wmc.40.2020.06.22.16.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 16:02:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization
 generations
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200615230750.105008-1-jmattson@google.com>
 <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
 <CALMp9eR4Ny1uaXmOFGTr2JoGqwTw1SUeY34OyEoLpD8oe2n=6w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3818ac9f-79fb-c5b3-dcd2-663f21be9caf@redhat.com>
Date:   Tue, 23 Jun 2020 01:02:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR4Ny1uaXmOFGTr2JoGqwTw1SUeY34OyEoLpD8oe2n=6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 00:36, Jim Mattson wrote:
> On Mon, Jun 22, 2020 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 16/06/20 01:07, Jim Mattson wrote:
>>> +             } else if (vcpu->arch.this_tsc_generation !=
>>> +                        kvm->arch.cur_tsc_generation) {
>>>                       u64 tsc_exp = kvm->arch.last_tsc_write +
>>>                                               nsec_to_cycles(vcpu, elapsed);
>>>                       u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>>
>> Can this cause the same vCPU to be counted multiple times in
>> nr_vcpus_matched_tsc?  I think you need to keep already_matched (see
>> also the commit message for 0d3da0d26e3c, "KVM: x86: fix TSC matching",
>> 2014-07-09, which introduced that variable).
> 
> No. In the case where we previously might have counted the vCPU a
> second time, we now start a brand-new generation, and the vCPU is the
> first to be counted for the new generation.

Right, because synchronizing is false.  But I'm worried that a migration
at the wrong time would cause a wrong start of a new generation.

start:
	all TSCs are 0

mid of synchronization
	some TSCs are adjusted by a small amount, gen 1 is started

----------------- migration -------------

start:
	all TSCs are 0

restore state
	all TSCs are written with KVM_SET_MSR, gen 1 is	started and
	completed

after execution restarts
	guests finishes updating TSCs, gen 2 starts

and now nr_vcpus_matched_tsc never reaches the maximum.

Paolo

