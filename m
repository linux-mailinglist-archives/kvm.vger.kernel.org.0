Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026163AD639
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFSAOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 20:14:00 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:34017 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhFSAOA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 20:14:00 -0400
Received: from sas1-3b8498a5e64a.qloud-c.yandex.net (sas1-3b8498a5e64a.qloud-c.yandex.net [IPv6:2a02:6b8:c08:cb19:0:640:3b84:98a5])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id 0A76C18C0450;
        Sat, 19 Jun 2021 03:11:43 +0300 (MSK)
Received: from sas1-f4dc5f2fc86f.qloud-c.yandex.net (sas1-f4dc5f2fc86f.qloud-c.yandex.net [2a02:6b8:c08:cb28:0:640:f4dc:5f2f])
        by sas1-3b8498a5e64a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 2IqZNf9eQb-BgHS6pYW;
        Sat, 19 Jun 2021 03:11:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624061502;
        bh=AF8xJN5qwkBn7d33Vg0PTsfQKZpwqcC/BbGR9fN6wwU=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=ZFGTX4OKs2j2dE9UVTDKFSzvHwYibU1hHO2PJ4QYYz4h94uART3YSTzJ2ndpwac6V
         D+PnzUEURMM8F52ml3Sg8OQW76p2teCbXGIS99LAx02Ua+8lnEtCIE1hetmZPvp0CI
         nz6VQV9haqWvvdhvopTQglWa9rdubDjGguHkbPRY=
Authentication-Results: sas1-3b8498a5e64a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas1-f4dc5f2fc86f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id nmVJc733w4-Bg4CBbHw;
        Sat, 19 Jun 2021 03:11:42 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
 <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
 <YM0fBtqYe+VyPME7@google.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <4834cc76-72d5-4d23-7a56-63e455683db5@yandex.ru>
Date:   Sat, 19 Jun 2021 03:11:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YM0fBtqYe+VyPME7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.06.2021 01:32, Sean Christopherson пишет:
> Argh!  Check out this gem:
>
> 	/*
> 	 *   Fix the "Accessed" bit in AR field of segment registers for older
> 	 * qemu binaries.
> 	 *   IA32 arch specifies that at the time of processor reset the
> 	 * "Accessed" bit in the AR field of segment registers is 1. And qemu
> 	 * is setting it to 0 in the userland code. This causes invalid guest
> 	 * state vmexit when "unrestricted guest" mode is turned on.
> 	 *    Fix for this setup issue in cpu_reset is being pushed in the qemu
> 	 * tree. Newer qemu binaries with that qemu fix would not need this
> 	 * kvm hack.
> 	 */
> 	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
> 		var->type |= 0x1; /* Accessed */
>
>
> KVM fixes up segs when unrestricted guest is enabled, but otherwise leaves 'em
> be, presumably because it has the emulator to fall back on for invalid state.
> Guess what's missing in the invalid state check...
>
> I think this should do it:
Until when will it run on an
emulator in this case?
Will it be too slow without a
slightest hint to the user?

If it is indeed the performance
penalty for no good reason,
then my preference would be
to get an error right from
KVM_SET_SREGS instead,
or maybe from KVM_RUN,
but not run everything on
an emulator.
