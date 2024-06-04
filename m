Return-Path: <kvm+bounces-18799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 187898FB87C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 18:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64E8F1F21265
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED45F1482ED;
	Tue,  4 Jun 2024 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R4b7JnJd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794CF8BFA
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517168; cv=none; b=QFGOgxUurnBBYpRFG9lXP2NTDx4EspIMdRQI5Hu0G5KySeV/f6vkm5EJxBgYpZpAqjsISezW2qpgFfwLBPP/vDHTFLSC9qdqjdLG+aaKphYsyufNu+Cwfj5qlvRj3emmuT2ojFZ4a8ovomWiXpMqOhJ2YkNYQcxWkRLwFamN92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517168; c=relaxed/simple;
	bh=hM/TP5fuBd2nzlsu3f+H7WQfS62CCwe8Vjt+N5ynidE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UB3nnGXd5+fRl6H6tL9uldE2o0/nF8cqSVpdBkmHqVYJPaOZy2Pt2XZd8ml+bNF6W5Xr+qKMsB0D3N8zSTnCaV4CRgcdh5jna4oRsCq7If1Vl9rdEr2M5gyPiZsmnSkYB5MayTTkKJW2vtmqFNm31Vqf7sffcgu9GfVIGVbFwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R4b7JnJd; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57a6985ab58so1261672a12.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 09:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517165; x=1718121965; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O5VQrFzKXcacSK2dpPQ1zSM+Xmxoug7aPj+YM5MTTIM=;
        b=R4b7JnJdf6E3bkaGPFwaSGHaoK7ksgMPRSxzGVQLpgOAaQlvBDnTR21YWyJth7Rg7c
         8B21dd/DOl/31/BldJwWed5u+o+LifteSZ0VEuFgir51gmsyhMfSxCw8AkUcdia8/+i5
         teUy1+sZEXTGzoizTBPlxw6E02nfoTJbyNqoHQLRVQe0Sk3tACSbmcl8AFhbbfqAHRZD
         sniIMSc2WaHRQOdm38jVSmdzxy7FzqnogxgngQpzl+SokfwKYsD6hgqU60KCftLbRiFT
         8TKA2jewzXqIkvlMwTWdO4/DqtuGLy3vleiUdp/53erGf2nLkBfI7np6jKFDz0InMsI0
         nALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517165; x=1718121965;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5VQrFzKXcacSK2dpPQ1zSM+Xmxoug7aPj+YM5MTTIM=;
        b=E0gqtLTz/6uRl52E84Okfk597sMzQPDPDPqwl3vkzAi2hixxUbcLRHoG+VVgqT6YwO
         7+kzUZBTXG6opZKihMJqxbo6Qwgavdhe+UvfSaXumpmpRznj/Em2mvIbL3l5iEQLo6Wu
         /dHQfjUufsIdElajclEAdbGnvo6KKsbO2QFpzS4B0o9QlpKFUMwpuf+ZQ3sImPJ7tJoC
         4pt4RpLnZSynvrb6nnllFy4zmisNjo2HBAZYfLUU06O+pXPc0RFgUe0FCicGAEvn1Bvl
         jl+IH78m4RAnc8+Uosvd4UQ1Y33blsAYCiVfqN0R6idwcy2AoWLn64EvfbmzmIUJuQYo
         exEA==
X-Forwarded-Encrypted: i=1; AJvYcCUtYR27HdbRPG1QXCp1n6r6fzDbchuV9kzPqkut356jTrAnkA9uhDwQI2uZ5Edq7zWwHaeCCr2R/mEzRhQPYJ4y3DIA
X-Gm-Message-State: AOJu0Yzf2VIfzBozavOix0V7KYOf5gKJq27UdxO3HBQjXxArjb2dxJNy
	Qogp1aYEPi2bRkggJ5Kr3eYR7anVDdim7diLFLQlgRswEWCpYt7bUjaNbZ5fdg==
X-Google-Smtp-Source: AGHT+IHjTOc77+v/hrh0//KfOPrghR8jLt/wXqgk/viqeRim9KBVvb5lrLhNkC2Y9ObA7kv+S1+hbA==
X-Received: by 2002:a50:cd9a:0:b0:57a:30fb:576 with SMTP id 4fb4d7f45d1cf-57a8b69704fmr73029a12.8.1717517164535;
        Tue, 04 Jun 2024 09:06:04 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31c6d270sm7488617a12.60.2024.06.04.09.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:06:03 -0700 (PDT)
Date: Tue, 4 Jun 2024 17:05:59 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error
 message
Message-ID: <whzwqltolrms4ct35az5eif5rg25e2km23cztypgikallbcxoj@wtwfckujzcrf>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-12-ptosi@google.com>
 <20240603144808.GL19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603144808.GL19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:48:08PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:17PM +0100, Pierre-Clément Tosi wrote:
> > For kCFI, the compiler encodes in the immediate of the BRK (which the
> > CPU places in ESR_ELx) the indices of the two registers it used to hold
> > (resp.) the function pointer and expected type. Therefore, the kCFI
> > handler must be able to parse the contents of the register file at the
> > point where the exception was triggered.
> > 
> > To achieve this, introduce a new hypervisor panic path that first stores
> > the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
> > indirectly) hyp_panic() and execute it from all EL2 synchronous
> > exception handlers i.e.
> > 
> > - call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
> > - call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
> > - set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs
> > 
> > Teach hyp_panic() to decode the kCFI ESR and extract the target and type
> > from the saved CPU context. In VHE, use that information to panic() with
> > a specialized error message. In nVHE, only report it if the host (EL1)
> > has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
> > which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
> >  arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
> >  arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
> >  arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
> >  6 files changed, 79 insertions(+), 9 deletions(-)
> 
> This quite a lot of work just to print out some opaque type numbers
> when CONFIG_NVHE_EL2_DEBUG=y. Is it really worth it? How would I use
> this information to debug an otherwise undebuggable kcfi failure at EL2?

The type ID alone might not be worth it but what about the target?

In my experience, non-malicious kCFI failures are often caused by an issue with
the callee, not the caller. Without this patch, only the source of the exception
is reported but, with it, the panic handler also prints the kCFI target (i.e.
value of the function pointer) as a symbol.

With the infrastructure for the target in place, it isn't much more work to also
report the type ID. Although it is rarely informative (as you noted), there are
some situations where it can still be useful e.g. if reported as zero and/or has
been corrupted and does not match its value from the ELF.

