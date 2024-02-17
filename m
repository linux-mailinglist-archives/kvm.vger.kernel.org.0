Return-Path: <kvm+bounces-8940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AF6858CAD
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59D621F22687
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BF117727;
	Sat, 17 Feb 2024 01:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pU9NiicI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D7EAE5
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 01:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708132521; cv=none; b=HQHzcOjHigsa710qU+jwJDGdvchwApQ9BsVRpkdmjL0HldBv4c4TXkpv8LJz/mgwjDjjgbdqhhgqztM946nHXtLUXqjZl8SB2Q6U89ZLp+vUlN/ZwxdDhFxNT2ncbEQsYxJrXrZ1HpP/QF4zy28mdzSCpn1+/4Ewx5/s1y6xXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708132521; c=relaxed/simple;
	bh=ZLpzPkaQVf3vPQXMg5o0TPQW1auuMvt5zHLMK/s9MLQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLTfCAFiqNuKfvxXC8K8MG5NoguMdui1uQTgXqzShOIa0YKF3M0eMKCoN3flHz8Wos6nEiRbpaxzBhV3qVO2ULOEIl9S/wxr34u7NevB/UFiW81Tznne8Nlhu/7IdW+oqXWIBagZgYhjczuxR4ac6hG7yVlK7HB6ZjLmdWs+xoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pU9NiicI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dc992f8c8aso2657780a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708132519; x=1708737319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4LBEMe2qsSCAfEzNdzegJHhWuWUWp8q/u+78ScdPwFM=;
        b=pU9NiicIBS/T1qFm818l485nxSBrpnbAiJA4YrTD6ZDPVsvhJeEuqMD7BLUGMbZpGm
         y4FL1d1wV3g+FaDt4dtGuuBiaIynd3SE5ZQ6P0uiBlKiUSDs4LLy1BpXuc1FL+EB8f5+
         tNvWy6G2OYDleJGksPV7lBuL8VYzOIGjNKrYy67XyOGGoAD36SCVZESWbr4uK18BJQj5
         o2w43D3/OWWpxVdd1eK5BHf4vZIhPfvlGyLYe2B3IcqZwaLah1AYqfRJJCl1VbQZjtxa
         MXFpbmlKhW/SUfBmmGhyOo/EBALXobo+nYxcmKJODIRcVPYrkpAV0xj+ZQDfG4rnu+P+
         cGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708132519; x=1708737319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LBEMe2qsSCAfEzNdzegJHhWuWUWp8q/u+78ScdPwFM=;
        b=kZuG1S+WL181ofF1CQtrAtBUxpUCLU1C4bRPAAkD+QyheHwU4Xy38kVm7XbdWkY/5B
         y9c0YS+2UF4yQnZs4ZOROWgeKITZ0xVfo8iTGPYz0YwwLZCp1aQaRLRFrGO8/6rq4j56
         /ccbjczP2r2IBzpdg6kh3a2SV3lfBYKI3CBGbhbnSFelwoDAVmz0SCQb4UhPkuEcTadt
         /lTypfnFpkd7O4EuU5T9GDT/MVYNSC0XdXG/GPhWKQbbCKv+U93WdP9bPvKyg0FdHx2k
         8wPXhCnYvRjxzKfASGGBbI0uYrVsZgrmYheN3scULhSVY/r9EsAuI/VLWPicu42QPLK5
         Mlhg==
X-Gm-Message-State: AOJu0Yz57Jooh1aLCo87mH8o5IhqgRtuY/z/IV340oWFWpRq5BYB7/bZ
	0Y/RPUhXZuqePJUG6LzjdOpFGlMIERKy77q7p9FyhUxZXIQDeGbqVSzgGOznfqU7TT12tdBNuCN
	5Zg==
X-Google-Smtp-Source: AGHT+IFVkQ9NvXY6j/sr7qRJV7g3L2FAzP7Bjq0b5BlAdMognqEtCrekhuZo7id9NSWv8WxOXOoIKWFJ+jA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c2:b0:1db:7d2a:8cc3 with SMTP id
 o2-20020a170902d4c200b001db7d2a8cc3mr281265plg.6.1708132519505; Fri, 16 Feb
 2024 17:15:19 -0800 (PST)
Date: Fri, 16 Feb 2024 17:02:29 -0800
In-Reply-To: <20240215010004.1456078-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170813138426.2064122.1636080722842815115.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix dirty logging of emulated atomics
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 14 Feb 2024 17:00:02 -0800, Sean Christopherson wrote:
> Fix a bug in KVM's emulator where the target page of an atomic write isn't
> marked dirty, and enhance the dirty_log_test selftest to serve as
> a regression test by conditionally doing forced emulation of guest writes.
> 
> Note, the selftest depends on several patches that are sitting in
> `kvm-x86 pmu`, so I'll likely take the selftest through that branch (eww).
> 
> [...]

Applied the fix itself to kvm-x86 fixes, I'll follow up with a heftier version
of the selftest patch for 6.9.

[1/2] KVM: x86: Mark target gfn of emulated atomic instruction as dirty
      https://github.com/kvm-x86/linux/commit/910c57dfa4d1

--
https://github.com/kvm-x86/linux/tree/next

