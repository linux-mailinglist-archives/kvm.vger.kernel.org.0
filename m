Return-Path: <kvm+bounces-57639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8505AB58764
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 750F33B3FA2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E431D2C11F6;
	Mon, 15 Sep 2025 22:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QtxGXMF6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A5F2582
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974968; cv=none; b=q0FWX+fdRyFvl00qHz5fnXvfx5eyUycGRB/75m0T/iBJP5LVhvdYRRc9rh2iV71Jv+26U+2KYS8yqnw05XdX5fo1AimXYUpXasPixNFffySQzKGGCnMMvkTDRfgkHtqFf+ZXP4DRiOXr2QxKXgmZFmYlLER2fsLnKO0JLmHNN2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974968; c=relaxed/simple;
	bh=2JPORVW6LXTWz1WFLkUTMz20Mfpc+OepdHOpLzAybU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D9si9cRP53U+PfdU24I0kCV47cUjQv8/F+lE5di67n3SdYzYvcYXLSzUoLUaOH8/V8mvqpqdsV3nyEZn6JW0dI66Gd9QIxq4hmJ8O2ahPZP96oiR8rWngWH9Fz0pRyZ6MCll98m3834YIKLEvCuuHSHGBXI91eC14t2cwbhxubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QtxGXMF6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471737e673so6275396a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757974966; x=1758579766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=54TM45a+t9JSioXK38Ar3BKPrMiJwoyxvjFtErXC3S8=;
        b=QtxGXMF6eZjqjgMMoWm2G/biyAGCc8Ha49yK0cA+fLerw4dwUvgTWV96HzPA41oVA5
         C2vPM0OUx6tAV0nWA10PgStiOs0ohdcEBxzrxTHawChwOH9O+0y6ZYKmD0Pz7EIf7b/J
         fMywBr3De7DsYGKaR32W+ZhKFUgUtLEstvadHVIwSpAaho0WnAW1+RkPoG6/XklEHSQ2
         d2XeDWQV90CEr73ViWGMvnFMgEcf0YMlXlHNQqF/4UsRv3eZ5EYfFtA22r+uHmTx3IVc
         S7IzZFMuoPBqVlwcBq/H0BRNU/BR4wXdl8mx7pxilV+9TV0C4lIbfpMGfs6aFCnCdfm0
         EFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757974966; x=1758579766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=54TM45a+t9JSioXK38Ar3BKPrMiJwoyxvjFtErXC3S8=;
        b=ssHiSIM/2tvAM+fu+oeERhHZbKF72bTbrbC5c7FP/Y1n2GWtKQwV3qnkgSdjgYGdPF
         EAVWhITeZEvwVbMhDpSLHAvON0M5FuvRiHoqBdkxVfKt/lP1zBuDNCYWBCNYjXB4k8eg
         G99Roa7+0RYC6JecfrGsJ9jR2JWsCbrG9glZMJ4Ki247DHALG30vpAQ9JBBu2Mpii+c+
         r2urDALrUDa5kGfS2YZJgzepTIgVCD6N+P3yywVn1QwN5LtRJGzKuNtoaTZI9B0HRw6+
         9TM7yzpX1FbeqDS4JTAPkObtXISgxi6HVHR+bI6LkTyZV4FJzqNsFv9cQJ3hLMJtIgOQ
         OO+g==
X-Forwarded-Encrypted: i=1; AJvYcCUEUUi2GKj4+06Te11mzdl6B/rPk3fXG3Bos65Ja1oZughgi/Ve7jChPzXSBzvN9g4t1sc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5CycyyPZ9Wc9np/O0XVRb/wqjnPP1TXB1lMEBDvoC71FIHUVs
	LwfpMf1MHe31xFp3ihUnieQWBRR73t03En/7nBd9SiJqyFNWz4scsNOXb4L71YhhAWKIbsCeulO
	LJfikjw==
X-Google-Smtp-Source: AGHT+IG4lyuAi+DdqkibJVbiXoSmhtBXMMowLBOZ3P1nBnHHcYoImlRydjxdcA5I2ROW09yHYzJ1IKE8fZ0=
X-Received: from pjay9.prod.google.com ([2002:a17:90a:1549:b0:32e:a3c3:df27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528d:b0:32e:358d:6678
 with SMTP id 98e67ed59e1d1-32e358d6fb4mr7344770a91.4.1757974966082; Mon, 15
 Sep 2025 15:22:46 -0700 (PDT)
Date: Mon, 15 Sep 2025 22:22:44 +0000
In-Reply-To: <20250915182018-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com> <aMh_BCLJqVKe-w7-@google.com>
 <20250915182018-mutt-send-email-mst@kernel.org>
Message-ID: <aMiRtGJbx9ZHWDbW@google.com>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Michael S. Tsirkin wrote:
> On Mon, Sep 15, 2025 at 02:03:00PM -0700, Sean Christopherson wrote:
> > On Wed, Aug 27, 2025, Sean Christopherson wrote:
> > > Michael,
> > > 
> > > Do you want to take this through the vhost tree?  It technically fixes a KVM
> > > bug, but this obviously touches far more vhost code than KVM code, and the
> > > patch that needs to go into 6.17 doesn't touch KVM at all.
> > 
> > Can this be squeezed into 6.17?  I know it's very late in the cycle, and that the
> > KVM bug is pre-existing, but the increased impact of the bug is new in 6.17 and I
> > don't want 6.17 to release without a fix.
> 
> To clarify you just mean 1/3, yes?

Correct, 2 and 3 aren't urgent.

