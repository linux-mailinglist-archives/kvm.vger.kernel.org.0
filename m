Return-Path: <kvm+bounces-23933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF30194FCFA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88C2E1F231BA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FEA22F11;
	Tue, 13 Aug 2024 05:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjzH4BbE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB52261D
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 05:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723525212; cv=none; b=dfcdeQhsB7I6ss9iqxB5uPy2RLiFxiO0848rKJFUTTVPe7LE/SVA4AUq1xI300GvkrMTsx0Mhs2NB+U6kJA9UUHdE15yVXD2tMCaERBcsSDcVz2r2f6Wy2kb42Cmq8BGiFNuS6f1JGjWGzjXnfgXIHnyF14BT6JW2PT8YxczESg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723525212; c=relaxed/simple;
	bh=OIgiu5/t2sr/7Ua27PqCLLrQCoNW8d+XuGnpTUhcZlo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=czHIE06KG8HJJlGa6GX29a2DprU4wRNnIP3UuDgnffjA+guSlhvNqRdybYeVMhmmyrh18dieX+FGEBiFSVwel1fh192acsIjtgSWWtoOtUJKHMeeGkiw0c+9ny+n79rFxcQbxlr/ajNzyc1QszulPh5a9bQC79yYIm/eEAXVMGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mjzH4BbE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b3d35ccfbso7389592276.3
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 22:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723525210; x=1724130010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nynt3K2pK+P2lohdVSwccr1R++3SqSYSkDl/B0+fxJ0=;
        b=mjzH4BbE3ocOPFuAlZe5YHr0ZG8ic+78ruA+DKZcnes3UPXyLAORX08KkX+XtMkF+w
         lTaLJ+L+PQDgeknXf4NJyVSRlrpG458PPyUvOhBirgCCOFKGf7tS23FfbTSa0Xro6rnA
         P5TpXiuAYt8oCckb371npUMnhz2jhPw29lIGpOsbTrJOweHltJoA7Qb2QktUSdbR7y0x
         xqnTRb4eXPH0hgyjP3pWNSK3lKm+Fe6rx20/FcRvYgB87SWbosvqL8s6zqiB+M19jfkU
         FfVEny8tZq+aytC3YJO7MOKn0dYakZb2wMIWQ1/kxH0tOKQJFPK/3p1I81tGlFRj+//5
         UjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723525210; x=1724130010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nynt3K2pK+P2lohdVSwccr1R++3SqSYSkDl/B0+fxJ0=;
        b=GXG64xT5oWo8CMvMzdg/Xzucb/InYdpugKicRt+1R9a0/55Uwy/ngF51xQGsNdhcuF
         BuYHd1BlDvGEMiVE2APqbmoJxxU6Qv2jboQUPKlWH0GehWXrTGg+H5U4fT+Yyc0xPhLw
         QPgmF4oI/2usawFWufNxtB6EIX853NYJwGVVBRlDWT4MMOdJ+ld4Xk+aHZRQfmd7nGUu
         bAwxyAOL41nfy3vvSfZJ8iQzUx8VNBIDoICkPFCqv/gCPXnLS006hgZzWce6FXB8k+JF
         MTpk3JhdYiQzvhwS1eGasqQ/hMoRFmAmw4/kjQEQ+YIO53CDK+6DnxDJ9QYWqL/NRLWx
         e8wQ==
X-Gm-Message-State: AOJu0YzgPJ2kr0JzreNnZUcO1IVykklxUqKM+eJAH2qH/jWIDDfBMB8h
	B+NWBaeezhzp2uf6Yr3IwU0i3VXHJS3GoHcQ+Rdc9tLGZ7OzJVn5pcQsAjPGJ4QTS8J/Iq6q/R6
	QvA==
X-Google-Smtp-Source: AGHT+IEDqQL5tBw8lsyIG+LCURons4tAdw0CdIJ3JCh4KF+Tcm7B48FYQ7r7EXgtjHnuK9Hxm20M3/npkq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:483:0:b0:e0b:f69b:da0a with SMTP id
 3f1490d57ef6-e113d2c151bmr4088276.12.1723525210070; Mon, 12 Aug 2024 22:00:10
 -0700 (PDT)
Date: Mon, 12 Aug 2024 22:00:08 -0700
In-Reply-To: <20240612111201.18012-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612111201.18012-1-lirongqing@baidu.com>
Message-ID: <ZrroWLvQ_0zXMRhg@google.com>
Subject: Re: [PATCH][v1] x86/kvm: Fix the decrypted pages free in kvmclock
From: Sean Christopherson <seanjc@google.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: kvm@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"

+more x86 folks

On Wed, Jun 12, 2024, Li RongQing wrote:
> When set_memory_decrypted() fails, pages may be left fully or partially
> decrypted. before free the pages to return pool, it should be encrypted
> via set_memory_encrypted(), or else this could lead to functional or
> security issues, if encrypting the pages fails, leak the pages

That seems like a major flaw in the API, i.e. not something that should be "fixed"
in kvmclock, especially since the vmm_fail paths only WARN.

Commit 82ace185017f ("x86/mm/cpa: Warn for set_memory_XXcrypted() VMM fails")
says the reason for only warning is to be able to play nice with both security
and uptime:

    Such conversion errors may herald future system instability, but are
    temporarily survivable with proper handling in the caller. The kernel
    traditionally makes every effort to keep running, but it is expected that
    some coco guests may prefer to play it safe security-wise, and panic in
    this case.

But punting the issue to the caller doesn't help with that, it just makes it all
too easy to introduce security bugs.  Wouldn't it be better to do something along
the lines of CONFIG_BUG_ON_DATA_CORRUPTION (though maybe runtime configurable?)
and let the end user explicitly decide what to do?

> Fixes: 6a1cac56f41f ("x86/kvm: Use __bss_decrypted attribute in shared variables")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvmclock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c152..5e9f9d2 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -228,7 +228,8 @@ static void __init kvmclock_init_mem(void)
>  		r = set_memory_decrypted((unsigned long) hvclock_mem,
>  					 1UL << order);
>  		if (r) {
> -			__free_pages(p, order);
> +			if (!set_memory_encrypted((unsigned long)hvclock_mem, 1UL << order))
> +				__free_pages(p, order);
>  			hvclock_mem = NULL;
>  			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
>  			return;
> -- 
> 2.9.4
> 

