Return-Path: <kvm+bounces-26714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23B0976B26
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BC802828D7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E871AD256;
	Thu, 12 Sep 2024 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZSQTMkzs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3281A01CC
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148984; cv=none; b=t3FdglmkL/hHMIYgorCJFD88b06c18TTnrgXM/Y3MhDcG/BLY9LgXFyHjLTeXWBzOQcgFsPc7jJN7NOfNnFmsiPhPB0GvK4mblne3OVsGx9Rz+7qh4y2+ucoXKl2ImwVhDIc9rcgNT3f4RdYMpwVp2wG4dbHgwx9pnEEUaTKV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148984; c=relaxed/simple;
	bh=TK63ZITwXiK1tpwBleYE7XvV84aecTotysnL7Q6Y+UI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ho7ijDtjXvR9VvrEVLsW/DLDn7HbcD/PHYLt7gDjnFzXG3QbsLlhem4cZkW65W+mxcrFcdB25NKwKZSg1y6RXcdl/pp2Bxw3kzoDEgdUEXJ00hHbX3sNHFgPUAUWR5uMk9uGeTSwz1NE5y7Hwyz3Ya1mNCSSAYVWm+wDyB+kVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZSQTMkzs; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4426ad833so24826757b3.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 06:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726148982; x=1726753782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XqdrXm4ZcBhMxArHEVqbh0H8bhyUvIJvDn8m8Oi5KOY=;
        b=ZSQTMkzsggCnz2qFqYYMTitCnmimFkrgh7IALeNoHySb+qFm8MajpuoJfjvVintMvd
         4aP0JepGxGkysCYFjF0Ly2vbHk6zfYK6M0QsGYzT0wF1VP7FE4uA/V8Ama4Z50WVDEQD
         fsc/o03ZR0imD3MIV8HkreYe9/AZNrbDVPY+aPg/8cpNNJVAYT5+fIQnKp5FGcOr01nH
         Hb5bq88ca8BDNwIWvtXYwyZRMj3/K1YSTx5fa/mSY0hcajgfgKQ/RyVdVqHYoVwOugyd
         RcqiqE8jaR3gxgmRwzdYJFYXiSernO3LG8PKQ3KDGCOFfKMZj+epi8dXQtlJqKTKAIm4
         CiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726148982; x=1726753782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqdrXm4ZcBhMxArHEVqbh0H8bhyUvIJvDn8m8Oi5KOY=;
        b=l8BIDhkWBFchoSuG1+PKNUl9SSGkgtK/xp1j0LWIXUtpFSC2DiP2UQROTBAmvukt3p
         k8yXBpP1/mIVDriN+2wE3dv/It8bgRDkVDofh+s4A9+5pMxQr0kE4OdQujpVGle/gs7K
         prJHr3/k5xlKQPQdu8Q5RMuuK1YGlxejDvc428dfNBH3tMtu6oHSlCus2upWKhrW5Qaq
         VsqjaSFVXXZh2aedup7VzaxegL0PY0vRogTOI9fW83ypZiO0A53TCaJiwWjB+n6E9O51
         S/88mtQ/oIjlfQ9PcfQ3P4XMpVXzxl4KKhO3Sy42rpYBaU+KhKygwYfAEFWQmwxa0gCR
         Miqw==
X-Forwarded-Encrypted: i=1; AJvYcCXBavOWLJTeA1XCLMBbjbZmv9QmvsrsBz4bBaUnZsP6MJqOjZ3xgUFsMnTor6kzQi/n83U=@vger.kernel.org
X-Gm-Message-State: AOJu0YymVKg69mdIxWgw/YHHUWFMjE3Ltr/Pqd4fsJnsa0a0WWXojG1t
	KPE0Dgm3SdmmZTFW3RxbvgxlWjFX7wJw9E7SgRE36wt0hyxRUQ2Kzkh+DLuvTuMOuMq1XVAheB3
	05Q==
X-Google-Smtp-Source: AGHT+IERWDyZH0lw1THIMdF1ZNEMNfNEpIHjvdgU0tin44x4h90whZRVuXvE3+8fuo4JVbUfWmxTfJ+4tEs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:50c:b0:e1d:a616:602 with SMTP id
 3f1490d57ef6-e1da6160834mr2247276.7.1726148982380; Thu, 12 Sep 2024 06:49:42
 -0700 (PDT)
Date: Thu, 12 Sep 2024 06:49:40 -0700
In-Reply-To: <20240912-a3894135370bf3fe551ed018@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-3-seanjc@google.com>
 <20240912-a3894135370bf3fe551ed018@orel>
Message-ID: <ZuLxIjMT4QzrUaad@google.com>
Subject: Re: [PATCH v2 02/13] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 12, 2024, Andrew Jones wrote:
> On Wed, Sep 11, 2024 at 01:41:47PM GMT, Sean Christopherson wrote:
> > Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> > a pointer to storage, as none of the KVM_GET_ONE_REG usage in KVM selftests
> 
> "none of the vcpu_get_reg() usage"
> 
> (There is KVM_GET_ONE_REG usage accessing larger registers, but those are
>  done through __vcpu_get_reg(). See get-reg-list.c)

Doh, right, which was also part of my reasoning for making the conversion (tests
can use __vcpu_get_reg() if they need to get a larger register).

