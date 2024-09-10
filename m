Return-Path: <kvm+bounces-26193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D30E9728B7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B901F223DF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E47817C7D4;
	Tue, 10 Sep 2024 04:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6ucgW3I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AE616BE2A
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944350; cv=none; b=d1Gfyp4FP0XUXRVFmH6XVKjWgxcfkFTDR6mBN5j5e9PdduFaIO2nUO3GjCc7sZT4JszaEetjV5xj+NLi+j2FPFLuyeUVsVEJAGzfInBMmm9UbMzty+CLcDbFwrDtnWOr7lT0He8YMHprJe4s5HZRv6RrQCghIY1g8MmLrFpJiOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944350; c=relaxed/simple;
	bh=ouhgkzpwSoBeVXbXY8X+LmUez6pjBVVNEOPMNMXmZls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J4lDNafcN4fJJNR3Vph+475SoU30LSz4eh/9zYIHm/7xHdpAztdFSKEiDd5pjl8+hiCaXZWVm2u/lqeG5ObX1V5ZIqC+QffqNtMZ+46MKWgwayr00lbhvfVLUdK34IUppjaVDh8iVViUNmJbZfoTHb4XtRxaRqh+EQQY0XmrjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6ucgW3I; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6e67742bee6so4303240a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944348; x=1726549148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p0ahJSfp9M93ReXZEuheO5wciJUeWk4gpU6ku+sQzcM=;
        b=i6ucgW3IMxni+LXy5Xx1A6HPj+8uW6hqoRfRS8/ePq25vYdhio2RvpugwZjPIa9tSY
         6oy3D+6h8WsxLQ1+Fye/AC/G0dBeOaRXP8WV2PN/ot2F6fZbST1YcyTv7tbqrH83/3Dy
         n/TugmTH8zsh9rUq7IYbJthqUgKgzQyhTmiJcw/gD7aQ9OD1PgaclISp92MdfOb7CuLr
         mgJufX1BfqtrqCf+KKCqe4zRtEce2sdKi8M/eIUPF4EauJiIAKrLteBbPCnSc7AECQ99
         UJFPh3IbZUn3Bcxb5bole7pfReBvPz+2BfSBO5SRYS/iq2KS2m4vcBVBsrpI3Kyksffw
         5KeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944348; x=1726549148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0ahJSfp9M93ReXZEuheO5wciJUeWk4gpU6ku+sQzcM=;
        b=EqKSnxXfi2Hns6ygguutm8JNVsqDoS+wbV9eTxvQ2tutGkj9N14K/bm+yN51dhNv7e
         hH6K7L25lfnVvQLLNPU8Wlw42g6CwhIVfFYQSP6N658DUP8UTrVKT4Kk6j/akiGm+Aj3
         0jw9pQ7mRc4dTlLE1cUup8/yoa7lU/iSPSK8I/ghbAry2UV6NvEnulAFoo9Vknl6a0Oo
         Ln66JiDTbbYrx2ComYUHpZxYK1P+dlbToOzfuT3zxK+vIjhXmixSTNMAG9kr2m/3PBG3
         fUtNCxs9DDOWq2kAngrz38iQaw2kkY/2f+U3EU0QVuUSmdOeFOSQlCxL+mh33FScO2Hr
         VAcg==
X-Gm-Message-State: AOJu0YwohaoJ0CJoQHTy11ttqLE2hfGHQGS+c4u1R1KIFYd1JEdR21ha
	7mqxs36mTG7s47ilq39ingUEyqzAWMTVo/7IiFsWaVHPkccR1FtmvdymeulcMG76vTqSZ9i2ork
	DRw==
X-Google-Smtp-Source: AGHT+IFTdUTOUjVlRVsNA/qwLP2Dx+IJcipHs/IyDfdogMWJJz88CO0jWMetX/POuftq39Bdmo9MzSB3xjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:228a:b0:206:8bea:1550 with SMTP id
 d9443c01a7336-206f06139e3mr9776605ad.9.1725944348518; Mon, 09 Sep 2024
 21:59:08 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:38 -0700
In-Reply-To: <20240830044448.130449-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830044448.130449-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594256204.1553168.9098912435019003934.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Verify single-stepping a fastpath VM-Exit
 exits to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 Aug 2024 21:44:48 -0700, Sean Christopherson wrote:
> In x86's debug_regs test, change the RDMSR(MISC_ENABLES) in the single-step
> testcase to a WRMSR(TSC_DEADLINE) in order to verify that KVM honors
> KVM_GUESTDBG_SINGLESTEP when handling a fastpath VM-Exit.
> 
> Note, the extra coverage is effectively Intel-only, as KVM only handles
> TSC_DEADLINE in the fastpath when the timer is emulated via the hypervisor
> timer, a.k.a. the VMX preemption timer.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Verify single-stepping a fastpath VM-Exit exits to userspace
      https://github.com/kvm-x86/linux/commit/c32e028057f1

--
https://github.com/kvm-x86/linux/tree/next

