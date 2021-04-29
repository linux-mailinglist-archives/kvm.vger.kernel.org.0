Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EDC36EDC7
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhD2QDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2QDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:03:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5651DC06138B;
        Thu, 29 Apr 2021 09:02:48 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619712165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8plJW1VXqdM/pu1ulaDOFaCnsDTuvu4fwYJsVAeb39E=;
        b=tDCrPYi8epRqOfmXjzRVd+hbooSGl783ckl6sQX1A5heow2ufo0jVGFKEUwjXHcqxVH/u2
        UEDVrPawKlRzU0u1CeXG3MZ5zw7lLsQBOasplVMnlEMkdIQ9luxXJqYbNP5lLTOPeObQPC
        T8beFcOEQkHWSLIGJkuXPLvurVYfijBce/i4AElu/rvpMDGyRAy/63pdV/bmltVUUhBqeW
        YsM5rPA1ksv03dHKMXgRe+SI4SfxX97eoIncb4TO/9UYcYzl28ZFpjVnUPIaYwk4Hlcrzi
        Np7Jy14haEfQb1uDWblpVZHg7dkZwLkRdDKQT7syPiQ+ul4VMSPT18dzLoVPqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619712165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8plJW1VXqdM/pu1ulaDOFaCnsDTuvu4fwYJsVAeb39E=;
        b=PTZIOGrGSXFPL5ab1UCrpZmd2Ah5VfdyMmMYN0nmPDQUhJGuf7ilDznRsamgSV3WP2R7n0
        UFI1Xp9muTi41NDw==
To:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
In-Reply-To: <2df3de0e-670a-ba28-fdd2-0002cebde545@linux.alibaba.com>
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com> <87lf92n5r1.ffs@nanos.tec.linutronix.de> <e33920a0-24bc-fa40-0a23-c2eb5693f85d@linux.alibaba.com> <875z057a12.ffs@nanos.tec.linutronix.de> <2df3de0e-670a-ba28-fdd2-0002cebde545@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 18:02:44 +0200
Message-ID: <87o8dxf597.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29 2021 at 17:38, Zelin Deng wrote:
> On 2021/4/29 =E4=B8=8B=E5=8D=884:46, Thomas Gleixner wrote:
>> And that validation expects that the CPUs involved run in a tight loop
>> concurrently so the TSC readouts which happen on both can be reliably
>> compared.
>>
>> But this cannot be guaranteed on vCPUs at all, because the host can
>> schedule out one or both at any point during that synchronization
>> check.
>
> Is there any plan to fix this?

The above cannot be fixed.

As I said before the solution is:

>> A two socket guest setup needs to have information from the host that
>> TSC is usable and that the socket sync check can be skipped. Anything
>> else is just doomed to fail in hard to diagnose ways.
>
> Yes, I had tried to add "tsc=3Dunstable" to skip tsc sync.=C2=A0 However =
if a=20

tsc=3Dunstable? Oh well.

> user process which is not pined to vCPU is using rdtsc, it can get tsc=20
> warp, because it can be scheduled among vCPUs.=C2=A0 Does it mean user

Only if the hypervisor is not doing the right thing and makes sure that
all vCPUs have the same tsc offset vs. the host TSC.

> applications have to guarantee itself to use rdtsc only when TSC is=20
> reliable?

If the TSCs of CPUs are not in sync then the kernel does the right thing
and uses some other clocksource for the various time interfaces, e.g.
the kernel provides clock_getttime() which guarantees to be correct
whether TSC is usable or not.

Any application using RDTSC directly is own their own and it's not a
kernel problem.

The host kernel cannot make guarantees that the hardware is sane neither
can a guest kernel make guarantees that the hypervisor is sane.

Thanks,

        tglx




