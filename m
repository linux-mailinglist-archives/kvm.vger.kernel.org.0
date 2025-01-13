Return-Path: <kvm+bounces-35328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 253E6A0C459
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D25623A71CC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6B71F8918;
	Mon, 13 Jan 2025 22:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYSOZFvu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405271D61A5
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736805858; cv=none; b=g6P1ONzU+NMksLua8gS7LkImv2trRUaorjJGJFGux3GD6Sw0jg1Yboc1k/RxT4rfMYlZA8qrWEcBMVB95qtxZ/AKHAbOhZu4pbAyPBzF1yetLdsND0pY34g3Kfic4htzGJWZ2BjHgu8GJ42ntwxjsCkwlu33CwyqDzpp9R6qIGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736805858; c=relaxed/simple;
	bh=EchIjsJPujj7t/pv7t0veqTlDk1UffPAlzXdJgJLSDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSBEscMjcRVD48urbdahTSKZDEcM66GLKpP1KehQU+B9EL2UVcA2sGb+jj8co0tOcSOnY+fgKA43QMdSLNzDcqB5q2WKeTnGQsKSu+flkUtub8KpsbnrJH5x7WYj8okZ2UQ08/Yy3p/LlaDKplwb8iKXhCQ5ARJyapuPePpDUnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYSOZFvu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso8656378a91.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736805856; x=1737410656; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ouQM0W6rpy+hi197i8Zk+lTDosT4d/QAcoc26c/0W4=;
        b=TYSOZFvurc8XUFWshLHPlxANfo6lHCo4ZQbJEjvwKrpNjVokjFxvCKC14KWyUqTnlZ
         ETQOJiJBZvcJ3SeoUk8bum4+0BWNUt//qdv7WWzP3HRxPbwepSB8r44mVEwF2paP/etP
         KuAYIn3yAnptLuALO4jeegrGY1vwGBaP2owUgwDt2h9muYebbcWsofeu0cDsoiJBUibM
         H4pHq3slDbeRJbiFL5k+En26ixiL5AaB/pIM8QKPwdi9QgCe2i5PxGxE4sk9DSdGXrLk
         UqUBHED/m9j+xaOam7LaL5vJpJ6K9bsc7Epsf1ZrDMwOwRj6L8lgf20Uk9SzQFtS1BUD
         NKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736805856; x=1737410656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ouQM0W6rpy+hi197i8Zk+lTDosT4d/QAcoc26c/0W4=;
        b=q9zKSNWHmIOmYwGf0wlE9BRx6aFtz4g5FgMXMLADHoW9OJnRQ/jxJ78ThARjn89+ut
         Bc6rwOJNksV6Ps2yjZCfjAKPHHA41BWQGGcGLvegmxc3ZpJPqQnrc4/gd7gEM+IjndMa
         e+dr8IdbtQXrjE1UbNCHsRRsIpgcTju2TVZfM6adWI7XWRY86vGlCTO77pzgvbzMIdTN
         ReHfFbG0EAeq9nqS55ega8t/olNRhVl/dLVOa3RI3s/A4AvYe2xiGqj9C4ZYiSPFnYnx
         ULinKVDf6ULHY6LN39EVMqSpLEQVIEF5CruJnJAhyo06Md1y3Rwysry9D2tWLwX5ZI9L
         Idrw==
X-Forwarded-Encrypted: i=1; AJvYcCUJa8S0lqM/ULcCWJqkuKn9kaljibb2MBuz6rYyMCRPg5B73XZtuFVBeLeWhxDpJm+SxFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjJH3XD+/zc49SFvuThutec2j3dInAqqYfDC0KQ6AEazz9w2vk
	46rLGA84asVn1sgFgweV5wok1mJnEXXSU0UQ5yhX4kHmVFxjgEUc5G9MqoRYrFMYdlLe3rFWMe0
	9Ig==
