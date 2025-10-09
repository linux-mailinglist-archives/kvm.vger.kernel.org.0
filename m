Return-Path: <kvm+bounces-59735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA8DBCB18E
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 082454E7FE3
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A102F2868B3;
	Thu,  9 Oct 2025 22:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfhPLGJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C9728153C
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049078; cv=none; b=KAnkde+9lWsFdPJFUIzpyTSrBNfbWCc31+yA7UlKgF/1qE3vy/dBwR2W42g8w4Zx0+cRz3VWgvWCM0q87hXFgr+kRCi4PS7dZw8vMtckk8j0t1iTlj0rDqTuhQYIziuxsz3qchPBo3heWflllELmFj67u9eCPD//P/hWLmQMVaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049078; c=relaxed/simple;
	bh=Yn2kvTm+mZNDuY39ANHX4G7xDC5i9BaIUGRte74CguA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmS8gvSUqbqD+6wMAbWKJq5W+bwH4JniyAg6oMBS7ETRGjkKJEntZj+sW3PwSM3ZdjHbkdMOjg5/r+oeLyGrY8U1uu9UeNhLydJJBhYmQoLxZBWyHt1JdKL1dJsTpm7AP8h7oobi2TN/CDgdT/IL2SOz5f6HxM+3h3UmyKonmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfhPLGJZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33274f8ff7cso3974506a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049076; x=1760653876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oyn4fVoh4cjthxckvqweX9TO6N78roW7lipNMYAXPf4=;
        b=UfhPLGJZg2MCu7YN2cvbfiB1UPKhc64m+14g+xx/Ql0onc00URbCsBqupmB8vaFzYM
         42pnVZgnFXQtLPS7+q003QthozOV00skpEH/FapSRHmNQgX83Vm44Hsibt3f10CzqRfm
         M6pBdK6rOp2Q1owOs345pdg2CorhqOFSZL6ssbyeuB814Ie9nfd3/QdRwWaDOacP62Rg
         3JE43WGZt/doZLbnlQGfjbkTILkjf6F0xsEmPm+oWED7vanO0inCWgDQZ01MWFMrt37w
         q5m/y2/puXFV7++OUr08FbKWFAEiNDCnGoTV/iuyBGvpJu/eRLu8ZZftqAShhlM3fhkT
         TYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049076; x=1760653876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyn4fVoh4cjthxckvqweX9TO6N78roW7lipNMYAXPf4=;
        b=dOICKmaBzBx/U5QNvdMMk9HJRI2mYFqJPxFiint6XMAA9WtFHYnJfcmsTi++W51E3Z
         VhkM6xXqp8JfbNJkc5M6oZtGES8gVfIBO7Q2eDsZZ6GehG+pMb1R66Fw+wgSAiGks1sY
         F9CTlAxWwVsJsNX6dzZ8Xbryz3P0Lz+6tKXvmdpJowUaFM7lNqjAFVx0A0C79F6f1oh8
         2NusXxFB7R/Ga70txZ9eDafYxkQt89j14WNPV578KMktJxraQajZ8EAPmaYZVkMuXV1v
         BNCAE1KyeG3IpnxRHoSkH12UVLHK6GgqKSj1qR/Btdt/lAmZFDlvN/OgILHSW3gpxuMS
         fdBA==
X-Forwarded-Encrypted: i=1; AJvYcCW4tsTH5xfeuKu4aY1hscBxUvJQvtSp1yiV49aIeKnARFbCYdTxzwqT92jz5t1IY2ry1no=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyjDf7crc6yUfxLK6pDmIVDPwZTFfmZgcozb9PiAPc3UC7IJM7
	GderaA+sAEIItVmu5L7D2k6Rl41pwG9Ft5AS5J4lVEdEEX+D/ZLDGKmin2+7J7WvV1zK0On3mWo
	H8zkMPZyJRdz3oESFucZKKb0h6g==
