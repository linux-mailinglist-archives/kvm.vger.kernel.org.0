Return-Path: <kvm+bounces-9940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51034867A2F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F13BD293792
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC2B12AAF0;
	Mon, 26 Feb 2024 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hrsTFM81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8912AAC4
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708961239; cv=none; b=BkKs1J/62uGWM0zGEJExbYyYj+1shkrTKcBiX9A88F33z7iGcm2MNnOxgA3L/rOrCz/Kb3addIhr6s70UM3Wb6vBRAPoK9UNhRsnQt7kf+rLMBSZHzgwEiUfHmF65lwR46LJF8sh/2kvietkoDZszF+e14GfuIDxXxoKiCZTKH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708961239; c=relaxed/simple;
	bh=ujz3KPBAMBQU33eq3LN9zOuebEUgTrKcSEL6G1EBSkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tr8Oajn48lV76lIFWu8PpcpYktT0WjdUIE4POCkFxf7mG5ylZiBoIL3WjOEx0Of9JPF+iiboy1YlRwRSqT/GmsAmpNx4XuuSf3UO7mWCMQ77oipcqIwZe4jDbEmYCh16BajC246ZWNt6YNWH2ZskE+j+pfepEP9FJk/9txaoYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hrsTFM81; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6088fa18619so42987177b3.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 07:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708961237; x=1709566037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPyeDZVIIyCXYt9YL0uYOoqOy56Yb0xUHXTmaer34Ao=;
        b=hrsTFM81d20T/qXvuoeg1B0y+bo9Z2l/Ae7J70FNWGSCFr8wgaocjWSPcx/oobaZ/P
         9YziBwwgZGPIDMB0xtl9x495rSdjPMkErpHsgNGHw7PIp8ycnapA7Hbg1ebEv+ljRNvG
         cNK4TuMEt9qUpnPiIOIYCtrS05jpPqfSdFvW8+QLL7aHFP7PNY+jdeM2RBHgRz21UU3g
         Z6X36jAA0YGrzThloQ1o6TXCsrbO15dskNw7B5osY8MgLUK571fWemUW+h51Kp9WUGwo
         RY72Pg6hJ4hccx3Vd1IHtPT+E0EcHIzO2q/cOK4xTpSGQqB88miegxSWleKTLjs4P+DV
         U0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708961237; x=1709566037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPyeDZVIIyCXYt9YL0uYOoqOy56Yb0xUHXTmaer34Ao=;
        b=JU8f6+evoRzA5elk6kZA1q60qq8e7Kfeuyu92VnLvB6y7xj7R3WPG2LykhZchFg8gi
         UpvHlCoOtrF2OVk+rPP4qrBNAXd+XmPm9okaTC8vl0UHZPs/PtmLexXdSUiGVVXHwFsE
         3nAFPPEwM/PeJe16i+E1YHlx/4+0hzjXYbRjs48CLkzEEJxH4g0Ol56N+tYXJ2V319TE
         69gZS49mEuOjTfB7xrcZpVJqkOOAv/+hEOAZ0wpR1VeEodc5cdHoBhM5Lrv4NwbKFRIs
         1bJRVoeSz1nGUvD1cOEjPsDe/scqqzAxsjRafQGBh8NC1lI+qFlregXJn4Atm5aaae4I
         1QAg==
X-Forwarded-Encrypted: i=1; AJvYcCW7KXS9F446/o+0FwUyaM6RAGSliGSDlU86hqNpGUJLbN08iXmRE5T73JTKcVbNZ47pJgkAsCm6q6P4n6gIdnyUZp24
X-Gm-Message-State: AOJu0Yw4l1pqupMkDbQiYMVbcfvp/KgHY3TV5AFm30taJdMk9MfsAv66
	rBvjeHviV/K6Tzd1j/L0nS3bxqq874/wCK909Muc/dj6PeFcl+SL56WJrmVGsQADTw0XDPUk8hP
	Azg==
