Return-Path: <kvm+bounces-37621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3682AA2CA69
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9E13168B33
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169C119AA58;
	Fri,  7 Feb 2025 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SDfXoL8b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6796A2A1D8
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738950031; cv=none; b=pAAfcF340PUi6adVs4NQfOxRYoGq7iX+5I9XGugKyZsOWoetN925vxTbk/LlXGfrtTwB75KjSHWmt6Z34ipO1Q8is1JF2UlZ2mmeQfbH9DmKyGvV4ms/lIl91VwLHb5Yg5fQeWg2Lu4pejQr85+V5hodau/NWcBstS4XaULDjZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738950031; c=relaxed/simple;
	bh=n1N6DGkGC6QwxHEMq4j7Rbj13/jC4Pq4IfD2QY1s1Pw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Ceqe3kZhVor7ht/LZO+YVoqKFVyKTBiLhQnJ6W61QP17q8c0bF/Ai5OozHn7bGpo42a5StTDssKNdC7WeoXqm+FiwRd0y2m9yDkKjwEfxMQrarrDBqwetX31pnyKzc5RihYeNK2ULcOCgz+304A7zYWAywJr9Vg5M3AF3yRi3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SDfXoL8b; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d0d7bceb62so10897615ab.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 09:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738950028; x=1739554828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W6g6EC0DlQs1BcSp3qdzq9mhvuRoS8MgcxiiAADEXXY=;
        b=SDfXoL8bkynAdler2+SvM3SJ/uUKzICGN2N7RHGO7dZsjMHTSUy2i/HNSZHW8LmCZt
         jei3XEQHmKTG3lqeGJajq9lQKEsjjBDSWA2IEsk9EoLDvTIL/oXOHVNN+khlKrJzUeIY
         lm+AgSiWwdzIwY+erk7KiRK2F00pTdglb8uv1lHBhub/PcN+aK33BKjCMBkwjzGBy89v
         RDw2mdr6MJrqxa0qbSVl+NfJC0swTYfbE3o3uwCqgMNFUDeXmToFij+Jg+adV6NMyM5/
         /oYvCwXqbpAuZOUohcUXJVlaaQMr5x7/g10qM05pyimWPF+IAX3q5IVIPHzSxb5EsKqT
         RwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738950028; x=1739554828;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6g6EC0DlQs1BcSp3qdzq9mhvuRoS8MgcxiiAADEXXY=;
        b=nN7iegLoiKc0GKCAzwG3nxbkcTXObHXZenThuGDoCoLNTQcSXltm2rH3Na8OULHITZ
         3exjhi1F/33jv6dhW4G0KHrSBtXgpADSOuotkCFIJuJ3YiUuTAm8Odlq5C6KZGQCxsCG
         0RacR6pKQI1YVZsSBrNCvz8yGyNgY4tZgLbQwVXEvvlLEOznxBcNrBVxzzNXdwSUP4+6
         tpAb1u/JkaxFgkbw9LkIMhOiUCZo6TZIijoGrPb+Kc0xDMMr62JIph63hCv2/JPNAqhw
         Oonv+UPi1BvXVBcZz9trI2d9Jpic6IcLGwITDoPaqSV4Jl1at8O44/1NPWjYSMrK60Dm
         XIrQ==
X-Gm-Message-State: AOJu0YxiwWmi4qcqmvoNWEyW3+M7JPNl1MamNdti34hiio1zfZsKucZb
	kiCDntlJ6syxflFG4WL8EPc255jY0V4eax4CmGzQrLLK+fGuZyHXdYhM3qv3W89XTUy8xA22puL
	1ZJbobv3jJo2CZpruF7M2uw==
