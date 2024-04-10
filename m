Return-Path: <kvm+bounces-14052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F1289E6BD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 552A9B22592
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FB538F;
	Wed, 10 Apr 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCpX4/hi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D97F
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708560; cv=none; b=q2FYVmYckUrw+KUc7+jnMTEAM3dygUWoGYPQncD+2UFVboTY6ErBpONO/5up5evUzC28Ui5L+IAmvzpIHh3qWZWbQ7DUvFQ6YaN0ILT+3NHf2crPbk0QmGC4NjxWgJ4R2R7xm2ZQb2WilyAhmDKYm9de+MoYAJTSYp4gEFgaPW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708560; c=relaxed/simple;
	bh=QdDxP2ZJ8WQlCeWFD59rgYvOdrsWRpWOkMBb3oA8T+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U4TWlcRRh56O0diIfISmzwgmSkBmVYgDpdgxuTUcT8omIFDZ+sg9o8cI3NlshuLnwDgBRcyr673g6NM1ieMJhH83Fgtud0S2XF3mS6ZIivgdCIFANl4p8AUrU3TknYFhWhwqVMWjYtCJq1a320HcpQDPz4EshpHcT3w59hQGLgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kCpX4/hi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8df7c5500so4457423a12.2
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708559; x=1713313359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvPLVDJi5NHtHFLkG3OMjbGDN57rlj1bIb+Ld7ZgFqo=;
        b=kCpX4/himLGFdSrULIIlCMoFzfxCvQ7qoHGO4wZXLOk0a+L2Ce1UKq+nGIu6TSpG2a
         +rZ+ovOEM6KGK8F0rpjLWXR9hGfNb2TKwkFB78F5zPY58XfiPVywGLOC1CLjs9tq9zzD
         NZP33Bw67yYXgz293sDKyx2MndoAss53Bi3FKdv+JLp87+J99c21P20wWeRdnbqhI3f1
         T5Ij5OxtJiRnr6yw/P2yf59uv0wRhHYNeDtwLX4iYlqyhojgzGQXEw2hET6j/XvrPDs1
         NLLgA6nPpClGx7EXIAVHBVQcvV/ZtkKJJDtMKjR+9f2byj14s46pkEZa//w8S7cdQcag
         r/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708559; x=1713313359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvPLVDJi5NHtHFLkG3OMjbGDN57rlj1bIb+Ld7ZgFqo=;
        b=E8JmB9WlZSONXgopzVqevY0l1u82x3Ls3i99a86OYtXsqTJ9KvJWED8M5TSfBZw+1A
         CFEVnIfntZRzVuAMhwFWgGLGlhMMByaqtQHujnZxA3vv8ndQVZyGxv+czaxVxCoTTXxd
         dJql9qA8P4oyaNtSAScm9Ymahr+6jrChSQ2EZzea/3FprUShd6hoLrVxvMVpigwI3ZsU
         c3wMUbgL6KZBo7Kq9H3VM/x1JMKCrC5Bxp8BHZp0m2X02Pi1VrvMXZ3T5RRan9iWnk1J
         40Atkmesb0OhrCs3rJcZQeHtLaBFsnWN0jF0TY1eP/xChCF0o26VyqlqiiYcwGKi3OGc
         FWWA==
X-Gm-Message-State: AOJu0YyTdSZ9JFozLRe5nZ0vtH+LUeIINSthG5GVjGNYfwWCr4IeJ1VH
	47Z1j0FJx9JI2CYGl7pouoWL2At7H+AmNDbCR1CwT67Nq2xcPG4FeFJhvDUtp8sDDlF2r51nJP2
	ZBQ==
X-Google-Smtp-Source: AGHT+IEUh+mFA4z/vi/1+xskBawTIBd6R87ZtpFJ7RJni2DIV880GqYNGexz9i2IbPVMQJu7x1GrNLrBw3Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:df15:0:b0:5d8:be12:fa64 with SMTP id
 u21-20020a63df15000000b005d8be12fa64mr3415pgg.0.1712708558768; Tue, 09 Apr
 2024 17:22:38 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:52 -0700
In-Reply-To: <20240307194059.1357377-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194059.1357377-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270789483.1597323.2620141110572560483.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Process atomically-zapped SPTEs after
 replacing REMOVED_SPTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 07 Mar 2024 11:40:59 -0800, David Matlack wrote:
> Process SPTEs zapped under the read-lock after the TLB flush and
> replacement of REMOVED_SPTE with 0. This minimizes the contention on the
> child SPTEs (if zapping an SPTE that points to a page table) and
> minimizes the amount of time vCPUs will be blocked by the REMOVED_SPTE.
> 
> In VMs with a large (400+) vCPUs, it can take KVM multiple seconds to
> process a 1GiB region mapped with 4KiB entries, e.g. when disabling
> dirty logging in a VM backed by 1GiB HugeTLB. During those seconds if a
> vCPU accesses the 1GiB region being zapped it will be stalled until KVM
> finishes processing the SPTE and replaces the REMOVED_SPTE with 0.
> 
> [...]

Applied to kvm-x86 mmu, with the tweaks mentioned earlier.  Thanks!

[1/1] KVM: x86/mmu: Process atomically-zapped SPTEs after replacing REMOVED_SPTE
      https://github.com/kvm-x86/linux/commit/aca48556c592

--
https://github.com/kvm-x86/linux/tree/next

