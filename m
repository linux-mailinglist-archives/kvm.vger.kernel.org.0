Return-Path: <kvm+bounces-18303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E36B8D3935
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28AFE1C22302
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED84B1586C8;
	Wed, 29 May 2024 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IgWRqzwU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C39158211
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716992962; cv=none; b=LhE7eVSZhR+LEDg4y0WovHSFdX4d04CqJ2ovOYPii45mFFRMwLzfWrF/x5nul7y/5w98H4zqM+9nAyJoJaBG4BoQvjO6VM7pnhaP5X2C82WpeZavRltxDm/V2BDOaJUz5tuA25R305wcWhG4Wa5anW+Mkh/7z3Gh3TOwmz9+pnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716992962; c=relaxed/simple;
	bh=//0ii/zNBOQKKNaDNP3w/g1gM1CezyuYoz6Y2NAEkac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RlgiX8fTqIUjoMoNNyjEnUcEjAwnqUi42ZAnN/xwyGDyKC4QxKkanDum6lbLAFzppz8VafREDNMtJhw7yX/BYuxbh/qMRAdtzs/BL0/x/yh4mitBfK5WIoIj9X5160vD0ROX5wtCDBGEd4D88/i+FvOs1hs0QZBv+ccUjzIo2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IgWRqzwU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-629638f1cb0so34246647b3.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716992959; x=1717597759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpzkxiZJ+JsVTYQLiVluvU7gtIP+cGyMlWZAn8HOBvc=;
        b=IgWRqzwUAUE/aQEi4/xVaVivYgj7kYV1vdqPIC7g7km8uYLcpdSAlsw/Z/b4Jmkm9K
         zs31IhnlalrHF85rPT5sSwJ2uTDG3e079mgDKbeWE7xYQiW3d0YMsQu5hDb6oMKIaRne
         T3sF2VDD63pRD0nh8bv/lBAz9StTcnndb1IIcHWOCNItaKxHPl7bIGojMw3Fjb2/M7b9
         vMe4dkBZxcb0kBrkuptQYzXi8vPP5PUBWbNqJTUQvDhVQHaJvBV8xDdOgsuvjF3eDXSG
         59qmHJlUPOfVvWSnaFzVxDVhvBK7AM7j0usZEmH8mte37YIQni1bGh0nmeY0oa0PH5QK
         bhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716992959; x=1717597759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpzkxiZJ+JsVTYQLiVluvU7gtIP+cGyMlWZAn8HOBvc=;
        b=K0F4ejv1NzAI8aKUzhRkKgDvKBQiVCPOZTJx1oxFOijiqEIUT0XJzlFjwPGAu557ic
         V4FKpzyFR7LpPY2HjMIMm47LdC2cvmenz7HLkd3UAVk5xTSWxjNaL7yUGB9TWbJkhHEd
         8V5fE3Itnff23tW9vCTf0QVRKA1XbGyvc5RWVS3VdR2chBi1RQgapcOgIprOWgboiFcO
         eGJ4fkzaZVIwOKI+cIYDFJO8L5mIqSjI3Rq99QxmIaxWXK1uJX3GGcIZQuoJhBN5nqsD
         VAsbWTfKzVV7qMMXCOoTrdCOlu3mhkjLfDHhw7KHbVpLjhgxUBzmAP0dbpVfEfjDOoTs
         CehQ==
X-Forwarded-Encrypted: i=1; AJvYcCX73xRrXXWjDPdqRDtmugkmDl2Yv0oUdMgqz+fuijBwQvG/9Co2TX0RYw9stJL/98VcHAJsrd2e6pUzAH2kEwT6K8Sc
X-Gm-Message-State: AOJu0YypDpp0YyFe1adBSoZrTt7TqZv9xRjp/OTQF/+5YIUuWEGMbrfm
	F/S/prQRTNfGTzJWQn47t0DNfEWhHtGTlWWgvL60fuOD8Oj30NHxPJUU5e13ph4O9r5h56G8ygI
	+BQ==
X-Google-Smtp-Source: AGHT+IEGZoW9p/45uvlpuAhiUqCesSBDBs0K+xmgAn7zLw0SiaXYS/WuIvmvG5ZvjK25/ioNuhWd5tsISM4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d8f:b0:62a:4932:68de with SMTP id
 00721157ae682-62a49326f54mr16363447b3.8.1716992959692; Wed, 29 May 2024
 07:29:19 -0700 (PDT)
Date: Wed, 29 May 2024 07:29:18 -0700
In-Reply-To: <Zk2MRRkS6c5cGYSV@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com> <20240522022827.1690416-2-seanjc@google.com>
 <Zk2MRRkS6c5cGYSV@chao-email>
Message-ID: <Zlc7vtp4HaPHqZ2K@google.com>
Subject: Re: [PATCH v2 1/6] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, Chao Gao wrote:
> On Tue, May 21, 2024 at 07:28:22PM -0700, Sean Christopherson wrote:
> >Register KVM's cpuhp and syscore callback when enabling virtualization
> >in hardware instead of registering the callbacks during initialization,
> >and let the CPU up/down framework invoke the inner enable/disable
> >functions.  Registering the callbacks during initialization makes things
> >more complex than they need to be, as KVM needs to be very careful about
> >handling races between enabling CPUs being onlined/offlined and hardware
> >being enabled/disabled.
> >
> >Intel TDX support will require KVM to enable virtualization during KVM
> >initialization, i.e. will add another wrinkle to things, at which point
> >sorting out the potential races with kvm_usage_count would become even
> >more complex.
> >
> 
> >Use a dedicated mutex to guard kvm_usage_count, as taking kvm_lock outside
> >cpu_hotplug_lock is disallowed.  Ideally, KVM would *always* take kvm_lock
> >outside cpu_hotplug_lock, but KVM x86 takes kvm_lock in several notifiers
> >that may be called under cpus_read_lock().  kvmclock_cpufreq_notifier() in
> >particular has callchains that are infeasible to guarantee will never be
> >called with cpu_hotplug_lock held.  And practically speaking, using a
> >dedicated mutex is a non-issue as the cost is a few bytes for all of KVM.
> 
> Shouldn't this part go to a separate patch?
> 
> I think so because you post a lockdep splat which indicates the existing
> locking order is problematic. So, using a dedicated mutex actually fixes
> some bug and needs a "Fixes:" tag, so that it can be backported separately.

Oooh, good point.  I'll try to re-decipher the lockdep splat, and go this route
if using a dedicated lock does is indeed fix a real issue.

> And Documentation/virt/kvm/locking.rst needs to be updated accordingly.
> 
> Actually, you are doing a partial revert to the commit:
> 
>   0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> 
> Perhaps you can handle this as a revert. After that, change the lock from
> a raw_spinlock_t to a mutex.

Hmm, I'd prefer to not revert to a spinlock, even temporarily.

