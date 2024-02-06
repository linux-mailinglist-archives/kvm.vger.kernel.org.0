Return-Path: <kvm+bounces-8154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3425484BF51
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB7EF1F25726
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F831CD17;
	Tue,  6 Feb 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yG/0Z1cy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9774B1CA8E
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255417; cv=none; b=qiS3sCkb8LhAMLGkRH0ZVL/LQu8RxtLawz9bf6uluck7GJtvnm1wXSGKHxdMFuTzgmJli7VOmdR1/tc+Rj3uLtRNjkg9HQDEvrjKfbzjEq4R/A7FuVL7X6aTHeRcIniZegu89OSnQlUMtUWWgdorNAqMtREE1UQ0/j6tFb51mug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255417; c=relaxed/simple;
	bh=XmYAqRBEKviyoYT4iE3X8UCqLYUiRQq5kAR/vxNpWek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R6ZeUi0GQdY0xSdGtM3jo6zvBtJHsICQ4kyLPpG3Am8ojCqbi9R//MIhwyWj4Vpp+LGgZIDSQZnO/0+BR7Hzgv4OZiEg/xEHsr1FmvVnzT6xhfzXB2xjkUTEHtm0y1bGco1kda+TvYDVt3EDTh3WV0brTQyr2ZNP7J3aviXgMgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yG/0Z1cy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2968734a0e6so2917560a91.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 13:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707255415; x=1707860215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EoqazHYMFgTO6u6ICQ3ULYXowNWIv6wCHqKNwnPyjdQ=;
        b=yG/0Z1cyz5jhT7a8Kqk0HvIq4Fz82MfUtaGnO+kB9HLPHgq91uBkUyU1j+BtU04Vdi
         0oLyrtuv+wj8PN8mV4xgxBkT4Aa/JF+lN6wc2auLLLqBGyJuR5elWmhcnMOWKzmv/YUw
         UQLpyyjERf2QTSJmV6INB9zWpe3wSbR5Yp8YkvzF5q96r8VjzG6LToNIqf4qmrjiz4j5
         TDyWNOLK85TZmyGlfFZDawr1DHgqKWJXL9wu3n5FZ/XvVzjEsTsLbmgRLMyfUp9coayP
         fdpc7uDACOg3RRT6Q72sHs77Kq064KnPTomOOVG+YF/nMwC2CsexX+sPoOl32ALo+d0P
         4yLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707255415; x=1707860215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EoqazHYMFgTO6u6ICQ3ULYXowNWIv6wCHqKNwnPyjdQ=;
        b=qU+96a75CJbZWibR+olZbjo7NmoKKDSwtmEuDxS0UiEcDX+lukAMLUNOD9nL9d0PHi
         JmxTUtP29+U/ArJUDkcZDc/MO/3TZpFA/x+VCx4j4ZHQYj8rNb7gYaK170yaHdGPjq+P
         FbkOdD83hLiJ8SDR7mRTCFdWMvKYfK98RcOxJ8GLv/4tToTmgTkuuerQBuhNC79DK9Ba
         cKiovIOwyHaIFgKLtG98quN72hy2CMd03EqK/O6qOkvxhM5OY0sMXwDu+7lJXEB2tYwG
         b2ePRHKR1nbyPSXkb7zF41rSGnwQhBYaIaMZtfnY7lwbmaHYa/9jXmUrPCeRdsOlI/iR
         sviQ==
X-Gm-Message-State: AOJu0YzJ1yAoo+GvlhdJ6ng5G8iAcAZeTjjE/m4oP72DZVZ1wCMHLaDU
	sBC8pBcbs77JflkRi5VSOM4lPCatmJdb6fVp3bm42F2n1IMEucNS23FiIgKgZKci2j4w+oLfCes
	y3g==
X-Google-Smtp-Source: AGHT+IHK13uiT9Ar4aRlIaTZ+mbukGC0sNZNEyvjllwGVZViLZ6IHXOsQerTK2AYC8Q+zdsZ3RN305WbPp0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d445:b0:296:9967:2e8e with SMTP id
 cz5-20020a17090ad44500b0029699672e8emr2190pjb.8.1707255414896; Tue, 06 Feb
 2024 13:36:54 -0800 (PST)
Date: Tue,  6 Feb 2024 13:36:17 -0800
In-Reply-To: <20240202231831.354848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240202231831.354848-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170724566758.385340.17150738546447592707.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Feb 2024 15:18:31 -0800, Sean Christopherson wrote:
> When finishing the final iteration of dirty_log_test testcase, set
> host_quit _before_ the final "continue" so that the vCPU worker doesn't
> run an extra iteration, and delete the hack-a-fix of an extra "continue"
> from the dirty ring testcase.  This fixes a bug where the extra post to
> sem_vcpu_cont may not be consumed, which results in failures in subsequent
> runs of the testcases.  The bug likely was missed during development as
> x86 supports only a single "guest mode", i.e. there aren't any subsequent
> testcases after the dirty ring test, because for_each_guest_mode() only
> runs a single iteration.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Fix a semaphore imbalance in the dirty ring logging test
      https://github.com/kvm-x86/linux/commit/ba58f873cdee

--
https://github.com/kvm-x86/linux/tree/next

