Return-Path: <kvm+bounces-30313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF819B93B8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:49:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D1D81C21C05
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2461AAE3A;
	Fri,  1 Nov 2024 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pn6JaUQp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701EF19DF53
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472555; cv=none; b=FerVw34hP35l2SnDXrw81XPMEh+xnZiE7RTqRaqO3S/PnpBCuJWJtPkd/wuD/AOW+fzHCUZ5xBQqrVg4vYSHh+BNnr8k8etKdvgFvptNEyxVnYGot621oVri8MA85i1AlBAKmGAVpAT0z4OVYGaEfUJWZ2F7sOhjo72JVfeHTGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472555; c=relaxed/simple;
	bh=cGHrtEFtuE+hCfoMg6QwHZrkVLdPYS4dokH/8vFaS4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qshw/qP0LUdCoqeHN0q4O+Hf1xrUIQj65iy0MoYrLDw5cFIFVuI6e+IJTNXvNaYORnq0akTHlJ5hoyS3yXYBI3Ud5AKhA/eXr39ILWrvVTNuy9Zga/YCIFQ164ucvzrh1w0UCrl20lSQpS76DdSZUUPgdSiasoKKC07DlwO4o+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pn6JaUQp; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e6241c002so2093054b3a.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 07:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730472552; x=1731077352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DZE1UJTY0R4cdv7zddNCP8fs2trgSrGlvyPjKtNioKk=;
        b=Pn6JaUQp/u9h5iLMZu6a4zUKKHl1x1vK+zyfVJa2vM0yqMDE55HzRG1k5E67l0JStC
         EInx1L38XyDvyJGhXS/DZATFaTjVpHjUV/7MdydIGdPcdR+Qa4CWlGRwcnoerz1WQm/f
         F+FBvwEJca1iMZfIzl3kHnFKokolK2T5pWSEZtcDGhGpY3eM45B8+5dmvafkNPRhHcvY
         WcmE7COBa7f5PGfiEEgl+ZHwgoeHyE0VdeG4lT88yMykM17lXdoxuYGBiiZSQoIQsQKk
         nbIGp7ayLJrOqzJZpC5LmdiB4o08ddE2dw91IG12mVXz6phJ1PZ0TU2rHZVkuPrNBJGB
         Nzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730472552; x=1731077352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZE1UJTY0R4cdv7zddNCP8fs2trgSrGlvyPjKtNioKk=;
        b=Psrdix5ajOOufJSTKTukedVBIkjHZ5wm006Dkinpbde2qZ6k/JgOaW2tRuo7OjYz4z
         JuBgSmUaiZCbroGF83LaBUF06vlwRS335W02ryBVAbehj4tpwnoxBBu1BPDeg5W4hxUc
         v8ZOHW5ClRMGK+s0Suz7gr84BWZFScH5Yh0JT9hG3ToKIz9UIqk9Wfc0cWIqaxlp0jdw
         h9OmcSov0grfdmfUIT+cVHjFL3abfj8Ll1s1Tp1VHApeX9M8yRrkbJ+iv+VqJ34nWIsG
         Cwh3pQHfKAHIrprIQTlv0AvYZcXOW1aDTYcRY2O2eOusxyrhJ8/q9hTyjiztyL0Z39Og
         TvHw==
X-Gm-Message-State: AOJu0Yzfvhc/GHFazAt8RRnhZEJbwqgEsK4i96nB/OohfS0qf53Vq6eh
	3vCFnHTEgo652ygguKpjaxIujeqYbQzh9GJ7O3BLqHAfhNhEsv2FIs4WMAssmvYT2ThSA4UgbIk
	v7w==
X-Google-Smtp-Source: AGHT+IEMn+R2pXyDAgd6MQb/9/YfmcNDeKHO+T3VqhRL44IIH/2U7mVqFF17cfyGVSm38w0p/82U4X2NwVI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6ca9:b0:720:3b92:da02 with SMTP id
 d2e1a72fcca58-720c96266d4mr105357b3a.1.1730472551824; Fri, 01 Nov 2024
 07:49:11 -0700 (PDT)
Date: Fri, 1 Nov 2024 07:49:10 -0700
In-Reply-To: <ZySXgqcYKoHJ3jcf@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018100919.33814-1-bk@alpico.io> <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de> <ZyOvPYHrpgPbxUtX@google.com>
 <ZyPjwW55n0JHg0pu@mias.mediconcil.de> <ZyQS8AhrBFS6nZuq@google.com> <ZySXgqcYKoHJ3jcf@mias.mediconcil.de>
Message-ID: <ZyTqZk88JbE3EcTk@google.com>
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Bernhard Kauer wrote:
> On Thu, Oct 31, 2024 at 04:29:52PM -0700, Sean Christopherson wrote:
> > > > Unless your VM doesn't need a timer and doesn't need interrupts of
> > > > any kind, emulating the local APIC in userspace is going to be much
> > > > less performant.
> > > 
> > > Do you have any performance numbers?
> > 
> > Heh, nope.  I actually tried to grab some, mostly out of curiosity again, but
> > recent (last few years) versions of QEMU don't even support a userspace APIC.
> > 
> > A single EOI is a great example though.  On a remotely modern CPU, an in-kernel
> > APIC allows KVM to enable hardware acceleration so that the EOI is virtualized by
> > hardware, i.e. doesn't take a VM-Exit and so the latency is basically the same as
> > a native EOI (tens of cycles, maybe less).
> > 
> > With a userspace APIC, the roundtrip to userspace to emulate the EOI is measured
> > in tens of thousands of cycles.  IIRC, last I played around with userspace exits
> > the average turnaround time was ~50k cycles.
> 
> 
> That sound a lot so I did some quick benchmarking.  An exit is around 1400
> TSC cycles on my AMD laptop, instruction emulation takes 1200 and going
> to user-level needs at least 6200.  Not terribly slow but still room for
> optimizations.

Ah, I suspect my recollection of ~50k cycles is from measuring all exits to
userspace, i.e. included the reaaaaly slow paths.

