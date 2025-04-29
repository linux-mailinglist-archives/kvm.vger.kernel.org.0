Return-Path: <kvm+bounces-44778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2EEAA0DBB
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F18631A88054
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E7B2D1F66;
	Tue, 29 Apr 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PL9DJazo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4793B19B3CB
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745934433; cv=none; b=bFVG7JNejPUQZVuW/1pzHbyM1PvJCq7MYK1SJxJHOV+Qk2wiKngTybyy87HhOVO6aDSi/7nJtq5kxpF5Rbmk7oe2GRo/nU39yd6KbRK5D5ZdH9+m0fwv/MRzKQLzzyWFYBCwBzFUJvUcHe02svM2L+ZPPdC1RzqA/xAJYD3bfZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745934433; c=relaxed/simple;
	bh=3TCRetitTdM6SSQpsZgJ3TdWcPHGJs/fr3ZwFvLIjFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5srhURrKrePU1i3nAGpA1SwFZpzC8jYTMh40RSZ+mWF3L7rNk/OtO0haod2IHcIj8UeWRBDx8wgIjqg+U+m6NZb0sgmbY0PJwrvkZT+EMgJqvCK4hKxqRzcPciltme23ck0rURnxMWzEXp/M8/UjClQ46PSUrnCC+zrdJw9Eio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PL9DJazo; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2264c9d0295so129785ad.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745934431; x=1746539231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fA3w93Erda+XJOmk0sPyV8UgKCS7MreAykhsx06cpPE=;
        b=PL9DJazoZh4xuZPPJT7/smED/Mk5jDhofOCjsqL3otSA+pHAWXgW0xFWEJl4rBR/WV
         sDOemClXrlF5y19gnR0KaPJjCCj7Ivfr2Wi3m4u5EKPj8PFklR9s7rTa2nRibFpAZ1qQ
         UgZPAVSTP20BePW602wSaZDNskgylysCALMVmwWm0zCZtpKYHO45ovWvL5Me1KAoTmpR
         tRj/KTdhapbMc4GgGzSooVjLbcbKrlkaIzxCoJ8+k+G1vmNEwQPlNXhZUoPSzoajum0J
         8vIcJJrDsjnRHwopKnuq9a9c2AbQr/csfW1m9gKVfHpgXtaLL9QTZ/HCEQkrcA8426AF
         ArRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745934431; x=1746539231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fA3w93Erda+XJOmk0sPyV8UgKCS7MreAykhsx06cpPE=;
        b=Zaez8Vxx64QkJaH+bass0y2cRvgrV75h3fRoxBFsHGzJvIZJk4gU46qtzLWjYoynht
         LlVTtlpa4H0R2nCKi6XD+ug1J45UU6M3XmC+op28C78NU4DmYogltYBwWA9jR+mFeqGO
         OErP2ZTHh9BXJPPAapGGsax4B3KYmwD8M4nvO5bNxVEA6fXpXAt299VTFoOU01ZY2sgX
         cLizt/E/f16cWM03UXRqBDQUvvLq3VEW5DKz9Wtb4bIY0y4yTBbpMqrbKRhW4WifCOkk
         6teidCInPH8WiEK1mCxJ5obnSBKumnx6KZC2IGwXgbgq7EiJH1BtG51QCDGcbLWvmSfd
         onbA==
X-Forwarded-Encrypted: i=1; AJvYcCVHz6NSC1KiLuDwarvdg9J4GQ0+UCvCfXZPqSmiPZqrcpHDDNtpazTNWRrN2WEngrtXseY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPJtg7JmFW/j3MvLMMQ9QM6DpgohMbPldrXwdL3AS065Lg36pv
	C//7ghUjkpNRxtx7y+azFYrNm1SlOC6sfvFWHyNKNHgPQamiMhGNYLlS/FI5hXSdEedVL1a3j3q
	vTyFINPh5RwZWzQKt+tkGA809ZAs7W507mxD1
X-Gm-Gg: ASbGnct/RD7ttFgXvnOgDDGZ9EUDENW5dfnI6ZNcHbPgzDAqYPbhLtVL4HoRvaADj9B
	A37BNARdjJWxcuyjeS2c9jvCoyW/w/mbgYrqO/CHVDFW9tQ/Fm/NBDTd3gB3Z40j1Z4H4+/Dx4j
	fJQEi7Io74nMyZEERDpKVFCV/44VEgV1Feb1g4KaIqIs4NTz5+nrgZcLA=
X-Google-Smtp-Source: AGHT+IHiMZNgIIdFnVgiIRJi0fXdR+Bv4W8fc74XvKYOI8OTbqfcUV1Y9n5UrnWf3AkgyV8Qy8gzTEq4mN0fQJbvYRI=
X-Received: by 2002:a17:902:d490:b0:220:c905:689f with SMTP id
 d9443c01a7336-22de860f65amr2515515ad.25.1745934431074; Tue, 29 Apr 2025
 06:47:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030033.32635-1-yan.y.zhao@intel.com> <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com> <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
