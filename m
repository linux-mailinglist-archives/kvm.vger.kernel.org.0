Return-Path: <kvm+bounces-48348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52637ACD036
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 01:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97E3177057
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3061D253F1A;
	Tue,  3 Jun 2025 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OsGv9NSK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE019225768
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 23:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748992826; cv=none; b=K+Hd7w7Teo5db88XoDwsHu0yI4OrvZaO9ULRMswkhGs66RrhCsUADQkQghEBmvL+ZYe85xh9VdfPtMQHOWaRGTGS/HK/Zonk9wffGscMKIKP6j8FjK2KycDW0qSYVLnCqCZ2xPy4fUfzMM6Cr/bWhPyCp54OjBE1M+SCpDVIMuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748992826; c=relaxed/simple;
	bh=j58Q16s6XP7YOP/lfHW/QjY9sHrr3GPqeCXlnplz2WY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z5FFBf/EAAARkmzFOyeAEm7tOStbkQpYJC1qCiAXi5JOV+eJkC7P7+xsnVqkQExjku+Emxl3AolnjKXE16wiVNHmFFiXCMvesXl+der7rfq01MhGekA//dJDCxhxXct/9297OjGjIfeS2PFp6ubSZkp44UgI0/1I0iPAAbrnT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OsGv9NSK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b240fdc9c20so6273839a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 16:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748992824; x=1749597624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1NQnWbd4TNjgXbBu1YELa+Y+x9/lksnJYJWgYujMTY=;
        b=OsGv9NSKrOWHJTqRBYFZ1ORrnrgdl+fW1X/Rg7DLM2YAcP1etrPvE7IsmdUBLq3ozw
         RGrK+l4dCvA4mOV1dDdlTgbGlD0zdWDdLJhh8Rmt/Hzi7qiePVwkTDVheL5KxjYEy+CO
         bYBfG/vvbbSFDOXS8409Ilwc5NyYwGBCGnur9eEK3LRGKyj0i/j/ShSFHc6dcKLKawmR
         I0jydmettrA3v6eirHWyuByR3MuhSNpAWH2pc/jXCEZS/dkeZp5y8EBbUTYnB4SRPv+y
         gztsi/Uluph9OWDjUVttI5UgdhMjoh3Spgg1oNVH6Bu9tAI9sj3lLsM5lVtg1jDxJWlE
         OEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748992824; x=1749597624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1NQnWbd4TNjgXbBu1YELa+Y+x9/lksnJYJWgYujMTY=;
        b=ZufpEJxd4IfCrnZMwYv3kcbJLz5nVExzkoHGA9gpXCc7JPcFzF7LKTqUGHJWi9RCzC
         BwiAQRhM1ZsKaEPkEDX0Fj5WLXYngsSOR5G/T6LHjK5JZw17Km15hs9q79VKnuZoblhR
         Qmf/BKx24MoAncK0UUblVYUS++gEFbTRjmKs3dRR0e/ShwOv4pN78qPnBrUebRn3DXkU
         Wto1KTofdnbkRgfOABJRBoZ6wXACv2VZVfZwT5usyDTLUiMnxH7iiev2ThVsis+rRUgR
         tcnxPHlYNaTTcFXsnatCQ3o3Off4r+xXUld74YGz58r0GthoPOOZLIwgW95fKEOTlpQ6
         MtXg==
X-Forwarded-Encrypted: i=1; AJvYcCX0WZpgex7FUay93Hwm93m0kIpGFw4Sc/Xo7gwvo6Bn8wLX3f4Simp27IF4poxENS4KN3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YywquagezBTAulqfckEl6WfiK50uIrRxXIpdfUyMXW/XtR78h26
	kapX9sX+fMq516X4CivOtNN6IoHEK3oERmzYKGKPQr2NA7mnfiqoyaIXd7KPmcQVXgl+XfqcuBu
	pVgFpFQ==
X-Google-Smtp-Source: AGHT+IHDEuV55HfI3KJOeebKilLhgQC1SPNfNkKoXqJ0hnYG38Ky2DmjXchOknyXiLB0Cqp9sCaPJzM173I=
X-Received: from pgbdp1.prod.google.com ([2002:a05:6a02:f01:b0:b2c:4bbc:1ed5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3949:b0:1f5:8262:2c0b
 with SMTP id adf61e73a8af0-21d22adc9a3mr1089443637.2.1748992824067; Tue, 03
 Jun 2025 16:20:24 -0700 (PDT)
Date: Tue, 3 Jun 2025 16:20:22 -0700
In-Reply-To: <20250523090848.16133-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523090848.16133-1-chenyi.qiang@intel.com>
Message-ID: <aD-DNn6ZnAAK4TmH@google.com>
Subject: Re: [kvm-unit-tests PATCH] nVMX: Fix testing failure for canonical
 checks when forced emulation is not available
From: Sean Christopherson <seanjc@google.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Chenyi Qiang wrote:
> Use the _safe() variant instead of _fep_safe() to avoid failure if the
> forced emulated is not available.
> 
> Fixes: 05fbb364b5b2 ("nVMX: add a test for canonical checks of various host state vmcs12 fields")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  x86/vmx_tests.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2f178227..01a15b7c 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10881,12 +10881,11 @@ static int set_host_value(u64 vmcs_field, u64 value)
>  	case HOST_BASE_GDTR:
>  		sgdt(&dt_ptr);
>  		dt_ptr.base = value;
> -		lgdt(&dt_ptr);
> -		return lgdt_fep_safe(&dt_ptr);
> +		return lgdt_safe(&dt_ptr);
>  	case HOST_BASE_IDTR:
>  		sidt(&dt_ptr);
>  		dt_ptr.base = value;
> -		return lidt_fep_safe(&dt_ptr);
> +		return lidt_safe(&dt_ptr);

Hmm, the main purpose of this particular test is to verify KVM's emulation of the
canonical checks, so it probably makes sense to force emulation when possible.

It's not the most performant approach, but how about this?

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2f178227..fe53e989 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10881,12 +10881,13 @@ static int set_host_value(u64 vmcs_field, u64 value)
        case HOST_BASE_GDTR:
                sgdt(&dt_ptr);
                dt_ptr.base = value;
-               lgdt(&dt_ptr);
-               return lgdt_fep_safe(&dt_ptr);
+               return is_fep_available() ? lgdt_fep_safe(&dt_ptr) :
+                                           lgdt_safe(&dt_ptr);
        case HOST_BASE_IDTR:
                sidt(&dt_ptr);
                dt_ptr.base = value;
-               return lidt_fep_safe(&dt_ptr);
+               return is_fep_available() ? lidt_fep_safe(&dt_ptr) :
+                                           lidt_safe(&dt_ptr);
        case HOST_BASE_TR:
                /* Set the base and clear the busy bit */
                set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);

