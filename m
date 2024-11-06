Return-Path: <kvm+bounces-30967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC01D9BF173
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6D40282E2F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8612F202F84;
	Wed,  6 Nov 2024 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdySeG0O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8DB1DFE3B
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906437; cv=none; b=FW5ab6vV+UmyC6Qx2SaYQzi4oVYHWkYFTw5ok17jvUealt8SSNqVoRudpX3QBHN3ROjE0xOwT+jhMHAHECdYkkzEUU+cP+ZGMi3tIcRkzEsPCnjIDt/V1Lq4QtnaIRPHMvMw1nswDdk8bdNiB6HKb19Ns9aLU8PXjpQ5WCwL4sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906437; c=relaxed/simple;
	bh=ILql3NzP/rngGHp+yWoMeyK6TmIIYBndwUyQh8CiBUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PvUrbC6QN6S8suEyGr4ZGf0sB3IWozi/PjtaNR5/lL36GPSVXmSfO33vL5a3HQCJPgwdO28LNTReaTTGfZqohSmcR8ILSslN7nKMEzuKZ5ENYw9DIfZuGaUwcMgF4oKHUX0KhjjaZxUeK1LbpqK0dVdbEpqJO1ii72/0JiLU4Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdySeG0O; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2cc47ce63so6540040a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730906436; x=1731511236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hG4tCYRFsSYdF7QUgL+lGN2NxaX7r7Qgh1HNcESyiPw=;
        b=QdySeG0OeaVzDzLL8XW7dGsty3Jx1PgwObi39czfgZ3sSthK9rSRYnho/KSGF2FnBa
         BHgzjCBdKtsspY35RE4jn9w480UIm5d97y+XnXkJQr/W6DWAkyWUpUFtywE8eJQu0sB1
         DSChEWB2UqTO1tskmPROJTtVaOKhPZIQZ0VEKE+AFYPYfeTNN7htAMrQqoAbA0woDhNZ
         JhZ57Wa2Lo0xnhWr9sdWE6pOPSinJWYBrdLlyZSqKYtarpIal1NjYOtf1inutRWgx/YM
         rgpLQjvpL1NiiJvgpl8oTOkv2ep/86KbBSKT8foOAr0OhjqXTLCgK9WewLdEPxJipxVc
         Syig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730906436; x=1731511236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hG4tCYRFsSYdF7QUgL+lGN2NxaX7r7Qgh1HNcESyiPw=;
        b=ip4sRSqOspsQO+2rP4RIKflqlBu7Oi9XYhHqGS5GFY+AsURjDGzBoQuR77Nz23SSwc
         yMs83X2JXkI09ds0ZdNO2+mNv/cXrSPkYAbX91Fg0htFuqKJuJ9fOSTetrXtC0S4jYjL
         LtjUQXXy/84pkDCSFaEUwouUkj3+ljd2T7szck+d6nzSAjnHrC2/zJeGo8e48Odviz19
         /c5gl5E3AItqhMlbZ6wyjdms67vOaQKXzIo979geKGul8ZZJV1LwOz6WPtpzXc7HoBde
         8VZo3oybSgZGMS4/SKhfnTtMA0/J1kN/k01K0nsOxQPErTit7qeTU8ElPIpLqW61j3PM
         JRcw==
X-Forwarded-Encrypted: i=1; AJvYcCWFyC/1STjTVv6My3e9wiCp+6uSWi1QWVQSACsYbqfcdRHcwp0Ds8j9lPTtk+TCGEPVCKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQwAvDYuaBK86d2Upzl0Lqf6Yuqad+BJM8aUG0qEIc69nV1fBk
	V51G/Yex9rD5pyj4irqUMkfjs8aVPNtIUSx8yp2zlj5wvsL7K2sp4bMzI4HCqM+qhYTtkNOlAUR
	elA==
X-Google-Smtp-Source: AGHT+IF/ZAHKEzkzhdYm1/o5YV26Ze1DiE96d6gldLJUs/9GOrRfh0iu32XwGysczT5r2hjIZk0Lyz53tlA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1943:b0:2e2:af52:a7b4 with SMTP id
 98e67ed59e1d1-2e8f11d0128mr81851a91.8.1730906435729; Wed, 06 Nov 2024
 07:20:35 -0800 (PST)
Date: Wed, 6 Nov 2024 07:20:34 -0800
In-Reply-To: <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241104101543.31885-1-bp@kernel.org> <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local> <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local> <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
Message-ID: <ZyuJQlZqLS6K8zN2@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, Borislav Petkov wrote:
> On Tue, Nov 05, 2024 at 11:18:16AM -0800, Sean Christopherson wrote:
> > It gets there, usually (as evidenced by my response).  But even for me, there's
> > a non-zero chance I'll miss something that's only Cc'd to kvm@, largely because
> > kvm@ is used by all things virt, i.e. it's a bit noisy:
> > 
> > $ git grep kvm@ MAINTAINERS | wc -l
> > 29
> 
> Hm, ok, so what do you guys prefer to be CCed on? Everyone from
> get_maintainer.pl's output? commit signers, authors, everyone? Or?

I prefer to be To:/Cc:'d on any patches that touch files that are covered by
relevant MAINTAINERS entries.  IMO, pulling names/emails from git is useless noise
the vast majority of the time.

