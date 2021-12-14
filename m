Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB97474CA4
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 21:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbhLNU2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 15:28:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43888 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbhLNU2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 15:28:30 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639513708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIrltjIa8LXE70tFlkI4s3RIRynR1uteQ692uHXzOeQ=;
        b=ex7P/8huN52fxzfClVJkzVoyJSYVArVN/kVMdCPW+Wb5XR16m5uNTWhNpbLLm28NWvmgjm
        42s7uFnjZLNXPy8zKOd3NAaLEKWBYLFp6QAe6NybfR6sUA6war0DcVQZpf49Zhq2nMbVk3
        n0mp8/uBznKYmGhueapAvosF4qHCiKa+8/fh+0Vb1upg2d6yl8D2RKb+9fyxGSnrEkjSck
        iAHGbxjjTkzoV/9cEeJMRuEmDuAMMMZ92KxyZFl2s/YrQOPutZ4LQ5bF+Vov8v5Hm55zG4
        k3nUVGQsUzZV3px3BYHrTPT+2hHGr8lDjUDi97w7Q+kogfakM2mitU9Nv1MuXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639513708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIrltjIa8LXE70tFlkI4s3RIRynR1uteQ692uHXzOeQ=;
        b=uLTp4lgAnPhxBX8J3kSgy+H1ADSxH+0bOtVVX5NoBX9x8Va1iPnDdPYjmhxoReljLthDko
        KT7G+FctlAzpVEBw==
To:     quintela@redhat.com
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <87k0g7qa3t.fsf@secure.mitica>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica>
Date:   Tue, 14 Dec 2021 21:28:28 +0100
Message-ID: <87k0g7rkwj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan,

On Tue, Dec 14 2021 at 20:07, Juan Quintela wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Tue, Dec 14 2021 at 16:11, Wei W. Wang wrote:
>>> We need to check with the QEMU migration maintainer (Dave and Juan CC-ed)
>>> if changing that ordering would be OK.
>>> (In general, I think there are no hard rules documented for this ordering)
>>
>> There haven't been ordering requirements so far, but with dynamic
>> feature enablement there are.
>>
>> I really want to avoid going to the point to deduce it from the
>> xstate:xfeatures bitmap, which is just backwards and Qemu has all the
>> required information already.
>
> First of all, I claim ZERO knowledge about low level x86_64.

Lucky you.

> Once told that, this don't matter for qemu migration, code is at

Once, that was at the time where rubber boots were still made of wood,
right? :)

> target/i386/kvm/kvm.c:kvm_arch_put_registers()
>
>
>     ret = kvm_put_xsave(x86_cpu);
>     if (ret < 0) {
>         return ret;
>     }
>     ret = kvm_put_xcrs(x86_cpu);
>     if (ret < 0) {
>         return ret;
>     }
>     /* must be before kvm_put_msrs */
>     ret = kvm_inject_mce_oldstyle(x86_cpu);

So this has already ordering requirements.

>     if (ret < 0) {
>         return ret;
>     }
>     ret = kvm_put_msrs(x86_cpu, level);
>     if (ret < 0) {
>         return ret;
>     }
>
> If it needs to be done in any other order, it is completely independent
> of whatever is inside the migration stream.

From the migration data perspective that's correct, but I have the
nagging feeling that this in not that simple.

> I guess that Paolo will put some light here.

I fear shining light on that will unearth quite a few skeletons :)

Thanks,

        tglx
