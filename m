Return-Path: <kvm+bounces-63145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D1DC5AC82
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4200D351956
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394E724A076;
	Fri, 14 Nov 2025 00:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUC2+or0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9523BCED
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080482; cv=none; b=VoAN/jSQkrwx2I07fpB1S+wruV7Xey7sB/MMGkCuUynF7b9Oiz7JveGY3Z7j/GIg/Y6whYGtbwt0rpWpAZMS+ihONfUpyL/cuOv3YNMKCbSRBrlIWeEhr9tNL4a33ggCop6oIMaNL+OReb5XH9bZChgvXuhDrDzstdXL3JHI1kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080482; c=relaxed/simple;
	bh=h4IIGtUwg2zfQLlgqSuzTJ14YwbK9UnHqRaoE6Y4Amw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iWBxnJw0PDCtJQgH22ZNMW60gyJ2yBpnuoZtfu8ojL4TFamFDGbF3ZgVixRn8PV1Cufb6fwT9/F7ZHiQLfs+TZq4IzOY4I1uGeDXxgS7uAFBxJzSRGJ/MLeHQPnil791k/mW6tmt347OlLWOtKk7tQPBEQHXYzzsyXXQG8vwZlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUC2+or0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so3389024a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763080480; x=1763685280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+LHuB8xIRgaS8JdU4+Im4g3U/MNFjG6h6raen6xbSHw=;
        b=OUC2+or0QrpYj80HnsJipfY1AGYBgOUnsYc4sxhuFeQgMbmXmd3uIjCVmEOQmVgp98
         GjQ0gHVUewOAWdgTe2mby9PSWhy6/vRruKgMyb31Ij7ZjkOB5YbAObT3i3pQvXgNI4o7
         Mx4UdiQm3qt3LH0guOkrFd6YZJZYmuc+F8FXz+FWCaNUwN9sSykutMz6v30sE8dsjgpz
         UZDs0b5qdo5CjDBkSXy1SWJH5L4eJtcFnHe7DLQZ//n0lgCSiId/sWHvIKDlTS4Ds1JC
         /eqYTn+PtCqsny9SsMWRyHxOv4hS2LExMe344/ylWnFCdGTsWLKBsh62U2UjTa5WdhNh
         oSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763080480; x=1763685280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+LHuB8xIRgaS8JdU4+Im4g3U/MNFjG6h6raen6xbSHw=;
        b=lBWAJv5Dnd2m7mm5s/wxStzHecr3djfszgRuroZ0zzm6QPf6sp4uMFcXkew7757RHl
         w7sF6YqhmnSUzZhc4PmIM8uHDFmuNR+3Pkjzhr96ucE/Nj3bwZ6pEGhm7nl+V9snUt4W
         bO9cr1z3VP0L14gZ9N0rJTAqeVDyEXF5yXXQHMofOJbZR+/Z+yCu1gbWKew+enKT3xub
         dMZo8yYTsa7W2IIMyDg409jecWhtbtiBSY7W0lQOS6F+u+5mj9drAuu14Uc2ibh1adDj
         AoY2ULwMtrunVO8q27l1h46zA3aj9hDHY7XkI1lP8WKH5sdMAdeYl+tokrKOyT/P8q3g
         i8rA==
X-Forwarded-Encrypted: i=1; AJvYcCUF8FyP8NNfky7RydIqsDvc1t16CbD1ESddGQOKqrKT4bDYtyYeefTaGdawwdq+93qri7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEL2RsrLceTUwTm6gO50XL/KFRnXaGWliduA84Rc/0UwdJnuts
	NzV6dZ/rKlj4IdijwHPc/ZKqYmrfHAvlYvVhOh7UnAHgnbgstf8SCIQ0hIILk7zUjaeFL1dbjmk
	FtUAFxg==
X-Google-Smtp-Source: AGHT+IGMe9Nh974AZHgvnwuhOflFpS2qGBRz4ejDlIY+jCOIYlRX8kP36jsF47mvsnpylL4SvqRZOZBbBJg=
X-Received: from pjbms19.prod.google.com ([2002:a17:90b:2353:b0:341:7640:eb1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35d0:b0:33b:cfae:3621
 with SMTP id 98e67ed59e1d1-343fa7611b6mr1152459a91.32.1763080480391; Thu, 13
 Nov 2025 16:34:40 -0800 (PST)
Date: Thu, 13 Nov 2025 16:34:35 -0800
In-Reply-To: <20251110232642.633672-10-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110232642.633672-1-yosry.ahmed@linux.dev> <20251110232642.633672-10-yosry.ahmed@linux.dev>
Message-ID: <aRZ5G6GSMnbHxx_K@google.com>
Subject: Re: [PATCH v3 09/14] x86/svm: Deflake svm_tsc_scale_test
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> On an AMT Turin (EPYC Zen 5), svm_tsc_scale_test flakes on the last test
> case with 0.0001 TSC scaling ratio, even with the 24-bit shift for
> stability. On failure, the actual value is 49 instead of the expected
> 50.
> 
> Use a higher scaling ratio, 0.001, which makes the test pass
> consistently.

Top-tier analysis right here :-D

I'm going to take Jim's version instead of papering over the bug.

https://lore.kernel.org/all/CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com

