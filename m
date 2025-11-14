Return-Path: <kvm+bounces-63232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C68C5E4A1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 760E94F6DEE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571D2334C21;
	Fri, 14 Nov 2025 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FoyUORnd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CC2334690
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138098; cv=none; b=i1ZHbcNzUlG9Vun6hxBCiaXoaC3ATFqfGHIkLoVYYnoD2TfaJGViWYUsxXmVY2OkibjU4mcmoCfW3Dv3IJVQVPxybMVaf8axB44Oeeo4qbwMwn4fYhXO9jw+PftbZmBkXDIynpenwI28ikqx8vLwxNrsCi2lYgfLf9ynybH0fQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138098; c=relaxed/simple;
	bh=jnFl3KD360Q5m2RrgWUVH8XPAr8lZsBDwB3PrrwcXOg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jrbvZWV3m4bWZaW/vFXYrZXA2v+T66HMgdZEXcjXMZlG8tLoZ9iF48D1mX36rFPcPcy7rnh+ibIwDSAvpwj4HURQiKHMFCtJPamH4VBjSrIlfdVqDdIcUWbO3vn5/2WIMGV30O2ZL4hmyvty5JTkWJuTM9XdjMwGrbqhPaEcRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FoyUORnd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34385d7c4a7so2148261a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 08:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763138096; x=1763742896; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1ns2rwdEzu0s09TGIVcYiZkdrx/ddrqcJKC2YkfYUM=;
        b=FoyUORndtSgYQ5gC/BJxMgUFQrz/aNBv9BJR4qAlHeGOGVREkRIhGQXWeIZ/a+PdwR
         BRvOx1NkuXXDim21db4wjwYvNj5AzjdXlmqO8g0+csTT2x/oUQHPYgly4QXLmV9tlDh1
         veBnoQvB8B5FQW4+FoeTDcJCbqBYWMKiKzYgAI4gpOE0nMk/Nws7+kYK0RoqmKu32aJ9
         yoioyuXgUd18O6bCi6ucWGHWUZQ/luA6Wl/NUK5xiW3C/g8tbkfZMCOy7rTZX6Nq0Apc
         cn5pfkUHK2B7vRlmkazUh8y9jaMdtcWK9pQC4qu6WKgbGvfex2mTPoUOF3oS4RjbHLPG
         szAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138096; x=1763742896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1ns2rwdEzu0s09TGIVcYiZkdrx/ddrqcJKC2YkfYUM=;
        b=mb/Aacu4nIQqudZjOh1zlUYfHpPTQf2FB7BRoWHFkiFGUE5fzbX3TX9qNLJRqC3P+R
         9NkRUmWwWs4A16412rn7dvgDnsro5Wd2w/qft2Tj3VXKn7XBZOJlA2GToUUNq0S8jEYs
         p6Skp3UMrRbLAQwVdCBMdMJ/8hqq76WKvnGwMdMouwyZjwc2ANqM1bxuqQbp6OFrJUEU
         0jJYrL84Gsc4wj38TIEUT+StY1wpVcy22nOUUf/iJSqlWRzGj1SYtf9lNsHecLBUwSKT
         G/s27jGZp1ixOrtAsgI1HRLP/24pqPuSgEMs3Z0P7ewYSTLWSleeXvU7bIVL/caQQG6Q
         IbAA==
X-Forwarded-Encrypted: i=1; AJvYcCX71isqRGj5RqnhRrdtehCcy9n8ObEQySkuCKTm8teFXB2MRmTn5D5eVJI/QCi4qi84tNM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYXRkeqB4u7k/VsWOlCTtmffU4FfFwuaX2RS9gArQIsc+ukJDW
	Aw9rPFke8BoNtqisuuwnOyM4EGuLbi/IoEaVwkKAW4c7l8RXFFiPYPzIFHBGQvWb5SfMB22H4E3
	2DG+bCg==
X-Google-Smtp-Source: AGHT+IEh3z2Nb6KAJBZHU2sJubTy7c1sKgFc9269+PwqQ2HmmtQrNwUp4uQSnTQj/lyUcwHB5wfYnJmS7+k=
X-Received: from pjps16.prod.google.com ([2002:a17:90a:a110:b0:341:2141:d814])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b48:b0:343:e692:f8d7
 with SMTP id 98e67ed59e1d1-343f9177d7dmr4295451a91.11.1763138096109; Fri, 14
 Nov 2025 08:34:56 -0800 (PST)
