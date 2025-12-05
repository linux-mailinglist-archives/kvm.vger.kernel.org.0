Return-Path: <kvm+bounces-65362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E8BCA8840
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 18:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C75D3242AAD
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 17:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C3E34CFDF;
	Fri,  5 Dec 2025 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GpBvGa8l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E2034250F
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 17:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954024; cv=none; b=gDfGnWdN7BrHO3eNwLybrcmF59za9LpGK2d/jL5WIZmZ3Eb7DhpKo2enHCKxwKeL1piS1jDJlkZRr3FPOy7jZM+pxrNXAzKqxRKqTE2UH9codX7KHDOGzBrkyA5h68RiTBlIAMr6jzUnZyP4t9jepTGOCGeRnPA56Jf+x30/tuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954024; c=relaxed/simple;
	bh=DHNk5w9XwMwbV9CixJzEXeub5jf6A4O9Fnq+bSSpvBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IgX3RRvNKsaxRFnUae092X5MXPCt+zAkx75XAW4RqIBPP1b/QGC4l/IaNqeYkbp0tGn7Wpg4ZNmYK1nnBMyOOscVEMlc3qIhl7mYm1KRe5HTlORn3+Lfqw0QDrHlN6/Pw2Mx8mbdwrRn1guZf9K+uyD5GYzVDU5Lk9mI/E/U85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GpBvGa8l; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958c80fcabso52155365ad.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 09:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764954013; x=1765558813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n2gYfoz6OBxfy2iG9IvxpX8oLw5cF4SiJlpoRIbvvvo=;
        b=GpBvGa8l4ByrboR6idAncBNLiyvzMX+qPDbskI7ghdMUmX16GWz6jvrwCruNokTt0I
         DcNVVbvP+jEiLEkhUm5WGB2Dd1AWI8Zgl1eJ6L/j5aiOj52xH3XgzxtEMIfMWblEmf1K
         2FCPH1x9RgRSa/hipVTMFbTZfi9jyriFZukB+Pnr3vViTxnIT/f4OJMva/q/6HRSKa9V
         GnEbSp6Y9tPKLhJHNx4mr34VgW3E5mVFBIGDTAW0DKFoUOOqVwS+YdPmeHwQBt9KO0nP
         g6ouAHXidFFEoCtbHglfWbmMJGTspKkynN07rOHai254FzEJ/eOKZ8YJJfkem4HTm9pP
         YqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764954013; x=1765558813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2gYfoz6OBxfy2iG9IvxpX8oLw5cF4SiJlpoRIbvvvo=;
        b=mek+OKkrjDEM0P/ftFXMVG4+cykFGSCMlCz2gUDVztBiVGA7Kj8yNCHUW2IRUV9A6/
         NUmuxoZZhaAEr/qEdjjooKij3U9UZUB3oOaX03jqOzF0WGbGccYSXhOAMMyf7XAp6tiH
         eL5s5Fdr9nbkskVEv9qf0ZhRrlCn0024l8w09V0az+zHSkljRZTXkXGezYtVCVHtCwZF
         Tot8anKuqm065YEgnnZIQVgvZ29doRYTr4OcVNTGcRVRX3IuCND7y0AqCWlFQDJ9NKx8
         nIe3I4yc9Dn+UUGNqNWXG92aJfeuNi1l6X3pz0TEFHCOlMzVEJS9La6CEpwzB6YYu6Qa
         E+EA==
X-Gm-Message-State: AOJu0YwzBVa6tUgCYCMQ4P5WOPYflmnKLDe95VUIfxAp24WORt8ufpc0
	6sqd+82vJ77xMzs9FiMKZygekCT28Qz2xO5XHLu3SbW3ZsA98xL8PcgqVNVSlzSNrvGFUl01Xg7
	3kC2fpA==
X-Google-Smtp-Source: AGHT+IHTewcuK4468H9YP/872oeRWG0b+MNWtRerydq5/7oXw7h4HToXu6iciqteusC+zbCGaDlYOaNUKM8=
X-Received: from pgc2.prod.google.com ([2002:a05:6a02:2f82:b0:bc0:a646:a342])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8b0f:b0:366:14ac:e1f4
 with SMTP id adf61e73a8af0-36614ace6dcmr824505637.70.1764954012983; Fri, 05
 Dec 2025 09:00:12 -0800 (PST)
Date: Fri,  5 Dec 2025 08:59:27 -0800
In-Reply-To: <20251202020334.1171351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202020334.1171351-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <176494720872.296359.3976381514002984346.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: Fix a guest_memfd memslot UAF
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 01 Dec 2025 18:03:32 -0800, Sean Christopherson wrote:
> Fix a UAF due to leaving a dangling guest_memfd memslot binding by
> disallowing clearing KVM_MEM_GUEST_MEMFD on a memslot.  The intent was
> that guest_memfd memslots would be immutable (could only be deleted),
> but somewhat ironically we missed the case where KVM_MEM_GUEST_MEMFD
> itself is the only flag that's toggled.
> 
> This is an ABI change, but I can't imagine anyone was relying on
> disappearing a guest_memfd memslot.
> 
> [...]

Applied to kvm-x86 fixes (I'm feeling lucky with the ABI change).

[1/2] KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
      https://github.com/kvm-x86/linux/commit/9935df5333aa
[2/2] KVM: Harden and prepare for modifying existing guest_memfd memslots
      https://github.com/kvm-x86/linux/commit/af62fe2494da

--
https://github.com/kvm-x86/linux/tree/next

