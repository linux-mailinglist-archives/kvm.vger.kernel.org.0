Return-Path: <kvm+bounces-7505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CB0842F04
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 22:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 604561F25D63
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 21:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24DF78B78;
	Tue, 30 Jan 2024 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M9B0LnlW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D7762DD
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706651395; cv=none; b=R04IrGSQPzfD+Tr9PePG2q2q8C27+Q+HXv+QwijBwoSp/NN9Yvg8tsj0T7PUTawDCpMXVkHVR0cYN28AIT/oo0bLOu87/yLXm4PcunLTpDcyIo1HDm84CuBojRkPpU5GaBfJuRVmgms2b69j0M0dUcVflgSxWIpdMXKNwR4Jvcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706651395; c=relaxed/simple;
	bh=rzCvy6q4MAPeRM6DTO+v4XZw8YVJG6KsvRtGvI6JNbI=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DzA//UtQEZWL8ylV2yUaW3SR/5eYk9sPlTxTSYPC66GBD5mEC2SxyaXTJyPgJ+4knQfcE0i4vTfwRwz7WnIRkmfPpwrzXbxjGbHvNxmCMMU3mjHodh9Tt2ICGb61kjHLpVueImWNbD9tbuV+krC6FR/r9Pd688Y6gZREfcNDcsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M9B0LnlW; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6dfc22e98ccso148825b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 13:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706651393; x=1707256193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lw84EX2PlOWpOjZV7N1lo37lxb7BMZhxthSdSYaU+U8=;
        b=M9B0LnlWN7o/BcYtSzXDwlNVEtip7JqlNUmReZscwa/5g1RSyQ3yEsnijQamPOvD8k
         fDGQkueH5343MyaSRo98dC0moejBUgHylzWAdOvePzn46odn1xDjlr5OdB1Ua7pj3zOa
         p3N+2kHoWRRxHAp63W+fP1Dqqr5WkAe3FzkgvaNEQzc/DvGjGVT9xxnpQhb33kEeLlXX
         vjUf4BJsowhEP7NB3G9vz2iwu33HxpS9pA9ySfxfM//q1aDisoEsiNa8uMu0mJwmQIUC
         RhPGS8EaVG2Vc4kCBb6oxiAcYbBx54RshfDpl9emx04ySQ1DbsMMxXer61+/m7FNOg8X
         id8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706651393; x=1707256193;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lw84EX2PlOWpOjZV7N1lo37lxb7BMZhxthSdSYaU+U8=;
        b=DnAgWK1cHiO/aJ25nbceVgPEtRDb3kehgr+W/W0oo38zdO+CfeIhqx2thepKa1yKqP
         bGEHBFp8LLlwk0T6NgROeDXvSfikSGYhuqQE367ld/p1xYuizBQsXhFG7rMBBFws7jcw
         5GIW3vNSim4GfVeos8bFVPXw1KQgIpeQr6gWzJknyWIKl7pfE2UT6o3hmdYaB8K13sGf
         7/iPM13tv98RqF6rfta9KRg+hFMbWGvFGLmnA4oeFsnYJUP0kXP25snbQKCrAQ02msbS
         fWoY2oRjdGjsG9hrY2YOaAvfftB8+oBi+8kDL6glKB8bVkIY39YT1t09H/glSlardzNf
         J8Lw==
X-Gm-Message-State: AOJu0Yx1h0Ny9cy4sVAYOlMrGw+mGFZCG5KATnban2oGt+aQ+d62TMJ0
	hSxreicn0zMJH3ToF7jQMbFBTOie+rPYIsBd0ooalYiCqbxSOHusMi1AkE7Y61rxHNKMh1zfxom
	el6pQR46xUkHte2HfeWK9ZA==
X-Google-Smtp-Source: AGHT+IGq0m5k0bCDYiTVoVJeRL0cjrOQZIHc+ghwsNeE9y9od8UVzQwCHuC4h678mIHOKf17ugpanskAK85eEQOtQw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a05:6a00:9387:b0:6da:bf5b:bd4e with
 SMTP id ka7-20020a056a00938700b006dabf5bbd4emr124901pfb.3.1706651392893; Tue,
 30 Jan 2024 13:49:52 -0800 (PST)
Date: Tue, 30 Jan 2024 21:49:50 +0000
In-Reply-To: <ZblPfEi_t3BsRdN_@google.com> (message from Sean Christopherson
 on Tue, 30 Jan 2024 11:35:24 -0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfryecwzl.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH V7 6/8] KVM: selftests: add library for
 creating/interacting with SEV guests
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pgonda@google.com, kvm@vger.kernel.org, pbonzini@redhat.com, 
	vannapurve@google.com, andrew.jones@linux.dev, thomas.lendacky@amd.com, 
	michael.roth@amd.com, afranji@google.com, erdemaktas@google.com, 
	sagis@google.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> +TDX folks
>
> On Mon, Dec 18, 2023, Peter Gonda wrote:
>> Add interfaces to allow tests to create SEV guests. The additional
>> requirements for SEV guests PTs and other state is encapsulated by the
>> new vm_sev_create_with_one_vcpu() function. This can future be
>> generalized for more vCPUs but the first set of SEV selftests in this
>> series only uses a single vCPU.
>> 
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Vishal Annapurve <vannapurve@google.com>
>> Cc: Ackerly Tng <ackerleytng@google.com>
>> cc: Andrew Jones <andrew.jones@linux.dev>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Michael Roth <michael.roth@amd.com>
>> Originally-by: Michael Roth <michael.roth@amd.com>
>> Co-developed-by: Ackerly Tng <ackerleytng@google.com>
>
> Needs Ackerly's SoB.
>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

> <snip>

