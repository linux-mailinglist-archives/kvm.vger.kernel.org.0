Return-Path: <kvm+bounces-37532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1D8A2B286
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C45FC188BA54
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6C41AB531;
	Thu,  6 Feb 2025 19:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2gx1ZHgm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5C41A23BF
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738871154; cv=none; b=SVW05DlswJllClANSi5slM4f0Bon/l2O51WXE6qHDOJkyvUvmvxQrMcYyhuKtMyLlkaqXaErkKQzzwzpomOL0VIoiTpRBZzi+sEXE/b/9XBxUJzbr3IDLIyP+CfFIQzaCqiEYuO6KdqH8TnkFM7gId62KtIt3mkGdXVXE7I4+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738871154; c=relaxed/simple;
	bh=O8clXKgjHAQejc7bfuCl6bjXFk1Ed3RO/7mnGfiKBpU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PxPoKqx25Qg/0Q2m1ll/PDJEv2F2D6ahAxGgVXD8VJ47txZUl1VfXS6KcTl5usCNBvfFPlm6z7Uena+H88tYzBbujAC2ZvlaVt9dsMTetJfgbOyYo2F/XBjO76iTL0XR6iJrr9mu1X94m1WyQqcIboEiSOeqQpIGvTbeQd9sTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2gx1ZHgm; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-844d5c7d664so93682139f.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 11:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738871152; x=1739475952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YbCfEtYjJ8HgdzmC6edBJv5q8C9brW4RxPoXoV16zfg=;
        b=2gx1ZHgmSbvbrhjx/bBNgs5m1SAYm60WvBAtPbBjft0A/BWd4NMuGWeTizbw4WIihB
         8u3nYcUWnZx2EcDcdEKtkQVxU2pbnnEU1g0ID45702UjtG3TbHIE4fQEuTmybPcgdw6k
         6705iIyD17dW6+kMu/kcx3ZQOCb0qhZarx6sqoiJz1ApMJippAL0Od+7mPkP/qdt7SGl
         ITI2NV00JFHXVMIbeWd6A9hCzAwdemeXP63c2LAtdQVIuLPjCFBDXaUekh5QitzcMDLt
         GnCktKAjl4gblv+Mk5L523RScj94qIRTs3HVHu+rzCLkm/dUvh0qB1hcZJ6wEwjklWHd
         EkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738871152; x=1739475952;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbCfEtYjJ8HgdzmC6edBJv5q8C9brW4RxPoXoV16zfg=;
        b=mlWosSOa5dNPrFbeas/ffk3KJbRf/YRbITkRJvqYygiyEz7veYMgC7nOca1YHcEF4r
         9ewBmpanLt40A39WrVHsu/AOSfDciddvfKpLcKy6StYQ6KgbSONJ/LxYM2/jJcr7TT+h
         qz261/JHgP8ihRQ8UoSWm/oLTcOJR2d7CKJx8kyB2lvMHhqAiZXdSGKYZ7OTbtIHLLfC
         aXWRx3vTh9VdPGlmnIKaa5E/pPH/nOIvl3BMHJrzOFxdX0WyakivesybzGZwPkW32GRy
         JifeeKq7lMu+agIcikiMxnM/05BotcqIcLO97PNqhvZ9HEOhFYvusUjX1U9II8MldmaB
         6liw==
X-Gm-Message-State: AOJu0YzfjoOgBoqtEEhLvGb5NfDvc99cYZ53j5TEBAn/qZqOx6pS0Y/E
	nUAHBo4TVATQZLg+2u6nuOqJ/tI2tlH2XhN9+JK4jLi3OsWvcxBBl4butjPuGAOwOqeKzPgvtgZ
	02QJ29Xzm2piEz/OUZG7TiQ==
