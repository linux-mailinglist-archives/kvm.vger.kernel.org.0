Return-Path: <kvm+bounces-43167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EEAA860B6
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 16:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB4141B8647D
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA401F8BBD;
	Fri, 11 Apr 2025 14:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0JKH4ed"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA4F1F5827
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 14:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744381970; cv=none; b=l+yM0m5YWXqUlskxDD3Y0c8A1lpCiU6ntoAxsxRqnC1eFzmbG4F9mGnLNpyxv597Umcbet9Vs02M1S8Txv+Lp0zeqgX8prEo0HsBjMtHVsO98WJvV3qrDBI2ixJvxf4HGK2omwbSGDK82dCyK701hC/cAxEsOEQzHPdvyg0KIfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744381970; c=relaxed/simple;
	bh=0uBVlVl6zt2smmydXiApRvxiKMlTSisj2Yu/ktHw5O8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pdzuCcqWQTogv7PBCoizhDEgpU0i0XiETYSYebIicwYIujOJ4/NMNjJNZUZnwMIxxGrL/MgSKs2l1dHmD1yIPVOanISKPQ/L+mKv9jPRuoRs174qwPUvoL2MgMdjbQrTJFx9hsdJLqCM783AGDRAadRkh+d7DYPnJYGGA2m/OO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0JKH4ed; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so1566969b3a.0
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744381968; x=1744986768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdYWtwGlFqkOjqypokEB9CfaYMOynOKxQo9pc/iInzs=;
        b=F0JKH4edhYVQVNxYF3uOjWIJ7OtcvbMmE6C7MhaltDwK5XxsUUR332gmd+A+AN7GOX
         6GKZ6v2zG1tQJPJroQzb8kkcjOVe1QN2jnIlOEW2wMh4jYki8sUID/Meie5VaHO4cO3h
         XkwRm7r0QNox1R+ZMAIB1k7x7isSBixxfq2soYZmKDddaSckqmVC3L/e4awA+GAVpxP9
         1kLQD+BVH0fthYnlqiUId5vJJAZF5LzdIx8lC+xV461wNRX2kP4wafX2RghCODZTsPr4
         F0jAuOGXsKAIYTuRSX25UmfGnZEksj64qizImpojGvhMfWUQd1J0/QH7uEuYw+7WzeI/
         rtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744381968; x=1744986768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdYWtwGlFqkOjqypokEB9CfaYMOynOKxQo9pc/iInzs=;
        b=DPN/glgdbGBDyKtbJxrBtgLPyAqab/SigEyguPLih2tdJVwsQYRQf2NtFVa9qLRBBu
         YiFPWTK0jjDIpoxv0ARqf4uae1t8k2TwiWBAHPFWJnkxqD+4sWjKEXlA1MkhglxPr/q0
         2YF4t6J50rJ8Vp16CnHl72rki3AyT9ULcCos77TzMTgvyNbFGBx1FWValttE6ZRnVZ7e
         /jrlHET2+117fXmXN1TrVE5CdYCzgamaVHfxFX1m/3nHwLmRiBiHk+pLW+nxkU6t3ELE
         /dVKc3jWJajnChby36x5gwSOOeRs41crPSIFjA4g5F2ymxyNhvGO2iZdXicLvCTMC20s
         0Alg==
X-Forwarded-Encrypted: i=1; AJvYcCWleWoodcjk8i/Loq7WSiRGrWyxYPVDwo3lkylYvWblZAT2vmH1re1Uu/Q6iGgpmT2+lgc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkef1BrqAocGf+kwl/G0VDiAto9PJ23Y1p1BbXkDj5PZAe80J7
	djV/xZlITP0vp7kJb44+v5f4zb3hOKe+e36ZrZ2XKYlAkpN1X3bcMc6OB9AN/tzucEc1JlqYu7s
	cpg==
X-Google-Smtp-Source: AGHT+IFyxCzl6htX/DS8ClLuQoR7pJ/TqB4Bmf2NEvfb9DmOqq4wCNxnwjdldtCmTRsZzd2uBHMx+RmD5A4=
X-Received: from pggs1.prod.google.com ([2002:a63:dc01:0:b0:af2:50f0:bc79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a2:b0:1f5:7007:9eb7
 with SMTP id adf61e73a8af0-20179983274mr4861364637.37.1744381968654; Fri, 11
 Apr 2025 07:32:48 -0700 (PDT)
Date: Fri, 11 Apr 2025 07:32:47 -0700
In-Reply-To: <d6ccf531-2ed0-4e38-97a5-2b747497fadb@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-10-seanjc@google.com>
 <d6ccf531-2ed0-4e38-97a5-2b747497fadb@amd.com>
Message-ID: <Z_knw1j6KeaEHVxr@google.com>
Subject: Re: [PATCH 09/67] KVM: SVM: Track per-vCPU IRTEs using
 kvm_kernel_irqfd structure
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Arun Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 11, 2025, Arun Kodilkar, Sairaj wrote:
> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> > diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> > index 8ad43692e3bb..6510a48e62aa 100644
> > --- a/include/linux/kvm_irqfd.h
> > +++ b/include/linux/kvm_irqfd.h
> > @@ -59,6 +59,9 @@ struct kvm_kernel_irqfd {
> >   	struct work_struct shutdown;
> >   	struct irq_bypass_consumer consumer;
> >   	struct irq_bypass_producer *producer;
> > +
> > +	struct list_head vcpu_list;
> > +	void *irq_bypass_data;
> >   };
> >   #endif /* __LINUX_KVM_IRQFD_H */
> 
> Hi Sean,
> You missed to update the functions avic_set_pi_irte_mode and
> avic_update_iommu_vcpu_affinity, which iterate over the ir_list.

Well bugger, I did indeed.  And now I'm questioning my (hacky) testing, as I don't
see how avic_update_iommu_vcpu_affinity() survived.

Oh, wow.  This is disgustingly hilarious.  By dumb luck, the offset of the data
pointer relative to the list_head structure is the same in amd_svm_iommu_ir and
kvm_kernel_irqfd.  And the usage in avic_set_pi_irte_mode() and
avic_update_iommu_vcpu_affinity() only ever touches the data, not "svm".

So even though the structure is completely wrong, the math works out and
avic_set_pi_irte_mode() and avic_update_iommu_vcpu_affinity() unknowingly pass in
irq_bypass_data, and all is well.

struct amd_svm_iommu_ir {
	struct list_head node;	/* Used by SVM for per-vcpu ir_list */
	void *data;		/* Storing pointer to struct amd_ir_data */
	struct vcpu_svm *svm;
};


struct kvm_kernel_irqfd {
	...

	struct kvm_vcpu *irq_bypass_vcpu;
	struct list_head vcpu_list;
	void *irq_bypass_data;
};

Great catch!  And thanks for the reviews!

