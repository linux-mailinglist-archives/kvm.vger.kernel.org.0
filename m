Return-Path: <kvm+bounces-21236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9818392C436
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB62C1C224E6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DA918562D;
	Tue,  9 Jul 2024 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zq6ZKeZE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF1185600
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555120; cv=none; b=TepLlOUzWl3ELVtXD0PNW7VLK9H2p6opL2hJgCin4CigQiDtIsOwJMfR82pbjJooLGr0yCq1UcssWOb7E+76kQdcuBmA5OSTn+1un0S1yC92rEmy5m78J/ySds1Sx552zB26bdogxEoGCxSkvFaEyz1//PWBA5MnXjfdUrd+o5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555120; c=relaxed/simple;
	bh=BufCoQvPcrMLdZydelzJEkWvQqMULRiWl+BErt3I6lA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UdfBD1M1wAtaM6tOxKscvk4/33rp3drL9/I309Vo38IOtPM/+FGPMgR1rA5/D2JZTqyrmGR2iGqAYWmXDQcAojQKGNQdGaHACuTGGlRPHYEF7ch2LRci0976589XiePV1MhFZQASnzm67opqZsaiaQEtQbJodh35moEYDe+JXJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zq6ZKeZE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6501bac2d6aso1527307b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720555117; x=1721159917; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OH4mJgHtAMjKpYrLchkY0/kYwpApwxh1WzFZLLQJUK4=;
        b=zq6ZKeZERlsTg9o2IihuLZAW9AppUg6GZGU1bfpZkca7IJVRl3OUtYVvyNS2Y2IKLI
         7NnlMGn/0403KHRcYne18sX8iRKbiFEdLYHbnvNFI0CHLpkWne6HljOBnSeVWuCnDJo3
         pfivL0YIaAS3i7ZWLvtal2uPEFlyTrbUzcKWLtATbM/SGm/vpt7Wa7pRMe8E3lH3CWv+
         dMdyFvFfJy0QVchaXwXV4t23ImKiIuIv3pt01rtNzs5ecikpqmIQhTce40tfAaGOmltz
         QUduyjbixqyVK0/nRkznw9M/KJm9d9sbwgygigWv9AHbbYTOojhjOINpNyuJbXsN3DBo
         bTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720555117; x=1721159917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OH4mJgHtAMjKpYrLchkY0/kYwpApwxh1WzFZLLQJUK4=;
        b=KlNUDgSvD26ZPCjlnnvrNCvtD/OhKMdnRDV6x4kEPbYrKMX95jTwqbjfmn5xXCgBWg
         7EinjvCRndNLffKv3+usrXIY/SIyNfFLLLPbOzH2XF8iysbNvBtFlUCdtDDtk67HrLcq
         hDQbVTpA17O1mJbyqD9qf8VsIroxs8lb7CLYbtzngVVGnG3OpFReBzYsNuqFL/rFdG8O
         Ft5t6aH6xJ/4jy0a6Z1gloGadPAkrDa3QCz6tfPOUIf4Lq5bsRgMUSTz+NJrpMVp6nTA
         AJEL8uIaLKWUAl2WqeSK3vN0WDs4sLhR3nLkFtnkmpEjgvDYBTW3SVAr+iIAN00XT72u
         F3lA==
X-Forwarded-Encrypted: i=1; AJvYcCX2R0zA9epCebdzIsDvWJci++R7HkOC1SWH9zZ4wLuDnJZNU2EUyLthoVOWhDYXZLqWQZHmBu/Ztwm0EH2v0jru6F4h
X-Gm-Message-State: AOJu0YyY6UTHIFMf3+wF+qzy77MdboDckBRC6khyRVqfXcxcKZs+6RC9
	Y8xP0ZXBKGHiwHvQABakW9J4zOwTJZbNlMB9RvP+Y6Qo0udPsYYF0jjflqO8cJy8ekLPkcB/ggz
	XSg==
X-Google-Smtp-Source: AGHT+IFPRc0GUmnw3tx5z0WM631Lp7VCqKEfr6zvcufCRCt0z7N+TzzPpJWrOmKAgFEWRWTwRbf3RhDOBAI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:340a:b0:64b:a38:31d0 with SMTP id
 00721157ae682-65919f6157bmr98987b3.4.1720555117531; Tue, 09 Jul 2024 12:58:37
 -0700 (PDT)
