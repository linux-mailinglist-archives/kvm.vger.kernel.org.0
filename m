Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690DB42C304
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhJMO0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:26:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35146 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhJMO0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:26:31 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634135067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7nVZGBCeuindwKm9eXa4HWiuVLAO3Utl4ky+RFG0dug=;
        b=aiZKgw7mnAIdEVEqdRTLyH/4mddDXeHSivtaNj8XXbmeRAtG8esEBBBm/BQNJwg0ahagxa
        sFx1ynBMku/YHRYrpjAk7klrcbsrSEx0vir3dS8iKNj+Aoik/ARbVtKNOYDXvrAG0g+R5R
        hYccq7Em5ereAEA9ONQT39Y02XeNaZ/uzWEGdoWPpFFcO5hpyeVIWih8G0/Kohp1/Yupd2
        5OFW62xjhhyukAuS/QNUeqo+NxW01E5dVyshJd4FgnO0rF72K6Zhz84GhvtzGlXkLz+6Ka
        aHaugf1nWhMv6qC8hi7Rs5xCur1F88xTiIPV3tfXmwWhnxcJ1GvhoR4w6cD+NA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634135067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7nVZGBCeuindwKm9eXa4HWiuVLAO3Utl4ky+RFG0dug=;
        b=8q2eYQd6ckfL6+RDB/3XOTz/iUl+8MtbNZl2ez1dS28Z4mdTArkP2ci186WOGQeCrlFdQb
        6Xdx8KNh/qmS+yDw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <87y26x811c.ffs@tglx>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
 <d673e736-0a72-4549-816d-b755227ea797@www.fastmail.com>
 <df3af1c2-fe93-ea21-56e5-4d70d08e55f2@redhat.com> <87y26x811c.ffs@tglx>
Date:   Wed, 13 Oct 2021 16:24:27 +0200
Message-ID: <87v92180kk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13 2021 at 16:14, Thomas Gleixner wrote:

> On Wed, Oct 13 2021 at 14:26, Paolo Bonzini wrote:
>
>> On 13/10/21 12:14, Andy Lutomirski wrote:
>>>> I think it's simpler to always wait for #NM, it will only happen
>>>> once per vCPU.  In other words, even if the guest clears XFD before
>>>> it generates #NM, the guest_fpu's XFD remains nonzero and an #NM
>>>> vmexit is possible.  After #NM the guest_fpu's XFD is zero; then
>>>> passthrough can happen and the #NM vmexit trap can be disabled.
>>>
>>> This will stop being at all optimal when Intel inevitably adds
>>> another feature that uses XFD.  In the potentially infinite window in
>>> which the guest manages XFD and #NM on behalf of its userspace and
>>> when the guest allocates the other hypothetical feature, all the #NMs
>>> will have to be trapped by KVM.
>>
>> The reason is that it's quite common to simply let the guest see all 
>> CPUID bits that KVM knows about.
>
> On fleets the cpu features exposed to guests matter a lot to ensure
> migratability and I would be surprised when such a feature would just
> be universally available to anyone.

As a VM customer you get charged for RAM, CPUs, storage and whatever
extra features you need. So why would AMX be any different?

So far Intel ignored the fact that these accelerators are managed
resources even if they are accessible via instructions and do not
require to open(/dev/magic_accelerator). But that's just wrong and XFD
should already have happened with AVX512.

Trying to expose AMX unconditionally is just wrong and overengineered
and proliferating the mess we already have to suffer from.

As I said in the other mail. QEMU has to get permissions to use AMX
first and not doing it by circumventing the permission part via a KVM
hack.

Thanks,

        tglx



