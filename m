Return-Path: <kvm+bounces-50485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5E6AE6415
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:59:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC01F40035F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB86291C22;
	Tue, 24 Jun 2025 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jvwFNSo2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB728ECD8
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766336; cv=none; b=SCza2eetIkbL5t9fV5X2oQZAA4ass9zlCgx6/utqoY5NSzD8c7COwXbgyi1M+vpqZhnWsBUfFv0JubnVfnZ1HkzBPBO9yTyJDDQqtNEzMs1JBu+IklTepgNPGVlhEmBbKePgwwzSjyywQq2vgCPoiYIi3xzkyZIFZ1oMhWSYXzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766336; c=relaxed/simple;
	bh=uskxUuB6YcOdbnKLw5g8SxZDF6K9gBPzBY4kiD0YoM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BA/1klVWCj+f4ce8mTiUe58RKkivg8blJISJ6Lq1h7BJViV8ua8u6ZLWAJ7rpi2lCdJDKczFKwJfOYIHt+RttOi0HPXkUWgifdkCMABVjLcuTb4566f/oXQcvRObuo0BRZ5PUJ7ZAYOuOkvp41bMmzNvS8ySw79yYiXIHiEcqJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jvwFNSo2; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-47e9fea29easo327781cf.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 04:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750766333; x=1751371133; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAkKzBT9Oi47cUQVFAqBKpPqCgRXO9n1TGoSSjrcRig=;
        b=jvwFNSo2vKovZdcqzRL77J4j6kpV7dTeOq+PS40Gyd+m+7JBuaOYxemCTC6VILZ1BJ
         x5TqqLwMQlJZQ7/wt4JsyV7XkqNnbGj5fwktarEtAzbN0tkNjMUkXHakUrCStPZdD6Jz
         4uWbAdb6zkeRzMPbOXXLaYYa1chckoN8ks3EPOPop99NzEMUnYghf5IRET9wdSsDVAGe
         DT0It0NDCvFxNbh4+36hKvLBC19sN5kaPKgMKLxpk1yM8hh//heQAFi/6ngw6A2LRoF6
         48VZRY8KLY+3D8g9lftzKMMZqj4g/CA3SvaCbKr8uOZjr0bwN5TOa6bfEwR5ka5aebTY
         lhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766333; x=1751371133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAkKzBT9Oi47cUQVFAqBKpPqCgRXO9n1TGoSSjrcRig=;
        b=b/R92poSjOB8wWZnaUbr30cZjffE8FOrOtoDc7ekHDkbsnJwbz3uPFQG0PTQpXeAQ8
         1lcEI4QuhQldaKtyscZyVL07IovBzobVgS+GOgMGSOtaJvXt9u0JwAVwI3IZRJXv1IZf
         SDzrTz80dL9yPFm7fH3rV00vhRkudlR/7bTSJnOitGVjJexyCrLE+eMyi44jYmTC5c8l
         Kr/Q+ZzbOaZu7MAMDauyB078tPlXNtzdSVmlvZaSxpR/Y3TgxJ0iOqasMnbe64EOvPMc
         /O0ZV0VyLl27wdjgRRl5Gh+qqJ3dwgPqGMjdvqFO4rQEZ5Peo9mkpqmWKtPE77R4ZXAZ
         F1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdGN1rdENCejSl76ZlhpzDL+scyGQnWlAc4txlFI6Ml0BlO8HYeLUduaz32g396Pk4rjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm/JMs5SLSlJzYsYqgS+Xw/kiKmVw5G8GvH0EZbgtoIfp93HdE
	xZ3Z8hQs+tKJ2hz6gob0AC1t5I0od0VZvupbBM3+7lXtOCHeWkIpcqRrdtsGpxuGJQvhOmcFrxa
	S9GGENL7ydz+6bz+i2BRbaCGpo5X+m0CMPIDZRMgy
X-Gm-Gg: ASbGncvkI4a28sn+0IwjCAV38Te609h/W5enRShHmdFyBugjh6ucrUdHXcymz0kGkep
	v8vGAjqsK1PmlOwj1uid/jZn7kXK6po+A9h0fhGqU0uqSwk2Cb8E6bjHpU0Jq0M+WwIfHnq78i1
	1w71sh1Q+pcjHgXXEgweKHiHdKVo36eeU+ZXDdIPrgqEwfdBKAbNHty+Tdb6RpuPXYkOclSw==
