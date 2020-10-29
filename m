Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0792429F65E
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgJ2Um4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:42:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36016 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgJ2UlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 16:41:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604004074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=atBWSsg54EdElpQmxIGprMythfayvCfZuL6C0LobpJM=;
        b=zq8OmPxEES1sHwpepW8vzEe0jYTTlYtXV12+hxY9jzb3tYWHhm/ZdTBMeg3suW0uXnI22o
        QRfyl9qohhkGLsu5YphvfKNBGVVDQawQCEUKIkYyS9kHIx+egw2JhKwPfjRd0CQcLbf0Ma
        0+PC2RmqmSccZCm0+EePmF3HtanM8DIlixTveKLP2V0Ksru8Qhe9ajxfSPkPPl0uWvBwkU
        CZwbIAvCZIttVS0GI97ynyZTPYQQIOv8hYusYoSjZ4dO50yoSQ3YCiIbnrq6RPIo7I7h9P
        itJ4XgJrsTvo9TskPmCZoEXzffgEzSJ6VbIxGy8NcIttwKKxU5XG9VypabrK6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604004074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=atBWSsg54EdElpQmxIGprMythfayvCfZuL6C0LobpJM=;
        b=0iX007DAMCgsp9VjWAMG/D89r7Kujao6BFenyKLGjjTNx6nxedksxtcAkjsrsCDNJr2Ram
        K5nPYTQvIUbyR9CA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     'Arnd Bergmann' <arnd@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "x86\@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86\@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel\@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu\@lists.linux-foundation.org" 
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
In-Reply-To: <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
References: <20201028212417.3715575-1-arnd@kernel.org> <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com> <20201029165611.GA2557691@rani.riverdale.lan> <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
Date:   Thu, 29 Oct 2020 21:41:13 +0100
Message-ID: <87v9esojdi.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29 2020 at 17:59, Paolo Bonzini wrote:
> On 29/10/20 17:56, Arvind Sankar wrote:
>>> For those two just add:
>>> 	struct apic *apic = x86_system_apic;
>>> before all the assignments.
>>> Less churn and much better code.
>>>
>> Why would it be better code?
>> 
>
> I think he means the compiler produces better code, because it won't
> read the global variable repeatedly.  Not sure if that's true,(*) but I
> think I do prefer that version if Arnd wants to do that tweak.

It's not true.

     foo *p = bar;

     p->a = 1;
     p->b = 2;

The compiler is free to reload bar after accessing p->a and with

    bar->a = 1;
    bar->b = 1;

it can either cache bar in a register or reread it after bar->a

The generated code is the same as long as there is no reason to reload,
e.g. register pressure.

Thanks,

        tglx