X-Google-Smtp-Source: AGHT+IHtKdSmRw3KrNJTHOuSXouv2bBkqBXKW+IytKNHDdptcNJMvlCA7vo46uvyD4q70ZJ3g5nFmXPd+VMVBYwilQ==
X-Received: from ilbed6.prod.google.com ([2002:a05:6e02:4806:b0:3ce:8db7:b87a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1d89:b0:3d0:2b88:116c with SMTP id e9e14a558f8ab-3d13dd4aaadmr29772225ab.10.1738950028552;
 Fri, 07 Feb 2025 09:40:28 -0800 (PST)
Date: Fri, 07 Feb 2025 17:40:27 +0000
In-Reply-To: <86lduit1if.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 07 Feb 2025 11:52:56 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntjza11wms.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 06 Feb 2025 19:45:51 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Hey Marc, thanks for the review. I thought of a different solution at
>> the very bottom. Please let me know if that is preferable.

>> Marc Zyngier <maz@kernel.org> writes:

>> > Colton,

>> > On Thu, 06 Feb 2025 00:17:44 +0000,
>> > Colton Lewis <coltonlewis@google.com> wrote:

>> >> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
>> >> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
>> >> causes confusing compilation problems why trying to use anything
>> >> defined in any of the headers in any other headers. Header guards is
>> >> the only reason this cycle didn't create tons of redefinition
>> >> warnings.

>> >> The motivating example was figuring out it was impossible to use the
>> >> hypercall macros kvm_call_hyp* from kvm_host.h in arm_pmuv3.h. The
>> >> compiler will insist they aren't defined even though kvm_host.h is
>> >> included. Many other examples are lurking which could confuse
>> >> developers in the future.

>> > Well, that's because contrary to what you have asserted in v1, not all
>> > include files are legitimate to use willy-nilly. You have no business
>> > directly using asm/kvm_host.h, and linux/kvm_host.h is what you need.

>> That's what I'm trying to fix. I'm trying to *remove* asm/kvm_host.h
>> from being included in asm/arm_pmu.h.

>> I agree with you that it *should not be included there* but it currently
>> is. And I can't drop-in replace the include with linux/kvm_host.h
>> because the that just adds another link in the cyclical dependency.


>> >> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
>> >> because asm/kvm_host.h is huge and we only need a few functions from
>> >> it. Move the required declarations to a new header asm/kvm_pmu.h.

>> >> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> >> ---

>> >> Possibly spinning more definitions out of asm/kvm_host.h would be a
>> >> good idea, but I'm not interested in getting bogged down in which
>> >> functions ideally belong where. This is sufficient to break the

>> > Tough luck. I'm not interested in half baked solutions, and "what
>> > belongs where" *is* the problem that needs solving.

>> Fair point, but a small solution is not half-baked if it is better than
>> what we have.

> No. Less crap is still crap.

> This sort of reasoning may fly for a quick fix that would otherwise
> result in a a crash or something similarly unpleasant. But for a
> rework that is only there to enable your particular project, you have
> all the time in the world to do it right.

Point taken. I agree.


>> >> cyclical dependency and get rid of the compilation issues. Though I
>> >> mention the one example I found, many other similar problems could
>> >> confuse developers in the future.

>> >> v2:
>> >> * Make a new header instead of moving kvm functions into the
>> >>    dedicated pmuv3 header

>> >> v1:
>> >>  
>> https://lore.kernel.org/kvm/20250204195708.1703531-1-coltonlewis@google.com/

>> >>   arch/arm64/include/asm/arm_pmuv3.h |  3 +--
>> >>   arch/arm64/include/asm/kvm_host.h  | 14 --------------
>> >>   arch/arm64/include/asm/kvm_pmu.h   | 26 ++++++++++++++++++++++++++
>> >>   include/kvm/arm_pmu.h              |  1 -
>> >>   4 files changed, 27 insertions(+), 17 deletions(-)
>> >>   create mode 100644 arch/arm64/include/asm/kvm_pmu.h

>> >> diff --git a/arch/arm64/include/asm/arm_pmuv3.h
>> >> b/arch/arm64/include/asm/arm_pmuv3.h
>> >> index 8a777dec8d88..54dd27a7a19f 100644
>> >> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> >> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> >> @@ -6,9 +6,8 @@
>> >>   #ifndef __ASM_PMUV3_H
>> >>   #define __ASM_PMUV3_H

>> >> -#include <asm/kvm_host.h>
>> >> -
>> >>   #include <asm/cpufeature.h>
>> >> +#include <asm/kvm_pmu.h>
>> >>   #include <asm/sysreg.h>

>> >>   #define RETURN_READ_PMEVCNTRN(n) \
>> >> diff --git a/arch/arm64/include/asm/kvm_host.h
>> >> b/arch/arm64/include/asm/kvm_host.h
>> >> index 7cfa024de4e3..6d4a2e7ab310 100644
>> >> --- a/arch/arm64/include/asm/kvm_host.h
>> >> +++ b/arch/arm64/include/asm/kvm_host.h
>> >> @@ -1385,25 +1385,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct
>> >> kvm_vcpu *vcpu);
>> >>   void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>> >>   void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);

