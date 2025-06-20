Return-Path: <kvm+bounces-50062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5516AE1A6D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96E324A5230
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AAC28B3E2;
	Fri, 20 Jun 2025 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTaPe6/q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB928A702
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421046; cv=none; b=QZ85joxctNKNh5Dke7/+iw2gf9z/jMId9RNSEYY0tA8qrRuAoflITGTPVvCMzTpG/TxLlA4QPkzuMxJ/adbkYb6xUv9Ytt3cWTxPEc5ygGgRZ3j33UPWIZmmEV5N/Q9EFCJn+/z45by9YK6EWLYg+X1XQNl7GtNNsx/7eatpYdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421046; c=relaxed/simple;
	bh=l1Z6RZ+Jg/F0bsfyt7bxGpqft0eCD+Wo2GNzL0aL/xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O+oqLi5cRglo5M3eovM6JfBfD4KZABovR18mnybwaOpo9lhjRa2L6pBk5kxI0vkPDOiFQ7ReugFLFEmTxCIYwFoaA6orsNCfWFOcFL5uvWg4oXRTZW9ZSypY+xBKqVboyBF8SK5y4CP8ZJ0hIk1LW5DGn7EZ9qc1OIN/picDiV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTaPe6/q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750421044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JW3kxfXMYL5iahKOftdvklIyRga4xpLB5+77DL7Pz9M=;
	b=hTaPe6/qfpZATNdEbXTfqSn94+igvssEc/Tszvlwno2SKMzZTr0T+qHer0FHxp9M9R4TjE
	tL3psX/uLfO2dkQxyr6lt61p74RhiZrhmIkvdp04QnDHxT8C8EvflojXBl2ymezvHcZy2y
	x231bOLvcIC9NGpRb9br5vcz/kl1Zzg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-rD2-0iF2O4mpFHRp26HT8w-1; Fri, 20 Jun 2025 08:04:03 -0400
X-MC-Unique: rD2-0iF2O4mpFHRp26HT8w-1
X-Mimecast-MFC-AGG-ID: rD2-0iF2O4mpFHRp26HT8w_1750421042
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4532514dee8so13517905e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 05:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750421042; x=1751025842;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JW3kxfXMYL5iahKOftdvklIyRga4xpLB5+77DL7Pz9M=;
        b=Hii8TUQAo1S9zVb8237tTrPvy9V/6Q+2LUoLVtwSNO6Pe7YE88b06wZ1HSqvQ9J5/X
         /Eb1DDwCdaj02ngVma5H2XJMdwjzdt7nfCYCkpmPuiifFjJvH7xdFp3bMuy8jARnou1x
         SstcJvChdcGki3Plq2KpabD/MtApqhaFazvH1TC7Llp2jD4dZgcnEBgAxrPRzBxBI39v
         ljUGJTsx2u4vyvGeEBGlrZzziRNdd/RY6WAVPLW86S2zAOu8gw7CunuJ4ki13HN9CABy
         vYtTaIWdWIDsLJmxO/z8ABDC1kBcah4xhP21CTOXYPvENmJb9QxOygvQhLjJ5DLNpqZQ
         sXvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK4XHcNTaq+5J6p8O+bOeR0rg2+ht0h4dULK43Df7Ig6mz9EuEQ7gnJg73lgRMvs9kqFg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2/gG9bPufeaT1Vn66VuFvxKK0qpvTEabiFJFTB1k8+MleVgb4
	Tvgt3dXaMGb7ctwiw5tLL8XccDPLg6g1yFXZoTqzT06DRS2/ziNelVrjwvf01fAp0iUO4jHndSu
	atfVYAzRUmzms0SPVCkQ8xVo7VBNXGLCgzP1fGYRVIPIUSc+kZC68mpcZLrIdREDcIxusMcbwWd
	7vns1eiwhGTazCZvvioqX+TL3+h6xQ
X-Gm-Gg: ASbGnctaYXn5w0G8nRCIhTH/AsMmu8FJTDP/F+xjOF4PGotv6G7U4gXMMqm1t1pWs9S
	xHfRs0fMtsbDXFLIIYMaNtNdFxUiyo7PTNn851iw+6RoN8gMnTOomM6YB6FsNqlND3TAt1qPRtQ
	QpW/0=
X-Received: by 2002:a5d:5f8e:0:b0:3a5:243c:6042 with SMTP id ffacd0b85a97d-3a6d12bb6b6mr2193976f8f.2.1750421041728;
        Fri, 20 Jun 2025 05:04:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJzasLSc76E2amKmRvg22TG4v1hAFaZKZ2pNBS9y7yYicS3IGqkmtp9MKL+Y+V7M0fpDUlyS00yQ6bumKJzPI=
X-Received: by 2002:a5d:5f8e:0:b0:3a5:243c:6042 with SMTP id
 ffacd0b85a97d-3a6d12bb6b6mr2193916f8f.2.1750421041262; Fri, 20 Jun 2025
 05:04:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619180159.187358-1-pbonzini@redhat.com> <20250619180159.187358-4-pbonzini@redhat.com>
 <cc443335-442d-4ed0-aa01-a6bf5c27b39c@intel.com>
In-Reply-To: <cc443335-442d-4ed0-aa01-a6bf5c27b39c@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 14:03:49 +0200
X-Gm-Features: Ac12FXzbneTz5YpRMuZL36zwNtkuaeE1Xz-EjUQKtd3ZczaGjNE0oZuCnQ-GZx8
Message-ID: <CABgObfaeYdKeYQb+6j6j6u5ytasgb=t2z03cQvkG2c+owfOCgg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, reinette.chatre@intel.com, 
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, mikko.ylinen@linux.intel.com, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Il ven 20 giu 2025, 03:21 Xiaoyao Li <xiaoyao.li@intel.com> ha scritto:
>
> >               tdx->vp_enter_args.r11 = 0;
> > +             tdx->vp_enter_args.r12 = 0;
> >               tdx->vp_enter_args.r13 = 0;
> >               tdx->vp_enter_args.r14 = 0;
> > +             return 1;
>
> Though it looks OK to return all-0 for r12 == 0 and undefined case of
> r12 > 1, I prefer returning TDVMCALL_STATUS_INVALID_OPERAND for
> undefined case.


From the GHCI I wasn't sure that TDVMCALL_STATUS_INVALID_OPERAND is a
valid result at all.

Paolo

>
> So please make above "case 0:", and make the "default:" return
> TDVMCALL_STATUS_INVALID_OPERAND
>
> >       }
> > -     return 1;
> >   }
> >
> >   static int tdx_complete_simple(struct kvm_vcpu *vcpu)
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 6708bc88ae69..fb3b4cd8d662 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -461,6 +461,11 @@ struct kvm_run {
> >                                       __u64 gpa;
> >                                       __u64 size;
> >                               } get_quote;
> > +                             struct {
> > +                                     __u64 ret;
> > +                                     __u64 leaf;
> > +                                     __u64 r11, r12, r13, r14;
> > +                             } get_tdvmcall_info;
> >                       };
> >               } tdx;
> >               /* Fix the size of the union. */
>


