Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328B742C48F
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhJMPOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:14:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ADFC061570;
        Wed, 13 Oct 2021 08:12:17 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634137936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=qwmr4myRxe7RG3G6J6iOLeRXKXZ1vFDP+7jx2zyzab4=;
        b=U1/lex2QVGq5OjNyovlELynOXfrUFzOO10wszuITrt/bJyyAXHFPx/W88IhTTYHIGqw8re
        noc/IlWZ734cU/GkwgCheqo5ptZRdrCy5sR2YiHgwvSamqD80VN3+imdObN2tgGaJFFdSC
        ZuzD/0kUa5Y7UTgKK9jzP0phip0RE32jXe5V/DbQP0pvz6SOGwJoD3Hi4De8emicsNTwEY
        fzn27mBPQWlS+g5kxhtpgyeExlndQdkoO7SVapm5oisvEVNU3M3yYsIJCSaSMhu1dVeu01
        XuIXljOpUO7R28z3ulM2AOttd0otoUAWa0Fn9m4js9sMGQlMk5qe0kbqwdpOkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634137936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=qwmr4myRxe7RG3G6J6iOLeRXKXZ1vFDP+7jx2zyzab4=;
        b=gfhEMBRRHpiJAcc335kvQIMpdF9e4TyFcsFNFoYKwu55OGxG2phiGnocC4usICoEUVJRKK
        csE4Xd/WWZaDarCw==
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
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
Date:   Wed, 13 Oct 2021 17:12:15 +0200
Message-ID: <87sfx57ycw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Wed, Oct 13 2021 at 06:15, Jing2 Liu wrote:
>> On 12/10/21 02:00, Thomas Gleixner wrote:
> When looking into the tglx/devel.git x86/fpu for the full #1-#4 
> series and the KVM AMX support, I'd like to talk two things
>  as follows,
>
> 1. KVM dynamic allocation API:
> Since KVM also uses dynamic allocation, after KVM detects guest
> requesting AMX by #NM trap, KVM need alloc extra buffer for
> this vcpu's current->thread.fpu.fpstate and guest_fpu related.
> So far, the kernel itself has such API like fpstate_realloc(), but it's
> static. How about making a common function usable for KVM?

Just making that function usable without a proper design how this should
work at all does not solve anything.

We first need a conclusion vs. buffer reallocation.

Once that is sorted then we can create proper infrastructure for that in
the FPU core code and not just expose a random function to KVM and hack
it into submssion.

Thanks,

        tglx
