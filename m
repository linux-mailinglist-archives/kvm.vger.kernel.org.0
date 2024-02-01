Return-Path: <kvm+bounces-7747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C519845DF7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0128B1F2C4FD
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F315CDD1;
	Thu,  1 Feb 2024 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yaSfUf4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6D5A4EC
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706806822; cv=none; b=gEqxtCYMFtQCvjBUxejcIZr+XOw4JSO+ioGclKJkINv6zE7UqR6nZ+IcWwP0sAPhD5Zg3sY59/WQla9m00aPNJCIcbl57rtlZomFqtP+Yzb113jdv0mIuSVH2QJFXYOeeypJMpCqHoIUfWm9IN1tYrzCejkcRKbX1UwTgOOb/P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706806822; c=relaxed/simple;
	bh=N4n3zRIvR+VTDaguBtwM3JkuHD6WLYuDJPmBPDcTpS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nIAY4rNKoQng0xeM+XcDOaARDfr0/rDXqdQo5d3fUe5JPjoMwlzM2FmFaNnNlKsPXzmlnyPSHsEX+3qQfVinqhRa4ooCcSN3ufnlgWVk4iXtciDxuyq83j+C3qPJ4aEjzRC4zgi02/G01Xx2cCzsKzrgJDmKnyA6XWmCxjW0fag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yaSfUf4q; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d542680c9cso13178545ad.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 09:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706806819; x=1707411619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/x3jlCLNc7UiUHoyVg434LJ4SeDSaVulHM99QrXsAOg=;
        b=yaSfUf4qjNdx+8mecKoY/fSIpRbXUcC2IWLwR+bfxg+bLTfXaQ71owfoew/ibncffw
         daiLgWckS6VUrYZrsNCMIzJNSMtGrsbjT1yie3bfkFGsg7yZ5c4VIqZ28lcigYR55y+X
         48s/LJ5QPWua9VwbW9STTNjS6/pD6yDCh6KN2OL0BCUC+HsU8ColMgXUQzWMjKB75BcG
         hsn7tKjgBKrYtjupX47SXFqILMW7dN3p8reSLp8nfgHh2zwUCecvCIET3LrrMQfkBTnF
         GUrmIEtoMhWfBEEcUKjuIutSbAnGn5tJmVmB/HmPWO2m5T7xUanx00SYOn0Zl3ALlbmf
         itjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706806819; x=1707411619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/x3jlCLNc7UiUHoyVg434LJ4SeDSaVulHM99QrXsAOg=;
        b=bKa1JmvOqyQ7+uR4AeV00kSm6xstJMEE3AZXtEHGbTQV4FtpwypefL5WHcI3wc7qQK
         Ba45Cqhf5zcGShmb/7Dk7VRF4pmX5Yg7tOdzMZ0mcY6ZQ9gf/dBVT1XXoo35PzKOphB0
         UP5dwmAb0beIGevds32C9WOQbBACs7uVzf6JsFcEHhVZhq05IEu+Zdk2d++8u9bWJEUh
         8oBWd3/KdlqOZhRW3XS8wQa3dC1fCQb/3btjwLSUuMLq1+rPnfqln+rWOLCeBY1YG351
         ghloHd44iNP+nbIknJ9S07BzQfONLa23srU96mKLO7G7F6Iyg6lvJjZToTu3F2RbWD7+
         ebJw==
X-Gm-Message-State: AOJu0YwZ78jjo3zyst2nXxrkEVD4x/qHmEvLTNqNBPc1TR9btwh9zQFE
	cxHggY6zhl+bGOno+sD1MUlFqdU9OcicunqRPY89/vlQcy1GDpoyTljRWbvmWEIQF7qQqvKmlzK
	XNQUV57xiR+Z4+yX2vn1NjYqcxcFkyydTNFSH1jV11SFELIoCCv8b1e92Fa909qI9Tk3B9JDHHp
	1zSMMSXFHUw4TKQ7jxHGapcAybEib8
X-Google-Smtp-Source: AGHT+IHzf36y0HnGIX/3H+jUOKEMIK/NvtVO4O2y3aiz38JRM3qjQA3HJXJ+4Z9mqhTO31dM1UgLkbISPBo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:348b:b0:1d7:8535:d089 with SMTP id
 mg11-20020a170903348b00b001d78535d089mr14916plb.11.1706806819590; Thu, 01 Feb
 2024 09:00:19 -0800 (PST)
Date: Thu, 1 Feb 2024 09:00:17 -0800
In-Reply-To: <170666266778.3861845.16453599042139259499.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109141121.1619463-1-vkuznets@redhat.com> <170666266778.3861845.16453599042139259499.b4-ty@google.com>
Message-ID: <ZbvOIQqGt6SJMJrm@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Fix clocksource requirements in tests
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 30, 2024, Sean Christopherson wrote:
> On Tue, 09 Jan 2024 15:11:16 +0100, Vitaly Kuznetsov wrote:
> > It was discovered that 'hyperv_clock' fails miserably when the system is
> > using an unsupported (by KVM) clocksource, e.g. 'kvm-clock'. The root cause
> > of the failure is that 'hyperv_clock' doesn't actually check which clocksource
> > is currently in use. Other tests (kvm_clock_test, vmx_nested_tsc_scaling_test)
> > have the required check but each test does it on its own.
> > 
> > Generalize clocksource checking infrastructure, make all three clocksource
> > dependent tests run with 'tsc' and 'hyperv_clocksource_tsc_page', and skip
> > gracefully when run in an unsupported configuration.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/5] KVM: selftests: Generalize check_clocksource() from kvm_clock_test
>       https://github.com/kvm-x86/linux/commit/449d0d6ccf55
> [2/5] KVM: selftests: Use generic sys_clocksource_is_tsc() in vmx_nested_tsc_scaling_test
>       https://github.com/kvm-x86/linux/commit/a79036441a68
> [3/5] KVM: selftests: Run clocksource dependent tests with hyperv_clocksource_tsc_page too
>       https://github.com/kvm-x86/linux/commit/436e6e541cb2
> [4/5] KVM: selftests: Make hyperv_clock require TSC based system clocksource
>       https://github.com/kvm-x86/linux/commit/14fce852a14b
> [5/5] KVM: x86: Make gtod_is_based_on_tsc() return 'bool'
>       https://github.com/kvm-x86/linux/commit/57cc53712934

FYI, I dropped the xen_shinfo patch, and past me wasn't clever enough to make sure
that patch was applied last.  New hashes are:

[1/5] KVM: selftests: Generalize check_clocksource() from kvm_clock_test
      https://github.com/kvm-x86/linux/commit/e440c5f2e3e6
[2/5] KVM: selftests: Use generic sys_clocksource_is_tsc() in vmx_nested_tsc_scaling_test
      https://github.com/kvm-x86/linux/commit/410cb01ead5b
[3/5] KVM: selftests: Run clocksource dependent tests with hyperv_clocksource_tsc_page too
      https://github.com/kvm-x86/linux/commit/09951bf2cbb3
[4/5] KVM: selftests: Make hyperv_clock require TSC based system clocksource
      https://github.com/kvm-x86/linux/commit/b6831a108be1
[5/5] KVM: x86: Make gtod_is_based_on_tsc() return 'bool'
      https://github.com/kvm-x86/linux/commit/9e62797fd7e8