>> >> -static inline bool kvm_pmu_counter_deferred(struct perf_event_attr
>> >> *attr)
>> >> -{
>> >> -	return (!has_vhe() && attr->exclude_host);
>> >> -}
>> >> -
>> >>   #ifdef CONFIG_KVM
>> >> -void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> >> -void kvm_clr_pmu_events(u64 clr);
>> >> -bool kvm_set_pmuserenr(u64 val);
>> >>   void kvm_enable_trbe(void);
>> >>   void kvm_disable_trbe(void);
>> >>   void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
>> >>   #else
>> >> -static inline void kvm_set_pmu_events(u64 set, struct
>> >> perf_event_attr *attr) {}
>> >> -static inline void kvm_clr_pmu_events(u64 clr) {}
>> >> -static inline bool kvm_set_pmuserenr(u64 val)
>> >> -{
>> >> -	return false;
>> >> -}
>> >>   static inline void kvm_enable_trbe(void) {}
>> >>   static inline void kvm_disable_trbe(void) {}
>> >>   static inline void kvm_tracing_set_el1_configuration(u64
>> >> trfcr_while_in_guest) {}
>> >> diff --git a/arch/arm64/include/asm/kvm_pmu.h
>> >> b/arch/arm64/include/asm/kvm_pmu.h
>> >> new file mode 100644
>> >> index 000000000000..3a8f737504d2
>> >> --- /dev/null
>> >> +++ b/arch/arm64/include/asm/kvm_pmu.h
>> >> @@ -0,0 +1,26 @@
>> >> +/* SPDX-License-Identifier: GPL-2.0-only */
>> >> +
>> >> +#ifndef __KVM_PMU_H
>> >> +#define __KVM_PMU_H
>> >> +
>> >> +void kvm_vcpu_pmu_resync_el0(void);
>> >> +
>> >> +#ifdef CONFIG_KVM
>> >> +void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> >> +void kvm_clr_pmu_events(u64 clr);
>> >> +bool kvm_set_pmuserenr(u64 val);
>> >> +#else
>> >> +static inline void kvm_set_pmu_events(u64 set, struct
>> >> perf_event_attr *attr) {}
>> >> +static inline void kvm_clr_pmu_events(u64 clr) {}
>> >> +static inline bool kvm_set_pmuserenr(u64 val)
>> >> +{
>> >> +	return false;
>> >> +}
>> >> +#endif
>> >> +
>> >> +static inline bool kvm_pmu_counter_deferred(struct perf_event_attr
>> >> *attr)
>> >> +{
>> >> +	return (!has_vhe() && attr->exclude_host);
>> >> +}
>> >> +
>> >> +#endif

>> > How does this solve your problem of using the HYP-calling macros?

>> This code does not directly solve that problem. It makes a solution to
>> that problem possible because it breaks up the cyclical dependency by
>> getting asm/kvm_host.h out of asm/arm_pmuv3.h while still providing the
>> declarations to arm_pmuv3.c

>> With a cyclical dependency the compiler gets confused if you try to use
>> anything from asm/kvm_host.h inside asm/arm_pmuv3.h (like HYP-calling
>> macros defined there for example). Again, I believe that inclusion
>> should not be there in the first place which is the motivation for this
>> patch.

>> But since it is included, here's what happens if you try:

>> When asm/kvm_host.h is included somewhere, it indirectly includes
>> asm/arm_pmuv3.h via the chain described in my commit message.
>> asm/arm_pmuv3.h is then effectively pasted into asm/kvm_host.h and due
>> to include guards is passed over this time, but this means that many
>> things in asm/kvm_host.h aren't defined yet so any symbols from
>> asm/kvm_host.h defined after the include of asm/arm_pmuv3.h are used
>> before their definition: boom, confusing compiler errors

