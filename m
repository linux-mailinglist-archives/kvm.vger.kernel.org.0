Return-Path: <kvm+bounces-15671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F298AEA74
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47481B2109E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506CE13BC34;
	Tue, 23 Apr 2024 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="J9u1MPcJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B6E13BADD
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713885297; cv=none; b=leRO0YTtdM0Yiy/+QOW+Gfm4N53xupPjLhpv9vrhfqoykWx+/NG4UHjLewUQobn0nfCk3ds9+GK5RMDDsjYN29JmU4+XmqnQ4kCVfNUbVo6sLiL7jVfDdliMjVwXvpGxf+zRYl0MB6Eh2YirHpn8VHAccUoI8yD6snVhnQGusX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713885297; c=relaxed/simple;
	bh=a5cD2LaaptC8wxD989v/1J0kMmeKcCSfjFsf7Y0J2sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhuGQTAwNvxy2FBIvcF5VrknwyIWOW0u0MivEh8PYrnHpPFeRyG3dLlT1JMkAN1VpzjHoZZK+9WRzZLAGE33EmpLLBMlUDjt6P+jwHObeKGzb9pKoTYKONfh8eRVBkvzJOkni1s0fBe99u7MUi87ulpS0z/3cINJgnwZVoqpEV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=J9u1MPcJ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51abd9fcbf6so8034540e87.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 08:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713885294; x=1714490094; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4zF9sVBcXt3p+LHo6Ft4b30wlVpGZC//wb02folK/K8=;
        b=J9u1MPcJPHT4dqSrXs9JbKZQOQPoeKh8fZhf6X/xPGM6EC4GoPa5mPsAVtR0dJ9V8Z
         ndgB/rntHyKyzRtWG9WbHwmcqIisFZlBzJEx8wBNrjgECM8PsqWXxOixqqulZxix6C31
         c5wWtxooo67YWl6eF5zsKPCDRk551DkmwsqfBrX7LL0iHIH0moGcXYt69vehaVbrY2aY
         Sm9P4AvxFFBJFsLnubzucGRLHGwOEF7fwhX17DNqKYrlWdPkjqzQJ+br2cbITA1LWUbz
         FGRdmvjbfTCpHJEI1zWheelIS5Lb+BWqCyjGkBdQ8ukCjacEYsEgZpENTBGTh+CSRiDP
         RChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713885294; x=1714490094;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zF9sVBcXt3p+LHo6Ft4b30wlVpGZC//wb02folK/K8=;
        b=lOhPfPWxsaB60KjHc8WiZXI3nXWGmJCXA4YLR/6FgLbrLdxFEw4TH6tEcObmzjUo/8
         FsPZa4czqTG2d8zIVGxPEvumomWAUCuy9QZHWBXHg/v5p22M0GgzYxlJnwf0gHNxvPfY
         +u0ypg674BnscDX36yJYv/kWyII7AXro4QgjB/6Uio8TV9vS24yeJa4BAoEAPL6fMc8z
         CpfM9dFb1m4Lzlvbez0TaqtD9j8r0GvmtQ5t7RAP7gbBsqZ+S3B1L4b+qpv4MsXzqZnP
         Kmn0uqnq48VJDZHUSkmkAKftEeK7s1+/KM1Wx+9B3DkAxB7bFwFjcTiGoGa40VIay6hU
         xSuw==
X-Forwarded-Encrypted: i=1; AJvYcCVpf8pHLjN/sEow0Iu2+8YN2KgciHpDMFEiQF/4f1YsMy546yVI50lNxyFdKEv92UwD36li2H4g9ZPQpHYSW+eiQHDD
X-Gm-Message-State: AOJu0Yy85Pj8riRsSKcLJ9YzRsZO2W9cnUrqXU7VVbWHyeu3JlLgeJjJ
	GtEHTKCqksEgqYS6JCWsumWpJEts3+tgywuMRPsFcMpi1qF3r9GMLXDrX2qICFY=
X-Google-Smtp-Source: AGHT+IF1/35Nlkwm9xUrkG3SYoD/oQBvgVGLdQGrEiz/Yiw++BMQpMgPiC/tA6FalJ2ScXPHHIEd6A==
X-Received: by 2002:a05:6512:483:b0:518:e7ed:3c7c with SMTP id v3-20020a056512048300b00518e7ed3c7cmr10661458lfq.14.1713885293863;
        Tue, 23 Apr 2024 08:14:53 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id g10-20020a1709067c4a00b00a4e5866448bsm7115652ejp.155.2024.04.23.08.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 08:14:53 -0700 (PDT)
Date: Tue, 23 Apr 2024 17:14:52 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, 
	Kunwu Chan <chentao@kylinos.cn>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@collabora.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Kunwu Chan <kunwu.chan@hotmail.com>, 
	Anup Patel <anup@brainfault.org>, Thomas Huth <thuth@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: selftests: Add 'malloc' failure check in
 test_vmx_nested_state
Message-ID: <20240423-0db9024011213dcffe815c5c@orel>
References: <20240423073952.2001989-1-chentao@kylinos.cn>
 <878bf83c-cd5b-48d0-8b4e-77223f1806dc@web.de>
 <ZifMAWn32tZBQHs0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZifMAWn32tZBQHs0@google.com>

On Tue, Apr 23, 2024 at 07:56:01AM -0700, Sean Christopherson wrote:
> +others
> 
> On Tue, Apr 23, 2024, Markus Elfring wrote:
> > …
> > > This patch will add the malloc failure checking
> > …
> > 
> > * Please use a corresponding imperative wording for the change description.
> > 
> > * Would you like to add the tag “Fixes” accordingly?
> 
> Nah, don't bother with Fixes.  OOM will cause the test to fail regardless, the
> fact that it gets an assert instead a NULL pointer deref is nice to have, but by
> no means does it fix a bug.
> 
> > > +++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> > > @@ -91,6 +91,7 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
> > >  	const int state_sz = sizeof(struct kvm_nested_state) + getpagesize();
> > >  	struct kvm_nested_state *state =
> > >  		(struct kvm_nested_state *)malloc(state_sz);
> > > +	TEST_ASSERT(state, "-ENOMEM when allocating kvm state");
> > …
> > 
> > Can “errno” be relevant for the error message construction?
> 
> Probably not, but there's also no reason to assume ENOMEM.  TEST_ASSERT() spits
> out the actual errno, and we can just say something like "malloc() failed for
> blah blah blah".  
> 
> But rather than keeping playing whack-a-mole, what if we add macros to perform
> allocations and assert on the result?  I have zero interest in chasing down all
> of the "unsafe" allocations, and odds are very good that we'll collectively fail
> to enforce checking on new code.
> 
> E.g. something like (obviously won't compile, just for demonstration purposes)
> 
> #define kvm_malloc(x)
> ({
> 	void *__ret;
> 
> 	__ret  = malloc(x);
> 	TEST_ASSERT(__ret, "Failed malloc(" #x ")\n");
> 	__ret;
> })
> 
> #define kvm_calloc(x, y)
> ({
> 	void *__ret;
> 
> 	__ret  = calloc(x, y);
> 	TEST_ASSERT(__ret, "Failed calloc(" #x ", " #y ")\n");
> 	__ret;
> })

Sounds good to me, but I'd call them test_malloc, test_calloc, etc. and
put them in include/test_util.h

Thanks,
drew

