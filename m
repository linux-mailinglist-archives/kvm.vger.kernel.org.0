Return-Path: <kvm+bounces-34107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4799F72DF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7325F16873C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1326786339;
	Thu, 19 Dec 2024 02:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="an+g9L5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C374978F3A
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576279; cv=none; b=rGG3MRABSXi342FV6fjhLrpL1FEFVbPHkrOP32n6oi8xXAg5SSXY9N4VwMbV0gU3qcuJQ6HCU+49WrgBNLrnoCgPorQkiFEAmqjXTobfHepLLlgixkDB0dTYAFxQbDatffSox3fQe2DGfYNJCV/8V1ZKfWzRBhQktn2b/sxdYPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576279; c=relaxed/simple;
	bh=N5TtTu90HOcYBcBTV4b66kovt6XJp4476TqhdMfefqE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ccrz/d8bp1TULjrGMhBP78Q0qNbHRtQ93eM+OxAD2KESRyo1d68atYQJ9pvqXfzCKNqfws0oETYYckKcgi0j/ezzF31DcOd/+/bed5vjy+9oc38HndYFqbcrC2eq8xyQAneG/wcd//rU1fQ+e/O6xgXqi5+arO0JYek4T9ro7yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=an+g9L5W; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so440075a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576277; x=1735181077; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFKI4y9HgSVIQX86yRCgZOV+b5D+A4o0PCrFZDcmYbI=;
        b=an+g9L5Whoq7z6AJfb0MB9244PTtUoZ/cFNyvt2u1fdvJdMjg2JC9sIys3aUXSKFmx
         qzRmqkRHPGsdVH29cjK4SFqARddQwZu8J2xFnuDzkbP5hJMmDk+Z8e06FVbwXCtTPdPs
         eu8uJJmt2blf0SsAitw4ragPLx03vWx3QIJyfViLUsQthDIjSCcqMHL/kYlJxrTo2r50
         53MebMcktU/P95W918j67RsTDNJjof3oIYyr7IcO1DFL/VO1C4ACySw5JR6W1KhAHNny
         9k1Wz/Hv7vG0q2aC2+jGhkQKeOGbTuULJh9gWv/yU6lBR0pmk/FS+Il4fEUHxblWJsUF
         eZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576277; x=1735181077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IFKI4y9HgSVIQX86yRCgZOV+b5D+A4o0PCrFZDcmYbI=;
        b=k+BZqjvDrE6KmkVSOtSBM6X1pHOsw0IoSzGoOMZGh8FzNEpxPXwraIg4dbvXNBW5pQ
         bzzP9eBAKpw0CpWSYY1JrBPcFhNnAj+LqoPg5wTwRnhGpSn7kV5KKIGAkymwcjvCUqeV
         d216Zfqj0XMdqoKdpn5ICCg8K2hxvN4+0KmQiWgZ6X9IByYAggiX+waQgWMng3dryxAj
         vQINYJA1nzWEfrRltoZqQlNG0Ac1hy6x2uowoXRu/yxleuO6e5/Iz4dl+f9kUrpoaSvI
         WvMUKLRjVm9CBLOEJgWhQyvEllbZr5iNO+ELncMaOYTNRuL/ETY/NXC2b5a7p06W6GCi
         rANA==
X-Gm-Message-State: AOJu0YwOwYnUUGrJffWswZXHgDj2Um9rpuOw+JFDz79dbLH/RCe7Dj0v
	jjS/gmao+FAzeOQnep5v1NmYsLsJnsSW8iG4S6qXTSIHBKKWmmrjbL5HPeALciRPgqInBEqc8l+
	w6w==
X-Google-Smtp-Source: AGHT+IHqs2IzZsVqhnBr+YlcyquV6nWcTTyhEp6MfOGp8rvmwH4uoMWDxmBpOdqJ0GIbMqpqApQaNilkDe8=
X-Received: from pjbsf2.prod.google.com ([2002:a17:90b:51c2:b0:2da:ac73:93e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534e:b0:2ee:d63f:d77
 with SMTP id 98e67ed59e1d1-2f443ce8c17mr2500537a91.9.1734576277341; Wed, 18
 Dec 2024 18:44:37 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:58 -0800
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173438868282.2574820.3350549298279234722.b4-ty@google.com>
Subject: Re: [PATCH 0/6] KVM: Fix bugs in vCPUs xarray usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Wed, 09 Oct 2024 08:04:49 -0700, Sean Christopherson wrote:
> This series stems from Will's observation[*] that kvm_vm_ioctl_create_vcpu()'s
> handling of xa_store() failure when inserting into vcpu_array is technically
> broken, although in practice it's impossible for xa_store() to fail.
> 
> After much back and forth and staring, I realized that commit afb2acb2e3a3
> ("KVM: Fix vcpu_array[0] races") papered over underlying bugs in
> kvm_get_vcpu() and kvm_for_each_vcpu().  The core problem is that KVM
> allowed other tasks to see vCPU0 while online_vcpus==0, and thus trying
> to gracefully error out of vCPU creation led to use-after-free failures.
> 
> [...]

Applied to kvm-x86 vcpu_array to get coverage in -next, and to force Paolo's
hand :-).

Paolo, I put this in a dedicated branch so that it's easy to toss if you want to
go a different direction for the xarray insertion mess.

[1/6] KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
      https://github.com/kvm-x86/linux/commit/1e7381f3617d
[2/6] KVM: Verify there's at least one online vCPU when iterating over all vCPUs
      https://github.com/kvm-x86/linux/commit/0664dc74e9d0
[3/6] KVM: Grab vcpu->mutex across installing the vCPU's fd and bumping online_vcpus
      https://github.com/kvm-x86/linux/commit/6e2b2358b3ef
[4/6] Revert "KVM: Fix vcpu_array[0] races"
      https://github.com/kvm-x86/linux/commit/d0831edcd87e
[5/6] KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
      https://github.com/kvm-x86/linux/commit/e53dc37f5a06
[6/6] KVM: Drop hack that "manually" informs lockdep of kvm->lock vs. vcpu->mutex
      https://github.com/kvm-x86/linux/commit/01528db67f28

--
https://github.com/kvm-x86/linux/tree/next

