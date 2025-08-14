Return-Path: <kvm+bounces-54690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1776B26EEC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 20:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA34AA4248
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D28233733;
	Thu, 14 Aug 2025 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RkYsB+6h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F3222D7B6
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196209; cv=none; b=ijQGyga4TCaiWYfIyh3LbPjkz98TC3YqSMOi6i/llAosvfciXK99Ek9bfPsfQs6+iOJOiXwqNETlpcwVNEVKJ0faBW1XAD1mMsXkksMQszNSf47zocPFHniT6RjKbUjoWPlecp5qwRs2tIMIK7aezjHakeIelF58LtB9D9QNRKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196209; c=relaxed/simple;
	bh=A4c0iTOf2R71rU6WSqW1yP7mOGni3aEu/5lN6bh82ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PfDrvdAxV/uzetTveVXSNYj7RZ5jGJl/aYS8hxTh1bVUPh135oZQtj6d4SZ3bISsuev2awfv/QSzcSXKUP3DG0uNe8WtnCU9ECPjNZdBNJYGXibyuRCwK1Xvd0kHanBBq+X2jfaIRwncDXDWF+52m6UyROZGwewI3y8xG7LCoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RkYsB+6h; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-242d1e9c6b4so33935ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 11:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755196207; x=1755801007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ig/c0W4/BOO1c1TnermMCysZ+XWEDUNRpnYsEQ42d4w=;
        b=RkYsB+6hzpQ8MaI6myIK+xqd3t2Ox3QnLZmmYNKK4ZDdZga/2Ib5v2bEhnObqJKom/
         FAc88W4Qd5Kze4dZf/iY8STZnNkMLW/SvYJTj2qgQKNFDP1pPFjr/rAmdytwqDJUb3B2
         4/T70/SbHEWg2lMcOi7ZKKgd89HRUiDxhZOru8tFUjrSHAIJblvJlbU4xmaROliXuNWj
         wtRtI6iBtgaN528SJgQUWCJ17rFnGK6Fs0S0EYP9rzHPb9ZBijgp6LL5IAmy7dW1Z5km
         QVo7mkecdp4skRn1fMzeIVgiakzD3p8NsgUULEbOclfo2LbVTzJiV4XzO8hFWaAprJJP
         dYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755196207; x=1755801007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ig/c0W4/BOO1c1TnermMCysZ+XWEDUNRpnYsEQ42d4w=;
        b=HvOEYh/Ezxa/n/+IjoXoCcdkX8dwZg5H3U7FO82EoIX96M9q+CDt5DJC6tfZQxHtW4
         0EStw8OwnzMCQJxCSAIKw3A2Oxls57nT82gojFv9/3LlNS2dMZDJi6oyiUCrwqQbC5Ai
         VhoNxiAbgpYq0DbQi0XemagpXFaiUk0/Ll4ebfy09mRmpFp78j64mKfDJ85Y1Fpclu3Q
         0d2/WgwK+W+uaq5tYCSjnvh6xS370QmyvT+T39cp5jFCXK4ElzPbd38VemMnQJeyHnWT
         bCbLAEuw3zxxHW8u+wW/Quq1G/5KkR6DlHuBBhWpQHz5/Z0Erx+2ATYAOA172nFhngtr
         b33A==
X-Forwarded-Encrypted: i=1; AJvYcCXvBU5sLs85uvQ5JRqKhEKZs+T9LOMsVFN3LlmdJUi4LtreDW8IMdwhZKZm1j9VF9XQNHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3LuD+dmuomwxhFhuQ/1f0mlZJ8/oSDDQh4UtW1JsY64rIomyK
	6xMOs7RpU8B6qm+1YFfNMOF9ywD3qVg4cBbhbM6aQQTgDLWDWn+dThR7dEO/wibXUWMQu3OT6Cw
	NYwPOtuc2uEIE+Rjj2e9Gzf/3hfWBKdwbri03c1M3
X-Gm-Gg: ASbGncsGqFVQRYr/c2yVRuWo5Q8PQOedK0CGV5wRM5CWvnWv8N86ZQuGFU9M+plvC2m
	QZROxuWFoWbMrb7Toye1cRA/NMiKISFU2nyjG8Qg3pSG2tCqMJ4ua4wVYt1TN5y1jua1NDP6tam
	mYrcv2w3Z7Hzh2Sa7P05iwSjOqXhQ9QSLBBS7PV+H+ANwFWFOiKMIGddhepziVlU3g5SZ78Mapv
	pTFe5udBW4BY437AlPS7Ct5A/Di61D/1h3DfC5eRXjVQPC77Cv7LrcAdUeOTuFGfw==
X-Google-Smtp-Source: AGHT+IEJ3rIt+hm3527BfevwvcRNLE+CbaQKjXaAlRRRLeXWlJYoOK5k1FQMQ32BZFyBpLy5XqDtrS+ugxQllWxJwvU=
X-Received: by 2002:a17:902:d512:b0:240:640a:c564 with SMTP id
 d9443c01a7336-24469cc0686mr251445ad.3.1755196206738; Thu, 14 Aug 2025
 11:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094616.4776-1-yan.y.zhao@intel.com>
 <CAGtprH8a4i-U-4Z6=Bk87FsC2nG+UbTVWB1Sc8oYXMJs7pHUwA@mail.gmail.com>
In-Reply-To: <CAGtprH8a4i-U-4Z6=Bk87FsC2nG+UbTVWB1Sc8oYXMJs7pHUwA@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 14 Aug 2025 11:29:54 -0700
X-Gm-Features: Ac12FXzYb_vWbUpk-pxM17D-jaCI2hnlVjz3bGZCmNK_-ADInzx_yScOkMMIGpI
Message-ID: <CAGtprH8da6iwwG6u6Z2EpGaqFVWWFJD4o3RUvDYmxDQ9qaYm0w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 22/23] KVM: TDX: Handle Dynamic PAMT on page split
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, thomas.lendacky@amd.com, pgonda@google.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 10:31=E2=80=AFPM Vishal Annapurve <vannapurve@googl=
e.com> wrote:
>
> On Thu, Aug 7, 2025 at 2:46=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
> >
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > +static struct page *tdx_alloc_pamt_page_split(void *data)
> > +{
> > +       struct kvm *kvm =3D data;
> > +       void *p;
> > +
> > +       p =3D kvm_mmu_memory_cache_alloc(&kvm->arch.pamt_page_cache);
> > +       return virt_to_page(p);
> > +}
> > +
> >  static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
> > -                                       enum pg_level level, struct pag=
e *page)
> > +                                       enum pg_level level, struct pag=
e *page,
> > +                                       kvm_pfn_t pfn_for_gfn)
> >  {
> >         int tdx_level =3D pg_level_to_tdx_sept_level(level);
> > +       hpa_t hpa =3D pfn_to_hpa(pfn_for_gfn);
> >         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> >         gpa_t gpa =3D gfn_to_gpa(gfn);
> >         u64 err, entry, level_state;
> > +       LIST_HEAD(pamt_pages);
> > +
> > +       tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_split, kvm)=
;
>
> This invocation needs a return value check.
>
> > +       tdx_alloc_pamt_pages(&pamt_pages, tdx_alloc_pamt_page_split, kv=
m);
>
> IIUC tdx_pamt_get() will result in pamt_pages allocation above, so
> this step is not needed.

I missed that one allocation is to cover the EPT page and another is
for HPA ranges backing the GPA mappings. So ignore my rest of the
comments except about the error handling for tdx_pamt_get() and
tdx_alloc_pamt_pages() missing in this patch.

