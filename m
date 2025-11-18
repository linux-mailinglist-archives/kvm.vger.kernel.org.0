Return-Path: <kvm+bounces-63623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 53915C6C067
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F4E7363921
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910182DCF4C;
	Tue, 18 Nov 2025 23:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEXYST7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA623702FF
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508814; cv=none; b=LXU1FbvKUJ0Vb0ZnK57HFqbejk/VVW92cHG9T2r9bjEY+MubSBHDGrxXldJJdF55lB+5l0jKGZ9+GBflZh0OOE5JeAqY35V3JPnp0ka+SQ54XJxRHsfz7ZTcEMBmbWl0D9UZ/tJlLtul8IYb+SbyLL5fwdWM7Wa4CpUuhsEEnCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508814; c=relaxed/simple;
	bh=UlMl8s2kbMXVk9drS8fC8aY3ez6oETKnMm/ewfvIP34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PSWdBzzaPU9hZVSChhtADsKx7zMm/0o00ESWBgXhH5z4CDpvK2GbX9Yahl+Wkr4rNd7mi+fl2LG46xF2//xYTw8qsu0VSI8nA0HdkWYSg7PoMbO7TdCiJhlB6D5RvW+Rt91WPaTx0HHFnpf1fjmKq+/ZuEg910WdkuRG+dkqpxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tEXYST7V; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f12fso18138225a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508812; x=1764113612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7noKG3IRm59itZH5IMS2I6fppT3OVWKLHytjavPUVEo=;
        b=tEXYST7VwkIGfCV7A/rWZJkFLZd8SP8xdcSXtbzdZgjQ6E2DZlAuXnk2A3XeftiaQJ
         mea7Q8kTDGW3D+M1EHc3N750YRB6MbVawyOghH6g+AOSfZzR5CsMfU0yH7qkytI570pb
         dLIXqOlR6PietABS58SgiHXZwkUnoXRJUsncEVulVpqTlTS5DxtN6cyx4DSH+bUiDcLn
         B339Bo+uLdNebPYugwnzvdgYD7Vpc3+tQw4YJmtbYJv+RubE/jIJI/it+6aPpDmOaYAG
         kFZC5QETEWcouuYnrKVCHsjuFC9NfI2SNpRm0Ju5NJ69SxqIQoTAts9EUIRWQQ+66EXP
         mHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508812; x=1764113612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7noKG3IRm59itZH5IMS2I6fppT3OVWKLHytjavPUVEo=;
        b=k1UBO/xfGCQySm8bpOungNJLHhCA38bTADA137VNrA8/34YVRX06YlobUFkBgHLsRp
         ASJU+ZQ2Hf4gaTbvukE20WhsMSaHBnRfxTwpSX5guBpYyQI0T8PG7r4ZWI+SaN//EmCG
         u0KAkDkktuN9T9lcdw6qRN+LCiWHqvNoPwdqUgg85nrtTKqywl492M7+McdR3Zk5DeGw
         KjxDIUBIfCY3K8SofJ5L93f3T7JQBr7TA/dFFrOKZYea8Jwz3AvRJP5sn5uMjpQ8Bh2B
         NsfFHgZTY51BWMI/Gld211ydRV09VJ0EEU70WHyl7OlWrWKukGEEsz54K7taElnuZ5JK
         aFdA==
X-Forwarded-Encrypted: i=1; AJvYcCUraN1VMgYFCH5OQVsg+robOEV2qxu4RluQmZmmwiVGexk8yhNxEE55Gl35s+wAs87lX4U=@vger.kernel.org
X-Gm-Message-State: AOJu0YynAFtz7a8zUIbFkjDvUwIEt9BH2lgnzwJnTEHJUsj5fN0M+Rjc
	0PkklSZFQPlSUJ6M+VoRWUbngkFkgcCGOkPrrGgoCIl6B6Sokc7436xtUJoNJLAy7E1uGVARMD7
	PQArEww==
X-Google-Smtp-Source: AGHT+IFIX7D9YhoxFznaiN5dLpuaVlX4L0ZJKcpLRaAB9jU7SldaIa1QZ42HAy0mLPDwur8YwmopygqCbYE=
X-Received: from pjblp5.prod.google.com ([2002:a17:90b:4a85:b0:340:b14b:de78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc3:b0:340:d1a1:af6d
 with SMTP id 98e67ed59e1d1-343fa7579bemr18916532a91.36.1763508812428; Tue, 18
 Nov 2025 15:33:32 -0800 (PST)
Date: Tue, 18 Nov 2025 15:33:30 -0800
In-Reply-To: <aRzg-3XWu7nM5yWS@telecaster>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
 <aRzg-3XWu7nM5yWS@telecaster>
Message-ID: <aR0CSrJ1u1vFSYZZ@google.com>
Subject: Re: [PATCH v3] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
From: Sean Christopherson <seanjc@google.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 18, 2025, Omar Sandoval wrote:
> On Tue, Nov 04, 2025 at 09:55:26AM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
> > instruction, discard the exception and retry the instruction if the code
> > stream is changed (e.g. by a different vCPU) between when the CPU
> > executes the instruction and when KVM decodes the instruction to get the
> > next RIP.
> > 
> > As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
> > INT3/INTO instead of retrying the instruction"), failure to verify that
> > the correct INTn instruction was decoded can effectively clobber guest
> > state due to decoding the wrong instruction and thus specifying the
> > wrong next RIP.
> > 
> > The bug most often manifests as "Oops: int3" panics on static branch
> > checks in Linux guests.  Enabling or disabling a static branch in Linux
> > uses the kernel's "text poke" code patching mechanism.  To modify code
> > while other CPUs may be executing that code, Linux (temporarily)
> > replaces the first byte of the original instruction with an int3 (opcode
> > 0xcc), then patches in the new code stream except for the first byte,
> > and finally replaces the int3 with the first byte of the new code
> > stream.  If a CPU hits the int3, i.e. executes the code while it's being
> > modified, then the guest kernel must look up the RIP to determine how to
> > handle the #BP, e.g. by emulating the new instruction.  If the RIP is
> > incorrect, then this lookup fails and the guest kernel panics.
> > 
> > The bug reproduces almost instantly by hacking the guest kernel to
> > repeatedly check a static branch[1] while running a drgn script[2] on
> > the host to constantly swap out the memory containing the guest's TSS.
> > 
> > [1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
> > [2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b
> > 
> > Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> > Cc: stable@vger.kernel.org
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > Changes from v2 (https://lore.kernel.org/all/6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com/):
> > 
> > - Fixed EMULTYPE_SET_SOFT_INT_VECTOR -> EMULTYPE_GET_SOFT_INT_VECTOR
> >   typo.
> > - Added explicit u32 cast to EMULTYPE_SET_SOFT_INT_VECTOR to make it
> >   clear that it won't overflow.
> > - Rebased on Linus's tree as of c9cfc122f03711a5124b4aafab3211cf4d35a2ac.
> > 
> >  arch/x86/include/asm/kvm_host.h |  9 +++++++++
> >  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
> >  arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
> >  3 files changed, 43 insertions(+), 11 deletions(-)
> 
> Ping, does this need any more updates?

For the record, I had this applied and tested before the ping, I just hadn't sent
the "thank you" yet.  :-D

commit 4da3768e1820cf15cced390242d8789aed34f54d
Author:     Omar Sandoval <osandov@fb.com>
AuthorDate: Tue Nov 4 09:55:26 2025 -0800
Commit:     Sean Christopherson <seanjc@google.com>
CommitDate: Thu Nov 13 13:03:19 2025 -0800  <======= See, I'm not lying!

