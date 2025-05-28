Return-Path: <kvm+bounces-47872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81814AC66E7
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 12:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5DD6A2343C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 10:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD385245020;
	Wed, 28 May 2025 10:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHTRpn45"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD98214A9E
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 10:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748427820; cv=none; b=h4aMv2dMk/T6agbnS7nyIUUn9EFoBjR812RnMOoIf+ffF6V4Ow049swsN+isQ/YWjCkkx4arex7AHCV7Noz0ddUEOWyxWDeV2Bf4Y6d4OgXPt/+/zo/vR5G576PI42kbQm2opIB4PX9BIMZyMp+LdmriB20QACouSNfX+eRVN7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748427820; c=relaxed/simple;
	bh=MM/ozcOCXZ5d+VyTWQymctGaa9SnFX03kQYidoP+Ecs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1YFZrXuRIvUJ3m3eVMfwTlBURLuYvaA8AGm97Az+PE5P2MnxnR8zwrZ4HYrkxR0Ykhyo0lXM3pxV3M4erHytmFmNhQjZI8ogNyNfW7SkFDgV6+/DAzMJJ4vE/P37cNXBu1OqoH0LIL1Q7cWVwt29dGQ651iLxC9hzVj3gwsHKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHTRpn45; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442cd12d151so37304305e9.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 03:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748427817; x=1749032617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UOkwFKzz2wqGgEsUgo/sGUbk2ueBcmlhvGMY23/sxjQ=;
        b=kHTRpn45wVHyvyIrtziiDYxY1F5uQQ/Mnhzwd+4zObVGTKUnVVENnV+lWN8tgMsIEl
         owMliJvOYSOnEetNUuR6/rGqjQ1pxTstq/zf/e7MxGv62j/BEhB3x2/pVqBrSWO2u0fU
         HL6jogp12sEIUze4BZfH+INO1cMURFwGKDQQPqf87bj/lv3z3F0QFKKadYRW1RGZOQ/B
         fdF+l3GTDxJPCFlw+Tg9PqKvo22xzCeD78w6r8IMNFS6vk4Ap+Rj6RvkcOPrtSa/vh2N
         27aDuJKRlSzfHhixoNPOgtY2/OWOdsMsFzU10qVIn9uP0eHiVYfEvUZrqHoGLedb/dy6
         z6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748427817; x=1749032617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UOkwFKzz2wqGgEsUgo/sGUbk2ueBcmlhvGMY23/sxjQ=;
        b=iGAuY6bE9mH+k4UjMHAcWSQ4ywTF81d97v2Gaorp86ecN4uTo8BPzH7sqqSqcBhvHm
         4JEKW4gph9g0mQ+njAUUowyRzJUxv5XplrO9SxHugtMfO4fZtxoHEtnYAhwoSE9o3DQV
         Ns1Mx8ngn97kQ5cBTh72U85IClOcXiUFDTynKYbHJ9HjPL+ykjqHs30mKBS6gr5lstWO
         /sRnKKmVOh2698gnmQRtZTTePOBd0en85NWn5c/SgYLQsUpZ6N71QCnK0SpXvIdOVXGR
         Ia1CNwvfBuQNCRf4xgmSX8ETO+8xlbjSvrA05cx4xQSSpUjehC+X/0YRGwk3/loaY456
         tg9A==
X-Forwarded-Encrypted: i=1; AJvYcCUZeg/z59BuZpSB5Q3ujX8lOUQ+wJkSdDkp3pWrvUApho0Lkulorpuu8qQ4UUtKdNzc8+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSJLCBMZd1WGpkajFWrQ1wNg7Zzda/7qdD+IiLKhSCnZIzGBbD
	TXMBEph+FwjBE7/QI7Llems6wj7W/CD1h42OfeK21QQcjEp3FQUTTW5m94cMTnVANb7XCNFDDWH
	USXxGcEVO7Nkb7dVr0Q==
X-Google-Smtp-Source: AGHT+IE/d7QvjBd9m9AiElll2EXSy/M+uGwax68KFlLRDUZEw5WjgchZ+RZlIS0fNhH6I9/raBwqDL4gIz57Ke0=
X-Received: from wmqe8.prod.google.com ([2002:a05:600c:4e48:b0:442:ccef:e0aa])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b02:b0:43d:412e:8a81 with SMTP id 5b1f17b1804b1-44c937d12dfmr114075975e9.28.1748427816674;
 Wed, 28 May 2025 03:23:36 -0700 (PDT)
Date: Wed, 28 May 2025 10:23:34 +0000
In-Reply-To: <20250528083431.1875345-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250528083431.1875345-1-pbonzini@redhat.com>
Message-ID: <aDbkJhSA2SJphO7i@google.com>
Subject: Re: [PATCH] rust: add helper for mutex_trylock
From: Alice Ryhl <aliceryhl@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, ojeda@kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="utf-8"

On Wed, May 28, 2025 at 10:34:30AM +0200, Paolo Bonzini wrote:
> After commit c5b6ababd21a ("locking/mutex: implement mutex_trylock_nested",
> currently in the KVM tree) mutex_trylock() will be a macro when lockdep is
> enabled.  Rust therefore needs the corresponding helper.  Just add it and
> the rust/bindings/bindings_helpers_generated.rs Makefile rules will do
> their thing.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

