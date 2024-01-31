Return-Path: <kvm+bounces-7519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 235E5843270
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2361B1C22152
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE395394;
	Wed, 31 Jan 2024 01:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4jSAfZaR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC34C90
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662888; cv=none; b=mqWtxKD72GAiFejyGlUvFBDtXzCL2NCzkI4c3h1yxm62h5J8JTKe5c1h2l/bqZYiELDnokk1msptOzH6zdjM4VvlUNxCgaR8Maz8OnYgUa33c8pog+VvZQgPZzctZVy+IwJ8PbGc7rMLyggoV7T6I+1ADktloOmxsVkMgSZwx7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662888; c=relaxed/simple;
	bh=1ZJ+3ZE+RNpfbMzIdelhRqVYdCqyg8aWpDwhRbhdEhs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N+8XM4cbDjd8iYPpbtqPpQHYsW4o9aKlS1EuOEnO3O2+y774P3Hi+hzct6Ucjced+zS8mTTQAWHH/noiVvKt8mnuBtIRkhF9waRwNvGLTAaoDisHHQM5FWfS+q09lHPRphjt+R1pBN0Qe98PDagM+/ABS+8NyiQqqBjRrZf/7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4jSAfZaR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60405c0c9b0so10999827b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662886; x=1707267686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjpePdvErsIpjn3ohMYKEhHGWLvIvzQUpmnBdbWurjw=;
        b=4jSAfZaRZUe2OuinECB5XNfwzMfBtRgUuXSAAOQC/HIExrstHXHUPrGGolmE98gVaA
         EUCE1QMSjmRIORliNf50hWdPZfHUB3pe3jWSFdzmN4GwA6yB14p75NJlXJ49peaUTfsT
         YGxogbhasj6uZEw8rnJLarzMqZq9JvMl1n4vnVHX/BnsBGJBpdKHoJDi00Zd4DZ4g8/Y
         G/2buqp8Xv63nj+4zWfZh+/kk5WqatWVc33xL3R4ers1SqtdawshBZkGRmQQP/GW/PeJ
         GaiOOza97XtLW9xMd/qbGfbH0JJTxnPFZdFgBqJjTJFEoRfIS/+ma5z0sJMPNY3Xd5wx
         9U4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662886; x=1707267686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjpePdvErsIpjn3ohMYKEhHGWLvIvzQUpmnBdbWurjw=;
        b=alj0bgF6kv2/89V4BIL5j2ppuoT+1XU/t7YS9htaIMEjRXghFbIlQ4OOIGQ4jRIDvT
         YhgnTggbADxctsoSLuMKzGO4GBANwjrXAPbAuuYA5XvbkLRbmL9+duf6kjnVaS3i00dc
         /F3iNdgc+IWm18Lo8bSwbyDvNPAZWtTQHvdbHwXaN0oDawDXh1Qe3P2kNNVIqCKK/WDL
         EycKUlVEEOPWht8yieCgpmSDigAxuH9fzpvfVAXy5NDeg8X4Cgt+UcQ07rurMf0tKSsl
         lL6wE1HFjddMrD+3HIsCj5jh1VIhd7RoK/o8FowVeSH/dyDsLfxKHy6CHK4SOwExtlx4
         zdgA==
X-Gm-Message-State: AOJu0YyMnIP49HdaUG9aWTWMpZ+48HtDUAOqbiP7J+jFLozPque9h7vz
	CpZ2sLB2ni5QCDWo1icHUwevL6uv1Yhjk2VQPEPdf68yMFd0HSRuyGiOqIxsE4sNhOng6utQ3mc
	u5g==
X-Google-Smtp-Source: AGHT+IExYOUCxYmakAVpAUAgYpBKYtXDHh8yXLQDZcvutV0XcHgQtRqDlTgSz6BSt5ZQRaYsIpcXcgC9xys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:240d:b0:dc2:5525:f6b with SMTP id
 dr13-20020a056902240d00b00dc255250f6bmr65174ybb.7.1706662885922; Tue, 30 Jan
 2024 17:01:25 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:29 -0800
In-Reply-To: <20240111135901.1785096-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111135901.1785096-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170666266419.3861766.8799090958259831473.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>, Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 11 Jan 2024 14:59:01 +0100, Vitaly Kuznetsov wrote:
> xen_shinfo_test is observed to be flaky failing sporadically with
> "VM time too old". With min_ts/max_ts debug print added:
> 
> Wall clock (v 3269818) 1704906491.986255664
> Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> min_ts: 1704906491.986312153
> max_ts: 1704906506.001006963
> ==== Test Assertion Failure ====
>   x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm_ts) <= 0
>   pid=32724 tid=32724 errno=4 - Interrupted system call
>      1	0x00000000004030ad: main at xen_shinfo_test.c:1003
>      2	0x00007fca6b23feaf: ?? ??:0
>      3	0x00007fca6b23ff5f: ?? ??:0
>      4	0x0000000000405e04: _start at ??:?
>   VM time too old
> 
> [...]

Applied to kvm-x86 selftests.  David, please holler if you disagree with
any of the changes.  They look sane to me, but clock stuff ain't my forte.

Thanks!

[1/1] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
      https://github.com/kvm-x86/linux/commit/a0868e7c5575

--
https://github.com/kvm-x86/linux/tree/next

