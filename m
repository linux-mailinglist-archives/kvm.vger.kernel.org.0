Return-Path: <kvm+bounces-7515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F1C843264
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 729551F26F7C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631CF18AE4;
	Wed, 31 Jan 2024 01:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G3n7s6iW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1710517C8B
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662814; cv=none; b=bJXz4ImsVJPHch2nOzaqPSR9mbnq7H0kk1kPLv1Aff+YNjCSnYi7cMi9SCt/Bv/vCu8+Q2748znE+4yXYZBiJNc6zc0S25M+V0+8D30/+XqxNCIqqZCWrUsr+uhePWrRZ9I+iUXtcnmGlrlPpuWarjLQVRZQ0faJUhoKVsdOIdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662814; c=relaxed/simple;
	bh=wgGzT6TUDG48PPLloOo3goD71TIEqTK3nSrqgx3qrtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AGLJEUVQfzJGlVeqz3Uyc2C4FgwmXqBgAG2PtpmVHekZb8zhbQ2qy8aWAKHgDBq6Y7ZfJjpEHfuJsAljUd8QXdYBUYcw/ErP0dy3Xhx26CwOxReCwcSpN6g6+nZmBa6KCZZGg8MOaJoiBtORDK4Cn649jWkieyjABTrpBYSJ/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G3n7s6iW; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ba69e803so604220276.2
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662812; x=1707267612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=imus7iG1fygzlM/+HQtDbXSzUkJeHNIgQ1UAJ0qGMVo=;
        b=G3n7s6iW6Eqm1qhJn6vDNSHAgFE87zTNWM2fWo3JNyGsnOpQcQBF3QZs1NxGdQMx/e
         ezkuWRkENccxrXO0DHklin4CB1O2JhrdX1nydy2xaHbJBHgQ4JFW3G+TPQo+r2nOj5gG
         m5lh0PvYoDdQz1wvvoOzwvFffrGUAz3JSslsY0l4vQfNeEszMG7qegn8iWfL7QB5i0n2
         DD0q+UvVgzYSgFXqSLqFY80KutF+uzERbfZkqn27xJIjnlXjXLNFV94qnk2LPUa4l/7s
         a1wNOSdkhF5iL8eH6FtJgmUXHKc/HIePLhI8a+Cb9GMdz2O1XwtLuzTBnXLiqzSv+xNX
         K+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662812; x=1707267612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imus7iG1fygzlM/+HQtDbXSzUkJeHNIgQ1UAJ0qGMVo=;
        b=D4wbAdRY3//TrC8H/T29tkCngfq+FUApB9HJnnD3IU8MGCUg0t3Y+1y1X6G12h6N2P
         pOYKsRC402R5Utb8JGW3zVD4LltrUT57jyD3x5NEbX5v5trftU7W84B72+XmWDuV/n2j
         j9/6SX6ltOIfLriSTn8bug5pU+/Y1Ov2VR1IwycT4sqDGWcV4r9VPZax6vltQIS81pWJ
         Q9VQ5pO3c9bYhGr8IjcqcqPC485FCxuzHf+43MIy7bf7EWOrbYsjkd7xENC7any02bfR
         MFZCyNNCaTXanqmSVvGJ9Hy7eHg5U09rWPymcvCEA7GA78q0v56btWWWaMAJlxljHA73
         1ueg==
X-Gm-Message-State: AOJu0YwMxz3U6t+hzdAR6rQYaodenVDNn6qtsslfLdmNOQreLGlSMNGs
	nkEp4EqW12RUx1TiMHDPstgqhv5Xx/wVM5nW3I08lD33PUtqLrIeIKjapwve8XwVjni3b9PZh1d
	eBg==
X-Google-Smtp-Source: AGHT+IGoolaig8BLWgySJofQnaPMqobQkEKwg5l04qA235dPVfbdb8mdTfDb/M1PXPWp3ev5IMjPTztNJB4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:15c1:b0:dc2:4d91:fb4b with SMTP id
 l1-20020a05690215c100b00dc24d91fb4bmr61290ybu.9.1706662812244; Tue, 30 Jan
 2024 17:00:12 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:21 -0800
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170629088388.3096286.8233473691080181709.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Remove redundant newlines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, Andrew Jones <ajones@ventanamicro.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Dec 2023 18:02:42 +0100, Andrew Jones wrote:
> This series has a lot of churn for dubious value, but I'm posting it
> anyway since I've already done the work. Each patch in the series is
> simply removing trailing newlines from format strings in TEST_* function
> callsites, since TEST_* functions append their own. The first patch
> addresses common lib and test code, the rest of the changes are split
> by arch in the remaining patches.
> 
> [...]

Applied to kvm-x86 selftests, with the fix for the "tsc\n" bug.  Thanks!

[1/5] KVM: selftests: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/250e138d8768
[2/5] KVM: selftests: aarch64: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/95be17e4008b
[3/5] KVM: selftests: riscv: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/93e43e50b80b
[4/5] KVM: selftests: s390x: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/a38125f188c1
[5/5] KVM: selftests: x86_64: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/65612e993493

--
https://github.com/kvm-x86/linux/tree/next