X-Google-Smtp-Source: AGHT+IHkBgKMhwVLkljwA3qRqGVQLniO8Rd2JfPhJNxGsBGlHhVC+4r/+VEFC4ZaYLPTGWbUsyBC7X4WmVs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1245:b0:dbe:30cd:8fcb with SMTP id
 t5-20020a056902124500b00dbe30cd8fcbmr261623ybu.0.1708961237221; Mon, 26 Feb
 2024 07:27:17 -0800 (PST)
Date: Mon, 26 Feb 2024 07:27:15 -0800
In-Reply-To: <Zdw5qziEGdTyLIFN@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110002340.485595-1-seanjc@google.com> <170864656017.3080257.14048100709856204250.b4-ty@google.com>
 <dfca56c5-770b-46a3-90a3-3a6b219048f2@intel.com> <Zdw5qziEGdTyLIFN@linux.bj.intel.com>
Message-ID: <Zdyt028xOBAgiBtn@google.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, Tao Su wrote:
> On Mon, Feb 26, 2024 at 09:30:33AM +0800, Xiaoyao Li wrote:
> > On 2/23/2024 9:35 AM, Sean Christopherson wrote:
> > > On Tue, 09 Jan 2024 16:23:40 -0800, Sean Christopherson wrote:
> > > > Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > > > whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > > > enumerated via MSR, i.e. aren't accessible to userspace without help from
> > > > the kernel, and knowing whether or not 5-level EPT is supported is sadly
> > > > necessary for userspace to correctly configure KVM VMs.
> > > > 
> > > > When EPT is enabled, bits 51:49 of guest physical addresses are consumed
> > > > if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
> > > > *can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
> > > > creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
> > > > above bit 48 will be completely broken.
> > > > 
> > > > [...]
> > > 
> > > Applied to kvm-x86 vmx, with a massaged changelog to avoid presenting this as a
> > > bug fix (and finally fixed the 51:49=>51:48 goof):
> > > 
> > >      Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > >      whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > >      enumerated via MSR, i.e. aren't accessible to userspace without help from
> > >      the kernel, and knowing whether or not 5-level EPT is supported is useful
> > >      for debug, triage, testing, etc.
> > >      For example, when EPT is enabled, bits 51:48 of guest physical addresses
> > >      are consumed by the CPU if and only if 5-level EPT is enabled.  For CPUs
> > >      with MAXPHYADDR > 48, KVM *can't* map all legal guest memory if 5-level
> > >      EPT is unsupported, making it more or less necessary to know whether or
> > >      not 5-level EPT is supported.
> > > 
> > > [1/1] x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
> > >        https://github.com/kvm-x86/linux/commit/b1a3c366cbc7
> > 
> > Do we need a new KVM CAP for this? This decides how to interact with old
> > kernel without this patch. In that case, no ept_5level in /proc/cpuinfo,
> > what should we do in the absence of ept_5level? treat it only 4 level EPT
> > supported?
> 
> Maybe also adding flag for 4-level EPT can be an option. If userspace
> checks both 4-level and 5-level are not in /proc/cpuinfo, it can regard
> the kernel as old.

The intent is that this is informational only, not something that userspace can
or should use to make decisions about how to configure KVM guests.  As pointed
out elsewhere in the thread, simply restricting guest.MAXPHYADDR to 48 doesn't
actually create an architecturally viable VM.  At the very least, KVM needs to
be configured with allow_smaller_maxphyaddr=1, and aside from the gaping holes
in KVM related to that knob, AIUI allow_smaller_maxphyaddr=1 isn't an option in
this case due to other quirks/flaws with the CPU in question.

I don't think there's been an on-list summary posted, but the plan is to figure
out a way to inform guest firmware of the max _usable_ physical address, so that
firmware doesn't create BARs and whatnot in memory that KVM can't map.  And then
have KVM relay the usuable guest.MAXPHYADDR to userspace.  That way userspace
doesn't need to infer the effective guest.MAXPHYADDR from EPT knobs.

