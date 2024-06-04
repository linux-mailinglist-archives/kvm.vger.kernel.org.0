Return-Path: <kvm+bounces-18823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B45208FBFFF
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720E2282B3A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF2714D703;
	Tue,  4 Jun 2024 23:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XgmDUgQV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874EF14B061
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544318; cv=none; b=lpxdASzKbu0BDwo2QN/assS9oDakWgZKSj720ShZECQSSI3JdRI8N6X5cMJXmew/E8y6roe4X3OyWCf7Edwb/l5FVqgVMJSXCNlspG47tln4egLQe9Sz85PrEEDs/dAVwOGIaoEjWz+ZtzIXZIkESxGOL9/STvpXN4MdoTzOnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544318; c=relaxed/simple;
	bh=4F8pZ57BLKSPOg0dC7ifh8ipWL6/ST+th0aJ7rMuLGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nE3ck66p5cZ4b5aXnk1FHwx6g3MmrdUzMltvDtZ3hegjxbfTeHMfas9VaoNg3cON3qOtGeYJEaYDnaldCTz1gYNlRpcC+QVgm/6uUd7io/eRVEB/bi7jk09ah/YHxTdMTRdLSGqO3royWdWDbFNiV675IkObs3pMdDfBeb+4Bvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XgmDUgQV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c554776d0fso322989a12.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544317; x=1718149117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9mbTpsLfEktMeOXsmxxA2gpvF0wwozR5+EDvFmfQ7ts=;
        b=XgmDUgQVqhYNcoyd8An6LyRGkyA90bSe9uSczVyiY1Il54Wp2THuKWPEArWjuU3eqB
         8N4aoVr6SkQCH6oWYqjFOPpNZETy8PrN4Ps87Z9oUPz+RS08gV6S57rkyA0kxZFeYjaf
         CqWGxOX1TEjbY0heJWBWSkclDHlzvVsakWPNzAC+ZaaUdRtC5SuISqGLs2C5DAhSeAFJ
         +M3/uA6cxv18/tB9VN4eB4YuD1i6MXB1X96jEGyrlnzpQi/TyeLz6mNIUaPbXr2shHH1
         Ow0DqVwZeMX2GXtwPWsBmhQZ4bdPfq64S1Zv2I4WMA2bbjpy+gcc6dAgVL19G6eN6wba
         xm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544317; x=1718149117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9mbTpsLfEktMeOXsmxxA2gpvF0wwozR5+EDvFmfQ7ts=;
        b=uEEoOQ9f6Xoow4II67nkT0DBECzWmkjEalruHR70uMnOhXYi8AXpcJ0tIhfair160q
         xbJVVeCK2pwgkhHAvPHjC/R7ub1u2o4UqrqtiYvKa2k7V+X7/Rj3B2I1Nywuz3yS43QF
         9KfyCIuyCYd3zoDwDfUHomMm9DqRPuXhdbOpq4Uev03bKMOnrS5XtcjsqAQPZY3FZi+T
         9M3jPtpOMB0iPrbJo1zl3hU6z7Vz1Z640QyaCTZifYFPchLRG9c4rc1JkRwVZHRPOb2D
         QrEQX4jo6Eytlfj2m87e2SFmHciTLGN2jJZ3o7TExiI1dvehqoP3448s81xkoQQzrrgg
         MP1w==
X-Gm-Message-State: AOJu0YypO3+nhnUimiA6gfqX+8Em2dLoDBHp1DfTWh4bow8+INGiTB/t
	C5cZTeF4jKTs+ckPHN/2Nu38uZSFslsPQ3BCK/+cp7FoORgIRHcYW8MibjrNRWVUKaLjqbDJfOa
	7aQ==
X-Google-Smtp-Source: AGHT+IFquzPD2lzjLhm17gQSbKN5QrbdeOKywzZQZb9ynG7yQ8wD/Isj+DDXyMQUMK7YtLMy69bDCZNbFS4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8e:b0:1f4:8ba7:72c0 with SMTP id
 d9443c01a7336-1f6a572fd0bmr742735ad.5.1717544316849; Tue, 04 Jun 2024
 16:38:36 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:37 -0700
In-Reply-To: <20240423221521.2923759-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754330706.2779254.12749909442900108234.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Collect host state snapshots into a struct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Apr 2024 15:15:17 -0700, Sean Christopherson wrote:
> Add a global "kvm_host" structure to hold various host values, e.g. for
> EFER, XCR0, raw MAXPHYADDR etc., instead of having a bunch of one-off
> variables that inevitably need to be exported, or in the case of
> shadow_phys_bits, are buried in a random location and are awkward to use,
> leading to duplicate code.
> 
> Sean Christopherson (4):
>   KVM: x86: Add a struct to consolidate host values, e.g. EFER, XCR0,
>     etc...
>   KVM: SVM: Use KVM's snapshot of the host's XCR0 for SEV-ES host state
>   KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
>   KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: x86: Add a struct to consolidate host values, e.g. EFER, XCR0, etc...
      https://github.com/kvm-x86/linux/commit/7974c0643ee3
[2/4] KVM: SVM: Use KVM's snapshot of the host's XCR0 for SEV-ES host state
      https://github.com/kvm-x86/linux/commit/52c47f5897b6
[3/4] KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
      https://github.com/kvm-x86/linux/commit/c043eaaa6be0
[4/4] KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"
      https://github.com/kvm-x86/linux/commit/82897db91215

--
https://github.com/kvm-x86/linux/tree/next

