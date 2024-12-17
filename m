Return-Path: <kvm+bounces-33894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4F39F3ECC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FDBE16DC13
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F5220B22;
	Tue, 17 Dec 2024 00:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wrP2M+ww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9F018035
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734395376; cv=none; b=iUpkOGQUgNrcg+OWP9kJAzDK6u63KfMEC29hCMaIuiBWl+69J2re2yT2oz7Ap7YDMpKR8DvUKHNW5oXSHpAeIt1ZHjtSSNCcfyy4J7ohsXbNu2S1G1OcBAmoRVSsJFrfxgPeKNhPS2VtG6eSRHXBVfW4MaVbLbIuebA4nglf4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734395376; c=relaxed/simple;
	bh=tKgUb236+UPmH908Ihb+K0eHexiRBeuza+BHm3B48YY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdwaoXJkkvszv54qqdIiCh2HS9Ydi61eILWg55RBebA+Z4H4viXEGTOMJoyyNbc58u5JriUdqf9O8ruumFXMSN5gcGalNLrtAVum9uicGkTYraMaV8eKCcIz9K4bpqhiwM9gLLY49BfzkTjg+kllGx2Ku11X42iUJ/jrnm3xPrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wrP2M+ww; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fd3ea0ff8eso3076774a12.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 16:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734395374; x=1735000174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Db/ZmD8RsS+Ekv1pMP4d94SEiz9JgoOtJsiGIN6ZfPs=;
        b=wrP2M+ww2GXNXy0EeLfKYbum7tW6pdjMeD33J7j0F1Sq78agC+bNg3W5IRqv4WFlOb
         UT4W7rKDb/XxjWhtqgg5a1vbHDAnAihGFL5X2S94LVloN4Qw5zM2vvlFbWXmAxXirRd7
         T7rMay4+bN3gF6XRJXP7DOYF06I9kXIbySi6mZoXrmPkcmaU0vbOxc97hr3bj8JU7eWM
         E6+9+slkHMIi+ck8fI6QRQ61SJDeY1F4yKy8Obm+EJ189plv1cZTMwUdXgaTvC62cIgZ
         KDZW7CDc9KpcCTVHddexPAxgBohvxl2s1wq7Mi55pUAJP3jnAkhYAXFrq2qbDzhBSuJ5
         TKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734395374; x=1735000174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Db/ZmD8RsS+Ekv1pMP4d94SEiz9JgoOtJsiGIN6ZfPs=;
        b=fOp1zUP3+E1Hc3KQ3o4RI7Rhzq/JftSwJX6R66GukPb/x1Rlyj0cSCaaF3yYPy6LhM
         mabzdYDUxfqdVFn7xQjTyuqky0w9mbUm4DZr+b4uCupzCqbGm3ZLyX6jXO5UHVA7v0vW
         ME9gQCjHFrtA1gBo/nqZehetyRayw+U+R2bqq8szaSIGfd1pktXZt6u1SzI4xsZ5Yfe3
         gl3WfL20Ail+AiFSqtP9PfLd3If+CJtKI7tppALy8hZZ/paLHkoYqEEUXyGTsgHZ5ykf
         dI71+KJiJxS2ggnTZTGCuOgrdr5wlN4ya/THwO5kOxlhwK8046SWnnxz+czaLx+XU1ps
         I/tg==
X-Forwarded-Encrypted: i=1; AJvYcCUeJYKk3petn7ugO1O7ltO3Fc5KKSDsvenTlr1/ULws9oQeSKS7UIwhizcEXXYm/RCmubE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjoFftQs/PLiVxG0Tp38TI1UPS7M85H+8HA5H1jY/FCmKLMpfw
	mU0qVXcZEZ1LIrNcAur2Onfmz/4HmcjCQD6+mnF9F049ermor9nSDDubtLEUBtS4GVEbzDwIf4j
	/5w==
X-Google-Smtp-Source: AGHT+IHjgHrA7xG0NpkEgyerFx4NYRTJeFfDwmp5imjiS4hM3JmM9g8Y/8s0n5IjWFI1IdYyAKTqLOiDHjQ=
X-Received: from pjbsj13.prod.google.com ([2002:a17:90b:2d8d:b0:2ef:79ee:65c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6cb:b0:2ea:5e0c:2847
 with SMTP id 98e67ed59e1d1-2f2d7eece3fmr1895400a91.22.1734395374509; Mon, 16
 Dec 2024 16:29:34 -0800 (PST)
Date: Mon, 16 Dec 2024 16:29:33 -0800
In-Reply-To: <20241206221257.7167-1-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241206221257.7167-1-huibo.wang@amd.com>
Message-ID: <Z2DF7UFNt1vayroN@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more readable
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Dhaval Giani <dhaval.giani@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 06, 2024, Melody Wang wrote:
> Hi all,
> 
> Here are two patches to make VMGEXIT GHCB exit codes more readable. All
> feedback is appreciated.
> 
> Thanks,
> Melody
> 
> Melody Wang (2):
>   KVM: SVM: Convert plain error code numbers to defines

When adding patches to a series, please treat the "new" series as a continuation
of the previous series, and follow all of the normal "rules" for documenting the
delta between versions.  I.e. this should be v3, since patch 1 was posted as v2.

https://lore.kernel.org/all/20241202214032.350109-1-huibo.wang@amd.com

>   KVM: SVM: Provide helpers to set the error code
> 
>  arch/x86/include/asm/sev-common.h |  8 +++++++
>  arch/x86/kvm/svm/sev.c            | 39 +++++++++++++++++--------------
>  arch/x86/kvm/svm/svm.c            |  6 +----
>  arch/x86/kvm/svm/svm.h            | 24 +++++++++++++++++++
>  4 files changed, 54 insertions(+), 23 deletions(-)
> 
> -- 
> 2.34.1
> 

