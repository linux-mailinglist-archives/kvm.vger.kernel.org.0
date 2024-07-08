Return-Path: <kvm+bounces-21111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F5992A7A8
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 348D51F216AC
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 16:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EFD147C7B;
	Mon,  8 Jul 2024 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FxOx1h6F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3BC146586
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720457681; cv=none; b=r3aO0Y39nIsdJ4MFPtCKCO0vMZeavN1b7OjBQCqzFRkcuyox9hq7AD5UWHY2wmItT6y3dg2iZ2M+ieu9sKaz4P8lWZhm6NQbnOW2Mxp8kzBW05bccxHycF5ZBJnwFFAMYFYp7I/WS72f8fzfXoDWVZmAU/PJ3x3iqlrXWZqlPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720457681; c=relaxed/simple;
	bh=HqDe24x8LQpKn3jK7U3yU7e7HPigsvCT7XZbiyaJk1o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P48v+cmaY9XAYcGeWvLN6TsuuQ8c6De+sf9irGxFtPLJxF7MOYJd8D660JrRLbAmIkQBzGAMFdgA77Uzc+DgwEylmvxwGrfy/dkxyDUHsU3oRHwsu0t1uBpgc+tt46V8YFbrrVpwCMI3LdouVRrf+QJQhTjEDez7JYiWWQQA5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FxOx1h6F; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6511c587946so80885207b3.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 09:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720457679; x=1721062479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oqybJXs9FswZzFP+wujqks47s/rR9u0hxtDPkPaWPQQ=;
        b=FxOx1h6F6JRq0lhtGJspr2Qmv93RUh0WdbT9oxGAC+BTyRxLlgpY+LeML+8Z662xr7
         kdPJvixHa3R3jFVAJ3TJC+6SrTSmJG9Jpx/gUZ0FtFWgJPBTrkI/0+VFP3WiB3mYXhTq
         v0yCX/R777TTpOnS6d+ILFhsWQHaWlQIqFugyQqj84fykzqceebRX9xBg9kssshJ7Ji8
         DyjUJ2fL/ikjMMTPjrvnS8BYIrgMTJxNcA7ERjzUotb5iowXIHus9EwDz2oerR38jara
         zhCda13kR2Nk0xKBQed7QJgki+YLSMVn1bp0Lg0/vSEdqrArmVeVBPUqQFpAwbDkiiXK
         SQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720457679; x=1721062479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oqybJXs9FswZzFP+wujqks47s/rR9u0hxtDPkPaWPQQ=;
        b=mDYNTZKtc6i1b/GWlIgZoi1+ulTYeb/eRFR/hfY+0KmfYSpJcnO4VZqh0a7hUyve1Q
         QPF7aip6uVuzmfvjPcJyjEf+lc/ajntftP1Xy3qcIRuuyKgvdi+tDCOp3Dn5Suqb2m5k
         aFPPbL/7bEfS3CVznYkG7fNkiz/rZsM+xL3IMCexlkCZ9bmBSlMgHmsQeeuQeZdiy3wc
         EDqVulgF2F602BZGSugZ//PRqLFGq6JXuFqkCL5iO7MODOmgaaXuT2Iqu4EAoehHeAck
         OTWjeRO+5JZH2kKUbv2/sXWmgClmLVzzSsImlAq8zgf7ttR+td0xibMcdbPPUGlYsdr4
         rbaA==
X-Gm-Message-State: AOJu0YyAoIBpG9sO+8p1v/JbL9dXRudBGpOH3Dh9LwMlz7nFkQWgh14i
	TWitBdfCMbDJJdMNc70enmR0efyGoUGX2kED6H//gMJfXRWz+4gSeGtz3a5BNmKiC+0chWJOAPF
	jNQ==
X-Google-Smtp-Source: AGHT+IHuZzySkqORTvISmyhPlDoIdw05sR1uvy9dP01Ky6R7aK5ICIHv78/axIwPdM8hNipzxU8qS/L9N40=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4d82:b0:62a:2a39:ccd9 with SMTP id
 00721157ae682-658f06d9fa5mr7337b3.6.1720457678955; Mon, 08 Jul 2024 09:54:38
 -0700 (PDT)
Date: Mon, 8 Jul 2024 09:54:37 -0700
In-Reply-To: <20240701211445.2870218-2-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240701211445.2870218-2-aaronlewis@google.com>
Message-ID: <ZowZzUTVNhp6gpL5@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for the test "vmx_apicv_test"
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 01, 2024, Aaron Lewis wrote:
> This test can take over 10 seconds to run on IvyBridge in debug.
> Increase the timeout to give this test the time it needs to complete.

Heh, there's a pretty big gap between 10 seconds and 100 seconds.  Can we tighten
the timeout, e.g. to 30 seconds, without risking false failures on IVB?

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 7c1691a988621..51c063d248e19 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -349,7 +349,7 @@ file = vmx.flat
>  extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
>  arch = x86_64
>  groups = vmx
> -timeout = 10
> +timeout = 100
>  
>  [vmx_posted_intr_test]
>  file = vmx.flat
> -- 
> 2.45.2.803.g4e1b14247a-goog
> 

