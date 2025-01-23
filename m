Return-Path: <kvm+bounces-36332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DD4A1A139
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 10:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB9293A8178
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 09:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDA620D519;
	Thu, 23 Jan 2025 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H6U4r2r5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642D20D4F4
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 09:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737625882; cv=none; b=kO427bdUpQDllWUF+nph+5sUeISfVsG2LwsNbw9KTXngNtLMBN/QOPxet51jJr7pvXgQ4VdxKCA4iQ3G8C+r0mQIyj7isEE8O3LIVuzUlSnmqNqI7jDd1sZPmq5nE2fAnBhMvCX1jYRwMRj1EBNdJOP0xw9nUq4vlFmLEGEvpik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737625882; c=relaxed/simple;
	bh=5vzqKP2X7TnSwJyvizFNr4OaD4j2CtDEN6uPpqu2oUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U2K5mhjcc58NRRIcGO9zufIkXEPj8XPIyAAcO8GBIcikEObWWaY1MljYAjPF2ui+5Rb5ASgLwk12slRnrvQLYF48EdC/xLv7vJIQA77966o3dreg608d5tR+qmEs0qdGrezTarzIJa3rirnuABLnCpZpQ6pYxwdtyM+m1Rb9yv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H6U4r2r5; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4678c9310afso154591cf.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 01:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737625879; x=1738230679; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yviuU7vMVVFib1+GlJJHR7UtIpXdMrw1DtytEsRq4SU=;
        b=H6U4r2r5g0AAGCQHHTxTrngXDHdJCaSVoS6pXucVXwDMJyAU3GiwWmGA+cykWEKy1S
         7gNRaDoMHCQNAVGHAm8btMH987ZrxwIKr7SoTwb8cIm7Ac+FKNm+Lu5+YIo0fIW8vUrD
         QFqzTl9RAFWaeTzHeLXZkEIsyDWbkal1TR0m+xnp5F9X/xFvGUaHHN3pxkIsQoF4gWvH
         Db4j4EuyvhE+qonr8Xr3eQ/aGsEnpAvf6QzJAn22wMVWCtXIP1t3uWeL+4z7zGwU+kj6
         7dbhq4NBZA0ydFqM6do63hPcZUveca7j2PVRfBNsfFVRIt839d+Je72S9N6D48Xbu/ge
         eepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737625879; x=1738230679;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yviuU7vMVVFib1+GlJJHR7UtIpXdMrw1DtytEsRq4SU=;
        b=omtqPhrxH9yD4LEJOpq3b7wXcYtpp6iSt4+j6j6fPazmDfeu6M3l2UNXr/8iRtdy3d
         JW5MH3ZDS/X9g3jKLMt9Bkh6qMMSQctY1ViPezaRNr87jiYqxIaVgd7A0gZ6JOSRV6xT
         ynAXvZ+z+aKLgugHcfVPxPXW1VjtgLa37Zjf0SRWQ2H1CX0rNOEMMyhommqWU1hcIOWU
         fzezQtNqTCPWICEcdlLhQoBv1Sst/rbLCEPwzMG+TdfgyCN3MAyCrm5Vh3ekJvaVXIAR
         u6CTOYeXVuxF5D5QnIqaTGGX7HbXWtSXCUL1KWjaVMF3Z9Pb3X8meBeC1HZESmTMkDb3
         nJlg==
X-Gm-Message-State: AOJu0YwefvVsadcy5AkYChGvFJeLCK96OI/69erNBB5ZD363d1F6zj65
	LDJwJ61tZ1FMoO6hICIUSaqrEXhLKUWEBUNagx1Pfk1nw47uodwBpId0k/DBF32FDD8MESgCeph
	omfgiP5VU5dY/zsDu0wcymgMQIueOFS7HwRel
X-Gm-Gg: ASbGncvpovjkC/WLe2q0zEWbnuz0xmLCqeThG/crg1CLHYSqIpFKXYmEIT/bUtnXgck
	HSCArlGd1w9rc5QbKIWxCsD36blCAWFDujZ1v3QCBWRintihEDLyLWgTtqEsx9xh+U+CbcR5Jqw
	zt2RQuNRDq+iYUyg==
X-Google-Smtp-Source: AGHT+IGGx6fhGAGnD3JpCHn1/8lIrUk1LZpCG+05sYeACx+iitK5ZlJ3LsWzOvvIi0xtTpfhCDHLRJeFYIUXCTXHqJY=
X-Received: by 2002:ac8:5887:0:b0:46c:7d66:557f with SMTP id
 d75a77b69052e-46e5c0f91b5mr3437421cf.8.1737625879389; Thu, 23 Jan 2025
 01:51:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-7-tabba@google.com> <diqzikq6sdda.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzikq6sdda.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 09:50:43 +0000
X-Gm-Features: AWEUYZnBbulFTZGR1qtloKSczYkeBb6FihtEZxc8a8TdA87tJk3UxG7x1ydvWtE
Message-ID: <CA+EHjTzbBNRsQqeSh5L98Rx3QUwh9pUrpg-zkOd7fvnUbJZ-Kw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jan 2025 at 22:16, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> Hey Fuad, I'm still working on verifying all this but for now this is
> one issue. I think this can be fixed by checking if the folio->mapping
> is NULL. If it's NULL, then the folio has been disassociated from the
> inode, and during the dissociation (removal from filemap), the
> mappability can also either
>
> 1. Be unset so that the default mappability can be set up based on
>    GUEST_MEMFD_FLAG_INIT_MAPPABLE, or
> 2. Be directly restored based on GUEST_MEMFD_FLAG_INIT_MAPPABLE

Thanks for pointing this out. I hadn't considered this case. I'll fix
in the respin.

> > <snip>
> >
> > +
> > +/*
> > + * Callback function for __folio_put(), i.e., called when all references by the
> > + * host to the folio have been dropped. This allows gmem to transition the state
> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
> > + * transitioning its state to private, since the host cannot attempt to access
> > + * it anymore.
> > + */
> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     struct xarray *mappable_offsets;
> > +     struct inode *inode;
> > +     pgoff_t index;
> > +     void *xval;
> > +
> > +     inode = folio->mapping->host;
>
> IIUC this will be a NULL pointer dereference if the folio had been
> removed from the filemap, either through truncation or if the
> guest_memfd file got closed.

Ack.

> > +     index = folio->index;
>
> And if removed from the filemap folio->index is probably invalid.

Ack and thanks again,
/fuad

> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     __kvm_gmem_restore_pending_folio(folio);
> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +}
> > +
> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> >  {
> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;

