Return-Path: <kvm+bounces-40107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C02A4F341
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CD157A38FC
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1EB15350B;
	Wed,  5 Mar 2025 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jb6gkVll"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB291519A8
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741136792; cv=none; b=unyOGM1pp5vh/yCUq9G9qxhTxdfSkkXYvevuH9prFxXXFf6s5OS3cA4OAkQpq9gJoTkhwhiG2JwLiA7Zl5Y2RRXzN0pKXFJv++5/a4Gi5XOI7WHyObcq/qzP7cnVaEfyPg5rbLKwciOs1k+ZSzPwrr8zunnHY21cwJde15OpFzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741136792; c=relaxed/simple;
	bh=ad67RTxJRt+a+J2/MlXyDezQL0+CpOunjY9DAS/MD1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hZnqPhxTjceHvK3VrabzdJp2NSRzY5QL5yY/pOdnYDVFpP5O2RqdfucociLVCKiOuZ0UNYflr1cVJyHm3DRxBiABdPimlLjEHNCQgZz0A2guj+ct2e68qM5/9Z91uctwQSniPTQgoJYM0/QNRONqyy9nMXOMxDXNfDWbo/NhrLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jb6gkVll; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fec7e82f6fso8188502a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741136790; x=1741741590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzTp4WUyKTQ3OGYFZEy8vdBSSNiKx6aFYbimuEYI7iw=;
        b=Jb6gkVll5TDJDe6AWL5A2XBmU6HT9U+9FR/nXR0OUPmTSt0A/MNNfH0VFHdaGxggzI
         DPO+578X+Rvx3rbgj3rp2CHasG8e5fATN25qvylUxAQaFeO1/o4e7qyC537VWU/0g9U2
         TSFShM7jWMEdmPiHW6unpeRQuc0fcE6WjOCECpHFfFd0uaEV28dQKvLeko2zxlm2tE5H
         mPo0fQlfZ8usIV9KLKjSx6neXeaZGom975NkVKyp8LDLbT6jmhNzToroR6NTy7ZxLTJ0
         6GWoKauoWJ4e6sl9Lit+8wOqGtkZmpc75BJNH0rtZcNDxkIAUJI6XbkANNIqvXBWrFrC
         bjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741136790; x=1741741590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzTp4WUyKTQ3OGYFZEy8vdBSSNiKx6aFYbimuEYI7iw=;
        b=AefL3kKTxOB7pS9BdtTaYh9gW6ty5F8lKszDiSnHvxRePVwMw502Hx1zhKidjDz5VE
         E6wEJd6wqK45EvDDbTfhQtX7f0LgKahGSgk7lUnwiosS5eyUrJStLy2T8smhZybIz6BC
         XqrOiv0waspwb5J1pL6gSh+li01akcSX81CCXeGH1MbJQ5/yzJMbIe1Awcc21wnqu3ZG
         B1hcgD7EmCAx6Ou59Ft3yqNZYluH2Ue3sTEnQN9Yl+EASAhsIN9XAumofSEW/SwEVM7z
         FO2cIMHR4scQoWfnZykQT3rMg0PBhPzKZE0psuAB0lwqsP0d1cSf6sP/oau9FXQybTlg
         6Fbg==
X-Gm-Message-State: AOJu0Yx00KlvwTk9m/Hplnvi5YHzNuhxv87SQJ+J9VAs97pJ/1sACuvZ
	oN0vgPM8Co+u7xwLIcTagKPoBnhLTLr166Ed4U/Wn5kpH9EJfS6QJ7sXcJIVfZRvASLRzJ7I7CR
	Wgw==
X-Google-Smtp-Source: AGHT+IG26rCgu8YRTOp3oqf/0pV8wSLpyGIf0JH/o2kQe5NfU+8+r2psECf5CRAyS07dNKHZeHLYt7veanA=
X-Received: from pjh5.prod.google.com ([2002:a17:90b:3f85:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c888:b0:2fe:a77b:d97e
 with SMTP id 98e67ed59e1d1-2ff49728368mr2329074a91.11.1741136790372; Tue, 04
 Mar 2025 17:06:30 -0800 (PST)
Date: Tue,  4 Mar 2025 17:05:17 -0800
In-Reply-To: <20250227005353.3216123-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227005353.3216123-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174110881033.39974.12863767331940037606.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Extract checks on entry/exit control pairs to a
 helper macro
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Feb 2025 16:53:53 -0800, Sean Christopherson wrote:
> Extract the checking of entry/exit pairs to a helper macro so that the
> code can be reused to process the upcoming "secondary" exit controls (the
> primary exit controls field is out of bits).  Use a macro instead of a
> function to support different sized variables (all secondary exit controls
> will be optional and so the MSR doesn't have the fixed-0/fixed-1 split).
> Taking the largest size as input is trivial, but handling the modification
> of KVM's to-be-used controls is much trickier, e.g. would require bitmap
> games to clear bits from a 32-bit bitmap vs. a 64-bit bitmap.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Extract checks on entry/exit control pairs to a helper macro
      https://github.com/kvm-x86/linux/commit/0c3566b63de8

--
https://github.com/kvm-x86/linux/tree/next

