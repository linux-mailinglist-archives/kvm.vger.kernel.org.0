Return-Path: <kvm+bounces-68223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C185D2791E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 723583046750
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23DD3D5227;
	Thu, 15 Jan 2026 18:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLPZJA82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68DA3D3012
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500384; cv=none; b=qOI57bkjOWIW58sQUnQ471EYKHcbz3sxiemLyFW90Gr2LDJ8FFdmIufUN9Z5zrZ6TprvhFCXH7Yju2/OhSoIrfNc2YC0MtJ7YCUnpbqDXdVOckk2lzRtc0Dv6lOTPP0DmhGelztJyPrsaNg1eyflXBwba8adbMnhGXn3xr4Y2Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500384; c=relaxed/simple;
	bh=m4cBMpoQDmTNuxlnjK0fxkb/F+VPKRQ1jdsmBXSmkw4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cnwewXY5qozXOsKVRjAbweAyXNm7awCKKfbysMfCPTAxvOhoXaRv23gO5IJod8lWdmImNIiqgqUxVqAk2JM7prWJZWvAMvrYoXxywjjTT+GS7xqdIgpOGYCj72HAsdrWPovgFqd0PHVeUtA5m90DAM3J31L4QKTdt/x2Z+d54zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLPZJA82; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337cde7e40so629706a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500382; x=1769105182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXjBMqGBOy8XLA9ekrI74hql+lXP+iI/s/RyGXfzNLo=;
        b=xLPZJA82ytSOW2IE9Z4k6nqxfV8rES43sUe8kCqRo18t4y/SJZ6vTN6STUiTsIN5RA
         RiVPU1U/urQiN62plV7/OyNR5xWeyoQUCHXJn2gChjjsy4wfOzw26G8X/kQjVFZufuLA
         aEUtf4abe/bD6Il3hASvOKQWfz/KHK1fZT7suPEKT3B2807E3qyzP/pbVztHOwC4Fibx
         NPfNpgroOqym7/8u+xDLe06iInI5l/hYlzpg+j2Y572M+D7g+T6JIcgXULOa+mAqN6iV
         inZQNkLttOwlGPOxWxMuDgOuGoiDFyQNnxQuVfM4256VqOCRe8E8Z6O7aKXt27QuIvJ1
         ca6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500382; x=1769105182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXjBMqGBOy8XLA9ekrI74hql+lXP+iI/s/RyGXfzNLo=;
        b=cLY1B5OsNQKR6VS6/r42TdUK3nzdsgIdz7uRCb419JO9CxWN7ChqIA7cFSklpJDZ/g
         vtsscRZ+blb2p1OsptNSc47/FDQPYkGvfXp5238twm7KIIp68fwXpE1YCFb10kpR+CtR
         WRLe+SoHVsHFdAdE7VVVvUaQrnt1lqSMcuJzL4bySpTwkfJgsa+Zlg3tZXc4SsBnwUQj
         Jv8IEvfRHfMUfZGTPbqMneY0NDgvSlH0/GqmcJkTacPs1f8akFWzcxNZ0DMOdqbDpPr1
         ezqXr/+SfnUR2E5nwbp6lfNL0wNFoChzBDAV2whDWvmGekV12Bjm/Hzr6We5XcOj68Pb
         DRxA==
X-Forwarded-Encrypted: i=1; AJvYcCXvkCo3X6kHhep+tSFYy/edPBpMsOAfLELtywEFec+ycrK7ethk6rKu983gqRzjLQszasQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqCGue7kBaGQbN/Y4EIS+5iefyHJuG30W8Ir0RdEI/k29c8jAP
	2pjL1dtqnNv4zYSyoOb4la8NzJupg140qzoPIlh2yZz9e95LgU7Ld90H4KGR8i5JRHyMgoRprUn
	NMaZxwA==
X-Received: from pgg16.prod.google.com ([2002:a05:6a02:4d90:b0:c51:8b09:2a32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:50c:b0:38d:ec17:17a
 with SMTP id adf61e73a8af0-38dfe7aafb3mr504164637.65.1768500382076; Thu, 15
 Jan 2026 10:06:22 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:26 -0800
In-Reply-To: <20260105065423.1870622-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260105065423.1870622-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849899358.719951.4865343558456057809.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: align the code with kvm_x86_call()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Jun Miao <jun.miao@intel.com>
Cc: tglx@linutronix.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 05 Jan 2026 14:54:23 +0800, Jun Miao wrote:
> The use of static_call_cond() is essentially the same as static_call() on
> x86 (e.g. static_call() now handles a NULL pointer as a NOP), and then the
> kvm_x86_call() is added to improve code readability and maintainability
> for keeping consistent code style.
> 
> Fixes 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: align the code with kvm_x86_call()
      https://github.com/kvm-x86/linux/commit/de0dc71188ca

--
https://github.com/kvm-x86/linux/tree/next

