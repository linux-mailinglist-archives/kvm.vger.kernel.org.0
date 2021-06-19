Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FFC3AD8DC
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 11:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhFSJUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Jun 2021 05:20:23 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:36823 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhFSJUW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Jun 2021 05:20:22 -0400
Received: from myt5-95f184467838.qloud-c.yandex.net (myt5-95f184467838.qloud-c.yandex.net [IPv6:2a02:6b8:c12:5981:0:640:95f1:8446])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id C439118C05A7;
        Sat, 19 Jun 2021 12:18:10 +0300 (MSK)
Received: from myt6-9bdf92ffd111.qloud-c.yandex.net (myt6-9bdf92ffd111.qloud-c.yandex.net [2a02:6b8:c12:468a:0:640:9bdf:92ff])
        by myt5-95f184467838.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 4OZBN6xDsw-IAHilqQF;
        Sat, 19 Jun 2021 12:18:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624094290;
        bh=G8ihFkoPxaj4xqRTQyEdHkcn0usFLQ2PC4LP8q9g2QY=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=l7Cg9MX+JluGyoZxldlKcMhCavlipx4lH3rUFN59jKy9TnsnTMIpRypuRZmfVP2Y2
         dhMALT/RHDvnmGlnq9zVyZ2S7ZS1LSazNLsLUxn4/jcnrb1tqJgGml0i29oZeoMaAX
         aujVqB0LkEpwpd0d4WVTDw+S1mRFVFpbpnFOO5rQ=
Authentication-Results: myt5-95f184467838.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-9bdf92ffd111.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id Xb75OwHdKq-IA38bIdR;
        Sat, 19 Jun 2021 12:18:10 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
 <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
 <YM0fBtqYe+VyPME7@google.com>
 <4834cc76-72d5-4d23-7a56-63e455683db5@yandex.ru>
 <YM1AWuoRm6xh+OVr@google.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <bda4611d-3ac7-de7c-44f4-f6fc5ac309f9@yandex.ru>
Date:   Sat, 19 Jun 2021 12:18:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YM1AWuoRm6xh+OVr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.06.2021 03:54, Sean Christopherson пишет:
> On Sat, Jun 19, 2021, stsp wrote:
>> 19.06.2021 01:32, Sean Christopherson пишет:
>>> Argh!  Check out this gem:
>>>
>>> 	/*
>>> 	 *   Fix the "Accessed" bit in AR field of segment registers for older
>>> 	 * qemu binaries.
>>> 	 *   IA32 arch specifies that at the time of processor reset the
>>> 	 * "Accessed" bit in the AR field of segment registers is 1. And qemu
>>> 	 * is setting it to 0 in the userland code. This causes invalid guest
>>> 	 * state vmexit when "unrestricted guest" mode is turned on.
>>> 	 *    Fix for this setup issue in cpu_reset is being pushed in the qemu
>>> 	 * tree. Newer qemu binaries with that qemu fix would not need this
>>> 	 * kvm hack.
>>> 	 */
>>> 	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
>>> 		var->type |= 0x1; /* Accessed */
>>>
>>>
>>> KVM fixes up segs when unrestricted guest is enabled, but otherwise leaves 'em
>>> be, presumably because it has the emulator to fall back on for invalid state.
>>> Guess what's missing in the invalid state check...
>>>
>>> I think this should do it:
>> Until when will it run on an emulator in this case?  Will it be too slow
>> without a slightest hint to the user?
> KVM would emulate until the invalid state went away, i.e. until the offending
> register was loaded with a new segment that set the Accessed bit.
Such condition will happen
pretty quickly if the emulator
sets the accessed bit also in LDT.
Does it do that?
