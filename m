Return-Path: <kvm+bounces-16369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AAB8B8FD8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B70D1F21C78
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481921607BC;
	Wed,  1 May 2024 18:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SbceQ6NH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AE1146D53
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714589130; cv=none; b=FjO2ed+QmSvzeFn6XUBdQ1VZL3TLbd8Lkffu/3q5DMmqq8Ou4h1ynEw0mOEgRQgyRBdOAD44FqOb01HzlMRAUTQJdx0vmhKX/y63BXi7KUWhTvAiQnF7DDtgI7jx7T4JaJO45xYetsz61+X8RSiYCd83L/AqjYuaWftkOrAUxFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714589130; c=relaxed/simple;
	bh=CKht8bznP+UrF9kl+MNPOitTbYsC3SPRd8wkazD2v9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I0mq4xgmfkjc5RSvz1ex5Jjo+Q2z1c0+JOSbQ0JeWp0vq3brG//e0sJ1yEB1qagK0s45k4akG7C3xcOgM0WYrB7UF75SjvGQb3JcbLge5SbbqCQTQE6A/MWm8JCJQa3eiECdpFCStGck6pyFztW8D13FcJtoV0bM8lqKYxeQZ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SbceQ6NH; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de54ccab44aso14631572276.3
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 11:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714589128; x=1715193928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4bH1nuvxEqAgawnP6q/iapzLLCUAYNh0OeHBy6uBTGA=;
        b=SbceQ6NHANLsrGwRCT5ojuOB5bJgEpMDWI2gQFCk+sD3rpANkACXDBuwvHaNMTbIB9
         EVrlZNPxp4i/2B3WWjKHQrpvKF3Qnxb6JhYr0nfq8dbTvNNA4/DGPpcx4cQvRd1kr7Rf
         fxFzCZREULBmglqMj0H7qamkelvJe9SweONXL9EjixL11hR+pEHLENvVnvYGgJaOQlLy
         iCtaQqRdNvt4k/8oE25t2ENwfCu12kPTlinA/50Q413k8azsJcw/5S+Xm4yY5anUSDCT
         1zLD/cpiCYM7H9pMl4dy+Q1wuc43ZmURxk1QsvblVGHRADys1P5laIXpXHBXgSmKyevS
         3A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714589128; x=1715193928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bH1nuvxEqAgawnP6q/iapzLLCUAYNh0OeHBy6uBTGA=;
        b=QjPPBBNnnj4KGgiH/mseghmcDyLtHaYmOmYdyHIQ3LTqlKDPrkuO4c/MIj8MENP+wu
         yJJtinIZ2TbpkoX4KK1EbdxxvB2S8QnSQeVSq7Ja126Ea+kC9Ajwt71jurm3UDsZpu1x
         cBfvVQ0Ikm4kY3TefoiEbFHMq0C7BBqCLL1t9oqgU77bLuxbyzF/nG8mt6xmCyTa5yxo
         pVWOYqQdyiml99HRRbhagiXI//h3wkp5EpT3I+tRa3Jp4EkVI6WlBIShrZOybLru5q7N
         vKRQGili0Wo3I/1NgAy1ZPQC8ZD+W1AdKpQHTce3fv9jSxDrKF0TPIG0TnRq/66RKAI4
         1UGA==
X-Forwarded-Encrypted: i=1; AJvYcCW6xzW7+WPHByE+6iYbLagsy6LB8FWddLfwsTlx95W6DBODCmggOm9X83MqFXA8lSD5WYLZhDNc1rmmnWdQfi0L2yWR
X-Gm-Message-State: AOJu0YxpY8z1wBVyqoObbCPZjXRgkhfB/dGt3+U8nOEDbGHMaHbUpAmb
	qJtkbfFS7VdExOPuM86ek7JOLvb8Mjxf/J2GlvdLUzRVqRQwGJ3iHRaJWLxz+eTqGmxMjRZ8y67
	ywg==
X-Google-Smtp-Source: AGHT+IHPZlT/rXriMsZSarLntfzWBGiGG5X7zn3dhED1eI9ACNPDW54s2YOj5XuX8BkV8xtoww8NyMh/8oY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d2:b0:de4:c54c:6754 with SMTP id
 ck18-20020a05690218d200b00de4c54c6754mr1067004ybb.3.1714589128223; Wed, 01
 May 2024 11:45:28 -0700 (PDT)
Date: Wed, 1 May 2024 11:45:26 -0700
In-Reply-To: <20240219074733.122080-5-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-5-weijiang.yang@intel.com>
Message-ID: <ZjKNxt1Sq71DI0K8@google.com>
Subject: Re: [PATCH v10 04/27] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC
 xfeature set
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features

I still don't understand why this is being called DYNAMIC.  CET_SS isn't dynamic,
as KVM is _always_ allowed to save/restore CET_SS, i.e. whether or not KVM can
expose CET_SS to a guest is a static, boot-time decision.  Whether or not a guest
XSS actually enables CET_SS is "dynamic", but that's true of literally every
xfeature in XCR0 and XSS.

XFEATURE_MASK_XTILE_DATA is labeled as dynamic because userspace has to explicitly
request that XTILE_DATA be enabled, and thus whether or not KVM is allowed to
expose XTILE_DATA to the guest is a dynamic, runtime decision.

So IMO, the umbrella macro should be XFEATURE_MASK_KERNEL_GUEST_ONLY.

