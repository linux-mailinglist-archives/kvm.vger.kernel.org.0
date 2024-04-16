Return-Path: <kvm+bounces-14818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D648A72F8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB4D4B21FCF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B4D136E09;
	Tue, 16 Apr 2024 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3WWYc187"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7C1350DD
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291582; cv=none; b=Dpak2ACZLtNzzBddGkRUPE3kHI7qWOtOLPtBzaZAEP+YQpjwC63Mi/zcdOdcx9Uy25ossMoh3eqkMPnB3oF3A3ZknXEj9pPZlYssASqJxMFs/8D5PgFoLUsvM+iQZjMHupcEaG2qbQXC8YSP7mrodEv8TBb71Mfr4BhCZ7kxFVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291582; c=relaxed/simple;
	bh=jw3qGNAzG64ELX4Tee1Sk0cisqm/f/xYf4XyruOjn+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+Uf2woucavQzpuLUvEaUgRAJEzUB+FmJqLy6QQbkjYvkqjdqR+lG/c+gT5/JA2gLBvV0Gl9yWS7oc/HMvPBbii699/MD9ZoHj8G9kn91/v69VwWgBnbiyxCZK/SRzj2S3rlToEncFIXCJjvh5qEI9+C6LtoF+46qEV5SXKhOwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3WWYc187; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc58cddb50so7561170276.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713291580; x=1713896380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWimoGAi6TC7EJDWUZBrD/1JzkjLqta1O0Lm+vlOf58=;
        b=3WWYc187kVef3M/fHYAepoeN4BVEU/3eQPlX8xa0ciX0HtjNIcEmIALYg3sUDXt5mf
         HtY44XkpvUO9Fg/511jyxbkaXazRfuYjFuP9dAfOX695q40Qer3A2Z2kEjFmzUweepaL
         /YMQHRX+xKjx0yRjoJh0Sfw0+jMYwIp00hLhDl0jhhT+WyySid5EVoIREcwslajWrs7g
         7LhkJjl0g7fja3r/uEPSryxPCPTKvU1/ahCIJr5z4oYCTIgm5VYGzCpBmhswxiktm8m7
         Z/bjVIcMkCpbp2D5g55CXMbnOuB6XAeewEOuAeuvDp4LS2WsaxBAPnURozXth+wFW1Jf
         PPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713291580; x=1713896380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWimoGAi6TC7EJDWUZBrD/1JzkjLqta1O0Lm+vlOf58=;
        b=my05QMC3SQ5+QaUkomDMgdcdomjFCyH8W377OcSIpO24VIgvsRtihHesDHthK0ez3f
         topxkdqUK9+mMpYEisThMqnp9JEPBZU1THuFZ5whxAWAnEPb1GIoekgLz6ynDCo4HEIW
         z7WpGYrvqTeuQN/qqSykDD6JBJDyN13qMwXKV0epz/g3cCR1A8jDjAHUhMgd60C8wbZo
         Zv5uk/IAeWMfzVg+DS5R0dZL0TiMJbqDpdVnPTfs1Tfg1qjUZObHX8Z0dYMYqsE2N0tJ
         E5AqdCHSmFHxqNppdxdqTf1tMoGdJnxuczLgA1zvF/itMigdXIpa65FJdD+YuqwZSHEQ
         uDWQ==
X-Gm-Message-State: AOJu0YwAtghVTJYEDxEz4wMrouob93SaKr+ia2rs83hgiM0/GH9G6+zC
	6Qq61nyg/XzX8fNRQr5eWg4ea5VbfkxsMJJh268bV0i28945ILeSAtLEpNz6HkRHiebpFc4EXPR
	cLA==
X-Google-Smtp-Source: AGHT+IFzVARd/Kh0xIbFd5v7iROgL00nXUhGqCqXhr9Y/J4BM+3WLtBzDPbCqJ4yUpAnAOVRksXuoAC3WAM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b0e:b0:dc6:5396:c0d4 with SMTP id
 fi14-20020a0569022b0e00b00dc65396c0d4mr4383816ybb.1.1713291579879; Tue, 16
 Apr 2024 11:19:39 -0700 (PDT)
Date: Tue, 16 Apr 2024 11:19:38 -0700
In-Reply-To: <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com> <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
Message-ID: <Zh7BOkOf0i_KZVNO@google.com>
Subject: Re: [RFC 1/3] x86: KVM: stats: Add a stat to report status of APICv inhibition
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Alejandro Jimenez wrote:
> The inhibition status of APICv can currently be checked using the
> 'kvm_apicv_inhibit_changed' tracepoint, but this is not accessible if
> tracefs is not available (e.g. kernel lockdown, non-root user). Export
> inhibition status as a binary stat that can be monitored from userspace
> without elevated privileges.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad5319a503f0..9b960a523715 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1524,6 +1524,7 @@ struct kvm_vm_stat {
>  	u64 nx_lpage_splits;
>  	u64 max_mmu_page_hash_collisions;
>  	u64 max_mmu_rmap_size;
> +	u64 apicv_inhibited;

Tracking the negative is odd, i.e. if we add a stat, KVM should probably track
if APICv is fully enabled, not if it's inhibited.

This also should be a boolean, not a u64.  Precisely enumerating _why_ APICv is
inhibited is firmly in debug territory, i.e. not in scope for "official" stats.

Oh, and this should be a per-vCPU stat, not a VM-wide stat.

As for whether or not we should add a stat for this, I'm leaning towards "yes".
APICv can have such a profound impact on performance (and functionality) that
definitively knowing that it's enabled seems justified.