X-Google-Smtp-Source: AGHT+IHPN8TIZGkXrQIWMGITx0F8fOm3vw8dMWb7JVx/B9HZzRXtZecChEPlXNK7/wkOh+HdmqOb1zcL5aE=
X-Received: from pjbdb14.prod.google.com ([2002:a17:90a:d64e:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f90:b0:2f6:f107:faf8
 with SMTP id 98e67ed59e1d1-2f6f107fe30mr4478474a91.24.1736805856584; Mon, 13
 Jan 2025 14:04:16 -0800 (PST)
Date: Mon, 13 Jan 2025 14:04:15 -0800
In-Reply-To: <87bjwaqzbz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <87ikqlr4vo.wl-maz@kernel.org> <Z4U03KRYy2DVEgJR@google.com>
 <86ikqiwq7y.wl-maz@kernel.org> <Z4ViZb7rruRiN-Oe@google.com> <87bjwaqzbz.wl-maz@kernel.org>
Message-ID: <Z4WN3_wUZ1H_e7ou@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Marc Zyngier wrote:
> On Mon, 13 Jan 2025 18:58:45 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Mon, Jan 13, 2025, Marc Zyngier wrote:
> > > On Mon, 13 Jan 2025 15:44:28 +0000,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > On Sat, Jan 11, 2025, Marc Zyngier wrote:
> > > > > Yet, you don't amend arm64 to publish that flag. Not that I think this
> > > > > causes any issue (even if you save the state at that point without
> > > > > reentering the guest, it will be still be consistent), but that
> > > > > directly contradicts the documentation (isn't that ironic? ;-).
> > > > 
> > > > It does cause issues, I missed this code in kvm_arch_vcpu_ioctl_run():
> > > > 
> > > > 	if (run->exit_reason == KVM_EXIT_MMIO) {
> > > > 		ret = kvm_handle_mmio_return(vcpu);
> > > > 		if (ret <= 0)
> > > > 			return ret;
> > > > 	}
> > > 
> > > That's satisfying a load from the guest forwarded to userspace.
> > 
> > And MMIO stores, no?  I.e. PC needs to be incremented on stores as well.
> 
> Yes, *after* the store as completed. If you replay the instruction,
> the same store comes out.
> 
> > > If the VMM did a save of the guest at this stage, restored and resumed it,
> > > *nothing* bad would happen, as PC still points to the instruction that got
> > > forwarded. You'll see the same load again.
> > 
> > But replaying an MMIO store could cause all kinds of problems, and even MMIO
> > loads could theoretically be problematic, e.g. if there are side effects in the
> > device that trigger on access to a device register.
> 
> But that's the VMM's problem. If it has modified its own state and
> doesn't return to the guest to complete the instruction, that's just
> as bad as a load, which *do* have side effects as well.

Agreed, just wanted to make sure I wasn't completely misunderstanding something
about arm64.

> Overall, the guest state exposed by KVM is always correct, and
> replaying the instruction is not going to change that. It is if the
> VMM is broken that things turn ugly *for the VMM itself*, 
> and I claim that no amount of flag being added is going to help that.

On x86 at least, adding KVM_RUN_NEEDS_COMPLETION reduces the chances for human
error.  x86 has had bugs in both KVM (patch 1) and userspace (Google's VMM when
handling MSR exits) that would have been avoided if KVM_RUN_NEEDS_COMPLETION existed.
Unless the VMM is doing something decidely odd, userspace needs to write code once
(maybe even just once for all architectures).  For KVM, the flag is set based on
whether or not the vCPU has a valid completion callback, i.e. will be correct so
long as the underlying KVM code is correct.

Contrast that with the current approach, where the KVM developer needs to get
the KVM code correct and remember to update KVM's documentation.  Documentation
is especially problematic, because in practice it can't be tested, i.e. is much
more likely to be missed by the developer and the maintainer.  The VMM either
needs to blindly redo KVM_RUN (as selftests do, and apparently as QEMU does), or
the developer adding VMM support needs to be diligent in reading KVM's documentation.
And like KVM documentation, testing that the VMM is implemented to KVM's "spec"
is effectively impossible in practice, because 99.9999% of the time userspace
exits and save/restore will work just fine.

I do agree that the VMM is likely going to run into problems sooner or later if
the developers/maintainers don't fundamentally understand the need to redo KVM_RUN,
but I also think there's significant value in reducing the chances for simple
human error to result in broken VMs.

