Return-Path: <kvm+bounces-68236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5375CD27BC5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F2D313109716
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD363BF31F;
	Thu, 15 Jan 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CeGvk4SY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66447E110
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501975; cv=none; b=DPOTl6JeDEd2LvTREhI4OWqsQx+RGlepaWPSWqGAeU0Sgr6QKMAacJ/wVdM/eZVMvlaETE0OK8ZyckbhnjN/5qwembR1+XkRE1eWC/qur19A0+ro9TCIyjaMLDPe7rO/rXUV9gnfyTlbJXoRiBTF7tHU8DMslZz5W7YGHjb8S70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501975; c=relaxed/simple;
	bh=2qiT4NTfKuvt2CiYWD2Ursk50u7Fg/gymNd+dkb19Jc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nlRMhIuYcVOlMz/h08VMkarcmm4NQnEUKSUXY5sin9ipHniW9yLtWRTK+y2w+CXCsGmlypL1N5RQDcPEmtzfHpd9E50geH19H14QzMv9Ldt574nWfGznEpl6ow9J/3PPBDb+e4gtHig2rey770LSCdYAy4qq8gqGp1R40ylrj2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CeGvk4SY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81f39ad0d82so2251109b3a.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768501973; x=1769106773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a51NdOQWnTZkpc4GjZkcCsc1lHmOzYUl/RjSNCWByuE=;
        b=CeGvk4SYLeGZms1ck0DhyPTnC3susu7VLDVM6dtjnGRpwbmu086avFlTygyekGqq9S
         7B9v32JUCa5CqNSMFRjku45NuzQYDD+wrdMLV3q8Y7rXxBixgyHOMd0dGqMjypzpMF2G
         hhpesDqg2XWNKYLrYIC8xZdsFvzqK2IRMNZefY4Clr35t27K4vS9vZtw641m8uKmgCfT
         1uEzrn/n2ltgP9GUukpFzOjggXsCwdAmD3vM6RNORcRbngdbZ0so6i04bNC6RY1eMIvq
         LdhZoWaKFQnWHtGKIAw0cahX0/H2iDB//4YGDI7zXfteBB8Rei+5HeWbLoJQZg/Qb0/f
         mQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501973; x=1769106773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a51NdOQWnTZkpc4GjZkcCsc1lHmOzYUl/RjSNCWByuE=;
        b=Pzyx8ZRWTZyDeZx8xxve2FIRfT9BaeFNsVD/Y8vuxUh11xHEAY1iXZEAbzdJ513+n+
         yR8nwnUDGYGcGClq+kWQYWJe+Vgx6WYkFpFicIP584ChKlRRLS9CVUqcxD6KjpYNJZ4T
         L/5ZC/OP8dOFzikUyIQ+6G1XSBV8Iv9neUPfGxe8H8fbFpPEOtFB6Ev51bAfAzepbItR
         Y5R53Alco9ybywKuMZhp8xgAHOWgw7S+B3Ymk6/dlS7xDY+eWNk59Pobx6fhxEeWURj1
         A150IhDaBOTmdJu+xOhOmPK6ovWiBDvVA9wcxM4QwUH0Il8tzRPihJBQybadud7H2KSb
         7m+Q==
X-Gm-Message-State: AOJu0YzbfinIrPb9Wsmx62sNxj3lvwHHcngq15AKBOUe/3WqpiCDncUD
	fAAxsacAS5Bxh40ozEsIhNQbHxCHqBN2yhqxCbGEYOe1AWpgE8xFtWYBQJ/LFNjrRriKzaAHTU6
	577nsXA==
X-Received: from pfbfo21.prod.google.com ([2002:a05:6a00:6015:b0:7b9:2c62:5fab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1bcb:b0:81e:e5e9:9aa7
 with SMTP id d2e1a72fcca58-81fa0399342mr405528b3a.52.1768501972944; Thu, 15
 Jan 2026 10:32:52 -0800 (PST)
Date: Thu, 15 Jan 2026 10:32:51 -0800
In-Reply-To: <20260115164342.27736-1-alejandro.garciavallejo@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com> <20260115164342.27736-1-alejandro.garciavallejo@amd.com>
Message-ID: <aWky0xn4sG2dNryK@google.com>
Subject: Re: [kvm-unit-tests] x86: Add #PF test case for the SVM DecodeAssists feature
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="us-ascii"

+Kevin and Yosry, who are working on similar tests

On Thu, Jan 15, 2026, Alejandro Vallejo wrote:
> Tests an intercepted #PF accesing the last (unmapped) qword of the
> virtual address space. The assist ought provides a prefetched
> code stream starting at the offending instruction.
> 
> This is little more than a smoke test. There's more cases not covered.
> Namely, CR/DR MOVs, INTn, INVLPG, nested PFs, and fault-on-fetch.
> 
> Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
> ---
> I'm not a big fan of using a literal -8ULL as "unbacked va", but I'm not
> sure how to instruct the harness to give me a hole.

Allocate a page, then use install_pte() or install_page_prot() to create a mapping
that will #PF.

> Likewise, some cases remain
> untested, with the interesting one (fault-on-fetch) requiring some cumbersome
> setup (put the codestream in the 14 bytes leading to a non-present NPT page.

Not _that_ cumbersome though.  Allocate a page, install_page_prot() with NX,
copy/write an instruction to the page, jump/call into the page.

run_in_user_ex() makes it even easier to do that at CPL3.

All the above said, I would rather piggyback the access test and not reinvent the
wheel.  E.g. wrap ac_test_run() a la vmx_pf_exception_test(), then intercept #PF
to verify the instruction information is filled as expected.  We'd need to modify
ac_test_do_access() to record what instruction it expected to fault, but that
shouldn't be _too_ hard, and it might even force us to improve the inscrutable
asm blob.

