Return-Path: <kvm+bounces-25153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A6A960C77
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA1C91F22EC4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC311C2DB6;
	Tue, 27 Aug 2024 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zg8a6Ff3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777251BB6B7
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724766338; cv=none; b=BrV6fnRwjsMwhRdVqfx0HNVvNB1kbAW+xKxA3u1tb5W0ZKcAEFMXO6SPVtDQ2PqdOxFvDt/pjabsATTedQwoR5zZDGwroBn5YDC0nDZe1zlqQlwOQOrxvBZJAHoA6Kgl8jNxiAbmpOpKlM2adqKdCIBWlaQBVub+Cru338imOkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724766338; c=relaxed/simple;
	bh=P10v92Y5OY4yMPDagH7+DfoNERm1wQ9KWSkRvv0kYWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FQZASbm61Ta9IKqr815Ejk7Blz1g757+s96IzBP8v6jTOi81fru+tG6lhdQ9Xyt9CCbE322hQ+1luCUf0z+tQTt1Byiyx/0mH2Rpe0lkuMqI3rwY54kL/QGKDXb+R2AcnrSYETF8PF8dqXvKTvfN32l0ZfpnuphMkVQ3nJzC8bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zg8a6Ff3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3e42ef677so5625342a91.1
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 06:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724766337; x=1725371137; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=98L0ngAVPWuAI0+/Dnw64oBuh1ZvmrAGOn7Cl7S6mLQ=;
        b=Zg8a6Ff3/PySQS8Z8xMA3+qVL8lM2xIDrfosm0VnRCJ2EYVxXUbFuP9tZjRzKolDe4
         Twjvyk7sJA0h64vcsb6tcekJQzCVKYm5A2fQ32Ma6zyvyEu8s3KAGXZPFbYWSvTb9wJy
         H98j/xgvVly1YtTtUjlltBFkX97BpJb9Spb76MnKliKxnrihJqIHNPLqjxhZjzxkrLrr
         nf3w5apHq9O9IPd0g4G3lsy4ca3MAR5mPjA1T+mZLf82Nb2DQUY+3e5cvjfDEeF3ySzt
         AJLnS6Hq7OGYRuZaBS/yOBSP+xjuIBsUZjKYrMIFMLnDbwCC7HrVAocbcr3k4Klzdin/
         /WIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724766337; x=1725371137;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98L0ngAVPWuAI0+/Dnw64oBuh1ZvmrAGOn7Cl7S6mLQ=;
        b=RtjscfUkji1z4CM2d+gQ+COAzvboyKMJAuIqKfbSVK0kckVhAA28t9JYXR2G3RaDlf
         zjIzgbtEfjOtaYQWNJw0FdoxWO/qI8z34dvYiWxnJI+JNF7YHqnagGkgJWPJXPHMBWKU
         uQgerLWhnSxIwjipkO77K+7wJekUI2GD/JDq5WVqlgfA2oWk6NiQEplvXqQXeRCLXH1/
         BYKfKWRSN3KSiFQ/wyP6LNTM+u/I7WPJP69NN6LITr7omITmKIY1Og+gIWg7pPIsDsd/
         8GCu1BLl1TJeS7aQsMXNNb+lx/ypR5PUjCoeWH9+lUgf4AYkZC7N7q2UcIBBc5POVy6a
         rviw==
X-Gm-Message-State: AOJu0Yz1wU9EDSvJ4EzohJpx+lSBSV30dY50k+dGV9CjltpiAFPL8O4x
	1QcbliF/Ckfc8skFrjQRuWpJ7R1SVmLz/+ThKUewAFM3+2CvS4J57SGw73c60NZtq0N6ag9i+hJ
	6hA==
X-Google-Smtp-Source: AGHT+IHkBGxlZ7/1EKiWDdxo9MWg7ZJfZHR7lNOSM7zVKpdMjnBib/iglEwC9UjavpwzZuOZ/tU9l79pRQM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3147:b0:2c9:9232:75e3 with SMTP id
 98e67ed59e1d1-2d646d3f25emr44953a91.4.1724766336462; Tue, 27 Aug 2024
 06:45:36 -0700 (PDT)
Date: Tue, 27 Aug 2024 06:45:34 -0700
In-Reply-To: <a6868d49f658ee8f935aee4910696e817b0c4b92.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240718193543.624039-1-ilstam@amazon.com> <172442195625.3956685.13979535644680422623.b4-ty@google.com>
 <a6868d49f658ee8f935aee4910696e817b0c4b92.camel@amazon.co.uk>
Message-ID: <Zs3YfvqouduN5S2V@google.com>
Subject: Re: [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, Paul Durrant <pdurrant@amazon.co.uk>, 
	David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 27, 2024, Ilias Stamatis wrote:
> On Fri, 2024-08-23 at 16:47 -0700, Sean Christopherson wrote:
> > Doh, I applied v2 instead of v3.  Though unless mine eyes deceive me,
> > they're the same.
> 
> They are the same indeed.
> 
> I'm not entirely sure what's the recommended thing to do when updating
> only some of the patches of a series, whether to send new versions for
> the revised patches only or resend everything. I opted to do the latter

Resend everything, as you did.  I simply messed up and grabbed the wrong version.

> and then I called out the changes between v2 and v3 inside the patches
> that were actually modified.

FWIW, I strongly prefer the delta be captured in the cover letter, though others
may obviously have different preferences.

https://lore.kernel.org/all/ZQnAN9TC6b8mSJ%2Ft@google.com

