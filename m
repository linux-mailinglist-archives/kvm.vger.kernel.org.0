Return-Path: <kvm+bounces-66909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A41A1CEC807
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 20:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 05020300103C
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 19:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDCE30BF69;
	Wed, 31 Dec 2025 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZnIgGory"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897D2FFDCA
	for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767209861; cv=pass; b=WfLYt82Fqti98X7ODB7ZGr5wMf/4nQTfE+1P6RVc1j/G/M9fuRr9Zvl+qbiScagXMQreBX4OQdP5FiUrruv1RxjNXuFZxEMHSYI0L91lwQ+5uYJn3anCW9aCQD84STAtnVWPJZFC9PQFBQLfd4arNghMQR8pbuATmmdmiLrOZ2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767209861; c=relaxed/simple;
	bh=NoEyPjCl3uokcLkbrqWgWznAyHxdTbaevFvq0x10ziY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7TG3MSjdC366jUBd9lgTxjoY0PplSHg8Hvpagy23RplYlwgfwVKCQ3IHkD95ONvVfZnDX1zPcVuulIDkD7EO8xxx9iyvg/vEaBx0BpM0wY0DOD9ozWkA/qW3iN+MZBLy17W6NzivQ1sCdDyQgMKkQaqFcLdU3kJ8J7JOEFTcWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZnIgGory; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0d06cfa93so139195ad.1
        for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 11:37:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767209859; cv=none;
        d=google.com; s=arc-20240605;
        b=S9NqyN2qvoWBKls7tInMUFa8XRJzqPzwTH24e9qIcdpUgPiC9yhPxLmJA3Bc6kTYLF
         5H3KxrgtdeDAXTi0VbISyPjGVU5CylujjNuGz/TgmVoxy+iXaDrS95PF26BQj+OeNQqY
         BNkm1RfPVB7o69nCQP7Xw9FpgLpZXEEetLKUi5IEFmnF3hd8gn//fGCYMG/7bwtcurs8
         f021cJ5wlGa9zkqjbha1DJADjr+11FOIgWP4W+8+NwrASjjmUNJBHcYl2DtEOsPUmIj+
         cocRS1cIoQeD1RYoo7ShHE5F4QudkB28osTdTacyZLrlCp1ag+KcxWjK3ZX1KhT/1Rpj
         oS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysMKL49heLlm7Vrxnd0cVhWtj8fKSAi5ryLLfx/8riA=;
        fh=DjvwkvV6cZWATyAbvtizOfStY6X1m/2PAVX7a49c1bY=;
        b=OUIXt/nNYUC1Brz5DcsNnoQWWsKDoRyJXBuXUeBMG2st2mLJ7HJ7dMPMHhEbFR4frA
         Yw9+m//qVBSC/mRGeEbVZok1p5yqH0nbNuRsSn7YcI9CcRpG9Dzs5kZ/a5AanJCWdI1j
         3MEG8wf9qATLBLnMZ3njU0f+9jkc6zl/YqnbNXN3JUcl2aXJhTiHECJ0pBy5zT/2g+1D
         VM1yEKXoIcX1KhxBSsPAi1J9i5xG5z9rUV0o0pWjIF34c1U1lzLa32Z1jYMX0dnMmpkx
         zJQ/fZEkN6y5BmNNQEFB90MuhrFndkJZjWFwgqDUXS92giLoonxDHG++e4Br8OTlQDdE
         RenQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767209859; x=1767814659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysMKL49heLlm7Vrxnd0cVhWtj8fKSAi5ryLLfx/8riA=;
        b=ZnIgGory6acqgzmEVxRTgxJaQOcZE47rLsRwPC/gqpJ++KtkJ4xzfIg7tNsVAlLl4n
         E1ADAf/2A26ilNOmY/oc/ds19Yo8ltdIBuQ1Lurt5WQNUdsbGqcBDECLna5/eH841wkk
         2NJR35IB6UI8d76xIhpG+8juxyO0lQ8Oei6MltlkykeCMrGVez3uWhezdssYZUisEPMT
         66ITops9KUw8QR9kEyipijSCz8kmxwh6Nv+Gp2xIKoRjNVDRBjiFxIfxigH+B2mZI8N4
         tGmOykGvcTKu7l7susg41ks+lxrPjPkyzAZI+N8wuxwFi0JrURkxL3qGiUw1nCca0+Mr
         QZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767209859; x=1767814659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ysMKL49heLlm7Vrxnd0cVhWtj8fKSAi5ryLLfx/8riA=;
        b=uRMs8LD3WVEYgF2DmIjCx/ipp3hUlCSbAuPRXRMzTn+LiZ60Yv0WpmWddgYTpo5sve
         /UMOeEDrfS2XyqBRDmg5hXMIcduk87uug8RzqzQ+b+hnOGR28zs0JXb1rGNjvVtqKKXs
         qOMYqjDKGkZrVg90x6NW6LbRql7qaHPH6zZFSneR6RGMwt+21YXKlgujZIYRh+5l1w/L
         Uu2AIqM+AQ0JK5TRN1tMcMip1aN5pRL+Y77wK+o4BE4LdD24ymxu7LxdU5n9pc5+rOHe
         yLmingUzR25K1d8uksl13iVD5XBphtay79WxNSlKVLsu1IWywExi+LjqDeF/FhvOKTgl
         uGvw==
