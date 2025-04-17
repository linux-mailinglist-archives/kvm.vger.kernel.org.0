Return-Path: <kvm+bounces-43557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDD0A91862
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1FBD19E1D0A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A525022A1D5;
	Thu, 17 Apr 2025 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ID35VpLh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4972F22576A
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 09:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744883651; cv=none; b=lOQ3NeFqVCCshmKC/zynaNSyE2nozQAnMjqCu0EGE52OSKxdpo6a2tksTN/b2Fx6558LRclA9C8r04BgJLTmMefIObnWZNd+LTxQjlj2HxuztRKgJ/Togzool2sB50flmfyUD1znm2xxRR2VmKJ8tdwv9KnAdx/BgMW+HMs3NfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744883651; c=relaxed/simple;
	bh=3BhkDRy9UEw8pUROqk03rHaQpLsP1EoR2Hnqbktpafc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KweVVwWF1O2ErTp/9NXWi7XVyZwoijAeJpHQv47uiOVwZ2ssWzT8EWRzZvjuzoiUIDKPN59my180wsLzXUlvIf7ktRLhprKi6og+2vMIAw/O9G5g5/y2s+vLxcUPAu+Mw6qi1gmDFZx7hGTUolaiP8qpHWRHfxAnGY8kiZGscrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ID35VpLh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744883649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8frcNR3d7ivP4NC+vlhr7MJ2cYU39BpSTQEOAw1o4aU=;
	b=ID35VpLhWpwaVM1r4/KrdZ43hdh212IgE1YbxcUtmx7YmqAS2Hk0S9ZqtAC8KIV9B5D0eC
	4+5tdUXWAh0nWhidC4SFkNTfTMoiBp0o5CYeOIe+03Sw1eoFDwjFvEMVoq2q7+SBgkuCmy
	8pUtK3bpXUtZBqmNB5cpvBvp1NLmtBU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-NCdJ3OloPEqJMO27GnKHmg-1; Thu, 17 Apr 2025 05:54:07 -0400
X-MC-Unique: NCdJ3OloPEqJMO27GnKHmg-1
X-Mimecast-MFC-AGG-ID: NCdJ3OloPEqJMO27GnKHmg_1744883646
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so4413615e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 02:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744883646; x=1745488446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8frcNR3d7ivP4NC+vlhr7MJ2cYU39BpSTQEOAw1o4aU=;
        b=RgOSZF+Jxk4/0RLkyZOAxbQfo3BNbJ0Ad3mHnLDS8JBONsjh4hFrFSwMvR1fne2C3y
         qiYG5dzovf2tF5Xjwq8M120Oy/BqWMuNusPbLaQz7pi+n2m8/iWoheDZU3I1CTF2zEU+
         JT7+mQh+HGosyoCAa1ISSo/kNjhSi1MrA/HSHCcRPa3VU2MM+phF00cHnhMofs9z/MDQ
         VBF00guckP7RnWaJyR3CKb1W+4JJWqgVjCmRaTT6YkiTrrKdgjxXRVEMCQuO+V/dIhPd
         NXeRpqE84on+wvANA+prCT5+ceDGc72VJSYNijNUDLsFye8rk3hwJZIYPWdYmG1uu5XZ
         twZA==
X-Forwarded-Encrypted: i=1; AJvYcCVhmfpSAzOnZ7+vPstpJyk7EjeeB5Eqrn/PuWZBmGon9SsR9IPo+nib3jkuvJRTxrdK7/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLoVUVAGkjqqp1+MJTShZAglkU70WAlQ1aBsvwZ6MwR4MHWX1P
	TEDaB9hSNMarxCaJcBMy3Uo+PNDjyIZlAXcxVBSgAj8XKeYRepYv67ELZ7dCHoA+WmFecL6UEnU
	rdQaSkPXNU6y9V/7gT6sCk+4UWVSaoEnyRrjaqomDu43s2LNE7l5vQoisShPFdP9jSOZ+bWo+Pq
	6vLnfmACxp4Ii3MSZ5ozV+BEC6
X-Gm-Gg: ASbGncuffo4LfMJRlGRmaBj4cyguXCM2laU1IkSi2rdNXifUUzuAvVAseOw21ODH4S9
	afOEB1piJK+ac1nBJ1rji3DMlB4ohXSLdtitlwWvamhpsgQCj2Zm4E1tn229fEf8cnA9gWg==
X-Received: by 2002:a05:6000:40c7:b0:398:fd9b:b935 with SMTP id ffacd0b85a97d-39ee5b9ff8fmr4783277f8f.53.1744883646445;
        Thu, 17 Apr 2025 02:54:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaUAX5A8zAgw7el/T3YwRV3GZLvfWnuHeaTHfLO1ACdU3siatVem4dbx0XtRNKUnrmhQD+B5DLQ7edX2knUB0=
X-Received: by 2002:a05:6000:40c7:b0:398:fd9b:b935 with SMTP id
 ffacd0b85a97d-39ee5b9ff8fmr4783241f8f.53.1744883646039; Thu, 17 Apr 2025
 02:54:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409014136.2816971-1-mlevitsk@redhat.com> <20250409014136.2816971-3-mlevitsk@redhat.com>
 <20250410081640.GX9833@noisy.programming.kicks-ass.net> <60b7607b-8ada-447d-9dcb-034d93b9abe8@redhat.com>
 <20250416185001.GA38216@noisy.programming.kicks-ass.net>
In-Reply-To: <20250416185001.GA38216@noisy.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Apr 2025 11:53:54 +0200
X-Gm-Features: ATxdqUE3EOhyuH0suu9pJLVTpoJVqiaHW5bjmzNK_nqhnV7Z7kL2fl3XehvCGu8
Message-ID: <CABgObfbH6JAh0Puu6gTKfkLd+e5uqSyHHP5i86W-=G6x5zr1wg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: move sev_lock/unlock_vcpus_for_migration
 to kvm_main.c
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvm-riscv@lists.infradead.org, 
	Oliver Upton <oliver.upton@linux.dev>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jing Zhang <jingzhangos@google.com>, Waiman Long <longman@redhat.com>, x86@kernel.org, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, 
	Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Sebastian Ott <sebott@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Andre Przywara <andre.przywara@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Sean Christopherson <seanjc@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 8:50=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
> > For the ARM case, which is the actual buggy one (it was complaining
> > about too high a depth) it still needs mutex_trylock_nest_lock();
> > the nest_lock is needed to avoid bumping the depth on every
> > mutex_trylock().
>
> Got a link to the ARM code in question ?

lock_all_vcpus() in arch/arm64/kvm/arm.c:

        lockdep_assert_held(&kvm->lock);
        kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
                if (!mutex_trylock(&tmp_vcpu->mutex)) {
                        unlock_vcpus(kvm, c - 1);
                        return false;
                }
        }

> And I'm assuming you're talking about task_struct::lockdep_depth ?
> The nest lock annotation does not in fact increment depth beyond
> one of each type. It does a refcount like thing.

Yes, exactly - mutex_trylock_nest_lock() is needed so that the
code above counts per-lock instead of using the per-task depth.

Paolo


