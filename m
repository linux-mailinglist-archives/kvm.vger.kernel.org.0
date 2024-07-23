Return-Path: <kvm+bounces-22114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C012393A2A1
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 16:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07C8AB233AE
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 14:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD909154BE4;
	Tue, 23 Jul 2024 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cOtdMqEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C4315252E
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 14:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721744623; cv=none; b=GOJq0MDiKwWSfP/pGdKvAGL1y7GCN6OwjUyp1VSujWuiQBsy2IzmCPl2zRgI55NrLhoboggLo0IwUM9ddwUX7Bnnx9kz04xOlvT3KtWdxdODc5xTFNzvj0s0Rsd6K6FBKqWBL3D+toUvUTDDt57p+k9A4rZ4CeHFCUDGwuwqjiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721744623; c=relaxed/simple;
	bh=djcUsIGzq+dZRGlkFaozwQrZI1bz9S4yJXrBzSwBEIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fv+qKBNHOFBKIsD5x4YeACt0pVAvELBDv6qFm7B3a3e1sGlpt28nWlQTmYFYDz9zf5slI6u6Sec24azL8EV2+XNFVLCyXuQgZg+wMSukbroz2N3zMRtNWqenv2Lm6xdCrhigBLbXMxUrS9ZY/fVTcCgQ7B1wHHc7njslAO7Mx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cOtdMqEb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66480c1a6b5so184633827b3.1
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721744619; x=1722349419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7uZHlnsW4OL40RtP/2lvo/AGXl6SnWpK7+UcdL6+Lw=;
        b=cOtdMqEbUjc4hxcAPm+5pma9qvIB9VWnfTby/q6Dv4rQzD2WsMrUJAMyxeI168jV11
         xt0EpT3Cpuf4mhYQ/Yj7BxHBcmKkytGUXxkNA3FGVc/uFAuUDTN88zPbJunuQip/BfO0
         /zu0sIwT6aGalco1F0orcrE5GqxbrXUSDJdKcbqKe1BcePny16juM3++vyTRnqiUcEkb
         RW9udQi0ZEJ4O6QkaSuHFADvxgQX5gtNXe8//l6drhMMAc6tx04QcRmSjrKCWRkkocox
         4eSueXwYl61BRlkBG8jllho/k+w2ERwNuwPssWcN4J/XQNta9SSiQ2OY811AvRbLLTQe
         3RgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721744619; x=1722349419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7uZHlnsW4OL40RtP/2lvo/AGXl6SnWpK7+UcdL6+Lw=;
        b=LQByB6jTvs12wPwhG8VQ521YR4ZKM5/QC5TdyQsdNhr5fCTLWF/wzZ2q8dfpQQqckA
         REDzy8/O4O4tVt4mLD81Qxww5EB7nriOeXxnSF5eLu4oWs1usE7bojyflW2yBAzNc0H0
         6fF2QnzaXQF7O3Q1cD3GfiIrVJaeZbA6DzD+3QTViWXorlvnMkfzqKuiT6gTCJ5WL4K7
         whbHdWsps6OJlFfl2K3TQNzQ+vtLI+6owcB/kFMSCzoShmg1xD3ZeinkLCh7lo8mJcSG
         I7Wfc37CuLlfEHChLmSnCYvGiM6CvA6aTGhBWpUV7cpBHzVDr2QP1oRP8oq2rjXj5pyP
         Px/A==
X-Forwarded-Encrypted: i=1; AJvYcCWxX71oN6BJ53HuT0ilJlS45WKYo1jtOCoDzmu+I8anVlOvSAhNBBG5TC0TKk3OVv/CQ58pKxBuHkbBmq1NiDVIIYe6
X-Gm-Message-State: AOJu0YyBOnGwPg6Jeqgd/ku2aq/ja4cUQjlxjaiTvO0rUPl29zL7Aa58
	RIfc3n7fmHbqHyMdgSN7LWMw1FgUb6G5OXbEi8HAu2F6t3P2Xn1eVXXF0R7/U6qWnJVhNX+rJBF
	JvA==
