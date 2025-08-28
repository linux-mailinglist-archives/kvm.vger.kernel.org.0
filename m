Return-Path: <kvm+bounces-56200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B18B3AE64
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE8633A6691
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EED271450;
	Thu, 28 Aug 2025 23:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a3pu7n+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8F42D0C72
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 23:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423203; cv=none; b=Jv1f+walIpFu1DIVJjnlHOCair8Ki7TR5el2+l8mlaxJPlNjuHu14Po5cpcTbY3L/5+DpHzlKVrLIApToRWhhA6Jab/ei+X4Dd93Q169wpp0uBx3IReSUjN9z8i1a16aCCx6efx5WCrzgEmrjh6nUqd5Ox9+knSY6FzWv3n1AHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423203; c=relaxed/simple;
	bh=Cxft7seCAmBWcypMb9m35OtziQzTUNY9jLYI/4QvXx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a17gyFXqxQCSPlHal60FW23bDu4MThLe9Nq0y0X5KxOrAV1ICf5Bo6Ujo7lR2kbmXg9rKwgnP85SZpXuaqjQL2Q2A8MXgamKGgyfMn1eUGubR6ebVdpm2mpsN86jiA8Qo+mVI+1QQ9sMCozPXhQlac3xUnt7gIxX5QcDFxhWfQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a3pu7n+P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-772299b3405so652630b3a.2
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 16:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756423201; x=1757028001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SCPDFqvUJHSIb9MrvnTYEaS1lyeHhMoigX0tHvZ1jNA=;
        b=a3pu7n+Prz5PLlnaxRCI9fxz5M6WuReZdGPKIUp39bHbXRK42PM9cv2TBr7/e+mWZH
         5UgwkZxTox19QrieMUcxAaqlx3H8a9SEvHY+jCDoQUa6asy3+HjdLM6fClBas2KLf/v2
         IyTkwNi1+Gr7Z6j6otAS7UgCyemuS3f7vWD8nS/AwYq1VXNx2xd6r648FuKYtXGPEpc1
         dDnmwii0mp9FbiRFEtl8j/zJtmZQSPdVSTWV+wDht6kZsCcqB97tbR9xLUvnAuXSHGIT
         baCbKvMbS7eg7ni5iFAhJw9iqa03k4vWQ8wa7O0DgR/k8r30DqBZ/b059T7kpNhlnqSM
         /+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756423201; x=1757028001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SCPDFqvUJHSIb9MrvnTYEaS1lyeHhMoigX0tHvZ1jNA=;
        b=HBBbH2xh4TOZuGZ74+51qk8zsjaJQBj3hphDZQxVxJxPn5HqcH+6D/LE43GipMR49J
         YrcnNzZ2C8GrsdfRj3HJXX6aPTLhLSKfgO8SwGzWMVIotNcAxsjFrtAayr5oOfhwTZ70
         Ggt+hjSBfXGGHGTM6+cqNPAzIvOFRiiCb4iqqp8BuGQKI8C8v0ZcPOJILM60+5oZN1cu
         l8Gy+TeozNBdzUb2d8Hf651LkJF3GKQZkPWcmiY4890mSnBPsP8ePv7MBhtNNAw/klQD
         JKgMagc9yefOc4ct/m7OZqICLcVSri/CFEcqI0WI7c/Z8MWG0bCpuj9zHjmyiyV0FTGl
         77AA==
X-Forwarded-Encrypted: i=1; AJvYcCXMQHhg99ktCk1UMp0Zjmf7pTJDujP2xWBciVv+6zNyDbTrqesxSodCUcyUHtsBGZa2qto=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXElYHopOH3SkCLrDsYkzXnutNL8bFK2B1o7vW3MvGdn+s8AYv
	GA0FpMSRg6whNIdSHvKii/CjAD7csAoY8V0WaRy5zhYA50ysNQ+FvuIbSR/uG20um/7VsxOvCuH
	a4zCAPw==
X-Google-Smtp-Source: AGHT+IFuvDqf/SDO8zb/Rg2sLEuAECUMgCjHNKn3M6DuiXByxYBIDEUMOWmtYL95p8pUeWwPYzmCaAAW9xw=
X-Received: from pfbdn11.prod.google.com ([2002:a05:6a00:498b:b0:772:14a5:87cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1810:b0:772:2869:14d3
 with SMTP id d2e1a72fcca58-77228691e77mr1743965b3a.20.1756423201269; Thu, 28
 Aug 2025 16:20:01 -0700 (PDT)
Date: Thu, 28 Aug 2025 23:19:59 +0000
In-Reply-To: <567d67970b610fe1e9d09dbfaa935e05093495e0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <567d67970b610fe1e9d09dbfaa935e05093495e0.camel@intel.com>
Message-ID: <aLDkHy-2VkjV2WeX@google.com>
Subject: Re: [RFC PATCH 00/12] KVM: x86/mmu: TDX post-populate cleanups
From: Sean Christopherson <seanjc@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Annapurve, Vishal" <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Edgecombe, Rick P wrote:
> On Tue, 2025-08-26 at 17:05 -0700, Sean Christopherson wrote:
> > RFC as this is compile tested only (mostly due to lack of access to a TDX
> > capable system, but also due to lack of cycles).
> 
> Let us know how we could best help with this. The series fails the tests because
> of the page size issue Yan pointed. We could just review and test a v2, or if
> you want us to pull together the feedback, test the result, and repost please
> let us know. I think either should work from our end.

I'll post a v2, it's going to look quite different.

> I suspect Vishal could hook you up with a TDX machine. But if you need any setup
> help there too, please shout.

Oh, he can, I just haven't crossed that testing bridge yet (ditto for SNP).  I'll
do so someday, but for now I'll abuse your generosity and throw noodles at ya :-)

