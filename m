Return-Path: <kvm+bounces-42971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F6AA818E8
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 00:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD09F1B821DC
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 22:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BC5255E39;
	Tue,  8 Apr 2025 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEPSSV0A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434125523A
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744152184; cv=none; b=f7pnxKvLaMYafANl9LB6RYx9hGx0wM4lGvXKFi6gnXmSByC9+np5CLNg9AgFMkdpS7KXYhEj9+eRKddZyLB7qe0Qebyud/ccc9WjecaXitPvW0akY8ZEQ4GcnvluKVjNWe/fN2rI8gvj2Zvq9QKECqHT1ctIYlHFh+G36pjLsg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744152184; c=relaxed/simple;
	bh=/39HQm/a80E19q76x7+fdBqxNELqvRKNZbYFLVtSRpQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F1OQDDhUaN9Y6y/aYDo0aFIS3XutnD6Ag0TgqtxHD8SP1mmdy4kKRlu43gpypzkcbvV1f/fDcH3ZA0p0gEjpUHL6e7CqSZuzFHdrU9cTYoUNTEoTeXBShASlBJK9chmWOWnmD8H9sSPY3MjNUod9l4d3EhsvoM8QWFh0zGU1xbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEPSSV0A; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2240a96112fso91949395ad.2
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 15:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744152182; x=1744756982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eMUtiO2D0UUMkBs1GE4pjSF4b7J9t7twmr9JLeLias4=;
        b=mEPSSV0AwL64Rah5OK070cRSARhPtVAYMISR3f3S7euV8/niwGAg1wEdDqNjR5OpRa
         z2W1CsobSeW/vwhwXq5obmUzX0MpUHa8XwH9L1zXSYBpb4Vk/pvTbXhJ5YXeAFvCivEz
         rEzs2OJdsz2mkQV0g3EiDeSdanSfjJGZnfhOocir3rooilcmdpCskkX5eMiEl9CJqIVR
         WXaeFpl5ClGWEvYSJ06PqM/Sf/SVyeqHkDyW5qqzrqHGCWLw0qgJzZtZqoCJr81/A37y
         lxtpxP2bghhgdE52L6FtuugwZ5006eUPCDnFdJZa8tojMgo5pB3MFgpEFr+FEohSYCz3
         vdSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744152182; x=1744756982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eMUtiO2D0UUMkBs1GE4pjSF4b7J9t7twmr9JLeLias4=;
        b=KGZ/h4zWMhOR5R6QNx9W/E2vYUYY4p3i3kR/dWcfNmJtuD3VMKPzZosUdgzXMssJlp
         cTjNiebcCHGeT0rzvZo97Y3PPUkY8QK/ty/gAPErn7PpxyheQHAWEXpQ+oBVecGhAX7E
         83TwJ9KgUyDTPfBJxUxiHxOYw9ZzchVVKResBYzmYEk/1zlkADwi+TzEcAGvY5CzbIsM
         U10dszrJZOO86o79OE0X7XlFgCnUQ7DU6nQzR8jVBYPOpqL6nea8HGQnzvsK+Q8V5mqG
         7xC9bKDh26CvliNcwFG8PMPDf36HntypYR3XJ6nWJ9fmKexhSiCPRO2DipjoE4CIwGjD
         rgeQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/cOVZiLqkyKgtpMfCLym88Enb0/Jcp0vXC0Xtem5plQQFFH81sxZ+bmw3cFzuVaQ3yBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaSH3JVAB/jRNSfXnVixZcT/OtFTFpKD11+ekr3H+ZubFWCvZl
	UNft5CCogQklNw3kwxOcx5PJSxm6Lra5T8ZYWMYIE3h99Mx31O9Hyn7a8EyM7AdKUfnsYerFwIN
	olg==
X-Google-Smtp-Source: AGHT+IF2GWiciyeJ/g2ZrCMsTGw6QrL2YJJPScvh9TmwHOHAo+GhFkwMDKvylScZhlko0tCTDYUw908Vkak=
X-Received: from pfbci5.prod.google.com ([2002:a05:6a00:28c5:b0:736:79d0:fd28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8c:b0:220:e023:8fa6
 with SMTP id d9443c01a7336-22ac4002ec2mr4889925ad.50.1744152181939; Tue, 08
 Apr 2025 15:43:01 -0700 (PDT)
Date: Tue, 8 Apr 2025 15:43:00 -0700
In-Reply-To: <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com> <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
Message-ID: <Z_WmdAZ9E2dxHpBE@google.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Maxim Levitsky wrote:
> On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
> > Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> > DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> > context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> > just supported, but fully enabled).
> > 
> > The bug has gone unnoticed because until recently, the only bits that
> > KVM would leave set were things like BTF, which are guest visible but
> > won't cause functional problems unless guest software is being especially
> > particular about #DBs.
> > 
> > The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> > as the resulting #DBs due to split-lock accesses in guest userspace (lol
> > Steam) get reflected into the guest by KVM.
> > 
> > Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> > likely the behavior that SVM guests have gotten the vast, vast majority of
> > the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> > option for a fix, e.g. versus trying to add proper BTF virtualization on the
> > fly.
> > 
> > v3:
> >  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
> >  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
> >    it's guaranteed to be '0' in this scenario). [Ravi]
> > 
> > v2:
> >  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
> >  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
> >    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
> >  - Collect a review. [Xiaoyao]
> >  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> > 
> > v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> > 
> 
> 
> Hi,
> 
> Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
> (if I am not mistaken of course).
> 
> We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
> set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
> (If I read the code correctly, I didn't verify this in runtime)

Ugh, SMM.  Yeah, KVM doesn't propagate DEBUGCTLMSR_FREEZE_IN_SMM to the guest
value.  KVM intercepts reads and writes to DEBUGCTL, so it should be easy enough
to shove the bit in on writes, and drop it on reads.

> This means that the host #SMIs will interfere with the guest PMU.  In
> particular this causes the 'pmu' kvm-unit-test to fail, which is something
> that our CI caught.
> 
> I think that kvm should just set this bit, or even better, use the host value
> of this bit, and hide it from the guest, because the guest shouldn't know
> about host's smm, and we AFAIK don't really support freezing perfmon when the
> guest enters its own emulated SMM.

Agreed.  Easy thing is to use the host's value, so that KVM doesn't need to check
for its existence.  I can't think of anything that would go sideways by freezing
perfmon if the host happens to take an SMI.

> What do you think? I'll post patches if you think that this is a good idea.
> (A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)
> 
> I also need to check if AMD also has this feature, or if this is Intel specific.

Intel only.  I assume/think/hope AMD's Host/Guest Only field in the event selector
effectively hides SMM from the guest.

