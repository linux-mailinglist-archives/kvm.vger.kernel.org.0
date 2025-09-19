Return-Path: <kvm+bounces-58172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD83B8ACD5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9BF53B6DE3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94253218B0;
	Fri, 19 Sep 2025 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kOlFh6Kg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F4A22F74F
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758304042; cv=none; b=rl1BBWegp9aRkMdQoV/zB5fx5sBn/4rf5k98dG4SPn3CRSBWyFt0ZrpB4Bf2QrqklPIi+gn2uhLSuAw6lq+82kI+t8ho/THgJfAi3cdtT6kJt2ti8/bXXsuvwV1/mn2vazeD5+FA7Mz9WrRrRjsP0hpMVmunZswN12nFSYHZSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758304042; c=relaxed/simple;
	bh=CCA2hIfxRCbpuhCF6r64ZzzmTwPPPBHLV30AjsEJnp0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SJMnKv7/XxRSK6XVBveHv9ohnd9mRCDjuopH6ffwKI88o9rlduAgeXuVgATOB8gybZqiBwZcIBLWg9VRjcl8y4hEm/czKqsHdWWIDdEFlWhRES80EarJWnnbg1VJlbdXtRFTAog6p+5NRs7BmiCvj1TORI0gYtPWrjJVwhdkFnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kOlFh6Kg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32edda89a37so2362094a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758304040; x=1758908840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0WZ6Xghu4W17h7FWzOehiS4XmoZiHaaiyghWkrntN4=;
        b=kOlFh6Kgx+FVq39YE0lPvKF9UbYiB8heaEhcj96c0UhugFho4J8iwIgnGD9yVPvgge
         1WZlYRUmb6fp3LiniPIK94Wryv5k0eLj9CF1xSVPHCg3MwV2/U3aB+FyP2IaQYttq0M/
         fxUzcGMalcOxHZUxJpbra8Yi87DHaE8dEhe6GZKLJ6Ge224seYQ7DVW8K0EcXLZQzVKF
         lVe2FbEIlfKM9l3oIGwgVFxw/bcredNClWHBA2ZS2OLXIFuYMQfX+8xQnlqbCEhew/U3
         +543VAHu/0zKXubWapMSe8Q47ApPe2g/UeKX/1St7x/Klr5XmEzQY9mLdA0/H8UGlwkL
         ORXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758304040; x=1758908840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0WZ6Xghu4W17h7FWzOehiS4XmoZiHaaiyghWkrntN4=;
        b=wcRALgIABD7Q7dsVsuiaS3I5eSg0p6+wyqKMAfXeL17SBTMM1F9CcRrNU1LsyrQccs
         hvZeJZ1hX1knPZvKXkoE/zpt0ULMXvAAhwf59/PJdmZFB+SW5t5gpSHEWWALdiHwsfdF
         WRTxt77cztUlZQLHO74Ng+HFYJN+593wY82j8wWDlO7GVneI07aOsddLVJx7TOyx40lg
         pgeigvuooL6fQD2dg6R8EskQ6gq9mBlW2BXz/wT/1tmZj7iFVnX9ekYcEt4cTi3qYD4w
         hNyYC9K48S6pA0297eGmiMtAEpNAKIKOqPNHZ48bPUKeS6uSc2zGwB93wEF4yUDRtqKg
         AsdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL0j2xxhnG3j77MDwCgc8/OA1lPe8n3ETHklPMu1I/9mtjZnAKVezolF+f90BQbWgqguY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2fTl1W4ZSvXHNDZheyPyeX5SXUuoBjxrerDaMU+CkPQ7hLwip
	u+9OD7Tbu0y5LyvVM82AGx7HcGQY0inpS9eyQRn2zS4fcrfda/k22He500IQTLSHOU1+R1u2hqV
	S6i+MWQ==
X-Google-Smtp-Source: AGHT+IGy1fcQnKtH8z25CTTz1cHiMf/FXRm1ioQcE3EUAK5WOYUUr8ZXtJvecio6NIFZO7ppTc0vNSEptlA=
X-Received: from pjbsj18.prod.google.com ([2002:a17:90b:2d92:b0:32e:a3c3:df27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3812:b0:32b:ca6f:1245
 with SMTP id 98e67ed59e1d1-33097fd0d9amr4823853a91.5.1758304039826; Fri, 19
 Sep 2025 10:47:19 -0700 (PDT)
Date: Fri, 19 Sep 2025 10:47:18 -0700
In-Reply-To: <d1bfb652-19ff-434f-bd51-b990543d14d6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-14-seanjc@google.com>
 <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com> <aMiPTEu_WfmEZiqT@google.com>
 <d1bfb652-19ff-434f-bd51-b990543d14d6@intel.com>
Message-ID: <aM2XJjYyssKU9ScY@google.com>
Subject: Re: [PATCH v15 13/41] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Xiaoyao Li wrote:
> On 9/16/2025 6:12 AM, Sean Christopherson wrote:
> > For 6.18, I think the safe play is to go with the first path (exempt KVM-internal
> > MSRs), and then try to go for the second approach (exempt all host accesses) for
> > 6.19.  KVM's ABI for ignore_msrs=true is already all kinds of messed up, so I'm
> > not terribly concerned about temporarily making it marginally worse.
> 
> Looks OK to me.

Actually, better idea.  Just use kvm_msr_{read,write}() for ONE_REG and bypass
the ignore_msrs crud.  It's new uAPI, so we can define the semantics to be anything
we want.  I see zero reason for ignore_msrs to apply to host accesses, and even
less reason for it to apply to ONE_REG.

Then there's no need to special case GUEST_SSP, and what to do about ignore_msrs
for host accesses remains an orthogonal discussion.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ed25d33aaee..4adfece25630 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5932,7 +5932,7 @@ static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
 {
        u64 val;
 
-       if (do_get_msr(vcpu, msr, &val))
+       if (kvm_msr_read(vcpu, msr, &val))
                return -EINVAL;
 
        if (put_user(val, user_val))
@@ -5948,7 +5948,7 @@ static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
        if (get_user(val, user_val))
                return -EFAULT;
 
-       if (do_set_msr(vcpu, msr, &val))
+       if (kvm_msr_write(vcpu, msr, &val))
                return -EINVAL;
 
        return 0;