X-Google-Smtp-Source: AGHT+IEmelRZ9ZJu08/OiMaUmje11/Gsz4SbXx5oLReryhBGhZaItJQt2LKWHVGmxTYaiV6rsN3g3rToagNXnHp9Yg==
X-Received: from pjboa10.prod.google.com ([2002:a17:90b:1bca:b0:330:7dd8:2dc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:268c:b0:330:6d5e:f17b with SMTP id 98e67ed59e1d1-33b513b3e20mr11757701a91.21.1760049076512;
 Thu, 09 Oct 2025 15:31:16 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:31:15 -0700
In-Reply-To: <20251007221420.344669-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-8-seanjc@google.com>
Message-ID: <diqzikgnhfm4.fsf@google.com>
Subject: Re: [PATCH v12 07/12] KVM: selftests: Report stacktraces SIGBUS,
 SIGSEGV, SIGILL, and SIGFPE by default
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Register handlers for signals for all selftests that are likely happen due
> to test (or kernel) bugs, and explicitly fail tests on unexpected signals
> so that users get a stack trace, i.e. don't have to go spelunking to do
> basic triage.
>
> Register the handlers as early as possible, to catch as many unexpected
> signals as possible, and also so that the common code doesn't clobber a
> handler that's installed by test (or arch) code.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I tested this with

diff --git i/tools/testing/selftests/kvm/guest_memfd_test.c w/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..f6de2a678bf99 100644
--- i/tools/testing/selftests/kvm/guest_memfd_test.c
+++ w/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -182,6 +182,8 @@ static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
        TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
        TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
 
+       mem[accessible_size] = 0xdd;
+
        for (i = 0; i < accessible_size; i++)
                TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);

And got

==== Test Assertion Failure ====
  lib/kvm_util.c:2299: false
  pid=388 tid=388 errno=29 - Illegal seek
     1  0x000000000040a253: report_unexpected_signal at kvm_util.c:2299
     2  0x000000000042615f: sigaction at ??:?
     3  0x000000000040283f: test_fault_sigbus at guest_memfd_test.c:183 (discriminator 4)
     4  0x0000000000402c1c: test_fault_private at guest_memfd_test.c:200
     5   (inlined by) __test_guest_memfd at guest_memfd_test.c:376
     6  0x0000000000401e15: test_guest_memfd at guest_memfd_test.c:401
     7   (inlined by) main at guest_memfd_test.c:491
     8  0x000000000041ea03: __libc_start_call_main at libc-start.o:?
     9  0x0000000000420bac: __libc_start_main_impl at ??:?
    10  0x0000000000401fe0: _start at ??:?
  Unexpected SIGBUS (7)

I expected the line number to be 185 but the report says 183. Not sure
if this is a compiler issue or something caused by macros, or if it's
because of signals mess with the tracking of instruction execution.

Either way, this is a very useful test feature, thanks!

Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8b60b767224b..0c3a6a40d1a9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2290,11 +2290,35 @@ __weak void kvm_selftest_arch_init(void)
>  {
>  }
>
> +static void report_unexpected_signal(int signum)
> +{
> +#define KVM_CASE_SIGNUM(sig)					\
> +	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
> +
> +	switch (signum) {
> +	KVM_CASE_SIGNUM(SIGBUS);
> +	KVM_CASE_SIGNUM(SIGSEGV);
> +	KVM_CASE_SIGNUM(SIGILL);
> +	KVM_CASE_SIGNUM(SIGFPE);
> +	default:
> +		TEST_FAIL("Unexpected signal %d\n", signum);
> +	}
> +}
> +
>  void __attribute((constructor)) kvm_selftest_init(void)
>  {
> +	struct sigaction sig_sa = {
> +		.sa_handler = report_unexpected_signal,
> +	};
> +
>  	/* Tell stdout not to buffer its content. */
>  	setbuf(stdout, NULL);
>
> +	sigaction(SIGBUS, &sig_sa, NULL);
> +	sigaction(SIGSEGV, &sig_sa, NULL);
> +	sigaction(SIGILL, &sig_sa, NULL);
> +	sigaction(SIGFPE, &sig_sa, NULL);
> +
>  	guest_random_seed = last_guest_seed = random();
>  	pr_info("Random seed: 0x%x\n", guest_random_seed);
>
> --
> 2.51.0.710.ga91ca5db03-goog

