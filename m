Return-Path: <kvm+bounces-63609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CF2C6BE1F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 462EA2C1D5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988912DC345;
	Tue, 18 Nov 2025 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpzMyLNX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7408D28DB56
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763505548; cv=none; b=X7YCXM8tsifzMDK/9eKYy4IQpxyFh5ZmORQACCNr6EkIqOTN5YkZAY1I9pkNThiZVWbN/jvO7Da+xK2VXS4r/NiiTiWQPGiCUmcgitAfiogAwxhcj0wbUbHl9mRZXvgT/k+ePFQxUOd/JuCXUB47zvZI1CcK+Gv+5NHlTuYfK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763505548; c=relaxed/simple;
	bh=jtUIF5MdlFOECAE75V4qaOwdXuq6Hiy7hIplcRxM//4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eHxPvEQ+PVDVrWIYzfVv2XknrNSx04xrIO9TqFAnllpJbcEtDVdJyFeXzEyuM7RoGJPCsi20fAlEdqRXOVLIpcAEShrG4vzY6EyemVZwgzARdD3VQZyyCkpnpMPISBlHTXoQhRM+NH2jqLf8iCce/tcTiI4Yy7OCf8EP/Y6Nnws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpzMyLNX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34566e62f16so4970137a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763505547; x=1764110347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oo6KmzupK/eVoYiEVvgRFuT9K1unD6T5h2VuXLM5lfo=;
        b=vpzMyLNXgG2OLQT5LTk+fOqUp4Bc71z+2Am0UTUI3mjVfmz2+YoTb1U7HJ/C4rOd81
         CLqGwhrOqe5QVycjzkRwxoKD5Nacx3v2yc61Mn6N0LjweTI3DGh29CVMLTT+erEs/ISt
         P1l5bsYMKXhXTrMwSgHu6oN0CVSAM4lNWuquIJ57ak/jrvafUgJLAt7i5OkFxzcQcbtt
         tJH9sSL3YlcRJIouPwRbYAGuw33ExKv5CJBGM6pbK4iRdF60jI9D7gEuoJkMcJNtsqQt
         9dvqaTwVobbeutVKuHF1UeaBHNEmXoVP2qBD+aRXc+ct84c1wKeYp9v4Lm/6QFqdccY3
         SzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763505547; x=1764110347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oo6KmzupK/eVoYiEVvgRFuT9K1unD6T5h2VuXLM5lfo=;
        b=fuvDKA/N4m74e4MRX9kbsvxzm1IQ3ot7R8K3GhCRIxCLgR6rZtLlVsx6IaZrZ04oq5
         tijbSlw6APm3n59WM+zLcaP4L2FfnDcR16SP/cEMDOUCOSYdCIH3JmlChqBrF5FYR72Q
         HB4l32Kr+EZW9NLdNWkU4pyLRTve5h56MYhkP/1+VogbwBz+whVmdw6dNVmNa5u09Vcs
         xJJAZ/WLUJtp0Rm5iDAVnkytsTK/WEJ0OhCDJX40hRcOcwl/zhFdGxXX3+sGUABQHuvh
         WtCg25XrmUBhwmubzKcG8Wxly6oCFX7AjuwI9rV5ng8qrm/eB/KXKXRgRgCEYYLL/84M
         4Naw==
X-Forwarded-Encrypted: i=1; AJvYcCXDmyywqRXFaIAraUl2t7udyMY2/vH7Ga/xIL0FY9cCH11gAP8XHOz7RkD46gQ8/gfExMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKSJfB5q2u0KKazFUQ9xLeg2ftXgWHHhn0NfC2xQNTFImCpzsy
	Mk4fKi7hB5ghwMVSzFDvjTsz5NXnFUhY02eZcLkZslgu3ZzKhjOGnYlEg9aUJapHU8JYglrCdm6
	ILrFmKQ==
X-Google-Smtp-Source: AGHT+IFspOl4j5tHLg16hXuypYgCGd4gAz4hrrpW8CeO2usVtdw5GnAav6M3brkC8cs7kAdKq7Y4Wc4k4rc=
X-Received: from pjbpq3.prod.google.com ([2002:a17:90b:3d83:b0:33f:e888:4aad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc6:b0:343:eb40:8e01
 with SMTP id 98e67ed59e1d1-343fa63dc9cmr19691544a91.27.1763505546658; Tue, 18
 Nov 2025 14:39:06 -0800 (PST)
Date: Tue, 18 Nov 2025 14:39:05 -0800
In-Reply-To: <aF1d7rh_vbr8cr7j@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612141637.131314-1-minipli@grsecurity.net> <aF1d7rh_vbr8cr7j@google.com>
Message-ID: <aRz1iaba3j1NqdPf@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator64: Extend non-canonical
 memory access tests with CR2 coverage
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 26, 2025, Sean Christopherson wrote:
> On Thu, Jun 12, 2025, Mathias Krause wrote:
> And then rather than add more copy+paste, what if we add a macro to handle the
> checks?  Then the CR2 validation can slot in nicely (and maybe someday the macro
> could be used outside of the x86/emulator64.c).
> 
> Attached patches yield:	

Applied said patches to kvm-x86 next.

[1/2] x86/emulator64: Add macro to test emulation of non-canonical accesses
      https://github.com/kvm-x86/kvm-unit-tests/commit/9f5f06b1
[2/2] x86/emulator64: Extend non-canonical memory access tests with CR2 coverage
      https://github.com/kvm-x86/kvm-unit-tests/commit/a55d5602

