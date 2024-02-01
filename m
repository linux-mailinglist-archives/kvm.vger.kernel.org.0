Return-Path: <kvm+bounces-7764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFC184610D
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AF4828C710
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BD985290;
	Thu,  1 Feb 2024 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cIaNTsdg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065327C6C1
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816178; cv=none; b=uh0qt7fJJVkyzn2Z1yQEqedI8MT8A6FViFgh/GFy6dXo2nA4Y/xB5SLax21Efbhd+geoFeIJ1IHWJNJYQ27aKH2SJgpOiMJXROHJRY4UlgbtlGu9xfVoFCVTnZ5aLXftz8OS6sH+FNmxqFuOAVuA8yW0oSAD8/lm2FPpE0tO8Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816178; c=relaxed/simple;
	bh=qfMTZUwrX0hQseYFBDB6O+l3/V7yP1wzA1uQCR9WF6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V10a9gBb4pxyMrSkTYy+MdSjulAHjMYQz3STYxdipGiyxdFoXJHy+RB5MRNVh/6Co9YcHKicfcXznfDCs9Q5B7BbjecAtAJXa8dIxilIl4ouYN6LlPumTQjZaQi6SzJuVLx+3CGhW5LU50YPWbYfCTM6LakKJFqZfBsKGheLEew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cIaNTsdg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d409124358so12978195ad.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 11:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706816176; x=1707420976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FsllCZK2FAGWJHcpt8xBy9rt8mAFX0Y7/cdzkhjefJw=;
        b=cIaNTsdgRqqgDv8m1WRIY9xzMLxL5yvzgHNSZVnL5gbjVk8YtpQw6QSsvoNn/skTWD
         eckgKoAG3avVzDHgtLdFYtqW0hSIPcT1tGXKEDpXioJvK8EJcewQZ+dPzuuoo5tBYL7I
         9DgWOA/b21QojdCu8ESBusw6wuYVlw+XIyYBOMD3QOl6MqcMTARldYR2CnxldT5RNnA1
         P1/cYEtJH4tevcECe/nY7M+Kx98uK5P5GXrTYFKL7rWehbwILQerOuXa1v7dHlQLLacw
         pQU7miM2gJGx+30SxuUDXqMRH199rlxq4ABVmUwHhcevOVE7+kHjjfNhtztDa+VUYp6Z
         002w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706816176; x=1707420976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FsllCZK2FAGWJHcpt8xBy9rt8mAFX0Y7/cdzkhjefJw=;
        b=JpEJBhpCOs6CoyWN4EXojdrTVtarHnMA+F66LSvAQKfVRaiSbitRC/+hhQX/8IzPqi
         grBwADrp/h+yB7VEAL5HxUHLzXmzjwllWtpK8RnPUi9UmHyw/bfm8G4mS4HoTOtIdJOa
         yobgLy3S2uC8gW5WxW4tRi80JiliYYazm25QPxrlomeAbyvanfa0I9Qs1CkzY3nJCCjU
         rkOFZAabM0xI++Rthcd+4nqhq7p6AQULlvcrE7awQaW1qpUSdUAfeuRXNZTFtOEfZ091
         w2ac7ApjDd3rpMJQZEPCMCCrFSiYNC9+wZA6hIwmJwB/sr/QaT7i+FU8Stfm4CKjzqVB
         p75g==
X-Gm-Message-State: AOJu0YwwknW1f5/b23r285/3WZvDMgaHpaz29DtSzpTvcWI735LHhX30
	Jrkq5TRBFIQeMds0c67/pL1rsY+dk88smO7ugF4v2vAdIzDk84KF5L+5aInVR1oIqV3wcAkVuyz
	E2A==
X-Google-Smtp-Source: AGHT+IGBPaQJijU+ZClk1MamKTuF3e9qb4VlY549Op2uZmIOtLM3UnE8nRsFRbt7USk8HD+C1KynLRxBCIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8ecc:b0:1d8:debb:413a with SMTP id
 x12-20020a1709028ecc00b001d8debb413amr18118plo.8.1706816176244; Thu, 01 Feb
 2024 11:36:16 -0800 (PST)
Date: Thu, 1 Feb 2024 11:36:14 -0800
In-Reply-To: <ZbvjKtsVjpuQmKE2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240123221220.3911317-1-mizhang@google.com> <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com> <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
 <ZbvUyaEypRmb2s73@google.com> <ZbvjKtsVjpuQmKE2@google.com>
Message-ID: <ZbvyrvvZM-Tocza2@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 01, 2024, Mingwei Zhang wrote:
> On Thu, Feb 01, 2024, Sean Christopherson wrote:
> > On Wed, Jan 31, 2024, Mingwei Zhang wrote:
> > > > The PMC is still active while the VM side handle_pmi_common() is not going to handle it?
> > > 
> > > hmm, so the new value is '0', but the old value is non-zero, KVM is
> > > supposed to zero out (stop) the fix counter), but it skips it. This
> > > leads to the counter continuously increasing until it overflows, but
> > > guest PMU thought it had disabled it. That's why you got this warning?
> > 
> > No, that can't happen, and KVM would have a massive bug if that were the case.
> > The truncation can _only_ cause bits to disappear, it can't magically make bits
> > appear, i.e. the _only_ way this can cause a problem is for KVM to incorrectly
> > think a PMC is being disabled.
> 
> The reason why the bug does not happen is because there is global
> control. So disabling a counter will be effectively done in the global
> disable part, ie., when guest PMU writes to MSR 0x38f.


> > fixed PMC is disabled. KVM will pause the counter in reprogram_counter(), and
> > then leave the perf event paused counter as pmc_event_is_allowed() will return
> > %false due to the PMC being locally disabled.
> >
> > But in this case, _if_ the counter is actually enabled, KVM will simply reprogram
> > the PMC.  Reprogramming is unnecessary and wasteful, but it's not broken.
> 
> no, if the counter is actually enabled, but then it is assigned to
> old_fixed_ctr_ctrl, the value is truncated. When control goes to the
> check at the time of disabling the counter, KVM thinks it is disabled,
> since the value is already truncated to 0. So KVM will skip by saying
> "oh, the counter is already disabled, why reprogram? No need!".

Ooh, I had them backwards.  KVM can miss 1=>0, but not 0=>1.  I'll apply this
for 6.8; does this changelog work for you?

  Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
  when reprogramming fixed counters, as truncating the value results in KVM
  thinking all fixed counters, except counter 0, are already disabled.  As
  a result, if the guest disables a fixed counter, KVM will get a false
  negative and fail to reprogram/disable emulation of the counter, which can
  leads to spurious PMIs in the guest.

