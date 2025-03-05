Return-Path: <kvm+bounces-40106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99060A4F33C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4021A7A4F2C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE4513B298;
	Wed,  5 Mar 2025 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCdbfATg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B3F136988
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741136773; cv=none; b=qV932PqlraH4cVBcM4GVVa6TtlZF8gD3IQfoyHyeg5LstiJXoVjWDqzfCEu0JHRz+F90ZE5QG4PtFIzftF29ZDvOKI1hap5G3icjhNZGbtHoFYI54ETxvmBOVGNkUANOR7xJ8+y2cwbt3tUtXDeALHHrg3huWpwa7IsdiVfodMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741136773; c=relaxed/simple;
	bh=SXzjYBAmbixh9anaRr1dJ7QeFFB+ALNffscWjHcghG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oupl1zuN5C1f1T7jygMsJSaI/Di1i0FmaPh36UzdbiiVVP5CGXT1cVo0iQC0G8Nvi306386QxyULI3wnsWk+VGpFERgzRWw87dUe79Nk3ZsN67DpA2U1TflmXd1jlv+6aLm1V1s4AUexD3xtL8rNsI0Ic1k6zdDwf/IKUAx3EvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCdbfATg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fec1f46678so14631743a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741136771; x=1741741571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9dQMVONACc/ChRDXXSj2E+97tCqbKUw9XyI1vlcsxSA=;
        b=qCdbfATguF9tMgJYnfARBowRR1ttJaSweCJC5ZmzROf6uFT/af4T8ttPHeC6oQAw1M
         Q5gpLPQyugj/L8QFMTlchzw9iL++QfMQ0Ky903PkLEDAcc2IMqe0GCe4lPL4PGOZVJDB
         l+kvwoGVn54V7DI74E+kNfHXJ8sMwHAL6j9/QwmMG0H3GF8P3SCvj/kgJcblwNaqiF4d
         R1NxxEQjPUc2LJtsnTVHpInaEQaYl7fteI5iVgSrENbQDeQC21ohoguK/+jyrJuXaj68
         2PjwykNtrSlMtHow/JmZtL/070w8StuA82d5FG9TzBCVdRCHyNjuV72ZDoj9yDScdbD3
         JsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741136771; x=1741741571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dQMVONACc/ChRDXXSj2E+97tCqbKUw9XyI1vlcsxSA=;
        b=RTGQN1lAbcL38kmjN8X2sqBeU7NovmDPvCYZZJqVTzsAHwr6zJTSU6UII4/34L5CiH
         d5GU9IpKcQAU0vzc/kAJD1DMFyFZRtI1zLGK48/Me5AVUrfxueiV7HreXJ+MVWm5fcNc
         Z14zRuIoX8GIwFr/QkQ9aaKb6fzzGxgK2ZrTI7F7/GXo9NTffIayOWBsjpu90K+Wh1NL
         TaXNhOF09OMSueDWkMnd1wFDdkt4CjgR0G4gGCS3dkC3m2RDzx2g/RFYsKp4qxPNFYcZ
         FTzVkhOh5jrNjPyMFBRZjieuKSm/0yTVW2mgpxWVn3kodq2wIBfwzyQKJqqsyxpArVBl
         2c2A==
X-Gm-Message-State: AOJu0Yzj+fgZ2cWERSIjf9X4Zds2vw6SQipqSeOusudp8Q0u9Fn2rrno
	TUtXiaTFXeAg2UNZ1Ne2L+c7SgjNpza3Sl/wOUoyjqZI3Aog+R//V38p2GKCJ1U1vVCla/+g5no
	sqQ==
X-Google-Smtp-Source: AGHT+IFJyL5DSsPfc7J5dgze+5EPuz9vZ84n5U1hHAIRYR+TQzk1rbdMEvItgD8yqCyw/CELtjntpL3YSIs=
X-Received: from pjboe13.prod.google.com ([2002:a17:90b:394d:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cb:b0:2ee:d193:f3d5
 with SMTP id 98e67ed59e1d1-2ff4978fe91mr2442244a91.7.1741136771305; Tue, 04
 Mar 2025 17:06:11 -0800 (PST)
Date: Tue,  4 Mar 2025 17:05:16 -0800
In-Reply-To: <20250226231809.3183093-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250226231809.3183093-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174078621049.3857714.9685413190678445101.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Relax assertion on HLT exits if CPU
 supports Idle HLT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Feb 2025 15:18:09 -0800, Sean Christopherson wrote:
> If the CPU supports Idle HLT, which elides HLT VM-Exits if the vCPU has an
> unmasked pending IRQ or NMI, relax the xAPIC IPI test's assertion on the
> number of HLT exits to only require that the number of exits is less than
> or equal to the number of HLT instructions that were executed.  I.e. don't
> fail the test if Idle HLT does what it's supposed to do.
> 
> Note, unfortunately there's no way to determine if *KVM* supports Idle HLT,
> as this_cpu_has() checks raw CPU support, and kvm_cpu_has() checks what can
> be exposed to L1, i.e. the latter would check if KVM supports nested Idle
> HLT.  But, since the assert is purely bonus coverage, checking for CPU
> support is good enough.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Relax assertion on HLT exits if CPU supports Idle HLT
      https://github.com/kvm-x86/linux/commit/62838fa5eade

--
https://github.com/kvm-x86/linux/tree/next

