Return-Path: <kvm+bounces-30225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5569B83AD
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C989F1F2267B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602681CC8B3;
	Thu, 31 Oct 2024 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kTGiUqhv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415581CBE86
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404318; cv=none; b=oOslO10D9elJ9xeIQ3Pl7PWhxAb3paKo63DsqJYb9J9FBlb88aygzzUlHGGXvdyVaYnODqCfVTrdrNLir2ewqxIxHGH9YHqgeBMveoJkLDkVVWDKgev3O065x+EFoOKNptuX5kq+ypJYPCEAMZXp4HymdDmKkyonR03hLc6/t4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404318; c=relaxed/simple;
	bh=wLw5iwt2gypufMKb/EV9w0fhXKsOY3s0moM3uYxxFko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GvOLQor8uJV2nvU0oKs7tJSYW3C4xyQ+O9fb1WFkR8cLhuVOE8jw/ARSG2pQfiN1O2fLgo6XtM8RcPwaKX4i7BVCiPXSAe5jpTsyeg49yIy3NOG5knjEw+QTyYezTMqFMBR03BRA9gPtcI7Sdz/QtoAslmZHBwkuEqcM2l9rSMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kTGiUqhv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7edbbc3a9f2so1069262a12.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404314; x=1731009114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ftx9JHLtQDyGtXwHqfD+2M9M5G9Bcwu3Ym3sXqsUfs=;
        b=kTGiUqhvFD7EjMsty6O1wAoIrHLI/VkBh+hLstd7Ny+VZy0m19UGuD4SZT/gIz1sb/
         0/oGTPmXI1zanUZMkUJu9upP/RhaFDtwAjRHStVVhaPiJMCetV4s3Sj4qW4RE37U9sUt
         KhB81V4oqB/GpKDw9174tylZQMYNTcNhjEdTGlZnhs8SbJBMWb3O79RvfAOMfiAYKG5l
         XKDarzrAbHHWJ25qPqMFTzRwYmcyetnmIm8a2iLghrRc2RY+en9l0sEFCXXULDpsn6B8
         tZHr7PDNElYDxQ0d7N1MGLKZt/Rk2YIj1X7Y5/kek/uSKnaQ55ip/q+JalCc/gtwOGGa
         SeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404314; x=1731009114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ftx9JHLtQDyGtXwHqfD+2M9M5G9Bcwu3Ym3sXqsUfs=;
        b=tvLIsT85B6skmupfu1BbYVvQ802lBZPBraWIkAkWZBiXx3hdvZFvZXnEZ4Wa6U5iDE
         PFXZAImmoRR8SNXmnRIlR1OAvtP68foiWkfDNI7+wiIWaLE0ASenXULlV+vGvTkvl7qM
         ykXVGRO+AcnP45UyWw/adJQNpZ4sE33wyAWDuTJ9s1oaggRHqP43b+n5t7F1B/6R163o
         pQt9NTyYiwi71QABR8LAn/IdvHpALz7feeZY7ENzdN5FoQ3AxFqO+dzxa01RaeUFZfyS
         wnZ6MNMZY5WzgTdq8B1LfjdfDKLAatw1qbuq1/Y95OA8I0JrRj91IiPterf/ao3WIytD
         we1A==
X-Forwarded-Encrypted: i=1; AJvYcCVNWTYluF+l8z6H8AAvpKTpgKHu7JS2FntvZ7yvviX6uWEzaqsLd2neyEtShNdMSAF9KR0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw63REgS2wc8a7CQIEGKgE67AUyoS4HaTmxSE4ifESihv5SYiVI
	W857wT6dn/WwEY8pKq+oFkQUm59V2QyIou3tTk6tZmzVvjzNwxhJ3saqC3X91dfVr0q+nqg3Xzn
	Mmw==
X-Google-Smtp-Source: AGHT+IFlEZIkNXudx2X7J7YjSx8fHVO7lf47DdNIwVTSOKGkLmjFGPk8e0YZm0RFEMyjBPPV59yEo/X+h1E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:4389:0:b0:7ea:618:32b8 with SMTP id
 41be03b00d2f7-7edd7c9109bmr32518a12.10.1730404313729; Thu, 31 Oct 2024
 12:51:53 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:27 -0700
In-Reply-To: <20241024095956.3668818-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241024095956.3668818-1-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039504313.1508539.4634909288183844362.b4-ty@google.com>
Subject: Re: [PATCH] kvm: selftest: fix noop test in guest_memfd_test.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Patrick Roy <roypat@amazon.co.uk>
Cc: chao.p.peng@linux.intel.com, ackerleytng@google.com, graf@amazon.com, 
	jgowans@amazon.com
Content-Type: text/plain; charset="utf-8"

On Thu, 24 Oct 2024 10:59:53 +0100, Patrick Roy wrote:
> The loop in test_create_guest_memfd_invalid that is supposed to test
> that nothing is accepted as a valid flag to KVM_CREATE_GUEST_MEMFD was
> initializing `flag` as 0 instead of BIT(0). This caused the loop to
> immediately exit instead of iterating over BIT(0), BIT(1), ... .

Applied to kvm-x86 fixes, thanks!

[1/1] kvm: selftest: fix noop test in guest_memfd_test.c
      https://github.com/kvm-x86/linux/commit/fd5b88cc7fbf

--
https://github.com/kvm-x86/linux/tree/next