Date: Fri, 14 Nov 2025 08:34:54 -0800
In-Reply-To: <20251112013017.1836863-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112013017.1836863-1-yosry.ahmed@linux.dev>
Message-ID: <aRdaLrnQ8Xt77S8Y@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 12, 2025, Yosry Ahmed wrote:
> svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> already set correctly. This results in force_msr_bitmap_recalc always
> being set to true on every nested transition,

Nit, it's only on VMRUN, not on every transition (i.e. not on nested #VMEXIT).

> essentially undoing the hyperv optimization in nested_svm_merge_msrpm().

When something fixes a KVM test failures (selftests or KUT), please call that
out in the changelog.  That way when other people encounter the failure, they'll
get search hits and won't have to waste their time bisecting and/or debugging.

If you hadn't mentioned off-list that this was detected by hyperv_svm_test, I
wouldn't have had the first clue as to why that test started failing.  Even with
the hint, it still took me a few minutes to connect the dots.

In general, be more explicit/detailed, e.g. "undoing the hyperv optimization" is
unnecessarily vague, as the reader has to go look at the code to understand what
you're talking about.  My philosophy with changelogs is that they are write-once,
read-many, and so if you can save any time/effort for readers, it's almost always
worth the extra time/effort on the "write" side.

And a nit: my strong preference is to lead with what is being changed, and then
dive into the details of why, what's breaking, etc.  This is one of the few
divergences from the tip-tree preferences.  From  Documentation/process/maintainer-kvm-x86.rst:

  Stating what a patch does before diving into details is preferred by KVM x86
  for several reasons.  First and foremost, what code is actually being changed
  is arguably the most important information, and so that info should be easy to
  find. Changelogs that bury the "what's actually changing" in a one-liner after
  3+ paragraphs of background make it very hard to find that information.

E.g.

--
Don't update the LBR MSR intercept bitmaps if they're already up-to-date,
as unconditionally updating the intercepts forces KVM to recalculate the
MSR bitmaps for vmcb02 on every nested VMRUN.  Functionally, the redundant
updates are benign, but forcing an update neuters the Hyper-V optimization
that allows KVM to skip refreshing the vmcb12 MSR bitmap if L1 marked the
"nested enlightenments" as being clean, i.e. if L1 told KVM that no
changes were made to the MSR bitmap since the last VMRUN.

Clobbering the Hyper-V optimization manifests as a failure in the
hyperv_svm_test KVM selftest, which intentionally changes the MSR bitmap
"without telling KVM about it" to verify that KVM honors the clean hint.

  ==== Test Assertion Failure ====
  x86/hyperv_svm_test.c:120: vmcb->control.exit_code == 0x081
  pid=193558 tid=193558 errno=4 - Interrupted system call
     1	0x0000000000411361: assert_on_unhandled_exception at processor.c:659
     2	0x0000000000406186: _vcpu_run at kvm_util.c:1699
     3	 (inlined by) vcpu_run at kvm_util.c:1710
     4	0x0000000000401f2a: main at hyperv_svm_test.c:175
     5	0x000000000041d0d3: __libc_start_call_main at libc-start.o:?
     6	0x000000000041f27c: __libc_start_main_impl at ??:?
     7	0x00000000004021a0: _start at ??:?
  vmcb->control.exit_code == SVM_EXIT_VMMCALL

Avoid using ....
--  

> Fix it by keeping track of whether LBR MSRs are intercepted or not and
> only doing the update if needed, similar to x2avic_msrs_intercepted.
> 
> Avoid using svm_test_msr_bitmap_*() to check the status of the
> intercepts, as an arbitrary MSR will need to be chosen as a
> representative of all LBR MSRs, and this could theoretically break if
> some of the MSRs intercepts are handled differently from the rest.

For posterity, Yosry originally proposed (off-list) fixing this by having
svm_set_intercept_for_msr() check for redundant updates, but I voted against
that because updating MSR interception _should_ be rare (full CPUID updates and
explicit MSR filter updates), and I don't want to risk hiding a bug/flaw elsewhere.
I.e. if something is triggering frequent/unexpected MSR bitmap changes, I want
that to be surfaced, not squashed/handled by the low level helpers.

 
> Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> only recently introduced with no direct alternatives in older kernels.
> 
> Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

With an updated changelog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>

