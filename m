Return-Path: <kvm+bounces-18945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CD78FD613
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 20:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 368D81C21F05
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F6413AA5F;
	Wed,  5 Jun 2024 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3h9TZfYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C1E139D10
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717613596; cv=none; b=Nxas2rT8fmrPjoj8InWjGGtvSh8v1ayCkbEOJGsSPKExDniJ2PlfsgKbeO9FRnbF+/vZGj/ayNep2WQ8/AtZKB8Ruj3W9BScURkt/YuFF2yfAmV1xpP8UwnuI+U+/YyrMp5zoaePYUWn2KQaQHcTL/oCjGh3v7dW62MO5Ruh+Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717613596; c=relaxed/simple;
	bh=M+rSz/UvljOY+3b+TcuR7EC962LBMt4iBDf4iKFLIbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e992yX91w6lQd9lji1O/xI0CItgEVIwtTb3+hQDg7z+QQNoGB/t0z6a5V9Am3nvOlhGs1xNWHAqJIeJsyHgSvgDpGGxiFLM1skxs8BK2YMDDl8Ht1+9aMgqWtcGPf1PC6jGOotHPgrf1DaruP/RgcO7bNENC8tJzGmN0c3DZWDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3h9TZfYW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-629f8a71413so1563867b3.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 11:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717613594; x=1718218394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ocZYxRdH3sxqA9c2g1I7OCZPOS437DU40s7Wfbg0DtQ=;
        b=3h9TZfYWASGgJe2rWVsYQz6YU2Ny2Cu4CYW8dL+Hkd10hzQD7uYNRmPvgVfWqfzwYn
         BBDQwUbLDOwsu2JFSadnb4pQHPOrDZtXg/anq4k5VBXojxVNmvnz7jwcIGLrdKWkS+QB
         AxxV6d7O9MX4REpRwFeJt2nN6th1pWboubTfTkYWqXKVH9Fcz9DWMFAD0j3hIGIRvtNn
         vspxYE4x36cZbEBFMVp4vERp75tD8Ld3Q9Xq55VKjLQcMnKfbYbv9TaKuKwdLx8sI8Qt
         hI1NfOsvjeYlbvVxjoCcS+mB8jWFZJgwmYxvqebCxILDR6yGKpMrt+DViIr83EopxJPg
         4N+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717613594; x=1718218394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocZYxRdH3sxqA9c2g1I7OCZPOS437DU40s7Wfbg0DtQ=;
        b=wyFIvghNeC04jDCmX9IzebOuUHOYVnpSk9pyMFwpLuqVRELdsbXwJAAuZ3HtW7xsRq
         JE5MUJRrZCFaqLMY/2mQMdfBjxt8aFJNyjzPT2T3CPMahw8kRERq2OsTz2h2ifZHExnX
         7wOpVuQA9Zlhl21u6DReVhPUzXlSjF+w+ATFjWkvBRsNsEvtFcqcWVv5LeTOO8VRCsEv
         tH4yb83HgbTA0FmziuVwfGUSFWZq9g5vL65i7oVnVt9s+kjDTzXwg3aDz+YVOMwmsr5f
         1PyCBLvNq0ahxpIrzj1vEQvZLyeMH9wVhBLSstVmbMnqx0fCn2X/cabzcYR6s8gWNxPE
         eKNg==
X-Gm-Message-State: AOJu0Yz/8QicjtazDJmU0Wz7hy3G0IkQnwSS7VirMtqWSf805vS5/lpq
	e0LGew4Z4SWKpesap8gOTQ+QVHE8eHQIn7QtUwF2aOLSCGjE6QCJec505FUuAD7I2INKk+xV/Pw
	jEA==
X-Google-Smtp-Source: AGHT+IGhJZ/MQpeAbL1JgvLWp2W9EhTFh+pLuBUaucXZ/7NPP79p7aXBP1hYQPVHyWEnheMLn/2bPdzLGLk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154e:b0:df7:9609:4cd8 with SMTP id
 3f1490d57ef6-dfaca7ef6e6mr633350276.0.1717613593823; Wed, 05 Jun 2024
 11:53:13 -0700 (PDT)
Date: Wed, 5 Jun 2024 11:53:12 -0700
In-Reply-To: <20240122085354.9510-4-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122085354.9510-1-binbin.wu@linux.intel.com> <20240122085354.9510-4-binbin.wu@linux.intel.com>
Message-ID: <ZmC0GC3wAdiO0Dp2@google.com>
Subject: Re: [kvm-unit-tests PATCH v6 3/4] x86: Add test cases for LAM_{U48,U57}
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 22, 2024, Binbin Wu wrote:
> +static inline bool lam_u48_active(void)
> +{
> +	return (read_cr3() & CR3_LAM_BITS_MASK) == X86_CR3_LAM_U48;
> +}
> +
> +static inline bool lam_u57_active(void)
> +{
> +	return !!(read_cr3() & X86_CR3_LAM_U57);
> +}

Same comments as the supervisor patches.

> +static void test_lam_user_mode(bool has_lam, u64 lam_mask, u64 mem, u64 mmio)
> +{
> +	unsigned r;
> +	bool raised_vector;
> +	unsigned long cr3 = read_cr3() & ~CR3_LAM_BITS_MASK;
> +	u64 flags = 0;
> +
> +	if (is_la57())
> +		flags |= FLAGS_LA57;
> +
> +	if (has_lam) {
> +		if (lam_mask == LAM48_MASK) {
> +			r = write_cr3_safe(cr3 | X86_CR3_LAM_U48);
> +			report((r == 0) && lam_u48_active(), "Set LAM_U48");

!r is the preferred style

> +		} else {
> +			r = write_cr3_safe(cr3 | X86_CR3_LAM_U57);
> +			report((r == 0) && lam_u57_active(), "Set LAM_U57");
> +		}
> +	}
> +	if (lam_u48_active() || lam_u57_active())
> +		flags |= FLAGS_LAM_ACTIVE;
> +
> +	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mem,
> +		    false, &raised_vector);

Ah, this is why test_ptr() doesn't recompute things.  Hrm.  Ah, I think we can at
least compute the mask dynamically, e.g. test_ptr() just need to know if LAM48
and/or LAM57 is enabled, right?

> +	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mmio,
> +		    true, &raised_vector);
> +}

