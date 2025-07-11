Return-Path: <kvm+bounces-52200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64693B025B0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5708584D69
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947C11F582A;
	Fri, 11 Jul 2025 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ucH3mN91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9E01E3DED
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 20:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752265182; cv=none; b=owxCmjkesSgNGpFUNfY5aGBtcJBQyuAvp0riA/t/85GBI8bUZgoGlhvoU6CudzUgNEmbvZrMDz7zN0wsx3Q5t1/uEH1FpbW2In1BYwQZoCAi/pXGx5bswKZfUzkK3NW9DBF5wnadNkl+RWuKjS6PT6JvzzytPcXPSzLU9FaU+9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752265182; c=relaxed/simple;
	bh=pnA59S//kLucI33SLPLNMt/VAXs6rqybvR8MkQ5JGmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tcHFvUGUBJ3jlbVegwqVPfJAu7/Z1eO6ajDP1S1c2C22jTm6hrUqWofF9dbPARpzgumAN284tPLUnf8imhSK6WSUwxC5A7V9Q1356WJP+SAcsPdZF9ReT24EL9f/rUvI24GkZlU+VkLfNtkP90PzMIcgdYxon9Tu6cM5Kz8l+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ucH3mN91; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e64b3f1so3362315a91.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752265181; x=1752869981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JPIsTcGu3PzRjBRBPaSZ6h7JDJNM68m0YAet5vg2Ms=;
        b=ucH3mN917I/pTJAHu+SGGpoeSy0RA4UuI56ekXWpKZJLdT5JQ03hlCu8Gba/1Oassd
         Azmkcc/CsoWhG+zcgy43HrtfIJ+HnYB2DB+kc9dYbexdyWtm4NGTGjcCoXJBdAxVQLgX
         YfsmgzG3BeyDQ24engxrFRFaQbBzA6Kz1ZTrllcM6MMaWTfUSDjRWckDSRzITdTjfVLl
         dFPzUSdO0tMtihOcWDJ/GaMkbCxBL/0Puy5y2AWZ+0SX7KOtUuusmmwbd+aK5piZj9o3
         eAPhh1CXRn3OCLI5O/G4AF29Y2QncIeAMazRcTmnhhxBZhdr4iAleKln8vybaZI/5/R+
         IVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752265181; x=1752869981;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2JPIsTcGu3PzRjBRBPaSZ6h7JDJNM68m0YAet5vg2Ms=;
        b=KbKG/bCahCrdeUfjiZxwLfTVB0CBiYpIxP2Zrcag7oneWuMJWuqU82wsTaxAlN2Pgy
         JeRk31P+hI2No/IvJEn9Hn3yCLEaXsFOAO3xVRgSg8nNQGSuIS9bqkcMf9KVZZg2TX88
         E7wTDyRDEU/78s+bENVJsfTiD9E7IIuGacHN5OUjJatVkjlsLf5YfTMTbGa0373PAkO1
         TOs7unYoAlz9aoIDRAMpu2AWPF9bDLtIrm0qr77jB74NmClfweBaX0bsXevbKS3+TWf2
         zslY0VNGLGmhX4p2A//SEyjRuKAeU78EOGYdocHkjH7y6YIlJr7yDKjBp1T8hbCb8kuy
         KQHg==
X-Forwarded-Encrypted: i=1; AJvYcCVWjJtf2bzRKv2W8O1kFJ+NFz+tKFtsXaW8tJMYAjk4VxB4qUaxMy7D4HF125QMJAoXeEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSUSzqJ3g3bTuTI3BBmhDmELmaI5C5A4k6mM9KMFvVUquFzAxW
	1OawQJwdo+/zphprhf2XncY5o+snENZ0Ojg8iKVUMnYThKeDtBaiB7BuTznVFWQP6D//wMFCR2c
	y1miOXw==
X-Google-Smtp-Source: AGHT+IE6jEDwuGJPzaPjMy3zMp4wWJzRDJZe6xL+mp6zIDzjwiRhlPL5m4qyqH9zku8KZY/dtiqyIvbC7RA=
X-Received: from pjbnd12.prod.google.com ([2002:a17:90b:4ccc:b0:311:c20d:676d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5105:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-31c4f573304mr6033735a91.17.1752265180689; Fri, 11
 Jul 2025 13:19:40 -0700 (PDT)
Date: Fri, 11 Jul 2025 13:19:39 -0700
In-Reply-To: <20250711194952.ppzljx7sb6ouiwix@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com> <CAGtprH9dCCxK=GwVZTUKCeERQGbYD78-t4xDzQprmwtGxDoZXw@mail.gmail.com>
 <20250711194952.ppzljx7sb6ouiwix@amd.com>
Message-ID: <aHFx2wtHcfimVKW_@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025, Michael Roth wrote:
> On Fri, Jul 11, 2025 at 11:38:10AM -0700, Vishal Annapurve wrote:
> > On Fri, Jul 11, 2025 at 9:37=E2=80=AFAM Michael Roth <michael.roth@amd.=
com> wrote:
> > >
> > > >
> > > > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_=
slot *slot,
> > > >                               struct file *file, gfn_t gfn, void __=
user *src,
> > > >                               kvm_gmem_populate_cb post_populate, v=
oid *opaque)
> > > > {
> > > >       pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> > > >       struct page *src_page =3D NULL;
> > > >       bool is_prepared =3D false;
> > > >       struct folio *folio;
> > > >       int ret, max_order;
> > > >       kvm_pfn_t pfn;
> > > >
> > > >       if (src) {
> > > >               ret =3D get_user_pages((unsigned long)src, 1, 0, &src=
_page);
> > > >               if (ret < 0)
> > > >                       return ret;
> > > >               if (ret !=3D 1)
> > > >                       return -ENOMEM;
> > > >       }
> > >
> > > One tricky part here is that the uAPI currently expects the pages to
> > > have the private attribute set prior to calling kvm_gmem_populate(),
> > > which gets enforced below.
> > >
> > > For in-place conversion: the idea is that userspace will convert
> > > private->shared to update in-place, then immediately convert back
> > > shared->private; so that approach would remain compatible with above
> > > behavior. But if we pass a 'src' parameter to kvm_gmem_populate(),
> > > and do a GUP or copy_from_user() on it at any point, regardless if
> > > it is is outside of filemap_invalidate_lock(), then
> > > kvm_gmem_fault_shared() will return -EACCES.
> >=20
> > I think that's a fine way to fail the initial memory population, this
> > simply means userspace didn't pass the right source address. Why do we
> > have to work around this error? Userspace should simply pass the
> > source buffer that is accessible to the host or pass null to indicate
> > that the target gfn already has the needed contents.
> >=20
> > That is, userspace can still bring a separate source buffer even with
> > in-place conversion available.

Yeah.  It might be superfluous to a certain extent, and it should be straig=
ht up
disallowed with PRESERVE, but I don't like the idea of taking a hard depend=
ency
on src being NULL.

> I thought there was some agreement that mmap() be the 'blessed'
> approach for initializing memory with in-place conversion to help
> untangle some of these paths, so it made sense to enforce that in
> kvm_gmem_populate() to make it 'official', but with Sean's suggested
> rework I suppose we could support both approaches.

Ya, my preference would be to not rely on subtly making two paths mutually
exclusive in order to avoid deadlock, especially when there are ABI implica=
tions.

I'm not dead set against it, e.g. if for some reason we just absolutely nee=
d to
disallow a non-NULL src for the that case, but hopefully we can avoid that.

