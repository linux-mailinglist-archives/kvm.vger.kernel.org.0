Return-Path: <kvm+bounces-32546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 833309D9F1C
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 23:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA37B166653
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 22:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FAE1DFE06;
	Tue, 26 Nov 2024 22:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XNgLAnm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE86F1B87FF
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 22:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732659021; cv=none; b=uGAXk9DOcr5El9VJxO7TDIsg9V+afMOKhWSuO2vALwwzXKZecTOr+0Gy92gTDVlSyg+s9W6vgKFu7dARzm3cegoLcTZO7as0GCIY3ZnuiOXf0fr7djgt2l7AVSKbS5JOA36Ya4J/Q7efwAK4DjmfIFpgspv86oKIj1Lf5aShuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732659021; c=relaxed/simple;
	bh=gSZIaECtCHOKSxXbwE9pVgArPG9n7++k8LrWJNGT3zE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rg2CFUOT64UGZ2NSysZftRRHpjgLH86G16/R8AJGDPYVB+KScRt33yJekMA5gHtN89eoGAPn0NMO/bKVOBbaIvDWYVFKW6pXyLMuh9pELL9WujXMEfKGFpSlng4fEzwOg5EcegoBwbgYrZbgti38pYhCoMnGLhXxNkinuC5NAFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XNgLAnm+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7251d37eac5so1534761b3a.0
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 14:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732659019; x=1733263819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3J7pzs54Wf25x1zIzv3e6zhuB2i9LCT6pm8EAHqawec=;
        b=XNgLAnm+jz1Fa5CdlWfX5ZrE7ULq/Rv0QC8LrBIe7xyF6J802JYmDWxSx/rOpOFPvB
         QQgTNTPh7SuIoum9c6CdY/SupNODdY2FqCy1roGQq/OFnYpA7rBkMAYXbxypzoC2nRCB
         SklJSMoob3inggfHAVvt900llVZQ3wHA5PgVXpqb9h4S6auwWLKB9N1kl6PFs99RZca0
         9zdzhEXEjoBWvb2i/Px/9KJPU+/TWgWwS9f60j2WufSWnK1vMQWrZcMdeSFfXu6EaQ+c
         62FpO5sBo4FqsLUisQYoein35mloCOz6U8EEIzTWtuHdjNe9f/G7Auojjx6wbca7WVKv
         qnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732659019; x=1733263819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3J7pzs54Wf25x1zIzv3e6zhuB2i9LCT6pm8EAHqawec=;
        b=lyMlLnHCDDWKk1DoUyJTBDAcmCoacbWkFfwCscXWDAVNyDafnBbYeXhumX0N+H24rv
         MnlOtWKyDgQgXQHDkO+FyP+rTWcjWXGbKTaj37tyPic7gciBAm86hyYMhjG9UdO6RjZZ
         bvOKi1xl03tJCaN6jYmhv5soOAOcDA/T9uLxqA88jCBN/acQwQBsLsmkkGXUnUq6bErh
         3o8RNoD0+alPwAZD5LF2DsfFmo16t23FlyucQcX4IWowH61rYXFe7NlJ9cvuMiMg2VQT
         +LFr8Rz5GXMX5RTxqZHFnHNu45B1UK3+QaaTi0dNLdUK8TwqFKmnrKKVonGDcXXuqFHN
         lckg==
X-Forwarded-Encrypted: i=1; AJvYcCU+Ze4uJfWF4Mra8+0lciiEMKGbyxgOhnXposiM9Ryue48DIp6ala7fIIldc99g1SR6oEU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZOadITdSn01kFVr4md3HU/OlzpOfpHloO/QZvj8mXUP5Hb3GT
	ra5dGuRmyXdZRF5U65KNyHsobtzL6ySybUXGnKMH15RGMDKVVRQ50T+4YsFrz5313UFCrhIqC5t
	wQg==
X-Google-Smtp-Source: AGHT+IEEM/tYogue16hPpfa95F5JMzu6HQKiqWHctKXgee1+kfaZo/ff1dsevgRueygNUpWBHwhaBZIY7tI=
X-Received: from pfbcp5.prod.google.com ([2002:a05:6a00:3485:b0:724:edad:f712])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22ce:b0:71e:5b92:b036
 with SMTP id d2e1a72fcca58-7253013e930mr1083280b3a.22.1732659019054; Tue, 26
 Nov 2024 14:10:19 -0800 (PST)
Date: Tue, 26 Nov 2024 14:10:16 -0800
In-Reply-To: <e12ef1ad-7576-4874-8cc2-d48b6619fa95@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118130403.23184-1-kalyazin@amazon.com> <ZzyRcQmxA3SiEHXT@google.com>
 <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com> <Zz-gmpMvNm_292BC@google.com>
 <b7d21cce-720f-4db3-bbb4-0be17e33cd09@amazon.com> <Z0URHBoqSgSr_X5-@google.com>
 <e12ef1ad-7576-4874-8cc2-d48b6619fa95@amazon.com>
Message-ID: <Z0ZHSHxpagw_HXDQ@google.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, peterx@redhat.com, 
	oleg@redhat.com, vkuznets@redhat.com, gshan@redhat.com, graf@amazon.de, 
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es, 
	xmarcalx@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 26, 2024, Nikita Kalyazin wrote:
> On 26/11/2024 00:06, Sean Christopherson wrote:
> > On Mon, Nov 25, 2024, Nikita Kalyazin wrote:
> > > In both cases the fault handling code is blocked and the pCPU is free for
> > > other tasks.  I can't see the vCPU spinning on the IO to get completed if
> > > the async task isn't created.  I tried that with and without async PF
> > > enabled by the guest (MSR_KVM_ASYNC_PF_EN).
> > > 
> > > What am I missing?
> > 
> > Ah, I was wrong about the vCPU spinning.
> > 
> > The goal is specifically to schedule() from KVM context, i.e. from kvm_vcpu_block(),
> > so that if a virtual interrupt arrives for the guest, KVM can wake the vCPU and
> > deliver the IRQ, e.g. to reduce latency for interrupt delivery, and possible even
> > to let the guest schedule in a different task if the IRQ is the guest's tick.
> > 
> > Letting mm/ or fs/ do schedule() means the only wake event even for the vCPU task
> > is the completion of the I/O (or whatever the fault is waiting on).
> 
> Ok, great, then that's how I understood it last time.  The only thing that
> is not entirely clear to me is like Vitaly says, KVM_ASYNC_PF_SEND_ALWAYS is
> no longer set, because we don't want to inject IRQs into the guest when it's
> in kernel mode, but the "host async PF" case would still allow IRQs (eg
> ticks like you said).  Why is it safe to deliver them?

IRQs are fine, the problem with PV async #PF is that it directly injects a #PF,
which the kernel may not be prepared to handle.

> > > > > > I have no objection to disabling host async page faults,
> > > > > > e.g. it's probably a net>>>>> negative for 1:1 vCPU:pCPU pinned setups, but such disabling
> > > > > > needs an opt-in from>>>>> userspace.
> Back to this, I couldn't see a significant effect of this optimisation with
> the original async PF so happy to give it up, but it does make a difference
> when applied to async PF user [2] in my setup.  Would a new cap be a good
> way for users to express their opt-in for it?

This probably needs to be handled in the context of the async #PF user series.
If that series never lands, adding a new cap is likely a waste.  And I suspect
that even then, a capability may not be warranted (truly don't know, haven't
looked at your other series).

