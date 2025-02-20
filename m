Return-Path: <kvm+bounces-38657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECAEA3D4A7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52B1D16B51E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 09:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD6C1EE7A3;
	Thu, 20 Feb 2025 09:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ug4jVr/A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E281E9B38
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 09:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740043620; cv=none; b=ncAIccevixH7hxyfxpPIkj7mqNXxoFINgX+A+y2MKT34lCb3Bkx7hOb3Ye91+9o98UBsgNVOKO/LlsfEkJ3/s4tqBSvhUYDWSI/pf8D97lFKIkG/yzrLS19caggIrsBDCaOQKQJSNsefJcIC1nx0d6CvxHKkkbfd3UsqbV9oqTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740043620; c=relaxed/simple;
	bh=kUOvrm7ywT6NunS23y63stOK1S527Ajdt060Q4v8QLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RLqxaYuAjzrzCIQhGAMCZHoSUtCQndLp2ILFycUpedvtJ61u3kxoZKUa43D9WHo4HHaoG3dHEUgv71+MnDuCcweJEwjiXebPo+0HOPei5L0xUMg/WBJp3mnxZ0rpo8GMWaPT9NkA9ee382wfB1VRCKwy3Y1pxsmW7H8Zf5YvuRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ug4jVr/A; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-471fbfe8b89so289841cf.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 01:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740043617; x=1740648417; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DnhcIOH335Rs5OhBGYZtd9oahr5TV1ZZB9arTSRJ0/c=;
        b=ug4jVr/AARzIBO4b5TcnAphWVqbU2tooroGHTTetuzjpGirCFTnAw2cLE/3OlvBsD+
         MNdGDZZ8FO+5bzk9qilCsRCya1Ns0x+reXdWCXThvGIvM6qAKfNEmTDSc0ieX5v2DN3B
         +L8+nTD7sEtZnZnfINSJp01lGl3JSjTJqC5mq8+cd5K4eA4T8bfMztMguokNbLeVgFNO
         bxbK5BmWyMsdUynaXB4xW0cMmBFktEExasmnJTIUKxdpGHuVBtlRieCHTpfhcsPEUIvI
         idKnHAIqQKlmzm+s9uDfzcpt3NiHYnRG/8cb0wTnVWetJSY/bubEGr+KTV67YKkPFw9y
         T46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740043617; x=1740648417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DnhcIOH335Rs5OhBGYZtd9oahr5TV1ZZB9arTSRJ0/c=;
        b=GtSpf3Gf3lduT6k20UFVdFjQSW0lDJLpeK21A3wTNLGczklHdUYHdFypi+B3H6hsPb
         ucDBTIzbueimURJzdqyxz05EjkXma6VJaPNRXkqegd4kZf8rQGpdp1eyGuzn+o+wWdKX
         a84B9mKeH5/VAXx/Of2omBUbupr4k9rr9B1wp8rTKVZ6DfP5kTxQNdOFjtcqH6cQuRdG
         bobcRDzhNlQ08eFUPRtxIlK19tbO8QPFENULvJhcmM7NbktjZlMxFV5OB5SiL3MRw1/s
         tlgDJ/0UCV+usPBr767e7Vt1cutstjcvtuEKo8tnkkm2wXZo1QLNpnHxQRtPfc/ofRQL
         3SiA==
X-Gm-Message-State: AOJu0YwOCrJMbRPROwdlayBj7L6XhQvcM9v5jvxuoERcXNPSW6+WGdqt
	EnulN5+AEg9/6HrSUd4qn1WFwudXDj6QOwIt6ejz9VEgjZJO3pmc857HMSXIXzcl5yhwKC15pi2
	0pv4V7R5wH1WESZ1V3SjQmN18yYYUdz00m2rD
X-Gm-Gg: ASbGnct0+n/mZIJysDeTRRv9xGXThDUgZD/8uFKvO2NE/SuHP+ZUU+7CKDT5B2kjy6M
	jdygzsQYa9VHXR7Kyy+m0uwFuOfHMej7q5l0Tybr1jl6CDw5QoJLFSMJMJNG0TGo1P0uRUm4=
X-Google-Smtp-Source: AGHT+IHyDFIVnCUigZ5bTkPpCdEKaSVO4OwYmEPkXXA0PRmebGTdWF4mHE1UGnZ53ZRMMA9fc4Pg5u7vW6FF1gU07aI=
X-Received: by 2002:ac8:5e06:0:b0:46c:78e4:a9cc with SMTP id
 d75a77b69052e-472171339e4mr2235621cf.25.1740043616801; Thu, 20 Feb 2025
 01:26:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-6-tabba@google.com> <diqzzfih8q7r.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzzfih8q7r.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Feb 2025 09:26:20 +0000
X-Gm-Features: AWEUYZkXWRg--vw_yP0RUaHbdTHUxGGOdXbhDT85cTXg1nmxQFtS7oDEzDq2-QI
Message-ID: <CA+EHjTwmbK916i=W7WkDQc+kGGee_rvwUGfhbWiJQRsfB0ZW0w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 05/15] KVM: guest_memfd: Folio mappability states
 and functions that manage their transition
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

Hi Ackerley,

