Return-Path: <kvm+bounces-60072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C04BDEB9F
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D46119C4C37
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C901B1F1313;
	Wed, 15 Oct 2025 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZPpl+i0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BBE13C8EA
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760534445; cv=none; b=hmuWa8/ZScSGl/Fnjh88UcPybPwlM1K+pk5ApmKnXx6ovKlvTeY43Btm5uFWmDIR7zeQBmwHTeGja2vzPioXd2SmhTJtPPSqwWF+SIp2EWSIRCT7/bQG3acwK1v9KyVAzRuhE+8kgBm/ZoEociC5h8kGFV1HB/CvDl+s9nf2msk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760534445; c=relaxed/simple;
	bh=kBtpBEDbxxPkyKSLCO25J6eEcXaInuzEPLqU3Q0dKa4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kwXj7Qa3e9LD7rJWS64MP/90BPhszIR51M4gfplaNyBuOmNs17/BMP+E/BEidn9lmoDRJbTY5HzkZfLQdBxQp7HYXyLWlRgOQP1gde/L0MF7DkpjlOzLaiivAZzyDaYl6sT8Hj9AI0qeMPCfIv5hWWwUbj8IKhJgpZe/2drquoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZPpl+i0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3306543e5abso1282339a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 06:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760534443; x=1761139243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7aiDcOMYGoqQqOGN6ZOeHf6WH7KNcOX7iTj2TVdo7v0=;
        b=UZPpl+i05859JymhtIwhc/gjLYUdoVFtmv3HV8Rtfdf8+gsMcotrZNU9HbrO8GUbs1
         y2rgKaWPD4YtphxdlQpv/GUFK1wSit/kLuAxWnpDW1ns6iOR2BHox7dkZq7eUp7xFXHO
         FrP33h7FFI3PbjvdzVY2cZv1BRovZtMDWPQjA5GC8L9bZ6UvsyWAeygFX8CBWfVMdbNp
         z3oHgDKpr3PcFpeDGJTqiFH4vx1sPKDKQ7dRBODo6JbsWncoQWtp/NCgIUq1MqUTBv9q
         LYvGiQZ8J61zqzSulc5i9dKjkb+iYMYkbiPfn7gMWWrOixuXQXrR4IHKAyIyKbpkZ12B
         EM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760534443; x=1761139243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7aiDcOMYGoqQqOGN6ZOeHf6WH7KNcOX7iTj2TVdo7v0=;
        b=QJv+I7bxjfzvr2CURlL46n2SXF0v9GQ1XYyvU5lJd4e6HHQCOViK60DTQSIc4R/v/g
         A/oiLo9oBxA7jbtFEvmPxTNtjv0Axk5dJ+AR2Sk/aVhPfWg52TbqkU2t7vtVTePXlWia
         bjik8OOaRGuQX5668aL8jGJBRyPB5okC5/FjeQ/Zso42A5Bu8S8UOva7cmtVJ6/sHBJp
         cBh+aaCHEg4YSkph1usK6GDzKziVjCY9yGgoS3V1aoyYRGU7H72A+jQs5BeoEZVbMbFX
         LTsGhHGTDzd3s1lnRzMqbLTpcqi2byTNkVvRA/9tJWCvn+eGqKeugEk+Ug7Vaj80DOHZ
         BzCw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ/HV8CqYGdbb0Jnyx9vFP1IE7y4zx3mRLn3edrueNMMhbxLC4TXZ5A18sp3cX5FqtVt4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3977Rxd8zv8ElbSniV/e2hAJd/bvWXo4EYomx+TdQI2CvCBX6
	otC+9KxaSXTJ0NgRICIjPpd9e5hr4yQ04JvgLT6p44nc3vuYS732pJefACeOaULNeC2TJX8OUHe
	eciJ7dA==
X-Google-Smtp-Source: AGHT+IEssmxeyFQuao3efdDtRLt1rPRjpC/WDzQrdS7wVy9gzL8MymtLf3x3dQAQmC8oLS9fcdcj5mofzLk=
X-Received: from pjbot4.prod.google.com ([2002:a17:90b:3b44:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1806:b0:32e:23c9:6f41
 with SMTP id 98e67ed59e1d1-33b9e0aacdfmr83606a91.5.1760534442777; Wed, 15 Oct
 2025 06:20:42 -0700 (PDT)
Date: Wed, 15 Oct 2025 06:20:41 -0700
In-Reply-To: <d9328f94-a6a9-4d98-8ea7-9b9e22bc1db6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014231042.1399849-1-seanjc@google.com> <aO71TX//mL3QOV3T@intel.com>
 <d9328f94-a6a9-4d98-8ea7-9b9e22bc1db6@intel.com>
Message-ID: <aO-fqYO_vmwtCn8l@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Xiaoyao Li wrote:
> On 10/15/2025 9:13 AM, Chao Gao wrote:
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> > > 	case EXIT_REASON_NOTIFY:
> > > 		/* Notify VM exit is not exposed to L1 */
> > > 		return false;
> > > +	case EXIT_REASON_SEAMCALL:
> > > +	case EXIT_REASON_TDCALL:
> > > +		/*
> > > +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
> > > +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
> > > +		 * never want or expect such an exit.
> > > +		 */
> > > +		return true;
> > > 	default:
> > > 		return true;
> > > 	}
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 097304bf1e1d..7326c68f9909 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -2127,6 +2127,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > > 		return tdx_emulate_mmio(vcpu);
> > > 	case EXIT_REASON_EPT_VIOLATION:
> > > 		return tdx_handle_ept_violation(vcpu);
> > > +	case EXIT_REASON_SEAMCALL:
> > > +		kvm_queue_exception(vcpu, UD_VECTOR);
> > 
> > Emm, the host cannot inject exceptions to TDX guests. Right?
> 
> Right.

Oh, yeah, duh.

> I also tested in TD guest. Actually, the TDX module injects #UD to TD guest
> on SEAMCALL exit.
> 
> The behavior is documented in 11.7.1 "Unconditionally Blocked Instructions"
> of TDX module base spec:
> 
>   Instructions that causes a #UD Unconditionally
> 
>   - SEAMCALL, SEAMRET

Nice!  I'll add a WARN_ON_ONCE() if KVM sees a SEAMCALL TD-Exit.  The SEAMRET
documentation in the TDX-Module spec is amusing since the CPU is supposed to
generate a #UD for SEAMRET, i.e. it's not like the TDX-Module has any choice in
the matter :-)

Thanks!