X-Forwarded-Encrypted: i=1; AJvYcCXRflAwosfrWYIamzafPrNAzurhaFnCyIikvHPQ8o+yvmNmZ1d6iI81qsrgBX6w33E1gXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrTritW6uJ6Ad4JHYYdMhZC21Ic8OkX9RymaepVyqkynxsB8Sy
	MggxXFkn99+gMoAVo62QJBFnCS4PXO5x9SxdH8F4YFOJj66r2F1dA5BR9gBTCFqd8ibegpNai7U
	jdXBV85XslIQgNqOBnd+4CQqsXpMIQsJqGHkqpVXQ
X-Gm-Gg: AY/fxX6GXind0wEzx+zvGr62B4eUHmih8NkcUevU1YfNvzCEO+DBK/e8jtZ/p3wiu4Z
	qABXjhLmxTw9G65EY+qlj8qNPHZZwVm51e8gf8ge8jHjasBK61hAvT090gQQ3VI6S/rkisiR7gO
	NZB5phMTFzu7ueGIt7o/NVIbIJMBGm/YpfsBh1bH54WvsG72WgY5UHFVdLdr4KuJzshNmDUr7p5
	vqILHKZ3na6TCPNusyzcoJ6KeASEKU9dOtFUeUwoECYs/eyuXv6gvFMn+8jlbDwuxy0Nclitn0h
	MGzIgFvEFH9novxNeSLQx64obsWXpmDSHxSTRw==
X-Google-Smtp-Source: AGHT+IHn7CyU0F9kBcMuZs7rlsuTMcoffQmKiap7eZo4/tVqo1HPI8RVYyBZ6zv0IqOcC0Vht0J1LHUtXeeEfa2MhVI=
X-Received: by 2002:a05:7022:401:b0:119:e56b:c1dc with SMTP id
 a92af1059eb24-121c7016461mr104832c88.7.1767209858724; Wed, 31 Dec 2025
 11:37:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094202.4481-1-yan.y.zhao@intel.com>
 <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
 <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com> <CAGtprH9foQx=XLXXMqYnga27jWjCSkqj5QHVnAM_Akv7CLNmbw@mail.gmail.com>
 <aTjS/c8c5wNZcSgO@yzhao56-desk.sh.intel.com>
In-Reply-To: <aTjS/c8c5wNZcSgO@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 31 Dec 2025 11:37:26 -0800
X-Gm-Features: AQt7F2qdrRJF1lBeO8xpQbS_BSjY-NPC16qeZ02XXo8xWs4K3bnN2yxlTbUOYQw
Message-ID: <CAGtprH9vdpAGDNtzje=7faHBQc9qTSF2fUEGcbCkfJehFuP-rw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid()
 to invalidate huge pages
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

