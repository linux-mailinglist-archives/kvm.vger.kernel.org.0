Return-Path: <kvm+bounces-15098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF958A9BF7
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B64A72823B9
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D2C165FD1;
	Thu, 18 Apr 2024 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JKFr0e5d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C51635BC
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448740; cv=none; b=r5WiBcHAdvP8wujvbl6/kOHArf3RMVvdoDEu17rj1udIePmaDW3RVhVbkkE8frhpGIKxyUvag8FFak9QJXHk5Pg5I+Tz2BZZ5PZBT83x75z5ra4eYGhS1z/x4cLTgGZvF5b26xfLweXEV7+NWjkEwloil8IQZn+tj4468+1+mHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448740; c=relaxed/simple;
	bh=jfJM8dSb6kGhQc66FRxX40igRNLtbqPBPjraUYrcYeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VkxNk+Vpy9Z93XN+4Wk1JJ2URL0553HlUoJYmothqAytD09eNuZTm6zSEPkOZ/j7+oBKOpG3T69UDqjRsq46GQrt3T7KKqv8mqKZLmQuVXfokol7NG8S9eiwjtpzgxKVyybvouQUEdfTKCBhmXcDvaWai5ECSqyT1J0mZ+DtX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JKFr0e5d; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce67a3f275so876559a12.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 06:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713448739; x=1714053539; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yNDmhaFib5vUgSCj1EuHEP0N8f9l8mHKtBljI9aZIys=;
        b=JKFr0e5d8H4A5jufLLQ28H0ENJ/8+aeFjRpZau5tDyynDdenWvHHYuyz3X6fNchT7y
         ncuGLkybbx03H20nUu4s/gwr1as/f/60P0yr95NFSMrOyjVY9F4xwxMqVof3BmQYA2dD
         usEBi3hVPCWpwA5bvGnygRJwgbXJROV4s5+1dSslV/uvMKJavcmK34P9Fjcu8GmA+tQs
         63stFCCwYfoVrtLhWlNJIYRBTMng5BM3scp+4SlYLpySUUdzTWzGWjdDADoO8MZU7Puw
         6V1Ci9AyoIfLcGSbF3G0Q3xI6TvEV+V/teXfou4QkCzuk1kBk2rQztC9zHmyLhY3Ytk7
         Vbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713448739; x=1714053539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNDmhaFib5vUgSCj1EuHEP0N8f9l8mHKtBljI9aZIys=;
        b=PP7IapSHrVR2/fJVSbrpS+S/W3J7fRms2Z/t3PgH73NkXxLr6v0a5efr+pkhTCbkiT
         zf2kJIBIC7CIfhqHEehHwz4gsc6/brJYw1wEfMUgvDJB+clbkgP0ew5+jD7iy9JeUEU5
         1pLYw7P0gIA4rSPq2+VcflhbLB9ABavUiDg9tWdQ40P8JZlp1zR/WxsZI8gXpRovnM9d
         YkLeX/0/7RGOK/gOuag1Jp6Lmf1WfXFfg172PlqKUzOO7g8/UujnE0SxpZWA3ju+0zOY
         IR2m3q3CB9HppGrtxg9zyZ7rzNflJ9oqOTOpMZ18BgDakC21ZD+2tlpxlnYE05Dkuewd
         Y/eA==
X-Forwarded-Encrypted: i=1; AJvYcCUya4mpry7MTM3TKTaig1sNR1B0rppnuB7Qi/302rBqSH6mKhwl9bbdNlwKle/+EOrACEOoJG17ysMpORY9OTbIKPBF
X-Gm-Message-State: AOJu0Yy3QERRzc57LBDY52zkp4ma+7bwc9EQg4mCzYaKAWg3UgDXqEZ7
	Tk3fGnCWFv7WEA7Z2EE/OfRGbuMj/+Pe9Ewgj74FaD6TKsOG1X+COJ42h1hzDUv1s/19hMvIA5c
	xFw==
