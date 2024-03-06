Return-Path: <kvm+bounces-11192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 812E5874149
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 21:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDB981F260E7
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 20:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F019214265E;
	Wed,  6 Mar 2024 20:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CgirPrj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C914262B
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 20:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709756235; cv=none; b=UhTZ+/cHXCUnrrH39pNr6rmwF9W71/IwZdQhQaM6AY2Uk1sYlC8TT/fgcV/EFZ18OBX3a1wcGN2Rx5kJJBHuP9qSU88OYczDWrpNzeAKPyorD6qqXsUPYhLaFNCo/n0tTH1980jI71trALwSDzVz3xzGXSA8GvxQlwqZFSTsi9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709756235; c=relaxed/simple;
	bh=34ASYYJBHPQCh6NcHoNdgyVLSpRzHrrx0vJzN8aXVCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fYD6TgVtRqdKZqjsybVyHHpgjZHZGx9Oj0JbwgvgzwlSEMhTsOYdx6R7VhGg23vB2v96MKuvyl6Pux3viQSE+7BT8N9QUOnI29x1Rfzk5tOSWnAQ7ZbDbzR5oVGMczVNlm2IcDDGkrDlyGMiACLU2BnZolNy0elRGbcYFFrllcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CgirPrj5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6096493f3d3so2048487b3.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 12:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709756231; x=1710361031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/urHmiK1ZdnYbzrZXS3jjImQq88qV6KdiEQUGd+wkIQ=;
        b=CgirPrj5uJmPiuRSTj8RwabMJWv6vlBD/uHo7/mv5iivtpzYZmLfULGAftxMm3TIbL
         n54ZuRJkekbG/jBcV894dLIxrFiVeKPAnZHhqfIUVMCtJoG9clrconmw2SXwvYnJ0ged
         72Hx2pEJKw0tPxybOGroY8k8OHJm2oppxCWjS/Apd7tNQ2+HliDe9TOsEWfaoGU/Qtlf
         zP50T6U3NtfCbhHOR7qX5zwwKLMOljieVnv7Dz+pSajXx/9/mtRnrPBJHbCbaNh+78H2
         fpGF21TSOtIvKx3+tp/tGY9rAkVE0wqy3TUajIddSu7myP/4wx+gk7R50VgK7AmfH6li
         niLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709756231; x=1710361031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/urHmiK1ZdnYbzrZXS3jjImQq88qV6KdiEQUGd+wkIQ=;
        b=Quzy+8yIo7Nfx+EDCX/BaNNonUuy2JnXcQpWFDJU/dzNRWLQzIaPDgBiZqZfFqrVNM
         DkprhO45hPPflFLebFRBFOAhrRPzvDwKm+ceAhYeReM9axAwzgn3j7B8cJOrCa4DGids
         tR9DN79iu0Yc/t9kXbmWQ9F+cJ5lXygFekfBthrSNLugOPI5+vN3Hg1dJQ61Mxtfjk8k
         W5yEGw/F95DpI2xbCPABWa0bceXgAlot6iWJPLCgMc+P9qyZawIkV/vFlN24CW5/mrQQ
         hDOQpv2c4PcY+N0mvHKi8z2WysaDWzy7FNXaJuOe917Xkynvf3K2whRe1eIXHo2jA/8S
         yfpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNz8fLww3gG/R/hpDBUYcbaYtFiwjKvW2JLY/Blb5iut3fciRgG+X/eQFCZgHOJLCDckSPfxi02EEcMrtksgneXZ4Z
X-Gm-Message-State: AOJu0YxOL30xXsNy9ZW1nVHA+BF3+nhMDKeup0CkvB9xpAaH6DFOaMFJ
	6ndLvjQY96a9xsor/t++IA+1xh223TNEsHB3EeAhqSNnOvRYFH0UZa1wzLrHUL/TPskjuQ0r6gg
	Y6w==
X-Google-Smtp-Source: AGHT+IG09L7eegOjtxuiHca6RcNEfdQIhkjEZzrNEMx0+YCwa9i3voy/utj2HShZtmX9Gpltv2fLzFpNkGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1148:b0:dc6:b813:5813 with SMTP id
 p8-20020a056902114800b00dc6b8135813mr539849ybu.9.1709756231503; Wed, 06 Mar
 2024 12:17:11 -0800 (PST)
Date: Wed, 6 Mar 2024 20:17:10 +0000
In-Reply-To: <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
 <ZeepGjHCeSfadANM@google.com> <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