X-Google-Smtp-Source: AGHT+IFNNmO9kDGnCQ3Tcv/rO4jc58g75MwHio/abi5ncLytMBu/Tab1kPhA/Bby7F9V3R2isfkFKifDgylapF+8eQ==
X-Received: from ilmy18.prod.google.com ([2002:a92:d812:0:b0:3d0:ebcd:cf64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c0e:b0:3d0:4e57:bbd3 with SMTP id e9e14a558f8ab-3d13dfa2297mr2468995ab.22.1738871151883;
 Thu, 06 Feb 2025 11:45:51 -0800 (PST)
Date: Thu, 06 Feb 2025 19:45:51 +0000
In-Reply-To: <87frkrtr4z.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 06 Feb 2025 08:27:08 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntmsey26xc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hey Marc, thanks for the review. I thought of a different solution at
the very bottom. Please let me know if that is preferable.

Marc Zyngier <maz@kernel.org> writes:

> Colton,

> On Thu, 06 Feb 2025 00:17:44 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
>> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
>> causes confusing compilation problems why trying to use anything
>> defined in any of the headers in any other headers. Header guards is
>> the only reason this cycle didn't create tons of redefinition
>> warnings.

>> The motivating example was figuring out it was impossible to use the
>> hypercall macros kvm_call_hyp* from kvm_host.h in arm_pmuv3.h. The
>> compiler will insist they aren't defined even though kvm_host.h is
>> included. Many other examples are lurking which could confuse
>> developers in the future.

> Well, that's because contrary to what you have asserted in v1, not all
> include files are legitimate to use willy-nilly. You have no business
> directly using asm/kvm_host.h, and linux/kvm_host.h is what you need.

That's what I'm trying to fix. I'm trying to *remove* asm/kvm_host.h
from being included in asm/arm_pmu.h.

I agree with you that it *should not be included there* but it currently
is. And I can't drop-in replace the include with linux/kvm_host.h
because the that just adds another link in the cyclical dependency.


>> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
>> because asm/kvm_host.h is huge and we only need a few functions from
>> it. Move the required declarations to a new header asm/kvm_pmu.h.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---

>> Possibly spinning more definitions out of asm/kvm_host.h would be a
>> good idea, but I'm not interested in getting bogged down in which
>> functions ideally belong where. This is sufficient to break the

> Tough luck. I'm not interested in half baked solutions, and "what
> belongs where" *is* the problem that needs solving.

Fair point, but a small solution is not half-baked if it is better than
what we have.

>> cyclical dependency and get rid of the compilation issues. Though I
>> mention the one example I found, many other similar problems could
>> confuse developers in the future.

>> v2:
>> * Make a new header instead of moving kvm functions into the
>>    dedicated pmuv3 header

>> v1:
>> https://lore.kernel.org/kvm/20250204195708.1703531-1-coltonlewis@google.com/

>>   arch/arm64/include/asm/arm_pmuv3.h |  3 +--
>>   arch/arm64/include/asm/kvm_host.h  | 14 --------------
>>   arch/arm64/include/asm/kvm_pmu.h   | 26 ++++++++++++++++++++++++++
>>   include/kvm/arm_pmu.h              |  1 -
>>   4 files changed, 27 insertions(+), 17 deletions(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_pmu.h

>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index 8a777dec8d88..54dd27a7a19f 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -6,9 +6,8 @@
>>   #ifndef __ASM_PMUV3_H
>>   #define __ASM_PMUV3_H

>> -#include <asm/kvm_host.h>
>> -
>>   #include <asm/cpufeature.h>
>> +#include <asm/kvm_pmu.h>
>>   #include <asm/sysreg.h>

>>   #define RETURN_READ_PMEVCNTRN(n) \
>> diff --git a/arch/arm64/include/asm/kvm_host.h  
>> b/arch/arm64/include/asm/kvm_host.h
>> index 7cfa024de4e3..6d4a2e7ab310 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1385,25 +1385,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu  
>> *vcpu);
>>   void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>>   void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);

>> -static inline bool kvm_pmu_counter_deferred(struct perf_event_attr  
>> *attr)
>> -{
>> -	return (!has_vhe() && attr->exclude_host);
>> -}
>> -
>>   #ifdef CONFIG_KVM
>> -void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> -void kvm_clr_pmu_events(u64 clr);
>> -bool kvm_set_pmuserenr(u64 val);
>>   void kvm_enable_trbe(void);
>>   void kvm_disable_trbe(void);
>>   void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
>>   #else
>> -static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr  
>> *attr) {}
>> -static inline void kvm_clr_pmu_events(u64 clr) {}
>> -static inline bool kvm_set_pmuserenr(u64 val)
>> -{
>> -	return false;
>> -}
>>   static inline void kvm_enable_trbe(void) {}
>>   static inline void kvm_disable_trbe(void) {}
>>   static inline void kvm_tracing_set_el1_configuration(u64  
>> trfcr_while_in_guest) {}
>> diff --git a/arch/arm64/include/asm/kvm_pmu.h  
>> b/arch/arm64/include/asm/kvm_pmu.h
>> new file mode 100644
>> index 000000000000..3a8f737504d2
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_pmu.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +
>> +#ifndef __KVM_PMU_H
>> +#define __KVM_PMU_H
>> +
>> +void kvm_vcpu_pmu_resync_el0(void);
>> +
>> +#ifdef CONFIG_KVM
>> +void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> +void kvm_clr_pmu_events(u64 clr);
>> +bool kvm_set_pmuserenr(u64 val);
>> +#else
>> +static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr  
>> *attr) {}
>> +static inline void kvm_clr_pmu_events(u64 clr) {}
>> +static inline bool kvm_set_pmuserenr(u64 val)
>> +{
>> +	return false;
>> +}
>> +#endif
>> +
>> +static inline bool kvm_pmu_counter_deferred(struct perf_event_attr  
>> *attr)
>> +{
>> +	return (!has_vhe() && attr->exclude_host);
>> +}
>> +
>> +#endif

