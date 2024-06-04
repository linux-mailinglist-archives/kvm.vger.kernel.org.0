Return-Path: <kvm+bounces-18812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E61C8FBFD6
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE6CD2839AC
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5C514E2F8;
	Tue,  4 Jun 2024 23:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sxg8Z/vR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63814D458
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717543793; cv=none; b=g1Nq4tAp8HOqfjaXaHm9plhQF3EvXTB/0xCW4lv/dTBF1zo+IYkLUyQJnIPp3m0z/fRFEAKaMWhX6Q31Ut8rVS1U17fIst886GEgqZI0FWqXlMHMK2ciOsstyLcfFDsSZELwI+2dOo9MVyAdg0dwxNv91GwJHTXqzUvbcoccMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717543793; c=relaxed/simple;
	bh=cMsCRivM5/rPaUXeSQ7yCaavw/L076BTyvOx6aLWSUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/arZWDCGExCXXOHxAVkqRdf4loRJqIElV77aqE9D2QUlButMka6BT346owqflgs2cK6Z7zfENa4+5RLKo85XSb4nc2ma3xuItTeBOdIhOsupYxr2tg/vw8PixxbBDQWs1CGa4B/nRNDukl48R8X36VFJHVJMGu+dpGSFkhDTXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sxg8Z/vR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c1ed594aa7so4178280a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717543791; x=1718148591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yn29SGEL/4hxpbDH7DFjKmYshmIBVrIAEi6P1l/UqBc=;
        b=sxg8Z/vRPkXVGtuMRGNK02uuFb8oCbsfUX7usb6Y8fxFfDwCPbgkjXM/vtQa0xALs/
         SPFTYnkuXCkCxxiwwbVy4Zk8nCCM/alSvjOMjvJHaEcKegxKi+YidlVGOlnKchNHaMK3
         p3pASX3Czdet+nAARn2J1awvkrUj96Qh3JLMqcfoZZfkg8qT34y3OLQS9TtjBtMXv3fV
         A0sNhSovtHnUQSfhnX459tCBir5/v6rS0JEwVNp2GDaT96SfBZqiclqtP1xfKZZYgbx2
         IHeDSvcoCNb3iaD+cUDfuoViMbJZhITgx5aV/M5h7XWrXEbqH/f71xigtLFqriki7ZlS
         dlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717543791; x=1718148591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yn29SGEL/4hxpbDH7DFjKmYshmIBVrIAEi6P1l/UqBc=;
        b=o/GT3qbIBZmBMBXlCbLMYjEA+9IPLTOup/M0sNHZvT6Pnao4aJT1hfbwS14TtSUFkK
         Nzg87hioMBwaV2et8WLFFJg9wz18R3mBjFom/OuCrHAsbygb6T2g2G9Q5qKf0VDFpkZY
         fpnbWa1d4pAPcVEa4dRieJ+Ne/p4ZvAqBOe6YY0/BvC871K8snLr53Zw0BeBWUyGdNkf
         5jkBcRz0UsmQGMovklWUZiTdsrj/F+66PY2IMRAky8Jjk4C9Ryg/RBbJYoB14nvevPz7
         ZTOwam1XT5ploOtStPVOj6qW6HeTp5j7dOJjugZPVXQPC/cOsnunk0hXssvM7s1Xaf12
         uCzw==
X-Forwarded-Encrypted: i=1; AJvYcCV9IUr+fqqajrqADsOYRnSMKP6qnS+L25LQAqm1JsER9rI+tsmZyxcF54TMllo4gnwwKoSum+tzBL8/v0O2ey2IJY9u
X-Gm-Message-State: AOJu0YzXaTmAPEbkcx04i/CxYi6mqyYC5ZyG4MevPwHuED/fH8WLCvNn
	SQ6i6M85+7doB+Aj7fXUNX0xXB5OMfnThBgoI5e1tvOgVNyzZWInJ1a9yYpkW6QETzjONpx/GHl
	b+g==
X-Google-Smtp-Source: AGHT+IHIJmGm0d7thB5hublwsNRV8ES1Xdkm1Wkz06dkR9yMo3R2cAI4IJXA4h56EOAexg6aGnDzmt2FYH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:de82:b0:2b2:b00b:a342 with SMTP id
 98e67ed59e1d1-2c27db579d5mr6046a91.4.1717543791515; Tue, 04 Jun 2024 16:29:51
 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:19 -0700
In-Reply-To: <20240510092353.2261824-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510092353.2261824-1-leitao@debian.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754269008.2777502.9202264224544350112.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>, 
	Breno Leitao <leitao@debian.org>
Cc: rbc@meta.com, paulmck@kernel.org, stable@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 10 May 2024 02:23:52 -0700, Breno Leitao wrote:
> Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure the
> loads and stores are atomic.  In the extremely unlikely scenario the
> compiler tears the stores, it's theoretically possible for KVM to attempt
> to get a vCPU using an out-of-bounds index, e.g. if the write is split
> into multiple 8-bit stores, and is paired with a 32-bit load on a VM with
> 257 vCPUs:
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
      https://github.com/kvm-x86/linux/commit/2b0844082557

--
https://github.com/kvm-x86/linux/tree/next

