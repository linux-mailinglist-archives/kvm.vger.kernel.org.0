Return-Path: <kvm+bounces-48745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFEAAD243D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EF5D1890657
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 16:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A5521ADCC;
	Mon,  9 Jun 2025 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C4XczrUd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039EA21B19D
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749487181; cv=none; b=seEMozpuaELcfFgA5x7uGCT3b/TtIMQrBk+rxleaDNP7WUTovrgyY486z3klBAyUGeJaJycCRRetOE7SMMrMywjf3/QqNYddhpkek7p/R5vw5J0QugkK2WIEMR6sQHja/u9Y/u5gA+3tQLZJi9by4ljKaIYFlXCBmDawM0W1NhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749487181; c=relaxed/simple;
	bh=3WT2M3t2asis+XbNpji5rb+9JfYg+oWQA2D7H2Bzueo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pk3QmiHiFDf59l4oYHsUjHXuQVFmlU9KP/iD9c785fNmvgnWQppo309sqZ5AHTlfKe9gv2XI6Zf6zzNYrr/yvJjS3nFjFNvOUfsBnqJfAqnjx5EN/fJTqyidCsv0BGl8DZykvMRnkmH63ymhVJ2XuS1q0HqiSyYsnM2DoE0sJ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C4XczrUd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115383fcecso2579499a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 09:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749487179; x=1750091979; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMQ8PN6884DW9W1jNjmty1PvTsBAocPOjKWRL+Dgqsk=;
        b=C4XczrUd5Ol5tch99PqfzB/B70Gb1rLFRt4f5ycfY1AXSMVE7eEE7Y7KCknFwOWWkZ
         yUK/63Mh58iIz9ZqrgZ/7vIm9X73vYv2KvRdxu1S6FVgGT4x1EBhTk+CalCvoRO+XFzi
         mTnnqtngSHDCuWR/EY7ADVSu3exeRnmM4qPSFwH/HRlRGJuzjYq2weyHm9tq3yVKLGmp
         bbLTW2fXxtm7kNTm3Ja0YXWG+Sk5l+16L47mmLo7mCDXunwiHzkYnH+wqkxwxpRpIqp0
         wym6gLgBMPDorCgD98bRqqCn8eYIwMhzwI8M6dkQ30w/48Fb/GPkr2/qXr/EIrfsoQVT
         RMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749487179; x=1750091979;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WMQ8PN6884DW9W1jNjmty1PvTsBAocPOjKWRL+Dgqsk=;
        b=tEXwQUktajlr4GcTp2sdWKQJAihoREwGm83biNJnlh4fa1DKnh3NdZWrwUxC3ODKfA
         QMBCJTtLbL0wz/y0NqYNJ3iabtwrEIRdTUEDhWrpDO1RCduSyMtNjEYfVnp50F8+SHgu
         0Z9ToINpuFF6eThJEfWm4dSUYsDHtFW5UOvf+6ZnIxiRCYttkmFLaB1/WAUziyI7O5tQ
         aq4skVgfgtSVkmdbp37/jjZNnBALK61Wd79KNei2q4oX1Xbesvh3s6vpT1vZzHtq0iH2
         PtZdS+PDbzvDWxhoBrwQGHuSOGLLpuxKiXLpIJBpm1ebw7eEw3VFduOhluVGLi28T7/m
         pH7A==
X-Forwarded-Encrypted: i=1; AJvYcCVHp/ujjaEvbTUGLiTW92oWtdivGNJyi5HeDDn8+UPxI9/DrvtyxhV4vVWmQPYy4wcrhs0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxw5wsacf8urPBwDg8cQ2aFhsPqf28ifDtMVJCHLpS8TONNqAC
	Fr7Yyr1vjk7rqTWDny0FBx4fw1dqDm2htwRrEtRmE9OMw3Y2UU4jkx/ISewJ2RbyKac+kINJH83
	RDaKs3w==
X-Google-Smtp-Source: AGHT+IHfDLIrS/svY0wyQaqGHXC5W4UuRgfimO7Q5quxSh0AY5WdDRwhCyELO5fMyH4vF7a7e9Oz94gvduI=
X-Received: from pfhx29.prod.google.com ([2002:a05:6a00:189d:b0:746:1857:3be6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:50f:b0:21a:de8e:44b1
 with SMTP id adf61e73a8af0-21ee686203dmr20638459637.34.1749487179116; Mon, 09
 Jun 2025 09:39:39 -0700 (PDT)
Date: Mon, 9 Jun 2025 09:39:37 -0700
In-Reply-To: <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
 <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com> <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
Message-ID: <aEcOSd-KBjOW61Rt@google.com>
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with SGX
From: Sean Christopherson <seanjc@google.com>
To: "Denis V. Lunev" <den@virtuozzo.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>, zhao1.liu@intel.com, mtosatti@redhat.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, andrey.drobyshev@virtuozzo.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2025, Denis V. Lunev wrote:
> On 6/9/25 18:12, Paolo Bonzini wrote:
> > On 6/9/25 15:23, Andrey Zhadchenko wrote:
> > > When hotplugging vCPUs to the Windows vms, we observed strange instan=
ce
> > > crash on Intel(R) Xeon(R) CPU E3-1230 v6:
> > > panic hyper-v: arg1=3D'0x3e', arg2=3D'0x46d359bbdff',
> > > arg3=3D'0x56d359bbdff', arg4=3D'0x0', arg5=3D'0x0'
> > >=20
> > > Presumably, Windows thinks that hotplugged CPU is not "equivalent
> > > enough"
> > > to the previous ones. The problem lies within msr 3a. During the
> > > startup,
> > > Windows assigns some value to this register. During the hotplug it
> > > expects similar value on the new vCPU in msr 3a. But by default it
> > > is zero.
> >=20
> > If I understand correctly, you checked that it's Windows that writes
> > 0x40005 to the MSR on non-hotplugged CPUs.

...

> > > Bit #18 probably means that Intel SGX is supported, because disabling
> > > it via CPU arguments results is successfull hotplug (and msr value 0x=
5).
> >=20
> > What is the trace like in this case?=C2=A0 Does Windows "accept" 0x0 an=
d
> > write 0x5?
> >=20
> > Does anything in edk2 run during the hotplug process (on real hardware
> > it does, because the whole hotplug is managed via SMM)? If so maybe tha=
t
> > could be a better place to write the value.

Yeah, I would expect firmware to write and lock IA32_FEATURE_CONTROL.

> > So many questions, but I'd really prefer to avoid this hack if the only
> > reason for it is SGX...

Does your setup actually support SGX?  I.e. expose EPC sections to the gues=
t?
If not, can't you simply disable SGX in CPUID?

> Linux by itself handles this well and assigns MSRs properly (we observe
> corresponding set_msr on the hotplugged CPU).

Linux is much more tolerant of oddities, and quite a bit of effort went int=
o
making sure that IA32_FEATURE_CONTROL was initialized if firmware left it u=
nlocked.

