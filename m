Return-Path: <kvm+bounces-39171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0760A44BD5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4F5A19E07C4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C4E1DFD96;
	Tue, 25 Feb 2025 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xx4qPyv7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE2E20D517
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 19:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740513032; cv=none; b=AZFpTvU2Kuvtdiv5CLJ4D/AmJFrNry+6BTGEZPzkobSOJnW+Jxqah74Las/+y2LX93qYerFwVETXqqvmIzdR/ujxOcmO1mCe+rg8eEKFnkIuZwZ7NNWyi5t4eS5bIS2CEx6ujK9NafKV2u/M6fBILydJUKEFOnNiXCLcTFo0F4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740513032; c=relaxed/simple;
	bh=1Zy2XDxcWg+1LkmYMbs1r3piUQe9Sjreh7wFFivRA54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jYVu7qGyp6/xKMuGUKSAAQ+r9iy41Hlr2yX9JLf6RPKetEd3CrPuoq+PCP14NNCYv+oyuN/fI90Rg/YrfgC085jDWBui+0LUIG46ewF7rkjoCEZUlI7ISOwNTygYCWe1j9QkWPJgNZJZ4iHhReEPoptr2Dc2F6zLBpcaqfRbggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xx4qPyv7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc2fee4425so19910935a91.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 11:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740513030; x=1741117830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6Et9fr82xY+XYRvIYbqLbXzncb7Clblhbzo1eZXaAE=;
        b=Xx4qPyv7S3IPT8sT48IvG07WH2dWb4yBzLVUdO6eQawYS4VlUN8EpVByzGvjO1cIsX
         MwbYxCcFcTiAkgXaoWOcRUNKMwiEiqhdh5OhIS4XRVHFrQzZ2C59EKVsarsMY6etmrSf
         cEdcaCv6z8EUSPbh9dCesZPUoYTkWQ2Jurq0NIBYznQDeETU/owdSdnlxsP5GNAh2fzk
         HEU7hNq6RDCKoUycUeL6RO24LxghEZ7l9uCPvanDa+Pjbqn2wmpNX0/HpAu/GavSH+gr
         EaokrFFrhXnDhC9g4aaTkjFY0bFTG6EZB5vOQ8NazAxLvLZvP02CVvs0u/79yygmBUnh
         QXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740513030; x=1741117830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6Et9fr82xY+XYRvIYbqLbXzncb7Clblhbzo1eZXaAE=;
        b=k0Gdq5fKN/PIBhlFQu2+LW43jI1aUsabHm/ySLyv6CVdQKAEsWQ0PHtQKu2BrRqzFQ
         HGe6pKoZlW6FQdvrJAEWYmOdD8dycXNm24m77R06iwqDajUekyWaD6h2NI805C+4b/xt
         wL8vo73/k3RFbSNJxoVyH1qWjpjuEOYqPVLgCJF3gTsGKeAaaSgbOUEt0kl5dxSmZCmC
         G/JFrIF6DgSVu8BbFjx1gxi7kjf79QOH35L2cj0iy6083YtRKnfTMT74VN2F5yB3ez/4
         qX6b02CexBRwLvKVNGadxYFsSnhVRtMrdkwXGbwNk66kycWQLhv3og3P48mVe9q2hSMh
         9Zgg==
X-Forwarded-Encrypted: i=1; AJvYcCUjwgGAWB/9m1i7I32wD79p9dyB7u2ren1uhNH77gPBDBjATApuOkN0xXt0hZCqgIqIMYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLA/Sc6g4Nonh0c2XuTj5qu7/ybncBQJgMypgDoh4ovFabYRB3
	+Hn/N8PfLb6Z1JsYYy1gj0f3hX2TuY7Wjo/30+XzecEiqu0rH09p4BVNkZ29RZq1T7dYpGGnuL0
	kcg==
X-Google-Smtp-Source: AGHT+IFG+wtu4XcbCmspoDw9L7aeoOS3H04Pvzf76WDj3NCQXzv9+gVkzgnl5jM4Kix+lDfLumAY6Da7HIU=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548c:b0:2ee:6d04:9dac
 with SMTP id 98e67ed59e1d1-2fe7e3b3228mr829766a91.32.1740513030464; Tue, 25
 Feb 2025 11:50:30 -0800 (PST)
Date: Tue, 25 Feb 2025 11:50:29 -0800
In-Reply-To: <20250219220826.2453186-6-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev> <20250219220826.2453186-6-yosry.ahmed@linux.dev>
Message-ID: <Z74fBQLeXxuiBC-U@google.com>
Subject: Re: [PATCH 5/6] KVM: nVMX: Always use IBPB to properly virtualize IBRS
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 19, 2025, Yosry Ahmed wrote:
> On synthesized nested VM-exits in VMX, an IBPB is performed if IBRS is
> advertised to the guest to properly provide separate prediction domains
> for L1 and L2. However, this is currently conditional on
> X86_FEATURE_USE_IBPB, which depends on the host spectre_v2_user
> mitigation.
> 
> In short, if spectre_v2_user=no, IBRS is not virtualized correctly and
> L1 becomes suspectible to attacks from L2. Fix this by performing the
> IBPB regardless of X86_FEATURE_USE_IBPB.
> 
> Fixes: 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS")
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

