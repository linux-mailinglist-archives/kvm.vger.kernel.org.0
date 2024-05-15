Return-Path: <kvm+bounces-17441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E25AB8C6999
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D92CB2192C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEF4155A52;
	Wed, 15 May 2024 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tw1B7+sV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C6315574D
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715786635; cv=none; b=B1ATA4kglGHnZzXmV7PqDYXJgjm4ntLD0tX0xTunH10jA3L9TrN0clXFcvMPBbVKKDOJNpVU1DnrWyDDAnTkaH+mfC8yFD2Jrwxvspcv1XJfJrbZhes8dSG9HYCL1gFe8G20cV29LJEwgqLm1VJMWJimCffBVUYQtwnqthgWHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715786635; c=relaxed/simple;
	bh=kU5haLDUlfgVHXQJnqJgdAkMMg41tQYnmCEL6k+6oDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=haBBB5eTOK9t/OIMN7F+K067i7l5KuO/+5OQfCdhgu/ek7GA9ZocFlP3FYVwxSrm/ndns3TaBIpQ0HMILEGFs3kEmZmIDQYxpY61NctVhW2SRCbuhgtst9sZi6mXKVYtJg7ABjKRoFAcI40c2j8QwB8eRf+PSWHVMvUkkR0QFR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tw1B7+sV; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b1200cc92so122392257b3.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 08:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715786633; x=1716391433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/vj1A9ui2SaRE/HWTW3nQNHcmp/FHeI/IPRLs6zsaMw=;
        b=tw1B7+sVFtLjslTi3HDAnFYd1iIy8cvWIarH4hCGkD6J92zscbjwLbuYGsatzPX5Cj
         KEnvLeIfSFgkSvKV/HiWjOFpFi2a2ELVLN+x2CHivUe0BjRn17aRRVqZhpcWFL8W2dOH
         57hVo9YNpfD4+ecY6Hpd1KsqbLuUezwfptRqO0sBtYHIHW4kt1Rm5bWrpIh4Y5enZHRj
         jrBrr512YcD2J/cKhbaENhvJu5cozKwDZqy6jk3e1vr/LEESnTO9bJg3nN3t/IEvy9v1
         +dabm4c3g/Qgu+DT9rjQrBCLZ2Y9mwgcT8pj9dFyQJzs8pm1I5UO78yQq7XZno5j/13N
         bM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715786633; x=1716391433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vj1A9ui2SaRE/HWTW3nQNHcmp/FHeI/IPRLs6zsaMw=;
        b=uE8INEOWOmSL0qCzagSeJUhXUEYm1ZADFLKEi7DSoE5BbCYsKIwTq1l9TQuDNfDzwv
         Z9wo9QZi+NqnJ1WS7RoYtba0dQAIn761qnz9e8tQ2lO6/fW4SUt9xr8dFsWgdT61otrq
         E4SsKJ0Jd/Epj1uqWeaaGLTlmLIpP6ttYVTtB9Ya1vZvx3yQoPDJKH9TcMW2nz49p7jp
         Km5mbbi3cdWzJ3FrH4JNaS2K2Vd0VteyxV+UdMscbzgYVPvSoU2SBMXvtkIM/qQUEZ2h
         DfNyXFCf2WMKDyrkscsdstZ7EG8TTTpcrp6MChTjO7xdx35LYZPRihXxk1xz959Ak+hL
         lVYA==
X-Forwarded-Encrypted: i=1; AJvYcCVr35pbQiZH0n1Rk9utNWAiASB8hsOWN8HQjpS9oihrn1Kq8hzs7hdsIKl8LxvKWIGgqHPcf/AdPYa8AoLhnusccJ7i
X-Gm-Message-State: AOJu0YwHlEGFb9VyO4a3HqtvMMWqAwfC1oo8Flm6nFVB+Ia4t6VPzPwq
	kWMr8LAeE+ppWV4eNd/scJzBWy141GNugdNcL7jP3hesEhvedmcnLWNkPNra0wlvj0Sk9jaujF7
	Vog==
X-Google-Smtp-Source: AGHT+IHYglKVcDSO/IWQfJ8xI8dVwMGpQ0/ErI/yxeFoh8tCkNXcyH0VPfrlyu4AmFvEBSdW3dgM2ePXTNA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:dee:5d43:a0f3 with SMTP id
 3f1490d57ef6-dee5d43c91fmr3707898276.6.1715786633444; Wed, 15 May 2024
 08:23:53 -0700 (PDT)
Date: Wed, 15 May 2024 08:23:51 -0700
In-Reply-To: <5547dd176122865e6a13b61829aa9c4b6cc21ff3.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de> <5547dd176122865e6a13b61829aa9c4b6cc21ff3.camel@cyberus-technology.de>
Message-ID: <ZkTGhmfF-FYisKL_@google.com>
Subject: Re: [PATCH] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
From: Sean Christopherson <seanjc@google.com>
To: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Thomas Prescher <thomas.prescher@cyberus-technology.de>, 
	"mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Julian Stecklina wrote:
> Hey Sean,
> 
> does this this patch go into the right direction?

At a glance, yes.  We're in a "quite period" until 6.10-rc1, so it'll be a few
weeks before I take a closer look at this (or really anything that's destined
for 6.11 or later).

