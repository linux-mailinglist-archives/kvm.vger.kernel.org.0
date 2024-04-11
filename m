Return-Path: <kvm+bounces-14325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9A38A1F8B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA63B1C214CC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDC617582;
	Thu, 11 Apr 2024 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyBBakwg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373E15E81
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712864056; cv=none; b=f4CwCuCbx7b/bof5ZWsMy3Pm7I54afbeOldKxCnZ7jEFiRzuNzLCg3cs01Gy/A4OX6vjfIeJ1QypgLLU+KSF+vWsJz1vt8cK/KUM90cevihk0LGg1/VP9eiV2gJwvhz57VyQDQauuyU/QNhty1maPN/rDKON+iauI7X/GxhQtS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712864056; c=relaxed/simple;
	bh=181iAP1TufLKZKB+puXLtuvQxMsTxzf0ulGdf48JV40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oi0pSNpHI6Crt+F7Ne+El11GLtM8FSkp+wSKxj/awsn8CoPr4NraqmNRuiimQBG6tLLHWPP5VJpsYyqXDCvohxNnxvpxHvnyx5mN3WQ0DY/TOhkbMSftT3ZBzIzIzFp9SBypI7MmoO4Cp+YtZCHQVDj0tU+kTUgP3IVTBjoNEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tyBBakwg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5f0382f688fso158454a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712864054; x=1713468854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Owi5VY3bx0eyfYbbHYaIgtR1PawXuLE8VEd3XEO08mc=;
        b=tyBBakwgrVzFPqyWZH6iEUiHfF8Z7oboQ4EzgZ5wK+8WrmQoorOYmTEdbkQxGMLTDV
         E3dr+duUmtMjbwfzmfKMjBFJE66v1Ylgp98IW0oI/sjbJgUI7dWD2al1gzxwr1kFvdnU
         V6+hoAdxqL+a2QoCX3x+sY6vJSlst9sQmG3y+HNgthLa2zMvUZzFo2/DAdC252SCzZRl
         x6te9RotKlqjAZRN9Q8w3A5BS0rJDpgHf3RJklEm7968jnSowfM4EqRuYnk/ZqJOKDWX
         Na6zGinej9xusBoOduRdm+tr4Ee74ygfe8RtrM2A0o8tMIJS0esyG5t197nRiltBGG1L
         7y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712864054; x=1713468854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Owi5VY3bx0eyfYbbHYaIgtR1PawXuLE8VEd3XEO08mc=;
        b=kUiDmB0FOtcqVbd0oFi0+2FVxrBOVm46bcFXu9gC8bGLFm64R7vUOetbCsH/m11q+i
         K63NaetkR0VdA34PIEeu0oOOnlq7sUtZKhQPzVU7XXWWPxS87ghtcecNms4qdXnx+N8T
         FJO8dKpNqLCIXjfEh/HiXmr4/cqyGliwaN/TlKuaHWGObyuZIlIqXhaFgWQpb+Ctz7QS
         MvXvzQ+b7MXbu/nmMDNLWh3p94ZhZWivIn5bAdwvNrAYp6jIb/hDXLLyYV64Dv9tLnfQ
         2lp9u4/VBJdvWhY3oYT/bBkrA5qFg1cdhcK48JKfXz62gIQaiTTZlVuPbVxeo45O2U5A
         /9Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWDvXKBKiFLk1zsEH2hyMJm5qnekFhcf0C8HbRkcpxK1hpp7tBugBlVex5d/ShLgYFtYpovshqqPPQ/KzRdR1wBBGJ4
X-Gm-Message-State: AOJu0Yw3bRXxmw7JSOTR3VyyztZuTatmpg9/DzHx6Se+t1tQIx6sJQq0
	r7QitxRrBdweMDaPqmZ8N3ADDUI38mUEiKrxU43YKaCpq/8h4lAQ7cVHJO72HpCR/2mj6I4mjGE
	uEA==
X-Google-Smtp-Source: AGHT+IGZ+qny5vsAryEUnYuYWfWFnPNMFNS3iikjoJhbHBN2jn6aXOOhLAyFbwTh2/A/B+k9D+DvbhyoZDs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68c:b0:1e3:cf18:7472 with SMTP id
 l12-20020a170902f68c00b001e3cf187472mr1091plg.9.1712864053929; Thu, 11 Apr
 2024 12:34:13 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:34:12 -0700
In-Reply-To: <Zhg3X_5A6BslIg-u@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-7-xiong.y.zhang@linux.intel.com> <Zhg3X_5A6BslIg-u@google.com>
Message-ID: <Zhg7NO9jHsh5rfGa@google.com>
Subject: Re: [RFC PATCH 06/41] perf: x86: Add function to switch PMI handler
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 11, 2024, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > From: Xiong Zhang <xiong.y.zhang@intel.com>
> > 
> > Add function to switch PMI handler since passthrough PMU and host PMU will
> > use different interrupt vectors.
> > 
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/events/core.c            | 15 +++++++++++++++
> >  arch/x86/include/asm/perf_event.h |  3 +++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > index 40ad1425ffa2..3f87894d8c8e 100644
> > --- a/arch/x86/events/core.c
> > +++ b/arch/x86/events/core.c
> > @@ -701,6 +701,21 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
> >  }
> >  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
> >  
> > +void perf_guest_switch_to_host_pmi_vector(void)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
> > +
> > +void perf_guest_switch_to_kvm_pmi_vector(void)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);
> 
> Why slice and dice the context switch if it's all in perf?  Just do this in
> perf_guest_enter().  

Ah, because perf_guest_enter() isn't x86-specific.

That can be solved by having the exported APIs be arch specific, e.g.
x86_perf_guest_enter(), and making perf_guest_enter() a perf-internal API.

That has the advantage of making it impossible to call perf_guest_enter() on an
unsupported architecture (modulo perf bugs).

