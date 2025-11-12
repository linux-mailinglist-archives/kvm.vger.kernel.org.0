Return-Path: <kvm+bounces-62925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9A2C540D1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D67673ABB45
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AACA34C815;
	Wed, 12 Nov 2025 19:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jgu3fLh2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3819234847B
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 19:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762974182; cv=none; b=Djz/F9kBm6CP5LQYqz+ro6I0VKa+1sBS/tCXTRXx0DQDBzZlTAc1tr8WJ3c+2DadqD88ZaVk5De7vGHogn1K8qwrh4+y1iDFtwESvxDmyck74DIVG4h4BCBqbtEfZIXp36bj7X6HT9+lY4sTcC60OVaXRfpMr9Cy98AR127z7Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762974182; c=relaxed/simple;
	bh=LGlxXNTw28kq+Z+gfE/ybRjGWQx2KDGhBKmCSMdpiVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jQZbgF8Knbb9s8gesb0sjEhbOVpAxzcrbtQEXjQ9JmxXFIxPlevvINpPdow7VnniTu+i4RkNoK7eVpKeBfEIRj/lbVblOuEFngaljetYHkJwNqd1ViGFmZ5hvgZKLp3d3tlKrdpNx6aPqEyUA1SPYdsydyWsXuiOMf7HFYiMXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jgu3fLh2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340d3b1baafso2076203a91.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 11:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762974180; x=1763578980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4mmGVlaK5jYxixMUv2ahQBTt1kS7CUbCMOJEAOujJI=;
        b=jgu3fLh2B5oMgKswTPBqfUZSeiofuRkJvFit/rSmyjUWmcGc9GcGwkt4qpRxn5Zt+f
         8gPWSHEkjHEh5LNIEfOz/gz8otajwi1+A/bps9u7e3LOrFBQ/tXVp4W9MfEwSrGbIe2w
         4r26NztFPJoANiFNtvakr9kRv2b3gZBTLlceN8G+JCrOcsTdI/BDDG+xNCajh1LAsULD
         RGvznyUdin9n+5oPpdRAyIf7HaCGbdntrhqcz6X31nw6YnOoYy1Ryrd7jbEoXtzL0PGM
         cy7TdF/2VsYSDDhR2qnThNswHPaSMtFriFK733dv08ln4PBuCs2ADAPOOxcCpnq2wJ+d
         Dk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762974180; x=1763578980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4mmGVlaK5jYxixMUv2ahQBTt1kS7CUbCMOJEAOujJI=;
        b=KZzlpdofE4YyGJh4TrOau3Pz5ViCBj46cVG9TpGbI6v31k5L2aU8e9dSmUqJ8Ac4Sv
         XkaAHORbx6idTtGGwpDRkP8kxgj9A5PuLFEvjPjj868zk0CvR6OnnngXqsoFPrWe6rij
         oerQqA6jDuOFZxE4UdeSDL1JW3NiqJwjbxNcLHW2rUls5m+Zdo1XbPYAgE5lEMvfShS2
         vrB9CJIqe2UnAYCmruLAlxb7oiudpJmZM7rcrRmwHT+Z8O4Q35lUdbSNhcCteGDA06Ae
         ZNt2TNp17FopyChj1NUNyp9k85Os7Ym5zPia+AiQ5U90qd3eR8dj7wesUwaYA4zwPTmf
         nD9w==
X-Forwarded-Encrypted: i=1; AJvYcCWQftPhSDL0JE05CI/uy3eWmZK3utsin+kjB2T9AnMvFsLrPpIfuzc2HD8hxhG/C9tjZy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwleNCJV+SvwCFK/X13uBAW6uHkp9StMK2ZefuQoeXDm3wIzgfs
	AWXvLm9r6A6j/6QxIQhBdDLQWSBWpX4SyKZLghDTxLcWuJBKAyw/b4AqadmWuF77/WUPCkup6E5
	YubtdoA==