>> You might argue: just don't do that, but I think it's a terrible
>> developer experience when you can't use definitions from a file that is
>> currently included. I spent hours puzzling over errors before realizing
>> a cyclical dependency was the root cause and want to save other devs
>> from the same fate.

> Then do it correctly. Or don't do that. Nobody other than you gets
> confused by this, it seems.


>> >> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> >> index 147bd3ee4f7b..2c78b1b1a9bb 100644
>> >> --- a/include/kvm/arm_pmu.h
>> >> +++ b/include/kvm/arm_pmu.h
>> >> @@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
>> >>   struct kvm_pmu_events *kvm_get_pmu_events(void);
>> >>   void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>> >>   void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>> >> -void kvm_vcpu_pmu_resync_el0(void);

>> >>   #define kvm_vcpu_has_pmu(vcpu)					\
>> >>   	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

>> >> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b

>> > I'm absolutely not keen on *two* PMU-related include files. They both
>> > describe internal APIs, and don't see a good reasoning for this
>> > arbitrary split other than "it works better for me and I don't want to
>> > do more than strictly necessary".

>> I understand the point which is why v1 tried not to introduce a new
>> header file and I was advised to make a new header file.

>> > For example, include/kvm was only introduced to be able to share files
>> > between architectures, and with 32bit KVM/arm being long dead, this
>> > serves no purpose anymore. Moving these things out of the way would be
>> > a good start and would provide a better base for further change.

>> Good to know. I avoided doing that because it would be a lot of change
>> noise and I wasn't sure such changes would be welcome.

>> > So please present a rationale on what needs to go where and why based
>> > on their usage pattern rather than personal convenience, and then
>> > we'll look at a possible patch. But not the other way around.

>> My rationale is fixing a cyclical dependency due to an inclusion of
>> asm/kvm_host.h where we both seem to agree it shouldn't be. Cyclical
>> dependencies are really bad and cause nasty surprises when something
>> that seems like it should obviously work doesn't. Fixing things like
>> this makes programming here more conveneint for everyone, not just
>> me. So I thought it was worth a separate patch.

> That's not a rationale. That's the umpteenth repetition of a circular
> argument. This "make it easy for everyone" is a total fallacy. If you
> really want to make it easy, split the include files using a clear
> definition of what goes where. That would *actually* help.


>> Another possible solution that avoids moving anything around is to take
>> asm/kvm_host.h out of asm/arm_pmuv3.h and do

>> #ifdef CONFIG_ARM64
>> #include <linux/kvm_host.h>
>> #endif

>> directly in arm_pmuv3.c which breaks the cycle while still providing the
>> correct declarations for arm_pmuv3.c (and admittedly many more than
>> necessary).

>> I find this conditional inclusion ugly and possibly you will have an
>> objection to it, but let me know.

> No. I want a full solution, not a point hack. Since you are not
> willing to define things, let me do it for you.

> - Anything that is at the interface between the host PMU driver and
>    KVM moves in its own include file. Nothing from kvm_host.h should be
>    needed for this, and the driver code only includes that particular
>    file.  Make is standalone, so that it doesn't require contextual
>    inclusions (see how your kvm_pmu.h doesn't include anything, and yet
>    depends on perf_event_attr being defined as well as has_vhe()).

> - Anything that is internal to KVM moves to kvm_host.h. Eventually,
>    this could move to a kvm_internal.h that is nobody else's business
>    (just like we have a vgic.h that is not visible to anyone).

> - include/kvm/arm_pmu.h dies.

> And since I like putting my words into action, here's the result of a
> 10 minute rework:

> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-includes

> Not exactly rocket science.

Thank you for the example. You are right it isn't hard. It's just moving
some code around. I'm sorry if I've irritated you. I don't like lazy
point hacks either. My goal was to best communicate the intent of the
change by changing exactly what needed to change and no more.

I'll learn from your example and attempt to exercise better taste for
the right way to do things in the future. I'm happy with killing
kvm/arm_pmu.h