X-Google-Smtp-Source: AGHT+IFItWaOUEnQWqkCr0iMJsyetgQtFozSIRuqtaWWAUjmia/GJg3tAAHgb8EkJpgaZINqlaKB1Ek0kcCYr/IuJ+k=
X-Received: by 2002:a05:622a:1983:b0:4a7:26ba:bc2a with SMTP id
 d75a77b69052e-4a7b16ece18mr3011891cf.15.1750766332945; Tue, 24 Jun 2025
 04:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com> <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
 <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com>
In-Reply-To: <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Jun 2025 12:58:16 +0100
X-Gm-Features: Ac12FXxIR7DmWnStmYreR1cKwqZETUwJ47Ed0F1LblD3zm6eL8DVUB8Z-pOLCcg
Message-ID: <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Jun 2025 at 12:44, David Hildenbrand <david@redhat.com> wrote:
>
> On 24.06.25 12:25, Fuad Tabba wrote:
> > Hi David,
> >
> > On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 24.06.25 12:02, Fuad Tabba wrote:
> >>> Hi,
> >>>
> >>> Before I respin this, I thought I'd outline the planned changes for
> >>> V13, especially since it involves a lot of repainting. I hope that
> >>> by presenting this first, we could reduce the number of times I'll
> >>> need to respin it.
> >>>
> >>> In struct kvm_arch: add bool supports_gmem instead of renaming
> >>> has_private_mem
> >>>
> >>> The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
> >>> called GUEST_MEMFD_FLAG_MMAP
> >>>
> >>> The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
> >>> called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP
> >>>
> >>> kvm_arch_supports_gmem_shared_mem() should be called
> >>> kvm_arch_supports_gmem_mmap()
> >>>
> >>> kvm_gmem_memslot_supports_shared() should be called
> >>> kvm_gmem_memslot_supports_mmap()
> >>>
> >>> kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
> >>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >>>
> >>> The capability KVM_CAP_GMEM_SHARED_MEM should be called
> >>> KVM_CAP_GMEM_MMAP
> >>>
> >>> The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
> >>> CONFIG_KVM_GMEM_SUPPORTS_MMAP
> >>
> >> Works for me.
> >>
> >>>
> >>> Also, what (unless you disagree) will stay the same as V12:
> >>>
> >>> Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
> >>> implies gmem, and we will have additional flags for MMAP support
> >>
> >> Agreed.
> >>
> >>>
> >>> Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> >>> CONFIG_KVM_GENERIC_GMEM_POPULATE
> >>
> >> Agreed.
> >>
> >>>
> >>> Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
> >>> private does imply that it has gmem
> >>
> >> Right. It's a little more tricky in reality at least with this series:
> >> without in-place conversion, not all gmem can have private memory. But
> >> the places that check kvm_slot_can_be_private() likely only care about
> >> if this memslot is backed by gmem.
> >
> > Exactly. Reading the code, all the places that check
> > kvm_slot_can_be_private() are really checking whether the slot has
> > gmem. After this series, if a caller is interested in finding out
> > whether a slot can be private could achieve the same effect by
> > checking that a gmem slot doesn't support mmap (i.e.,
> > kvm_slot_has_gmem() && kvm_arch_supports_gmem_mmap() ). If that
> > happens, we can reintroduce kvm_slot_can_be_private() as such.
> >
> > Otherwise, I could keep it and already define it as so. What do you think?
> >
> >> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
> >> calling that?
> >
> > Good point, I'd missed that. Isn't it true that
> > kvm_is_memslot_gmem_only() is synonymous (at least for now) with
> > kvm_gmem_memslot_supports_mmap()?
>
> Yes. I think having a simple kvm_is_memslot_gmem_only() helper might
> make fault handling code easier to read, though.

Ack. So, with that, at least the two of us are in agreement about what
needs to be done for V13. I'll wait until I hear from Sean and
potentially the others before I respin.

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

