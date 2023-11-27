Return-Path: <kvm+bounces-2531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B25197FAB2B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3C361C20E0E
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5373045C15;
	Mon, 27 Nov 2023 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [IPv6:2a02:4780:10:3cd9::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8566D1B6;
	Mon, 27 Nov 2023 12:17:45 -0800 (PST)
Received: by gentwo.org (Postfix, from userid 1003)
	id B7CFE41AEE; Mon, 27 Nov 2023 12:17:43 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B6CC641AED;
	Mon, 27 Nov 2023 12:17:43 -0800 (PST)
Date: Mon, 27 Nov 2023 12:17:43 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@linux.com>
To: Mihai Carabas <mihai.carabas@oracle.com>
cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
    linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, akpm@linux-foundation.org, 
    pmladek@suse.com, peterz@infradead.org, dianders@chromium.org, 
    npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
    juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
    ankur.a.arora@oracle.com
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-Reply-To: <724589ce-7656-4be0-aa37-f6edeb92e1c4@oracle.com>
Message-ID: <277fbd0d-25ea-437e-2ea7-6121c4e269db@linux.com>
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com> <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com> <6bd5fd43-552d-b020-1338-d89279f7a517@linux.com> <724589ce-7656-4be0-aa37-f6edeb92e1c4@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1152771662-1701116263=:544079"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1152771662-1701116263=:544079
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 22 Nov 2023, Mihai Carabas wrote:

> La 22.11.2023 22:51, Christoph Lameter a scris:
>> 
>> On Mon, 20 Nov 2023, Mihai Carabas wrote:
>> 
>>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>>> smp_cond_load_relaxed which basically does a "wfe".
>> 
>> Well it clears events first (which requires the first WFE) and then does a 
>> WFE waiting for any events if no events were pending.
>> 
>> WFE does not cause a VMEXIT? Or does the inner loop of 
>> smp_cond_load_relaxed now do 2x VMEXITS?
>> 
>> KVM ARM64 code seems to indicate that WFE causes a VMEXIT. See 
>> kvm_handle_wfx().
>
> In KVM ARM64 the WFE traping is dynamic: it is enabled only if there are more 
> tasks waiting on the same core (e.g. on an oversubscribed system).
>
> In arch/arm64/kvm/arm.c:
>
>  457 >-------if (single_task_running())
>  458 >------->-------vcpu_clear_wfx_traps(vcpu);
>  459 >-------else
>  460 >------->-------vcpu_set_wfx_traps(vcpu);

Ahh. Cool did not know about that. But still: Lots of VMEXITs once the 
load has to be shared.

> This of course can be improved by having a knob where you can completly 
> disable wfx traping by your needs, but I left this as another subject to 
> tackle.

kvm_arch_vcpu_load() looks strange. On the one hand we pass a cpu 
number into it and then we use functions that only work if we are running 
on that cpu?

It would be better to use smp_processor_id() in the function 
and not pass the cpu number to it.
--8323329-1152771662-1701116263=:544079--