In-Reply-To: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 29 Apr 2025 06:46:59 -0700
X-Gm-Features: ATxdqUEkaLaVII63hnsleMg67sq1kpfI2Fv8JpVpN0768laW2G7meeI9SsffK_s
Message-ID: <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 5:52=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Mon, Apr 28, 2025 at 05:17:16PM -0700, Vishal Annapurve wrote:
> > On Wed, Apr 23, 2025 at 8:07=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > Increase folio ref count before mapping a private page, and decrease
> > > folio ref count after a mapping failure or successfully removing a pr=
ivate
> > > page.
> > >
> > > The folio ref count to inc/dec corresponds to the mapping/unmapping l=
evel,
> > > ensuring the folio ref count remains balanced after entry splitting o=
r
> > > merging.
> > >
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/tdx.c | 19 ++++++++++---------
> > >  1 file changed, 10 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 355b21fc169f..e23dce59fc72 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -1501,9 +1501,9 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hp=
a_t root_hpa, int pgd_level)
> > >         td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
> > >  }
> > >
> > > -static void tdx_unpin(struct kvm *kvm, struct page *page)
> > > +static void tdx_unpin(struct kvm *kvm, struct page *page, int level)
> > >  {
> > > -       put_page(page);
> > > +       folio_put_refs(page_folio(page), KVM_PAGES_PER_HPAGE(level));
> > >  }
> > >
> > >  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > > @@ -1517,13 +1517,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, =
gfn_t gfn,
> > >
> > >         err =3D tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, =
&entry, &level_state);
> > >         if (unlikely(tdx_operand_busy(err))) {
> > > -               tdx_unpin(kvm, page);
> > > +               tdx_unpin(kvm, page, level);
> > >                 return -EBUSY;
> > >         }
> > >
> > >         if (KVM_BUG_ON(err, kvm)) {
> > >                 pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_st=
ate);
> > > -               tdx_unpin(kvm, page);
> > > +               tdx_unpin(kvm, page, level);
> > >                 return -EIO;
> > >         }
> > >
> > > @@ -1570,10 +1570,11 @@ int tdx_sept_set_private_spte(struct kvm *kvm=
, gfn_t gfn,
> > >          * a_ops->migrate_folio (yet), no callback is triggered for K=
VM on page
> > >          * migration.  Until guest_memfd supports page migration, pre=
vent page
> > >          * migration.
> > > -        * TODO: Once guest_memfd introduces callback on page migrati=
on,
> > > -        * implement it and remove get_page/put_page().
> > > +        * TODO: To support in-place-conversion in gmem in futre, rem=
ove
> > > +        * folio_ref_add()/folio_put_refs().
> >
> > With necessary infrastructure in guest_memfd [1] to prevent page
> > migration, is it necessary to acquire extra folio refcounts? If not,
> > why not just cleanup this logic now?
> Though the old comment says acquiring the lock is for page migration, the=
 other
> reason is to prevent the folio from being returned to the OS until it has=
 been
> successfully removed from TDX.
>
> If there's an error during the removal or reclaiming of a folio from TDX,=
 such
> as a failure in tdh_mem_page_remove()/tdh_phymem_page_wbinvd_hkid() or
> tdh_phymem_page_reclaim(), it is important to hold the page refcount with=
in TDX.
>
> So, we plan to remove folio_ref_add()/folio_put_refs() in future, only in=
voking
> folio_ref_add() in the event of a removal failure.

In my opinion, the above scheme can be deployed with this series
itself. guest_memfd will not take away memory from TDX VMs without an
invalidation. folio_ref_add() will not work for memory not backed by
page structs, but that problem can be solved in future possibly by
notifying guest_memfd of certain ranges being in use even after
invalidation completes.


>
> > [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/virt/kvm/guest=
_memfd.c?h=3Dkvm-coco-queue#n441
> >
> > > Only increase the folio ref count
> > > +        * when there're errors during removing private pages.
> > >          */
> > > -       get_page(page);
> > > +       folio_ref_add(page_folio(page), KVM_PAGES_PER_HPAGE(level));
> > >
> > >         /*
> > >          * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matc=
hing
> > > @@ -1647,7 +1648,7 @@ static int tdx_sept_drop_private_spte(struct kv=
m *kvm, gfn_t gfn,
> > >                 return -EIO;
> > >
> > >         tdx_clear_page(page, level);
> > > -       tdx_unpin(kvm, page);
> > > +       tdx_unpin(kvm, page, level);
> > >         return 0;
> > >  }
> > >
> > > @@ -1727,7 +1728,7 @@ static int tdx_sept_zap_private_spte(struct kvm=
 *kvm, gfn_t gfn,
> > >         if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, le=
vel) &&
> > >             !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))=
 {
> > >                 atomic64_dec(&kvm_tdx->nr_premapped);
> > > -               tdx_unpin(kvm, page);
> > > +               tdx_unpin(kvm, page, level);
> > >                 return 0;
> > >         }
> > >
> > > --
> > > 2.43.2
> > >

