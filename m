Return-Path: <kvm+bounces-30342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DDB9B979F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B3EC1C215EF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2561A0BE7;
	Fri,  1 Nov 2024 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+Ah9SCV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08541CDFCB
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486059; cv=none; b=EwnsCM2aRdn7DpHMM4pH9usm6leuPtMWKUPsBoepajrke1tl2DbjdgobBr/DgDxOKC7qkrnnzKXJqAlSLRKlcka4LsjeypB/MtXChA+/Zyj8jlU/qdKayXGIcfzpsJkfG1rZZK2ALzrqCq7P3Mor2bkF9BVqjuT29zYvDUUgSIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486059; c=relaxed/simple;
	bh=oN0vujRXhSbTaSgamD07yGLZLfJwliF1KUGYf3X5eyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=Vgdh/WSM6E9yDoEneOhtcNY5oW8zlt36LaMFneOE9LObBmcudlSTUc3M1o4CjL+LULxH97oK3YqygSFQt3zEsERBMkrMThGJSA8G069slr6ug2IiKFuyhn4g+52+qBP+pgGwY5FHP7eB4FoQTCbubsxD6TJFf71B5W0j65wswjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+Ah9SCV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e1e989aa2so2737244b3a.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486057; x=1731090857; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ILZtmXmmPjUA1g0mznhbcMlteKfyuGhztP/uRth5K5c=;
        b=j+Ah9SCV5NTHqwIihCZcHzAPTAbejWQfPqBZHkT24HwS8Kg0PBjGehIUF3mb3RReex
         ODEyHgLvT2BCYbouO5NOMU1qeX6RHXV7W3vbCoY0CzM2txy+eaUJeSLuEp7JJ+T3i+dV
         0ibJthDmGHqKe8PcVvS5f/93gLqvDjjHXssu0B2WktfvLvMcTb1liQfePHBzhoNWqpOB
         ClkuHVDSHpwxgpFyCviXkkdV+S6JG5hZZtBJ+/RgzXQ+xTy7DhYo8Dvx57WPc7b0jG3u
         Qz7MYpwTxScxEvIayEnPHEpNaxp9mzlrX+wpxpR7CAS5zHsSyaT2ab5PaCHRR+DTesCD
         1S9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486057; x=1731090857;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ILZtmXmmPjUA1g0mznhbcMlteKfyuGhztP/uRth5K5c=;
        b=GfjOrWR+u4/vQ8Lyv2yw3cQVQw0gh1nhjF6Mu442/Gd1rBG43LQW4RA/t+R4COrpgR
         fuOzWG9u/4YsV/ls2qAPLiMpM1MWL50mmlldzQYOPfLmrRFRrRNzYOp71UZ8l5TAVcMd
         KFNFpemzHcgOI56GljG5LeaU4r5M6MnKcgRYqs4TpLzNO6oDp7ExCaeCR6O2aE2WApjT
         9zbdjZpz9Z9bX7aY2YJDL8ZrJRgXZg8PdR9iuJqy9l41RIPrRHG116snWMjpQK2cKWbN
         deuNsoTSuRAMUQttXMFXKjR+SH7lXyUxiyorhYhvy7qbYSu+fkXle1qxEJOdp6hhpg5/
         6/nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsdGK0KLRatktilj6vliFj0nrRli400ZlUXwxeSSjtvYO8V6IjwZJEBtdEwbB2+hVgVTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSwg4p1WSFHJaiTkFwtg7q85E2oe62BQs+sG/j1xZbnAtn42eS
	eej+qu0kqTcFpF0p0IXS9UuYyOO2YyVTUN3oVDL9g1q1zwIfAT2lqwwvBZ5DRsGEDhmtOEyVYaw
	3qQ==
X-Google-Smtp-Source: AGHT+IHeghFUa1oTqrPglV/po8yE2iF0JL0zdJIwGuRvfOvetTscuU7ZphiSgLb/o0u6deVXPooDkiBAglo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4604:b0:71e:4535:9310 with SMTP id
 d2e1a72fcca58-720c964ca2dmr12052b3a.0.1730486057285; Fri, 01 Nov 2024
 11:34:17 -0700 (PDT)
Date: Fri, 1 Nov 2024 11:34:15 -0700
In-Reply-To: <20240719235107.3023592-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com> <20240719235107.3023592-2-seanjc@google.com>
Message-ID: <ZyUfJ4NFyb3OShjY@google.com>
Subject: Re: [PATCH v2 01/10] KVM: x86: Enforce x2APIC's must-be-zero reserved
 ICR bits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 19, 2024, Sean Christopherson wrote:
> Inject a #GP on a WRMSR(ICR) that attempts to set any reserved bits that
> are must-be-zero on both Intel and AMD, i.e. any reserved bits other than
> the BUSY bit, which Intel ignores and basically says is undefined.
> 
> KVM's xapic_state_test selftest has been fudging the bug since commit
> 4b88b1a518b3 ("KVM: selftests: Enhance handling WRMSR ICR register in
> x2APIC mode"), which essentially removed the testcase instead of fixing
> the bug.
> 
> WARN if the nodecode path triggers a #GP, as the CPU is supposed to check
> reserved bits for ICR when it's partially virtualized.

Apparently this isn't accurate, as I've now hit the WARN twice with x2AVIC.  I
haven't debugged in depth, but it's either INVALID_TARGET and INVALID_INT_TYPE.
Which is odd, because the WARN only happens rarely, e.g. appears to be a race of
some form.  But I wouldn't expect those checks to be subject to races.

Ah, but maybe this one is referring to the VALID bit?

  address is not present in the physical or logical ID tables

If that's the case, then (a) ucode is buggy (IMO) and is doing table lookups
*before* reserved bits checks, and (b) I don't see a better option than simply
deleting the WARN.

  ------------[ cut here ]------------
  WARNING: CPU: 146 PID: 274555 at arch/x86/kvm/lapic.c:2521 kvm_apic_write_nodecode+0x7a/0x90 [kvm]
  Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
  CPU: 146 UID: 0 PID: 274555 Comm: qemu Not tainted 6.12.0-smp--41585e8a34cb-sink #458
  Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
  RIP: 0010:kvm_apic_write_nodecode+0x7a/0x90 [kvm]
  RSP: 0018:ff51c04b4d133be8 EFLAGS: 00010202
  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000000cffff
  RDX: 0000000087fd0e00 RSI: 00000000000cffff RDI: ff42132c9e336f00
  RBP: ff51c04b4d133e50 R08: 0000000000000000 R09: 0000000000060000
  R10: ffffffffc067428f R11: ffffffffc080aa20 R12: 00000000000cffff
  R13: 0000000000000000 R14: ff42132d09e7c2c0 R15: 0000000000000000
  FS:  00007fc1af0006c0(0000) GS:ff42138a08500000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000006267e52001 CR4: 0000000000771ef0
  PKRU: 00000000
  Call Trace:
   <TASK>
   avic_incomplete_ipi_interception+0x24a/0x4c0 [kvm_amd]
   kvm_arch_vcpu_ioctl_run+0x1e11/0x2720 [kvm]
   kvm_vcpu_ioctl+0x54f/0x630 [kvm]
   __se_sys_ioctl+0x6b/0xc0
   do_syscall_64+0x83/0x160
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7fc1b584624b
   </TASK>
  ---[ end trace 0000000000000000 ]---

