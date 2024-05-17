Return-Path: <kvm+bounces-17584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E568C82D3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72187282D73
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 08:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0991DDF5;
	Fri, 17 May 2024 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZlPEPbgc";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="re9dqAbs"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E505ED535;
	Fri, 17 May 2024 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715936227; cv=none; b=G0DGK/wrmG8pz9MgIjzwFMMJu3SldaR+22A/zhMuAFBW4EjShkz1517EGBMmHxhyPft4RdvNdhDRJC2g6xixPQWxtMgcJGWZsHh1N0l8XCpsvSrAt/MEnJjNphFNKqfsmL+6pgdCk5HzhHxIq9zibYMqs0i8KWMF471ODx9ZhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715936227; c=relaxed/simple;
	bh=KwABJcoXzv/apJpy2BiCEvtbilXsC/7jeJ66JE67Aik=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=E6a/ZAeouDpgNtbJ3LrO4q4fsYq8VPMCJhcp9UKoQtJRV3BpduX44uEcjykRAxxwzci4LuLRP34RcQHSmkGZ6kZvpoaTJAi67uwjxd4rsmhtkar+qXkP1rimWQyaP0Zt0zAdkYnHOyiFaTk5G4wn7HsWV7Re4Xa6wFN2r9i6h+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZlPEPbgc; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=re9dqAbs; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1715936224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPppGGohGgr5AyKjt6H/6fL/nfQDYDybva5rQhqmn6w=;
	b=ZlPEPbgca+2/UXHWxVg5R2Ac/qF9KCzwaVaAWZVcL0t9sk8CYHp0y+MeQA8J4ehkmKtFZR
	Guezx7XS2FDi+LV5/qrmwqlJTtFH35rboHYGLVHfHkDWof4oOwLBHDuu45V+Yj5m0CGA9R
	F5ecHBN4qj/yoa33coqmerSu2VJlkPLQU7FDI69EGjJG9wpwVb31jDXJKsKNMcVyb2lhuW
	vjgRBA6XlStJeUL4ByKxbMcCi3P2r2Zu1TtashO1Y/7gKnswBdMPe5pX2lT6P1Ump6a/nY
	KWHJ1GANS/jIS9xR9UzqpXDHEJhPIdRDtQOZu3ZRZ3YvmswmDpbvSGnaa+zdew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1715936224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPppGGohGgr5AyKjt6H/6fL/nfQDYDybva5rQhqmn6w=;
	b=re9dqAbsB7DcbcViC9BF0L5Tzjwf33iNun07O+dNxgQeA10Zt5AQIv+O/3Jsp6pWTPNeUF
	J7zliwLSLABQcODg==
To: Sean Christopherson <seanjc@google.com>, Weijiang Yang
 <weijiang.yang@intel.com>
Cc: rick.p.edgecombe@intel.com, pbonzini@redhat.com, dave.hansen@intel.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, chao.gao@intel.com, mlevitsk@redhat.com,
 john.allen@amd.com
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
In-Reply-To: <ZkYauRJBhaw9P1A_@google.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com>
Date: Fri, 17 May 2024 10:57:03 +0200
Message-ID: <87r0e0ke8w.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, May 16 2024 at 07:39, Sean Christopherson wrote:
> On Thu, May 16, 2024, Weijiang Yang wrote:
>> We synced the issue internally, and got conclusion that KVM should honor=
 host
>> IBT config.  In this case IBT bit in boot_cpu_data should be honored.=C2=
=A0 With
>> this policy, it can avoid CPUID confusion to guest side due to host ibt=
=3Doff
>> config.
>
> What was the reasoning?  CPUID confusion is a weak justification, e.g. it=
's not
> like the guest has visibility into the host kernel, and raw CPUID will st=
ill show
> IBT support in the host.
>
> On the other hand, I can definitely see folks wanting to expose IBT to gu=
ests
> when running non-complaint host kernels, especially when live migration i=
s in
> play, i.e. when hiding IBT from the guest will actively cause problems.

I have to disagree here violently.

If the exposure of a CPUID bit to a guest requires host side support,
e.g. in xstate handling, then exposing it to a guest is simply not
possible.

Just because virtualization allows to do that does not mean that it's
correct in any way.

Thanks,

        tglx

