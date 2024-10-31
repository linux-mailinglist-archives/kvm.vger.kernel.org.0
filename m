Return-Path: <kvm+bounces-30136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0840F9B7140
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A4321C213A6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E3A2110E;
	Thu, 31 Oct 2024 00:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hkMaPnDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C11360
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 00:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730335479; cv=none; b=Me2n006uFnOnWNn1f2FtHCGbdUZkSsNd9yJnpEWiKz6RHLioPnF3nSPJpPsER+DbxCkyh05Q+3lHlgku3xCxCio4gBL67Z3G3Rzns+DG63Q3J52ko4XvlSTFs20xXtuNyRqR/FfTFTItrEufcwtONxhIArF01BFS3QySWylwyBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730335479; c=relaxed/simple;
	bh=AYrQGfs68cSYHvk/bWCY9a535fP/g1hcVwiIR8S3CBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0YpuiwKgFMKr/k8G3VBt5EmyEcpR1r5zYC4usRAUiRfKZkSKXHGuHX1u8VhEigX3FgUfMwzQbXNzKPtQxCnF8w9uenaSsheLSaSIR2dXwDgqQSpfY19tyOu+8DvGgrT/oGMck4MAQLZAO6aGSiIJWgBhADW63v+9ADE3EvRrx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hkMaPnDg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30c7a38bd7so545196276.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 17:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730335476; x=1730940276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7wJ3E/0287ZVUuvLonUQTrfab1e+06UVSv7RU40m2Do=;
        b=hkMaPnDgPr8URhZBAgjJIWTv7MrLlm/H8vm3K7LYZBC8/8cm22hddZROnaG3316wOZ
         MNjHKNW3HOSxwW7uYHo1Wgr0okhOW43OVs7PUb8Y/lVYabEjfiagDfupTZr2rcwP+0UC
         aryQXMl2dmKYwTL4DwBf3fDTBOp2SsemFnd7v+9rHTr2UhPnixku+MGDeiGUohbSMSQ8
         tHM4DuD0Jbvhfh9ODfPbnwkCeKFC/nizAM0UGsC7l8Hmfg/TkoSzsATQalGR6Ix8a19R
         9I0AcLD7WRz5L9C4QPLBiC40Qh5nDiRcSJtGQJGczQKgv0DUR5yWdfwMYWNrGSJVdcSL
         nFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730335476; x=1730940276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wJ3E/0287ZVUuvLonUQTrfab1e+06UVSv7RU40m2Do=;
        b=JFnYFMC1ONklm+vGpNy7SXNK0ZKPDpigNKu70N1tDpueSz42e3wCJ7vU0pkhlDlWCg
         rXWZUJK1JDQFl3anKoldhE5NroytViDagp9KtKrvRv1idmghzX7idP0mB7nqbCZQ90aF
         CKwpZc8sGFHFgQrVZnEaxkhAgj5UEOcq3NHKRQv5j8uyLwaapbHlmVCpnzDhAxHmJLrr
         K6BCQpSu5/MfpGTZ1+66n+l7NRMlfrpFn8O2TwNBI7qLVYNaG9fUnALUVhGxDSV1zrlu
         8a3HOa/PldZkUSUiIUAUNFQIwiteGYx4J70SGS4KDzBiXHYbh1iXMDPaQdmqg4kHsSKi
         QBQQ==
X-Gm-Message-State: AOJu0YwiDQ2Fnn8qNYmT9XlNPPvU851A8K5/zUg+ZCmGXV+Igs23/SgI
	pZKtEJwCuaplPPXIf7UU6mMgI+Q/x45hzEvVGhpxeEqS8/ecN4XX/XStVVZKFG3teFdomOb0zkp
	iCA==
X-Google-Smtp-Source: AGHT+IEwJjx+aJ0B2DwkgIuFUqCAGGX8/N+fiKgpfgymEMaJd1081DiN10Kva8XOo5JzXSPIfh2Rrskky5c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d348:0:b0:e30:b89f:e3d with SMTP id
 3f1490d57ef6-e30e8c2d094mr4435276.1.1730335476075; Wed, 30 Oct 2024 17:44:36
 -0700 (PDT)
Date: Wed, 30 Oct 2024 17:44:34 -0700
In-Reply-To: <20240906221824.491834-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906221824.491834-1-mlevitsk@redhat.com> <20240906221824.491834-3-mlevitsk@redhat.com>
Message-ID: <ZyLS8kxMW3WySRu2@google.com>
Subject: Re: [PATCH v4 2/4] KVM: x86: implement emul_is_noncanonical_address
 using is_noncanonical_address
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Maxim Levitsky wrote:
> Implement the emul_is_noncanonical_address() using
> is_noncanonical_address().
> 
> This will allow to extend the is_noncanonical_address() to support
> different flavors of canonical checks.
> 
> Also add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD emulation flags which will be
> used to indicate an emulation of a msr or a segment base load, which
> will affect the required canonical check.

Adding the flags belongs in a separate patch, there's no reason to squeeze them
into this patch.  Just an FYI, I'll split/fixup when applying.