Message-ID: <ZejPRlFpWNRs5jzp@google.com>
Subject: Re: [Patch v3] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Like Xu <likexu@tencent.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Like Xu wrote:
> > > @@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> > >   			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
> > >   			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > >   				pmu->fixed_ctr_ctrl_mask &=
> > > -					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
> > 
> > OMG, this might just win the award for most obfuscated PMU code in KVM, which is
> > saying something.  The fact that INTEL_PMC_IDX_FIXED happens to be 32, the same
> > bit number as ICL_FIXED_0_ADAPTIVE, is 100% coincidence.  Good riddance.
> > 
> > Argh, and this goofy code helped introduce a real bug.  reprogram_fixed_counters()
> > doesn't account for the upper 32 bits of IA32_FIXED_CTR_CTRL.
> > 
> > Wait, WTF?  Nothing in KVM accounts for the upper bits.  This can't possibly work.
> > 
> > IIUC, because KVM _always_ sets precise_ip to a non-zero bit for PEBS events,
> > perf will _always_ generate an adaptive record, even if the guest requested a
> > basic record.  Ugh, and KVM will always generate adaptive records even if the
> > guest doesn't support them.  This is all completely broken.  It probably kinda
> > sorta works because the Basic info is always stored in the record, and generating
> > more info requires a non-zero MSR_PEBS_DATA_CFG, but ugh.
> 
> Yep, it works at least on machines with both adaptive and pebs_full features.

*AND* if the guest uses PEBS exactly the same way that the Linux kernel uses PEBS.

> Mingwei or others are encouraged to construct use cases in KUT::pmu_pebs.flat
> that violate guest-pebs rules (e.g., leak host state), as we all recognize
> that testing is the right way to condemn legacy code, not just lengthy emails.

*sigh*

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index f7b52b90..43e7a207 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -212,8 +212,12 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
        u64 baseline_extra_ctrl = 0, fixed_ctr_ctrl = 0;
        unsigned int idx;
 
-       if (has_baseline)
-               wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
+       if (has_baseline) {
+               if (pebs_data_cfg)
+                       wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
+               else
+                       wrmsr(MSR_PEBS_DATA_CFG, 0xf);
+       }
 
        ds = (struct debug_store *)ds_bufer;
        ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
