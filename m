Return-Path: <kvm+bounces-61738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDB1C27235
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0002F1887102
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5907303A08;
	Fri, 31 Oct 2025 22:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKWe0PjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B919034D3B0
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 22:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761950657; cv=none; b=JwxMkRvTC7HCEfJJNCgW92Ty2KrrfiUQY2/VyuYEpNcTjEwnDnUaPTfOPedNw65uLjsDphhiiUESpsYIrQSu8LNqzvw4o8RH+WTxyXmhQc+K/pWiVLVlZbUDKMfoAQkSXi9j2f/jm6pTQFcujNz6pNNbCyVOa7QnxuD73Vy4eCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761950657; c=relaxed/simple;
	bh=7ejd3RH9OzcjzuCiyP1mqAuhkPZwqxi+qnR/OTVauos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ETsD5uM9B4hZ2gExEJ1Y2V6XxbAYWubKENWF7Ndq/Fvf3zRlv9sjTS0XqbbrOkOYnl2+jU3HK6eGmlgHbK1byfS72YQLprdC2kGJui+pMb/TNJnubABbLJH0BYmDp1nz4zldZ+T/ArxHuECPo8lGtHSYDOotqc5LXzmM7rmyk8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKWe0PjT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290e4fade70so34462175ad.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 15:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761950655; x=1762555455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0q+N251yAB/AzpOkxo0G52kUjL0b1rEPNWWcsggfEcw=;
        b=ZKWe0PjTr+3X+G1uWoBGfBcMFabWuegF3VHze1O7OEwih/YE5I+thtA2RcsTxnCwGh
         0bhCEYCMz94mQUWTfCNS/HuMmsEFo79v80wMa1r8lyNvih1zFYMH/mCuTwhEEFIFFKSE
         FHxZMI835z8a+FHwdawa2oA0ruhBmDiNY58JwmSVQisa5X0RPnby2nvMrJ5uJnNwBh3z
         h6GkbB6HpdsXw6gOYv8p2ylWshI5AKvMBWIiLwd6rOm/goeZ3Kwi8ZHNNF+QTN8hGIdp
         6ZDF5dImpvBEGkR1wpUcdmEPYpHvhaziR7xywlNBMgQe/Vtl1zIPaLRLJtKHFfGcYlFW
         zq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761950655; x=1762555455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0q+N251yAB/AzpOkxo0G52kUjL0b1rEPNWWcsggfEcw=;
        b=gluP9d1lvJDlOQDcxOrtB7MHSgvYpRJiARZWlXkqmO4ORzSRiz6f6RY2tNLwZeLEug
         z4bB0686YhhxCGeBR215x/ZCINNb8XqNim8PqGyDJDYHBGFdR3SiHCQ3YwQ86eefwxMM
         sCkiGCC9BCUigFhKNpKOYXYP7v4hZEKhzzvU2GaJPmXtFD+MLap9bZXWRym+hm+ZDyjh
         JM/G7ZX775iiWOyGf3MTz7iGFXenyXII3aS67P86JpNyTnNy4v5uZrcP60890CRIUxvN
         R84lbX5sLo7RxgVzx2pkESRUHuisUzFM+zUMZnErXPe4z6scmH3vBi00jSbOj/kmAl43
         jZFg==
X-Forwarded-Encrypted: i=1; AJvYcCUONEc7Cj4Ntxi3WRRHT7EzrFcwcm7AOoSkS8ElU0GFiKYtfUdwnYVlUyjzrvih+EOMFps=@vger.kernel.org
X-Gm-Message-State: AOJu0YzidNnNjWMysxprmQL34A7S64CWhnU3OgGiSL19eJUWPOY7VDUa
	LhDsLjKBZcw7vQ/LgLWZ9S+GWuJ+iiHARN09ay1qy07YRVF7slbE+jmVQ2rZ7ALi+EKhoAs0emU
	HS3c06g==
X-Google-Smtp-Source: AGHT+IHu5BWtXXcIrOoEGg3ZxnAvM3V/AsNyyuif7JGLKNHrl5AceqXXXIwvvw93pPL1RDMi6Aq/Qw8p9GQ=
X-Received: from pjzg6.prod.google.com ([2002:a17:90a:e586:b0:33d:ee1f:6fb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ca:b0:276:305b:14a7
 with SMTP id d9443c01a7336-2951a4d8340mr72998965ad.33.1761950655040; Fri, 31
 Oct 2025 15:44:15 -0700 (PDT)
Date: Fri, 31 Oct 2025 15:44:13 -0700
In-Reply-To: <6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com>
Message-ID: <aQU7vR9_pf8uwqry@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
From: Sean Christopherson <seanjc@google.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Omar Sandoval wrote:
> @@ -2153,6 +2158,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
>  #define EMULTYPE_PF		    (1 << 6)
>  #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
>  #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
> +#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
> +
> +#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	(((v) & 0xff) << 16)
> +#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
>  
>  static inline bool kvm_can_emulate_event_vectoring(int emul_type)
>  {

...

> +static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
>  {
> +	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
> +			      EMULTYPE_GET_SOFT_INT_VECTOR(vector);

Apparently our friendly neighborhood test bots[*] are the only ones that tested
this :-)

This should be EMULTYPE_SET_SOFT_INT_VECTOR()
                        ^
                        |

And I suspect EMULTYPE_SET_SOFT_INT_VECTOR() needs to cast (v) to a u32 so as
not to overflow the shift.


[*] https://lore.kernel.org/all/202510310909.y5ClH2qW-lkp@intel.com

