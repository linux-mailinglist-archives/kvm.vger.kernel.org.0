Return-Path: <kvm+bounces-34085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B41889F6FE8
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 23:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC7B77A4148
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 22:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E37B1FCF53;
	Wed, 18 Dec 2024 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z0EBWwqX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30BE1FC0FD
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734559941; cv=none; b=FAkU6LD83SJ8qkKWS5qQ5eP7uXWf7VH/q/Y5aqx3oUGxnSJOCr8PM4jgGJ62lBYp+6lpXEloB8zwmdOvwNn8MMWv66mv4lm5pViEUc4JrWUeTjT6S8jJkWZvf9TvJq1IUjPdW/+asE8c0+Wz1DAM1jf/DkmoMeW9CCd8lfMOpns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734559941; c=relaxed/simple;
	bh=9ElCmbEdpmXTkkl32gV25N180alLg2mTUaxIcxwRA9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fC5kS1T4YH0ElSeLavpsHDmBcGoS3DG53B9cdlR0VQYI9rdblZ0tZH5i6vDkeRp4eanl33IqAduId/hm0uisYn1eeNMHi8urtio9hOXMWWHVV82y6zSqIw329ph12XP8bu6eTnC1S+5mWds8Dyywpts4FrXDcTcEmZRHVnP7iR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z0EBWwqX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so130535a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 14:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734559939; x=1735164739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8/Bx7vVXdjG8Qup6CRv0EW1z1SiIeJxiXGSb6iiEaI=;
        b=z0EBWwqXMZj4T9d9nQxkYJbDWp7S1zrFN5n373gc7feuVX+CaqxsSuP1x2cIy4hDnV
         vlA26mWmkN0JQKYIGTqJsVOHCQ1YynIjHiANAg2j3VHMRC+F4t5JapRUoKbiYNrGVb6E
         StFOnG4zjjLx6bGwyB6ETkNxBXwQl39NbPe3drpAqMKjbJ1fwcwQertqhQ+kUHpdIL1+
         PDgazaPYqzYyrgZEB+xmFUIsp89K8gtX7posg39rFqoivvkaZpcHSJw6r/81LNqftqMi
         /ZodtNkQgox4QinVR7RTUIKpOiAIR6KiCraj6/GJlitORvXF9k+iFEwP+tpaKtpKPVVX
         gmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734559939; x=1735164739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H8/Bx7vVXdjG8Qup6CRv0EW1z1SiIeJxiXGSb6iiEaI=;
        b=oeIE0hA/9fJqYD55uooAG8xZIeKohVO6Tupjk/xPFcO+Uc/eGTUuJdQaqpysIR+VJK
         jNTBVfGH0p6wHTcaMg3LQT2kY/DuCpQC/dMzkJgr/MYB40/31J4v+DOwhTfo0LNnyuoz
         Gv0UGnNJdwYYHO2JbK9Im3mQ8IG/1Zi4wCdmEJ7S8VTYZv3vyX/gUVmsWXuK6GvAiEUz
         UGfgMFke5V3a3Bgf3XDImvJMbAjgsF/ugDoiO0X384CMYZV1WBavRSTLX9co7EPQ97+z
         dWI9rUtrvYbJlSp2oqhSSl0dObrmU0aR4wXWARtKxLcJ4x7vQl+jHXJMC/biOawJy669
         jQew==
X-Forwarded-Encrypted: i=1; AJvYcCWpiCaTSbnVSeYHMWlEabwQV542ax0dOob44wDuxDI+UQmTj5oV4IF5O371age1Q/btYPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/oHI7Vw2u+JHG3TQXlGdZPlaidZkM0HVteTo5Hwm5ze/bZc61
	Lhk/wN4zEqNs9lny6aYk+BkegAsy017fbZjBtOhEpviZKdxYz05Bwl5SQf8hlqoLHFKyUOeFn25
	ogg==
X-Google-Smtp-Source: AGHT+IErnWAR5psGjYVEFgNdPO9Ra9c1ykxsWobkdL6749/rPBHLJQjHXddkE3dKVeRJv5MVr7RsZhgUpzE=
X-Received: from pjuj8.prod.google.com ([2002:a17:90a:d008:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134d:b0:2ea:37b4:5373
 with SMTP id 98e67ed59e1d1-2f443ce8daamr1395725a91.10.1734559939355; Wed, 18
 Dec 2024 14:12:19 -0800 (PST)
Date: Wed, 18 Dec 2024 14:12:18 -0800
In-Reply-To: <173455833964.3185228.5614329030867008316.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com> <173455833964.3185228.5614329030867008316.b4-ty@google.com>
Message-ID: <Z2NIwmRDaZBc_V4o@google.com>
Subject: Re: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 18, 2024, Sean Christopherson wrote:
> On Wed, 27 Nov 2024 16:55:31 -0800, Sean Christopherson wrote:
> > Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
> > avoid unpleasant conflicts, and because I hope to land both in kvm/next
> > shortly after 6.12-rc1 since they impact all of KVM selftests.
> > 
> > mmu_stress_test
> > ---------------
> > Convert the max_guest_memory_test into a more generic mmu_stress_test.
> > The basic gist of the "conversion" is to have the test do mprotect() on
> > guest memory while vCPUs are accessing said memory, e.g. to verify KVM
> > and mmu_notifiers are working as intended.
> > 
> > [...]
> 
> As I am running out of time before I disappear for two weeks, applied to:
> 
>    https://github.com/kvm-x86/linux.git selftests_arch
> 
> Other KVM maintainers, that branch is officially immutable.  I also pushed a tag,
> kvm-selftests-arch-6.14, just in case I pull a stupid and manage to clobber the
> branch.  My apologies if this causes pain.  AFAICT, there aren't any queued or
> in-flight patches that git's rename magic can't automatically handle, so hopefully
> this ends up being pain-free.
> 
> Paolo, here's a pull request if you want to pull this into kvm/next long before
> the 6.14 merge window.  Diff stats at the very bottom (hilariously long).

Argh!  I completely forget to build test this on non-x86, and missed that arm64
snuck in 75cd027cbcb1 ("KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely 
ignored").  *sigh*

Given that I just sent out mail, I'm going to cross my fingers and hope that no
one has merged the above branch/tag.  I've deleted the branch and tags from the
remote, but kept the tag locally just in case.

Please holler if you managed to grab the broken branch/tag.  If no one screams,
I'll assume I got luckly and will push a fixed version (with different names) later
today.

