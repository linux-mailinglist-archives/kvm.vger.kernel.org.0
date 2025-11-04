Return-Path: <kvm+bounces-62003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C72C326E2
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14B7D460D89
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B0833DEF0;
	Tue,  4 Nov 2025 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y+n7BbBg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5957D33B94B
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278448; cv=none; b=tK/tMFncfvF3A/aKje7E6DYDKcTuCvxwE7HE+2+/hBn7+cCcwPb8C48sAgSugxqhAINRZlyUHwCCHA3Jv2BzA/V4hh8FLNMaV4UieslsGUS+YNc6NqPzMoWZjH4gsvkITMZjxdYAvri6pTId0ptjXwA6wK4N9SkTwBn/r7Ft8cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278448; c=relaxed/simple;
	bh=dhwqrT6S/LS4zUkJRE8UP3Y4qubDSuf7ZUCumB8j2To=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaWSczf8vdZYZhtqZsr0wzAO89OlayFqTs1XEmRjna4Dk0JFdVS/UE7MJVywImg/hhbertapzUOPJwToniTbahQPa/9gh5QciHcSI3eNrkI67AM7cVT06IIG9l8HQDFcGnS7ebFw7NrvhKqJ0nToo1X7YNRO/3RCdS7xYXU5mKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y+n7BbBg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a26485fc5dso5549048b3a.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278446; x=1762883246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9Rq6oMw8Rb0BnOC/V8XXpWWLQcsgDUDwspc39yYxKY=;
        b=y+n7BbBg2qwGkl7AZ3BxI/kHTRyi6Vx6WbpLjEMWlQ3JBa8mHqYgVGJdcRL266TLQ8
         03OMJ3SE1gTvBs3IDPqy8rNcOCIeJHVJNaZiBYX61QOZlNGxm6NUQ/V7R81mKGP/A9xo
         fvW+ZI12TeF8qIs9OtWomhtjT9pxMwcq+Ip6DEhgzoYg8R+anCCB8VJQ8nv6mcpdBleP
         j+suV617Je9w/V7XaC1eYHWSFYKpwNOXqeVcuY0JVaRjqg6OzyOBrRVNKS/BvdvWAOXp
         IIyZronM/6YszYTtnh/xTLJg1wFA096GGrGJxWuUPot/KeY7ajpjN0KJ0CIs9qjV503r
         rniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278447; x=1762883247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+9Rq6oMw8Rb0BnOC/V8XXpWWLQcsgDUDwspc39yYxKY=;
        b=G0X2zF1bWjjw22A2DdPNjIsTkhwpb4XRwSe+Htt8FrTXVguValUjVb2+sVmHoMySTa
         B+xmBvDrdwQVnrXFdF61BhDimgxdPklTksP8tbyb7poYPE/rJ8LFTfhvqu7cokP8JtHl
         YumGmflC8C3fRWnoGVgi7DYy9kjuaXRzvIHd0rkWt3M6EUWmoJtfeGW2ecPrPmX8K0OA
         AK/c69xpRRvCD9MBFtj/23WMwzDiefZJaFUCCPKdr6+HuSpgS55Nlhpcz2kQFZ7lvFo6
         xZn4WbWL1CMX3KAFlyDjSFctBH2w+4BmusrQtDYQ/ZDR5Q0AJhhqH7UOe9NBRKCM4Ebj
         oo+w==
X-Gm-Message-State: AOJu0YywV0dT6qPjSk3lgKtWUKX5VFURZTIXnchJAAF+w5Smbbqw0L56
	jgTWnTiEXtZdygET0JyD5//xnI4ASuJX6bZhpamPdIMpDKYQ5MU0O0zDa/hrXko2utoCQZCKcA5
	ctrJrDg==
X-Google-Smtp-Source: AGHT+IHx54CudknapTjqpUs7zfNGiPy/qu5Mmu7jpkq4hiNlDYxs3va+KkHlVpMQ+tU4DdsMuRGF6T4bSwM=
X-Received: from pfzz12.prod.google.com ([2002:a05:6a00:1ec:b0:77f:4904:b672])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d1e:b0:7a2:8111:780a
 with SMTP id d2e1a72fcca58-7ae1cb64ff7mr153168b3a.2.1762278446257; Tue, 04
 Nov 2025 09:47:26 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:12 -0800
In-Reply-To: <20251007223057.368082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007223057.368082-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227813898.3935465.839720915635160924.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Forcefully override ARCH from x86_64 to x86
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Oct 2025 15:30:57 -0700, Sean Christopherson wrote:
> Forcefully override ARCH from x86_64 to x86 to handle the scenario where
> the user specifies ARCH=x86_64 on the command line.

Applied to kvm-x86 selftests, thanks!  I'm deliberately not sending this
straight to 6.18 to give us a full cycle of testing (changes to selftests
infrastructure have been notoriously brittle), but I tagged it for stable so
that it'll eventually land in LTS kernels.

[1/1] KVM: selftests: Forcefully override ARCH from x86_64 to x86
      https://github.com/kvm-x86/linux/commit/17e5a9b77716

--
https://github.com/kvm-x86/linux/tree/next

