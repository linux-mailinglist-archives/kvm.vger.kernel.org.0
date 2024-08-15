Return-Path: <kvm+bounces-24268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C7089535A2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AEF71C25262
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFDE91A08C6;
	Thu, 15 Aug 2024 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3QdljX/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C372D19FA9D
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732801; cv=none; b=ccyv/ssiEnKiKZ0zX0LuJ5//radcjC62iNBhSpdxAnhNIxlY9fU38BUSgCZpuLdrxnRqumGaL9Q07nV7jSET0Qs3IcsCFm7Axe+pIHdABrTxMzt9JAoKPEH9MMYoZqgsOF9knXhkVW8LAJir1bmfmWvwOL7LyOWYcOKndsknr8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732801; c=relaxed/simple;
	bh=WPQTMYfsOfAymfXre3RJj6ZP8YMqHZV3gvzZQKZNjQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tKK+SY0qLQRMNfDuoXISXGBUa2ZQVA1zLCljg2aiaZ9JO2zVHYxsmGaCxorp03q34dO+mQw0FA6UPLFIRIsYm/Ej7YtiB2lTAHiOjoOq4SYfyRogBcYd7E/EWKpPpuSU1P2jtPl5EpyI017ArWWX5/NXAH/l6VYVpJbxExtDNvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3QdljX/+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-721d20a0807so946870a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723732799; x=1724337599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cpqWW/QzIPoV5K+iQm5YrEqDbkkjx2cyk1LgXuzath0=;
        b=3QdljX/+jhBj5Rt4vfNgiOgvOK+9W1kbc317kjASVKa9ve1HZxBce663R0PwF606Gc
         g2XCYUrEhBzgEN72bC5ledsf4qfp5zElG8rjfMtUgt0aK0hzSie9jYHuXUTird2IqeQ5
         kMEbdes/OLpB4JQkgqo0DMiS98igy+9ehDtoe5d+4dtaKmOV3Kx/otUJvFAgW465nrqy
         UJyjpZyrmUVugQkla0WxAjPHYRheKZJH0rueLQdm9CwbX1ycOFna+PZ6rt3UmK292LdK
         K+zvf5zA9W1Xjb35N/QVvBano1yweJV5EOhh7esyB4VDmkDzeZEPnA6U11zajQZLxCfB
         XPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723732799; x=1724337599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpqWW/QzIPoV5K+iQm5YrEqDbkkjx2cyk1LgXuzath0=;
        b=MeBcayW86jube08LR7kuJudCjmGhZJOTXgWN1Moiolgic1JMJ6pnm6yvZ0sjr4GNZq
         DXaFILgOTQOesuDAg6V+IWe9bDe1Nczm1J7AmVjTmc3lyzT8YUGEatw9PFi641MXWdW+
         88VN6hIdts1i3u7cLIAAP1uuPcc6CVak7fCjFRKovUYzxnO6iBkviSN2GV9izPbkqJ6z
         QHepJq2ZTG5JfJ/eQUjdNtF3r3ZLRuMWcSOICSsaj5/C2tAewbLsu2o/HLvJlZ4r5wgJ
         uF/8DITPNirznmsisDSlN1O9KmusQBn3z6++TwJZS+NR/5hhjP6bOvPNGTiRb8TqD1us
         no8g==
X-Gm-Message-State: AOJu0YxC2TmeiEnvHEb9ZqgypS46b/vMJuREeqkHSaUGaJ2Chd3ld5Wf
	9LR6x4QzWoqRTWDG/4DgBS96ZA4idCmoGZHrQ+CPU4d2i3df6eTX9lE1do3tNaZ8ZXg4gXv9F2i
	meA==
X-Google-Smtp-Source: AGHT+IFEkrnB4JXT6Dloh0C8+5/5YiZ42TL3t1XJbDSuXuEFFIc1s/Cjqy56yZFXsju+XxkBWgC8I/2rLr4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:725a:0:b0:7c1:89ee:a9d0 with SMTP id
 41be03b00d2f7-7c6a54b35a3mr11260a12.0.1723732798726; Thu, 15 Aug 2024
 07:39:58 -0700 (PDT)
Date: Thu, 15 Aug 2024 07:39:57 -0700
In-Reply-To: <efb9af41-21ed-4b97-8c67-40d6cda10484@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com> <20240608000639.3295768-2-seanjc@google.com>
 <efb9af41-21ed-4b97-8c67-40d6cda10484@redhat.com>
Message-ID: <Zr4TPVQ_SNEKyfUz@google.com>
Subject: Re: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> On 6/8/24 02:06, Sean Christopherson wrote:
> > Use a dedicated mutex to guard kvm_usage_count to fix a potential deadlock
> > on x86 due to a chain of locks and SRCU synchronizations.  Translating the
> > below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wait on
> > CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due to the
> > fairness of r/w semaphores).
> > 
> >      CPU0                     CPU1                     CPU2
> > 1   lock(&kvm->slots_lock);
> > 2                                                     lock(&vcpu->mutex);
> > 3                                                     lock(&kvm->srcu);
> > 4                            lock(cpu_hotplug_lock);
> > 5                            lock(kvm_lock);
> > 6                            lock(&kvm->slots_lock);
> > 7                                                     lock(cpu_hotplug_lock);
> > 8   sync(&kvm->srcu);
> > 
> > Note, there are likely more potential deadlocks in KVM x86, e.g. the same
> > pattern of taking cpu_hotplug_lock outside of kvm_lock likely exists with
> > __kvmclock_cpufreq_notifier()
> 
> Offhand I couldn't see any places where {,__}cpufreq_driver_target() is
> called within cpus_read_lock().  I didn't look too closely though.

Aha!  I think I finally found it and it's rather obvious now that I've found it.
I looked quite deeply on multiple occasions in the past and never found such a
case, but I could've sworn someone (Kai?) report a lockdep splat related to the
cpufreq stuff when I did the big generic hardware enabling a while back.  Of
course, I couldn't find that either :-)

Anyways...

  cpuhp_cpufreq_online()
  |
  -> cpufreq_online()
     |
     -> cpufreq_gov_performance_limits()
        |
        -> __cpufreq_driver_target()
           |
           -> __target_index()

> 
> > +``kvm_usage_count``
> > +^^^^^^^^^^^^^^^^^^^
> 
> ``kvm_usage_lock``

Good job me.

