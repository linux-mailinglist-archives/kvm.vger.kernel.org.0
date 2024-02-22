Return-Path: <kvm+bounces-9445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B108605D1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 23:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E062D1F24E32
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 22:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF5417C79;
	Thu, 22 Feb 2024 22:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SaeMbPpo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3318032
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708641735; cv=none; b=Rg3wfoZG/WeqD5BNMwAFQ+jGbbKwvdVg0PrbUAp2DjLc+fl8shy+F4qaqmtyZw7xZ0x1rRsTT/i3rYGdVtyZaTurDYjbKXpYmfyvXdl/GQVJfLSQXLJ57xnOMrD2lmu/tuvOVyIc7q1AeLAcTah5BzTRcUFzb99OoMwhRe085wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708641735; c=relaxed/simple;
	bh=imYlGZaDB2n5vfS4ZwIvsXZiZqAKg8o6WkaCZH5L1Qw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=uzRIpRfZumTpDrm0lh1KsOx4t6XGCFO1LwdIKYH7SoYzvqKSYwDYTF3ya5mFgu1AvbS0+F2ttx9t5bQSpGoyXZnKVJtHqmy8tu83YSVPs9Af0JqAiPv63rdGWlPSMfh5/2unofqA4CuBuhe2rftEoEFFA4wcBxKN5bahRPH0sDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SaeMbPpo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6082ad43ca1so4202497b3.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 14:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708641732; x=1709246532; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFvVQg9UZb065hqoLsESeNre8JaYtsdQOcTRgkYVRKY=;
        b=SaeMbPpo6eyjEje/9O8LxIFYQSMovoXOTvHSYbqCZYIXEWQpXdVepqWghUELLvtJkv
         rOcWCIK5p3WDzrOpjyDUwwxDQ1Ev4focvCZuj4bHvt/UEgfRtqPv8MggySN14DAMP4dd
         Xef8Hr4fcHiTbNM0UGVJ+jL242JBb4wtiPSeSNVBMM1t4Qzx6yIUPv0sWI0xfyemO8uW
         rxFRL6TBZLuUrUIe8nNZ8YbCojNYFZ7qMK7jcqidZgAg2+Yt03LaGUbvQCZd/C4+cofn
         Qnco20h/iNlTEWKkozSJOeICkkt+izMJEwcQYwQZjIMBIiM3eftXdDeHw9pbtUIFBu9x
         ExWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708641732; x=1709246532;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFvVQg9UZb065hqoLsESeNre8JaYtsdQOcTRgkYVRKY=;
        b=i0litRmNJXQCaBWnIWnZOh5DO08WAQqm5E5cGOsENanT78WPMbR8ozoP0az5GoPG6A
         dHbFQuIh+90fgJRReOWeHcn8O/KZFCkZpZSWrLKcZVJaVDgMiXyss8DOaLSqn1DeMCRE
         KsGF9EpvFnpcqcwZQ10Hk2lIt+yOboMj4VT1aJlguj3zxzziUeTvJBtjRPqqEULEqPtW
         Dd4vpmAXilBQJvPmR+lv6ffM9o5aV2fworl2/mHPylWAzk4Jd2oeEQbXVDqjZ8YWZfBq
         UYQ969ychGIxoJ3ZjfgSVZB/y9AlKPnR7j1DpyDso4T35oYI8oaNisij4q64F9YztuxU
         5kXg==
X-Forwarded-Encrypted: i=1; AJvYcCVXTUOwOeJk2/knYU54z9JyaTZ+HMuo/oFLzO9X7e0AZHyu0RzBgi/c72QUTp1aUOUX7j2opXc6+pbtjz26fOuxL1Jh
X-Gm-Message-State: AOJu0YxvDhCnAmw5jXOjrKSRKp4yzrBgdBaoxrbUaF5FnH/IiY4AA+cz
	k65cMi9Xw4iIkAhVFSrKU3j7wlGbjr0+9WXqy4EgxTione6ZSyvbkzrU9D9dDGjZJFfKjC0LqFU
	5iA==
X-Google-Smtp-Source: AGHT+IEn84VsOMK3xly4fJg9p4ZGQL4jC+l+k5U6BnNNTDUyy7r/Gzq9iPM6OigIQq722pMhxaceeSC3g0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9242:0:b0:608:20df:8b0a with SMTP id
 j63-20020a819242000000b0060820df8b0amr102171ywg.6.1708641732562; Thu, 22 Feb
 2024 14:42:12 -0800 (PST)
Date: Thu, 22 Feb 2024 14:42:10 -0800
In-Reply-To: <ZcKYRsNUAngWGy2a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com> <20240203000917.376631-11-seanjc@google.com>
 <ZcKYRsNUAngWGy2a@google.com>
Message-ID: <ZdfNwhe2s0Mn2gB4@google.com>
Subject: Re: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Sean Christopherson wrote:
> On Fri, Feb 02, 2024, Sean Christopherson wrote:
> > +int main(int argc, char *argv[])
> > +{
> > +	TEST_REQUIRE(is_kvm_sev_supported());
> 
> This also needs
> 
> 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
> 
> to handle the case where the platform supports SEV, i.e. /dev/sev exists, but
> KVM doesn't support SEV, e.g. if TDP is disabled, if SEV was explicitly disabled
> via module param, etc.

Thinking more about this, I think we should simply delete is_kvm_sev_supported().
(a) it obviously doesn't query _KVM_ support, and (b) if KVM says SEV is supported,
then it darn well actually be supported.