Date: Tue, 9 Jul 2024 12:58:36 -0700
In-Reply-To: <2c8a398c9899a50c9d8f06fa916eb8eb13b6fbc5.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-4-seanjc@google.com>
 <2c8a398c9899a50c9d8f06fa916eb8eb13b6fbc5.camel@redhat.com>
Message-ID: <Zo2WbN5m6eI03AW8@google.com>
Subject: Re: [PATCH v2 03/49] KVM: x86: Account for KVM-reserved CR4 bits when
 passing through CR4 on VMX
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > Drop x86.c's local pre-computed cr4_reserved bits and instead fold KVM's
> > reserved bits into the guest's reserved bits.  This fixes a bug where VMX's
> > set_cr4_guest_host_mask() fails to account for KVM-reserved bits when
> > deciding which bits can be passed through to the guest.  In most cases,
> > letting the guest directly write reserved CR4 bits is ok, i.e. attempting
> > to set the bit(s) will still #GP, but not if a feature is available in
> > hardware but explicitly disabled by the host, e.g. if FSGSBASE support is
> > disabled via "nofsgsbase".
> > 
> > Note, the extra overhead of computing host reserved bits every time
> > userspace sets guest CPUID is negligible.  The feature bits that are
> > queried are packed nicely into a handful of words, and so checking and
> > setting each reserved bit costs in the neighborhood of ~5 cycles, i.e. the
> > total cost will be in the noise even if the number of checked CR4 bits
> > doubles over the next few years.  In other words, x86 will run out of CR4
> > bits long before the overhead becomes problematic.
> 
> It might be just me, but IMHO this justification is confusing, leading me to
> belive that maybe the code is on the hot-path instead.
> 
> The right justification should be just that this code is in
> kvm_vcpu_after_set_cpuid is usually (*) only called once per vCPU (twice
> after your patch #1)

Ya.  I was trying to capture that even if that weren't true, i.e. even if userspace
was doing something odd, that the extra cost is irrelevant.  I'll expand and reword
the paragraph to make it clear this isn't a hot path for any sane userspace.

> (*) Qemu also calls it, each time vCPU is hotplugged but this doesn't change
> anything performance wise.

...

> > @@ -9831,10 +9826,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> >  		kvm_caps.supported_xss = 0;
> >  
> > -#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> > -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> > -#undef __kvm_cpu_cap_has
> > -
> >  	if (kvm_caps.has_tsc_control) {
> >  		/*
> >  		 * Make sure the user can only configure tsc_khz values that
> 
> 
> I mostly agree with this patch - caching always carries risks and when it doesn't
> value performance wise, it should always be removed.
> 
> 
> However I don't think that this patch fixes a bug as it claims:
> 
> This is the code prior to this patch:
> 
> kvm_x86_vendor_init ->
> 
> 	r = ops->hardware_setup();
> 		svm_hardware_setup
> 			svm_set_cpu_caps + kvm_set_cpu_caps
> 
> 		-- or --
> 
> 		vmx_hardware_setup ->
> 			vmx_set_cpu_caps + + kvm_set_cpu_caps
> 
> 
> 	# read from 'kvm_cpu_caps'
> 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> 
> 
> AFAIK kvm cpu caps are never touched outside of svm_set_cpu_caps/vmx_hardware_setup
> (they don't depend on some later post-processing, cpuid, etc).
> 
> In fact a good refactoring would to make kvm_cpu_caps const after this point,
> using cast, assert or something like that.
> 
> This leads me to believe that cr4_reserved_bits is computed correctly.

cr4_reserved_bits is computed correctly.  The bug is that cr4_reserved_bits isn't
consulted by set_cr4_guest_host_mask(), which is what I meant by "KVM-reserved
bits" in the changelog.

> I could be wrong, but then IMHO it is a very good idea to provide an explanation
> on how this bug can happen.

The first paragraph of the changelog tries to do that, and I'm struggling to come
up with different wording that makes it more clear what's wrong.  Any ideas/suggestions?

