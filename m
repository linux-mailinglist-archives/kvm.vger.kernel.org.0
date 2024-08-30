Return-Path: <kvm+bounces-25581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0A7966D00
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 01:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF12D281341
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 23:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE32192B85;
	Fri, 30 Aug 2024 23:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5E5gcI8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7F18FC61
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 23:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725061520; cv=none; b=u2Tafnz2LCThBeLG7VEnyeSh30sUzHSmQZQwv2rMiDAC3aKmVPUY00L5V74Em222KbkgqMHZuU7jI2d/TI1IHMuNyhAr6PZbGTuCF8RqlQpPhnYQPUA47usF69/Efx+boFGu8Ed5H0iTVqthqqVzxYqDAcrUgNLSDcaySt474eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725061520; c=relaxed/simple;
	bh=wMq8fcpcUbfH9RqkPRWJri2Nj7kzPTs23AYrLOXTvkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJCZN2oBVqqm/8QPSHuoNitmYJRW9EPfK4cqT6szps0mHaO3AhFwLh9yOdSEwxNcnXV+6SoFshnHxFmJZVrYCgrOGm8pAojaa3cDgVoPAavtGMUR97L7ilT9Fa14JPrkWSeG7QmH3J58wIHdPjpiJ1MKAg7SuzX6xCa3UvgjAwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5E5gcI8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02fff66a83so3867566276.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 16:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725061518; x=1725666318; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rJOwOLrN9fCKsj31ZOyoET6NEGryeoiVS8pcmwkgvZY=;
        b=n5E5gcI83b6uAQivqmHbIds7cjNDsSTx3PZ/W+u4/PY/dkjMRvPen6mAwR9wk3cJ14
         9AMEEPrB6kqbJ5cu2An8sP6HQL0b0PL/4gjFazpS5gs1XdWGvIloIg+27HH+YMUE0NhL
         zsyHSmKiQfrUelXPXV5KHXZ3KQbb15fp9viAuAxkrHeqEWZxawelKH86+c3d1NqCH9h7
         iLd0Pgo+6a2xsRZFzapOiFrPbGr1LSUadUur6NMXXoC5YL72GUcyWiE9D+hvfkikmRuh
         ujJwzxQqZHOcNpTblUoEg9bOd8uwEGyV0iA6o9KXd56sJonojpTH6THnNlFzczqhWo2R
         0iJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725061518; x=1725666318;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rJOwOLrN9fCKsj31ZOyoET6NEGryeoiVS8pcmwkgvZY=;
        b=olrVYtmQYEkiOVjP94ssoqXUu+dBJkbJupBPONYUlQZA8sw8C2xr1AduU34m0RaPZ6
         gCin5Lq8OO64SnT7tBXi7PcxUM/sFoEGjbK/eLeEHGB5fGSqxg5Y+pF2NcQAOXAiMOhY
         Olp2ZF6K2mQ1/f3ABq410D2OjdoE/2IZv0TeniFTyU6+QGVb873iqQBuTBualz4t97xD
         9CAcB8sZfTphanOmL7Q/X0X3+uzzX+rUrUKmg7izDMveA7vDO/YX1jidoyvoDRcqyrYl
         lRVyqcP+/gLHJYmU3Nk6zPkZF6zHXahNM4V4Bqv6os8/t3j7RWuNYv+1u+OAD5tXxli8
         t8iQ==
X-Gm-Message-State: AOJu0YxfWihiL8YCPjURBiPc6BwMT2V6DbkKGk2kc7ycQmagQAidNCT/
	a7siYCo5W5hppMWI2QG4OktrI/9skEqYXJ+p11odYZJv9YA+2X487kh2uhSN4+wEU1K1PZcAnee
	v5g==
X-Google-Smtp-Source: AGHT+IH1lPOudhT62PJGTofQxOruBAiqUYlrCNQI4oNs0c97UCsba7G2Vigk3ybkwDh2sT9EBq08lseCwvI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2493:b0:e0e:4350:d7de with SMTP id
 3f1490d57ef6-e1a7a1786a0mr6613276.9.1725061518076; Fri, 30 Aug 2024 16:45:18
 -0700 (PDT)
Date: Fri, 30 Aug 2024 16:45:16 -0700
In-Reply-To: <CABgObfZSCZ-dgK3zWao573+RmZSPhnaoMsrify9-48UVhbKVdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com> <20240608000639.3295768-2-seanjc@google.com>
 <efb9af41-21ed-4b97-8c67-40d6cda10484@redhat.com> <Zr4TPVQ_SNEKyfUz@google.com>
 <CABgObfZSCZ-dgK3zWao573+RmZSPhnaoMsrify9-48UVhbKVdw@mail.gmail.com>
Message-ID: <ZtJZjIRdiN8e5_Es@google.com>
Subject: Re: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024, Paolo Bonzini wrote:
> On Thu, Aug 15, 2024 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> > > On 6/8/24 02:06, Sean Christopherson wrote:
> > > > Use a dedicated mutex to guard kvm_usage_count to fix a potential d=
eadlock
> > > > on x86 due to a chain of locks and SRCU synchronizations.  Translat=
ing the
> > > > below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wai=
t on
> > > > CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due=
 to the
> > > > fairness of r/w semaphores).
> > > >
> > > >      CPU0                     CPU1                     CPU2
> > > > 1   lock(&kvm->slots_lock);
> > > > 2                                                     lock(&vcpu->m=
utex);
> > > > 3                                                     lock(&kvm->sr=
cu);
> > > > 4                            lock(cpu_hotplug_lock);
> > > > 5                            lock(kvm_lock);
> > > > 6                            lock(&kvm->slots_lock);
> > > > 7                                                     lock(cpu_hotp=
lug_lock);
> > > > 8   sync(&kvm->srcu);
> > > >
> > > > Note, there are likely more potential deadlocks in KVM x86, e.g. th=
e same
> > > > pattern of taking cpu_hotplug_lock outside of kvm_lock likely exist=
s with
> > > > __kvmclock_cpufreq_notifier()
> > >
> > > Offhand I couldn't see any places where {,__}cpufreq_driver_target() =
is
> > > called within cpus_read_lock().  I didn't look too closely though.
> >
> > Anyways...
> >
> >   cpuhp_cpufreq_online()
> >   |
> >   -> cpufreq_online()
> >      |
> >      -> cpufreq_gov_performance_limits()
> >         |
> >         -> __cpufreq_driver_target()
> >            |
> >            -> __target_index()
>=20
> Ah, I only looked in generic code.
>=20
> Can you add a comment to the comment message suggesting switching the vm_=
list
> to RCU? All the occurrences of list_for_each_entry(..., &vm_list, ...) se=
em
> amenable to that, and it should be as easy to stick all or part of
> kvm_destroy_vm() behind call_rcu().

+1 to the idea of making vm_list RCU-protected, though I think we'd want to=
 use
SRCU, e.g. set_nx_huge_pages() currently takes eash VM's slots_lock while p=
urging
possible NX hugepages.

And I think kvm_destroy_vm() can simply do a synchronize_srcu() after remov=
ing
the VM from the list.  Trying to put kvm_destroy_vm() into an RCU callback =
would
probably be a bit of a disaster, e.g. kvm-intel.ko in particular currently =
does
some rather nasty things while destory a VM.

