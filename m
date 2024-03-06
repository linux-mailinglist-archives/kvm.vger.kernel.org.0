Return-Path: <kvm+bounces-11085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51EC1872BCF
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC80A28A673
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D3C6FD0;
	Wed,  6 Mar 2024 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0euno7dS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0D3A50
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709685542; cv=none; b=fIZhr+/fkg42HxyBdPicMztz6Gwm31zFBnIPVT3xm9WlVWqdWgQBO3piNsuwYBzJiAx6YRaky5ywb/vvB8kl9qeiVgNfYqj7iZpoKgpONvE/JoDJlnWGEVaKtI2OsQ80Ar/4y9GWQbOVcpNBe3nub8WLC8Pzp/cSODKtv/LPRv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709685542; c=relaxed/simple;
	bh=19srNkeRmKulCVt7yRP8P5lYwBwZ5dAunV44wgovb7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fo7fCQrEeGV5fuOpiD+/rX6SfdH2lir9d32SmNkekbKWNhMux1ig9tEBByo6LB8j2A4F37D9rR5PPbnIKS5dlxVC5juRZlmDpm/Uob1qFeQVrD0+OQgMYjmfeTauqLTRVL54MD17uBf9yQ+Bl1NFU0axNezp5f8pSiPm27hRHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0euno7dS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60966f363c1so92149687b3.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 16:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709685540; x=1710290340; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/i3rfw64O52qXGZ4d4T6bC7gn+jBl0OoygyLhiTiv84=;
        b=0euno7dS8aC+u17jPskbyw25I+CmThVyNw//SFdM8p0duoJBxvxZmstx0FB3sGNdd5
         AmpKmqx+ECNlPIyI33oEcJKjWN4v3a3F9I3LIscKFXtS3LEOvggtRWrP/Sx8QeyZ7nK2
         hCnHuo46js8srw01wQiVSKMQl5kP/DXQPgM8WdVgjq25NuVVRv3yzLfzAOH7VZDagA9P
         Nciym+UUNNRAl2nRpZH+4PLkM1vHaIlMaZCTgOJuGar1CU7CAeSPdLGGSqcB6lGUVeug
         wKX7S1uml7E0q6DVf3/7lQxNtvNSlubas+1KlYRO9ziLUVG107V5pCgHeTOzYZ8ap9IR
         Yp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709685540; x=1710290340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/i3rfw64O52qXGZ4d4T6bC7gn+jBl0OoygyLhiTiv84=;
        b=KY07Rng7PnVL3mfvn53sUuD2onCuSch3lIeHiOQxm8Fl60BvTUv+CtHFq4FjabvFgY
         rFaLwCdqlPndvfWGsm3X6tIFYvDGTzrk7dBbtXPyNErhfPO9ZB+e0OkCKjrhUii2EsaU
         w7F9yWkvSTf9BKGli7a2vURQUN8k3YuVKse/qgtyLVqgWNKzYBiMZGbypfMxj2/G+p0F
         AQtGIqoSWOz6daw5aT5u44z7LtrYS4Z8I9BIMqudvN6sWbDUE/RVN3v2GFU6rizv1nH+
         0qQ6iUwDX4nj0PS0AXh/vgkV+nl1MHpnzsZ7ZYvJxjQGilw4IFyIj4hWLjx77fmPX7ZK
         bZgA==
X-Forwarded-Encrypted: i=1; AJvYcCXWUBhaZhaMNHJhYFTZXd4FVlxs7Y5rwQgorGuVvaQEDyooLUgi79YJCTYQ9YHAribpJo/K8MbtNdy/0Hwd8qI92GVC
X-Gm-Message-State: AOJu0YyMSV8UDEqlNxb2ifkCB6pwUixM4k1JTxS3xy9/mvOWWPmrdn6k
	nNpka7FlzsJNOjkf1PUKTNztkw+xJ++JOjQMaoK4Ea/xEhXD1b0wBAUN57rMvyliPblVBJDA4dz
	stg==
X-Google-Smtp-Source: AGHT+IFjhgqkeSA0IBuHXaVbpAtmbjXg8WehUV6+fYD7o5Lypw9IdoQz2wGD2lYjE7lDaFO7denBlZbiDQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc47:0:b0:dcd:25be:aefb with SMTP id
 y68-20020a25dc47000000b00dcd25beaefbmr3445801ybe.13.1709685540197; Tue, 05
 Mar 2024 16:39:00 -0800 (PST)
Date: Tue, 5 Mar 2024 16:38:58 -0800
In-Reply-To: <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
Message-ID: <Zee7IhqAU_UZFToW@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Kai Huang wrote:
> 
> 
> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> > Prioritize private vs. shared gfn attribute checks above slot validity
> > checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> > userspace if there is no memslot, but emulate accesses to the APIC access
> > page even if the attributes mismatch.
> 
> IMHO, it would be helpful to explicitly say that, in the later case (emulate
> APIC access page) we still want to report MEMORY_FAULT error first (so that
> userspace can have chance to fixup, IIUC) instead of emulating directly,
> which will unlikely work.

Hmm, it's not so much that emulating directly won't work, it's that KVM would be
violating its ABI.  Emulating APIC accesses after userspace converted the APIC
gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
is shared-only.

FWIW, I doubt there's a legitmate use case for converting the APIC gfn to private,
this is purely to ensure KVM has simple, consistent rules for how private vs.
shared access work.

