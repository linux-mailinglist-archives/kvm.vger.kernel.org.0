Return-Path: <kvm+bounces-34806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F9BA0632D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C7A5167B01
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 17:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205141FFC70;
	Wed,  8 Jan 2025 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3MJoio7w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAB14F9FD
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736356700; cv=none; b=FfVA/Cg1xazHRY6Fg3YDw7haD2EWX2jx13jGgrlG9i/0yqEJu+OaTpCLGYgQjs/Wt75oA9+yR0IMpJ1l9/cT829ew2CqmPZGku4AiIJ2ZbxZlOPfbGb+Ad+U5qmqTlLrjwnVsJ9wmmOQ6Z3EYztuRLl/gjJcGnN3KSjRhXmkuS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736356700; c=relaxed/simple;
	bh=bxbzPDPzeo6Mj+J2K3yE7tGlJ/vd/UEgWfWw2x4x1Pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=opCItys5eJSPfvw1Ths+85oU5/mUg3jvvIQluSFpFztzKonFvcSmAlVuMtONe+TAWpnOGlWT283dEirXNRFz7PraXp+o2y51+eU9a7vdMuHjVmg48MfrepQorwqQRqhors21tLh7z38lBAnmuXYcQ8/O/WBTgRg3JFnC9pMa9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3MJoio7w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so58943a91.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 09:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736356698; x=1736961498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1OImYgQQWoSU9wIssXYzkU46oMuxX1ekNYL4JguZU=;
        b=3MJoio7wt0Vty0LHKQ/JERH/PkLdt7GPRHoYwJURT1YUPQoWBf9rvRVfBf+21YuqWx
         CLFF4kus6b0Ew0zH1iJ8XkwGLhUzjxE5KWsOnPIxUd5ppLjcjZsAiSSaoIw/bAJ46ZQr
         5M4MLDlrCS1IbOkmLD7pu4f7wsGKKRACS6PuQTQeiAVR8yxZIMpIZC5naak0ww/esZoo
         M4hT7l86iErclhzQAPIZSVmiuTldkusZxbFpnFAMCITLMhlaaYEui7k5L5MPlX0fhciA
         qIrsABd+rXOeV676opJC2+7NfbQ0NpWyAz8IAFoLCczl95NIrNsNE6dc7lCLdyi6NjYw
         nJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736356698; x=1736961498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1OImYgQQWoSU9wIssXYzkU46oMuxX1ekNYL4JguZU=;
        b=kVy885KAWc3Auw3Y6yMl5bBVkNsr3TjEc57bFNRgKzeK6SujHHxpAfyGzEjlpC0SYr
         +CUYZ6YO7zRq5HsoVi9YD9lDGABQ5pyp1tkQb7t7csebi/rQA23LrUoqcsoRgE/5jDKs
         Vjp6qlsmoZiMf6a5D66cN0bed03+rptm5m8AgsuYboJF6/fPmKUqbifZdLsbZOR9ewPD
         XGwSJgQqAO1tEZZ4fk91MRrWwbo+5a3E0kAe5EOWNZD/9p9OOJ5CxtRxfqUcXGHQlAW5
         nbbjbGBWfDBAsbqA1kisIPWw7BTOPW0ENWcc+VyLwhEOA1Pmbxk0Me1tkCus4PmgUhpT
         c1PQ==
X-Forwarded-Encrypted: i=1; AJvYcCU42m7Y7ylBygDJcYpj+2za7GwuRyxjyxIy4/tTchTNl2dAvsMoU9N6J1ZIimSI1b2XXS8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0vI5gB5B5GgP5ZI+7Odia542uQ5GglfPsJSXlNa0ebTY3A8Qc
	uTRXZ/U5/Gow8nrBRp6xZBJMnmwqNdGcPEcMqSKLFhJS39dU0YX9rQMxJ3CR37sOaUiiRY2IB5H
	/Cw==
X-Google-Smtp-Source: AGHT+IHfHcu56E1hc5dqPiSS91EWf26xDr6vcxJmjXCGZbU/oon6eBARqLMgUGZz0Y1H8HxUjhwHjPZmJCc=
X-Received: from pfbbd43.prod.google.com ([2002:a05:6a00:27ab:b0:728:aad0:33a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a02:b0:726:f7c9:7b1e
 with SMTP id d2e1a72fcca58-72d21f4c0c6mr5435061b3a.13.1736356698391; Wed, 08
 Jan 2025 09:18:18 -0800 (PST)
Date: Wed, 8 Jan 2025 09:18:17 -0800
In-Reply-To: <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202120416.6054-1-bp@kernel.org> <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com> <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com> <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com> <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
Message-ID: <Z36zWVBOiBF4g-mW@google.com>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 08, 2025, Borislav Petkov wrote:
> > And do you know what 0xd23f corresponds to?
> 
> How's that:
> 
> $ objdump -D arch/x86/kvm/kvm.ko
> ...
> 000000000000d1a0 <kvm_vcpu_halt>:
>     d1a0:       e8 00 00 00 00          call   d1a5 <kvm_vcpu_halt+0x5>
>     d1a5:       55                      push   %rbp
>     ...
> 
>     d232:       e8 09 93 ff ff          call   6540 <kvm_vcpu_check_block>
>     d237:       85 c0                   test   %eax,%eax
>     d239:       0f 88 f6 01 00 00       js     d435 <kvm_vcpu_halt+0x295>
>     d23f:       f3 90                   pause
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
>     d241:       e8 00 00 00 00          call   d246 <kvm_vcpu_halt+0xa6>
>     d246:       48 89 c3                mov    %rax,%rbx
>     d249:       e8 00 00 00 00          call   d24e <kvm_vcpu_halt+0xae>
>     d24e:       84 c0                   test   %al,%al
> 
> 
> Which makes sense :-)

Ooh, it's just the MSR writes that increased.  I misinterpreted the profile
statement and thought that something in KVM was jumping from ~0% to 4.31%.  If
the cost really is just this:

   1.66%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
   1.50%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe

vs

   1.01%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
   0.81%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe

then my vote is to go with the user_return approach.  It's unfortunate that
restoring full speculation may be delayed until a CPU exits to userspace or KVM
is unloaded, but given that enable_virt_at_load is enabled by default, in practice
it's likely still far better than effectively always running the host with reduced
speculation.

> > Yeah, especially if this is all an improvement over the existing mitigation.
> > Though since it can impact non-virtualization workloads, maybe it should be a
> > separately selectable mitigation?  I.e. not piggybacked on top of ibpb-vmexit?
> 
> Well, ibpb-on-vmexit is your typical cloud provider scenario where you address
> the VM/VM attack vector by doing an IBPB on VMEXIT. 

No?  svm_vcpu_load() emits IBPB when switching VMCBs, i.e. when switching between
vCPUs that may live in separate security contexts.  That IBPB is skipped when
X86_FEATURE_IBPB_ON_VMEXIT is enabled, because the host is trusted to not attack
its guests.

> This SRSO_MSR_FIX thing protects the *host* from a malicious guest so you
> need both enabled for full protection on the guest/host vector.

If reducing speculation protects the host, why wouldn't that also protect other
guests?  The CPU needs to bounce through the host before enterring a different
guest.

And if for some reason reducing speculation doesn't suffice, wouldn't it be
better to fall back to doing IBPB only when switching VMCBs?

