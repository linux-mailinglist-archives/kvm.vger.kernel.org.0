Return-Path: <kvm+bounces-11040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3928724CF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BA301C21DFD
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECD3DDA1;
	Tue,  5 Mar 2024 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIyeloCv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5ECD271
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657379; cv=none; b=XericJOGOh+f5Exh7oX2eYn2HUICu1hm3RtmJfNFAIo+swE4O4HqWytHyPCMtUApkWgczlP+b5HIEPL+rOn/1+bvg91eXnEBhV5GS7dWJvl3qDnYegbD9d6xTlBn44+W/Aq62cTx5Qm/cxAXj8WrJQaiVGH0JJcPYxobN81VEbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657379; c=relaxed/simple;
	bh=qbV5GBHxAnDxkjaJfXmOkJweCyzg1dMqs5oq5rbAGZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VoXRk38QgN57jYROe/DtyDy088Ywhmy+gtAk3zFDyt5O/OCeqYtghHtpUZxscTfnc/GeELSeEyLs7KX/NEQPEvXAfVWetHPn3pQriBZQ1H0rfzZfp4uvjytQ9uP8K4Y4flLkDQqX/UhKK/0mHk1++NXPvbPn/j+5GSwHgQ0eBf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DIyeloCv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608ac8c5781so101601687b3.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 08:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709657377; x=1710262177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xXZIc3wNbndhWEpVASmyszcv7nKEE3gY7hgo/qGmKlo=;
        b=DIyeloCvJwx3wyJzp/sRdl21zVK9eSajcjoF6lrNH6PP2VwyHScJ9W0pFaR5X+gTQK
         /Uzs5BVb5n4LKmvcS9Av+SbK2nrEl6HLDrLcQsksIfcexUSwwjFla/GYONfbAL6pAv4E
         vTSTF5Bruy4cQLFjYqbFz91icTo+srspxw3uQj0/54kTgjsII6bQM12e3E5l00gKsIHt
         5ZxxrgKnx9m8nEQ1WYngkrvZSPYvER2MK+P9VxGoIWkpW/iTLlxA5NHaJSASx0NHPNG4
         bVg3mhu22BjqEIhQVagU3k86ngTFy96TKXjYOH4A75dWSvq0wCquBm74YbW6zUutU7RZ
         QZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709657377; x=1710262177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xXZIc3wNbndhWEpVASmyszcv7nKEE3gY7hgo/qGmKlo=;
        b=glCkudIzPXHPh3QA0iSGb+GQC/XILPIxsx6Sc8PkqGmbJlG7UC4mrudhWcqHhokqJQ
         3BcScmwerKFaAIRBTSvlFcP2+3FGfjg4XRLkGSNxF/Xx9aCmK8bOZM53buH75U688cW+
         vFWQrGlLY3PzncU8HCG/M112s5VT4Q6LJQOov4gCCBb325cO5mZoc0aQP/zCSU7psm3e
         TFyc+01AmWQR+HdNOEcr+gHEA8WC1BZc8udFpesU2XYdF3c62QvOy/NQmq4n8ng1Yj2s
         HXadPQz7XrmsMXtC6NYDfjDzQoNyvYQ9m20PES0tNkq3V/IVCWiBkt8OM2mC2yAZg5mR
         jYvA==
X-Forwarded-Encrypted: i=1; AJvYcCWEyEr+nDvFpBjJpySETOUi9ONP7ZmbXWdWajGb/Ysj1uN9IU0MjXmWYNw3On4BAgVRWBbrSzyzKYFrIFDjKlKO/Rrk
X-Gm-Message-State: AOJu0YwRPam4BwbIFyqrcQ0Rltbj6yl/2OHBN4zuZKoNBrgeXXJ71VDc
	CvLO24k4ItTeWb+5K5gtpA6LYkMTn+inNSGfLy9KDPThYVFdM+YNJ0b5gAF82zedP99x8njDZA2
	kRA==
X-Google-Smtp-Source: AGHT+IELJZj61IeskW7Yq6+29Bob4zlRg4/whoNJBc6e44I0oxelmb9XYLdfKu21EAsyvqGMguVZS0coKnE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:110a:b0:dbd:b165:441 with SMTP id
 o10-20020a056902110a00b00dbdb1650441mr3120332ybu.0.1709657377037; Tue, 05 Mar
 2024 08:49:37 -0800 (PST)
Date: Tue, 5 Mar 2024 08:49:35 -0800
In-Reply-To: <722904540.5000784.1709650623262.JavaMail.zimbra@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <722904540.5000784.1709650623262.JavaMail.zimbra@sjtu.edu.cn>
Message-ID: <ZedNH2DFpsg5RvHC@google.com>
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: pbonzini <pbonzini@redhat.com>, tglx <tglx@linutronix.de>, 
	thomas lendacky <thomas.lendacky@amd.com>, kvm <kvm@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Zheyun Shen wrote:
> On Mon, Mar 04, 2024, Sean Christopherson wrote:
> > Instead of copy+paste WBINVD+cpumask_clear() everywhere, add a prep patch to
> > replace relevant open coded calls to wbinvd_on_all_cpus() with calls to
> > sev_guest_memory_reclaimed().  Then only sev_guest_memory_reclaimed() needs to
> > updated, and IMO it helps document why KVM is blasting WBINVD.
> 
> > I'm also pretty sure this should be a cpumask_var_t, and dynamically allocated
> > as appropriate.  And at that point, it should be allocated and filled if and only
> > if the CPU doesn't have X86_FEATURE_SME_COHERENT
> 
> I notice that several callers of wbinvd_on_all_cpus() must use wbinvd to flush cache
> instead of using clflush or just doing nothing if the CPU has X86_FEATURE_SME_COHERENT,
> according to https://github.com/AMDESE/linux/commit/2e2409afe5f0c284c7dfe5504058e8d115806a7d
> Therefore, I think the flush operation should be divided into two functions. One is the 
> optimized wbinvd, which does not consider X86_FEATURE_SME_COHERENT, and the other is 
> sev_guest_memory_reclaimed(), which should use clflush instead of wbinvd in case of 
> X86_FEATURE_SME_COHERENT. Thus the cpumask struct should be exist whether the CPU has
> X86_FEATURE_SME_COHERENT or not.

FWIW, the usage of sev_flush_asids() isn't tied to a single VM, i.e. KVM can't use
per-VM tracking in that case.  But...

> Besides, if we consider X86_FEATURE_SME_COHERENT to get rid of wbinvd in sev_guest_memory_reclaimed(),
> we should ensure the clflush is called on corresponding addresses, as mentioned in  
> https://github.com/AMDESE/linux/commit/d45829b351ee6ec5f54dd55e6aca1f44fe239fe6 
> However, caller of sev_guest_memory_reclaimed() (e.g., kvm_mmu_notifier_invalidate_range_start()) 
> only get HVA belongs to userspace(e.g., qemu), so calling clflush with this HVA may 
> lead to a page fault in kernel. I was wondering if notifying userspace applications to 
> do clflush themselves is the only solution here. But for the sake of safety, maybe KVM 
> cannot left the work for untrusted userspace applications?

Ugh, right, I forgot the whole mess with userspace virtual addresses.  Bummer.

> Or should I just temporarily ignore the X86_FEATURE_SME_COHERENT scenario
> which is hard to implement, and just refine the patch only for
> wbinvd_on_all_cpus() ?

Ignore X86_FEATURE_SME_COHERENT and just refine the patch to optimize WBINVDs that
are tied to a specific VM.  I simply forgot that KVM only uses CLFLUSHOPT when
purging VMSA pages.

