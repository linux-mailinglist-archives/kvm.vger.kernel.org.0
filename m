Return-Path: <kvm+bounces-11226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8581187452E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E366287041
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C473FEC;
	Thu,  7 Mar 2024 00:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kXbROZBU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3A1391
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709771816; cv=none; b=NacmIo6/dEZfSYJeTjMdH5gsm+r3wrf4Tfjj3NBveOTLUauttVj7+e5YcokFSot1p2fKDty6K9Gfg2iTpJmSP6NpVqac+ZaQbyru06DZWELGHyPOrGUqhoxwX9dm0zHnqJXxFjbZAaYdUO7jYzfXzz89c7RRiOyt8l1sAnMbCYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709771816; c=relaxed/simple;
	bh=L9dgnWyLxFCVdggjmJiORnnWcjypSYVxA8mld3gFTj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JawfIZSCtFc1pVfxzqJrSoR4TPzDxnR51l9uri3/L9+Lp2J8mSGEeiN2L/SOtZVUePtgA33gEc7Ky6uXMNQ/o/W/ezU5iRa3biF8A7bW9WGvFGxUmaaDwSCSiAzDOYY+T/gFxOySTo92L+HyQYSeLOOCTPaRRLRuHcI+jIuL7Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kXbROZBU; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33e1878e357so156706f8f.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 16:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709771813; x=1710376613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sA+douFdCVSw2K0QPSVkTDqBV+yw1K0VDjl64dpeibg=;
        b=kXbROZBU1kB+arwyc8KxlyCpXSM83Kp0Zvx7bscuuNxL9irmq698P4HeS2IDpHZjJ+
         1M0Ck2/ehlGZRfk2SmsnhpxuRD9s9+GRippLj06ZEUIMRlZyt+H+/1A16CG9sBP1gTdy
         TBQa8aGWvtTFMplkJngq/PgHmnuJQKUIT6rXmlQIUdqIWYs3/YLLwsqx1QlPLiXKZAVP
         YSvc0ZOCft8K4lPE7M/PZ1nxxBH4zat1ihmVEfjLdvpOfXKxTHYiQ7FJ14M+ghbKhpzy
         5c38mNJIWGQxxuqho2e9BCkgk95Wj0+zVD0nmH/Jb7EbK2B1+Ak366ymBTCMiqXkGym3
         uT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709771813; x=1710376613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sA+douFdCVSw2K0QPSVkTDqBV+yw1K0VDjl64dpeibg=;
        b=uNAtfN5dDDnzCEgGRuEqjqRr3dGJEiSSa6y+XomSGv2LAC9WsAfRRhivIrhQKsIUU1
         qGx7Q7dlNn7pL/M9XSUSib9f++vj15szk0LgxdF9VFnq6XBxd90Q6fGKOOhPItnl47qE
         pI9MsGk2wIJNpVncKV63juKIVFk9MF9TTfBZoDOztbfxovbvmMeD5v+9S2Q7cZAZ/edt
         Gtgz0JxPV+Bnn05DRtexHoxI7WWTAU36mzx3L6eKE6vGBSf2JFozHzeB5yngFjyi7kq2
         CT5o00z3THDf5oxS4bg/ii1eXZB1crLsaRv8bwg437qpwnTyvJv5vfB/mlFCMDufSU1q
         5f9w==
X-Gm-Message-State: AOJu0YyUkDu3aEc3oTyqJmu9cLCw0eKh7Fwao1fBmVrGeMDBcblsVXmS
	zqG5lXeGgde9cZgNW38UN7gE1tLYLmrebZ4hFAdsV1SPlOwL0ue8Vxnk/Keixn8URItCByMkHS2
	iSo5/4kTjpEjL9tRvQP0DnTe+MJddPkn9PODA
X-Google-Smtp-Source: AGHT+IFaagZRCCemBSS/fbnTN+CGon0DKBjI0AJKtCElvj+bTZZKWGY7FBjNXKPsRWWE6tButWW/iJZi6gvGKtUfzuA=
X-Received: by 2002:a05:6000:250:b0:33e:1c80:7a0 with SMTP id
 m16-20020a056000025000b0033e1c8007a0mr9969063wrz.17.1709771813319; Wed, 06
 Mar 2024 16:36:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <ZekKwlLdf6vm5e5u@google.com>
In-Reply-To: <ZekKwlLdf6vm5e5u@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 6 Mar 2024 16:36:25 -0800
Message-ID: <CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>, 
	Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 4:31=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> >
> > +     if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_1G=
)) &&
> > +         mapping->nr_pages >=3D KVM_PAGES_PER_HPAGE(PG_LEVEL_1G))
> > +             max_level =3D PG_LEVEL_1G;
> > +     else if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEV=
EL_2M)) &&
> > +              mapping->nr_pages >=3D KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> > +             max_level =3D PG_LEVEL_2M;
> > +     else
> > +             max_level =3D PG_LEVEL_4K;
>
> Is there a requirement that KVM must not map memory outside of the
> requested region?

And if so, what if the requested region is already mapped with a larger pag=
e?

