Return-Path: <kvm+bounces-39412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EBFA46E9A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 23:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC65E16D958
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 22:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD1E25CC83;
	Wed, 26 Feb 2025 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNW1/H9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092CA25BAD8
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 22:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608962; cv=none; b=ri4Fk7dLReU+J2cKGJO6PdgPTgVbGNJHnP0bHli9PCi2TOrKnNPgcCEGmn6Uz8TqHIyjOGM82kihs61pMsbEJQx6lP/pzJ4L09iiTkxuYrmMNFJvh++co5SJY7+5HFQ2FUcKzZfmQvvXHwxIj765+V/P9ywfmAsImXr8oUESwrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608962; c=relaxed/simple;
	bh=oInMe2/RpAohD6ao5OUZGc6NV2cdulRmnasixT3rrpk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MYwQu2HfeFHO53eC8hsooQL/uxJ14Ii7GtwZEV6e5KsEUSbRVlqq2MMSFVl16mxrNFspyO54Ri+VKLwX6f2vzy66XFE8g02OGI9sa7qvN9C5iJJKpHdkQSajwNWydAbfpVk3z84wOLF/3yEqsA9L6v08DacHI58/o5vFb8CF2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNW1/H9H; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2217a4bfcc7so3785895ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 14:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740608960; x=1741213760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oBGRt7WXjkkbaucrCtRFoiyJpp1hbaiF4R/5f+bgEWc=;
        b=rNW1/H9HOm1qe0pEAeHt480a80Z7rlcmsQGZ+PXuvfXiNMSJwg5hoiqOxneN350dzc
         w7ypyd47S8laFxPQsG5+3xHLFq5w9hPg+Guef1pafCcYUDvfCxpf637mmAf1/23QHdjb
         57UjSCBPmRCaQ2E+JQZyl/oauQycwVCSxamNBLyra3u9QfnOlHL9V8KCVs6j7bBFJ6M5
         +Jp57BMM2u/3vL3E5D/QhAWYhsTdAMXRF6PtvNz2QwQgwUPDkccv98cx4hGGapRKeQWM
         BcOVF2YEl+Ue2z3WbFkvmmmZGkmmhLMnco4AFqE/bzdcTQOQvaelr0F1IpCrGWxbebzp
         y1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740608960; x=1741213760;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBGRt7WXjkkbaucrCtRFoiyJpp1hbaiF4R/5f+bgEWc=;
        b=tyQW+KAk3JFPD83q2yuzgfu3jkthnuO6BnnqcerQGMnmv1/lUErLEhjyK4KZpzsc3b
         TomaT82bu7Z7COraiTXDkZceSe4pCAzaUIvMFk3LtoFcRhrl9PAbs5wlLP4DT+XzfKZh
         RWysxZWn0hcdIS+JzZUvVOL5NeJX5f0Jk75CvOC2sP/or15hVe0uDAwsRs2J0AND6JLS
         Q7Mynx0hbxJ6vIEtaZLO2JxNLKeu4iG6+21ryTfgI1np+2Kexxy6vbAMab/hHJvOkA6c
         69DS6AuH7KY7NNt1IOJF98++cTqVZgUlEAAd4HBL+FEwl6m/ATe4TXn91TUrUNaM5RTz
         m5Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWYwfaB+n2IjWtIIAnMKgAEFPwli8flNMsc9zCNcc830qy62ZXSmotOe3cuBrHDIPVESJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGrNbYSLiLwLx8KwAcLPRzZdNSQngUaXcsd0LNMnLi0ndmY74f
	Sleg2aCdE2IsGaXSJK0LmWTnDvK4abW/NX3z5vnaAHjKiSoTkOdhYx6P08i8Sue0R1j/H7Z6mDg
	SjrhY8sZQJkeu3JsFKYbR0g==
