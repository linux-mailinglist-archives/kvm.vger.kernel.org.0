Return-Path: <kvm+bounces-26728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2E3976C8D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69452B24884
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C731BAEF0;
	Thu, 12 Sep 2024 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWW9yDkB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3A14293
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152419; cv=none; b=TngfY5TkzRrrxXyNhFmwvOGpHdUh4NjdmA1pV++kberlxmnCppuBbh2AtiSiF02Yb+OKWB2vKAUG+OmGK/udbJO1Nqmeto6U/IW3blvJx5LJCTjOUEBzCFviXcmF0NkR98CzTxVRSiq5GlqszaJOp6Pf2QGV/o4TTe62qVteas8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152419; c=relaxed/simple;
	bh=tpdgi4juBb051AiOwZ5loJ0Avk2Y9YVyXPUQ57w6zTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Soj1NN/QbLz9fu/c2BiKNcDBtmnsa4mr8lAx26LWorgcwFlVhUgsj19ttLXbCUvOulSa7/edYiSF01Au2rezfFU84Mbm1kkzQe2BjQmat8Nx+A06ZTMGIkJeptTj+qpw5dZcrqk3FYMvsf9QIu1bmyzw4PJmEY8vKbQ1a7pNihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWW9yDkB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726152417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpdgi4juBb051AiOwZ5loJ0Avk2Y9YVyXPUQ57w6zTk=;
	b=LWW9yDkBBnvJQc0+nXBykRoboaZyYWVBqj0g4nqgE0pxJ2PWFxAnt/DpuOC3oMOHfVa7ot
	weObX6hXjKzqPsqleHTqkFN3fECOSTk8MPI+K3hIG+W7mhVNgNnYR3wCU0WSErjoukKn5W
	TKWuDMRaZSb8xx6J7fc22kQ70FSiP5U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-XHV2DcpNOCaxQlEVFhfofw-1; Thu, 12 Sep 2024 10:46:53 -0400
X-MC-Unique: XHV2DcpNOCaxQlEVFhfofw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3730b54347cso504063f8f.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726152412; x=1726757212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tpdgi4juBb051AiOwZ5loJ0Avk2Y9YVyXPUQ57w6zTk=;
        b=DH5nL6WoYwEp1O9Ds/zKXjoag7CvMudJat1YCUnu/yrcd7AvCt3ymDQexeRzzU0YKe
         beJEGEfl5zPBGC8aujCNyCjWMyNsNV0x1UTyptOmC+DcfNOl5ZgVRc7nQWI4a/D1QSHp
         +sTUynArz9DoUC6BkFxsE7FU2UqXktdswrqxfQ4574U//aDEXRtBYj6KuMMpA05SLN3v
         KlnYxiMs8X4ScAyMfPPyInOTaQTDtTEI7a3/8D6ZbChjZFXmlgJuZgmwuSaxUK9+M/M+
         5rDObGOUpq9IJhCuD6oz+xhVDDMa3nca/eO0cdQ90KlRetqH327UgTZ0UFOLGF4LenEO
         E35A==
X-Forwarded-Encrypted: i=1; AJvYcCWnZmq4RrHUqeAJl+k0kyhmmL8MQqaIUCRmkRuoGXvQi4qAdOdD9FKblSkvYt0RJPk1OMM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1LWkSUzReqBJprnvEOTaFx7npqKiSYIHAFuNf1JKRl/lsrJNu
	H47Z744i+djGKdtmYDVAs1nP2st8g0ugQeyVrSpH4sCMBp3GtRaKxbmLRurnktqG0WYR3vqC+0F
	h1858Xx/16D23jmF8QNnurjkofegHvb5lsG/tApFWNU++90/HpmT4DhMNN+OGgbQ8CzD6eNYY74
	XpPTchqGaAqMLUHui8yOP40Ztq
X-Received: by 2002:a05:6000:128b:b0:374:c911:7756 with SMTP id ffacd0b85a97d-378c2d5a0b9mr1767653f8f.38.1726152412431;
        Thu, 12 Sep 2024 07:46:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXOt7eWeKrY/oke1uOUY9JGn1eMWvkplmC6z0F6bdmjBjP9Jctk6jvW8//ZU8X0ryKSQz/AKC9pD2uLCl6aP8=
X-Received: by 2002:a05:6000:128b:b0:374:c911:7756 with SMTP id
 ffacd0b85a97d-378c2d5a0b9mr1767637f8f.38.1726152411958; Thu, 12 Sep 2024
 07:46:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com> <8761e1b8-4c65-4837-b152-98be86cf220d@intel.com>
 <ZuLzl6reeDH_1fFh@google.com> <d5c49c918a86d37995ed6388c1e77cd41fc51c19.camel@intel.com>
In-Reply-To: <d5c49c918a86d37995ed6388c1e77cd41fc51c19.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Sep 2024 16:46:39 +0200
Message-ID: <CABgObfZsqf7BbXo0CzyDOAG=x_GucHt-kANQHLa=on9RhE_ngg@mail.gmail.com>
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private mem
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 4:43=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Thu, 2024-09-12 at 06:58 -0700, Sean Christopherson wrote:
> > > Which clearly says it is checking the *faulting* GPA.
> >
> > I don't think that necessarily solves the problem either, because the r=
eader
> > has
> > to know that the KVM looks at the shared bit.
> >
> > If open coding is undesirable
>
> Yea, I think it's used in enough places that a helper is worth it.
>
> > , maybe a very literal name, e.g. vmx_is_shared_bit_set()?
>
> Sure, thanks.

I didn't see a problem with kvm_is_private_gpa(), but I do prefer
something that has vmx_ or vt_ in the name after seeing it. My
preference would go to something like vt_is_tdx_private_gpa(), but I'm
not going to force one name or another.

Paolo


