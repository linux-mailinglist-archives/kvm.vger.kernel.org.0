Return-Path: <kvm+bounces-10110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D21F869EB3
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3062B1C22630
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0F914830F;
	Tue, 27 Feb 2024 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZopooMpe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D81376
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057667; cv=none; b=OS3OTzZNR9QUxom8qOHTfxNadT6c7o7ZVq1gPifJxeQmHc3+RK5mYcTQQcjj3WSuTjdJzUmzQpkDajHRTuJkiwL+5zdDbTO8b0zD16UaBvYv2RqTi5d/FvvRGKISW7IGW5dwLNkKTfjb02t6NxQM0hgSJyCC2dBy0ngzoZ0M3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057667; c=relaxed/simple;
	bh=SQzPTDOdrE1LGfT2vViyNQJFJrJs0hqegxwnJj7glas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/3fdgvkOtDvbGaAlNR+tupFWt7VIpiCUL4KmN7wJYzeLgrSaKPhtRC8TD/MG/3Gb2e96YRrpdJAS8EIBqrpUXbIpSnZWBxOMtwy0AeQuH3PMyUNNR/AVTBxK10ZYJoXfoPSHUHbdmyNc6hKPr6Oo/FhRrCdIz+zmot+mXp65KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZopooMpe; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e558491ca6so227723b3a.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709057665; x=1709662465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4ExdkX/Yv30I8jbowKPkb34r0bdbH77vYgPlhEJNuU=;
        b=ZopooMpeI7ZkEIukgxPVhygMwNLKAgCOYjiElZXXbBX6TxKd+1kstPWeInHp00Rwo7
         jN3ujBut0GXBVPQGLcCdIn81HInqHxTuzkgnkdGmxE5i5Z2ZHAPhwkBFPQzJ4CnpUWtF
         Ulys5XAC3NBzUmniLFoYhI2tYzeQFhubErKxzNcsGK+rZRpeGROnv4CGr1KAY/TsOKK+
         QJL/fzSrAIu77BxHNo8ApmdNE2RtS4Tup7X8KN6ikBq87dcNQ5tgLDA3AcjPHqiPXHbG
         87RBXZoX4V6MyqGNg7nPQ4H8pfh9O4Co0bu4U8y8jnB8s1UuROyKVhe9i0Df5p/WtdAn
         7YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709057665; x=1709662465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B4ExdkX/Yv30I8jbowKPkb34r0bdbH77vYgPlhEJNuU=;
        b=RMejbhDMFXEyDRmBQyl0AfZN6AnlD5q5w+piJWsnMn4/CEGq18TmfTgpzWtOLhLjDp
         N4BRhcm+ZQTgu501G1g+TBp2K9eK1KFdGO8Pi8A7kx/Dpt9GHLFNlJTAMmnJt+GbFxfg
         HOE/yM8tL9vN5sTCNRDxosC7ruqwG74YOPd8bz/3mst4n+2bkL9kw14rdYD3ubJJ0hHe
         AfVVwt6mMqWIRL6M19ML46J90n1NljTzLQyfvpZB9k2ez9NhIeeTLcK01leVceavDAf/
         Yq+k7hnMmp45CyGym6v6ga0gDy5KfJTV4PVqGqqqwGViKvqH13vmnCv7AIFt60FMIlpg
         qFiA==
X-Gm-Message-State: AOJu0Yxg8LCpIPcI+Pn58Dkpw9Nglo9If3CtF+Q15d9+q5A0Bg2EM/Hz
	IBPfBn2/XOK9El8PzAPDVui2uBaWMj2ns61DWfOezMVU5nuqW7mGfPk5imwBFIxl65/v6qM/8lF
	e1w==
X-Google-Smtp-Source: AGHT+IF94FBot9tDj6Jl2SPXsXd9Stg7Pd6HtglfpKTzz+7mB+WUN4A5xz4cm+GStz1u3Y0kUMQ/AmU2JDQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4fc8:b0:6e5:35ba:28ad with SMTP id
 le8-20020a056a004fc800b006e535ba28admr155786pfb.6.1709057665065; Tue, 27 Feb
 2024 10:14:25 -0800 (PST)
Date: Tue, 27 Feb 2024 10:14:23 -0800
In-Reply-To: <20240226213244.18441-6-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226213244.18441-1-john.allen@amd.com> <20240226213244.18441-6-john.allen@amd.com>
Message-ID: <Zd4mf5Z1N4dFjFU7@google.com>
Subject: Re: [PATCH v2 5/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com, rick.p.edgecombe@intel.com, 
	thomas.lendacky@amd.com, bp@alien8.de, pbonzini@redhat.com, 
	mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, John Allen wrote:
> Rename SEV-ES save area SSP fields to be consistent with the APM.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 87a7b917d30e..728c98175b9c 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -358,10 +358,10 @@ struct sev_es_save_area {
>  	struct vmcb_seg ldtr;
>  	struct vmcb_seg idtr;
>  	struct vmcb_seg tr;
> -	u64 vmpl0_ssp;
> -	u64 vmpl1_ssp;
> -	u64 vmpl2_ssp;
> -	u64 vmpl3_ssp;
> +	u64 pl0_ssp;
> +	u64 pl1_ssp;
> +	u64 pl2_ssp;
> +	u64 pl3_ssp;

Are these CPL fields, or VMPL fields?  Presumably it's the former since this is
a single save area.  If so, the changelog should call that out, i.e. make it clear
that the current names are outright bugs.  If these somehow really are VMPL fields,
I would prefer to diverge from the APM, because pl[0..3] is way to ambiguous in
that case.

It's borderline if they're CPL fields, but Intel calls them PL[0..3]_SSP, so I'm
much less inclined to diverge from two other things in that case.

