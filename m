Return-Path: <kvm+bounces-7760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B24845FE7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:30:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC067B23F9F
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137567C6C9;
	Thu,  1 Feb 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1KgYw5iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75193A1B7
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706812209; cv=none; b=ql1A6fmZPbBm1ZEEWO/0O6mtmCzzSvjKsQ1yfcEvsJyZdfyGzX3nFc39vrgsVemz03CuOusgGHyNQrEV3vt27Pm87l5KJ+NRUGHDgrMzmK9lqexZgsL8OzY7+lQVReagXEWo3Bkg+aFI5q+zxJRuSVkBKA/v5oJdedgtzTszu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706812209; c=relaxed/simple;
	bh=tl+xb0buvjPCqBSdrLLLtSx2Pgvi0F02Ilb8PqkDCSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDJy6I6GR3uZx+TzQRMC+WzZPAnEYVHj09kH+631IFj9mjkyK28xqreV0FszbrlMyNx9YSp1oMsq9eNMeni3C0WopCCl1QB/4DF3DY4uj8lKj3b5KmsSHiiEzRLgyl2jc5ZwLR+FNhs5PxL7+vZ6hR4HEBg3Tldw/5WTP7kecTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1KgYw5iL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so1007781a12.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 10:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706812207; x=1707417007; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4wSE2ygUFAznZ5Qee3ev00ln4+pdv/BNmpVSDQaWUNE=;
        b=1KgYw5iLyE1kQmqPbUUEeYpnw3tQLkNwrs+3bDiYJVuPUP9REYMkDd+fshQWWggwrw
         e7bWj43DhcjnsqS8HZt9fNkzx1rHiZtFjM/0nM/PRmfA8tY5kiH94M+qC45L/X7q7RvY
         0TzjEq6BNt0Dp8gdtb6m/p4SNrgN8PIr4XNwvae2sjngEWmJBGGh+753IY5Z9rwZS752
         5gdwW5g8FHgTz0EJyzLhD/tO+XKe7L5J1IEv/PncLcZV0mjmKbdnbe5CQqNUw+Ik27k4
         HvlEXnzD+P3FIN4PTC65sE/3ryZoy1Goune3ujGFEK/Pdd8kgtC0Tqqaxxe8it+QhnUv
         hQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706812207; x=1707417007;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wSE2ygUFAznZ5Qee3ev00ln4+pdv/BNmpVSDQaWUNE=;
        b=jGsmSSqJ/ZDtPb25Ux7OApqZKkPd+WxTVjmR1Gtvcr0cbwWLSFkHR3nTUFvna6n/hD
         a2uKsip+zQDOevzVDbrVHf0ftAV4ecO4TatlPM3pNMRPhRuU199XIoSBlP8txAcmKO/h
         lhxCziHJKetx7pPTGuIOQA+XElzVvsN9C/trb5eLPbxpu0/Mz7GIiclPwsrKhWjHi+QJ
         JxLJyxGFVgiyTyZjoYM1KrPWHv7YB9HwVjiWz/fN/1hGYxZ2gTkBL/gAwYlJg0G81Cja
         4E3zKHPwb1QNhB+4OQLHGQe2KApOmgGYvrC6yUa744M1yy9CViBWBUMDxjxduM/Rrv5J
         q5rA==
X-Gm-Message-State: AOJu0YxVFTDKCCVz5DVztU7qfNu2uF+gqZRQZqHEHj2SPXrxSuiBoe8u
	EKPDUUvzWEfvvWcdoKwZ/+t3IIK+rHu4m+lo+lF7qFMJLfyjvP30mUQFC2HShQ==
X-Google-Smtp-Source: AGHT+IFkUxdzz7RSM6zTidovMWvvSgr2zWwLzE35NeJcFciHdEBR/9aHgLNsZgsfB6uqA9Dp8WbSmQ==
X-Received: by 2002:a05:6a20:2d2c:b0:19e:34c8:41e1 with SMTP id g44-20020a056a202d2c00b0019e34c841e1mr6637373pzl.26.1706812206775;
        Thu, 01 Feb 2024 10:30:06 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWUSa4z+wd9ebARYNZ9ywrvbu4D5PC8TohIofjL1mLkm305wxM4hgMJEo6VEXw6GxMRH0KvswhTy4T3lNVMZYAZvwgHcUBSqoV6R9q46XjRpG5dmfCIiktC7og9gFcp+3rM2268sUAZaJkudF6SsL/QuxrQ4c/1p2n0iDfzGs9S7p7EhlGzYhU38gIKT+0L/aepiJnxefaYrEY=
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id s11-20020a63e80b000000b005d68962e1a7sm135860pgh.24.2024.02.01.10.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 10:30:06 -0800 (PST)
Date: Thu, 1 Feb 2024 18:30:02 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading
 pmu->fixed_ctr_ctrl