X-Google-Smtp-Source: AGHT+IGvPQnH0U/tpIR1t3mRe7duPwj4S4iYv3/ML/p+jwqS35TYyJTs5i6KeHPlHAo4yj88wS0IHavwHDA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d84:b0:62f:f535:f41 with SMTP id
 00721157ae682-66a65d6ed69mr5250417b3.9.1721744619279; Tue, 23 Jul 2024
 07:23:39 -0700 (PDT)
Date: Tue, 23 Jul 2024 07:23:37 -0700
In-Reply-To: <20240723132004.GA67088@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240722235922.3351122-1-seanjc@google.com> <20240723132004.GA67088@k08j02272.eu95sqa>
Message-ID: <Zp-8o7dGivU_ek86@google.com>
Subject: Re: [PATCH] KVM: nVMX: Honor userspace MSR filter lists for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 23, 2024, Hou Wenlong wrote:
> On Tue, Jul 23, 2024 at 07:59:22AM +0800, Sean Christopherson wrote:
> > ---
> > 
> > I found this by inspection when backporting Hou's change to an internal kernel.
> > I don't love piggybacking Intel's "you can't touch these special MSRs" behavior,
> > but ignoring the userspace MSR filters is far worse IMO.  E.g. if userspace is
> > denying access to an MSR in order to reduce KVM's attack surface, letting L1
> > sneak in reads/writes through VM-Enter/VM-Exit completely circumvents the
> > filters.
> > 
> >  Documentation/virt/kvm/api.rst  | 19 ++++++++++++++++---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/vmx/nested.c       | 12 ++++++------
> >  arch/x86/kvm/x86.c              |  6 ++++--
> >  4 files changed, 28 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 8e5dad80b337..e6b1e42186f3 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4226,9 +4226,22 @@ filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
> >  an error.
> >  
> >  .. warning::
> > -   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
> > -   This includes both writes to individual VMCS fields and reads/writes
> > -   through the MSR lists pointed to by the VMCS.
> > +   MSR accesses that are side effects of instruction execution (emulated or
> > +   native) are not filtered as hardware does not honor MSR bitmaps outside of
> > +   RDMSR and WRMSR, and KVM mimics that behavior when emulating instructions
> > +   to avoid pointless divergence from hardware.  E.g. RDPID reads MSR_TSC_AUX,
> > +   SYSENTER reads the SYSENTER MSRs, etc.
> > +
> > +   MSRs that are loaded/stored via dedicated VMCS fields are not filtered as
> > +   part of VM-Enter/VM-Exit emulation.
> > +
> > +   MSRs that are loaded/store via VMX's load/store lists _are_ filtered as part
> > +   of VM-Enter/VM-Exit emulation.  If an MSR access is denied on VM-Enter, KVM
> > +   synthesizes a consistency check VM-Exit(EXIT_REASON_MSR_LOAD_FAIL).  If an
> > +   MSR access is denied on VM-Exit, KVM synthesizes a VM-Abort.  In short, KVM
> > +   extends Intel's architectural list of MSRs that cannot be loaded/saved via
> > +   the VM-Enter/VM-Exit MSR list.  It is platform owner's responsibility to
> > +   to communicate any such restrictions to their end users.
> >
> Do we also need to modify the statement before this warning?

Yeah, that's a good idea.

While you're here, did you have a use case that is/was affected by the current
VM-Enter/VM-Exit vs. MSR filtering behavior?

> Since the behaviour is different from RDMSR/WRMSR emulation case.
> 
> ```
> if an MSR access is denied by userspace the resulting KVM behavior depends on
> whether or not KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER is
> enabled.  If KVM_MSR_EXIT_REASON_FILTER is enabled, KVM will exit to userspace
> on denied accesses, i.e. userspace effectively intercepts the MSR access.
> ```

