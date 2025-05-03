Return-Path: <kvm+bounces-45278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD1BAA8000
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 12:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338EC3B3C35
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 10:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C95F1E2838;
	Sat,  3 May 2025 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GOB+MR3V"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B794519ABD8;
	Sat,  3 May 2025 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746266935; cv=none; b=gecQba97/o8IP2bwiV8JpcPwjmMhtMDwOYRsb4Iryj4+LYHt+MLi4iZ13Z5TcUt/CSoTHd+Wcl+Vtd/v4pN4UG6hGSVkvORDeFaGciZqh2px3ODNN13Ii5sldx6JXkw8SXjoYcHKT7cAkHwYkH1ME/SG/rlGFKvQM6E5jlVBmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746266935; c=relaxed/simple;
	bh=9op9BmzY8ov6wLvu2KZZNlZJhoo/hYZSZDgi3xq3z0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOrTtDhmPNPPDy4LpcfagPi2Baij2F1K7GP/+jpusngUMIh0DBGaeTrbjqbPevXWZklZ5Oxpat5/MPQgTIzicKmcJbkshOdwPOfUDkqAK0OkVP0gTn65meWPqPvRQt+r7Mtw5rfFOyGrwFpcWKeJ7zMZo+Nlyo/o7nv+ZWbDG8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GOB+MR3V; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dJ5yxwzSd18ze9t6hVLldU0j6KOkUmoNge4T8HYqBS0=; b=GOB+MR3VxfN1j7WarrQhI/6dmH
	vRfudx8ixVXXLahZ5Vh8j/YV+rz0bN0tn9bTArcTr1NsyR+0jGLwlNt8EYztmc0IUq0DpZL7Pe46D
	mCGzoxK2teuDvnXJsCVUEUXwYXDC3wAee2RqoeN+fsJd+RzTI+mQwxdDIvggeLZlaiKAWFLqPRq0S
	IuswIIPXKlfbEagBmwO0i3IGgARDudkxbUIeLTk+oovsy5LYtPuksQ4IQ+OneWlj/q6IJCz1xOC8h
	XittOBymb3zchZdOthguklAKCk9nDEM6I2jsYEv83el4962flzGypwFgOz5frjIaNshHKTwaMi6+8
	KWo6/NdQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uB9nB-00000002xfU-2zcZ;
	Sat, 03 May 2025 10:08:22 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 09B7630114C; Sat,  3 May 2025 12:08:21 +0200 (CEST)
Date: Sat, 3 May 2025 12:08:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>, Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 5/5] x86: KVM: SEV: implement kvm_lock_all_vcpus and
 use it
Message-ID: <20250503100820.GF4198@noisy.programming.kicks-ass.net>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
 <20250430203013.366479-6-mlevitsk@redhat.com>
 <aBUxqZ6qgfYZLsye@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBUxqZ6qgfYZLsye@google.com>

On Fri, May 02, 2025 at 01:57:13PM -0700, Sean Christopherson wrote:

> int kvm_lock_all_vcpus(struct kvm *kvm)
> {
> 	struct kvm_vcpu *vcpu;
> 	unsigned long i, j;
> 	int r;
> 
> 	lockdep_assert_held(&kvm->lock);

So I agree that having this assertion here is probably good from a
read-code pov, however, strictly speaking, it is redundant in that:

> 	kvm_for_each_vcpu(i, vcpu, kvm) {
> 		r = mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock);

will implicitly assert kvm->lock is held. If you try to use an unheld
lock as nest lock, it will complain loudly :-)

(my inner pendant had to reply, ignore at will :-)

> 		if (r)
> 			goto out_unlock;
> 	}
> 	return 0;
> 
> out_unlock:
> 	kvm_for_each_vcpu(j, vcpu, kvm) {
> 		if (i == j)
> 			break;
> 		mutex_unlock(&vcpu->mutex);
> 	}
> 	return r;
> }
> EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus);

