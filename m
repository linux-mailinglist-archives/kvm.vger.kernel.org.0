Return-Path: <kvm+bounces-9464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A65D860851
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1062E1F22384
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07447D510;
	Fri, 23 Feb 2024 01:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vaa17W59"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D3C946C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652169; cv=none; b=I6XT46H7COHrQudJHrJmIYA2Agd9dzEwfRuQ2T0aSvg3E3Q4sjKGaseNqrDb2MGYv3wAh1tphpOLA9038IW6abqdHhdsAryKwb9a5tyzhXhXQ8byQbkOxQ71v9LNcMG+59WjgLwNjY23NX9B/J8Ae0aAfxQsHC5DyOKEfoBgmgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652169; c=relaxed/simple;
	bh=Sq/4yJBd9ML0c0fLMROZQYqcV34f5yTAEpAVQYIXi7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a8yTmlssMwlyzbp5jLLjkcKc+7wwMwP1Ymf4Ocp2xMtcpgasUqkG4xS7RqaeZsONxeKnHVvC8uXJEKDd4tErUn4H6gqD2nrWOjz4mEsRuLEfVtycwcndhnvMLLEPAhLXYOcQVcZeH+NCB7n9Q0vTp3ebRnQ0kYFwf4IM9LdFrkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vaa17W59; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-290e7a0a585so287786a91.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652167; x=1709256967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZmbV2p8JhGrv8njDEn0OfasK7J8Wpatj2TP35lEcZo=;
        b=Vaa17W59YeH+XJQrQvNCSwyHTC5c/yazPpK1wXo/e5dnLkECAdX+Qpc9qAYikFypvL
         FZm8uyGDKJ35mxbe/GxcE590eBHk5OkNd0bPHEYugQC9YOk1yYwsDWvgHDUvE8m9/pYF
         FiHLGk9FD1oZCiMp3N6/XgHWhSUHUS6YGnvc7m0zgnfszpEYFetBELH7uGjK/cmWpAk9
         wcY9G1tQnRFNBtP/u5H7V+BPOrZ8DLY+pV4Ldvh4UVfNX+85zNM8uhGgNgZft3FD7tf7
         mlyKfoZzWIlz0rlqpHTJHAM7jHSPu6pA3XtaMqwlSRlnHMC7EIBNLU3pP1hupJTg+/kn
         Xw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652167; x=1709256967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZmbV2p8JhGrv8njDEn0OfasK7J8Wpatj2TP35lEcZo=;
        b=VCcPXGna/nofAQ4/LcRcw0PDBuGjhTGvEJuhXUEy7pWkerVZqkozEClp6daJnj1YOY
         lKk08SvQOIJJFH0V8NUNX/cWcmaCP3TMnkFI0uHfPvfF8EpX829DTl7JhwtUS3YRo2jl
         QIthL+Ei6stKFORs2J3XBcpksB54dJ+HZ5T7bgC9rNomUYTsDGZ0ajAnXTDeQVAwOEmH
         XH4jnu/SPJoL8U29W++9O/TBXLzoZYijj+9EdVTaPT69vfmRAmtR4bE1A8B/UVRBFJLK
         EqFCPTDzrdyurFzpt9nrktuXabFJBTZFVBZG3aAsDQ6zFFKP2sDaizgjhmvTtqeb+9y/
         Yrig==
X-Gm-Message-State: AOJu0YwQlswgbx0trhi8QCoavVapKaYvQCGENkG/oyF+kXVYx1mMxjNI
	4s/gHaQwYkrZESLs39aOlHfzyX3fco8Laz4+pzoucxKxP8lrTijZ1sGjgqMACiEjdh+malvD7Vg
	NjQ==
X-Google-Smtp-Source: AGHT+IFIRlJSSVNfaZIh1D4Tx2tEKRHkKjKJlAmofoumEeaMvCyMdcX2UmTyxR+F+By67hFGIjPatd/z0EQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:524a:b0:299:5139:49d6 with SMTP id
 sh10-20020a17090b524a00b00299513949d6mr1657pjb.0.1708652167068; Thu, 22 Feb
 2024 17:36:07 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:36 -0800
In-Reply-To: <20240222190612.2942589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222190612.2942589-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170865047682.3113211.8370189842632253595.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: GUEST_MEMFD fixes/restrictions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 Feb 2024 11:06:07 -0800, Sean Christopherson wrote:
> A few minor-ish fixes related to GUEST_MEMFD that I am hoping to squeeze
> into 6.8 as the they affect KVM's ABI (especially patch 1).
> 
> Sean Christopherson (5):
>   KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY
>   KVM: x86: Update KVM_SW_PROTECTED_VM docs to make it clear they're a
>     WIP
>   KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
>   KVM: selftests: Create GUEST_MEMFD for relevant invalid flags
>     testcases
>   KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are
>     exclusive
> 
> [...]

Applied ridiculously quickly to kvm-x86 guest_memfd_fixes, so as to get these
into -next before the weekend.  I purposely put these in a separate branch so
that I can squash fixes, reviews, etc., or drop the branch outright if Paolo
swoops in and grabs 'em.

[1/5] KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY
      https://github.com/kvm-x86/linux/commit/e563592224e0
[2/5] KVM: x86: Update KVM_SW_PROTECTED_VM docs to make it clear they're a WIP
      https://github.com/kvm-x86/linux/commit/422692098c4c
[3/5] KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
      https://github.com/kvm-x86/linux/commit/a1176ef5c92a
[4/5] KVM: selftests: Create GUEST_MEMFD for relevant invalid flags testcases
      https://github.com/kvm-x86/linux/commit/63e5c5a10559
[5/5] KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are exclusive
      https://github.com/kvm-x86/linux/commit/2dfd23830344

--
https://github.com/kvm-x86/linux/tree/next