On Wed, 19 Feb 2025 at 23:33, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> This question should not block merging of this series since performance
> can be improved in a separate series:
>
> > <snip>
> >
> > +
> > +/*
> > + * Marks the range [start, end) as mappable by both the host and the guest.
> > + * Usually called when guest shares memory with the host.
> > + */
> > +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     void *xval = xa_mk_value(KVM_GMEM_ALL_MAPPABLE);
> > +     pgoff_t i;
> > +     int r = 0;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     for (i = start; i < end; i++) {
>
> Were any alternative data structures considered, or does anyone have
> suggestions for alternatives? Doing xa_store() in a loop here will take
> a long time for large ranges.
>
> I looked into the following:
>
> Option 1: (preferred) Maple trees
>
> Maple tree has a nice API, though it would be better if it can combine
> ranges that have the same value.
>
> I will have to dig into performance, but I'm assuming that even large
> ranges are stored in a few nodes so this would be faster than iterating
> over indices in an xarray.
>
> void explore_maple_tree(void)
> {
>         DEFINE_MTREE(mt);
>
>         mt_init_flags(&mt, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);
>
>         mtree_store_range(&mt, 0, 16, xa_mk_value(0x20), GFP_KERNEL);
>         mtree_store_range(&mt, 8, 24, xa_mk_value(0x32), GFP_KERNEL);
>         mtree_store_range(&mt, 5, 10, xa_mk_value(0x32), GFP_KERNEL);
>
>         {
>                 void *entry;
>                 MA_STATE(mas, &mt, 0, 0);
>
>                 mas_for_each(&mas, entry, ULONG_MAX) {
>                         pr_err("[%ld, %ld]: 0x%lx\n", mas.index, mas.last, xa_to_value(entry));
>                 }
>         }
>
>         mtree_destroy(&mt);
> }
>
> stdout:
>
> [0, 4]: 0x20
> [5, 10]: 0x32
> [11, 24]: 0x32
>
> Option 2: Multi-index xarray
>
> The API is more complex than maple tree's, and IIUC multi-index xarrays
> are not generalizable to any range, so the range can't be 8 1G pages + 1
> 4K page for example. The size of the range has to be a power of 2 that
> is greater than 4K.
>
> Using multi-index xarrays would mean computing order to store
> multi-index entries. This can be computed from the size of the range to
> be added, but is an additional source of errors.
>
> Option 3: Interval tree, which is built on top of red-black trees
>
> The API is set up at a lower level. A macro is used to define interval
> trees, the user has to deal with nodes in the tree directly and
> separately define functions to override sub-ranges in larger ranges.

I didn't consider any other data structures, mainly out of laziness :)
What I mean by that is, xarrays is what is already used in guest_memfd
for tracking other gfn related items, even though many have talked
about in the future replacing it with something else.

I agree with you that it's not the ideal data structure, but also,
like you said, this isn't part of the interface, and it would be easy
to replace in the future. As you mention, one of the challenges is
figuring out the performance impact in practice, and once things have
settled down and the interface is more or less settled, some
benchmarking would be useful to guide us here.

Thanks!
/fuad

> > +             r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> > +             if (r)
> > +                     break;
> > +     }
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +/*
> > + * Marks the range [start, end) as not mappable by the host. If the host doesn't
> > + * have any references to a particular folio, then that folio is marked as
> > + * mappable by the guest.
> > + *
> > + * However, if the host still has references to the folio, then the folio is
> > + * marked and not mappable by anyone. Marking it is not mappable allows it to
> > + * drain all references from the host, and to ensure that the hypervisor does
> > + * not transition the folio to private, since the host still might access it.
> > + *
> > + * Usually called when guest unshares memory with the host.
> > + */
> > +static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +     void *xval_none = xa_mk_value(KVM_GMEM_NONE_MAPPABLE);
> > +     pgoff_t i;
> > +     int r = 0;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     for (i = start; i < end; i++) {
> > +             struct folio *folio;
> > +             int refcount = 0;
> > +
> > +             folio = filemap_lock_folio(inode->i_mapping, i);
> > +             if (!IS_ERR(folio)) {
> > +                     refcount = folio_ref_count(folio);
> > +             } else {
> > +                     r = PTR_ERR(folio);
> > +                     if (WARN_ON_ONCE(r != -ENOENT))
> > +                             break;
> > +
> > +                     folio = NULL;
> > +             }
> > +
> > +             /* +1 references are expected because of filemap_lock_folio(). */
> > +             if (folio && refcount > folio_nr_pages(folio) + 1) {
> > +                     /*
> > +                      * Outstanding references, the folio cannot be faulted
> > +                      * in by anyone until they're dropped.
> > +                      */
> > +                     r = xa_err(xa_store(mappable_offsets, i, xval_none, GFP_KERNEL));
> > +             } else {
> > +                     /*
> > +                      * No outstanding references. Transition the folio to
> > +                      * guest mappable immediately.
> > +                      */
> > +                     r = xa_err(xa_store(mappable_offsets, i, xval_guest, GFP_KERNEL));
> > +             }
> > +
> > +             if (folio) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +             }
> > +
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> >
> > <snip>

