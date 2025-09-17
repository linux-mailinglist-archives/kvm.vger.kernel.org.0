Return-Path: <kvm+bounces-57945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6971EB82042
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2BC616FDC8
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7482E11C5;
	Wed, 17 Sep 2025 21:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JpJWpihR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A372877D8
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758145677; cv=none; b=tYxkeKdCm1iafUFH9RLGiRGiX+Sjg0SBy+ZGneiB+AwM69km6+mG2CeeSafaKGSDgxK5sgEzd7JCpA9P1l/zZXv0spinYXU5qwAucu99zB7LlbHV8ka6upOL4D1C0WHvBdalbaD/t6lTlqnsilZ1XTi+e9uvKuGOOx8difHx1Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758145677; c=relaxed/simple;
	bh=vDwVGMUwoQIN7wRx8wxfl/H6EhwD+FaLehZCfMpO3zc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hSIAScDqad/4J0PB8ve55z+I+MMyGjY9xcaMci1/hDN9dnlsg8X0yj6C43cUngI+oRSzq03Fq7+l4k4Dap9r+yHlcgkaeQGHav0qvGUbwj9sntbwuzcwDMgK4Ngba/pVC8SX2Rvii/bVOR2ZYvwiQmBZ3Tgn7UM8/RuwNSgSUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JpJWpihR; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-777d7c52cc3so461936b3a.2
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 14:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758145675; x=1758750475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnOjwU8r714Dt21UtDQelJ2X/q33AiLSuVZHKqtjtm4=;
        b=JpJWpihRe6d3+sa2l+sAJ9wWJFuBBi25gCtu9tNUIA+f712Hh6uNTqDmNItHPqMJ3n
         wmZPgxVbN3fStWypkoXahELfXOOduaDodUFwfyunNgRdRyDSrHk8trbmuCoRlR4fvrPM
         Nc8faOMlRs0yhOLmpDPrWlexgfGFEh0Anby9dqh5rJtyokVzvF70Mnblgrra4b/6JYsL
         9vs3L5vlnzh/F2l2nIdvPROXq1emFe1XfTZiQuyOpz81Cxu5iaOu5pah4Lycx6KutR1a
         Eh7VQTgjyz1CasX9ykoiAMJF8n7hdF9Ej+5Qc6eZc35yLPkrZgl4r2i4Qzn00x7Qy3m8
         xczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758145675; x=1758750475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CnOjwU8r714Dt21UtDQelJ2X/q33AiLSuVZHKqtjtm4=;
        b=G6h9hni5qtkyS2h9vRLIGrCg5xdTgSV2PnOwrAU7cVaWEojKU9mEmkzxmQafHEwHaS
         A1P/sxAdacqgknCCogFNHZF77C73Yv8/59NYwCLDquJ6U8wv8yzaVIL0MGRCWh+hN/XI
         1HSRYAc+M44Y4WNJWvGfFysICo16CEM5qwtrueacLmdKIXO5A6GlzzhnK9dgiN/yi5D6
         KJNQviTzrrQVp7aHdDrvC1qkqYHeDp+5hPPnr53RS2ITm7V1yqmGSAhsK2U/5NcEpg8b
         FHy1y6huJxBtfxZ5nurBaRwCxOcdCoy6bVntLHJXharVgUF2KzU1Mi8MeDDTSWC7bPz/
         Wrmw==
X-Forwarded-Encrypted: i=1; AJvYcCXnmg6TkubeUG+fObvMedC8t2EmmJ0Amo6m9S5cAigdd5GmaLp+FnzsSh/9voIAkcyGwgk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0oGZcN9U5GEPV+dxxpyxpkgqwrpVds6Xhyu6zpfVsPNQdDm8f
	tWZGkaiyFAGrpWZeNlBQcw2V2cfO7R27BXmRQQ73VGoCszsK8jgBYP8QKIpGsc35+e8F3G2neU/
	D1FSP0Q==
X-Google-Smtp-Source: AGHT+IEFUY333coW+9O5ChpDApK9jT9ssFMZZMv4IoI5zkYzkCI5j2G8LD61MmxUj2auUaIOAztnx9RjTbU=
X-Received: from pjboh4.prod.google.com ([2002:a17:90b:3a44:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8a:b0:248:e0f7:1326
 with SMTP id adf61e73a8af0-27a8ca84639mr5618265637.2.1758145674850; Wed, 17
 Sep 2025 14:47:54 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:47:53 -0700
In-Reply-To: <aMiAaEMucEeOKiTj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-3-seanjc@google.com>
 <43b841ed-a5c3-4f65-9c7e-0c09f15cce3f@amd.com> <aMiAaEMucEeOKiTj@google.com>
Message-ID: <aMssiS12LPPmDjNK@google.com>
Subject: Re: [PATCH v15 02/41] KVM: SEV: Read save fields from GHCB exactly once
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Sean Christopherson wrote:
> On Mon, Sep 15, 2025, Tom Lendacky wrote:
> > On 9/12/25 18:22, Sean Christopherson wrote:
> > > Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
> > > GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
> > > doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
> > > redoing get() after checking the initial value, but at least addresses
> > > all potential TOCTOU issues in the current KVM code base.
> > > 
> > > Opportunistically reduce the indentation of the macro-defined helpers and
> > > clean up the alignment.
> > > 
> > > Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Just wondering if we should make the kvm_ghcb_get_*() routines take just
> > a struct vcpu_svm routine so that they don't get confused with the
> > ghcb_get_*() routines? The current uses are just using svm->sev_es.ghcb
> > to set the ghcb variable that gets used anyway. That way the KVM
> > versions look specifically like KVM versions.
> 
> Yeah, that's a great idea.  I'll send a patch, 

Actually, I'll do that straightaway in this patch (need to send a v16 anyways).
Introducing kvm_ghcb_get_##field() and then immediately changing all callers is
ridiculous, and if this ends up getting backported to LTS kernels, it'd be better
to backport the final form, e.g. so that additional fixes don't generate conflicts
that could have been easily avoided.