@@ -224,7 +228,7 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
        for (idx = 0; idx < pmu.nr_fixed_counters; idx++) {
                if (!(BIT_ULL(FIXED_CNT_INDEX + idx) & bitmask))
                        continue;
-               if (has_baseline)
+               if (has_baseline && pebs_data_cfg)
                        baseline_extra_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
                wrmsr(MSR_PERF_FIXED_CTRx(idx), ctr_start_val);
                fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
@@ -235,7 +239,7 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
        for (idx = 0; idx < max_nr_gp_events; idx++) {
                if (!(BIT_ULL(idx) & bitmask))
                        continue;
-               if (has_baseline)
+               if (has_baseline && pebs_data_cfg)
                        baseline_extra_ctrl = ICL_EVENTSEL_ADAPTIVE;
                wrmsr(MSR_GP_EVENT_SELECTx(idx), EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
                                                 intel_arch_events[idx] | baseline_extra_ctrl);

FAIL: Multiple (0x700000055): PEBS record (written seq 0) is verified (including size, counters and cfg).
FAIL: The pebs_record_size (488) doesn't match with MSR_PEBS_DATA_CFG (32).
FAIL: The pebs_data_cfg (0xf) doesn't match with MSR_PEBS_DATA_CFG (0x0).
FAIL: GP counter 0 (0xfffffffffffe): PEBS record (written seq 0) is verified (including size, counters and cfg).
FAIL: The pebs_record_size (488) doesn't match with MSR_PEBS_DATA_CFG (32).
FAIL: The pebs_data_cfg (0xf) doesn't match with MSR_PEBS_DATA_CFG (0x0).
FAIL: Multiple (0x700000055): PEBS record (written seq 0) is verified (including size, counters and cfg).
FAIL: The pebs_record_size (488) doesn't match with MSR_PEBS_DATA_CFG (32).
FAIL: The pebs_data_cfg (0xf) doesn't match with MSR_PEBS_DATA_CFG (0x0).

> > Oh great, and it gets worse.  intel_pmu_disable_fixed() doesn't clear the upper
> > bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set.  Unless I'm misreading the code,
> > intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE either,
> > as it only modifies the bit when it wants to set ICL_FIXED_0_ADAPTIVE.
> > 
> > *sigh*
> > 
> > I'm _very_ tempted to disable KVM PEBS support for the current PMU, and make it
> > available only when the so-called passthrough PMU is available[*].  Because I
> > don't see how this is can possibly be functionally correct, nor do I see a way
> > to make it functionally correct without a rather large and invasive series.
> 
> Considering that I've tried the idea myself, I have no inclination towards
> "passthrough PMU", and I'd like to be able to take the time to review that
> patchset while we all wait for a clear statement from that perf-core man,
> who don't really care about virtualization and don't want to lose control
> of global hardware resources.
> 
> Before we actually get to that ideal state you want, we have to deal with
> some intermediate state and face to any users that rely on the current code,

It's not an ideal state, it's simply the only way I see to get things like adaptive
PEBS to work safely, reliably, and correctly without taking on an absurd amount of
complexity.

> you had urged to merge in a KVM document for vPMU, not sure how far
> along that part of the work is.

> > Ouch.  And after chatting with Mingwei, who asked the very good question of
> > "can this leak host state?", I am pretty sure that yes, this can leak host state.
> 
> The Basic Info has a tsc field, I suspect it's the host-state-tsc.

It's not, the CPU offsets it correctly, at least on ICX (I haven't check scaling).

> > When PERF_CAP_PEBS_BASELINE is enabled for the guest, i.e. when the guest has
> > access to adaptive records, KVM gives the guest full access to MSR_PEBS_DATA_CFG
> > 
> > 	pmu->pebs_data_cfg_mask = ~0xff00000full;
> > 
> > which makes sense in a vacuum, because AFAICT the architecture doesn't allow
> > exposing a subset of the four adaptive controls.
> > 
> > GPRs and XMMs are always context switched and thus benign, but IIUC, Memory Info
> > provides data that might now otherwise be available to the guest, e.g. if host
> > userspace has disallowed equivalent events via KVM_SET_PMU_EVENT_FILTER.
> 
> Indeed, KVM_SET_PMU_EVENT_FILTER doesn't work in harmony with
> guest-pebs, and I believe there is a big problem here, especially with the
> lack of targeted testing.
> 
> One reason for this is that we don't use this cockamamie API in our

Libeling APIs because they aren't useful for _your_ security goals doesn't mean
you get to ignore their existence when contributing upstream.  New features don't
necessarilly have to fully support existing capabilities, e.g. I would be a-ok
making KVM_SET_PMU_EVENT_FILTER mututally exclusive with exposing adapative PEBS
to the guest.  That way the user can at least know that filtering won't work if
adapative PEBS is exposed to the guest.

> large-scale production environments, and users of vPMU want to get real
> runtime information about physical cpus, not just virtualised hardware
> architecture interfaces.
> 
> > 
> > And unless I'm missing something, LBRs are a full leak of host state.  Nothing
> > in the SDM suggests that PEBS records honor MSR intercepts, so unless KVM is
> > also passing through LBRs, i.e. is context switching all LBR MSRs, the guest can
> > use PEBS to read host LBRs at will.
> 
> KVM is also passing through LBRs when guest uses LBR but not at the
> granularity of vm-exit/entry. I'm not sure if the LBR_EN bit is required
> to get LBR information via PEBS, also not confirmed whether PEBS-lbr
> can be enabled at the same time as independent LBR;
> 
> I recall that PEBS-assist, per cpu-arch, would clean up this part of the
> record when crossing root/non-root boundaries, or not generate record.

Nope.  The MSRs definitely leak to the guest.  The only hard part was figuring
out how to get perf to utilize LBRs without consuming every counter (`perf top`
was the extent of my knowledge, until now...).

E.g.

  perf record -b -e instructions

and

  FAIL: PEBS LBR record 0 isn't empty, got from = 'ffffffffc0a00ccb', to = 'ffffffffc0a010af', info = '2'
  FAIL: PEBS LBR record 1 isn't empty, got from = 'ffffffffc0a010aa', to = 'ffffffffc0a00cb0', info = '6'
  FAIL: PEBS LBR record 2 isn't empty, got from = 'ffffffffc0a00e06', to = 'ffffffffc0a01090', info = '1'
  FAIL: PEBS LBR record 3 isn't empty, got from = 'ffffffffc0a00df4', to = 'ffffffffc0a00e00', info = '2'
  FAIL: PEBS LBR record 4 isn't empty, got from = 'ffffffffc0a00dbc', to = 'ffffffffc0a00de0', info = '1'
  FAIL: PEBS LBR record 5 isn't empty, got from = 'ffffffffc0a00f63', to = 'ffffffffc0a00db5', info = '1'
  FAIL: PEBS LBR record 6 isn't empty, got from = 'ffffffffc0903f23', to = 'ffffffffc0a00f61', info = '11'
  FAIL: PEBS LBR record 7 isn't empty, got from = 'ffffffffc0a00f5c', to = 'ffffffffc0903f10', info = '1'
  FAIL: PEBS LBR record 8 isn't empty, got from = 'ffffffffc0a00db0', to = 'ffffffffc0a00f55', info = '1'
  FAIL: PEBS LBR record 9 isn't empty, got from = 'ffffffff8f6b2c23', to = 'ffffffffc0a00da6', info = 'a'
  FAIL: PEBS LBR record 10 isn't empty, got from = 'ffffffffc0a00da1', to = 'ffffffff8f6b2b60', info = '7'
  FAIL: PEBS LBR record 11 isn't empty, got from = 'ffffffff8eba1b85', to = 'ffffffffc0a00d9a', info = '6'
  FAIL: PEBS LBR record 12 isn't empty, got from = 'ffffffff8eba1b8c', to = 'ffffffff8eba1b3f', info = '1'
  FAIL: PEBS LBR record 13 isn't empty, got from = 'ffffffff8eba1b2d', to = 'ffffffff8eba1b87', info = 'e'
  FAIL: PEBS LBR record 14 isn't empty, got from = 'ffffffff8eba1aff', to = 'ffffffff8eba1b18', info = '7'
  FAIL: PEBS LBR record 15 isn't empty, got from = 'ffffffff8eb996e0', to = 'ffffffff8eba1aeb', info = '2'
  FAIL: PEBS LBR record 16 isn't empty, got from = 'ffffffff8eb9963a', to = 'ffffffff8eb996cc', info = '1'
  FAIL: PEBS LBR record 17 isn't empty, got from = 'ffffffff8eb995ef', to = 'ffffffff8eb9962f', info = '1'
  FAIL: PEBS LBR record 18 isn't empty, got from = 'ffffffff8f6b30a1', to = 'ffffffff8eb995df', info = '4'
  FAIL: PEBS LBR record 19 isn't empty, got from = 'ffffffff8eb995da', to = 'ffffffff8f6b3070', info = '2'
  FAIL: PEBS LBR record 20 isn't empty, got from = 'ffffffff8eba1ae6', to = 'ffffffff8eb995c0', info = '6'
  FAIL: PEBS LBR record 21 isn't empty, got from = 'ffffffffc0a00d95', to = 'ffffffff8eba1a90', info = '2'
  FAIL: PEBS LBR record 22 isn't empty, got from = 'ffffffff8eb69135', to = 'ffffffffc0a00d89', info = '2'
  FAIL: PEBS LBR record 23 isn't empty, got from = 'ffffffff8eb690d6', to = 'ffffffff8eb69104', info = '2'
  FAIL: PEBS LBR record 24 isn't empty, got from = 'ffffffff8eb69102', to = 'ffffffff8eb690c3', info = '1'
  FAIL: PEBS LBR record 25 isn't empty, got from = 'ffffffff8eb6f442', to = 'ffffffff8eb69100', info = '2'
  FAIL: PEBS LBR record 26 isn't empty, got from = 'ffffffff8eb6f3f3', to = 'ffffffff8eb6f429', info = '5'
  FAIL: PEBS LBR record 27 isn't empty, got from = 'ffffffff8eb6f3a6', to = 'ffffffff8eb6f3c3', info = '2'
  FAIL: PEBS LBR record 28 isn't empty, got from = 'ffffffff8eb690fb', to = 'ffffffff8eb6f390', info = '2'
  FAIL: PEBS LBR record 29 isn't empty, got from = 'ffffffff8eb690c1', to = 'ffffffff8eb690d8', info = '2'
  FAIL: PEBS LBR record 30 isn't empty, got from = 'ffffffff8eb6907b', to = 'ffffffff8eb690b1', info = '1'
  FAIL: PEBS LBR record 31 isn't empty, got from = 'ffffffff8eb690af', to = 'ffffffff8eb6906e', info = '1'

> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > index 41a4533f9989..a2f827fa0ca1 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -392,7 +392,7 @@ static inline bool vmx_pt_mode_is_host_guest(void)
> >   static inline bool vmx_pebs_supported(void)
> >   {
> > -       return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> > +       return false;
> 
> As you know, user-space VMM may disable guest-pebs by filtering out the
> MSR_IA32_PERF_CAPABILITIE.PERF_CAP_PEBS_FORMAT or CPUID.PDCM.

Relying on userspace to fudge around KVM bugs is not acceptable for upstream.
PMU virtualization is already a bit dicey in that KVM relies on userspace to
filter out sensitive events, but leaking host addresses and failing to correctly
virtualize the architecture is an entirely different level of wrong.

> In the end, if our great KVM maintainers insist on doing this,
> there is obviously nothing I can do about it.

Bullshit.  There is plenty you could have done to prevent this.  It took me what,
6 hours total?  To (a) realize the code is buggy, (b) type up an email, and (c)
modify tests to confirm the bugs.  And at least half of that time was due to me
floundering around trying to generate LBR records because I know nothing about
the perf tool.

If you were more interested in ensuring KVM is maintainble, secure, and functionally
correct, we wouldn't be where we are today.