On Tue, Dec 9, 2025 at 5:57=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Dec 09, 2025 at 05:30:54PM -0800, Vishal Annapurve wrote:
> > On Tue, Dec 9, 2025 at 5:20=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > On Tue, Dec 09, 2025 at 05:14:22PM -0800, Vishal Annapurve wrote:
> > > > On Thu, Aug 7, 2025 at 2:42=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.c=
om> wrote:
> > > > >
> > > > > index 0a2b183899d8..8eaf8431c5f1 100644
> > > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > > @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struc=
t kvm *kvm, gfn_t gfn,
> > > > >  {
> > > > >         int tdx_level =3D pg_level_to_tdx_sept_level(level);
> > > > >         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> > > > > +       struct folio *folio =3D page_folio(page);
> > > > >         gpa_t gpa =3D gfn_to_gpa(gfn);
> > > > >         u64 err, entry, level_state;
> > > > >
> > > > > @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struc=
t kvm *kvm, gfn_t gfn,
> > > > >                 return -EIO;
> > > > >         }
> > > > >
> > > > > -       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, p=
age);
> > > > > -
> > > > > +       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, f=
olio,
> > > > > +                                         folio_page_idx(folio, p=
age),
> > > > > +                                         KVM_PAGES_PER_HPAGE(lev=
el));
> > > >
> > > > This code seems to assume that folio_order() always matches the lev=
el
> > > > at which it is mapped in the EPT entries.
> > > I don't think so.
> > > Please check the implemenation of tdh_phymem_page_wbinvd_hkid() [1].
> > > Only npages=3DKVM_PAGES_PER_HPAGE(level) will be invalidated, while n=
pages
> > > <=3D folio_nr_pages(folio).
> >
> > Is the gfn passed to tdx_sept_drop_private_spte() always huge page
> > aligned if mapping is at huge page granularity?
> Yes.
> The GFN passed to tdx_sept_set_private_spte() is huge page aligned in
> kvm_tdp_mmu_map(). SEAMCALL TDH_MEM_PAGE_AUG will also fail otherwise.
> The GFN passed to tdx_sept_remove_private_spte() comes from the same mapp=
ing
> entry in the mirror EPT.
>
> > If gfn/pfn is not aligned then when folio is split to 4K, page_folio()
> > will return the same page and folio_order and folio_page_idx() will be
> > zero. This can cause tdh_phymem_page_wbinvd_hkid() to return failure.
> >
> > If the expectation is that page_folio() will always point to a head
> > page for given hugepage granularity mapping then that logic will not
> > work correctly IMO.
> The current logic is that:
> 1. tdh_mem_page_aug() maps physical memory starting from the page at "sta=
rt_idx"
>    within a "folio" and spanning "npages" contiguous PFNs.
>    (npages corresponds to the mapping level KVM_PAGES_PER_HPAGE(level)).
>    e.g. it can map at level 2MB, starting from the 4MB offset in a folio =
of
>    order 1GB.
>
> 2. if split occurs, the huge 2MB mapping will be split into 4KB ones, whi=
le the
>    underlying folio remains 1GB.

Private to shared conversion flow discussed so far [1][2][3]:
1) Preallocate maple tree entries needed for conversion
2) Split filemap range being converted to 4K pages
3) Mark KVM MMU invalidation begin for the huge page aligned range
4) Zap KVM MMU entries for the converted range
5) Update maple tree entries to carry final attributes
6) Mark KVM MMU invalidation end for huge page aligned range

Possible addition of splitting cross boundary leafs with the above flow:
1) Preallocate maple tree entries needed for conversion
2) Split filemap range being converted to 4K pages
3) Mark KVM MMU invalidation begin for the huge page aligned range
4) Split KVM MMU private boundary leafs for converted range
5) Zap KVM MMU entries for the converted range
6) Update maple tree entries to carry final attributes
7) Mark KVM MMU invalidation end for huge page aligned range

Note that in both the above flows KVM MMU entries will get zapped
after folio is split to 4K i.e. when tdx_sept_remove_private_spte()
happens folio will be split but the EPT entry level will still be 2M
and the assumption of EPT entries always being subset of folios will
not hold true.

I think things might be simplified if KVM TDX stack always operates on
the pages without assuming ranges being covered by "folios".

[1] https://lore.kernel.org/kvm/aN8P87AXlxlEDdpP@google.com/
[2] https://lore.kernel.org/kvm/diqzzf8oazh4.fsf@google.com/
[3] https://github.com/googleprodkernel/linux-cc/blob/9ee2bd65cc9b63c871f8f=
49d217a7a70576a942d/virt/kvm/guest_memfd.c#L894

>    e.g. now the 0th 4KB mapping after split points to the 4MB offset in t=
he
>    1GB folio, and the 1st 4KB mapping points to the 4MB+4KB offset...
>    The mapping level after split is 4KB.
>
> 3. tdx_sept_remove_private_spte() invokes tdh_mem_page_remove() and
>    tdh_phymem_page_wbinvd_hkid().
>    -The GFN is 2MB aligned and level is 2MB if split does not occur or
>    -The GFN is 4KB aligned and level is 4KB if split has occurred.
>    While the underlying folio remains 1GB, the folio_page_idx(folio, page=
)
>    specifies the offset in the folio, and the npages corresponding to
>    the mapping level is <=3D folio_nr_pages(folio).
>
>
> > > [1] https://lore.kernel.org/all/20250807094202.4481-1-yan.y.zhao@inte=
l.com/
> > >
> > > > IIUC guest_memfd can decide
> > > > to split folios to 4K for the complete huge folio before zapping th=
e
> > > > hugepage EPT mappings. I think it's better to just round the pfn to
> > > > the hugepage address based on the level they were mapped at instead=
 of
> > > > relying on the folio order.

