Return-Path: <kvm+bounces-11603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2041878BC7
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40189B21226
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45524A2C;
	Tue, 12 Mar 2024 00:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wW581PCf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB954690
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 00:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710201922; cv=none; b=eG2xZMl+IW3b5MtxEOU26cp7ZCF5k/BRJjBdltuU1VkddWUyqC765p+hSKvWHsdVJP8QvIb/9xCnNH+lLo9wJ4v0bkpi4NY9NI0b8E1eIa+vUtH/APVhU8JaVW8umUqB6lyf2+fhpB65LlCmv7Yh09Fv3okblecAL+AvJdt7o/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710201922; c=relaxed/simple;
	bh=oDgrXl5DBf/ssXVPKNHBj7+pNzDKZ/SShKKd7bU4p94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lXjVaze9NnZ9Wz/1XdyKa72oIHRNBiOQQ3/VOjXMtH0rZcPStBGiugb4kDeA0yb4lempVawslC84OlnEUls10tuj/5YdWMfWarlJn1G6YMm/ibfvS1QlBS8WKXFlQxVWhMMFuXyV2W21lA5tnuHhLL2vJPvQdRZmLMzc/VzLelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wW581PCf; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso7485386276.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710201920; x=1710806720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7nbFkEwpwvreC3HB/EWWz0sBWfWHXMbipnFPkmSSNo=;
        b=wW581PCfgXwlI5gR+v40BkrHXKr5/WjOoRLYzIexvBS5an5AT8T86FqlCu7MBWl9kr
         PTUmgWUH9MdEqHSqQ20W8YoX5wqKXoBsLkgsHjRF/tCHUnVtS75TmtAhfkiinI0FQP8r
         GV4IXEs7c05k2JOHIjk3D6gtbRDx80tJeXUVtyuYuA0pL7a8HKtFWpwCsSWt9ldgidR3
         Ao6tVa36k53gBx70xbOWLTg0giHdP5eNKKaFO4CnoGMWLldBgr8r6zdyb30RTejL65UQ
         JiBF1vYmMjJiYDbA14D0x9z9dg9m+GhwEwjBg2YjmTsmDxUAa0nMaQoWaXScJ+xjOkk/
         Xyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710201920; x=1710806720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7nbFkEwpwvreC3HB/EWWz0sBWfWHXMbipnFPkmSSNo=;
        b=nVm5Mv1vA89jusPf8T+2NpUEmoj724XWG2aStz60TCkbu4i+NPiHZQr2GPJJ5VzM6K
         C4Tlo2s2hXuMZKREv/lL0hmXfG3ldU/Jj9MJlKe/CksdpJ9oMlx6cAhtDwqPnZahBnMz
         9BY+4xSaqO/s7iilbtCeob7QYsfpFTjMRuEiTlhVETSgiHWoTNYlWDZUyrJud0dJSxRJ
         h/e+sk+bpqeDuFnfe9+IFYYrbUFnVwitpUJ3NRI6FBJikLuf/5Omga0aowcOtn00a4Q7
         eghzTiCR5v0tKPNVP4P0aqTjv28GvS2dLaNsDT7X+MdBKvBYLsPPYBkLi23RgWRkuKvP
         BUkA==
X-Gm-Message-State: AOJu0YymO+P4uoe48M8bRi+v780eywd3jkfUEmC/u4IIFFUpUlDpe3AW
	zP9wRHgHVE0N8bEyS6FS9W/PC1YNYM4rLVCQIBvUARwJt0p1gjBQjAJcvOVatg/r3so6unBXNne
	RGw==
X-Google-Smtp-Source: AGHT+IFmJ3DibNwSJCV96918JM+8ES+/9EcjfPHD/sGVhKeOr2hd1X8USdSRj0ey2/+lQmXVc2jPSuAM2fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1889:b0:dc6:dfc6:4207 with SMTP id
 cj9-20020a056902188900b00dc6dfc64207mr2181207ybb.10.1710201920464; Mon, 11
 Mar 2024 17:05:20 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:05:18 -0700
In-Reply-To: <f39788063fc3e63edb8ba0490ff17ed8cb6598da.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f39788063fc3e63edb8ba0490ff17ed8cb6598da.camel@redhat.com>
Message-ID: <Ze-cPqZDXnF-FEXj@google.com>
Subject: Re: kernel selftest max_guest_memory_test fails when using more that
 256 vCPUs
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 11, 2024, mlevitsk@redhat.com wrote:
> Hi,
> 
> Recently I debugged a failure of this selftest and this is what is happening:
> 
> For each vCPU this test runs the guest till it does the ucall, then it resets
> all the vCPU registers to their initial values (including RIP) and runs the guest again.
> I don't know if this is needed.
> 
> What happens however is that ucall code allocates the ucall struct prior to calling the host,
> and then expects the host to resume the guest, at which point the guest frees the struct.
> 
> However since the host manually resets the guest registers, the code that frees the ucall struct
> is never reached and thus the ucall struct is leaked.
> 
> Currently ucall code has a pool of KVM_MAX_VCPUS (512) objects, thus if the test is run with more
> than 256 vCPUs, the pool is exhausted and the test fails.
> 
> So either we need to:
>   - add a way to manually free the ucall struct for such tests from the host side.

Part of me wants to do something along these lines, as every GUEST_DONE() and
failed GUEST_ASSERT() is "leaking" a ucall structure.  But practically speaking,
freeing a ucall structure from anywhere except the vCPU context is bound to cause
more problems than it solves.

>   - remove the manual reset of the vCPUs register state from this test and
>   instead put the guest code in while(1) {} loop.

Definitely this one.  IIRC, the only reason I stuffed registers in the test was
because I was trying to force MMU reloads.  I can't think of any reason why a
simple infinite loop in the guest wouldn't work.  I'm pretty sure this is all
that's needed?

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 6628dc4dda89..5f9950f41313 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -22,10 +22,12 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
        uint64_t gpa;
 
-       for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-               *((volatile uint64_t *)gpa) = gpa;
+       for (;;) {
+               for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+                       *((volatile uint64_t *)gpa) = gpa;
 
-       GUEST_DONE();
+               GUEST_DONE();
+       }
 }
 
 struct vcpu_info {
@@ -64,17 +66,12 @@ static void *vcpu_worker(void *data)
        struct kvm_vcpu *vcpu = info->vcpu;
        struct kvm_vm *vm = vcpu->vm;
        struct kvm_sregs sregs;
-       struct kvm_regs regs;
 
        vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
-
-       /* Snapshot regs before the first run. */
-       vcpu_regs_get(vcpu, &regs);
        rendezvous_with_boss();
 
        run_vcpu(vcpu);
        rendezvous_with_boss();
-       vcpu_regs_set(vcpu, &regs);
        vcpu_sregs_get(vcpu, &sregs);
 #ifdef __x86_64__
        /* Toggle CR0.WP to trigger a MMU context reset. */


>   - refactor the ucall code to not rely on a fixed pool of structs, making it
>   possible to tolerate small memory leaks like that (I don't like this to be
>   honest).

Heh, me neither.