X-Google-Smtp-Source: AGHT+IHuvqhQEZ7hNdQkPZD4rJuUDRtujSfP/ARhp39mznKnaO/RO83SQKd3cGLtzFtwhfz/COPT78mlV1Y=
X-Received: from pjbpm18.prod.google.com ([2002:a17:90b:3c52:b0:340:6b70:821e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d0a:b0:340:c4dc:4b70
 with SMTP id 98e67ed59e1d1-343dde1a5f9mr5487061a91.6.1762974180495; Wed, 12
 Nov 2025 11:03:00 -0800 (PST)
Date: Wed, 12 Nov 2025 11:02:58 -0800
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250916172247.610021-1-jon@nutanix.com>
Message-ID: <aRTZ4oqqIqDlMS6d@google.com>
Subject: Re: [kvm-unit-tests PATCH 00/17] x86/vmx: align with Linux kernel VMX definitions
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Jon Kohler wrote:
> This series modernizes VMX definitions to align with the canonical ones
> within Linux kernel source. Currently, kvm-unit-tests uses custom VMX
> constant definitions that have grown organically and have diverged from
> the kernel, increasing the overhead to grok from one code base to
> another.
> 
> This alignment provides several benefits:
> - Reduces maintenance overhead by using authoritative definitions
> - Eliminates potential bugs from definition mismatches
> - Makes the test suite more consistent with kernel code
> - Simplifies future updates when new VMX features are added
> 
> Given the lines touched, I've broken this up into two groups within the
> series:
> 
> Group 1: Import various headers from Linux kernel 6.16 (P01-04)

Hrm.  I'm definitely in favor of aligning names, and not opposed to pulling
information from the kernel, but I don't think I like the idea of doing a straight
copy+paste.  The arch/x86/include/asm/vmxfeatures.h insanity in particular is pure
overhead/noise in KUT.  E.g. the layer of indirection to find out the bit number is
_really_ annoying, and the shifting done for VMFUNC is downright gross, but at
least in the kernel we get pretty printing in /proc/cpuinfo.

Similarly, I don't want to pull in trapnr.h verbatim, because KVM already provides
<nr>_VECTOR in a uapi header, and I strongly prefer the <nr>_VECTOR macros
("trap" is very misleading when considering fault-like vs. trap-like exceptions).

This is also a good opportunity to align the third player: KVM selftests.  Which
kinda sorta copy the kernel headers, but with stale and annoying differences.

Lastly, if we're going to pull from the kernel, ideally we would have a script to
semi-automate updating the KUT side of things.

So, I think/hope we can kill a bunch of birds at once by creating a script to
parse the kernel's vmxfeatures.h, vmx.h, trapnr.h, msr-index.h (to replace lib/x86/msr.h),
and generate the pieces we want.  And if we do that for KVM selftests, then we
can commit the script to the kernel repo, i.e. we can make it the kernel's
responsibility to keep the script up-to-date, e.g. if there's a big rename or
something.

> Headers were brought in with minimal adaptation outside of minor tweaks
> for includes, etc.
> 
> Group 2: Mechanically replace existing constants with equivalents (P05-17)
> 
> Replace custom VMX constant definitions in x86/vmx.h with Linux kernel
> equivalents from lib/linux/vmx.h. This systematic replacement covers:
> 
> - Pin-based VM-execution controls (PIN_* -> PIN_BASED_*)
> - CPU-based VM-execution controls (CPU_* -> CPU_BASED_*, SECONDARY_EXEC_*)
> - VM-exit controls (EXI_* -> VM_EXIT_*)
> - VM-entry controls (ENT_* -> VM_ENTRY_*)
> - VMCS field names (custom enum -> standard Linux enum)
> - VMX exit reasons (VMX_* -> EXIT_REASON_*)
> - Interrupt/exception type definitions
> 
> All functional behavior is preserved - only the constant names and
> values change to match Linux kernel definitions. All existing VMX tests
> pass with no functional changes.
> 
> There is still a bit of bulk in x86/vmx.h, which can be addressed in
> future patches as needed.
> 
> Jon Kohler (17):
>   lib: add linux vmx.h clone from 6.16
>   lib: add linux trapnr.h clone from 6.16
>   lib: add vmxfeatures.h clone from 6.16
>   lib: define __aligned() in compiler.h
>   x86/vmx: basic integration for new vmx.h
>   x86/vmx: switch to new vmx.h EPT violation defs
>   x86/vmx: switch to new vmx.h EPT RWX defs
>   x86/vmx: switch to new vmx.h EPT access and dirty defs
>   x86/vmx: switch to new vmx.h EPT capability and memory type defs
>   x86/vmx: switch to new vmx.h primary processor-based VM-execution
>     controls
>   x86/vmx: switch to new vmx.h secondary execution control bit
>   x86/vmx: switch to new vmx.h secondary execution controls
>   x86/vmx: switch to new vmx.h pin based VM-execution controls
>   x86/vmx: switch to new vmx.h exit controls
>   x86/vmx: switch to new vmx.h entry controls
>   x86/vmx: switch to new vmx.h interrupt defs
>   x86/vmx: align exit reasons with Linux uapi
> 
>  lib/linux/compiler.h    |    1 +
>  lib/linux/trapnr.h      |   44 ++
>  lib/linux/vmx.h         |  672 ++++++++++++++++++
>  lib/linux/vmxfeatures.h |   93 +++
>  lib/x86/msr.h           |   14 +
>  x86/vmx.c               |  230 +++---
>  x86/vmx.h               |  356 ++--------
>  x86/vmx_tests.c         | 1489 ++++++++++++++++++++++-----------------
>  8 files changed, 1876 insertions(+), 1023 deletions(-)
>  create mode 100644 lib/linux/trapnr.h
>  create mode 100644 lib/linux/vmx.h
>  create mode 100644 lib/linux/vmxfeatures.h
> 
> base-commit: 890498d834b68104e79b57a801fa11fc6ce82846
> 
> -- 
> 2.43.0
> 

