Return-Path: <kvm+bounces-18232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB0A8D22C4
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC0E01C21F09
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6509045957;
	Tue, 28 May 2024 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MOGYGVjV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D13424B2F
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716918476; cv=none; b=QUGnXhhI12KvTZJ3qR2riqbi74DrqGlkZ6FALHBtWs80PD7M0G1BDfwt25jy+xb+TUrNIqO6xapepBAeMZZvKhHZVErEWKlj9DNIUp38zYNJ1xtGnQ2Jh3gBReoMWksh4HobzjLOG9STnNDx/rmBDv/yLWSMw+gCH2mGnRGbGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716918476; c=relaxed/simple;
	bh=IpaDiea+XrcitC1S3q3JbjCh6STq1vLCHmAgsLFtB9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y4EJk2AC0mdlLeOzLI8AjA020W+x4nBko2t3hLiyZX+8qAmGatrREVT7U+tKXnY4ta8PVMOCYFOB+qTxJuuPg2VdSYvPPmDEOWmvBYlPAkvFCZDn+hAcZJDJX++3uN+IssY/etb03A9GIZWCP7WRQOuwCffa0oJNeL9S96WenUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MOGYGVjV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716918474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IpaDiea+XrcitC1S3q3JbjCh6STq1vLCHmAgsLFtB9w=;
	b=MOGYGVjVfQTBkO8TkNzaWSTEF8UKGIal5QMgKrvQow4UWYvIF1180OcURMIFNQ2r+FVSnB
	1ORy6vfKfFt7hIr0KV1nw3yS8KTlDtIHVlFsAXUIr7GmGCaNckPkzyAzZmqZdjRcvPhuHv
	zkejIe1As+agBgvRFSNa2yyTeUgNYYY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-WCi3WK32MkmyhPrBIQbvuw-1; Tue, 28 May 2024 13:47:52 -0400
X-MC-Unique: WCi3WK32MkmyhPrBIQbvuw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4211043b5easo6318135e9.3
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:47:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716918471; x=1717523271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpaDiea+XrcitC1S3q3JbjCh6STq1vLCHmAgsLFtB9w=;
        b=acJBrkBnpZm9pYcQfnl55Y2A9Sbpm4ByzgGU9MOb+XfAi4BI0z0PAmhLzr/AqeMO9A
         E2Uu9NWK2jyAK1k7bmiqNpLhtRA4zxvX96AkXqFVQVZ9A0bwnku9qOlDXC77Dkj2KGnp
         teSJo4QKfW79a8m1UomXKCDOWGdhEJmLIDiC/LJCVrII3Or1H4M7z48JNM4Ax+WbH0i8
         HR4BmfrIlzpVFm0YWxzAHQSOZE1+pAIPu+mnhTQ7CpFpFzboHYXy68P3FEJNsvrSoBOs
         16m6aEmzNcZPgqdSC7pom5aqheK8FvluRpttJBPmkIg67E5WvIo/dwm8K6o905ste4g8
         c0qw==
X-Forwarded-Encrypted: i=1; AJvYcCUa6jptrHytkRFUjhxo+mQN54oqilIpR3TM9yDzbMS7eisheKxxoYIHSCOR0BtrNlG/l8/ksLJrQgkrcAWLontjFF3N
X-Gm-Message-State: AOJu0YyBnt4BEK2GmV+7asroR0WkCkrv+sl3TTNhYzXnAG3fQHj0NLz4
	w4hT2ILlED647YLHENS2E8hUwV1dmenyj4P1m4TkzksF5y5PPlQPJjqflMIO92Y7C9Lwn5ad7zT
	jJhp0jI1pwrovvAzBb5TPZ+P6H7mal2ycsu4dvUe1wzDQ8lzQXZChMUgd2hBTTafZ5m4b/bsltD
	8AEstOh0Nx6vu8/Ad5leHlyQGB
X-Received: by 2002:adf:fe88:0:b0:34d:e252:b57d with SMTP id ffacd0b85a97d-35526c27436mr10419517f8f.17.1716918471325;
        Tue, 28 May 2024 10:47:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaR5+xzvDJoxCZiUbtkXASxV59eIdH4br7ui/grcMLd6yTvO1MxQYSlArcsFBKf6TIUWptXdTnzqIM+RUJS3A=
X-Received: by 2002:adf:fe88:0:b0:34d:e252:b57d with SMTP id
 ffacd0b85a97d-35526c27436mr10419499f8f.17.1716918470964; Tue, 28 May 2024
 10:47:50 -0700 (PDT)
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
In-Reply-To: <31a2b098797b3837597880d5827a727fee9be11e.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 19:47:39 +0200
Message-ID: <CABgObfa+vx3euEXwopBBzt7BEVT8MV7HuuLayRKxURnopO3f=w@mail.gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 6:27=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> > I don't see benefit of x86_ops.max_gfn() compared to kvm->arch.max_gfn.
> > But I don't have strong preference. Either way will work.
>
> The non-TDX VM's won't need per-VM data, right? So it's just unneeded ext=
ra
> state per-vm.

It's just a cached value like there are many in the MMU. It's easier
for me to read code without the mental overhead of a function call.

> For TDX it will be based on the shared bit, so we actually already have t=
he per-
> vm data we need. So we don't even need both gfn_shared_mask and max_gfn f=
or TDX.

But they are independent, for example AMD placed the encryption bit
highest, then the reduced physical address space bits, then finally
the rest of the gfn. I think it's consistent with the kvm_has_*
approach, to not assume much and just store separate data.

Paolo


