Return-Path: <kvm+bounces-57619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21567B58649
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DDE017E7AD
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A482BEC57;
	Mon, 15 Sep 2025 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vI46tAAV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A42E63C
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757970184; cv=none; b=K0ZBNnezcRKBuVSVpPekqbzD7O1dEE2LPlavyl2+Pfj0eL1yYRHsgG2q/fQy4gmhMWmgTO0Xcd1aW9oMw8F2NKh3Bu6tHox4gFH2zlsGqzwE0EXUMalSPQOV96roMvKjnKLDte5LM73gCWz1MpANbj4BdJE3sRI71uDuofgGMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757970184; c=relaxed/simple;
	bh=fTSNHZAQcFYsYv6n1G4GxZktpGJ8qsXioj7qp8jjd+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=FBUM7+TtU5CDdpP1BG4PXd9yBFxY5mUaKGrwpyey8bLE5MRiYdABFMhhenGYfAu+pHuQrkdHG6wFhRkOvCerMXAZzt+E3dojSMEwO79rVM8OX+cUWo3wBlTO28xATNB/A/O1JpK/0c7JrPZqPsSV9HxOx2muVia1HLwvdAXfAKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vI46tAAV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-777d7c52cc3so2762961b3a.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757970182; x=1758574982; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RxwTdZBEmt4jtUv/E6BNSirMqJUJGOYRGh1YXveb5WM=;
        b=vI46tAAVGlKFMbbrbWTw8o5gmnIlmjQSeE/qj3dAJXeWX5EglJxVraiqXFaDSFrM2y
         eRxg2hLVD77CHXL0ajYmPvyJeSLHLe/kyiRsdVwGzd9OuAHGD+5BYJX2xRULc7B7QGQn
         0evkDPB5+SVyO8lUxiBM+Z/3r6Fu1G6/vbr+ryVdWWEku2LhMy0/rMPUyAHUswDNPn7Z
         c/drTUZrzy5jsQyYEXNv8vLEHytG+iptdNBNr7YKuA03m+xdiW7UrDB4ErOSwvj7d0ki
         8Y4242uF5DAKHHQ5VuI0RU6Eu69IX16iRzHL7yOIYEOncKdK9C0RaIC9shHHYJKGNhi4
         YHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757970182; x=1758574982;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxwTdZBEmt4jtUv/E6BNSirMqJUJGOYRGh1YXveb5WM=;
        b=gAU+JmqK9vibtcecqABbLszn6xD+UXtKO6LiYMbXNlmk1VWs5bmSpKXRCibRgcOSp6
         13wtQtq/GYzOdbZ0g+kWuQGW4a8LDMpHA/J+Hg3M6mra2jQ0k8bFhirQtUw9Szzev7n4
         2jmAs/5EdMw+H4p2HGGjEcZT8/itSk5WJXftfg2PN1wFhSeBxS7SCkTvQ7vxy17ztpbY
         QRixPx94Nzygozei7htwvRPPoJ1rZf7+tXvY4vlgQGiGKLodDjigvEyZURdCihnISYQs
         fq+rw0QYt+VZ2KEwbQqFXiB/fxRYoXABGiflALGcnTvLf8bwRhTJB2+SKZdsIZQ5c9XK
         Oz5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPN55x7odWv2tmvuj9D+CMcE02timUcC0nF1iFBXkuGhPMuvNqlzw/1JDcGmirL1kzUpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA9iCv/bLjdqT/J7vTOxlr3bXg5wdk4rhCdwmcuzMr1H8GFiJh
	7v7eSk5OuIEedhTH8bOH7EP3kwK/s6xr9QQiQxPZPSuCOIM22lGrhiLRn9ayviJR0ZyUjkod9gr
	FooagfQ==
X-Google-Smtp-Source: AGHT+IFuSpiuKJG6P8l3wSHwKGYEnnc3OxEX+l/ch1UwznTqKr0gm4ilazi12JKz5vJTRzZBy222Qo02Nhs=
X-Received: from pjbnw4.prod.google.com ([2002:a17:90b:2544:b0:32b:65c6:661a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734c:b0:24e:c235:d80d
 with SMTP id adf61e73a8af0-2602c14454amr18045793637.49.1757970181895; Mon, 15
 Sep 2025 14:03:01 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:03:00 -0700
In-Reply-To: <20250827194107.4142164-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com>
Message-ID: <aMh_BCLJqVKe-w7-@google.com>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Sean Christopherson wrote:
> Michael,
> 
> Do you want to take this through the vhost tree?  It technically fixes a KVM
> bug, but this obviously touches far more vhost code than KVM code, and the
> patch that needs to go into 6.17 doesn't touch KVM at all.

Can this be squeezed into 6.17?  I know it's very late in the cycle, and that the
KVM bug is pre-existing, but the increased impact of the bug is new in 6.17 and I
don't want 6.17 to release without a fix.

