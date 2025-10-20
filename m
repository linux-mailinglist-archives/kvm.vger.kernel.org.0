Return-Path: <kvm+bounces-60547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 446ABBF251D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB50D18A5F0C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179F12848A0;
	Mon, 20 Oct 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Lk//sBX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86002750FA
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976621; cv=none; b=BRNdgd5Qmw3YF36f9M0gd9SInPxj98XD0r8ODwgAh2KEO72+PAW6sCWuvDIWJxD0TBfnuB70RQBSUQcoRdH0nNtBvaodO+EIMxr0GLx1rBlt6RtlKPj22fdS2guIzB3jDGq0lAO4V5Ju7HkJVZ4/AjovFJs8X6Y/5BesGF1r0KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976621; c=relaxed/simple;
	bh=NE26bYfoFFrIsWDpJOzZL4KrJBFLdl0TaANwy0FsKOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LD4/d50YsaimuWX/pbvQ5u2sAY8pqCioFtldcf0r/T8QYsaraO3ej6U5+n5pCooF/EE0RrypgaTPatETr+icMRDcvnXFfpGn0wGWr3rn3+R0KKvbnlHa/IoVgp2nnz6zhwP0D2ueNYyd5YVj7gFwWQOQ2U9B3ghyJktaU7jID+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Lk//sBX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bc5d7c289so7864543a91.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760976619; x=1761581419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xu0WN8ythofnvoWOCKr5Ol3+oLE60o8C+tmt+Bq/TD8=;
        b=2Lk//sBXNYMHMrDphL13wGF9pO/RYoP1Bz1PzVmBZFyzau+qOvyeF4Yd2QJYpkKs1/
         Ezvsc0CdLyOfSh2Mg9ypOmgccD47e9+2Lu2qr69nxaEjwFqrcM0ssCMiYiynOmUeVJ1p
         vXHAZ+990JbAZPJaL/z2+lyiVu5aKKyTDDxrzTpU8afpAPS7TVvVIkwBCFF6dxb906rq
         TvG6h17RwrW/WsLswjdTkX6Gc0XvMq9KVPhPYDleOMi8sHJa9+uwPrQHmVWe9kf1zCnb
         4IH5rCN+qZXRnSSY+KD1kZWGSvdCyX2oWcnBqlkRUskLlqe1LSee4p7DXsiVDYDq7y2x
         AEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760976619; x=1761581419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xu0WN8ythofnvoWOCKr5Ol3+oLE60o8C+tmt+Bq/TD8=;
        b=uh1a/yarvdU2e4OVnRjPyB64QoLNYDlrE/ALMxEuQfHGPO3tUMkaodmDVYVOf+B9Us
         VKGAlqDOVSTUrINlZXvJhgx81eH2R9KBt30n/wAL0+JAQjFxYyEPyakO+3eWlI29F0xP
         5skT6ktNbmQyw3+P1wzqffma6jxIPRkOKEV/dKLkeasQWU9/Fk0oRAbRs1n26HNZScF/
         BanOvExVh2P0oN18bXyNhgtTKdLGNaJrb5RtODKe/6MU6Biql10nSvIa1k0JfBhHiMbn
         EjHmdEiDg0qr0mZPne7XiXNqwLbtGn3icKLMApNDWv5QAUVAq43fw1yrsBMvEqKhuqbY
         xHcg==
X-Forwarded-Encrypted: i=1; AJvYcCVq1LbFOg4iZijyX9n+I2z2VW/66f/hN4ZCVkwOTqIxgHbeFbOP0FZfuJXSjWSaif3/3IU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2thiT7KuHq9HVy6WgV9znEe+WzpQRDDJUpAK4DlKY8ZaKfZ6u
	ePUrekwjLa1BxMDIqRMqjOAHByNJ704graOtxuzn8QdB9b4V6CrAzxn7tOiCG68GhioYItx2dXc
	/z5ydmw==
X-Google-Smtp-Source: AGHT+IGJLbXrm62yjngKT3FP3u1oyPXRP6DoV0W7nmjBQLe1fhWafGHsJm096m+Nlm5LTnuEg5uF8cgAl3k=
X-Received: from pjzl22.prod.google.com ([2002:a17:90b:796:b0:33d:6d99:1ed4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5111:b0:329:ca48:7090
 with SMTP id 98e67ed59e1d1-33bcf940e76mr15500567a91.37.1760976619094; Mon, 20
 Oct 2025 09:10:19 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:10:17 -0700
In-Reply-To: <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com> <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com>
Message-ID: <aPZe6Xc2H2P-iNQe@google.com>
Subject: Re: [PATCH v2 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Pawan Gupta wrote:
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 49707e563bdf71bdd05d3827f10dd2b8ac6bca2c..00730cc22c2e7115f6dbb38a1ed8d10383ada5c0 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -534,7 +534,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
>  		: "memory");
>  }
>  
> -DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
> +DECLARE_PER_CPU(bool, x86_pred_flush_pending);

Rather than "flush pending", what about using "need" in the name to indicate that
a flush is necessary?  That makes it more obvious that e.g. KVM is marking the
CPU as needing a flush by some other code, as opposed to implying that KVM itself
has a pending flush.

And maybe spell out "prediction"?  Without the context of features being checked,
I don't know that I would be able to guess "prediction".

E.g. x86_need_prediction_flush?

Or x86_prediction_flush_exit_to_user if we would prefer to clarify when the flush
needs to occur?

