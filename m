Return-Path: <kvm+bounces-38474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED724A3A603
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 19:47:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4ED3A449B
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C961EB5CD;
	Tue, 18 Feb 2025 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="loCelom+"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEBA2356D3;
	Tue, 18 Feb 2025 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739904455; cv=none; b=dszXA7BMnxcXKS/xFc5o8bzdtRfcFq4JotvhCxhHhFsIvRVNgUuwhtdzrFT+XOChrZCLYn1qUIMwQpC3stCCw/oi+APmr3vuwaIkNY6iCxVAJM9wpSALjB3wqC0ptWgWQxvzFCx5uCfqZb1bWGPVfabBE2Pgm6hiyeeObrWuX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739904455; c=relaxed/simple;
	bh=kgS821ZvzlP2dxTaoeNLI5ioJyRwNqun+19UmhCW1u8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=MwLV+J+QV4KjrHCx/GT2FYJddG5uO4kLW72QIlpPIB94laknChUQy0TKQCTeAh3Y7Eirf/HbfbcRZkQ1NbQfWqILSpxwGVXwxHu5gboAtTwWHRG0OibG5l6rjnmrukj15eSQEV5pwr6kVopCAnqCYRHWQz7lu522IuoICCAwT90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=loCelom+; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pEhBnu7IjxegZyI8flpkEhAnooxMPcthAGKgdF/zgLM=; b=loCelom+fJGGA1oNRk+AQI7Er9
	pLNjceLkq3ijPryR0QFAHzUgMCTlEJr+QwKufL34ERUznAiqHOHgEenPTTQnsyL+8Q3rqtJp7258p
	jBICA1RsPHQkl7wIuRiwurokwbSyjNtYyU9mhsBo+yHaQvF/7JojcsPk6NML9sNX3FMfhs3TMVMdK
	IG6nJ1xcf6/Zhy3UJLQaMqunHrA2cBIm6XSG9h7QX+szW3eTraeeDapQXDzqYcdjb7Hp6YshMWLbc
	UPRce3gk3+7px1gcOUYl9mbBRsYh4wPMxOPD9zEnE4oBDU4s3wzlLCpHJwnZPsinonqkyM2i8+2TC
	sLNLi2UA==;
Received: from [2a01:cb15:834c:4100:cee8:77e5:e34e:6bff] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkScz-000000022C5-3vT0;
	Tue, 18 Feb 2025 18:47:30 +0000
Date: Tue, 18 Feb 2025 19:47:27 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joao Martins <joao.m.martins@oracle.com>,
 David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/5=5D_KVM=3A_x86/xen=3A_Restrict_?=
 =?US-ASCII?Q?hypercall_MSR_to_unofficial_synthetic_range?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Z7S2SpH3CtqCVlBc@google.com>
References: <20250215011437.1203084-1-seanjc@google.com> <20250215011437.1203084-2-seanjc@google.com> <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org> <Z7S2SpH3CtqCVlBc@google.com>
Message-ID: <CB09D020-703C-41D2-8F1F-32BF776BE1DB@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 18 February 2025 17:33:14 CET, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>On Sat, Feb 15, 2025, David Woodhouse wrote:
>> On 15 February 2025 02:14:33 CET, Sean Christopherson <seanjc@google=2E=
com> wrote:
>> >diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>> >index a909b817b9c0=2E=2E5b94825001a7 100644
>> >--- a/arch/x86/kvm/xen=2Ec
>> >+++ b/arch/x86/kvm/xen=2Ec
>> >@@ -1324,6 +1324,15 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct =
kvm_xen_hvm_config *xhc)
>> > 	     xhc->blob_size_32 || xhc->blob_size_64))
>> > 		return -EINVAL;
>> >=20
>> >+	/*
>> >+	 * Restrict the MSR to the range that is unofficially reserved for
>> >+	 * synthetic, virtualization-defined MSRs, e=2Eg=2E to prevent confu=
sing
>> >+	 * KVM by colliding with a real MSR that requires special handling=
=2E
>> >+	 */
>> >+	if (xhc->msr &&
>> >+	    (xhc->msr < KVM_XEN_MSR_MIN_INDEX || xhc->msr > KVM_XEN_MSR_MAX_=
INDEX))
>> >+		return -EINVAL;
>> >+
>> > 	mutex_lock(&kvm->arch=2Exen=2Exen_lock);
>> >=20
>> > 	if (xhc->msr && !kvm->arch=2Exen_hvm_config=2Emsr)
>>=20
>> I'd still like to restrict this to ensure it doesn't collide with MSRs =
that
>> KVM expects to emulate=2E But that can be a separate patch, as discusse=
d=2E
>
>I think that has to go in userspace=2E  If KVM adds on-by-default, i=2Ee=
=2E unguarded,
>conflicting MSR emulation, then KVM will have broken userspace regardless=
 of
>whether or not KVM explicitly rejects KVM_XEN_HVM_CONFIG based on emulate=
d MSRs=2E
>
>If we assume future us are somewhat competent and guard new MSR emulation=
 with a
>feature bit, capability, etc=2E, then rejecting KVM_XEN_HVM_CONFIG isn't =
obviously
>better, or even feasible in some cases=2E  E=2Eg=2E if the opt-in is done=
 via guest
>CPUID, then KVM is stuck because KVM_XEN_HVM_CONFIG can (and generally sh=
ould?)
>be called before vCPUs are even created=2E  Even if the opt-in is VM-scop=
ed, e=2Eg=2E
>a capabilitiy, there are still ordering issues as userpace would see diff=
erent
>behavior depending on the order between KVM_XEN_HVM_CONFIG and the capabi=
lity=2E

Well, I just changed QEMU to do KVM_XEN_HVM_CONFIG from the first vCPU ini=
t because QEMU doesn't know if it needs to avoid the Hyper-V MSR space at k=
vm_xen_init() time=2E But yes, we don't want to depend on ordering either w=
ay=2E

