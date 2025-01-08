Return-Path: <kvm+bounces-34776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2FCA05CF7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C51181888FD7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 13:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EBB1FC10C;
	Wed,  8 Jan 2025 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/3T3RYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C081FC105
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736343523; cv=none; b=mTIlr67xge0msoWvqyDZtPBUlifhZtR4vs++I/NcyIfEy9zVAoQZDA5zqz71BqqWID6OAMs+cX2GmobxbFxF8iPXSREWY2UmvgrMSIIfxdHHD9nfxZEGcKzIfJf+0i95jOyqshS4KfQqLoI3kB0VEnsjKpHDZA+Kn/DnDA6fERg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736343523; c=relaxed/simple;
	bh=v1i3LZGDxegDo70qkjz8fMmEq10GKUa5BipY/8Zb4jU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQJ49QwbuNLHHSWGF0rc+o3Ve9/2wTq9NBXwAQDR1qwSU7chiwJcH9U/qlZFwI5EK4ULHNAEwP66+YFA73PYrviMiOjo8dZZnMmjqFbjoNFA4u8yd2tPTKpl88YkhZ6EBqbGb7BmLb4D5uFTa4s3v+ogWc5vtV9WfOzo+p3GA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/3T3RYI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2164fad3792so230991375ad.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 05:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736343521; x=1736948321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w7673IoZMAUWJAQk7JdKPTs3A4XFRDa/9rJ0Dsq7WK4=;
        b=m/3T3RYI5R1GFJMMsVTdemCJj+QfdO6WSB+ltF6rz3AdrgoIYvAo1W4Bis7geWD2We
         OZcW2cEP+kO9gcwxg8I0kvs/xUi4GEAt9nTtYpeQed9HrmxJ62pQ2VHVjKEZsKAs1Kht
         MdWFYcyInUdYukD0C4tSn4eHgVEAN3mNDNdHNlmmD+FRsa/ya3vrJ3Qo7x6u+jGO4I/4
         jIsf8BHS+u5rLI5Zd4+mTIIlqbEXIQucKoUHEJvOZypD29OrSuAm/KXuep8KOxCThksR
         /J6vvF7jeilIpmT3bENexc1nnk9SCx8bNbRYQ1L6SaJZqoiqLnRiRqZY7eAEVMUnt9C4
         oOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736343521; x=1736948321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7673IoZMAUWJAQk7JdKPTs3A4XFRDa/9rJ0Dsq7WK4=;
        b=A0fvseVt0XgXaJS7bPJtsbhCy7dwP6RYoAEjThALEiAhllTFZGfw717Kr2e6GtIYWy
         XrsjyyPbwLmnADOgmi2VftW5RT2zQ/ubiB+4ZqE50JGmB35x5p8CO4xL78YHIifICmtX
         AEowBRgU2Gsa9txTHtzI18s7FrIt4zSockgj2DB/vywtLEvjfsg92J+3XyDeF6GKlb0d
         iwnoZ4KoxgkHcwogJA0wICTuqgoNJunLfXXPkMH1DBuCkKvl1NLWF5IS4RVFGHLvAlmX
         DJDpX/qPqsvk+3g9HpUBtmi2n4wyNfHvy9cyw0C1XHv/ZLZ1S0yOtSsonYpcjcWZo1O2
         CQNw==
X-Forwarded-Encrypted: i=1; AJvYcCVoo0/45uv9M7R/U43lAOhUzqjGQXhlhiqSIx4P+NQEwwRJy84ei8Lk3Xu7H99yd0ayR+I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlge5yNTVbBj/qXjAkWf5P2QkdU862nJlUFfBPrRKdEhzzKrso
	luKx01u7prC6yb12r/1zUgRMHPFO1HbE9U1rsIDRDkFv238wImU8DEo3gRg5EUFv95QM2yH+BDk
	cOw==
X-Google-Smtp-Source: AGHT+IE662rYKosp+Ytrg40LSm+v+14FNK7tIJlFa6LwAW+vPjEqsvJjXB56x/CoInApRih0gZZdUxpnLbo=
X-Received: from pfba2.prod.google.com ([2002:a05:6a00:ac02:b0:725:ee5e:6efd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1589:b0:1d9:4837:ada2
 with SMTP id adf61e73a8af0-1e88d1da95amr5556536637.35.1736343520579; Wed, 08
 Jan 2025 05:38:40 -0800 (PST)
Date: Wed, 8 Jan 2025 05:38:39 -0800
In-Reply-To: <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202120416.6054-1-bp@kernel.org> <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com> <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com> <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
Message-ID: <Z35_34GTLUHJTfVQ@google.com>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 30, 2024, Borislav Petkov wrote:
> On Mon, Dec 16, 2024 at 10:51:13AM -0800, Sean Christopherson wrote:
> Note the WARN_ON_ONCE bracketing. But I know you're doing this on purpose - to
> see if I'm paying attention and not taking your patch blindly :-P

LOL, yeah, totally on purpose.

> With that fixed, this approach still doesn't look sane to me: before I start
> the guest I have all SPEC_REDUCE bits correctly clear:
> 
> # rdmsr -a 0xc001102e | uniq -c 
>     128 420000
> 
> ... start a guest, shut it down cleanly, qemu exits properly...
> 
> # rdmsr -a 0xc001102e | uniq -c 

...

> so SPEC_REDUCE remains set on some cores. Not good since I'm not running VMs
> anymore.
> 
> # rmmod kvm_amd kvm
> # rdmsr -a 0xc001102e | uniq -c 
>     128 420000
> 
> that looks more like it.

The "host" value will only be restored when the CPU exits to userspace, so if
there are no userspace tasks running on those CPUs, i.e. nothing that forces them
back to userspace, then it's expected for them to have the "guest" value loaded,
even after the guest is long gone.  Unloading KVM effectively forces KVM to simulate
a return to userspace and thus restore the host values.

It seems unlikely that someone would care deeply about the performance of a CPU
that is only running kernel code, but I agree it's odd and not exactly desirable.

> Also, this user-return MSR toggling does show up higher in the profile:
> 
>    4.31%  qemu-system-x86  [kvm]                    [k] 0x000000000000d23f
>    2.44%  qemu-system-x86  [kernel.kallsyms]        [k] read_tsc
>    1.66%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
>    1.50%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe
> 
> vs
> 
>    1.01%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
>    0.81%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe
> 
> so it really is noticeable.

Hmm, mostly out of curiosity, what's the "workload"?  And do you know what 0xd23f
corresponds to?

For most setups, exits all the way to userspace are relatively uncommon.  There
are scenarios where the number of userspace exits is quite high, e.g. if the guest
is spamming its emulated serial console, but I wouldn't expect switching the MSR
on user entry/exit to be that noticeable.

> So I wanna say, let's do the below and be done with it. My expectation is that
> this won't be needed in the future anymore either so it'll be a noop on most
> machines...

Yeah, especially if this is all an improvement over the existing mitigation.
Though since it can impact non-virtualization workloads, maybe it should be a
separately selectable mitigation?  I.e. not piggybacked on top of ibpb-vmexit?