Message-ID: <ZbvjKtsVjpuQmKE2@google.com>
References: <20240123221220.3911317-1-mizhang@google.com>
 <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com>
 <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
 <ZbvUyaEypRmb2s73@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbvUyaEypRmb2s73@google.com>

On Thu, Feb 01, 2024, Sean Christopherson wrote:
> On Wed, Jan 31, 2024, Mingwei Zhang wrote:
> > On Wed, Jan 31, 2024 at 9:02 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
> > > On 1/31/24 07:43, Sean Christopherson wrote:
> > > > On Tue, Jan 23, 2024, Mingwei Zhang wrote:
> > > >> Fix type length error since pmu->fixed_ctr_ctrl is u64 but the local
> > > >> variable old_fixed_ctr_ctrl is u8. Truncating the value leads to
> > > >> information loss at runtime. This leads to incorrect value in old_ctrl
> > > >> retrieved from each field of old_fixed_ctr_ctrl and causes incorrect code
> > > >> execution within the for loop of reprogram_fixed_counters(). So fix this
> > > >> type to u64.
> > > >
> > > > But what is the actual fallout from this?  Stating that the bug causes incorrect
> > > > code execution isn't helpful, that's akin to saying water is wet.
> > > >
> > > > If I'm following the code correctly, the only fallout is that KVM may unnecessarily
> > > > mark a fixed PMC as in use and reprogram it.  I.e. the bug can result in (minor?)
> > > > performance issues, but it won't cause functional problems.
> > >
> > > My this issue cause "Uhhuh. NMI received for unknown reason XX on CPU XX." at VM side?
> > >
> > > The PMC is still active while the VM side handle_pmi_common() is not going to handle it?
> > 
> > hmm, so the new value is '0', but the old value is non-zero, KVM is
> > supposed to zero out (stop) the fix counter), but it skips it. This
> > leads to the counter continuously increasing until it overflows, but
> > guest PMU thought it had disabled it. That's why you got this warning?
> 
> No, that can't happen, and KVM would have a massive bug if that were the case.
> The truncation can _only_ cause bits to disappear, it can't magically make bits
> appear, i.e. the _only_ way this can cause a problem is for KVM to incorrectly
> think a PMC is being disabled.

The reason why the bug does not happen is because there is global
control. So disabling a counter will be effectively done in the global
disable part, ie., when guest PMU writes to MSR 0x38f.

So this will be an ugly bug in an ancient PMU.
> 
> And FWIW, KVM does do the right thing (well, "right" might be too strong) when a

right thing? yes. too strong.

> fixed PMC is disabled. KVM will pause the counter in reprogram_counter(), and
> then leave the perf event paused counter as pmc_event_is_allowed() will return
> %false due to the PMC being locally disabled.
>
> But in this case, _if_ the counter is actually enabled, KVM will simply reprogram
> the PMC.  Reprogramming is unnecessary and wasteful, but it's not broken.

no, if the counter is actually enabled, but then it is assigned to
old_fixed_ctr_ctrl, the value is truncated. When control goes to the
check at the time of disabling the counter, KVM thinks it is disabled,
since the value is already truncated to 0. So KVM will skip by saying
"oh, the counter is already disabled, why reprogram? No need!".

> 
> Side topic, looking at this code made me realize just how terrible the names
> pmc_in_use and pmc_speculative_in_use() are.  "pmc_in_use" sounds like it tracks
> which PMCs have perf_events, and at first glance at kvm_pmu_cleanup(), it even
> _looks_ like that's the case.  But kvm_pmu_cleanup() is _skipping_ PMCs that are
> not "in use".  And conversely, there is nothing speculative about checking the
> local enable bit for a PMC.

pmc_in_use is a terrible name. It seems the only usage point is for
LBR...
> 
> I'll send patches to rename pmc_in_use to pmc_accessed, and pmc_speculative_in_use()
> to pmc_is_locally_enabled().

yes, I like pmc_is_locally_enabled(). But I don't know what is better
for pmc_in_use.

> 
> As for this one, unless someone spends the time to prove me wrong, it's destined
> for 6.9 with a changelog that says the bug is likely benign.

It is not benign, but does not matter for modern CPUs with Intel PerfMon
v2 and later. So, for virtualized environment, it might be still
critical for those VMs with PerfMon v1.

Thanks.
-Mingwei

