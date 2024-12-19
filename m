Return-Path: <kvm+bounces-34109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0359F72E5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 799321698C0
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBFA15530F;
	Thu, 19 Dec 2024 02:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijmOKTem"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4C13D8A3
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576293; cv=none; b=YbCf6MnPqCbiLInebgNxFaxT8IlkVAiqp23yue0cIpI+0+RgNOalQE4GLd2idHxVIxTYTYnN2+aFo6fey2aOdYRSOkOx+VGVvKc9qbZgLCV7FRrzOa1t5uWcGkQZB/i1sM756Hbg6QiP4ucCZYwmMkw5i7QqsnVELyyom30bSYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576293; c=relaxed/simple;
	bh=3NFQzGV87S5jWc8VJAm4d2a+6OyJbOTnKqp2geUzhHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L+R0VxfUrMZMx0QyOHo4XogcUcynX+VNlNKSjT2Ka4k2mhZY3dJeb0NV37gfuaaRcAg+HyI1ySzyaxRE+ov6Gh5dktAujBihyShoarsbyUJV+JgL9evFYLl6iR3CEKgGMM2ZhmBR9nlaEDgSuBm+kUzFzeYgXHosLB+XfmlkXMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ijmOKTem; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fd4c36920eso181851a12.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576291; x=1735181091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tErNa9C/fkg99HNZMayuEnA1pK7Zp9fLfFlJoBw4TI=;
        b=ijmOKTem8IsAEj9xgr2EqUbE+xwwCcVmvpQQVZh9D1c6XJMSbedhzTTgszAiZMdnmH
         C9hnrV1ez3cfb5F10jh0Cy+G7rVj9sPixdWY3s8RIgvzDVyc982qrnT0nwH3Edm5dw3W
         ZXHLXCSewLJiMbRMglXOxT3CkYLWjEZLkzkewXPC+UDrP3yd1Sm+dHVy0DYeZyA+Wbl2
         3TWfh42gwRfEo46MazVtOdFGzHlVX/WynYF5LPKDWajuTOq9C/jfRwBg91xOXGUopGFq
         +N0kpQZDSgiSM1k0I2iAfHmgQs/QTuxoXNw2+DLK1xWzVbvGf6IvQAtiGQd4zW+P7ST6
         DE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576291; x=1735181091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tErNa9C/fkg99HNZMayuEnA1pK7Zp9fLfFlJoBw4TI=;
        b=veqU5gBTx1BnMUz4Fc5udC4yk5ibGJhaPKpp2tcP2o5Eqzeom7NQ4nPCAd6rM1tnbn
         OdGMrqLbqZ6BysjX4SbsEMW/txDjN5Ad71psFxHX1QH0QmHabPjmZ2sFPDT/QbcNohF5
         WmzBsYwHgcfA1Bz8FPnbWytIKnEyOFOObu9qX07AyuHJ7fufg/ukKL0wKxeOr2yyYG+J
         JCdNFgeyApoTGSRSOGY1YF/aWIkq7kYcE6QMXyN1Vx8grmwgbX/I/IEJErfTFazjdDg+
         wodb1MK1X7QJXHIbqTbsgUeWScexkjQf0keg+rNSfJZIPP1s/ePiJVckPwyadMhSyJHt
         Ny5g==
X-Gm-Message-State: AOJu0YwUSf2E2y1VFwgw0MGr/YyJ0vMCtX9bFfKNAJ32AbbhqCxfmYiP
	ixhhYsTPJtFFEPptvO1KZ2/PIXt9RNBTFs2Talq+KT9Gb5Eb9NRpM3vsEQX22A1vQsWfgY4hdX/
	R7Q==
X-Google-Smtp-Source: AGHT+IEEJNCkw1qi3UXIuACUek8sr/YqrtGsFg2fJWsn5UazFfcV3jlUcHhBWzUvmHykLYqkO1vLKoTSoR4=
X-Received: from pjbqn11.prod.google.com ([2002:a17:90b:3d4b:b0:2ef:a732:f48d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4c:b0:2ee:c4f2:a77d
 with SMTP id 98e67ed59e1d1-2f443d050admr2048099a91.21.1734576291311; Wed, 18
 Dec 2024 18:44:51 -0800 (PST)
Date: Wed, 18 Dec 2024 18:41:02 -0800
In-Reply-To: <20241101185031.1799556-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101185031.1799556-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457526613.3291723.13873716422605620248.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: VMX: Mark Intel PT virtualization as BROKEN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 01 Nov 2024 11:50:29 -0700, Sean Christopherson wrote:
> Hide Intel PT virtualization behind BROKEN, as it has multiple fatal
> flaws, several which put the host at risk, and several of which are far
> too invasive to backport to stable trees.
> 
> I included one of the easier fixes from Adrian to help show just how
> broken PT virtualization is, e.g. to illustrate the apparent lack of usage.
> 
> [...]

Applied patch 2 to kvm-x86 vmx (patch 1 already went in).

[1/2] KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind CONFIG_BROKEN
      (no commit info)
[2/2] KVM: VMX: Allow toggling bits in MSR_IA32_RTIT_CTL when enable bit is cleared
      https://github.com/kvm-x86/linux/commit/591ff4670c7b

--
https://github.com/kvm-x86/linux/tree/next

