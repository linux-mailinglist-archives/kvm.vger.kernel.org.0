Return-Path: <kvm+bounces-40225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F313DA54550
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 09:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26DC0169ACB
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 08:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C7B1FF7CC;
	Thu,  6 Mar 2025 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COQKXmaZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5829C19D891
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 08:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741250961; cv=none; b=SB53Q6Q2lwGOee+en0tUPaK32CrPFrbH5mx9VJVbjqxbrNFIBZI0cd7s9dpdffmFmYyNGsYdnSn2jiGQX8u0TVGbwWvMSzwW0wQssUYgSps+xeCllea+F75WiPy46rNVT2hJRnwBRArrh/SrokMFux40x+y0Udoj4pdSG0Pu4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741250961; c=relaxed/simple;
	bh=IHii5Uw4pnSE4gvuurjPHp1mIyurMUIqZEGJnfAAYeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUKf7lbenPNljvgLC5mbY5a+aoG/W9Sb/Z7w/OS/QtdtzRWDHihKQhg3kRt1Xd/G23/K7s8E0LIVVHDhG+k1dH+Ac14lyWQ69vLkJb+Ij0JpxeK58Fu6EWQsUyH0uXggOmXqfJCqRHCOr5Y+N8B9/YFO4UmxWxfLSLxm/TM8YEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COQKXmaZ; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4750a85a0ddso146551cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 00:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741250959; x=1741855759; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YaJ5imc2Ngyr8E9KKVZNLqQ9tGVAPYT9wXbjUhwizE8=;
        b=COQKXmaZBsLQSe0iqKknfx8pfZ+40mzwCoggyK4LQjo/4L5xLxE5ZN3wwGkQvtsuff
         nmGQMKFtWW2TkTulXFK2JUkp2W4ylXVRK0qgObVbbB1Axwb0DLCJMC6OcMXh6bldAtuj
         dlyapg04lxoSIbqsl3l/2sTN5FcXHAlCCn679jiMr2wt00iGO3bjyQ76IZMYE0mnxiK7
         /UlQU2ro9uJfpP80F7hhECB0znr8/dCHdNWMO00rmFZ4jID8bMaO1YavwTpcdc49zP4l
         wPvjMBEqRdkT/L8rHJugPiTTFcP2mDzEm2Tq1amzgg0ml+KNRBIsRxpBXq+z4MBMP8Fo
         HBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741250959; x=1741855759;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YaJ5imc2Ngyr8E9KKVZNLqQ9tGVAPYT9wXbjUhwizE8=;
        b=T/reY+qq4Cwsbqn6zpSqipbJ23DkoarXDq/MX8pE/rQbjLmJSUgW9ZPqc6zw4WjP2W
         Nfp7Ot9VqokEZJPCHYlfxzPlk9tWT48oIt8LEyudyjkRClFUA/d+ZPHByQ2kR/PNfGLY
         o3ShOxDbBiM4/YQy98pIabk1QOPHDRod06MJhCS85DUZ7jellM4s4cPATLjV7dKG/sFN
         OZOpS43o/eQD0flM5yZP6DcIxJCFdNK81Kq5AxSOfRl4YUxDHyCB2k3k4rwiCfGeipmS
         B2QWeri8P2Ehz11nbtUqqagBjdtsMVUtcBdYRfbtIJ/qZwrYvNmE1gBoYam7ObsqCJCa
         pzww==
X-Gm-Message-State: AOJu0Yx+/Qv5OrsySDDeCJVBcfuqKsubrvQR/+lQfuc3jmFoKct0sF6w
	+DLz5OvsdNtmmoGecRR/+lMsLvNCLQfAl2sWVG8bRywFBjjnPmMry8pv9T2D1ScOJzAAPIXhbVq
	gGhKiIyRDeiMrTeS3ysqMP4kZGCxWInUQZwyZ
X-Gm-Gg: ASbGnct/krf4Giy0kUDmSJXFG5vnUansjYZbm2KVhF5OCPpDccGBq1RgTyztSeUx7wo
	ZHPNaKz1/HqkGkf+UOmONj1DwXd0ADLX+2CK0kVvX7G5fUnLpnWIKjCp6oTFQjQ290bGRCc38LX
	7uZXL2l0Ze1tQCmKSzaIt7hWuG
X-Google-Smtp-Source: AGHT+IFVQ5+MnT7k0zC/yN7YRHNio4wgp4bB/nSw7B4UORXArvo/ohKiKOdEwTR0GaYylL+N9lYiPAGglmshKYyXfr0=
X-Received: by 2002:a05:622a:11d6:b0:474:b32b:8387 with SMTP id
 d75a77b69052e-4751b019d48mr3161521cf.4.1741250958810; Thu, 06 Mar 2025
 00:49:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-4-tabba@google.com> <diqzr03bt4ay.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzr03bt4ay.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Mar 2025 08:48:41 +0000
X-Gm-Features: AQ5f1JqHOa32gTN9SxcdVcOqUtRaTjP8QpQ0nQ6Rs8sRUeR-mnCOcOtr8-vKQjM
Message-ID: <CA+EHjTzOGuCvN91WS76Bx1dBOQNxv+Tqz=gTc85bVvjCrF0hyA@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Thu, 6 Mar 2025 at 00:02, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > <snip>
> >
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             switch (PTR_ERR(folio)) {
> > +             case -EAGAIN:
> > +                     ret = VM_FAULT_RETRY;
> > +                     break;
> > +             case -ENOMEM:
> > +                     ret = VM_FAULT_OOM;
> > +                     break;
> > +             default:
> > +                     ret = VM_FAULT_SIGBUS;
> > +                     break;
> > +             }
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
> > +     if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /*
> > +      * Only private folios are marked as "guestmem" so far, and we never
> > +      * expect private folios at this point.
> > +      */
>
> I think this is not quite accurate.
>
> Based on my understanding and kvm_gmem_handle_folio_put() in this other
> patch [1], only pages *in transition* from shared to private state are
> marked "guestmem", although it is true that no private folios or folios
> marked guestmem are expected here.

Technically, pages in transition are private as far as the host is
concerned. This doesn't say that _all_ private pages are marked as
guestmem. It says that only private pages are marked as guestmem. It
could be private and _not_ be marked as guestmem :)

I probably should rephrase something along the lines of, "no shared
folios would be marked as guestmem". How does that sound?

Thanks,
/fuad

> > +     if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* No support for huge pages. */
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +out_filemap:
> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +     return ret;
> > +}
> >
> > <snip>
>
> [1] https://lore.kernel.org/all/20250117163001.2326672-7-tabba@google.com/

