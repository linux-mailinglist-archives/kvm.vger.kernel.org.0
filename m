Return-Path: <kvm+bounces-60137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B615BE3C32
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 15:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7462188625F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 13:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C98339B30;
	Thu, 16 Oct 2025 13:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BYg/+XKs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538DD18A6C4
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760622068; cv=none; b=KrzY7eA0xlX0bGUtQbIZCIv8NtI97rtKcK42eHwwh6Z+ZSFfr5SJkdeYPEa2/1sce+UYKFRm2n2SIIaoTkrrPqhyZv8b58PaTZwbTPS18xVEEgqkBsCiFd0pjWYyhsUnrEhAzi62U6p3YrKbbjKO3UC5r/ckyaRTcSe79Mt/t9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760622068; c=relaxed/simple;
	bh=aVEhqc/c60MDyAfUgQvI6KEHXzGImS1PZJ4Zx3bPwW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bDFJuQL/BJX/VxEmDr3SvKPAvkSL4ovzKUsYlVaSifTAOwNa02p5/e7h3wG0rr7ZIHm1ihDanji7P+TYzAEXMJIpd3ZoAiRl0VybBUbGlQOlT3pJ7QosJy44auKjHWFzST/1lCkh6k7ulYtJIpEMdVMF5pgDR+9iMolQYhPlZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BYg/+XKs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27eca7298d9so18469615ad.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 06:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760622066; x=1761226866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnajJrtq/zicbKOANLTRdaDsT6uMH68/4M/MyZaKoJ8=;
        b=BYg/+XKsJcMDtkTygrrexdSXoGy8Wf0Tqs4WdAm2gpgQJtixDqhjEgCmfaPow4OZZk
         ZxLDUeWCvK5qk9dCk01Aa62m6+L5dU6qifK/IkYu3KvjSAn6sTeU0xeNQ1X7/47pOIbo
         AH00768Byj1S1PGe2rvDCaWUrL6pPqKLkF9VNlUD5zL28iwZIgkcV1mF/I1TlidFo91D
         iGdnr9aA+yV1sE9zt/Upa/+YpboS0RsAgaN4xqlZoagc7j8GMXLJAvao0IFfHXYchC5M
         LLYV8LkgIivm8+CvMssFtFVWg6QOp1lagDdOVbf0qFgKRf5jqBTfnZfr8cBhTAtT3W07
         cMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760622066; x=1761226866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DnajJrtq/zicbKOANLTRdaDsT6uMH68/4M/MyZaKoJ8=;
        b=orcdhydIXRmxElGVfQOwVnxsz0V9aOaPAegHRgR9Mqr1OBb3SkOVs2hnCAtOvcIn8c
         gjRpeqV84oMckAFLp4PgEj8nRv/WU871kL8XlOR3ywgGhZQaUniThi5eJ8uzx+KJSy19
         lZUC5ell+Er9lyShXr7dL11eJpJ3hdqYbKK4K83ZUM5KLlkZY2CkL32bzQCQnZzpTAr7
         a9NYOdvUvsLEC1uiNK9p7+ITp2h0V2Ifq3W3MgJA5ozl45KNKC0eE0bEmZcmxECFML+u
         TtMQy6HYpZXa7kYXFdOJh19nyc9OVcDe9iqu0DaIpxW7IpM5wAeI0KZfU5TPznoNLw23
         ifOg==
X-Forwarded-Encrypted: i=1; AJvYcCXKhkVJkVS3t2M6EMiyBmuDAzp/ZO7QW/nspyCNC4OSXKMBLYMY51bIutU2v2uL3zXxO9g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3I7BDBxc93aLIg9Qsk3tBqzoEaOFlkzs3FC67jsMyFo4stxIS
	NI7n170WcifwBZ7+NF+/1fZvE59m6+txM9J9R35bXWTG8sKE4XDSCNk4Ex0hqC3cDt11TBhpmr+
	3jtmzVg==
X-Google-Smtp-Source: AGHT+IHCpSqOqfu494ZwihjiS2Nn5X3JignxUlxwge9/0fS8hKe4ONpHcMnssp5tHSKwqdBpSnpYNN1XKd0=
X-Received: from pjbsv12.prod.google.com ([2002:a17:90b:538c:b0:33b:9921:8e9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ae4:b0:27d:69de:edd3
 with SMTP id d9443c01a7336-29027374b2cmr398857755ad.20.1760622065740; Thu, 16
 Oct 2025 06:41:05 -0700 (PDT)
Date: Thu, 16 Oct 2025 06:41:03 -0700
In-Reply-To: <20251016132738.GB95606@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214259.1584273-1-seanjc@google.com> <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com> <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com> <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
 <aO_JdH3WhfWr2BKr@google.com> <aPCzqQO7LE/cNiMA@yzhao56-desk.sh.intel.com> <20251016132738.GB95606@k08j02272.eu95sqa>
Message-ID: <aPD173WPjul0qC0P@google.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 16, 2025, Hou Wenlong wrote:
> On Thu, Oct 16, 2025 at 04:58:17PM +0800, Yan Zhao wrote:
> > On Wed, Oct 15, 2025 at 09:19:00AM -0700, Sean Christopherson wrote:
> > > +	/*
> > > +	 * Leave the user-return notifiers as-is when disabling virtualization
> > > +	 * for reboot, i.e. when disabling via IPI function call, and instead
> > > +	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
> > > +	 * the *very* unlikely scenario module unload is racing with reboot).
> > > +	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
> > > +	 * could be actively modifying user-return MSR state when the IPI to
> > > +	 * disable virtualization arrives.  Handle the extreme edge case here
> > > +	 * instead of trying to account for it in the normal flows.
> > > +	 */
> > > +	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
> > kvm_offline_cpu() may be invoked when irq is enabled.
> > So does it depend on [1]?
> > 
> > [1] https://lore.kernel.org/kvm/aMirvo9Xly5fVmbY@google.com/
> >
> 
> Actually, kvm_offline_cpu() can't be interrupted by kvm_shutdown().
> syscore_shutdown() is always called after
> migrate_to_reboot_cpu(), which internally waits for currently running
> CPU hotplug to complete, as described in [*].
> 
> [*] https://lore.kernel.org/kvm/dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com
> 
> 
> > > +		drop_user_return_notifiers();
> > > +	else
> > > +		__module_get(THIS_MODULE);
> > Since vm_vm_fops holds ref of module kvm_intel, and drop_user_return_notifiers()
> > is called in kvm_destroy_vm() or kvm_exit():
> > 
> > kvm_destroy_vm/kvm_exit
> >   kvm_disable_virtualization
> >     kvm_offline_cpu
> >       kvm_disable_virtualization_cpu
> >         drop_user_return_notifiers
> > 
> > also since fire_user_return_notifiers() executes with irq disabled, is it
> > necessary to pin kvm.ko?

Pinning kvm.ko is necessary because kvm_disable_virtualization_cpu() will bail
early due to virtualization_enabled being false (it will have been cleared by
the IPI call from kvm_shutdown()).  We could try figuring out a way around that,
but I don't see an easy solution, and in practice I can't think of any meaningful
downside to pinning kvm.ko.

I don't want to leave virtualization_enabled set because that's completely wrong
for everything except x86's user-return MSRs, which aren't even strictly related
to enabling virtualization.

I considered calling drop_user_return_notifiers() directly from kvm_exit(), but
that would require more special-case code, and it would mean blasting an IPI to
all CPUs, which seems like a bad idea when we know the system is trying to reboot.

