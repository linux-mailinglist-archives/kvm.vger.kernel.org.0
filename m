Return-Path: <kvm+bounces-39015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E49B1A42987
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C0E4172DC9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E405265CA3;
	Mon, 24 Feb 2025 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yb96jXej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E75264A84
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417896; cv=none; b=HdzJwTVg+uIJ+DhtnRX1UCk4toWD0Ut1m0i8PHyQtthAAsMZlBxUM9VNFqQu03QU3IPYFFWaIbRO51/G8AFB6Y05Eq19WtgxTm1N1apCtUdyI9DFB+BFl3dCMIfBHqXrWqBHOEkoBtOhLRMYnFbQ4sur8kp+LWUMDCCh/8qXPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417896; c=relaxed/simple;
	bh=GqsPGIAHI7LCcTqZ7zptSs4ylqgPbLNPMy2qBFaQz6o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XO1Q7Tu8OWLQVM6KgK7+eFUt3rcj9AFgMp0Eh2a5T8CNVVv1GyjbEQTjqC6LZ+wG5jzhe8ZiFaSsjqEmIYa3AHrq0korgEO0yMRm6Wjcs5yjFQvwnenNySjyPjwPhvRYDIPLryVka+d3A6i2Ih/6ZI+5zewJ5NzogQ03R2puI2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yb96jXej; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc2b258e82so10101976a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417894; x=1741022694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wY0mNxCMVithetIlwrfqq6O2d5wRmS38R9vx9t9hSfI=;
        b=Yb96jXejn0ciKByc1S/wOA91AV9o52MuN+buvh4ztG1L9PZ1ACAFuEJUNBIXOShQIS
         A2Ano5LYZJe0roFfE6d3Kf74P6LPQ3rfJhPnLbFsYtQ4H/aw8Cs+rqFHzwG/X3+Illch
         46X/MPHKuJfYIvsKxjFC6yqRQjKxKRbrcJkegG2GILZF+BTcktVT0PFoXZLkqXTRijgs
         xppYrzMQR408NWpDHTR2U7gY2R6E2CIEIXXp5ayS64J+9omwnnf3leKGoHkzu044mR4x
         +7w1lThcrRH8yaj/r8YG3yruTHE5kVeJJSRWCp86dtvGmGrMeYpmC3iYpMckBqqpDGkU
         ++/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417894; x=1741022694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wY0mNxCMVithetIlwrfqq6O2d5wRmS38R9vx9t9hSfI=;
        b=QbN7dMZKtTaae9gKxGIntC1w38cOB+dfaBMl4XREd7QWtIAoIdbr/xsuTXtP+NJTG0
         XYfme96H416HNCcpLGHBwrR3W1SrqHhGpP92dG2bxd6ZbtB61qxOFxNa4sRowWX35Son
         4sNnuB+HPeon08bjaWyclgM4LlQWkNiW+JYuLhk57MIQsrtZTd6n6jJxifCD5BqoUeCB
         4Swpwb+7EOWiPwUmALWnnvPtNqXC0iO1PBuzkoJtOivZEbu3OTBtP3+9wPT6q62T5DH3
         7qk2M8TjM2Plkf+F3ym8RLia0lv0PnfJnJpbjgRfXy/5ReVl8OYomcnmjYzet1TS9G1Y
         PGaA==
X-Forwarded-Encrypted: i=1; AJvYcCUtsBAic6KEWzfto+wPndrseKp1uyh7P54kwkYF2sqyAJD5NFr04uGRZDqxMSw/i6t2UkE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1PnSDoVHkoG74vGm8Fl0PaWcqR1gnATVO4IcgyjR/+sQWqQkc
	FOI8m0WPnQH8OwXM56ppdaPulSikmkYFf3JgNRfnRqWbjqbT2vDkEin2kwAXkz0xCpMbms9nS6i
	Qmg==
X-Google-Smtp-Source: AGHT+IHhLciMRjkGmVelKijLCFltymbRjT7TEppvUtm0tjiBHKi8pnZQVipJqSG8p8VtG/z+8Lkda+MOST0=
X-Received: from pjbrr12.prod.google.com ([2002:a17:90b:2b4c:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c48:b0:2fa:1a8a:cff8
 with SMTP id 98e67ed59e1d1-2fce7b0558dmr23968669a91.29.1740417894116; Mon, 24
 Feb 2025 09:24:54 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:51 -0800
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240907005440.500075-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041726330.2348748.4497469408080794833.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical
 checks on LA57 enabled CPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 06 Sep 2024 20:54:35 -0400, Maxim Levitsky wrote:
> This is a set of tests that checks KVM and CPU behaviour in regard to
> canonical checks of various msrs, segment bases, instructions that
> were found to ignore CR4.LA57 on CPUs that support 5 level paging.
> 
> Best regards,
> 	Maxim Levitsky
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo).  Thanks!

[1/5] x86: add _safe and _fep_safe variants to segment base load instructions
      https://github.com/kvm-x86/kvm-unit-tests/commit/5047281ab3e1
[2/5] x86: add a few functions for gdt manipulation
      https://github.com/kvm-x86/kvm-unit-tests/commit/b1f3eec1b59b
[3/5] x86: move struct invpcid_desc descriptor to processor.h
      https://github.com/kvm-x86/kvm-unit-tests/commit/b88e90e64526
[4/5] Add a test for writing canonical values to various msrs and fields
      https://github.com/kvm-x86/kvm-unit-tests/commit/f6257e242a52
[5/5] nVMX: add a test for canonical checks of various host state vmcs12 fields.
      https://github.com/kvm-x86/kvm-unit-tests/commit/05fbb364b5b2

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

