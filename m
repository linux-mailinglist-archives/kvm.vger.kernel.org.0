Return-Path: <kvm+bounces-5482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C11822577
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 556B81C21ADE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BE21798D;
	Tue,  2 Jan 2024 23:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cHlbuSPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838B117983
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 23:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f325796097so23567647b3.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 15:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704237870; x=1704842670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fh9eNvoV0oeuaUQb/okMXItISu2g2bUxlu83QsxotOY=;
        b=cHlbuSPQAtvYa1LQF7J0BuB7ouFq6jT9N1IZjLl3ck0zdNla37AN89LsW/iWnxFf4l
         /mwqqCKAuJdkrfZoMw4erecjlbXTHQSp1D3zN4e6odIiiN/P10yzqOSI0zuV9O6abBcx
         JY+K/Zdfga5wsQ4pSk5g6TXBpE8CdnGOMp3RAsoWMoqAPIAGrekxo6O7W/+TsK93aUmv
         rG1QiWAMByx29EIydYR2hb6mI1moRerIlbjEBaiFotzT/vg5UFCP2+K03UO6hpD+KKeb
         B11H1dO89Qes6+vCwy1k1rH6Syr3q8f9gCcBb1IWGbBQ6OZbqGWI5MHZn8UoVrj1Jf2T
         isOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704237870; x=1704842670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fh9eNvoV0oeuaUQb/okMXItISu2g2bUxlu83QsxotOY=;
        b=XppDrUBXPNgr2gr5vX4zRKlPo+WzCwuX/NeY5mPoa+ti/nhDevwH6jbGrUh3rdas8D
         pQuVAOHyDT+6s34Frw2up6GelfSfmgudCr8WqsEyVRadmkhWF+hlP6UT9ooFj+R140+e
         WQyjjyCIcuHPPeuiLR3smw+yyrPuw59Ie+SXUH/DJ57OavQKCnPvlyQ2nKS0iRnG17kD
         vkPoC1aPYYCWG7xvrHUMdP7TxAq/DTTa3XavkuAB3RXaqMpGJ+KUFBLx2hTX8sZWhuIX
         CbiIhKwSNEnkvxkjnj0djsz//IIZFoxzfXuFg2IoWCbd9oImdUHjkGp4Slup3tyfUanD
         oRTA==
X-Gm-Message-State: AOJu0YzPxtuaGx1xeVII8oJpYDSyr5VOnm/APS13SJOZ62LEbFp7CgtI
	dhy0bX6/9AeXSplYMTpsKThK7je2ydFhslyTng==
X-Google-Smtp-Source: AGHT+IGEul/JWfCj1+7KCYxVUNcdXf898KG/PAlKqk2BQQWT+H9Vf2yf5p9aNVPCNu55u2UquBxbrxG8y5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:360f:b0:5d2:913a:6421 with SMTP id
 ft15-20020a05690c360f00b005d2913a6421mr9460563ywb.8.1704237870620; Tue, 02
 Jan 2024 15:24:30 -0800 (PST)
Date: Tue, 2 Jan 2024 15:24:29 -0800
In-Reply-To: <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
Message-ID: <ZZSbLUGNNBDjDRMB@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, chao.gao@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 21, 2023, Xu Yilun wrote:
> On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index c57e181bba21..72634d6b61b2 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> > >  	reset_guest_paging_metadata(vcpu, mmu);
> > >  }
> > >  
> > > +/* guest-physical-address bits limited by TDP */
> > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > > +{
> > > +	return max_tdp_level == 5 ? 57 : 48;
> > 
> > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > 
> >   Bits 56:52 of each guest-physical address are necessarily zero because
> >   guest-physical addresses are architecturally limited to 52 bits.
> > 
> > Rather than split hairs over something that doesn't matter, I think it makes sense
> > for the CPUID code to consume max_tdp_level directly (I forgot that max_tdp_level
> > is still accurate when tdp_root_level is non-zero).
> 
> It is still accurate for now. Only AMD SVM sets tdp_root_level the same as
> max_tdp_level:
> 
> 	kvm_configure_mmu(npt_enabled, get_npt_level(),
> 			  get_npt_level(), PG_LEVEL_1G);
> 
> But I wanna doulbe confirm if directly using max_tdp_level is fully
> considered.  In your last proposal, it is:
> 
>   u8 kvm_mmu_get_max_tdp_level(void)
>   {
> 	return tdp_root_level ? tdp_root_level : max_tdp_level;
>   }
> 
> and I think it makes more sense, because EPT setup follows the same
> rule.  If any future architechture sets tdp_root_level smaller than
> max_tdp_level, the issue will happen again.

Setting tdp_root_level != max_tdp_level would be a blatant bug.  max_tdp_level
really means "max possible TDP level KVM can use".  If an exact TDP level is being
forced by tdp_root_level, then by definition it's also the max TDP level, because
it's the _only_ TDP level KVM supports.

