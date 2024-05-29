Return-Path: <kvm+bounces-18267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A938D2E21
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 09:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1118C1C23E68
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013D4168C27;
	Wed, 29 May 2024 07:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Damz21XA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA9C16727E
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 07:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716967565; cv=none; b=XP44to+N6fLlgPssvm3d/Br7uw0dFMFjHAJRM6KYBSMzTN39CQHvOhZhvqUdXlnCkC+A0Di8h9CufKFP3SLTHOpUISjNVXBzfd9yu30rWnO9j03p9Unp50OyA+mVhVbimev/rsvyMLPvAtI9wypNL3bFrL+S/5pVBOtZAOr+1dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716967565; c=relaxed/simple;
	bh=HUp9ef2YRtaPOIAwZ9sDrRyclD6cn9Ku7vh8Zcktdeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQ2KpD2/ECHPkNjdjKXSsrZnsJ4er+TxcXcriBhjmfCAZnQ0g4yrz7w3L04KoiRZhR9bksW3kC8rTaQwhBO+qtFG+llo3Buka59HQj1FSoCHXlF+oUIzYn1PFu+4vghqBeto5JogCkHnoqxupuOdk/IZVlePRZy8GEOEDRrHlRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Damz21XA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716967561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HUp9ef2YRtaPOIAwZ9sDrRyclD6cn9Ku7vh8Zcktdeg=;
	b=Damz21XAORbP0kIyn4LQeHpbSNw2wKJaoFqykJOcKPy5xPsbauLDA8p3O+XwO3/PZ3xBkE
	q3U0705m2g8luVVJ+HVn2L+CsoxHTeELmg1shVxcqyZjL3HAXEjgWlVe9UtcxJol+uSsJ2
	mfKMsKGmzN+A6lM6XUb0iYHcG2FQg60=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-aYiOrjcaMdGihgEc3ERBCw-1; Wed, 29 May 2024 03:26:00 -0400
X-MC-Unique: aYiOrjcaMdGihgEc3ERBCw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-354f34e0ab0so1116539f8f.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 00:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716967559; x=1717572359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUp9ef2YRtaPOIAwZ9sDrRyclD6cn9Ku7vh8Zcktdeg=;
        b=t+2XIx+SYsLKNoKuoQOzu/GIJxkGNLrlsWrwgM+kQakbATEvNoTujzKsC15onMqUtD
         WTiUrZjtkJ9QdNZGYlW+ysK++xk2+S3veZlVPqMCgg+dnDJtVxKwCeCZLdSCOhMPcLHW
         zpNuilx0jb8k4CDGNjeMxafsTU0H6/gjqsbRHhhrV6l/eSXG+EkLyv/DapOBGcs5eHEb
         OmhMb2Y7mZe+EsN7dws/3mKT3FQUZdYJAWeeycafT8YxxW0DT2SEhb5V/4ZiWk1gmtF2
         qE20UyiEhG+2ZM17KrXQYieC8oQGtZB8p36G219A1gGUaeuKpop3uVoSc50sfuzdhCYe
         IGmw==
X-Forwarded-Encrypted: i=1; AJvYcCUF4o1aroCRHlm1O7KgtLEbHVJwH8hRU1yZ1357d4Vv7YJIDeCZGerSymFJXWPtX1n9gJLQ22/GRMCEEjK201z0RDAy
X-Gm-Message-State: AOJu0YxMdA+CCcH4fTKedkw7nT2+hX6vZiA4wFnmKa6C2o+78hKL/RsR
	cK1UaL8d/ctkPltDb6zUqsHmof5rnEbcDKrjPmxa16ejQOqq0DIkTrwLNmyWyVJobjPo4XopqwX
	5AgTJjsn+n3Wwb8djWDprwNdulThX+OZZw3AQQh8F2zgh6E3BPRCRleFsFLBAJU/mxzK/XgP264
	yOofWlvaLQd5oaikkzVigFDV0/
X-Received: by 2002:adf:cf06:0:b0:354:fa0d:142b with SMTP id ffacd0b85a97d-35526c4bf41mr9321832f8f.13.1716967558820;
        Wed, 29 May 2024 00:25:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8aTkcnZX+WdmGFYx/MjXvWWiuu39mNoQ9X7Jpocswrxp+wFIAYP3mJbd7ljDqT8tJA9r9RJI7Rb8VXqpoEGE=
X-Received: by 2002:adf:cf06:0:b0:354:fa0d:142b with SMTP id
 ffacd0b85a97d-35526c4bf41mr9321820f8f.13.1716967558434; Wed, 29 May 2024
 00:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com> <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
 <20240521161520.GB212599@ls.amr.corp.intel.com> <20240522223413.GC212599@ls.amr.corp.intel.com>
 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
 <20240522234754.GD212599@ls.amr.corp.intel.com> <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
 <20240523000100.GE212599@ls.amr.corp.intel.com> <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
 <20240524075519.GF212599@ls.amr.corp.intel.com> <31a2b098797b3837597880d5827a727fee9be11e.camel@intel.com>
 <CABgObfa+vx3euEXwopBBzt7BEVT8MV7HuuLayRKxURnopO3f=w@mail.gmail.com> <b6217ba2f75366d25ff46cd72dcf671cdc57f340.camel@intel.com>
In-Reply-To: <b6217ba2f75366d25ff46cd72dcf671cdc57f340.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 29 May 2024 09:25:46 +0200
Message-ID: <CABgObfYCnC2qoMHmKx7QK=pEoARfcGw=F-epXYT4z6uoJeH_-w@mail.gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 4:14=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2024-05-28 at 19:47 +0200, Paolo Bonzini wrote:
> > On Tue, May 28, 2024 at 6:27=E2=80=AFPM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > > > I don't see benefit of x86_ops.max_gfn() compared to kvm->arch.max_=
gfn.
> > > > But I don't have strong preference. Either way will work.
> > >
> > > The non-TDX VM's won't need per-VM data, right? So it's just unneeded=
 extra
> > > state per-vm.
> >
> > It's just a cached value like there are many in the MMU. It's easier
> > for me to read code without the mental overhead of a function call.
>
> Ok. Since this has (optimization) utility beyond TDX, maybe it's worth sp=
litting
> it off as a separate patch? I think maybe we'll pursue this path unless t=
here is
> objection.

Yes, absolutely.

Paolo


