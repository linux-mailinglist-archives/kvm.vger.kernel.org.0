Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC3465E99
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 08:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355817AbhLBHWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 02:22:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344823AbhLBHWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 02:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638429571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qlwfsaoVSceIM7+4wFeFG1DIh1QzBLUgfeE92ble2TE=;
        b=Wxb0TuOu1FgoJGqHt/heaMX0DqT7n1gWGoNd6jHTofULP7PZLYwWiODxgMLrgfXu6wCDRk
        koLlbPMmSwSRW3yJoESILPcm9zvbAtOGCYk4P+VdiqSV1QAH7MwBUO9k68Gsiwvmm0sNm6
        Ubc5HQmnQdUwc7ED0d/ACCj3LZDh3u8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-0EEGdWedNfavC6Nnslo-Kg-1; Thu, 02 Dec 2021 02:19:30 -0500
X-MC-Unique: 0EEGdWedNfavC6Nnslo-Kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C1221006AA6;
        Thu,  2 Dec 2021 07:19:29 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F331836B;
        Thu,  2 Dec 2021 07:19:26 +0000 (UTC)
Message-ID: <ffbb8a16f267e73316084d1252696edaf81e35a9.camel@redhat.com>
Subject: Re: Re: [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for
 kvmclock
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Date:   Thu, 02 Dec 2021 09:19:25 +0200
In-Reply-To: <b37ffc3d-4038-fc5e-d681-b89c04a37b04@bytedance.com>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
         <20211201024650.88254-3-pizhenwei@bytedance.com> <877dcn7md2.ffs@tglx>
         <b37ffc3d-4038-fc5e-d681-b89c04a37b04@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-02 at 13:26 +0800, zhenwei pi wrote:
> On 12/2/21 10:48 AM, Thomas Gleixner wrote:
> > On Wed, Dec 01 2021 at 10:46, zhenwei pi wrote:
> > > If the host side supports APERF&MPERF feature, the guest side may get
> > > mismatched frequency.
> > > 
> > > KVM uses x86_get_cpufreq_khz() to get the same frequency for guest side.
> > > 
> > > Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> > > ---
> > >   arch/x86/kvm/x86.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5a403d92833f..125ed3c8b21a 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8305,10 +8305,8 @@ static void tsc_khz_changed(void *data)
> > >   
> > >   	if (data)
> > >   		khz = freq->new;
> > > -	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> > > -		khz = cpufreq_quick_get(raw_smp_processor_id());
> > >   	if (!khz)
> > > -		khz = tsc_khz;
> > > +		khz = x86_get_cpufreq_khz(raw_smp_processor_id());
> > 
> > my brain compiler tells me that this is broken.
> > Without this patch:
> 1, boot_cpu_has(X86_FEATURE_CONSTANT_TSC) is true:
> no kvmclock_cpufreq_notifier, and khz = tsc_khz;
> 
> 2, boot_cpu_has(X86_FEATURE_CONSTANT_TSC) is false:
> during installing kmod, try cpufreq_quick_get(), or use tsc_khz;
> and get changed by kvmclock_cpufreq_notifier.
> 
> With this patch:
> 1, boot_cpu_has(X86_FEATURE_CONSTANT_TSC) is true:
> no kvmclock_cpufreq_notifier, try aperf/mperf, or try 
> cpufreq_quick_get(), or use cpu_khz
> 
> 2, boot_cpu_has(X86_FEATURE_CONSTANT_TSC) is false:
> during installing kmod, try aperf/mperf, or try cpufreq_quick_get(), or 
> use cpu_khz;
> and get changed by kvmclock_cpufreq_notifier.
> 
> I tested on Skylake&Icelake CPU, and got different CPU frequency from 
> host & guest, the main purpose of this patch is to get the same frequency.
> 

Note that on my Zen2 machine (3970X), aperf/mperf returns current cpu freqency,
as now see in /proc/cpuinfo, while TSC is always running with base CPU clock frequency (3.7 GHZ)
(that is max frequency that CPU is guranteed to run with, anything above is boost 'bonus')

[mlevitsk@starship ~/Kernel/br-vm-64/src]$cat /proc/cpuinfo | grep "cpu MHz"
cpu MHz		: 3685.333
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2761.946
cpu MHz		: 2200.000
cpu MHz		: 2200.000
cpu MHz		: 2200.000
...

[mlevitsk@starship ~/Kernel/master/src]$dmesg | grep tsc
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3700.230 MHz processor
...


Before I forget about it I do want to point out few things
that are not 100% related to this thread but do related to TSC:

1. It sucks that on AMD, the TSC frequency is calibrated from other 
clocksources like PIT/HPET, since the result is not exact and varies
from boot to boot. I do wonder if they have something like that
APERF/MPERF thing which sadly is not what I was looking for.

2. In the guest on AMD, we mark the TSC as unsynchronized always due to the code
in unsynchronized_tsc, unless invariant tsc is used in guest cpuid,
which is IMHO not fair to AMD as we don't do this for  Intel cpus.
(look at unsynchronized_tsc function)

3. I wish the kernel would export the tsc frequency it found to userspace
somewhere in /sys or /proc, as this would be very useful for userspace applications.
Currently it can only be found in dmesg if I am not mistaken..
I don't mind if such frequency would only be exported if the TSC is stable,
always running, not affected by CPUfreq, etc.


Best regards,
	Maxim Levitsky

