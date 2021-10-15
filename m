Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2235942EF1D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbhJOKwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 06:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhJOKwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 06:52:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF084C061570;
        Fri, 15 Oct 2021 03:50:38 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634295037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wlb45V5A8Kz+I2XPfAf31iLoraQsYB+xMp+K09OrwfQ=;
        b=v6r5WEL5nQ8VDcA4MiOjTGW08wEGS+VF2L4OKaH+oAX9BNkE9pYGgZ/2bMw9ki7fOV2R2Y
        UpWalX2+rNCVuq2vW+DKv9c6/7YChyo+JGGDiDcGsCXMqEmA8ECJhXMBVqFBaZOTnVMf3F
        coU2ALclY/gt/TiMu5ByHrxntWcviwdiR/gdZUcT3+44cJFQHLoBgusAWMSb1DB2MA7e1j
        HKdWg5Uw91KtkHnXUwTwqGErSCy51KGDAK0+gId4UyotT8ecDwAncmupm0mYyt1N41Coft
        yQ9w36+CX0GbmjHq2dNzTurkADMSG0hp69AnrVTmKBc6VXvcjbbHPvZshvNaow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634295037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wlb45V5A8Kz+I2XPfAf31iLoraQsYB+xMp+K09OrwfQ=;
        b=/wJpfc5acJjZ2uFIHmcahvO+iXqBMGuYvL6vEeipZP3A9O7rdi42hGLe4X79K6Y1sq/EP+
        0GaZiRqCcuMU8lDA==
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <BYAPR11MB3256D90BEEDE57988CA39705A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
 <BYAPR11MB3256D90BEEDE57988CA39705A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
Date:   Fri, 15 Oct 2021 12:50:36 +0200
Message-ID: <877dee5zpf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Fri, Oct 15 2021 at 09:00, Jing2 Liu wrote:
> On 10/14/2021 11:01 PM, Paolo Bonzini wrote:
> For the guest dynamic state support, based on the latest discussion,
> four copies of XFD need be cared and switched, I'd like to list as
> follows.

There will not be 4 copies. Read my last mail and think about the
consequences.

I'm really tired of this tinkering frenzy. There is only one correct
approach to this:

   1) Define the requirements

   2) Define the best trapping mechanism

   3) Sit down, look at the existing code including the FPU rework for
      AMX. Come up with a proper integration plan

   4) Clean up the existing KVM FPU mess further so the integration
      can be done smoothly

   5) Add the required infrastructure in FPU core and KVM

   6) Add the trapping mechanics

   7) Enable feature

What you are doing is looking for the quickest way to duct tape this
into the existing mess.

That might be matching the KVM expectations, but it's not going to
happen.

KVM already violates all well known rules of encapsulation and just
fiddles in the guts of FPU mechanism, duplicates code in buggy ways.

This has to stop now!

You are free to ignore me, but all you are going to achieve is to delay
AMX integration further. Seriously, I'm not even going to reply to
anything which is not based on the above approach.

I'm sure you can figure out at which point we are at the moment.

Thanks,

        tglx

