Return-Path: <kvm+bounces-25059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB1095F607
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FEC51C21BE4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857841925B8;
	Mon, 26 Aug 2024 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ixbp9v9f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C3F3399B
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724688407; cv=none; b=LWVv/kDRL75pcKCc6lfv54TZ3AuwLcyq61p0AU4LfwuxsLk7NaYWxteAlUkfbiEmiVyMUF6fgHAqoXkqWNRPmnSlYCmyShJUAcodihEuPzybXxk3uzT7kcy5pyxUqvuYGzqHU1Iyi6JAhgNQpQzsq8F2u9cz1YxlHBQO4vbwqpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724688407; c=relaxed/simple;
	bh=OkGoFuz+fDUxddm3p4u97QJ8wx3Ln4XdHW9MaJMQRak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mEIq372JGGgvwRifr60oml5CM1YTDGkRCYVNTPRk+aHm2aRM1j+E5VmKafM/3L/9fwIBwP+umOrhVe8pRnQkNhctZFjN+Z8Zl+xDfN950HGXILGFck5VwQ6T40S/D9Skwh/HnZyJMal6yBC+cetuMpyRZDL7B/kkSnalqC6Mi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ixbp9v9f; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cf603d9ffaso1206760a12.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 09:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724688405; x=1725293205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BynQTMQmisTL3nM3s/Ff9E1/xSh6KM8uArokROfN7nM=;
        b=Ixbp9v9fgomxwBqk7cyFof/uMe7f5pPwpSYUCKuQAUe0d573fXlPXxudUm+DNmVyaZ
         HYpjcMH2zFr4eLZLpzqPktSY7w/bJ5KCHv6wZ40TOVqMwgLHVl2DinkOEDnbg/hunKq7
         g7Tx/CDmG7Y4TSBa/mwAww9lVvs4bb0wJNH0a/Z2qtWl6yABbWauCfsyvsXj99BPkOLM
         yEF1ofPsUkcVQo6HoTVb+/a2pjZeySrQ88teNX/qa/n07ospAN0iI6+Gbzq1I30HsGYv
         ji1D0gkeXoTHhLPd4ItGP9jbScGxRmWfEek/A4/KhOx+P+0EbvQN408gL/vxX0yIt0Sh
         9+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724688405; x=1725293205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BynQTMQmisTL3nM3s/Ff9E1/xSh6KM8uArokROfN7nM=;
        b=XN86j4doWRKwivZwot4WGCZPsSerCtG6pfmSN5izLcTebCFt5Dswv4e1JRbOm/ED1P
         kRpNciAtDunynBL9MaGRWYnu5UFgFhOBczgk+FGWPNuh4dMoPVMhMREsK0m/+aw4UiQy
         EM35LhYPMs/0MQTKKd1M8EB9ydaWYvf21TuBSHaFoul+cFNlTDeWqGe2UVTCshgKgIzW
         O1bI780tAIKpDwofwPVc+tbnpdCcR4/BAfv6yN3xxyhtYnYS0j+/9D3rNhnxZasv5u3Q
         D4PWFX8O8S7LIsSTZ2W4YOgX5aVJq1QO5ITgPUATgGAgemESTq96lJANIUH4icg0L1NW
         YQRA==
X-Gm-Message-State: AOJu0YxG0ZaemwtTqPMtYr6fdvHCX8c0nR4wt7P6LugkL0orrJqqh+Re
	fE86D07LDrTI4OUsQWUIO8p3nzlD8NLS5LPDhUQMgxj7gpUyjNItDej2z8Gt5vJa4fSo1k91Zma
	pBw==
X-Google-Smtp-Source: AGHT+IGu5PyL8vTVsTk4Bc9xMIMbu9l/UfTusA5mkGKtrJsB3RZoCmjSzYuFMfzLV1OMDGFxZbOOYBBn3Hc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:a0c:b0:77d:336c:a857 with SMTP id
 41be03b00d2f7-7cf54efae8bmr22574a12.11.1724688405258; Mon, 26 Aug 2024
 09:06:45 -0700 (PDT)
Date: Mon, 26 Aug 2024 09:06:43 -0700
In-Reply-To: <002c7137-427e-4bd8-ae9e-04aab3995087@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-5-manali.shukla@amd.com>
 <Zr-0vX9rZDY2qSwl@google.com> <002c7137-427e-4bd8-ae9e-04aab3995087@amd.com>
Message-ID: <ZsyoEz9DMq2hZhV4@google.com>
Subject: Re: [RFC PATCH v1 4/4] KVM: selftests: Add bus lock exit test
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 26, 2024, Manali Shukla wrote:
> >> +struct buslock_test {
> >> +	unsigned char pad[126];
> >> +	atomic_long_t val;
> >> +} __packed;
> >> +
> >> +struct buslock_test test __cacheline_aligned;
> >> +
> >> +static __always_inline void buslock_atomic_add(int i, atomic_long_t *v)
> >> +{
> >> +	asm volatile(LOCK_PREFIX "addl %1,%0"
> >> +		     : "+m" (v->counter)
> >> +		     : "ir" (i) : "memory");
> >> +}
> >> +
> >> +static void buslock_add(void)
> >> +{
> >> +	/*
> >> +	 * Increment a cache unaligned variable atomically.
> >> +	 * This should generate a bus lock exit.
> > 
> > So... this test doesn't actually verify that a bus lock exit occurs.  The userspace
> > side will eat an exit if one occurs, but there's literally not a single TEST_ASSERT()
> > in here.
> 
> Agreed, How about doing following?
> 
> +       for (;;) {
> +               struct ucall uc;
> +
> +               vcpu_run(vcpu);
> +
> +               if (run->exit_reason == KVM_EXIT_IO) {
> +                       switch (get_ucall(vcpu, &uc)) {
> +                       case UCALL_ABORT:
> +                               REPORT_GUEST_ASSERT(uc);
> +                               /* NOT REACHED */
> +                       case UCALL_SYNC:
> +                               break;
> +                       case UCALL_DONE:
> +                               goto done;
> +                       default:
> +                               TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
> +                       }
> +               }
> +
> +               TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_X86_BUS_LOCK);

I doubt this works, the UCALL_SYNC above will fallthrough to this assert.  I
assume run->exit_reason needs a continue for UCALL_SYNC.

> +               TEST_ASSERT_EQ(run->flags, KVM_RUN_X86_BUS_LOCK);
> +               run->flags &= ~KVM_RUN_X86_BUS_LOCK;

No need, KVM should clear the flag if the exit isn't due to a bus lock.

> +               run->exit_reason = 0;

Again, no need, KVM should take care of resetting exit_reason.

> +       }
> 
> - Manali
> 
> 

