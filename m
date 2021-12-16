Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C77476D81
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbhLPJei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 04:34:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53466 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbhLPJeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 04:34:37 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639647275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sdM5rwJ8tV2a2rlkyYIPTJmZdaZ06uAOCzzxfZokkLc=;
        b=KHMaIHW1p4efob7oZloYA/FfyTfIKH0ZUsyv41I04+f6pnGhL/arvKnC5GldRMO4LYFnYY
        y1/bwoeIl3rTPTlGwyqM7bZ/ABjTQk6e+zjTLxvFbsYhPBMwPR8cJTqALszR8a5QqcFAxp
        m5Ap5soscNGtTi90wsK4htHzw3Kz9aDeisJS16/wb6LxjTIaFowPuUAQ/g5/goiWcvwAA2
        BJMo5HCuFq6NT1HNiltYKJQ4EKSHltR7B8YnI2RKE4hn50B4m24G3T+5UaOxkh63fYecmz
        x3aoOeCCmC4N/9cxteuBk1Nlru1wVTXtIPaCwhaclhErSSrzQI7DQAijZq6JDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639647275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sdM5rwJ8tV2a2rlkyYIPTJmZdaZ06uAOCzzxfZokkLc=;
        b=Mx+J3U37pylyHc/u43xVZojv3ZditZLDFgp6eah9dTzgHa/Hopb9EY418KsYnPMpvvrTYH
        cvFm615v6W4XIcAQ==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica>
 <afeba57f71f742b88aac3f01800086f9@intel.com> <878rwmrxgb.ffs@tglx>
 <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
Date:   Thu, 16 Dec 2021 10:34:34 +0100
Message-ID: <87fsqslwph.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16 2021 at 01:04, Kevin Tian wrote:
>> From: Paolo Bonzini <paolo.bonzini@gmail.com> On Behalf Of Paolo Bonzini
>> Considering that in practice all Linux guests with AMX would have XFD
>> passthrough (because if there's no prctl, Linux keeps AMX disabled in
>> XFD), this removes the need to do all the #NM handling too.  Just make
>
> #NM trap is for XFD_ERR thus still required.
>
>> XFD passthrough if it can ever be set to a nonzero value.  This costs an
>> RDMSR per vmexit even if neither the host nor the guest ever use AMX.
>
> Well, we can still trap WRMSR(XFD) in the start and then disable interception
> after the 1st trap.

If we go for buffer expansion at vcpu_create() or CPUID2 then I think
you don't need a trap at all.

XFD_ERR:  Always 0 on the host. Guest state needs to be preserved on
          VMEXIT and restored on VMENTER

This can be done simply with the MSR entry/exit controls. No trap
required neither for #NM for for XFD_ERR.

VMENTER loads guest state. VMEXIT saves guest state and loads host state
(0)

XFD:     Always guest state

So VMENTER does nothing and VMEXIT either saves guest state and the sync
function uses the automatically saved value or you keep the sync
function which does the rdmsrl() as is.

Hmm?

Thanks,

        tglx
