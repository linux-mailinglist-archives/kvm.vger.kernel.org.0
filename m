Return-Path: <kvm+bounces-30226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F9F9B83B5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83C521F226E7
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B92E1CBE9F;
	Thu, 31 Oct 2024 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2UKputQc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF7F347C7
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404417; cv=none; b=j4iMsBiGhVRjmXgufbhsKyih1tEE4caNA2sH0czyQs06aRb4RiVOim3qnkHQ3MkabQWqN2uZLYPo8P8DV14cz0+tGrTy86ek+Fvh5bCwGw8BMhK6+lqrgDphDXcYGP38W7AlFCqLBhjlQ/VJh2lXE9RAKZ1cQ0KIm1uOeuBvjbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404417; c=relaxed/simple;
	bh=FroSOV/uD5rdzEaLIMdl9JXIy+2JWa3hTbW339w1cW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VjmVMEjr8UeZ3ovDfdu3408KXZTNao+xplUyl2ZEfr5jjk4sfiIHf1EqpVUl1Z0cYqsKyFaRWPK0OF8clo0cmrwm+4VJllER+koE+e8Bnzi11mwtMmHg8VDTFsZOdRYCuGNU5kQRWGvu72jxM3iAETtyT/XVKh9aTI8RBTsi5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2UKputQc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eda7c4f014so1219103a12.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404415; x=1731009215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDryuS3JwdKmtkDt/QNqzIISsjjDc6tSvCEk4zlonUE=;
        b=2UKputQcUQhz6JuEz0yF/Skk6de22nc99lxi2D2vv04WoUE4nsqDahPvUqtoUGPuEU
         N9QEwUyGMIOFtgsgsTIe3zQG+yd25wOjRMtNB5BcFfwamIvJPBP0wkYxlZmg3qVFZ1gZ
         J2U3XNG3SwYE7sUWrNdFqlUyMGVxD0khKp3+6WwtfuU7h+tnh1AIpj+Pm4qubjr1nb0M
         laVcGwcIJ9eeZbtF+hnwelyzZI2OA6yj/Zr/YDc4DyhsmtPEss6HlhP84PpxWOyOth5x
         cW8CLfHRhcDjBLre6MZsnQkr3+OaRAUBL2qi62VdP4kGCPoA8nOotkLOMCNvznRyTa0A
         XGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404415; x=1731009215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDryuS3JwdKmtkDt/QNqzIISsjjDc6tSvCEk4zlonUE=;
        b=p9zsHuKvvTi604NPjjQcVaIiaDB7zC+MKETEYpAl7Yy167bB6YTQ6hJATsPZ3/M88a
         EKuSoJMJlAVC70QmAvInut+0RWUndcA6+bCRXeiEqdh6/atliE5nntdiytDiq9hbcALq
         P3UfwgdNiC8SqLpJnv+HSNxzLNrX18/NIgiaMMBe9gFpU1PU7nXViTiRs8ogNFQxsAH3
         H4ma5VFGH1UCXeohXOqVJLwzr08jg8CK4l/DQpWsu4Sza95wt2fhqQvVGoYtLJoIhPkd
         Y4D32DmxlbJTYGmZuRvhcv0fUfxZL7bLo6QkSFFBz0neYxXS+uH5Gi/OTPNoiqhDtmrY
         pjjg==
X-Forwarded-Encrypted: i=1; AJvYcCUFhgjXOepzvKjSDn2ayavoG1gB8tgDGgBgyGew/ui5P+pqiZeV/uy8qGXbTvPaPJoZuLM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Jq0b9nd8GXhn78TAH7ERBRDxrnuL3uZwmhpCX0DwoMJN/uPj
	sEWzUtPYounzmC5CFvBrkq2DMuQUMQSS8JZv7GpFM+qORNqrg/KjOi8/VHtDp9BYZY87g5L8fvs
	Xbg==
X-Google-Smtp-Source: AGHT+IEYQskIydQ17rOCvnDIIztIPwEtV42Xo/Yb7l4NrEHNVvMPUaIF0Ogt4/xaQ903hVU90IvPM22EQH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:385c:0:b0:7ea:999a:7930 with SMTP id
 41be03b00d2f7-7edd7b6c7e8mr28419a12.1.1730404414918; Thu, 31 Oct 2024
 12:53:34 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:29 -0700
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039527102.1510350.14562788857137656763.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: Protect vCPU's PID with a rwlock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:01:34 -0700, Sean Christopherson wrote:
> Protect vcpu->pid with a rwlock instead of RCU, so that running a vCPU
> with a different task doesn't require a full RCU synchronization, which
> can introduce a non-trivial amount of jitter, especially on large systems.
> 
> I've had this mini-series sitting around for ~2 years, pretty much as-is.
> I could have sworn past me thought there was a flaw in using a rwlock, and
> so I never posted it, but for the life of me I can't think of any issues.
> 
> [...]

Applied to kvm-x86 generic, with a comment explaining the vcpu->mutex is the
true protector of vcpu->pid.

Oliver, I didn't add the requested lockdep notification, I really want to make
that a separate discussion:

https://lore.kernel.org/all/20241009150455.1057573-7-seanjc@google.com

[1/2] KVM: Return '0' directly when there's no task to yield to
      https://github.com/kvm-x86/linux/commit/6cf9ef23d942
[2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
      https://github.com/kvm-x86/linux/commit/3e7f43188ee2

--
https://github.com/kvm-x86/linux/tree/next