X-Google-Smtp-Source: AGHT+IEx90GrBY3H6MbzTcyDAQhZ2Ks2wua1pC+ws2C0H9wlTxI+92NL1aBLbDXxy63FmYi74R2O4wQAYik0gcC9+w==
X-Received: from pjh15.prod.google.com ([2002:a17:90b:3f8f:b0:2fa:e9b:33b7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ea0a:b0:216:393b:23d4 with SMTP id d9443c01a7336-221a0ec9a77mr342976695ad.11.1740608960088;
 Wed, 26 Feb 2025 14:29:20 -0800 (PST)
Date: Wed, 26 Feb 2025 22:29:19 +0000
In-Reply-To: <CA+EHjTw1SCg1Eu4CeJv4Tg6Ono2+sXDVKeGshBMu4gg87Uk_bg@mail.gmail.com>
 (message from Fuad Tabba on Wed, 29 Jan 2025 10:15:23 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzikowfigw.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 04/15] KVM: guest_memfd: Track mappability within a
 struct kvm_gmem_private
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: gshan@redhat.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

Fuad Tabba <tabba@google.com> writes:

> Hi Gavin,
>
> On Fri, 24 Jan 2025 at 05:32, Gavin Shan <gshan@redhat.com> wrote:
>>
>> Hi Fuad,
>>
>> On 1/18/25 2:29 AM, Fuad Tabba wrote:
>> > From: Ackerley Tng <ackerleytng@google.com>
>> >
>> > Track whether guest_memfd memory can be mapped within the inode,
>> > since it is property of the guest_memfd's memory contents.
>> >
>> > The guest_memfd PRIVATE memory attribute is not used for two
>> > reasons. First because it reflects the userspace expectation for
>> > that memory location, and therefore can be toggled by userspace.
>> > The second is, although each guest_memfd file has a 1:1 binding
>> > with a KVM instance, the plan is to allow multiple files per
>> > inode, e.g. to allow intra-host migration to a new KVM instance,
>> > without destroying guest_memfd.
>> >
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> > Co-developed-by: Vishal Annapurve <vannapurve@google.com>
>> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> > Co-developed-by: Fuad Tabba <tabba@google.com>
>> > Signed-off-by: Fuad Tabba <tabba@google.com>
>> > ---
>> >   virt/kvm/guest_memfd.c | 56 ++++++++++++++++++++++++++++++++++++++----
>> >   1 file changed, 51 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index 6453658d2650..0a7b6cf8bd8f 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -18,6 +18,17 @@ struct kvm_gmem {
>> >       struct list_head entry;
>> >   };
>> >
>> > +struct kvm_gmem_inode_private {
>> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
>> > +     struct xarray mappable_offsets;
>> > +#endif
>> > +};
>> > +
>> > +static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
>> > +{
>> > +     return inode->i_mapping->i_private_data;
>> > +}
>> > +
>> >   /**
>> >    * folio_file_pfn - like folio_file_page, but return a pfn.
>> >    * @folio: The folio which contains this index.
>> > @@ -312,8 +323,28 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
>> >   }
>> >
>> > +static void kvm_gmem_evict_inode(struct inode *inode)
>> > +{
>> > +     struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
>> > +
>> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
>> > +     /*
>> > +      * .evict_inode can be called before private data is set up if there are
>> > +      * issues during inode creation.
>> > +      */
>> > +     if (private)
>> > +             xa_destroy(&private->mappable_offsets);
>> > +#endif
>> > +
>> > +     truncate_inode_pages_final(inode->i_mapping);
>> > +
>> > +     kfree(private);
>> > +     clear_inode(inode);
>> > +}
>> > +
>> >   static const struct super_operations kvm_gmem_super_operations = {
>> > -     .statfs         = simple_statfs,
>> > +     .statfs         = simple_statfs,
>> > +     .evict_inode    = kvm_gmem_evict_inode,
>> >   };
>> >
>>
>> As I understood, ->destroy_inode() may be more suitable place where the xarray is
>> released. ->evict_inode() usually detach the inode from the existing struct, to make
>> it offline. ->destroy_inode() is actually the place where the associated resource
>> (memory) is relased.
>>
>> Another benefit with ->destroy_inode() is we're not concerned to truncate_inode_pages_final()
>> and clear_inode().
>
> I see. I'll give this a try.
>

While working on 1G page support (old revision at [1]), I was looking at
this.

Using .destroy_inode to clean up private->mappable_offsets should work
fine, and I agree this should be refactored to use .destroy_inode
instead. Thanks for pointing this out!

FWIW, for 1G page support, the truncation process has to be overridden
to, so the .evict_inode override will have to come back.

>>
>> >   static int kvm_gmem_init_fs_context(struct fs_context *fc)
>> > @@ -440,6 +471,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>> >                                                     loff_t size, u64 flags)
>> >   {
>> >       const struct qstr qname = QSTR_INIT(name, strlen(name));
>> > +     struct kvm_gmem_inode_private *private;
>> >       struct inode *inode;
>> >       int err;
>> >
>> > @@ -448,10 +480,19 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>> >               return inode;
>> >
>> >       err = security_inode_init_security_anon(inode, &qname, NULL);
>> > -     if (err) {
>> > -             iput(inode);
>> > -             return ERR_PTR(err);
>> > -     }
>> > +     if (err)
>> > +             goto out;
>> > +
>> > +     err = -ENOMEM;
>> > +     private = kzalloc(sizeof(*private), GFP_KERNEL);
>> > +     if (!private)
>> > +             goto out;
>> > +
>> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
>> > +     xa_init(&private->mappable_offsets);
>> > +#endif
>> > +
>> > +     inode->i_mapping->i_private_data = private;
>> >
>>
>> The whole block of code needs to be guarded by CONFIG_KVM_GMEM_MAPPABLE because
>> kzalloc(sizeof(...)) is translated to kzalloc(0) when CONFIG_KVM_GMEM_MAPPABLE
>> is disabled, and kzalloc() will always fail. It will lead to unusable guest-memfd
>> if CONFIG_KVM_GMEM_MAPPABLE is disabled.
>
> Good point, thanks for pointing this out.
>
> Cheers,
> /fuad
>
>> >       inode->i_private = (void *)(unsigned long)flags;
>> >       inode->i_op = &kvm_gmem_iops;
>> > @@ -464,6 +505,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>> >       WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> >
>> >       return inode;
>> > +
>> > +out:
>> > +     iput(inode);
>> > +
>> > +     return ERR_PTR(err);
>> >   }
>> >
>> >   static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
>>
>> Thanks,
>> Gavin
>>

[1] https://lore.kernel.org/all/cover.1726009989.git.ackerleytng@google.com/T/

