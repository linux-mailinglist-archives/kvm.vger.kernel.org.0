Return-Path: <kvm+bounces-9522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F377E8613DF
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A496B285824
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 14:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867A58061F;
	Fri, 23 Feb 2024 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OB3PH38m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3220981ADB
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708698036; cv=none; b=KoXgBeXHjLQng6VOf+8RbyE1cfQWmWrZ+vtmHU3VJfV4wEOEwnfrI5hN7FlMQ7gSH3JyQf+z/N83O6zPIPS18gwkNdqul+oiRXOZ+fPcdXfPwJpmCQAB6yjldaFJuD0KxGIXZwxsXcWZJzvqFtWmxO+XgiNBRGqv0F+TaDjV+lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708698036; c=relaxed/simple;
	bh=TV2TbTF5HNR+UtY5N1ayGaJ+DSc7ezRUbJP15SLdHEs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bt7BXhVNc3p/k6P+MPlF+WGz2Vxy0G+MKgB2T/0BokIHiczQDlzjh1SzzknMeTvYo50Ebyl66LGpTSHlgV+hRwBhi1F+Sf2Ikp9bNaMgMnvQTSGoe0feWipdwjn693U43b1irnqJZahQ61Lf36iYz3FUkE1WTRkKcnu7Y0iHSv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OB3PH38m; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047fed0132so13375377b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 06:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708698034; x=1709302834; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZuuePe5dJSpQ6kc+Papl7SiBSTZFtVsqxBtzBME+JE=;
        b=OB3PH38ms84+EJDNBwr36sET2bW4ceLtNv9nCdqb2omIt12D/4M2vxSQUpi6Fboxfu
         Fafz0Jgyg9syPxARJyz/IoaAxtU+dxFPf9R/Wgd3d4EwksPRd+KmY4w7BvWoo4+YST28
         D4qNK5TMTUKXGCdnd4MShH3QYtooc4dE2PM9rsztuPgN/oFU99eDdE+kMnVipW0bsZk8
         d+uDkZC/AjdnLADO/Nk6m55Bu9LuhyjeAcXPDWD9K8p2haVOjof67W5PrEJXJiVLlnEJ
         58US+g4X56tgPFIoY2r5LhCoOampJGEvjObRdmYeH0gWupLYnMF1MCEJIfiXlNRYEk//
         lmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708698034; x=1709302834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZuuePe5dJSpQ6kc+Papl7SiBSTZFtVsqxBtzBME+JE=;
        b=VHI9dV3mm6ML99ONxcHSsmLs/46QycDjx6HiOrQGY7QPYLX2K70NkQAwSCzERLg0ED
         JUcFu1ff758cPpKZzwUDxBuHUYSikzlExM40j0Or70WwQ5WiHk9mCwJG+qNI4eTJAxyw
         l1GAYFFHw48X9s3O47vJQ38ZMzEUhGlAW5XaAsvMwt+VamxybkrR1JvWFkjvIU5NLXKA
         6iW+DkbHpKL+jjJCsWX9vHapKAm3Tsa4a+tX8Vryz16U7+eMVUtKYBfMTDGUNsibIpSZ
         HP97AXVz5K2LAD9dJ45inRPw3TK/KVvKGKKckXC4zPn8F2vYlER+DvKd+1JBEk0WUKMj
         eTIg==
X-Forwarded-Encrypted: i=1; AJvYcCWdw+idFvcFhUUR2MmnVQ24QuXzFOjQ23dj+jnWrUCvxozBYkHTqx9HTm+XJHwsOYkrf2d88OJvs2kEInBh4j00ymWh
X-Gm-Message-State: AOJu0YzGKT3FfkhcOxAQyMYUwijZzZ+9g7zE10ZtR9FItyoYWGAY1qIu
	p3FmIiNKM9N+mpy815abHOD40HOQ3YzVrJfdLcywBsJTISL+lzYK4Ta5I+/H1sPbkz29YXzeLj+
	Qwg==
X-Google-Smtp-Source: AGHT+IEHTg6TFxiespYtA70wAjrucDCk6kM0ronxHGBqeoKErrvrpFr13f6qgnM/+6fcnCWep9y0WRDva5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d7d4:0:b0:608:788f:8cfa with SMTP id
 z203-20020a0dd7d4000000b00608788f8cfamr361155ywd.1.1708698034257; Fri, 23 Feb
 2024 06:20:34 -0800 (PST)
Date: Fri, 23 Feb 2024 06:20:32 -0800
In-Reply-To: <20240223104009.632194-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-2-pbonzini@redhat.com>
Message-ID: <ZdipaR9KZSreIrIh@google.com>
Subject: Re: [PATCH v2 01/11] KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> The data structs for KVM_MEMORY_ENCRYPT_OP have different sizes for 32- and 64-bit
> kernels, but they do not make any attempt to convert from one ABI to the other.
> Fix this by adding the appropriate padding.

Maybe call out that SEV+ is 64-bit only, so this doesn't matter in practice?  Or
does this affect .compat_ioctl()?

> No functional change intended for 64-bit userspace.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-2-pbonzini@redhat.com>
> Reviewed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Heh, you've double-stamped several of the patches in this series.

Reviewed-by: Sean Christopherson <seanjc@google.com>

