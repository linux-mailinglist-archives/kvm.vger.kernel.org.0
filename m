Return-Path: <kvm+bounces-27797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF9798D389
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 384421F23273
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 12:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FD01D016E;
	Wed,  2 Oct 2024 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XymcDe+1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88501CFEDC;
	Wed,  2 Oct 2024 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727873035; cv=none; b=qwEYh2ZNusL7z57LA0QHut4K6d+yDkOtNlXoYaDeMDw9uANfQqx+pLQmp9yKpIyZvMTMNmG7R4h9fWSWOXFUeYg/vX833+uB4Ai/nZsxD1Dg2mi/5Uu3AmnwMz6SkVttheK5wq7RatmgWypXuBhSI20lDWM0P6P+9u45S8QNFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727873035; c=relaxed/simple;
	bh=H9JZa60oS8czGhwYb+NiigG9iV+YG7miaELjImNvhww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OaYR3QUahODxZ6YRbthgKzJX9+eQRKAiPT6XZfeqiKzzc9pliHJFxVd7PTJ+qjKi40xoI0mZ0eaDngou+R95eL8NLWzwvl6OUAcDtN2Uvl+3VOlwP7W9mFvvM7LuDMU2joDr+AVL4gWTMD6zK7J0Kx4n+8pUOyClNPq/MuA9E98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XymcDe+1; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5399651d21aso2927372e87.3;
        Wed, 02 Oct 2024 05:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727873032; x=1728477832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4rRP9G2d4blqaziKnLUwRdGOQLKxycRahTh4PRhM00=;
        b=XymcDe+12IueEwncLZwwbf+wDww7KedRfoV/d/zd6AqaUWGzDFeBFYgN/cOP4fX2JK
         7tLzHk9cvvacZzlBHhvsGqGXcksU3evaqfrOTce7SozQ0iXgnGrmXqF18LtTBZp7YIiS
         sBOz8nn3yfTq8h8qcNKN3iBkHarbpKB6owlK7kREcOjYolndWpPKppv8rNckdZR0odbr
         listHM5ZPxQZpNJ77v/H/IeHXkRDkPJYJnvbvnxJ1qlKPdU7EsTdcQY7cyRq8w1YPK5R
         i4FlRwUtS2Z644ZU3/9Rjbm2IUr2wTR8ZufgEfppXBREJ3B6wAhW34bdZ49UAObXunw1
         bPfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727873032; x=1728477832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4rRP9G2d4blqaziKnLUwRdGOQLKxycRahTh4PRhM00=;
        b=g5Yzi0AA/oiF4FjWZXfsNFHij18p+Q5sOJ+ATQMsIXpBIzKfwU1ttveJjiFd0Q3XaK
         I8r5izwZIHjw8MDlUIHXEzY9Ag/ukD5pDd1h4gkG752bo4mQu/e+0pPVK89J8vjaM0Vw
         54D4MLvzTfSQVJjsMQabrv8XTd54zUHDLz8wch3mlkEuNVOV+kniVqHzeHXbXmZT+YAW
         jViHM2SRwp/3ANGoIQQK+5Zc544nsGGkPrbmpUr7AqzkVyWHNHqcgLbnHhHkyu8/2stL
         8bFjbxbv9NrPHUvQ/qUcKzoF+jTBNxGsvE389FEkU039W/g4IohdV5b6oFc+NVA4oaaF
         geIA==
X-Forwarded-Encrypted: i=1; AJvYcCX7pZvl8DlaIwVipHV9VDio8IK0pJfg+H19T7/A3uJx8Mm1clye19ATJh9P5qhA98Qg76kkoifVpAB5xjrM@vger.kernel.org, AJvYcCXvtd0GBsa3cCjajcP4wdHY0NKSzfSdoPPCJ9H77tJhnb27v0V5s3nivYcFlS8LMfVVbGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx3asnJ9wyjLnWqceF6DSC5enyiD8g/TqOUgJnJY1iiccDz/Fn
	w/JVqMozEMYHm/7By1kshWXchPTNLLkyWjDhdX2HCwBsAInu61m8bGRBHa/D
X-Google-Smtp-Source: AGHT+IFJ6S/Dt3QrEpPziXf2ZDgYJ9LHH8Z9j9VYvQ/c0Kv/o+GV7SQ2mmB0CmuDWqYPZqH5O1LOOg==
X-Received: by 2002:a05:6512:400c:b0:535:d4e6:14e2 with SMTP id 2adb3069b0e04-539a068590bmr1637458e87.36.1727873031492;
        Wed, 02 Oct 2024 05:43:51 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-31d3-dad0-4a4b-3d13.rev.dnainternet.fi. [2001:14ba:7262:6300:31d3:dad0:4a4b:3d13])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5389fd5df91sm1912604e87.82.2024.10.02.05.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 05:43:50 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: seanjc@google.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mankku@gmail.com,
	mingo@redhat.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Wed,  2 Oct 2024 15:42:56 +0300
Message-ID: <20241002124324.14360-1-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <Zu0vvRyCyUaQ2S2a@google.com>
References: <Zu0vvRyCyUaQ2S2a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Sean,

> On Fri, Sep 20, 2024, Markku Ahvenjärvi wrote:
> > Running certain hypervisors under KVM on VMX suffered L1 hangs after
> > launching a nested guest. The external interrupts were not processed on
> > vmlaunch/vmresume due to stale VPPR, and L2 guest would resume without
> > allowing L1 hypervisor to process the events.
> > 
> > The patch ensures VPPR to be updated when checking for pending
> > interrupts.
>
> This is architecturally incorrect, PPR isn't refreshed at VM-Enter.

I looked into this and found the following from Intel manual:

"30.1.3 PPR Virtualization

The processor performs PPR virtualization in response to the following
operations: (1) VM entry; (2) TPR virtualization; and (3) EOI virtualization.

..."

The section "27.3.2.5 Updating Non-Register State" further explains the VM
enter:

"If the “virtual-interrupt delivery” VM-execution control is 1, VM entry loads
the values of RVI and SVI from the guest interrupt-status field in the VMCS
(see Section 25.4.2). After doing so, the logical processor first causes PPR
virtualization (Section 30.1.3) and then evaluates pending virtual interrupts
(Section 30.2.1). If a virtual interrupt is recognized, it may be delivered in
VMX non-root operation immediately after VM entry (including any specified
event injection) completes; ..."

According to that, PPR is supposed to be refreshed at VM-Enter, or am I
missing something here?

Kind regards,
Markku

