Return-Path: <kvm+bounces-33527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACB19EDA3E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE85E2813E1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C231F63C9;
	Wed, 11 Dec 2024 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f9HKNs6d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7362F1F2393
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956543; cv=none; b=ax4g1ymTqHcvjmF+2aOT+vNxB5i1fsoDmV9dbFFcfPSSDrU7j6zeMRbe7b0IBBESkKkCafFIKCkwt5NcPEKg0eoDhPSwCrzq9p50j30vZaMwqYMyzpKFx++a4TfnOnicBSGF1c5hPe4Z5etipO6UzFeL89pX0XZhuY/YumrD71c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956543; c=relaxed/simple;
	bh=lt4zBLD00go+8ZTh4scuZr6KDyf46ul1zxnocObd+bg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L/0uHCRvOBYyvPk/nGWL6/zrwwzvedgYLiQ+eiKBBawIG3IvnyfMBjpcN05ZAkS/9j82ZIIXZeSNc5Q4+FnIKjNKlm3pvYDfZh6GP3mmfUkgEvCFz9Z0dzLbx9SjGdKVkx7qXTJiWdD8KNc8O5jtHMScDG/D/IqpnuASvi0/NvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f9HKNs6d; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fd561e68d9so14155a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 14:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733956541; x=1734561341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SVG8ahP/XXrJwp/ghgbGxkrwSNTwBGi72igr84vZWsw=;
        b=f9HKNs6drD3an/kEN0U0KNQZ2s8TSHVJn8UBfCQG3ol9STtymLOxDq7PVvsX3vyp66
         gwZQIlx6pVpYU1qaakSdbjLDxf5iTEKcBlCAeUHx4HF6EUFy8tGr6bBMVB0RHvU+lOSi
         henWblFsm84YO8qsL1mjNV7rUwWDNXWCJfHBlLObyo9xWUhjB9ly0Z7O7SxOAv5+WmxG
         XtSNODavZ354qcn4xqceJdcijWA/ODdy65/W7T4CyLF2xuodYWftbeZC2P1o836waytB
         KinTQYoIqD2Kl/cTtzegT/bksVOTJ+e570OXSb203TeA+2lfA8qkAcTy0SgIbTC5hiAM
         /AGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733956541; x=1734561341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVG8ahP/XXrJwp/ghgbGxkrwSNTwBGi72igr84vZWsw=;
        b=tzDt9qSeH7hZ64cWAtNEQejnuXRes7YvEcxPykAeUgWiTzew5oalqNXSm+jXy2glvm
         Et9t0gbtaAn5/aNK5tHZ9JNFc7szGU2hKbp+wxv0wx4AWrlUzBvxbYAAQcMAjJZRRsyH
         TIUM8HDKjsc7zYHfdR89TwAPdjuZRM3myfx4j/6IdVdhADrUepc5s2+iogEWNdsGRXrz
         pnzMJYDupl1+JaaIx9cHjB3L4uvZ2I6wTrnwC+q4UYRyCMFl4XDssKsnhOgwhqP43iqE
         FhNPi1bOeVKdjILMNxmI0icBN/jTcdzn6n778WPnKwCko25uUw68GmOVqb+Z0tlao9lV
         v0aQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDOmBluV5073kYGQuSPvr/xPpHaCyxo/3GfLLEJeDIZpRavK2TJaFc2dE9Vx0bqEkXLTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF8GrAFRjwWu1c00jMvT4UynGHdUPrN/bXs8B8ttl2l2d1glks
	yxuk7hOXT9dsGrzsN817MZpeCvPBYfhyspqjFDWQLB9yGtNc+Jr3VD2WsdyOS6CfJNFmQ8RYEGd
	1dw==
X-Google-Smtp-Source: AGHT+IGOKgLtrZFpctzdhq5n5IysWDqxKWjxJrTJsdkk765OEG8e8e8bmISVxnp1jIvzrNIQtklA1qJsYYY=
X-Received: from pjbqx4.prod.google.com ([2002:a17:90b:3e44:b0:2ea:3a1b:f48f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e48:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2f1392938a2mr2342276a91.11.1733956540841; Wed, 11
 Dec 2024 14:35:40 -0800 (PST)
Date: Wed, 11 Dec 2024 14:35:39 -0800
In-Reply-To: <20241211203816.GHZ1n4OFXK8KS4K6dC@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202120416.6054-1-bp@kernel.org> <20241202120416.6054-2-bp@kernel.org>
 <20241210065331.ojnespi77no7kfqf@jpoimboe> <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>
 <20241211075315.grttcgu2ht2vuq5d@jpoimboe> <20241211203816.GHZ1n4OFXK8KS4K6dC@fat_crate.local>
Message-ID: <Z1oTu37PmOvK6OlN@google.com>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 11, 2024, Borislav Petkov wrote:
> Btw, Sean, how should we merge this?
> 
> Should I take it all through tip and give you an immutable branch?

Hmm, that should work.  I don't anticipate any conflicts other than patch 2
(Advertise SRSO_USER_KERNEL_NO to userspace), which is amusingly the most trivial
patch.

Patch 2 is going to conflict with the CPUID/cpu_caps rework[*], but the conflict
won't be hard to resolve, and I'm pretty sure that if I merge in your branch after
applying the rework, the merge commit will show an "obviously correct" resolution.
Or if I screw it up, an obviously wrong resolution :-)

Alternatively, take 1, 3, and 4 through tip, and 2 through my tree, but that
seems unnecessarily convoluted.

[*] https://lore.kernel.org/all/20241128013424.4096668-40-seanjc@google.com

