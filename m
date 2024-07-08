Return-Path: <kvm+bounces-21118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D38C692A85B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 19:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C73B281C54
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64AF146A85;
	Mon,  8 Jul 2024 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d88WXj4l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974853C30
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720460732; cv=none; b=pHGJMJOGZuqZmo4rg6n2RrF/vmZo9dvysJfDP/263yY5kM1VRDKk+59VZrF1AeZNyIutvhQThShewYIEPq0Vxm32PFf1EP3J290owytVrwtvp2jP3NdFIQy6AGFrssBYx34Tyyc9y9khwYo5c4+qgWeZeuPeMlRdVvnelGsINKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720460732; c=relaxed/simple;
	bh=k4wAD/+adruccyHwOaQoHNi9Q0llBGyjMSQxq5Sy4/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W/1afI4tPvrlUXcSGnEJOO1fOrL7Gcj9evojGYVWoxcQddvqpQhZhKmNcB0KrVVww0+bq3AyXEdSSHx9G+hEKFeVdatKXcLKRvzM4M0l6tYcGVC5BOsisjRtHNEynIkEntkrIHn7uJfEWRj8DyNhCjLklGtLVOiXm5/I7h8m19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d88WXj4l; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70aff5bc227so3616123b3a.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 10:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720460731; x=1721065531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=af/2NixPGXqQu2+711IVVm33vpo8e62X5Nl0616t+N0=;
        b=d88WXj4loHbNEWB3QlKWiRexwbgILqvTFv4NuQjUczvEjuJQMOnkTaTo/ISorAPdf9
         gfNGbPvzkX7kX1ZpgLSV4VBQ+0GktItVpTAO3jFU+eIhVcyJNc1AlyVYNbXTFIre7ybk
         Qta4RoN6I0HC6GzhE/0rr+Ilw7FhpFEclAzCUO6NEyKJTxYpddoBA0LLzgfbbDz3ieU1
         88JbX22MZYmhENBmNX+tDpUj5D22D81gKQvwe07imC8LOJZYt2GCFPxFqgEsVjg+C0IU
         Sd2Gtel6n97Ag8WhIaDT/W5xMlXWGuw0+FLXAxm+o1twhnQc+MI/bN94FBABE7CiDnsH
         yUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720460731; x=1721065531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=af/2NixPGXqQu2+711IVVm33vpo8e62X5Nl0616t+N0=;
        b=QVLiViYQX83jgK/LEJvE1aoMVGx40nlBPnQXi16+UxasQmAIxb79rkXPoWEqErQPRw
         iYgHWEL/B6lCRtf4m2gqE3YJQG7Iv5KLbXATMwcytzOTz1MHielasZ8ubz9grnPnFL7W
         y+f7gRc1dQ4Xh28WMIhZIx9S73vvwIQl+wJgUsRJ5pbAf/oNgypsnGzmm4wJnXyCs081
         tmlm+kkeqiNmBMh5gKsxLt7Upov7x2ZN4H0WIU2JHKIuN0oCdDOqxmetoPhYgsQ3XKP0
         SVX2UtQMEElo00nntsWVy/8Owj/yZRggBMUbLvtoXcHzOIu7ZDLDprOCvdWOH59xdYfZ
         ZEqA==
X-Gm-Message-State: AOJu0YwG7NW2dg7flxh2zLtKzd6XZ1MuF2Wen8+4/EAx0Aih7RZVPLV3
	DoUIyOVwqXUzQYtlAsevHuziXQ7IiIWJFmYxUVONB17L3VonVDm+i3ZSbhGhdM3/AweD63aPArJ
	Czw==
X-Google-Smtp-Source: AGHT+IEkDQewAMyTGQZnBwj+vLYaiD+nM341MvQJQawdDBWcOwt55girCekpnrdk+t/KIANSAN2uswD5ZNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3e27:b0:706:3421:7414 with SMTP id
 d2e1a72fcca58-70b434ea4f6mr14943b3a.1.1720460730712; Mon, 08 Jul 2024
 10:45:30 -0700 (PDT)
Date: Mon, 8 Jul 2024 10:45:29 -0700
In-Reply-To: <c461682ef5aa422faf1ce13aab447b09@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c461682ef5aa422faf1ce13aab447b09@amazon.de>
Message-ID: <ZowluXkwYJjPR2mL@google.com>
Subject: Re: [5.10.x Backport CVE-2021-47094] KVM: x86/mmu: Don't advance
 iterator after restart due to yielding
From: Sean Christopherson <seanjc@google.com>
To: Stanislav Uschakow <suschako@amazon.de>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sun, Jun 30, 2024, Stanislav Uschakow wrote:
> This is a request for comment backport of
> 
> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=3a0f64de479cae75effb630a2e0a237ca0d0623c>
> 
> - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=b601c3bc9d5053065acdaa1481c
> 
> - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=d884eefd75cc54887bc2e9e724207443525dfb2c
> 
> for 5.10.x. I ran the kvm-unit-tests on patched and unpatched kernel without introducing regressions.
> 
> I'm not quite sure if that backport is sufficient since the d884eefd75cc
> targets v5.15 and the codebase differs quite between v5.10 and v5.15.

Why?  The 5.10 implementation isn't suitable for anything remotely resembling a
production environment.  The TDP MMU wasn't enabled by default until 5.15 for
very good reasons.

And even in 5.15, using the TDP MMU dicey.  See commit 7e546bd08943 ("Revert "KVM:
x86: enable TDP MMU by default"") from the 5.15.y stable tree.