> How does this solve your problem of using the HYP-calling macros?

This code does not directly solve that problem. It makes a solution to
that problem possible because it breaks up the cyclical dependency by
getting asm/kvm_host.h out of asm/arm_pmuv3.h while still providing the
declarations to arm_pmuv3.c

With a cyclical dependency the compiler gets confused if you try to use
anything from asm/kvm_host.h inside asm/arm_pmuv3.h (like HYP-calling
macros defined there for example). Again, I believe that inclusion
should not be there in the first place which is the motivation for this
patch.

But since it is included, here's what happens if you try:

When asm/kvm_host.h is included somewhere, it indirectly includes
asm/arm_pmuv3.h via the chain described in my commit message.
asm/arm_pmuv3.h is then effectively pasted into asm/kvm_host.h and due
to include guards is passed over this time, but this means that many
things in asm/kvm_host.h aren't defined yet so any symbols from
asm/kvm_host.h defined after the include of asm/arm_pmuv3.h are used
before their definition: boom, confusing compiler errors

You might argue: just don't do that, but I think it's a terrible
developer experience when you can't use definitions from a file that is
currently included. I spent hours puzzling over errors before realizing
a cyclical dependency was the root cause and want to save other devs
from the same fate.

>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 147bd3ee4f7b..2c78b1b1a9bb 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
>>   struct kvm_pmu_events *kvm_get_pmu_events(void);
>>   void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>>   void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>> -void kvm_vcpu_pmu_resync_el0(void);

>>   #define kvm_vcpu_has_pmu(vcpu)					\
>>   	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

>> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b

> I'm absolutely not keen on *two* PMU-related include files. They both
> describe internal APIs, and don't see a good reasoning for this
> arbitrary split other than "it works better for me and I don't want to
> do more than strictly necessary".

I understand the point which is why v1 tried not to introduce a new
header file and I was advised to make a new header file.

> For example, include/kvm was only introduced to be able to share files
> between architectures, and with 32bit KVM/arm being long dead, this
> serves no purpose anymore. Moving these things out of the way would be
> a good start and would provide a better base for further change.

Good to know. I avoided doing that because it would be a lot of change
noise and I wasn't sure such changes would be welcome.

> So please present a rationale on what needs to go where and why based
> on their usage pattern rather than personal convenience, and then
> we'll look at a possible patch. But not the other way around.

My rationale is fixing a cyclical dependency due to an inclusion of
asm/kvm_host.h where we both seem to agree it shouldn't be. Cyclical
dependencies are really bad and cause nasty surprises when something
that seems like it should obviously work doesn't. Fixing things like
this makes programming here more conveneint for everyone, not just
me. So I thought it was worth a separate patch.

Another possible solution that avoids moving anything around is to take
asm/kvm_host.h out of asm/arm_pmuv3.h and do

#ifdef CONFIG_ARM64
#include <linux/kvm_host.h>
#endif

directly in arm_pmuv3.c which breaks the cycle while still providing the
correct declarations for arm_pmuv3.c (and admittedly many more than
necessary).

I find this conditional inclusion ugly and possibly you will have an
objection to it, but let me know.

