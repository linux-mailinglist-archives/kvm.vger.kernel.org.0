Return-Path: <kvm+bounces-68220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DB8D27661
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A94B31215C1
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621213D3017;
	Thu, 15 Jan 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Om+c46u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5583C00BB
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500335; cv=none; b=ZkESwfQblgBD1J84JyvhpkJ7pL7/bEiTshD8/ZHHchgL4K4NPOYWMJ+IZOMhikS/tqgr1Ux+mXXshTrfbCZkYJ1G6DsKMsMnaZoyqj+iUtE+37UitkMgnnL7E2V2yHfs1luOeWyHJiOVh7YarR6jHNrNPTGA5O+jtXogEzjbWoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500335; c=relaxed/simple;
	bh=a0LE2pz2ec9ZnZxSQSRcRwjsTGP3jlsLaZ0l+73KD6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=chm0NcjRMq9/OnRJ2QOe+rUEFv9reyfSDC6jKbUAun1PJc2UbP87LkiIGqBPhP+iGeyc0z8buAnMf7t+t9nYSkesk4nBuuqith53sGorAqwFKyig2gAfJJRqNj2c1hy2tkjSmFo0LiB9oerPa0gmis4iFpg/dABz7PGvCy6fonA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Om+c46u; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81c43a20b32so1001612b3a.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500334; x=1769105134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2byGtWA+XhDCZfdzGd+Mpsof5lNlMqrMFt6k5ec80HU=;
        b=3Om+c46uFj8dgBmuembzvdVtLY3pHnHyDQFBG3tPkC4g0erMYtpjQvGHNR/HJ3cfAr
         50skh+ViTpUo3Qwp9kjVaQFHl0AdTZpgo3HKbRHuF9I/V2lB8EznPXreGOQIHKJK3MRt
         gyrl91rPYZN1V792jmQ0A78kPKyaGTv6eiltapDDu7NHED23TZttII1sgrLrfbyB7uOP
         wkq504eOinoAeJUStHsqS6Js4WnJDg+z6BshChPwysqJ1IHxS03JlbtuarshcfftfsgT
         sTUIm7jETtXoEMqCfyyf56QDPRtCJyZv1m4B6SQjezUbPd1MAaIF1yVJNss1yGmI04hE
         h6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500334; x=1769105134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2byGtWA+XhDCZfdzGd+Mpsof5lNlMqrMFt6k5ec80HU=;
        b=IiaSTEsd3CHrD82oMegQZzQBJmR/fEqwzJrhx+auyNVYKXf8XNfJ+j1KKU7rXhBLcQ
         oP+9rYhDW5VtrSangtRkzkvqMRqKvSqAZT98PFiwWyF2PfUhXEroh0NYs5SfI6G2Uxds
         qs+MKKHGdjvPVgzNzA2dG1WdIWZnI6HZfu5JabK4lV7w6ohrjK+LdzHoz6xGBRcIqCgc
         LepGqBW411v5SCnIUHOkkgYEXodOK9EvykLSZvTTPKwkyoNsEwOsllfS1khdkAXuqv8r
         EIi2MwFLtJRAplIc7hDLsox5EqaYyDooG7NbR3Iummpz+eSQanBLilpuLqFRN9c51UBJ
         K/2A==
X-Gm-Message-State: AOJu0Yzbt9ajiYCkQ4nFQdaE4ZGnYh8WLV7KndGnniFPvf5kQZkw7iDm
	loRrl9msA3+fg+np2yDiFEge0zI+XOc/L+nZHeLLe/AeUPMaxcCccll6hMwEHdHwJdtmyncJxbx
	ChxvH9Q==
X-Received: from pgcv19.prod.google.com ([2002:a05:6a02:5313:b0:c0d:c35:c5ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:d8a:b0:38d:ec8c:7e62
 with SMTP id adf61e73a8af0-38e00c4333amr34883637.30.1768500333659; Thu, 15
 Jan 2026 10:05:33 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:19 -0800
In-Reply-To: <20260113174606.104978-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113174606.104978-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849868515.717654.3745446194809392090.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: Fix dangling IRQ bypass on x86 and arm64
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 13 Jan 2026 09:46:04 -0800, Sean Christopherson wrote:
> Fix three bugs in one, where KVM can incorrectly leave an IRQ configured
> for bypass after the associated irqfd is deassigned from the VM (if the VMM
> deassigns the irqfd while it's in bypass mode).
> 
> Two of the bugs are recent-ish, one each in x86 and arm64.  The x86 bug is
> the most visible/noisy as it leads to kernel panics on AMD due to SVM's use
> of a per-CPU list to track IRQs/irqfds that are being posted to the vCPU.
> 
> [...]

Applied rather quickly to kvm-x86 fixes, so that these can get as much time in
-next as possible.  I'll wait until next week to send a pull request (hooray
for -rc8), and these are sitting at the top of the branch so I can amend (or
drop) them as needed.

[1/2] KVM: Don't clobber irqfd routing type when deassigning irqfd
      https://github.com/kvm-x86/linux/commit/b4d37cdb77a0
[2/2] KVM: x86: Assert that non-MSI doesn't have bypass vCPU when deleting producer
      https://github.com/kvm-x86/linux/commit/ef3719e33e66

--
https://github.com/kvm-x86/linux/tree/next

