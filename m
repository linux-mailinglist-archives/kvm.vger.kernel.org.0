Return-Path: <kvm+bounces-52194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CEFB0240E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 779FC3AAD96
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBE52F2711;
	Fri, 11 Jul 2025 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1KFlKADO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D45B13B590
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752259587; cv=none; b=dNKnGe/0guqukcZU6KNhGDFzaHEbbaWKkp4Bl7vpymnxLfzW0lDWKFwGxtLV7iadDD5rinosh6hZX/4PcqZ32ZKjrvfEokPrRqBJBx4QBnjC/nlFtRvWfqym9y6kHgD16RL4qUz9OzdC6iVUMOVQmItsLJ/S5nKNpgiDaH77InM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752259587; c=relaxed/simple;
	bh=zYiGdxOL7zThjAm9ak0MVc2aInvxHTk2ZyWy/3uXVMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dztdl3Ck/VDCA1bvy2MbSHcNbcFkxBty70UwF+p/set1gn7DEmodVLjwjR5F/hQHqf2BohWYtyaSgKXn/iImkDCzxUGFaA88TGrDgP42Y3GC6R/jyZvJrOzu2JzURqXyq/f/JgnhPnR/DEZbUn7bCRl1oOzkBViAgbeaJzZ2Rro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1KFlKADO; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235e389599fso28615ad.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752259585; x=1752864385; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3aEobjPCY0l74zDE1rwtOs+YJ5bZnTUHt69hJSYx74=;
        b=1KFlKADOX2x+IU2feQiUTjByA17XFUtmEXyHKzLAXDUNBZy3Hh6Pt2T30cDFjNfEfF
         GW6KwYvROeqbazzlDDpGx8URU4ztlIbDplvIgGdPeUn1nxE5zXu+aitMzpIaBRh1A5Xs
         krYn8Ixzb7IurIP3tg1sI0cTL6bTVEbEx9EgAkkcoXYHl+U3RPeejLTJKqpzuaBQJZJM
         pyfRXI2KpeLKWt6z9xCFRau577sPoPrHJsDusJpHlqo9OJX0jN37TjU+Iy2UC9JwZ22Y
         vF24rIB1Ibb0LVH3HCDKXsEOYZPYREPLz8Ui/iZ25pjvvVDgEh1NuamQO5Zwr/Z5bpII
         CLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752259585; x=1752864385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3aEobjPCY0l74zDE1rwtOs+YJ5bZnTUHt69hJSYx74=;
        b=dqGkrk0urJqkI6VXZV67/nev+tZR4SANcVLCbb5jz7D8QI9/uGa9Hs+kLeNZhEXqef
         jHAImOc2LPR8kpu3QoF4B+enx5ztAQsfCmw5wfr9WqKEGZR5JKUSt/N4OORDJmHUSSeQ
         AcgTYStAenH1TD+h6d/wvuzv83z0L+ON48qss+vTZWCeQpKVc5exPI1UCFg+CM1asyp0
         6uhQngcvVSbQ1+vcdmQyBLXBOSIJjDESnSpZRCaNXbor4jZV+04CZUw5AKDPBNMSARCh
         WhH3xuCeTvmVvTXSyI5lQaupA5dCF8aK8o0YOZGEJNzty39hcXNvbEq+MIYBJMiHrhp1
         ThJw==
X-Forwarded-Encrypted: i=1; AJvYcCWyS9zg7lUadFv2QWydwvjoCw5UvecLeZmobQqAh69vyG6CyOkueU6LejKOxcPoiQhzK9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYyQgu7+CS4Dml+axC50BMOfFs2bda8MAKOlAaxFt8kePyZ1+J
	IjEy/7KiSeSEqD+CSBucw/6ZRhgkcg8fGgV6mixXOzPLJy0QtJLbrj133eO36mf6yxkq4OeE/k+
	sJSUOVPZ45L9R0nE8HF8TP84yXoaAmGxCjbIQuh4v
X-Gm-Gg: ASbGncuE4LE5i8QVtS/zJzcXVJZHSQrwCSLzk3hx9wkGTzLfWja+FOvx1E52EhUx/Py
	vqleRqUA3SPz2MHg63mNLv4ZflV8JgvtyC5FgBqrK26a3zxq7oNZjUM9RJlN3cOldjP04t7pS9Q
	5JDyYFBu7wGXaWFcDcpPtN4LC4VLbljuvaDa45mQ6X1IVUW6aE53hDzoAt3GycAif8f0CDNFNX7
	MeQrhCqaOo9N8wOf0e54C3i+FRip9S9ZZ+DLQ==
X-Google-Smtp-Source: AGHT+IElSHIK+nFgCq+qGXxEYfAJicQBUs9O8jurR7Ssr4uaPjtm1X6j112grWmousd9jed4zUvBFs/XqJrLOCmyabM=
X-Received: by 2002:a17:903:1b30:b0:234:a734:4ab9 with SMTP id
 d9443c01a7336-23df6a2907bmr282615ad.20.1752259584520; Fri, 11 Jul 2025
 11:46:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
In-Reply-To: <aHEwT4X0RcfZzHlt@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 11 Jul 2025 11:46:12 -0700
X-Gm-Features: Ac12FXxHO3aH_ClVGK7BVe1DV9rCSynSWxs-Uxj1Wjji9UEyfhn7erZXSt82de4
Message-ID: <CAGtprH9NOdN9VZWkWLjYcTixrN1+dgWfC3rcdmv9rQBkriZrdQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 8:40=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jul 11, 2025, Michael Roth wrote:
> > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in th=
e patch
> > > log:
> > >
> > > Problem
> > > =3D=3D=3D
> > > ...
> > > (2)
> > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > > resulting in the following lock sequence in tdx_vcpu_init_mem_region(=
):
> > > - filemap invalidation lock --> mm->mmap_lock
> > >
> > > However, in future code, the shared filemap invalidation lock will be=
 held
> > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > - mm->mmap_lock --> filemap invalidation lock
> >
> > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it)=
.
>
> Irrespective of shared faults, I think the API could do with a bit of cle=
anup
> now that TDX has landed, i.e. now that we can see a bit more of the pictu=
re.
>
> As is, I'm pretty sure TDX is broken with respect to hugepage support, be=
cause
> kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever =
deals
> with one page at a time.  So that needs to be changed.  I assume it's alr=
eady
> address in one of the many upcoming series, but it still shows a flaw in =
the API.
>
> Hoisting the retrieval of the source page outside of filemap_invalidate_l=
ock()
> seems pretty straightforward, and would provide consistent ABI for all ve=
ndor

Will relying on standard KVM -> guest_memfd interaction i.e.
simulating a second stage fault to get the right target address work
for all vendors i.e. CCA/SNP/TDX? If so, we might not have to maintain
this out of band path of kvm_gmem_populate.

> flavors.  E.g. as is, non-struct-page memory will work for SNP, but not T=
DX.  The
> obvious downside is that struct-page becomes a requirement for SNP, but t=
hat
>

Maybe you had more thought here?

