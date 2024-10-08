Return-Path: <kvm+bounces-28137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FEAE995266
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 16:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6D1C284AE1
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 14:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5211E0480;
	Tue,  8 Oct 2024 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnHFE9D0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F81DFE16
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728399078; cv=none; b=IX92zYchAi9VA/EzVbZ6mS46i8vatjCk7Zo6ABqMShSdxPoKHZJAJlWAJ5zocsSgKUs4eHOJxvKzXtpiFFLfwR8bBFmVOavANhEmWMUB0py5QX2kSH9QkkysuqnZgbdj3RaQTwipWlFqsR/grBl1TqOJEDzUer51HqpfFNh6fkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728399078; c=relaxed/simple;
	bh=ZgSRuvfGZ0ItcV/YwoUKTRPIr6VJ33TVYlDf96a8E7w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aGi8XurmYYYur2eAKwumh5lSa5dbgNcT9AI4RFRQHp2GGCh2J5hMhpQRunK8pH86b0bvvmO7dlIxFglMRTd2wa2tsj02dU+Hn7Cw1oNKfYP35v4aaf5szj7zqM8t0cfEpC+jRBANuW7vbx66seoblxjZgJW3ceiNH1f7gP6leRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnHFE9D0; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e262e764f46so9604939276.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2024 07:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728399076; x=1729003876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=emQng1abso/nTmgu6ZsfIn6KMzH8O2Ep6fGhK6qECAo=;
        b=cnHFE9D0vSc+ODj4Khd3GrOFDWrGjz8ZB5mJj7b+bmjXN70DXMU/qYD8GJhXf7/5lE
         aWzR1PKdtQNnRibh07lsrpvTzJnKRnib5FOvfLwC9BDowlsHxvmn80TSwrURLYqHVDUC
         vZjEJ6bTlg7Ofwh3NxKXiLbUap5DjHlsn1DlckAe2TmBeHR9oxCumWC4iRgdXlhn0nnf
         t2jrQxXzr2ghj2zDAnVIKjKpHqPp68MjGyYxX1gm4UjNFlWcHPfviHK+c/Accv8LEf5n
         ZiF6f53ZBuMRmJK0sZ9BD00TzuvPeF+w/5DvypGZ1k4lG/udOiJddfEZhTyv3+Kh0Qe7
         AytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728399076; x=1729003876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=emQng1abso/nTmgu6ZsfIn6KMzH8O2Ep6fGhK6qECAo=;
        b=cb1/w1D/44pXfpfk5EEuWMiHzRFkRtj2N2D6dcZSayHdp2d9FJaLVxK9MxPunseJdw
         jDc/Xue+E6GLIq3loVbsKNYJzjKCxVcsfxV1ts8VeO1bo4p9b2wN5n6Fh0S1d62e3/J0
         SdCNMS1jOvE+pUXHPQPts3adtZAC8ZmpEoO8UPBCsQyz/0hHkY2riu7GYNxauSrSy7f7
         RwSNC7gLvB9VDTKMT3TWoBDPmqT2JMXcY5/qBu7NsZd+um99MXvBcd/7mLt8usppqAOe
         8hcy/UbufaGE2WvaE/6LDgTXhUpLuqCj1ClA8JjqYoe1/aKSn1jaYmVmK33cWlZJwfWL
         tgZQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4E51OPB2WUIFq30L3IZ1lBv2RZCfC57l2zIpRCY7GpwdL2Xj04QfbbwP839K/NrpJkc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAgzBCmJeTHHmbEcQaK1pUUcNnFssrtRm4hIbEor2TAJvgkz9K
	fDqAZk5WC89XY8uewzqGDWNiNLn65iqemVjQovttg1kad+rLVGUrKDbFp/9VcdaXmLh27NmDnsD
	fKQ==
X-Google-Smtp-Source: AGHT+IFiI3ay5y7w5pgPUPFBTOQ/KW+bT1HbnjiMC1wKY+tCLdLaTeLJvIQHLRs+a2IawRP+op3DZpb5qBc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d658:0:b0:e28:f8e4:cc5e with SMTP id
 3f1490d57ef6-e28f8e4ced4mr209276.2.1728399075773; Tue, 08 Oct 2024 07:51:15
 -0700 (PDT)
Date: Tue, 8 Oct 2024 07:51:13 -0700
In-Reply-To: <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com> <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com> <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com> <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
Message-ID: <ZwVG4bQ4g5Tm2jrt@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yuan Yao <yuan.yao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 25, 2024, Yan Zhao wrote:
> On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> > On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> > > On Fri, Sep 13, 2024, Yan Zhao wrote:
> > > > This is a lock status report of TDX module for current SEAMCALL retry issue
> > > > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > > > branch TDX_1.5.05.
> > > > 
> > > > TL;DR:
> > > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> > > 
> > > The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> > > install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> > > a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> > > trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> > > whatever reason.
> > > 
> > > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> > > what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> > > the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> > > hits the fault?
> > > 
> > > For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> > > desirable because in many cases, the winning task will install a valid mapping
> > > before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> > > instruction is re-executed.  In the happy case, that provides optimal performance
> > > as KVM doesn't introduce any extra delay/latency.
> > > 
> > > But for TDX, the math is different as the cost of a re-hitting a fault is much,
> > > much higher, especially in light of the zero-step issues.
> > > 
> > > E.g. if the TDP MMU returns a unique error code for the frozen case, and
> > > kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> > > then the TDX EPT violation path can safely retry locally, similar to the do-while
> > > loop in kvm_tdp_map_page().
> > > 
> > > The only part I don't like about this idea is having two "retry" return values,
> > > which creates the potential for bugs due to checking one but not the other.
> > > 
> > > Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> > > to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> > > option better even though the out-param is a bit gross, because it makes it more
> > > obvious that the "frozen_spte" is a special case that doesn't need attention for
> > > most paths.
> > Good idea.
> > But could we extend it a bit more to allow TDX's EPT violation handler to also
> > retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?
> I'm asking this because merely avoiding invoking tdh_vp_enter() in vCPUs seeing
> FROZEN_SPTE might not be enough to prevent zero step mitigation.

The goal isn't to make it completely impossible for zero-step to fire, it's to
make it so that _if_ zero-step fires, KVM can report the error to userspace without
having to retry, because KVM _knows_ that advancing past the zero-step isn't
something KVM can solve.

 : I'm not worried about any performance hit with zero-step, I'm worried about KVM
 : not being able to differentiate between a KVM bug and guest interference.  The
 : goal with a local retry is to make it so that KVM _never_ triggers zero-step,
 : unless there is a bug somewhere.  At that point, if zero-step fires, KVM can
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 : report the error to userspace instead of trying to suppress guest activity, and
 : potentially from other KVM tasks too.

In other words, for the selftest you crafted, KVM reporting an error to userspace
due to zero-step would be working as intended.  

> E.g. in below selftest with a TD configured with pending_ve_disable=N,
> zero step mitigation can be triggered on a vCPU that is stuck in EPT violation
> vm exit for more than 6 times (due to that user space does not do memslot
> conversion correctly).
> 
> So, if vCPU A wins the chance to call tdh_mem_page_aug(), the SEAMCALL may
> contend with zero step mitigation code in tdh_vp_enter() in vCPU B stuck
> in EPT violation vm exits.

