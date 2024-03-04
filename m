Return-Path: <kvm+bounces-10816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA243870753
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 17:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 803FB1F23CAF
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240B84CE11;
	Mon,  4 Mar 2024 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SVjAOgsT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F9C1E48B
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709570274; cv=none; b=OTZBoeIbd+yc5doYhXmkXuMfMTJejPzivYECMNpLT4g2UQAcz7bM1XknpOw/XZMVebZHGkwsGshCR59XFte4+sRfcgks/8kw99ATDIyIIkJ5xwhAfUODjN2nTGx8eLkAF6UV/G7y/vfzjMlkAoljGyx0OFiCc9+nmxPrYR9P5S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709570274; c=relaxed/simple;
	bh=4aHwxdGxoejJyDNv4pzXE89oIPQDG1fk8iLHeraQ44A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F9b107drdTXB4umV5r0R6FtvfLzPmRq8tMeJRDyp9YnH8rr11SzBxs+gzV2m3QiZZdJeEs4Lg1c/Etqv/KJ+A4DhNzsCHb7GiesQo6nIO1xz/YyLEA67VsKMkhA5JhGM5aATmbITvj6lpGb26n2RnNstOrk0u6H2PSxc+n/01zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SVjAOgsT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc693399655so8577013276.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 08:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709570272; x=1710175072; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/KfEI8gaz4FKcUI1Choooy+OQPG/WSY3Mi84VhLiojA=;
        b=SVjAOgsTAb7LTd/AgGIKifD54zcwgIHkO0SmhnWwBDsPzD8y1o8BB3xTNQPQBDeyp6
         Ze7VNkw0JhTvI6E+yGr51ls+RqUsNF5t0EWMOvqpzK4fzNLRfDHgD4kqnYsLQq0z1F7C
         /lWfy9UHrecra53scmeGuRrYT24+RmYTxLM+v4amvIvIcexqj4HzwDmrjc+PQCbZwxRQ
         5ERnZlbvJpsR2AFkBFcw+5LxeilZBxRRqtsHYDVOCDVZIevNEMrvA1yfoIXNcfIcCGxc
         kV/sObYYeAQ6PEtlhlwegjMfVsv5kVHfYDVkONEVwkASv+6Vew/u45kwtKibHKSoAnnY
         uufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709570272; x=1710175072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/KfEI8gaz4FKcUI1Choooy+OQPG/WSY3Mi84VhLiojA=;
        b=seK8/cNOaOf/62KjQgO7ezTogxiqEt5xEWJVKV5i0LVY8jiCMvKyUyX+spiDEa7lLp
         VumIN3yNnPehkdlMTeP6lhSofA5+DFkzY0o/dGZa8Ywzuq2is86qL1bl2s3vFjBENckS
         cTWHj3BPqNmjlgo21Wlzxi2+x9YxO2KTDLGumMs1l3CJj/yG02DvttbgKDIV+RSc2j35
         +tIqzGpi0hV+dWml6YCrporGufGXW2tVqFPexCVS+LFbcmsZb8BQGQ61yGaKimQ2fBST
         BsGGXuuk0fgWMo5U2E47gErK1n+tZKHtV3XmT9Rj+IDJEJ5kR5YwgeGEs++F1rYfvlb1
         mIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKp3XhrAWggKM2YUZi9uZSCpElvJMcQz2rglYQaSNtBbiK1ZWycpmKwA5v9OVA/gbE0FGN6q9yIPiL08TltsZhjRUP
X-Gm-Message-State: AOJu0Yxgtvpbp85hnnW+9s/5DYRmOAp25FHw6S3CCNr21Ru8Y5BnP424
	CBZCVZGd0l9J6YonyPbsM+vbRR8i3+bHnO45qlgH73tqROlT2QB4oR6Y3H8JnAEQ5wuXVD8+Y47
	0mg==
X-Google-Smtp-Source: AGHT+IFr9VE+8742uLdZ5k+nJnffkgEUEpcactZjFcf1JOn5ZMwhDKcZ9pqmLwhs3Kkma5rYMDHsuRkJU0M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1101:b0:dc6:fec4:1c26 with SMTP id
 o1-20020a056902110100b00dc6fec41c26mr2470737ybu.1.1709570271925; Mon, 04 Mar
 2024 08:37:51 -0800 (PST)
Date: Mon, 4 Mar 2024 08:37:50 -0800
In-Reply-To: <ZeXpqf/0YoBmctw2@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <20240226190344.787149-14-pbonzini@redhat.com>
 <ZeXpqf/0YoBmctw2@yilunxu-OptiPlex-7050>
Message-ID: <ZeX43hHosoyCQsi-@google.com>
Subject: Re: [PATCH v3 13/15] KVM: SEV: define VM types for SEV and SEV-ES
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Xu Yilun wrote:
> On Mon, Feb 26, 2024 at 02:03:42PM -0500, Paolo Bonzini wrote:
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index d0c1b459f7e9..9d950b0b64c9 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -857,5 +857,7 @@ struct kvm_hyperv_eventfd {
> >  
> >  #define KVM_X86_DEFAULT_VM	0
> >  #define KVM_X86_SW_PROTECTED_VM	1
> > +#define KVM_X86_SEV_VM		2
> > +#define KVM_X86_SEV_ES_VM	3
> >  
> >  #endif /* _ASM_X86_KVM_H */
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 2549a539a686..1248ccf433e8 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -247,6 +247,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	if (kvm->created_vcpus)
> >  		return -EINVAL;
> >  
> > +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> 
> IIUC it should be KVM_X86_SEV_VM?

No, this is for the KVM_SEV_INIT version 1, which is restricted to "default" VMs.
The idea is that KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM guests must be initialized
via KVM_SEV_INIT2.

