Return-Path: <kvm+bounces-59919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4021BD49CD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7B54189FF88
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E4F3101CD;
	Mon, 13 Oct 2025 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VixOhuDl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FF83101C7
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369780; cv=none; b=mP24yBF+oKkk6V1wAsfACFGjxt+EvsUP1h7zwZDZPVOrO/34FfyOiFNj1VG3BMhsweHwDY+0p9YiZZwy29opDOaH+mnALp3jkgTLLhBjbdDvQ/p3+M60MBi32LFWeag8nr38YMvjNYFLcmtzqCVDbx9sAtEQtPBCwx6nz/0RLL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369780; c=relaxed/simple;
	bh=KnbiNEI6jdfFoyCXFlvrrBN2LNaWnjAsJojkaDAb3zY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G93oHhcsxgcNM4U2NeAnwfgVYHa+xsqn+SEl3iPfQU78BXvS0RLgWCZvvRbUKI8uOyJ9xQ2iHDmG/Xe/s2hllAsTiOTftbLLVypoXpfWckXLogG47yyhkNFyEMSECWSWn61CmnejOI/cNCpYB3r+l4/KmEvHP4FiG7al7fpoCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VixOhuDl; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e473e577eso30156875e9.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 08:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760369777; x=1760974577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FlFedRueswZiwwJSvXOIyDnT3oPzpw1Sfa+/cqnl83o=;
        b=VixOhuDlRMASSH2Ew9mehjOzjWokkcGCCRdHf8AMO5OClJ0Fr0LOTdvRH0mi5A5XiH
         kO4fsUFGI4vYu5qL7MloeBxssldw0PWI7+Zdu2aThISPeR89vLFbGncEXToXv9yEIht/
         4qUoDYr2tizImnE9U5fOHCKUFwq/tB6vesJe8GcD9dorknx3kOaJqXvUuINv/xkiWkkA
         m5n4yMELxn/8vlGCti/YwJdzZQccm6U64lVXjalFRZugh+iTkNibpfuwjmpyg4O8ztkr
         UHRdtGiHjtK6ovbfur5eTWOaEGucxrG/oG9q4+pdXWVn9t3pDL2kdj/dVSoNGpQiDLeB
         hhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760369777; x=1760974577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlFedRueswZiwwJSvXOIyDnT3oPzpw1Sfa+/cqnl83o=;
        b=wJVOLSAerQiwmrfu9It0LzHmM4H3038Mi+RFxkyQBpaOXaXtMajU+2xHJ+zTkP9Hkn
         LHTSlqwn/Y3o2RV7j1XZuzjVRSmXUaKX+6gxXtnO0MeP4s2mfIdGNSQG8Y2UFJRMyfvE
         qWdz+fbzfo08mDUaNLPpFE40mjuUymcVBLhbLvcBzEr3CE6gVhgEIKgQT5/H2nXFA2Ot
         cc5r3WmDNlOS6XDioqu0/YHucKbcP/yATm6yVkyfilZJQ2HSiY5jI1BLbDFh01edvyUk
         6iOsIp6OzecNXvG8s+kiiibLPhUxwr+jtuohmrm7IVFHq0eqm7lqzWcTQ1HgmpijAZi/
         SLDw==
X-Forwarded-Encrypted: i=1; AJvYcCUOsCk8awQ7qYjoqpHxiPoHxvZnrcutX23cBuwske/sr+9oZgIuG/G4vJh4RwGhXg6tgxM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6s0j1WPzFJrkxkRxPX5RZx+jxKI7E1hYNxy0MgDa8tH/4aygO
	fchnl03PCQi+emHokGTTNiXwEqHaAqxU1oBkowqZ4lZ/dvbqYkChP1XuTUcv8SG9KT58GyQdSYW
	i2M5eQ1PtG3YHuA==
X-Google-Smtp-Source: AGHT+IHe33aTc6DLr2QuBitaWmdhOm2nkmbEu0YxgnPqOB4zoPd1RlYBlwwAqBGdVpW1YUG3fMQrmSmUYvbqkQ==
X-Received: from wmby12.prod.google.com ([2002:a05:600c:c04c:b0:46e:3771:b9c9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a341:b0:46e:74bb:6bc with SMTP id 5b1f17b1804b1-46fa9a8932cmr136710475e9.5.1760369776743;
 Mon, 13 Oct 2025 08:36:16 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:36:16 +0000
In-Reply-To: <20251013-l1tf-test-v1-2-583fb664836d@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-l1tf-test-v1-0-583fb664836d@google.com> <20251013-l1tf-test-v1-2-583fb664836d@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDHB06W60S97.3GDEC7DRZFQEJ@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: selftests: add an L1TF exploit test
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Shuah Khan <shuah@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Alexandra Sandulescu <aesa@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon Oct 13, 2025 at 3:13 PM UTC, Brendan Jackman wrote:
> The test requirements are: the machine is vulnerable to L1TF and the
> helper kernel module is loaded prior to the test execution.
> The test should pass when the kernel enables asi (asi=on). 

Agh, sorry, I missed a bit when scrubbing the commit message, there
should not be mentions of ASI in here.