X-Google-Smtp-Source: AGHT+IF/NVV828WbXcekdzll/VFb0eXEt6pK7hsJ3IAg6SEtS8UxqRGfLTiacsRBhENxV1bZpBNSUKpoYJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4854:0:b0:5d5:1e4d:c845 with SMTP id
 x20-20020a634854000000b005d51e4dc845mr24856pgk.10.1713448738618; Thu, 18 Apr
 2024 06:58:58 -0700 (PDT)
Date: Thu, 18 Apr 2024 06:58:56 -0700
In-Reply-To: <DS0PR11MB63739BE4347EC6369ED22EBADC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417150354.275353-1-wei.w.wang@intel.com> <Zh_4QN7eFxyu9hgA@google.com>
 <DS0PR11MB63739BE4347EC6369ED22EBADC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZiEnIFW3ZQhDwdZ-@google.com>
Subject: Re: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS
 static calls
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Wei W Wang wrote:
> On Thursday, April 18, 2024 12:27 AM, Sean Christopherson wrote:
> > On Wed, Apr 17, 2024, Wei Wang wrote:
> > > Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to
> > > streamline the usage of KVM_X86_OPS static calls. The current
> > > implementation of these calls is verbose and can lead to alignment
> > > challenges due to the two pairs of parentheses. This makes the code
> > > susceptible to exceeding the "80 columns per single line of code"
> > > limit as defined in the coding-style document. The two macros are
> > > added to improve code readability and maintainability, while adhering to
> > the coding style guidelines.
> > 
> > Heh, I've considered something similar on multiple occasionsi.  Not because
> > the verbosity bothers me, but because I often search for exact "word" matches
> > when looking for function usage and the kvm_x86_ prefix trips me up.
> 
> Yeah, that's another compelling reason for the improvement.
> 
> > IIRC, static_call_cond() is essentially dead code, i.e. it's the exact same as
> > static_call().  I believe there's details buried in a proposed series to remove
> > it[*].  And to not lead things astray, I verified that invoking a NULL kvm_x86_op
> > with static_call() does no harm (well, doesn't explode at least).
> > 
> > So if we add wrapper macros, I would be in favor in removing all
> > static_call_cond() as a prep patch so that we can have a single macro.
> 
> Sounds good. Maybe KVM_X86_OP_OPTIONAL could now also be removed? 

No, KVM_X86_OP_OPTIONAL() is what allow KVM to WARN if a mandatory hook isn't
defined.  Without the OPTIONAL and OPTIONAL_RET variants, KVM would need to assume
every hook is optional, and thus couldn't WARN.

  static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
  {
	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));

#define __KVM_X86_OP(func) \
	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
#define KVM_X86_OP(func) \
	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
#define KVM_X86_OP_OPTIONAL_RET0(func) \
	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
					   (void *)__static_call_return0);
#include <asm/kvm-x86-ops.h>
#undef __KVM_X86_OP

	kvm_pmu_ops_update(ops->pmu_ops);
  }

> > kvm_ops_update() already WARNs if a mandatory hook isn't defined, so doing
> > more checks at runtime wouldn't provide any value.
> 
> > 
> > As for the name, what about KVM_X86_CALL() instead of KVM_X86_SC()?  Two
> > extra characters, but should make it much more obvious what's going on for
> > readers that aren't familiar with the infrastructure.
> 
> I thought the macro definition is quite intuitive and those encountering it for the
> first time could get familiar with it easily from the definition.
> Similarly, KVM_X86_CALL() is fine to me, despite the fact that it doesn't explicitly
> denote "static" calls.

Repeat readers/developers will get used to KVM_X86_SC(), but for someone that has
never read KVM code before, KVM_X86_SC() is unintuitive, e.g. basically requires
looking at the implementation, especially if the reader isn't familiar with the
kernel's static call framework.

In other words, there needs to be "CALL" somewhere in the name to convey the basic
gist of the code.  And IMO, the "static" part is a low level detail that isn't
necessary to understand the core functionality of the code, so omitting it to
shorten line lengths is a worthwhile tradeoff.

