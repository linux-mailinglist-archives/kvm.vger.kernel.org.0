Return-Path: <kvm+bounces-28597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A74F4999AD1
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C7AA285F5F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103D61F473B;
	Fri, 11 Oct 2024 02:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="YRzuGY+l"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D332B9C6;
	Fri, 11 Oct 2024 02:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728615445; cv=none; b=DPky6tsVMtHoa8KDDdYmiEsGyF3d8RV0uLutEMNtHZs5uMelm82qaHCTxcYNlGUabneH6ZwSMa5hSwCLAoGk/pv89xEIKH0iNuWNIJPZTV2IseSKFmfTo1AyTrZhpwdID00ILvVQuJoPnvzN6GHf1K78c2ArFTt6zlA2Ab2tJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728615445; c=relaxed/simple;
	bh=6CUqCoHlttQuUsv6IoVz0XwD63cRQ/3l1VGxdbnvp2A=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hB6XkrxwfHWjKOcvBGRllS1wh9GK/8pHSOGXzoxN6AAThWs4IXxNGr8JaQQalTwmMhgt5Z92K3t5VBFYP8NUCWgtC4dHiNRCkOsDDCpLCRvIBRlgQrRguEUDibjzf5d77Iv/d4GdpVi9d8Vld0wvBjBwho+2zpSfTsP9yofRJa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=YRzuGY+l; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1728615438;
	bh=wpW3iH7IIXlP6/6yKksaYG8NqjTTOAEbPsyVV1ojgxI=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=YRzuGY+lBIuXetsc+qd2jKk7BDPQANtoWEkjLnxJL6R9MnBV1nC2SeOFQ4jhFsYd3
	 843M0cxhsJohxJGCRyfsOiirw3Uq3n6sB6eG/EEpjFZT5FbT2B0SdKZl4KBRTKvw58
	 x4NT9sQA4q7z6BsdMW8lAzl7IkYcYgHdCPhkqgJ8r9SVBo5ktMt/nUWgRD07CxF4sf
	 xIpmhsx1GIX+SX4fQCS2mkg13y/rhZ0OQhGt1MFjRIyZTqftCVobT86Es7hx/iF1CQ
	 QK5sHnJrSBJiy3pvQ/h7WdDMjm2XtENeV0bdWKMAe0SGKt/tKqdErNDcAUljeK6dOD
	 XNjvJMSNmZYWw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XPrrZ4VC4z4xPX;
	Fri, 11 Oct 2024 13:57:18 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Vishal Chourasia
 <vishalc@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] powerpc/kvm: Fix spinlock member access for PREEMPT_RT
In-Reply-To: <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
References: <ZwgYXsCDDwsOBZ4a@linux.ibm.com>
 <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
Date: Fri, 11 Oct 2024 13:57:16 +1100
Message-ID: <8734l373eb.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 10/10/24 20:09, Vishal Chourasia wrote:
>> Hi,
>> 
>> While building the kernel with CONFIG_PREEMPT_RT, I encountered several
>> compilation errors in the PowerPC KVM code. The issues appear in
>> book3s_hv_rm_mmu.c where it tries to access the 'rlock' member of struct
>> spinlock, which doesn't exist in the RT configuration.
>
> How was this tested? I suspect that putting to sleep a task that is 
> running in real mode is a huge no-no.

Yeah.

Even without preempt, spin_lock() can end up in debug/tracing code that
will blow up in real mode.

Vishal, if you look at the history of that file you'll see eg:

  87013f9c602c ("powerpc/kvm/book3s: switch from raw_spin_*lock to arch_spin_lock.")

> The actual solution would have to 
> be to split mmu_lock into a spin_lock and a raw_spin_lock, but that's a 
> huge amount of work probably.  I'd just add a "depends on !PPC || 
> !KVM_BOOK3S_64_HV" or something like that, to prevent enabling KVM-HV on 
> PREEMPT_RT kernels.

Yeah that should work to get something building.

The bulk (or all?) of that file is not used for Radix guests, only for
hash page table MMU guests.

So I think it should be possible to hide that code behind a new CONFIG
option that controls support for HPT guests. And then that option could
be incompatible with PREEMPT_RT. But that will require unstitching some
of the connections between that code and the other ppc KVM code.

cheers

