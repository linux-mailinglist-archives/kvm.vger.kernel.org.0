Return-Path: <kvm+bounces-67797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B8ED146B0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C2807300969F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3B037E312;
	Mon, 12 Jan 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BhTFFfJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2737BE6D
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239569; cv=none; b=HBanCjNmcjpuWv1nXtePVAYbXyr00FgWvKpk+bEY387nkcfYGexd80ASJs6B1n+nWZ8UN1q59LvpcP0ww6emOUz+ALg+7t/sNRqhKpVKS3I89k315GBNlV1ycAqDcgnyE1H5qMFk0Ww1eHN8DUIeU3D/XbqYd766DF+4RrCpLYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239569; c=relaxed/simple;
	bh=CDG2fl5bkqZTC1g7HBj7h2q4O/QW47Lb4qtzNAieikE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=boT5gVoFBgrHjySUwEUTr+n+XmLriHB2AfWf03ZaAgLV9ZEvMxOVIOdzpLHcZiLeHNL0MKOf6SsPnb3pM8v6QvF1kY5bIlIYzHEc/O39AvGI4X8/Ygns9IPLbJujJtR7Fbo5J0stxAtG51PB/OBsP2jZiuPZQDJ6BYm8mmAsi68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BhTFFfJ9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa6655510so7214569a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239567; x=1768844367; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j8RmRv94GbL28wKgjOgTIXNK4m3dw1CDizaMVJiwo3I=;
        b=BhTFFfJ9eC8KdXHjKtFJdpW4AZ2SLkn+geEuw33339vNJMl16cFT2o4OHMC332iPvZ
         V8VZnMpm8XL3pXhkSw1O0dIfz2oqbadboYFS159WvZKZdPfmubayOILGAp/TMdvgJkMp
         FlcN24Rgo7BymWHRK5lJ0VNZIwUXKTtHG7QKpEqMXhFmbtLx+O+YHtykp7Z1pvt+JNCC
         /kg/Mg3uKSZGvV3ebeWOM2A3qivf0dOTsn53oIXHKrBvGVlJHU7heMk7F3Awo7XbooKl
         9yC8yemtdl5lOJYihqTSIrX2ZjkFU5pXztfIzryFpHuWgR8g6IzSWRpGaGAFgJb+6H1l
         /Orw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239567; x=1768844367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8RmRv94GbL28wKgjOgTIXNK4m3dw1CDizaMVJiwo3I=;
        b=QO5FLcVCeMeX9bEgPRenNiux2fqQsHDXtIjz6IRNgqyJ1MkXb8W7JrtKQRjsL34jRW
         XqvVJNGV/i6gke+731XpvHzZENT+wSXOqSXP1FoaIBCjroZfu0BeGLwqM2SRZ22O2zoK
         bYQv5OzZGy8W2KPCaDlUZprWYUXWCuK02LCCmHQOL8WyqpZLjOsW80GYIJb+MFPdp8Dm
         T5/DQRqXGcFLb5Wk3OvY/gZqHggdJDByEV9h3jOH5yhQAzzX5jN9LYElCs98HMa/zt+i
         yXtCCqjODkYQJevwsC4iQpqK0SJg5Y8jpaJSyASoeliaqHji4hRmSjYGz1aj+cQW/BZQ
         dJLQ==
X-Gm-Message-State: AOJu0YzxQq91DtHTjtTGCY15+wVhuT3yaY0gtKjfXhCS3mx5sJxdS11W
	TxJ86WUMREl415mo/l5ND8IREjMbDqrrAnY6vTWP4wZvvPYnihp23e5N+anGfG6euWBpubK76BI
	x1L2T3w==
X-Google-Smtp-Source: AGHT+IGxr47GHKaMmHjacdRGgtQ7JHTntaKpR87DhLyL2RjVraHXmxyuJJsGoYdVx6BiLF83r8cR8Relrc8=
X-Received: from pjee7.prod.google.com ([2002:a17:90b:5787:b0:34f:8ef8:5834])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17ce:b0:33b:bed8:891c
 with SMTP id 98e67ed59e1d1-34f68c019cfmr17859070a91.23.1768239566856; Mon, 12
 Jan 2026 09:39:26 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:34 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823923122.1373976.1415505209221612254.b4-ty@google.com>
Subject: Re: [PATCH v3 0/5] KVM: nVMX: Mark APIC page dirty on VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Nov 2025 14:34:39 -0800, Sean Christopherson wrote:
> Extended version of Fred's patch to mark the APIC access page dirty on
> VM-Exit (KVM already marks it dirty when it's unmapped).
> 
> v3:
>  - Fix a benign memslots bug in __kvm_vcpu_map().
>  - Mark vmcs12 pages dirty if and only if they're mapped (out-of-band).
>  - Don't mark the APIC access page dirty when deliver nested posted IRQ.
> 
> [...]

Applied to kvm-x86 apic, thanks!

[1/5] KVM: Use vCPU specific memslots in __kvm_vcpu_map()
      https://github.com/kvm-x86/linux/commit/44da6629d282
[2/5] KVM: x86: Mark vmcs12 pages as dirty if and only if they're mapped
      https://github.com/kvm-x86/linux/commit/70b02809ded9
[3/5] KVM: nVMX: Precisely mark vAPIC and PID maps dirty when delivering nested PI
      https://github.com/kvm-x86/linux/commit/f74bb1d2eda1
[4/5] KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to vmx.c, and rename
      https://github.com/kvm-x86/linux/commit/57dfa61f6248
[5/5] KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages
      https://github.com/kvm-x86/linux/commit/c9d7134679eb

--
https://github.com/kvm-x86/linux/tree/next

