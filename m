Return-Path: <kvm+bounces-22154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2E893AC8F
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 08:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FC1C1C22153
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 06:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D484450284;
	Wed, 24 Jul 2024 06:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="0guTbQLD"
X-Original-To: kvm@vger.kernel.org
Received: from out187-4.us.a.mail.aliyun.com (out187-4.us.a.mail.aliyun.com [47.90.187.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74B74C84;
	Wed, 24 Jul 2024 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.187.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721802353; cv=none; b=don7WDJaR5wAstoY7eWlIwd3RiFV8HWvUl76CyZpxa2A8jte427TUmDHLFraooE54oe5B+wOukFBdTIp7dolkD13yl5fyEFez9MsdB0u1ByBWINScF8IjNTHYoNuu5eswPShGBo96OZQ3SY9+oPdo0+Zd+t0TXak4gkNkbZGRAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721802353; c=relaxed/simple;
	bh=hM9w8SezAnui1RmVH6Fm3NjhI5mjQfCG1KwAqH9KXjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHN+ByhsD4/hC2NP4BVsV3IYp9EAtj5eK6/aGcfvmWjV9mBGJrJKIaHohqXo6VOP08a5EEHp8CnxRyQlFjxfrlpy+msgCmCtZQzis+vdmgT0nbY+JZqMnIVeThgqZhSvjzOQIurkPbGGy/JcsSSpvHfynR8ZX0xWqVbL6+KYmmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=0guTbQLD; arc=none smtp.client-ip=47.90.187.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1721802336; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=g2XFTRo1bTmgM7OhMstauV8A4SmolnQq/s7DX8E6yec=;
	b=0guTbQLDhT1MFWw/dJZaIBa8iZ+ayItodXs1kPysFgkWNa06O+3rgOIYQCzFGsXOK7M/O8RHMSpb63S6lA6sVpQxd/JX7ug9n0vQ/0GvSnc4t7AvOjo7nCz/R3tuzSNDAbS89EiqX4BpA7yH8zxddxE2Chb4H+5Ts/pFF4wBspo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033070021165;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---.YY3arCD_1721801398;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.YY3arCD_1721801398)
          by smtp.aliyun-inc.com;
          Wed, 24 Jul 2024 14:09:59 +0800
Date: Wed, 24 Jul 2024 14:09:58 +0800
From: "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: nVMX: Honor userspace MSR filter lists for nested
 VM-Enter/VM-Exit
Message-ID: <20240724060958.GA109293@k08j02272.eu95sqa>
References: <20240722235922.3351122-1-seanjc@google.com>
 <20240723132004.GA67088@k08j02272.eu95sqa>
 <Zp-8o7dGivU_ek86@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zp-8o7dGivU_ek86@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 23, 2024 at 10:23:37PM +0800, Sean Christopherson wrote:
> On Tue, Jul 23, 2024, Hou Wenlong wrote:
> > On Tue, Jul 23, 2024 at 07:59:22AM +0800, Sean Christopherson wrote:
> > > ---
> > > 
> > > I found this by inspection when backporting Hou's change to an internal kernel.
> > > I don't love piggybacking Intel's "you can't touch these special MSRs" behavior,
> > > but ignoring the userspace MSR filters is far worse IMO.  E.g. if userspace is
> > > denying access to an MSR in order to reduce KVM's attack surface, letting L1
> > > sneak in reads/writes through VM-Enter/VM-Exit completely circumvents the
> > > filters.
> > > 
> > >  Documentation/virt/kvm/api.rst  | 19 ++++++++++++++++---
> > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > >  arch/x86/kvm/vmx/nested.c       | 12 ++++++------
> > >  arch/x86/kvm/x86.c              |  6 ++++--
> > >  4 files changed, 28 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 8e5dad80b337..e6b1e42186f3 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -4226,9 +4226,22 @@ filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
> > >  an error.
> > >  
> > >  .. warning::
> > > -   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
> > > -   This includes both writes to individual VMCS fields and reads/writes
> > > -   through the MSR lists pointed to by the VMCS.
> > > +   MSR accesses that are side effects of instruction execution (emulated or
> > > +   native) are not filtered as hardware does not honor MSR bitmaps outside of
> > > +   RDMSR and WRMSR, and KVM mimics that behavior when emulating instructions
> > > +   to avoid pointless divergence from hardware.  E.g. RDPID reads MSR_TSC_AUX,
> > > +   SYSENTER reads the SYSENTER MSRs, etc.
> > > +
> > > +   MSRs that are loaded/stored via dedicated VMCS fields are not filtered as
> > > +   part of VM-Enter/VM-Exit emulation.
> > > +
> > > +   MSRs that are loaded/store via VMX's load/store lists _are_ filtered as part
> > > +   of VM-Enter/VM-Exit emulation.  If an MSR access is denied on VM-Enter, KVM
> > > +   synthesizes a consistency check VM-Exit(EXIT_REASON_MSR_LOAD_FAIL).  If an
> > > +   MSR access is denied on VM-Exit, KVM synthesizes a VM-Abort.  In short, KVM
> > > +   extends Intel's architectural list of MSRs that cannot be loaded/saved via
> > > +   the VM-Enter/VM-Exit MSR list.  It is platform owner's responsibility to
> > > +   to communicate any such restrictions to their end users.
> > >
> > Do we also need to modify the statement before this warning?
> 
> Yeah, that's a good idea.
> 
> While you're here, did you have a use case that is/was affected by the current
> VM-Enter/VM-Exit vs. MSR filtering behavior?
>
Uh, nested virtualization is not usually used in our enviroment and I
didn't test it with MSR filtering before. I found a conflict between MSR
filtering and RDPID instruction emulation when testing the x86 emulator
for PVM, so I sent this patch. At that time, I was thinking that the
state transitions (including VM-Enter/VM-Exit) would also be affected by
MSR filtering, so I mentioned it in the commit message.

> > Since the behaviour is different from RDMSR/WRMSR emulation case.
> > 
> > ```
> > if an MSR access is denied by userspace the resulting KVM behavior depends on
> > whether or not KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER is
> > enabled.  If KVM_MSR_EXIT_REASON_FILTER is enabled, KVM will exit to userspace
> > on denied accesses, i.e. userspace effectively intercepts the MSR access.
> > ```

