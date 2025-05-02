Return-Path: <kvm+bounces-45256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48929AA7B2A
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 22:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B752172F2E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 20:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76744202963;
	Fri,  2 May 2025 20:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3NuIORlw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC441FFC67
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 20:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746219437; cv=none; b=YW+uI7Mn3buWPnCoIx1k3YjIlCXObrZR66+zk+tq20YgSDBff1UYrc5pxJETBFqfCUkDUdWN3lVNW46VuZRVFmeCP2Zqlk8jijHSjAmt1Vl8zUavaZRZUhyyXUOUMyKs9jEn6D0zbWdppzxF3cnRYlUFBkgpHL+phwRM05Nf6nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746219437; c=relaxed/simple;
	bh=geu1hvD8M1WtLM5eq0X8U0+bofpDI6etMkY3XNoydoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XrflNHi52qTddvPWM1UmHbRa5jyTBDstKUHmDEV0xgtNoWc5ETdyvyVAXwEf48xBHtjwaR3wu5K5TzzO2z85PpW9Y+YZhnk6xShDUGQQMsgVWPv0uNc1A4jX0W1F1HpXpigtYispGhoF+ECzwdjQgcROmXGFn2xAbh9oZVVvys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3NuIORlw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so2109211a91.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 13:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746219435; x=1746824235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjfhxP1aTkCqZKrd23sK3YHNUgKYVqxJbIVvYWHW5Vg=;
        b=3NuIORlwGKpiTG8uc8jaGhgjcoXRUu0mYrvL2Q0RXDm5LUEB2oKDNCqtn/r3aR2I/u
         +0Q3sLwQh7sZJPCEdVBzqAHuy9CZ/pEBzDILJPVIZG8L62dwFcom0YBul3v610OBXqy6
         Y35hdNKN2bbCw+pgoAs4/ZJYs7cx354wXAO/JfW12JycXALCzsdl1w4C54BXKF/gd3yM
         qb2p7RjmsVWk0pbuWQmoIJxcn+Lzo2wGBM4lBBOfjyppTahIFEddMZ2vSoPxXbD8Fqu3
         HURlN17/QrX1ztXlo0p9wtCHDN06XsfINcaddPaxyRfPHcmUV3P4j4OoFqL6m+GXaG6J
         TVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746219435; x=1746824235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjfhxP1aTkCqZKrd23sK3YHNUgKYVqxJbIVvYWHW5Vg=;
        b=urVuEXnpPjUnFDO4GY4bRWdsS741FaKKAcYlgWLvPu1dzsyE3Ubq/wBbvL73DqhUB5
         ytkIYgbY2oY/VPGhtV9GK40BBoLOWaCBzDva36Wb2G8VDWO4snbY7WqVEWVupebLd/Gs
         2QL9mtJU90UHpvu3qEcatNLi9ssBj5+2AVxo0uLAiDOkwy8unAsGyEudEdGwfcZCvraO
         oKDKCs5lbbmd/ZzfqwZzpc7JgzK7V7IkF+GHTLdbHn6CvYFkR4CZedfg971n9tbryoks
         1or+GsEXaDgFgR5P1md3pDaoeflcXKYlPWEZ56M7Bk1oKy0aU2JbNqh8blZl9gVIEP2h
         fmiw==
X-Gm-Message-State: AOJu0YwkYdnGHhLzqfVxHbDNT8MFcwDTr6hoSToiscFtVkUaQ6ZpQGg1
	pX/tgF7amVykDuMfjknPwb7QS1HYlpglmfavotPJ94UCfxwZz5UKM9qa2ZgHVFO2GuQt8wtaniF
	P4w==
X-Google-Smtp-Source: AGHT+IFuPDTKjcdWvbnOJrt3XOUZC4A4co+KVYAa4VIdQzxs3SS2Bb249oxqj85YoS9Ls6YyYG5MsQtlc4s=
X-Received: from pjbqb9.prod.google.com ([2002:a17:90b:2809:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0e:b0:2ff:618c:a1e0
 with SMTP id 98e67ed59e1d1-30a4e6b2624mr6211245a91.29.1746219435414; Fri, 02
 May 2025 13:57:15 -0700 (PDT)
Date: Fri, 2 May 2025 13:57:13 -0700
In-Reply-To: <20250430203013.366479-6-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430203013.366479-1-mlevitsk@redhat.com> <20250430203013.366479-6-mlevitsk@redhat.com>
Message-ID: <aBUxqZ6qgfYZLsye@google.com>
Subject: Re: [PATCH v4 5/5] x86: KVM: SEV: implement kvm_lock_all_vcpus and
 use it
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Waiman Long <longman@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Potapenko <glider@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org, 
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Keisuke Nishimura <keisuke.nishimura@inria.fr>, 
	Sebastian Ott <sebott@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shusen Li <lishusen2@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 30, 2025, Maxim Levitsky wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 834f08dfa24c..9211b07b0565 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1392,6 +1392,31 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
>  
> +/*
> + * Lock all of the VM's vCPUs.
> + * Assumes that the kvm->lock is held.

Add a lockdep assertion instead of a comment.

> + * Returns -EINTR if the process is killed.
> + */
> +int kvm_lock_all_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)

Needs curly braces.

> +		if (mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock))

I'd rather return mutex_lock_killable_nest_lock()'s error code verbatim.  Then
the function comment can go away, because the only thing remaining would be:

	/*
	 * Lock all of the VM's vCPUs.
	 /*

and that should be completely self-explanatory.  E.g.

int kvm_lock_all_vcpus(struct kvm *kvm)
{
	struct kvm_vcpu *vcpu;
	unsigned long i, j;
	int r;

	lockdep_assert_held(&kvm->lock);

	kvm_for_each_vcpu(i, vcpu, kvm) {
		r = mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock);
		if (r)
			goto out_unlock;
	}
	return 0;

out_unlock:
	kvm_for_each_vcpu(j, vcpu, kvm) {
		if (i == j)
			break;
		mutex_unlock(&vcpu->mutex);
	}
	return r;
}
EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus);

