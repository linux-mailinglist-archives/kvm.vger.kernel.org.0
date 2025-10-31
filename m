Return-Path: <kvm+bounces-61684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3AAC250B6
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 56AA44F2321
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36AD433FE15;
	Fri, 31 Oct 2025 12:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OfEuf2yh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E94126F0A
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761914248; cv=none; b=pcYVj7WpEsOIthAN8lRybTGO2gqXtmmC0kDUaU18fD/QSpSVs9mKhkG6fVbRkj0g6KHTclC7sZch0hO958reZU1ZOTyshHpORhnq4r4pVtbuQAnTeUvwcCEB2LDJwhx+TvRwdcxthszctl0X42w6pJGHoXAeMM84Ggm1NT7tlec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761914248; c=relaxed/simple;
	bh=mteeuF+zSnn8liY/YkxKKEH9DgQ50gUMGhizCxZZ3aY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R5ajtOXIIA4VVncAlk6XI+tA+IVEugiX/Hdt2hlmdL0o/WdSnZmw/pJx6DFJ9vxfKw4YsVkRAyPc5B2p4SHhPekXEMJCHxVwD/R6QDLk5dA5c54bdn5egq3DySkefgz/vX7avLniwrmP9LSnlVhywCGdRHXzHTwDOABDHXpKwRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OfEuf2yh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso21725245e9.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 05:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761914245; x=1762519045; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7/eQCG4xVazxV14+GmKEhZk17sA8vEiffoRg74ze94=;
        b=OfEuf2yh2/yLwrNlXgSC69H3CsFfNeDQVassVZcI4b8HxOiPfdJpcve3cUzGcO9hXB
         7TuGjuYv5HKJ362QwnOpnqlxvcb85vtYuD3fwnLEVT9DS8RQWQHP9jQZ+sD8F2V/lXAL
         7A+4cTe43cADMJlwC96IYtV0/4cbv3mTLSBYxFivEO7mHZqyDR0xk3aSEOd1CPaphJF5
         51WAMT0Z44qN7Ignffz2KOZLzGlG1YXibG3//rCWCRKG0pbzZw5i8vAzLv28Z2rU1qrp
         qYsjh5bW2BXpQAirX7RUehXp1JIErVLM6bjWkuLmdxo+pRYaokczHxynIxxhTzBIOwBS
         eAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761914245; x=1762519045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7/eQCG4xVazxV14+GmKEhZk17sA8vEiffoRg74ze94=;
        b=sXowEc8tIrjMTCLp6DDfvXI6SE/Ji8Lcrp8WwZxeOeTUoqhJOYpKy9NCV0oZNtfl/P
         1n1QIAdt27vmc8sM58QELQn47yrcmt3KeFc4nhpSs3jwuytX3CyGHExjP8Stj+F/wOsL
         eU7HAta+bC+D+Lo1nFEEr/0kPWyqCf/Bzi9R+DENgCs1Y/RJ3xWIGsJBpYiVL/ZcLcHf
         mfg8g7aRWAZbWwQfxobJ6dK5MUvKVcbOH+pJ2VaA2P33cphO8p401OGi0Tw2DFandDWc
         RUM4ScBPNsL32eewujjh6nqJ44L3aQY263wkCFA6gUr+rpBfcBLCgQQbBIqXfucyzUdO
         XBsQ==
X-Gm-Message-State: AOJu0YxqN253WYlFoWnzs6rXc6rP+FC5Nj7ZEtkY12pEvyl+rNE2JyRb
	33b0xsxDHJn/QClazNw767bM8ahk5JxkcKXfO9OvOliGqkXrCZi+/cBaAMr6yJxYL0G4irUB4Nh
	n547OV15l1cj82Q==
X-Google-Smtp-Source: AGHT+IHW6XtQ4aJitnBiRjS9Q5Wsw6QOTBTHmcz+2eW+m+53Yowm66E3UT1Y1mXzQmDFnCmiVVF68crqHO8pQA==
X-Received: from wmga22.prod.google.com ([2002:a05:600c:2d56:b0:477:d9d:9b35])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c4a7:b0:475:de81:563a with SMTP id 5b1f17b1804b1-477308b22a2mr32175495e9.33.1761914245153;
 Fri, 31 Oct 2025 05:37:25 -0700 (PDT)
Date: Fri, 31 Oct 2025 12:37:24 +0000
In-Reply-To: <20251031003040.3491385-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-8-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDWIH1QNJBN8.2FS1RESKCD3Y@google.com>
Subject: Re: [PATCH v4 7/8] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> Disable support for flushing the L1 data cache to mitigate L1TF if CPU
> mitigations are disabled for the entire kernel.  KVM's mitigation of L1TF
> is in no way special enough to justify ignoring CONFIG_CPU_MITIGATIONS=n.
>
> Deliberately use CPU_MITIGATIONS instead of the more precise
> MITIGATION_L1TF, as MITIGATION_L1TF only controls the default behavior,
> i.e. CONFIG_MITIGATION_L1TF=n doesn't completely disable L1TF mitigations
> in the kernel.
>
> Keep the vmentry_l1d_flush module param to avoid breaking existing setups,
> and leverage the .set path to alert the user to the fact that
> vmentry_l1d_flush will be ignored.  Don't bother validating the incoming
> value; if an admin misconfigures vmentry_l1d_flush, the fact that the bad
> configuration won't be detected when running with CONFIG_CPU_MITIGATIONS=n
> is likely the least of their worries.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

(Git says no changed lines)

