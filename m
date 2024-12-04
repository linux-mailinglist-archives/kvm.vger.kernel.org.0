Return-Path: <kvm+bounces-33040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2251B9E3F33
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9E56B35E79
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4E820C47B;
	Wed,  4 Dec 2024 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7cfGAPq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0051F7079
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733326262; cv=none; b=PooGNzNUKGQXzSRt/80bxQ7BzttWHUWGK1Mf1D0XRe0bA6M79UPk0IpnRvou9oqYVIAL4/kBpAl6+w+m8o8y/4nJerFwbk1mCn5Q47P6Fq2lhDOyCT6tU66souqeedVbdseLzx8n0n5G3kChCOWlgUO39DyxTMYROPYLYVTWY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733326262; c=relaxed/simple;
	bh=raZSwCSoIxMAMxZedsY7kgc1gQPkh8K/6vkYq+qQ0yU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cUAxwhQ6lgirhy0MVyfZUod3rR6Q5SnuZQm1JO0fFpV9FmtQkeaBCDjmp6bgTVyJOMoa+m+O/3cHz/QRjpYl4mTmBevSzAYrrrxvy7aigCRpwb5yKD+VYZKHJL6l+PjqVW2A2NAoVZUrB58AwstuTwdT4dmsyRb3pQenf9eaK68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7cfGAPq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee3aa6daaaso5903914a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 07:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733326260; x=1733931060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWzYXhh1XGle9PKP984gp5jQmjBdiOdHdzDrlgt7MZk=;
        b=s7cfGAPqPixORq7s40p3eeNZ/H1XR5cPKckVKg9m2ggNuD61U8uFHMGNSh5YYHOw10
         PWLRT8ocbR8jRE7eFe8qEQHHCvtINmDWRtHDPVIT8ZRQf2lijLxqDnx6ctnNzl8w7ltd
         5XKX+vMjqscW+ArK9+OzUgcr9T9YzWGXmvw1ymuRLiWJ7nsdvE1n+GXFWU3WTC8hL6z9
         vG4S6lHJUkQdTKys0Qy4BrcXPZlT7+wcqKlyr618RWtSi3AFrSuhxewrwPA6fIMjigMK
         hLCupV5MSqWMJgG/O2IkIdW7D2a6fQcMMNadBY87dR3T9r2Xxus3VCMEhhT6b9r0V1fk
         k/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733326260; x=1733931060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWzYXhh1XGle9PKP984gp5jQmjBdiOdHdzDrlgt7MZk=;
        b=TSXN46bDxvNAJXy0vnTnVfhN3xT5At/64tIp4qn+YWiIe/2NQ4kct1mjVhizuoT4d9
         5Ou+flfstSUccfpBVjs+WU9a8ro8s/hzv7B6yzwtbd3OGQoNNk7GHCCbFuXpqMoujuv/
         N1e8X9g2Smk0SlqRY7Vl9J5WgcxH9+9GC7VqkIuYhdJ1QXFUuGICP2Hjg4lyU2Sz4L2S
         t8854G/Ea/8UowOWdsOhRs6/JyQt1rQH1X3kjBpb2HXkzheQTL+eufnpfZdT6TXuRmgX
         xkLGkcAFo2qbv5T34DJAZ7JuMycELXrVkdgy41JroREfuijn7DqMMlx089/5bnTfjyIy
         AS7Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4y2J3ftttvGysEFyEOCigwKT/CkZmk9sBMcwYZxwxgMXe7RiyZCF3mwfk+r4FCDy+Hyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMgQZARocPlz4JcACVRYYC8soxjf6Je7uTPP0BcDJ0eSOeGcuh
	2u2nXJ4bQoRXCKb8i4qmMB4nXZ8TdUSVkIeCV/zxwpjIMTFxrDuXHDS6nRnV6yEmRcvyVjuYVwG
	m+A==
X-Google-Smtp-Source: AGHT+IG8hKZnFRirR/ao2e8umiwaB/AV15nxqrbtp2UlNP2cgH4Q1y4HPfvHflLtOx0OwlnKrZjyoia9Lc8=
X-Received: from pjj15.prod.google.com ([2002:a17:90b:554f:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8e:b0:2ee:f550:3848
 with SMTP id 98e67ed59e1d1-2ef011e3802mr8465345a91.5.1733326260234; Wed, 04
 Dec 2024 07:31:00 -0800 (PST)
Date: Wed, 4 Dec 2024 07:30:58 -0800
In-Reply-To: <20241204103042.1904639-12-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-12-arnd@kernel.org>
Message-ID: <Z1B1phcpbiYWLgCD@google.com>
Subject: Re: [PATCH 11/11] x86: drop 32-bit KVM host support
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 04, 2024, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are very few 32-bit machines that support KVM, the main exceptions
> are the "Yonah" Generation Xeon-LV and Core Duo from 2006 and the Atom
> Z5xx "Silverthorne" from 2008 that were all release just before their
> 64-bit counterparts.
> 
> Using KVM as a host on a 64-bit CPU using a 32-bit kernel generally
> works fine, but is rather pointless since 64-bit kernels are much better
> supported and deal better with the memory requirements of VM guests.
> 
> Drop all the 32-bit-only portions and the "#ifdef CONFIG_X86_64" checks
> of the x86 KVM code and add a Kconfig dependency to only allow building
> this on 64-bit kernels.

While 32-bit KVM doesn't need to be a thing for x86 usage, Paolo expressed concerns
that dropping 32-bit support on x86 would cause general 32-bit KVM support to
bitrot horribly.  32-bit x86 doesn't get much testing, but I do at least boot VMs
with it on a semi-regular basis.  I don't think we can say the same for other
architectures with 32-bit variants.

PPC apparently still has 32-bit users[1][2], and 32-bit RISC-V is a thing, so I
think we're stuck with 32-bit x86 for the time being. :-(

[1] https://lore.kernel.org/all/87zg4aveow.fsf@mail.lhotse
[2] https://lore.kernel.org/all/fc43f9eb-a60f-5c4a-a694-83029234a9c4@xenosoft.de

